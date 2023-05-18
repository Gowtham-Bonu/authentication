class ApplicationController < ActionController::Base

  helper_method :current_user
  helper_method :logged_in?
  


  def log_in(user)
    session[:user_id] = user.id
  end

  def current_user
    @current_user ||= if (user_id = session[:user_id])
      User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_digest])
        log_in user
        user
      end
    end
  end

  def logged_in?
    !current_user.nil?
  end

  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_digest] = user.remember_digest
  end

  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_digest)
  end

  def logged_in_user
    unless logged_in?
      redirect_to login_users_path, alert: "Please log in."
    end
  end
end
