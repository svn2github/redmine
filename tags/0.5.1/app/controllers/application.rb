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

class ApplicationController < ActionController::Base
  before_filter :check_if_login_required, :set_localization
  filter_parameter_logging :password
  
  REDMINE_SUPPORTED_SCM.each do |scm|
    require_dependency "repository/#{scm.underscore}"
  end
  
  def logged_in_user=(user)
    @logged_in_user = user
    session[:user_id] = (user ? user.id : nil)
  end
  
  def logged_in_user
    if session[:user_id]
      @logged_in_user ||= User.find(session[:user_id])
    else
      nil
    end
  end
  
  # Returns the role that the logged in user has on the current project
  # or nil if current user is not a member of the project
  def logged_in_user_membership
    @user_membership ||= logged_in_user.role_for_project(@project)
  end
  
  # check if login is globally required to access the application
  def check_if_login_required
    # no check needed if user is already logged in
    return true if logged_in_user
    # auto-login feature
    autologin_key = cookies[:autologin]
    if autologin_key && Setting.autologin?
      self.logged_in_user = User.find_by_autologin_key(autologin_key)
    end
    require_login if Setting.login_required?
  end 
  
  def set_localization
    lang = begin
      if self.logged_in_user and self.logged_in_user.language and !self.logged_in_user.language.empty? and GLoc.valid_languages.include? self.logged_in_user.language.to_sym
        self.logged_in_user.language
      elsif request.env['HTTP_ACCEPT_LANGUAGE']
        accept_lang = parse_qvalues(request.env['HTTP_ACCEPT_LANGUAGE']).first.split('-').first
        if accept_lang and !accept_lang.empty? and GLoc.valid_languages.include? accept_lang.to_sym
          accept_lang
        end
      end
    rescue
      nil
    end || Setting.default_language
    set_language_if_valid(lang)    
  end
  
  def require_login
    unless self.logged_in_user
      store_location
      redirect_to :controller => "account", :action => "login"
      return false
    end
    true
  end

  def require_admin
    return unless require_login
    unless self.logged_in_user.admin?
      render_403
      return false
    end
    true
  end

  # authorizes the user for the requested action.
  def authorize(ctrl = params[:controller], action = params[:action])
    unless @project.active?
      @project = nil
      render_404
      return false
    end
    # check if action is allowed on public projects
    if @project.is_public? and Permission.allowed_to_public "%s/%s" % [ ctrl, action ]
      return true
    end    
    # if action is not public, force login
    return unless require_login    
    # admin is always authorized
    return true if self.logged_in_user.admin?
    # if not admin, check membership permission    
    if logged_in_user_membership and Permission.allowed_to_role( "%s/%s" % [ ctrl, action ], logged_in_user_membership )    
      return true		
    end		
    render_403
    false
  end
  
  # make sure that the user is a member of the project (or admin) if project is private
  # used as a before_filter for actions that do not require any particular permission on the project
  def check_project_privacy
    unless @project.active?
      @project = nil
      render_404
      return false
    end
    return true if @project.is_public?
    return false unless logged_in_user
    return true if logged_in_user.admin? || logged_in_user_membership
    render_403
    false
  end

  # store current uri in session.
  # return to this location by calling redirect_back_or_default
  def store_location
    session[:return_to_params] = params
  end

  # move to the last store_location call or to the passed default one
  def redirect_back_or_default(default)
    if session[:return_to_params].nil?
      redirect_to default
    else
      redirect_to session[:return_to_params]
      session[:return_to_params] = nil
    end
  end
  
  def render_403
    @html_title = "403"
    @project = nil
    render :template => "common/403", :layout => true, :status => 403
    return false
  end
    
  def render_404
    @html_title = "404"
    render :template => "common/404", :layout => true, :status => 404
    return false
  end

  # qvalues http header parser
  # code taken from webrick
  def parse_qvalues(value)
    tmp = []
    if value
      parts = value.split(/,\s*/)
      parts.each {|part|
        if m = %r{^([^\s,]+?)(?:;\s*q=(\d+(?:\.\d+)?))?$}.match(part)
          val = m[1]
          q = (m[2] or 1).to_f
          tmp.push([val, q])
        end
      }
      tmp = tmp.sort_by{|val, q| -q}
      tmp.collect!{|val, q| val}
    end
    return tmp
  end
end