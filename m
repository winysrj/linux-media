Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:33322 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575Ab2JYVi4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Oct 2012 17:38:56 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH 2/2] omap3isp: video: Merge two pipeline search operations at streamon time
Date: Thu, 25 Oct 2012 23:39:43 +0200
Message-Id: <1351201183-21036-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1351201183-21036-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1351201183-21036-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The current code first iterates over entities with external connectivity
to locate the external source, and then walks the pipeline to verify its
connectivity. Merge both search operations.

This has the side effect of removing the bogus "can't find source,
failing now" warning message printed when using memory-to-memory
pipelines that include the preview engine and/or resizer only.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/ispvideo.c |  179 ++++++++++++---------------
 1 files changed, 80 insertions(+), 99 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index 249ef71..81c0832 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -280,39 +280,90 @@ static int isp_video_get_graph_data(struct isp_video *video,
 	return 0;
 }
 
+static int isp_video_check_external_subdevs(struct isp_pipeline *pipe,
+					    struct media_pad *external)
+{
+	struct isp_device *isp = pipe->output->isp;
+	struct v4l2_subdev_format fmt;
+	struct v4l2_ext_controls ctrls;
+	struct v4l2_ext_control ctrl;
+	int ret;
+
+	pipe->external = media_entity_to_v4l2_subdev(external->entity);
+
+	fmt.pad = external->index;
+	fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
+	ret = v4l2_subdev_call(media_entity_to_v4l2_subdev(external->entity),
+			       pad, get_fmt, NULL, &fmt);
+	if (unlikely(ret < 0)) {
+		dev_warn(isp->dev, "get_fmt returned null!\n");
+		return ret;
+	}
+
+	pipe->external_width =
+		omap3isp_video_format_info(fmt.format.code)->width;
+
+	memset(&ctrls, 0, sizeof(ctrls));
+	memset(&ctrl, 0, sizeof(ctrl));
+
+	ctrl.id = V4L2_CID_PIXEL_RATE;
+
+	ctrls.count = 1;
+	ctrls.controls = &ctrl;
+
+	ret = v4l2_g_ext_ctrls(pipe->external->ctrl_handler, &ctrls);
+	if (ret < 0) {
+		dev_warn(isp->dev, "no pixel rate control in subdev %s\n",
+			 pipe->external->name);
+		return ret;
+	}
+
+	pipe->external_rate = ctrl.value64;
+
+	return 0;
+}
+
 /*
- * Validate a pipeline by checking both ends of all links for format
- * discrepancies.
+ * Validate the pipeline connectivity and retrieve external subdev information.
  *
  * Compute the minimum time per frame value as the maximum of time per frame
  * limits reported by every block in the pipeline.
  *
- * Return 0 if all formats match, or -EPIPE if at least one link is found with
- * different formats on its two ends or if the pipeline doesn't start with a
- * video source (either a subdev with no input pad, or a non-subdev entity).
+ * Return 0 if the pipeline is valid, or one of the following error codes
+ * otherwise:
+ *
+ * -EPIPE if the pipeline doesn't start with a video source (either a subdev
+ *  with no input pad, or a non-subdev entity)
+ *
+ * -ENOSPC if the external pixel rate exceeds the pipeline pixel rate limit
+ *
+ * Other error codes can be returned if the external subdev fails to return its
+ * output format or pixel rate.
  */
 static int isp_video_validate_pipeline(struct isp_pipeline *pipe)
 {
 	struct isp_device *isp = pipe->output->isp;
+	struct media_pad *external = NULL;
 	struct media_pad *pad;
 	struct v4l2_subdev *subdev;
+	int ret;
 
 	subdev = isp_video_remote_subdev(pipe->output, NULL);
 	if (subdev == NULL)
 		return -EPIPE;
 
 	while (1) {
-		/* Retrieve the sink format */
+		/* All ISP entities have their sink pad numbered 0. */
 		pad = &subdev->entity.pads[0];
 		if (!(pad->flags & MEDIA_PAD_FL_SINK))
 			break;
 
-		/* Update the maximum frame rate */
+		/* Update the maximum frame rate. */
 		if (subdev == &isp->isp_res.subdev)
 			omap3isp_resizer_max_rate(&isp->isp_res,
 						  &pipe->max_rate);
 
-		/* Retrieve the source format. Return an error if no source
+		/* Find the connected source. Return an error if no source
 		 * entity can be found, and stop checking the pipeline if the
 		 * source entity isn't a subdev.
 		 */
@@ -324,6 +375,27 @@ static int isp_video_validate_pipeline(struct isp_pipeline *pipe)
 			break;
 
 		subdev = media_entity_to_v4l2_subdev(pad->entity);
+
+		/* Store the first external pad. */
+		if (external == NULL && subdev->grp_id != (1 << 16))
+			external = pad;
+	}
+
+	if (external == NULL)
+		return 0;
+
+	ret = isp_video_check_external_subdevs(pipe, external);
+	if (ret < 0)
+		return ret;
+
+	if (pipe->entities & (1 << isp->isp_ccdc.subdev.entity.id)) {
+		unsigned int rate = UINT_MAX;
+		/* Check that maximum allowed CCDC pixel rate isn't exceeded by
+		 * the pixel rate.
+		 */
+		omap3isp_ccdc_max_rate(&isp->isp_ccdc, &rate);
+		if (pipe->external_rate > rate)
+			return -ENOSPC;
 	}
 
 	return 0;
@@ -878,93 +950,6 @@ isp_video_dqbuf(struct file *file, void *fh, struct v4l2_buffer *b)
 					  file->f_flags & O_NONBLOCK);
 }
 
