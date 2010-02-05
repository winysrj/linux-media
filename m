Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-01.arcor-online.net ([151.189.21.41]:54393 "EHLO
	mail-in-01.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933881Ab0BEW5q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Feb 2010 17:57:46 -0500
From: stefan.ringel@arcor.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, dheitmueller@kernellabs.com,
	Stefan Ringel <stefan.ringel@arcor.de>
Subject: [PATCH 1/12] tm6000: add Terratec Cinergy Hybrid XE
Date: Fri,  5 Feb 2010 23:57:01 +0100
Message-Id: <1265410631-11955-1-git-send-email-stefan.ringel@arcor.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stefan Ringel <stefan.ringel@arcor.de>

Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
---
 drivers/staging/tm6000/tm6000-cards.c |   22 +++++++++++++++++++++-
 1 files changed, 21 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-cards.c b/drivers/staging/tm6000/tm6000-cards.c
index c4db903..7f594a2 100644
--- a/drivers/staging/tm6000/tm6000-cards.c
+++ b/drivers/staging/tm6000/tm6000-cards.c
@@ -44,6 +44,10 @@
 #define TM6000_BOARD_FREECOM_AND_SIMILAR	7
 #define TM6000_BOARD_ADSTECH_MINI_DUAL_TV	8
 #define TM6010_BOARD_HAUPPAUGE_900H		9
+#define TM6010_BOARD_BEHOLD_WANDER		10
+#define TM6010_BOARD_BEHOLD_VOYAGER		11
+#define TM6010_BOARD_TERRATEC_CINERGY_HYBRID_XE	12
+
 
 #define TM6000_MAXBOARDS        16
 static unsigned int card[]     = {[0 ... (TM6000_MAXBOARDS - 1)] = UNSET };
@@ -208,7 +212,21 @@ struct tm6000_board tm6000_boards[] = {
 		},
 		.gpio_addr_tun_reset = TM6000_GPIO_2,
 	},
-
+	[TM6010_BOARD_TERRATEC_CINERGY_HYBRID_XE] = {
+		.name         = "Terratec Cinergy Hybrid XE",
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
+	}
 };
 
 /* table of devices that work with this driver */
@@ -221,6 +239,7 @@ struct usb_device_id tm6000_id_table [] = {
 	{ USB_DEVICE(0x2040, 0x6600), .driver_info = TM6010_BOARD_HAUPPAUGE_900H },
 	{ USB_DEVICE(0x6000, 0xdec0), .driver_info = TM6010_BOARD_BEHOLD_WANDER },
 	{ USB_DEVICE(0x6000, 0xdec1), .driver_info = TM6010_BOARD_BEHOLD_VOYAGER },
+	{ USB_DEVICE(0x0ccd, 0x0086), .driver_info = TM6010_BOARD_TERRATEC_CINERGY_HYBRID_XE },
 	{ },
 };
 
@@ -311,6 +330,7 @@ static void tm6000_config_tuner (struct tm6000_core *dev)
 
 		switch(dev->model) {
 		case TM6010_BOARD_HAUPPAUGE_900H:
+		case TM6010_BOARD_TERRATEC_CINERGY_HYBRID_XE:
 			ctl.fname = "xc3028L-v36.fw";
 			break;
 		default:
-- 
1.6.4.2

