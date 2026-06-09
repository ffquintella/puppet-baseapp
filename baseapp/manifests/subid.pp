# @summary Register a user's subordinate UID/GID range in /etc/subuid and /etc/subgid.
#
# Adds one `name:start:count` entry to each of `/etc/subuid` and `/etc/subgid`
# (the same range for both, which is what rootless podman expects) as concat
# fragments of the files owned by `baseapp::subids`. Use this from an app module
# instead of calling `usermod --add-subuids` or `puppet/podman`'s
# `podman::subuid`/`podman::subgid` directly, so every rootless app on the node
# contributes to one centrally-managed pair of files.
#
# @param subid
#   First subordinate id allocated to the user (the `start` field). Pick a block
#   that does not overlap any other user's range.
# @param count
#   Size of the subordinate id block (typically 65536).
# @param user
#   The user the range belongs to. Defaults to the resource title.
#
# @example Register the ferrogate service user's range
#   baseapp::subid { 'ferrogate':
#     subid => 655425536,
#     count => 65536,
#   }
define baseapp::subid (
  Integer[0] $subid,
  Integer[1] $count,
  String[1]  $user = $title,
) {
  include baseapp::subids

  $_entry = "${user}:${subid}:${count}"

  concat::fragment { "baseapp-subuid-${user}":
    target  => '/etc/subuid',
    content => $_entry,
    order   => "50-${user}",
  }

  concat::fragment { "baseapp-subgid-${user}":
    target  => '/etc/subgid',
    content => $_entry,
    order   => "50-${user}",
  }
}
