# redMine - project management software
# Copyright (C) 2006  Jean-Philippe Lang
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

class Document < ActiveRecord::Base
  belongs_to :project
  belongs_to :category, :class_name => "Enumeration", :foreign_key => "category_id"
  has_many :attachments, :as => :container, :dependent => :destroy

  acts_as_searchable :columns => ['title', 'description']
  acts_as_event :title => Proc.new {|o| "#{l(:label_document)}: #{o.title}"},
                :url => Proc.new {|o| {:controller => 'documents', :action => 'show', :id => o.id}}

  validates_presence_of :project, :title, :category
  validates_length_of :title, :maximum => 60
end
