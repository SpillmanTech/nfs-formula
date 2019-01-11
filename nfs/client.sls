{% from "nfs/map.jinja" import nfs with context %}

{% if nfs.pkgs_client %}
nfs-client:
    pkg.installed:
        - pkgs: {{ nfs.pkgs_client|json }}
{% endif %}          

{% if nfs.service_client %}
nfs-service-client:
  -  service.running:
    -    - name: {{ nfs.service_client }}
    -    - enable: True
{% endif %}
