Return-path: <mchehab@gaivota>
Received: from mfe5.msomt.modwest.com ([204.11.245.169]:54297 "EHLO
	mfe5.msomt.modwest.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259Ab0LZVoE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Dec 2010 16:44:04 -0500
Date: Sun, 26 Dec 2010 18:13:30 -0300
From: Ramiro Morales <ramiro@rmorales.net>
To: linux-media@vger.kernel.org
Cc: pvosnova@gmail.com
Subject: Re: [PATCH] saa7134: Add support for Compro VideoMate Vista M1F
Message-ID: <20101226211329.GA4037@fao>
References: <20100612215757.GA4796@fao>
 <4C328641.1000106@redhat.com>
 <20101226210011.GA3849@fao>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101226210011.GA3849@fao>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Mon, Jul 05, 2010 at 10:26:25PM -0300, Mauro Carvalho Chehab wrote:
> I need the patch author Signed-off-by, in order to be able to apply it.
> As you're sending me the patches, I need your SOB also. Please c/c the
> author's email on the email you send me submitting his patches.
> 

Hi again,

Find attached the patch upated to remotes/linuxtv/staging/for_v2.6.38
as of now.

The card ID is 183 now.

I'm c/c'ing Pavel Osnova and I've added my SOB as requested.

Regards,

diff --git a/Documentation/video4linux/CARDLIST.saa7134 b/Documentation/video4linux/CARDLIST.saa7134
index 8d9afc7..8db1a94 100644
--- a/Documentation/video4linux/CARDLIST.saa7134
+++ b/Documentation/video4linux/CARDLIST.saa7134
@@ -180,3 +180,4 @@
 179 -> Beholder BeholdTV A7                     [5ace:7090]
 180 -> Avermedia PCI M733A                      [1461:4155,1461:4255]
 181 -> TechoTrend TT-budget T-3000              [13c2:2804]
+183 -> Compro VideoMate Vista M1F               [185b:c900]
diff --git a/drivers/media/rc/keymaps/Makefile b/drivers/media/rc/keymaps/Makefile
index 148900f..0659e9f 100644
--- a/drivers/media/rc/keymaps/Makefile
+++ b/drivers/media/rc/keymaps/Makefile
@@ -81,6 +81,7 @@ obj-$(CONFIG_RC_MAP) += rc-adstech-dvb-t-pci.o \
 			rc-trekstor.o \
 			rc-tt-1500.o \
 			rc-twinhan1027.o \
+			rc-videomate-m1f.o \
 			rc-videomate-s350.o \
 			rc-videomate-tv-pvr.o \
 			rc-winfast.o \
diff --git a/drivers/media/rc/keymaps/rc-videomate-m1f.c b/drivers/media/rc/keymaps/rc-videomate-m1f.c
new file mode 100644
index 0000000..4994d40
--- /dev/null
+++ b/drivers/media/rc/keymaps/rc-videomate-m1f.c
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
+static struct rc_map_table videomate_m1f[] = {
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
+static struct rc_map_list videomate_m1f_map = {
+	.map = {
+		.scan    = videomate_m1f,
+		.size    = ARRAY_SIZE(videomate_m1f),
+		.rc_type = RC_TYPE_UNKNOWN,     /* Legacy IR type */
+		.name    = RC_MAP_VIDEOMATE_M1F,
+	}
+};
+
+static int __init init_rc_map_videomate_m1f(void)
+{
+	return rc_map_register(&videomate_m1f_map);
+}
+
+static void __exit exit_rc_map_videomate_m1f(void)
+{
+	rc_map_unregister(&videomate_m1f_map);
+}
+
+module_init(init_rc_map_videomate_m1f)
+module_exit(exit_rc_map_videomate_m1f)
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Pavel Osnova <pvosnova@gmail.com>");
diff --git a/drivers/media/video/saa7134/saa7134-cards.c b/drivers/media/video/saa7134/saa7134-cards.c
index ff23e6e..e7aa588 100644
--- a/drivers/media/video/saa7134/saa7134-cards.c
+++ b/drivers/media/video/saa7134/saa7134-cards.c
@@ -5538,6 +5538,37 @@ struct saa7134_board saa7134_boards[] = {
 			.amux   = LINE2,
 		} },
 	},
