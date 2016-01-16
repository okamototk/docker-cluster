describe port(2376) do
  it { should be_listening }
end

describe command('docker inspect swarm_manage') do
  its(:exit_status) { should eq 0 }
end
