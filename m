Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:42671 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755306AbaJ3T1z (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Oct 2014 15:27:55 -0400
Date: Thu, 30 Oct 2014 17:27:50 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Matthias Schwarzott <zzam@gentoo.org>
Cc: linux-media@vger.kernel.org, crope@iki.fi
Subject: Re: [PATCH V3 10/13] cx231xx: change usage of I2C_1 to the real i2c
 port
Message-ID: <20141030172750.193cfaae@recife.lan>
In-Reply-To: <1412227265-17453-11-git-send-email-zzam@gentoo.org>
References: <1412227265-17453-1-git-send-email-zzam@gentoo.org>
	<1412227265-17453-11-git-send-email-zzam@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu,  2 Oct 2014 07:21:02 +0200
Matthias Schwarzott <zzam@gentoo.org> escreveu:

> change almost all instances of I2C_1 to I2C_1_MUX_3

So far, this is likely the most dangerous patch on this series ;)

> 
> Only these cases are changed to I2C_1_MUX_1:
> * All that have dont_use_port_3 set.
> * CX231XX_BOARD_HAUPPAUGE_EXETER, old code did explicitly not switch to port3.
> * eeprom access for 930C

I think Pixelview SBTVD Hybrid also doesn't use MUX_3 for tuner. Thankfully,
I have such tuner. So, I'll test and fix it if needed.

