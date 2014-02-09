Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:36951 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852AbaBINE1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 Feb 2014 08:04:27 -0500
Received: by mail-we0-f170.google.com with SMTP id w62so3540093wes.1
        for <linux-media@vger.kernel.org>; Sun, 09 Feb 2014 05:04:26 -0800 (PST)
Message-ID: <1391951046.13992.15.camel@canaries32-MCP7A>
Subject: [PATCH 2/2] af9035: Add remaining it913x dual ids to af9035.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Date: Sun, 09 Feb 2014 13:04:06 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As follow on to patch
af9035: Move it913x single devices to af9035
and patch 1.

SNR is reported as db/10 values.

All dual ids are added to af9035 and it913x driver disabled.

it913x/it913x-fe removal patches to follow.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/usb/dvb-usb-v2/af9035.c | 8 ++++++++
 drivers/media/usb/dvb-usb-v2/it913x.c | 5 +++++
 2 files changed, 13 insertions(+)

diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index 4f682ad..49e8360 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -1552,6 +1552,14 @@ static const struct usb_device_id af9035_id_table[] = {
 		&af9035_props, "Avermedia A835B(4835)",	RC_MAP_IT913X_V2) },
 	{ DVB_USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_H335,
 		&af9035_props, "Avermedia H335", RC_MAP_IT913X_V2) },
+	{ DVB_USB_DEVICE(USB_VID_KWORLD_2, USB_PID_KWORLD_UB499_2T_T09,
+		&af9035_props, "Kworld UB499-2T T09", RC_MAP_IT913X_V1) },
+	{ DVB_USB_DEVICE(USB_VID_KWORLD_2, USB_PID_SVEON_STV22_IT9137,
+		&af9035_props, "Sveon STV22 Dual DVB-T HDTV",
+							RC_MAP_IT913X_V1) },
+	{ DVB_USB_DEVICE(USB_VID_KWORLD_2, USB_PID_CTVDIGDUAL_V2,
+		&af9035_props, "Digital Dual TV Receiver CTVDIGDUAL_V2",
+							RC_MAP_IT913X_V1) },
 	/* XXX: that same ID [0ccd:0099] is used by af9015 driver too */
 	{ DVB_USB_DEVICE(USB_VID_TERRATEC, 0x0099,
 		&af9035_props, "TerraTec Cinergy T Stick Dual RC (rev. 2)", NULL) },
diff --git a/drivers/media/usb/dvb-usb-v2/it913x.c b/drivers/media/usb/dvb-usb-v2/it913x.c
index 78bf8fd..39488f8 100644
--- a/drivers/media/usb/dvb-usb-v2/it913x.c
+++ b/drivers/media/usb/dvb-usb-v2/it913x.c
@@ -781,6 +781,8 @@ static const struct usb_device_id it913x_id_table[] = {
 	{}		/* Terminating entry */
 };
 
+#if 0
+
 MODULE_DEVICE_TABLE(usb, it913x_id_table);
 
 static struct usb_driver it913x_driver = {
@@ -792,8 +794,11 @@ static struct usb_driver it913x_driver = {
 	.id_table	= it913x_id_table,
 };
 
+
 module_usb_driver(it913x_driver);
 
+#endif
+
 MODULE_AUTHOR("Malcolm Priestley <tvboxspy@gmail.com>");
 MODULE_DESCRIPTION("it913x USB 2 Driver");
 MODULE_VERSION("1.33");
-- 
1.9.rc1

