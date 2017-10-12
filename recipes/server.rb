#
# Cookbook:: wsus
# Recipe:: server
#
# Copyright:: 2017, The Authors, All Rights Reserved.

include_recipe 'wsus-server::default'
include_recipe 'wsus-server::freeze'
