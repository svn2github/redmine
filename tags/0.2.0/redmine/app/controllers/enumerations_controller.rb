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

class EnumerationsController < ApplicationController
  layout 'base'
  before_filter :require_admin
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
  end

  def new
    @enumeration = Enumeration.new(:opt => params[:opt])
  end

  def create
    @enumeration = Enumeration.new(params[:enumeration])
    if @enumeration.save
      flash[:notice] = 'Enumeration was successfully created.'
      redirect_to :action => 'list', :opt => @enumeration.opt
    else
      render :action => 'new'
    end
  end

  def edit
    @enumeration = Enumeration.find(params[:id])
  end

  def update
    @enumeration = Enumeration.find(params[:id])
    if @enumeration.update_attributes(params[:enumeration])
      flash[:notice] = 'Enumeration was successfully updated.'
      redirect_to :action => 'list', :opt => @enumeration.opt
    else
      render :action => 'edit'
    end
  end

  def destroy
    Enumeration.find(params[:id]).destroy
    redirect_to :action => 'list'
  rescue
    flash[:notice] = "Unable to delete enumeration"
    redirect_to :action => 'list'
  end
end
