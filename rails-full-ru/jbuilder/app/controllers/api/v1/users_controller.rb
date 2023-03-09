# frozen_string_literal: true

class Api::V1::UsersController < Api::ApplicationController
  # BEGIN
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end
  # END
end
