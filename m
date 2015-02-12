Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f180.google.com ([209.85.216.180]:55559 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbbBLAFN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Feb 2015 19:05:13 -0500
Received: by mail-qc0-f180.google.com with SMTP id s11so5979283qcv.11
        for <linux-media@vger.kernel.org>; Wed, 11 Feb 2015 16:05:12 -0800 (PST)
From: =?UTF-8?q?Rafael=20Louren=C3=A7o=20de=20Lima=20Chehab?=
	<chehabrafael@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: =?UTF-8?q?Rafael=20Louren=C3=A7o=20de=20Lima=20Chehab?=
	<chehabrafael@gmail.com>
Subject: [PATCH RFC] dvb-usb-v2: add support for the media controller at USB driver
Date: Wed, 11 Feb 2015 22:04:44 -0200
Message-Id: <1423699484-8733-1-git-send-email-chehabrafael@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Create a struct media_device and add it to the dvb adapter.

Please notice that the tuner is not mapped yet by the dvb core.

Signed-off-by: Rafael Lourenço de Lima Chehab <chehabrafael@gmail.com>
---
 drivers/media/usb/dvb-usb-v2/dvb_usb.h      |  5 +++
 drivers/media/usb/dvb-usb-v2/dvb_usb_core.c | 61 +++++++++++++++++++++++++++++
 2 files changed, 66 insertions(+)

diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb.h b/drivers/media/usb/dvb-usb-v2/dvb_usb.h
index 14e111e13e54..b273250d0e31 100644
--- a/drivers/media/usb/dvb-usb-v2/dvb_usb.h
+++ b/drivers/media/usb/dvb-usb-v2/dvb_usb.h
@@ -25,6 +25,7 @@
 #include <linux/usb/input.h>
 #include <linux/firmware.h>
 #include <media/rc-core.h>
+#include <media/media-device.h>
 
 #include "dvb_frontend.h"
 #include "dvb_demux.h"
@@ -389,6 +390,10 @@ struct dvb_usb_device {
 	struct delayed_work rc_query_work;
 
 	void *priv;
+
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	struct media_device *media_dev;
+#endif
 };
 
 extern int dvb_usbv2_probe(struct usb_interface *,
diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
index 1950f37df835..ea4d7bec8fc1 100644
--- a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
+++ b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
@@ -86,6 +86,8 @@ static int dvb_usbv2_i2c_init(struct dvb_usb_device *d)
 		goto err;
 	}
 
+	dvb_create_media_graph(d->media_dev);
+
 	return 0;
 err:
 	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
@@ -400,6 +402,55 @@ skip_feed_stop:
 	return ret;
 }
 
+static void dvb_usbv2_media_device_register(struct dvb_usb_device *d)
+{
+#ifdef CONFIG_MEDIA_CONTROLLER
+
+	struct media_device *mdev;
+	struct usb_device *udev = d->udev;
+	int ret;
+
+	mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
+	if (!mdev)
+		return;
+
+	mdev->dev = &udev->dev;
+	strlcpy(mdev->model, d->name, sizeof(mdev->model));
+	if (udev->serial)
+		strlcpy(mdev->serial, udev->serial, sizeof(mdev->serial));
+	strcpy(mdev->bus_info, udev->devpath);
+	mdev->hw_revision = le16_to_cpu(udev->descriptor.bcdDevice);
+	mdev->driver_version = LINUX_VERSION_CODE;
+
+	ret = media_device_register(mdev);
+	if (ret) {
+		dev_err(&d->udev->dev,
+			"Couldn't create a media device. Error: %d\n",
+			ret);
+		kfree(mdev);
+		return;
+	}
+
+	d->media_dev = mdev;
+
+	dev_info(&d->udev->dev, "media controller created\n");
+
+#endif
+}
+
+static void dvb_usbv2_media_device_unregister (struct dvb_usb_device *d)
+{
+#ifdef CONFIG_MEDIA_CONTROLLER
+	if (!d->media_dev)
+		return;
+
+	media_device_unregister(d->media_dev);
+	kfree(d->media_dev);
+	d->media_dev = NULL;
+
+#endif
+}
+
 static int dvb_usbv2_adapter_dvb_init(struct dvb_usb_adapter *adap)
 {
 	int ret;
@@ -416,6 +467,11 @@ static int dvb_usbv2_adapter_dvb_init(struct dvb_usb_adapter *adap)
 
 	adap->dvb_adap.priv = adap;
 
+#ifdef CONFIG_MEDIA_CONTROLLER
+	dvb_usbv2_media_device_register(d);
+	adap->dvb_adap.mdev = d->media_dev;
+#endif
+
 	if (d->props->read_mac_address) {
 		ret = d->props->read_mac_address(adap,
 				adap->dvb_adap.proposed_mac);
@@ -464,6 +520,7 @@ err_dvb_net_init:
 err_dvb_dmxdev_init:
 	dvb_dmx_release(&adap->demux);
 err_dvb_dmx_init:
+	dvb_usbv2_media_device_unregister(d);
 	dvb_unregister_adapter(&adap->dvb_adap);
 err_dvb_register_adapter:
 	adap->dvb_adap.priv = NULL;
@@ -472,6 +529,8 @@ err_dvb_register_adapter:
 
 static int dvb_usbv2_adapter_dvb_exit(struct dvb_usb_adapter *adap)
 {
+	struct dvb_usb_device *d = adap_to_d(adap);
+
 	dev_dbg(&adap_to_d(adap)->udev->dev, "%s: adap=%d\n", __func__,
 			adap->id);
 
@@ -480,6 +539,7 @@ static int dvb_usbv2_adapter_dvb_exit(struct dvb_usb_adapter *adap)
 		adap->demux.dmx.close(&adap->demux.dmx);
 		dvb_dmxdev_release(&adap->dmxdev);
 		dvb_dmx_release(&adap->demux);
+		dvb_usbv2_media_device_unregister(d);
 		dvb_unregister_adapter(&adap->dvb_adap);
 	}
 
@@ -954,6 +1014,7 @@ void dvb_usbv2_disconnect(struct usb_interface *intf)
 	struct dvb_usb_device *d = usb_get_intfdata(intf);
 	const char *name = d->name;
 	struct device dev = d->udev->dev;
+
 	dev_dbg(&d->udev->dev, "%s: bInterfaceNumber=%d\n", __func__,
 			intf->cur_altsetting->desc.bInterfaceNumber);
 
-- 
2.1.0

