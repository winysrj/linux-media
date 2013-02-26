Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:48686 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753015Ab3BZRYD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Feb 2013 12:24:03 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: poma <pomidorabelisima@gmail.com>, Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/5] dvb_usb_v2: locked versions of USB bulk IO functions
Date: Tue, 26 Feb 2013 19:23:02 +0200
Message-Id: <1361899386-22946-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implement:
dvb_usbv2_generic_rw_locked()
dvb_usbv2_generic_write_locked()

Caller must hold device lock when locked versions are called.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/dvb_usb.h     |  4 ++++
 drivers/media/usb/dvb-usb-v2/dvb_usb_urb.c | 38 ++++++++++++++++++++++++++----
 2 files changed, 37 insertions(+), 5 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb.h b/drivers/media/usb/dvb-usb-v2/dvb_usb.h
index 3cac8bd..42801f8 100644
--- a/drivers/media/usb/dvb-usb-v2/dvb_usb.h
+++ b/drivers/media/usb/dvb-usb-v2/dvb_usb.h
@@ -400,5 +400,9 @@ extern int dvb_usbv2_reset_resume(struct usb_interface *);
 /* the generic read/write method for device control */
 extern int dvb_usbv2_generic_rw(struct dvb_usb_device *, u8 *, u16, u8 *, u16);
 extern int dvb_usbv2_generic_write(struct dvb_usb_device *, u8 *, u16);
+/* caller must hold lock when locked versions are called */
+extern int dvb_usbv2_generic_rw_locked(struct dvb_usb_device *,
+		u8 *, u16, u8 *, u16);
+extern int dvb_usbv2_generic_write_locked(struct dvb_usb_device *, u8 *, u16);
 
 #endif
diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb_urb.c b/drivers/media/usb/dvb-usb-v2/dvb_usb_urb.c
index 5716662..74c911f 100644
--- a/drivers/media/usb/dvb-usb-v2/dvb_usb_urb.c
+++ b/drivers/media/usb/dvb-usb-v2/dvb_usb_urb.c
@@ -21,8 +21,8 @@
 
 #include "dvb_usb_common.h"
 
-int dvb_usbv2_generic_rw(struct dvb_usb_device *d, u8 *wbuf, u16 wlen, u8 *rbuf,
-		u16 rlen)
+int dvb_usb_v2_generic_io(struct dvb_usb_device *d,
+		u8 *wbuf, u16 wlen, u8 *rbuf, u16 rlen)
 {
 	int ret, actual_length;
 
@@ -32,8 +32,6 @@ int dvb_usbv2_generic_rw(struct dvb_usb_device *d, u8 *wbuf, u16 wlen, u8 *rbuf,
 		return -EINVAL;
 	}
 
-	mutex_lock(&d->usb_mutex);
-
 	dev_dbg(&d->udev->dev, "%s: >>> %*ph\n", __func__, wlen, wbuf);
 
 	ret = usb_bulk_msg(d->udev, usb_sndbulkpipe(d->udev,
@@ -63,13 +61,43 @@ int dvb_usbv2_generic_rw(struct dvb_usb_device *d, u8 *wbuf, u16 wlen, u8 *rbuf,
 				actual_length, rbuf);
 	}
 
+	return ret;
+}
+
+int dvb_usbv2_generic_rw(struct dvb_usb_device *d,
+		u8 *wbuf, u16 wlen, u8 *rbuf, u16 rlen)
+{
+	int ret;
+
+	mutex_lock(&d->usb_mutex);
+	ret = dvb_usb_v2_generic_io(d, wbuf, wlen, rbuf, rlen);
 	mutex_unlock(&d->usb_mutex);
+
 	return ret;
 }
 EXPORT_SYMBOL(dvb_usbv2_generic_rw);
 
 int dvb_usbv2_generic_write(struct dvb_usb_device *d, u8 *buf, u16 len)
 {
-	return dvb_usbv2_generic_rw(d, buf, len, NULL, 0);
+	int ret;
+
+	mutex_lock(&d->usb_mutex);
+	ret = dvb_usb_v2_generic_io(d, buf, len, NULL, 0);
+	mutex_unlock(&d->usb_mutex);
+
+	return ret;
 }
 EXPORT_SYMBOL(dvb_usbv2_generic_write);
+
+int dvb_usbv2_generic_rw_locked(struct dvb_usb_device *d,
+		u8 *wbuf, u16 wlen, u8 *rbuf, u16 rlen)
+{
+	return dvb_usb_v2_generic_io(d, wbuf, wlen, rbuf, rlen);
+}
+EXPORT_SYMBOL(dvb_usbv2_generic_rw_locked);
+
+int dvb_usbv2_generic_write_locked(struct dvb_usb_device *d, u8 *buf, u16 len)
+{
+	return dvb_usb_v2_generic_io(d, buf, len, NULL, 0);
+}
+EXPORT_SYMBOL(dvb_usbv2_generic_write_locked);
-- 
1.7.11.7

