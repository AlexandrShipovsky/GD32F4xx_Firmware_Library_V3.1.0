######################################
# target
######################################
TARGET = gd32f427zgt6


######################################
# building variables
######################################
# debug build?
DEBUG = 1
# optimization for size
OPT = -Os


#######################################
# paths
GCC_PATH=~/CLionProjects/betaflight/tools/gcc-arm-none-eabi-10.3-2021.10/bin/

#######################################
# Build path
BUILD_DIR = build

######################################
# source
######################################
# C sources
C_SOURCES =  \
Firmware/GD32F4xx_standard_peripheral/Source/gd32f4xx_adc.c \
Firmware/GD32F4xx_standard_peripheral/Source/gd32f4xx_can.c \
Firmware/GD32F4xx_standard_peripheral/Source/gd32f4xx_crc.c \
Firmware/GD32F4xx_standard_peripheral/Source/gd32f4xx_ctc.c \
Firmware/GD32F4xx_standard_peripheral/Source/gd32f4xx_dac.c \
Firmware/GD32F4xx_standard_peripheral/Source/gd32f4xx_dbg.c \
Firmware/GD32F4xx_standard_peripheral/Source/gd32f4xx_dci.c \
Firmware/GD32F4xx_standard_peripheral/Source/gd32f4xx_dma.c \
Firmware/GD32F4xx_standard_peripheral/Source/gd32f4xx_enet.c \
Firmware/GD32F4xx_standard_peripheral/Source/gd32f4xx_exmc.c \
Firmware/GD32F4xx_standard_peripheral/Source/gd32f4xx_exti.c \
Firmware/GD32F4xx_standard_peripheral/Source/gd32f4xx_fmc.c \
Firmware/GD32F4xx_standard_peripheral/Source/gd32f4xx_fwdgt.c \
Firmware/GD32F4xx_standard_peripheral/Source/gd32f4xx_gpio.c \
Firmware/GD32F4xx_standard_peripheral/Source/gd32f4xx_i2c.c \
Firmware/GD32F4xx_standard_peripheral/Source/gd32f4xx_ipa.c \
Firmware/GD32F4xx_standard_peripheral/Source/gd32f4xx_iref.c \
Firmware/GD32F4xx_standard_peripheral/Source/gd32f4xx_misc.c \
Firmware/GD32F4xx_standard_peripheral/Source/gd32f4xx_pmu.c \
Firmware/GD32F4xx_standard_peripheral/Source/gd32f4xx_rcu.c \
Firmware/GD32F4xx_standard_peripheral/Source/gd32f4xx_rtc.c \
Firmware/GD32F4xx_standard_peripheral/Source/gd32f4xx_sdio.c \
Firmware/GD32F4xx_standard_peripheral/Source/gd32f4xx_spi.c \
Firmware/GD32F4xx_standard_peripheral/Source/gd32f4xx_syscfg.c \
Firmware/GD32F4xx_standard_peripheral/Source/gd32f4xx_timer.c \
Firmware/GD32F4xx_standard_peripheral/Source/gd32f4xx_tli.c \
Firmware/GD32F4xx_standard_peripheral/Source/gd32f4xx_trng.c \
Firmware/GD32F4xx_standard_peripheral/Source/gd32f4xx_usart.c \
Firmware/GD32F4xx_standard_peripheral/Source/gd32f4xx_wwdgt.c \
Firmware/GD32F4xx_usb_library/driver/Source/drv_usb_core.c \
Firmware/GD32F4xx_usb_library/driver/Source/drv_usb_dev.c \
Firmware/GD32F4xx_usb_library/driver/Source/drv_usbd_int.c \
Firmware/GD32F4xx_usb_library/device/class/cdc/Source/cdc_acm_core.c \
Firmware/GD32F4xx_usb_library/device/core/Source/usbd_core.c \
Firmware/GD32F4xx_usb_library/device/core/Source/usbd_enum.c \
Firmware/GD32F4xx_usb_library/device/core/Source/usbd_transc.c \
Examples/USB/USB_Device/cdc_acm/src/system_gd32f4xx.c \
Examples/USB/USB_Device/cdc_acm/src/gd32f4xx_it.c \
Examples/USB/USB_Device/cdc_acm/src/gd32f4xx_hw.c \
Examples/USB/USB_Device/cdc_acm/src/app.c

# ASM sources
ASM_SOURCES = Firmware/CMSIS/GD/GD32F4xx/Source/GCC/startup_gd32f407_427.s


#######################################
# binaries
#######################################
PREFIX = arm-none-eabi-
# The gcc compiler bin path can be either defined in make command via GCC_PATH variable (> make GCC_PATH=xxx)
# either it can be added to the PATH environment variable.
ifdef GCC_PATH
CC = $(GCC_PATH)/$(PREFIX)gcc
AS = $(GCC_PATH)/$(PREFIX)gcc -x assembler-with-cpp
CP = $(GCC_PATH)/$(PREFIX)objcopy
SZ = $(GCC_PATH)/$(PREFIX)size
else
CC = $(PREFIX)gcc
AS = $(PREFIX)gcc -x assembler-with-cpp
CP = $(PREFIX)objcopy
SZ = $(PREFIX)size
endif
HEX = $(CP) -O ihex
BIN = $(CP) -O binary -S
 
