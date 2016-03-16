Return-path: <linux-media-owner@vger.kernel.org>
Received: from [198.137.202.9] ([198.137.202.9]:39114 "EHLO
	bombadil.infradead.org" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S965780AbcCPMFG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Mar 2016 08:05:06 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hyun Kwon <hyun.kwon@xilinx.com>,
	Michal Simek <michal.simek@xilinx.com>,
	=?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
	Antti Palosaari <crope@iki.fi>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Seung-Woo Kim <sw0312.kim@samsung.com>,
	Junghak Sung <jh1009.sung@samsung.com>,
	Geunyoung Kim <nenggun.kim@samsung.com>,
	Arnd Bergmann <arnd@arndb.de>,
	=?UTF-8?q?Rafael=20Louren=C3=A7o=20de=20Lima=20Chehab?=
	<chehabrafael@gmail.com>, Matthias Schwarzott <zzam@gentoo.org>,
	Tommi Rantala <tt.rantala@gmail.com>,
	Patrick Boettcher <patrick.boettcher@posteo.de>,
	Luis de Bethencourt <luis@debethencourt.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org,
	linux-renesas-soc@vger.kernel.org
Subject: [PATCH 5/5] [media] media-device: make media_device_cleanup() static
Date: Wed, 16 Mar 2016 09:04:06 -0300
Message-Id: <864cdbedcdde600b09d77bfecb1b828e16e41ac0.1458129823.git.mchehab@osg.samsung.com>
In-Reply-To: <dba4d41bdfa6bb8dc51cb0f692102919b2b7c8b4.1458129823.git.mchehab@osg.samsung.com>
References: <dba4d41bdfa6bb8dc51cb0f692102919b2b7c8b4.1458129823.git.mchehab@osg.samsung.com>
In-Reply-To: <dba4d41bdfa6bb8dc51cb0f692102919b2b7c8b4.1458129823.git.mchehab@osg.samsung.com>
References: <dba4d41bdfa6bb8dc51cb0f692102919b2b7c8b4.1458129823.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When multiple drivers are sharing the media_device struct,
one driver cannot know the right moment to cleanup the
media_device struct, because it can happen only when the
struct is not used by the other drivers.

So, let's call media_device_cleanup() internally, and
ensure that media_device_unregister() will do the right thing,
if the media device is not fully initialized.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/common/siano/smsdvb-main.c      |  1 -
 drivers/media/media-device.c                  | 13 ++++++-------
 drivers/media/pci/saa7134/saa7134-core.c      |  1 -
 drivers/media/platform/exynos4-is/media-dev.c |  3 +--
 drivers/media/platform/omap3isp/isp.c         |  1 -
 drivers/media/platform/s3c-camif/camif-core.c |  2 --
 drivers/media/platform/vsp1/vsp1_drv.c        |  1 -
 drivers/media/platform/xilinx/xilinx-vipp.c   |  3 +--
 drivers/media/usb/au0828/au0828-core.c        |  1 -
 drivers/media/usb/cx231xx/cx231xx-cards.c     |  1 -
 drivers/media/usb/dvb-usb-v2/dvb_usb_core.c   |  1 -
 drivers/media/usb/dvb-usb/dvb-usb-dvb.c       |  1 -
 drivers/media/usb/em28xx/em28xx-cards.c       |  1 -
 drivers/media/usb/siano/smsusb.c              |  2 +-
 drivers/media/usb/uvc/uvc_driver.c            |  4 +---
 include/media/media-device.h                  | 10 ----------
 16 files changed, 10 insertions(+), 36 deletions(-)

diff --git a/drivers/media/common/siano/smsdvb-main.c b/drivers/media/common/siano/smsdvb-main.c
index 9148e14c9d07..711c389c05e3 100644
--- a/drivers/media/common/siano/smsdvb-main.c
+++ b/drivers/media/common/siano/smsdvb-main.c
@@ -617,7 +617,6 @@ static void smsdvb_media_device_unregister(struct smsdvb_client_t *client)
 	if (!coredev->media_dev)
 		return;
 	media_device_unregister(coredev->media_dev);
-	media_device_cleanup(coredev->media_dev);
 	kfree(coredev->media_dev);
 	coredev->media_dev = NULL;
 #endif
diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 38e6c319fe6e..0c7371eeda84 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -707,14 +707,12 @@ void media_device_init(struct media_device *mdev)
 }
 EXPORT_SYMBOL_GPL(media_device_init);
 
-void media_device_cleanup(struct media_device *mdev)
+static void media_device_cleanup(struct media_device *mdev)
 {
 	ida_destroy(&mdev->entity_internal_idx);
 	mdev->entity_internal_idx_max = 0;
 	media_entity_graph_walk_cleanup(&mdev->pm_count_walk);
-	mutex_destroy(&mdev->graph_mutex);
 }
