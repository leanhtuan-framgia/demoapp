class CommentsController < ApplicationController
  def create
    @comment = current_user.comments.build comt_params
    @feed_items = current_user.feeds.paginate page: params[:page]
    if @comment.save
      flash[:successful] = "Commented"
      init_comment
      respond_to do |format|
        format.html {redirect_to request.referrer || root_url}
        format.js
      end
    else
      flash[:danger] = "Error!"
      @feed_items = current_user.feeds.paginate page: params[:page]
      render "static_pages/home"
    end
  end

  def destroy
    Comment.find_by(id: params[:id]).destroy
    init_comment
    @feed_items = current_user.feeds.paginate page: params[:page]
    flash[:success] = "Comment Deleted"
    respond_to do |format|
      format.html {redirect_to request.referrer || root_url}
      format.js
    end
  end

  private
  def comt_params
    params.require(:comment).permit :content, :user_id, :entry_id
  end

end
