Return-path: <mchehab@gaivota>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:46722 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755499Ab0J3TQW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 30 Oct 2010 15:16:22 -0400
Subject: Re: [PATCH] Patch for cx18 module with added support of GoTView
 PCI DVD3 Hybrid tuner
From: Andy Walls <awalls@md.metrocast.net>
To: Alexey Chernov <4ernov@gmail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <201010302225.00535.4ernov@gmail.com>
References: <201010290112.02949.4ernov@gmail.com>
	 <1288457186.2062.23.camel@morgan.silverblock.net>
	 <201010302225.00535.4ernov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 30 Oct 2010 15:16:48 -0400
Message-ID: <1288466208.2073.15.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Sat, 2010-10-30 at 22:25 +0400, Alexey Chernov wrote:
> Hi, Andy,
> 
> On Saturday 30 October 2010 20:46:26 Andy Walls wrote:
 
> > Does this card have an EEPROM?  I couldn't tell from pictures on the
> > internet.  (Maybe one of the chips designated U2, SU3, or SU1 is an
> > EEPROM.)

> > Do you happen to know the part number of the EEPROM chip?
> > Does the current EEPROM dump, when initializing the GoTView card,
> > output anything interesting, or is it all "0xff"?
> 
> yes, it does. I've got full EEPROM dump of it from support and also it
> is printed during initialization. Here's the output of dmesg
> concerning the card:

OK.  Thanks.  I don't think you need to bother GoTView about a part
number if things are working and the EERPOM didn't get erased yet. ;)

I've even managed to decode some of the EEPROM data:

> cx18:  Start initialization, version 1.4.0
> cx18-0: Initializing card 0
> cx18-0: Autodetected GoTView PCI DVD3 Hybrid card
> cx18-0: cx23418 revision 01010000 (B)
> cx18-0: eeprom dump:
> cx18-0: eeprom 00: 56 54 58 43 33 ff ff ff ff ff ff ff ff ff ff ff
                        ^^^^^^^^^^^
PCI Subsystem Vendor/Device ID (just like the MPC-718)

> cx18-0: eeprom 10: 5a 00 55 aa 9a a9 60 03 00 1b 88 10 00 00 00 00
> cx18-0: eeprom 20: 02 00 00 01 00 00 00 00 ff ff ff ff ff ff ff ff
> cx18-0: eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> cx18-0: eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> cx18-0: eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> cx18-0: eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> cx18-0: eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> cx18-0: eeprom 80: 47 4f 54 56 49 45 57 20 50 52 4f 20 44 56 44 33
                     G  O  T  V  I  E  W     P  R  O     D  V  D  3   

> cx18-0: eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> cx18-0: eeprom a0: 79 02 95 20 25 80 79 03 95 20 55 80 83 82 26 69
> cx18-0: eeprom b0: 30 80 ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> cx18-0: eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> cx18-0: eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> cx18-0: eeprom e0: 45 45 50 52 4f 4d 20 47 6f 54 56 69 65 77 20 50
                     E  E  P  R  O  M     G  o  T  V  i  e  w     P

> cx18-0: eeprom f0: 52 4f 00 76 34 2e 30 ff ff ff ff ff ff ff ff ff
                     R  O     v  4  .  0

> cx18-0: eeprom PCI ID: 5854:3343

> The EEPROM dump seems to match one that I received from Gotview
> support so it appears to be correct. As for part number, I think I can
> ask Gotview support for it on Monday.

I agree, the EEPROM data appears to be correct.  We probably don't need
to know the part number.




> Ok, thank you for suggestion, did it (new patch below).


> Several comments on the patch:
> 1. Both users on the official Gotview forum and support said that PCI DVD3 is very similar to Yuan MPC718 card so the main part of code is taken from Yuan configuration. Some users reported it to work properly.
> 2. Everything is being initialized correctly including analog, dvb, radio and alsa parts. Analogue part and alsa virtual card is tested by myself using original Gotview card.
> 3. Thanks to GoTView for providing information about the card.
> 
> Signed-off-by: Alexey Chernov <4ernov@gmail.com>

