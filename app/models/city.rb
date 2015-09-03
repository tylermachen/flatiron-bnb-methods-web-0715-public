class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, through: :listings

  def self.highest_ratio_res_to_listings
    cities = {}
    all.each do |city|
      res_ratio = city.reservations.count / city.listings.count unless city.listings.count == 0
      cities[city] = res_ratio
    end
    cities.max_by { |k, v| v }.first
  end

  def self.most_res
    cities = {}
    all.each { |city| cities[city] = city.reservations.count }
    cities.max_by { |k, v| v }.first
  end

  def city_openings(start_date, end_date)
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
