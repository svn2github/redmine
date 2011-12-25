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

class RoutingTest < ActionController::IntegrationTest
  def test_queries
    assert_routing(
        { :method => 'get', :path => "/queries.xml" },
        { :controller => 'queries', :action => 'index', :format => 'xml' }
      )
    assert_routing(
        { :method => 'get', :path => "/queries.json" },
        { :controller => 'queries', :action => 'index', :format => 'json' }
      )
    assert_routing(
        { :method => 'get', :path => "/queries/new" },
        { :controller => 'queries', :action => 'new' }
      )
    assert_routing(
        { :method => 'get', :path => "/projects/redmine/queries/new" },
        { :controller => 'queries', :action => 'new', :project_id => 'redmine' }
      )
    assert_routing(
        { :method => 'post', :path => "/queries" },
        { :controller => 'queries', :action => 'create' }
      )
    assert_routing(
        { :method => 'post', :path => "/projects/redmine/queries" },
        { :controller => 'queries', :action => 'create', :project_id => 'redmine' }
      )
    assert_routing(
        { :method => 'get', :path => "/queries/1/edit" },
        { :controller => 'queries', :action => 'edit', :id => '1' }
      )
    assert_routing(
        { :method => 'put', :path => "/queries/1" },
        { :controller => 'queries', :action => 'update', :id => '1' }
      )
    assert_routing(
        { :method => 'delete', :path => "/queries/1" },
        { :controller => 'queries', :action => 'destroy', :id => '1' }
      )
  end

  def test_wiki_singular_projects_pages
    assert_routing(
        { :method => 'get', :path => "/projects/567/wiki" },
        { :controller => 'wiki', :action => 'show', :project_id => '567' }
      )
    assert_routing(
        { :method => 'get', :path => "/projects/567/wiki/lalala" },
        { :controller => 'wiki', :action => 'show', :project_id => '567',
          :id => 'lalala' }
      )
    assert_routing(
        { :method => 'get', :path => "/projects/567/wiki/my_page/edit" },
        { :controller => 'wiki', :action => 'edit', :project_id => '567',
          :id => 'my_page' }
      )
    assert_routing(
        { :method => 'get', :path => "/projects/1/wiki/CookBook_documentation/history" },
        { :controller => 'wiki', :action => 'history', :project_id => '1',
          :id => 'CookBook_documentation' }
      )
    assert_routing(
        { :method => 'get', :path => "/projects/1/wiki/CookBook_documentation/diff" },
        { :controller => 'wiki', :action => 'diff', :project_id => '1',
          :id => 'CookBook_documentation' }
      )
    assert_routing(
        { :method => 'get', :path => "/projects/1/wiki/CookBook_documentation/diff/2" },
        { :controller => 'wiki', :action => 'diff', :project_id => '1',
          :id => 'CookBook_documentation', :version => '2' }
      )
    assert_routing(
        { :method => 'get', :path => "/projects/1/wiki/CookBook_documentation/diff/2/vs/1" },
        { :controller => 'wiki', :action => 'diff', :project_id => '1',
          :id => 'CookBook_documentation', :version => '2', :version_from => '1' }
      )
    assert_routing(
        { :method => 'get', :path => "/projects/1/wiki/CookBook_documentation/annotate/2" },
        { :controller => 'wiki', :action => 'annotate', :project_id => '1',
          :id => 'CookBook_documentation', :version => '2' }
      )
    assert_routing(
        { :method => 'get', :path => "/projects/22/wiki/ladida/rename" },
        { :controller => 'wiki', :action => 'rename', :project_id => '22',
          :id => 'ladida' }
      )
    assert_routing(
        { :method => 'get', :path => "/projects/567/wiki/index" },
        { :controller => 'wiki', :action => 'index', :project_id => '567' }
      )
    assert_routing(
        { :method => 'get', :path => "/projects/567/wiki/date_index" },
        { :controller => 'wiki', :action => 'date_index', :project_id => '567' }
      )
    assert_routing(
        { :method => 'get', :path => "/projects/567/wiki/export" },
        { :controller => 'wiki', :action => 'export', :project_id => '567' }
      )
    assert_routing(
        { :method => 'post', :path => "/projects/567/wiki/CookBook_documentation/preview" },
        { :controller => 'wiki', :action => 'preview', :project_id => '567',
          :id => 'CookBook_documentation' }
      )
    assert_routing(
        { :method => 'post', :path => "/projects/22/wiki/ladida/rename" },
        { :controller => 'wiki', :action => 'rename', :project_id => '22',
          :id => 'ladida' }
      )
    assert_routing(
        { :method => 'post', :path => "/projects/22/wiki/ladida/protect" },
        { :controller => 'wiki', :action => 'protect', :project_id => '22',
          :id => 'ladida' }
      )
    assert_routing(
        { :method => 'post', :path => "/projects/22/wiki/ladida/add_attachment" },
        { :controller => 'wiki', :action => 'add_attachment', :project_id => '22',
          :id => 'ladida' }
      )
    assert_routing(
        { :method => 'put', :path => "/projects/567/wiki/my_page" },
        { :controller => 'wiki', :action => 'update', :project_id => '567',
          :id => 'my_page' }
      )
    assert_routing(
        { :method => 'delete', :path => "/projects/22/wiki/ladida" },
        { :controller => 'wiki', :action => 'destroy', :project_id => '22',
          :id => 'ladida' }
      )
  end

  def test_wikis_plural_admin_setup
    assert_routing(
        { :method => 'get', :path => "/projects/ladida/wiki/destroy" },
        { :controller => 'wikis', :action => 'destroy', :id => 'ladida' }
      )
    assert_routing(
        { :method => 'post', :path => "/projects/ladida/wiki" },
        { :controller => 'wikis', :action => 'edit', :id => 'ladida' }
      )
    assert_routing(
        { :method => 'post', :path => "/projects/ladida/wiki/destroy" },
        { :controller => 'wikis', :action => 'destroy', :id => 'ladida' }
      )
  end
end
