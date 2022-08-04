class Room < ApplicationRecord
  validates :name, presence: true, uniqueness: true, length: { minimum: 1, maximum: 15 }

  scope :public_rooms, -> { where(is_private: false) }

  after_create_commit { broadcast_if_public }
  has_many :messages, dependent: :destroy
  has_many :participants, dependent: :destroy

  def broadcast_if_public
    broadcast_append_to "rooms" unless self.is_private
  end

  def self.create_private_room(users, room_name)
    selected_room = Room.create(name: room_name, is_private: true)
    users.each do |user|
      Participant.create(user_id: user.id, room_id: selected_room.id)
    end
    selected_room
  end

end
