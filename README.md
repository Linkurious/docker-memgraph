# Dockerized repository for Memgraph

**Note**: This in just a Proof of Concept, it is not suited for production usage.
This repository provides a docker-compose stack and helm chart for running memgraph.

## Docker-compose stack

### Configuration

- Configure variables in .env. See .env.example for template.
Reasonable defaults are provided.

### Usage

- Run with docker-compose

    ```bash
    docker-compose up -d
    ```

## Helm chart

This chart is still work in progress and not yet published.

With Helm:

```bash
  helm update --install memgraph charts/memgraph
```

### Tilt

We provide a `Tiltfile`, for devlopping or testing the chart you can simply:

```bash
  tilt up
```

