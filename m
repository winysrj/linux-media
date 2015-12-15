Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41874 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965218AbbLOMOX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Dec 2015 07:14:23 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hyun Kwon <hyun.kwon@xilinx.com>,
	Michal Simek <michal.simek@xilinx.com>,
	=?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
	Antti Palosaari <crope@iki.fi>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	=?UTF-8?q?Rafael=20Louren=C3=A7o=20de=20Lima=20Chehab?=
	<chehabrafael@gmail.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Tommi Rantala <tt.rantala@gmail.com>,
	Matthias Schwarzott <zzam@gentoo.org>,
	Olli Salonen <olli.salonen@iki.fi>,
	Luis de Bethencourt <luis@debethencourt.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-sh@vger.kernel.org
Subject: [PATCH] [media] media-device: handle errors at media_device_init()
Date: Tue, 15 Dec 2015 10:14:01 -0200
Message-Id: <2ab9b0b406c93928ebfbf910b320d2694a325b23.1450181567.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Changeset 43ac4401dca9 ("[media] media-device: split media
initialization and registration") broke media device register
into two separate functions, but introduced a BUG_ON() and
made media_device_init() void. It also introduced several
warnings.

Instead of adding BUG_ON(), let's revert to WARN_ON() and fix
the init code in a way that, if something goes wrong during
device init, driver probe will fail without causing the Kernel
to BUG.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---

Javier is in vacations. So, instead of waiting for him to fixup those issues,
let's address ourselves.

 drivers/media/media-device.c                  |  8 ++++---
 drivers/media/platform/exynos4-is/media-dev.c |  7 +++++-
 drivers/media/platform/omap3isp/isp.c         |  9 ++++++--
 drivers/media/platform/s3c-camif/camif-core.c |  4 +++-
 drivers/media/platform/vsp1/vsp1_drv.c        |  7 +++++-
 drivers/media/platform/xilinx/xilinx-vipp.c   |  7 +++++-
 drivers/media/usb/au0828/au0828-core.c        | 26 +++++++++++++++++----
 drivers/media/usb/cx231xx/cx231xx-cards.c     | 21 +++++++++++++----
 drivers/media/usb/dvb-usb-v2/dvb_usb_core.c   | 33 +++++++++++++++++++--------
 drivers/media/usb/dvb-usb/dvb-usb-dvb.c       | 32 +++++++++++++++++++-------
 drivers/media/usb/siano/smsusb.c              |  6 ++++-
 drivers/media/usb/uvc/uvc_driver.c            |  3 ++-
 include/media/media-device.h                  |  2 +-
 13 files changed, 127 insertions(+), 38 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 76e2b2f3a15f..34621605eed7 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -625,10 +625,10 @@ EXPORT_SYMBOL_GPL(media_device_unregister_entity);
  * - dev must point to the parent device
  * - model must be filled with the device model name
  */
-void media_device_init(struct media_device *mdev)
+int __must_check media_device_init(struct media_device *mdev)
 {
-
-	BUG_ON(mdev->dev == NULL);
+	if (WARN_ON(mdev->dev == NULL))
+		return -EINVAL;
 
 	INIT_LIST_HEAD(&mdev->entities);
 	INIT_LIST_HEAD(&mdev->interfaces);
@@ -638,6 +638,8 @@ void media_device_init(struct media_device *mdev)
 	mutex_init(&mdev->graph_mutex);
 
 	dev_dbg(mdev->dev, "Media device initialized\n");
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(media_device_init);
 
diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index 27663dd45294..4fea0037dade 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -1353,7 +1353,11 @@ static int fimc_md_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	media_device_init(&fmd->media_dev);
+	ret = media_device_init(&fmd->media_dev);
+	if (ret < 0) {
+		v4l2_err(v4l2_dev, "Failed to register media device: %d\n", ret);
+		goto err_v4l2_dev;
+	}
 
 	ret = fimc_md_get_clocks(fmd);
 	if (ret)
@@ -1424,6 +1428,7 @@ err_m_ent:
 	fimc_md_unregister_entities(fmd);
 err_md:
 	media_device_cleanup(&fmd->media_dev);
+err_v4l2_dev:
 	v4l2_device_unregister(&fmd->v4l2_dev);
 	return ret;
 }
diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 942b189c0eca..347bfdd8ce65 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -1876,7 +1876,12 @@ static int isp_register_entities(struct isp_device *isp)
 		sizeof(isp->media_dev.model));
 	isp->media_dev.hw_revision = isp->revision;
 	isp->media_dev.link_notify = isp_pipeline_link_notify;
