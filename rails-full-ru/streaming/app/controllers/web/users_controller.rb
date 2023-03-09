# frozen_string_literal: true

require 'csv'

class Web::UsersController < Web::ApplicationController
  # BEGIN
  def stream_csv
    headers.delete('Content-Length')
    headers['Cache-Control'] = 'no-cache'
    headers['Content-Type'] = 'text/csv'
    headers['Content-Disposition'] = 'attachment; filename="report.csv"'
    headers['X-Accel-Buffering'] = 'no'

    response.status = 200

    self.response_body = users_csv_enumerator
  end
  # END

  def index
    @users = User.page(params[:page])
  end

  def show
    @user = User.find params[:id]
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find params[:id]
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to @user, notice: t('success')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @user = User.find params[:id]

    if @user.update(user_params)
      redirect_to @user, notice: t('success')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user = User.find params[:id]

    @user.destroy

    redirect_to users_url, notice: t('success')
  end

  def normal_csv
    respond_to do |format|
      format.csv do
        csv = generate_csv(User.column_names, User.all)
        send_data(csv)
      end
    end
  end

  # BEGIN
  def users_csv_enumerator
    @users_csv_enumerator ||= Enumerator.new do |yielder|
      yielder << CSV.generate_line(User.column_names)
      User.find_each do |row|
        yielder << CSV.generate_line(row.attributes.map { |k, v| v })
      end
    end
  end
  # END

  private

  def generate_csv(column_names, records)
    CSV.generate do |csv|
      csv << column_names # add headers to the CSV

      records.find_each do |record|
        csv << record.attributes.values_at(*column_names)
      end
    end
  end

  def user_params
    params.require(:user).permit(
      :name,
      :email
    )
  end
end
