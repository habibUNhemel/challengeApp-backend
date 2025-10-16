module Api
  module V1
    class ChallengesController < ApplicationController
      before_action :authenticate_user!, only: %i[create update destroy]
      before_action :set_challenge, only: %i[show update destroy]
      before_action :authorize_admin, only: %i[create update destroy]

      # GET api/v1/challenges
      def index
        # Show all challenges
        @challenges = Challenge.all
        render json: @challenges
      end

# path query parameters

      # GET api/v1/challenges/:id (details of a single challenge)
      def show
        # Show single challenge
        challenge = Challenge.find(params[:challenge_id])
        if challenge
          render json: { message: "Challenge found successfully", data: challenge }
        else
          render json: { error: 'Challenge not found',data: challenge }
        end
      end

      # POST api/v1/challenges
      def create

        # puts 'RRRRRR'
        # puts current_user.id
        # puts current_user.email
        # puts 'RRRRRR'
        # # Create single challenge
        # @challenge = Challenge.new(challenge_params.merge(user_id: current_user.id))


        @challenge = current_user.challenges.build(challenge_params)
        if @challenge.save
          render json: @challenge, status: :created
        else
          render json: { errors: @challenge.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PATCH/PUT api/v1/challenges/:id
      def update
        # Update single challenge
        challenge = Challenge.find(params[:id])
        if challenge.update(challenge_params)
          render json: { message: "Challenge updated successfully", data: challenge }
        else
          render json: { message: "Challenge not found", data: challenge.errors}
        end
      end
      
      # api/v1/challenges/:id
      def destroy
        challenge = Challenge.find(params[:id])
        if challenge
          challenge.destroy
          render json: { message: "Challenge deleted successfully" }
        else
          render json: { error: 'Challenge not found' }, status: :not_found
        end
      end

      private


      def authorize_admin
        render json: {message: "Access denied"}  unless current_user&.email ==  ENV['ADMIN_EMAIL']
      end



      def set_challenge
        @challenge = Challenge.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Challenge not found' }, status: :not_found
      end

      def challenge_params
        params.require(:challenge).permit(:title, :description, :difficulty, :points, :category, :active, :start_date, :end_date)
      end
    end
  end
end