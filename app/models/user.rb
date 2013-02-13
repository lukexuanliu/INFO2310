class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :email, :name, :password
  
  validates :password, presence: true, if: "hashed_password.blank?"
  
  validates :name, presence: true,
                      length: { minimum: 4, maximum: 50 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
                        format: { with: VALID_EMAIL_REGEX },
                      uniqueness: { case_sensitive: false }
  
  has_many :micro_posts

  before_save :encrypt_password
                
  def encrypt_password
    self.salt ||= Digest::SHA256.hexdigest("--#{Time.now.to_s}- -#{email}--")
    self.hashed_password = encrypt(password)
  end

  def encrypt(raw_password)
    Digest::SHA256.hexdigest("--#{salt}--#{raw_password}--")
  end
  
  # If there is a user in the database with the given email, and 
  # the password matches theirs, returns the user.
  # Otherwise, returns nil
  def self.authenticate(email, plain_text_password)
    #match email with self.email
	#  if not found, return nil
	user = self.find_by_email(email)
	return nil unless user
	
	#hash plain_text_password using its salt
	#  match the result with self.hashed_password
	(user.encrypt(plain_text_password) == user.hashed_password) ? user : nil
  end
end