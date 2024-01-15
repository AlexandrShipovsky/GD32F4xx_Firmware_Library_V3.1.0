/*!
    \file    app.c
    \brief   USB main routine for CDC device

    \version 2023-06-25, V3.1.0, firmware for GD32F4xx
*/

/*
    Copyright (c) 2023, GigaDevice Semiconductor Inc.

    Redistribution and use in source and binary forms, with or without modification, 
are permitted provided that the following conditions are met:

    1. Redistributions of source code must retain the above copyright notice, this 
       list of conditions and the following disclaimer.
    2. Redistributions in binary form must reproduce the above copyright notice, 
       this list of conditions and the following disclaimer in the documentation 
       and/or other materials provided with the distribution.
    3. Neither the name of the copyright holder nor the names of its contributors 
       may be used to endorse or promote products derived from this software without 
       specific prior written permission.

    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. 
IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, 
INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT 
NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR 
PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY 
OF SUCH DAMAGE.
*/
#include "drv_usb_hw.h"
#include "cdc_acm_core.h"
#include "string.h"

usb_core_driver cdc_acm;

/*!
    \brief      main routine will construct a USB CDC device
    \param[in]  none
    \param[out] none
    \retval     none
*/
int main(void)
{
    usb_gpio_config();
    usb_rcu_config();
    usb_timer_init();

    // LED init
    /* enable the led clock */
    rcu_periph_clock_enable(RCU_GPIOC);
    rcu_periph_clock_enable(RCU_GPIOA);
    /* configure led GPIO port */
    gpio_mode_set(GPIOC, GPIO_MODE_OUTPUT, GPIO_PUPD_NONE,GPIO_PIN_1);
    gpio_output_options_set(GPIOC, GPIO_OTYPE_PP, GPIO_OSPEED_50MHZ,GPIO_PIN_1);

    for(uint8_t i = 0;i < 10;i++)
    {
        gpio_bit_toggle(GPIOC,GPIO_PIN_1);
        usb_mdelay(100);
    }

    usbd_init (&cdc_acm,
#ifdef USE_USB_FS
              USB_CORE_ENUM_FS,
#elif defined(USE_USB_HS)
              USB_CORE_ENUM_HS,
#endif /* USE_USB_FS */
              &cdc_desc,
              &cdc_class);

    usb_intr_config();

    /* main loop */
    usb_cdc_handler cdc;
    uint8_t buf[] = "Hello from K1921BK01T2\n\r";

    while (1) {
        if (USBD_CONFIGURED == cdc_acm.dev.cur_status) {
            if (0U == cdc_acm_check_ready(&cdc_acm)) {
                        cdc_acm_data_receive(&cdc_acm);
                    } else {
                cdc.receive_length = sizeof(buf);
                memcpy(&cdc.data,buf,sizeof(buf));
                cdc_acm.dev.class_data[CDC_COM_INTERFACE] = &cdc;
                cdc_acm_data_send(&cdc_acm);
                 }
            }

        usb_mdelay(1000);
    }
}