> 
> Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
> Reviewed-by: Antti Palosaari <crope@iki.fi>
> ---
>  drivers/media/usb/cx231xx/cx231xx-cards.c | 30 +++++++++++++++---------------
>  1 file changed, 15 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
> index f5fb93a..4eb2057 100644
> --- a/drivers/media/usb/cx231xx/cx231xx-cards.c
> +++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
> @@ -104,7 +104,7 @@ struct cx231xx_board cx231xx_boards[] = {
>  		.ctl_pin_status_mask = 0xFFFFFFC4,
>  		.agc_analog_digital_select_gpio = 0x0c,
>  		.gpio_pin_status_mask = 0x4001000,
> -		.tuner_i2c_master = I2C_1,
> +		.tuner_i2c_master = I2C_1_MUX_3,
>  		.demod_i2c_master = I2C_2,
>  		.has_dvb = 1,
>  		.demod_addr = 0x02,
> @@ -144,7 +144,7 @@ struct cx231xx_board cx231xx_boards[] = {
>  		.ctl_pin_status_mask = 0xFFFFFFC4,
>  		.agc_analog_digital_select_gpio = 0x0c,
>  		.gpio_pin_status_mask = 0x4001000,
> -		.tuner_i2c_master = I2C_1,
> +		.tuner_i2c_master = I2C_1_MUX_3,
>  		.demod_i2c_master = I2C_2,
>  		.has_dvb = 1,
>  		.demod_addr = 0x32,
> @@ -184,7 +184,7 @@ struct cx231xx_board cx231xx_boards[] = {
>  		.ctl_pin_status_mask = 0xFFFFFFC4,
>  		.agc_analog_digital_select_gpio = 0x1c,
>  		.gpio_pin_status_mask = 0x4001000,
> -		.tuner_i2c_master = I2C_1,
> +		.tuner_i2c_master = I2C_1_MUX_3,
>  		.demod_i2c_master = I2C_2,
>  		.has_dvb = 1,
>  		.demod_addr = 0x02,
> @@ -225,7 +225,7 @@ struct cx231xx_board cx231xx_boards[] = {
>  		.ctl_pin_status_mask = 0xFFFFFFC4,
>  		.agc_analog_digital_select_gpio = 0x1c,
>  		.gpio_pin_status_mask = 0x4001000,
> -		.tuner_i2c_master = I2C_1,
> +		.tuner_i2c_master = I2C_1_MUX_3,
>  		.demod_i2c_master = I2C_2,
>  		.has_dvb = 1,
>  		.demod_addr = 0x02,
> @@ -297,7 +297,7 @@ struct cx231xx_board cx231xx_boards[] = {
>  		.ctl_pin_status_mask = 0xFFFFFFC4,
>  		.agc_analog_digital_select_gpio = 0x0c,
>  		.gpio_pin_status_mask = 0x4001000,
> -		.tuner_i2c_master = I2C_1,
> +		.tuner_i2c_master = I2C_1_MUX_3,
>  		.demod_i2c_master = I2C_2,
>  		.has_dvb = 1,
>  		.demod_addr = 0x02,
> @@ -325,7 +325,7 @@ struct cx231xx_board cx231xx_boards[] = {
>  		.ctl_pin_status_mask = 0xFFFFFFC4,
>  		.agc_analog_digital_select_gpio = 0x0c,
>  		.gpio_pin_status_mask = 0x4001000,
> -		.tuner_i2c_master = I2C_1,
> +		.tuner_i2c_master = I2C_1_MUX_3,
>  		.demod_i2c_master = I2C_2,
>  		.has_dvb = 1,
>  		.demod_addr = 0x32,
> @@ -353,7 +353,7 @@ struct cx231xx_board cx231xx_boards[] = {
>  		.ctl_pin_status_mask = 0xFFFFFFC4,
>  		.agc_analog_digital_select_gpio = 0x0c,
>  		.gpio_pin_status_mask = 0x4001000,
> -		.tuner_i2c_master = I2C_1,
> +		.tuner_i2c_master = I2C_1_MUX_1,
>  		.demod_i2c_master = I2C_2,
>  		.has_dvb = 1,
>  		.demod_addr = 0x0e,
> @@ -419,7 +419,7 @@ struct cx231xx_board cx231xx_boards[] = {
>  		.tuner_sda_gpio = -1,
>  		.gpio_pin_status_mask = 0x4001000,
>  		.tuner_i2c_master = I2C_2,
> -		.demod_i2c_master = I2C_1,
> +		.demod_i2c_master = I2C_1_MUX_3,
>  		.ir_i2c_master = I2C_2,
>  		.has_dvb = 1,
>  		.demod_addr = 0x10,
> @@ -457,7 +457,7 @@ struct cx231xx_board cx231xx_boards[] = {
>  		.tuner_sda_gpio = -1,
>  		.gpio_pin_status_mask = 0x4001000,
>  		.tuner_i2c_master = I2C_2,
> -		.demod_i2c_master = I2C_1,
> +		.demod_i2c_master = I2C_1_MUX_3,
>  		.ir_i2c_master = I2C_2,
>  		.has_dvb = 1,
>  		.demod_addr = 0x10,
> @@ -495,7 +495,7 @@ struct cx231xx_board cx231xx_boards[] = {
>  		.tuner_sda_gpio = -1,
>  		.gpio_pin_status_mask = 0x4001000,
>  		.tuner_i2c_master = I2C_2,
> -		.demod_i2c_master = I2C_1,
> +		.demod_i2c_master = I2C_1_MUX_3,
>  		.ir_i2c_master = I2C_2,
>  		.rc_map_name = RC_MAP_PIXELVIEW_002T,
>  		.has_dvb = 1,
> @@ -587,7 +587,7 @@ struct cx231xx_board cx231xx_boards[] = {
>  		.ctl_pin_status_mask = 0xFFFFFFC4,
>  		.agc_analog_digital_select_gpio = 0x0c,
>  		.gpio_pin_status_mask = 0x4001000,
> -		.tuner_i2c_master = I2C_1,
> +		.tuner_i2c_master = I2C_1_MUX_3,
>  		.norm = V4L2_STD_PAL,
>  
>  		.input = {{
> @@ -622,7 +622,7 @@ struct cx231xx_board cx231xx_boards[] = {
>  		.ctl_pin_status_mask = 0xFFFFFFC4,
>  		.agc_analog_digital_select_gpio = 0x0c,
>  		.gpio_pin_status_mask = 0x4001000,
> -		.tuner_i2c_master = I2C_1,
> +		.tuner_i2c_master = I2C_1_MUX_3,
>  		.norm = V4L2_STD_NTSC,
>  
>  		.input = {{
> @@ -718,7 +718,7 @@ struct cx231xx_board cx231xx_boards[] = {
>  		.ctl_pin_status_mask = 0xFFFFFFC4,
>  		.agc_analog_digital_select_gpio = 0x0c,
>  		.gpio_pin_status_mask = 0x4001000,
> -		.tuner_i2c_master = I2C_1,
> +		.tuner_i2c_master = I2C_1_MUX_3,
>  		.demod_i2c_master = I2C_2,
>  		.has_dvb = 1,
>  		.demod_addr = 0x0e,
> @@ -757,7 +757,7 @@ struct cx231xx_board cx231xx_boards[] = {
>  		.ctl_pin_status_mask = 0xFFFFFFC4,
>  		.agc_analog_digital_select_gpio = 0x0c,
>  		.gpio_pin_status_mask = 0x4001000,
> -		.tuner_i2c_master = I2C_1,
> +		.tuner_i2c_master = I2C_1_MUX_3,
>  		.demod_i2c_master = I2C_2,
>  		.has_dvb = 1,
>  		.demod_addr = 0x0e,
> @@ -1064,7 +1064,7 @@ void cx231xx_card_setup(struct cx231xx *dev)
>  			struct i2c_client client;
>  
>  			memset(&client, 0, sizeof(client));
> -			client.adapter = cx231xx_get_i2c_adap(dev, I2C_1);
> +			client.adapter = cx231xx_get_i2c_adap(dev, I2C_1_MUX_1);
>  			client.addr = 0xa0 >> 1;
>  
>  			read_eeprom(dev, &client, eeprom, sizeof(eeprom));
