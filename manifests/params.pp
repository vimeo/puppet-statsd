class statsd::params {
  case $::operatingsystem {
    /Ubuntu|Debian/: {
	    $runtime_package='nodejs'
      $packages=['npm','build-essential']
      $node_path='/usr/local/lib/node_modules'
    }
    CentOS: {
	    $runtime_package='nodejs-stable-release'
      $packages=['nodejs-compat-symlinks', 'npm']
      $node_path='/usr/lib/nodejs/'
    }
    default: {
      fail("Your operatingsystem, ${operatingsystem} is not supported in the statsd module")
    }
  }
}
