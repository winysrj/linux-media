Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:5038 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750904AbcEDM3q (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 May 2016 08:29:46 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	mchehab@osg.samsung.com,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Subject: [PATCH 1/3] media: Move media_device link_notify operation to an ops structure
Date: Wed,  4 May 2016 15:26:43 +0300
Message-Id: <1462364803-2579-1-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1462361133-23887-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1462361133-23887-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

This will allow adding new operations without increasing the
media_device structure size for drivers that don't implement any media
device operation.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Fix compilation error for the omap3isp driver.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/media-entity.c                  | 11 ++++++-----
 drivers/media/platform/exynos4-is/media-dev.c |  6 +++++-
 drivers/media/platform/omap3isp/isp.c         |  6 +++++-
 drivers/staging/media/omap4iss/iss.c          |  6 +++++-
 include/media/media-device.h                  | 16 ++++++++++++----
 5 files changed, 33 insertions(+), 12 deletions(-)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index c53c1d5..301fd4f 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -806,17 +806,18 @@ int __media_entity_setup_link(struct media_link *link, u32 flags)
 
 	mdev = source->graph_obj.mdev;
 
-	if (mdev->link_notify) {
-		ret = mdev->link_notify(link, flags,
-					MEDIA_DEV_NOTIFY_PRE_LINK_CH);
+	if (mdev->ops && mdev->ops->link_notify) {
+		ret = mdev->ops->link_notify(link, flags,
+					     MEDIA_DEV_NOTIFY_PRE_LINK_CH);
 		if (ret < 0)
 			return ret;
 	}
 
 	ret = __media_entity_setup_link_notify(link, flags);
 
-	if (mdev->link_notify)
-		mdev->link_notify(link, flags, MEDIA_DEV_NOTIFY_POST_LINK_CH);
+	if (mdev->ops && mdev->ops->link_notify)
+		mdev->ops->link_notify(link, flags,
+				       MEDIA_DEV_NOTIFY_POST_LINK_CH);
 
 	return ret;
 }
diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index 04348b5..1ed1a9e 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -1190,6 +1190,10 @@ static int fimc_md_link_notify(struct media_link *link, unsigned int flags,
 	return ret ? -EPIPE : 0;
 }
 
+static const struct media_device_ops fimc_md_ops = {
+	.link_notify = fimc_md_link_notify,
+};
+
 static ssize_t fimc_md_sysfs_show(struct device *dev,
 				  struct device_attribute *attr, char *buf)
 {
@@ -1416,7 +1420,7 @@ static int fimc_md_probe(struct platform_device *pdev)
 
 	strlcpy(fmd->media_dev.model, "SAMSUNG S5P FIMC",
 		sizeof(fmd->media_dev.model));
-	fmd->media_dev.link_notify = fimc_md_link_notify;
+	fmd->media_dev.ops = &fimc_md_ops;
 	fmd->media_dev.dev = dev;
 
 	v4l2_dev = &fmd->v4l2_dev;
diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 5d54e2c..0321d84 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -657,6 +657,10 @@ static irqreturn_t isp_isr(int irq, void *_isp)
 	return IRQ_HANDLED;
 }
 
+static const struct media_device_ops isp_media_ops = {
+	.link_notify = v4l2_pipeline_link_notify,
+};
+
 /* -----------------------------------------------------------------------------
  * Pipeline stream management
  */
@@ -1680,7 +1684,7 @@ static int isp_register_entities(struct isp_device *isp)
 	strlcpy(isp->media_dev.model, "TI OMAP3 ISP",
 		sizeof(isp->media_dev.model));
 	isp->media_dev.hw_revision = isp->revision;
-	isp->media_dev.link_notify = v4l2_pipeline_link_notify;
+	isp->media_dev.ops = &isp_media_ops;
 	media_device_init(&isp->media_dev);
 
 	isp->v4l2_dev.mdev = &isp->media_dev;
diff --git a/drivers/staging/media/omap4iss/iss.c b/drivers/staging/media/omap4iss/iss.c
index c5a5138..355a704 100644
--- a/drivers/staging/media/omap4iss/iss.c
+++ b/drivers/staging/media/omap4iss/iss.c
@@ -362,6 +362,10 @@ static irqreturn_t iss_isr(int irq, void *_iss)
 	return IRQ_HANDLED;
 }
 
+static const struct media_device_ops iss_media_ops = {
+	.link_notify = v4l2_pipeline_link_notify,
+};
+
 /* -----------------------------------------------------------------------------
  * Pipeline stream management
  */
@@ -988,7 +992,7 @@ static int iss_register_entities(struct iss_device *iss)
 	strlcpy(iss->media_dev.model, "TI OMAP4 ISS",
 		sizeof(iss->media_dev.model));
 	iss->media_dev.hw_revision = iss->revision;
-	iss->media_dev.link_notify = v4l2_pipeline_link_notify;
+	iss->media_dev.ops = &iss_media_ops;
 	ret = media_device_register(&iss->media_dev);
 	if (ret < 0) {
 		dev_err(iss->dev, "Media device registration failed (%d)\n",
diff --git a/include/media/media-device.h b/include/media/media-device.h
index a9b33c4..19c8ed4 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -280,6 +280,16 @@ struct media_entity_notify {
 };
 
 /**
+ * struct media_device_ops - Media device operations
+ * @link_notify: Link state change notification callback. This callback is
+ *		 called with the graph_mutex held.
+ */
+struct media_device_ops {
+	int (*link_notify)(struct media_link *link, u32 flags,
+			   unsigned int notification);
+};
+
+/**
  * struct media_device - Media device
  * @dev:	Parent device
  * @devnode:	Media device node
@@ -311,8 +321,7 @@ struct media_entity_notify {
  * @enable_source: Enable Source Handler function pointer
  * @disable_source: Disable Source Handler function pointer
  *
- * @link_notify: Link state change notification callback. This callback is
- *		 called with the graph_mutex held.
+ * @ops:	Operation handler callbacks
  *
  * This structure represents an abstract high-level media device. It allows easy
  * access to entities and provides basic media device-level support. The
@@ -379,8 +388,7 @@ struct media_device {
 			     struct media_pipeline *pipe);
 	void (*disable_source)(struct media_entity *entity);
 
-	int (*link_notify)(struct media_link *link, u32 flags,
-			   unsigned int notification);
+	const struct media_device_ops *ops;
 };
 
 /* We don't need to include pci.h or usb.h here */
-- 
1.9.1

