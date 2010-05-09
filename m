Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42057 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929Ab0EISfo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 May 2010 14:35:44 -0400
Received: by fxm10 with SMTP id 10so1823913fxm.19
        for <linux-media@vger.kernel.org>; Sun, 09 May 2010 11:35:42 -0700 (PDT)
Content-Type: text/plain; charset=iso-8859-2; format=flowed; delsp=yes
To: Emard <davoremard@gmail.com>
Subject: Re: [PATCH] Compro Videomate T750F Vista digital+analog support
References: <20100508160628.GA6050@z60m> <op.vceiu5q13xmt7q@crni>
 <AANLkTinMYcgG6Ac73Vgdx8NMYocW8Net6_-dMC3yEflQ@mail.gmail.com>
 <AANLkTikbpZ0LM5rK70abVuJS27j0lT7iZs12DrSKB9wI@mail.gmail.com>
 <op.vcfoxwnq3xmt7q@crni> <20100509173243.GA8227@z60m>
Date: Sun, 09 May 2010 20:35:42 +0200
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: =?iso-8859-2?B?U2FtdWVsIFJha2l0bmnoYW4=?=
	<samuel.rakitnican@gmail.com>
Message-ID: <op.vcga9rw2ndeod6@crni>
In-Reply-To: <20100509173243.GA8227@z60m>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 09 May 2010 19:32:43 +0200, Emard <davoremard@gmail.com> wrote:

>> Hmm, power on is pure hardware thing on this card I think, it
>> doesn't need a driver.
>
> But it seems it needs a driver. Although pin is connected to MB power  
> switch,
> the card has to be in certain state (GPIOs programmed, pci standby power
> enabled e.g.) in order for this to work.
>
> Anyway, I have fixed the remote control issue and supported the
> whole remote keycode set.
>
> Here's the patch v15
>

(cc-ing linux-media)

Great! So everything works now?

Still cannot test this code as I've pulled new version of tree (from hg)  
which doesn't compile on my Slackware 13. In fact new tree compile to only  
a few kernel versions right now according to Hans Verkuil daily builds.



So you are aware that your diff must be in against current development  
tree in other to apply? According to recent changes keytables for remotes  
are presented as separate modules under linux/drivers/media/IR/keymaps:

	http://linuxtv.org/hg/v4l-dvb/file/4a8d6d981f07/linux/drivers/media/IR/keymaps

One other thing is that t750 and t750f are shipped with two different  
remotes, so it may probably be needed to add code for auto detection  
between the two or add a modprobe parameter, or even add a separate card  
entry.

Older mail for reference:
	http://www.mail-archive.com/linux-media@vger.kernel.org/msg07478.html

In fact remote shipped with t750f is common between all f series I  
believe, so I think that it could be named rc-videomate-mce.c or  
rc-videomate-f-series.c.




