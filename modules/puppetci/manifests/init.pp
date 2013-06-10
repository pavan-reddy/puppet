# == Class: puppetci
#
#  Install Jenkins.  Add a job called PuppetCI to statically test puppet code.
#
# === Parameters
#
# === Variables
#
#
# === Examples
# For now, it needs manual editing, you can do this via the Jenkins GUI.  You'll need to set the Repo's on the Main settings,
# and the URL for the github project in the job configuration.
#
# === Authors
#
# Matthew Barr <mbarr@mbarr.net>
#
# === Copyright
#
# Copyright 2013 Matthew Barr.
#

class puppetci {
  include puppet-lint 

  #For RVM
  package {
    'build-essential':;
    'dkms':;
    'gcc':;
    'linux-headers-generic':;
#    'ncurses-dev':;
    'zlibc':;
    'zlib1g':;
    'zlib1g-dev':;
#     'curl':;
#    'gcc-c++':;
#    'patch':;
#    'readline':;
#    'readline-dev':;
#    'zlib':;
#    'zlib-dev':;
#    'libyaml-dev':;
#    'libffi-dev':;
#    'openssl-dev':;
#    'libxml2-dev':;
#    'libxslt-dev':;
#    'make':;
#    'bzip2':;
#    'autoconf':;
#    'automake':;
#    'libtool':;
#    'bison':;
#    'libcurl-dev':;
  }

  class {'jenkins':
    lts  => 0,
    repo => 1,
  }

  class {'puppetci::plugins':
    require => Package['jenkins'];
  }
  file { '/var/lib/jenkins/org.jenkinsci.plugins.ghprb.GhprbTrigger.xml':
    source  => 'puppet:///modules/puppetci/org.jenkinsci.plugins.ghprb.GhprbTrigger.xml',
    replace => 'no',
    owner   => 'jenkins',
    group   => 'jenkins';

    '/var/lib/jenkins/jobs':
    ensure => directory,
    owner  => 'jenkins',
    group  => 'jenkins';

    '/var/lib/jenkins/jobs/PuppetCI':
    ensure => directory,
    owner  => 'jenkins',
    group  => 'jenkins';

    '/var/lib/jenkins/jobs/PuppetCI/config.xml':
    ensure  => file,
    replace => 'no',
    source  => 'puppet:///modules/puppetci/config.xml',
    owner   => 'jenkins',
    group   => 'jenkins';
  }

  file { '/var/lib/jenkins/hudson.plugins.git.GitSCM.xml':
    source  => 'puppet:///modules/puppetci/hudson.plugins.git.GitSCM.xml',
    replace => 'no',
    owner   => 'jenkins',
    group   => 'jenkins',
  }

  exec { '/usr/bin/wget http://localhost:8080/job/PuppetCI/build -o /dev/null':
    subscribe => Service['jenkins'],
  }

}
