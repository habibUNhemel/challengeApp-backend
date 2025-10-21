class ApplicationController < ActionController::API
   # ✅ ADD THIS LINE:
  include ActionController::Cookies
end
