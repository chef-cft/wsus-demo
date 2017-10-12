#
# Cookbook:: wsus
# Recipe:: client
#
# Copyright:: 2017, The Authors, All Rights Reserved.

include_recipe 'wsus-client::configure'

wsus_client_update 'WSUS updates' do
  handle_reboot true
end