Looks good.

Tested-by: Alexey Chernov <4ernov@gmail.com>
Reviewed-by: Andy Walls <awalls@md.metrocast.net>
Signed-off-by: Andy Walls <awalls@md.metrocast.net>

Regards,
Andy

> diff -uprB v4l-dvb.orig/drivers/media/video/cx18/cx18-cards.c v4l-dvb/drivers/media/video/cx18/cx18-cards.c
> --- v4l-dvb.orig/drivers/media/video/cx18/cx18-cards.c	2010-10-28 22:04:11.000000000 +0400
> +++ v4l-dvb/drivers/media/video/cx18/cx18-cards.c	2010-10-30 22:12:50.000000000 +0400
> @@ -251,6 +251,66 @@ static const struct cx18_card cx18_card_
>  
>  /* ------------------------------------------------------------------------- */
>  
> +/* GoTView PCI */
> +
> +static const struct cx18_card_pci_info cx18_pci_gotview_dvd3[] = {
> +	{ PCI_DEVICE_ID_CX23418, CX18_PCI_ID_GOTVIEW, 0x3343 },
> +	{ 0, 0, 0 }
> +};
> +
> +static const struct cx18_card cx18_card_gotview_dvd3 = {
> +	.type = CX18_CARD_GOTVIEW_PCI_DVD3,
> +	.name = "GoTView PCI DVD3 Hybrid",
> +	.comment = "Experimenters needed for device to work well.\n"
> +		  "\tTo help, mail the ivtv-devel list (www.ivtvdriver.org).\n",
> +	.v4l2_capabilities = CX18_CAP_ENCODER,
> +	.hw_audio_ctrl = CX18_HW_418_AV,
> +	.hw_muxer = CX18_HW_GPIO_MUX,
> +	.hw_all = CX18_HW_TVEEPROM | CX18_HW_418_AV | CX18_HW_TUNER |
> +		  CX18_HW_GPIO_MUX | CX18_HW_DVB | CX18_HW_GPIO_RESET_CTRL,
> +	.video_inputs = {
> +		{ CX18_CARD_INPUT_VID_TUNER,  0, CX18_AV_COMPOSITE2 },
> +		{ CX18_CARD_INPUT_SVIDEO1,    1,
> +				CX18_AV_SVIDEO_LUMA3 | CX18_AV_SVIDEO_CHROMA4 },
> +		{ CX18_CARD_INPUT_COMPOSITE1, 1, CX18_AV_COMPOSITE1 },
> +		{ CX18_CARD_INPUT_SVIDEO2,    2,
> +				CX18_AV_SVIDEO_LUMA7 | CX18_AV_SVIDEO_CHROMA8 },
> +		{ CX18_CARD_INPUT_COMPOSITE2, 2, CX18_AV_COMPOSITE6 },
> +	},
> +	.audio_inputs = {
> +		{ CX18_CARD_INPUT_AUD_TUNER, CX18_AV_AUDIO5,        0 },
> +		{ CX18_CARD_INPUT_LINE_IN1,  CX18_AV_AUDIO_SERIAL1, 1 },
> +		{ CX18_CARD_INPUT_LINE_IN2,  CX18_AV_AUDIO_SERIAL2, 1 },
> +	},
> +	.tuners = {
> +		/* XC3028 tuner */
> +		{ .std = V4L2_STD_ALL, .tuner = TUNER_XC2028 },
> +	},
> +	/* FIXME - the FM radio is just a guess and driver doesn't use SIF */
> +	.radio_input = { CX18_CARD_INPUT_AUD_TUNER, CX18_AV_AUDIO5, 2 },
> +	.ddr = {
> +		/* Hynix HY5DU283222B DDR RAM */
> +		.chip_config = 0x303,
> +		.refresh = 0x3bd,
> +		.timing1 = 0x36320966,
> +		.timing2 = 0x1f,
> +		.tune_lane = 0,
> +		.initial_emrs = 2,
> +	},
> +	.gpio_init.initial_value = 0x1,
> +	.gpio_init.direction = 0x3,
> +	
> +	.gpio_audio_input = { .mask   = 0x3,
> +			      .tuner  = 0x1,
> +			      .linein = 0x2,
> +			      .radio  = 0x1 },
> +	.xceive_pin = 0,
> +	.pci_list = cx18_pci_gotview_dvd3,
> +	.i2c = &cx18_i2c_std,
> +};
> +
> +/* ------------------------------------------------------------------------- */
> +
>  /* Conexant Raptor PAL/SECAM: note that this card is analog only! */
>  
>  static const struct cx18_card_pci_info cx18_pci_cnxt_raptor_pal[] = {
> @@ -463,6 +523,7 @@ static const struct cx18_card *cx18_card
>  	&cx18_card_toshiba_qosmio_dvbt,
>  	&cx18_card_leadtek_pvr2100,
>  	&cx18_card_leadtek_dvr3100h,
> +	&cx18_card_gotview_dvd3
>  };
>  
>  const struct cx18_card *cx18_get_card(u16 index)
> diff -uprB v4l-dvb.orig/drivers/media/video/cx18/cx18-driver.c v4l-dvb/drivers/media/video/cx18/cx18-driver.c
> --- v4l-dvb.orig/drivers/media/video/cx18/cx18-driver.c	2010-10-28 22:04:11.000000000 +0400
> +++ v4l-dvb/drivers/media/video/cx18/cx18-driver.c	2010-10-30 22:14:03.000000000 +0400
> @@ -156,6 +156,7 @@ MODULE_PARM_DESC(cardtype,
>  		 "\t\t\t 6 = Toshiba Qosmio DVB-T/Analog\n"
>  		 "\t\t\t 7 = Leadtek WinFast PVR2100\n"
>  		 "\t\t\t 8 = Leadtek WinFast DVR3100 H\n"
> +		 "\t\t\t 9 = GoTView PCI DVD3 Hybrid\n"
>  		 "\t\t\t 0 = Autodetect (default)\n"
>  		 "\t\t\t-1 = Ignore this card\n\t\t");
>  MODULE_PARM_DESC(pal, "Set PAL standard: B, G, H, D, K, I, M, N, Nc, 60");
> @@ -338,6 +339,12 @@ void cx18_read_eeprom(struct cx18 *cx, s
>  		CX18_INFO("eeprom PCI ID: %02x%02x:%02x%02x\n",
>  			  eedata[2], eedata[1], eedata[4], eedata[3]);
>  		break;
> +	case CX18_CARD_GOTVIEW_PCI_DVD3:
> +		tv->model = 0x3343;
> +		cx18_eeprom_dump(cx, eedata, sizeof(eedata));
> +		CX18_INFO("eeprom PCI ID: %02x%02x:%02x%02x\n",
> +			  eedata[2], eedata[1], eedata[4], eedata[3]);
> +		break;
>  	default:
>  		tv->model = 0xffffffff;
>  		cx18_eeprom_dump(cx, eedata, sizeof(eedata));
> @@ -362,6 +369,8 @@ static void cx18_process_eeprom(struct c
>  		break;
>  	case 0x718:
>  		return;
> +	case 0x3343:
> +		return;
>  	case 0xffffffff:
>  		CX18_INFO("Unknown EEPROM encoding\n");
>  		return;
> diff -uprB v4l-dvb.orig/drivers/media/video/cx18/cx18-driver.h v4l-dvb/drivers/media/video/cx18/cx18-driver.h
> --- v4l-dvb.orig/drivers/media/video/cx18/cx18-driver.h	2010-10-28 22:04:11.000000000 +0400
> +++ v4l-dvb/drivers/media/video/cx18/cx18-driver.h	2010-10-30 22:12:50.000000000 +0400
> @@ -84,7 +84,8 @@
>  #define CX18_CARD_TOSHIBA_QOSMIO_DVBT 5 /* Toshiba Qosmio Interal DVB-T/Analog*/
>  #define CX18_CARD_LEADTEK_PVR2100     6 /* Leadtek WinFast PVR2100 */
>  #define CX18_CARD_LEADTEK_DVR3100H    7 /* Leadtek WinFast DVR3100 H */
> -#define CX18_CARD_LAST 		      7
> +#define CX18_CARD_GOTVIEW_PCI_DVD3    8 /* GoTView PCI DVD3 Hybrid */
> +#define CX18_CARD_LAST 		      8
>  
>  #define CX18_ENC_STREAM_TYPE_MPG  0
>  #define CX18_ENC_STREAM_TYPE_TS   1
> @@ -106,6 +107,7 @@
>  #define CX18_PCI_ID_CONEXANT		0x14f1
>  #define CX18_PCI_ID_TOSHIBA		0x1179
>  #define CX18_PCI_ID_LEADTEK		0x107D
> +#define CX18_PCI_ID_GOTVIEW 		0x5854
>  
>  /* ======================================================================== */
>  /* ========================== START USER SETTABLE DMA VARIABLES =========== */
> diff -uprB v4l-dvb.orig/drivers/media/video/cx18/cx18-dvb.c v4l-dvb/drivers/media/video/cx18/cx18-dvb.c
> --- v4l-dvb.orig/drivers/media/video/cx18/cx18-dvb.c	2010-10-28 22:04:11.000000000 +0400
> +++ v4l-dvb/drivers/media/video/cx18/cx18-dvb.c	2010-10-30 22:18:45.000000000 +0400
> @@ -203,6 +203,14 @@ static struct zl10353_config yuan_mpc718
>  	.disable_i2c_gate_ctrl = 1,         /* Disable the I2C gate */
>  };
>  
> +static struct zl10353_config gotview_dvd3_zl10353_demod = {
> +	.demod_address         = 0x1e >> 1, /* Datasheet suggested straps */
> +	.if2                   = 45600,     /* 4.560 MHz IF from the XC3028 */
> +	.parallel_ts           = 1,         /* Not a serial TS */
> +	.no_tuner              = 1,         /* XC3028 is not behind the gate */
> +	.disable_i2c_gate_ctrl = 1,         /* Disable the I2C gate */
> +};
> +
>  static int dvb_register(struct cx18_stream *stream);
>  
>  /* Kernel DVB framework calls this when the feed needs to start.
> @@ -247,6 +255,7 @@ static int cx18_dvb_start_feed(struct dv
>  
>  	case CX18_CARD_LEADTEK_DVR3100H:
>  	case CX18_CARD_YUAN_MPC718:
> +	case CX18_CARD_GOTVIEW_PCI_DVD3:
>  	default:
>  		/* Assumption - Parallel transport - Signalling
>  		 * undefined or default.
> @@ -495,6 +504,29 @@ static int dvb_register(struct cx18_stre
>  				fe->ops.tuner_ops.set_config(fe, &ctrl);
>  		}
>  		break;
> +	case CX18_CARD_GOTVIEW_PCI_DVD3:
> +		dvb->fe = dvb_attach(zl10353_attach,
> +				     &gotview_dvd3_zl10353_demod,
> +				     &cx->i2c_adap[1]);
> +		if (dvb->fe != NULL) {
> +			struct dvb_frontend *fe;
> +			struct xc2028_config cfg = {
> +				.i2c_adap = &cx->i2c_adap[1],
> +				.i2c_addr = 0xc2 >> 1,
> +				.ctrl = NULL,
> +			};
> +			static struct xc2028_ctrl ctrl = {
> +				.fname   = XC2028_DEFAULT_FIRMWARE,
> +				.max_len = 64,
> +				.demod   = XC3028_FE_ZARLINK456,
> +				.type    = XC2028_AUTO,
> +			};
> +
> +			fe = dvb_attach(xc2028_attach, dvb->fe, &cfg);
> +			if (fe != NULL && fe->ops.tuner_ops.set_config != NULL)
> +				fe->ops.tuner_ops.set_config(fe, &ctrl);
> +		}
> +		break;
>  	default:
>  		/* No Digital Tv Support */
>  		break;
> 


