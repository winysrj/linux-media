Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40480 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751459AbcGNWf0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jul 2016 18:35:26 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, shuahkh@osg.samsung.com,
	laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl
Subject: [RFC 15/16] omap3isp: Release the isp device struct by media device callback
Date: Fri, 15 Jul 2016 01:35:10 +0300
Message-Id: <1468535711-13836-16-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1468535711-13836-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1468535711-13836-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use the media device release callback to release the isp device's data
structure. This approach has the benefit of not releasing memory which may
still be accessed through open file handles whilst the isp driver is being
unbound.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/platform/omap3isp/isp.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index b09d2508..a0dff24 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -1671,6 +1671,8 @@ static int isp_link_entity(
 	return media_create_pad_link(entity, i, input, pad, flags);
 }
 
+static void isp_release(struct media_device *mdev);
+
 static int isp_register_entities(struct isp_device *isp)
 {
 	int ret;
@@ -1683,6 +1685,7 @@ static int isp_register_entities(struct isp_device *isp)
 		sizeof(isp->media_dev->model));
 	isp->media_dev->hw_revision = isp->revision;
 	isp->media_dev->link_notify = v4l2_pipeline_link_notify;
+	isp->media_dev->release = isp_release;
 
 	isp->v4l2_dev.mdev = isp->media_dev;
 	ret = v4l2_device_register(isp->dev, &isp->v4l2_dev);
@@ -1943,6 +1946,20 @@ static void isp_detach_iommu(struct isp_device *isp)
 	iommu_group_remove_device(isp->dev);
 }
 
+static void isp_release(struct media_device *mdev)
+{
+	struct isp_device *isp = media_device_priv(mdev);
+
+	isp_cleanup_modules(isp);
+	isp_xclk_cleanup(isp);
+
+	__omap3isp_get(isp, false);
+	isp_detach_iommu(isp);
+	__omap3isp_put(isp, false);
+
+	media_entity_enum_cleanup(&isp->crashed);
+}
+
 static int isp_attach_iommu(struct isp_device *isp)
 {
 	struct dma_iommu_mapping *mapping;
@@ -2003,14 +2020,6 @@ static int isp_remove(struct platform_device *pdev)
 
 	v4l2_async_notifier_unregister(&isp->notifier);
 	isp_unregister_entities(isp);
-	isp_cleanup_modules(isp);
-	isp_xclk_cleanup(isp);
-
-	__omap3isp_get(isp, false);
-	isp_detach_iommu(isp);
-	__omap3isp_put(isp, false);
-
-	media_entity_enum_cleanup(&isp->crashed);
 
 	return 0;
 }
-- 
2.1.4

