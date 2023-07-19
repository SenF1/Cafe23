Rails.application.routes.draw do
  # API routing
  scope module: 'api', defaults: {format: 'json'} do
    namespace :v1 do
      # provide the routes for the API here

      
      

    end
  end

  # Routes for regular HTML views go here...

  # Semi-static page routes
  get 'home', to: 'home#index', as: :home
  get 'home/about', to: 'home#about', as: :about
  get 'home/contact', to: 'home#contact', as: :contact
  get 'home/privacy', to: 'home#privacy', as: :privacy
  

  # Authentication routes
  resources :sessions
  resources :employees
  get 'employees/new', to: 'employees#new', as: :signup
  get 'employee/edit', to: 'employees#edit', as: :edit_current_employee
  get 'login', to: 'sessions#new', as: :login
  get 'logout', to: 'sessions#destroy', as: :logout

  get 'shifts/time_clock', to: 'shifts#time_clock', as: :time_clock
  patch 'shifts/time_in', to: 'shifts#time_in', as: :time_in
  patch 'shifts/time_out', to: 'shifts#time_out', as: :time_out
  resources :shifts
  resources :shift_jobs, only: [:new, :create, :destroy], as: :shift_jobs

  resources :pay_grades, except: [:destroy]
  resources :pay_grade_rates, only: [:new, :create]
  resources :stores, except: [:destroy]
  resources :assignments
  resources :jobs, except: [:show]

  get 'payrolls/store_form', to: 'payrolls#store_form', as: :store_form
  get 'payrolls/employee_form', to: 'payrolls#employee_form', as: :employee_form
  get 'payrolls/store_payroll', to: 'payrolls#store_payroll', as: :store_payroll
  get 'payrolls/employee_payroll', to: 'payrolls#employee_payroll', as: :employee_payroll
  # You can have the root of your site routed with 'root'
  root 'home#index'
  
end
