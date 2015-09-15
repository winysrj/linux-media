Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:36237 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754764AbbIOJdc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Sep 2015 05:33:32 -0400
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Luis de Bethencourt <luis@debethencourt.com>,
	linux-sh@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	=?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
	linux-samsung-soc@vger.kernel.org,
	Hyun Kwon <hyun.kwon@xilinx.com>,
	Matthias Schwarzott <zzam@gentoo.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Tommi Rantala <tt.rantala@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org, Kukjin Kim <kgene@kernel.org>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Michal Simek <michal.simek@xilinx.com>,
	Olli Salonen <olli.salonen@iki.fi>,
	linux-arm-kernel@lists.infradead.org,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Antti Palosaari <crope@iki.fi>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	=?UTF-8?q?Rafael=20Louren=C3=A7o=20de=20Lima=20Chehab?=
	<chehabrafael@gmail.com>
Subject: [PATCH v3 2/2] [media] media-device: split media initialization and registration
Date: Tue, 15 Sep 2015 11:33:02 +0200
Message-Id: <1442309582-18168-3-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1442309582-18168-1-git-send-email-javier@osg.samsung.com>
References: <1442309582-18168-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The media device node is registered and so made visible to user-space
before entities are registered and links created which means that the
media graph obtained by user-space could be only partially enumerated
if that happens too early before all the graph has been created.

To avoid this race condition, split the media init and registration
in separate functions and only register the media device node when
all the pending subdevices have been registered, either explicitly
by the driver or asynchronously using v4l2_async_register_subdev().

The media_device_register() had a check for drivers not filling dev
and model fields but all drivers in mainline set them and not doing
it will be a driver bug so change the function return to void and
add a BUG_ON() instead.

Also, add a media_device_cleanup() function that will destroy the
graph_mutex that is initialized in media_device_init().

Suggested-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

---

Changes in v3:
- Replace the WARN_ON() in media_device_init() for a BUG_ON().
  Suggested by Sakari Ailus.

Changes in v2:
- Change media_device_init() to return void instead of an error.
  Suggested by Sakari Ailus.
- Remove the error messages when media_device_register() fails.
  Suggested by Sakari Ailus.
- Fix typos in commit message of patch #2. Suggested by Sakari Ailus.

 drivers/media/common/siano/smsdvb-main.c      |  1 +
 drivers/media/media-device.c                  | 36 ++++++++++++++++++++++-----
 drivers/media/platform/exynos4-is/media-dev.c | 15 ++++++-----
 drivers/media/platform/omap3isp/isp.c         | 14 +++++------
 drivers/media/platform/s3c-camif/camif-core.c | 15 +++++++----
 drivers/media/platform/vsp1/vsp1_drv.c        | 12 ++++-----
 drivers/media/platform/xilinx/xilinx-vipp.c   | 12 +++------
 drivers/media/usb/au0828/au0828-core.c        | 27 ++++++++++----------
 drivers/media/usb/cx231xx/cx231xx-cards.c     | 30 +++++++++++-----------
 drivers/media/usb/dvb-usb-v2/dvb_usb_core.c   | 23 +++++++++--------
 drivers/media/usb/dvb-usb/dvb-usb-dvb.c       | 24 ++++++++++--------
 drivers/media/usb/siano/smsusb.c              |  5 ++--
 drivers/media/usb/uvc/uvc_driver.c            | 10 +++++---
 include/media/media-device.h                  |  2 ++
 14 files changed, 131 insertions(+), 95 deletions(-)

diff --git a/drivers/media/common/siano/smsdvb-main.c b/drivers/media/common/siano/smsdvb-main.c
index ab345490a43a..8a1ea2192439 100644
--- a/drivers/media/common/siano/smsdvb-main.c
+++ b/drivers/media/common/siano/smsdvb-main.c
@@ -617,6 +617,7 @@ static void smsdvb_media_device_unregister(struct smsdvb_client_t *client)
 	if (!coredev->media_dev)
 		return;
 	media_device_unregister(coredev->media_dev);
+	media_device_cleanup(coredev->media_dev);
 	kfree(coredev->media_dev);
 	coredev->media_dev = NULL;
 #endif
diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 47d09ffe6a9b..9355378d9634 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -526,7 +526,7 @@ static void media_device_release(struct media_devnode *mdev)
 }
 
 /**
- * media_device_register - register a media device
+ * media_device_init() - initialize a media device
  * @mdev:	The media device
  *
  * The caller is responsible for initializing the media device before
@@ -535,13 +535,10 @@ static void media_device_release(struct media_devnode *mdev)
  * - dev must point to the parent device
  * - model must be filled with the device model name
  */
-int __must_check __media_device_register(struct media_device *mdev,
-					 struct module *owner)
+void media_device_init(struct media_device *mdev)
 {
-	int ret;
 
-	if (WARN_ON(mdev->dev == NULL || mdev->model[0] == 0))
-		return -EINVAL;
+	BUG_ON(mdev->dev == NULL || mdev->model[0] == 0);
 
 	INIT_LIST_HEAD(&mdev->entities);
 	INIT_LIST_HEAD(&mdev->interfaces);
@@ -550,6 +547,33 @@ int __must_check __media_device_register(struct media_device *mdev,
 	spin_lock_init(&mdev->lock);
 	mutex_init(&mdev->graph_mutex);
 
+	dev_dbg(mdev->dev, "Media device initialized\n");
+}
+EXPORT_SYMBOL_GPL(media_device_init);
+
+/**
+ * media_device_cleanup() - Cleanup a media device
+ * @mdev:	The media device
+ *
+ */
+void media_device_cleanup(struct media_device *mdev)
+{
+	mutex_destroy(&mdev->graph_mutex);
+}
+EXPORT_SYMBOL_GPL(media_device_cleanup);
+
+/**
+ * __media_device_register() - register a media device
+ * @mdev:	The media device
+ * @owner:	The module owner
+ *
+ * returns zero on success or a negative error code.
+ */
+int __must_check __media_device_register(struct media_device *mdev,
+					 struct module *owner)
+{
+	int ret;
+
 	/* Register the device node. */
 	mdev->devnode.fops = &media_device_fops;
 	mdev->devnode.parent = mdev->dev;
diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index 4a25df9dd869..d55b4f304d86 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -1313,7 +1313,10 @@ static int subdev_notifier_complete(struct v4l2_async_notifier *notifier)
 	ret = v4l2_device_register_subdev_nodes(&fmd->v4l2_dev);
 unlock:
 	mutex_unlock(&fmd->media_dev.graph_mutex);
-	return ret;
+	if (ret < 0)
+		return ret;
+
+	return media_device_register(&fmd->media_dev);
 }
 
 static int fimc_md_probe(struct platform_device *pdev)
@@ -1350,11 +1353,7 @@ static int fimc_md_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	ret = media_device_register(&fmd->media_dev);
-	if (ret < 0) {
-		v4l2_err(v4l2_dev, "Failed to register media device: %d\n", ret);
-		goto err_v4l2_dev;
-	}
+	media_device_init(&fmd->media_dev);
 
 	ret = fimc_md_get_clocks(fmd);
 	if (ret)
@@ -1424,8 +1423,7 @@ err_clk:
 err_m_ent:
 	fimc_md_unregister_entities(fmd);
 err_md:
-	media_device_unregister(&fmd->media_dev);
-err_v4l2_dev:
+	media_device_cleanup(&fmd->media_dev);
 	v4l2_device_unregister(&fmd->v4l2_dev);
 	return ret;
 }
@@ -1445,6 +1443,7 @@ static int fimc_md_remove(struct platform_device *pdev)
 	fimc_md_unregister_entities(fmd);
 	fimc_md_pipelines_free(fmd);
 	media_device_unregister(&fmd->media_dev);
+	media_device_cleanup(&fmd->media_dev);
 	fimc_md_put_clocks(fmd);
 
 	return 0;
diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index cb8ac90086c1..0d1249ffef30 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -1793,6 +1793,7 @@ static void isp_unregister_entities(struct isp_device *isp)
 
 	v4l2_device_unregister(&isp->v4l2_dev);
 	media_device_unregister(&isp->media_dev);
+	media_device_cleanup(&isp->media_dev);
 }
 
 static int isp_link_entity(
@@ -1875,12 +1876,7 @@ static int isp_register_entities(struct isp_device *isp)
 		sizeof(isp->media_dev.model));
 	isp->media_dev.hw_revision = isp->revision;
 	isp->media_dev.link_notify = isp_pipeline_link_notify;
