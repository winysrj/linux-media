Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:36383 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934596AbcCPL4n (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Mar 2016 07:56:43 -0400
Received: by mail-lb0-f178.google.com with SMTP id x1so46128190lbj.3
        for <linux-media@vger.kernel.org>; Wed, 16 Mar 2016 04:56:42 -0700 (PDT)
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>,
	Christian Knippel <namerp@gmail.com>
Subject: [PATCH] az6027: Add support for Elgato EyeTV Sat v3
Date: Wed, 16 Mar 2016 13:56:30 +0200
Message-Id: <1458129390-14025-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Another version of Elgato EyeTV Sat USB DVB-S2 adapter needs just
a USB ID addition.

Signed-off-by: Christian Knippel <namerp@gmail.com>
Reported-by: Olli Salonen <olli.salonen@iki.fi>

---
 drivers/media/dvb-core/dvb-usb-ids.h | 1 +
 drivers/media/usb/dvb-usb/az6027.c   | 7 ++++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-core/dvb-usb-ids.h b/drivers/media/dvb-core/dvb-usb-ids.h
index 0afad39..f94e58f 100644
--- a/drivers/media/dvb-core/dvb-usb-ids.h
+++ b/drivers/media/dvb-core/dvb-usb-ids.h
@@ -373,6 +373,7 @@
 #define USB_PID_ELGATO_EYETV_DTT_Dlx			0x0020
 #define USB_PID_ELGATO_EYETV_SAT			0x002a
 #define USB_PID_ELGATO_EYETV_SAT_V2			0x0025
+#define USB_PID_ELGATO_EYETV_SAT_V3			0x0036
 #define USB_PID_DVB_T_USB_STICK_HIGH_SPEED_COLD		0x5000
 #define USB_PID_DVB_T_USB_STICK_HIGH_SPEED_WARM		0x5001
 #define USB_PID_FRIIO_WHITE				0x0001
diff --git a/drivers/media/usb/dvb-usb/az6027.c b/drivers/media/usb/dvb-usb/az6027.c
index 92e47d6..2e71136 100644
--- a/drivers/media/usb/dvb-usb/az6027.c
+++ b/drivers/media/usb/dvb-usb/az6027.c
@@ -1090,6 +1090,7 @@ static struct usb_device_id az6027_usb_table[] = {
 	{ USB_DEVICE(USB_VID_TECHNISAT, USB_PID_TECHNISAT_USB2_HDCI_V2) },
 	{ USB_DEVICE(USB_VID_ELGATO, USB_PID_ELGATO_EYETV_SAT) },
 	{ USB_DEVICE(USB_VID_ELGATO, USB_PID_ELGATO_EYETV_SAT_V2) },
+	{ USB_DEVICE(USB_VID_ELGATO, USB_PID_ELGATO_EYETV_SAT_V3) },
 	{ },
 };
 
@@ -1138,7 +1139,7 @@ static struct dvb_usb_device_properties az6027_properties = {
 
 	.i2c_algo         = &az6027_i2c_algo,
 
-	.num_device_descs = 7,
+	.num_device_descs = 8,
 	.devices = {
 		{
 			.name = "AZUREWAVE DVB-S/S2 USB2.0 (AZ6027)",
@@ -1168,6 +1169,10 @@ static struct dvb_usb_device_properties az6027_properties = {
 			.name = "Elgato EyeTV Sat",
 			.cold_ids = { &az6027_usb_table[6], NULL },
 			.warm_ids = { NULL },
+		}, {
+			.name = "Elgato EyeTV Sat",
+			.cold_ids = { &az6027_usb_table[7], NULL },
+			.warm_ids = { NULL },
 		},
 		{ NULL },
 	}
-- 
1.9.1

