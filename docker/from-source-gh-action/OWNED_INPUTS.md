## Owned Build Inputs

This file tracks the historical build contract from `12a6746` and the owned
equivalents that the current implementation expects.

| Historical role in `12a6746` | Historical upstream source | Owned source now expected | Current status |
| --- | --- | --- | --- |
| `CORE_ASSETS` tarball consumed by the normal Docker build | Historical Dockerfile at `12a6746` pointed to `core-co-26.04-assets.tar.gz`, but the actually published Linux core assets available around 2026-03-30 to 2026-04-03 were `co-25.04` | `GusRz/azentro-collabora-build-assets` release asset `core-co-25.04-assets.tar.gz` under release tag `for-code-assets` | Required default for a working historical-family build |
| Poco source tarball | `pocoproject.org` `poco-1.12.5p2-all.tar.gz` | `GusRz/azentro-collabora-build-assets` raw file `poco-1.12.5p2-all.tar.gz` | Present |
| `online` repo cloned by `build.sh` | `CollaboraOnline/online.git` branch `main` in the historical Dockerfile | `GusRz/azentro-collabora-online-mirror.git` frozen tag `azentro-online-co-25.04-1cb7768` (coolwsd 25.04.10.3, version-compatible with `core-co-25.04-assets.tar.gz`: cherry-pick of 9 fixes — menu/branding (`40532200fd`), mobile/compact UI width detection (`e888d3379f`, `c0badbcf73`), Online Help hide (`bc80b8d098`), two earlier ineffective duplicate-logo attempts (`09583bb2f0`, `a58c647be1`, kept — harmless), the real duplicate-logo fix (`.lo-menu a:hover` background shorthand resetting `background-repeat`/`background-size`, `e698a4e232`), a fixed-box-size fix so the icon's hover padding doesn't inflate 30px→46px and shift the rest of the menu (`6363a76063`), and hiding the mobile `#toolbar-mobile-back` chevron that otherwise tears down the embedded iframe on click (`97c4732340`, cherry-picked onto this lineage as `1cb7768`) — onto `azentro/stable`@`59c4ace625`, the last commit before the branch bumped to coolwsd 26.04. Supersedes invalid intermediate tags `azentro-online-co-25.04-dada8e8` (naive 26.04 HEAD snapshot, failed `COKit.h` check), `azentro-online-co-25.04-445c9d5` (missing mobile-detection fixes), `azentro-online-co-25.04-56429c4` and `azentro-online-co-25.04-abf7f23` (wrong root cause for duplicate logo), `azentro-online-co-25.04-d9da7d1` (missing the padding-jump fix), `azentro-online-co-25.04-a1cb833` (missing the back-chevron hide), and `azentro-online-co-25.04-97c4732` (built by tagging current `azentro/stable` HEAD directly instead of cherry-picking onto the `59c4ace625`-based lineage, so it carried the post-26.04-bump tree and failed the same `COKit.h` check as `dada8e8`); also supersedes `azentro-online-co-25.04-3847fbc`, kept for history) | Present; build consumes the frozen tag |
| Optional `core` source path when `CORE_ASSETS` is unset | `git.libreoffice.org/core` | `GusRz/azentro-collabora-core-mirror.git` branch `distro/collabora/co-25.04` | Present, but not used by the normal build |
| Published runtime image | `ghcr.io/collaboraonline/code-nightly` | `ghcr.io/gusrz/azentro-collabora-online` | Requires `GHCR_USERNAME` and `GHCR_TOKEN` in Actions |

Validate the currently expected owned inputs with:

```bash
bash docker/from-source-gh-action/verify-owned-inputs.sh
```
