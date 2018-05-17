PROJECT=keeb
TARGET=$(PROJECT).bin
EXECUTABLE=$(PROJECT).elf

BINPATH=/bin
CC=$(BINPATH)/arm-none-eabi-gcc
CP=$(BINPATH)/arm-none-eabi-objcopy
OD=$(BINPATH)/arm-none-eabi-objdump
LD=$(BINPATH)/arm-none-eabi-ld
AR=$(BINPATH)/arm-none-eabi-ar
AS=$(BINPATH)/arm-none-eabi-as

DEFS = -DUSE_STDPERIPH_DRIVER -DSTM32F429_439xx -DHSE_VALUE=8000000 -DUSE_STM3220F_EVAL
MCU = cortex-m4
MCFLAGS = -mcpu=$(MCU) -mthumb -mlittle-endian -mfpu=fpv4-sp-d16 -mfloat-abi=hard --specs=nosys.specs

STMUTIL = ../Utilities
STMLIBS = ../Libraries
STM32_INCLUDES = -I./ \
				 -I$(STMUTIL)/Common \
				 -I$(STMUTIL)/STM32F429I-Discovery \
				 -I$(STMUTIL)/Third_Party/fat_fs/inc \
				 -I$(STMLIBS)/STM32_USB_OTG_Driver/inc \
				 -I$(STMLIBS)/STM32_USB_HOST_Library/Core/inc \
				 -I$(STMLIBS)/STM32_USB_HOST_Library/Class/MSC/inc \
				 -I$(STMLIBS)/STM32_USB_HOST_Library/Class/HID/inc \
				 -I$(STMLIBS)/STM32F4xx_StdPeriph_Driver/inc \
				 -I$(STMLIBS)/CMSIS/Device/ST/STM32F4xx/Include \
				 -I$(STMLIBS)/CMSIS/Include/

OPTIMIZE = -Os

# Debug flags
DEBUG  += -g -fno-schedule-insns -fno-schedule-insns2

# Backtrace support
DEBUG  += -fno-omit-frame-pointer -funwind-tables
DEBUG  += -mapcs -mno-sched-prolog

CFLAGS = $(MCFLAGS) $(OPTIMIZE) $(DEBUG) $(DEFS) -I./ $(STM32_INCLUDES) -Wl,--allow-multiple-definition,-T,./STM32F429ZI_FLASH.ld
AFLAGS = $(MCFLAGS)

SRC = main.c \
	  system_stm32f4xx.c \
	  stm32fxxx_it.c \
	  usb_bsp.c \
	  usbh_usr_lcd.c \
	  usbh_usr_app_lcd.c \
	  fattime.c \
	  syscalls.c \
	  $(STMLIBS)/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_gpio.c \
	  $(STMLIBS)/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_rcc.c \
	  $(STMLIBS)/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_exti.c \
	  $(STMLIBS)/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_i2c.c \
	  $(STMLIBS)/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_dma.c \
	  $(STMLIBS)/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_dma2d.c \
	  $(STMLIBS)/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_spi.c \
	  $(STMLIBS)/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_ltdc.c \
	  $(STMLIBS)/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_fmc.c \
	  $(STMLIBS)/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_syscfg.c \
	  $(STMLIBS)/STM32F4xx_StdPeriph_Driver/src/misc.c \
	  $(STMLIBS)/STM32_USB_OTG_Driver/src/usb_core.c \
	  $(STMLIBS)/STM32_USB_OTG_Driver/src/usb_hcd.c \
	  $(STMLIBS)/STM32_USB_OTG_Driver/src/usb_hcd_int.c \
	  $(STMLIBS)/STM32_USB_HOST_Library/Core/src/* \
	  $(STMLIBS)/STM32_USB_HOST_Library/Class/HID/src/*.c \
	  $(STMLIBS)/STM32_USB_HOST_Library/Class/MSC/src/*.c \
	  $(STMUTIL)/STM32F429I-Discovery/stm32f429i_discovery.c \
	  $(STMUTIL)/STM32F429I-Discovery/stm32f429i_discovery_lcd.c \
	  $(STMUTIL)/STM32F429I-Discovery/stm32f429i_discovery_sdram.c \
	  $(STMUTIL)/Third_Party/fat_fs/src/ff.c \
	  $(STMUTIL)/Common/fonts.c \
	  $(STMUTIL)/Common/lcd_log.c

STARTUP = $(STMLIBS)/CMSIS/Device/ST/STM32F4xx/Source/Templates/TrueSTUDIO/startup_stm32f429_439xx.s
#STARTUP = startup_stm32f429_439xx.s

OBJDIR = .
OBJ = $(SRC:%.c=$(OBJDIR)/%.o)
OBJ += Startup.o

.PHONY: all program clean

all: $(TARGET)

$(TARGET): $(EXECUTABLE)
	@echo " OBJCOPY $@"
	$(CP) -O binary $^ $@

$(EXECUTABLE): $(SRC) $(STARTUP)
	@echo " CC $@"
	$(CC) $(CFLAGS) $^ -o $@

test:
	openocd -f interface/stlink-v2-1.cfg \
		-f target/stm32f4x.cfg \
		-c "init" \
		-c "reset init" \
		-c "halt" \
		-c "flash write_image erase $(PROJECT).elf" \
		-c "verify_image $(PROJECT).elf" \
		-c "reset run" -c shutdown

flash:
	st-flash write $(TARGET) 0x8000000

clean:
	rm -f Startup.lst $(TARGET) $(TARGET).lst $(OBJ) $(AUTOGEN) $(TARGET).out $(TARGET).hex $(TARGET).map \
		$(TARGET).dmp $(TARGET).elf
