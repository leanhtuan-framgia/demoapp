Rails.application.routes.draw do

  get "users/new"
  root "static_pages#home"
  get "signup", to: "users#new"
  post "/signup", to: "users#create"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  resources :users do
    resources :relationships, only: :index
  end

  resources :entries, only: [:create, :destroy] do
    #resources :comments, only: :create
  end

  resources :relationships, only: [:create, :destroy]

  resources :comments, only: [:create, :destroy]
end
