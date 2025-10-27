require "test_helper"

class CommissionsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    sign_in_as users(:one)
    get commissions_url
    assert_response :success
  end
end
