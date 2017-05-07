Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33437 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755268AbdEGVvK (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 7 May 2017 17:51:10 -0400
Subject: Re: [PATCH v3 2/2] em28xx: add support for new of Terratec H6
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
References: <cover.1493776983.git.mchehab@s-opensource.com>
 <33242eedb39ecb4a3fd9d28a6d0b7d8dd1716557.1493776983.git.mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
From: =?UTF-8?Q?Frank_Sch=c3=a4fer?= <fschaefer.oss@googlemail.com>
Message-ID: <7effd9bf-6a00-2d5b-1b5c-d5e36763e33a@googlemail.com>
Date: Sun, 7 May 2017 20:02:27 +0200
MIME-Version: 1.0
In-Reply-To: <33242eedb39ecb4a3fd9d28a6d0b7d8dd1716557.1493776983.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am 03.05.2017 um 04:12 schrieb Mauro Carvalho Chehab:
> There's a new version of Terratec H6 with uses USB ID
> 0ccd:10b2. This version is similar to the old one (with is
> supported via the HTC entry), except that this one has the
> eeprom on the second bus.
Last half of the sentence isn't true (leftover from v1).

> On this board, one side of this board is labeled with:
> 	dvbc v2.0
> The other side with:
> 	94V-0, MO2, RK-4221 with huge digits: 1107
>
> With those patches, the board is properly detected:
>
>     em28xx 1-1.5:1.0: New device TERRATEC TERRATCE H5 MKII @ 480 Mbps (0ccd:10b2, interface 0, class 0)
>     em28xx 1-1.5:1.0: Audio interface 0 found (Vendor Class)
>     em28xx 1-1.5:1.0: Video interface 0 found: isoc
>     em28xx 1-1.5:1.0: DVB interface 0 found: isoc
>     em28xx 1-1.5:1.0: chip ID is em2884
>     em28xx eeprom 00000000: 26 00 00 00 02 0b 0f e5 f5 64 01 60 09 e5 f5 64  &........d.`...d
>     em28xx eeprom 00000010: 09 60 03 c2 c6 22 e5 f7 b4 03 13 e5 f6 b4 87 03  .`..."..........
>     em28xx eeprom 00000020: 02 0a b9 e5 f6 b4 93 03 02 09 46 c2 c6 22 c2 c6  ..........F.."..
>     em28xx eeprom 00000030: 22 00 60 00 ef 70 08 85 3d 82 85 3c 83 93 ff ef  ".`..p..=..<....
>     em28xx eeprom 00000040: 60 19 85 3d 82 85 3c 83 e4 93 12 07 a3 12 0a fe  `..=..<.........
>     em28xx eeprom 00000050: 05 3d e5 3d 70 02 05 3c 1f 80 e4 22 12 0b 06 02  .=.=p..<..."....
>     em28xx eeprom 00000060: 07 e2 01 00 1a eb 67 95 cd 0c b2 10 f0 13 6b 03  ......g.......k.
>     em28xx eeprom 00000070: 98 22 6a 1c 86 12 27 57 4e 16 29 00 60 00 00 00  ."j...'WN.).`...
>     em28xx eeprom 00000080: 02 00 00 00 5e 00 13 00 f0 10 44 82 82 00 00 00  ....^.....D.....
>     em28xx eeprom 00000090: 5b 81 c0 00 00 00 20 40 20 80 02 20 10 01 00 00  [..... @ .. ....
>     em28xx eeprom 000000a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     em28xx eeprom 000000b0: c6 40 00 00 81 00 00 00 00 00 00 00 00 c4 00 00  .@..............
>     em28xx eeprom 000000c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 1c 03  ................
>     em28xx eeprom 000000d0: 31 00 32 00 33 00 34 00 35 00 36 00 37 00 38 00  1.2.3.4.5.6.7.8.
>     em28xx eeprom 000000e0: 39 00 41 00 42 00 43 00 44 00 12 03 54 00 45 00  9.A.B.C.D...T.E.
>     em28xx eeprom 000000f0: 52 00 52 00 41 00 54 00 45 00 43 00 22 03 54 00  R.R.A.T.E.C.".T.
Ok, so the eeprom issue seems to be gone.

>     em28xx 1-1.5:1.0: eeprom 000100: ... (skipped)
>     em28xx 1-1.5:1.0: EEPROM ID = 26 00 00 00, EEPROM hash = 0xbcd5a8cf
>     em28xx 1-1.5:1.0: EEPROM info:
>     em28xx 1-1.5:1.0:	microcode start address = 0x0004, boot configuration = 0x00
>     em28xx 1-1.5:1.0:	I2S audio, 5 sample rates
>     em28xx 1-1.5:1.0:	500mA max power
>     em28xx 1-1.5:1.0:	Table at offset 0x27, strings=0x2298, 0x1c6a, 0x1286
>     em28xx 1-1.5:1.0: Identified as Terratec Cinergy H6 rev. 2 (card=101)
>     em28xx 1-1.5:1.0: Currently, V4L2 is not supported on this model
>     em28xx 1-1.5:1.0: dvb set to isoc mode.
>     usbcore: registered new interface driver em28xx
>     em28xx 1-1.5:1.0: Binding audio extension
>     em28xx 1-1.5:1.0: em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
>     em28xx 1-1.5:1.0: em28xx-audio.c: Copyright (C) 2007-2016 Mauro Carvalho Chehab
>     em28xx 1-1.5:1.0: Endpoint 0x83 high-speed on intf 0 alt 7 interval = 8, size 196
>     em28xx 1-1.5:1.0: Number of URBs: 1, with 64 packets and 192 size
>     em28xx 1-1.5:1.0: Audio extension successfully initialized
>     em28xx: Registered (Em28xx Audio Extension) extension
>     em28xx 1-1.5:1.0: Binding DVB extension
>     drxk: status = 0x639260d9
>     drxk: detected a drx-3926k, spin A3, xtal 20.250 MHz
>     drxk: DRXK driver version 0.9.4300
>     drxk: frontend initialized.
>     tda18271 4-0060: creating new instance
>     tda18271: TDA18271HD/C2 detected @ 4-0060
This confirms that the tuner is a tda18271, hence...

>     dvbdev: DVB: registering new adapter (1-1.5:1.0)
>     em28xx 1-1.5:1.0: DVB: registering adapter 0 frontend 0 (DRXK DVB-C DVB-T)...
>     dvbdev: dvb_create_media_entity: media entity 'DRXK DVB-C DVB-T' registered.
>     dvbdev: dvb_create_media_entity: media entity 'dvb-demux' registered.
>     em28xx 1-1.5:1.0: DVB extension successfully initialized
>     em28xx: Registered (Em28xx dvb Extension) extension
>     em28xx 1-1.5:1.0: Registering input extension
>     rc rc0: 1-1.5:1.0 IR as /devices/platform/soc/3f980000.usb/usb1/1-1/1-1.5/1-1.5:1.0/rc/rc0
>     Registered IR keymap rc-nec-terratec-cinergy-xs
>     input: 1-1.5:1.0 IR as /devices/platform/soc/3f980000.usb/usb1/1-1/1-1.5/1-1.5:1.0/rc/rc0/input0
>     em28xx 1-1.5:1.0: Input extension successfully initalized
>     em28xx: Registered (Em28xx Input Extension) extension
>     tda18271: performing RF tracking filter calibration
>     tda18271: RF tracking filter calibration complete
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  drivers/media/usb/em28xx/em28xx-cards.c | 18 ++++++++++++++++++
>  drivers/media/usb/em28xx/em28xx-dvb.c   |  1 +
>  drivers/media/usb/em28xx/em28xx.h       |  1 +
>  3 files changed, 20 insertions(+)
>
> diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
> index a12b599a1fa2..25e952b176ae 100644
> --- a/drivers/media/usb/em28xx/em28xx-cards.c
> +++ b/drivers/media/usb/em28xx/em28xx-cards.c
> @@ -1193,6 +1193,22 @@ struct em28xx_board em28xx_boards[] = {
>  		.i2c_speed    = EM28XX_I2C_CLK_WAIT_ENABLE |
>  				EM28XX_I2C_FREQ_400_KHZ,
>  	},
> +	[EM2884_BOARD_TERRATEC_H6] = {
> +		.name         = "Terratec Cinergy H6 rev. 2",
> +		.has_dvb      = 1,
> +		.ir_codes     = RC_MAP_NEC_TERRATEC_CINERGY_XS,
> +#if 0
> +		.tuner_type   = TUNER_PHILIPS_TDA8290,
> +		.tuner_addr   = 0x41,
> +		.dvb_gpio     = terratec_h5_digital, /* FIXME: probably wrong */
> +		.tuner_gpio   = terratec_h5_gpio,
> +#else
> +		.tuner_type   = TUNER_ABSENT,
> +#endif
...this can be simplified at least to

#if 0
        .dvb_gpio     = terratec_h5_digital, /* FIXME: probably wrong */
        .tuner_gpio   = terratec_h5_gpio,
#endif
        .tuner_type   = TUNER_ABSENT,    /* Digital-only TDA18271HD */

Getting the device tested completely would of course be preferable.

> +		.def_i2c_bus  = 1,
> +		.i2c_speed    = EM28XX_I2C_CLK_WAIT_ENABLE |
> +				EM28XX_I2C_FREQ_400_KHZ,
Hmm... that might explain why eeprom reading works now:
The initial test was made without any board data.
In that case the em28xx driver uses the default i2c speed of 100kHz.
The current timeout value EM28XX_I2C_XFER_TIMEOUT = 36ms might be enough
when running at 400kHz, but not when running at 100kHz.


Regards,
Frank

> +	},
>  	[EM2884_BOARD_HAUPPAUGE_WINTV_HVR_930C] = {
>  		.name         = "Hauppauge WinTV HVR 930C",
>  		.has_dvb      = 1,
> @@ -2496,6 +2512,8 @@ struct usb_device_id em28xx_id_table[] = {
>  			.driver_info = EM2884_BOARD_TERRATEC_H5 },
>  	{ USB_DEVICE(0x0ccd, 0x10b6),	/* H5 Rev. 3 */
>  			.driver_info = EM2884_BOARD_TERRATEC_H5 },
> +	{ USB_DEVICE(0x0ccd, 0x10b2),	/* H6 */
> +			.driver_info = EM2884_BOARD_TERRATEC_H6 },
>  	{ USB_DEVICE(0x0ccd, 0x0084),
>  			.driver_info = EM2860_BOARD_TERRATEC_AV350 },
>  	{ USB_DEVICE(0x0ccd, 0x0096),
> diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
> index 82edd37f0d73..4a7db623fe29 100644
> --- a/drivers/media/usb/em28xx/em28xx-dvb.c
> +++ b/drivers/media/usb/em28xx/em28xx-dvb.c
> @@ -1522,6 +1522,7 @@ static int em28xx_dvb_init(struct em28xx *dev)
>  		break;
>  	case EM2884_BOARD_ELGATO_EYETV_HYBRID_2008:
>  	case EM2884_BOARD_CINERGY_HTC_STICK:
> +	case EM2884_BOARD_TERRATEC_H6:
>  		terratec_htc_stick_init(dev);
>  
>  		/* attach demodulator */
> diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
> index e8d97d5ec161..88084f24f033 100644
> --- a/drivers/media/usb/em28xx/em28xx.h
> +++ b/drivers/media/usb/em28xx/em28xx.h
> @@ -148,6 +148,7 @@
>  #define EM28178_BOARD_PLEX_PX_BCUD                98
>  #define EM28174_BOARD_HAUPPAUGE_WINTV_DUALHD_DVB  99
>  #define EM28174_BOARD_HAUPPAUGE_WINTV_DUALHD_01595 100
> +#define EM2884_BOARD_TERRATEC_H6		  101
>  
>  /* Limits minimum and default number of buffers */
>  #define EM28XX_MIN_BUF 4
