# Project Guidelines

## Overview

Docker + Helm deployment package for [Memgraph](https://memgraph.com) graph database. **Proof of Concept** — not production-ready (no persistent storage, known chart bugs). See [README.md](../README.md) for usage.

## Architecture

- **Docker Compose**: local dev stack (`docker-compose.yml` + override/preprod variants)
- **Helm chart** (`charts/memgraph/`): Kubernetes deployment via StatefulSet with dual containers (Memgraph + Lab/Platform sidecar)
- **Prometheus monitoring**: built-in exporter (`mg-exporter.yaml`) + ServiceMonitor
- **Ingress**: Traefik IngressRoute with forward-auth middleware
- **Network policies**: restrictive by default (same-namespace + exporter only)
- **CI/CD**: Jenkins pipelines using `linkurious-shared` library

### Key Files

| File | Purpose |
|------|---------|
| `charts/memgraph/values.yaml` | All configurable settings — check here first |
| `charts/memgraph/templates/statefulset.yaml` | Main workload (Memgraph + optional Lab sidecar + init containers) |
| `charts/memgraph/templates/_helpers.tpl` | Template helpers (fullname, labels, host URL construction) |
| `values.internal.yaml` | Internal environment overrides (SSO, datasets, netpol) |
| `Tiltfile` | Dev workflow — requires `*-k8s-dev` context and `*-dev` namespace |

## Build and Test

```bash
# Local dev (Docker Compose)
docker-compose up -d                # Ports: 7687 (Bolt), 3000 (UI), 7444 (TLS)

# Helm install
helm upgrade --install memgraph charts/memgraph [--values=values.internal.yaml]

# Dev iteration with Tilt
tilt up                             # Must be in k8s-dev context + dev namespace

# Template dry-run
helm template memgraph charts/memgraph
```

## Conventions

- **Naming**: all resources use `{Release.Name}-memgraph` via Helm fullname helper (63-char DNS limit)
- **Labels**: standard `app.kubernetes.io/*` labels via `_helpers.tpl`
- **Feature gating**: all optional features (Platform UI, init file, Prometheus, autoscaling, netpol, ingress) toggled via `enabled` booleans in `values.yaml`
- **Security defaults**: non-root UID 101, no privilege escalation, read-only root filesystem
- **Config hierarchy**: `values.yaml` → `values.internal.yaml` → Tilt/Helm `--set` flags

## Known Issues

- **HPA targets Deployment instead of StatefulSet** — `hpa.yaml` won't work as-is
- **Test pod references undefined `.Values.service.port`** — should be `.Values.service.boltPort`
- **No PersistentVolumeClaim** — data lives in `emptyDir`, lost on pod restart
- **Memory limit hardcoded** in `memgraphConfig` array (`--memory-limit=1536`), not parameterized
