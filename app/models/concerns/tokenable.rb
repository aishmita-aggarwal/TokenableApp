module Tokenable
  extend ActiveSupport::Concern

  def generate_unique_token(attribute = :token, type = '', length = 6)
    if type == :hex
      generate_unique_hex_token(attribute, length)
    else
      generate_unique_digit_token(attribute, length)
    end
    generate_unique_token(attribute, type, length) if self.class.exists?(attribute => send(attribute))
  end

  private
    def generate_unique_hex_token(attribute, length)
      self[attribute] = SecureRandom.hex(length/2)
    end

    def generate_unique_digit_token(attribute, length)
      self[attribute] = rand(10 ** length).to_s.rjust(length, '0')
    end

  class_methods do

    def acts_as_tokenable(column = :token, options = {})
      input = set_values(column, options)
      add_callback(input)
    end

    private
      def set_values(column, options)
        input = {}
        input[:column] =  column
        input[:type] = options[:type] || :digit
        input[:length] = options[:length] || 6
        input[:before] = options[:before] || :create
        input
      end

      def add_callback(input)
        send("before_#{ input[:before] }") do |record|
          record.generate_unique_token(input[:column], input[:type], input[:length])
        end
      end
  end
end
