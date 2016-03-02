Return-path: <linux-media-owner@vger.kernel.org>
Received: from nautilus.laiva.org ([62.142.120.74]:55161 "EHLO
	nautilus.laiva.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbcCBLNN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Mar 2016 06:13:13 -0500
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH 2/2] dw2102: add support for TeVii S662
Date: Wed,  2 Mar 2016 13:06:06 +0200
Message-Id: <1456916766-28165-2-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1456916766-28165-1-git-send-email-olli.salonen@iki.fi>
References: <1456916766-28165-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

TeVii S662 is a USB 2.0 DVB-S2 tuner that's identical to TechnoTrend
S2-4600 tuner. Add the USB ID to dw2102 driver.

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/usb/dvb-usb/dw2102.c |   23 +++++++++++++++++------
 1 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/dw2102.c b/drivers/media/usb/dvb-usb/dw2102.c
index 8fd1aae..aa9a203 100644
--- a/drivers/media/usb/dvb-usb/dw2102.c
+++ b/drivers/media/usb/dvb-usb/dw2102.c
@@ -1,9 +1,10 @@
 /* DVB USB framework compliant Linux driver for the
  *	DVBWorld DVB-S 2101, 2102, DVB-S2 2104, DVB-C 3101,
- *	TeVii S600, S630, S650, S660, S480, S421, S632
+ *	TeVii S421, S480, S482, S600, S630, S632, S650, S660, S662,
  *	Prof 1100, 7500,
  *	Geniatech SU3000, T220,
- *	TechnoTrend S2-4600 Cards
+ *	TechnoTrend S2-4600,
+ *	Terratec Cinergy S2 cards
  * Copyright (C) 2008-2012 Igor M. Liplianin (liplianin@me.by)
  *
  *	This program is free software; you can redistribute it and/or modify it
@@ -65,6 +66,10 @@
 #define USB_PID_TEVII_S660 0xd660
 #endif
 
+#ifndef USB_PID_TEVII_S662
+#define USB_PID_TEVII_S662 0xd662
+#endif
+
 #ifndef USB_PID_TEVII_S480_1
 #define USB_PID_TEVII_S480_1 0xd481
 #endif
@@ -1688,6 +1693,7 @@ enum dw2102_table_entry {
 	TEVII_S482_1,
 	TEVII_S482_2,
 	TERRATEC_CINERGY_S2_BOX,
+	TEVII_S662
 };
 
 static struct usb_device_id dw2102_table[] = {
@@ -1716,6 +1722,7 @@ static struct usb_device_id dw2102_table[] = {
 	[TEVII_S482_1] = {USB_DEVICE(0x9022, 0xd483)},
 	[TEVII_S482_2] = {USB_DEVICE(0x9022, 0xd484)},
 	[TERRATEC_CINERGY_S2_BOX] = {USB_DEVICE(USB_VID_TERRATEC, 0x0105)},
+	[TEVII_S662] = {USB_DEVICE(0x9022, USB_PID_TEVII_S662)},
 	{ }
 };
 
@@ -2233,7 +2240,7 @@ static struct dvb_usb_device_properties tt_s2_4600_properties = {
 		} },
 		}
 	},
-	.num_device_descs = 4,
+	.num_device_descs = 5,
 	.devices = {
 		{ "TechnoTrend TT-connect S2-4600",
 			{ &dw2102_table[TECHNOTREND_S2_4600], NULL },
@@ -2251,6 +2258,10 @@ static struct dvb_usb_device_properties tt_s2_4600_properties = {
 			{ &dw2102_table[TERRATEC_CINERGY_S2_BOX], NULL },
 			{ NULL },
 		},
+		{ "TeVii S662",
+			{ &dw2102_table[TEVII_S662], NULL },
+			{ NULL },
+		},
 	}
 };
 
@@ -2364,10 +2375,10 @@ module_usb_driver(dw2102_driver);
 MODULE_AUTHOR("Igor M. Liplianin (c) liplianin@me.by");
 MODULE_DESCRIPTION("Driver for DVBWorld DVB-S 2101, 2102, DVB-S2 2104,"
 			" DVB-C 3101 USB2.0,"
-			" TeVii S600, S630, S650, S660, S480, S421, S632"
-			" Prof 1100, 7500 USB2.0,"
+			" TeVii S421, S480, S482, S600, S630, S632, S650,"
+			" TeVii S660, S662, Prof 1100, 7500 USB2.0,"
 			" Geniatech SU3000, T220,"
-			" TechnoTrend S2-4600 devices");
+			" TechnoTrend S2-4600, Terratec Cinergy S2 devices");
 MODULE_VERSION("0.1");
 MODULE_LICENSE("GPL");
 MODULE_FIRMWARE(DW2101_FIRMWARE);
-- 
1.7.0.4

