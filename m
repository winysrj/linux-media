Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55752 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932561AbcA0NvK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jan 2016 08:51:10 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH 5/5] staging: v4l: omap4iss: Use V4L2 graph PM operations
Date: Wed, 27 Jan 2016 15:50:58 +0200
Message-Id: <1453902658-29783-6-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1453902658-29783-1-git-send-email-sakari.ailus@iki.fi>
References: <1453902658-29783-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Power on devices represented by entities in the graph through the pipeline
state using V4L2 graph PM operations instead of what was in the omap3isp
driver.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/staging/media/omap4iss/iss.c       | 211 +----------------------------
 drivers/staging/media/omap4iss/iss.h       |   4 -
 drivers/staging/media/omap4iss/iss_video.c |  13 +-
 drivers/staging/media/omap4iss/iss_video.h |   1 -
 4 files changed, 3 insertions(+), 226 deletions(-)

diff --git a/drivers/staging/media/omap4iss/iss.c b/drivers/staging/media/omap4iss/iss.c
index 30b473c..fb80d2b 100644
--- a/drivers/staging/media/omap4iss/iss.c
+++ b/drivers/staging/media/omap4iss/iss.c
@@ -363,215 +363,6 @@ static irqreturn_t iss_isr(int irq, void *_iss)
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
- * The omap4iss_pipeline_pm_use() function must be called in the open() and
- * close() handlers of video device nodes. It increments or decrements the use
- * count of all subdev entities in the pipeline.
- *
- * To react to link management on powered pipelines, the link setup notification
- * callback updates the use count of all entities in the source and sink sides
- * of the link.
- */
-
-/*
- * iss_pipeline_pm_use_count - Count the number of users of a pipeline
- * @entity: The entity
- *
- * Return the total number of users of all video device nodes in the pipeline.
- */
-static int iss_pipeline_pm_use_count(struct media_entity *entity,
-				     struct media_entity_graph *graph)
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
- * iss_pipeline_pm_power_one - Apply power change to an entity
- * @entity: The entity
- * @change: Use count change
- *
- * Change the entity use count by @change. If the entity is a subdev update its
- * power state by calling the core::s_power operation when the use count goes
- * from 0 to != 0 or from != 0 to 0.
- *
- * Return 0 on success or a negative error code on failure.
- */
-static int iss_pipeline_pm_power_one(struct media_entity *entity, int change)
-{
-	struct v4l2_subdev *subdev;
-
-	subdev = is_media_entity_v4l2_subdev(entity)
-	       ? media_entity_to_v4l2_subdev(entity) : NULL;
-
-	if (entity->use_count == 0 && change > 0 && subdev) {
-		int ret;
-
-		ret = v4l2_subdev_call(subdev, core, s_power, 1);
-		if (ret < 0 && ret != -ENOIOCTLCMD)
-			return ret;
-	}
-
-	entity->use_count += change;
-	WARN_ON(entity->use_count < 0);
-
-	if (entity->use_count == 0 && change < 0 && subdev)
-		v4l2_subdev_call(subdev, core, s_power, 0);
-
-	return 0;
-}
-
-/*
- * iss_pipeline_pm_power - Apply power change to all entities in a pipeline
- * @entity: The entity
- * @change: Use count change
- *
- * Walk the pipeline to update the use count and the power state of all non-node
- * entities.
- *
- * Return 0 on success or a negative error code on failure.
- */
-static int iss_pipeline_pm_power(struct media_entity *entity, int change,
-				 struct media_entity_graph *graph)
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
-			ret = iss_pipeline_pm_power_one(entity, change);
-
-	if (!ret)
-		return 0;
-
-	media_entity_graph_walk_start(graph, first);
-
-	while ((first = media_entity_graph_walk_next(graph)) &&
-	       first != entity)
-		if (is_media_entity_v4l2_subdev(first))
-			iss_pipeline_pm_power_one(first, -change);
-
-	return ret;
-}
-
-/*
- * omap4iss_pipeline_pm_use - Update the use count of an entity
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
-int omap4iss_pipeline_pm_use(struct media_entity *entity, int use,
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
-	ret = iss_pipeline_pm_power(entity, change, graph);
-	if (ret < 0)
-		entity->use_count -= change;
-
-	mutex_unlock(&entity->graph_obj.mdev->graph_mutex);
-
-	return ret;
-}
-
-/*
- * iss_pipeline_link_notify - Link management notification callback
- * @link: The link
- * @flags: New link flags that will be applied
- *
- * React to link management on powered pipelines by updating the use count of
- * all entities in the source and sink sides of the link. Entities are powered
- * on or off accordingly.
- *
- * Return 0 on success or a negative error code on failure. Powering entities
- * off is assumed to never fail. This function will not fail for disconnection
- * events.
- */
-static int iss_pipeline_link_notify(struct media_link *link, u32 flags,
-				    unsigned int notification)
-{
-	struct media_entity_graph *graph =
-		&container_of(link->graph_obj.mdev, struct iss_device,
-			      media_dev)->pm_count_graph;
-	struct media_entity *source = link->source->entity;
-	struct media_entity *sink = link->sink->entity;
-	int source_use;
-	int sink_use;
-	int ret;
-
-	if (notification == MEDIA_DEV_NOTIFY_PRE_LINK_CH) {
-		ret = media_entity_graph_walk_init(graph,
-						   link->graph_obj.mdev);
-		if (ret)
-			return ret;
-	}
-
-	source_use = iss_pipeline_pm_use_count(source, graph);
-	sink_use = iss_pipeline_pm_use_count(sink, graph);
-
-	if (notification == MEDIA_DEV_NOTIFY_POST_LINK_CH &&
-	    !(flags & MEDIA_LNK_FL_ENABLED)) {
-		/* Powering off entities is assumed to never fail. */
-		iss_pipeline_pm_power(source, -sink_use, graph);
-		iss_pipeline_pm_power(sink, -source_use, graph);
-		return 0;
-	}
-
-	if (notification == MEDIA_DEV_NOTIFY_PRE_LINK_CH &&
-	    (flags & MEDIA_LNK_FL_ENABLED)) {
-		ret = iss_pipeline_pm_power(source, sink_use, graph);
-		if (ret < 0)
-			return ret;
-
-		ret = iss_pipeline_pm_power(sink, source_use, graph);
-		if (ret < 0)
-			iss_pipeline_pm_power(source, -sink_use, graph);
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
 
@@ -1197,7 +988,7 @@ static int iss_register_entities(struct iss_device *iss)
 	strlcpy(iss->media_dev.model, "TI OMAP4 ISS",
 		sizeof(iss->media_dev.model));
 	iss->media_dev.hw_revision = iss->revision;
-	iss->media_dev.link_notify = iss_pipeline_link_notify;
+	iss->media_dev.link_notify = v4l2_pipeline_link_notify;
 	ret = media_device_register(&iss->media_dev);
 	if (ret < 0) {
 		dev_err(iss->dev, "Media device registration failed (%d)\n",
diff --git a/drivers/staging/media/omap4iss/iss.h b/drivers/staging/media/omap4iss/iss.h
index 05f08a3..c58665a 100644
--- a/drivers/staging/media/omap4iss/iss.h
+++ b/drivers/staging/media/omap4iss/iss.h
@@ -87,7 +87,6 @@ struct iss_reg {
 struct iss_device {
 	struct v4l2_device v4l2_dev;
 	struct media_device media_dev;
-	struct media_entity_graph pm_count_graph;
 	struct device *dev;
 	u32 revision;
 
@@ -152,9 +151,6 @@ void omap4iss_isp_subclk_enable(struct iss_device *iss,
 void omap4iss_isp_subclk_disable(struct iss_device *iss,
 				 enum iss_isp_subclk_resource res);
 
-int omap4iss_pipeline_pm_use(struct media_entity *entity, int use,
-			     struct media_entity_graph *graph);
-
 int omap4iss_register_entities(struct platform_device *pdev,
 			       struct v4l2_device *v4l2_dev);
 void omap4iss_unregister_entities(struct platform_device *pdev);
diff --git a/drivers/staging/media/omap4iss/iss_video.c b/drivers/staging/media/omap4iss/iss_video.c
index 058233a..ec47b04 100644
--- a/drivers/staging/media/omap4iss/iss_video.c
+++ b/drivers/staging/media/omap4iss/iss_video.c
@@ -1009,13 +1009,7 @@ static int iss_video_open(struct file *file)
 		goto done;
 	}
 
-	ret = media_entity_graph_walk_init(&handle->graph,
-					   &video->iss->media_dev);
-	if (ret)
-		goto done;
-
-	ret = omap4iss_pipeline_pm_use(&video->video.entity, 1,
-				       &handle->graph);
+	ret = v4l2_pipeline_pm_use(&video->video.entity, 1);
 	if (ret < 0) {
 		omap4iss_put(video->iss);
 		goto done;
@@ -1054,7 +1048,6 @@ static int iss_video_open(struct file *file)
 done:
 	if (ret < 0) {
 		v4l2_fh_del(&handle->vfh);
-		media_entity_graph_walk_cleanup(&handle->graph);
 		kfree(handle);
 	}
 
@@ -1070,13 +1063,11 @@ static int iss_video_release(struct file *file)
 	/* Disable streaming and free the buffers queue resources. */
 	iss_video_streamoff(file, vfh, video->type);
 
-	omap4iss_pipeline_pm_use(&video->video.entity, 0, &handle->graph);
+	v4l2_pipeline_pm_use(&video->video.entity, 0);
 
 	/* Release the videobuf2 queue */
 	vb2_queue_release(&handle->queue);
 
-	/* Release the file handle. */
-	media_entity_graph_walk_cleanup(&handle->graph);
 	v4l2_fh_del(vfh);
 	kfree(handle);
 	file->private_data = NULL;
diff --git a/drivers/staging/media/omap4iss/iss_video.h b/drivers/staging/media/omap4iss/iss_video.h
index 34588b7..c8bd295 100644
--- a/drivers/staging/media/omap4iss/iss_video.h
+++ b/drivers/staging/media/omap4iss/iss_video.h
@@ -183,7 +183,6 @@ struct iss_video_fh {
 	struct vb2_queue queue;
 	struct v4l2_format format;
 	struct v4l2_fract timeperframe;
-	struct media_entity_graph graph;
 };
 
 #define to_iss_video_fh(fh)	container_of(fh, struct iss_video_fh, vfh)
-- 
2.1.4

