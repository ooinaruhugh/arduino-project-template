SUFFIXES = .ino

##### This is for you to set

PROJECT_NAME = sketch

# LOCK_BITS=
# EFUSE=
# HFUSE=
# LFUSE=

SRCS = # insert source file here
OBJS = $(addsuffix .o,$(basename $(SRCS)))

##### Here comes all the setup
# Toolchain
CC=avr-gcc
CXX=avr-g++
AS=avr-as
RANLIB=avr-gcc-ranlib
AR=avr-gcc-ar
OBJCOPY=avr-objcopy
AVRDUDE=avrdude

# TARGET?=$(error Please set the TARGET flag)

include scripts/platform.mk
include scripts/programmers.mk
include scripts/set-flags.mk
include scripts/locate_arduino_header.mk

all: $(PROJECT_NAME).hex

$(PROJECT_NAME).elf: override CPPFLAGS+=-DPROJECT_NAME=$(PROJECT_NAME)
$(PROJECT_NAME).elf: $(OBJS) guard-TARGET
	$(CC) $(LDFLAGS) -o $@ $(OBJS) $(LOADLIBES) $(LDLIBS)

%.hex: %.elf
	$(OBJCOPY) -R .eeprom -O ihex $< $@

%.elf: %.o guard-TARGET
	$(CC) $(LDFLAGS) -o $@ $< $(LOADLIBES) $(LDLIBS)

%.o: %.ino guard-TARGET
	$(CXX) $(CPPFLAGS) $(ARDUINO_HEADER) $(CXXFLAGS) -x c++ -c $< -o $@

%.upload: %.hex guard-PORT guard-PROGRAMMER FORCE
	$(AVRDUDE) $(AVRDUDE_FLAGS) -U flash:w:$<

# fuses.upload:
# 	$(AVRDUDE) $(AVRDUDE_FLAGS) -e -Ulock:w:$(LOCK_BITS):m -Uefuse:w:$(EFUSE):m -Uhfuse:w:$(HFUSE):m -Ulfuse:w:$(LFUSE):m

guard-%: FORCE
	@test -n "${$*}" || (echo "Please set the $* flag"; exit 1)

clean: 
	$(RM) $(OBJS)
	
FORCE:
.PHONY: all depend clean #fuses.upload
