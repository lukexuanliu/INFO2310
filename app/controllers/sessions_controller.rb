class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.authenticate(params[:session][:email], 
	                         params[:session][:password])
	if user == nil
	  flash[:error] = "Invalid email/password combination"
	  redirect_to new_session_path
	else
	  flash[:notice] = "Welcome, #{user.email}!"
	  cookies[:current_user_id] = user.id
	  sign_in(user)
	  redirect_to user_path(user)
	end
  end

  def destroy
  end

end