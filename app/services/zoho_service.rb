require 'httparty'

class ZohoService
  # ⚠️ REPLACE THESE WITH YOUR ACTUAL VALUES ⚠️
  CLIENT_ID = "1000.97XN5SIYLZ569BZ3GNLKDRD0U5TLMA"  # Your actual Client ID
  CLIENT_SECRET = "9a55b9205240b898ffcb19e3002f20caa4c82ec27c"  # Your actual Client Secret
  REDIRECT_URI = 'http://localhost:3000/zoho/callback'

  def self.exchange_code_for_tokens(authorization_code)
    puts "🔄 Exchanging code for tokens..."
    
    response = HTTParty.post('https://accounts.zoho.com/oauth/v2/token',
      body: {
        code: authorization_code,
        grant_type: 'authorization_code',
        client_id: CLIENT_ID,
        client_secret: CLIENT_SECRET,
        redirect_uri: REDIRECT_URI
      },
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded'
      }
    )
    
    puts "📡 Token response: #{response.code}"
    puts "Body: #{response.body}"
    
    if response.success?
      JSON.parse(response.body)
    else
      puts "❌ Token exchange failed"
      nil
    end
  end

  def self.fetch_form_data(access_token)
    # We'll figure out app_name and form_name later
    test_url = "https://www.zohoapis.com/creator/v2.1/data"
    
    response = HTTParty.get(test_url,
      headers: {
        'Authorization': "Zoho-oauthtoken #{access_token}",
        'Content-Type': 'application/json'
      }
    )
    
    JSON.parse(response.body)
  end
end