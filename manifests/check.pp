#
# This define is a facility that used as entry point for tests defined in Hiera.
# See main class for reference.

# Params:
#
# type: type of check to perform. It supports the eight check types
# supported by monit: directory, fifo, file, filesystem, host, process,
# program, and system.
# Additionally we provide `service` wrapper check. This wrapper compounds a
# set of primitive checks to fully monitor a service.
#
# config: hash of parameters for `monit::check::${type}`. Empty parameters
# will be given the default values.
#
# group: monit group.
#
# alerts: array of monit alerts.
#
# tests: hash of monit tests.
#
# priority: used as a prefix for the filename generated. Load order doesn't
# matter to monit. This is just a facility to organize your checks by filename.
#
# bundle: used to group checks by filename. All checks in the same bundle will
# be added to the same filename.
#
# order: order of the check within the bundle filename.

define monit::check(
  $ensure   = present,
  $type,
  $config   = {},
  $group    = $name,
  $alerts   = [],
  $tests    = [],
  $priority = '',
  $template = "monit/check/${type}.erb",
  $bundle   = $name,
  $order    = 0,
) {
  validate_re(
    $type,
    '^(directory|fifo|file|filesystem|host|process|program|service|system)$',
    "Unknown check type '${type}'."
  )
  validate_hash($config)

  $defaults = {
    'ensure'     => $ensure,
    'check_name' => $name,
    'group'      => $group,
    'alerts'     => $alerts,
    'tests'      => $tests,
    'priority'   => $priority,
    'bundle'     => $bundle,
    'order'      => $order,
  }
  $params = merge($config, $defaults)
  ensure_resource("monit::check::${type}", "${name}_${type}", $params)
}
