Return-path: <linux-media-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:45852 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab0EHFXs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 May 2010 01:23:48 -0400
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: linux-media@vger.kernel.org
Subject: [PATCH v2] saa7134: add support for Avermedia M733A
Date: Sat, 8 May 2010 02:23:37 -0300
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201005080223.37534.herton@mandriva.com.br>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This change adds support for Avermedia M733A. The original version for
linux 2.6.31 was sent to me from Avermedia, original author is unknown.
I ported it to current kernels, expanded and fixed key code handling for
RM-K6 remote control, and added an additional pci id also supported.

Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
---
 Documentation/video4linux/CARDLIST.saa7134         |    5 +-
 drivers/media/IR/keymaps/Makefile                  |    1 +
 .../media/IR/keymaps/rc-avermedia-m733a-rm-k6.c    |   95 ++++++++++++++++++++
 drivers/media/video/saa7134/saa7134-cards.c        |   57 ++++++++++++-
 drivers/media/video/saa7134/saa7134-input.c        |    7 ++
 drivers/media/video/saa7134/saa7134.h              |    1 +
 include/media/rc-map.h                             |    1 +
 7 files changed, 164 insertions(+), 3 deletions(-)
 create mode 100644 drivers/media/IR/keymaps/rc-avermedia-m733a-rm-k6.c

diff --git a/Documentation/video4linux/CARDLIST.saa7134 b/Documentation/video4linux/CARDLIST.saa7134
index 070f257..1387a69 100644
--- a/Documentation/video4linux/CARDLIST.saa7134
+++ b/Documentation/video4linux/CARDLIST.saa7134
@@ -176,5 +176,6 @@
 175 -> Leadtek Winfast DTV1000S                 [107d:6655]
 176 -> Beholder BeholdTV 505 RDS                [0000:5051]
 177 -> Hawell HW-404M7
-179 -> Beholder BeholdTV H7			[5ace:7190]
-180 -> Beholder BeholdTV A7			[5ace:7090]
+178 -> Beholder BeholdTV H7                     [5ace:7190]
+179 -> Beholder BeholdTV A7                     [5ace:7090]
+180 -> Avermedia M733A                          [1461:4155,1461:4255]
diff --git a/drivers/media/IR/keymaps/Makefile b/drivers/media/IR/keymaps/Makefile
index ec25258..585f75c 100644
--- a/drivers/media/IR/keymaps/Makefile
+++ b/drivers/media/IR/keymaps/Makefile
@@ -7,6 +7,7 @@ obj-$(CONFIG_RC_MAP) += rc-adstech-dvb-t-pci.o \
 			rc-avermedia-cardbus.o \
 			rc-avermedia-dvbt.o \
 			rc-avermedia-m135a-rm-jx.o \
+			rc-avermedia-m733a-rm-k6.o \
 			rc-avertv-303.o \
 			rc-behold.o \
 			rc-behold-columbus.o \
