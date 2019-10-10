Rails.application.routes.draw do
  get 'report_generate/index'
  post 'report_generate/upload_csv'
  root to: 'report_generate#index'
end


# resources :public, path: '', only: [] do
#   collection do
#     get '/influencers', to: 'public#home', as: 'influencer_home'
#     get '/brands', to: 'public#brand_home', as: 'brand_home'
#     get :dashboard
#     post :get_in_touch
#     get :faqs
#     get :terms
#     get 'sign-up-requirements', to:  'public#sign_up_requirements'
#   end
# end
#
# root to: 'public#home'