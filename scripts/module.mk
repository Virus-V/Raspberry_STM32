# 生成模块
module.a: $(MODULE_OBJS)
	@echo "Packing: $^"
	$(AR) -rv $@ $^

clean:
	@$(REMOVE) $(MODULE_OBJS)
	@$(REMOVE) $(patsubst %.o,%.d,$(MODULE_OBJS))
	@$(REMOVE) $(patsubst %.o,%.lst,$(MODULE_OBJS))
	@$(REMOVE) module.a

%.o:: %.c
	@echo "Compiling: $<"
	$(CC) -c $(CFLAGS) $< -o $@

%.o:: %.s
	@echo "Compiling: $<"
	$(CC) -c $(ASFLAGS) $< -o $@

.PRECIOUS: $(MODULE_OBJS)
.PHONY: clean

-include $(patsubst %.o,%.d,$(MODULE_OBJS))

%.d: %.c
	$(CC) -MM $(DEFINES) $(addprefix -I ,$(INCLUDE_PATH)) $< > $@.$$$$;	\
	sed 's,\($(notdir $*)\)\.o[ :]*,$(dir $*)\1.o $@ : ,g' < $@.$$$$ > $@;	\
	rm -f $@.$$$$