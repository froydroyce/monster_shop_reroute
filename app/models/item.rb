class Item < ApplicationRecord
  belongs_to :merchant
  has_many :order_items
  has_many :orders, through: :order_items
  has_many :reviews, dependent: :destroy

  validates_presence_of :name,
                        :description,
                        :image,
                        :price,
                        :inventory

  def sorted_reviews(limit = nil, order = :asc)
    reviews.order(rating: order).limit(limit)
  end

  def average_rating
    reviews.average(:rating)
  end

  def self.enabled_items
    where(active: true)
  end

  def self.top_five
    joins(:order_items).select('items.*, sum(order_items.quantity) as total_quantity').group(:id).order('total_quantity desc').limit(5)
  end

  def self.bottom_five
    joins(:order_items).select('items.*, sum(order_items.quantity) as total_quantity').group(:id).order('total_quantity').limit(5)
  end

  def any_orders?
    order_items.empty?
  end
end
