class Api::V1::SessionsController < ApplicationController

  def create
    user_email = params[:session][:email]
    user_password = params[:session][:password]
    user = user_email.present? && User.find_by(email: user_email)
    p "user>>>>user>>>user"
    p user
    p user_password
    p user_email
    p user.valid_password? user_password
    if user.valid_password? user_password
      sign_in user, store: false
      user.generate_auth_token!
      user.save
      render json: user, status: 200, location: [:api, user, :session]
    else
      render json: {errors: "Invalid email or password"}, status: 422
    end
  end

  def destroy
    user = User.find_by(auth_token: params[:id])
    if user
      user.generate_auth_token!
      user.save
      head 204
    end
  end

  private
  def user_params
    params.require(:session).permit(:email, :password)
  end
end
