class statsd ($graphite_host, $graphite_port = 2003, $port = 8125, $debug = 0, $flush_interval = 60000) {
  include statsd::params
  include statsd::npm
  $node_path=$statsd::params::node_path

  exec { 'npm-statsd':
    command     => '/usr/bin/npm install -g statsd',
    refreshonly => true,
    require     => Class[statsd::npm],
    # you can trigger an update of statsd package by changing /etc/statsd.js, bit of a hack but works
    subscribe   => File['/etc/statsd.js'] 
  }

  file {
    '/etc/init/statsd.conf':
      ensure  => file,
      owner   => root,
      group   => root,
      mode    => '0644',
      content => template('statsd/statsd.init.erb');

    '/etc/statsd.js':
      ensure  => file,
      content => template('statsd/statsd.js.erb');
  }
  exec { 'restart-statsd':
    require    => [Exec['npm-statsd'], File['/etc/init/statsd.conf']],
    subscribe  => [
        File['/etc/init/statsd.conf'],
        File['/etc/statsd.js'],
        Exec['npm-statsd'],
        Class[statsd::npm]
      ],
    command     => '/sbin/stop statsd; /sbin/start statsd',
    refreshonly => true
  }
}
