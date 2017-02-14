nginx-pkg:
  pkg.installed:
    - name: nginx
{% if grains['os'] == 'RedHat' %}
nginx_conf_file:
  file.managed:
    - name: /etc/nginx/nginx.conf
    - source: salt://nginx/files/nginx.conf
{% endif %}

{% if grains['os'] == 'RedHat' %}
nginx-systemctl_reload:
  cmd.run:
    - name: /bin/systemctl daemon-reload; /bin/systemctl enable nginx
{%- endif %}

nginx-start_service:
  cmd.run:
    - name: 'service nginx stop || echo already stopped; service nginx start'
