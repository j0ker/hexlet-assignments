# frozen_string_literal: true

module Web
  module Movies
    class CommentsController < ApplicationController
      def index
        @comments = resource_movie.comments
      end

      def create
        @comment = resource_movie.comments.new(comment_params)
        if @comment.save
          redirect_to movie_comments_path(resource_movie), notice: t('.success')
        else
          flash[:alert] = t('.fail')
          render :new
        end
      end

      def new
        @comment = Comment.new
      end

      def edit
        @comment = Comment.find_by(id: params[:id], movie_id: resource_movie.id)
      end

      def update
        @comment = Comment.find_by(id: params[:id], movie_id: resource_movie.id)
        if @comment.update(comment_params)
          redirect_to movie_comments_path(resource_movie), notice: t('.success')
        else
          redirect_to movie_comments_path(resource_movie), notice: t('.fail')
        end
      end

      def destroy
        @comment = Comment.find(params[:id])
        if @comment.destroy
          redirect_to movie_comments_path(resource_movie), notice: t('.success')
        else
          redirect_to movie_comments_path(resource_movie), notice: t('.fail')
        end
      end

      private

      def comment_params
        params.require(:comment).permit(:body)
      end
    end
  end
end
