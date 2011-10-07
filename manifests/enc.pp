class foreman::enc {
  file{
    '/etc/puppet/node.rb':
      content => template("foreman/external_node.rb.erb"),
      owner => puppet, group => puppet, mode => 550;
    "$foreman::params::puppet_home/yaml/foreman":
      ensure => directory,
      owner => puppet, group => puppet, mode => 540;
  }
}
