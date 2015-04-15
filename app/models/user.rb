class User < ActiveRecord::Base
  include Tokenable

  acts_as_tokenable :name, type: :hex, length: 100, before: :create
  acts_as_tokenable  length: 10
end