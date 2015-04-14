class User < ActiveRecord::Base
  include Tokenable

  tokenize :name, type: :hex, size: 12, before: :create
  tokenize
end