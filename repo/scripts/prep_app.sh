#!/bin/bash

chmod 644 /etc/systemd/system/app.service
chown root:root /etc/systemd/system/app.service
sleep 10
systemctl daemon-reload