-	media_device_init(&isp->media_dev);
+	ret = media_device_init(&isp->media_dev);
+	if (ret < 0) {
+		dev_err(isp->dev, "%s: Media device registration failed (%d)\n",
+			__func__, ret);
+		return ret;
+	}
 
 	isp->v4l2_dev.mdev = &isp->media_dev;
 	ret = v4l2_device_register(isp->dev, &isp->v4l2_dev);
@@ -2361,7 +2366,7 @@ static int isp_subdev_notifier_complete(struct v4l2_async_notifier *async)
 		}
 	}
 
-	ret = v4l2_device_register_subdev_nodes(&isp->v4l2_dev);
+	ret = v4l2_device_register_subdev_nodes(v4l2_dev);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/media/platform/s3c-camif/camif-core.c b/drivers/media/platform/s3c-camif/camif-core.c
index ea02b7ef2119..6e6ad152adbc 100644
--- a/drivers/media/platform/s3c-camif/camif-core.c
+++ b/drivers/media/platform/s3c-camif/camif-core.c
@@ -328,7 +328,9 @@ static int camif_media_dev_init(struct camif_dev *camif)
 	if (ret < 0)
 		return ret;
 
-	media_device_init(md);
+	ret = media_device_init(md);
+	if (ret < 0)
+		v4l2_device_unregister(v4l2_dev);
 
 	return ret;
 }
diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index 42dff9d020af..1e319eaeb8fe 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -142,7 +142,12 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
 	strlcpy(mdev->model, "VSP1", sizeof(mdev->model));
 	snprintf(mdev->bus_info, sizeof(mdev->bus_info), "platform:%s",
 		 dev_name(mdev->dev));
-	media_device_init(mdev);
+	ret = media_device_init(mdev);
+	if (ret < 0) {
+		dev_err(vsp1->dev, "media device registration failed (%d)\n",
+			ret);
+		return ret;
+	}
 
 	vdev->mdev = mdev;
 	ret = v4l2_device_register(vsp1->dev, vdev);
diff --git a/drivers/media/platform/xilinx/xilinx-vipp.c b/drivers/media/platform/xilinx/xilinx-vipp.c
index e795a4501e8b..7c5d23010d6f 100644
--- a/drivers/media/platform/xilinx/xilinx-vipp.c
+++ b/drivers/media/platform/xilinx/xilinx-vipp.c
@@ -585,7 +585,12 @@ static int xvip_composite_v4l2_init(struct xvip_composite_device *xdev)
 		sizeof(xdev->media_dev.model));
 	xdev->media_dev.hw_revision = 0;
 
-	media_device_init(&xdev->media_dev);
+	ret = media_device_init(&xdev->media_dev);
+	if (ret < 0) {
+		dev_err(xdev->dev, "media device registration failed (%d)\n",
+			ret);
+		return ret;
+	}
 
 	xdev->v4l2_dev.mdev = &xdev->media_dev;
 	ret = v4l2_device_register(xdev->dev, &xdev->v4l2_dev);
diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index e7aab47ae4f5..2f91bbc633b4 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -217,15 +217,16 @@ static void au0828_usb_disconnect(struct usb_interface *interface)
 	au0828_usb_release(dev);
 }
 
