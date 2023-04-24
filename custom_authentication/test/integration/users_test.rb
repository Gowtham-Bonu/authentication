require "test_helper"

class UsersTest < ActionDispatch::IntegrationTest
  include UsersHelper
  setup do
    user = User.last
    post login_path, params: { email: user.email, password: "yash12"  }
  end

  test "access root page without login and redirect to login page" do
    get root_path
    assert_response :success
  end

  test "create a new user" do
    get new_user_path
    assert_response :success

    post users_path, params: { user: { username: "gowu", email: "gowu@mail.com", password: "gowu12" } }
    post login_path, params: { email: "gowu@mail.com", password: "gowu12"  }
    assert_redirected_to root_path
    follow_redirect!
    assert_response :success
  end
end
