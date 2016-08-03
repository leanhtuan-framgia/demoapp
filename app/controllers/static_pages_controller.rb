class StaticPagesController < ApplicationController
  def home
    if logged_in?
      init_comment
      @entry = current_user.entries.build
      @feed_items = current_user.feeds.paginate page: params[:page]
    else
      @feed_items = Entry.order_by_time.paginate page: params[:page]
    end

  end
end
