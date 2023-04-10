Rails.application.routes.draw do
  root 'homes#index'

  get 'login' => 'users#login'
  post 'login' => 'users#access'
  get 'logout' => 'users#logout'

  resources :users, only: [:new, :create]
end
