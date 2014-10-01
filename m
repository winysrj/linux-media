Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:42484 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750901AbaJATkN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 1 Oct 2014 15:40:13 -0400
Message-ID: <542C589A.40606@iki.fi>
Date: Wed, 01 Oct 2014 22:40:10 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Matthias Schwarzott <zzam@gentoo.org>, linux-media@vger.kernel.org,
	mchehab@osg.samsung.com
Subject: Re: [PATCH V2 10/13] cx231xx: change usage of I2C_1 to the real i2c
 port
References: <1412140821-16285-1-git-send-email-zzam@gentoo.org> <1412140821-16285-11-git-send-email-zzam@gentoo.org>
In-Reply-To: <1412140821-16285-11-git-send-email-zzam@gentoo.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reviewed-by: Antti Palosaari <crope@iki.fi>

Antti

On 10/01/2014 08:20 AM, Matthias Schwarzott wrote:
> change almost all instances of I2C_1 to I2C_1_MUX_3
>
> Only these cases are changed to I2C_1_MUX_1:
> * All that have dont_use_port_3 set.
> * CX231XX_BOARD_HAUPPAUGE_EXETER, old code did explicitly not switch to port3.
> * eeprom access for 930C
>
> Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
> ---
>   drivers/media/usb/cx231xx/cx231xx-cards.c | 30 +++++++++++++++---------------
>   1 file changed, 15 insertions(+), 15 deletions(-)
>
> diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
> index f5fb93a..4eb2057 100644
> --- a/drivers/media/usb/cx231xx/cx231xx-cards.c
> +++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
> @@ -104,7 +104,7 @@ struct cx231xx_board cx231xx_boards[] = {
>   		.ctl_pin_status_mask = 0xFFFFFFC4,
>   		.agc_analog_digital_select_gpio = 0x0c,
>   		.gpio_pin_status_mask = 0x4001000,
> -		.tuner_i2c_master = I2C_1,
> +		.tuner_i2c_master = I2C_1_MUX_3,
>   		.demod_i2c_master = I2C_2,
>   		.has_dvb = 1,
>   		.demod_addr = 0x02,
> @@ -144,7 +144,7 @@ struct cx231xx_board cx231xx_boards[] = {
>   		.ctl_pin_status_mask = 0xFFFFFFC4,
>   		.agc_analog_digital_select_gpio = 0x0c,
>   		.gpio_pin_status_mask = 0x4001000,
> -		.tuner_i2c_master = I2C_1,
> +		.tuner_i2c_master = I2C_1_MUX_3,
>   		.demod_i2c_master = I2C_2,
>   		.has_dvb = 1,
>   		.demod_addr = 0x32,
> @@ -184,7 +184,7 @@ struct cx231xx_board cx231xx_boards[] = {
>   		.ctl_pin_status_mask = 0xFFFFFFC4,
>   		.agc_analog_digital_select_gpio = 0x1c,
>   		.gpio_pin_status_mask = 0x4001000,
> -		.tuner_i2c_master = I2C_1,
> +		.tuner_i2c_master = I2C_1_MUX_3,
>   		.demod_i2c_master = I2C_2,
>   		.has_dvb = 1,
>   		.demod_addr = 0x02,
> @@ -225,7 +225,7 @@ struct cx231xx_board cx231xx_boards[] = {
>   		.ctl_pin_status_mask = 0xFFFFFFC4,
>   		.agc_analog_digital_select_gpio = 0x1c,
>   		.gpio_pin_status_mask = 0x4001000,
> -		.tuner_i2c_master = I2C_1,
> +		.tuner_i2c_master = I2C_1_MUX_3,
>   		.demod_i2c_master = I2C_2,
>   		.has_dvb = 1,
>   		.demod_addr = 0x02,
> @@ -297,7 +297,7 @@ struct cx231xx_board cx231xx_boards[] = {
>   		.ctl_pin_status_mask = 0xFFFFFFC4,
>   		.agc_analog_digital_select_gpio = 0x0c,
>   		.gpio_pin_status_mask = 0x4001000,
> -		.tuner_i2c_master = I2C_1,
> +		.tuner_i2c_master = I2C_1_MUX_3,
>   		.demod_i2c_master = I2C_2,
>   		.has_dvb = 1,
>   		.demod_addr = 0x02,
> @@ -325,7 +325,7 @@ struct cx231xx_board cx231xx_boards[] = {
>   		.ctl_pin_status_mask = 0xFFFFFFC4,
>   		.agc_analog_digital_select_gpio = 0x0c,
>   		.gpio_pin_status_mask = 0x4001000,
> -		.tuner_i2c_master = I2C_1,
> +		.tuner_i2c_master = I2C_1_MUX_3,
>   		.demod_i2c_master = I2C_2,
>   		.has_dvb = 1,
>   		.demod_addr = 0x32,
> @@ -353,7 +353,7 @@ struct cx231xx_board cx231xx_boards[] = {
>   		.ctl_pin_status_mask = 0xFFFFFFC4,
>   		.agc_analog_digital_select_gpio = 0x0c,
>   		.gpio_pin_status_mask = 0x4001000,
> -		.tuner_i2c_master = I2C_1,
> +		.tuner_i2c_master = I2C_1_MUX_1,
>   		.demod_i2c_master = I2C_2,
>   		.has_dvb = 1,
>   		.demod_addr = 0x0e,
> @@ -419,7 +419,7 @@ struct cx231xx_board cx231xx_boards[] = {
>   		.tuner_sda_gpio = -1,
>   		.gpio_pin_status_mask = 0x4001000,
>   		.tuner_i2c_master = I2C_2,
> -		.demod_i2c_master = I2C_1,
> +		.demod_i2c_master = I2C_1_MUX_3,
>   		.ir_i2c_master = I2C_2,
>   		.has_dvb = 1,
>   		.demod_addr = 0x10,
> @@ -457,7 +457,7 @@ struct cx231xx_board cx231xx_boards[] = {
>   		.tuner_sda_gpio = -1,
>   		.gpio_pin_status_mask = 0x4001000,
>   		.tuner_i2c_master = I2C_2,
> -		.demod_i2c_master = I2C_1,
> +		.demod_i2c_master = I2C_1_MUX_3,
>   		.ir_i2c_master = I2C_2,
>   		.has_dvb = 1,
>   		.demod_addr = 0x10,
> @@ -495,7 +495,7 @@ struct cx231xx_board cx231xx_boards[] = {
>   		.tuner_sda_gpio = -1,
>   		.gpio_pin_status_mask = 0x4001000,
>   		.tuner_i2c_master = I2C_2,
> -		.demod_i2c_master = I2C_1,
> +		.demod_i2c_master = I2C_1_MUX_3,
>   		.ir_i2c_master = I2C_2,
>   		.rc_map_name = RC_MAP_PIXELVIEW_002T,
>   		.has_dvb = 1,
> @@ -587,7 +587,7 @@ struct cx231xx_board cx231xx_boards[] = {
>   		.ctl_pin_status_mask = 0xFFFFFFC4,
>   		.agc_analog_digital_select_gpio = 0x0c,
>   		.gpio_pin_status_mask = 0x4001000,
> -		.tuner_i2c_master = I2C_1,
> +		.tuner_i2c_master = I2C_1_MUX_3,
>   		.norm = V4L2_STD_PAL,
>
>   		.input = {{
> @@ -622,7 +622,7 @@ struct cx231xx_board cx231xx_boards[] = {
>   		.ctl_pin_status_mask = 0xFFFFFFC4,
>   		.agc_analog_digital_select_gpio = 0x0c,
>   		.gpio_pin_status_mask = 0x4001000,
> -		.tuner_i2c_master = I2C_1,
> +		.tuner_i2c_master = I2C_1_MUX_3,
>   		.norm = V4L2_STD_NTSC,
>
>   		.input = {{
> @@ -718,7 +718,7 @@ struct cx231xx_board cx231xx_boards[] = {
>   		.ctl_pin_status_mask = 0xFFFFFFC4,
>   		.agc_analog_digital_select_gpio = 0x0c,
>   		.gpio_pin_status_mask = 0x4001000,
> -		.tuner_i2c_master = I2C_1,
> +		.tuner_i2c_master = I2C_1_MUX_3,
>   		.demod_i2c_master = I2C_2,
>   		.has_dvb = 1,
>   		.demod_addr = 0x0e,
> @@ -757,7 +757,7 @@ struct cx231xx_board cx231xx_boards[] = {
>   		.ctl_pin_status_mask = 0xFFFFFFC4,
>   		.agc_analog_digital_select_gpio = 0x0c,
>   		.gpio_pin_status_mask = 0x4001000,
> -		.tuner_i2c_master = I2C_1,
> +		.tuner_i2c_master = I2C_1_MUX_3,
>   		.demod_i2c_master = I2C_2,
>   		.has_dvb = 1,
>   		.demod_addr = 0x0e,
> @@ -1064,7 +1064,7 @@ void cx231xx_card_setup(struct cx231xx *dev)
>   			struct i2c_client client;
>
>   			memset(&client, 0, sizeof(client));
> -			client.adapter = cx231xx_get_i2c_adap(dev, I2C_1);
> +			client.adapter = cx231xx_get_i2c_adap(dev, I2C_1_MUX_1);
>   			client.addr = 0xa0 >> 1;
>
>   			read_eeprom(dev, &client, eeprom, sizeof(eeprom));
>

-- 
http://palosaari.fi/