-	ret = media_device_register(&isp->media_dev);
-	if (ret < 0) {
-		dev_err(isp->dev, "%s: Media device registration failed (%d)\n",
-			__func__, ret);
-		return ret;
-	}
+	media_device_init(&isp->media_dev);
 
 	isp->v4l2_dev.mdev = &isp->media_dev;
 	ret = v4l2_device_register(isp->dev, &isp->v4l2_dev);
@@ -2347,7 +2343,11 @@ static int isp_subdev_notifier_complete(struct v4l2_async_notifier *async)
 		}
 	}
 
-	return v4l2_device_register_subdev_nodes(&isp->v4l2_dev);
+	ret = v4l2_device_register_subdev_nodes(&isp->v4l2_dev);
+	if (ret < 0)
+		return ret;
+
+	return media_device_register(&isp->media_dev);
 }
 
 /*
diff --git a/drivers/media/platform/s3c-camif/camif-core.c b/drivers/media/platform/s3c-camif/camif-core.c
index 3e33c60be004..be2f05a55a19 100644
--- a/drivers/media/platform/s3c-camif/camif-core.c
+++ b/drivers/media/platform/s3c-camif/camif-core.c
@@ -305,7 +305,7 @@ static void camif_unregister_media_entities(struct camif_dev *camif)
 /*
  * Media device
  */
-static int camif_media_dev_register(struct camif_dev *camif)
+static int camif_media_dev_init(struct camif_dev *camif)
 {
 	struct media_device *md = &camif->media_dev;
 	struct v4l2_device *v4l2_dev = &camif->v4l2_dev;
@@ -328,9 +328,7 @@ static int camif_media_dev_register(struct camif_dev *camif)
 	if (ret < 0)
 		return ret;
 
-	ret = media_device_register(md);
-	if (ret < 0)
-		v4l2_device_unregister(v4l2_dev);
+	media_device_init(md);
 
 	return ret;
 }
@@ -483,7 +481,7 @@ static int s3c_camif_probe(struct platform_device *pdev)
 		goto err_alloc;
 	}
 
-	ret = camif_media_dev_register(camif);
+	ret = camif_media_dev_init(camif);
 	if (ret < 0)
 		goto err_mdev;
 
@@ -510,6 +508,11 @@ static int s3c_camif_probe(struct platform_device *pdev)
 		goto err_unlock;
 
 	mutex_unlock(&camif->media_dev.graph_mutex);
+
+	ret = media_device_register(&camif->media_dev);
+	if (ret < 0)
+		goto err_sens;
+
 	pm_runtime_put(dev);
 	return 0;
 
@@ -518,6 +521,7 @@ err_unlock:
 err_sens:
 	v4l2_device_unregister(&camif->v4l2_dev);
 	media_device_unregister(&camif->media_dev);
+	media_device_cleanup(&camif->media_dev);
 	camif_unregister_media_entities(camif);
 err_mdev:
 	vb2_dma_contig_cleanup_ctx(camif->alloc_ctx);
@@ -539,6 +543,7 @@ static int s3c_camif_remove(struct platform_device *pdev)
 	struct s3c_camif_plat_data *pdata = &camif->pdata;
 
 	media_device_unregister(&camif->media_dev);
+	media_device_cleanup(&camif->media_dev);
 	camif_unregister_media_entities(camif);
 	v4l2_device_unregister(&camif->v4l2_dev);
 
diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index 8f995d267646..58c2560b2840 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -127,6 +127,7 @@ static void vsp1_destroy_entities(struct vsp1_device *vsp1)
 
 	v4l2_device_unregister(&vsp1->v4l2_dev);
 	media_device_unregister(&vsp1->media_dev);
+	media_device_cleanup(&vsp1->media_dev);
 }
 
 static int vsp1_create_entities(struct vsp1_device *vsp1)
@@ -141,12 +142,7 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
 	strlcpy(mdev->model, "VSP1", sizeof(mdev->model));
 	snprintf(mdev->bus_info, sizeof(mdev->bus_info), "platform:%s",
 		 dev_name(mdev->dev));
