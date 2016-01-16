require 'spec_helper'

describe service('etcd') do
  it { should be_enabled }
  it { should be_running }
end

describe port(2379) do
  it { should be_listening }
end  

describe port(2380) do
  it { should be_listening }
end  

describe port(4001) do
  it { should be_listening }
end  
