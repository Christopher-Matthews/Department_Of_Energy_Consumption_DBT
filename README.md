# Department Of Energy Consumption DBT

This is a dbt project for transforming Department of Energy consumption data in BigQuery.

It includes:
- `staging` models to clean and standardize raw ingestion tables
- `mart` models to provide analytics-ready business tables

## Environments

- `dev` target writes dbt models to `dept_of_energy_test`
- `prod` target writes dbt models to `dept_of_energy`
- Source raw tables remain in `dept_of_energy`

## Common Commands

- Local dev run:
  `dbt run --target dev --profiles-dir profiles`
- Local dev tests:
  `dbt test --target dev --profiles-dir profiles`
- Production run:
  `dbt build --target prod --profiles-dir profiles`