-	ret = media_device_register(mdev);
-	if (ret < 0) {
-		dev_err(vsp1->dev, "media device registration failed (%d)\n",
-			ret);
-		return ret;
-	}
+	media_device_init(mdev);
 
 	vdev->mdev = mdev;
 	ret = v4l2_device_register(vsp1->dev, vdev);
@@ -288,6 +284,10 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
 	}
 
 	ret = v4l2_device_register_subdev_nodes(&vsp1->v4l2_dev);
+	if (ret < 0)
+		goto done;
+
+	ret = media_device_register(mdev);
 
 done:
 	if (ret < 0)
diff --git a/drivers/media/platform/xilinx/xilinx-vipp.c b/drivers/media/platform/xilinx/xilinx-vipp.c
index 79d4be7ce9a5..7c7eb7d73781 100644
--- a/drivers/media/platform/xilinx/xilinx-vipp.c
+++ b/drivers/media/platform/xilinx/xilinx-vipp.c
@@ -311,7 +311,7 @@ static int xvip_graph_notify_complete(struct v4l2_async_notifier *notifier)
 	if (ret < 0)
 		dev_err(xdev->dev, "failed to register subdev nodes\n");
 
-	return ret;
+	return media_device_register(&xdev->media_dev);
 }
 
 static int xvip_graph_notify_bound(struct v4l2_async_notifier *notifier,
@@ -571,6 +571,7 @@ static void xvip_composite_v4l2_cleanup(struct xvip_composite_device *xdev)
 {
 	v4l2_device_unregister(&xdev->v4l2_dev);
 	media_device_unregister(&xdev->media_dev);
+	media_device_cleanup(&xdev->media_dev);
 }
 
 static int xvip_composite_v4l2_init(struct xvip_composite_device *xdev)
@@ -582,19 +583,14 @@ static int xvip_composite_v4l2_init(struct xvip_composite_device *xdev)
 		sizeof(xdev->media_dev.model));
 	xdev->media_dev.hw_revision = 0;
 
-	ret = media_device_register(&xdev->media_dev);
-	if (ret < 0) {
-		dev_err(xdev->dev, "media device registration failed (%d)\n",
-			ret);
-		return ret;
-	}
+	media_device_init(&xdev->media_dev);
 
 	xdev->v4l2_dev.mdev = &xdev->media_dev;
 	ret = v4l2_device_register(xdev->dev, &xdev->v4l2_dev);
 	if (ret < 0) {
 		dev_err(xdev->dev, "V4L2 device registration failed (%d)\n",
 			ret);
-		media_device_unregister(&xdev->media_dev);
+		media_device_cleanup(&xdev->media_dev);
 		return ret;
 	}
 
diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index 1c12285428fe..0245a584de65 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -136,6 +136,7 @@ static void au0828_unregister_media_device(struct au0828_dev *dev)
 #ifdef CONFIG_MEDIA_CONTROLLER
 	if (dev->media_dev) {
 		media_device_unregister(dev->media_dev);
+		media_device_cleanup(dev->media_dev);
 		kfree(dev->media_dev);
 		dev->media_dev = NULL;
 	}
@@ -214,12 +215,11 @@ static void au0828_usb_disconnect(struct usb_interface *interface)
 	au0828_usb_release(dev);
 }
 
