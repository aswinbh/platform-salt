[Unit]
Description=opentsdb

[Service]
Type=simple
ExecStart=/usr/bin/tsdb tsd
Restart=always
RestartSec=2

[Install]
WantedBy=multi-user.target