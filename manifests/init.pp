#
# foreman module
#
# Copyright 2010-2011, Ohad Levy
# Ohad Levy ohadlevy(at)gmail(dot)com
# Copyright 2011, Atizo AG
# Simon Josi simon.josi+puppet(at)atizo.com
#
# This program is free software; you can redistribute 
# it and/or modify it under the terms of the GNU 
# General Public License version 3 as published by 
# the Free Software Foundation.
#

class foreman {
  Class['foreman'] <- Class['xinetd']
  Class['foreman'] <- Class['tftpd']

  include foreman::params
  include foreman::repo

  package{'foreman':
    ensure => latest,
    require => Class['foreman::repo'],
    notify => Service['foreman'],
  }
  service{'foreman':
    hasstatus => true,
    enable => $foreman::params::passenger ? {
      true => false,
      false => true,
    },
    ensure => $foreman::params::passenger ? {
      true => stopped,
      false => running,
    },
  }
  user::managed{$foreman::params::user:
    homedir => $foreman::params::app_root,
    managehome => false,
    shell => '/sbin/nologin',
    require => Package['foreman'],
  }
  file{'/etc/foreman/settings.yaml':
    content => template('foreman/settings.yaml.erb'),
    owner => $foreman::params::user,
    notify => Service['foreman'],
    require => User::Managed[$foreman::params::user],
  }

  # cleans up the session entries in the database
  cron{'clear_session_table':
    user => $foreman::params::user,
    environment => "RAILS_ENV=$foreman::params::environment",
    command => "(cd $foreman::params::app_root && $foreman::params::ruby_bin rake db:sessions:clear)",
    hour => '23',
    minute => '15',
    require => User::Managed[$foreman::params::user],
  }

  if $foreman::params::enc {
    include foreman::enc
  }
  if $foreman::params::reports {
    include foreman::reports
  }
  if $foreman::params::passenger {
    include foreman::passenger
  }
}
