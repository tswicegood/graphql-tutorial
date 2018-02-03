require 'test_helper'

class Resolvers::CreateLinkTest < ActiveSupport::TestCase
  def current_user
    User.create!(
      name: "test",
      email: "test@example.com",
      password: "test"
    )
  end

  def perform(args = {})
    Resolvers::CreateLink.new.call(nil, args, { session: {}, current_user: current_user })
  end

  test 'creating new link' do
    link = perform({
      url: 'http://example.com',
      description: 'Just a test site'
    })

    assert link.persisted?
    assert_equal link.description, 'Just a test site'
    assert_equal link.url, 'http://example.com'
  end
end
