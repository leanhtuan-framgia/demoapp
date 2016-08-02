class Entry < ApplicationRecord
  belongs_to :user

  has_many :comments, dependent: :destroy

  validates :user, presence: true
  validates :content, presence: true, length: {maximum: 200}
  validates :title, presence: true, length: {maximum: 30}

  scope :order_by_time, -> {order created_at: :desc}
  scope :feeds,
    ->(other_ids, id) {where("user_id IN (?) OR user_id = ?", other_ids, id)}
end
