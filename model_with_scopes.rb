class Member < ActiveRecord::Base
  require 'paperclip'
  attr_accessible :name, :country, :title, :avatar_file_name, :description, :position

  named_scope :position, lambda { |*args| param = (args.empty? ? 'manager' : args.first); {:conditions => {:position => param}, :order => :id }}
  named_scope :title, lambda { |*args| param = (args.empty? ? 'cult_leader' : args.first); {:conditions => { :position => 'grad', :title => param} }}

  INSTRUCTOR_PRIORITIES = ["Course Director", "IDC Staff Instructor", "Master Scuba Diver Trainer", "Open Water Scuba Instructor", "Divemaster"]

  def self.members_in_threes(type, grad = true)
    members = grad ? Member.title(type) : Member.position(type)
    index = members.size/3
    members_in_3 = []
    (0...index+1).each do |i|
      base = i*3
      members_in_3[i] = [members[base], members[base+1], members[base+2]].compact
    end
    members_in_3
  end

  def self.sorted_dive_staff
    Member.position('dive_staff').sort {|a,b| INSTRUCTOR_PRIORITIES.index(a.title) <=> INSTRUCTOR_PRIORITIES.index(b.title) }
  end

  def first_name
    a = name.split(" ")
    a.slice!(-1) if a.size > 1
    a.join(" ")
  end
end
