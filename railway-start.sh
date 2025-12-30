#!/bin/bash
# Railway start script for calibre-web
# This script maps Railway's PORT environment variable to CALIBRE_PORT

# Use Railway's PORT if set, otherwise default to 8083
export CALIBRE_PORT="${PORT:-8083}"

# Set the database path for persistent storage
export CALIBRE_DBPATH="${CALIBRE_DBPATH:-/data}"

# Enable reconnect endpoint for Docker/Railway
export CALIBRE_RECONNECT=1

# Create necessary directories
mkdir -p "$CALIBRE_DBPATH"
mkdir -p /library

# Copy sample metadata.db if library is empty
if [ ! -f /library/metadata.db ]; then
    cp /app/library/metadata.db /library/metadata.db 2>/dev/null || true
fi

echo "Starting Calibre-Web on port $CALIBRE_PORT..."
exec python cps.py
