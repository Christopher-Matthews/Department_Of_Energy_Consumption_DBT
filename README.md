# Department Of Energy Consumption DBT

This is a dbt project for transforming Department of Energy consumption data in BigQuery.

It includes:
- `staging` models to clean and standardize raw ingestion tables
- `mart` models to provide analytics-ready business tables

## Environments

- `dev` target writes dbt models to `dept_of_energy_test`
- `prod` target writes dbt models to `dept_of_energy`
- Source raw tables remain in `dept_of_energy`

## CI / GitHub Actions

A weekly workflow runs `dbt build --target prod` every Sunday at midnight UTC.

**Required secrets** (Repository → Settings → Secrets and variables → Actions):

| Secret         | Description                                                              |
|----------------|--------------------------------------------------------------------------|
| `GCP_PROJECT_ID` | Your Google Cloud project ID                                           |
| `GCP_SA_KEY`     | Base64-encoded service account JSON (see below)                        |

To create `GCP_SA_KEY`: run `base64 -i .gcp_user_creds.json | tr -d '\n'` (macOS) or `base64 -w 0 .gcp_user_creds.json` (Linux), then paste the output as the secret value.

You can manually trigger the workflow from the Actions tab (Run workflow).

## Common Commands

- Virtual Env:
  `source .venv/bin/activate`
- Local dev run:
  `dbt run --target dev --profiles-dir profiles`
- Local dev tests:
  `dbt test --target dev --profiles-dir profiles`
- Production run:
  `dbt build --target prod --profiles-dir profiles`
