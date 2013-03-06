class StaticPagesController < ApplicationController
  def home
    if signed_in?
	@micro_post = MicroPost.new #empty micropost to start the method
      @feed = current_user.feed(page: params[:page], per_page: 10)
    end  
  end

  def help
  end
  
  def about
  end
end
