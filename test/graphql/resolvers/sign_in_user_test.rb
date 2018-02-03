require 'test_helper'

class Resolvers::SignInUserTest < ActiveSupport::TestCase
  def perform(args = {})
    Resolvers::SignInUser.new.call(nil, args, @cxt)
  end

  def perform_signin
    perform(
      email: {
        email: @user.email,
        password: @user.password
      }
    )
  end

  setup do
    @cxt = { session: {},  cookies: {} }
    @user = User.create!(
      name: "test",
      email: "test@example.com",
      password: "test"
    )
  end

  test 'creates a token' do
    result = perform_signin

    assert result.present?
    assert result.token.present?
    assert_equal result.user, @user
  end

  test 'stores token in session' do
    assert @cxt[:session][:token].nil?, "smoke test"

    result = perform_signin
    assert @cxt[:session][:token].present?
  end

  test 'handles no credentials' do
    assert_nil perform
  end

  test 'handles wrong email' do
    assert_nil perform({email: {email: 'wrong'}})
  end

  test 'handles wrong password' do
    assert_nil perform({email: {email: @user.email, password: 'wrong'}})
  end
end
