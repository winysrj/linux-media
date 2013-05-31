Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:11463 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab3EaQr6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 May 2013 12:47:58 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MNO0025J9BXB9O0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Sat, 01 Jun 2013 01:47:57 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: hj210.choi@samsung.com, yhwan.joo@samsung.com, arun.kk@samsung.com,
	shaik.ameer@samsung.com, kyungmin.park@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [REVIEW PATCH 4/7] exynos4-is: Refactor vidioc_s_fmt,
 vidioc_try_fmt handlers
Date: Fri, 31 May 2013 18:47:02 +0200
Message-id: <1370018825-13088-5-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1370018825-13088-1-git-send-email-s.nawrocki@samsung.com>
References: <1370018825-13088-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove duplicated code in the vidioc_try_fmt and vidioc_s_fmt handlers.
This is a pre-requsite to allow successful fimc.capture video open even
if its corresponding media entities are not linked into a complete
pipeline.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/exynos4-is/fimc-capture.c |  158 ++++++++++------------
 1 file changed, 75 insertions(+), 83 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-capture.c b/drivers/media/platform/exynos4-is/fimc-capture.c
index 25f8a1e..763f9de 100644
--- a/drivers/media/platform/exynos4-is/fimc-capture.c
+++ b/drivers/media/platform/exynos4-is/fimc-capture.c
@@ -503,9 +503,6 @@ static int fimc_capture_open(struct file *file)
 
 		ret = fimc_pipeline_call(ve, open, &ve->vdev.entity, true);
 
