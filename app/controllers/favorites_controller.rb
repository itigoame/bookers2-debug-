class FavoritesController < ApplicationController
  def create
    @bookshow = Book.find(params[:book_id])
    @favorite = current_user.favorites.new(book_id: @bookshow.id)
    @favorite.save
  end

  def destroy
    @bookshow = Book.find(params[:book_id])
    @favorite = current_user.favorites.find_by(book_id: @bookshow.id)
    @favorite.destroy
  end

end
