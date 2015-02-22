module UserLoginSteps
  def create_user(email, password)
    post '/users', {user: {email: email, password: password, password_confirmation: password}}
    expect(response).to have_http_status(200)
  end

  def generate_access_token(email, password)
    valid_params = {
      grant_type: 'password',
      username: email,
      password: password
    }
    post '/oauth/token', valid_params
  end
end
