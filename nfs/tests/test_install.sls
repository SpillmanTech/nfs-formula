{% from "nfs/map.jinja" import nfs with context %}

{% for pkg in nfs.pkgs %}
test_{{pkg}}_is_installed:
  testinfra.package:
    - name: {{ pkg }}
    - is_installed: True
{% endfor %}
