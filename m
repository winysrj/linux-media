Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:55316 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757874Ab2HVXmX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Aug 2012 19:42:23 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/2] dvb_usb_v2: add debug macro dvb_usb_dbg_usb_control_msg
Date: Thu, 23 Aug 2012 02:41:59 +0300
Message-Id: <1345678920-6360-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For dumping usb_control_msg().

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/dvb_usb.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb.h b/drivers/media/usb/dvb-usb-v2/dvb_usb.h
index 5a53c62..bae16a1 100644
--- a/drivers/media/usb/dvb-usb-v2/dvb_usb.h
+++ b/drivers/media/usb/dvb-usb-v2/dvb_usb.h
@@ -63,6 +63,17 @@
 #define fe_to_priv(fe) (fe_to_d(fe)->priv)
 #define d_to_priv(d) (d->priv)
 
+#define dvb_usb_dbg_usb_control_msg(udev, r, t, v, i, b, l) { \
+	char *direction; \
+	if (t == (USB_TYPE_VENDOR | USB_DIR_OUT)) \
+		direction = ">>>"; \
+	else \
+		direction = "<<<"; \
+	dev_dbg(&udev->dev, "%s: %02x %02x %02x %02x %02x %02x %02x %02x " \
+			"%s %*ph\n",  __func__, t, r, v & 0xff, v >> 8, \
+			i & 0xff, i >> 8, l & 0xff, l >> 8, direction, l, b); \
+}
+
 #define DVB_USB_STREAM_BULK(endpoint_, count_, size_) { \
 	.type = USB_BULK, \
 	.count = count_, \
-- 
1.7.11.4

