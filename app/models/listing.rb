class Listing < ActiveRecord::Base
  belongs_to    :neighborhood
  belongs_to    :host, :class_name => "User"
  has_many      :reservations
  has_many      :reviews, :through => :reservations
  has_many      :guests, :class_name => "User", :through => :reservations
  before_create :update_host_status_true
  after_destroy :update_host_status_false
  validates     :address, :listing_type, :title, :description, :price,
                :neighborhood_id, presence: true

  def average_review_rating
    ratings = reviews.each_with_object([]) { |r, a| a << r.rating }
    ratings.reduce(0.0) { |sum, r| sum + r } / ratings.size
  end

  private

  def update_host_status_true
    host.update(host: true)
  end

  def update_host_status_false
    host.update(host: false) if host.listings.empty?
  end
end
