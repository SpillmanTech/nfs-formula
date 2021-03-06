{% from "nfs/map.jinja" import nfs with context %}

{#  FreeBSD has everything needed for NFS w/o any
    additional pkgs, so pkgs_server == False #}
{% if nfs.pkgs_server is not none %}
nfs-server-deps:
    pkg.installed:
        - pkgs: {{ nfs.pkgs_server|json }}
{% endif %}          

nfs-exports-configure:
  file.managed:
    - name: {{ nfs.exports_file }}
    - source: {{ nfs.export_template }}
    - template: jinja
    - watch_in:
      - service: nfs-service

{# RedHat-based OSes requires to start rpcbind first
    and in some versions there is a bug that it does not start as a dependency #}
{% if nfs.service_server_dependency %}
nfs-service-dependency:
  service.running:
    - name: {{ nfs.service_server_dependency }}
    - enable: True
{% endif %}

nfs-service:
  service.running:
{% if nfs.service_name is string %}  
    - name: {{ nfs.service_name }}
{% elif nfs.service_name is iterable %}      
    - names: {{ nfs.service_name }}
{% endif %}      
    - enable: True

{% if grains.get('os') == 'FreeBSD' %}
  {% set mountd_flags = salt['pillar.get'](
        'nfs:server:mountd_flags', None) -%}
  {% if mountd_flags %}
mountd_flags:
  sysrc.managed:
    - value: {{ mountd_flags }}
  {% endif %}
{% endif %}