+	[SAA7134_BOARD_VIDEOMATE_M1F] = {
+		/* Pavel Osnova <pvosnova@gmail.com> */
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
+			.amux = LINE1,
+		},
+		.mute = {
+			.name = name_mute,
+			.amux = TV,
+		},
+	},
 
 };
 
@@ -6731,6 +6762,12 @@ struct pci_device_id saa7134_pci_tbl[] = {
 		.subdevice    = 0x7090,
 		.driver_data  = SAA7134_BOARD_BEHOLD_A7,
 	}, {
+		.vendor       = PCI_VENDOR_ID_PHILIPS,
+		.device       = PCI_DEVICE_ID_PHILIPS_SAA7135,
+		.subvendor    = 0x185b,
+		.subdevice    = 0xc900,
+		.driver_data  = SAA7134_BOARD_VIDEOMATE_M1F,
+	}, {
 		/* --- boards without eeprom + subsystem ID --- */
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7134,
@@ -7046,6 +7083,7 @@ int saa7134_board_init1(struct saa7134_dev *dev)
 	case SAA7134_BOARD_VIDEOMATE_TV_PVR:
 	case SAA7134_BOARD_VIDEOMATE_GOLD_PLUS:
 	case SAA7134_BOARD_VIDEOMATE_TV_GOLD_PLUSII:
+	case SAA7134_BOARD_VIDEOMATE_M1F:
 	case SAA7134_BOARD_VIDEOMATE_DVBT_300:
 	case SAA7134_BOARD_VIDEOMATE_DVBT_200:
 	case SAA7134_BOARD_VIDEOMATE_DVBT_200A:
diff --git a/drivers/media/video/saa7134/saa7134-input.c b/drivers/media/video/saa7134/saa7134-input.c
index 98678d9..dc646e6 100644
--- a/drivers/media/video/saa7134/saa7134-input.c
+++ b/drivers/media/video/saa7134/saa7134-input.c
@@ -721,6 +721,11 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 		mask_keyup   = 0x020000;
 		polling      = 50; /* ms */
 		break;
+	case SAA7134_BOARD_VIDEOMATE_M1F:
+		ir_codes     = RC_MAP_VIDEOMATE_M1F;
+		mask_keycode = 0x0ff00;
+		mask_keyup   = 0x040000;
+		break;
 	}
 	if (NULL == ir_codes) {
 		printk("%s: Oops: IR config error [card=%d]\n",
diff --git a/drivers/media/video/saa7134/saa7134.h b/drivers/media/video/saa7134/saa7134.h
index babfbe7..5b0a347 100644
--- a/drivers/media/video/saa7134/saa7134.h
+++ b/drivers/media/video/saa7134/saa7134.h
@@ -326,6 +326,7 @@ struct saa7134_card_ir {
 #define SAA7134_BOARD_AVERMEDIA_M733A       180
 #define SAA7134_BOARD_TECHNOTREND_BUDGET_T3000 181
 #define SAA7134_BOARD_KWORLD_PCI_SBTVD_FULLSEG 182
+#define SAA7134_BOARD_VIDEOMATE_M1F         183
 
 #define SAA7134_MAXBOARDS 32
 #define SAA7134_INPUT_MAX 8
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index 5d3a457..ee9e2f7 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -138,6 +138,7 @@ void rc_map_init(void);
 #define RC_MAP_TREKSTOR                  "rc-trekstor"
 #define RC_MAP_TT_1500                   "rc-tt-1500"
 #define RC_MAP_TWINHAN_VP1027_DVBS       "rc-twinhan1027"
+#define RC_MAP_VIDEOMATE_M1F             "rc-videomate-m1f"
 #define RC_MAP_VIDEOMATE_S350            "rc-videomate-s350"
 #define RC_MAP_VIDEOMATE_TV_PVR          "rc-videomate-tv-pvr"
 #define RC_MAP_WINFAST                   "rc-winfast"
Signed-off-by: Pavel Osnova <pvosnova@gmail.com>
Signed-off-by: Ramiro Morales <ramiro@rmorales.net>

-- 
Ramiro Morales
