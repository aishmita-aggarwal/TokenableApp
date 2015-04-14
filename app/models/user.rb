class User < ActiveRecord::Base
  include Tokenable

  acts_as_tokenable :name, type: :hex, length: 12, before: :create
  acts_as_tokenable
end