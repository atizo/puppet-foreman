class foreman::reports {
  Class['foreman::reports'] <- Class['foreman::params']
  file{"$foreman::params::puppet_basedir/reports/foreman.rb":
    content => template("foreman/foreman-report.rb.erb"),
    owner => puppet, group => puppet, mode => 444;
  }
  cron::crond{
    'expire_old_reports':
      user => $foreman::params::user,
      env => "RAILS_ENV=$foreman::params::environment",
      command => "(cd $foreman::params::app_root && $foreman::params::ruby_bins/rake reports:expire)",
      hour => 7,
      minute  => 30;
    'daily_summary':
      user => $foreman::params::user,
      env => "RAILS_ENV=$foreman::params::environment",
      command => "(cd $foreman::params::app_root && $foreman::params::ruby_bins/rake reports:summarize)",
      hour => 7,
      minute => 31;
  }
}
