Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52616 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753013AbcBURk3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Feb 2016 12:40:29 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, Sakari Ailus <sakari.ailus@iki.fi>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH v3 3/4] v4l: omap3isp: Use V4L2 graph PM operations
Date: Sun, 21 Feb 2016 18:25:10 +0200
Message-Id: <1456071911-3284-4-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1456071911-3284-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1456071911-3284-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@iki.fi>

Power on devices represented by entities in the graph through the pipeline
state using V4L2 graph PM operations instead of what was in the omap3isp
driver.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/isp.c      | 213 +----------------------------
 drivers/media/platform/omap3isp/isp.h      |   4 -
 drivers/media/platform/omap3isp/ispvideo.c |  13 +-
 drivers/media/platform/omap3isp/ispvideo.h |   1 -
 4 files changed, 6 insertions(+), 225 deletions(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index f9e5245..5d54e2c 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -64,6 +64,7 @@
 
 #include <media/v4l2-common.h>
 #include <media/v4l2-device.h>
+#include <media/v4l2-mc.h>
 #include <media/v4l2-of.h>
 
 #include "isp.h"
@@ -657,216 +658,6 @@ static irqreturn_t isp_isr(int irq, void *_isp)
 }
 
 /* -----------------------------------------------------------------------------
- * Pipeline power management
- *
- * Entities must be powered up when part of a pipeline that contains at least
- * one open video device node.
- *
- * To achieve this use the entity use_count field to track the number of users.
- * For entities corresponding to video device nodes the use_count field stores
- * the users count of the node. For entities corresponding to subdevs the
- * use_count field stores the total number of users of all video device nodes
- * in the pipeline.
- *
- * The omap3isp_pipeline_pm_use() function must be called in the open() and
- * close() handlers of video device nodes. It increments or decrements the use
- * count of all subdev entities in the pipeline.
- *
- * To react to link management on powered pipelines, the link setup notification
- * callback updates the use count of all entities in the source and sink sides
- * of the link.
- */
-
-/*
- * isp_pipeline_pm_use_count - Count the number of users of a pipeline
- * @entity: The entity
- *
- * Return the total number of users of all video device nodes in the pipeline.
- */
-static int isp_pipeline_pm_use_count(struct media_entity *entity,
-	struct media_entity_graph *graph)
-{
-	int use = 0;
-
-	media_entity_graph_walk_start(graph, entity);
-
-	while ((entity = media_entity_graph_walk_next(graph))) {
-		if (is_media_entity_v4l2_io(entity))
-			use += entity->use_count;
-	}
-
-	return use;
-}
-
-/*
- * isp_pipeline_pm_power_one - Apply power change to an entity
- * @entity: The entity
- * @change: Use count change
- *
- * Change the entity use count by @change. If the entity is a subdev update its
- * power state by calling the core::s_power operation when the use count goes
- * from 0 to != 0 or from != 0 to 0.
- *
- * Return 0 on success or a negative error code on failure.
- */
-static int isp_pipeline_pm_power_one(struct media_entity *entity, int change)
-{
-	struct v4l2_subdev *subdev;
-	int ret;
-
-	subdev = is_media_entity_v4l2_subdev(entity)
-	       ? media_entity_to_v4l2_subdev(entity) : NULL;
-
-	if (entity->use_count == 0 && change > 0 && subdev != NULL) {
-		ret = v4l2_subdev_call(subdev, core, s_power, 1);
-		if (ret < 0 && ret != -ENOIOCTLCMD)
-			return ret;
-	}
-
-	entity->use_count += change;
-	WARN_ON(entity->use_count < 0);
-
-	if (entity->use_count == 0 && change < 0 && subdev != NULL)
-		v4l2_subdev_call(subdev, core, s_power, 0);
-
-	return 0;
-}
-
-/*
- * isp_pipeline_pm_power - Apply power change to all entities in a pipeline
- * @entity: The entity
- * @change: Use count change
- *
- * Walk the pipeline to update the use count and the power state of all non-node
- * entities.
- *
- * Return 0 on success or a negative error code on failure.
- */
-static int isp_pipeline_pm_power(struct media_entity *entity, int change,
-	struct media_entity_graph *graph)
-{
-	struct media_entity *first = entity;
-	int ret = 0;
-
-	if (!change)
-		return 0;
-
-	media_entity_graph_walk_start(graph, entity);
-
-	while (!ret && (entity = media_entity_graph_walk_next(graph)))
-		if (is_media_entity_v4l2_subdev(entity))
-			ret = isp_pipeline_pm_power_one(entity, change);
-
-	if (!ret)
-		return ret;
-
-	media_entity_graph_walk_start(graph, first);
-
-	while ((first = media_entity_graph_walk_next(graph))
-	       && first != entity)
-		if (is_media_entity_v4l2_subdev(first))
-			isp_pipeline_pm_power_one(first, -change);
-
-	return ret;
-}
-
-/*
- * omap3isp_pipeline_pm_use - Update the use count of an entity
- * @entity: The entity
- * @use: Use (1) or stop using (0) the entity
- *
- * Update the use count of all entities in the pipeline and power entities on or
- * off accordingly.
- *
- * Return 0 on success or a negative error code on failure. Powering entities
- * off is assumed to never fail. No failure can occur when the use parameter is
- * set to 0.
- */
-int omap3isp_pipeline_pm_use(struct media_entity *entity, int use,
-			     struct media_entity_graph *graph)
-{
-	int change = use ? 1 : -1;
-	int ret;
-
-	mutex_lock(&entity->graph_obj.mdev->graph_mutex);
-
-	/* Apply use count to node. */
-	entity->use_count += change;
-	WARN_ON(entity->use_count < 0);
-
-	/* Apply power change to connected non-nodes. */
-	ret = isp_pipeline_pm_power(entity, change, graph);
-	if (ret < 0)
-		entity->use_count -= change;
-
-	mutex_unlock(&entity->graph_obj.mdev->graph_mutex);
-
-	return ret;
-}
-
-/*
- * isp_pipeline_link_notify - Link management notification callback
- * @link: The link
- * @flags: New link flags that will be applied
- * @notification: The link's state change notification type (MEDIA_DEV_NOTIFY_*)
- *
- * React to link management on powered pipelines by updating the use count of
- * all entities in the source and sink sides of the link. Entities are powered
- * on or off accordingly.
- *
- * Return 0 on success or a negative error code on failure. Powering entities
- * off is assumed to never fail. This function will not fail for disconnection
- * events.
- */
-static int isp_pipeline_link_notify(struct media_link *link, u32 flags,
-				    unsigned int notification)
-{
-	struct media_entity_graph *graph =
-		&container_of(link->graph_obj.mdev, struct isp_device,
-			      media_dev)->pm_count_graph;
-	struct media_entity *source = link->source->entity;
-	struct media_entity *sink = link->sink->entity;
-	int source_use;
-	int sink_use;
-	int ret = 0;
-
-	if (notification == MEDIA_DEV_NOTIFY_PRE_LINK_CH) {
-		ret = media_entity_graph_walk_init(graph,
-						   link->graph_obj.mdev);
-		if (ret)
-			return ret;
-	}
-
-	source_use = isp_pipeline_pm_use_count(source, graph);
-	sink_use = isp_pipeline_pm_use_count(sink, graph);
-
-	if (notification == MEDIA_DEV_NOTIFY_POST_LINK_CH &&
-	    !(flags & MEDIA_LNK_FL_ENABLED)) {
-		/* Powering off entities is assumed to never fail. */
-		isp_pipeline_pm_power(source, -sink_use, graph);
-		isp_pipeline_pm_power(sink, -source_use, graph);
-		return 0;
-	}
-
-	if (notification == MEDIA_DEV_NOTIFY_PRE_LINK_CH &&
-		(flags & MEDIA_LNK_FL_ENABLED)) {
-
-		ret = isp_pipeline_pm_power(source, sink_use, graph);
-		if (ret < 0)
-			return ret;
-
-		ret = isp_pipeline_pm_power(sink, source_use, graph);
-		if (ret < 0)
-			isp_pipeline_pm_power(source, -sink_use, graph);
-	}
-
-	if (notification == MEDIA_DEV_NOTIFY_POST_LINK_CH)
-		media_entity_graph_walk_cleanup(graph);
-
-	return ret;
-}
-
-/* -----------------------------------------------------------------------------
  * Pipeline stream management
  */
 
