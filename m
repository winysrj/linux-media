Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44652 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933289AbbLQIlA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Dec 2015 03:41:00 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH/RFC 21/48] media: Move media_device link_notify operation to an ops structure
Date: Thu, 17 Dec 2015 10:39:59 +0200
Message-Id: <1450341626-6695-22-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1450341626-6695-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1450341626-6695-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This will allow adding new operations without increasing the
media_device structure size for drivers that don't implement any media
device operation.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/media-entity.c                  | 11 ++++++-----
 drivers/media/platform/exynos4-is/media-dev.c |  6 +++++-
 drivers/media/platform/omap3isp/isp.c         |  6 +++++-
 drivers/staging/media/omap4iss/iss.c          |  6 +++++-
 include/media/media-device.h                  | 14 +++++++++++---
 5 files changed, 32 insertions(+), 11 deletions(-)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 767fe55ba08e..1e1c08c0c947 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -592,17 +592,18 @@ int __media_entity_setup_link(struct media_link *link, u32 flags)
 
 	mdev = source->parent;
 
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
index 9481ce3201a2..091f5930e424 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -1111,6 +1111,10 @@ static int fimc_md_link_notify(struct media_link *link, unsigned int flags,
 	return ret ? -EPIPE : 0;
 }
 
+static const struct media_device_ops fimc_md_ops = {
+	.link_notify = fimc_md_link_notify,
+};
+
 static ssize_t fimc_md_sysfs_show(struct device *dev,
 				  struct device_attribute *attr, char *buf)
 {
@@ -1334,7 +1338,7 @@ static int fimc_md_probe(struct platform_device *pdev)
 
 	strlcpy(fmd->media_dev.model, "SAMSUNG S5P FIMC",
 		sizeof(fmd->media_dev.model));
-	fmd->media_dev.link_notify = fimc_md_link_notify;
+	fmd->media_dev.ops = &fimc_md_ops;
 	fmd->media_dev.dev = dev;
 
 	v4l2_dev = &fmd->v4l2_dev;
diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 56e683b19a73..a35c292955e7 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -851,6 +851,10 @@ static int isp_pipeline_link_notify(struct media_link *link, u32 flags,
 	return 0;
 }
 
+static const struct media_device_ops isp_media_ops {
+	.link_notify = isp_pipeline_link_notify,
+};
+
 /* -----------------------------------------------------------------------------
  * Pipeline stream management
  */
@@ -1873,7 +1877,7 @@ static int isp_register_entities(struct isp_device *isp)
 	strlcpy(isp->media_dev.model, "TI OMAP3 ISP",
 		sizeof(isp->media_dev.model));
 	isp->media_dev.hw_revision = isp->revision;
-	isp->media_dev.link_notify = isp_pipeline_link_notify;
+	isp->media_dev.ops = &isp_media_ops;
 	ret = media_device_register(&isp->media_dev);
 	if (ret < 0) {
 		dev_err(isp->dev, "%s: Media device registration failed (%d)\n",
diff --git a/drivers/staging/media/omap4iss/iss.c b/drivers/staging/media/omap4iss/iss.c
index e27a988540a6..dbff493c6a25 100644
--- a/drivers/staging/media/omap4iss/iss.c
+++ b/drivers/staging/media/omap4iss/iss.c
@@ -556,6 +556,10 @@ static int iss_pipeline_link_notify(struct media_link *link, u32 flags,
 	return 0;
 }
 
+static const struct media_device_ops iss_media_ops = {
+	.link_notify = iss_pipeline_link_notify,
+};
+
 /* -----------------------------------------------------------------------------
  * Pipeline stream management
  */
@@ -1183,7 +1187,7 @@ static int iss_register_entities(struct iss_device *iss)
 	strlcpy(iss->media_dev.model, "TI OMAP4 ISS",
 		sizeof(iss->media_dev.model));
 	iss->media_dev.hw_revision = iss->revision;
-	iss->media_dev.link_notify = iss_pipeline_link_notify;
+	iss->media_dev.ops = &iss_media_ops;
 	ret = media_device_register(&iss->media_dev);
 	if (ret < 0) {
 		dev_err(iss->dev, "Media device registration failed (%d)\n",
diff --git a/include/media/media-device.h b/include/media/media-device.h
index 6e6db78f1ee2..7e6de4dbf497 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -33,6 +33,15 @@
 struct device;
 
 /**
+ * struct media_device_ops - Media device operations
+ * @link_notify: Link state change notification callback
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
@@ -45,7 +54,7 @@ struct device;
  * @entities:	List of registered entities
  * @lock:	Entities list lock
  * @graph_mutex: Entities graph operation lock
- * @link_notify: Link state change notification callback
+ * @ops:	Operation handler callbacks
  *
  * This structure represents an abstract high-level media device. It allows easy
  * access to entities and provides basic media device-level support. The
@@ -76,8 +85,7 @@ struct media_device {
 	/* Serializes graph operations. */
 	struct mutex graph_mutex;
 
-	int (*link_notify)(struct media_link *link, u32 flags,
-			   unsigned int notification);
+	const struct media_device_ops *ops;
 };
 
 /* Supported link_notify @notification values. */
-- 
2.4.10

