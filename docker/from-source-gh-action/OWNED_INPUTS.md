## Owned Build Inputs

This file tracks the historical build contract from `12a6746` and the owned
equivalents that the current implementation expects.

| Historical role in `12a6746` | Historical upstream source | Owned source now expected | Current status |
| --- | --- | --- | --- |
| `CORE_ASSETS` tarball consumed by the normal Docker build | Historical Dockerfile at `12a6746` pointed to `core-co-26.04-assets.tar.gz`, but the actually published Linux core assets available around 2026-03-30 to 2026-04-03 were `co-25.04` | `GusRz/azentro-collabora-build-assets` release asset `core-co-25.04-assets.tar.gz` under release tag `for-code-assets` | Required default for a working historical-family build |
| Poco source tarball | `pocoproject.org` `poco-1.12.5p2-all.tar.gz` | `GusRz/azentro-collabora-build-assets` raw file `poco-1.12.5p2-all.tar.gz` | Present |
| `online` repo cloned by `build.sh` | `CollaboraOnline/online.git` branch `main` in the historical Dockerfile | `GusRz/azentro-collabora-online-mirror.git` frozen tag `azentro-online-co-25.04-dada8e8` (snapshot of `azentro/stable`@`40532200fd`; supersedes prior frozen tag `azentro-online-co-25.04-3847fbc`, kept for history) | Present; build consumes the frozen tag |
| Optional `core` source path when `CORE_ASSETS` is unset | `git.libreoffice.org/core` | `GusRz/azentro-collabora-core-mirror.git` branch `distro/collabora/co-25.04` | Present, but not used by the normal build |
| Published runtime image | `ghcr.io/collaboraonline/code-nightly` | `ghcr.io/gusrz/azentro-collabora-online` | Requires `GHCR_USERNAME` and `GHCR_TOKEN` in Actions |

Validate the currently expected owned inputs with:

```bash
bash docker/from-source-gh-action/verify-owned-inputs.sh
```
