Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57561 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756543AbaLWUu1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Dec 2014 15:50:27 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 01/66] dvb-usb-v2: add pointer to 'struct usb_interface' for driver usage
Date: Tue, 23 Dec 2014 22:48:54 +0200
Message-Id: <1419367799-14263-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Top level pointer on USB probe is struct usb_interface *. Add that
pointer to struct dvb_usb_device that drivers could use it, for
dev_* logging and more.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/dvb_usb.h      | 2 ++
 drivers/media/usb/dvb-usb-v2/dvb_usb_core.c | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb.h b/drivers/media/usb/dvb-usb-v2/dvb_usb.h
index 14e111e..41c6363 100644
--- a/drivers/media/usb/dvb-usb-v2/dvb_usb.h
+++ b/drivers/media/usb/dvb-usb-v2/dvb_usb.h
@@ -354,6 +354,7 @@ struct dvb_usb_adapter {
  * @name: device name
  * @rc_map: name of rc codes table
  * @rc_polling_active: set when RC polling is active
+ * @intf: pointer to the device's struct usb_interface
  * @udev: pointer to the device's struct usb_device
  * @rc: remote controller configuration
  * @powered: indicated whether the device is power or not
@@ -370,6 +371,7 @@ struct dvb_usb_device {
 	const char *name;
 	const char *rc_map;
 	bool rc_polling_active;
+	struct usb_interface *intf;
 	struct usb_device *udev;
 	struct dvb_usb_rc rc;
 	int powered;
diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
index 1950f37..9913e0f 100644
--- a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
+++ b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
@@ -868,6 +868,7 @@ int dvb_usbv2_probe(struct usb_interface *intf,
 		goto err;
 	}
 
+	d->intf = intf;
 	d->name = driver_info->name;
 	d->rc_map = driver_info->rc_map;
 	d->udev = udev;
-- 
http://palosaari.fi/

