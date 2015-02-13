Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f171.google.com ([209.85.216.171]:62889 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbbBMV3q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Feb 2015 16:29:46 -0500
Received: by mail-qc0-f171.google.com with SMTP id l6so16133793qcy.2
        for <linux-media@vger.kernel.org>; Fri, 13 Feb 2015 13:29:46 -0800 (PST)
From: =?UTF-8?q?Rafael=20Louren=C3=A7o=20de=20Lima=20Chehab?=
	<chehabrafael@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: =?UTF-8?q?Rafael=20Louren=C3=A7o=20de=20Lima=20Chehab?=
	<chehabrafael@gmail.com>
Subject: [PATCH] dvb-usb: add support for the media controller at USB driver
Date: Fri, 13 Feb 2015 19:29:14 -0200
Message-Id: <1423862954-6609-1-git-send-email-chehabrafael@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Create a struct media_device and add it to the dvb adapter.

Please notice that the tuner is not mapped yet by the dvb core.

Signed-off-by: Rafael Lourenço de Lima Chehab <chehabrafael@gmail.com>
---
 drivers/media/usb/dvb-usb/dvb-usb-dvb.c | 58 +++++++++++++++++++++++++++++++++
 drivers/media/usb/dvb-usb/dvb-usb.h     |  4 +++
 2 files changed, 62 insertions(+)

diff --git a/drivers/media/usb/dvb-usb/dvb-usb-dvb.c b/drivers/media/usb/dvb-usb/dvb-usb-dvb.c
index 719413b15f20..c5b88206ce2b 100644
--- a/drivers/media/usb/dvb-usb/dvb-usb-dvb.c
+++ b/drivers/media/usb/dvb-usb/dvb-usb-dvb.c
@@ -94,6 +94,55 @@ static int dvb_usb_stop_feed(struct dvb_demux_feed *dvbdmxfeed)
 	return dvb_usb_ctrl_feed(dvbdmxfeed,0);
 }
 
+static void dvb_usb_media_device_register(struct dvb_usb_device *d)
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
+	strlcpy(mdev->model, d->desc->name, sizeof(mdev->model));
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
+static void dvb_usb_media_device_unregister(struct dvb_usb_device *d)
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
 int dvb_usb_adapter_dvb_init(struct dvb_usb_adapter *adap, short *adapter_nums)
 {
 	int i;
@@ -107,6 +156,11 @@ int dvb_usb_adapter_dvb_init(struct dvb_usb_adapter *adap, short *adapter_nums)
 	}
 	adap->dvb_adap.priv = adap;
 
+#ifdef CONFIG_MEDIA_CONTROLLER
+	dvb_usb_media_device_register(adap->dev);
+	adap->dvb_adap.mdev = adap->dev->media_dev;
+#endif
+
 	if (adap->dev->props.read_mac_address) {
 		if (adap->dev->props.read_mac_address(adap->dev,adap->dvb_adap.proposed_mac) == 0)
 			info("MAC address: %pM",adap->dvb_adap.proposed_mac);
@@ -154,6 +208,7 @@ err_net_init:
 err_dmx_dev:
 	dvb_dmx_release(&adap->demux);
 err_dmx:
+	dvb_usb_media_device_unregister(adap->dev);
 	dvb_unregister_adapter(&adap->dvb_adap);
 err:
 	return ret;
@@ -167,6 +222,7 @@ int dvb_usb_adapter_dvb_exit(struct dvb_usb_adapter *adap)
 		adap->demux.dmx.close(&adap->demux.dmx);
 		dvb_dmxdev_release(&adap->dmxdev);
 		dvb_dmx_release(&adap->demux);
+		dvb_usb_media_device_unregister(adap->dev);
 		dvb_unregister_adapter(&adap->dvb_adap);
 		adap->state &= ~DVB_USB_ADAP_STATE_DVB;
 	}
@@ -268,6 +324,8 @@ int dvb_usb_adapter_frontend_init(struct dvb_usb_adapter *adap)
 		adap->num_frontends_initialized++;
 	}
 
+	dvb_create_media_graph(adap->dev->media_dev);
+
 	return 0;
 }
 
diff --git a/drivers/media/usb/dvb-usb/dvb-usb.h b/drivers/media/usb/dvb-usb/dvb-usb.h
index ce4c4e3b58bb..7323cbeb6fd6 100644
--- a/drivers/media/usb/dvb-usb/dvb-usb.h
+++ b/drivers/media/usb/dvb-usb/dvb-usb.h
@@ -453,6 +453,10 @@ struct dvb_usb_device {
 	struct module *owner;
 
 	void *priv;
+
+#ifdef CONFIG_MEDIA_CONTROLLER
+	struct media_device *media_dev;
+#endif
 };
 
 extern int dvb_usb_device_init(struct usb_interface *,
-- 
2.1.0

