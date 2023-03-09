# frozen_string_literal: true

# BEGIN

# END

class Web::RepositoriesController < Web::ApplicationController
  def index
    @repositories = Repository.all
  end

  def new
    @repository = Repository.new
  end

  def show
    @repository = Repository.find params[:id]
  end

  def create
    # BEGIN
    client = Octokit::Client.new
    uri = URI(permitted_params[:link])
    user_repo = uri.request_uri[1..]
    repo = client.repo user_repo
    repository_params = { link: repo['html_url'], owner_name: repo['owner']['login'], repo_name: repo['name'],
                          description: repo['description'], default_branch: repo['default_branch'],
                          watchers_count: repo['watchers_count'], language: repo['language'],
                          repo_created_at: repo['created_at'], repo_updated_at: repo['updated_at'] }
    @repository = Repository.new(repository_params)
    if @repository.save
      redirect_to repository_path(@repository), notice: t('.success')
    else
      flash[:alert] = t('.fails')
      render :new
    end
    # END
  end

  def edit
    @repository = Repository.find params[:id]
  end

  def update
    @repository = Repository.find params[:id]

    if @repository.update(permitted_params)
      redirect_to repositories_path, notice: t('success')
    else
      flash[:notice] = t('fail')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @repository = Repository.find params[:id]

    if @repository.destroy
      redirect_to repositories_path, notice: t('success')
    else
      redirect_to repositories_path, notice: t('fail')
    end
  end

  private

  def permitted_params
    params.require(:repository).permit(:link)
  end
end
