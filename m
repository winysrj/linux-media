Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-12.arcor-online.net ([151.189.21.52]:35325 "EHLO
	mail-in-12.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758449Ab0EZAL2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 May 2010 20:11:28 -0400
Subject: Re: [PATCH for 2.6.34] saa7134: add support for Compro VideoMate
	M1F
From: hermann pitton <hermann-pitton@arcor.de>
To: Pavel Osnova <pvosnova@gmail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <AANLkTimxiByXV9LI5uXbykT9NRoxo_AfdUDpA3XHy7w4@mail.gmail.com>
References: <AANLkTimxiByXV9LI5uXbykT9NRoxo_AfdUDpA3XHy7w4@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 26 May 2010 02:00:31 +0200
Message-Id: <1274832031.3273.79.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel,

Am Dienstag, den 25.05.2010, 20:42 +0300 schrieb Pavel Osnova:
> This patch add support for Compro VideoMate M1F analog TV tuner.

just some small comments.

You must find a way to get patches to patchwork without line breakages.

Patches should be against recent git or mercurial v4l-dvb and you should
run "make checkpatch" and review the minor stuff it complains about.

For my knowledge, there is no TUNER_LG_PAL_NEW_TAPC with tda9887.
The NEW_TAPC uses LG tuner API and those with tda9887 Philips MK3.

They are different for the UHF switch. Did you test on anything in UHF?

We have some stuff in that cruft unfortunately.

Even with extra radio tuner, Composite and S-Video should have the same
amux.

You set gpios without defining a gpio mask.

Such has no effect.

Cheers,
Hermann


> 
> diff -urN linux-2.6.34/Documentation/video4linux/CARDLIST.saa7134
> linux-2.6.34patched orig/Documentation/video4linux/CARDLIST.saa7134
> --- linux-2.6.34/Documentation/video4linux/CARDLIST.saa7134
> 2010-05-17 00:17:36.000000000 +0300
> +++ linux-2.6.34patched
> orig/Documentation/video4linux/CARDLIST.saa7134    2010-05-24
> 13:33:01.915467949 +0300
> @@ -175,3 +175,4 @@
>  174 -> Asus Europa Hybrid OEM                   [1043:4847]
>  175 -> Leadtek Winfast DTV1000S                 [107d:6655]
>  176 -> Beholder BeholdTV 505 RDS                [0000:5051]
> +177 -> Compro VideoMate M1F               [185b:c900]
> diff -urN linux-2.6.34/drivers/media/IR/ir-keymaps.c
> linux-2.6.34patched orig/drivers/media/IR/ir-keymaps.c
> --- linux-2.6.34/drivers/media/IR/ir-keymaps.c    2010-05-17
> 00:17:36.000000000 +0300
> +++ linux-2.6.34patched orig/drivers/media/IR/ir-keymaps.c
> 2010-05-24 13:37:59.872106122 +0300
> @@ -3492,3 +3492,65 @@
>      .ir_type = IR_TYPE_NEC,
>  };
>  EXPORT_SYMBOL_GPL(ir_codes_kworld_315u_table);
> +
> +/* Compro VideoMate M1F
> + * Pavel Osnova <pvosnova@gmail.com>
> + */
> +static struct ir_scancode ir_codes_videomate_m1f[] = {
> +    { 0x01, KEY_POWER },
> +    { 0x31, KEY_TUNER },
> +    { 0x33, KEY_VIDEO },
> +    { 0x2f, KEY_RADIO },
> +    { 0x30, KEY_CAMERA },
> +    { 0x2d, KEY_NEW }, /* TV record button */
> +    { 0x17, KEY_CYCLEWINDOWS },
> +    { 0x2c, KEY_ANGLE },
> +    { 0x2b, KEY_LANGUAGE },
> +    { 0x32, KEY_SEARCH }, /* '...' button */
> +    { 0x11, KEY_UP },
> +    { 0x13, KEY_LEFT },
> +    { 0x15, KEY_OK },
> +    { 0x14, KEY_RIGHT },
> +    { 0x12, KEY_DOWN },
> +    { 0x16, KEY_BACKSPACE },
> +    { 0x02, KEY_ZOOM }, /* WIN key */
> +    { 0x04, KEY_INFO },
> +    { 0x05, KEY_VOLUMEUP },
> +    { 0x03, KEY_MUTE },
> +    { 0x07, KEY_CHANNELUP },
> +    { 0x06, KEY_VOLUMEDOWN },
> +    { 0x08, KEY_CHANNELDOWN },
> +    { 0x0c, KEY_RECORD },
> +    { 0x0e, KEY_STOP },
> +    { 0x0a, KEY_BACK },
> +    { 0x0b, KEY_PLAY },
> +    { 0x09, KEY_FORWARD },
> +    { 0x10, KEY_PREVIOUS },
> +    { 0x0d, KEY_PAUSE },
> +    { 0x0f, KEY_NEXT },
> +    { 0x1e, KEY_1 },
> +    { 0x1f, KEY_2 },
> +    { 0x20, KEY_3 },
> +    { 0x21, KEY_4 },
> +    { 0x22, KEY_5 },
> +    { 0x23, KEY_6 },
> +    { 0x24, KEY_7 },
> +    { 0x25, KEY_8 },
> +    { 0x26, KEY_9 },
> +    { 0x2a, KEY_NUMERIC_STAR }, /* * key */
> +    { 0x1d, KEY_0 },
> +    { 0x29, KEY_SUBTITLE }, /* # key */
> +    { 0x27, KEY_CLEAR },
> +    { 0x34, KEY_SCREEN },
> +    { 0x28, KEY_ENTER },
> +    { 0x19, KEY_RED },
> +    { 0x1a, KEY_GREEN },
> +    { 0x1b, KEY_YELLOW },
> +    { 0x1c, KEY_BLUE },
> +    { 0x18, KEY_TEXT },
> +};
> +struct ir_scancode_table ir_codes_videomate_m1f_table = {
> +    .scan = ir_codes_videomate_m1f,
> +    .size = ARRAY_SIZE(ir_codes_videomate_m1f),
> +};
> +EXPORT_SYMBOL_GPL(ir_codes_videomate_m1f_table);
> diff -urN linux-2.6.34/drivers/media/video/saa7134/saa7134-cards.c
> linux-2.6.34patched orig/drivers/media/video/saa7134/saa7134-cards.c
> --- linux-2.6.34/drivers/media/video/saa7134/saa7134-cards.c
> 2010-05-17 00:17:36.000000000 +0300
> +++ linux-2.6.34patched
> orig/drivers/media/video/saa7134/saa7134-cards.c    2010-05-24
> 13:44:41.618731443 +0300
> @@ -5355,7 +5355,39 @@
>              .amux = LINE2,
>          },
>      },
> -
> +    [SAA7134_BOARD_VIDEOMATE_M1F] = {
> +                .name           = "Compro VideoMate M1F",
> +                .audio_clock    = 0x00187de7,
> +                .tuner_type     = TUNER_LG_PAL_NEW_TAPC,
> +                .radio_type     = TUNER_TEA5767,
> +                .tuner_addr     = ADDR_UNSET,
> +                .radio_addr     = 0x60,
> +                .tda9887_conf   = TDA9887_PRESENT,
> +                .inputs         = {{
> +                        .name = name_tv,
> +                        .vmux = 1,
> +                        .amux = TV,
> +                        .tv   = 1,
> +                },{
> +                        .name = name_comp1,
> +                        .vmux = 3,
> +                        .amux = LINE2,
> +                },{
> +                        .name = name_svideo,
> +                        .vmux = 8,
> +                        .amux = LINE1,
> +                }},
> +                .radio = {
> +                        .name = name_radio,
> +                        .amux = LINE2,
> +                        .gpio = 0x80000,
> +                },
> +                .mute = {
> +                        .name = name_mute,
> +                        .amux = LINE2,
> +                        .gpio = 0x40000,
> +                },
> +        },
>  };
> 
>  const unsigned int saa7134_bcount = ARRAY_SIZE(saa7134_boards);
> @@ -6803,6 +6835,7 @@
>      case SAA7134_BOARD_VIDEOMATE_TV_PVR:
>      case SAA7134_BOARD_VIDEOMATE_GOLD_PLUS:
>      case SAA7134_BOARD_VIDEOMATE_TV_GOLD_PLUSII:
> +    case SAA7134_BOARD_VIDEOMATE_M1F:
>      case SAA7134_BOARD_VIDEOMATE_DVBT_300:
>      case SAA7134_BOARD_VIDEOMATE_DVBT_200:
>      case SAA7134_BOARD_VIDEOMATE_DVBT_200A:
> diff -urN linux-2.6.34/drivers/media/video/saa7134/saa7134.h
> linux-2.6.34patched orig/drivers/media/video/saa7134/saa7134.h
> --- linux-2.6.34/drivers/media/video/saa7134/saa7134.h    2010-05-17
> 00:17:36.000000000 +0300
> +++ linux-2.6.34patched orig/drivers/media/video/saa7134/saa7134.h
> 2010-05-24 13:42:13.798747367 +0300
> @@ -300,6 +300,7 @@
>  #define SAA7134_BOARD_ASUS_EUROPA_HYBRID    174
>  #define SAA7134_BOARD_LEADTEK_WINFAST_DTV1000S 175
>  #define SAA7134_BOARD_BEHOLD_505RDS_MK3     176
> +#define SAA7134_BOARD_VIDEOMATE_M1F    177
> 
>  #define SAA7134_MAXBOARDS 32
>  #define SAA7134_INPUT_MAX 8
> diff -urN linux-2.6.34/drivers/media/video/saa7134/saa7134-input.c
> linux-2.6.34patched orig/drivers/media/video/saa7134/saa7134-input.c
> --- linux-2.6.34/drivers/media/video/saa7134/saa7134-input.c
> 2010-05-17 00:17:36.000000000 +0300
> +++ linux-2.6.34patched
> orig/drivers/media/video/saa7134/saa7134-input.c    2010-05-24
> 13:45:33.755392801 +0300
> @@ -679,6 +679,11 @@
>          mask_keyup   = 0x020000;
>          polling      = 50; /* ms */
>          break;
> +    case SAA7134_BOARD_VIDEOMATE_M1F:
> +        ir_codes     = &ir_codes_videomate_m1f_table;
> +        mask_keycode = 0x0ff00;
> +        mask_keyup   = 0x040000;
> +        break;
>      break;
>      }
>      if (NULL == ir_codes) {
> diff -urN linux-2.6.34/include/media/ir-common.h linux-2.6.34patched
> orig/include/media/ir-common.h
> --- linux-2.6.34/include/media/ir-common.h    2010-05-17
> 00:17:36.000000000 +0300
> +++ linux-2.6.34patched orig/include/media/ir-common.h    2010-05-24
> 13:49:29.845368218 +0300
> @@ -164,4 +164,5 @@
>  extern struct ir_scancode_table ir_codes_nec_terratec_cinergy_xs_table;
>  extern struct ir_scancode_table ir_codes_winfast_usbii_deluxe_table;
>  extern struct ir_scancode_table ir_codes_kworld_315u_table;
> +extern struct ir_scancode_table ir_codes_videomate_m1f_table;
>  #endif
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

