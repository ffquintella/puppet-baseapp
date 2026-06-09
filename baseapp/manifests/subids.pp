# @summary Own /etc/subuid and /etc/subgid as the single subordinate-ID authority.
#
# Declares the concat targets that hold the subordinate UID/GID ranges rootless
# containers need. App modules register their service user's range with the
# `baseapp::subid` defined type, which adds fragments to these files — so a node
# running several rootless apps (e.g. ferrogate + bastionvault) ends up with one
# consistently-managed `/etc/subuid` and `/etc/subgid` instead of each module
# fighting over them.
#
# This class is included automatically by `baseapp::subid`; declare that defined
# type rather than this class directly.
#
# **It must be the only manager of these files.** If the `puppet/podman` module
# is also on the node, set its `manage_subuid => false` (the default) so it does
# not declare its own `Concat['/etc/subuid']`, which would collide with this one.
#
# @param mode
#   Mode for the generated /etc/subuid and /etc/subgid files.
#
# @api private
class baseapp::subids (
  Stdlib::Filemode $mode = '0644',
) {
  concat { ['/etc/subuid', '/etc/subgid']:
    ensure         => present,
    owner          => 'root',
    group          => 'root',
    mode           => $mode,
    ensure_newline => true,
    warn           => "# FILE MANAGED BY PUPPET (baseapp::subids) - DO NOT EDIT\n",
  }
}