diff --git a/drivers/media/IR/keymaps/rc-avermedia-m733a-rm-k6.c b/drivers/media/IR/keymaps/rc-avermedia-m733a-rm-k6.c
new file mode 100644
index 0000000..cf8d457
--- /dev/null
+++ b/drivers/media/IR/keymaps/rc-avermedia-m733a-rm-k6.c
@@ -0,0 +1,95 @@
+/* avermedia-m733a-rm-k6.h - Keytable for avermedia_m733a_rm_k6 Remote Controller
+ *
+ * Copyright (c) 2010 by Herton Ronaldo Krzesinski <herton@mandriva.com.br>
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
+ * Avermedia M733A with IR model RM-K6
+ * This is the stock remote controller used with Positivo machines with M733A
+ * Herton Ronaldo Krzesinski <herton@mandriva.com.br>
+ */
+
+static struct ir_scancode avermedia_m733a_rm_k6[] = {
+	{ 0x0401, KEY_POWER2 },
+	{ 0x0406, KEY_MUTE },
+	{ 0x0408, KEY_MODE },     /* TV/FM */
+
+	{ 0x0409, KEY_1 },
+	{ 0x040a, KEY_2 },
+	{ 0x040b, KEY_3 },
+	{ 0x040c, KEY_4 },
+	{ 0x040d, KEY_5 },
+	{ 0x040e, KEY_6 },
+	{ 0x040f, KEY_7 },
+	{ 0x0410, KEY_8 },
+	{ 0x0411, KEY_9 },
+	{ 0x044c, KEY_DOT },      /* '.' */
+	{ 0x0412, KEY_0 },
+	{ 0x0407, KEY_REFRESH },  /* Refresh/Reload */
+
+	{ 0x0413, KEY_AUDIO },
+	{ 0x0440, KEY_SCREEN },   /* Full Screen toggle */
+	{ 0x0441, KEY_HOME },
+	{ 0x0442, KEY_BACK },
+	{ 0x0447, KEY_UP },
+	{ 0x0448, KEY_DOWN },
+	{ 0x0449, KEY_LEFT },
+	{ 0x044a, KEY_RIGHT },
+	{ 0x044b, KEY_OK },
+	{ 0x0404, KEY_VOLUMEUP },
+	{ 0x0405, KEY_VOLUMEDOWN },
+	{ 0x0402, KEY_CHANNELUP },
+	{ 0x0403, KEY_CHANNELDOWN },
+
+	{ 0x0443, KEY_RED },
+	{ 0x0444, KEY_GREEN },
+	{ 0x0445, KEY_YELLOW },
+	{ 0x0446, KEY_BLUE },
+
+	{ 0x0414, KEY_TEXT },
+	{ 0x0415, KEY_EPG },
+	{ 0x041a, KEY_TV2 },      /* PIP */
+	{ 0x041b, KEY_MHP },      /* Snapshot */
+
+	{ 0x0417, KEY_RECORD },
+	{ 0x0416, KEY_PLAYPAUSE },
+	{ 0x0418, KEY_STOP },
+	{ 0x0419, KEY_PAUSE },
+
+	{ 0x041f, KEY_PREVIOUS },
+	{ 0x041c, KEY_REWIND },
+	{ 0x041d, KEY_FORWARD },
+	{ 0x041e, KEY_NEXT },
+};
+
+static struct rc_keymap avermedia_m733a_rm_k6_map = {
+	.map = {
+		.scan    = avermedia_m733a_rm_k6,
+		.size    = ARRAY_SIZE(avermedia_m733a_rm_k6),
+		.ir_type = IR_TYPE_NEC,
+		.name    = RC_MAP_AVERMEDIA_M733A_RM_K6,
+	}
+};
+
+static int __init init_rc_map_avermedia_m733a_rm_k6(void)
+{
+	return ir_register_map(&avermedia_m733a_rm_k6_map);
+}
+
+static void __exit exit_rc_map_avermedia_m733a_rm_k6(void)
+{
+	ir_unregister_map(&avermedia_m733a_rm_k6_map);
+}
+
+module_init(init_rc_map_avermedia_m733a_rm_k6)
+module_exit(exit_rc_map_avermedia_m733a_rm_k6)
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/video/saa7134/saa7134-cards.c b/drivers/media/video/saa7134/saa7134-cards.c
index 72700d4..6502166 100644
--- a/drivers/media/video/saa7134/saa7134-cards.c
+++ b/drivers/media/video/saa7134/saa7134-cards.c
@@ -3897,6 +3897,40 @@ struct saa7134_board saa7134_boards[] = {
 			.gpio = 0x01,
 		},
 	},
