Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53130 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755479Ab2CTAMd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Mar 2012 20:12:33 -0400
Message-ID: <4F67CB6A.5030403@redhat.com>
Date: Mon, 19 Mar 2012 21:12:26 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Ivan Kalvachev <ikalvachev@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] em28xx: support for 2304:0242 PCTV QuatroStick (510e)
References: <CABA=pqfbzWV45e7RLVTzrnnr4LCDwQD2d3kdYw0hcehSo3VCuQ@mail.gmail.com>
In-Reply-To: <CABA=pqfbzWV45e7RLVTzrnnr4LCDwQD2d3kdYw0hcehSo3VCuQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 19-03-2012 20:09, Ivan Kalvachev escreveu:
> This patch should be applied after the
> "PATCH 2/2] em28xx: support for 2013:0251 PCTV QuatroStick nano
> (520e)" patchset.
> 
> It is mostly copy/paste of the 520e code with setting GPIO7 removed
> (no LED light).
> 
> I've worked on just released vanilla linux-3.3.0 kernel, so there may
> be 1/2 lines offset to the internal working source, but most of the
> code should apply cleanly.
> 
> I was able to get the DVB-C working (tuned and watched TV). Haven't
> tested DVB-T (no signal atm).
> 
> Here is a log of the `dmsg` when detecting my device.
> 
> [ 1197.735520] em28xx: New device Pinnacle Systems PCTV 510e @ 480
> Mbps (2304:0242, interface 0, class 0)
> [ 1197.735525] em28xx: Audio Vendor Class interface 0 found
> [ 1197.735527] em28xx: Video interface 0 found
> [ 1197.735530] em28xx: DVB interface 0 found
> [ 1197.735588] em28xx #0: chip ID is em2884
> [ 1198.030970] em28xx #0: Identified as PCTV QuatroStick (510e) (card=85)
> [ 1198.053727] Registered IR keymap rc-pinnacle-pctv-hd
> [ 1198.053829] input: em28xx IR (em28xx #0) as
> /devices/pci0000:00/0000:00:1a.7/usb1/1-4/rc/rc0/input10
> [ 1198.053933] rc0: em28xx IR (em28xx #0) as
> /devices/pci0000:00/0000:00:1a.7/usb1/1-4/rc/rc0
> [ 1198.054591] em28xx #0: Config register raw data: 0xb7
> [ 1198.054595] em28xx #0: I2S Audio (5 sample rates)
> [ 1198.054598] em28xx #0: No AC97 audio processor
> [ 1198.071627] em28xx #0: v4l2 driver version 0.1.3
> [ 1198.093354] em28xx #0: V4L2 video device registered as video1
> [ 1198.093382] usbcore: registered new interface driver em28xx
> [ 1198.097021] em28xx-audio.c: probing for em28xx Audio Vendor Class
> [ 1198.097026] em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
> [ 1198.097028] em28xx-audio.c: Copyright (C) 2007-2011 Mauro Carvalho Chehab
> [ 1198.097721] Em28xx: Initialized (Em28xx Audio Extension) extension
> [ 1198.116227] drxk: status = 0x039260d9
> [ 1198.116233] drxk: detected a drx-3926k, spin A1, xtal 20.250 MHz
> [ 1199.570712] DRXK driver version 0.9.4300
> [ 1199.585694] drxk: frontend initialized.
> [ 1199.588100] tda18271 2-0060: creating new instance
> [ 1199.597682] TDA18271HD/C2 detected @ 2-0060
> [ 1199.935489] DVB: registering new adapter (em28xx #0)
> [ 1199.935495] DVB: registering adapter 0 frontend 0 (DRXK DVB-C DVB-T)...
> [ 1199.936048] em28xx #0: Successfully loaded em28xx-dvb
> [ 1199.936054] Em28xx: Initialized (Em28xx dvb Extension) extension
> 
> 
> Special thanks to everybody who worked on the code and to Antti
> Palosaari and Devin Heitmueller who provided essential support on irc.
> 
> Best Regards
>    Ivan Kalvachev
> iive
> 
> 
> pctv510e.patch

Please send your Signed-off-by:. This is a requirement for us to merge it upstream.

Thanks!
Mauro
> 
> 
> diff -urdp em28xx.org/em28xx-cards.c em28xx/em28xx-cards.c
> --- a/drivers/media/video/em28xx/em28xx-cards.c	2012-03-20 00:15:11.463410017 +0200
> +++ b/drivers/media/video/em28xx/em28xx-cards.c	2012-03-20 00:21:48.974379246 +0200
> @@ -364,6 +364,19 @@ static struct em28xx_reg_seq maxmedia_ub
>  	{-1,                 -1,    -1,   -1},
>  };
>  
> +/* 2304:0242 PCTV QuatroStick (510e)
> + * GPIO_2: decoder reset, 0=active
> + * GPIO_4: decoder suspend, 0=active
> + * GPIO_6: demod reset, 0=active
> + * GPIO_7: LED, 1=active
> + */
> +static struct em28xx_reg_seq pctv_510e[] = {
> +	{EM2874_R80_GPIO, 0x10, 0xff, 100},
> +	{EM2874_R80_GPIO, 0x14, 0xff, 100}, /* GPIO_2 = 1 */
> +	{EM2874_R80_GPIO, 0x54, 0xff, 050}, /* GPIO_6 = 1 */
> +	{             -1,   -1,   -1,  -1},
> +};
> +
>  /* 2013:0251 PCTV QuatroStick nano (520e)
>   * GPIO_2: decoder reset, 0=active
>   * GPIO_4: decoder suspend, 0=active
> @@ -1944,6 +1957,18 @@ struct em28xx_board em28xx_boards[] = {
>  				EM28XX_I2C_CLK_WAIT_ENABLE |
>  				EM28XX_I2C_FREQ_400_KHZ,
>  	},
> +	/* 2304:0242 PCTV QuatroStick (510e)
> +	 * Empia EM2884 + Micronas DRX 3926K + NXP TDA18271HDC2 */
> +	[EM2884_BOARD_PCTV_510E] = {
> +		.name          = "PCTV QuatroStick (510e)",
> +		.tuner_type    = TUNER_ABSENT,
> +		.tuner_gpio    = pctv_510e,
> +		.has_dvb       = 1,
> +		.ir_codes      = RC_MAP_PINNACLE_PCTV_HD,
> +		.i2c_speed     = EM2874_I2C_SECONDARY_BUS_SELECT |
> +				EM28XX_I2C_CLK_WAIT_ENABLE |
> +				EM28XX_I2C_FREQ_400_KHZ,
> +	},
>  	/* 2013:0251 PCTV QuatroStick nano (520e)
>  	 * Empia EM2884 + Micronas DRX 3926K + NXP TDA18271HDC2 */
>  	[EM2884_BOARD_PCTV_520E] = {
> @@ -2109,6 +2134,8 @@ struct usb_device_id em28xx_id_table[] =
>  			.driver_info = EM2860_BOARD_EASYCAP },
>  	{ USB_DEVICE(0x1b80, 0xe425),
>  			.driver_info = EM2874_BOARD_MAXMEDIA_UB425_TC },
> +	{ USB_DEVICE(0x2304, 0x0242),
> +			.driver_info = EM2884_BOARD_PCTV_510E },
>  	{ USB_DEVICE(0x2013, 0x0251),
>  			.driver_info = EM2884_BOARD_PCTV_520E },
>  	{ },
> diff -urdp em28xx.org/em28xx-dvb.c em28xx/em28xx-dvb.c
> --- a/drivers/media/video/em28xx/em28xx-dvb.c	2012-03-20 00:15:11.462410022 +0200
> +++ b/drivers/media/video/em28xx/em28xx-dvb.c	2012-03-19 21:38:36.533292904 +0200
> @@ -333,6 +333,13 @@ struct drxk_config maxmedia_ub425_tc_drx
>  	.no_i2c_bridge = 1,
>  };
>  
> +struct drxk_config pctv_520e_drxk = {
> +	.adr = 0x29,
> +	.single_master = 1,
> +	.microcode_name = "dvb-demod-drxk-pctv.fw",
> +	.chunk_size = 58,
> +};
> +
>  static int drxk_gate_ctrl(struct dvb_frontend *fe, int enable)
>  {
>  	struct em28xx_dvb *dvb = fe->sec_priv;
> @@ -466,6 +473,33 @@ static void terratec_h5_init(struct em28
>  	em28xx_gpio_set(dev, terratec_h5_end);
>  };
>  
> +static void pctv_520e_init(struct em28xx *dev)
> +{
> +	/*
> +	 * Init TDA8295(?) analog demodulator. Looks like I2C traffic to
> +	 * digital demodulator and tuner are routed via TDA8295.
> +	 */
> +	int i;
> +	struct {
> +		unsigned char r[4];
> +		int len;
> +	} regs[] = {
> +		{{ 0x06, 0x02, 0x00, 0x31 }, 4},
> +		{{ 0x01, 0x02 }, 2},
> +		{{ 0x01, 0x02, 0x00, 0xc6 }, 4},
> +		{{ 0x01, 0x00 }, 2},
> +		{{ 0x01, 0x00, 0xff, 0xaf }, 4},
> +		{{ 0x01, 0x00, 0x03, 0xa0 }, 4},
> +		{{ 0x01, 0x00 }, 2},
> +		{{ 0x01, 0x00, 0x73, 0xaf }, 4},
> +	};
> +
> +	dev->i2c_client.addr = 0x82 >> 1; /* 0x41 */
> +
> +	for (i = 0; i < ARRAY_SIZE(regs); i++)
> +		i2c_master_send(&dev->i2c_client, regs[i].r, regs[i].len);
> +};
> +
>  static int em28xx_mt352_terratec_xs_init(struct dvb_frontend *fe)
>  {
>  	/* Values extracted from a USB trace of the Terratec Windows driver */
> @@ -967,6 +1001,25 @@ static int em28xx_dvb_init(struct em28xx
>  				"driver version\n");
>  
>  		break;
> +	case EM2884_BOARD_PCTV_510E:
> +	case EM2884_BOARD_PCTV_520E:
> +		pctv_520e_init(dev);
> +
> +		/* attach demodulator */
> +		dvb->fe[0] = dvb_attach(drxk_attach, &pctv_520e_drxk,
> +				&dev->i2c_adap);
> +
> +		if (dvb->fe[0]) {
> +			/* attach tuner */
> +			if (!dvb_attach(tda18271_attach, dvb->fe[0], 0x60,
> +					&dev->i2c_adap,
> +					&em28xx_cxd2820r_tda18271_config)) {
> +				dvb_frontend_detach(dvb->fe[0]);
> +				result = -EINVAL;
> +				goto out_free;
> +			}
> +		}
> +		break;
>  	default:
>  		em28xx_errdev("/2: The frontend of your DVB/ATSC card"
>  				" isn't supported yet\n");
> diff -urdp em28xx.org/em28xx.h em28xx/em28xx.h
> --- a/drivers/media/video/em28xx/em28xx.h	2012-03-20 00:15:11.463410017 +0200
> +++ b/drivers/media/video/em28xx/em28xx.h	2012-03-19 21:34:37.089311437 +0200
> @@ -126,7 +126,8 @@
>  #define EM2884_BOARD_CINERGY_HTC_STICK		  82
>  #define EM2860_BOARD_HT_VIDBOX_NW03 		  83
>  #define EM2874_BOARD_MAXMEDIA_UB425_TC            84
> -#define EM2884_BOARD_PCTV_520E                    85
> +#define EM2884_BOARD_PCTV_510E                    85
> +#define EM2884_BOARD_PCTV_520E                    86
>  
>  /* Limits minimum and default number of buffers */
>  #define EM28XX_MIN_BUF 4
> 