-		if (ret == 0)
-			ret = fimc_capture_set_default_format(fimc);
-
 		if (ret == 0 && vc->user_subdev_api && vc->inh_sensor_ctrls) {
 			/*
 			 * Recreate controls of the the video node to drop
@@ -522,6 +519,9 @@ static int fimc_capture_open(struct file *file)
 
 		fimc_md_graph_unlock(ve);
 
+		if (ret == 0)
+			ret = fimc_capture_set_default_format(fimc);
+
 		if (ret < 0) {
 			clear_bit(ST_CAPT_BUSY, &fimc->state);
 			pm_runtime_put_sync(&fimc->pdev->dev);
@@ -916,55 +916,83 @@ static int fimc_cap_g_fmt_mplane(struct file *file, void *fh,
 	return 0;
 }
 
-static int fimc_cap_try_fmt_mplane(struct file *file, void *fh,
-				   struct v4l2_format *f)
+/*
+ * Try or set format on the fimc.X.capture video node and additionally
+ * on the whole pipeline if @try is false.
+ * Locking: the caller must _not_ hold the graph mutex.
+ */
+static int __video_try_or_set_format(struct fimc_dev *fimc,
+				     struct v4l2_format *f, bool try,
+				     struct fimc_fmt **inp_fmt,
+				     struct fimc_fmt **out_fmt)
 {
 	struct v4l2_pix_format_mplane *pix = &f->fmt.pix_mp;
-	struct fimc_dev *fimc = video_drvdata(file);
-	struct fimc_ctx *ctx = fimc->vid_cap.ctx;
-	struct exynos_video_entity *ve = &fimc->vid_cap.ve;
-	struct v4l2_mbus_framefmt mf;
-	struct v4l2_subdev *sensor;
-	struct fimc_fmt *ffmt = NULL;
+	struct fimc_vid_cap *vc = &fimc->vid_cap;
+	struct exynos_video_entity *ve = &vc->ve;
+	struct fimc_ctx *ctx = vc->ctx;
+	unsigned int width = 0, height = 0;
 	int ret = 0;
 
+	/* Pre-configure format at the camera input interface, for JPEG only */
 	if (fimc_jpeg_fourcc(pix->pixelformat)) {
 		fimc_capture_try_format(ctx, &pix->width, &pix->height,
 					NULL, &pix->pixelformat,
 					FIMC_SD_PAD_SINK_CAM);
-		ctx->s_frame.f_width  = pix->width;
-		ctx->s_frame.f_height = pix->height;
+		if (try) {
+			width = pix->width;
+			height = pix->height;
+		} else {
+			ctx->s_frame.f_width = pix->width;
+			ctx->s_frame.f_height = pix->height;
+		}
 	}
-	ffmt = fimc_capture_try_format(ctx, &pix->width, &pix->height,
-				       NULL, &pix->pixelformat,
-				       FIMC_SD_PAD_SOURCE);
-	if (!ffmt)
+
+	/* Try the format at the scaler and the DMA output */
+	*out_fmt = fimc_capture_try_format(ctx, &pix->width, &pix->height,
+					  NULL, &pix->pixelformat,
+					  FIMC_SD_PAD_SOURCE);
+	if (*out_fmt == NULL)
 		return -EINVAL;
 
-	if (!fimc->vid_cap.user_subdev_api) {
-		mf.width = pix->width;
-		mf.height = pix->height;
-		mf.code = ffmt->mbus_code;
+	/* Restore image width/height for JPEG (no resizing supported). */
+	if (try && fimc_jpeg_fourcc(pix->pixelformat)) {
+		pix->width = width;
+		pix->height = height;
+	}
+
+	/* Try to match format at the host and the sensor */
+	if (!vc->user_subdev_api) {
+		struct v4l2_mbus_framefmt mbus_fmt;
+		struct v4l2_mbus_framefmt *mf;
+
+		mf = try ? &mbus_fmt : &fimc->vid_cap.ci_fmt;
+
+		mf->code = (*out_fmt)->mbus_code;
+		mf->width = pix->width;
+		mf->height = pix->height;
 
 		fimc_md_graph_lock(ve);
-		fimc_pipeline_try_format(ctx, &mf, &ffmt, false);
+		ret = fimc_pipeline_try_format(ctx, mf, inp_fmt, try);
 		fimc_md_graph_unlock(ve);
 
-		pix->width = mf.width;
-		pix->height = mf.height;
-		if (ffmt)
-			pix->pixelformat = ffmt->fourcc;
+		if (ret < 0)
+			return ret;
+
+		pix->width = mf->width;
+		pix->height = mf->height;
 	}
 
-	fimc_adjust_mplane_format(ffmt, pix->width, pix->height, pix);
+	fimc_adjust_mplane_format(*out_fmt, pix->width, pix->height, pix);
+
+	if ((*out_fmt)->flags & FMT_FLAGS_COMPRESSED) {
+		struct v4l2_subdev *sensor;
 
-	if (ffmt->flags & FMT_FLAGS_COMPRESSED) {
 		fimc_md_graph_lock(ve);
 
 		sensor = __fimc_md_get_subdev(ve->pipe, IDX_SENSOR);
 		if (sensor)
 			fimc_get_sensor_frame_desc(sensor, pix->plane_fmt,
-						   ffmt->memplanes, true);
+						   (*out_fmt)->memplanes, try);
 		else
 			ret = -EPIPE;
 
@@ -974,6 +1002,15 @@ static int fimc_cap_try_fmt_mplane(struct file *file, void *fh,
 	return ret;
 }
 
+static int fimc_cap_try_fmt_mplane(struct file *file, void *fh,
+				   struct v4l2_format *f)
+{
+	struct fimc_dev *fimc = video_drvdata(file);
+	struct fimc_fmt *out_fmt = NULL, *inp_fmt = NULL;
+
+	return __video_try_or_set_format(fimc, f, true, &inp_fmt, &out_fmt);
+}
+
 static void fimc_capture_mark_jpeg_xfer(struct fimc_ctx *ctx,
 					enum fimc_color_fmt color)
 {
@@ -991,58 +1028,23 @@ static void fimc_capture_mark_jpeg_xfer(struct fimc_ctx *ctx,
 static int __fimc_capture_set_format(struct fimc_dev *fimc,
 				     struct v4l2_format *f)
 {
-	struct fimc_ctx *ctx = fimc->vid_cap.ctx;
+	struct fimc_vid_cap *vc = &fimc->vid_cap;
+	struct fimc_ctx *ctx = vc->ctx;
 	struct v4l2_pix_format_mplane *pix = &f->fmt.pix_mp;
-	struct v4l2_mbus_framefmt *mf = &fimc->vid_cap.ci_fmt;
-	struct fimc_pipeline *p = to_fimc_pipeline(fimc->vid_cap.ve.pipe);
 	struct fimc_frame *ff = &ctx->d_frame;
-	struct fimc_fmt *s_fmt = NULL;
+	struct fimc_fmt *inp_fmt = NULL;
 	int ret, i;
 
 	if (vb2_is_busy(&fimc->vid_cap.vbq))
 		return -EBUSY;
 
-	/* Pre-configure format at camera interface input, for JPEG only */
-	if (fimc_jpeg_fourcc(pix->pixelformat)) {
-		fimc_capture_try_format(ctx, &pix->width, &pix->height,
-					NULL, &pix->pixelformat,
-					FIMC_SD_PAD_SINK_CAM);
-		ctx->s_frame.f_width  = pix->width;
-		ctx->s_frame.f_height = pix->height;
-	}
-	/* Try the format at the scaler and the DMA output */
-	ff->fmt = fimc_capture_try_format(ctx, &pix->width, &pix->height,
-					  NULL, &pix->pixelformat,
-					  FIMC_SD_PAD_SOURCE);
-	if (!ff->fmt)
-		return -EINVAL;
+	ret = __video_try_or_set_format(fimc, f, false, &inp_fmt, &ff->fmt);
+	if (ret < 0)
+		return ret;
 
 	/* Update RGB Alpha control state and value range */
 	fimc_alpha_ctrl_update(ctx);
 
-	/* Try to match format at the host and the sensor */
-	if (!fimc->vid_cap.user_subdev_api) {
-		mf->code   = ff->fmt->mbus_code;
-		mf->width  = pix->width;
-		mf->height = pix->height;
-		ret = fimc_pipeline_try_format(ctx, mf, &s_fmt, true);
-		if (ret)
-			return ret;
-
-		pix->width  = mf->width;
-		pix->height = mf->height;
-	}
-
-	fimc_adjust_mplane_format(ff->fmt, pix->width, pix->height, pix);
-
-	if (ff->fmt->flags & FMT_FLAGS_COMPRESSED) {
-		ret = fimc_get_sensor_frame_desc(p->subdevs[IDX_SENSOR],
-					pix->plane_fmt, ff->fmt->memplanes,
-					true);
-		if (ret < 0)
-			return ret;
-	}
-
 	for (i = 0; i < ff->fmt->memplanes; i++) {
 		ff->bytesperline[i] = pix->plane_fmt[i].bytesperline;
 		ff->payload[i] = pix->plane_fmt[i].sizeimage;
@@ -1056,8 +1058,8 @@ static int __fimc_capture_set_format(struct fimc_dev *fimc,
 	fimc_capture_mark_jpeg_xfer(ctx, ff->fmt->color);
 
 	/* Reset cropping and set format at the camera interface input */
-	if (!fimc->vid_cap.user_subdev_api) {
-		ctx->s_frame.fmt = s_fmt;
+	if (!vc->user_subdev_api) {
+		ctx->s_frame.fmt = inp_fmt;
 		set_frame_bounds(&ctx->s_frame, pix->width, pix->height);
 		set_frame_crop(&ctx->s_frame, 0, 0, pix->width, pix->height);
 	}
@@ -1069,18 +1071,8 @@ static int fimc_cap_s_fmt_mplane(struct file *file, void *priv,
 				 struct v4l2_format *f)
 {
 	struct fimc_dev *fimc = video_drvdata(file);
-	int ret;
 
-	fimc_md_graph_lock(&fimc->vid_cap.ve);
-	/*
-	 * The graph is walked within __fimc_capture_set_format() to set
-	 * the format at subdevs thus the graph mutex needs to be held at
-	 * this point.
-	 */
-	ret = __fimc_capture_set_format(fimc, f);
-
-	fimc_md_graph_unlock(&fimc->vid_cap.ve);
-	return ret;
+	return __fimc_capture_set_format(fimc, f);
 }
 
 static int fimc_cap_enum_input(struct file *file, void *priv,
-- 
1.7.9.5

