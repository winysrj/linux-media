Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60602 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932695AbbLPNev (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Dec 2015 08:34:51 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, mchehab@osg.samsung.com,
	hverkuil@xs4all.nl, javier@osg.samsung.com
Subject: [PATCH v3 19/23] staging: v4l: omap4iss: Use the new media graph walk interface
Date: Wed, 16 Dec 2015 15:32:34 +0200
Message-Id: <1450272758-29446-20-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1450272758-29446-1-git-send-email-sakari.ailus@iki.fi>
References: <1450272758-29446-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The media graph walk requires initialisation and cleanup soon. Update the
users to perform the soon necessary API calls.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/staging/media/omap4iss/iss.c       | 59 +++++++++++++++++++-----------
 drivers/staging/media/omap4iss/iss.h       |  4 +-
 drivers/staging/media/omap4iss/iss_video.c | 33 +++++++++++++++--
 drivers/staging/media/omap4iss/iss_video.h |  1 +
 4 files changed, 70 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/media/omap4iss/iss.c b/drivers/staging/media/omap4iss/iss.c
index 6738d01..d7eadc8 100644
--- a/drivers/staging/media/omap4iss/iss.c
+++ b/drivers/staging/media/omap4iss/iss.c
@@ -389,14 +389,14 @@ static irqreturn_t iss_isr(int irq, void *_iss)
  *
  * Return the total number of users of all video device nodes in the pipeline.
  */
-static int iss_pipeline_pm_use_count(struct media_entity *entity)
+static int iss_pipeline_pm_use_count(struct media_entity *entity,
+				     struct media_entity_graph *graph)
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
@@ -449,27 +449,27 @@ static int iss_pipeline_pm_power_one(struct media_entity *entity, int change)
  *
  * Return 0 on success or a negative error code on failure.
  */
-static int iss_pipeline_pm_power(struct media_entity *entity, int change)
+static int iss_pipeline_pm_power(struct media_entity *entity, int change,
+				 struct media_entity_graph *graph)
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
 			ret = iss_pipeline_pm_power_one(entity, change);
 
 	if (!ret)
 		return 0;
 
-	media_entity_graph_walk_start(&graph, first);
+	media_entity_graph_walk_start(graph, first);
 
-	while ((first = media_entity_graph_walk_next(&graph))
+	while ((first = media_entity_graph_walk_next(graph))
 	       && first != entity)
 		if (is_media_entity_v4l2_subdev(first))
 			iss_pipeline_pm_power_one(first, -change);
@@ -489,7 +489,8 @@ static int iss_pipeline_pm_power(struct media_entity *entity, int change)
  * off is assumed to never fail. No failure can occur when the use parameter is
  * set to 0.
  */
-int omap4iss_pipeline_pm_use(struct media_entity *entity, int use)
+int omap4iss_pipeline_pm_use(struct media_entity *entity, int use,
+			     struct media_entity_graph *graph)
 {
 	int change = use ? 1 : -1;
 	int ret;
@@ -501,7 +502,7 @@ int omap4iss_pipeline_pm_use(struct media_entity *entity, int use)
 	WARN_ON(entity->use_count < 0);
 
 	/* Apply power change to connected non-nodes. */
-	ret = iss_pipeline_pm_power(entity, change);
+	ret = iss_pipeline_pm_power(entity, change, graph);
 	if (ret < 0)
 		entity->use_count -= change;
 
@@ -526,34 +527,48 @@ int omap4iss_pipeline_pm_use(struct media_entity *entity, int use)
 static int iss_pipeline_link_notify(struct media_link *link, u32 flags,
 				    unsigned int notification)
 {
+	struct media_entity_graph *graph =
+		&container_of(link->graph_obj.mdev, struct iss_device,
+			      media_dev)->pm_count_graph;
 	struct media_entity *source = link->source->entity;
 	struct media_entity *sink = link->sink->entity;
-	int source_use = iss_pipeline_pm_use_count(source);
-	int sink_use = iss_pipeline_pm_use_count(sink);
+	int source_use;
+	int sink_use;
 	int ret;
 
+	if (notification == MEDIA_DEV_NOTIFY_PRE_LINK_CH) {
+		ret = media_entity_graph_walk_init(graph,
+						   link->graph_obj.mdev);
+		if (ret)
+			return ret;
+	}
+
+	source_use = iss_pipeline_pm_use_count(source, graph);
+	sink_use = iss_pipeline_pm_use_count(sink, graph);
+
 	if (notification == MEDIA_DEV_NOTIFY_POST_LINK_CH &&
 	    !(flags & MEDIA_LNK_FL_ENABLED)) {
 		/* Powering off entities is assumed to never fail. */
-		iss_pipeline_pm_power(source, -sink_use);
-		iss_pipeline_pm_power(sink, -source_use);
+		iss_pipeline_pm_power(source, -sink_use, graph);
+		iss_pipeline_pm_power(sink, -source_use, graph);
 		return 0;
 	}
 
 	if (notification == MEDIA_DEV_NOTIFY_PRE_LINK_CH &&
 		(flags & MEDIA_LNK_FL_ENABLED)) {
-		ret = iss_pipeline_pm_power(source, sink_use);
+		ret = iss_pipeline_pm_power(source, sink_use, graph);
 		if (ret < 0)
 			return ret;
 
-		ret = iss_pipeline_pm_power(sink, source_use);
+		ret = iss_pipeline_pm_power(sink, source_use, graph);
 		if (ret < 0)
-			iss_pipeline_pm_power(source, -sink_use);
-
-		return ret;
+			iss_pipeline_pm_power(source, -sink_use, graph);
 	}
 
-	return 0;
+	if (notification == MEDIA_DEV_NOTIFY_POST_LINK_CH)
+		media_entity_graph_walk_cleanup(graph);
+
+	return ret;
 }
 
 /* -----------------------------------------------------------------------------
diff --git a/drivers/staging/media/omap4iss/iss.h b/drivers/staging/media/omap4iss/iss.h
index 5dd0d99..ee7dc08 100644
--- a/drivers/staging/media/omap4iss/iss.h
+++ b/drivers/staging/media/omap4iss/iss.h
@@ -87,6 +87,7 @@ struct iss_reg {
 struct iss_device {
 	struct v4l2_device v4l2_dev;
 	struct media_device media_dev;
+	struct media_entity_graph pm_count_graph;
 	struct device *dev;
 	u32 revision;
 
@@ -151,7 +152,8 @@ void omap4iss_isp_subclk_enable(struct iss_device *iss,
 void omap4iss_isp_subclk_disable(struct iss_device *iss,
 				 enum iss_isp_subclk_resource res);
 
-int omap4iss_pipeline_pm_use(struct media_entity *entity, int use);
+int omap4iss_pipeline_pm_use(struct media_entity *entity, int use,
+			     struct media_entity_graph *graph);
 
 int omap4iss_register_entities(struct platform_device *pdev,
 			       struct v4l2_device *v4l2_dev);
diff --git a/drivers/staging/media/omap4iss/iss_video.c b/drivers/staging/media/omap4iss/iss_video.c
index 4fd5fc8..450578b 100644
--- a/drivers/staging/media/omap4iss/iss_video.c
+++ b/drivers/staging/media/omap4iss/iss_video.c
@@ -210,6 +210,12 @@ iss_video_far_end(struct iss_video *video)
 	struct iss_video *far_end = NULL;
 
 	mutex_lock(&mdev->graph_mutex);
+
+	if (media_entity_graph_walk_init(&graph, mdev)) {
+		mutex_unlock(&mdev->graph_mutex);
+		return NULL;
+	}
+
 	media_entity_graph_walk_start(&graph, entity);
 
 	while ((entity = media_entity_graph_walk_next(&graph))) {
@@ -227,6 +233,9 @@ iss_video_far_end(struct iss_video *video)
 	}
 
 	mutex_unlock(&mdev->graph_mutex);
+
+	media_entity_graph_walk_cleanup(&graph);
+
 	return far_end;
 }
 
@@ -774,7 +783,11 @@ iss_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 
 	ret = media_entity_enum_init(&pipe->ent_enum, entity->graph_obj.mdev);
 	if (ret)
-		goto err_enum_init;
+		goto err_graph_walk_init;
+
+	ret = media_entity_graph_walk_init(&graph, entity->graph_obj.mdev);
+	if (ret)
+		goto err_graph_walk_init;
 
 	if (video->iss->pdata->set_constraints)
 		video->iss->pdata->set_constraints(video->iss, true);
@@ -855,6 +868,8 @@ iss_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 		spin_unlock_irqrestore(&video->qlock, flags);
 	}
 
+	media_entity_graph_walk_cleanup(&graph);
+
 	mutex_unlock(&video->stream_lock);
 
 	return 0;
@@ -868,9 +883,11 @@ err_media_entity_pipeline_start:
 		video->iss->pdata->set_constraints(video->iss, false);
 	video->queue = NULL;
 
+	media_entity_graph_walk_cleanup(&graph);
+
+err_graph_walk_init:
 	media_entity_enum_cleanup(&pipe->ent_enum);
 
-err_enum_init:
 	mutex_unlock(&video->stream_lock);
 
 	return ret;
@@ -994,7 +1011,13 @@ static int iss_video_open(struct file *file)
 		goto done;
 	}
 
-	ret = omap4iss_pipeline_pm_use(&video->video.entity, 1);
+	ret = media_entity_graph_walk_init(&handle->graph,
+					   &video->iss->media_dev);
+	if (ret)
+		goto done;
+
+	ret = omap4iss_pipeline_pm_use(&video->video.entity, 1,
+				       &handle->graph);
 	if (ret < 0) {
 		omap4iss_put(video->iss);
 		goto done;
@@ -1033,6 +1056,7 @@ static int iss_video_open(struct file *file)
 done:
 	if (ret < 0) {
 		v4l2_fh_del(&handle->vfh);
+		media_entity_graph_walk_cleanup(&handle->graph);
 		kfree(handle);
 	}
 
@@ -1048,12 +1072,13 @@ static int iss_video_release(struct file *file)
 	/* Disable streaming and free the buffers queue resources. */
 	iss_video_streamoff(file, vfh, video->type);
 
-	omap4iss_pipeline_pm_use(&video->video.entity, 0);
+	omap4iss_pipeline_pm_use(&video->video.entity, 0, &handle->graph);
 
 	/* Release the videobuf2 queue */
 	vb2_queue_release(&handle->queue);
 
 	/* Release the file handle. */
+	media_entity_graph_walk_cleanup(&handle->graph);
 	v4l2_fh_del(vfh);
 	kfree(handle);
 	file->private_data = NULL;
diff --git a/drivers/staging/media/omap4iss/iss_video.h b/drivers/staging/media/omap4iss/iss_video.h
index d16bc45..94764ea 100644
--- a/drivers/staging/media/omap4iss/iss_video.h
+++ b/drivers/staging/media/omap4iss/iss_video.h
@@ -183,6 +183,7 @@ struct iss_video_fh {
 	struct vb2_queue queue;
 	struct v4l2_format format;
 	struct v4l2_fract timeperframe;
+	struct media_entity_graph graph;
 };
 
 #define to_iss_video_fh(fh)	container_of(fh, struct iss_video_fh, vfh)
-- 
2.1.4

