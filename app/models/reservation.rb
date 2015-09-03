class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one    :review
  belongs_to :neighborhood
  validates  :checkin, :checkout, presence: true
  has_many   :cities, through: :listings
  validate   :not_own_reservation, :not_same_dates,
             :checkin_before_checkout, :listing_available

  def duration
    checkout - checkin
  end

  def total_price
    listing.price * duration
  end

  private

  def not_own_reservation
    if listing.host == guest
      errors.add(:same_ids, "Sorry, you cannot reserve your own listing")
    end
  end

  def not_same_dates
    if checkin && checkout && duration == 0
      errors.add(:same_dates, "Sorry, checkin and checkout cannot be the same")
    end
  end

  def listing_available
    if checkin && checkout
      listing.reservations.each do |reservation|
        if reservation.checkout > checkin && reservation.checkin < checkout
          errors.add(:listing_available, "Sorry, the listing is unavailable")
        end
      end
    end
  end

  def checkin_before_checkout
    if checkin && checkout && checkin > checkout
      errors.add(:checkout_before_checkin, "Checkout can not be before checkin")
    end
  end
end
