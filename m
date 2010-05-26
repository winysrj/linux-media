Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f216.google.com ([209.85.219.216]:40173 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756585Ab0EZTu7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 May 2010 15:50:59 -0400
Received: by ewy8 with SMTP id 8so237555ewy.28
        for <linux-media@vger.kernel.org>; Wed, 26 May 2010 12:50:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1274832031.3273.79.camel@pc07.localdom.local>
References: <AANLkTimxiByXV9LI5uXbykT9NRoxo_AfdUDpA3XHy7w4@mail.gmail.com>
	 <1274832031.3273.79.camel@pc07.localdom.local>
Date: Wed, 26 May 2010 22:50:56 +0300
Message-ID: <AANLkTil_iz-uv4zc9brKCSyJmOiVGk0aRgnA7wKuHHXq@mail.gmail.com>
Subject: Re: [PATCH for 2.6.34] saa7134: add support for Compro VideoMate M1F
From: Pavel Osnova <pvosnova@gmail.com>
To: hermann pitton <hermann-pitton@arcor.de>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hermann, thank you for reply.

I updated the patch according to your advice. This card really doesn't
have tda9887 chip, so I fixed it.
As for UHF: I have cable TV and frequencies of most channels are in
range from 300 to 900 MHz,
so I think UHF is fine.


diff -uprN v4l-dvb_orig/Documentation/video4linux/CARDLIST.saa7134
v4l-dvb/Documentation/video4linux/CARDLIST.saa7134
--- v4l-dvb_orig/Documentation/video4linux/CARDLIST.saa7134	2010-05-26
20:34:06.000000000 +0300
+++ v4l-dvb/Documentation/video4linux/CARDLIST.saa7134	2010-05-26
21:12:28.247684250 +0300
@@ -176,5 +176,6 @@
 175 -> Leadtek Winfast DTV1000S                 [107d:6655]
 176 -> Beholder BeholdTV 505 RDS                [0000:5051]
 177 -> Hawell HW-404M7
-179 -> Beholder BeholdTV H7			[5ace:7190]
-180 -> Beholder BeholdTV A7			[5ace:7090]
+178 -> Beholder BeholdTV H7			[5ace:7190]
+179 -> Beholder BeholdTV A7			[5ace:7090]
+180 -> Compro VideoMate M1F			[185b:c900]
diff -uprN v4l-dvb_orig/drivers/media/IR/keymaps/Makefile
v4l-dvb/drivers/media/IR/keymaps/Makefile
--- v4l-dvb_orig/drivers/media/IR/keymaps/Makefile	2010-05-26
20:34:09.000000000 +0300
+++ v4l-dvb/drivers/media/IR/keymaps/Makefile	2010-05-26
21:09:41.498117258 +0300
@@ -61,6 +61,7 @@ obj-$(CONFIG_RC_MAP) += rc-adstech-dvb-t
 			rc-terratec-cinergy-xs.o \
 			rc-tevii-nec.o \
 			rc-tt-1500.o \
+			rc-videomate-m1f.o \
 			rc-videomate-s350.o \
 			rc-videomate-tv-pvr.o \
 			rc-winfast.o \
diff -uprN v4l-dvb_orig/drivers/media/IR/keymaps/rc-videomate-m1f.c
v4l-dvb/drivers/media/IR/keymaps/rc-videomate-m1f.c
--- v4l-dvb_orig/drivers/media/IR/keymaps/rc-videomate-m1f.c	1970-01-01
03:00:00.000000000 +0300
+++ v4l-dvb/drivers/media/IR/keymaps/rc-videomate-m1f.c	2010-05-26
22:27:31.993333335 +0300
@@ -0,0 +1,92 @@
+/* videomate-m1f.h - Keytable for videomate_m1f Remote Controller
+ *
+ * keymap imported from ir-keymaps.c
+ *
+ * Copyright (c) 2010 by Pavel Osnova <pvosnova@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <media/rc-map.h>
+
+static struct ir_scancode videomate_m1f[] = {
+	{ 0x01, KEY_POWER },
+	{ 0x31, KEY_TUNER },
+	{ 0x33, KEY_VIDEO },
+	{ 0x2f, KEY_RADIO },
+	{ 0x30, KEY_CAMERA },
+	{ 0x2d, KEY_NEW }, /* TV record button */
+	{ 0x17, KEY_CYCLEWINDOWS },
+	{ 0x2c, KEY_ANGLE },
+	{ 0x2b, KEY_LANGUAGE },
+	{ 0x32, KEY_SEARCH }, /* '...' button */
+	{ 0x11, KEY_UP },
+	{ 0x13, KEY_LEFT },
+	{ 0x15, KEY_OK },
+	{ 0x14, KEY_RIGHT },
+	{ 0x12, KEY_DOWN },
+	{ 0x16, KEY_BACKSPACE },
+	{ 0x02, KEY_ZOOM }, /* WIN key */
+	{ 0x04, KEY_INFO },
+	{ 0x05, KEY_VOLUMEUP },
+	{ 0x03, KEY_MUTE },
+	{ 0x07, KEY_CHANNELUP },
+	{ 0x06, KEY_VOLUMEDOWN },
+	{ 0x08, KEY_CHANNELDOWN },
+	{ 0x0c, KEY_RECORD },
+	{ 0x0e, KEY_STOP },
+	{ 0x0a, KEY_BACK },
+	{ 0x0b, KEY_PLAY },
+	{ 0x09, KEY_FORWARD },
+	{ 0x10, KEY_PREVIOUS },
+	{ 0x0d, KEY_PAUSE },
+	{ 0x0f, KEY_NEXT },
+	{ 0x1e, KEY_1 },
+	{ 0x1f, KEY_2 },
+	{ 0x20, KEY_3 },
+	{ 0x21, KEY_4 },
+	{ 0x22, KEY_5 },
+	{ 0x23, KEY_6 },
+	{ 0x24, KEY_7 },
+	{ 0x25, KEY_8 },
+	{ 0x26, KEY_9 },
+	{ 0x2a, KEY_NUMERIC_STAR }, /* * key */
+	{ 0x1d, KEY_0 },
+	{ 0x29, KEY_SUBTITLE }, /* # key */
+	{ 0x27, KEY_CLEAR },
+	{ 0x34, KEY_SCREEN },
+	{ 0x28, KEY_ENTER },
+	{ 0x19, KEY_RED },
+	{ 0x1a, KEY_GREEN },
+	{ 0x1b, KEY_YELLOW },
+	{ 0x1c, KEY_BLUE },
+	{ 0x18, KEY_TEXT },
+};
+
+static struct rc_keymap videomate_m1f_map = {
+	.map = {
+		.scan    = videomate_m1f,
+		.size    = ARRAY_SIZE(videomate_m1f),
+		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
+		.name    = RC_MAP_VIDEOMATE_M1F,
+	}
+};
+
+static int __init init_rc_map_videomate_m1f(void)
+{
+	return ir_register_map(&videomate_m1f_map);
+}
+
+static void __exit exit_rc_map_videomate_m1f(void)
+{
+	ir_unregister_map(&videomate_m1f_map);
+}
+
+module_init(init_rc_map_videomate_m1f)
+module_exit(exit_rc_map_videomate_m1f)
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Pavel Osnova <pvosnova@gmail.com>");
diff -uprN v4l-dvb_orig/drivers/media/video/saa7134/saa7134-cards.c
v4l-dvb/drivers/media/video/saa7134/saa7134-cards.c
--- v4l-dvb_orig/drivers/media/video/saa7134/saa7134-cards.c	2010-05-26
20:34:09.000000000 +0300
+++ v4l-dvb/drivers/media/video/saa7134/saa7134-cards.c	2010-05-26
22:28:39.163333335 +0300
@@ -5428,7 +5428,33 @@ struct saa7134_board saa7134_boards[] =
 			.amux = TV,
 		},
 	},
