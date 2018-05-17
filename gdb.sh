#!/bin/sh

arm-none-eabi-gdb --eval-command="target remote localhost:3333" $1 \
                  --eval-command="monitor arm semihosting enable" \
                  --eval-command="monitor reset halt"
