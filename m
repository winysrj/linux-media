Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52739 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968Ab2HOCV5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Aug 2012 22:21:57 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hin-Tak Leung <htl10@users.sourceforge.net>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 4/6] dvb_usb_v2: .reset_resume() support
Date: Wed, 15 Aug 2012 05:21:07 +0300
Message-Id: <1344997269-20338-5-git-send-email-crope@iki.fi>
In-Reply-To: <1344997269-20338-1-git-send-email-crope@iki.fi>
References: <1344997269-20338-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add .reset_resume() support.
Also some other small changes for suspend / resume.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/dvb_usb.h      |  2 +-
 drivers/media/usb/dvb-usb-v2/dvb_usb_core.c | 42 +++++++++++++++++++++++------
 2 files changed, 35 insertions(+), 9 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb.h b/drivers/media/usb/dvb-usb-v2/dvb_usb.h
index 63fc275..5a53c62 100644
--- a/drivers/media/usb/dvb-usb-v2/dvb_usb.h
+++ b/drivers/media/usb/dvb-usb-v2/dvb_usb.h
@@ -383,7 +383,7 @@ extern int dvb_usbv2_probe(struct usb_interface *,
 extern void dvb_usbv2_disconnect(struct usb_interface *);
 extern int dvb_usbv2_suspend(struct usb_interface *, pm_message_t);
 extern int dvb_usbv2_resume(struct usb_interface *);
-#define dvb_usbv2_reset_resume dvb_usbv2_resume
+extern int dvb_usbv2_reset_resume(struct usb_interface *);
 
 /* the generic read/write method for device control */
 extern int dvb_usbv2_generic_rw(struct dvb_usb_device *, u8 *, u16, u8 *, u16);
diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
index a0e70e9..e2d73e1 100644
--- a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
+++ b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
@@ -952,7 +952,7 @@ EXPORT_SYMBOL(dvb_usbv2_disconnect);
 int dvb_usbv2_suspend(struct usb_interface *intf, pm_message_t msg)
 {
 	struct dvb_usb_device *d = usb_get_intfdata(intf);
-	int i, active_fe;
+	int ret = 0, i, active_fe;
 	struct dvb_frontend *fe;
 	dev_dbg(&d->udev->dev, "%s:\n", __func__);
 
@@ -972,18 +972,17 @@ int dvb_usbv2_suspend(struct usb_interface *intf, pm_message_t msg)
 			/* stop usb streaming */
 			usb_urb_killv2(&d->adapter[i].stream);
 
-			dvb_frontend_suspend(fe);
+			ret = dvb_frontend_suspend(fe);
 		}
 	}
 
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL(dvb_usbv2_suspend);
 
-int dvb_usbv2_resume(struct usb_interface *intf)
+static int dvb_usbv2_resume_common(struct dvb_usb_device *d)
 {
-	struct dvb_usb_device *d = usb_get_intfdata(intf);
-	int i, active_fe;
+	int ret = 0, i, active_fe;
 	struct dvb_frontend *fe;
 	dev_dbg(&d->udev->dev, "%s:\n", __func__);
 
@@ -992,7 +991,7 @@ int dvb_usbv2_resume(struct usb_interface *intf)
 		if (d->adapter[i].dvb_adap.priv && active_fe != -1) {
 			fe = d->adapter[i].fe[active_fe];
 
-			dvb_frontend_resume(fe);
+			ret = dvb_frontend_resume(fe);
 
 			/* resume usb streaming */
 			usb_urb_submitv2(&d->adapter[i].stream, NULL);
@@ -1009,10 +1008,37 @@ int dvb_usbv2_resume(struct usb_interface *intf)
 		schedule_delayed_work(&d->rc_query_work,
 				msecs_to_jiffies(d->rc.interval));
 
-	return 0;
+	return ret;
+}
+
+int dvb_usbv2_resume(struct usb_interface *intf)
+{
+	struct dvb_usb_device *d = usb_get_intfdata(intf);
+	dev_dbg(&d->udev->dev, "%s:\n", __func__);
+
+	return dvb_usbv2_resume_common(d);
 }
 EXPORT_SYMBOL(dvb_usbv2_resume);
 
+int dvb_usbv2_reset_resume(struct usb_interface *intf)
+{
+	struct dvb_usb_device *d = usb_get_intfdata(intf);
+	int ret;
+	dev_dbg(&d->udev->dev, "%s:\n", __func__);
+
+	dvb_usbv2_device_power_ctrl(d, 1);
+
+	if (d->props->init)
+		d->props->init(d);
+
+	ret = dvb_usbv2_resume_common(d);
+
+	dvb_usbv2_device_power_ctrl(d, 0);
+
+	return ret;
+}
+EXPORT_SYMBOL(dvb_usbv2_reset_resume);
+
 MODULE_VERSION("2.0");
 MODULE_AUTHOR("Patrick Boettcher <patrick.boettcher@desy.de>");
 MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
-- 
1.7.11.2

