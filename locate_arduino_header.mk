ARDUINO_HEADER_LOCATION:=$(shell $(CC) $(CPPFLAGS) $(CFLAGS) -xc /dev/null -E -Wp,-v 2>&1 \
	| sed -n 's,^ ,,p' \
	| xargs -n1 -I{} sh -c "test -f {}/Arduino.h && echo {}/Arduino.h" | head -n 1;)
	
ifneq ($(ARDUINO_HEADER_LOCATION),)
ARDUINO_HEADER=-include $(ARDUINO_HEADER_LOCATION)
else 
$(warning Unable to find "Arduino.h", cannot auto-include into *.ino files)
endif
