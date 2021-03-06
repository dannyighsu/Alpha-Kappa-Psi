class Rushee < ActiveRecord::Base

	GRADE_TYPES = ["Freshman", "Sophomore", "Junior", "Junior Transfer", "Senior"]

	has_many :rusheeposts, dependent: :destroy
  has_one :rush_application, foreign_key: 'rushee_id', dependent: :destroy
  has_many :interview_slots, foreign_key: 'rushee_id', dependent: :destroy

	before_save { self.email = email.downcase }
	before_save { self.grade = grade.capitalize }

	has_attached_file :photograph,
	  :styles => { :medium => "300x300>", :middle => "250x250>", :middlesmall => "225x225>", :small => "200x200>", :thumb => "100x100>" },
	  :storage => :s3,
	  :bucket => "akpsi-alpha-beta",
	  :default_url => '/images/:attachment/missing_:style.png',
	  :url =>':s3_domain_url',
	  :path => '/:class/:attachment/:id_partition/:style/:filename',
	  :s3_credentials => S3_CREDENTIALS

	# Validate attachment type
	validates_attachment_content_type :photograph, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]

	# Validation for name attribute
	validates(:name, presence: true, length: { maximum: 50 } )

	# Validation for email attribute
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
	validates(:email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false } )

	# Validates password
	has_secure_password
	validates :password, presence: { on: :create }, length: { minimum: 6, allow_blank: true }

	validates_inclusion_of :grade, :in => GRADE_TYPES

end
