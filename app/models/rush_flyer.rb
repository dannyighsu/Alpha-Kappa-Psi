class RushFlyer < ActiveRecord::Base

  has_attached_file :front,
    :storage => :s3,
    :bucket => "akpsi-alpha-beta",
    :default_url => '/images/:attachment/missing_:style.png',
    :url =>':s3_domain_url',
    :path => '/:class/:attachment/:id_partition/:style/:filename',
    :s3_credentials => S3_CREDENTIALS

  validates_attachment_content_type :image,
    :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]

end
