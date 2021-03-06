class ApplicationController < ActionController::Base

  def forem_user
    current_active
  end
  helper_method :forem_user


  before_filter :configure_permitted_parameters, if: :devise_controller?

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception

  # Specifies the path that Devise redirects to after active sign-in
  def after_sign_in_path_for(resource)
    if resource.is_a?(Active)
      active_path(resource)
    elsif resource.is_a?(Rushee)
      rushee_path(resource)
    else
      root_path
    end
  end

  protected

  # Setting strong parameters to enable adding of additional attributes to Active model
  # (via: http://stackoverflow.com/questions/16297797/add-custom-field-column-to-devise-with-rails-4)

  def configure_permitted_parameters
    registration_params = [:name, :email, :major, :authenticity_token, :pledge_class, :biography, :positions_held, :hometown, :linkedin, :photograph, :display_on_index, :eboard, :password, :password_confirmation]

    if params[:action] == 'update'
      devise_parameter_sanitizer.for(:account_update) {
        |u| u.permit(registration_params << :current_password)
      }
    elsif params[:action] == 'create'
      devise_parameter_sanitizer.for(:sign_up) {
        |u| u.permit(registration_params)
      }
    end
  end

end
