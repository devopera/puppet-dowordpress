define dowordpress::wp (

  # define arguments
  # ---------------
  # setup defaults

  $command = $title,
  $cwd = '/var/www',
  $user = 'web',
  $group = 'www-data',
  $cwd_check = true,
  $creates = '',
  $onlyif = 'true',

  # end of define arguments
  # ----------------------
  # begin define

) {
  if ($cwd_check == true) {
    # check the current working directory exists, or else create it
    file { "wp-${title}-${cwd}" :
      path => $cwd,
      ensure => directory,
      owner => $user,
      group => $group,
      before => Exec["wp-${title}"], 
    }
  }
  # run wp-cli
  exec { "wp-${title}":
    path => '/usr/bin:/bin',
    command => "bash -c 'cd ${cwd}; wp ${command}'",
    user => $user,
    group => $group, 
    creates => $creates,
    onlyif => $onlyif,
  }
}
