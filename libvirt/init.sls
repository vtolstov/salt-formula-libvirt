{% from "libvirt/map.jinja" import libvirt_settings with context %}
include:
  - .install
  - .python
  - .config
  - .service
  - .keys
  - .storage-pool
  - .domains
