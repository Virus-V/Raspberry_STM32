#
# 《树莓派玩转STM32开发》系列专题
#  求知Coder
#

include $(WORKSPACE)/scripts/variables.mk

# 使用的外设列表
PERIPH_LIST = gpio rcc

MODULE_OBJS = $(foreach var,$(PERIPH_LIST),$(CURDIR)/stm32f10x_$(var).o) $(CURDIR)/misc.o

INCLUDE_PATH += $(CURDIR)
INCLUDE_PATH += $(WORKSPACE)/User # stm32f10x_conf.h
INCLUDE_PATH += $(WORKSPACE)/CMSIS/CM3/CoreSupport $(WORKSPACE)/CMSIS/CM3/DeviceSupport/ST/STM32F10x

include $(WORKSPACE)/scripts/module.mk