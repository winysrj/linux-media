Return-path: <linux-media-owner@vger.kernel.org>
Received: from sirokuusama2.dnainternet.net ([83.102.40.153]:55214 "EHLO
	sirokuusama2.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423534AbcFMOLL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jun 2016 10:11:11 -0400
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH] dw2102: add USB ID for Terratec Cinergy S2 Rev.3
Date: Mon, 13 Jun 2016 17:04:50 +0300
Message-Id: <1465826690-11770-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the USB ID for Terratec Cinergy S2 Rev.3 (0ccd:0102).

Curiously dvb-usb-ids included already the USB ID for TERRATEC_CINERGY_S2_R3 even if the device was not supported.

Reported-by: Christian Knippel <namerp@googlemail.com>
Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/usb/dvb-usb/dw2102.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb/dw2102.c b/drivers/media/usb/dvb-usb/dw2102.c
index 49b55d7..961f64e 100644
--- a/drivers/media/usb/dvb-usb/dw2102.c
+++ b/drivers/media/usb/dvb-usb/dw2102.c
@@ -1641,6 +1641,7 @@ enum dw2102_table_entry {
 	TEVII_S421,
 	TEVII_S632,
 	TERRATEC_CINERGY_S2_R2,
+	TERRATEC_CINERGY_S2_R3,
 	GOTVIEW_SAT_HD,
 	GENIATECH_T220,
 	TECHNOTREND_S2_4600,
@@ -1669,6 +1670,7 @@ static struct usb_device_id dw2102_table[] = {
 	[TEVII_S421] = {USB_DEVICE(0x9022, USB_PID_TEVII_S421)},
 	[TEVII_S632] = {USB_DEVICE(0x9022, USB_PID_TEVII_S632)},
 	[TERRATEC_CINERGY_S2_R2] = {USB_DEVICE(USB_VID_TERRATEC, USB_PID_TERRATEC_CINERGY_S2_R2)},
+	[TERRATEC_CINERGY_S2_R3] = {USB_DEVICE(USB_VID_TERRATEC, USB_PID_TERRATEC_CINERGY_S2_R3)},
 	[GOTVIEW_SAT_HD] = {USB_DEVICE(0x1FE1, USB_PID_GOTVIEW_SAT_HD)},
 	[GENIATECH_T220] = {USB_DEVICE(0x1f4d, 0xD220)},
 	[TECHNOTREND_S2_4600] = {USB_DEVICE(USB_VID_TECHNOTREND,
@@ -2083,7 +2085,7 @@ static struct dvb_usb_device_properties su3000_properties = {
 		}},
 		}
 	},
-	.num_device_descs = 5,
+	.num_device_descs = 6,
 	.devices = {
 		{ "SU3000HD DVB-S USB2.0",
 			{ &dw2102_table[GENIATECH_SU3000], NULL },
@@ -2101,6 +2103,10 @@ static struct dvb_usb_device_properties su3000_properties = {
 			{ &dw2102_table[TERRATEC_CINERGY_S2_R2], NULL },
 			{ NULL },
 		},
+		{ "Terratec Cinergy S2 USB HD Rev.3",
+			{ &dw2102_table[TERRATEC_CINERGY_S2_R3], NULL },
+			{ NULL },
+		},
 		{ "GOTVIEW Satellite HD",
 			{ &dw2102_table[GOTVIEW_SAT_HD], NULL },
 			{ NULL },
-- 
2.5.0

