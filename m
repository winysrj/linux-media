Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35343 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800Ab0E3XsX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 May 2010 19:48:23 -0400
Received: by fxm10 with SMTP id 10so2023708fxm.19
        for <linux-media@vger.kernel.org>; Sun, 30 May 2010 16:48:22 -0700 (PDT)
Date: Mon, 31 May 2010 01:48:18 +0200
From: Davor Emard <davoremard@gmail.com>
To: Samuel =?utf-8?Q?Rakitni=C4=8Dan?= <samuel.rakitnican@gmail.com>
Cc: semiRocket <semirocket@gmail.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Compro Videomate T750F Vista digital+analog support
Message-ID: <20100530234817.GA17135@emard.lan>
References: <20100508160628.GA6050@z60m>
 <op.vceiu5q13xmt7q@crni>
 <AANLkTinMYcgG6Ac73Vgdx8NMYocW8Net6_-dMC3yEflQ@mail.gmail.com>
 <AANLkTikbpZ0LM5rK70abVuJS27j0lT7iZs12DrSKB9wI@mail.gmail.com>
 <op.vcfoxwnq3xmt7q@crni>
 <20100509173243.GA8227@z60m>
 <op.vcga9rw2ndeod6@crni>
 <20100509231535.GA6334@z60m>
 <op.vcsntos43xmt7q@crni>
 <op.vc551isrndeod6@crni>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.vc551isrndeod6@crni>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

HI!

I have downloaded latest hg v4l and adapted the compro 
t750f support patch. The patch is the same but v4l code is
newer so there's some improvement

Restarting VDR is now stable. Tried it cca 10x VDR restarts, 
DVB-T tuner always worked. Remote still has 10% keys lost.

ALSA device now appears with alsa=1 in the list
arecord -l (but I haven't tried to capture anything yet)

Someone mentioned that MCE-alike remote is the same to all 
f-series of the cards so I called it rc-videomate-f.

Here's the patch

diff -r 304cfde05b3f linux/drivers/media/IR/keymaps/Makefile
--- a/linux/drivers/media/IR/keymaps/Makefile	Tue May 25 23:50:51 2010 -0400
+++ b/linux/drivers/media/IR/keymaps/Makefile	Mon May 31 01:18:12 2010 +0200
@@ -63,5 +63,6 @@
 			rc-tt-1500.o \
 			rc-videomate-s350.o \
 			rc-videomate-tv-pvr.o \
+			rc-videomate-f.o \
 			rc-winfast.o \
 			rc-winfast-usbii-deluxe.o
diff -r 304cfde05b3f linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Tue May 25 23:50:51 2010 -0400
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Mon May 31 01:18:12 2010 +0200
@@ -4920,12 +4920,14 @@
 	},
 	[SAA7134_BOARD_VIDEOMATE_T750] = {
 		/* John Newbigin <jn@it.swin.edu.au> */
+		/* Emard 2010-05-10 v18-v4l <davoremard@gmail.com> */
 		.name           = "Compro VideoMate T750",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_XC2028,
 		.radio_type     = UNSET,
-		.tuner_addr	= ADDR_UNSET,
+		.tuner_addr	= 0x61,
 		.radio_addr	= ADDR_UNSET,
+		.mpeg           = SAA7134_MPEG_DVB,
 		.inputs = {{
 			.name   = name_tv,
 			.vmux   = 3,
@@ -6752,6 +6754,11 @@
 			msleep(10);
 			saa7134_set_gpio(dev, 18, 1);
 		break;
+		case SAA7134_BOARD_VIDEOMATE_T750:
+			saa7134_set_gpio(dev, 20, 0);
+			msleep(10);
+			saa7134_set_gpio(dev, 20, 1);
+		break;
 		}
 	return 0;
 	}
@@ -7171,6 +7178,11 @@
 		saa_andorl(SAA7134_GPIO_GPMODE0 >> 2,   0x0000C000, 0x0000C000);
 		saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x0000C000, 0x0000C000);
 		break;
+	case SAA7134_BOARD_VIDEOMATE_T750:
+		dev->has_remote = SAA7134_REMOTE_GPIO;
+		saa_andorl(SAA7134_GPIO_GPMODE0 >> 2,   0x00008000, 0x00008000);
+		saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x00008000, 0x00008000);
+		break;
 	}
 	return 0;
 }
