Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.26]:22486 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933995Ab2AKV1V (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jan 2012 16:27:21 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	teturtia@gmail.com, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@gmail.com, riverful@gmail.com
Subject: [PATCH 21/23] omap3isp: Move resizer link validation to ispresizer.c
Date: Wed, 11 Jan 2012 23:26:58 +0200
Message-Id: <1326317220-15339-21-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <4F0DFE92.80102@iki.fi>
References: <4F0DFE92.80102@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Also remove isp_pipeline_validate.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/video/omap3isp/ispresizer.c |   17 ++++++++-
 drivers/media/video/omap3isp/ispvideo.c   |   61 -----------------------------
 2 files changed, 16 insertions(+), 62 deletions(-)

diff --git a/drivers/media/video/omap3isp/ispresizer.c b/drivers/media/video/omap3isp/ispresizer.c
index ecc377b..81f66bf 100644
--- a/drivers/media/video/omap3isp/ispresizer.c
+++ b/drivers/media/video/omap3isp/ispresizer.c
@@ -1303,6 +1303,21 @@ static int resizer_s_crop(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 	return 0;
 }
 
+static int resizer_link_validate(struct v4l2_subdev *sd,
+				 struct media_link *link,
+				 struct v4l2_subdev_format *source_fmt,
+				 struct v4l2_subdev_format *sink_fmt)
+{
+	struct isp_ccdc_device *ccdc = v4l2_get_subdevdata(sd);
+	struct isp_device *isp = to_isp_device(ccdc);
+	struct isp_pipeline *pipe = to_isp_pipeline(&sd->entity);
+
+	omap3isp_resizer_max_rate(&isp->isp_res, &pipe->max_rate);
+
+	return v4l2_subdev_link_validate_default(sd, link, source_fmt,
+						 sink_fmt);
+}
+
 /* resizer pixel formats */
 static const unsigned int resizer_formats[] = {
 	V4L2_MBUS_FMT_UYVY8_1X16,
@@ -1535,7 +1550,7 @@ static const struct v4l2_subdev_pad_ops resizer_v4l2_pad_ops = {
 	.set_fmt = resizer_set_format,
 	.get_crop = resizer_g_crop,
 	.set_crop = resizer_s_crop,
-	.link_validate = v4l2_subdev_link_validate_default,
+	.link_validate = resizer_link_validate,
 };
 
 /* subdev operations */
diff --git a/drivers/media/video/omap3isp/ispvideo.c b/drivers/media/video/omap3isp/ispvideo.c
index c6e0c39..ee9447f 100644
--- a/drivers/media/video/omap3isp/ispvideo.c
+++ b/drivers/media/video/omap3isp/ispvideo.c
@@ -253,62 +253,6 @@ isp_video_far_end(struct isp_video *video)
 	return far_end;
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
-
-		/*
-		 * host_priv != NULL: this is a sensor. We're at our
-		 * end of the pipeline so we quit now.
-		 */
-		if (subdev->host_priv)
-			break;
-	}
-
-	return 0;
-}
-
 static int
 __isp_video_get_format(struct isp_video *video, struct v4l2_format *format)
 {
@@ -950,11 +894,6 @@ isp_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 		pipe->output = far_end;
 	}
 
-	/* Validate the pipeline and update its state. */
-	ret = isp_video_validate_pipeline(pipe);
-	if (ret < 0)
-		goto error;
-
 	spin_lock_irqsave(&pipe->lock, flags);
 	pipe->state &= ~ISP_PIPELINE_STREAM;
 	pipe->state |= state;
-- 
1.7.2.5