-static void au0828_media_device_register(struct au0828_dev *dev,
-					  struct usb_device *udev)
+static void au0828_media_device_init(struct au0828_dev *dev,
+				     struct usb_device *udev)
 {
 #ifdef CONFIG_MEDIA_CONTROLLER
 	struct media_device *mdev;
-	int ret;
 
 	mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
 	if (!mdev)
@@ -237,14 +237,7 @@ static void au0828_media_device_register(struct au0828_dev *dev,
 	mdev->hw_revision = le16_to_cpu(udev->descriptor.bcdDevice);
 	mdev->driver_version = LINUX_VERSION_CODE;
 
-	ret = media_device_register(mdev);
-	if (ret) {
-		pr_err(
-			"Couldn't create a media device. Error: %d\n",
-			ret);
-		kfree(mdev);
-		return;
-	}
+	media_device_init(mdev);
 
 	dev->media_dev = mdev;
 #endif
@@ -372,8 +365,8 @@ static int au0828_usb_probe(struct usb_interface *interface,
 	dev->boardnr = id->driver_info;
 	dev->board = au0828_boards[dev->boardnr];
 
-	/* Register the media controller */
-	au0828_media_device_register(dev, usbdev);
+	/* Initialize the media controller */
+	au0828_media_device_init(dev, usbdev);
 
 #ifdef CONFIG_VIDEO_AU0828_V4L2
 	dev->v4l2_dev.release = au0828_usb_v4l2_release;
@@ -444,9 +437,15 @@ static int au0828_usb_probe(struct usb_interface *interface,
 	if (retval) {
 		pr_err("%s() au0282_dev_register failed to create graph\n",
 		       __func__);
-		au0828_usb_disconnect(interface);
+		goto done;
 	}
 
+	retval = media_device_register(dev->media_dev);
+
+done:
+	if (retval < 0)
+		au0828_usb_disconnect(interface);
+
 	return retval;
 }
 
diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index 022b30099a89..5df4a0ef37fe 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -1172,6 +1172,7 @@ static void cx231xx_unregister_media_device(struct cx231xx *dev)
 #ifdef CONFIG_MEDIA_CONTROLLER
 	if (dev->media_dev) {
 		media_device_unregister(dev->media_dev);
+		media_device_cleanup(dev->media_dev);
 		kfree(dev->media_dev);
 		dev->media_dev = NULL;
 	}
@@ -1205,12 +1206,11 @@ void cx231xx_release_resources(struct cx231xx *dev)
 	clear_bit(dev->devno, &cx231xx_devused);
 }
 
-static void cx231xx_media_device_register(struct cx231xx *dev,
-					  struct usb_device *udev)
+static void cx231xx_media_device_init(struct cx231xx *dev,
+				      struct usb_device *udev)
 {
 #ifdef CONFIG_MEDIA_CONTROLLER
 	struct media_device *mdev;
-	int ret;
 
 	mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
 	if (!mdev)
@@ -1224,14 +1224,7 @@ static void cx231xx_media_device_register(struct cx231xx *dev,
 	mdev->hw_revision = le16_to_cpu(udev->descriptor.bcdDevice);
 	mdev->driver_version = LINUX_VERSION_CODE;
 
-	ret = media_device_register(mdev);
-	if (ret) {
-		dev_err(dev->dev,
-			"Couldn't create a media device. Error: %d\n",
-			ret);
-		kfree(mdev);
-		return;
-	}
+	media_device_init(mdev);
 
 	dev->media_dev = mdev;
 #endif
@@ -1669,8 +1662,8 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 	/* save our data pointer in this interface device */
 	usb_set_intfdata(interface, dev);
 
-	/* Register the media controller */
-	cx231xx_media_device_register(dev, udev);
+	/* Initialize the media controller */
+	cx231xx_media_device_init(dev, udev);
 
 	/* Create v4l2 device */
 #ifdef CONFIG_MEDIA_CONTROLLER
@@ -1742,11 +1735,16 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 	request_modules(dev);
 
 	retval = cx231xx_create_media_graph(dev);
-	if (retval < 0) {
-		cx231xx_release_resources(dev);
-	}
+	if (retval < 0)
+		goto done;
+
+	retval = media_device_register(dev->media_dev);
 
+done:
+	if (retval < 0)
+		cx231xx_release_resources(dev);
 	return retval;
+
 err_video_alt:
 	/* cx231xx_uninit_dev: */
 	cx231xx_close_extension(dev);
diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
index 6d3f61f6dc77..a0413dcc3361 100644
--- a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
+++ b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
@@ -400,7 +400,7 @@ skip_feed_stop:
 	return ret;
 }
 
-static void dvb_usbv2_media_device_register(struct dvb_usb_adapter *adap)
+static void dvb_usbv2_media_device_init(struct dvb_usb_adapter *adap)
 {
 #ifdef CONFIG_MEDIA_CONTROLLER_DVB
 	struct media_device *mdev;
@@ -420,14 +420,7 @@ static void dvb_usbv2_media_device_register(struct dvb_usb_adapter *adap)
 	mdev->hw_revision = le16_to_cpu(udev->descriptor.bcdDevice);
 	mdev->driver_version = LINUX_VERSION_CODE;
 
-	ret = media_device_register(mdev);
-	if (ret) {
-		dev_err(&d->udev->dev,
-			"Couldn't create a media device. Error: %d\n",
-			ret);
-		kfree(mdev);
-		return;
-	}
+	media_device_init(mdev);
 
 	dvb_register_media_controller(&adap->dvb_adap, mdev);
 
@@ -436,6 +429,13 @@ static void dvb_usbv2_media_device_register(struct dvb_usb_adapter *adap)
 #endif
 }
 
+static void dvb_usbv2_media_device_register(struct dvb_usb_adapter *adap)
+{
+#ifdef CONFIG_MEDIA_CONTROLLER_DVB
+	media_device_register(adap->dvb_adap.mdev);
+#endif
+}
+
 static void dvb_usbv2_media_device_unregister(struct dvb_usb_adapter *adap)
 {
 #ifdef CONFIG_MEDIA_CONTROLLER_DVB
@@ -444,6 +444,7 @@ static void dvb_usbv2_media_device_unregister(struct dvb_usb_adapter *adap)
 		return;
 
 	media_device_unregister(adap->dvb_adap.mdev);
+	media_device_cleanup(adap->dvb_adap.mdev);
 	kfree(adap->dvb_adap.mdev);
 	adap->dvb_adap.mdev = NULL;
 
@@ -467,7 +468,7 @@ static int dvb_usbv2_adapter_dvb_init(struct dvb_usb_adapter *adap)
 
 	adap->dvb_adap.priv = adap;
 
-	dvb_usbv2_media_device_register(adap);
+	dvb_usbv2_media_device_init(adap);
 
 	if (d->props->read_mac_address) {
 		ret = d->props->read_mac_address(adap,
@@ -702,6 +703,8 @@ static int dvb_usbv2_adapter_frontend_init(struct dvb_usb_adapter *adap)
 	if (ret < 0)
 		goto err_dvb_unregister_frontend;
 
+	dvb_usbv2_media_device_register(&adap->dvb_adap);
+
 	return 0;
 
 err_dvb_unregister_frontend:
diff --git a/drivers/media/usb/dvb-usb/dvb-usb-dvb.c b/drivers/media/usb/dvb-usb/dvb-usb-dvb.c
index b51dbdf03f42..4086d9626664 100644
--- a/drivers/media/usb/dvb-usb/dvb-usb-dvb.c
+++ b/drivers/media/usb/dvb-usb/dvb-usb-dvb.c
@@ -95,7 +95,7 @@ static int dvb_usb_stop_feed(struct dvb_demux_feed *dvbdmxfeed)
 	return dvb_usb_ctrl_feed(dvbdmxfeed, 0);
 }
 
-static void dvb_usb_media_device_register(struct dvb_usb_adapter *adap)
+static void dvb_usb_media_device_init(struct dvb_usb_adapter *adap)
 {
 #ifdef CONFIG_MEDIA_CONTROLLER_DVB
 	struct media_device *mdev;
@@ -115,20 +115,21 @@ static void dvb_usb_media_device_register(struct dvb_usb_adapter *adap)
 	mdev->hw_revision = le16_to_cpu(udev->descriptor.bcdDevice);
 	mdev->driver_version = LINUX_VERSION_CODE;
 
-	ret = media_device_register(mdev);
-	if (ret) {
-		dev_err(&d->udev->dev,
-			"Couldn't create a media device. Error: %d\n",
-			ret);
-		kfree(mdev);
-		return;
-	}
+	media_device_init(mdev);
+
 	dvb_register_media_controller(&adap->dvb_adap, mdev);
 
 	dev_info(&d->udev->dev, "media controller created\n");
 #endif
 }
 
+static void dvb_usb_media_device_register(struct dvb_usb_adapter *adap)
+{
+#ifdef CONFIG_MEDIA_CONTROLLER_DVB
+	media_device_register(adap->dvb_adap.mdev);
+#endif
+}
+
 static void dvb_usb_media_device_unregister(struct dvb_usb_adapter *adap)
 {
 #ifdef CONFIG_MEDIA_CONTROLLER_DVB
@@ -136,6 +137,7 @@ static void dvb_usb_media_device_unregister(struct dvb_usb_adapter *adap)
 		return;
 
 	media_device_unregister(adap->dvb_adap.mdev);
+	media_device_cleanup(adap->dvb_adap.mdev);
 	kfree(adap->dvb_adap.mdev);
 	adap->dvb_adap.mdev = NULL;
 #endif
@@ -154,7 +156,7 @@ int dvb_usb_adapter_dvb_init(struct dvb_usb_adapter *adap, short *adapter_nums)
 	}
 	adap->dvb_adap.priv = adap;
 
-	dvb_usb_media_device_register(adap);
+	dvb_usb_media_device_init(adap);
 
 	if (adap->dev->props.read_mac_address) {
 		if (adap->dev->props.read_mac_address(adap->dev, adap->dvb_adap.proposed_mac) == 0)
@@ -323,6 +325,8 @@ int dvb_usb_adapter_frontend_init(struct dvb_usb_adapter *adap)
 
 	ret = dvb_create_media_graph(&adap->dvb_adap);
 
+	dvb_usb_media_device_register(adap);
+
 	return ret;
 }
 
diff --git a/drivers/media/usb/siano/smsusb.c b/drivers/media/usb/siano/smsusb.c
index c945e4c2fbd4..8abbd3cc8eba 100644
--- a/drivers/media/usb/siano/smsusb.c
+++ b/drivers/media/usb/siano/smsusb.c
@@ -361,10 +361,11 @@ static void *siano_media_device_register(struct smsusb_device_t *dev,
 	mdev->hw_revision = le16_to_cpu(udev->descriptor.bcdDevice);
 	mdev->driver_version = LINUX_VERSION_CODE;
 
+	media_device_init(mdev);
+
 	ret = media_device_register(mdev);
 	if (ret) {
-		pr_err("Couldn't create a media device. Error: %d\n",
-			ret);
+		media_device_cleanup(mdev);
 		kfree(mdev);
 		return NULL;
 	}
diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 4b5b3e8fb7d3..08f45a86d40a 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -1655,6 +1655,7 @@ static void uvc_delete(struct uvc_device *dev)
 #ifdef CONFIG_MEDIA_CONTROLLER
 	if (media_devnode_is_registered(&dev->mdev.devnode))
 		media_device_unregister(&dev->mdev);
+	media_device_cleanup(&dev->mdev);
 #endif
 
 	list_for_each_safe(p, n, &dev->chains) {
@@ -1905,7 +1906,7 @@ static int uvc_probe(struct usb_interface *intf,
 			"linux-uvc-devel mailing list.\n");
 	}
 
-	/* Register the media and V4L2 devices. */
+	/* Initialize the media device and register the V4L2 device. */
 #ifdef CONFIG_MEDIA_CONTROLLER
 	dev->mdev.dev = &intf->dev;
 	strlcpy(dev->mdev.model, dev->name, sizeof(dev->mdev.model));
@@ -1915,8 +1916,7 @@ static int uvc_probe(struct usb_interface *intf,
 	strcpy(dev->mdev.bus_info, udev->devpath);
 	dev->mdev.hw_revision = le16_to_cpu(udev->descriptor.bcdDevice);
 	dev->mdev.driver_version = LINUX_VERSION_CODE;
-	if (media_device_register(&dev->mdev) < 0)
-		goto error;
+	media_device_init(&dev->mdev);
 
 	dev->vdev.mdev = &dev->mdev;
 #endif
@@ -1935,6 +1935,10 @@ static int uvc_probe(struct usb_interface *intf,
 	if (uvc_register_chains(dev) < 0)
 		goto error;
 
+	/* Register the media device node */
+	if (media_device_register(&dev->mdev) < 0)
+		goto error;
+
 	/* Save our data pointer in the interface data. */
 	usb_set_intfdata(intf, dev);
 
diff --git a/include/media/media-device.h b/include/media/media-device.h
index 1b12774a9ab4..a2c757071fce 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -106,6 +106,8 @@ struct media_device {
 /* media_devnode to media_device */
 #define to_media_device(node) container_of(node, struct media_device, devnode)
 
+void media_device_init(struct media_device *mdev);
+void media_device_cleanup(struct media_device *mdev);
 int __must_check __media_device_register(struct media_device *mdev,
 					 struct module *owner);
 #define media_device_register(mdev) __media_device_register(mdev, THIS_MODULE)
-- 
2.4.3

