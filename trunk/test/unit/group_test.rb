# Redmine - project management software
# Copyright (C) 2006-2011  Jean-Philippe Lang
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

require File.expand_path('../../test_helper', __FILE__)

class GroupTest < ActiveSupport::TestCase
  fixtures :projects, :trackers, :issue_statuses, :issues,
           :enumerations, :users, :issue_categories,
           :projects_trackers,
           :roles,
           :member_roles,
           :members,
           :enabled_modules,
           :workflows,
           :groups_users

  def test_create
    g = Group.new(:lastname => 'New group')
    assert g.save
  end

  def test_blank_name_error_message
    g = Group.new
    assert !g.save
    assert_include "Name can't be blank", g.errors.full_messages
  end

  def test_roles_given_to_new_user
    group = Group.find(11)
    user = User.find(9)
    project = Project.first

    Member.create!(:principal => group, :project => project, :role_ids => [1, 2])
    group.users << user
    assert user.member_of?(project)
  end

  def test_roles_given_to_existing_user
    group = Group.find(11)
    user = User.find(9)
    project = Project.first

    group.users << user
    m = Member.create!(:principal => group, :project => project, :role_ids => [1, 2])
    assert user.member_of?(project)
  end

  def test_roles_updated
    group = Group.find(11)
    user = User.find(9)
    project = Project.first
    group.users << user
    m = Member.create!(:principal => group, :project => project, :role_ids => [1])
    assert_equal [1], user.reload.roles_for_project(project).collect(&:id).sort

    m.role_ids = [1, 2]
    assert_equal [1, 2], user.reload.roles_for_project(project).collect(&:id).sort

    m.role_ids = [2]
    assert_equal [2], user.reload.roles_for_project(project).collect(&:id).sort

    m.role_ids = [1]
    assert_equal [1], user.reload.roles_for_project(project).collect(&:id).sort
  end

  def test_roles_removed_when_removing_group_membership
    assert User.find(8).member_of?(Project.find(5))
    Member.find_by_project_id_and_user_id(5, 10).destroy
    assert !User.find(8).member_of?(Project.find(5))
  end

  def test_roles_removed_when_removing_user_from_group
    assert User.find(8).member_of?(Project.find(5))
    User.find(8).groups.clear
    assert !User.find(8).member_of?(Project.find(5))
  end

  def test_destroy_should_unassign_issues
    group = Group.first
    Issue.update_all(["assigned_to_id = ?", group.id], 'id = 1')

    assert group.destroy
    assert group.destroyed?

    assert_equal nil, Issue.find(1).assigned_to_id
  end
end
