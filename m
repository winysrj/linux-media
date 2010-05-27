Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:39989 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754371Ab0E0RSx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 May 2010 13:18:53 -0400
Date: Thu, 27 May 2010 14:18:45 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Emard <davoremard@gmail.com>
Cc: linux-media@vger.kernel.org, semirocket@gmail.com
Subject: Re: [PATCH] Compro Videomate T750F Vista digital+analog support
Message-ID: <20100527141845.200ad4e3@pedra>
In-Reply-To: <20100509184822.GA6340@z60m>
References: <20100508160628.GA6050@z60m>
	<op.vceiu5q13xmt7q@crni>
	<AANLkTinMYcgG6Ac73Vgdx8NMYocW8Net6_-dMC3yEflQ@mail.gmail.com>
	<AANLkTikbpZ0LM5rK70abVuJS27j0lT7iZs12DrSKB9wI@mail.gmail.com>
	<op.vcfoxwnq3xmt7q@crni>
	<20100509173243.GA8227@z60m>
	<op.vcga9rw2ndeod6@crni>
	<20100509184822.GA6340@z60m>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 9 May 2010 20:48:22 +0200
Emard <davoremard@gmail.com> escreveu:

> Yes, almost everything:
> DVB-T, Analog TV, FM Radio, IR Remote control.
> 
> I haven't tested too much analog TV (it seems to work,
> receivers some snowy channels but I don't have good antenna).
> Also didn't test video inputs at all.
> 
> Not supported is onboard RTC timer that can wake up the 
> computer.
> 
> Here's a cleaned up patch
> -------------------------
> 
> --- linux-2.6.33.3/drivers/media/video/saa7134/saa7134-cards.c.orig	2010-05-08 16:13:28.000000000 +0200
> +++ linux-2.6.33.3/drivers/media/video/saa7134/saa7134-cards.c	2010-05-09 20:19:03.000000000 +0200
> @@ -4881,12 +4881,14 @@ struct saa7134_board saa7134_boards[] =
>  	},
>  	[SAA7134_BOARD_VIDEOMATE_T750] = {
>  		/* John Newbigin <jn@it.swin.edu.au> */
> +		/* Emard 2010-05-09 v16 <davoremard@gmail.com> */
>  		.name           = "Compro VideoMate T750",
>  		.audio_clock    = 0x00187de7,
>  		.tuner_type     = TUNER_XC2028,
>  		.radio_type     = UNSET,
> -		.tuner_addr	= ADDR_UNSET,
> +		.tuner_addr	= 0x61,
>  		.radio_addr	= ADDR_UNSET,
> +		.mpeg           = SAA7134_MPEG_DVB,
>  		.inputs = {{
>  			.name   = name_tv,
>  			.vmux   = 3,
> @@ -6550,6 +6552,11 @@ static int saa7134_xc2028_callback(struc
>  			msleep(10);
>  			saa7134_set_gpio(dev, 18, 1);
>  		break;
> +		case SAA7134_BOARD_VIDEOMATE_T750:
> +			saa7134_set_gpio(dev, 20, 0);
> +			msleep(10);
> +			saa7134_set_gpio(dev, 20, 1);
> +		break;
>  		}
>  	return 0;
>  	}
> @@ -6955,6 +6962,11 @@ int saa7134_board_init1(struct saa7134_d
>  		dev->has_remote = SAA7134_REMOTE_GPIO;
>  		saa_andorl(SAA7134_GPIO_GPMODE0 >> 2,   0x00008000, 0x00008000);
>  		saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x00008000, 0x00008000);
> +		break;
> +	case SAA7134_BOARD_VIDEOMATE_T750:
> +		dev->has_remote = SAA7134_REMOTE_GPIO;
> +		saa_andorl(SAA7134_GPIO_GPMODE0 >> 2,   0x00008000, 0x00008000);
> +		saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x00008000, 0x00008000);
>  		break;
>  	}
>  	return 0;
> --- linux-2.6.33.3/drivers/media/video/saa7134/saa7134-dvb.c.orig	2010-05-08 16:20:12.000000000 +0200
> +++ linux-2.6.33.3/drivers/media/video/saa7134/saa7134-dvb.c	2010-05-09 15:33:30.000000000 +0200
> @@ -55,6 +55,7 @@
>  #include "tda8290.h"
>  
>  #include "zl10353.h"
> +#include "qt1010.h"
>  
>  #include "zl10036.h"
>  #include "zl10039.h"
> @@ -886,6 +887,17 @@ static struct zl10353_config behold_x7_c
>  	.disable_i2c_gate_ctrl = 1,
>  };
>  
> +static struct zl10353_config videomate_t750_zl10353_config = {
> +       .demod_address  = 0x0f,
> +       .no_tuner = 1,
> +       .parallel_ts = 1,
> +};
> +
> +static struct qt1010_config videomate_t750_qt1010_config = {
> +       .i2c_address = 0x62
> +};
> +
> +
>  /* ==================================================================
>   * tda10086 based DVB-S cards, helper functions
>   */
> @@ -1556,6 +1568,24 @@ static int dvb_init(struct saa7134_dev *
>  					__func__);
>  
>  		break;
> +        case SAA7134_BOARD_VIDEOMATE_T750:
> +                printk("Compro VideoMate T750 DVB setup\n");
> +                fe0->dvb.frontend = dvb_attach(zl10353_attach,
> +                                                &videomate_t750_zl10353_config,
> +                                                &dev->i2c_adap);
> +                if (fe0->dvb.frontend != NULL) {
> +                        // if there is a gate function then the i2c bus breaks.....!
> +                        fe0->dvb.frontend->ops.i2c_gate_ctrl = 0;
> + 
> +                        if (dvb_attach(qt1010_attach,
> +                                       fe0->dvb.frontend,
> +                                       &dev->i2c_adap,
> +                                       &videomate_t750_qt1010_config) == NULL)
> +                        {
> +                                wprintk("error attaching QT1010\n");
> +                        }
> +                }
> +                break;
>  	case SAA7134_BOARD_ZOLID_HYBRID_PCI:
>  		fe0->dvb.frontend = dvb_attach(tda10048_attach,
>  					       &zolid_tda10048_config,
> --- linux-2.6.33.3/drivers/media/video/saa7134/saa7134-input.c.orig	2010-05-08 16:52:20.000000000 +0200
> +++ linux-2.6.33.3/drivers/media/video/saa7134/saa7134-input.c	2010-05-09 17:32:25.000000000 +0200
> @@ -671,6 +671,11 @@ int saa7134_input_init1(struct saa7134_d
>  		mask_keycode = 0x003f00;
>  		mask_keydown = 0x040000;
>  		break;
> +	case SAA7134_BOARD_VIDEOMATE_T750:
> +		ir_codes     = &ir_codes_videomate_t750_table;
> +		mask_keycode = 0x003f00;
> +		mask_keyup   = 0x040000;
> +		break;
>  	case SAA7134_BOARD_LEADTEK_WINFAST_DTV1000S:
>  		ir_codes     = &ir_codes_winfast_table;
>  		mask_keycode = 0x5f00;
> --- linux-2.6.33.3/drivers/media/IR/ir-keymaps.c.orig	2010-05-08 17:03:35.000000000 +0200
> +++ linux-2.6.33.3/drivers/media/IR/ir-keymaps.c	2010-05-09 19:35:27.000000000 +0200
> @@ -3197,6 +3197,96 @@ struct ir_scancode_table ir_codes_videom
>  };
>  EXPORT_SYMBOL_GPL(ir_codes_videomate_s350_table);
>  
> +/*
> +Compro videomate vista T750F remote
> +-----------------------------------
> +Emard 2010-05-09 <davoremard@gmail.com>
> +                                            POWER
> +VIDEO           RADIO       AUDIO          CAMERA 
> +PVR             EPG         TV      DVD  SUBTITLE
> +
> +                      UP
> +                 LEFT OK RIGHT
> +                     DOWN
> +
> +BACKSPACE            MENU                    INFO
> +
> +VOLUMEUP                                CHANNELUP
> +                     MUTE
> +VOLUMEDOWN                            CHANNELDOWN
> +
> +RECORD                                       STOP
> +REWIND               PLAY             FASTFORWARD
> +PREVIOUSSONG       PLAYPAUSE             NEXTSONG
> +
> +NUMERIC_1          NUMERIC_2         NUMERIC_3
> +NUMERIC_4          NUMERIC_5         NUMERIC_6
> +NUMERIC_7          NUMERIC_8         NUMERIC_9
> +NUMERIC_STAR       NUMERIC_0         NUMERIC_POUND
> +
> +CLEAR                ZOOM                 ENTER
> +
> +RED      GREEN      YELLOW     BLUE        TEXT
> +*/
> +static struct ir_scancode ir_codes_videomate_t750[] = {
> +	{ 0x01, KEY_POWER},
> +	{ 0x31, KEY_VIDEO},
> +	{ 0x33, KEY_RADIO},
> +	{ 0x2f, KEY_AUDIO},
> +	{ 0x30, KEY_CAMERA}, /* pictures */
> +	{ 0x2d, KEY_PVR},    /* Recordings */
> +	{   23, KEY_EPG},
> +	{   44, KEY_TV},
> +	{   43, KEY_DVD},
> +	{ 0x32, KEY_SUBTITLE},
> +	{   17, KEY_UP},
> +	{   19, KEY_LEFT},
> +	{   21, KEY_OK},
> +	{   20, KEY_RIGHT},
> +	{   18, KEY_DOWN},
> +	{   22, KEY_BACKSPACE},
> +	{ 0x02, KEY_MENU},
> +	{ 0x04, KEY_INFO},
> +	{ 0x05, KEY_VOLUMEUP},
> +	{ 0x06, KEY_VOLUMEDOWN},
> +	{ 0x03, KEY_MUTE},
> +	{ 0x07, KEY_CHANNELUP},
> +	{ 0x08, KEY_CHANNELDOWN},
> +	{ 0x0c, KEY_RECORD},
> +	{ 0x0e, KEY_STOP},
> +	{ 0x0a, KEY_REWIND},
> +	{ 0x0b, KEY_PLAY},
> +	{ 0x09, KEY_FASTFORWARD},
> +	{ 0x10, KEY_PREVIOUSSONG},
> +	{ 0x0d, KEY_PLAYPAUSE},
> +	{ 0x0f, KEY_NEXTSONG},
> +	{   30, KEY_NUMERIC_1},
> +	{ 0x1f, KEY_NUMERIC_2},
> +	{ 0x20, KEY_NUMERIC_3},
> +	{ 0x21, KEY_NUMERIC_4},
> +	{ 0x22, KEY_NUMERIC_5},
> +	{ 0x23, KEY_NUMERIC_6},
> +	{ 0x24, KEY_NUMERIC_7},
> +	{ 0x25, KEY_NUMERIC_8},
> +	{ 0x26, KEY_NUMERIC_9},
> +	{ 0x2a, KEY_NUMERIC_STAR},
> +	{   29, KEY_NUMERIC_0},
> +	{   41, KEY_NUMERIC_POUND},
> +	{   39, KEY_CLEAR},
> +	{ 0x34, KEY_ZOOM},
> +	{ 0x28, KEY_ENTER},
> +	{   25, KEY_RED},
> +	{   26, KEY_GREEN},
> +	{   27, KEY_YELLOW},
> +	{   28, KEY_BLUE},
> +	{   24, KEY_TEXT},

The IR code suffered a major change during this development cycle. So, this patch doesn't apply
anymore.
> +};
> +struct ir_scancode_table ir_codes_videomate_t750_table = {
> +	.scan = ir_codes_videomate_t750,
> +	.size = ARRAY_SIZE(ir_codes_videomate_t750),
> +};
> +EXPORT_SYMBOL_GPL(ir_codes_videomate_t750_table);
> +
>  /* GADMEI UTV330+ RM008Z remote
>     Shine Liu <shinel@foxmail.com>
>   */
> --- linux-2.6.33.3/include/media/ir-common.h.orig	2010-04-26 16:48:30.000000000 +0200
> +++ linux-2.6.33.3/include/media/ir-common.h	2010-05-09 17:30:24.000000000 +0200
> @@ -160,6 +160,7 @@ extern struct ir_scancode_table ir_codes
>  extern struct ir_scancode_table ir_codes_evga_indtube_table;
>  extern struct ir_scancode_table ir_codes_terratec_cinergy_xs_table;
>  extern struct ir_scancode_table ir_codes_videomate_s350_table;
> +extern struct ir_scancode_table ir_codes_videomate_t750_table;
>  extern struct ir_scancode_table ir_codes_gadmei_rm008z_table;
>  extern struct ir_scancode_table ir_codes_nec_terratec_cinergy_xs_table;
>  #endif
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html




Cheers,
Mauro
