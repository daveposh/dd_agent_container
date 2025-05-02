FROM datadog/agent:latest

# Install necessary packages
RUN apt-get update && apt-get install -y \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Create directory for syslog file
RUN mkdir -p /var/log/syslog

# Copy Datadog configuration
COPY datadog.yaml /etc/datadog-agent/datadog.yaml
COPY conf.d/syslog.d/conf.yaml /etc/datadog-agent/conf.d/syslog.d/conf.yaml

# Set environment variables
ENV DD_API_KEY=your_api_key_here
ENV DD_SITE=datadoghq.com
ENV DD_LOGS_ENABLED=true
ENV DD_LOGS_CONFIG_CONTAINER_COLLECT_ALL=true

# Expose ports for DogStatsD and trace agent
EXPOSE 8125/udp 8126/tcp

# Start the agent
CMD ["agent", "run"] 