#!/usr/bin/env bash

# ------------------------------------------------------------------------------
# Reads multiple benchmark reports produced by scripts from test/externalTests/
# and creates a shorter report, containing only totals.
#
# Usage:
#    <script name>.sh <REPORT> ...
#
# REPORT: Path to the original report file.
#
# Example:
#    <script name>.sh reports/externalTests/benchmark-*.json
# ------------------------------------------------------------------------------
# This file is part of solidity.
#
# solidity is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# solidity is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with solidity.  If not, see <http://www.gnu.org/licenses/>
#
# (c) 2021 solidity contributors.
#------------------------------------------------------------------------------

set -euo pipefail

cat "$@" |
    jq --slurp 'add' |
    jq 'with_entries({
            key: .key,
            value: .value | with_entries({
                key: .key,
                value: {
                    bytecode_size: .value.total_bytecode_size,
                    method_gas: .value.gas.total_method_gas,
                    deployment_gas: .value.gas.total_deployment_gas,
                    version: .value.version
                }
            })
        }'
