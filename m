Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:45497 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031079Ab2HGW5L (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Aug 2012 18:57:11 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 2/2] dvb_usb_v2: use %*ph to dump usb xfer debugs
Date: Wed,  8 Aug 2012 01:56:36 +0300
Message-Id: <1344380196-9488-2-git-send-email-crope@iki.fi>
In-Reply-To: <1344380196-9488-1-git-send-email-crope@iki.fi>
References: <1344380196-9488-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb/dvb-usb-v2/dvb_usb_urb.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb-v2/dvb_usb_urb.c b/drivers/media/dvb/dvb-usb-v2/dvb_usb_urb.c
index 5f5bdd0..0431bee 100644
--- a/drivers/media/dvb/dvb-usb-v2/dvb_usb_urb.c
+++ b/drivers/media/dvb/dvb-usb-v2/dvb_usb_urb.c
@@ -21,7 +21,6 @@
 
 #include "dvb_usb_common.h"
 
-#undef DVB_USB_XFER_DEBUG
 int dvb_usbv2_generic_rw(struct dvb_usb_device *d, u8 *wbuf, u16 wlen, u8 *rbuf,
 		u16 rlen)
 {
@@ -37,10 +36,8 @@ int dvb_usbv2_generic_rw(struct dvb_usb_device *d, u8 *wbuf, u16 wlen, u8 *rbuf,
 	if (ret < 0)
 		return ret;
 
-#ifdef DVB_USB_XFER_DEBUG
-	print_hex_dump(KERN_DEBUG, KBUILD_MODNAME ": >>> ", DUMP_PREFIX_NONE,
-			32, 1, wbuf, wlen, 0);
-#endif
+	dev_dbg(&d->udev->dev, "%s: >>> %*ph\n", __func__, wlen, wbuf);
+
 	ret = usb_bulk_msg(d->udev, usb_sndbulkpipe(d->udev,
 			d->props->generic_bulk_ctrl_endpoint), wbuf, wlen,
 			&actual_length, 2000);
@@ -64,11 +61,8 @@ int dvb_usbv2_generic_rw(struct dvb_usb_device *d, u8 *wbuf, u16 wlen, u8 *rbuf,
 			dev_err(&d->udev->dev, "%s: 2nd usb_bulk_msg() " \
 					"failed=%d\n", KBUILD_MODNAME, ret);
 
-#ifdef DVB_USB_XFER_DEBUG
-		print_hex_dump(KERN_DEBUG, KBUILD_MODNAME ": <<< ",
-				DUMP_PREFIX_NONE, 32, 1, rbuf, actual_length,
-				0);
-#endif
+		dev_dbg(&d->udev->dev, "%s: <<< %*ph\n", __func__,
+				actual_length, rbuf);
 	}
 
 	mutex_unlock(&d->usb_mutex);
-- 
1.7.11.2

