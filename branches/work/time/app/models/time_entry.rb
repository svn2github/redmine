class TimeEntry < ActiveRecord::Base
  belongs_to :project
  belongs_to :issue
  belongs_to :user
  belongs_to :activity, :class_name => 'Enumeration', :foreign_key => :activity_id
  
  attr_protected :project_id, :user_id, :tyear, :tmonth, :tweek
  
  validates_presence_of :user_id, :activity_id, :project_id, :hours, :spent_on
  validates_numericality_of :hours, :allow_nil => true
  validates_length_of :comment, :maximum => 255

  def before_validation
    self.project = issue.project if issue && project.nil?
  end
  
  def validate
    errors.add :hours, :activerecord_error_invalid if hours && hours < 0
    errors.add :project_id, :activerecord_error_invalid if project.nil?
    errors.add :issue_id, :activerecord_error_invalid if issue && project!=issue.project
  end
  
  def spent_on=(date)
    super
    self.tyear = spent_on ? spent_on.year : nil
    self.tmonth = spent_on ? spent_on.month : nil
    self.tweek = spent_on ? spent_on.cweek : nil
  end  
end
