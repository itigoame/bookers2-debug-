class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy

  has_many :follower, class_name: "Relationship",foreign_key: "follower_id",dependent: :destroy
  has_many :followings,through: :follower, source: :followed

  has_many :followed, class_name: "Relationship" ,foreign_key: "followed_id",dependent: :destroy
  has_many :followers,through: :followed, source: :follower

  has_one_attached :profile_image

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length:{maximum: 50 }

  # 検索窓
  def self.looks(search, word)
    if search == "perfect_match"
      @user = User.where("name LIKE?", "#{word}")
    elsif search == "forward_match"
      @user = User.where("name LIKE?","#{word}%")
    elsif search == "backward_match"
      @user = User.where("name LIKE?","%#{word}")
    elsif search == "partial_match"
      @user = User.where("name LIKE?","%#{word}%")
    else
      @user = User.all
    end
  end

  def self.guest
    find_or_create_by!(name: "guestuser",email: "guest@example.com") do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "guestuser"
    end
  end

  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end

  # フォローしたときの処理
  def follow(user_id)
    follower.create(followed_id: user_id)
  end

  # フォローを外すときの処理
  def unfollow(user_id)
    follower.find_by(followed_id: user_id).destroy
  end

  # フォローしているか判定
  def followings?(user)
    followings.include?(user)
  end
end
