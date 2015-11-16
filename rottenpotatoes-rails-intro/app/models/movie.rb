class Movie < ActiveRecord::Base

  def self.rating_filtered(filter_by)
    if filter_by == [] || filter_by.nil?
      return self.all
    else
      self.where(rating: filter_by)
    end
  end

  def self.all_ratings
      self.uniq.pluck(:rating)
  end

end
