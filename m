Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f49.google.com ([209.85.214.49]:57350 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116Ab3FIUPj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 Jun 2013 16:15:39 -0400
Received: by mail-bk0-f49.google.com with SMTP id mz10so838516bkb.22
        for <linux-media@vger.kernel.org>; Sun, 09 Jun 2013 13:15:38 -0700 (PDT)
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	kyungmin.park@samsung.com, sw0312.kim@samsung.com,
	a.hajda@samsung.com, hj210.choi@samsung.com,
	shaik.ameer@samsung.com, arun.kk@samsung.com,
	s.nawrocki@samsung.com
Subject: [REVIEW PATCH v3 1/2] media: Change media device link_notify behaviour
Date: Sun,  9 Jun 2013 22:14:37 +0200
Message-Id: <1370808878-11379-2-git-send-email-s.nawrocki@samsung.com>
In-Reply-To: <1370808878-11379-1-git-send-email-s.nawrocki@samsung.com>
References: <1370808878-11379-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently the media device link_notify callback is invoked before the
actual change of state of a link when the link is being enabled, and
after the actual change of state when the link is being disabled.

This doesn't allow a media device driver to perform any operations
on a full graph before a link is disabled, as well as performing
any tasks on a modified graph right after a link's state is changed.

This patch modifies signature of the link_notify callback. This
callback is now called always before and after a link's state change.
To distinguish the notifications a 'notification' argument is added
to the link_notify callback: MEDIA_DEV_NOTIFY_PRE_LINK_CH indicates
notification before link's state change and
MEDIA_DEV_NOTIFY_POST_LINK_CH corresponds to a notification after
link flags change.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
Changes since v1:
 - link_notify callback 'flags' argument's type changed to u32,
 - in the omap3isp driver check link->flags instead of the passed flags
   argument of the link_notify handler to see if pipeline should be
   powered off,
-  use link->flags to check link's state in the fimc_md_link_notify()
   handler instead of link_notify 'flags' argument.
---
 drivers/media/media-entity.c                  |   18 +++--------
 drivers/media/platform/exynos4-is/media-dev.c |   18 ++++++-----
 drivers/media/platform/omap3isp/isp.c         |   41 +++++++++++++++----------
 include/media/media-device.h                  |    9 ++++-
 4 files changed, 47 insertions(+), 39 deletions(-)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index e1cd132..7004cb0 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -496,25 +496,17 @@ int __media_entity_setup_link(struct media_link *link, u32 flags)
 
 	mdev = source->parent;
 
-	if ((flags & MEDIA_LNK_FL_ENABLED) && mdev->link_notify) {
-		ret = mdev->link_notify(link->source, link->sink,
-					MEDIA_LNK_FL_ENABLED);
+	if (mdev->link_notify) {
+		ret = mdev->link_notify(link, flags,
+					MEDIA_DEV_NOTIFY_PRE_LINK_CH);
 		if (ret < 0)
 			return ret;
 	}
 
 	ret = __media_entity_setup_link_notify(link, flags);
-	if (ret < 0)
-		goto err;
 
-	if (!(flags & MEDIA_LNK_FL_ENABLED) && mdev->link_notify)
-		mdev->link_notify(link->source, link->sink, 0);
-
-	return 0;
-
-err:
-	if ((flags & MEDIA_LNK_FL_ENABLED) && mdev->link_notify)
-		mdev->link_notify(link->source, link->sink, 0);
+	if (mdev->link_notify)
+		mdev->link_notify(link, flags, MEDIA_DEV_NOTIFY_POST_LINK_CH);
 
 	return ret;
 }
diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index 424ff92..045a6ae 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -1287,34 +1287,36 @@ int fimc_md_set_camclk(struct v4l2_subdev *sd, bool on)
 	return __fimc_md_set_camclk(fmd, si, on);
 }
 
