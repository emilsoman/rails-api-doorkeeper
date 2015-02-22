require 'rails_helper'

RSpec.describe 'User requests' do
  describe 'POST /users' do
    let(:valid_params) do
      {
        user: {
          email: 'test@test.com',
          password: 'password',
          password_confirmation: 'password'
        }
      }
    end

    context 'when params are not nested inside :user key' do
      before do
        post '/users', valid_params[:user]
      end
      it 'responds with status 400' do
        expect(response).to have_http_status 400
      end
      it 'responds with message indicating missing param' do
        expect(response.body).to eql 'param is missing or the value is empty: user'
      end
    end

    context 'when password and password confirmation do not match' do
      before do
        post '/users', {user: {email: 'test@test.com', password: 'password', password_confirmation: 'different'}}
      end
      it 'responds with status 400' do
        expect(response).to have_http_status 400
      end
      it 'responds with a message indicating non matching password confirmation' do
        expect(response.body).to eql ({"password_confirmation"=>["doesn't match Password"]}).to_json
      end
    end

    context 'when params are valid' do
      it 'creates a new user in the database' do
        expect { post '/users', valid_params }.to change { User.count }.from(0).to(1)
        expect(response).to have_http_status 200
      end
    end
  end
end