-static void au0828_media_device_init(struct au0828_dev *dev,
-				     struct usb_device *udev)
+static int au0828_media_device_init(struct au0828_dev *dev,
+				    struct usb_device *udev)
 {
 #ifdef CONFIG_MEDIA_CONTROLLER
 	struct media_device *mdev;
+	int ret;
 
 	mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
 	if (!mdev)
-		return;
+		return -ENOMEM;
 
 	mdev->dev = &udev->dev;
 
@@ -239,10 +240,18 @@ static void au0828_media_device_init(struct au0828_dev *dev,
 	mdev->hw_revision = le16_to_cpu(udev->descriptor.bcdDevice);
 	mdev->driver_version = LINUX_VERSION_CODE;
 
-	media_device_init(mdev);
+	ret = media_device_init(mdev);
+	if (ret) {
+		pr_err(
+			"Couldn't create a media device. Error: %d\n",
+			ret);
+		kfree(mdev);
+		return ret;
+	}
 
 	dev->media_dev = mdev;
 #endif
+	return 0;
 }
 
 
@@ -368,7 +377,14 @@ static int au0828_usb_probe(struct usb_interface *interface,
 	dev->board = au0828_boards[dev->boardnr];
 
 	/* Initialize the media controller */
-	au0828_media_device_init(dev, usbdev);
+	retval = au0828_media_device_init(dev, usbdev);
+	if (retval) {
+		pr_err("%s() au0828_media_device_init failed\n",
+		       __func__);
+		mutex_unlock(&dev->lock);
+		kfree(dev);
+		return retval;
+	}
 
 #ifdef CONFIG_VIDEO_AU0828_V4L2
 	dev->v4l2_dev.release = au0828_usb_v4l2_release;
diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index 2e997f09a4cd..d086b3c17969 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -1206,11 +1206,12 @@ void cx231xx_release_resources(struct cx231xx *dev)
 	clear_bit(dev->devno, &cx231xx_devused);
 }
 
-static void cx231xx_media_device_init(struct cx231xx *dev,
-				      struct usb_device *udev)
+static int cx231xx_media_device_init(struct cx231xx *dev,
+				     struct usb_device *udev)
 {
 #ifdef CONFIG_MEDIA_CONTROLLER
 	struct media_device *mdev;
+	int ret;
 
 	mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
 	if (!mdev)
@@ -1224,10 +1225,18 @@ static void cx231xx_media_device_init(struct cx231xx *dev,
 	mdev->hw_revision = le16_to_cpu(udev->descriptor.bcdDevice);
 	mdev->driver_version = LINUX_VERSION_CODE;
 
-	media_device_init(mdev);
+	ret = media_device_init(mdev);
+	if (ret) {
+		dev_err(dev->dev,
+			"Couldn't create a media device. Error: %d\n",
+			ret);
+		kfree(mdev);
+		return;
+	}
 
 	dev->media_dev = mdev;
 #endif
+	return 0;
 }
 
 static int cx231xx_create_media_graph(struct cx231xx *dev)
@@ -1663,7 +1672,11 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 	usb_set_intfdata(interface, dev);
 
 	/* Initialize the media controller */
-	cx231xx_media_device_init(dev, udev);
+	retval = cx231xx_media_device_init(dev, udev);
+	if (retval) {
+		dev_err(d, "cx231xx_media_device_init failed\n");
+		goto err_v4l2;
+	}
 
 	/* Create v4l2 device */
 #ifdef CONFIG_MEDIA_CONTROLLER
diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
index a0413dcc3361..9992ac6e63cc 100644
--- a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
+++ b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
@@ -400,7 +400,7 @@ skip_feed_stop:
 	return ret;
 }
 
-static void dvb_usbv2_media_device_init(struct dvb_usb_adapter *adap)
+static int dvb_usbv2_media_device_init(struct dvb_usb_adapter *adap)
 {
 #ifdef CONFIG_MEDIA_CONTROLLER_DVB
 	struct media_device *mdev;
@@ -410,7 +410,7 @@ static void dvb_usbv2_media_device_init(struct dvb_usb_adapter *adap)
 
 	mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
 	if (!mdev)
-		return;
+		return -ENOMEM;
 
 	mdev->dev = &udev->dev;
 	strlcpy(mdev->model, d->name, sizeof(mdev->model));
@@ -420,19 +420,28 @@ static void dvb_usbv2_media_device_init(struct dvb_usb_adapter *adap)
 	mdev->hw_revision = le16_to_cpu(udev->descriptor.bcdDevice);
 	mdev->driver_version = LINUX_VERSION_CODE;
 
-	media_device_init(mdev);
+	ret = media_device_init(mdev);
+	if (ret) {
+		dev_err(&d->udev->dev,
+			"Couldn't create a media device. Error: %d\n",
+			ret);
+		kfree(mdev);
+		return ret;
+	}
 
 	dvb_register_media_controller(&adap->dvb_adap, mdev);
 
 	dev_info(&d->udev->dev, "media controller created\n");
-
 #endif
+	return 0;
 }
 
-static void dvb_usbv2_media_device_register(struct dvb_usb_adapter *adap)
+static int dvb_usbv2_media_device_register(struct dvb_usb_adapter *adap)
 {
 #ifdef CONFIG_MEDIA_CONTROLLER_DVB
-	media_device_register(adap->dvb_adap.mdev);
+	return media_device_register(adap->dvb_adap.mdev);
+#else
+	return 0;
 #endif
 }
 
@@ -468,7 +477,12 @@ static int dvb_usbv2_adapter_dvb_init(struct dvb_usb_adapter *adap)
 
 	adap->dvb_adap.priv = adap;
 
-	dvb_usbv2_media_device_init(adap);
+	ret = dvb_usbv2_media_device_init(adap);
+	if (ret < 0) {
+		dev_dbg(&d->udev->dev, "%s: dvb_usbv2_media_device_init() failed=%d\n",
+				__func__, ret);
+		goto err_dvb_register_mc;
+	}
 
 	if (d->props->read_mac_address) {
 		ret = d->props->read_mac_address(adap,
@@ -519,6 +533,7 @@ err_dvb_dmxdev_init:
 	dvb_dmx_release(&adap->demux);
 err_dvb_dmx_init:
 	dvb_usbv2_media_device_unregister(adap);
+err_dvb_register_mc:
 	dvb_unregister_adapter(&adap->dvb_adap);
 err_dvb_register_adapter:
 	adap->dvb_adap.priv = NULL;
@@ -703,9 +718,9 @@ static int dvb_usbv2_adapter_frontend_init(struct dvb_usb_adapter *adap)
 	if (ret < 0)
 		goto err_dvb_unregister_frontend;
 
-	dvb_usbv2_media_device_register(&adap->dvb_adap);
+	ret = dvb_usbv2_media_device_register(adap);
 
-	return 0;
+	return ret;
 
 err_dvb_unregister_frontend:
 	for (i = count_registered - 1; i >= 0; i--)
diff --git a/drivers/media/usb/dvb-usb/dvb-usb-dvb.c b/drivers/media/usb/dvb-usb/dvb-usb-dvb.c
index 4086d9626664..920396f935ab 100644
--- a/drivers/media/usb/dvb-usb/dvb-usb-dvb.c
+++ b/drivers/media/usb/dvb-usb/dvb-usb-dvb.c
@@ -95,7 +95,7 @@ static int dvb_usb_stop_feed(struct dvb_demux_feed *dvbdmxfeed)
 	return dvb_usb_ctrl_feed(dvbdmxfeed, 0);
 }
 
-static void dvb_usb_media_device_init(struct dvb_usb_adapter *adap)
+static int dvb_usb_media_device_init(struct dvb_usb_adapter *adap)
 {
 #ifdef CONFIG_MEDIA_CONTROLLER_DVB
 	struct media_device *mdev;
@@ -105,7 +105,7 @@ static void dvb_usb_media_device_init(struct dvb_usb_adapter *adap)
 
 	mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
 	if (!mdev)
-		return;
+		return -EINVAL;
 
 	mdev->dev = &udev->dev;
 	strlcpy(mdev->model, d->desc->name, sizeof(mdev->model));
@@ -115,18 +115,27 @@ static void dvb_usb_media_device_init(struct dvb_usb_adapter *adap)
 	mdev->hw_revision = le16_to_cpu(udev->descriptor.bcdDevice);
 	mdev->driver_version = LINUX_VERSION_CODE;
 
-	media_device_init(mdev);
-
+	ret = media_device_init(mdev);
+	if (ret) {
+		dev_err(&d->udev->dev,
+			"Couldn't create a media device. Error: %d\n",
+			ret);
+		kfree(mdev);
+		return ret;
+	}
 	dvb_register_media_controller(&adap->dvb_adap, mdev);
 
 	dev_info(&d->udev->dev, "media controller created\n");
 #endif
+	return 0;
 }
 
-static void dvb_usb_media_device_register(struct dvb_usb_adapter *adap)
+static int dvb_usb_media_device_register(struct dvb_usb_adapter *adap)
 {
 #ifdef CONFIG_MEDIA_CONTROLLER_DVB
-	media_device_register(adap->dvb_adap.mdev);
+	return media_device_register(adap->dvb_adap.mdev);
+#else
+	return 0;
 #endif
 }
 
@@ -156,7 +165,11 @@ int dvb_usb_adapter_dvb_init(struct dvb_usb_adapter *adap, short *adapter_nums)
 	}
 	adap->dvb_adap.priv = adap;
 
-	dvb_usb_media_device_init(adap);
+	ret = dvb_usb_media_device_init(adap);
+	if (ret < 0) {
+		deb_info("dvb_usb_media_device_init failed: error %d", ret);
+		goto err_mc;
+	}
 
 	if (adap->dev->props.read_mac_address) {
 		if (adap->dev->props.read_mac_address(adap->dev, adap->dvb_adap.proposed_mac) == 0)
@@ -206,6 +219,7 @@ err_dmx_dev:
 	dvb_dmx_release(&adap->demux);
 err_dmx:
 	dvb_usb_media_device_unregister(adap);
+err_mc:
 	dvb_unregister_adapter(&adap->dvb_adap);
 err:
 	return ret;
@@ -324,8 +338,10 @@ int dvb_usb_adapter_frontend_init(struct dvb_usb_adapter *adap)
 		return ret;
 
 	ret = dvb_create_media_graph(&adap->dvb_adap);
+	if (ret)
+		return ret;
 
-	dvb_usb_media_device_register(adap);
+	ret = dvb_usb_media_device_register(adap);
 
 	return ret;
 }
diff --git a/drivers/media/usb/siano/smsusb.c b/drivers/media/usb/siano/smsusb.c
index 8abbd3cc8eba..327180efa264 100644
--- a/drivers/media/usb/siano/smsusb.c
+++ b/drivers/media/usb/siano/smsusb.c
@@ -361,7 +361,11 @@ static void *siano_media_device_register(struct smsusb_device_t *dev,
 	mdev->hw_revision = le16_to_cpu(udev->descriptor.bcdDevice);
 	mdev->driver_version = LINUX_VERSION_CODE;
 
-	media_device_init(mdev);
+	ret = media_device_init(mdev);
+	if (ret) {
+		kfree(mdev);
+		return NULL;
+	}
 
 	ret = media_device_register(mdev);
 	if (ret) {
diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 96fc2c2efa7b..4dfd3eb814e7 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -1917,7 +1917,8 @@ static int uvc_probe(struct usb_interface *intf,
 	strcpy(dev->mdev.bus_info, udev->devpath);
 	dev->mdev.hw_revision = le16_to_cpu(udev->descriptor.bcdDevice);
 	dev->mdev.driver_version = LINUX_VERSION_CODE;
-	media_device_init(&dev->mdev);
+	if (media_device_init(&dev->mdev) < 0)
+		goto error;
 
 	dev->vdev.mdev = &dev->mdev;
 #endif
diff --git a/include/media/media-device.h b/include/media/media-device.h
index 572190860cbb..f09be5d47a7d 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -351,7 +351,7 @@ struct media_device {
  * within the media device, create pad to pad links and then finally register
  * the media device by calling media_device_register() as a final step.
  */
-void media_device_init(struct media_device *mdev);
+int __must_check media_device_init(struct media_device *mdev);
 
 /**
  * media_device_cleanup() - Cleanups a media device element
-- 
2.5.0


