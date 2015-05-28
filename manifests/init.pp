class dowordpress (

  # class arguments
  # ---------------
  # setup defaults

  $user = 'web',
  
  $exec_dir = $dowordpress::params::exec_dir,
  $exec_name = $dowordpress::params::exec_name,
  $source = $dowordpress::params::source,

  # end of class arguments
  # ----------------------
  # begin class

) inherits dowordpress::params {

  # install wp-cli
  exec { 'install-wp-cli' :
    path    => '/bin:/usr/bin:/sbin:/usr/sbin',
    # global install using phar
    command => "wget -O ${exec_dir}/${exec_name} ${source} && chmod 755 ${exec_dir}/${exec_name}",
    onlyif  => "test ! -f ${exec_dir}/${exec_name}",
  }

}
