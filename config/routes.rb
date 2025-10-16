Rails.application.routes.draw do


  devise_for :users,controllers:
   { 
    sessions: 'users/sessions',
   registrations: 'users/registrations'
  }
  # Define your application routes per the DSL in https://

  namespace :api do
    namespace :v1 do
      resources :challenges
    end
  end

  
end