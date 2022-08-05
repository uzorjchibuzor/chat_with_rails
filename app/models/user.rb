class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable recoverable, 
  devise :database_authenticatable, :registerable,
         :validatable, :rememberable

  scope :all_except, ->(user) { where.not(id: user) }

  after_create_commit { broadcast_append_to 'users' } 
  has_many :messages, dependent: :destroy
  has_one_attached :avatar, dependent: :destroy
  has_many :participants, dependent: :destroy

  after_commit :add_default_avatar, on: %i[create update]
  after_update_commit { broadcast_update }

  enum status: %i[offline away online]
    
  def avatar_thumbnail
    avatar.variant(resize_to_limit: [150,150]).processed
  end

  def chat_avatar
    chat_thumbnail
  end

  def chat_thumbnail
    avatar.variant(resize_to_limit: [50,50]).processed
  end

  def status_to_css
    case status
    when 'online'
      'bg-success'
    when 'away'
      'bg-warning'
    when 'offline'
      'bg-dark'
    else 
      'bg-dark'
    end
  end

  def username
    email.split('@').first.capitalize
  end

  private

  def broadcast_update
    broadcast_replace_to 'user_status', user: self
  end

  def add_default_avatar
    return if avatar.attached?
    avatar.attach(io: File.open(Rails.root.join('app', 'assets', 'images', 'default_avatar.png')), filename: 'default_avatar.png', content_type: 'image/png')
  end
end
