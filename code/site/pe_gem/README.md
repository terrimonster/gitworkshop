# puppetlabs pe_gem module

This module provides management of Ruby gems for Puppet Enterprise.

    package { 'json':
      ensure => present,
      provider => pe_gem,
    }

This uses puppet gem as a parent and simply alters the gem path to /opt/puppet/bin/gem.
