module UsersHelper
  def request_sent(user)
    @user = user
    current_user.sent_requests.any? do |request|
      request.friend_id == @user.id
    end
  end

  def request_received(user)
    @user = user
    current_user.received_requests.any? do |request|
      request.user_id == @user.id
    end
  end

  # def no_request?(user)
  #   @user = user
  #   !request_sent? && !request_received? && user != current_user
  #   # byebug
  # end
end
