require 'rails_helper'
require 'support/user_login_steps'
include UserLoginSteps

RSpec.describe 'Refresh token using refresh_token' do
  let(:valid_params) do
    {
      grant_type: 'refresh_token',
      refresh_token: token.refresh_token
    }
  end

  let(:email) { 'test@test.com' }
  let(:password) { 'password' }
  let(:token) { Doorkeeper::AccessToken.first }
  before do
    create_user(email, password)
    generate_access_token(email, password)
    post '/oauth/token', valid_params
  end
  it 'responds with status 200' do
    expect(response).to have_http_status 200
  end
  it 'responds with new access token and refresh token' do
    new_token = Doorkeeper::AccessToken.last
    expect(new_token.token).not_to eql token.token
    expect(new_token.refresh_token).not_to eql token.refresh_token

    expect(response.body).to eql ({
      access_token: new_token.token,
      token_type: 'bearer',
      expires_in: new_token.expires_in,
      refresh_token: new_token.refresh_token,
      created_at: new_token.created_at.to_i
    }).to_json
  end

  context 'when token is expired' do
    it 'still generates new token' do
      Timecop.travel(Time.now + token.expires_in.seconds + 10) do
        expect(token.expired?).to be_truthy
        valid_params[:refresh_token] = Doorkeeper::AccessToken.last.refresh_token
        post '/oauth/token', valid_params
        expect(Doorkeeper::AccessToken.count).to eql 3
      end
    end
  end
end

