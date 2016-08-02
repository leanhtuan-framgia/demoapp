class UsersController < ApplicationController
  before_action :logged_in_user, except: [:new, :show, :create]
  before_action :find_user, except: [:new, :create, :index]
  before_action :correct_user, only: :destroy
  before_action :init_comment, only: [:show, :index]

  def index
    @users = User.paginate page: params[:page]
  end

  def show
    @entries = @user.entries.paginate page: params[:page]
    @relationship = if current_user.following? @user
      current_user.active_relationships.find_by followed_id: @user.id
    else
      current_user.active_relationships.build
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = "Create user success"
      redirect_to root_url
    else
      render :new
    end
  end

  private
  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end

  def correct_user
    redirect_to root_url unless @user.correct_user? current_user
  end

  def find_user
    @user = User.find_by id: params[:id]
  end

  def init_comment
    @comment ||= Comment.new
  end
end
