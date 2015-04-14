module Tokenable
  extend ActiveSupport::Concern

  included do
    before_create :generate_token
  end

  def generate_token
    #for hex based unique code
    self.token = SecureRandom.urlsafe_base64

    #for digit based unique code
    # self.token = rand(10 ** 6).to_s.rjust(6, '0')
    generate_token if self.class.exists?(token: token)
  end
end