Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-17.arcor-online.net ([151.189.21.57]:52846 "EHLO
	mail-in-17.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932548Ab0CJR7W (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Mar 2010 12:59:22 -0500
From: stefan.ringel@arcor.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, dheitmueller@kernellabs.com,
	Stefan Ringel <stefan.ringel@arcor.de>
Subject: [PATCH] tm6000: add new hybrid-stick
Date: Wed, 10 Mar 2010 18:57:57 +0100
Message-Id: <1268243877-29157-1-git-send-email-stefan.ringel@arcor.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stefan Ringel <stefan.ringel@arcor.de>

-add Hauppauge WinTV HVR 900H/WinTV USB2-Stick
	vid/pid
	0x2040/6601
	0x2040/6610
	0x2040/6611

-add Terratec Cinergy Hybrid-Stick
	vid/pid
	0x0ccd/0x00a5

-add Twinhan TU501(704D1)
	vid/pid
	0x13d3/0x3240
	0x13d3/0x3241
	0x13d3/0x3243
	0x13d3/0x3264


Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
---
 drivers/staging/tm6000/tm6000-cards.c |   39 +++++++++++++++++++++++++++-----
 1 files changed, 33 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-cards.c b/drivers/staging/tm6000/tm6000-cards.c
index 83cb4b9..2053008 100644
--- a/drivers/staging/tm6000/tm6000-cards.c
+++ b/drivers/staging/tm6000/tm6000-cards.c
@@ -47,6 +47,7 @@
 #define TM6010_BOARD_BEHOLD_WANDER		10
 #define TM6010_BOARD_BEHOLD_VOYAGER		11
 #define TM6010_BOARD_TERRATEC_CINERGY_HYBRID_XE	12
+#define TM6010_BOARD_TWINHAN_TU501		13
 
 #define TM6000_MAXBOARDS        16
 static unsigned int card[]     = {[0 ... (TM6000_MAXBOARDS - 1)] = UNSET };
@@ -169,7 +170,7 @@ struct tm6000_board tm6000_boards[] = {
 		.gpio_addr_tun_reset = TM6000_GPIO_4,
 	},
 	[TM6010_BOARD_HAUPPAUGE_900H] = {
-		.name         = "Hauppauge HVR-900H",
+		.name         = "Hauppauge WinTV HVR-900H / WinTV USB2-Stick",
 		.tuner_type   = TUNER_XC2028, /* has a XC3028 */
 		.tuner_addr   = 0xc2 >> 1,
 		.demod_addr   = 0x1e >> 1,
@@ -180,7 +181,7 @@ struct tm6000_board tm6000_boards[] = {
 			.has_zl10353  = 1,
 			.has_eeprom   = 1,
 		},
-		.gpio_addr_tun_reset = TM6000_GPIO_2,
+		.gpio_addr_tun_reset = TM6010_GPIO_2,
 	},
 	[TM6010_BOARD_BEHOLD_WANDER] = {
 		.name         = "Beholder Wander DVB-T/TV/FM USB2.0",
@@ -212,7 +213,22 @@ struct tm6000_board tm6000_boards[] = {
 		.gpio_addr_tun_reset = TM6000_GPIO_2,
 	},
 	[TM6010_BOARD_TERRATEC_CINERGY_HYBRID_XE] = {
-		.name         = "Terratec Cinergy Hybrid XE",
+		.name         = "Terratec Cinergy Hybrid XE / Cinergy Hybrid-Stick",
+		.tuner_type   = TUNER_XC2028, /* has a XC3028 */
+		.tuner_addr   = 0xc2 >> 1,
+		.demod_addr   = 0x1e >> 1,
+		.type         = TM6010,
+		.caps = {
+			.has_tuner    = 1,
+			.has_dvb      = 1,
+			.has_zl10353  = 1,
+			.has_eeprom   = 1,
+			.has_remote   = 1,
+		},
+		.gpio_addr_tun_reset = TM6010_GPIO_2,
+	},
+	[TM6010_BOARD_TWINHAN_TU501] = {
+		.name         = "Twinhan TU501(704D1)",
 		.tuner_type   = TUNER_XC2028, /* has a XC3028 */
 		.tuner_addr   = 0xc2 >> 1,
 		.demod_addr   = 0x1e >> 1,
@@ -236,9 +252,17 @@ struct usb_device_id tm6000_id_table [] = {
 	{ USB_DEVICE(0x14aa, 0x0620), .driver_info = TM6000_BOARD_FREECOM_AND_SIMILAR },
 	{ USB_DEVICE(0x06e1, 0xb339), .driver_info = TM6000_BOARD_ADSTECH_MINI_DUAL_TV },
 	{ USB_DEVICE(0x2040, 0x6600), .driver_info = TM6010_BOARD_HAUPPAUGE_900H },
+	{ USB_DEVICE(0x2040, 0x6601), .driver_info = TM6010_BOARD_HAUPPAUGE_900H },
+	{ USB_DEVICE(0x2040, 0x6610), .driver_info = TM6010_BOARD_HAUPPAUGE_900H },
+	{ USB_DEVICE(0x2040, 0x6611), .driver_info = TM6010_BOARD_HAUPPAUGE_900H },
 	{ USB_DEVICE(0x6000, 0xdec0), .driver_info = TM6010_BOARD_BEHOLD_WANDER },
 	{ USB_DEVICE(0x6000, 0xdec1), .driver_info = TM6010_BOARD_BEHOLD_VOYAGER },
 	{ USB_DEVICE(0x0ccd, 0x0086), .driver_info = TM6010_BOARD_TERRATEC_CINERGY_HYBRID_XE },
+	{ USB_DEVICE(0x0ccd, 0x00A5), .driver_info = TM6010_BOARD_TERRATEC_CINERGY_HYBRID_XE },
+	{ USB_DEVICE(0x13d3, 0x3240), .driver_info = TM6010_BOARD_TWINHAN_TU501 },
+	{ USB_DEVICE(0x13d3, 0x3241), .driver_info = TM6010_BOARD_TWINHAN_TU501 },
+	{ USB_DEVICE(0x13d3, 0x3243), .driver_info = TM6010_BOARD_TWINHAN_TU501 },
+	{ USB_DEVICE(0x13d3, 0x3264), .driver_info = TM6010_BOARD_TWINHAN_TU501 },
 	{ },
 };
 
@@ -271,7 +295,9 @@ int tm6000_tuner_callback(void *ptr, int component, int command, int arg)
 		case 0:
 			/* newer tuner can faster reset */
 			switch (dev->model) {
+			case TM6010_BOARD_HAUPPAUGE_900H:
 			case TM6010_BOARD_TERRATEC_CINERGY_HYBRID_XE:
+			case TM6010_BOARD_TWINHAN_TU501:
 				tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
 					       dev->tuner_reset_gpio, 0x01);
 				msleep(60);
@@ -328,11 +354,11 @@ int tm6000_cards_setup(struct tm6000_core *dev)
 	 */
 	switch (dev->model) {
 	case TM6010_BOARD_HAUPPAUGE_900H:
+	case TM6010_BOARD_TERRATEC_CINERGY_HYBRID_XE:
+	case TM6010_BOARD_TWINHAN_TU501:
 		/* Turn xceive 3028 on */
 		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN, TM6010_GPIO_3, 0x01);
-		msleep(11);
-		break;
-	case TM6010_BOARD_TERRATEC_CINERGY_HYBRID_XE:
+		msleep(15);
 		/* Turn zarlink zl10353 on */
 		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN, TM6010_GPIO_4, 0x00);
 		msleep(15);
@@ -445,6 +471,7 @@ static void tm6000_config_tuner (struct tm6000_core *dev)
 		switch(dev->model) {
 		case TM6010_BOARD_HAUPPAUGE_900H:
 		case TM6010_BOARD_TERRATEC_CINERGY_HYBRID_XE:
+		case TM6010_BOARD_TWINHAN_TU501:
 			ctl.fname = "xc3028L-v36.fw";
 			break;
 		default:
-- 
1.6.6.1

