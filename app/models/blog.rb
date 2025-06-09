# frozen_string_literal: true

class Blog < ApplicationRecord
  belongs_to :user
  has_many :likings, dependent: :destroy
  has_many :liking_users, class_name: 'User', source: :user, through: :likings

  validates :title, :content, presence: true

  scope :published, -> { where('secret = FALSE') }

  scope :search, lambda { |term|
    where('title LIKE :term OR content LIKE :term', term: "%#{term}%")
  }

  scope :default_order, -> { order(id: :desc) }

  scope :view_auth, lambda { |user|
    if user
      where('secret = FALSE').or(where(user_id: user.id))
    else
      where('secret = FALSE')
    end
  }

  def owned_by?(target_user)
    user == target_user
  end
end
