Return-path: <linux-media-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:56353 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756439Ab0DEWQJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Apr 2010 18:16:09 -0400
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: linux-media@vger.kernel.org
Subject: [PATCH] saa7134: add support for Avermedia M733A
Date: Mon, 5 Apr 2010 19:16:00 -0300
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201004051916.00483.herton@mandriva.com.br>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This change adds support for Avermedia M733A. The original version for
linux 2.6.31 was sent to me from Avermedia, original author is unknown.
I ported it to current kernels, and modified for the two pci ids
supported (1461:4155, 1461:4255).

Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
---
 Documentation/video4linux/CARDLIST.saa7134  |    1 +
 drivers/media/IR/ir-keymaps.c               |   53 +++++++++++++++++++++++++
 drivers/media/video/saa7134/saa7134-cards.c |   57 ++++++++++++++++++++++++++-
 drivers/media/video/saa7134/saa7134-input.c |    6 +++
 drivers/media/video/saa7134/saa7134.h       |    1 +
 include/media/ir-common.h                   |    1 +
 6 files changed, 118 insertions(+), 1 deletions(-)

diff --git a/Documentation/video4linux/CARDLIST.saa7134 b/Documentation/video4linux/CARDLIST.saa7134
index bb3d5fa..321d00b 100644
--- a/Documentation/video4linux/CARDLIST.saa7134
+++ b/Documentation/video4linux/CARDLIST.saa7134
@@ -176,3 +176,4 @@
 175 -> Leadtek Winfast DTV1000S                 [107d:6655]
 176 -> Beholder BeholdTV 505 RDS                [0000:5051]
 177 -> Hawell HW-404M7
+178 -> Avermedia M733A                          [1461:4155,1461:4255]
diff --git a/drivers/media/IR/ir-keymaps.c b/drivers/media/IR/ir-keymaps.c
index dfc777b..8c8c056 100644
--- a/drivers/media/IR/ir-keymaps.c
+++ b/drivers/media/IR/ir-keymaps.c
@@ -172,6 +172,59 @@ static struct ir_scancode ir_codes_avermedia_m135a[] = {
 };
 IR_TABLE(avermedia_m135a, IR_TYPE_UNKNOWN, ir_codes_avermedia_m135a);
 
