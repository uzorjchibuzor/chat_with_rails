class Room < ApplicationRecord
  validates :name, presence: true, uniqueness: true, length: { minimum: 5, maximum: 15 }

  scope :public_rooms, -> { where(is_private: false) }
end
