Rails.application.routes.draw do
  root 'home#index'
  
  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations",
  }
  # devise_scope :user do
  #   get 'users', to: 'devise/sessions#new'
  # end

  get 'user/:id', to: 'users#show', as: 'user'

  resources :rooms do
    resources :messages
  end
end
