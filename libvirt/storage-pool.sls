{%- for name, options in salt['pillar.get']('libvirt:storage-pool', {})|dictsort %}
{%- set tname salt.modules.temp.file(prefix='libvirt_storage_pool-'+name,parent='/tmp/') %}
{%- if options.get('type') == 'dir' %}
libvirt_storage_pool_prepare_{{ name }}:
  file.directory:
    - name: {{ options.get('path') }}
    - user: libvirt
    - group: libvirt
    - dir_mode: 0770
    - file_mode: 0660

libvirt_storage_pool_tpl_{{ name }}:
  file.managed:
    - name: {{ tname }}
    - source: salt://{{ slspath }}/templates/libvirt_storage_pool_dir.xml.jinja 
    - template: jinja
    - owner: root
    - mode: 0600
    - context:
      name: {{ name }}
      path: {{ options.get('path') }}
    - unless: virsh pool-info {{ name }}

libvirt_storage_pool_define_{{ name }}:
  cmd.run:
    - name: virsh pool-define {{ tname }}
    - unless: virsh pool-info {{ name }}

libvirt_storage_pool_start_{{ name }}:
  cmd.run:
    - name: virsh pool-start {{ name }}
    - unless: virsh pool-info {{ name }}  | grep -q running
{%- endif %}
{%- endfor %}
