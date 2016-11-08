Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35298 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752479AbcKHNzj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 Nov 2016 08:55:39 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Cc: mchehab@osg.samsung.com, shuahkh@osg.samsung.com,
        laurent.pinchart@ideasonboard.com
Subject: [RFC v4 20/21] omap3isp: Release the isp device struct by media device callback
Date: Tue,  8 Nov 2016 15:55:29 +0200
Message-Id: <1478613330-24691-20-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1478613330-24691-1-git-send-email-sakari.ailus@linux.intel.com>
References: <20161108135438.GO3217@valkosipuli.retiisi.org.uk>
 <1478613330-24691-1-git-send-email-sakari.ailus@linux.intel.com>
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
index 8bc7a7c..54b84a0 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -657,8 +657,11 @@ static irqreturn_t isp_isr(int irq, void *_isp)
 	return IRQ_HANDLED;
 }
 
+static void isp_release(struct media_device *mdev);
+
 static const struct media_device_ops isp_media_ops = {
 	.link_notify = v4l2_pipeline_link_notify,
+	.release = isp_release,
 };
 
 /* -----------------------------------------------------------------------------
@@ -1948,6 +1951,20 @@ static void isp_detach_iommu(struct isp_device *isp)
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
@@ -2008,14 +2025,6 @@ static int isp_remove(struct platform_device *pdev)
 
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

