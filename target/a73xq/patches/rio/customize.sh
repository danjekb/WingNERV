if [ "$TARGET_HAS_RIO" = "true" ]; then
    LOG_STEP_IN "- Removing kernel modules in Vendor"
    DELETE_FROM_WORK_DIR "vendor" "lib/modules"
    if [ "$TARGET_HAS_ROOT" = "true" ]; then
        LOG_STEP_IN "- Replacing Kernel with KernelSU Rio"
        rm -rf $WORK_DIR/kernel/*
        cp -rf $SRC_DIR/prebuilts/kernels/rio/a73xq/ksu/* "$WORK_DIR/kernel/"
        LOG_STEP_OUT
    else
        LOG_STEP_IN "- Replacing Kernel with Rio"
        rm -rf $WORK_DIR/kernel/*
        cp -rf $SRC_DIR/prebuilts/kernels/rio/a73xq/vanilla/* "$WORK_DIR/kernel/"
        LOG_STEP_OUT
    fi
    LOG_STEP_OUT
fi