-static int fimc_md_link_notify(struct media_pad *source,
-			       struct media_pad *sink, u32 flags)
+static int fimc_md_link_notify(struct media_link *link, u32 flags,
+						unsigned int notification)
 {
+	struct media_entity *sink = link->sink->entity;
 	struct exynos_video_entity *ve;
 	struct video_device *vdev;
 	struct fimc_pipeline *pipeline;
 	int i, ret = 0;
 
-	if (media_entity_type(sink->entity) != MEDIA_ENT_T_DEVNODE_V4L)
+	if (media_entity_type(sink) != MEDIA_ENT_T_DEVNODE_V4L ||
+	    notification == MEDIA_DEV_NOTIFY_PRE_LINK_CH)
 		return 0;
 
-	vdev = media_entity_to_video_device(sink->entity);
+	vdev = media_entity_to_video_device(sink);
 	ve = vdev_to_exynos_video_entity(vdev);
 	pipeline = to_fimc_pipeline(ve->pipe);
 
-	if (!(flags & MEDIA_LNK_FL_ENABLED) && pipeline->subdevs[IDX_SENSOR]) {
-		if (sink->entity->use_count > 0)
+	if (!(link->flags & MEDIA_LNK_FL_ENABLED) && pipeline->subdevs[IDX_SENSOR]) {
+		if (sink->use_count > 0)
 			ret = __fimc_pipeline_close(ve->pipe);
 
 		for (i = 0; i < IDX_MAX; i++)
 			pipeline->subdevs[i] = NULL;
-	} else if (sink->entity->use_count > 0) {
+	} else if (sink->use_count > 0) {
 		/*
 		 * Link activation. Enable power of pipeline elements only if
 		 * the pipeline is already in use, i.e. its video node is open.
 		 * Recreate the controls destroyed during the link deactivation.
 		 */
-		ret = __fimc_pipeline_open(ve->pipe, sink->entity, true);
+		ret = __fimc_pipeline_open(ve->pipe, sink, true);
 	}
 
 	return ret ? -EPIPE : ret;
diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 1d7dbd5..1a2d25c 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -792,9 +792,9 @@ int omap3isp_pipeline_pm_use(struct media_entity *entity, int use)
 
 /*
  * isp_pipeline_link_notify - Link management notification callback
- * @source: Pad at the start of the link
- * @sink: Pad at the end of the link
+ * @link: The link
  * @flags: New link flags that will be applied
+ * @notification: The link's state change notification type (MEDIA_DEV_NOTIFY_*)
  *
  * React to link management on powered pipelines by updating the use count of
  * all entities in the source and sink sides of the link. Entities are powered
@@ -804,29 +804,38 @@ int omap3isp_pipeline_pm_use(struct media_entity *entity, int use)
  * off is assumed to never fail. This function will not fail for disconnection
  * events.
  */
-static int isp_pipeline_link_notify(struct media_pad *source,
-				    struct media_pad *sink, u32 flags)
+static int isp_pipeline_link_notify(struct media_link *link, u32 flags,
+				    unsigned int notification)
 {
-	int source_use = isp_pipeline_pm_use_count(source->entity);
-	int sink_use = isp_pipeline_pm_use_count(sink->entity);
+	struct media_entity *source = link->source->entity;
+	struct media_entity *sink = link->sink->entity;
+	int source_use = isp_pipeline_pm_use_count(source);
+	int sink_use = isp_pipeline_pm_use_count(sink);
 	int ret;
 
-	if (!(flags & MEDIA_LNK_FL_ENABLED)) {
+	if (notification == MEDIA_DEV_NOTIFY_POST_LINK_CH &&
+	    !(link->flags & MEDIA_LNK_FL_ENABLED)) {
 		/* Powering off entities is assumed to never fail. */
-		isp_pipeline_pm_power(source->entity, -sink_use);
-		isp_pipeline_pm_power(sink->entity, -source_use);
+		isp_pipeline_pm_power(source, -sink_use);
+		isp_pipeline_pm_power(sink, -source_use);
 		return 0;
 	}
 
-	ret = isp_pipeline_pm_power(source->entity, sink_use);
-	if (ret < 0)
-		return ret;
+	if (notification == MEDIA_DEV_NOTIFY_PRE_LINK_CH &&
+		(flags & MEDIA_LNK_FL_ENABLED)) {
 
-	ret = isp_pipeline_pm_power(sink->entity, source_use);
-	if (ret < 0)
-		isp_pipeline_pm_power(source->entity, -sink_use);
+		ret = isp_pipeline_pm_power(source, sink_use);
+		if (ret < 0)
+			return ret;
 
-	return ret;
+		ret = isp_pipeline_pm_power(sink, source_use);
+		if (ret < 0)
+			isp_pipeline_pm_power(source, -sink_use);
+
+		return ret;
+	}
+
+	return 0;
 }
 
 /* -----------------------------------------------------------------------------
diff --git a/include/media/media-device.h b/include/media/media-device.h
index eaade98..12155a9 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -45,6 +45,7 @@ struct device;
  * @entities:	List of registered entities
  * @lock:	Entities list lock
  * @graph_mutex: Entities graph operation lock
+ * @link_notify: Link state change notification callback
  *
  * This structure represents an abstract high-level media device. It allows easy
  * access to entities and provides basic media device-level support. The
@@ -75,10 +76,14 @@ struct media_device {
 	/* Serializes graph operations. */
 	struct mutex graph_mutex;
 
-	int (*link_notify)(struct media_pad *source,
-			   struct media_pad *sink, u32 flags);
+	int (*link_notify)(struct media_link *link, u32 flags,
+			   unsigned int notification);
 };
 
+/* Supported link_notify @notification values. */
+#define MEDIA_DEV_NOTIFY_PRE_LINK_CH	0
+#define MEDIA_DEV_NOTIFY_POST_LINK_CH	1
+
 /* media_devnode to media_device */
 #define to_media_device(node) container_of(node, struct media_device, devnode)
 
-- 
1.7.4.1

