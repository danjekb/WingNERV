TARGET_FIRMWARE_PATH="$(cut -d "/" -f 1 -s <<< "$TARGET_FIRMWARE")_$(cut -d "/" -f 2 -s <<< "$TARGET_FIRMWARE")"

ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/priv-app/SamSungCamera" 0 0 755 "u:object_r:system_file:s0"
for f in $(find $FW_DIR/$TARGET_FIRMWARE_PATH/system/system/lib64 -printf "%P\\n" | grep -E 'lib(jni)*[Bb][Ss][Tt]'); do
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/lib64/$f" 0 0 644 "u:object_r:system_lib_file:s0"
done

unset TARGET_FIRMWARE_PATH
