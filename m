Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:34867 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497AbaBHQL3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Feb 2014 11:11:29 -0500
Received: by mail-wg0-f41.google.com with SMTP id n12so1502789wgh.2
        for <linux-media@vger.kernel.org>; Sat, 08 Feb 2014 08:11:27 -0800 (PST)
Message-ID: <1391875876.2944.3.camel@canaries32-MCP7A>
Subject: [PATCH] af9035: Move it913x single devices to af9035
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>, kapetr@mizera.cz
Date: Sat, 08 Feb 2014 16:11:16 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The generic v1 and v2 devices have been all tested.

IDs tested
USB_PID_ITETECH_IT9135 v1 & v2
USB_PID_ITETECH_IT9135_9005 v1
USB_PID_ITETECH_IT9135_9006 v2

Current Issues
There is no signal  on
USB_PID_ITETECH_IT9135 v2 

No SNR reported all devices.

All single devices tune and scan fine.

All remotes tested okay.

Dual device failed to register second adapter
USB_PID_KWORLD_UB499_2T_T09
It is not clear what the problem is at the moment.

So only single IDs are transferred in this patch.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/usb/dvb-usb-v2/af9035.c | 22 ++++++++++++++++------
 drivers/media/usb/dvb-usb-v2/it913x.c | 24 ------------------------
 2 files changed, 16 insertions(+), 30 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index 8ede8ea..3825c2f 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -1528,12 +1528,22 @@ static const struct usb_device_id af9035_id_table[] = {
 	{ DVB_USB_DEVICE(USB_VID_TERRATEC, 0x00aa,
 		&af9035_props, "TerraTec Cinergy T Stick (rev. 2)", NULL) },
 	/* IT9135 devices */
-#if 0
-	{ DVB_USB_DEVICE(0x048d, 0x9135,
-		&af9035_props, "IT9135 reference design", NULL) },
-	{ DVB_USB_DEVICE(0x048d, 0x9006,
-		&af9035_props, "IT9135 reference design", NULL) },
-#endif
+	{ DVB_USB_DEVICE(USB_VID_ITETECH, USB_PID_ITETECH_IT9135,
+		&af9035_props, "ITE 9135 Generic", RC_MAP_IT913X_V1) },
+	{ DVB_USB_DEVICE(USB_VID_ITETECH, USB_PID_ITETECH_IT9135_9005,
+		&af9035_props, "ITE 9135(9005) Generic", RC_MAP_IT913X_V2) },
+	{ DVB_USB_DEVICE(USB_VID_ITETECH, USB_PID_ITETECH_IT9135_9006,
+		&af9035_props, "ITE 9135(9006) Generic", RC_MAP_IT913X_V1) },
+	{ DVB_USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_A835B_1835,
+		&af9035_props, "Avermedia A835B(1835)", RC_MAP_IT913X_V2) },
+	{ DVB_USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_A835B_2835,
+		&af9035_props, "Avermedia A835B(2835)", RC_MAP_IT913X_V2) },
+	{ DVB_USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_A835B_3835,
+		&af9035_props, "Avermedia A835B(3835)", RC_MAP_IT913X_V2) },
+	{ DVB_USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_A835B_4835,
+		&af9035_props, "Avermedia A835B(4835)",	RC_MAP_IT913X_V2) },
+	{ DVB_USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_H335,
+		&af9035_props, "Avermedia H335", RC_MAP_IT913X_V2) },
 	/* XXX: that same ID [0ccd:0099] is used by af9015 driver too */
 	{ DVB_USB_DEVICE(USB_VID_TERRATEC, 0x0099,
 		&af9035_props, "TerraTec Cinergy T Stick Dual RC (rev. 2)", NULL) },
diff --git a/drivers/media/usb/dvb-usb-v2/it913x.c b/drivers/media/usb/dvb-usb-v2/it913x.c
index fe95a58..78bf8fd 100644
--- a/drivers/media/usb/dvb-usb-v2/it913x.c
+++ b/drivers/media/usb/dvb-usb-v2/it913x.c
@@ -772,36 +772,12 @@ static const struct usb_device_id it913x_id_table[] = {
 	{ DVB_USB_DEVICE(USB_VID_KWORLD_2, USB_PID_KWORLD_UB499_2T_T09,
 		&it913x_properties, "Kworld UB499-2T T09(IT9137)",
 			RC_MAP_IT913X_V1) },
-	{ DVB_USB_DEVICE(USB_VID_ITETECH, USB_PID_ITETECH_IT9135,
-		&it913x_properties, "ITE 9135 Generic",
-			RC_MAP_IT913X_V1) },
 	{ DVB_USB_DEVICE(USB_VID_KWORLD_2, USB_PID_SVEON_STV22_IT9137,
 		&it913x_properties, "Sveon STV22 Dual DVB-T HDTV(IT9137)",
 			RC_MAP_IT913X_V1) },
-	{ DVB_USB_DEVICE(USB_VID_ITETECH, USB_PID_ITETECH_IT9135_9005,
-		&it913x_properties, "ITE 9135(9005) Generic",
-			RC_MAP_IT913X_V2) },
-	{ DVB_USB_DEVICE(USB_VID_ITETECH, USB_PID_ITETECH_IT9135_9006,
-		&it913x_properties, "ITE 9135(9006) Generic",
-			RC_MAP_IT913X_V1) },
-	{ DVB_USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_A835B_1835,
-		&it913x_properties, "Avermedia A835B(1835)",
-			RC_MAP_IT913X_V2) },
-	{ DVB_USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_A835B_2835,
-		&it913x_properties, "Avermedia A835B(2835)",
-			RC_MAP_IT913X_V2) },
-	{ DVB_USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_A835B_3835,
-		&it913x_properties, "Avermedia A835B(3835)",
-			RC_MAP_IT913X_V2) },
-	{ DVB_USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_A835B_4835,
-		&it913x_properties, "Avermedia A835B(4835)",
-			RC_MAP_IT913X_V2) },
 	{ DVB_USB_DEVICE(USB_VID_KWORLD_2, USB_PID_CTVDIGDUAL_V2,
 		&it913x_properties, "Digital Dual TV Receiver CTVDIGDUAL_V2",
 			RC_MAP_IT913X_V1) },
-	{ DVB_USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_H335,
-		&it913x_properties, "Avermedia H335",
-			RC_MAP_IT913X_V2) },
 	{}		/* Terminating entry */
 };
 
-- 
1.9.rc1