##########################
#############
# CFLAGS
#######################################
# cpu
CPU = -mcpu=cortex-m4

# fpu
# NONE for Cortex-M0/M0+/M3

# float-abi


# mcu
MCU = $(CPU) -mthumb $(FPU) $(FLOAT-ABI)

# macros for gcc
# AS defines
AS_DEFS = 

# C defines
C_DEFS =  \
-DUSE_STDPERIPH_DRIVER \
-DGD32F427 \
-DUSE_USB_FS

# AS includes
AS_INCLUDES = \
-IFirmware/CMSIS \
-IFirmware/CMSIS/GD/GD32F4xx/Include  

# C includes
C_INCLUDES =  \
-IFirmware/GD32F4xx_standard_peripheral/Include \
-IFirmware/CMSIS/GD/GD32F4xx/Include \
-IFirmware/CMSIS \
-IFirmware/GD32F4xx_usb_library/driver/Include \
-IFirmware/GD32F4xx_usb_library/ustd/class/cdc \
-IFirmware/GD32F4xx_usb_library/ustd/common \
-IFirmware/GD32F4xx_usb_library/device/class/cdc/Include \
-IFirmware/GD32F4xx_usb_library/device/core/Include \
-IExamples/USB/USB_Device/cdc_acm/inc

# compile gcc flags
ASFLAGS = $(MCU) $(AS_DEFS) $(AS_INCLUDES) $(OPT) -Wall -fdata-sections -ffunction-sections

CFLAGS = $(MCU) $(C_DEFS) $(C_INCLUDES) $(OPT) -Wall -fdata-sections -ffunction-sections

ifeq ($(DEBUG), 1)
CFLAGS += -g -gdwarf-2
endif


# Generate dependency information
CFLAGS += -MMD -MP -MF"$(@:%.o=%.d)"


#######################################
# LDFLAGS
#######################################
# link script
LDSCRIPT = Examples/USB/USB_Device/cdc_acm/GCC/stm32f427zgt6.ld

# libraries
LIBS = -lc -lm -lnosys 
LIBDIR = 
LDFLAGS = $(MCU) -u_printf_float -specs=nosys.specs -T$(LDSCRIPT) $(LIBDIR) $(LIBS) -Wl,-Map=$(BUILD_DIR)/$(TARGET).map,--cref -Wl,--gc-sections

# default action: build all
all: $(BUILD_DIR)/$(TARGET).elf $(BUILD_DIR)/$(TARGET).hex $(BUILD_DIR)/$(TARGET).bin


#######################################
# build the application
#######################################
# list of objects
OBJECTS = $(addprefix $(BUILD_DIR)/,$(notdir $(C_SOURCES:.c=.o)))
vpath %.c $(sort $(dir $(C_SOURCES)))
# list of ASM program objects
OBJECTS += $(addprefix $(BUILD_DIR)/,$(notdir $(ASM_SOURCES:.s=.o)))
vpath %.s $(sort $(dir $(ASM_SOURCES)))

$(BUILD_DIR)/%.o: %.c Makefile | $(BUILD_DIR) 
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/$(notdir $(<:.c=.lst)) $< -o $@

$(BUILD_DIR)/%.o: %.s Makefile | $(BUILD_DIR)
	$(AS) -c $(CFLAGS) $< -o $@

$(BUILD_DIR)/$(TARGET).elf: $(OBJECTS) Makefile
	$(CC) $(OBJECTS) $(LDFLAGS) -o $@
	$(SZ) $@

$(BUILD_DIR)/%.hex: $(BUILD_DIR)/%.elf | $(BUILD_DIR)
	$(HEX) $< $@
	
$(BUILD_DIR)/%.bin: $(BUILD_DIR)/%.elf | $(BUILD_DIR)
	$(BIN) $< $@	
	
$(BUILD_DIR):
	mkdir $@		

#######################################
# program
#######################################
program_openocd:
	openocd -f /usr/share/openocd/scripts/interface/cmsis-dap.cfg -f /usr/share/openocd/scripts/target/stm32f4x.cfg -c "program build/$(TARGET).elf verify reset exit"

program_pyocd:
	pyocd erase -c -t gd32f450zg --config pyocd.yaml
	pyocd load build/$(TARGET).hex -t gd32f450zg --config pyocd.yaml

#######################################
# clean up
#######################################
clean:
	-rm -fR $(BUILD_DIR)

#######################################
# dependencies
#######################################
-include $(wildcard $(BUILD_DIR)/*.d)

# *** EOF ***
