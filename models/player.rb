class Player < ActiveRecord::Base
  has_many :results

  validates_uniqueness_of :name
end