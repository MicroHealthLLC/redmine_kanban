if Rails::VERSION::MAJOR >= 3
  RedmineApp::Application.routes.draw do
    resource :kanban do
      put :sync, :on => :member
      
      resources :user_kanbans do
        get 'users' => 'user_kanbans#index'
      end
      resource :user_kanbans do
        get 'my-requests' => 'user_kanbans#show'
      end
      resources :assigned_kanbans do
        get 'assigned-to' => 'assigned_kanbans#index'
      end
      resource :assigned_kanbans, :only => [:show] do
        get 'my-assigned' => 'assigned_kanbans#show'
      end
      resource :kanban_overviews, :only => [:show] do
        get 'overview' => 'kanban_overviews#show'
      end
    end
    resources :kanban_issues
  end
else
  ActionController::Routing::Routes.draw do |map|
    map.resource :kanban, :member => {:sync => :put} do |kanban|
      kanban.resources :user_kanbans, :as => 'users'
      kanban.resource :user_kanbans, :as => 'my-requests'
      kanban.resources :assigned_kanbans, :as => 'assigned-to'
      kanban.resource :assigned_kanbans, :as => 'my-assigned', :only => [:show]
      kanban.resource :kanban_overviews, :as => 'overview', :only => [:show]
    end
    map.resources :kanban_issues
  end
end
