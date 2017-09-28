{%- for pool in salt['pillar.get']('libvirt:storage-pool', [])|sort %}
{%- set tname = '/tmp/libvirt_storage_pool-'+pool.get('name') %}
{%- if pool.get('type') == 'dir' %}
libvirt_storage_pool_prepare_{{ pool.name }}:
  file.directory:
    - name: {{ pool.options.get('path') }}
    - user: root
    - group: libvirt
    - dir_mode: 0770
    - file_mode: 0660

libvirt_storage_pool_tpl_{{ pool.name }}:
  file.managed:
    - name: {{ tname }}
    - source: salt://{{ slspath }}/templates/libvirt_storage_pool_dir.xml.jinja 
    - template: jinja
    - user: root
    - mode: 0600
    - context:
      name: {{ pool.name }}
      path: {{ pool.options.get('path') }}
    - unless: virsh pool-info {{ pool.name }}
    - require:
        - file: libvirt_storage_pool_prepare_{{ pool.name }}

libvirt_storage_pool_define_{{ pool.name }}:
  cmd.run:
    - name: virsh pool-define {{ tname }}
    - unless: virsh pool-info {{ pool.name }}
    - require:
        - file: libvirt_storage_pool_tpl_{{ pool.name }}

libvirt_storage_pool_start_{{ pool.name }}:
  cmd.run:
    - name: virsh pool-start {{ pool.name }}
    - unless: virsh pool-info {{ pool.name }} | grep -q running
{%- endif %}
{%- endfor %}