-
+	[SAA7134_BOARD_VIDEOMATE_M1F] = {
+		/* Pavel Osnova <pvosnova@gmail.com> */
+		.name           = "Compro VideoMate M1F",
+		.audio_clock    = 0x00187de7,
+		.tuner_type     = TUNER_LG_PAL_NEW_TAPC,
+		.radio_type     = TUNER_TEA5767,
+		.tuner_addr     = ADDR_UNSET,
+		.radio_addr     = 0x60,
+		.inputs         = { {
+			.name = name_tv,
+			.vmux = 1,
+			.amux = TV,
+			.tv   = 1,
+		}, {
+			.name = name_comp1,
+			.vmux = 3,
+			.amux = LINE2,
+		}, {
+			.name = name_svideo,
+			.vmux = 8,
+			.amux = LINE2,
+		} },
+		.radio = {
+			.name = name_radio,
+			.amux = LINE2,
+		},
+	},
 };

 const unsigned int saa7134_bcount = ARRAY_SIZE(saa7134_boards);
@@ -6890,6 +6916,7 @@ int saa7134_board_init1(struct saa7134_d
 	case SAA7134_BOARD_VIDEOMATE_TV_PVR:
 	case SAA7134_BOARD_VIDEOMATE_GOLD_PLUS:
 	case SAA7134_BOARD_VIDEOMATE_TV_GOLD_PLUSII:
+	case SAA7134_BOARD_VIDEOMATE_M1F:
 	case SAA7134_BOARD_VIDEOMATE_DVBT_300:
 	case SAA7134_BOARD_VIDEOMATE_DVBT_200:
 	case SAA7134_BOARD_VIDEOMATE_DVBT_200A:
diff -uprN v4l-dvb_orig/drivers/media/video/saa7134/saa7134.h
v4l-dvb/drivers/media/video/saa7134/saa7134.h
--- v4l-dvb_orig/drivers/media/video/saa7134/saa7134.h	2010-05-26
20:34:09.000000000 +0300
+++ v4l-dvb/drivers/media/video/saa7134/saa7134.h	2010-05-26
21:13:10.654349519 +0300
@@ -303,6 +303,7 @@ struct saa7134_format {
 #define SAA7134_BOARD_HAWELL_HW_404M7		177
 #define SAA7134_BOARD_BEHOLD_H7             178
 #define SAA7134_BOARD_BEHOLD_A7             179
+#define SAA7134_BOARD_VIDEOMATE_M1F		180

 #define SAA7134_MAXBOARDS 32
 #define SAA7134_INPUT_MAX 8
diff -uprN v4l-dvb_orig/drivers/media/video/saa7134/saa7134-input.c
v4l-dvb/drivers/media/video/saa7134/saa7134-input.c
--- v4l-dvb_orig/drivers/media/video/saa7134/saa7134-input.c	2010-05-26
20:34:09.000000000 +0300
+++ v4l-dvb/drivers/media/video/saa7134/saa7134-input.c	2010-05-26
21:14:54.764339462 +0300
@@ -815,6 +815,11 @@ int saa7134_input_init1(struct saa7134_d
 		mask_keyup   = 0x020000;
 		polling      = 50; /* ms */
 		break;
+	case SAA7134_BOARD_VIDEOMATE_M1F:
+		ir_codes     = RC_MAP_VIDEOMATE_M1F;
+		mask_keycode = 0x0ff00;
+		mask_keyup   = 0x040000;
+		break;
 	break;
 	}
 	if (NULL == ir_codes) {
diff -uprN v4l-dvb_orig/include/media/rc-map.h v4l-dvb/include/media/rc-map.h
--- v4l-dvb_orig/include/media/rc-map.h	2010-05-26 20:34:11.000000000 +0300
+++ v4l-dvb/include/media/rc-map.h	2010-05-26 21:07:32.494384159 +0300
@@ -111,6 +111,7 @@ void rc_map_init(void);
 #define RC_MAP_TERRATEC_CINERGY_XS       "rc-terratec-cinergy-xs"
 #define RC_MAP_TEVII_NEC                 "rc-tevii-nec"
 #define RC_MAP_TT_1500                   "rc-tt-1500"
+#define RC_MAP_VIDEOMATE_M1F             "rc-videomate-m1f"
 #define RC_MAP_VIDEOMATE_S350            "rc-videomate-s350"
 #define RC_MAP_VIDEOMATE_TV_PVR          "rc-videomate-tv-pvr"
 #define RC_MAP_WINFAST                   "rc-winfast"
Signed-off-by: Pavel Osnova <pvosnova@gmail.com>


On 26 May 2010 03:00, hermann pitton <hermann-pitton@arcor.de> wrote:
> Hi Pavel,
>
> Am Dienstag, den 25.05.2010, 20:42 +0300 schrieb Pavel Osnova:
>> This patch add support for Compro VideoMate M1F analog TV tuner.
>
> just some small comments.
>
> You must find a way to get patches to patchwork without line breakages.
>
> Patches should be against recent git or mercurial v4l-dvb and you should
> run "make checkpatch" and review the minor stuff it complains about.
>
> For my knowledge, there is no TUNER_LG_PAL_NEW_TAPC with tda9887.
> The NEW_TAPC uses LG tuner API and those with tda9887 Philips MK3.
>
> They are different for the UHF switch. Did you test on anything in UHF?
>
> We have some stuff in that cruft unfortunately.
>
> Even with extra radio tuner, Composite and S-Video should have the same
> amux.
>
> You set gpios without defining a gpio mask.
>
> Such has no effect.
>
> Cheers,
> Hermann
>
>
>>
>> diff -urN linux-2.6.34/Documentation/video4linux/CARDLIST.saa7134
>> linux-2.6.34patched orig/Documentation/video4linux/CARDLIST.saa7134
>> --- linux-2.6.34/Documentation/video4linux/CARDLIST.saa7134
>> 2010-05-17 00:17:36.000000000 +0300
>> +++ linux-2.6.34patched
>> orig/Documentation/video4linux/CARDLIST.saa7134    2010-05-24
>> 13:33:01.915467949 +0300
>> @@ -175,3 +175,4 @@
>>  174 -> Asus Europa Hybrid OEM                   [1043:4847]
>>  175 -> Leadtek Winfast DTV1000S                 [107d:6655]
>>  176 -> Beholder BeholdTV 505 RDS                [0000:5051]
>> +177 -> Compro VideoMate M1F               [185b:c900]
>> diff -urN linux-2.6.34/drivers/media/IR/ir-keymaps.c
>> linux-2.6.34patched orig/drivers/media/IR/ir-keymaps.c
>> --- linux-2.6.34/drivers/media/IR/ir-keymaps.c    2010-05-17
>> 00:17:36.000000000 +0300
>> +++ linux-2.6.34patched orig/drivers/media/IR/ir-keymaps.c
>> 2010-05-24 13:37:59.872106122 +0300
>> @@ -3492,3 +3492,65 @@
>>      .ir_type = IR_TYPE_NEC,
>>  };
>>  EXPORT_SYMBOL_GPL(ir_codes_kworld_315u_table);
>> +
>> +/* Compro VideoMate M1F
>> + * Pavel Osnova <pvosnova@gmail.com>
>> + */
>> +static struct ir_scancode ir_codes_videomate_m1f[] = {
>> +    { 0x01, KEY_POWER },
>> +    { 0x31, KEY_TUNER },
>> +    { 0x33, KEY_VIDEO },
>> +    { 0x2f, KEY_RADIO },
>> +    { 0x30, KEY_CAMERA },
>> +    { 0x2d, KEY_NEW }, /* TV record button */
>> +    { 0x17, KEY_CYCLEWINDOWS },
>> +    { 0x2c, KEY_ANGLE },
>> +    { 0x2b, KEY_LANGUAGE },
>> +    { 0x32, KEY_SEARCH }, /* '...' button */
>> +    { 0x11, KEY_UP },
>> +    { 0x13, KEY_LEFT },
>> +    { 0x15, KEY_OK },
>> +    { 0x14, KEY_RIGHT },
>> +    { 0x12, KEY_DOWN },
>> +    { 0x16, KEY_BACKSPACE },
>> +    { 0x02, KEY_ZOOM }, /* WIN key */
>> +    { 0x04, KEY_INFO },
>> +    { 0x05, KEY_VOLUMEUP },
>> +    { 0x03, KEY_MUTE },
>> +    { 0x07, KEY_CHANNELUP },
>> +    { 0x06, KEY_VOLUMEDOWN },
>> +    { 0x08, KEY_CHANNELDOWN },
>> +    { 0x0c, KEY_RECORD },
>> +    { 0x0e, KEY_STOP },
>> +    { 0x0a, KEY_BACK },
>> +    { 0x0b, KEY_PLAY },
>> +    { 0x09, KEY_FORWARD },
>> +    { 0x10, KEY_PREVIOUS },
>> +    { 0x0d, KEY_PAUSE },
>> +    { 0x0f, KEY_NEXT },
>> +    { 0x1e, KEY_1 },
>> +    { 0x1f, KEY_2 },
>> +    { 0x20, KEY_3 },
>> +    { 0x21, KEY_4 },
>> +    { 0x22, KEY_5 },
>> +    { 0x23, KEY_6 },
>> +    { 0x24, KEY_7 },
>> +    { 0x25, KEY_8 },
>> +    { 0x26, KEY_9 },
>> +    { 0x2a, KEY_NUMERIC_STAR }, /* * key */
>> +    { 0x1d, KEY_0 },
>> +    { 0x29, KEY_SUBTITLE }, /* # key */
>> +    { 0x27, KEY_CLEAR },
>> +    { 0x34, KEY_SCREEN },
>> +    { 0x28, KEY_ENTER },
>> +    { 0x19, KEY_RED },
>> +    { 0x1a, KEY_GREEN },
>> +    { 0x1b, KEY_YELLOW },
>> +    { 0x1c, KEY_BLUE },
>> +    { 0x18, KEY_TEXT },
>> +};
>> +struct ir_scancode_table ir_codes_videomate_m1f_table = {
>> +    .scan = ir_codes_videomate_m1f,
>> +    .size = ARRAY_SIZE(ir_codes_videomate_m1f),
>> +};
>> +EXPORT_SYMBOL_GPL(ir_codes_videomate_m1f_table);
>> diff -urN linux-2.6.34/drivers/media/video/saa7134/saa7134-cards.c
>> linux-2.6.34patched orig/drivers/media/video/saa7134/saa7134-cards.c
>> --- linux-2.6.34/drivers/media/video/saa7134/saa7134-cards.c
>> 2010-05-17 00:17:36.000000000 +0300
>> +++ linux-2.6.34patched
>> orig/drivers/media/video/saa7134/saa7134-cards.c    2010-05-24
>> 13:44:41.618731443 +0300
>> @@ -5355,7 +5355,39 @@
>>              .amux = LINE2,
>>          },
>>      },
>> -
>> +    [SAA7134_BOARD_VIDEOMATE_M1F] = {
>> +                .name           = "Compro VideoMate M1F",
>> +                .audio_clock    = 0x00187de7,
>> +                .tuner_type     = TUNER_LG_PAL_NEW_TAPC,
>> +                .radio_type     = TUNER_TEA5767,
>> +                .tuner_addr     = ADDR_UNSET,
>> +                .radio_addr     = 0x60,
>> +                .tda9887_conf   = TDA9887_PRESENT,
>> +                .inputs         = {{
>> +                        .name = name_tv,
>> +                        .vmux = 1,
>> +                        .amux = TV,
>> +                        .tv   = 1,
>> +                },{
>> +                        .name = name_comp1,
>> +                        .vmux = 3,
>> +                        .amux = LINE2,
>> +                },{
>> +                        .name = name_svideo,
>> +                        .vmux = 8,
>> +                        .amux = LINE1,
>> +                }},
>> +                .radio = {
>> +                        .name = name_radio,
>> +                        .amux = LINE2,
>> +                        .gpio = 0x80000,
>> +                },
>> +                .mute = {
>> +                        .name = name_mute,
>> +                        .amux = LINE2,
>> +                        .gpio = 0x40000,
>> +                },
>> +        },
>>  };
>>
>>  const unsigned int saa7134_bcount = ARRAY_SIZE(saa7134_boards);
>> @@ -6803,6 +6835,7 @@
>>      case SAA7134_BOARD_VIDEOMATE_TV_PVR:
>>      case SAA7134_BOARD_VIDEOMATE_GOLD_PLUS:
>>      case SAA7134_BOARD_VIDEOMATE_TV_GOLD_PLUSII:
>> +    case SAA7134_BOARD_VIDEOMATE_M1F:
>>      case SAA7134_BOARD_VIDEOMATE_DVBT_300:
>>      case SAA7134_BOARD_VIDEOMATE_DVBT_200:
>>      case SAA7134_BOARD_VIDEOMATE_DVBT_200A:
>> diff -urN linux-2.6.34/drivers/media/video/saa7134/saa7134.h
>> linux-2.6.34patched orig/drivers/media/video/saa7134/saa7134.h
>> --- linux-2.6.34/drivers/media/video/saa7134/saa7134.h    2010-05-17
>> 00:17:36.000000000 +0300
>> +++ linux-2.6.34patched orig/drivers/media/video/saa7134/saa7134.h
>> 2010-05-24 13:42:13.798747367 +0300
>> @@ -300,6 +300,7 @@
>>  #define SAA7134_BOARD_ASUS_EUROPA_HYBRID    174
>>  #define SAA7134_BOARD_LEADTEK_WINFAST_DTV1000S 175
>>  #define SAA7134_BOARD_BEHOLD_505RDS_MK3     176
>> +#define SAA7134_BOARD_VIDEOMATE_M1F    177
>>
>>  #define SAA7134_MAXBOARDS 32
>>  #define SAA7134_INPUT_MAX 8
>> diff -urN linux-2.6.34/drivers/media/video/saa7134/saa7134-input.c
>> linux-2.6.34patched orig/drivers/media/video/saa7134/saa7134-input.c
>> --- linux-2.6.34/drivers/media/video/saa7134/saa7134-input.c
>> 2010-05-17 00:17:36.000000000 +0300
>> +++ linux-2.6.34patched
>> orig/drivers/media/video/saa7134/saa7134-input.c    2010-05-24
>> 13:45:33.755392801 +0300
>> @@ -679,6 +679,11 @@
>>          mask_keyup   = 0x020000;
>>          polling      = 50; /* ms */
>>          break;
>> +    case SAA7134_BOARD_VIDEOMATE_M1F:
>> +        ir_codes     = &ir_codes_videomate_m1f_table;
>> +        mask_keycode = 0x0ff00;
>> +        mask_keyup   = 0x040000;
>> +        break;
>>      break;
>>      }
>>      if (NULL == ir_codes) {
>> diff -urN linux-2.6.34/include/media/ir-common.h linux-2.6.34patched
>> orig/include/media/ir-common.h
>> --- linux-2.6.34/include/media/ir-common.h    2010-05-17
>> 00:17:36.000000000 +0300
>> +++ linux-2.6.34patched orig/include/media/ir-common.h    2010-05-24
>> 13:49:29.845368218 +0300
>> @@ -164,4 +164,5 @@
>>  extern struct ir_scancode_table ir_codes_nec_terratec_cinergy_xs_table;
>>  extern struct ir_scancode_table ir_codes_winfast_usbii_deluxe_table;
>>  extern struct ir_scancode_table ir_codes_kworld_315u_table;
>> +extern struct ir_scancode_table ir_codes_videomate_m1f_table;
>>  #endif
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
