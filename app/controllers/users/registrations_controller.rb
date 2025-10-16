


class Users::RegistrationsController < Devise::RegistrationsController
  include RackSessionFix
  respond_to :json

  # 🧩 Override destroy to skip session reset
  def destroy
    user = resource
    user.destroy
    render json: { message: 'Account deleted successfully.' }, status: :ok
  end

  private

  def respond_with(resource, _opts = {})
    if request.method == 'POST' && resource.persisted?
      render json: { 
        message: 'Signed up successfully.', 
        data: resource 
      }, status: :ok
    else
      render json: {
        message: "User couldn't be created successfully.",
        errors: resource.errors.full_messages.to_sentence
      }, status: :unprocessable_entity
    end
  end
end
