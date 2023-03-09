# frozen_string_literal: true

require 'test_helper'

class Web::RepositoriesControllerTest < ActionDispatch::IntegrationTest
  # BEGIN
  setup do
    @response_body = load_fixture('files/response.json')
    @link = 'https://github.com/j0ker/first_app'
    stub_request(:get, 'https://api.github.com/repos/j0ker/first_app').
      with(headers: {
            'Accept'=>'application/vnd.github.v3+json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Content-Type'=>'application/json', 'User-Agent'=>'Octokit Ruby Gem 4.25.1'
        }).to_return(status: 200, body: @response_body, headers: {})
  end

  test 'should create repository' do
    post repositories_url, params: { repository: { link: @link } }
    repository = Repository.find_by(link: @response_body['html_url'])
    assert_redirected_to repository_path(repository)
  end
  # END
end
