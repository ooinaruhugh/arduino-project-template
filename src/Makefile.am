SUFFIXES = .ino

AM_CFLAGS= \
    -c -g -Os \
    -ffunction-sections \
    -fdata-sections \
    -MMD \
    -flto \
    -fno-fat-lto-objects

AM_CXXFLAGS= \
    -c -g -Os \
    -fpermissive \
    -fno-exceptions \
    -ffunction-sections \
    -fdata-sections \
    -fno-threadsafe-statics \
    -Wno-error=narrowing \
    -MMD \
    -flto

# AM_CFLAGS += @AM_CFLAGS@
# AM_CXXFLAGS += @AM_CXXFLAGS@
AM_CPPFLAGS += @AM_CPPFLAGS@
AM_LDFLAGS = @AM_LDFLAGS@

bin_PROGRAMS = sketch.elf sketch.eep sketch.hex

SRCS = # insert source file here
OBJS = $(addsuffix .o,$(basename $(SRCS)))
sketch_elf_sources = $(SRCS)

%.o: %.ino
	$(CXX) $(AM_CPPFLAGS) $(CPPFLAGS) $(AM_CXXFLAGS) $(CXXFLAGS) -x c++ -c $< -o $@

sketch.elf: $(OBJS)
	$(CC) -Os -g -flto -fuse-linker-plugin -Wl,--gc-sections -mmcu=@MCU@ $(LDFLAGS) -o $@ $< -lm -lcore-@LIB_CORE@

sketch.eep: sketch.elf
	$(OBJCOPY) \
		-O ihex \
		-j .eeprom \
		--set-section-flags=.eeprom=alloc,load \
		--no-change-warnings \
		--change-section-lma \
		.eeprom=0 \
		$< $@

sketch.hex: sketch.elf
	$(OBJCOPY) -O ihex -R .eeprom $< $@

.PHONY: upload
upload: sketch.hex
	$(AVRDUDE) -v -p @MCU@ -P @USB_DEVICE@ -b@BAUD@ -D -Uflash:w:$<:i