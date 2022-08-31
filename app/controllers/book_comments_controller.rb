class BookCommentsController < ApplicationController

  def create
    @bookshow =Book.find(params[:book_id])
    @comment = current_user.book_comments.new(book_comments_params)
    @comment.book_id = @bookshow.id
    @comment.save
  end

  def destroy
    @bookshow =Book.find(params[:book_id])
    @comment = current_user.book_comments.find_by(book_id: @bookshow.id)
    @comment.destroy
  end

  private

  def book_comments_params
    params.require(:book_comment).permit(:comment)
  end

end
