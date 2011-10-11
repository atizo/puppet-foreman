class foreman::params(
  fqdn = $fqdn,

  # Should foreman act as an external node classifier (manage puppet class assignments)
  enc = true,
  
  # Should foreman receive reports from puppet
  reports = true,

  # Should foreman recive facts from puppet
  facts = true,

  # Do you use storeconfig (and run foreman on the same database) ? (note: not required)
  storeconfigs = false,

  # should foreman manage host provisioning as well
  unattended = true,

  # Enable users authentication (default user:admin pw:changeme)
  authentication = false,

  # configure foreman via apache and passenger
  passenger = true,

  # force SSL (note: requires passenger)
  ssl = true,

  # advanced configuration - no need to change anything here by default
  # allow usage of test / RC rpms as well
  use_testing = true,
  railspath = '/usr/share',
  rails_app_root = false,
  user = 'foreman',
  environment = 'production',

  # os specific paths
  puppet_home = '/var/lib/puppet'
) {
  if $ssl {
    $foreman_url = "https://$fqdn"
  } else {
    $foreman_url = "http://$fqdn"
  }
  if $rails_app_root {
    $app_root = $rails_app_root
  } else {
    $app_root = "$railspath/foreman"
  }
  case $operatingsystem {
    redhat,centos,fedora: {
       $puppet_basedir  = "/usr/lib/ruby/site_ruby/1.8/puppet"
       $apache_conf_dir = "/etc/httpd/conf.d"
    }
    default:              {
       $puppet_basedir  = "/usr/lib/ruby/1.8/puppet"
       $apache_conf_dir = "/etc/apache2/conf.d/foreman.conf"
    }
  }
}
