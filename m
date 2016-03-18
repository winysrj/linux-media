Return-path: <linux-media-owner@vger.kernel.org>
Received: from [198.137.202.9] ([198.137.202.9]:56690 "EHLO
	bombadil.infradead.org" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S932156AbcCRNGm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Mar 2016 09:06:42 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
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
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Junghak Sung <jh1009.sung@samsung.com>,
	Inki Dae <inki.dae@samsung.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Geunyoung Kim <nenggun.kim@samsung.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	=?UTF-8?q?Rafael=20Louren=C3=A7o=20de=20Lima=20Chehab?=
	<chehabrafael@gmail.com>, Tommi Rantala <tt.rantala@gmail.com>,
	Matthias Schwarzott <zzam@gentoo.org>,
	Patrick Boettcher <patrick.boettcher@posteo.de>,
	Luis de Bethencourt <luis@debethencourt.com>,
	Amitoj Kaur Chawla <amitoj1606@gmail.com>,
	Julia Lawall <Julia.Lawall@lip6.fr>,
	linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org,
	linux-renesas-soc@vger.kernel.org, devel@driverdev.osuosl.org,
	alsa-devel@alsa-project.org
Subject: [PATCH] [media] media: rename media unregister function
Date: Fri, 18 Mar 2016 10:05:45 -0300
Message-Id: <2ffc02c944068b2c8655727238d1542f8328385d.1458306276.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that media_device_unregister() also does a cleanup, rename it
to media_device_unregister_cleanup().

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/common/siano/smsdvb-main.c             | 2 +-
 drivers/media/media-device.c                         | 4 ++--
 drivers/media/pci/saa7134/saa7134-core.c             | 2 +-
 drivers/media/platform/exynos4-is/media-dev.c        | 4 ++--
 drivers/media/platform/omap3isp/isp.c                | 2 +-
 drivers/media/platform/s3c-camif/camif-core.c        | 4 ++--
 drivers/media/platform/vsp1/vsp1_drv.c               | 2 +-
 drivers/media/platform/xilinx/xilinx-vipp.c          | 4 ++--
 drivers/media/usb/au0828/au0828-core.c               | 2 +-
 drivers/media/usb/cx231xx/cx231xx-cards.c            | 2 +-
 drivers/media/usb/dvb-usb-v2/dvb_usb_core.c          | 2 +-
 drivers/media/usb/dvb-usb/dvb-usb-dvb.c              | 2 +-
 drivers/media/usb/em28xx/em28xx-cards.c              | 2 +-
 drivers/media/usb/siano/smsusb.c                     | 4 ++--
 drivers/media/usb/uvc/uvc_driver.c                   | 2 +-
 drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c | 4 ++--
 drivers/staging/media/omap4iss/iss.c                 | 2 +-
 include/media/media-device.h                         | 6 +++---
 include/media/media-entity.h                         | 2 +-
 sound/usb/media.c                                    | 2 +-
 20 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/drivers/media/common/siano/smsdvb-main.c b/drivers/media/common/siano/smsdvb-main.c
index 711c389c05e3..26184f84f41b 100644
--- a/drivers/media/common/siano/smsdvb-main.c
+++ b/drivers/media/common/siano/smsdvb-main.c
@@ -616,7 +616,7 @@ static void smsdvb_media_device_unregister(struct smsdvb_client_t *client)
 
 	if (!coredev->media_dev)
 		return;
-	media_device_unregister(coredev->media_dev);
+	media_device_unregister_cleanup(coredev->media_dev);
 	kfree(coredev->media_dev);
 	coredev->media_dev = NULL;
 #endif
diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 070421e4d32e..9076439abc5f 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -822,7 +822,7 @@ printk("%s: mdev=%p\n", __func__, mdev);
 	dev_dbg(mdev->dev, "Media device unregistered\n");
 }
 
-void media_device_unregister(struct media_device *mdev)
+void media_device_unregister_cleanup(struct media_device *mdev)
 {
 printk("%s: mdev=%p\n", __func__, mdev);
 	if (mdev == NULL)
@@ -833,7 +833,7 @@ printk("%s: mdev=%p\n", __func__, mdev);
 	mutex_unlock(&mdev->graph_mutex);
 
 }
