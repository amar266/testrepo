# Class: rjil::jiocloud::consul
#
class rjil::jiocloud::consul($config_hash) {
  include dnsmasq

  dnsmasq::conf { 'consul':
    ensure  => present,
    content => 'server=/consul/127.0.0.1#8600',
  }
  
  dnsmasq::conf { 'google':
    ensure  => present,
    content => 'server=8.8.4.4',
  }

  class { '::consul':
    install_method => 'package',
    ui_package_name => 'consul-web-ui',
    ui_package_ensure => 'absent',
    bin_dir => '/usr/bin',
    config_hash => $config_hash,
  }
  exec { "reload-consul":
    command     => "/usr/bin/consul reload",
    refreshonly => true,
    subscribe   => Service['consul'],
  }

}
