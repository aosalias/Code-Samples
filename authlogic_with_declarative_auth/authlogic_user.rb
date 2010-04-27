class User < ActiveRecord::Base
  acts_as_authentic
  has_many :votes
  has_many :bills, :through => :votes, :uniq => true
  has_many :assignments
  has_many :roles, :through => :assignments, :uniq => true

  before_create { |u| u.roles = [Role.user] }

  def role_symbols
    roles.map do |role|
      role.name.underscore.to_sym
    end
  end
end