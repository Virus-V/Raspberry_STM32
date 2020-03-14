#include <stdint.h>
#include "stm32f10x.h"

void Init_LED(void) {
    GPIO_InitTypeDef GPIO_InitStructure;
    // GPIOC退出复位状态
    RCC_APB2PeriphResetCmd(RCC_APB2Periph_GPIOC, DISABLE);
    // 打开GPIOC的时钟
    RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOC, ENABLE);
    GPIO_InitStructure.GPIO_Pin = GPIO_Pin_1;
    GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP;
    GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
    GPIO_Init(GPIOC, &GPIO_InitStructure);
}

void delay(void) {
    uint32_t i;

    for(i=0; i<100000; i++){
        __NOP();
    }
}

int main() {
    Init_LED();
    
    while(1) {
        GPIO_SetBits(GPIOC, GPIO_Pin_1);
        delay();
        GPIO_ResetBits(GPIOC, GPIO_Pin_1);
        delay();
    }

    return 0;
}
