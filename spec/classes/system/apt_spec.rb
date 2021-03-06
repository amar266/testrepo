require 'spec_helper'

describe 'rjil::system::apt' do

  let :facts do
    {
      'lsbdistid'       => 'ubuntu',
      'lsbdistcodename' => 'trusty',
      'osfamily'        => 'Debian',
    }
  end

  it { should contain_class('apt') }

  it 'should contain all repos' do
    should contain_apt__source('puppetlabs').with(
      'location' => 'http://apt.puppetlabs.com',
      'repos'    => 'main',
      'key'      => '4BD6EC30'
    )
  end

  it 'should not configure a proxy' do
    should contain_file('/etc/apt/apt.conf.d/90proxy').with({
      'ensure' => 'absent'
    })
  end

  describe 'with proxy set' do
    let :params do
      {
        'proxy' => 'http://1.2.3.4:5678/'
      }
    end
    it { should contain_file('/etc/apt/apt.conf.d/90proxy').with({ 'content' => 'Acquire::Http::Proxy "http://1.2.3.4:5678/";' }) }
  end

  describe "with enable_puppetlabs set to false" do
    let :params do
      {
        'enable_puppetlabs' => false
      }
    end
    it { should_not contain_apt__source('puppetlabs') }
  end

end
