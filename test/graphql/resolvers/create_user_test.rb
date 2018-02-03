require 'test_helper'

class Resolvers::CreateUserTest < ActiveSupport::TestCase
  def perform(args = {})
    Resolvers::CreateUser.new.call(nil, args, {})
  end

  test 'creating a new user' do
    user = perform({
      name: 'Test User',
      authProvider: {
        email: {
          email: 'bob@example.com',
          password: 'secret'
        }
      }
    })

    assert user.persisted?
    assert_equal user.name, 'Test User'
    assert_equal user.email, 'bob@example.com'
  end
end