+	[SAA7134_BOARD_AVERMEDIA_M733A] = {
+		.name		= "Avermedia PCI M733A",
+		.audio_clock	= 0x00187de7,
+		.tuner_type	= TUNER_PHILIPS_TDA8290,
+		.radio_type	= UNSET,
+		.tuner_addr	= ADDR_UNSET,
+		.radio_addr	= ADDR_UNSET,
+		.tuner_config	= 0,
+		.gpiomask	= 0x020200000,
+		.inputs		= {{
+			.name = name_tv,
+			.vmux = 1,
+			.amux = TV,
+			.tv   = 1,
+		}, {
+			.name = name_comp1,
+			.vmux = 3,
+			.amux = LINE1,
+		}, {
+			.name = name_svideo,
+			.vmux = 8,
+			.amux = LINE1,
+		} },
+		.radio = {
+			.name = name_radio,
+			.amux = TV,
+			.gpio = 0x00200000,
+		},
+		.mute = {
+			.name = name_mute,
+			.amux = TV,
+			.gpio = 0x01,
+		},
+	},
 	[SAA7134_BOARD_BEHOLD_401] = {
 		/*       Beholder Intl. Ltd. 2008      */
 		/*Dmitry Belimov <d.belimov@gmail.com> */
@@ -5820,7 +5854,19 @@ struct pci_device_id saa7134_pci_tbl[] = {
 		.subvendor    = 0x1461, /* Avermedia Technologies Inc */
 		.subdevice    = 0xf11d,
 		.driver_data  = SAA7134_BOARD_AVERMEDIA_M135A,
-	}, {
+	},{
+		.vendor       = PCI_VENDOR_ID_PHILIPS,
+		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
+		.subvendor    = 0x1461, /* Avermedia Technologies Inc */
+		.subdevice    = 0x4155,
+		.driver_data  = SAA7134_BOARD_AVERMEDIA_M733A,
+	},{
+		.vendor       = PCI_VENDOR_ID_PHILIPS,
+		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
+		.subvendor    = 0x1461, /* Avermedia Technologies Inc */
+		.subdevice    = 0x4255,
+		.driver_data  = SAA7134_BOARD_AVERMEDIA_M733A,
+	},{
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7130,
 		.subvendor    = PCI_VENDOR_ID_PHILIPS,
@@ -6786,6 +6832,7 @@ static int saa7134_tda8290_callback(struct saa7134_dev *dev,
 	switch (dev->board) {
 	case SAA7134_BOARD_HAUPPAUGE_HVR1150:
 	case SAA7134_BOARD_HAUPPAUGE_HVR1120:
+	case SAA7134_BOARD_AVERMEDIA_M733A:
 		/* tda8290 + tda18271 */
 		ret = saa7134_tda8290_18271_callback(dev, command, arg);
 		break;
@@ -7087,6 +7134,14 @@ int saa7134_board_init1(struct saa7134_dev *dev)
 		saa_andorl(SAA7134_GPIO_GPMODE0 >> 2,   0x0000C000, 0x0000C000);
 		saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x0000C000, 0x0000C000);
 		break;
+	case SAA7134_BOARD_AVERMEDIA_M733A:
+		saa7134_set_gpio(dev, 1, 1);
+		msleep(10);
+		saa7134_set_gpio(dev, 1, 0);
+		msleep(10);
+		saa7134_set_gpio(dev, 1, 1);
+		dev->has_remote = SAA7134_REMOTE_GPIO;
+		break;
 	}
 	return 0;
 }
diff --git a/drivers/media/video/saa7134/saa7134-input.c b/drivers/media/video/saa7134/saa7134-input.c
index 28c230d..c44e235 100644
--- a/drivers/media/video/saa7134/saa7134-input.c
+++ b/drivers/media/video/saa7134/saa7134-input.c
@@ -662,6 +662,13 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 		mask_keycode = 0xffff;
 		raw_decode   = 1;
 		break;
+	case SAA7134_BOARD_AVERMEDIA_M733A:
+		ir_codes     = RC_MAP_AVERMEDIA_M733A_RM_K6;
+		mask_keydown = 0x0040000;
+		mask_keyup   = 0x0040000;
+		mask_keycode = 0xffff;
+		raw_decode   = 1;
+		break;
 	case SAA7134_BOARD_AVERMEDIA_777:
 	case SAA7134_BOARD_AVERMEDIA_A16AR:
 		ir_codes     = RC_MAP_AVERMEDIA;
diff --git a/drivers/media/video/saa7134/saa7134.h b/drivers/media/video/saa7134/saa7134.h
index 3962534..756a1ca 100644
--- a/drivers/media/video/saa7134/saa7134.h
+++ b/drivers/media/video/saa7134/saa7134.h
@@ -303,6 +303,7 @@ struct saa7134_format {
 #define SAA7134_BOARD_HAWELL_HW_404M7		177
 #define SAA7134_BOARD_BEHOLD_H7             178
 #define SAA7134_BOARD_BEHOLD_A7             179
+#define SAA7134_BOARD_AVERMEDIA_M733A       180
 
 #define SAA7134_MAXBOARDS 32
 #define SAA7134_INPUT_MAX 8
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index 5833966..6f1f9f7 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -56,6 +56,7 @@ void rc_map_init(void);
 #define RC_MAP_AVERMEDIA_CARDBUS         "rc-avermedia-cardbus"
 #define RC_MAP_AVERMEDIA_DVBT            "rc-avermedia-dvbt"
 #define RC_MAP_AVERMEDIA_M135A_RM_JX     "rc-avermedia-m135a-rm-jx"
+#define RC_MAP_AVERMEDIA_M733A_RM_K6     "rc-avermedia-m733a-rm-k6"
 #define RC_MAP_AVERMEDIA                 "rc-avermedia"
 #define RC_MAP_AVERTV_303                "rc-avertv-303"
 #define RC_MAP_BEHOLD_COLUMBUS           "rc-behold-columbus"
-- 
1.7.1
