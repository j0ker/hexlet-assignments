# frozen_string_literal: true

module Web
  module Movies
    class ReviewsController < ApplicationController
      def index
        @reviews = resource_movie.reviews
      end

      def create
        @review = resource_movie.reviews.new(review_params)
        if @review.save
          redirect_to movie_reviews_path(resource_movie), notice: t('.success')
        else
          flash[:alert] = t('.fail')
          render :new
        end
      end

      def new
        @review = Review.new
      end

      def edit
        @review = Review.find_by(id: params[:id], movie_id: resource_movie.id)
      end

      def update
        @review = Review.find_by(id: params[:id], movie_id: resource_movie.id)
        if @review.update(review_params)
          redirect_to movie_reviews_path(resource_movie), notice: t('.success')
        else
          redirect_to movie_reviews_path(resource_movie), notice: t('.fail')
        end
      end

      def destroy
        @review = Review.find(params[:id])
        if @review.destroy
          redirect_to movie_reviews_path(resource_movie), notice: t('.success')
        else
          redirect_to movie_reviews_path(resource_movie), notice: t('.fail')
        end
      end

      private

      def review_params
        params.require(:review).permit(:body)
      end
    end
  end
end
