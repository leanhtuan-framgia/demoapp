class User < ApplicationRecord
  has_many :entries, dependent: :destroy
  has_many :comments, dependent: :destroy

  has_many :active_relationships, class_name: Relationship.name,
    foreign_key: "follower_id", dependent: :destroy
  has_many :passive_relationships, class_name: Relationship.name,
    foreign_key: "followed_id", dependent: :destroy

  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships

  validates :name, presence: true, length: {maximum: 50}

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 255},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}
  has_secure_password
  validates :password, presence: true, length: {minimum: 6}

  before_save :email_downcase

  class << self
      def digest string
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
          BCrypt::Engine.cost
        BCrypt::Password.create string, cost: cost
      end

      def new_token
        SecureRandom.urlsafe_base64
      end
    end

    def feeds
      entries.order_by_time
      Entry.feeds following_ids,id
    end

    def create_reset_digest
      self.reset_token = User.new_token
      update_columns reset_digest: User.digest(reset_token),
        reset_sent_at: Time.zone.now
    end

    def correct_user? current_user
      self == current_user
    end

    def follow other_user
      active_relationships.create followed_id: other_user.id
    end

    def unfollow other_user
      active_relationships.find_by(followed_id: other_user.id).destroy
    end

    def following? other_user
      following.include? other_user
    end

    private
    def email_downcase
      self.email = email.downcase
    end
end
