class dowordpress (

  # class arguments
  # ---------------
  # setup defaults

  $user = 'web',
  
  # install directory
  $exec_dir = '/home/web/.wp-cli',

  # end of class arguments
  # ----------------------
  # begin class

) {

  # install wp-cli
  exec { 'install-wp-cli' :
    path    => '/usr/bin:/bin:',
    # phar installation has been deprecated
    # command => "bash -c \"wget http://wp-cli.org/packages/phar/wp-cli.phar -O ${exec_dir}/wp && chmod 0755 ${exec_dir}/wp\"",
    # global install problematic 
    # command => "bash -c \"curl http://wp-cli.org/installer.sh > /tmp/wp-cli-installer.sh && WP_CLI_PHP='/usr/local/zend/bin/php-cli' INSTALL_DIR='/usr/share/wp-cli' bash /tmp/wp-cli-installer.sh && ln -s /usr/share/wp-cli/bin/wp ${exec_dir}/wp\"",
    # user    => root,
    # onlyif  => "test ! -f ${exec_dir}/wp",
    command => "bash -c \"source /home/${user}/.bashrc && curl http://wp-cli.org/installer.sh > /tmp/wp-cli-installer.sh && WP_CLI_PHP='/usr/local/zend/bin/php-cli' INSTALL_DIR='${exec_dir}' bash /tmp/wp-cli-installer.sh\"",
    user    => $user,
  }
  # 
}