-EXPORT_SYMBOL_GPL(media_device_unregister);
+EXPORT_SYMBOL_GPL(media_device_unregister_cleanup);
 
 static void media_device_release_devres(struct device *dev, void *res)
 {
diff --git a/drivers/media/pci/saa7134/saa7134-core.c b/drivers/media/pci/saa7134/saa7134-core.c
index 213dc71f09eb..5f08cb22fb1a 100644
--- a/drivers/media/pci/saa7134/saa7134-core.c
+++ b/drivers/media/pci/saa7134/saa7134-core.c
@@ -812,7 +812,7 @@ static void saa7134_unregister_media_device(struct saa7134_dev *dev)
 #ifdef CONFIG_MEDIA_CONTROLLER
 	if (!dev->media_dev)
 		return;
-	media_device_unregister(dev->media_dev);
+	media_device_unregister_cleanup(dev->media_dev);
 	kfree(dev->media_dev);
 	dev->media_dev = NULL;
 #endif
diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index 8c106fda7b84..e968523e0b5c 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -1501,7 +1501,7 @@ err_clk:
 err_m_ent:
 	fimc_md_unregister_entities(fmd);
 err_md:
-	media_device_unregister(&fmd->media_dev);
+	media_device_unregister_cleanup(&fmd->media_dev);
 	v4l2_device_unregister(&fmd->v4l2_dev);
 	return ret;
 }
@@ -1520,7 +1520,7 @@ static int fimc_md_remove(struct platform_device *pdev)
 	device_remove_file(&pdev->dev, &dev_attr_subdev_conf_mode);
 	fimc_md_unregister_entities(fmd);
 	fimc_md_pipelines_free(fmd);
-	media_device_unregister(&fmd->media_dev);
+	media_device_unregister_cleanup(&fmd->media_dev);
 	fimc_md_put_clocks(fmd);
 
 	return 0;
diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index cd67edcad8d3..b8fe65fb06cb 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -1597,7 +1597,7 @@ static void isp_unregister_entities(struct isp_device *isp)
 	omap3isp_stat_unregister_entities(&isp->isp_hist);
 
 	v4l2_device_unregister(&isp->v4l2_dev);
-	media_device_unregister(&isp->media_dev);
+	media_device_unregister_cleanup(&isp->media_dev);
 }
 
 static int isp_link_entity(
diff --git a/drivers/media/platform/s3c-camif/camif-core.c b/drivers/media/platform/s3c-camif/camif-core.c
index 0159f98da435..303a84d7f4ec 100644
--- a/drivers/media/platform/s3c-camif/camif-core.c
+++ b/drivers/media/platform/s3c-camif/camif-core.c
@@ -520,7 +520,7 @@ err_unlock:
 	mutex_unlock(&camif->media_dev.graph_mutex);
 err_sens:
 	v4l2_device_unregister(&camif->v4l2_dev);
-	media_device_unregister(&camif->media_dev);
+	media_device_unregister_cleanup(&camif->media_dev);
 	camif_unregister_media_entities(camif);
 err_mdev:
 	vb2_dma_contig_cleanup_ctx(camif->alloc_ctx);
@@ -541,7 +541,7 @@ static int s3c_camif_remove(struct platform_device *pdev)
 	struct camif_dev *camif = platform_get_drvdata(pdev);
 	struct s3c_camif_plat_data *pdata = &camif->pdata;
 
-	media_device_unregister(&camif->media_dev);
+	media_device_unregister_cleanup(&camif->media_dev);
 	camif_unregister_media_entities(camif);
 	v4l2_device_unregister(&camif->v4l2_dev);
 
diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index 2faefec89b62..b227319521ba 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -212,7 +212,7 @@ static void vsp1_destroy_entities(struct vsp1_device *vsp1)
 	}
 
 	v4l2_device_unregister(&vsp1->v4l2_dev);
-	media_device_unregister(&vsp1->media_dev);
+	media_device_unregister_cleanup(&vsp1->media_dev);
 
 	if (!vsp1->info->uapi)
 		vsp1_drm_cleanup(vsp1);
diff --git a/drivers/media/platform/xilinx/xilinx-vipp.c b/drivers/media/platform/xilinx/xilinx-vipp.c
index ec4b21c64ef6..e46407af3f95 100644
--- a/drivers/media/platform/xilinx/xilinx-vipp.c
+++ b/drivers/media/platform/xilinx/xilinx-vipp.c
@@ -572,7 +572,7 @@ done:
 static void xvip_composite_v4l2_cleanup(struct xvip_composite_device *xdev)
 {
 	v4l2_device_unregister(&xdev->v4l2_dev);
-	media_device_unregister(&xdev->media_dev);
+	media_device_unregister_cleanup(&xdev->media_dev);
 }
 
 static int xvip_composite_v4l2_init(struct xvip_composite_device *xdev)
