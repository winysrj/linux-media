Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60601 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932907AbbLPNew (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Dec 2015 08:34:52 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, mchehab@osg.samsung.com,
	hverkuil@xs4all.nl, javier@osg.samsung.com,
	Prabhakar Lad <prabhakar.lad@ti.com>
Subject: [PATCH v3 20/23] staging: v4l: davinci_vpbe: Use the new media graph walk interface
Date: Wed, 16 Dec 2015 15:32:35 +0200
Message-Id: <1450272758-29446-21-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1450272758-29446-1-git-send-email-sakari.ailus@iki.fi>
References: <1450272758-29446-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The media graph walk requires initialisation and cleanup soon. Update the
users to perform the soon necessary API calls.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Prabhakar Lad <prabhakar.lad@ti.com>
---
 drivers/staging/media/davinci_vpfe/vpfe_video.c | 37 ++++++++++++++++++-------
 drivers/staging/media/davinci_vpfe/vpfe_video.h |  1 +
 2 files changed, 28 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.c b/drivers/staging/media/davinci_vpfe/vpfe_video.c
index 2dbf14b..1bacd19 100644
--- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
+++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
@@ -127,13 +127,14 @@ __vpfe_video_get_format(struct vpfe_video_device *video,
 }
 
 /* make a note of pipeline details */
-static void vpfe_prepare_pipeline(struct vpfe_video_device *video)
+static int vpfe_prepare_pipeline(struct vpfe_video_device *video)
 {
+	struct media_entity_graph graph;
 	struct media_entity *entity = &video->video_dev.entity;
 	struct media_device *mdev = entity->graph_obj.mdev;
 	struct vpfe_pipeline *pipe = &video->pipe;
 	struct vpfe_video_device *far_end = NULL;
-	struct media_entity_graph graph;
+	int ret;
 
 	pipe->input_num = 0;
 	pipe->output_num = 0;
@@ -144,6 +145,11 @@ static void vpfe_prepare_pipeline(struct vpfe_video_device *video)
 		pipe->outputs[pipe->output_num++] = video;
 
 	mutex_lock(&mdev->graph_mutex);
+	ret = media_entity_graph_walk_init(&graph, entity->graph_obj.mdev);
+	if (ret) {
+		mutex_unlock(&video->lock);
+		return -ENOMEM;
+	}
 	media_entity_graph_walk_start(&graph, entity);
 	while ((entity = media_entity_graph_walk_next(&graph))) {
 		if (entity == &video->video_dev.entity)
@@ -156,7 +162,10 @@ static void vpfe_prepare_pipeline(struct vpfe_video_device *video)
 		else
 			pipe->outputs[pipe->output_num++] = far_end;
 	}
+	media_entity_graph_walk_cleanup(&graph);
 	mutex_unlock(&mdev->graph_mutex);
+
+	return 0;
 }
 
 /* update pipe state selected by user */
@@ -165,7 +174,9 @@ static int vpfe_update_pipe_state(struct vpfe_video_device *video)
 	struct vpfe_pipeline *pipe = &video->pipe;
 	int ret;
 
-	vpfe_prepare_pipeline(video);
+	ret = vpfe_prepare_pipeline(video);
+	if (ret)
+		return ret;
 
 	/* Find out if there is any input video
 	  if yes, it is single shot.
@@ -276,11 +287,10 @@ static int vpfe_video_validate_pipeline(struct vpfe_pipeline *pipe)
  */
 static int vpfe_pipeline_enable(struct vpfe_pipeline *pipe)
 {
-	struct media_entity_graph graph;
 	struct media_entity *entity;
 	struct v4l2_subdev *subdev;
 	struct media_device *mdev;
-	int ret = 0;
+	int ret;
 
 	if (pipe->state == VPFE_PIPELINE_STREAM_CONTINUOUS)
 		entity = vpfe_get_input_entity(pipe->outputs[0]);
@@ -289,8 +299,12 @@ static int vpfe_pipeline_enable(struct vpfe_pipeline *pipe)
 
 	mdev = entity->graph_obj.mdev;
 	mutex_lock(&mdev->graph_mutex);
-	media_entity_graph_walk_start(&graph, entity);
-	while ((entity = media_entity_graph_walk_next(&graph))) {
+	ret = media_entity_graph_walk_init(&pipe->graph,
+					   entity->graph_obj.mdev);
+	if (ret)
+		goto out;
+	media_entity_graph_walk_start(&pipe->graph, entity);
+	while ((entity = media_entity_graph_walk_next(&pipe->graph))) {
 
 		if (!is_media_entity_v4l2_subdev(entity))
 			continue;
@@ -299,6 +313,9 @@ static int vpfe_pipeline_enable(struct vpfe_pipeline *pipe)
 		if (ret < 0 && ret != -ENOIOCTLCMD)
 			break;
 	}
+out:
+	if (ret)
+		media_entity_graph_walk_cleanup(&pipe->graph);
 	mutex_unlock(&mdev->graph_mutex);
 	return ret;
 }
@@ -316,7 +333,6 @@ static int vpfe_pipeline_enable(struct vpfe_pipeline *pipe)
  */
 static int vpfe_pipeline_disable(struct vpfe_pipeline *pipe)
 {
-	struct media_entity_graph graph;
 	struct media_entity *entity;
 	struct v4l2_subdev *subdev;
 	struct media_device *mdev;
@@ -329,9 +345,9 @@ static int vpfe_pipeline_disable(struct vpfe_pipeline *pipe)
 
 	mdev = entity->graph_obj.mdev;
 	mutex_lock(&mdev->graph_mutex);
-	media_entity_graph_walk_start(&graph, entity);
+	media_entity_graph_walk_start(&pipe->graph, entity);
 
-	while ((entity = media_entity_graph_walk_next(&graph))) {
+	while ((entity = media_entity_graph_walk_next(&pipe->graph))) {
 
 		if (!is_media_entity_v4l2_subdev(entity))
 			continue;
@@ -342,6 +358,7 @@ static int vpfe_pipeline_disable(struct vpfe_pipeline *pipe)
 	}
 	mutex_unlock(&mdev->graph_mutex);
 
+	media_entity_graph_walk_cleanup(&pipe->graph);
 	return ret ? -ETIMEDOUT : 0;
 }
 
diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.h b/drivers/staging/media/davinci_vpfe/vpfe_video.h
index 1b1b6c4..81f7698 100644
--- a/drivers/staging/media/davinci_vpfe/vpfe_video.h
+++ b/drivers/staging/media/davinci_vpfe/vpfe_video.h
@@ -51,6 +51,7 @@ enum vpfe_video_state {
 struct vpfe_pipeline {
 	/* media pipeline */
 	struct media_pipeline		*pipe;
+	struct media_entity_graph	graph;
 	/* state of the pipeline, continuous,
 	 * single-shot or stopped
 	 */
-- 
2.1.4

