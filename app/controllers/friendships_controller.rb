class FriendshipsController < ApplicationController
  before_action :set_friendship, only: %i[show edit update destroy]

  # GET /friendships or /friendships.json
  def index
    @friendships = Friendship.all
  end

  # GET /friendships/1 or /friendships/1.json
  def show; end

  # GET /friendships/new
  def new
    @friendship = Friendship.new
  end

  # GET /friendships/1/edit
  def edit; end

  def check_reverse_pair(user, friend)
    Friendship.where(user_id: user, friend_id: friend)
  end

  def accept_or_reject_friend_request
    friend_status = Friendship.where(user_id: params[:user], friend_id: params[:friend])
    friend_status.update(confirmed: params[:status])
    if params[:status] == 'accept'
      redirect_back(fallback_location: users_path, notice: 'Friend request Accepted')
    else
      redirect_back(fallback_location: users_path, notice: 'Friend request Rejected')
    end
  end

  # POST /friendships or /friendships.json
  def create
    @sender = User.find(params[:user])
    @reciever = User.find(params[:friend])

    reverse_pair = check_reverse_pair(@reciever, @sender)
    if reverse_pair.empty?
      @friend_request = @sender.friendships.build(user: @sender, friend: @reciever, confirmed: 'Unconfirmed')

      if @friend_request.save
        redirect_to users_path, notice: 'Friend request sent successfully'
      else
        redirect_to users_path, notice: 'A pending friend request exist'
      end
    else
      redirect_to users_path, notice: 'Friendship Exists'
    end
  end

  # PATCH/PUT /friendships/1 or /friendships/1.json
  def update
    respond_to do |format|
      if @friendship.update(friendship_params)
        format.html { redirect_to @friendship, notice: 'Friendship was successfully updated.' }
        format.json { render :show, status: :ok, location: @friendship }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @friendship.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /friendships/1 or /friendships/1.json
  def destroy
    @friendship.destroy
    respond_to do |format|
      format.html { redirect_to friendships_url, notice: 'Friendship was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_friendship
    @friendship = Friendship.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def friendship_params
    params.require(:friendship).permit(:user, :friend, :confirmed)
  end
end
