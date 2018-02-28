include:
  - .config
  - .install

libvirt.keys:
  virt.keys:
    - name: libvirt
    - require:
      - pkg: libvirt.pkg
