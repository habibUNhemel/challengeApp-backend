class ZohoController < ApplicationController
  # def connect
  #   client_id = "1000.97XN5SIYLZ569BZ3GNLKDRD0U5TLMA"  # ← Replace with your actual Client ID
  #   redirect_uri = 'http://localhost:3000/zoho/callback'
  #   scope = 'ZohoCreator.data.READ,ZohoCreator.data.CREATE'
    
  #   auth_url = "https://accounts.zoho.com/oauth/v2/auth?client_id=#{client_id}&response_type=code&redirect_uri=#{redirect_uri}&scope=#{scope}&access_type=offline&prompt=consent"
    
  #   redirect_to auth_url, allow_other_host: true
  # end

  def callback
    authorization_code = params[:code]
    
    puts "🔍 Received params: #{params.inspect}"
    
    if authorization_code.present?
      puts "✅ Authorization code received: #{authorization_code}"
      
      # Exchange code for tokens
      tokens = ZohoService.exchange_code_for_tokens(authorization_code)
      
      if tokens
        # Store in session
        session[:zoho_access_token] = tokens['access_token']
        session[:zoho_refresh_token] = tokens['refresh_token']
        
        render plain: "✅ SUCCESS! Zoho Connected. 
        
        Your Access Token: #{tokens['access_token']}
        
        Next step: Visit http://localhost:3000/api/zoho/form_data to see your form data!"
      else
        render plain: "❌ Failed to get tokens from Zoho"
      end
    else
      error_message = params[:error] || "No code received"
      render plain: "❌ Authorization failed: #{error_message}
      
      Full params: #{params.inspect}"
    end
  end

  def form_data
    access_token = session[:zoho_access_token]
    
    unless access_token
      render json: { 
        error: 'No access token found. Please connect to Zoho first by visiting:',
        connect_url: 'http://localhost:3000/zoho/connect'
      }
      return
    end

    zoho_data = ZohoService.fetch_form_data(access_token)
    render json: zoho_data
  end


  def connect
  client_id = "1000.97XN5SIYLZ569BZ3GNLKDRD0U5TLMA"  # Your Client ID is correct!
  redirect_uri = 'http://localhost:3000/zoho/callback'
  scope = 'ZohoCreator.data.READ,ZohoCreator.data.CREATE'  # ← FULL SCOPE
  
  auth_url = "https://accounts.zoho.com/oauth/v2/auth?client_id=#{client_id}&response_type=code&redirect_uri=#{redirect_uri}&scope=#{scope}&access_type=offline&prompt=consent"
  
  redirect_to auth_url, allow_other_host: true
end

end

