# # encoding: utf-8

# Inspec test for recipe wsus::server

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe powershell('Get-WsusServer') do
  its('strip') { should eq 'Name : Windows Server Update Services 3.0 SP2' }
end
