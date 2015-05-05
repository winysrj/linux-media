Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:42185 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752277AbbEEV67 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 May 2015 17:58:59 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 08/21] af9035: fix device order in ID list
Date: Wed,  6 May 2015 00:58:29 +0300
Message-Id: <1430863122-9888-8-git-send-email-crope@iki.fi>
In-Reply-To: <1430863122-9888-1-git-send-email-crope@iki.fi>
References: <1430863122-9888-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Driver supports multiple chipset versions. Devices are ordered to
ID table per used chipset type. "ITE 9303 Generic" device uses IT9303
chipset and was added mistakenly between IT9135 IDs.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/af9035.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index 558166d..ae72357 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -2026,6 +2026,7 @@ static const struct usb_device_id af9035_id_table[] = {
 		&af9035_props, "Asus U3100Mini Plus", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_TERRATEC, 0x00aa,
 		&af9035_props, "TerraTec Cinergy T Stick (rev. 2)", NULL) },
+
 	/* IT9135 devices */
 	{ DVB_USB_DEVICE(USB_VID_ITETECH, USB_PID_ITETECH_IT9135,
 		&af9035_props, "ITE 9135 Generic", RC_MAP_IT913X_V1) },
@@ -2051,9 +2052,6 @@ static const struct usb_device_id af9035_id_table[] = {
 	{ DVB_USB_DEVICE(USB_VID_KWORLD_2, USB_PID_CTVDIGDUAL_V2,
 		&af9035_props, "Digital Dual TV Receiver CTVDIGDUAL_V2",
 							RC_MAP_IT913X_V1) },
-	/* IT930x devices */
-	{ DVB_USB_DEVICE(USB_VID_ITETECH, USB_PID_ITETECH_IT9303,
-		&it930x_props, "ITE 9303 Generic", NULL) },
 	/* XXX: that same ID [0ccd:0099] is used by af9015 driver too */
 	{ DVB_USB_DEVICE(USB_VID_TERRATEC, 0x0099,
 		&af9035_props, "TerraTec Cinergy T Stick Dual RC (rev. 2)",
@@ -2066,6 +2064,10 @@ static const struct usb_device_id af9035_id_table[] = {
 		&af9035_props, "PCTV AndroiDTV (78e)", RC_MAP_IT913X_V1) },
 	{ DVB_USB_DEVICE(USB_VID_PCTV, USB_PID_PCTV_79E,
 		&af9035_props, "PCTV microStick (79e)", RC_MAP_IT913X_V2) },
+
+	/* IT930x devices */
+	{ DVB_USB_DEVICE(USB_VID_ITETECH, USB_PID_ITETECH_IT9303,
+		&it930x_props, "ITE 9303 Generic", NULL) },
 	{ }
 };
 MODULE_DEVICE_TABLE(usb, af9035_id_table);
-- 
http://palosaari.fi/

