# Class: git
#
# This module manages git
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class git {
 

  package { ["git","gitweb"]:
    ensure  => latest,
    notify  => Service["nginx"],
  }

  file { "/etc/nginx/sites-available/git":
    source  => "/etc/puppet/files/nginx.sites.git",
    require => Package["nginx","gitweb","fcgiwrap"],
    notify  => Service["nginx","fcgiwrap"],
  }

  file { "/etc/nginx/sites-enabled/git":
    ensure => link,
    target => "/etc/nginx/sites-available/git",
    notify  => Service["nginx","fcgiwrap"],
  }

  file { "/usr/lib/git":
    ensure => link,
    target => "/var/lib/git",
  }

  file { "/home/git/repositories":
    ensure => directory,
    owner   => git,
    group   => www-data,
  }

  mount { "/home/git/repositories":
      ensure  => mounted,
      atboot  => False,
      device  => "/var/lib/git",
      fstype  => "none",
      options => "noauto,rw,bind",
      require => [ File["/home/git/repositories"], Package["git"] ],
      notify  => Service["nginx","fcgiwrap"],     
    }


}
