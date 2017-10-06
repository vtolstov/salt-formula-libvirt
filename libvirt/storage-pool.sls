{%- for pool in salt['pillar.get']('libvirt:storage-pool', [])|sort %}
{%- if pool.type == 'dir' or pool.type == 'cifs' %}
libvirt_storage_pool_prepare_{{ pool.name }}:
  file.directory:
    - name: {{ pool.options.get('path') }}
    - user: {{ pool.get('user', 'libvirt-qemu') }}
    - group: {{ pool.get('group', 'libvirt-qemu') }}
    - dir_mode: {{ pool.get('mode', '0770') }}
    - unless: grep -q {{ pool.options.path }} /proc/self/mountinfo
{%- endif %}

libvirt_storage_pool_tpl_{{ pool.name }}:
  file.managed:
    - name: /tmp/libvirt_storage_pool-{{ pool.name }}
    - source: salt://{{ slspath }}/templates/libvirt_storage_pool_{{ pool.type }}.xml.jinja 
    - template: jinja
    - user: root
    - mode: 0600
    - context:
        name: {{ pool.name }}
        options: {{ pool.options }}
    - unless: virsh pool-info {{ pool.name }}
    - require:
        - file: libvirt_storage_pool_prepare_{{ pool.name }}

libvirt_storage_pool_define_{{ pool.name }}:
  cmd.run:
    - name: virsh pool-define /tmp/libvirt_storage_pool-{{ pool.name }}
    - unless: virsh pool-info {{ pool.name }}
    - require:
        - file: libvirt_storage_pool_tpl_{{ pool.name }}

libvirt_storage_pool_start_{{ pool.name }}:
  cmd.run:
    - name: virsh pool-start {{ pool.name }}
    - unless: virsh pool-info {{ pool.name }} | grep -q running

libvirt_storage_pool_autostart_{{ pool.name }}:
  cmd.run:
    - name: virsh pool-autostart {{ pool.name }}
    - unless: virsh pool-info {{ pool.name }} | grep -qE 'Autostart:.*yes$'
{%- endfor %}
