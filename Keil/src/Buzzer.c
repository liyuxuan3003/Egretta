#include "Buzzer.h"

#include "BitOperate.h"
#include "HardwareConfig.h"

void BuzzerConfig()
{
    uint8_t outputBuz=SWI_6(P);
    uint8_t outputAud=SWI_7(P);
    (outputBuz) ? BIT_SET(BUZZER->OUTP,BUZ) : BIT_CLR(BUZZER->OUTP,BUZ);
    (outputAud) ? BIT_SET(BUZZER->OUTP,AUD) : BIT_CLR(BUZZER->OUTP,AUD);
    (outputBuz) ? LED_6(H) : LED_6(L);
    (outputAud) ? LED_7(H) : LED_7(L);
    return;
}

void BuzzerOutput(uint8_t note,uint32_t time)
{
    BUZZER->NOTE=note;
    BUZZER->TIME=time;
    return;
}

void BuzzerPlay(const uint16_t *note,const uint16_t *time,uint16_t len)
{
    for(uint32_t i=0; i<len; i++)
    {
        MIDI[i].NOTE=note[i];
        MIDI[i].TIME=time[i];
    }
    return;
}

void BuzzerPlaySetting(uint32_t loop,uint32_t gap)
{
    BUZZER->LOOP = loop;
    BUZZER->GAPT = gap;
    return;
}