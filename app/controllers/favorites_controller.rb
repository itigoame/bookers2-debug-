class FavoritesController < ApplicationController
  def create
    book = Book.find(params[:id])
    favorite = favorites.new(user_id:current_user_id,book: params[:id])
    favorite.save
    redirect_to book_path(book)
  end

  def destroy
    book = Book.find(params[:id])
    favorite = favorites.find_by(user_id:current_user_id,book: params[:id])
    favorite.destroy
    redirect_to book_path(book)
  end
end
