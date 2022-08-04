class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable recoverable, 
  devise :database_authenticatable, :registerable,
         :validatable, :rememberable

  scope :all_except, ->(user) { where.not(id: user) }
end
