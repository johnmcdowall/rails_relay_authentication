class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  enum role: [ :reader, :publisher, :admin ]

  has_many :posts

  def firstName
    first_name
  end
  
  def firstName=(value)
    self[:first_name] = value
  end

  def lastName
    last_name
  end
  
  def lastName=(value)
    self[:last_name] = value
  end
end