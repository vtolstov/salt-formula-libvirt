{% from "libvirt/map.jinja" import libvirt_settings with context %}
{% set os_family = salt['grains.get']('os_family', None) %}

include:
  - .install
  - .service

libvirt_admin.config:
  file.managed:
    - name: {{ libvirt_settings.libvirt_admin_config }}
    - template: jinja
    - source: salt://{{ slspath }}/templates/libvirt_kv.conf.jinja
    - context:
      settings: 'libvirt:libvirt-admin'

libvirt.config:
  file.managed:
    - name: {{ libvirt_settings.libvirt_config }}
    - template: jinja
    - source: salt://{{ slspath }}/templates/libvirt_kv.conf.jinja
    - context:
      settings: 'libvirt:libvirt'

libvirtd.config:
  file.managed:
    - name: {{ libvirt_settings.libvirtd_config }}
    - template: jinja
    - source: salt://{{ slspath }}/templates/libvirt_kv.conf.jinja
    - context:
      settings: 'libvirt:libvirtd'

lxc.config:
  file.managed:
    - name: {{ libvirt_settings.lxc_config }}
    - template: jinja
    - source: salt://{{ slspath }}/templates/libvirt_kv.conf.jinja
    - context:
      settings: 'libvirt:lxc'

qemu.config:
  file.managed:
    - name: {{ libvirt_settings.qemu_config }}
    - template: jinja
    - source: salt://{{ slspath }}/templates/libvirt_kv.conf.jinja
    - context:
      settings: 'libvirt:qemu'

qemu_lockd.config:
  file.managed:
    - name: {{ libvirt_settings.qemu_lockd_config }}
    - template: jinja
    - source: salt://{{ slspath }}/templates/libvirt_kv.conf.jinja
    - context:
      settings: 'libvirt:qemu-lockd'

virtlockd.config:
  file.managed:
    - name: {{ libvirt_settings.virtlockd_config }}
    - template: jinja
    - source: salt://{{ slspath }}/templates/libvirt_kv.conf.jinja
    - context:
      settings: 'libvirt:virtlockd'

virtlogd.config:
  file.managed:
    - name: {{ libvirt_settings.virtlogd_config }}
    - template: jinja
    - source: salt://{{ slspath }}/templates/libvirt_kv.conf.jinja
    - context:
      settings: 'libvirt:virtlogd'

libvirt.daemonconfig:
  file.managed:
    - name: {{ libvirt_settings.daemon_config_path }}/{{ libvirt_settings.libvirt_service }}
    - template: jinja
    - source: salt://{{ slspath }}/templates/{{ os_family }}/daemon_libvirtd.jinja
    - watch_in:
      - service: libvirt.service
