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

  # install directory
  $exec_dir = $dowordpress::params::exec_dir,
  $exec_name = $dowordpress::params::exec_name,

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
    path => "/usr/bin:/bin:${exec_dir}:/home/${user}/.wp-cli/bin",
    command => "bash -c 'cd ${cwd}; ${exec_name} ${command}'",
    user => $user,
    group => $group, 
    creates => $creates,
    onlyif => $onlyif,
  }
}
