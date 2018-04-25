Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:51340 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750969AbeDYJQZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Apr 2018 05:16:25 -0400
Date: Wed, 25 Apr 2018 06:16:20 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: mjs <mjstork@gmail.com>
Cc: "3 linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Add new dvb-t board ":Zolid Hybrid Tv Stick"
Message-ID: <20180425061620.19037894@vento.lan>
In-Reply-To: <5ae045df.ddf5500a.22ca5.10bb@mx.google.com>
References: <5ae045df.ddf5500a.22ca5.10bb@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 25 Apr 2018 11:09:50 +0200
mjs <mjstork@gmail.com> escreveu:

> From 0a3355b47dc465c6372d30fa4a36d1c5db6c0fe2 Mon Sep 17 00:00:00 2001
> From: Marcel Stork <mjstork@gmail.com>
> Date: Wed, 25 Apr 2018 10:53:34 +0200
> Subject: [PATCH] Add new dvb-t board ":Zolid Hybrid Tv Stick".
> 
> Extra code to be able to use this stick, only digital, not analog nor remote-control.
> 
> Changes to be committed:
> 	modified:   em28xx-cards.c
> 	modified:   em28xx-dvb.c
> 	modified:   em28xx.h

You forgot to add your Signed-off-by. That's mandatory for patches to
be acepted.

> 
> ---
>  em28xx-cards.c | 30 +++++++++++++++++++++++++++++-
>  em28xx-dvb.c   |  1 +
>  em28xx.h       |  1 +
>  3 files changed, 31 insertions(+), 1 deletion(-)


use git diff against upstream tree. This should be using
a different paths there, e.g. drivers/media/usb/em28xx/...

