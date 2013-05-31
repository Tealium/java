# Author:: Joshua Timberman (<joshua@opscode.com>)
# Cookbook Name:: java
# Recipe:: set_java_home
#
# Copyright 2013, Opscode, Inc.
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


case node['platform_family']
when "rhel", "fedora"
  node.default['java']['java_home'] = "/usr/lib/jvm/java"
  node.default['java']['openjdk_packages'] = ["java-1.#{node['java']['jdk_version']}.0-openjdk", "java-1.#{node['java']['jdk_version']}.0-openjdk-devel"]
when "freebsd"
  node.default['java']['java_home'] = "/usr/local/openjdk#{node['java']['jdk_version']}"
  node.default['java']['openjdk_packages'] = ["openjdk#{node['java']['jdk_version']}"]
when "arch"
  node.default['java']['java_home'] = "/usr/lib/jvm/java-#{node['java']['jdk_version']}-openjdk"
  node.default['java']['openjdk_packages'] = ["openjdk#{jdk_version}"]
when "windows"
  node.default['java']['install_flavor'] = "windows"
  node.default['java']['windows']['url'] = nil
  node.default['java']['windows']['package_name'] = "Java(TM) SE Development Kit 7 (64-bit)"
when "debian"
  node.default['java']['java_home'] = "/usr/lib/jvm/default-java"
  node.default['java']['openjdk_packages'] = ["openjdk-#{node['java']['jdk_version']}-jdk", "default-jre-headless"]
else
  node.default['java']['java_home'] = "/usr/lib/jvm/default-java"
  node.default['java']['openjdk_packages'] = ["openjdk-#{node['java']['jdk_version']}-jdk"]
end



ruby_block  "set-env-java-home" do
  block do
    ENV["JAVA_HOME"] = node['java']['java_home']
  end
  not_if { ENV["JAVA_HOME"] == node['java']['java_home'] }
end

directory "/etc/profile.d" do
  mode 00755
end

file "/etc/profile.d/jdk.sh" do
  content "export JAVA_HOME=#{node['java']['java_home']}"
  mode 00755
end
