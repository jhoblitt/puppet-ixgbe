class ixgbe::install {
  # set ethtool options
  file {'/etc/udev/rules.d/71-10g-ethernet.rules':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => 'puppet:///modules/ixgbe/71-10g-ethernet.rules',
    ensure  => present, 
    notify  => Exec['udevadm trigger'],
  }

  # pass parameters in the driver module
  file {'/etc/modprobe.d/ixgbe.conf':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => 'puppet:///modules/ixgbe/ixgbe.conf',
    ensure  => present, 
  #  notify  => Exec['reboot'],
  }

  exec {'udevadm trigger':
    command     => '/sbin/udevadm trigger',
    refreshonly => true,
    path        => ['/sbin'],
  }

  # XXX this is a bit heavy handed... 
  #exec { 'reboot':
  #  refreshonly => true,
  #  path        => ['/sbin'],
  #} 

  sysctl { 'net.core.netdev_max_backlog':
    ensure => present,
    value  => '30000',
  }
  sysctl { 'net.core.netdev_budget':
    ensure => present,
    value => '30000',
  }
}
