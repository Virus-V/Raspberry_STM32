#
# 《树莓派玩转STM32开发》系列专题
#  求知Coder
#

# 构建目标
TARGET = led
WORKSPACE = $(shell pwd)

# 模块列表
MODULE_LIST = User STLibrary CMSIS

MODULE_OBJ = $(foreach var,$(MODULE_LIST),$(var)/module.a)

# 链接器脚本
LINKER_SCRIPT = $(WORKSPACE)/CMSIS/flash.ld

# MCU架构和型号
MCU      = cortex-m3
SUBMDL   = stm32f103

# 仿真器类型
DBG_INTERFACE = stlink
# 调试目标类型
DBG_TARGET = stm32f1x

# toolchain (using code sourcery now)
CROSS_COMPILE = arm-none-eabi

# Define programs and commands.
SHELL = sh
CC = $(CROSS_COMPILE)-gcc
CPP = $(CROSS_COMPILE)-g++
AR = $(CROSS_COMPILE)-ar
OBJCOPY = $(CROSS_COMPILE)-objcopy
OBJDUMP = $(CROSS_COMPILE)-objdump
SIZE = $(CROSS_COMPILE)-size
NM = $(CROSS_COMPILE)-nm
REMOVE = rm -f
REMOVEDIR = rm -r
COPY = cp

# 优化级别 [0,1,2,3,s]
OPT ?= 0
# 调试
DEBUG = -g

#宏定义
DEFINES = -D STM32F10X_MD -D USE_STDPERIPH_DRIVER

# 头文件目录
INCLUDE_PATH = $(WORKSPACE)

export 

include $(WORKSPACE)/scripts/variables.mk

HEXSIZE = $(SIZE) --target=binary $(TARGET).hex
ELFSIZE = $(SIZE) -A $(TARGET).elf

.PHONY: all build_modules download clean

all: build sizeafter end

build: elf bin lss sym 

elf: $(TARGET).elf
bin: $(TARGET).bin
lss: $(TARGET).lss
sym: $(TARGET).sym

sizeafter: build
	@if [ -f $(TARGET).elf ]; then echo "Size after"; $(ELFSIZE); fi

end: sizeafter
	@echo "Make Complete~"
	@echo $(shell date)

# 从elf创建hex文件
%.hex: %.elf
	$(OBJCOPY) -O binary $< $@

# 从elf创建bin文件
%.bin: %.elf
	$(OBJCOPY) -O binary $< $@

# 导出extened list文件
%.lss: %.elf
	$(OBJDUMP) -h -S -D $< > $@

# 从elf导出符号表
%.sym: %.elf
	$(NM) -n $< > $@

.SECONDARY : $(TARGET).elf

# 构建elf
%.elf: $(MODULE_OBJ)
	$(CC) $(CFLAGS) -Wl,--undefine=main $^ $(LDFLAGS) --output $@ 

$(MODULE_OBJ): build_modules

# 构建子模块
build_modules: 
	@echo "Build modules..."
	$(foreach var,$(MODULE_LIST),\
		echo "building $(var) module.."; \
		$(MAKE) -C $(var);	\
	)
	@echo "Modules build finished..."

download:
	@echo "Downloading $(TARGET) ..."
	@openocd -f interface/$(DBG_INTERFACE).cfg -f target/$(DBG_TARGET).cfg -c "program $(TARGET).elf verify reset exit"

clean:
	$(foreach var,$(MODULE_LIST),\
		echo "Clean $(var) module.."; \
		$(MAKE) -C $(var) clean;	\
	)
	@$(REMOVE) $(TARGET).elf $(TARGET).bin $(TARGET).lss $(TARGET).sym $(TARGET).hex
	@$(REMOVE) $(TARGET).map
