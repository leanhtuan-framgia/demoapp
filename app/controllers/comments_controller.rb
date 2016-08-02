class CommentsController < ApplicationController
  def create
    @comment = current_user.comments.build comt_params
    if @comment.save
      flash[:successful] = "Commented"
      redirect_to request.referrer || root_url
    else
      flash[:danger] = "Error!"
      @feed_items = current_user.feeds.paginate page: params[:page]
      render "static_pages/home"
    end
  end

  def destroy
    @comment.destroy
    flash[:success] = "Comment Deleted"
    redirect_to request.referrer || root_url
  end

  private
  def comt_params
    params.require(:comment).permit :content, :user_id, :entry_id
  end

end