> ---  
> linux-2.6.33.3/drivers/media/video/saa7134/saa7134-cards.c.orig	2010-05-08  
> 16:13:28.000000000 +0200
> +++  
> linux-2.6.33.3/drivers/media/video/saa7134/saa7134-cards.c	2010-05-09  
> 17:35:29.000000000 +0200
> @@ -4881,12 +4881,14 @@ struct saa7134_board saa7134_boards[] =
>  	},
>  	[SAA7134_BOARD_VIDEOMATE_T750] = {
>  		/* John Newbigin <jn@it.swin.edu.au> */
> +		/* Emard 2010-05-09 <davoremard@gmail.com> */
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
> @@ -6956,6 +6963,11 @@ int saa7134_board_init1(struct saa7134_d
>  		saa_andorl(SAA7134_GPIO_GPMODE0 >> 2,   0x00008000, 0x00008000);
>  		saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x00008000, 0x00008000);
>  		break;
> +	case SAA7134_BOARD_VIDEOMATE_T750:
> +		dev->has_remote = SAA7134_REMOTE_GPIO;
> +		saa_andorl(SAA7134_GPIO_GPMODE0 >> 2,   0x00848000, 0x00808000);
> +		saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x00848000, 0x00808000);
> +		break;
>  	}
>  	return 0;
>  }
> @@ -7132,6 +7144,7 @@ int saa7134_board_init2(struct saa7134_d
>  		}
>  		/* break intentionally omitted */
>  	case SAA7134_BOARD_VIDEOMATE_DVBT_300:
> +	case SAA7134_BOARD_VIDEOMATE_T750:
>  	case SAA7134_BOARD_ASUS_EUROPA2_HYBRID:
>  	case SAA7134_BOARD_ASUS_EUROPA_HYBRID:
>  	{
> ---  
> linux-2.6.33.3/drivers/media/video/saa7134/saa7134-dvb.c.orig	2010-05-08  
> 16:20:12.000000000 +0200
> +++ linux-2.6.33.3/drivers/media/video/saa7134/saa7134-dvb.c	2010-05-09  
> 15:33:30.000000000 +0200
> @@ -55,6 +55,7 @@
>  #include "tda8290.h"
> #include "zl10353.h"
> +#include "qt1010.h"
> #include "zl10036.h"
>  #include "zl10039.h"
> @@ -886,6 +887,17 @@ static struct zl10353_config behold_x7_c
>  	.disable_i2c_gate_ctrl = 1,
>  };
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
> 		break;
> +        case SAA7134_BOARD_VIDEOMATE_T750:
> +                printk("Compro VideoMate T750 DVB setup\n");
> +                fe0->dvb.frontend = dvb_attach(zl10353_attach,
> +                                                 
> &videomate_t750_zl10353_config,
> +                                                &dev->i2c_adap);
> +                if (fe0->dvb.frontend != NULL) {
> +                        // if there is a gate function then the i2c bus  
> breaks.....!
> +                        fe0->dvb.frontend->ops.i2c_gate_ctrl = 0;
> +
> +                        if (dvb_attach(qt1010_attach,
> +                                       fe0->dvb.frontend,
> +                                       &dev->i2c_adap,
> +                                       &videomate_t750_qt1010_config)  
> == NULL)
> +                        {
> +                                wprintk("error attaching QT1010\n");
> +                        }
> +                }
> +                break;
>  	case SAA7134_BOARD_ZOLID_HYBRID_PCI:
>  		fe0->dvb.frontend = dvb_attach(tda10048_attach,
>  					       &zolid_tda10048_config,
> ---  
> linux-2.6.33.3/drivers/media/video/saa7134/saa7134-input.c.orig	2010-05-08  
> 16:52:20.000000000 +0200
> +++  
> linux-2.6.33.3/drivers/media/video/saa7134/saa7134-input.c	2010-05-09  
> 17:32:25.000000000 +0200
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
> --- linux-2.6.33.3/drivers/media/IR/ir-keymaps.c.orig	2010-05-08  
> 17:03:35.000000000 +0200
> +++ linux-2.6.33.3/drivers/media/IR/ir-keymaps.c	2010-05-09  
> 18:23:54.000000000 +0200
> @@ -3197,6 +3197,96 @@ struct ir_scancode_table ir_codes_videom
>  };
>  EXPORT_SYMBOL_GPL(ir_codes_videomate_s350_table);
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
> +NUMERIC_STAR       NUMEIRC_0         NUMERIC_POUND
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
> --- linux-2.6.33.3/include/media/ir-common.h.orig	2010-04-26  
> 16:48:30.000000000 +0200
> +++ linux-2.6.33.3/include/media/ir-common.h	2010-05-09  
> 17:30:24.000000000 +0200
> @@ -160,6 +160,7 @@ extern struct ir_scancode_table ir_codes
>  extern struct ir_scancode_table ir_codes_evga_indtube_table;
>  extern struct ir_scancode_table ir_codes_terratec_cinergy_xs_table;
>  extern struct ir_scancode_table ir_codes_videomate_s350_table;
> +extern struct ir_scancode_table ir_codes_videomate_t750_table;
>  extern struct ir_scancode_table ir_codes_gadmei_rm008z_table;
>  extern struct ir_scancode_table ir_codes_nec_terratec_cinergy_xs_table;
>  #endif


-- 
Lorem ipsum