> 
> diff --git a/em28xx-cards.c b/em28xx-cards.c
> index 6e0e67d..01b38a4 100644
> --- a/em28xx-cards.c
> +++ b/em28xx-cards.c
> @@ -87,6 +87,21 @@ static const struct em28xx_reg_seq default_digital[] = {
>  	{	-1,		-1,	-1,		-1},
>  };
>  
> +/* Board Zolid Hybrid Tv Stick */
> +static struct em28xx_reg_seq zolid_tuner[] = {
> +	{EM2820_R08_GPIO_CTRL,		0xfd,		0xff,	100},
> +	{EM2820_R08_GPIO_CTRL,		0xfe,		0xff,	100},
> +	{		-1,					-1,			-1,		 -1},
> +};
> +
> +static struct em28xx_reg_seq zolid_digital[] = {
> +	{EM2820_R08_GPIO_CTRL,		0x6a,		0xff,	100},
> +	{EM2820_R08_GPIO_CTRL,		0x7a,		0xff,	100},
> +	{EM2880_R04_GPO,			0x04,		0xff,	100},
> +	{EM2880_R04_GPO,			0x0c,		0xff,	100},
> +	{	-1,						-1,			-1,		 -1},
> +};
> +
>  /* Board Hauppauge WinTV HVR 900 analog */
>  static const struct em28xx_reg_seq hauppauge_wintv_hvr_900_analog[] = {
>  	{EM2820_R08_GPIO_CTRL,	0x2d,	~EM_GPIO_4,	10},
> @@ -679,6 +694,16 @@ const struct em28xx_board em28xx_boards[] = {
>  			.amux     = EM28XX_AMUX_VIDEO,
>  		} },
>  	},
> +	[EM2882_BOARD_ZOLID_HYBRID_TV_STICK] = {
> +		.name			= ":ZOLID HYBRID TV STICK",
> +		.tuner_type		= TUNER_XC2028,
> +		.tuner_gpio		= zolid_tuner,
> +		.decoder		= EM28XX_TVP5150,
> +		.xclk			= EM28XX_XCLK_FREQUENCY_12MHZ,
> +		.mts_firmware	= 1,
> +		.has_dvb		= 1,
> +		.dvb_gpio		= zolid_digital,
> +	},
>  	[EM2820_BOARD_KWORLD_PVRTV2800RF] = {
>  		.name         = "Kworld PVR TV 2800 RF",
>  		.tuner_type   = TUNER_TEMIC_PAL,
> @@ -2493,7 +2518,7 @@ struct usb_device_id em28xx_id_table[] = {
>  			.driver_info = EM2820_BOARD_UNKNOWN },
>  	{ USB_DEVICE(0xeb1a, 0x2881),
>  			.driver_info = EM2820_BOARD_UNKNOWN },
> -	{ USB_DEVICE(0xeb1a, 0x2883),
> +	{ USB_DEVICE(0xeb1a, 0x2883), /* used by zolid hybrid tv stick */
>  			.driver_info = EM2820_BOARD_UNKNOWN },
>  	{ USB_DEVICE(0xeb1a, 0x2868),
>  			.driver_info = EM2820_BOARD_UNKNOWN },
> @@ -2688,6 +2713,7 @@ static const struct em28xx_hash_table em28xx_eeprom_hash[] = {
>  	{0xb8846b20, EM2881_BOARD_PINNACLE_HYBRID_PRO, TUNER_XC2028},
>  	{0x63f653bd, EM2870_BOARD_REDDO_DVB_C_USB_BOX, TUNER_ABSENT},
>  	{0x4e913442, EM2882_BOARD_DIKOM_DK300, TUNER_XC2028},
> +	{0x85dd871e, EM2882_BOARD_ZOLID_HYBRID_TV_STICK, TUNER_XC2028},
>  };
>  
>  /* I2C devicelist hash table for devices with generic USB IDs */
> @@ -2699,6 +2725,7 @@ static const struct em28xx_hash_table em28xx_i2c_hash[] = {
>  	{0xc51200e3, EM2820_BOARD_GADMEI_TVR200, TUNER_LG_PAL_NEW_TAPC},
>  	{0x4ba50080, EM2861_BOARD_GADMEI_UTV330PLUS, TUNER_TNF_5335MF},
>  	{0x6b800080, EM2874_BOARD_LEADERSHIP_ISDBT, TUNER_ABSENT},
> +	{0x27e10080, EM2882_BOARD_ZOLID_HYBRID_TV_STICK, TUNER_XC2028},
>  };
>  
>  /* NOTE: introduce a separate hash table for devices with 16 bit eeproms */
> @@ -3187,6 +3214,7 @@ void em28xx_setup_xc3028(struct em28xx *dev, struct xc2028_ctrl *ctl)
>  	case EM2880_BOARD_TERRATEC_HYBRID_XS:
>  	case EM2880_BOARD_TERRATEC_HYBRID_XS_FR:
>  	case EM2881_BOARD_PINNACLE_HYBRID_PRO:
> +	case EM2882_BOARD_ZOLID_HYBRID_TV_STICK:
>  		ctl->demod = XC3028_FE_ZARLINK456;
>  		break;
>  	case EM2880_BOARD_HAUPPAUGE_WINTV_HVR_900_R2:
> diff --git a/em28xx-dvb.c b/em28xx-dvb.c
> index ebe62ff..640eafe 100644
> --- a/em28xx-dvb.c
> +++ b/em28xx-dvb.c
> @@ -1488,6 +1488,7 @@ static int em28xx_dvb_init(struct em28xx *dev)
>  	case EM2880_BOARD_HAUPPAUGE_WINTV_HVR_900:
>  	case EM2882_BOARD_TERRATEC_HYBRID_XS:
>  	case EM2880_BOARD_EMPIRE_DUAL_TV:
> +	case EM2882_BOARD_ZOLID_HYBRID_TV_STICK:
>  		dvb->fe[0] = dvb_attach(zl10353_attach,
>  					&em28xx_zl10353_xc3028_no_i2c_gate,
>  					&dev->i2c_adap[dev->def_i2c_bus]);
> diff --git a/em28xx.h b/em28xx.h
> index 5fc70d9..37bb696 100644
> --- a/em28xx.h
> +++ b/em28xx.h
> @@ -146,6 +146,7 @@
>  #define EM28174_BOARD_HAUPPAUGE_WINTV_DUALHD_DVB  99
>  #define EM28174_BOARD_HAUPPAUGE_WINTV_DUALHD_01595 100
>  #define EM2884_BOARD_TERRATEC_H6		  101
> +#define EM2882_BOARD_ZOLID_HYBRID_TV_STICK		102
>  
>  /* Limits minimum and default number of buffers */
>  #define EM28XX_MIN_BUF 4



Thanks,
Mauro
