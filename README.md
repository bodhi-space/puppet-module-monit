Puppet Monit
============

Performs installation and configuration of Monit service.

Hiera examples
--------------

```yaml
monit::check_interval    : 60
monit::check_start_delay : 120
monit::mailserver        : localhost
monit::eventqueue        : true
monit::alert             :
  - root@localhost
monit::httpserver        : true
monit::httpserver_allow  :
  - admin:secret

monit::checks :
  "%{::hostname}" :
    type          : system
    tests         :
      - type      : 'loadavg(1min)'
        operator  : '>'
        value     : 6
      - type      : 'loadavg(5min)'
        operator  : '>'
        value     : 3
      - type      : 'cpu(user)'
        operator  : '>'
        value     : 80%
      - type      : 'cpu(system)'
        operator  : '>'
        value     : 30%
      - type      : 'cpu(wait)'
        operator  : '>'
        value     : 30%
      - type      : 'memory'
        operator  : '>'
        value     : 75%

  rootfs :
    type     : filesystem
    config   :
      path   : /
    tests    :
      - type: fsflags
      - type: permission
        value: '0755'
      - type: space
        operator: '>'
        value: 80%

  sshd :
    type    : process
    config  :
      pidfile       : "/var/run/sshd.pid"
      start_program : "/etc/init.d/sshd start"
      stop_program  : "/etc/init.d/sshd stop"
    tests  :
      - type     : connection
        host     : 127.0.0.1
        port     : 22
        protocol : ssh
        action   : restart

  ntp:
    type: process
    config:
      pidfile: "/var/run/ntpd.pid"
      start_program: "/etc/init.d/ntpd start"
      stop_program: "/etc/init.d/ntpd stop"
    tests:
      - type        : connection
        host        : 127.0.0.1
        socket_type : udp
        port        : 123
        protocol    : ntp
        action      : restart

  varnish:
    type: process
    config:
      pidfile: "/var/run/varnish.pid"
      start_program : "/etc/init.d/varnish start"
      stop_program  : "/etc/init.d/varnish stop"
    tests:
      - type: connection
        host: 127.0.0.1
        port: 8080
        protocol: http
        protocol_test:
          request: /health.varnish
      - type      : 'cpu(user)'
        operator  : '>'
        value     : 60%
        tolerance :
          cycles  : 2
      - type      : 'children'
        operator  : '>'
        value     : 150
```
