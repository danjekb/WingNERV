#!/usr/bin/env bash
#
# Copyright (C) 2025 Salvo Giangreco
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

source "$SRC_DIR/scripts/utils/firmware_utils.sh" || exit 1
source "$TOOLS_DIR/venv/bin/activate" || exit 1

FORCE=false
SPECIFIC_VERSION=""

FIRMWARES=()
MODEL=""
CSC=""
IMEI=""
SERIAL_NO=""
TARGET_VERSION=""
ZIP_FILE=""

PREPARE_SCRIPT()
{
    local EXTRA_FIRMWARES=()
    local IGNORE_SOURCE=false
    local IGNORE_TARGET=false

    while [ "$#" != 0 ]; do
        if [[ "$1" == "--force" ]] || [[ "$1" == "-f" ]]; then
            FORCE=true
        elif [[ "$1" == "--version" ]] || [[ "$1" == "-v" ]]; then
            SPECIFIC_VERSION="$2"
            shift
        elif [[ "$1" == "--ignore-source" ]]; then
            IGNORE_SOURCE=true
        elif [[ "$1" == "--ignore-target" ]]; then
            IGNORE_TARGET=true
        elif [[ "$1" == "-"* ]]; then
            LOGE "Unknown option: $1"
            PRINT_USAGE
            exit 1
        else
            EXTRA_FIRMWARES+=("$1")
        fi

        shift
    done

    if ! $IGNORE_SOURCE; then
        _CHECK_NON_EMPTY_PARAM "SOURCE_FIRMWARE" "$SOURCE_FIRMWARE" || exit 1
        FIRMWARES+=("$SOURCE_FIRMWARE")
        IFS=':' read -r -a SOURCE_EXTRA_FIRMWARES <<< "$SOURCE_EXTRA_FIRMWARES"
        if [ "${#SOURCE_EXTRA_FIRMWARES[@]}" -ge 1 ]; then
            FIRMWARES+=("${SOURCE_EXTRA_FIRMWARES[@]}")
        fi
    fi

    if ! $IGNORE_TARGET; then
        _CHECK_NON_EMPTY_PARAM "TARGET_FIRMWARE" "$TARGET_FIRMWARE" || exit 1
        FIRMWARES+=("$TARGET_FIRMWARE")
        IFS=':' read -r -a TARGET_EXTRA_FIRMWARES <<< "$TARGET_EXTRA_FIRMWARES"
        if [ "${#TARGET_EXTRA_FIRMWARES[@]}" -ge 1 ]; then
            FIRMWARES+=("${TARGET_EXTRA_FIRMWARES[@]}")
        fi
    fi

    if [ "${#EXTRA_FIRMWARES[@]}" -ge 1 ]; then
        FIRMWARES+=("${EXTRA_FIRMWARES[@]}")
    fi
}

PRINT_USAGE()
{
    echo "Usage: download_fw [options] <firmware>" >&2
    echo " --ignore-source   : Skip parsing source firmware flags" >&2
    echo " --ignore-target   : Skip parsing target firmware flags" >&2
    echo " -f, --force       : Force firmware download" >&2
    echo " -v, --version <v> : Download a specific firmware version" >&2
}

VERIFY_ODIN_PACKAGES()
{
    local FILE_NAME
    local LENGTH
    local STORED_HASH
    local CALCULATED_HASH

    while IFS= read -r f; do
        FILE_NAME="$(basename "$f")"
        LOG_STEP_IN "- Verifying $FILE_NAME..."

        FILE_NAME="${FILE_NAME%.md5}"

        LENGTH="32" 
        LENGTH="$((LENGTH + 2))" 
        LENGTH="$((LENGTH + ${#FILE_NAME}))" 
        LENGTH="$((LENGTH + 1))" 

        STORED_HASH="$(tail -c "$LENGTH" "$f" | cut -d " " -f 1 -s)"
        if [ ! "$STORED_HASH" ] || [[ "${#STORED_HASH}" != "32" ]]; then
            LOG "\033[0;31m! Expected hash could not be parsed\033[0m"
            exit 1
        fi

        CALCULATED_HASH="$(head -c-$LENGTH "$f" | md5sum | cut -d " " -f 1 -s)"

        if [[ "$STORED_HASH" != "$CALCULATED_HASH" ]]; then
            LOG "\033[0;31m! File is damaged\033[0m"
            exit 1
        fi

        LOG_STEP_OUT
    done < <(find "$ODIN_DIR/${MODEL}_${CSC}" -type f -name "*.md5")
}

