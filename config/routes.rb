Application.routes.draw do

  begin
    require 'sidekiq/web'

    Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
      [user, password] == [
        "admin", ENV['SIDEKIQ_PASSWORD'] || "password"
      ]
    end

    mount Sidekiq::Web => '/sidekiq' 
  end

  match '(errors)/:status', to: 'errors#show',
    constraints: { status: /\d{3}/ },
    defaults: { status: '500' },
    via: :all

end
