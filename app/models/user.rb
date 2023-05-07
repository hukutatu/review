class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_one_attached :profile_image

  has_many :mine, class_name: "Relationship", foreign_key: "follow_id", dependent: :destroy
  has_many :followings, through: :mine, source: :followed

  has_many :youre, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :youre, source: :follow



  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: { maximum: 50 }


  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end

  def follow(user)
    mine.create(followed_id: user.id)
  end

  def unfollow(user)
    mine.find_by(followed_id: user.id).destroy
  end

  def following?(user)
    followings.include?(user)
  end
end
