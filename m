Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:28026 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932414Ab2CBRc4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 2 Mar 2012 12:32:56 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, dacohen@gmail.com,
	snjw23@gmail.com, andriy.shevchenko@linux.intel.com,
	t.stanislaws@samsung.com, tuukkat76@gmail.com,
	k.debski@samsung.com, riverful@gmail.com, hverkuil@xs4all.nl,
	teturtia@gmail.com
Subject: [PATCH v4 30/34] omap3isp: Move CCDC link validation to ccdc_link_validate()
Date: Fri,  2 Mar 2012 19:30:38 +0200
Message-Id: <1330709442-16654-30-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <20120302173219.GA15695@valkosipuli.localdomain>
References: <20120302173219.GA15695@valkosipuli.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Perform CCDC link validation in ccdc_link_validate() instead of
isp_video_validate_pipeline(). Also perform maximum data rate check in
isp_video_check_external_subdevs().

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/video/omap3isp/ispccdc.c  |   65 +++++++++++++++++++++
 drivers/media/video/omap3isp/ispvideo.c |   94 ++++---------------------------
 2 files changed, 76 insertions(+), 83 deletions(-)

diff --git a/drivers/media/video/omap3isp/ispccdc.c b/drivers/media/video/omap3isp/ispccdc.c
index cd1bf6d..84f230e 100644
--- a/drivers/media/video/omap3isp/ispccdc.c
+++ b/drivers/media/video/omap3isp/ispccdc.c
@@ -2000,6 +2000,69 @@ static int ccdc_set_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 }
 
 /*
+ * Decide whether desired output pixel code can be obtained with
+ * the lane shifter by shifting the input pixel code.
+ * @in: input pixelcode to shifter
+ * @out: output pixelcode from shifter
+ * @additional_shift: # of bits the sensor's LSB is offset from CAMEXT[0]
+ *
+ * return true if the combination is possible
+ * return false otherwise
+ */
+static bool ccdc_is_shiftable(enum v4l2_mbus_pixelcode in,
+			      enum v4l2_mbus_pixelcode out,
+			      unsigned int additional_shift)
+{
+	const struct isp_format_info *in_info, *out_info;
+
+	if (in == out)
+		return true;
+
+	in_info = omap3isp_video_format_info(in);
+	out_info = omap3isp_video_format_info(out);
+
+	if ((in_info->flavor == 0) || (out_info->flavor == 0))
+		return false;
+
+	if (in_info->flavor != out_info->flavor)
+		return false;
+
+	return in_info->bpp - out_info->bpp + additional_shift <= 6;
+}
+
+static int ccdc_link_validate(struct v4l2_subdev *sd,
+			      struct media_link *link,
+			      struct v4l2_subdev_format *source_fmt,
+			      struct v4l2_subdev_format *sink_fmt)
+{
+	struct isp_ccdc_device *ccdc = v4l2_get_subdevdata(sd);
+	unsigned long parallel_shift;
+
+	/* Check if the two ends match */
+	if (source_fmt->format.width != sink_fmt->format.width ||
+	    source_fmt->format.height != sink_fmt->format.height)
+		return -EPIPE;
+
+	/* We've got a parallel sensor here. */
+	if (ccdc->input == CCDC_INPUT_PARALLEL) {
+		struct isp_parallel_platform_data *pdata =
+			&((struct isp_v4l2_subdevs_group *)
+			  media_entity_to_v4l2_subdev(link->source->entity)
+			  ->host_priv)->bus.parallel;
+		parallel_shift = pdata->data_lane_shift * 2;
+	} else {
+		parallel_shift = 0;
+	}
+
+	/* Lane shifter may be used to drop bits on CCDC sink pad */
+	if (!ccdc_is_shiftable(source_fmt->format.code,
+			       sink_fmt->format.code, parallel_shift))
+		return -EPIPE;
+
+	return 0;
+}
+
+/*
  * ccdc_init_formats - Initialize formats on all pads
  * @sd: ISP CCDC V4L2 subdevice
  * @fh: V4L2 subdev file handle
@@ -2041,6 +2104,7 @@ static const struct v4l2_subdev_pad_ops ccdc_v4l2_pad_ops = {
 	.enum_frame_size = ccdc_enum_frame_size,
 	.get_fmt = ccdc_get_format,
 	.set_fmt = ccdc_set_format,
+	.link_validate = ccdc_link_validate,
 };
 
 /* V4L2 subdev operations */
