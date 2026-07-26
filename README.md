# Battle Cats TW Roll Preview

A small, client-side tool that previews the next three Uber or Legend results
for a known seed in the Taiwan version of *The Battle Cats*.

## What this project demonstrates

- A dependency-free HTML and JavaScript interface.
- A deterministic Ruby data-reduction pipeline.
- Scheduled data refreshes with reproducible output.
- Source attribution and local-only preference storage.

The tool does not discover seeds. Its simplified fixed-track preview is not a
replacement for the full upstream tracker, especially when duplicate-cat rules
or track switching apply.

## Privacy

No seed is committed or prefilled. Values entered in the page stay in the
browser and are stored only in that browser's local storage. Clicking the
upstream link intentionally sends the seed in the destination URL so the full
tracker can open the same position.

## Run locally

Serve the repository root because browsers generally block `fetch()` from a
`file://` page:

```sh
python3 -m http.server 18181
```

Then open <http://127.0.0.1:18181/site/>.

## Data pipeline

`data/bc-tw.yaml` is fetched from the Apache-2.0-licensed
[`godfat/battle-cats-rolls`](https://gitlab.com/godfat/battle-cats-rolls)
project. `scripts/build-lite-data.rb` converts it into the smaller
`data/bc-tw-lite.json` used by the browser.

Run a manual refresh and validation with:

```sh
scripts/update-bc-tw.sh
ruby scripts/validate-data.rb
```

The scheduled GitHub Action runs every six hours but creates a commit only when
the upstream data actually changes.

## Project layout

- `site/index.html` — client-side interface and roll preview.
- `data/bc-tw.yaml` — attributed upstream TW data snapshot.
- `data/bc-tw-lite.json` — deterministic browser data generated from the YAML.
- `scripts/build-lite-data.rb` — data conversion.
- `scripts/validate-data.rb` — integrity and schema checks.
- `scripts/update-bc-tw.sh` — atomic upstream refresh.

## License and disclaimer

This repository is licensed under Apache License 2.0. See [LICENSE](LICENSE) and
[NOTICE](NOTICE) for attribution.

This is an unofficial fan-made utility. *The Battle Cats* and related names are
the property of their respective owners. This project is not affiliated with
or endorsed by PONOS Corporation.