-EXPORT_SYMBOL_GPL(media_device_cleanup);
 
 int __must_check __media_device_register(struct media_device *mdev,
 					 struct module *owner)
@@ -812,11 +810,12 @@ static void do_media_device_unregister(struct kref *kref)
 	}
 
 	/* Check if mdev devnode was registered */
-	if (!media_devnode_is_registered(&mdev->devnode))
-		return;
+	if (media_devnode_is_registered(&mdev->devnode)) {
+		device_remove_file(&mdev->devnode.dev, &dev_attr_model);
+		media_devnode_unregister(&mdev->devnode);
+	}
 
-	device_remove_file(&mdev->devnode.dev, &dev_attr_model);
-	media_devnode_unregister(&mdev->devnode);
+	media_device_cleanup(mdev);
 
 	dev_dbg(mdev->dev, "Media device unregistered\n");
 }
diff --git a/drivers/media/pci/saa7134/saa7134-core.c b/drivers/media/pci/saa7134/saa7134-core.c
index c0e1780ec831..213dc71f09eb 100644
--- a/drivers/media/pci/saa7134/saa7134-core.c
+++ b/drivers/media/pci/saa7134/saa7134-core.c
@@ -813,7 +813,6 @@ static void saa7134_unregister_media_device(struct saa7134_dev *dev)
 	if (!dev->media_dev)
 		return;
 	media_device_unregister(dev->media_dev);
-	media_device_cleanup(dev->media_dev);
 	kfree(dev->media_dev);
 	dev->media_dev = NULL;
 #endif
diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index feb521f28e14..8c106fda7b84 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -1501,7 +1501,7 @@ err_clk:
 err_m_ent:
 	fimc_md_unregister_entities(fmd);
 err_md:
-	media_device_cleanup(&fmd->media_dev);
+	media_device_unregister(&fmd->media_dev);
 	v4l2_device_unregister(&fmd->v4l2_dev);
 	return ret;
 }
@@ -1521,7 +1521,6 @@ static int fimc_md_remove(struct platform_device *pdev)
 	fimc_md_unregister_entities(fmd);
 	fimc_md_pipelines_free(fmd);
 	media_device_unregister(&fmd->media_dev);
-	media_device_cleanup(&fmd->media_dev);
 	fimc_md_put_clocks(fmd);
 
 	return 0;
diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 5d54e2c6c16b..cd67edcad8d3 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -1598,7 +1598,6 @@ static void isp_unregister_entities(struct isp_device *isp)
 
 	v4l2_device_unregister(&isp->v4l2_dev);
 	media_device_unregister(&isp->media_dev);
-	media_device_cleanup(&isp->media_dev);
 }
 
 static int isp_link_entity(
diff --git a/drivers/media/platform/s3c-camif/camif-core.c b/drivers/media/platform/s3c-camif/camif-core.c
index 0b44b9accf50..0159f98da435 100644
--- a/drivers/media/platform/s3c-camif/camif-core.c
+++ b/drivers/media/platform/s3c-camif/camif-core.c
@@ -521,7 +521,6 @@ err_unlock:
 err_sens:
 	v4l2_device_unregister(&camif->v4l2_dev);
 	media_device_unregister(&camif->media_dev);
-	media_device_cleanup(&camif->media_dev);
 	camif_unregister_media_entities(camif);
 err_mdev:
 	vb2_dma_contig_cleanup_ctx(camif->alloc_ctx);
@@ -543,7 +542,6 @@ static int s3c_camif_remove(struct platform_device *pdev)
 	struct s3c_camif_plat_data *pdata = &camif->pdata;
 
 	media_device_unregister(&camif->media_dev);
-	media_device_cleanup(&camif->media_dev);
 	camif_unregister_media_entities(camif);
 	v4l2_device_unregister(&camif->v4l2_dev);
 
diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index 25750a0e4631..2faefec89b62 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -213,7 +213,6 @@ static void vsp1_destroy_entities(struct vsp1_device *vsp1)
 
 	v4l2_device_unregister(&vsp1->v4l2_dev);
 	media_device_unregister(&vsp1->media_dev);
-	media_device_cleanup(&vsp1->media_dev);
 
 	if (!vsp1->info->uapi)
 		vsp1_drm_cleanup(vsp1);
diff --git a/drivers/media/platform/xilinx/xilinx-vipp.c b/drivers/media/platform/xilinx/xilinx-vipp.c
index e795a4501e8b..ec4b21c64ef6 100644
--- a/drivers/media/platform/xilinx/xilinx-vipp.c
+++ b/drivers/media/platform/xilinx/xilinx-vipp.c
@@ -573,7 +573,6 @@ static void xvip_composite_v4l2_cleanup(struct xvip_composite_device *xdev)
 {
 	v4l2_device_unregister(&xdev->v4l2_dev);
 	media_device_unregister(&xdev->media_dev);
-	media_device_cleanup(&xdev->media_dev);
 }
 
 static int xvip_composite_v4l2_init(struct xvip_composite_device *xdev)
@@ -592,7 +591,7 @@ static int xvip_composite_v4l2_init(struct xvip_composite_device *xdev)
 	if (ret < 0) {
 		dev_err(xdev->dev, "V4L2 device registration failed (%d)\n",
 			ret);
-		media_device_cleanup(&xdev->media_dev);
+		media_device_unregister(&xdev->media_dev);
 		return ret;
 	}
 
diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index 06da73f1ff22..0a26ffff6f18 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -158,7 +158,6 @@ static void au0828_unregister_media_device(struct au0828_dev *dev)
 	dev->media_dev->disable_source = NULL;
 
 	media_device_unregister(dev->media_dev);
-	media_device_cleanup(dev->media_dev);
 	dev->media_dev = NULL;
 #endif
 }
diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index c63248a18823..438fe0761bda 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -1172,7 +1172,6 @@ static void cx231xx_unregister_media_device(struct cx231xx *dev)
 #ifdef CONFIG_MEDIA_CONTROLLER
 	if (dev->media_dev) {
 		media_device_unregister(dev->media_dev);
-		media_device_cleanup(dev->media_dev);
 		kfree(dev->media_dev);
 		dev->media_dev = NULL;
 	}
diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
index 3fbb2cd19f5e..238ecb3a510b 100644
--- a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
+++ b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
@@ -438,7 +438,6 @@ static void dvb_usbv2_media_device_unregister(struct dvb_usb_adapter *adap)
 		return;
 
 	media_device_unregister(adap->dvb_adap.mdev);
-	media_device_cleanup(adap->dvb_adap.mdev);
 	kfree(adap->dvb_adap.mdev);
 	adap->dvb_adap.mdev = NULL;
 
diff --git a/drivers/media/usb/dvb-usb/dvb-usb-dvb.c b/drivers/media/usb/dvb-usb/dvb-usb-dvb.c
index 6477b04e95c7..093ca809b5f8 100644
--- a/drivers/media/usb/dvb-usb/dvb-usb-dvb.c
+++ b/drivers/media/usb/dvb-usb/dvb-usb-dvb.c
@@ -132,7 +132,6 @@ static void dvb_usb_media_device_unregister(struct dvb_usb_adapter *adap)
 		return;
 
 	media_device_unregister(adap->dvb_adap.mdev);
-	media_device_cleanup(adap->dvb_adap.mdev);
 	kfree(adap->dvb_adap.mdev);
 	adap->dvb_adap.mdev = NULL;
 #endif
diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 930e3e3fc948..734ecfb890ff 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -3091,7 +3091,6 @@ static void em28xx_unregister_media_device(struct em28xx *dev)
 #ifdef CONFIG_MEDIA_CONTROLLER
 	if (dev->media_dev) {
 		media_device_unregister(dev->media_dev);
-		media_device_cleanup(dev->media_dev);
 		kfree(dev->media_dev);
 		dev->media_dev = NULL;
 	}
diff --git a/drivers/media/usb/siano/smsusb.c b/drivers/media/usb/siano/smsusb.c
index c2e25876e93b..cbf9a34f2074 100644
--- a/drivers/media/usb/siano/smsusb.c
+++ b/drivers/media/usb/siano/smsusb.c
@@ -375,7 +375,7 @@ static void *siano_media_device_register(struct smsusb_device_t *dev,
 
 	ret = media_device_register(mdev);
 	if (ret) {
-		media_device_cleanup(mdev);
+		media_device_unregister(mdev);
 		kfree(mdev);
 		return NULL;
 	}
diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 451e84e962e2..dcce75e1aff2 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -1674,9 +1674,7 @@ static void uvc_delete(struct uvc_device *dev)
 	if (dev->vdev.dev)
 		v4l2_device_unregister(&dev->vdev);
 #ifdef CONFIG_MEDIA_CONTROLLER
-	if (media_devnode_is_registered(&dev->mdev.devnode))
-		media_device_unregister(&dev->mdev);
-	media_device_cleanup(&dev->mdev);
+	media_device_unregister(&dev->mdev);
 #endif
 
 	list_for_each_safe(p, n, &dev->chains) {
diff --git a/include/media/media-device.h b/include/media/media-device.h
index 73c16e6e6b6b..9166bff8068e 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -430,16 +430,6 @@ static inline __must_check int media_entity_enum_init(
 void media_device_init(struct media_device *mdev);
 
 /**
- * media_device_cleanup() - Cleanups a media device element
- *
- * @mdev:	pointer to struct &media_device
- *
- * This function that will destroy the graph_mutex that is
- * initialized in media_device_init().
- */
-void media_device_cleanup(struct media_device *mdev);
-
-/**
  * __media_device_register() - Registers a media device element
  *
  * @mdev:	pointer to struct &media_device
-- 
2.5.0

