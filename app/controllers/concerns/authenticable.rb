module Authenticable
  def current_user
    p "i am inside current user method"
    p request.headers['Authorization']
    @current_user ||= User.find_by(auth_token: request.headers['Authorization']) 
  end
  
  def user_signed_in?
    current_user.present?
  end

  def authenticate_with_token!
    render json: {errors: "Not authenticated"},
    status: :unauthorized unless user_signed_in?
  end
end