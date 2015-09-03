class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest,  :class_name => "User"
  validates  :rating, :description, presence: true
  validate   :valid_checkout

  private

  def valid_checkout
    if !reservation || reservation.status != "accepted" || reservation.checkout > Date.today
      errors.add(:invalid_review, "Please double check your reservation.")
    end
  end
end