diff -r 304cfde05b3f linux/drivers/media/video/saa7134/saa7134-dvb.c
--- a/linux/drivers/media/video/saa7134/saa7134-dvb.c	Tue May 25 23:50:51 2010 -0400
+++ b/linux/drivers/media/video/saa7134/saa7134-dvb.c	Mon May 31 01:18:12 2010 +0200
@@ -55,6 +55,7 @@
 #include "tda8290.h"
 
 #include "zl10353.h"
+#include "qt1010.h"
 
 #include "zl10036.h"
 #include "zl10039.h"
@@ -886,6 +887,17 @@
 	.disable_i2c_gate_ctrl = 1,
 };
 
+static struct zl10353_config videomate_t750_zl10353_config = {
+	.demod_address  = 0x0f,
+	.no_tuner = 1,
+	.parallel_ts = 1,
+};
+
+static struct qt1010_config videomate_t750_qt1010_config = {
+	.i2c_address = 0x62
+};
+
+
 /* ==================================================================
  * tda10086 based DVB-S cards, helper functions
  */
@@ -1569,6 +1581,21 @@
 					__func__);
 
 		break;
+	case SAA7134_BOARD_VIDEOMATE_T750:
+		printk("Compro VideoMate T750 DVB setup\n");
+		fe0->dvb.frontend = dvb_attach(zl10353_attach,
+						&videomate_t750_zl10353_config,
+						&dev->i2c_adap);
+		if (fe0->dvb.frontend != NULL) {
+			// if there is a gate function then the i2c bus breaks.....!
+			fe0->dvb.frontend->ops.i2c_gate_ctrl = 0;
+			if (dvb_attach(qt1010_attach,
+					fe0->dvb.frontend,
+					&dev->i2c_adap,
+					&videomate_t750_qt1010_config) == NULL)
+				wprintk("error attaching QT1010\n");
+		}
+		break;
 	case SAA7134_BOARD_ZOLID_HYBRID_PCI:
 		fe0->dvb.frontend = dvb_attach(tda10048_attach,
 					       &zolid_tda10048_config,
diff -r 304cfde05b3f linux/drivers/media/video/saa7134/saa7134-input.c
--- a/linux/drivers/media/video/saa7134/saa7134-input.c	Tue May 25 23:50:51 2010 -0400
+++ b/linux/drivers/media/video/saa7134/saa7134-input.c	Mon May 31 01:18:12 2010 +0200
@@ -865,6 +865,11 @@
 		mask_keycode = 0x003f00;
 		mask_keydown = 0x040000;
 		break;
+	case SAA7134_BOARD_VIDEOMATE_T750:
+		ir_codes     = RC_MAP_VIDEOMATE_F;
+		mask_keycode = 0x003f00;
+		mask_keyup   = 0x040000;
+		break;
 	case SAA7134_BOARD_LEADTEK_WINFAST_DTV1000S:
 		ir_codes     = RC_MAP_WINFAST;
 		mask_keycode = 0x5f00;
diff -r 304cfde05b3f linux/include/media/rc-map.h
--- a/linux/include/media/rc-map.h	Tue May 25 23:50:51 2010 -0400
+++ b/linux/include/media/rc-map.h	Mon May 31 01:18:12 2010 +0200
@@ -113,6 +113,7 @@
 #define RC_MAP_TT_1500                   "rc-tt-1500"
 #define RC_MAP_VIDEOMATE_S350            "rc-videomate-s350"
 #define RC_MAP_VIDEOMATE_TV_PVR          "rc-videomate-tv-pvr"
+#define RC_MAP_VIDEOMATE_F               "rc-videomate-f"
 #define RC_MAP_WINFAST                   "rc-winfast"
 #define RC_MAP_WINFAST_USBII_DELUXE      "rc-winfast-usbii-deluxe"
 /*
--- v4l-dvb/linux/drivers/media/IR/keymaps/rc-videomate-f.c.orig	2010-05-31 01:31:03.000000000 +0200
+++ v4l-dvb/linux/drivers/media/IR/keymaps/rc-videomate-f.c	2010-05-31 00:54:31.000000000 +0200
@@ -0,0 +1,119 @@
+/* videomate-f.h - Keytable for videomate f series Remote Controller
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <media/rc-map.h>
+
+/*
+Compro videomate vista T750F remote
+-----------------------------------
+Emard 2010-05-09 <davoremard@gmail.com>
+                                            POWER
+VIDEO           RADIO       AUDIO          CAMERA 
+PVR             EPG         TV      DVD  SUBTITLE
+
+                      UP
+                 LEFT OK RIGHT
+                     DOWN
+
+BACK                 MENU                    INFO
+
+VOLUMEUP                                CHANNELUP
+                     MUTE
+VOLUMEDOWN                            CHANNELDOWN
+
+RECORD                                       STOP
+REWIND               PLAY             FASTFORWARD
+PREVIOUSSONG       PLAYPAUSE             NEXTSONG
+
+NUMERIC_1          NUMERIC_2         NUMERIC_3
+NUMERIC_4          NUMERIC_5         NUMERIC_6
+NUMERIC_7          NUMERIC_8         NUMERIC_9
+NUMERIC_STAR       NUMERIC_0         NUMERIC_POUND
+
+CLEAR                ZOOM                 ENTER
+
+RED      GREEN      YELLOW     BLUE        TEXT
+*/
+static struct ir_scancode videomate_f[] = {
+	{ 0x01, KEY_POWER},
+	{ 0x31, KEY_VIDEO},
+	{ 0x33, KEY_RADIO},
+	{ 0x2f, KEY_AUDIO},
+	{ 0x30, KEY_CAMERA}, /* pictures */
+	{ 0x2d, KEY_PVR},    /* Recordings */
+	{   23, KEY_EPG},
+	{   44, KEY_TV},
+	{   43, KEY_DVD},
+	{ 0x32, KEY_SUBTITLE},
+	{   17, KEY_UP},
+	{   19, KEY_LEFT},
+	{   21, KEY_OK},
+	{   20, KEY_RIGHT},
+	{   18, KEY_DOWN},
+	{   22, KEY_BACK},
+	{ 0x02, KEY_MENU},
+	{ 0x04, KEY_INFO},
+	{ 0x05, KEY_VOLUMEUP},
+	{ 0x06, KEY_VOLUMEDOWN},
+	{ 0x03, KEY_MUTE},
+	{ 0x07, KEY_CHANNELUP},
+	{ 0x08, KEY_CHANNELDOWN},
+	{ 0x0c, KEY_RECORD},
+	{ 0x0e, KEY_STOP},
+	{ 0x0a, KEY_REWIND},
+	{ 0x0b, KEY_PLAY},
+	{ 0x09, KEY_FASTFORWARD},
+	{ 0x10, KEY_PREVIOUSSONG},
+	{ 0x0d, KEY_PLAYPAUSE},
+	{ 0x0f, KEY_NEXTSONG},
+	{   30, KEY_NUMERIC_1},
+	{ 0x1f, KEY_NUMERIC_2},
+	{ 0x20, KEY_NUMERIC_3},
+	{ 0x21, KEY_NUMERIC_4},
+	{ 0x22, KEY_NUMERIC_5},
+	{ 0x23, KEY_NUMERIC_6},
+	{ 0x24, KEY_NUMERIC_7},
+	{ 0x25, KEY_NUMERIC_8},
+	{ 0x26, KEY_NUMERIC_9},
+	{ 0x2a, KEY_NUMERIC_STAR},
+	{   29, KEY_NUMERIC_0},
+	{   41, KEY_NUMERIC_POUND},
+	{   39, KEY_CLEAR},
+	{ 0x34, KEY_ZOOM},
+	{ 0x28, KEY_ENTER},
+	{   25, KEY_RED},
+	{   26, KEY_GREEN},
+	{   27, KEY_YELLOW},
+	{   28, KEY_BLUE},
+	{   24, KEY_TEXT},
+};
+
+static struct rc_keymap videomate_f_map = {
+	.map = {
+		.scan    = videomate_f,
+		.size    = ARRAY_SIZE(videomate_f),
+		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
+		.name    = RC_MAP_VIDEOMATE_F,
+	}
+};
+
+static int __init init_rc_map_videomate_f(void)
+{
+	return ir_register_map(&videomate_f_map);
+}
+
+static void __exit exit_rc_map_videomate_f(void)
+{
+	ir_unregister_map(&videomate_f_map);
+}
+
+module_init(init_rc_map_videomate_f)
+module_exit(exit_rc_map_videomate_f)
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Davor Emard <davoremard@gmail.com>");

