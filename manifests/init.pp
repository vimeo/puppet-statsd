class statsd ($graphite_host, $graphite_port = 2003, $port = 8125, $debug = 0, $flush_interval = 60000) {
	package { "nodejs-stable-release":
		ensure => present;
	}
	package {
		"nodejs-compat-symlinks":
			require => Package["nodejs-stable-release"],
			ensure => present;
		"npm":
			require => Package["nodejs-stable-release"],
			ensure => present;
	}
	exec { "npm-statsd":
	      command => "/usr/bin/npm install -g statsd",
	      refreshonly => true,
		require => Package["npm"];
	}

        file {
		"/etc/init/statsd.conf":
                	ensure => file,
			owner   => "root",
			group   => "root",
			mode    => "0644",
                	source => "puppet:///modules/statsd/statsd.init.upstart";

		"/etc/statsd.js":
			ensure => file,
			content => template("statsd/statsd.js.erb");
	}
	exec { "restart-statsd":
		require => file["/etc/init/statsd.conf"],
		subscribe  => [
				File['/etc/init/statsd.conf'],
				File['/etc/statsd.js'],
				Exec['npm-statsd'],
				Package['nodejs-compat-symlinks']
			],
		command => "/sbin/stop statsd; /sbin/start statsd";
	}
}
