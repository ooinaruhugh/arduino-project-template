#ifndef CONFIG_H
#define CONFIG_H

#include <avr/pgmspace.h>

#define QUOTE(name) #name
#define STR(macro) QUOTE(macro)

const char STRING_PROJECT_NAME[] PROGMEM = STR(PROJECT_NAME);

#endif  // CONFIG_H