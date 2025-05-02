# Datadog Agent Container

This repository contains a Docker configuration for running the Datadog agent in a containerized environment. It's designed to collect metrics, logs, and traces from your containerized applications.

## Features

- Container monitoring and metrics collection
- Log collection from syslog
- DogStatsD support for custom metrics
- Trace agent for APM
- Python support for custom integrations

## Prerequisites

- Docker installed on your host machine
- A valid Datadog API key
- Access to the Datadog platform

## Configuration

Before building the container, you need to:

1. Replace the placeholder API key in the Dockerfile:
   ```dockerfile
   ENV DD_API_KEY=your_api_key_here
   ```

2. Optionally modify the Datadog site if you're not using the default:
   ```dockerfile
   ENV DD_SITE=datadoghq.com
   ```

## Building the Container

```bash
docker build -t datadog-agent .
```

## Running the Container

```bash
docker run -d \
  --name datadog-agent \
  -v /var/run/docker.sock:/var/run/docker.sock:ro \
  -v /proc/:/host/proc/:ro \
  -v /sys/fs/cgroup/:/host/sys/fs/cgroup:ro \
  -e DD_API_KEY=your_api_key_here \
  -e DD_SITE=datadoghq.com \
  datadog-agent
```

## Configuration Files

- `datadog.yaml`: Main Datadog agent configuration
- `conf.d/syslog.d/conf.yaml`: Syslog collection configuration

## Ports

- `8125/udp`: DogStatsD for custom metrics
- `8126/tcp`: Trace agent for APM

## Security Considerations

- Never commit your actual API key to the repository
- Use environment variables or secrets management for sensitive data
- The container runs with read-only access to host system files

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request 