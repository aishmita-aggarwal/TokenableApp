class User < ActiveRecord::Base
  include Tokenable

  tokenize :name, type: :hex, size: 12, callback: :before_create
  tokenize
end