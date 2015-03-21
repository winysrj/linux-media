Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:36281 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbbCUUmc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Mar 2015 16:42:32 -0400
Received: by labe2 with SMTP id e2so33901351lab.3
        for <linux-media@vger.kernel.org>; Sat, 21 Mar 2015 13:42:30 -0700 (PDT)
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH] dw2102: TeVii S482 support
Date: Sat, 21 Mar 2015 22:42:23 +0200
Message-Id: <1426970543-28176-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

TeVii S482 is a PCIe device with two tuners that actually contains two 
USB devices. The devices are visible in the lsusb printout.

Bus 006 Device 002: ID 9022:d483 TeVii Technology Ltd.
Bus 007 Device 002: ID 9022:d484 TeVii Technology Ltd.

The device itself works exactly with the same settings as TechnoTrend 
TT-connect S2-4600. Firmware for DS3103 demodulator is required:
http://palosaari.fi/linux/v4l-dvb/firmware/M88DS3103/

This patch should be applied on top of the TT S2-4600 patch:
https://patchwork.linuxtv.org/patch/28818/

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/usb/dvb-usb/dw2102.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb/dw2102.c b/drivers/media/usb/dvb-usb/dw2102.c
index 9dc3619..1ca0e25 100644
--- a/drivers/media/usb/dvb-usb/dw2102.c
+++ b/drivers/media/usb/dvb-usb/dw2102.c
@@ -1659,6 +1659,8 @@ enum dw2102_table_entry {
 	GOTVIEW_SAT_HD,
 	GENIATECH_T220,
 	TECHNOTREND_S2_4600,
+	TEVII_S482_1,
+	TEVII_S482_2,
 };
 
 static struct usb_device_id dw2102_table[] = {
@@ -1684,6 +1686,8 @@ static struct usb_device_id dw2102_table[] = {
 	[GENIATECH_T220] = {USB_DEVICE(0x1f4d, 0xD220)},
 	[TECHNOTREND_S2_4600] = {USB_DEVICE(USB_VID_TECHNOTREND,
 		USB_PID_TECHNOTREND_CONNECT_S2_4600)},
+	[TEVII_S482_1] = {USB_DEVICE(0x9022, 0xd483)},
+	[TEVII_S482_2] = {USB_DEVICE(0x9022, 0xd484)},
 	{ }
 };
 
@@ -2201,12 +2205,20 @@ static struct dvb_usb_device_properties tt_s2_4600_properties = {
 		} },
 		}
 	},
-	.num_device_descs = 1,
+	.num_device_descs = 3,
 	.devices = {
 		{ "TechnoTrend TT-connect S2-4600",
 			{ &dw2102_table[TECHNOTREND_S2_4600], NULL },
 			{ NULL },
 		},
+		{ "TeVii S482 (tuner 1)",
+			{ &dw2102_table[TEVII_S482_1], NULL },
+			{ NULL },
+		},
+		{ "TeVii S482 (tuner 2)",
+			{ &dw2102_table[TEVII_S482_2], NULL },
+			{ NULL },
+		},
 	}
 };
 
-- 
1.9.1