@@ -1889,7 +1680,7 @@ static int isp_register_entities(struct isp_device *isp)
 	strlcpy(isp->media_dev.model, "TI OMAP3 ISP",
 		sizeof(isp->media_dev.model));
 	isp->media_dev.hw_revision = isp->revision;
-	isp->media_dev.link_notify = isp_pipeline_link_notify;
+	isp->media_dev.link_notify = v4l2_pipeline_link_notify;
 	media_device_init(&isp->media_dev);
 
 	isp->v4l2_dev.mdev = &isp->media_dev;
diff --git a/drivers/media/platform/omap3isp/isp.h b/drivers/media/platform/omap3isp/isp.h
index 49b7f71..7e6f663 100644
--- a/drivers/media/platform/omap3isp/isp.h
+++ b/drivers/media/platform/omap3isp/isp.h
@@ -177,7 +177,6 @@ struct isp_device {
 	struct v4l2_device v4l2_dev;
 	struct v4l2_async_notifier notifier;
 	struct media_device media_dev;
-	struct media_entity_graph pm_count_graph;
 	struct device *dev;
 	u32 revision;
 
@@ -267,9 +266,6 @@ void omap3isp_subclk_enable(struct isp_device *isp,
 void omap3isp_subclk_disable(struct isp_device *isp,
 			     enum isp_subclk_resource res);
 
-int omap3isp_pipeline_pm_use(struct media_entity *entity, int use,
-			     struct media_entity_graph *graph);
-
 int omap3isp_register_entities(struct platform_device *pdev,
 			       struct v4l2_device *v4l2_dev);
 void omap3isp_unregister_entities(struct platform_device *pdev);
diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index 2aff755..ac76d29 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -22,8 +22,10 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
+
 #include <media/v4l2-dev.h>
 #include <media/v4l2-ioctl.h>
+#include <media/v4l2-mc.h>
 #include <media/videobuf2-dma-contig.h>
 
 #include "ispvideo.h"
@@ -1292,12 +1294,7 @@ static int isp_video_open(struct file *file)
 		goto done;
 	}
 
-	ret = media_entity_graph_walk_init(&handle->graph,
-					   &video->isp->media_dev);
-	if (ret)
-		goto done;
-
-	ret = omap3isp_pipeline_pm_use(&video->video.entity, 1, &handle->graph);
+	ret = v4l2_pipeline_pm_use(&video->video.entity, 1);
 	if (ret < 0) {
 		omap3isp_put(video->isp);
 		goto done;
@@ -1328,7 +1325,6 @@ static int isp_video_open(struct file *file)
 done:
 	if (ret < 0) {
 		v4l2_fh_del(&handle->vfh);
-		media_entity_graph_walk_cleanup(&handle->graph);
 		kfree(handle);
 	}
 
@@ -1348,8 +1344,7 @@ static int isp_video_release(struct file *file)
 	vb2_queue_release(&handle->queue);
 	mutex_unlock(&video->queue_lock);
 
-	omap3isp_pipeline_pm_use(&video->video.entity, 0, &handle->graph);
-	media_entity_graph_walk_cleanup(&handle->graph);
+	v4l2_pipeline_pm_use(&video->video.entity, 0);
 
 	/* Release the file handle. */
 	v4l2_fh_del(vfh);
diff --git a/drivers/media/platform/omap3isp/ispvideo.h b/drivers/media/platform/omap3isp/ispvideo.h
index 1564298..6a48d58 100644
--- a/drivers/media/platform/omap3isp/ispvideo.h
+++ b/drivers/media/platform/omap3isp/ispvideo.h
@@ -189,7 +189,6 @@ struct isp_video_fh {
 	struct vb2_queue queue;
 	struct v4l2_format format;
 	struct v4l2_fract timeperframe;
-	struct media_entity_graph graph;
 };
 
 #define to_isp_video_fh(fh)	container_of(fh, struct isp_video_fh, vfh)
-- 
2.1.4

