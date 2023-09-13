AC_INIT([test],[0.1.0],[kafe@kafe.dev])

# AC_CONFIG_SRCDIR([])
AC_CONFIG_AUX_DIR([build-aux])

AM_INIT_AUTOMAKE([foreign no-exeext])
AM_SILENT_RULES([yes])

cross_compiling=yes
AC_PROG_MAKE_SET
AC_PROG_CC([avr-gcc])
AC_PROG_CXX([avr-g++])

# Checks for programs.

AC_CHECK_TOOL(AS, avr-as, avr-as)
AM_PROG_AS([avr-as])
AC_CHECK_TOOL(RANLIB, avr-ranlib, avr-ranlib)
AC_CHECK_TOOL(AR, avr-ar, avr-ar)
AC_CHECK_TOOL(OBJCOPY, avr-objcopy, avr-objcopy)
AC_CHECK_TOOL(SIZE, avr-size, avr-size)
AC_CHECK_TOOL(AVRDUDE, avrdude, avrdude)

# Make sure that we found the right avr cross-compiler.

case "${CC}" in
   *gcc*)
       case "X`${CC} -dumpmachine`X" in
           XavrX) ;;
           *) AC_MSG_ERROR(Wrong C compiler found; check the PATH!) ;;
       esac
       ;;
   *) AC_MSG_ERROR(Wrong C compiler found; check the PATH!) ;;
esac
case "${CXX}" in
   *g++*)
       case "X`${CXX} -dumpmachine`X" in
           XavrX) ;;
           *) AC_MSG_ERROR(Wrong C++ compiler found; check the PATH!) ;;
       esac
       ;;
   *) AC_MSG_ERROR(Wrong C++ compiler found; check the PATH!) ;;
esac
case "${AS}" in
   *avr*as*) ;;
   *) AC_MSG_ERROR(Wrong assembler found; check the PATH!) ;;
esac
case "${AR}" in
   *avr*ar*) ;;
   *) AC_MSG_ERROR(Wrong archiver found; check the PATH!) ;;
esac
case "${RANLIB}" in
   *avr*ranlib*) ;;
   *) AC_MSG_ERROR(Wrong ranlib found; check the PATH!) ;;
esac
case "${OBJCOPY}" in
   *avr*objcopy*) ;;
   *) AC_MSG_ERROR(Wrong objcopy found; check the PATH!) ;;
esac
case "${SIZE}" in
   *avr*size*) ;;
   *) AC_MSG_ERROR(Wrong size found; check the PATH!) ;;
esac

AX_CXX_COMPILE_STDCXX_11

AC_CONFIG_FILES([Makefile src/Makefile])

AC_ARG_VAR([BOARD], 
   [The board type compiling for.])
AC_ARG_VAR([USB_DEVICE], 
   [Path to the USB device for upload.])

AS_CASE([$BOARD],
    [arduino-uno],
    [
        echo "Configuring for Arduino UNO..."
        AM_CPPFLAGS="-mmcu=atmega328p -DF_CPU=16000000L -DVARIANT_STANDARD -DARDUINO=0 -DARDUINO_AVR_UNO -DARDUINO_ARCH_AVR"
        MCU=atmega328p
        LIB_CORE=arduino-avr-uno
        UPLOAD_PROTOCOL=arduino
        BAUD=115200
    ],
    [arduino-mega2560],
    [
        echo "Configuring for Arduino Mega 2560..."
        AM_CPPFLAGS="-mmcu=atmega2560 -DF_CPU=16000000L -DARDUINO=0 -DARDUINO_AVR_MEGA2560 -DARDUINO_ARCH_AVR -DVARIANT_MEGA"
        MCU=atmega2560
        LIB_CORE=arduino-avr-mega2560
        UPLOAD_PROTOCOL=wiring
        BAUD=115200
    ],
    [
        echo "Test"
    ])

AC_SUBST([AM_CPPFLAGS])
AC_SUBST([AM_LDFLAGS])
AC_SUBST([MCU])
AC_SUBST([LIB_CORE])
AC_SUBST([USB_DEVICE])
AC_OUTPUT