Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:42543 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751424AbaBIQQF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Feb 2014 11:16:05 -0500
Message-ID: <52F7A9C2.1000109@iki.fi>
Date: Sun, 09 Feb 2014 18:16:02 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Heiko Voigt <hvoigt@hvoigt.net>,
	Ivan Kalvachev <ikalvachev@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: RFH: Trying to implement support PCTV Quatro Stick 522e
References: <20140209153324.GA4043@sandbox-ub>
In-Reply-To: <20140209153324.GA4043@sandbox-ub>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moikka Heiko,

On 09.02.2014 17:33, Heiko Voigt wrote:
> Hi,
>
> I just purchased a PCTV QuatroStick 522e (2013:025e). Since it is the successor
> of the 520e I believed that there would probably be Linux support for it, it
> seems not.

ah, first 292e and now that...

> But I do not want to give up so easily and since there is support for the
> previous models I would like to have a go at adding support for this one.
>
> I already tried a simple copy and paste approach from the 520e
> (resulting in the attached patch[1]) but it seems too many things have been
> changed, since it leads to this error[2]. To test I applied my patch on top of
> Ubuntus 13.10 kernel repository so I can easily build packages.

Log you attached end of that mail looks like about everything is failing 
totally badly. That means there is some other chip than em28xx.

Also DRX-K and TDA18271 used for 520e are ages old and EOL, so you will 
not see those anymore on new devices.

>
> My questions are probably mainly directed to Antti since he implemented the
> support for 520e:
>
> How did you get the information about 520e? Does it make sense to contact pctv?
> I will send an email to their support anyway. Did they provide you with any
> information or did you crack open the housing of the stick to find out whats on
> the board? Is there anyone else doing development for this device?

PCTV 520e support was pretty simple as there was existing driver for 
each used chips. Biggest problem was to find out GPIO bug in DRX-K 
driver, which was used to drive LNA. Sniffing windows driver and 
generate code, copy paste and test until problematic register is found.

For that certain device my role was rather small as I didn't make any 
new driver. Just got device and glued all drivers together.

>
> Maybe someone can give me some pointers?

Generally speaking I tend to get some help from different entities as 
well as most of the other long term contributors...


You could gather needed information many ways. Inspect windows driver 
binaries, take sniffs, open the device, do error and trial tests when 
you has got control to chips and so. There is tons of methods. Writing 
new chipset driver is still rather big work in any case.


Drop windows driver to my email and I will quickly check which are 
possible chipset.

regards
Antti


