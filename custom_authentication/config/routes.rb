Rails.application.routes.draw do
  root 'homes#index'

  post 'login' => 'users#access'

  resources :users, only: [:new, :create] do
    collection do
      get 'login'
      delete 'logout'
    end
  end
end
