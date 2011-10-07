class foreman::reports {
  file{"$foreman::params::puppet_basedir/reports/foreman.rb":
    content => template("foreman/foreman-report.rb.erb"),
    owner => puppet, group => puppet, mode => 444;
  }
  cron { 
    'expire_old_reports':
      user => $foreman::params::user,
      environment => "RAILS_ENV=$foreman::params::environment",
      command => "(cd $foreman::params::app_root && rake reports:expire)",
      hour => 7,
      minute  => 30;
    'daily summary':
      user => $foreman::params::user,
      environment => "RAILS_ENV=$foreman::params::environment",
      command => "(cd $foreman::params::app_root && rake reports:summarize)",
      hour => 7,
      minute => 31;
  }
}