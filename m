Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.26]:42564 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030188Ab2CIUbv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 9 Mar 2012 15:31:51 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	teturtia@gmail.com, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@gmail.com, riverful@gmail.com,
	pradeep.sawlani@gmail.com
Subject: [PATCH v5.3 25/35] omap3isp: Collect entities that are part of the pipeline
Date: Fri,  9 Mar 2012 22:31:25 +0200
Message-Id: <1331325085-28462-1-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1912567.UNqMTnFDpO@avalon>
References: <1912567.UNqMTnFDpO@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Collect entities which are part of the pipeline into a single bit mask.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
since last version:

- state is set in isp_video_streamon() rather than
  isp_video_get_graph_data().
- Get information from all entities which was broken by the previous
  version.

 drivers/media/video/omap3isp/ispvideo.c |   57 +++++++++++++++++-------------
 drivers/media/video/omap3isp/ispvideo.h |    2 +
 2 files changed, 34 insertions(+), 25 deletions(-)

diff --git a/drivers/media/video/omap3isp/ispvideo.c b/drivers/media/video/omap3isp/ispvideo.c
index d34f690..d8a5250 100644
--- a/drivers/media/video/omap3isp/ispvideo.c
+++ b/drivers/media/video/omap3isp/ispvideo.c
@@ -255,8 +255,8 @@ isp_video_remote_subdev(struct isp_video *video, u32 *pad)
 }
 
 /* Return a pointer to the ISP video instance at the far end of the pipeline. */
-static struct isp_video *
-isp_video_far_end(struct isp_video *video)
+static int isp_video_get_graph_data(struct isp_video *video,
+				    struct isp_pipeline *pipe)
 {
 	struct media_entity_graph graph;
 	struct media_entity *entity = &video->video.entity;
@@ -267,21 +267,38 @@ isp_video_far_end(struct isp_video *video)
 	media_entity_graph_walk_start(&graph, entity);
 
 	while ((entity = media_entity_graph_walk_next(&graph))) {
+		struct isp_video *__video;
+
+		pipe->entities |= 1 << entity->id;
+
+		if (far_end != NULL)
+			continue;
+
 		if (entity == &video->video.entity)
 			continue;
 
 		if (media_entity_type(entity) != MEDIA_ENT_T_DEVNODE)
 			continue;
 
-		far_end = to_isp_video(media_entity_to_video_device(entity));
-		if (far_end->type != video->type)
-			break;
-
-		far_end = NULL;
+		__video = to_isp_video(media_entity_to_video_device(entity));
+		if (__video->type != video->type)
+			far_end = __video;
 	}
 
 	mutex_unlock(&mdev->graph_mutex);
-	return far_end;
+
+	if (video->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
+		pipe->input = far_end;
+		pipe->output = video;
+	} else {
+		if (far_end == NULL)
+			return -EPIPE;
+
+		pipe->input = video;
+		pipe->output = far_end;
+	}
+
+	return 0;
 }
 
 /*
@@ -972,7 +989,6 @@ isp_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 	struct isp_video *video = video_drvdata(file);
 	enum isp_pipeline_state state;
 	struct isp_pipeline *pipe;
-	struct isp_video *far_end;
 	unsigned long flags;
 	int ret;
 
@@ -992,6 +1008,8 @@ isp_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 	pipe = video->video.entity.pipe
 	     ? to_isp_pipeline(&video->video.entity) : &video->pipe;
 
+	pipe->entities = 0;
+
 	if (video->isp->pdata->set_constraints)
 		video->isp->pdata->set_constraints(video->isp, true);
 	pipe->l3_ick = clk_get_rate(video->isp->clock[ISP_CLK_L3_ICK]);
@@ -1011,25 +1029,14 @@ isp_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 	video->bpl_padding = ret;
 	video->bpl_value = vfh->format.fmt.pix.bytesperline;
 
-	/* Find the ISP video node connected at the far end of the pipeline and
-	 * update the pipeline.
-	 */
-	far_end = isp_video_far_end(video);
+	ret = isp_video_get_graph_data(video, pipe);
+	if (ret < 0)
+		goto err_check_format;
 
-	if (video->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
+	if (video->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		state = ISP_PIPELINE_STREAM_OUTPUT | ISP_PIPELINE_IDLE_OUTPUT;
-		pipe->input = far_end;
-		pipe->output = video;
-	} else {
-		if (far_end == NULL) {
-			ret = -EPIPE;
-			goto err_check_format;
-		}
-
+	else
 		state = ISP_PIPELINE_STREAM_INPUT | ISP_PIPELINE_IDLE_INPUT;
-		pipe->input = video;
-		pipe->output = far_end;
-	}
 
 	/* Validate the pipeline and update its state. */
 	ret = isp_video_validate_pipeline(pipe);
diff --git a/drivers/media/video/omap3isp/ispvideo.h b/drivers/media/video/omap3isp/ispvideo.h
index d91bdb9..c9187cb 100644
--- a/drivers/media/video/omap3isp/ispvideo.h
+++ b/drivers/media/video/omap3isp/ispvideo.h
@@ -88,6 +88,7 @@ enum isp_pipeline_state {
 /*
  * struct isp_pipeline - An ISP hardware pipeline
  * @error: A hardware error occurred during capture
+ * @entities: Bitmask of entities in the pipeline (indexed by entity ID)
  */
 struct isp_pipeline {
 	struct media_pipeline pipe;
@@ -96,6 +97,7 @@ struct isp_pipeline {
 	enum isp_pipeline_stream_state stream_state;
 	struct isp_video *input;
 	struct isp_video *output;
+	u32 entities;
 	unsigned long l3_ick;
 	unsigned int max_rate;
 	atomic_t frame_number;
-- 
1.7.2.5

