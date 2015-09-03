class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many   :listings
  has_many   :reservations, through: :listings

  def self.highest_ratio_res_to_listings
    hoods = {}
    all.each do |hood|
      res_ratio = hood.reservations.count / hood.listings.count unless hood.listings.count == 0
      hoods[hood] = res_ratio.to_f
    end
    hoods.max_by { |k, v| v }.first
  end

  def self.most_res
    hoods = {}
    all.each { |hood| hoods[hood] = hood.reservations.count }
    hoods.max_by { |k, v| v }.first
  end

  def neighborhood_openings(start_date, end_date)
    openings = []
    d1 = Date.parse(start_date)
    d2 = Date.parse(end_date)
    listings.each do |listing|
      listing.reservations.each do |reservation|
        if reservation.checkout < d1 || reservation.checkin > d2
          openings << listing
        end
      end
    end
    openings
  end
end
