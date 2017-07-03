#!/bin/bash

cd /var/lib/postgresql

# Initialize data directory
DATA_DIR=/data/postgres
if [ ! -f "$DATA_DIR"/postgresql.conf ]; then
    mkdir -p "$DATA_DIR"
    chown postgres:postgres "$DATA_DIR"

    sudo -u postgres /usr/lib/postgresql/9.6/bin/initdb -E utf8 --locale en_US.UTF-8 -D "$DATA_DIR"
    sed -i -e"s/^#listen_addresses =.*$/listen_addresses = '*'/" $DATA_DIR/postgresql.conf
    echo  "shared_preload_libraries='pg_stat_statements'">> "$DATA_DIR"/postgresql.conf
    echo "host    all    all    0.0.0.0/0    md5" >> "$DATA_DIR"/pg_hba.conf

    mkdir -p "$DATA_DIR"/pg_log
fi
chown -R postgres:postgres "$DATA_DIR"
chmod -R 700 "$DATA_DIR"

# Initialize first run
if [[ -e /.firstrun ]]; then
    /scripts/first_run.sh
fi

# Start PostgreSQL
echo "Starting PostgreSQL..."
exec chpst sudo -u postgres /usr/lib/postgresql/9.4/bin/postgres -D "$DATA_DIR"
