#
# 《树莓派玩转STM32开发》系列专题
#  求知Coder
#

include $(WORKSPACE)/scripts/variables.mk

SUB_DIRS := $(CURDIR)/CM3/CoreSupport $(CURDIR)/CM3/DeviceSupport/ST/STM32F10x

# 找到需要编译的源文件
CM_SRC_FILES += $(wildcard $(addsuffix /*.c,$(SUB_DIRS)))

INCLUDE_PATH += $(SUB_DIRS)
INCLUDE_PATH += $(WORKSPACE)/User # stm32f10x_conf.h
INCLUDE_PATH += $(WORKSPACE)/STLibrary

MODULE_OBJS = $(patsubst %.c, %.o, $(CM_SRC_FILES)) $(CURDIR)/startup_stm32f10x_md.o

include $(WORKSPACE)/scripts/module.mk
