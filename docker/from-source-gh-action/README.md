This directory contains the canonical Docker-only build flow for both local builds
and GitHub Actions.

This path is intentionally aligned with the historical `12a6746` contract:
the normal build consumes prebuilt `CORE_ASSETS` and does not rebuild `core`
from source unless you explicitly unset `CORE_ASSETS`.

## Build locally

To build the image locally, run the following command:

```bash
docker build -t code .
```

This is the same Dockerfile and build logic used by the GitHub Actions workflow.

Before building, validate that the owned inputs expected by this flow exist:

```bash
bash verify-owned-inputs.sh
```

The default inputs currently expected by this path are:

- `https://github.com/GusRz/azentro-collabora-build-assets/releases/download/for-code-assets/core-co-25.04-assets.tar.gz`
- `https://github.com/GusRz/azentro-collabora-build-assets/raw/main/poco-1.12.5p2-all.tar.gz`
- `https://github.com/GusRz/azentro-collabora-online-mirror.git` on tag `azentro-online-co-25.04-3847fbc`
- `https://github.com/GusRz/azentro-collabora-core-mirror.git`

If the owned `CORE_ASSETS` tarball does not exist yet, the build fails fast.

To override the owned sources explicitly:

```bash
docker build \
  --build-arg CORE_ASSETS=https://github.com/<org>/<assets-repo>/releases/download/for-code-assets/core-co-25.04-assets.tar.gz \
  --build-arg COLLABORA_ONLINE_REPO=https://github.com/<org>/<online-repo>.git \
  --build-arg COLLABORA_ONLINE_BRANCH=azentro-online-co-25.04-3847fbc \
  --build-arg CORE_REPO=https://github.com/<org>/<core-repo>.git \
  --build-arg POCO_URL=https://github.com/<org>/<assets-repo>/raw/main/poco-1.12.5p2-all.tar.gz \
  -t code .
```
