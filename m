Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:49488 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752760AbaBLTqc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Feb 2014 14:46:32 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Malcolm Priestley <tvboxspy@gmail.com>,
	Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 3/4] af9035: Add remaining it913x dual ids to af9035.
Date: Wed, 12 Feb 2014 21:46:17 +0200
Message-Id: <1392234378-20959-3-git-send-email-crope@iki.fi>
In-Reply-To: <1392234378-20959-1-git-send-email-crope@iki.fi>
References: <1392234378-20959-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Malcolm Priestley <tvboxspy@gmail.com>

As follow on to patch
af9035: Move it913x single devices to af9035
and patch 1.

SNR is reported as db/10 values.

All dual ids are added to af9035 and it913x driver disabled.

it913x/it913x-fe removal patches to follow.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Signed-off-by: Antti Palosaari <crope@iki.fi>
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
1.8.5.3

