class pc_puppet::master {

  file { 'autosign':
    ensure  => 'present',
    content => '*.vagrant.vm',
    path    => '/etc/puppetlabs/puppet/autosign.conf',
  }

  $dirs = ["${::settings::confdir}/environments","${::settings::confdir}/environments/production"]

  file { $dirs:
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
  }

  ini_setting { 'basemodulepath':
    ensure  => 'present',
    path    => "${::settings::confdir}/puppet.conf",
    section => 'main',
    setting => 'basemodulepath',
    value   => "${::settings::confdir}/modules:/opt/puppet/share/puppet/modules",
    notify  => Service['pe-httpd'],
  }

  ini_setting { 'environmentpath':
    ensure  => 'present',
    path    => "${::settings::confdir}/puppet.conf",
    section => 'main',
    setting => 'environmentpath',
    value   => "${::settings::confdir}/environments",
    notify  => Service['pe-httpd'],
  }

  service { 'pe-httpd':
    ensure => 'running',
    enable => true,
  }

  file { '/root/.ssh':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0700',
  }

  file { '/root/.ssh/config':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => "Host 192.168.137.11 gitlab.vagrant.vm\n  StrictHostKeyChecking no",
  }

  exec { 'create_ssh_keys':
    path    => [ '/usr/bin' ],
    command => "ssh-keygen -f /root/.ssh/id_rsa -N ''",
    creates => '/root/.ssh/id_rsa',
    require => File['/root/.ssh'],
  }

  ## Firewall rules for PE
  firewall { '100 allow puppet':
    port   => [8140, 61613, 443],
    proto  => 'tcp',
    action => 'accept',
  }
}