@@ -2150,6 +2214,7 @@ static int ccdc_link_setup(struct media_entity *entity,
 /* media operations */
 static const struct media_entity_operations ccdc_media_ops = {
 	.link_setup = ccdc_link_setup,
+	.link_validate = v4l2_subdev_link_validate,
 };
 
 void omap3isp_ccdc_unregister_entities(struct isp_ccdc_device *ccdc)
diff --git a/drivers/media/video/omap3isp/ispvideo.c b/drivers/media/video/omap3isp/ispvideo.c
index 564e16d..0c63229 100644
--- a/drivers/media/video/omap3isp/ispvideo.c
+++ b/drivers/media/video/omap3isp/ispvideo.c
@@ -130,37 +130,6 @@ omap3isp_video_format_info(enum v4l2_mbus_pixelcode code)
 }
 
 /*
- * Decide whether desired output pixel code can be obtained with
- * the lane shifter by shifting the input pixel code.
- * @in: input pixelcode to shifter
- * @out: output pixelcode from shifter
- * @additional_shift: # of bits the sensor's LSB is offset from CAMEXT[0]
- *
- * return true if the combination is possible
- * return false otherwise
- */
-static bool isp_video_is_shiftable(enum v4l2_mbus_pixelcode in,
-		enum v4l2_mbus_pixelcode out,
-		unsigned int additional_shift)
-{
-	const struct isp_format_info *in_info, *out_info;
-
-	if (in == out)
-		return true;
-
-	in_info = omap3isp_video_format_info(in);
-	out_info = omap3isp_video_format_info(out);
-
-	if ((in_info->flavor == 0) || (out_info->flavor == 0))
-		return false;
-
-	if (in_info->flavor != out_info->flavor)
-		return false;
-
-	return in_info->bpp - out_info->bpp + additional_shift <= 6;
-}
-
-/*
  * isp_video_mbus_to_pix - Convert v4l2_mbus_framefmt to v4l2_pix_format
  * @video: ISP video instance
  * @mbus: v4l2_mbus_framefmt format (input)
@@ -298,50 +267,24 @@ isp_video_far_end(struct isp_video *video)
 static int isp_video_validate_pipeline(struct isp_pipeline *pipe)
 {
 	struct isp_device *isp = pipe->output->isp;
-	struct v4l2_subdev_format fmt_source;
-	struct v4l2_subdev_format fmt_sink;
 	struct media_pad *pad;
 	struct v4l2_subdev *subdev;
-	int ret;
 
 	subdev = isp_video_remote_subdev(pipe->output, NULL);
 	if (subdev == NULL)
 		return -EPIPE;
 
 	while (1) {
-		unsigned int shifter_link;
 		/* Retrieve the sink format */
 		pad = &subdev->entity.pads[0];
 		if (!(pad->flags & MEDIA_PAD_FL_SINK))
 			break;
 
-		fmt_sink.pad = pad->index;
-		fmt_sink.which = V4L2_SUBDEV_FORMAT_ACTIVE;
-		ret = v4l2_subdev_call(subdev, pad, get_fmt, NULL, &fmt_sink);
-		if (ret < 0 && ret != -ENOIOCTLCMD)
-			return -EPIPE;
-
 		/* Update the maximum frame rate */
 		if (subdev == &isp->isp_res.subdev)
 			omap3isp_resizer_max_rate(&isp->isp_res,
 						  &pipe->max_rate);
 
-		/* Check ccdc maximum data rate when data comes from sensor
-		 * TODO: Include ccdc rate in pipe->max_rate and compare the
-		 *       total pipe rate with the input data rate from sensor.
-		 */
-		if (subdev == &isp->isp_ccdc.subdev && pipe->input == NULL) {
-			unsigned int rate = UINT_MAX;
-
-			omap3isp_ccdc_max_rate(&isp->isp_ccdc, &rate);
-			if (pipe->external_rate > rate)
-				return -ENOSPC;
-		}
-
-		/* If sink pad is on CCDC, the link has the lane shifter
-		 * in the middle of it. */
-		shifter_link = subdev == &isp->isp_ccdc.subdev;
-
 		/* Retrieve the source format. Return an error if no source
 		 * entity can be found, and stop checking the pipeline if the
 		 * source entity isn't a subdev.
@@ -354,32 +297,6 @@ static int isp_video_validate_pipeline(struct isp_pipeline *pipe)
 			break;
 
 		subdev = media_entity_to_v4l2_subdev(pad->entity);
-
-		fmt_source.pad = pad->index;
-		fmt_source.which = V4L2_SUBDEV_FORMAT_ACTIVE;
-		ret = v4l2_subdev_call(subdev, pad, get_fmt, NULL, &fmt_source);
-		if (ret < 0 && ret != -ENOIOCTLCMD)
-			return -EPIPE;
-
-		/* Check if the two ends match */
-		if (fmt_source.format.width != fmt_sink.format.width ||
-		    fmt_source.format.height != fmt_sink.format.height)
-			return -EPIPE;
-
-		if (shifter_link) {
-			unsigned int parallel_shift = 0;
-			if (isp->isp_ccdc.input == CCDC_INPUT_PARALLEL) {
-				struct isp_parallel_platform_data *pdata =
-					&((struct isp_v4l2_subdevs_group *)
-					      subdev->host_priv)->bus.parallel;
-				parallel_shift = pdata->data_lane_shift * 2;
-			}
-			if (!isp_video_is_shiftable(fmt_source.format.code,
-						fmt_sink.format.code,
-						parallel_shift))
-				return -EPIPE;
-		} else if (fmt_source.format.code != fmt_sink.format.code)
-			return -EPIPE;
 	}
 
 	return 0;
@@ -950,6 +867,7 @@ static int isp_video_check_external_subdevs(struct isp_pipeline *pipe)
 	struct v4l2_subdev_format fmt;
 	struct v4l2_ext_controls ctrls;
 	struct v4l2_ext_control ctrl;
+	unsigned int rate = UINT_MAX;
 	int i;
 	int ret = 0;
 
@@ -1002,6 +920,16 @@ static int isp_video_check_external_subdevs(struct isp_pipeline *pipe)
 
 	pipe->external_rate = ctrl.value64;
 
+	if (pipe->pipe.entities & (1 << isp->isp_ccdc.subdev.entity.id)) {
+		/*
+		 * Check that maximum allowed CCDC pixel rate isn't
+		 * exceeded by the pixel rate.
+		 */
+		omap3isp_ccdc_max_rate(&isp->isp_ccdc, &rate);
+		if (pipe->external_rate > rate)
+			return -ENOSPC;
+	}
+
 	return 0;
 }
 
-- 
1.7.2.5

