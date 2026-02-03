Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :tasks
      resources :categories, only: [:index, :create, :destroy]
    end
  end

  # Health check endpoint
  get "up" => "rails/health#show", as: :rails_health_check
end
