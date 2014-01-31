class Movie < ActiveRecord::Base

  has_many :reviews

  validates :title,
    presence: true

  validates :director,
    presence: true

  validates :runtime_in_minutes,
    numericality: { only_integer: true }

  validates :description,
    presence: true

  validates :poster_image_url,
    presence: true

  validates :release_date,
    presence: true

  validate :release_date_is_in_the_future

  def calculate_average_rating
    return nil unless reviews.any?
    reviews.sum(:rating_out_of_ten) / reviews.size
  end

  before_destroy :disallow_deletion_if_has_reviews

  protected

  def release_date_is_in_the_future
    if release_date.present?
      errors.add(:release_date, "should probably be in the future") if release_date < Date.today
    end
  end

  def disallow_deletion_if_has_reviews
    if self.reviews.size > 0
      self.errors.add :base, "Movie has reviews"
      return false 
    end
    true
  end

end
