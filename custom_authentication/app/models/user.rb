class User < ApplicationRecord
  has_secure_password

  attr_accessor :remember_digest

  validates :username, :email, :password_digest, presence: true
  validates :email, :password_digest, uniqueness: true
  validates :password, length: { minimum: 6 }

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_digest = User.new_token
    update_attribute(:remember_token, User.digest(remember_digest))
  end

  def authenticated?(remember_digest)
    BCrypt::Password.new(remember_token).is_password?(remember_digest)
  end

  def forget
    update_attribute(:remember_token, nil)
  end
end
