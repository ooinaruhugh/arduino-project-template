### TARGET=uno
MCU_uno=atmega328p
F_CPU_uno=16000000L
BOARD_uno=AVR_UNO
VARIANT_uno=STANDARD
ARCH_uno=AVR
AVRDUDE_PART_uno=$(MCU_uno)
RATE_uno=115200
PROGRAMMER_uno=uno

### TARGET=mega2560
MCU_mega2560=atmega2560
F_CPU_mega2560=16000000L
BOARD_mega2560=AVR_MEGA2560
VARIANT_mega2560=MEGA
ARCH_mega2560=AVR
AVRDUDE_PART_mega2560=$(MCU_mega2560)
RATE_mega2560=115200
PROGRAMMER_mega2560=mega2560

### TARGET=micro
MCU_micro=atmega32u4
F_CPU_micro=16000000L
BOARD_micro=AVR_MICRO
VARIANT_micro=MICRO
ARCH_micro=AVR
AVRDUDE_PART_micro=$(MCU_micro)
EXTRA_FLAGS_micro=-DUSB_VID=0x2341 -DUSB_PID=0x8037 -DUSB_MANUFACTURER=Unknown "-DUSB_PRODUCT=\"Arduino Micro\""

### TARGET=nano
MCU_nano.atmega328=atmega328p
F_CPU_nano.atmega328=16000000L
BOARD_nano.atmega328=AVR_NANO
VARIANT_nano.atmega328=EIGHTANALOGINPUTS
ARCH_nano.atmega328=AVR
AVRDUDE_PART_nano.atmega328=$(MCU_nano.atme)

### TARGET=attiny13a
MCU_attiny13a=attiny13a
F_CPU_attiny13a=9600000UL
AVRDUDE_PART_attiny13a=t13

ARDUINO_BOARDS=uno mega2560 micro nano.atmega328
ifneq ($(filter $(TARGET),$(ARDUINO_BOARDS)),)
	WITH_ARDUINO_CORE=1
endif