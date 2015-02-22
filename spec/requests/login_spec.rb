require 'rails_helper'

RSpec.describe 'User login request' do
  let(:email) { 'test@test.com' }
  let(:password) { 'password' }

  let(:valid_params) do
    {
      grant_type: 'password',
      username: email,
      password: password
    }
  end
  context 'when params are valid' do
    before do
      User.create(email: email, password: password, password_confirmation: password)
      post '/oauth/token', valid_params
    end
    it 'responds with access token' do
      access_token = Doorkeeper::AccessToken.first
      expect(response.body).to eql ({
        access_token: access_token.token,
        token_type: 'bearer',
        expires_in: access_token.expires_in,
        refresh_token: access_token.refresh_token,
        created_at: access_token.created_at.to_i
      }).to_json
    end
  end
end
