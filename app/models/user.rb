class User < ActiveRecord::Base
  include Tokenable

  validates :name, presence: true
end