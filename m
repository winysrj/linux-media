Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44218 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753270AbaIYPGr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Sep 2014 11:06:47 -0400
Message-ID: <54242F82.8090303@iki.fi>
Date: Thu, 25 Sep 2014 18:06:42 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Matthias Schwarzott <zzam@gentoo.org>, linux-media@vger.kernel.org,
	mchehab@osg.samsung.com
Subject: Re: [PATCH 05/12] cx231xx: Use symbolic constants for i2c ports
References: <1411621684-8295-1-git-send-email-zzam@gentoo.org> <1411621684-8295-5-git-send-email-zzam@gentoo.org>
In-Reply-To: <1411621684-8295-5-git-send-email-zzam@gentoo.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reviewed-by: Antti Palosaari <crope@iki.fi>

regards
Antti

On 09/25/2014 08:07 AM, Matthias Schwarzott wrote:
> use already existing I2C_0 ... I2C_3
>
> Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
> ---
>   drivers/media/usb/cx231xx/cx231xx-cards.c | 62 +++++++++++++++----------------
>   drivers/media/usb/cx231xx/cx231xx.h       |  8 ++--
>   2 files changed, 35 insertions(+), 35 deletions(-)
>
> diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
> index 092fb85..2f027c7 100644
> --- a/drivers/media/usb/cx231xx/cx231xx-cards.c
> +++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
> @@ -104,8 +104,8 @@ struct cx231xx_board cx231xx_boards[] = {
>   		.ctl_pin_status_mask = 0xFFFFFFC4,
>   		.agc_analog_digital_select_gpio = 0x0c,
>   		.gpio_pin_status_mask = 0x4001000,
> -		.tuner_i2c_master = 1,
> -		.demod_i2c_master = 2,
> +		.tuner_i2c_master = I2C_1,
> +		.demod_i2c_master = I2C_2,
>   		.has_dvb = 1,
>   		.demod_addr = 0x02,
>   		.norm = V4L2_STD_PAL,
> @@ -144,8 +144,8 @@ struct cx231xx_board cx231xx_boards[] = {
>   		.ctl_pin_status_mask = 0xFFFFFFC4,
>   		.agc_analog_digital_select_gpio = 0x0c,
>   		.gpio_pin_status_mask = 0x4001000,
> -		.tuner_i2c_master = 1,
> -		.demod_i2c_master = 2,
> +		.tuner_i2c_master = I2C_1,
> +		.demod_i2c_master = I2C_2,
>   		.has_dvb = 1,
>   		.demod_addr = 0x32,
>   		.norm = V4L2_STD_NTSC,
> @@ -184,8 +184,8 @@ struct cx231xx_board cx231xx_boards[] = {
>   		.ctl_pin_status_mask = 0xFFFFFFC4,
>   		.agc_analog_digital_select_gpio = 0x1c,
>   		.gpio_pin_status_mask = 0x4001000,
> -		.tuner_i2c_master = 1,
> -		.demod_i2c_master = 2,
> +		.tuner_i2c_master = I2C_1,
> +		.demod_i2c_master = I2C_2,
>   		.has_dvb = 1,
>   		.demod_addr = 0x02,
>   		.norm = V4L2_STD_PAL,
> @@ -225,8 +225,8 @@ struct cx231xx_board cx231xx_boards[] = {
>   		.ctl_pin_status_mask = 0xFFFFFFC4,
>   		.agc_analog_digital_select_gpio = 0x1c,
>   		.gpio_pin_status_mask = 0x4001000,
> -		.tuner_i2c_master = 1,
> -		.demod_i2c_master = 2,
> +		.tuner_i2c_master = I2C_1,
> +		.demod_i2c_master = I2C_2,
>   		.has_dvb = 1,
>   		.demod_addr = 0x02,
>   		.norm = V4L2_STD_PAL,
> @@ -297,8 +297,8 @@ struct cx231xx_board cx231xx_boards[] = {
>   		.ctl_pin_status_mask = 0xFFFFFFC4,
>   		.agc_analog_digital_select_gpio = 0x0c,
>   		.gpio_pin_status_mask = 0x4001000,
> -		.tuner_i2c_master = 1,
> -		.demod_i2c_master = 2,
> +		.tuner_i2c_master = I2C_1,
> +		.demod_i2c_master = I2C_2,
>   		.has_dvb = 1,
>   		.demod_addr = 0x02,
>   		.norm = V4L2_STD_PAL,
> @@ -325,8 +325,8 @@ struct cx231xx_board cx231xx_boards[] = {
>   		.ctl_pin_status_mask = 0xFFFFFFC4,
>   		.agc_analog_digital_select_gpio = 0x0c,
>   		.gpio_pin_status_mask = 0x4001000,
> -		.tuner_i2c_master = 1,
> -		.demod_i2c_master = 2,
> +		.tuner_i2c_master = I2C_1,
> +		.demod_i2c_master = I2C_2,
>   		.has_dvb = 1,
>   		.demod_addr = 0x32,
>   		.norm = V4L2_STD_NTSC,
> @@ -353,8 +353,8 @@ struct cx231xx_board cx231xx_boards[] = {
>   		.ctl_pin_status_mask = 0xFFFFFFC4,
>   		.agc_analog_digital_select_gpio = 0x0c,
>   		.gpio_pin_status_mask = 0x4001000,
> -		.tuner_i2c_master = 1,
> -		.demod_i2c_master = 2,
> +		.tuner_i2c_master = I2C_1,
> +		.demod_i2c_master = I2C_2,
>   		.has_dvb = 1,
>   		.demod_addr = 0x0e,
>   		.norm = V4L2_STD_NTSC,
> @@ -418,9 +418,9 @@ struct cx231xx_board cx231xx_boards[] = {
>   		.tuner_scl_gpio = -1,
>   		.tuner_sda_gpio = -1,
>   		.gpio_pin_status_mask = 0x4001000,
> -		.tuner_i2c_master = 2,
> -		.demod_i2c_master = 1,
> -		.ir_i2c_master = 2,
> +		.tuner_i2c_master = I2C_2,
> +		.demod_i2c_master = I2C_1,
> +		.ir_i2c_master = I2C_2,
>   		.has_dvb = 1,
>   		.demod_addr = 0x10,
>   		.norm = V4L2_STD_PAL_M,
> @@ -456,9 +456,9 @@ struct cx231xx_board cx231xx_boards[] = {
>   		.tuner_scl_gpio = -1,
>   		.tuner_sda_gpio = -1,
>   		.gpio_pin_status_mask = 0x4001000,
> -		.tuner_i2c_master = 2,
> -		.demod_i2c_master = 1,
> -		.ir_i2c_master = 2,
> +		.tuner_i2c_master = I2C_2,
> +		.demod_i2c_master = I2C_1,
> +		.ir_i2c_master = I2C_2,
>   		.has_dvb = 1,
>   		.demod_addr = 0x10,
>   		.norm = V4L2_STD_NTSC_M,
> @@ -494,9 +494,9 @@ struct cx231xx_board cx231xx_boards[] = {
>   		.tuner_scl_gpio = -1,
>   		.tuner_sda_gpio = -1,
>   		.gpio_pin_status_mask = 0x4001000,
> -		.tuner_i2c_master = 2,
> -		.demod_i2c_master = 1,
> -		.ir_i2c_master = 2,
> +		.tuner_i2c_master = I2C_2,
> +		.demod_i2c_master = I2C_1,
> +		.ir_i2c_master = I2C_2,
>   		.rc_map_name = RC_MAP_PIXELVIEW_002T,
>   		.has_dvb = 1,
>   		.demod_addr = 0x10,
> @@ -587,7 +587,7 @@ struct cx231xx_board cx231xx_boards[] = {
>   		.ctl_pin_status_mask = 0xFFFFFFC4,
>   		.agc_analog_digital_select_gpio = 0x0c,
>   		.gpio_pin_status_mask = 0x4001000,
> -		.tuner_i2c_master = 1,
> +		.tuner_i2c_master = I2C_1,
>   		.norm = V4L2_STD_PAL,
>
>   		.input = {{
> @@ -622,7 +622,7 @@ struct cx231xx_board cx231xx_boards[] = {
>   		.ctl_pin_status_mask = 0xFFFFFFC4,
>   		.agc_analog_digital_select_gpio = 0x0c,
>   		.gpio_pin_status_mask = 0x4001000,
> -		.tuner_i2c_master = 1,
> +		.tuner_i2c_master = I2C_1,
>   		.norm = V4L2_STD_NTSC,
>
>   		.input = {{
> @@ -718,8 +718,8 @@ struct cx231xx_board cx231xx_boards[] = {
>   		.ctl_pin_status_mask = 0xFFFFFFC4,
>   		.agc_analog_digital_select_gpio = 0x0c,
>   		.gpio_pin_status_mask = 0x4001000,
> -		.tuner_i2c_master = 1,
> -		.demod_i2c_master = 2,
> +		.tuner_i2c_master = I2C_1,
> +		.demod_i2c_master = I2C_2,
>   		.has_dvb = 1,
>   		.demod_addr = 0x0e,
>   		.norm = V4L2_STD_PAL,
> @@ -757,8 +757,8 @@ struct cx231xx_board cx231xx_boards[] = {
>   		.ctl_pin_status_mask = 0xFFFFFFC4,
>   		.agc_analog_digital_select_gpio = 0x0c,
>   		.gpio_pin_status_mask = 0x4001000,
> -		.tuner_i2c_master = 1,
> -		.demod_i2c_master = 2,
> +		.tuner_i2c_master = I2C_1,
> +		.demod_i2c_master = I2C_2,
>   		.has_dvb = 1,
>   		.demod_addr = 0x0e,
>   		.norm = V4L2_STD_PAL,
> @@ -1033,7 +1033,7 @@ void cx231xx_card_setup(struct cx231xx *dev)
>   	/* request some modules */
>   	if (dev->board.decoder == CX231XX_AVDECODER) {
>   		dev->sd_cx25840 = v4l2_i2c_new_subdev(&dev->v4l2_dev,
> -					&dev->i2c_bus[0].i2c_adap,
> +					&dev->i2c_bus[I2C_0].i2c_adap,
>   					"cx25840", 0x88 >> 1, NULL);
>   		if (dev->sd_cx25840 == NULL)
>   			cx231xx_info("cx25840 subdev registration failure\n");
> @@ -1062,7 +1062,7 @@ void cx231xx_card_setup(struct cx231xx *dev)
>   			struct i2c_client client;
>
>   			memset(&client, 0, sizeof(client));
> -			client.adapter = &dev->i2c_bus[1].i2c_adap;
> +			client.adapter = &dev->i2c_bus[I2C_1].i2c_adap;
>   			client.addr = 0xa0 >> 1;
>
>   			read_eeprom(dev, &client, eeprom, sizeof(eeprom));
> diff --git a/drivers/media/usb/cx231xx/cx231xx.h b/drivers/media/usb/cx231xx/cx231xx.h
> index c92382f..3ab107a 100644
> --- a/drivers/media/usb/cx231xx/cx231xx.h
> +++ b/drivers/media/usb/cx231xx/cx231xx.h
> @@ -322,10 +322,10 @@ enum cx231xx_decoder {
>   };
>
>   enum CX231XX_I2C_MASTER_PORT {
> -	I2C_0 = 0,
> -	I2C_1 = 1,
> -	I2C_2 = 2,
> -	I2C_3 = 3
> +	I2C_0 = 0, /* master 0 - internal connection */
> +	I2C_1 = 1, /* master 1 - I2C_DEMOD_EN = 0    */
> +	I2C_2 = 2, /* master 2                       */
> +	I2C_3 = 3  /* master 1 - I2C_DEMOD_EN = 1    */
>   };
>
>   struct cx231xx_board {
>

-- 
http://palosaari.fi/