>
> Thanks a lot in advance.
>
> Cheers Heiko
>
> [1] ---8<---
>
> Subject: [PATCH] [media] em28xx: support for 2013:0251 PCTV QuatroStick (522e)
>
> Heavily based on copy and paste from c247d7b, fa5527c and 795cb41
>
> Signed-off-by: Heiko Voigt <hvoigt@hvoigt.net>
> ---
>   drivers/media/usb/em28xx/em28xx-cards.c | 28 ++++++++++++++++++++++++++++
>   drivers/media/usb/em28xx/em28xx-dvb.c   |  1 +
>   drivers/media/usb/em28xx/em28xx.h       |  1 +
>   3 files changed, 30 insertions(+)
>
> diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
> index eb39903..d91477a 100644
> --- a/drivers/media/usb/em28xx/em28xx-cards.c
> +++ b/drivers/media/usb/em28xx/em28xx-cards.c
> @@ -433,6 +433,20 @@ static struct em28xx_reg_seq pctv_520e[] = {
>   	{	-1,			-1,	-1,	-1},
>   };
>
> +/* 2013:025e PCTV QuatroStick nano (522e)
> + * GPIO_2: decoder reset, 0=active
> + * GPIO_4: decoder suspend, 0=active
> + * GPIO_6: demod reset, 0=active
> + * GPIO_7: LED, 1=active
> + */
> +static struct em28xx_reg_seq pctv_522e[] = {
> +	{EM2874_R80_GPIO_P0_CTRL,	0x10,	0xff,	100},
> +	{EM2874_R80_GPIO_P0_CTRL,	0x14,	0xff,	100}, /* GPIO_2 = 1 */
> +	{EM2874_R80_GPIO_P0_CTRL,	0x54,	0xff,	050}, /* GPIO_6 = 1 */
> +	{EM2874_R80_GPIO_P0_CTRL,	0xd4,	0xff,	000}, /* GPIO_7 = 1 */
> +	{	-1,			-1,	-1,	-1},
> +};
> +
>   /* 1ae7:9003/9004 SpeedLink Vicious And Devine Laplace webcam
>    * reg 0x80/0x84:
>    * GPIO_0: capturing LED, 0=on, 1=off
> @@ -2094,6 +2108,18 @@ struct em28xx_board em28xx_boards[] = {
>   		.i2c_speed     = EM28XX_I2C_CLK_WAIT_ENABLE |
>   				EM28XX_I2C_FREQ_400_KHZ,
>   	},
> +	/* 2013:025e PCTV QuatroStick (522e)
> +	 * Empia EM2884 + Micronas DRX 3926K + NXP TDA18271HDC2 */
> +	[EM2884_BOARD_PCTV_522E] = {
> +		.name          = "PCTV QuatroStick nano (522e)",
> +		.tuner_type    = TUNER_ABSENT,
> +		.tuner_gpio    = pctv_522e,
> +		.has_dvb       = 1,
> +		.ir_codes      = RC_MAP_PINNACLE_PCTV_HD,
> +		.def_i2c_bus   = 1,
> +		.i2c_speed     = EM28XX_I2C_CLK_WAIT_ENABLE |
> +				EM28XX_I2C_FREQ_400_KHZ,
> +	},
>   	[EM2884_BOARD_TERRATEC_HTC_USB_XS] = {
>   		.name         = "Terratec Cinergy HTC USB XS",
>   		.has_dvb      = 1,
> @@ -2322,6 +2348,8 @@ struct usb_device_id em28xx_id_table[] = {
>   			.driver_info = EM2884_BOARD_PCTV_510E },
>   	{ USB_DEVICE(0x2013, 0x0251),
>   			.driver_info = EM2884_BOARD_PCTV_520E },
> +	{ USB_DEVICE(0x2013, 0x025e),
> +			.driver_info = EM2884_BOARD_PCTV_522E },
>   	{ USB_DEVICE(0x1b80, 0xe1cc),
>   			.driver_info = EM2874_BOARD_DELOCK_61959 },
>   	{ USB_DEVICE(0x1ae7, 0x9003),
> diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
> index a0a669e..fd65825 100644
> --- a/drivers/media/usb/em28xx/em28xx-dvb.c
> +++ b/drivers/media/usb/em28xx/em28xx-dvb.c
> @@ -1298,6 +1298,7 @@ static int em28xx_dvb_init(struct em28xx *dev)
>   		break;
>   	case EM2884_BOARD_PCTV_510E:
>   	case EM2884_BOARD_PCTV_520E:
> +	case EM2884_BOARD_PCTV_522E:
>   		pctv_520e_init(dev);
>
>   		/* attach demodulator */
> diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
> index 32d8a4b..00c083e 100644
> --- a/drivers/media/usb/em28xx/em28xx.h
> +++ b/drivers/media/usb/em28xx/em28xx.h
> @@ -137,6 +137,7 @@
>   #define EM2874_BOARD_KWORLD_UB435Q_V2		  90
>   #define EM2765_BOARD_SPEEDLINK_VAD_LAPLACE	  91
>   #define EM28178_BOARD_PCTV_461E                   92
> +#define EM2884_BOARD_PCTV_522E			  93
>
>   /* Limits minimum and default number of buffers */
>   #define EM28XX_MIN_BUF 4
>


-- 
http://palosaari.fi/
