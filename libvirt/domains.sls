{%- for domain in salt['pillar.get']('libvirt:domains', [])|sort %}
libvirt_domain_tpl_{{ domain.name }}:
  file.managed:
    - name: /tmp/libvirt_domain-{{ domain.name }}
    - source: {{ domain.tpl }}
    - template: jinja
    - user: root
    - mode: 0600
    - context:
        data: {{ domain }}
    - unless: virsh dominfo {{ domain.name }}

libvirt_domain_define_{{ domain.name }}:
  cmd.run:
    - name: virsh define /tmp/libvirt_domain-{{ domain.name }}
    - unless: virsh dominfo {{ domain.name }}
    - require:
        - file: libvirt_domain_tpl_{{ domain.name }}

libvirt_domain_start_{{ domain.name }}:
  cmd.run:
    - name: virsh start {{ domain.name }}
    - unless: virsh dominfo {{ domain.name }} | grep -q running
    - onlyif: virsh dominfo {{ domain.name }}

{%- if domain.autostart is defined %}
{%- if domain.autostart %}
libvirt_domain_autostart_{{ domain.name }}:
  cmd.run:
    - name: virsh autostart {{ domain.name }}
    - unless: virsh autostart {{ domain.name }} | grep -qE 'Autostart:.*yes$'
{%- else %}
libvirt_domain_noautostart_{{ domain.name }}:
  cmd.run:
    - name: virsh autostart --disable {{ domain.name }}
    - unless: virsh autostart {{ domain.name }} | grep -qE 'Autostart:.*no$'
{%- endif %}
{%- endif %}
{%- endfor %}
