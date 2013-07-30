Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57074 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756878Ab3G3UaI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Jul 2013 16:30:08 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/2] dvb_usb_v2: get rid of deferred probe
Date: Tue, 30 Jul 2013 23:29:01 +0300
Message-Id: <1375216141-25295-2-git-send-email-crope@iki.fi>
In-Reply-To: <1375216141-25295-1-git-send-email-crope@iki.fi>
References: <1375216141-25295-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Deferred probe was added in order to avoid udev vs. Kernel firmware
download problems. It is not needed anymore.

https://bugzilla.redhat.com/show_bug.cgi?id=827538

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/dvb_usb.h      |   5 --
 drivers/media/usb/dvb-usb-v2/dvb_usb_core.c | 134 ++++++++++------------------
 2 files changed, 45 insertions(+), 94 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb.h b/drivers/media/usb/dvb-usb-v2/dvb_usb.h
index 399916b..124b4ba 100644
--- a/drivers/media/usb/dvb-usb-v2/dvb_usb.h
+++ b/drivers/media/usb/dvb-usb-v2/dvb_usb.h
@@ -352,9 +352,7 @@ struct dvb_usb_adapter {
  * @rc_map: name of rc codes table
  * @rc_polling_active: set when RC polling is active
  * @udev: pointer to the device's struct usb_device
- * @intf: pointer to the device's usb interface
  * @rc: remote controller configuration
- * @probe_work: work to defer .probe()
  * @powered: indicated whether the device is power or not
  * @usb_mutex: mutex for usb control messages
  * @i2c_mutex: mutex for i2c-transfers
@@ -370,10 +368,7 @@ struct dvb_usb_device {
 	const char *rc_map;
 	bool rc_polling_active;
 	struct usb_device *udev;
-	struct usb_interface *intf;
 	struct dvb_usb_rc rc;
-	struct work_struct probe_work;
-	pid_t work_pid;
 	int powered;
 
 	/* locking */
diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
index 19f6737..8a054d6 100644
--- a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
+++ b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
@@ -833,20 +833,44 @@ err:
 	return ret;
 }
 
-/*
- * udev, which is used for the firmware downloading, requires we cannot
- * block during module_init(). module_init() calls USB probe() which
- * is this routine. Due to that we delay actual operation using workqueue
- * and return always success here.
- */
-static void dvb_usbv2_init_work(struct work_struct *work)
+int dvb_usbv2_probe(struct usb_interface *intf,
+		const struct usb_device_id *id)
 {
 	int ret;
-	struct dvb_usb_device *d =
-			container_of(work, struct dvb_usb_device, probe_work);
+	struct dvb_usb_device *d;
+	struct usb_device *udev = interface_to_usbdev(intf);
+	struct dvb_usb_driver_info *driver_info =
+			(struct dvb_usb_driver_info *) id->driver_info;
+
+	dev_dbg(&udev->dev, "%s: bInterfaceNumber=%d\n", __func__,
+			intf->cur_altsetting->desc.bInterfaceNumber);
+
+	if (!id->driver_info) {
+		dev_err(&udev->dev, "%s: driver_info failed\n", KBUILD_MODNAME);
+		ret = -ENODEV;
+		goto err;
+	}
+
+	d = kzalloc(sizeof(struct dvb_usb_device), GFP_KERNEL);
+	if (!d) {
+		dev_err(&udev->dev, "%s: kzalloc() failed\n", KBUILD_MODNAME);
+		ret = -ENOMEM;
+		goto err;
+	}
 
-	d->work_pid = current->pid;
-	dev_dbg(&d->udev->dev, "%s: work_pid=%d\n", __func__, d->work_pid);
+	d->name = driver_info->name;
+	d->rc_map = driver_info->rc_map;
+	d->udev = udev;
+	d->props = driver_info->props;
+
+	if (intf->cur_altsetting->desc.bInterfaceNumber !=
+			d->props->bInterfaceNumber) {
+		ret = -ENODEV;
+		goto err_free_all;
+	}
+
+	mutex_init(&d->usb_mutex);
+	mutex_init(&d->i2c_mutex);
 
 	if (d->props->size_of_priv) {
 		d->priv = kzalloc(d->props->size_of_priv, GFP_KERNEL);
@@ -854,7 +878,7 @@ static void dvb_usbv2_init_work(struct work_struct *work)
 			dev_err(&d->udev->dev, "%s: kzalloc() failed\n",
 					KBUILD_MODNAME);
 			ret = -ENOMEM;
-			goto err_usb_driver_release_interface;
+			goto err_free_all;
 		}
 	}
 
@@ -884,20 +908,12 @@ static void dvb_usbv2_init_work(struct work_struct *work)
 				 * device. As 'new' device is warm we should
 				 * never go here again.
 				 */
-				return;
+				goto exit;
 			} else {
-				/*
-				 * Unexpected error. We must unregister driver
-				 * manually from the device, because device is
-				 * already register by returning from probe()
-				 * with success. usb_driver_release_interface()
-				 * finally calls disconnect() in order to free
-				 * resources.
-				 */
-				goto err_usb_driver_release_interface;
+				goto err_free_all;
 			}
 		} else {
-			goto err_usb_driver_release_interface;
+			goto err_free_all;
 		}
 	}
 
