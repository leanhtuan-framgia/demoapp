class EntriesController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :find_entry, only: :destroy

  def create
    @entry = current_user.entries.build entry_params
    if @entry.save
      flash[:successful] = "Entry Created!"
      redirect_to root_url
    else
      @feed_items = current_user.feeds.paginate page: params[:page]
      render "static_pages/home"
    end
  end

  def destroy
    @entry.destroy
    flash[:success] = "Entry Deleted"
    redirect_to request.referrer || root_url
  end

  private

  def entry_params
    params.require(:entry).permit :title, :content
  end

  def find_entry
    @entry = current_user.entries.find_by id: params[:id]
    redirect_to root_url if @entry.nil?
  end
end
