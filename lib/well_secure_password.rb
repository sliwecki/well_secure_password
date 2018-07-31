# frozen_string_literal: true
require 'well_secure_password/version'
require 'well_secure_password/config'
require 'well_secure_password/engine'

module WellSecurePassword
  extend ActiveSupport::Concern

  module ClassMethods

    def has_well_secure_password(options = {})
      begin
        require 'bcrypt'
      rescue LoadError
        $stderr.puts("You don't have bcrypt installed in your application. Please add it to your Gemfile and run bundle install")
        raise
      end

      include InstanceMethodsOnActivation

      if options.fetch(:validations, true)
        include ActiveModel::Validations
        validate { |record| record.errors.add(:password, :blank) unless record.password_digest.present? }
        # validates_length_of(:password, maximum: WellSecurePassword::MAX_PASSWORD_LENGTH_ALLOWED)
        validates_confirmation_of(:password, allow_blank: true)
      end
    end
  end

  module InstanceMethodsOnActivation

    def authenticate(unencrypted_password)
      sha512_hash = OpenSSL::Digest::SHA512.new(unencrypted_password).digest
      BCrypt::Password.new(WellSecurePassword::Engine.decode(self.password_digest)).is_password?(sha512_hash) && self
    end

    attr_reader :password

    def password=(unencrypted_password)
      if unencrypted_password.nil?
        self.password_digest = nil
      elsif !unencrypted_password.empty?
        @password = unencrypted_password
        self.password_digest = WellSecurePassword::Engine.encode(unencrypted_password)
      end
    end

    def password_confirmation=(unencrypted_password)
      @password_confirmation = unencrypted_password
    end
  end
end

ActiveSupport.on_load(:active_record) { include WellSecurePassword } if defined? ActiveRecord