@@ -906,73 +922,17 @@ static void dvb_usbv2_init_work(struct work_struct *work)
 
 	ret = dvb_usbv2_init(d);
 	if (ret < 0)
-		goto err_usb_driver_release_interface;
+		goto err_free_all;
 
 	dev_info(&d->udev->dev,
 			"%s: '%s' successfully initialized and connected\n",
 			KBUILD_MODNAME, d->name);
-
-	return;
-err_usb_driver_release_interface:
-	dev_info(&d->udev->dev, "%s: '%s' error while loading driver (%d)\n",
-			KBUILD_MODNAME, d->name, ret);
-	usb_driver_release_interface(to_usb_driver(d->intf->dev.driver),
-			d->intf);
-	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
-	return;
-}
-
-int dvb_usbv2_probe(struct usb_interface *intf,
-		const struct usb_device_id *id)
-{
-	int ret;
-	struct dvb_usb_device *d;
-	struct usb_device *udev = interface_to_usbdev(intf);
-	struct dvb_usb_driver_info *driver_info =
-			(struct dvb_usb_driver_info *) id->driver_info;
-
-	dev_dbg(&udev->dev, "%s: bInterfaceNumber=%d\n", __func__,
-			intf->cur_altsetting->desc.bInterfaceNumber);
-
-	if (!id->driver_info) {
-		dev_err(&udev->dev, "%s: driver_info failed\n", KBUILD_MODNAME);
-		ret = -ENODEV;
-		goto err;
-	}
-
-	d = kzalloc(sizeof(struct dvb_usb_device), GFP_KERNEL);
-	if (!d) {
-		dev_err(&udev->dev, "%s: kzalloc() failed\n", KBUILD_MODNAME);
-		ret = -ENOMEM;
-		goto err;
-	}
-
-	d->name = driver_info->name;
-	d->rc_map = driver_info->rc_map;
-	d->udev = udev;
-	d->intf = intf;
-	d->props = driver_info->props;
-
-	if (d->intf->cur_altsetting->desc.bInterfaceNumber !=
-			d->props->bInterfaceNumber) {
-		ret = -ENODEV;
-		goto err_kfree;
-	}
-
-	mutex_init(&d->usb_mutex);
-	mutex_init(&d->i2c_mutex);
-	INIT_WORK(&d->probe_work, dvb_usbv2_init_work);
+exit:
 	usb_set_intfdata(intf, d);
-	ret = schedule_work(&d->probe_work);
-	if (ret < 0) {
-		dev_err(&d->udev->dev, "%s: schedule_work() failed\n",
-				KBUILD_MODNAME);
-		goto err_kfree;
-	}
 
 	return 0;
-err_kfree:
-	kfree(d);
+err_free_all:
+	dvb_usbv2_exit(d);
 err:
 	dev_dbg(&udev->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
@@ -984,12 +944,8 @@ void dvb_usbv2_disconnect(struct usb_interface *intf)
 	struct dvb_usb_device *d = usb_get_intfdata(intf);
 	const char *name = d->name;
 	struct device dev = d->udev->dev;
-	dev_dbg(&d->udev->dev, "%s: pid=%d work_pid=%d\n", __func__,
-			current->pid, d->work_pid);
-
-	/* ensure initialization work is finished until release resources */
-	if (d->work_pid != current->pid)
-		cancel_work_sync(&d->probe_work);
+	dev_dbg(&d->udev->dev, "%s: bInterfaceNumber=%d\n", __func__,
+			intf->cur_altsetting->desc.bInterfaceNumber);
 
 	if (d->props->exit)
 		d->props->exit(d);
-- 
1.7.11.7

