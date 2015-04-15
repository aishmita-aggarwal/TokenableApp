module Tokenable
  extend ActiveSupport::Concern

  def generate_unique_token(attribute = :token, type = :digit, length = 6)
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

    def acts_as_tokenable(*args)
      options = (args.last.is_a? Hash) ? args.pop : {}
      add_callback(set_values(args, options))
    end

    private
      def set_values(columns, options)
        input = {
          columns: columns.any? ? columns : [:token],
          type: options[:type] || :digit,
          length: options[:length] || 6,
          before: options[:before] || :create
        }
      end

      def add_callback(input)
        input[:columns].each do |attribute|
          send("before_#{ input[:before] }") do |record|
            if record.has_attribute?(attribute)
              record.generate_unique_token(attribute, input[:type], input[:length])
            else
              raise ActiveRecord::UnknownAttributeError.new(record, attribute)
            end
          end
        end
      end
  end
end
