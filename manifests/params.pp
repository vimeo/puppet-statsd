class statsd::params {
  case $::operatingsystem {
    /Ubuntu|Debian/ {
	    $runtimePackage='node'
      $packages='npm'
    }
    CentOS: {
	    $runtimePackage='nodejs-stable-release'
      $packages=['nodejs-compat-symlinks', 'npm']
    }
    default: {
      fail("Your operatingsystem, ${operatingsystem} is not supported in the statsd module")
    }
  }

  
}
