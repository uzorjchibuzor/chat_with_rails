class RoomsController < ApplicationController
  before_action :set_new_room, only: %i[index show create]
  def index
    setup_rooms_and_users_variables

    render :index
  end

  def show
    setup_rooms_and_users_variables

    @selected_room = Room.find(params[:id]) 
    @messages = @selected_room.messages.order(created_at: :asc)
    @message = Message.new

    render :index
  end

  def create
    @room = Room.create(room_params)
  end



  private

  def set_new_room
    @room = Room.new
  end

  def room_params
    params.require(:room).permit(:name, :is_private)
  end

  def setup_rooms_and_users_variables
    @rooms = Room.public_rooms
    @users = User.all_except(current_user)
  end
end
