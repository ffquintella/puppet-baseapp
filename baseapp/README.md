# baseapp

## Description

`baseapp` creates the standard application directory layout under `/srv`
so other Puppet modules can rely on a consistent on-disk structure for
their apps.

The module creates and manages ownership/mode on:

- `/srv`
- `/srv/application-config`
- `/srv/application-data`
- `/srv/application-logs`
- `/srv/scripts`

It also pulls in `puppetlabs/stdlib` for you, so consumers don't have to
declare it themselves.

## Supported platforms

- RedHat family: RHEL, CentOS, Rocky, AlmaLinux (7, 8, 9)
- Debian family: Debian (10, 11, 12), Ubuntu (20.04, 22.04, 24.04)

The module fails compilation on any other `os.family`.

## Usage

### Simplest — defaults

Directories owned by `root:root`, mode `0755`:

```puppet
include baseapp
```

### From another module (recommended pattern)

Declare `baseapp` from your app module and `contain` it so the
directories are guaranteed to exist before any of your own resources:

```puppet
class mymodule (
  String $app_user  = 'mymodule',
  String $app_group = 'mymodule',
) {
  class { 'baseapp':
    owner => $app_user,
    group => $app_group,
    mode  => '0750',
  }
  contain baseapp

  file { '/srv/application-config/mymodule.conf':
    ensure  => file,
    owner   => $app_user,
    group   => $app_group,
    mode    => '0640',
    content => epp('mymodule/mymodule.conf.epp'),
    require => Class['baseapp'],
  }
}
```

### When another module already manages `/srv`

```puppet
class { 'baseapp':
  manage_srv => false,
  owner      => 'myapp',
  group      => 'myapp',
}
```

### Hiera

Because every parameter has a default, you can drive `baseapp` entirely
from Hiera. Simply `include baseapp` somewhere in your classification and
set the parameters via data:

`data/common.yaml`:

```yaml
---
baseapp::owner: 'myapp'
baseapp::group: 'myapp'
baseapp::mode: '0750'
baseapp::srv_mode: '0755'
baseapp::manage_srv: true
```

Per-OS overrides via `data/os/%{facts.os.family}.yaml` (assuming a
standard `hiera.yaml` hierarchy):

```yaml
# data/os/RedHat.yaml
---
baseapp::group: 'wheel'
```

```yaml
# data/os/Debian.yaml
---
baseapp::group: 'staff'
```

Per-node overrides:

```yaml
# data/nodes/web01.example.com.yaml
---
baseapp::owner: 'nginx'
baseapp::group: 'nginx'
```

## Parameters

| Parameter    | Type               | Default  | Description                                       |
| ------------ | ------------------ | -------- | ------------------------------------------------- |
| `owner`      | `String[1]`        | `'root'` | Owner of the four `/srv/application-*` dirs.      |
| `group`      | `String[1]`        | `'root'` | Group of the four `/srv/application-*` dirs.      |
| `mode`       | `Stdlib::Filemode` | `'0755'` | Mode of the four `/srv/application-*` dirs.       |
| `srv_mode`   | `Stdlib::Filemode` | `'0755'` | Mode applied to `/srv` itself.                    |
| `manage_srv` | `Boolean`          | `true`   | Set to `false` if another module manages `/srv`.  |

`/srv` itself is always owned by `root:root` when managed by this module.

## Development

Validate and test with `regent` (not `pdk`):

```sh
regent validate
regent test unit
```

License: Apache-2.0
