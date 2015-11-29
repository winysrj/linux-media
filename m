Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39770 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752413AbbK2TWo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Nov 2015 14:22:44 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, mchehab@osg.samsung.com,
	hverkuil@xs4all.nl, javier@osg.samsung.com
Subject: [PATCH v2 09/22] v4l: omap3isp: Use the new media_entity_graph_walk_start() interface
Date: Sun, 29 Nov 2015 21:20:10 +0200
Message-Id: <1448824823-10372-10-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1448824823-10372-1-git-send-email-sakari.ailus@iki.fi>
References: <1448824823-10372-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/platform/omap3isp/isp.c      | 63 ++++++++++++++++++------------
 drivers/media/platform/omap3isp/isp.h      |  4 +-
 drivers/media/platform/omap3isp/ispvideo.c | 19 ++++++++-
 drivers/media/platform/omap3isp/ispvideo.h |  1 +
 4 files changed, 60 insertions(+), 27 deletions(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 0d1249f..4a01a36 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -683,14 +683,14 @@ static irqreturn_t isp_isr(int irq, void *_isp)
  *
  * Return the total number of users of all video device nodes in the pipeline.
  */
-static int isp_pipeline_pm_use_count(struct media_entity *entity)
+static int isp_pipeline_pm_use_count(struct media_entity *entity,
+	struct media_entity_graph *graph)
 {
-	struct media_entity_graph graph;
 	int use = 0;
 
-	media_entity_graph_walk_start(&graph, entity);
+	media_entity_graph_walk_start(graph, entity);
 
-	while ((entity = media_entity_graph_walk_next(&graph))) {
+	while ((entity = media_entity_graph_walk_next(graph))) {
 		if (is_media_entity_v4l2_io(entity))
 			use += entity->use_count;
 	}
@@ -742,27 +742,27 @@ static int isp_pipeline_pm_power_one(struct media_entity *entity, int change)
  *
  * Return 0 on success or a negative error code on failure.
  */
-static int isp_pipeline_pm_power(struct media_entity *entity, int change)
+static int isp_pipeline_pm_power(struct media_entity *entity, int change,
+	struct media_entity_graph *graph)
 {
-	struct media_entity_graph graph;
 	struct media_entity *first = entity;
 	int ret = 0;
 
 	if (!change)
 		return 0;
 
-	media_entity_graph_walk_start(&graph, entity);
+	media_entity_graph_walk_start(graph, entity);
 
-	while (!ret && (entity = media_entity_graph_walk_next(&graph)))
+	while (!ret && (entity = media_entity_graph_walk_next(graph)))
 		if (is_media_entity_v4l2_subdev(entity))
 			ret = isp_pipeline_pm_power_one(entity, change);
 
 	if (!ret)
-		return 0;
+		return ret;
 
-	media_entity_graph_walk_start(&graph, first);
+	media_entity_graph_walk_start(graph, first);
 
-	while ((first = media_entity_graph_walk_next(&graph))
+	while ((first = media_entity_graph_walk_next(graph))
 	       && first != entity)
 		if (is_media_entity_v4l2_subdev(first))
 			isp_pipeline_pm_power_one(first, -change);
@@ -782,7 +782,8 @@ static int isp_pipeline_pm_power(struct media_entity *entity, int change)
  * off is assumed to never fail. No failure can occur when the use parameter is
  * set to 0.
  */
-int omap3isp_pipeline_pm_use(struct media_entity *entity, int use)
+int omap3isp_pipeline_pm_use(struct media_entity *entity, int use,
+			     struct media_entity_graph *graph)
 {
 	int change = use ? 1 : -1;
 	int ret;
@@ -794,7 +795,7 @@ int omap3isp_pipeline_pm_use(struct media_entity *entity, int use)
 	WARN_ON(entity->use_count < 0);
 
 	/* Apply power change to connected non-nodes. */
-	ret = isp_pipeline_pm_power(entity, change);
+	ret = isp_pipeline_pm_power(entity, change, graph);
 	if (ret < 0)
 		entity->use_count -= change;
 
@@ -820,35 +821,49 @@ int omap3isp_pipeline_pm_use(struct media_entity *entity, int use)
 static int isp_pipeline_link_notify(struct media_link *link, u32 flags,
 				    unsigned int notification)
 {
+	struct media_entity_graph *graph =
+		&container_of(link->graph_obj.mdev, struct isp_device,
+			      media_dev)->pm_count_graph;
 	struct media_entity *source = link->source->entity;
 	struct media_entity *sink = link->sink->entity;
-	int source_use = isp_pipeline_pm_use_count(source);
-	int sink_use = isp_pipeline_pm_use_count(sink);
-	int ret;
+	int source_use;
+	int sink_use;
+	int ret = 0;
+
+	if (notification == MEDIA_DEV_NOTIFY_PRE_LINK_CH) {
+		ret = media_entity_graph_walk_init(graph,
+						   link->graph_obj.mdev);
+		if (ret)
+			return ret;
+	}
+
+	source_use = isp_pipeline_pm_use_count(source, graph);
+	sink_use = isp_pipeline_pm_use_count(sink, graph);
 
 	if (notification == MEDIA_DEV_NOTIFY_POST_LINK_CH &&
 	    !(flags & MEDIA_LNK_FL_ENABLED)) {
 		/* Powering off entities is assumed to never fail. */
-		isp_pipeline_pm_power(source, -sink_use);
-		isp_pipeline_pm_power(sink, -source_use);
+		isp_pipeline_pm_power(source, -sink_use, graph);
+		isp_pipeline_pm_power(sink, -source_use, graph);
 		return 0;
 	}
 
 	if (notification == MEDIA_DEV_NOTIFY_PRE_LINK_CH &&
 		(flags & MEDIA_LNK_FL_ENABLED)) {
 
-		ret = isp_pipeline_pm_power(source, sink_use);
+		ret = isp_pipeline_pm_power(source, sink_use, graph);
 		if (ret < 0)
 			return ret;
 
-		ret = isp_pipeline_pm_power(sink, source_use);
+		ret = isp_pipeline_pm_power(sink, source_use, graph);
 		if (ret < 0)
-			isp_pipeline_pm_power(source, -sink_use);
-
-		return ret;
+			isp_pipeline_pm_power(source, -sink_use, graph);
 	}
 
-	return 0;
+	if (notification == MEDIA_DEV_NOTIFY_POST_LINK_CH)
+		media_entity_graph_walk_cleanup(graph);
+
+	return ret;
 }
 
 /* -----------------------------------------------------------------------------
diff --git a/drivers/media/platform/omap3isp/isp.h b/drivers/media/platform/omap3isp/isp.h
index 5acc2e6..b6f81f2 100644
--- a/drivers/media/platform/omap3isp/isp.h
+++ b/drivers/media/platform/omap3isp/isp.h
@@ -176,6 +176,7 @@ struct isp_device {
 	struct v4l2_device v4l2_dev;
 	struct v4l2_async_notifier notifier;
 	struct media_device media_dev;
+	struct media_entity_graph pm_count_graph;
 	struct device *dev;
 	u32 revision;
 
@@ -265,7 +266,8 @@ void omap3isp_subclk_enable(struct isp_device *isp,
 void omap3isp_subclk_disable(struct isp_device *isp,
 			     enum isp_subclk_resource res);
 
-int omap3isp_pipeline_pm_use(struct media_entity *entity, int use);
+int omap3isp_pipeline_pm_use(struct media_entity *entity, int use,
+			     struct media_entity_graph *graph);
 
 int omap3isp_register_entities(struct platform_device *pdev,
 			       struct v4l2_device *v4l2_dev);
diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index 52843ac..e68ec2f 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -227,8 +227,15 @@ static int isp_video_get_graph_data(struct isp_video *video,
 	struct media_entity *entity = &video->video.entity;
 	struct media_device *mdev = entity->graph_obj.mdev;
 	struct isp_video *far_end = NULL;
+	int ret;
 
 	mutex_lock(&mdev->graph_mutex);
+	ret = media_entity_graph_walk_init(&graph, entity->graph_obj.mdev);
+	if (ret) {
+		mutex_unlock(&mdev->graph_mutex);
+		return ret;
+	}
+
 	media_entity_graph_walk_start(&graph, entity);
 
 	while ((entity = media_entity_graph_walk_next(&graph))) {
@@ -252,6 +259,8 @@ static int isp_video_get_graph_data(struct isp_video *video,
 
 	mutex_unlock(&mdev->graph_mutex);
 
+	media_entity_graph_walk_cleanup(&graph);
+
 	if (video->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
 		pipe->input = far_end;
 		pipe->output = video;
@@ -1242,7 +1251,12 @@ static int isp_video_open(struct file *file)
 		goto done;
 	}
 
-	ret = omap3isp_pipeline_pm_use(&video->video.entity, 1);
+	ret = media_entity_graph_walk_init(&handle->graph,
+					   &video->isp->media_dev);
+	if (ret)
+		goto done;
+
+	ret = omap3isp_pipeline_pm_use(&video->video.entity, 1, &handle->graph);
 	if (ret < 0) {
 		omap3isp_put(video->isp);
 		goto done;
@@ -1273,6 +1287,7 @@ static int isp_video_open(struct file *file)
 done:
 	if (ret < 0) {
 		v4l2_fh_del(&handle->vfh);
+		media_entity_graph_walk_cleanup(&handle->graph);
 		kfree(handle);
 	}
 
@@ -1292,7 +1307,7 @@ static int isp_video_release(struct file *file)
 	vb2_queue_release(&handle->queue);
 	mutex_unlock(&video->queue_lock);
 
-	omap3isp_pipeline_pm_use(&video->video.entity, 0);
+	omap3isp_pipeline_pm_use(&video->video.entity, 0, &handle->graph);
 
 	/* Release the file handle. */
 	v4l2_fh_del(vfh);
diff --git a/drivers/media/platform/omap3isp/ispvideo.h b/drivers/media/platform/omap3isp/ispvideo.h
index 4071dd7..6c498ea 100644
--- a/drivers/media/platform/omap3isp/ispvideo.h
+++ b/drivers/media/platform/omap3isp/ispvideo.h
@@ -189,6 +189,7 @@ struct isp_video_fh {
 	struct vb2_queue queue;
 	struct v4l2_format format;
 	struct v4l2_fract timeperframe;
+	struct media_entity_graph graph;
 };
 
 #define to_isp_video_fh(fh)	container_of(fh, struct isp_video_fh, vfh)
-- 
2.1.4

