class ApplicationController < ActionController::API
  rescue_from ActionController::ParameterMissing do |e|
    render status: :bad_request, json: e.message
  end
end
