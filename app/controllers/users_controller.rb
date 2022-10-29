class UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:edit, :update]
  before_action :ensure_guest_user, only: [:edit]

  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new
    @followings = @user.followings
    @followers = @user.followers

  end

  def index
    @users = User.all
    @book = Book.new
    @followings = current_user.followings
    @followers = current_user.followers
    @user = current_user
  end

  def edit
    @user=User.find(params[:id])
  end

  def update
    @user=User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "You have updated user successfully."
    else
      render "edit"
    end
  end

  # フォロー一覧
  def followings
    @user = User.find(params[:id])
    @users = @user.followings
  end

  # フォロワー一覧
  def followers
    @user = User.find(params[:id])
    @users = @user.followers
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end

  def ensure_guest_user
    @user = User.find(params[:id])
    if @user.name == "guestuser"
      redirect_to user_path(current_user),notice: "ゲストユーザーはプロフィール編集画面へ遷移できません。"
    end
  end
end
