Rails.application.routes.draw do
  devise_for :users, controllers: { 
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  # Zoho Routes
  get '/zoho/callback', to: 'zoho#callback'
  get '/zoho/connect', to: 'zoho#connect'
  get '/zoho/tokens', to: 'zoho#create_tokens'  # Add this line
  get '/api/zoho/form_data', to: 'zoho#form_data'
  get '/zoho/debug', to: 'zoho#debug'


  namespace :api do
    namespace :v1 do
      resources :challenges
    end
  end
end