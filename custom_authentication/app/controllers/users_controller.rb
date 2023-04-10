class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      redirect_to root_path, notice: "User has been signed up"
    else
      flash.now[:alert] = "user has not been created!"
      render :new, status: :unprocessable_entity
    end
  end

  def login
  end

  def access
    user = User.find_by(email: params[:email].downcase)
    if user && user.authenticate(params[:password])
      log_in user
      params[:remember_me] == '1' ? remember(user) : forget(user)
      redirect_to root_path, notice: "You have successfully logged in ... "
    else
      flash.now[:alert] = 'Invalid email/password combination'
      render :login, status: :unprocessable_entity
    end
  end

  def logout
    log_out
    redirect_to root_path, notice: "You have successfully logged out ... "
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password)
  end
end
