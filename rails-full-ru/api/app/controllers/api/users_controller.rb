# frozen_string_literal: true

class Api::UsersController < Api::ApplicationController
  # BEGIN
  def index
    @users = User.all
    respond_with @users.as_json(only: %i[id first_name last_name email])
  end

  def show
    @user = User.find(params[:id])
    respond_with @user.as_json(root: true, only: %i[id first_name last_name email address])
  end
  # END
end
