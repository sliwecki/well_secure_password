require 'dry-configurable'

module WellSecurePassword
  class Config
    extend Dry::Configurable

    setting :secret_key
  end
end
