FROM python:3.11-slim

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    libmagic1 \
    imagemagick \
    libldap2-dev \
    libsasl2-dev \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy requirements first for better caching
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the application
COPY . .

# Make start script executable
RUN chmod +x railway-start.sh

# Create directories for persistent data
RUN mkdir -p /data /library

# Copy the sample metadata.db to library if needed
RUN cp /app/library/metadata.db /library/metadata.db 2>/dev/null || true

# Set environment variables
ENV CALIBRE_DBPATH=/data
ENV CALIBRE_PORT=8083
ENV CALIBRE_RECONNECT=1
ENV PYTHONUNBUFFERED=1

# Expose the port (Railway will use its own PORT env variable)
EXPOSE 8083

# Start the application using the Railway start script
CMD ["bash", "railway-start.sh"]
