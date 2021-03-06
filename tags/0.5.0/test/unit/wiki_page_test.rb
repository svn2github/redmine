# redMine - project management software
# Copyright (C) 2006-2007  Jean-Philippe Lang
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

require File.dirname(__FILE__) + '/../test_helper'

class WikiPageTest < Test::Unit::TestCase
  fixtures :wikis, :wiki_pages, :wiki_contents, :wiki_content_versions

  def setup
    @wiki = Wiki.find(1)
    @page = @wiki.pages.first
  end
  
  def test_create
    page = WikiPage.new(:wiki => @wiki)
    assert !page.save
    assert_equal 1, page.errors.count
  
    page.title = "Page"
    assert page.save
    page.reload
    
    @wiki.reload
    assert @wiki.pages.include?(page)
  end
  
  def test_find_or_new_page
    page = @wiki.find_or_new_page("CookBook documentation")
    assert_kind_of WikiPage, page
    assert !page.new_record?
    
    page = @wiki.find_or_new_page("Non existing page")
    assert_kind_of WikiPage, page
    assert page.new_record?
  end
end
