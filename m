Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:56821 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753570Ab2LJAqW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Dec 2012 19:46:22 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH RFC 11/11] dvb_usb_v2: change rc polling active/deactive logic
Date: Mon, 10 Dec 2012 02:45:35 +0200
Message-Id: <1355100335-2123-11-git-send-email-crope@iki.fi>
In-Reply-To: <1355100335-2123-1-git-send-email-crope@iki.fi>
References: <1355100335-2123-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use own flag to mark when rc polling is active/deactive and make
decisions, like start/stop polling on suspend/resume, against that.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/dvb_usb.h      |  3 ++-
 drivers/media/usb/dvb-usb-v2/dvb_usb_core.c | 10 +++++++---
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb.h b/drivers/media/usb/dvb-usb-v2/dvb_usb.h
index 059291b..3cac8bd 100644
--- a/drivers/media/usb/dvb-usb-v2/dvb_usb.h
+++ b/drivers/media/usb/dvb-usb-v2/dvb_usb.h
@@ -347,6 +347,7 @@ struct dvb_usb_adapter {
  * @props: device properties
  * @name: device name
  * @rc_map: name of rc codes table
+ * @rc_polling_active: set when RC polling is active
  * @udev: pointer to the device's struct usb_device
  * @intf: pointer to the device's usb interface
  * @rc: remote controller configuration
@@ -364,7 +365,7 @@ struct dvb_usb_device {
 	const struct dvb_usb_device_properties *props;
 	const char *name;
 	const char *rc_map;
-
+	bool rc_polling_active;
 	struct usb_device *udev;
 	struct usb_interface *intf;
 	struct dvb_usb_rc rc;
diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
index 1330c64..95968d3 100644
--- a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
+++ b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
@@ -113,13 +113,16 @@ static void dvb_usb_read_remote_control(struct work_struct *work)
 	 * When the parameter has been set to 1 via sysfs while the
 	 * driver was running, or when bulk mode is enabled after IR init.
 	 */
-	if (dvb_usbv2_disable_rc_polling || d->rc.bulk_mode)
+	if (dvb_usbv2_disable_rc_polling || d->rc.bulk_mode) {
+		d->rc_polling_active = false;
 		return;
+	}
 
 	ret = d->rc.query(d);
 	if (ret < 0) {
 		dev_err(&d->udev->dev, "%s: rc.query() failed=%d\n",
 				KBUILD_MODNAME, ret);
+		d->rc_polling_active = false;
 		return; /* stop polling */
 	}
 
@@ -183,6 +186,7 @@ static int dvb_usbv2_remote_init(struct dvb_usb_device *d)
 				d->rc.interval);
 		schedule_delayed_work(&d->rc_query_work,
 				msecs_to_jiffies(d->rc.interval));
+		d->rc_polling_active = true;
 	}
 
 	return 0;
@@ -964,7 +968,7 @@ int dvb_usbv2_suspend(struct usb_interface *intf, pm_message_t msg)
 	dev_dbg(&d->udev->dev, "%s:\n", __func__);
 
 	/* stop remote controller poll */
-	if (d->rc.query && !d->rc.bulk_mode)
+	if (d->rc_polling_active)
 		cancel_delayed_work_sync(&d->rc_query_work);
 
 	for (i = MAX_NO_OF_ADAPTER_PER_DEVICE - 1; i >= 0; i--) {
@@ -1011,7 +1015,7 @@ static int dvb_usbv2_resume_common(struct dvb_usb_device *d)
 	}
 
 	/* start remote controller poll */
-	if (d->rc.query && !d->rc.bulk_mode)
+	if (d->rc_polling_active)
 		schedule_delayed_work(&d->rc_query_work,
 				msecs_to_jiffies(d->rc.interval));
 
-- 
1.7.11.7

