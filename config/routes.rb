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