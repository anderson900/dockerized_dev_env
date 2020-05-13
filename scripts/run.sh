#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Configure vscode for the current user so that files created within the container have the correct ownership
export USERNAME="devuser"
export USER_UID=$(id -u)

# Launch vscode
code ${DIR}/..

