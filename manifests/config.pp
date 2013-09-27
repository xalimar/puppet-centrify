
class centrify::config inherits centrify {

  # Error check for no auth servers
  if size($::auth_servers) == 0 {
    fail('you must provide at least one auth server for this to work')
  }

  # Error check for no users or groups allowed in the system
  if size($::users_allow) == 0 {
    if size($::groups_allow) ==0 {
      fail('there are no users or groups to authenticate, this is not recommended')
    }
  }

  # Error check for missing domain name
  if size($::domain_name) == 0 {
    fail('must have a domain name to set up auth servers')
  }
  else {
    if ! is_domain_name($::domain_name){
      fail('domain name does not appear to be valid')
    }
  }

  # Error check if the ssh_port that is given is a integer
  if ! is_integer($::ssh_port) {
    fail('port for ssh does not seem to be a number')
  }

  file {'/etc/centrifydc/ssh/sshd_config':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('centrify/ssh_config.erb'),
    notify  => Class['centrify::service'],
  }

  file {'/etc/centrifydc/centrifydc.conf':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('centrify/centrifydc.conf.erb'),
    notify  => Class['centrify::service'],
  }

  file {'/etc/centrifydc/groups.allow':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('centrify/group_allow.erb'),
    notify  => Class['centrify::service'],
  }

  file {'/etc/centrifydc/users.allow':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('centrify/users_allow.erb'),
    notify  => Class['centrify::service']
  }

}