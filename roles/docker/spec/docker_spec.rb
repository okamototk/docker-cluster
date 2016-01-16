describe service('docker') do
  it { should be_enabled }
  it { should be_running }
end

describe port(2375) do
  it { should be_listening }
end

describe command('docker inspect swarm_join') do
  its(:exit_status) { should eq 0 }
end

describe command('iptables -S DOCKER') do
  its(:exit_status) { should eq 0 }
end