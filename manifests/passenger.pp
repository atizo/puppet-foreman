class foreman::passenger() {
  Class['foreman::passenger'] <- Class['::passenger']
  Class['foreman::passenger'] <- Class['foreman']

  apache::vhost::generator{"${foreman::params::fqdn}.conf":
    http_port => $foreman::params::http_port,
    http => {
      'ServerName' => $foreman::params::fqdn,
      'DocumentRoot' => "$foreman::params::app_root/public",
      'RailsAutoDetect' => 'On',
      'AddDefaultCharset' => 'UTF-8',
    },
    notify => Service['apache'],
  }

  # passenger ~2.10 will not load the app if a config.ru doesn't exist in the app
  # root. Also, passenger will run as suid to the owner of the config.ru file.
  file {
    "$foreman::params::app_root/config.ru":
      ensure => link,
      owner => $foreman::params::user,
      target => "$foreman::params::app_root/vendor/rails/railties/dispatches/config.ru";
    "$foreman::params::app_root/config/environment.rb":
      owner => $foreman::params::user,
  }

}
