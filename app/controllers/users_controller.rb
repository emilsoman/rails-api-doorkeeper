class UsersController < ApplicationController
  def create
    user = User.create(user_params)
    unless user.valid?
      render status: :bad_request, json: user.errors
    end
  end

  private

    def user_params
      permitted_params = params.require(:user)
        .permit([:email, :password, :password_confirmation])
    end
end
