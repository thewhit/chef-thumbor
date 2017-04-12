#
# Cookbook Name:: thumbor
# Recipe:: default
#
# Author:: Enrico Stahn <mail@enricostahn.com>
#
# Copyright 2012-2015, Zanui <engineering@zanui.com.au>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe 'apt::default'
include_recipe 'poise-python::default'
include_recipe 'thumbor::dependencies'
include_recipe "thumbor::#{node['thumbor']['install_method']}"
include_recipe 'thumbor::user'
include_recipe 'thumbor::initstyle'
include_recipe 'thumbor::config'

service 'thumbor' do
  case node['thumbor']['init_style']
  when 'upstart'
    provider Chef::Provider::Service::Upstart
  else
    provider Chef::Provider::Service::Init
  end
  supports restart: true, start: true, stop: true, reload: true, status: true
  service_name node['thumbor']['service_name']
  action [:enable, :start]
end

include_recipe "thumbor::#{node['thumbor']['proxy']['type']}" if node['thumbor']['proxy']['type'] != 'none'
include_recipe "thumbor::#{node['thumbor']['queue']['type']}" if node['thumbor']['queue']['type'] != 'none'

include_recipe 'thumbor::monit' if node['thumbor']['monit']['enable']