+/* Herton Ronaldo Krzesinski <herton@mandriva.com.br> */
+static struct ir_scancode ir_codes_avermedia_m733a[] = {
+	{ 0x00, KEY_POWER2 },
+	{ 0x2e, KEY_DOT },
+	{ 0x01, KEY_MODE },
+
+	{ 0x05, KEY_1 },
+	{ 0x06, KEY_2 },
+	{ 0x07, KEY_3 },
+	{ 0x09, KEY_4 },
+	{ 0x0a, KEY_5 },
+	{ 0x0b, KEY_6 },
+	{ 0x0d, KEY_7 },
+	{ 0x0e, KEY_8 },
+	{ 0x0f, KEY_9 },
+	{ 0x11, KEY_0 },
+
+	{ 0x13, KEY_RIGHT },
+	{ 0x12, KEY_LEFT },
+
+	{ 0x17, KEY_SLEEP },
+	{ 0x10, KEY_SHUFFLE },
+
+	{ 0x43, KEY_CHANNELUP },
+	{ 0x42, KEY_CHANNELDOWN },
+	{ 0x1f, KEY_VOLUMEUP },
+	{ 0x1e, KEY_VOLUMEDOWN },
+	{ 0x0c, KEY_ENTER },
+
+	{ 0x14, KEY_MUTE },
+	{ 0x08, KEY_AUDIO },
+
+	{ 0x03, KEY_TEXT },
+	{ 0x04, KEY_EPG },
+	{ 0x2b, KEY_TV2 },
+
+	{ 0x1d, KEY_RED },
+	{ 0x1c, KEY_YELLOW },
+	{ 0x41, KEY_GREEN },
+	{ 0x40, KEY_BLUE },
+
+	{ 0x1a, KEY_PLAYPAUSE },
+	{ 0x19, KEY_RECORD },
+	{ 0x18, KEY_PLAY },
+	{ 0x1b, KEY_STOP },
+};
+
+struct ir_scancode_table ir_codes_avermedia_m733a_table = {
+	.scan = ir_codes_avermedia_m733a,
+	.size = ARRAY_SIZE(ir_codes_avermedia_m733a),
+};
+EXPORT_SYMBOL_GPL(ir_codes_avermedia_m733a_table);
+
 /* Oldrich Jedlicka <oldium.pro@seznam.cz> */
 static struct ir_scancode ir_codes_avermedia_cardbus[] = {
 	{ 0x00, KEY_POWER },
diff --git a/drivers/media/video/saa7134/saa7134-cards.c b/drivers/media/video/saa7134/saa7134-cards.c
index 655068f..bf53270 100644
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
@@ -5764,7 +5798,19 @@ struct pci_device_id saa7134_pci_tbl[] = {
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
@@ -6716,6 +6762,7 @@ static int saa7134_tda8290_callback(struct saa7134_dev *dev,
 	switch (dev->board) {
 	case SAA7134_BOARD_HAUPPAUGE_HVR1150:
 	case SAA7134_BOARD_HAUPPAUGE_HVR1120:
+	case SAA7134_BOARD_AVERMEDIA_M733A:
 		/* tda8290 + tda18271 */
 		ret = saa7134_tda8290_18271_callback(dev, command, arg);
 		break;
@@ -7015,6 +7062,14 @@ int saa7134_board_init1(struct saa7134_dev *dev)
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
index 8c67904..c648a8b 100644
--- a/drivers/media/video/saa7134/saa7134-input.c
+++ b/drivers/media/video/saa7134/saa7134-input.c
@@ -529,6 +529,12 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 		mask_keycode = 0x00013f;
 		nec_gpio     = 1;
 		break;
+	case SAA7134_BOARD_AVERMEDIA_M733A:
+		ir_codes     = &ir_codes_avermedia_m733a_table;
+		mask_keydown = 0x0040000;
+		mask_keycode = 0x00013f;
+		nec_gpio     = 1;
+		break;
 	case SAA7134_BOARD_AVERMEDIA_777:
 	case SAA7134_BOARD_AVERMEDIA_A16AR:
 		ir_codes     = &ir_codes_avermedia_table;
diff --git a/drivers/media/video/saa7134/saa7134.h b/drivers/media/video/saa7134/saa7134.h
index c3a1ae0..bd0bc93 100644
--- a/drivers/media/video/saa7134/saa7134.h
+++ b/drivers/media/video/saa7134/saa7134.h
@@ -301,6 +301,7 @@ struct saa7134_format {
 #define SAA7134_BOARD_LEADTEK_WINFAST_DTV1000S 175
 #define SAA7134_BOARD_BEHOLD_505RDS_MK3     176
 #define SAA7134_BOARD_HAWELL_HW_404M7		177
+#define SAA7134_BOARD_AVERMEDIA_M733A		178
 
 #define SAA7134_MAXBOARDS 32
 #define SAA7134_INPUT_MAX 8
diff --git a/include/media/ir-common.h b/include/media/ir-common.h
index c662980..9625ffe 100644
--- a/include/media/ir-common.h
+++ b/include/media/ir-common.h
@@ -103,6 +103,7 @@ extern struct ir_scancode_table ir_codes_empty_table;
 extern struct ir_scancode_table ir_codes_avermedia_table;
 extern struct ir_scancode_table ir_codes_avermedia_dvbt_table;
 extern struct ir_scancode_table ir_codes_avermedia_m135a_table;
+extern struct ir_scancode_table ir_codes_avermedia_m733a_table;
 extern struct ir_scancode_table ir_codes_avermedia_cardbus_table;
 extern struct ir_scancode_table ir_codes_apac_viewcomp_table;
 extern struct ir_scancode_table ir_codes_pixelview_table;
-- 
1.7.0.4

