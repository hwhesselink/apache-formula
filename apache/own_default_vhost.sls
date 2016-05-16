{% if grains['os_family']=="Debian" %}

{% from "apache/map.jinja" import apache with context %}

{%- set def000 = '000-default.conf' %}

include:
  - apache

apache_own-default-vhost:
  file.managed:
   - name: {{ apache.vhostdir }}/{{ def000 }}
   - source: salt://apache/files/{{ salt['grains.get']('os_family') }}/sites-available/{{ def000 }}
    - require:
      - pkg: apache
    - watch_in:
      - module: apache-reload

a2ensite {{ def000 }}:
 cmd.run:
   - unless: test -f /etc/apache2/sites-enabled/{{ def000 }}
   - order: 230
   - require:
     - pkg: apache
   - watch:
     - file: {{ apache.vhostdir }}/{{ def000 }}

{% endif %}
