module WellSecurePassword
  module Engine
    module_function

    def encode(secret)
      sha512_hash = OpenSSL::Digest::SHA512.new(secret).digest
      bcrypt_hash = BCrypt::Password.create(sha512_hash, cost: BCrypt::Engine.cost)
      cipher = OpenSSL::Cipher::AES256.new(:CBC)
      cipher.encrypt
      cipher.key = OpenSSL::Digest::SHA256.new(WellSecurePassword::Config.config.secret_key).digest
      iv = cipher.random_iv
      encrypted = cipher.update(bcrypt_hash) + cipher.final
      Base64.strict_encode64(iv+encrypted)
    end

    def decode(digest)
      binary_string = Base64.strict_decode64(digest)
      iv = binary_string.byteslice(0..15)
      encrypted = binary_string.byteslice(16..binary_string.bytesize)
      cipher = OpenSSL::Cipher::AES256.new(:CBC)
      cipher.decrypt
      cipher.key = OpenSSL::Digest::SHA256.new(WellSecurePassword::Config.config.secret_key).digest
      cipher.iv = iv
      cipher.update(encrypted) + cipher.final
    end
  end
end
