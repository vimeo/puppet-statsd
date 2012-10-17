class statsd::npm {
  package { $statsd::params::runtime_package:
    ensure => present;
	}
	package { $statsd::params::packages:
    require => Package[$statsd::params::runtime_package],
    ensure => present;
	}
}