-static int isp_video_check_external_subdevs(struct isp_video *video,
-					    struct isp_pipeline *pipe)
-{
-	struct isp_device *isp = video->isp;
-	struct media_entity *ents[] = {
-		&isp->isp_csi2a.subdev.entity,
-		&isp->isp_csi2c.subdev.entity,
-		&isp->isp_ccp2.subdev.entity,
-		&isp->isp_ccdc.subdev.entity
-	};
-	struct media_pad *source_pad;
-	struct media_entity *source = NULL;
-	struct media_entity *sink;
-	struct v4l2_subdev_format fmt;
-	struct v4l2_ext_controls ctrls;
-	struct v4l2_ext_control ctrl;
-	unsigned int i;
-	int ret = 0;
-
-	for (i = 0; i < ARRAY_SIZE(ents); i++) {
-		/* Is the entity part of the pipeline? */
-		if (!(pipe->entities & (1 << ents[i]->id)))
-			continue;
-
-		/* ISP entities have always sink pad == 0. Find source. */
-		source_pad = media_entity_remote_source(&ents[i]->pads[0]);
-		if (source_pad == NULL)
-			continue;
-
-		source = source_pad->entity;
-		sink = ents[i];
-		break;
-	}
-
-	if (!source) {
-		dev_warn(isp->dev, "can't find source, failing now\n");
-		return ret;
-	}
-
-	if (media_entity_type(source) != MEDIA_ENT_T_V4L2_SUBDEV)
-		return 0;
-
-	pipe->external = media_entity_to_v4l2_subdev(source);
-
-	fmt.pad = source_pad->index;
-	fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
-	ret = v4l2_subdev_call(media_entity_to_v4l2_subdev(sink),
-			       pad, get_fmt, NULL, &fmt);
-	if (unlikely(ret < 0)) {
-		dev_warn(isp->dev, "get_fmt returned null!\n");
-		return ret;
-	}
-
-	pipe->external_width =
-		omap3isp_video_format_info(fmt.format.code)->width;
-
-	memset(&ctrls, 0, sizeof(ctrls));
-	memset(&ctrl, 0, sizeof(ctrl));
-
-	ctrl.id = V4L2_CID_PIXEL_RATE;
-
-	ctrls.count = 1;
-	ctrls.controls = &ctrl;
-
-	ret = v4l2_g_ext_ctrls(pipe->external->ctrl_handler, &ctrls);
-	if (ret < 0) {
-		dev_warn(isp->dev, "no pixel rate control in subdev %s\n",
-			 pipe->external->name);
-		return ret;
-	}
-
-	pipe->external_rate = ctrl.value64;
-
-	if (pipe->entities & (1 << isp->isp_ccdc.subdev.entity.id)) {
-		unsigned int rate = UINT_MAX;
-		/*
-		 * Check that maximum allowed CCDC pixel rate isn't
-		 * exceeded by the pixel rate.
-		 */
-		omap3isp_ccdc_max_rate(&isp->isp_ccdc, &rate);
-		if (pipe->external_rate > rate)
-			return -ENOSPC;
-	}
-
-	return 0;
-}
-
 /*
  * Stream management
  *
@@ -1052,10 +1037,6 @@ isp_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 	else
 		state = ISP_PIPELINE_STREAM_INPUT | ISP_PIPELINE_IDLE_INPUT;
 
-	ret = isp_video_check_external_subdevs(video, pipe);
-	if (ret < 0)
-		goto err_check_format;
-
 	/* Validate the pipeline and update its state. */
 	ret = isp_video_validate_pipeline(pipe);
 	if (ret < 0)
-- 
1.7.8.6

