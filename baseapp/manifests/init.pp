# @summary Create the standard application directory layout under /srv.
#
# Creates the shared on-disk layout that other application modules build on
# top of. Intended to be declared (via `include`) from higher-level app
# modules so every app on a node ends up with the same directory structure
# and ownership conventions.
#
# Supported OS families: RedHat, Debian.
#
# @param owner
#   User that owns the created /srv/application-* directories.
# @param group
#   Group that owns the created /srv/application-* directories.
# @param mode
#   Mode applied to the /srv/application-* directories.
# @param srv_mode
#   Mode applied to /srv itself.
# @param manage_srv
#   Whether to manage /srv itself. Set to false if another module already
#   manages it to avoid duplicate resource declarations.
#
# @example Default usage from another module
#   include baseapp
#
# @example Custom ownership
#   class { 'baseapp':
#     owner => 'myapp',
#     group => 'myapp',
#   }
class baseapp (
  String[1]        $owner      = 'root',
  String[1]        $group      = 'root',
  Stdlib::Filemode $mode       = '0755',
  Stdlib::Filemode $srv_mode   = '0755',
  Boolean          $manage_srv = true,
) {
  $_osfamily = $facts['os']['family']
  if $_osfamily == 'RedHat' {
    $_supported = true
  } else {
    if $_osfamily == 'Debian' {
      $_supported = true
    } else {
      fail("Module baseapp does not support osfamily ${_osfamily}")
    }
  }

  if $manage_srv {
    file { '/srv':
      ensure => directory,
      owner  => 'root',
      group  => 'root',
      mode   => $srv_mode,
    }
  }

  file { '/srv/application-config':
    ensure => directory,
    owner  => $owner,
    group  => $group,
    mode   => $mode,
  }

  file { '/srv/application-data':
    ensure => directory,
    owner  => $owner,
    group  => $group,
    mode   => $mode,
  }

  file { '/srv/application-logs':
    ensure => directory,
    owner  => $owner,
    group  => $group,
    mode   => $mode,
  }

  file { '/srv/scripts':
    ensure => directory,
    owner  => $owner,
    group  => $group,
    mode   => $mode,
  }
}
