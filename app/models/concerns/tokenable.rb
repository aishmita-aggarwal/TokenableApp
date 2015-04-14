module Tokenable
  extend ActiveSupport::Concern

  def generate_unique_token(attribute = :token, type = :digit, size = 6)
    if type == :hex
      generate_unique_hex_token(attribute, size)
    else
      generate_unique_digit_token(attribute, size)
    end
    generate_unique_token(attribute, type, size) if self.class.exists?(attribute => send(attribute))
  end

  private
    def generate_unique_hex_token(attribute, size)
      self[attribute] = SecureRandom.hex(size/2)
    end

    def generate_unique_digit_token(attribute, size)
      self[attribute] = rand(10 ** size).to_s.rjust(size, '0')
    end

  class_methods do

    def tokenize(*args, &block)
      options = (args.last.is_a? Hash) ? args.pop : {}
      input = set_values(args, options)
      add_callback(input, &block)
    end

    private
      def set_values(args, options)
        input = {}
        input[:args] = args.any? ? args : [:token]
        input[:type] = options[:type] || :digit
        input[:size] = options[:size] || 6
        input[:before] = options[:before] || :create
        input
      end

      def add_callback(input, &block)
        input[:args].each do |attribute|
          send("before_#{ input[:before] }") do |record|
            record.generate_unique_token(attribute, input[:type], input[:size])
          end
        end
      end
  end
end
