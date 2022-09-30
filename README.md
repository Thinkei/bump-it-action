# bump-it action
Github Action for trigger a release workflow by following semver version.

**When would you use it?**

When releasing the software

## Arguments

| Argument Name            | Required   | Default     | Description           |
| ---------------------    | ---------- | ----------- | --------------------- |
| `range`                  | True       | 10          | The commit hash which you want to release|
| `project_path`           | True      | "thinkei/bump-it-test"        | Git repository path where you want to use |
| `auth_token`      | True      | `secret123`      | Key authentication |
| `dry_run`       | False      | `true`      | Preview the changelogs and predicted semver version before releasing it. |


## Example

### Simple

```yaml
- uses: thinkei/bump-it-action@v1.0.1
  with:
    project_path: "thinkei/bump-it-test"
    range: ${{ github.sha }}
    auth_token: ${{ secrets.AUTH_TOKEN }}
    dry_run: true
```


## Setup development environment
### prepare environment
```
cat > .env <<EOF
INPUT_RANGE=55dd8e2e48be154a4a0b2cab0cb1ca9afc328a66
INPUT_PROJECT_PATH=thinkei/bump-it-test
INPUT_AUTH_TOKEN=secret123
INPUT_DRY_RUN=true
EOF
```
### bump-it development
```sh
docker-compose up
```

## License
Copyright 2022

