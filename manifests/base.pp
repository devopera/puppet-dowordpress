class dowordpress::base (

  # class arguments
  # ---------------
  # setup defaults

  $user = 'web',
  $group = 'www-data',
  
  # wordpress install details
  $site_name = 'Devopera Wordpress Demo',
  $admin_user = 'admin',
  $admin_email = 'root@localhost',
  $admin_password = 'admLn**',

  # database connection values
  $db_type = 'mysql',
  $db_name = 'dowordpress',
  $db_user = 'dowordpress',
  $db_pass = 'admLn**',
  $db_host = 'localhost',
  $db_port = '3306',
  $db_grants = ['all'],
  
  # install directory
  $target_dir = '/var/www/html',

  # end of class arguments
  # ----------------------
  # begin class

) {

  # name of first directory in downloaded zip
  $target_name = 'wordpress'

  # create <target_dir>/wordpress folder from downloaded tar (then clean up tar)
  exec { 'install-wordpress-source' :
    path    => '/usr/bin:/bin:',
    command => "bash -c \"wget http://wordpress.org/latest.tar.gz -O ${target_dir}/wordpress-latest.tar.gz && cd ${target_dir} && tar xzf ${target_dir}/wordpress-latest.tar.gz > /dev/null 2>&1 && rm ${target_dir}/wordpress-latest.tar.gz\"",
    user => $user,
    group => $group,
    onlyif  => "test ! -d ${target_dir}/${target_name}",
  }->

  # create symlink from our home folder
  file { "/home/${user}/${target_name}":
    ensure => 'link',
    target => "${target_dir}/${target_name}",
  }

  # create a wp-config file
  file { 'setup-wp-config' :
    path => "${target_dir}/${target_name}/wp-config.php",
    content => template('dowordpress/wp-config.php.erb'),
    owner => $user,
    group => $group,
  }

  # use installapp macros to install repo, hosts and vhosts
  dorepos::installapp { 'appconfig-wordpress' :
    user => $user,
    group => $group,
    repo_source => 'git://github.com/devopera/appconfig-wordpress.git',
    byrepo_filewriteable => { },
    require => [File['/var/www/git/github.com'], Exec['install-wordpress-source']],
  }->

  # create a database
  # but protect against bug http://bugs.mysql.com/bug.php?id=28331
  domysqldb::command { "dowordpress-create-db-${db_name}" :
    command => "CREATE DATABASE IF NOT EXISTS `${db_name}`",
  }->
  domysqldb::command { "dowordpress-create-user-${db_name}" :
    command => "GRANT ALL ON ${db_name}.* TO '${db_user}'@'${db_host}' IDENTIFIED BY '${db_pass}';",
  }->
  # mysql::db { "${db_name}":
  #   user     => $db_user,
  #   password => $db_pass,
  #   host     => $db_host,
  #   grant    => $db_grants,
  # }->

  # install wordpress db
  dowordpress::wp { 'install-wordpress-core' :
    command => "core install --url=${target_dir}/${target_name} --title=${site_name} --admin_name=${admin_user} --admin_email=${admin_email} --admin_password=${admin_password}",
    cwd => "${target_dir}/${target_name}",
    user => $user,
    group => $group,
  }

}
