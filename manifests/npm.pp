class statsd::npm {
  package { $statsd::params::runtimePackage:
    ensure => present;
	}
	package { $statsd::params::packages:
    require => Package[$statsd::params::runtimePackage],
    ensure => present;
	}
}
