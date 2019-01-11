{% from "nfs/map.jinja" import nfs with context %}

include:
  - nfs.client

{% for m in salt['pillar.get']('nfs:mount', {}).items() %}
{% set derived_mount_name = m[1].mountpoint|replace("/","",1)|replace("/","-") ~ ".mount" %}
nfs.{{ m[1].mountpoint }}.mount:
  file.managed:
    - name: /etc/systemd/system/{{ m[1].mountname|default(derived_mount_name) }}
    - source: {{ nfs.systemd_mount_template }}
    - template: jinja
    - context:
        m: {{ m[1] }}
  module.run:
    - name: service.systemctl_reload
    - onchanges:
      - file: nfs.{{ m[1].mountpoint }}.mount

nfs.{{ m[1].mountpoint }}.running:
  service.running:
    - name: {{ m[1].mountname|default(derived_mount_name) }}
    - watch:
      - module: nfs.{{ m[1].mountpoint }}.mount
{% endfor %}
