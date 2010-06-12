Return-path: <linux-media-owner@vger.kernel.org>
Received: from mfe4.msomt.modwest.com ([204.11.245.168]:47799 "EHLO
	mfe4.msomt.modwest.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689Ab0FLW2N (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Jun 2010 18:28:13 -0400
Received: from fao (unknown [190.246.191.228])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by mfe4.msomt.modwest.com (Postfix) with ESMTP id C180C218008
	for <linux-media@vger.kernel.org>; Sat, 12 Jun 2010 15:58:03 -0600 (MDT)
Date: Sat, 12 Jun 2010 18:57:58 -0300
From: Ramiro Morales <ramiro@rmorales.net>
To: linux-media@vger.kernel.org
Subject: [PATCH] saa7134: Add support for Compro VideoMate Vista M1F
Message-ID: <20100612215757.GA4796@fao>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

(I've just subscribed myself to the list so I can't easily reply to the
original "[PATCH for 2.6.34] saa7134: add support for Compro VideoMate
M1F" thread from May 25 started by Pavel Osnova.)

I've just bought this card. I'm in Argentina so if there are several
models it should be the appropriate one for this market (PAL-NC?).

Find below Pavel's latest patch adapted/updated to v4l-dvb Mercurial
repository status as of today (Hg revision 023a0048e6a8).

For a start, the PCI ID is different from the Pavel's one (185b:c900):

  $ lspci |grep -i philips
  01:07.0 Multimedia controller: Philips Semiconductors SAA7131/SAA7133/SAA7135 Video Broadcast Decoder (rev d1)
  $ lspci -n |grep 01\:07\.0
  01:07.0 0480: 1131:7133 (rev d1)

(btw, it's the same PCI ID as card #17: AOPEN VA1000 POWER)

I've decided to maintain Pavel's name, email address and
"Signed-off-by:" header, hopefully he will be able to review the patch
and give his opinion.

Will reply to this message with another one containing a full
description of the card components hermann-pitton had asked for.

Regards,


diff --git a/linux/Documentation/video4linux/CARDLIST.saa7134 b/linux/Documentation/video4linux/CARDLIST.saa7134
--- a/linux/Documentation/video4linux/CARDLIST.saa7134
+++ b/linux/Documentation/video4linux/CARDLIST.saa7134
@@ -179,3 +179,4 @@
 178 -> Beholder BeholdTV H7                     [5ace:7190]
 179 -> Beholder BeholdTV A7                     [5ace:7090]
 180 -> Avermedia PCI M733A                      [1461:4155,1461:4255]
+181 -> Compro VideoMate Vista M1F               [185b:c900,1131:7133]
diff --git a/linux/drivers/media/IR/keymaps/Makefile b/linux/drivers/media/IR/keymaps/Makefile
--- a/linux/drivers/media/IR/keymaps/Makefile
+++ b/linux/drivers/media/IR/keymaps/Makefile
@@ -62,6 +62,7 @@
 			rc-terratec-cinergy-xs.o \
 			rc-tevii-nec.o \
 			rc-tt-1500.o \
+			rc-videomate-m1f.o \
 			rc-videomate-s350.o \
 			rc-videomate-tv-pvr.o \
 			rc-winfast.o \
diff --git a/linux/drivers/media/IR/keymaps/rc-videomate-m1f.c b/linux/drivers/media/IR/keymaps/rc-videomate-m1f.c
new file mode 100644
--- /dev/null
+++ b/linux/drivers/media/IR/keymaps/rc-videomate-m1f.c
@@ -0,0 +1,92 @@
+/* videomate-m1f.h - Keytable for videomate_m1f Remote Controller
+ *
+ * keymap imported from ir-keymaps.c
+ *
+ * Copyright (c) 2010 by Pavel Osnova <pvosnova <at> gmail.com>
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
+		.ir_type = IR_TYPE_UNKNOWN,     /* Legacy IR type */
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
+MODULE_AUTHOR("Pavel Osnova <pvosnova <at> gmail.com>");
diff --git a/linux/drivers/media/video/saa7134/saa7134-cards.c b/linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c
@@ -5501,6 +5501,33 @@
 			.amux = TV,
 		},
 	},
+	[SAA7134_BOARD_VIDEOMATE_M1F] = {
+		/* Pavel Osnova <pvosnova <at> gmail.com> */
+		.name           = "Compro VideoMate Vista M1F",
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
 
@@ -7017,6 +7044,7 @@
 	case SAA7134_BOARD_VIDEOMATE_TV_PVR:
 	case SAA7134_BOARD_VIDEOMATE_GOLD_PLUS:
 	case SAA7134_BOARD_VIDEOMATE_TV_GOLD_PLUSII:
+	case SAA7134_BOARD_VIDEOMATE_M1F:
 	case SAA7134_BOARD_VIDEOMATE_DVBT_300:
 	case SAA7134_BOARD_VIDEOMATE_DVBT_200:
 	case SAA7134_BOARD_VIDEOMATE_DVBT_200A:
diff --git a/linux/drivers/media/video/saa7134/saa7134-input.c b/linux/drivers/media/video/saa7134/saa7134-input.c
--- a/linux/drivers/media/video/saa7134/saa7134-input.c
+++ b/linux/drivers/media/video/saa7134/saa7134-input.c
@@ -879,6 +879,11 @@
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
diff --git a/linux/drivers/media/video/saa7134/saa7134.h b/linux/drivers/media/video/saa7134/saa7134.h
--- a/linux/drivers/media/video/saa7134/saa7134.h
+++ b/linux/drivers/media/video/saa7134/saa7134.h
@@ -305,6 +305,7 @@
 #define SAA7134_BOARD_BEHOLD_H7             178
 #define SAA7134_BOARD_BEHOLD_A7             179
 #define SAA7134_BOARD_AVERMEDIA_M733A       180
+#define SAA7134_BOARD_VIDEOMATE_M1F         181
 
 #define SAA7134_MAXBOARDS 32
 #define SAA7134_INPUT_MAX 8
diff --git a/linux/include/media/rc-map.h b/linux/include/media/rc-map.h
--- a/linux/include/media/rc-map.h
+++ b/linux/include/media/rc-map.h
@@ -112,6 +112,7 @@
 #define RC_MAP_TERRATEC_CINERGY_XS       "rc-terratec-cinergy-xs"
 #define RC_MAP_TEVII_NEC                 "rc-tevii-nec"
 #define RC_MAP_TT_1500                   "rc-tt-1500"
+#define RC_MAP_VIDEOMATE_M1F             "rc-videomate-m1f"
 #define RC_MAP_VIDEOMATE_S350            "rc-videomate-s350"
 #define RC_MAP_VIDEOMATE_TV_PVR          "rc-videomate-tv-pvr"
 #define RC_MAP_WINFAST                   "rc-winfast"
Signed-off-by: Pavel Osnova <pvosnova <at> gmail.com>

-- 
Ramiro Morales


