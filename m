Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60753 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327Ab0JBFyA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Oct 2010 01:54:00 -0400
Received: by wwj40 with SMTP id 40so2226405wwj.1
        for <linux-media@vger.kernel.org>; Fri, 01 Oct 2010 22:53:58 -0700 (PDT)
Date: Sat, 2 Oct 2010 07:53:55 +0200
From: Davor Emard <davoremard@gmail.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] Compro videmate T750f for 2.6.35.7
Message-ID: <20101002055354.GB12113@emard.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

HI

This is my update for compro videomate t750f v19 for kernel 2.6.35.7
which has separated IR remote in a file.

There seem to be different types of this card which I don't know
how to distinguish. This patch works for my card but may not work
for other types.

Best regards, Davor

--- linux-2.6.35.7/drivers/media/video/saa7134/saa7134-input.c.orig	2010-09-29 03:09:08.000000000 +0200
+++ linux-2.6.35.7/drivers/media/video/saa7134/saa7134-input.c	2010-10-02 05:45:01.467990234 +0200
@@ -816,6 +816,11 @@ int saa7134_input_init1(struct saa7134_d
 		mask_keycode = 0x003f00;
 		mask_keydown = 0x040000;
 		break;
+	case SAA7134_BOARD_VIDEOMATE_T750:
+		ir_codes     = RC_MAP_VIDEOMATE_T750;
+		mask_keycode = 0x003f00;
+		mask_keyup   = 0x040000;
+		break;
 	case SAA7134_BOARD_LEADTEK_WINFAST_DTV1000S:
 		ir_codes     = RC_MAP_WINFAST;
 		mask_keycode = 0x5f00;
--- linux-2.6.35.7/drivers/media/video/saa7134/saa7134-cards.c.orig	2010-09-29 03:09:08.000000000 +0200
+++ linux-2.6.35.7/drivers/media/video/saa7134/saa7134-cards.c	2010-10-02 05:43:50.639315788 +0200
@@ -4915,12 +4915,14 @@ struct saa7134_board saa7134_boards[] =
 	},
 	[SAA7134_BOARD_VIDEOMATE_T750] = {
 		/* John Newbigin <jn@it.swin.edu.au> */
+		/* Emard 2010-05-10 v18 <davoremard@gmail.com> */
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
@@ -6722,6 +6724,11 @@ static int saa7134_xc2028_callback(struc
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
@@ -7142,6 +7149,11 @@ int saa7134_board_init1(struct saa7134_d
 		saa7134_set_gpio(dev, 1, 1);
 		dev->has_remote = SAA7134_REMOTE_GPIO;
 		break;
+	case SAA7134_BOARD_VIDEOMATE_T750:
+		dev->has_remote = SAA7134_REMOTE_GPIO;
+		saa_andorl(SAA7134_GPIO_GPMODE0 >> 2,   0x00008000, 0x00008000);
+		saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x00008000, 0x00008000);
+		break;
 	}
 	return 0;
 }
--- linux-2.6.35.7/drivers/media/video/saa7134/saa7134-dvb.c.orig	2010-09-29 03:09:08.000000000 +0200
+++ linux-2.6.35.7/drivers/media/video/saa7134/saa7134-dvb.c	2010-10-02 05:43:50.639315788 +0200
@@ -54,6 +54,7 @@
 #include "tda8290.h"
 
 #include "zl10353.h"
+#include "qt1010.h"
 
 #include "zl10036.h"
 #include "zl10039.h"
@@ -885,6 +886,17 @@ static struct zl10353_config behold_x7_c
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
@@ -1564,6 +1576,21 @@ static int dvb_init(struct saa7134_dev *
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
--- linux-2.6.35.7/drivers/media/IR/keymaps/Makefile.orig	2010-09-29 03:09:08.000000000 +0200
+++ linux-2.6.35.7/drivers/media/IR/keymaps/Makefile	2010-10-01 21:32:01.207530164 +0200
@@ -63,6 +63,7 @@ obj-$(CONFIG_RC_MAP) += rc-adstech-dvb-t
 			rc-tevii-nec.o \
 			rc-tt-1500.o \
 			rc-videomate-s350.o \
+			rc-videomate-t750.o \
 			rc-videomate-tv-pvr.o \
 			rc-winfast.o \
 			rc-winfast-usbii-deluxe.o
--- linux-2.6.35.7/drivers/media/IR/keymaps/rc-videomate-t750.c.orig	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.35.7/drivers/media/IR/keymaps/rc-videomate-t750.c	2010-10-02 05:49:23.664275732 +0200
@@ -0,0 +1,123 @@
+/* videomate-s350.h - Keytable for videomate_s350 Remote Controller
+ *
+ * keymap imported from ir-keymaps.c
+ *
+ * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
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
+static struct ir_scancode videomate_t750[] = {
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
+static struct rc_keymap videomate_t750_map = {
+	.map = {
+		.scan    = videomate_t750,
+		.size    = ARRAY_SIZE(videomate_t750),
+		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
+		.name    = RC_MAP_VIDEOMATE_T750,
+	}
+};
+
+static int __init init_rc_map_videomate_t750(void)
+{
+	return ir_register_map(&videomate_t750_map);
+}
+
+static void __exit exit_rc_map_videomate_t750(void)
+{
+	ir_unregister_map(&videomate_t750_map);
+}
+
+module_init(init_rc_map_videomate_t750)
+module_exit(exit_rc_map_videomate_t750)
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Davor Emard <davoremard@gmail.com>");
--- linux-2.6.35.7/include/media/rc-map.h.orig	2010-10-01 21:30:52.156604735 +0200
+++ linux-2.6.35.7/include/media/rc-map.h	2010-10-01 21:31:13.515998577 +0200
@@ -113,6 +113,7 @@ void rc_map_init(void);
 #define RC_MAP_TEVII_NEC                 "rc-tevii-nec"
 #define RC_MAP_TT_1500                   "rc-tt-1500"
 #define RC_MAP_VIDEOMATE_S350            "rc-videomate-s350"
+#define RC_MAP_VIDEOMATE_T750            "rc-videomate-t750"
 #define RC_MAP_VIDEOMATE_TV_PVR          "rc-videomate-tv-pvr"
 #define RC_MAP_WINFAST                   "rc-winfast"
 #define RC_MAP_WINFAST_USBII_DELUXE      "rc-winfast-usbii-deluxe"
