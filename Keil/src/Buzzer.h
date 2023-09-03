#ifndef BUZZER_H
#define BUZZER_H

#include <stdint.h>

#include "GlobalDefine.h"
#include "Peripheral.h"

#define BUZ 0
#define AUD 1

#define MIDI_OFFSET 16*WORD

typedef struct
{
    volatile uint32_t NOTE;
    volatile uint32_t TIME;
    volatile uint32_t OUTP;
    volatile uint32_t LOOP;
    volatile uint32_t GAPT;
    volatile uint32_t STAT;
} BuzzerType;

typedef struct 
{
    volatile uint16_t NOTE;
    volatile uint16_t TIME;
} MIDIType;

#define BUZZER ((BuzzerType *)BUZZER_BASE)
#define MIDI ((MIDIType *) BUZZER_BASE + MIDI_OFFSET)

void BuzzerConfig();
void BuzzerPlay(const uint16_t *note,const uint16_t *time,uint16_t len);
void BuzzerPlaySetting(uint32_t loop,uint32_t gap);
void BuzzerOutput(uint8_t note,uint32_t time);

// #define T0 200
// #define T1 180

// #define N8(t) t 
// #define N4(t) t,t 
// #define N2(t) t,t,t,t

// #define L8 T1
// #define L4 T0,T1 
// #define L2 T0,T0,T0,T1

// static const uint8_t noteArr[] = 
// {
//     N4(1),N4(2),N4(3),N4(1),
//     N4(1),N4(2),N4(3),N4(1),
//     N4(3),N4(4),N2(5),
//     N4(3),N4(4),N2(5),
//     N8(5),N8(6),N8(5),N8(4),N4(3),N4(1),
//     N8(5),N8(6),N8(5),N8(4),N4(3),N4(1),
//     N4(1),N4(1),N2(1),
//     N4(1),N4(1),N2(1)
// };

// static const uint16_t noteLenArr[] =
// {
//     L4,L4,L4,L4,
//     L4,L4,L4,L4,
//     L4,L4,L2,
//     L4,L4,L2,
//     L8,L8,L8,L8,L4,L4,
//     L8,L8,L8,L8,L4,L4,
//     L4,L4,L2,
//     L4,L4,L2
// };

#endif