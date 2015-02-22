Rails.application.routes.draw do
  use_doorkeeper

  resources :sessions, only: [:create, :destroy]
  resources :users, only: [:create]
end
