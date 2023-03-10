# frozen_string_literal: true

require 'test_helper'

class Web::RepositoriesControllerTest < ActionDispatch::IntegrationTest
  # BEGIN
  setup do
    @data_file = load_fixture('files/response.json')
    @data = JSON.parse(@data_file)
    @url = @data['url']
    @attrs = {
      link: @data['html_url']
    }
    stub_request(:get, @url).to_return body: @data_file, headers: { content_type: 'application/json' }
  end

  test 'should create repository' do
    post repositories_url, params: { repository: @attrs }

    repository = Repository.find_by(link: @data['html_url'])

    assert repository
  end
  # END
end
