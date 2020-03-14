CFLAGS = -mcpu=$(MCU) -mthumb -mthumb-interwork -mfloat-abi=softfp
CFLAGS += $(DEBUG) -O$(OPT)
CFLAGS += -ffunction-sections -fdata-sections 
CFLAGS += -Wall -Wimplicit -Wcast-align -Wpointer-arith -Wswitch -Wredundant-decls -Wreturn-type -Wshadow -Wunused -Wcast-align
CFLAGS += -nostartfiles
CFLAGS += -Wa,-adhlns=$(subst $(suffix $<),.lst,$<)
CFLAGS += $(DEFINES)
CFLAGS += $(addprefix -I ,$(INCLUDE_PATH))

# Aeembler Flags
ASFLAGS = -mcpu=$(MCU) -mthumb -mthumb-interwork -mfloat-abi=softfp 
ASFLAGS += $(DEFINES)
ASFLAGS += $(addprefix -I ,$(INCLUDE_PATH)) -x assembler-with-cpp
ASFLAGS += -Wa,-adhlns=$(subst .s,.lst,$<)

# Linker Flags
LDFLAGS = -nostartfiles -Wl,-Map=$(TARGET).map,--cref,--gc-sections
LDFLAGS += -lgcc -lc
LDFLAGS += --specs=nano.specs --specs=nosys.specs -Wl,--no-wchar-size-warning
LDFLAGS += -T$(LINKER_SCRIPT)