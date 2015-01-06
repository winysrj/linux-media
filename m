Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55125 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756799AbbAFVJN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Jan 2015 16:09:13 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Matthias Schwarzott <zzam@gentoo.org>,
	Antti Palosaari <crope@iki.fi>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv3 03/20] cx231xx: add media controller support
Date: Tue,  6 Jan 2015 19:08:34 -0200
Message-Id: <fa927b6207391e52a106c170939968b3a0a885ab.1420578087.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1420578087.git.mchehab@osg.samsung.com>
References: <cover.1420578087.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1420578087.git.mchehab@osg.samsung.com>
References: <cover.1420578087.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Let's add media controller support for this driver and register it
for both V4L and DVB.

The media controller on this driver is not mandatory, as it can fully
work without it. So, if the media controller register fails, just print
an error message, but proceed with device registering.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index ae05d591f228..7e1c73a5172d 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -912,9 +912,6 @@ static inline void cx231xx_set_model(struct cx231xx *dev)
  */
 void cx231xx_pre_card_setup(struct cx231xx *dev)
 {
-
-	cx231xx_set_model(dev);
-
 	dev_info(dev->dev, "Identified as %s (card=%d)\n",
 		dev->board.name, dev->model);
 
@@ -1092,6 +1089,17 @@ void cx231xx_config_i2c(struct cx231xx *dev)
 	call_all(dev, video, s_stream, 1);
 }
 
+static void cx231xx_unregister_media_device(struct cx231xx *dev)
+{
+#ifdef CONFIG_MEDIA_CONTROLLER
+	if (dev->media_dev) {
+		media_device_unregister(dev->media_dev);
+		kfree(dev->media_dev);
+		dev->media_dev = NULL;
+	}
+#endif
+}
+
 /*
  * cx231xx_realease_resources()
  * unregisters the v4l2,i2c and usb devices
@@ -1099,6 +1107,8 @@ void cx231xx_config_i2c(struct cx231xx *dev)
 */
 void cx231xx_release_resources(struct cx231xx *dev)
 {
+	cx231xx_unregister_media_device(dev);
+
 	cx231xx_release_analog_resources(dev);
 
 	cx231xx_remove_from_devlist(dev);
@@ -1117,6 +1127,38 @@ void cx231xx_release_resources(struct cx231xx *dev)
 	clear_bit(dev->devno, &cx231xx_devused);
 }
 
+static void cx231xx_media_device_register(struct cx231xx *dev,
+					  struct usb_device *udev)
+{
+#ifdef CONFIG_MEDIA_CONTROLLER
+	struct media_device *mdev;
+	int ret;
+
+	mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
+	if (!mdev)
+		return;
+
+	mdev->dev = dev->dev;
+	strlcpy(mdev->model, dev->board.name, sizeof(mdev->model));
+	if (udev->serial)
+		strlcpy(mdev->serial, udev->serial, sizeof(mdev->serial));
+	strcpy(mdev->bus_info, udev->devpath);
+	mdev->hw_revision = le16_to_cpu(udev->descriptor.bcdDevice);
+	mdev->driver_version = LINUX_VERSION_CODE;
+
+	ret = media_device_register(mdev);
+	if (ret) {
+		dev_err(dev->dev,
+			"Couldn't create a media device. Error: %d\n",
+			ret);
+		kfree(mdev);
+		return;
+	}
+
+	dev->media_dev = mdev;
+#endif
+}
+
 /*
  * cx231xx_init_dev()
  * allocates and inits the device structs, registers i2c bus and v4l device
@@ -1225,10 +1267,8 @@ static int cx231xx_init_dev(struct cx231xx *dev, struct usb_device *udev,
 	}
 
 	retval = cx231xx_register_analog_devices(dev);
-	if (retval) {
-		cx231xx_release_analog_resources(dev);
+	if (retval)
 		goto err_analog;
-	}
 
 	cx231xx_ir_init(dev);
 
@@ -1236,6 +1276,8 @@ static int cx231xx_init_dev(struct cx231xx *dev, struct usb_device *udev,
 
 	return 0;
 err_analog:
+	cx231xx_unregister_media_device(dev);
+	cx231xx_release_analog_resources(dev);
 	cx231xx_remove_from_devlist(dev);
 err_dev_init:
 	cx231xx_dev_uninit(dev);
@@ -1437,6 +1479,8 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 	dev->video_mode.alt = -1;
 	dev->dev = d;
 
+	cx231xx_set_model(dev);
+
 	dev->interface_count++;
 	/* reset gpio dir and value */
 	dev->gpio_dir = 0;
@@ -1501,7 +1545,11 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 	/* save our data pointer in this interface device */
 	usb_set_intfdata(interface, dev);
 
+	/* Register the media controller */
+	cx231xx_media_device_register(dev, udev);
+
 	/* Create v4l2 device */
+	dev->v4l2_dev.mdev = dev->media_dev;
 	retval = v4l2_device_register(&interface->dev, &dev->v4l2_dev);
 	if (retval) {
 		dev_err(d, "v4l2_device_register failed\n");
diff --git a/drivers/media/usb/cx231xx/cx231xx-dvb.c b/drivers/media/usb/cx231xx/cx231xx-dvb.c
index dd600b994e69..05d21b9f30d8 100644
--- a/drivers/media/usb/cx231xx/cx231xx-dvb.c
+++ b/drivers/media/usb/cx231xx/cx231xx-dvb.c
@@ -455,6 +455,7 @@ static int register_dvb(struct cx231xx_dvb *dvb,
 
 	mutex_init(&dvb->lock);
 
+
 	/* register adapter */
 	result = dvb_register_adapter(&dvb->adapter, dev->name, module, device,
 				      adapter_nr);
@@ -465,6 +466,8 @@ static int register_dvb(struct cx231xx_dvb *dvb,
 		goto fail_adapter;
 	}
 
+	dvb->adapter.mdev = dev->media_dev;
+
 	/* Ensure all frontends negotiate bus access */
 	dvb->frontend->ops.ts_bus_ctrl = cx231xx_dvb_bus_ctrl;
 
diff --git a/drivers/media/usb/cx231xx/cx231xx.h b/drivers/media/usb/cx231xx/cx231xx.h
index 6d6f3ee812f6..af9d6c4041dc 100644
--- a/drivers/media/usb/cx231xx/cx231xx.h
+++ b/drivers/media/usb/cx231xx/cx231xx.h
@@ -658,6 +658,10 @@ struct cx231xx {
 	struct video_device *vbi_dev;
 	struct video_device *radio_dev;
 
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	struct media_device *media_dev;
+#endif
+
 	unsigned char eedata[256];
 
 	struct cx231xx_video_mode video_mode;
-- 
2.1.0

