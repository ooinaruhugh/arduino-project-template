# Toolchain
CC=avr-gcc
CXX=avr-g++
AS=avr-as
RANLIB=avr-gcc-ranlib
AR=avr-gcc-ar
OBJCOPY=avr-objcopy
AVRDUDE=avrdude

TARGET=

include Platform.mk

MCU=$(MCU_$(TARGET))
F_CPU=$(F_CPU_$(TARGET))
BOARD=$(BOARD_$(TARGET))
VARIANT=$(VARIANT_$(TARGET))
ARCH=$(ARCH_$(TARGET))
EXTRA_FLAGS=$(EXTRA_FLAGS_$(TARGET))
TOOLCHAIN_VERSION=0

AVRDUDE_PART=$(AVRDUDE_PART_$(TARGET))
AVRDUDE_PORT= # Hardcode here depending on used programmer
AVRDUDE_PROTOCOL= # Hardcode here depending on used programmer
AVRDUDE_RATE= # Hardcode here depending on used programmer

override CFLAGS := -g -Os -std=c17 \
	-mmcu=$(MCU) -DF_CPU=$(F_CPU) \
	-ffunction-sections \
    -fdata-sections \
    -MMD \
    -flto \
    -fno-fat-lto-objects \
	$(EXTRA_FLAGS) \
	$(CFLAGS)

override CXXFLAGS := -g -Os -std=c++17 \
	-mmcu=$(MCU) -DF_CPU=$(F_CPU) \
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
	-DVARIANT_$(VARIANT) \
	-DARDUINO=$(TOOLCHAIN_VERSION) \
	-DARDUINO_$(BOARD) \
	-DARDUINO_ARCH_$(ARCH)

override LDFLAGS := -Os -g \
	-flto \
	-fuse-linker-plugin \
	-Wl,--gc-sections \
	-mmcu=$(MCU)

SUFFIXES = .ino

SRCS = src/blink.ino # insert source file here
OBJS = $(addsuffix .o,$(basename $(SRCS)))

PROJECT_NAME = sketch

test:
	true $(CPPFLAGS) $(CFLAGS)

$(PROJECT_NAME).elf: $(OBJS)
	$(CC) -Os -g -flto -fuse-linker-plugin -Wl,--gc-sections -mmcu=@MCU@ $(LDFLAGS) -o $@ $< -lm -lcore-@LIB_CORE@

%.hex: %.elf
	$(OBJCOPY) -R .eeprom -O ihex $< $@

%.elf: %.o
	$(CC) $(LDFLAGS) -o $@ $< -lm 

%.o: %.ino
	$(CXX) $(AM_CPPFLAGS) $(CPPFLAGS) $(AM_CXXFLAGS) $(CXXFLAGS) -x c++ -c $< -o $@

%.upload: %.hex
	$(AVRDUDE) -p $(AVRDUDE_PART) -P $(PORT) -c $(AVRDUDE_PROTOCOL) -b $(AVRDUDE_RATE) -U flash:w:$<

clean: 
	$(RM) $(OBJS)
	
.PHONY: depend clean
