# Arduino project template
This is a very simple project template to build code for Arduino boards 
(or pretty much anything that `avr-gcc` can target if you put in more effort).

You can drop in `*.ino` files, and the `Arduino.h` header should be automatically included
for them, if the compiler was able to find that in the first place.

I took the settings `board.txt` or somewhere else and put them manually 
into platform.mk because I couldn't be bothered to handle parsing board.txt 
or read through >2k lines Makefile written by other people who can do that.

This assumes that you have aworking `avr-gcc` cross-compiler somewhere 
and, if you need it, the Arduino core precompiled where `avr-gcc` can find it.
It assumes names as in [my other repo](https://github.com/ooinaruhugh/ArduinoCore-avr),
but you can either change them or just drop the necessary files here if you want.

## Usage

Just add the sources to `SRCS`, set a name in `PROJECT_NAME`. For compiling, you need to set
the `TARGET` variable, e.g. like this 
```sh
make TARGET=uno
```

This compiles your sketch and all files that you have specified for your target board.

I made use of pattern rules, so for any soruce code file that you have, you can make 
corresponding `*.o`, `*.elf` or `*.hex` files, where it makes sense. Just specify the path.

I also used that for upload rules, so if you specify the path of a `*.hex` file, 
but with `.upload` as suffix, it will upload that program using your settings.

If you don't want to use the core from Arduino (or don't have it or whatever),
just set `WITH_ARDUINO_CORE` to something different than `1`.

## License

The MIT License (MIT) 2023 - [Kamillo Ferry](https://github.com/ooinaruhugh/). 
Please have a look at the [LICENSE](LICENSE) for more details.
