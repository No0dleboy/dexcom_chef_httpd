#
# Cookbook Name:: learn_chef_httpd
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
package 'httpd'

service 'httpd' do
  action [:enable, :start]
end

directory '/var/www/html/hello'

template '/var/www/html/hello/index.html' do
  source 'index.html.erb'
end
