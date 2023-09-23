# Toolchain
CC=avr-gcc
CXX=avr-g++
AS=avr-as
RANLIB=avr-gcc-ranlib
AR=avr-gcc-ar
OBJCOPY=avr-objcopy
AVRDUDE=avrdude

TARGET=$(error Please set the TARGET flag)

include platform.mk
include programmer.mk

MCU=$(MCU_$(TARGET))
F_CPU=$(F_CPU_$(TARGET))
BOARD=$(BOARD_$(TARGET))
VARIANT=$(VARIANT_$(TARGET))
ARCH=$(ARCH_$(TARGET))
EXTRA_FLAGS=$(EXTRA_FLAGS_$(TARGET))
TOOLCHAIN_VERSION=0

AVRDUDE_PART=$(AVRDUDE_PART_$(TARGET))
PORT=$(error You need to specify a port for programming)
PROGRAMMER=$(error You need to specify a programmer)
PROTOCOL=$(PROTOCOL_$(PROGRAMMER))
RATE=$(RATE_$(PROGRAMMER))

override CFLAGS := -g -Os -std=c17 \
	-ffunction-sections \
    -fdata-sections \
    -MMD \
    -flto \
    -fno-fat-lto-objects \
	$(EXTRA_FLAGS) \
	$(CFLAGS)

override CXXFLAGS := -g -Os -std=c++17 \
	-fpermissive \
    -fno-exceptions \
    -ffunction-sections \
    -fdata-sections \
    -fno-threadsafe-statics \
    -Wno-error=narrowing \
    -MMD \
    -flto \
	$(EXTRA_FLAGS) \
	$(CXXFLAGS)

override CPPFLAGS := \
	-mmcu=$(MCU) \
	-DF_CPU=$(F_CPU) \
	-Iinclude
	$(CPPFLAGS)

AVRDUDE_FLAGS=-p $(AVRDUDE_PART) -P $(PORT) -c $(PROTOCOL) -b $(RATE)

ifneq ($(VARIANT),)
override CPPFLAGS+=-DVARIANT_$(VARIANT)
endif
ifneq ($(TOOLCHAIN_VERSION),)
override CPPFLAGS+=-DARDUINO=$(TOOLCHAIN_VERSION)
endif
ifneq ($(ARCH),)
override CPPFLAGS+=-DARDUINO_ARCH_$(ARCH)
endif
ifneq ($(BOARD),)
override CPPFLAGS+=-DARDUINO_$(BOARD)
endif

override LDFLAGS := -Os -g \
	-flto \
	-fuse-linker-plugin \
	-Wl,--gc-sections \
	-mmcu=$(MCU)

override LDLIBS := -lm $(LDLIBS)
ifeq ($(WITH_ARDUINO_CORE),1)
override LDLIBS += -lcore-$(TARGET)
endif

SUFFIXES = .ino

PROJECT_NAME = sketch

# LOCK_BITS=
# EFUSE=
# HFUSE=
# LFUSE=

SRCS = src/blink.ino # insert source file here
OBJS = $(addsuffix .o,$(basename $(SRCS)))

$(PROJECT_NAME).elf: $(OBJS)
	$(CC) $(LDFLAGS) -o $@ $< $(LOADLIBES) $(LDLIBS)

%.hex: %.elf
	$(OBJCOPY) -R .eeprom -O ihex $< $@

%.elf: %.o
	$(CC) $(LDFLAGS) -o $@ $< $(LOADLIBES) $(LDLIBS)

%.o: %.ino
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -x c++ -c $< -o $@

%.upload: %.hex FORCE
	$(AVRDUDE) $(AVRDUDE_FLAGS) -U flash:w:$<

# fuses.upload:
# 	$(AVRDUDE) $(AVRDUDE_FLAGS) -e -Ulock:w:$(LOCK_BITS):m -Uefuse:w:$(EFUSE):m -Uhfuse:w:$(HFUSE):m -Ulfuse:w:$(LFUSE):m

clean: 
	$(RM) $(OBJS)
	
FORCE:
.PHONY: depend clean fuses.upload