@@ -591,7 +591,7 @@ static int xvip_composite_v4l2_init(struct xvip_composite_device *xdev)
 	if (ret < 0) {
 		dev_err(xdev->dev, "V4L2 device registration failed (%d)\n",
 			ret);
-		media_device_unregister(&xdev->media_dev);
+		media_device_unregister_cleanup(&xdev->media_dev);
 		return ret;
 	}
 
diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index 0a26ffff6f18..61ea468d9c3e 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -157,7 +157,7 @@ static void au0828_unregister_media_device(struct au0828_dev *dev)
 	dev->media_dev->enable_source = NULL;
 	dev->media_dev->disable_source = NULL;
 
-	media_device_unregister(dev->media_dev);
+	media_device_unregister_cleanup(dev->media_dev);
 	dev->media_dev = NULL;
 #endif
 }
diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index 438fe0761bda..004bd0c42771 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -1171,7 +1171,7 @@ static void cx231xx_unregister_media_device(struct cx231xx *dev)
 {
 #ifdef CONFIG_MEDIA_CONTROLLER
 	if (dev->media_dev) {
-		media_device_unregister(dev->media_dev);
+		media_device_unregister_cleanup(dev->media_dev);
 		kfree(dev->media_dev);
 		dev->media_dev = NULL;
 	}
diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
index 238ecb3a510b..a6da9aec965d 100644
--- a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
+++ b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
@@ -437,7 +437,7 @@ static void dvb_usbv2_media_device_unregister(struct dvb_usb_adapter *adap)
 	if (!adap->dvb_adap.mdev)
 		return;
 
-	media_device_unregister(adap->dvb_adap.mdev);
+	media_device_unregister_cleanup(adap->dvb_adap.mdev);
 	kfree(adap->dvb_adap.mdev);
 	adap->dvb_adap.mdev = NULL;
 
diff --git a/drivers/media/usb/dvb-usb/dvb-usb-dvb.c b/drivers/media/usb/dvb-usb/dvb-usb-dvb.c
index 093ca809b5f8..653e0c6a7542 100644
--- a/drivers/media/usb/dvb-usb/dvb-usb-dvb.c
+++ b/drivers/media/usb/dvb-usb/dvb-usb-dvb.c
@@ -131,7 +131,7 @@ static void dvb_usb_media_device_unregister(struct dvb_usb_adapter *adap)
 	if (!adap->dvb_adap.mdev)
 		return;
 
-	media_device_unregister(adap->dvb_adap.mdev);
+	media_device_unregister_cleanup(adap->dvb_adap.mdev);
 	kfree(adap->dvb_adap.mdev);
 	adap->dvb_adap.mdev = NULL;
 #endif
diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 734ecfb890ff..1307667ff234 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -3090,7 +3090,7 @@ static void em28xx_unregister_media_device(struct em28xx *dev)
 
 #ifdef CONFIG_MEDIA_CONTROLLER
 	if (dev->media_dev) {
-		media_device_unregister(dev->media_dev);
+		media_device_unregister_cleanup(dev->media_dev);
 		kfree(dev->media_dev);
 		dev->media_dev = NULL;
 	}
diff --git a/drivers/media/usb/siano/smsusb.c b/drivers/media/usb/siano/smsusb.c
index cbf9a34f2074..b4f6955b00a8 100644
--- a/drivers/media/usb/siano/smsusb.c
+++ b/drivers/media/usb/siano/smsusb.c
@@ -375,7 +375,7 @@ static void *siano_media_device_register(struct smsusb_device_t *dev,
 
 	ret = media_device_register(mdev);
 	if (ret) {
-		media_device_unregister(mdev);
+		media_device_unregister_cleanup(mdev);
 		kfree(mdev);
 		return NULL;
 	}
@@ -452,7 +452,7 @@ static int smsusb_init_device(struct usb_interface *intf, int board_id)
 		pr_err("smscore_register_device(...) failed, rc %d\n", rc);
 		smsusb_term_device(intf);
 #ifdef CONFIG_MEDIA_CONTROLLER_DVB
-		media_device_unregister(mdev);
+		media_device_unregister_cleanup(mdev);
 #endif
 		kfree(mdev);
 		return rc;
diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index dcce75e1aff2..8d8d17eab817 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -1674,7 +1674,7 @@ static void uvc_delete(struct uvc_device *dev)
 	if (dev->vdev.dev)
 		v4l2_device_unregister(&dev->vdev);
 #ifdef CONFIG_MEDIA_CONTROLLER
-	media_device_unregister(&dev->mdev);
+	media_device_unregister_cleanup(&dev->mdev);
 #endif
 
 	list_for_each_safe(p, n, &dev->chains) {
diff --git a/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c b/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c
index ec46f366dd17..9c1258992d88 100644
--- a/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c
+++ b/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c
@@ -673,7 +673,7 @@ probe_out_entities_unregister:
 probe_out_v4l2_unregister:
 	v4l2_device_unregister(&vpfe_dev->v4l2_dev);
 probe_out_media_unregister:
-	media_device_unregister(&vpfe_dev->media_dev);
+	media_device_unregister_cleanup(&vpfe_dev->media_dev);
 probe_out_entities_cleanup:
 	vpfe_cleanup_modules(vpfe_dev, pdev);
 probe_disable_clock:
@@ -698,7 +698,7 @@ static int vpfe_remove(struct platform_device *pdev)
 	vpfe_unregister_entities(vpfe_dev);
 	vpfe_cleanup_modules(vpfe_dev, pdev);
 	v4l2_device_unregister(&vpfe_dev->v4l2_dev);
-	media_device_unregister(&vpfe_dev->media_dev);
+	media_device_unregister_cleanup(&vpfe_dev->media_dev);
 	vpfe_disable_clock(vpfe_dev);
 	kzfree(vpfe_dev);
 
diff --git a/drivers/staging/media/omap4iss/iss.c b/drivers/staging/media/omap4iss/iss.c
index fb80d2bc5a25..3f8ae4645026 100644
--- a/drivers/staging/media/omap4iss/iss.c
+++ b/drivers/staging/media/omap4iss/iss.c
@@ -926,7 +926,7 @@ static void iss_unregister_entities(struct iss_device *iss)
 	omap4iss_csi2_unregister_entities(&iss->csi2b);
 
 	v4l2_device_unregister(&iss->v4l2_dev);
-	media_device_unregister(&iss->media_dev);
+	media_device_unregister_cleanup(&iss->media_dev);
 }
 
 /*
diff --git a/include/media/media-device.h b/include/media/media-device.h
index 4a475604d992..dcf9cbccf1c9 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -70,7 +70,7 @@
  * Drivers register media device instances by calling
  *	__media_device_register() via the macro media_device_register()
  * and unregistered by calling
- *	media_device_unregister().
+ *	media_device_unregister_cleanup().
  *
  * * Entities, pads and links:
  *
@@ -491,7 +491,7 @@ int __must_check __media_device_register(struct media_device *mdev,
  * It is safe to call this function on an unregistered (but initialised)
  * media device.
  */
-void media_device_unregister(struct media_device *mdev);
+void media_device_unregister_cleanup(struct media_device *mdev);
 
 /**
  * media_device_register_entity() - registers a media entity inside a
@@ -650,7 +650,7 @@ static inline int media_device_register(struct media_device *mdev)
 {
 	return 0;
 }
-static inline void media_device_unregister(struct media_device *mdev)
+static inline void media_device_unregister_cleanup(struct media_device *mdev)
 {
 }
 static inline int media_device_register_entity(struct media_device *mdev,
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 6dc9e4e8cbd4..82384503a77b 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -547,7 +547,7 @@ void media_gobj_create(struct media_device *mdev,
  *
  * @gobj:	Pointer to the graph object
  *
- * This should be called by all routines like media_device_unregister()
+ * This should be called by all routines like media_device_unregister_cleanup()
  * that remove/destroy media graph objects.
  */
 void media_gobj_destroy(struct media_gobj *gobj);
diff --git a/sound/usb/media.c b/sound/usb/media.c
index 0d03773b4c67..67758a2f23d6 100644
--- a/sound/usb/media.c
+++ b/sound/usb/media.c
@@ -304,7 +304,7 @@ void media_snd_device_delete(struct snd_usb_audio *chip)
 
 	if (mdev) {
 		if (media_devnode_is_registered(&mdev->devnode))
-			media_device_unregister(mdev);
+			media_device_unregister_cleanup(mdev);
 		chip->media_dev = NULL;
 	}
 }
-- 
2.5.0