PREPARE_SCRIPT "$@"

for i in "${FIRMWARES[@]}"; do
    PARSE_FIRMWARE_STRING "$i" || exit 1

    if [ -n "$SPECIFIC_VERSION" ]; then
        TARGET_VERSION="$SPECIFIC_VERSION"
    else
        TARGET_VERSION="$(GET_LATEST_FIRMWARE "$MODEL" "$CSC")"
    fi

    if [ ! "$TARGET_VERSION" ]; then
        LOGE "Target firmware version could not be determined"
        exit 1
    fi

    LOG_STEP_IN "- Processing $MODEL firmware with $CSC CSC"
    LOG "- Downloaded firmware: $(cat "$ODIN_DIR/${MODEL}_${CSC}/.downloaded" 2> /dev/null)"
    LOG "- Extracted firmware: $(cat "$FW_DIR/${MODEL}_${CSC}/.extracted" 2> /dev/null)"
    LOG "- Target firmware version: $TARGET_VERSION"

    LOG_STEP_IN

    if ! $FORCE; then
        if [ -f "$FW_DIR/${MODEL}_${CSC}/.extracted" ]; then
            if COMPARE_SEC_BUILD_VERSION "$(cat "$FW_DIR/${MODEL}_${CSC}/.extracted")" "$TARGET_VERSION"; then
                LOG "\033[0;33m! This firmware has already been extracted, skipping\033[0m"
                LOG_STEP_OUT; LOG_STEP_OUT
                continue
            fi
        fi

        if [ -f "$ODIN_DIR/${MODEL}_${CSC}/.downloaded" ]; then
            if [ "$(cat "$ODIN_DIR/${MODEL}_${CSC}/.downloaded")" == "$TARGET_VERSION" ]; then
                LOG "\033[0;33m! This specific firmware version has already been downloaded\033[0m"
                LOG_STEP_OUT; LOG_STEP_OUT
                continue
            fi
        fi
    fi

    LOG "- Downloading firmware..."
    [ -f "$ODIN_DIR/${MODEL}_${CSC}/.downloaded" ] && rm -rf "$ODIN_DIR/${MODEL}_${CSC}"
    mkdir -p "$ODIN_DIR/${MODEL}_${CSC}"
    
    (
    cd "$OUT_DIR"
    samloader -m "$MODEL" -r "$CSC" -i "$IMEI" -s "$SERIAL_NO" download -v "$TARGET_VERSION" -O "$ODIN_DIR/${MODEL}_${CSC}" 1> /dev/null || exit 1
    )

    ZIP_FILE="$(find "$ODIN_DIR/${MODEL}_${CSC}" -name "*.zip" | sort -r | head -n 1)"
    if [ ! "$ZIP_FILE" ] || [ ! -f "$ZIP_FILE" ]; then
        LOG "\033[0;31m! Download failed\033[0m"
        exit 1
    fi

    LOG "- Extracting $(basename "$ZIP_FILE")..."
    eval "unzip -o \"$ZIP_FILE\" -d \"$ODIN_DIR/${MODEL}_${CSC}\" && rm -rf \"$ZIP_FILE\"" || exit 1

    VERIFY_ODIN_PACKAGES

    echo -n "$TARGET_VERSION" > "$ODIN_DIR/${MODEL}_${CSC}/.downloaded"

    LOG_STEP_OUT; LOG_STEP_OUT
done

deactivate
exit 0
