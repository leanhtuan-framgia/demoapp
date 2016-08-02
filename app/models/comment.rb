class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :entry

  validates :user, presence: true
  validates :entry, presence: true
  validates :content, presence: true, length: {maximum: 100}

  scope :order_by_time, -> {order created_at: :desc}
  scope :get_comments_by_entry, -> (entry_id){where("entry_id = ?", entry_id)}
end

