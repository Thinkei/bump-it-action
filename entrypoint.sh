#!/usr/bin/env bash
set -e

usage_docs() {
  echo ""
  echo "You can use this Github Action with:"
  echo "- uses: thinkei/bump-it-action"
  echo "  with:"
  echo "    range: 4fc03f745e6fd62ef20aca26213173e2d6f6daaf"
  echo "    project_path: thinkei/bump-it-test"
  echo "    auth_token: \${{ secrets.AUTH_TOKEN }}"
  echo "    dry_run: true"
}
API_URL="https://bump-it.staging.ehrocks.com"

validate_args() {
  range=4fc03f745e6fd62ef20aca26213173e2d6f6daaf
  if [ "${INPUT_RANGE}" ]
  then
    range=${INPUT_RANGE}
  fi

  project_path=thinkei/bump-it-test
  if [ -n "${INPUT_PROJECT_PATH}" ]
  then
    project_path=${INPUT_PROJECT_PATH}
  fi

  auth_token=secret123
  if [ -n "${INPUT_AUTH_TOKEN}" ]
  then
    auth_token=${INPUT_AUTH_TOKEN}
  fi

  dry_run=true
  if [ -n "${INPUT_DRY_RUN}" ]
  then
    dry_run=${INPUT_DRY_RUN}
  fi

  if [ -z "${INPUT_RANGE}" ]
  then
    echo "Error: range is a required argument."
    usage_docs
    exit 1
  fi

  if [ -z "${INPUT_PROJECT_PATH}" ]
  then
    echo "Error: project_path is a required argument."
    usage_docs
    exit 1
  fi

  if [ -z "${INPUT_AUTH_TOKEN}" ]
  then
    echo "Error: auth_token token is required."
    usage_docs
    exit 1
  fi
}


api() {
  path=$1; api_body=$2;
  echo $api_body
  echo -e "= * = * = * =\n"
  if response=$(curl -sSL -XPOST \
      "${API_URL}/${path}" \
      -H "auth-token: ${auth_token}" \
      -H 'Content-Type: application/json' \
      -d "${api_body}")
  then
    echo "$response"
  else
    echo >&2 "api failed:"
    echo >&2 "body: $api_body"
    echo >&2 "path: $path"
    echo >&2 "response: $response"
    exit 1
  fi
}

_trigger_preview_changelog() {
  body=$(printf '{"type":"github","project_path":"%s","range":"%s"}' ${project_path} ${range})
  api "changelog" $body
}

_trigger_release() {
  body=$(printf '{"type":"github","project_path":"%s","range":"%s"}' ${project_path} ${range})
  api "release" $body
}

main() {
  validate_args

  if [ "${dry_run}" = true ]
  then
    _trigger_preview_changelog
  else
    _trigger_release
  fi

}

main
