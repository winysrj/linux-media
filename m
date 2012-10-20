Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56667 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751577Ab2JTVsV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Oct 2012 17:48:21 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [PATCH 1/2] omap3isp: Add resizer data rate configuration to resizer_link_validate
Date: Sun, 21 Oct 2012 00:48:17 +0300
Message-Id: <1350769698-24752-1-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <20121020214803.GR21261@valkosipuli.retiisi.org.uk>
References: <20121020214803.GR21261@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The configuration of many other blocks depend on resizer maximum data rate.
Get the value from resizer at link validation time.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/ispresizer.c |   15 +++++++
 drivers/media/platform/omap3isp/ispvideo.c   |   54 --------------------------
 2 files changed, 15 insertions(+), 54 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispresizer.c b/drivers/media/platform/omap3isp/ispresizer.c
index d11fb26..bb5fb4a 100644
--- a/drivers/media/platform/omap3isp/ispresizer.c
+++ b/drivers/media/platform/omap3isp/ispresizer.c
@@ -1532,6 +1532,20 @@ static int resizer_set_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 	return 0;
 }
 
+static int resizer_link_validate(struct v4l2_subdev *sd,
+				 struct media_link *link,
+				 struct v4l2_subdev_format *source_fmt,
+				 struct v4l2_subdev_format *sink_fmt)
+{
+	struct isp_res_device *res = v4l2_get_subdevdata(sd);
+	struct isp_pipeline *pipe = to_isp_pipeline(&sd->entity);
+
+	omap3isp_resizer_max_rate(res, &pipe->max_rate);
+
+	return v4l2_subdev_link_validate_default(sd, link,
+						 source_fmt, sink_fmt);
+}
+
 /*
  * resizer_init_formats - Initialize formats on all pads
  * @sd: ISP resizer V4L2 subdevice
@@ -1570,6 +1584,7 @@ static const struct v4l2_subdev_pad_ops resizer_v4l2_pad_ops = {
 	.set_fmt = resizer_set_format,
 	.get_selection = resizer_get_selection,
 	.set_selection = resizer_set_selection,
+	.link_validate = resizer_link_validate,
 };
 
 /* subdev operations */
diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index a0b737fe..aae70f7 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -280,55 +280,6 @@ static int isp_video_get_graph_data(struct isp_video *video,
 	return 0;
 }
 
-/*
- * Validate a pipeline by checking both ends of all links for format
- * discrepancies.
- *
- * Compute the minimum time per frame value as the maximum of time per frame
- * limits reported by every block in the pipeline.
- *
- * Return 0 if all formats match, or -EPIPE if at least one link is found with
- * different formats on its two ends or if the pipeline doesn't start with a
- * video source (either a subdev with no input pad, or a non-subdev entity).
- */
-static int isp_video_validate_pipeline(struct isp_pipeline *pipe)
-{
-	struct isp_device *isp = pipe->output->isp;
-	struct media_pad *pad;
-	struct v4l2_subdev *subdev;
-
-	subdev = isp_video_remote_subdev(pipe->output, NULL);
-	if (subdev == NULL)
-		return -EPIPE;
-
-	while (1) {
-		/* Retrieve the sink format */
-		pad = &subdev->entity.pads[0];
-		if (!(pad->flags & MEDIA_PAD_FL_SINK))
-			break;
-
-		/* Update the maximum frame rate */
-		if (subdev == &isp->isp_res.subdev)
-			omap3isp_resizer_max_rate(&isp->isp_res,
-						  &pipe->max_rate);
-
-		/* Retrieve the source format. Return an error if no source
-		 * entity can be found, and stop checking the pipeline if the
-		 * source entity isn't a subdev.
-		 */
-		pad = media_entity_remote_source(pad);
-		if (pad == NULL)
-			return -EPIPE;
-
-		if (media_entity_type(pad->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
-			break;
-
-		subdev = media_entity_to_v4l2_subdev(pad->entity);
-	}
-
-	return 0;
-}
-
 static int
 __isp_video_get_format(struct isp_video *video, struct v4l2_format *format)
 {
@@ -1056,11 +1007,6 @@ isp_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 	if (ret < 0)
 		goto err_check_format;
 
-	/* Validate the pipeline and update its state. */
-	ret = isp_video_validate_pipeline(pipe);
-	if (ret < 0)
-		goto err_check_format;
-
 	pipe->error = false;
 
 	spin_lock_irqsave(&pipe->lock, flags);
-- 
1.7.2.5

