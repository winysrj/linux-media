Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:37965 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932494Ab1IAPak (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Sep 2011 11:30:40 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Thu, 01 Sep 2011 17:30:17 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 13/19 v4] s5p-fimc: Add subdev for the FIMC processing block
In-reply-to: <1314891023-14227-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: mchehab@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, s.nawrocki@samsung.com,
	sw0312.kim@samsung.com, riverful.kim@samsung.com
Message-id: <1314891023-14227-14-git-send-email-s.nawrocki@samsung.com>
References: <1314891023-14227-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a subdev to expose the host's scaling and composition functions.
The camera frame composition onto an output buffer may be configured
through set/get_crop at FIMC.{n} source pad.
Additionally allow crop, composition and controls to be modified
during streaming. Make sure the default format is set when opening
the video capture node.
Rename struct fimc_vid_cap::fmt to more relevant 'mf' to avoid
confusion.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-capture.c |  734 ++++++++++++++++++++++++---
 drivers/media/video/s5p-fimc/fimc-core.c    |   30 +-
 drivers/media/video/s5p-fimc/fimc-core.h    |   53 ++-
 drivers/media/video/s5p-fimc/fimc-mdevice.c |   39 ++-
 drivers/media/video/s5p-fimc/fimc-reg.c     |    8 +-
 5 files changed, 748 insertions(+), 116 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index f0fed61..62fd8a1 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -63,6 +63,7 @@ static int fimc_init_capture(struct fimc_dev *fimc)
 		fimc_hw_set_effect(ctx);
 		fimc_hw_set_output_path(ctx);
 		fimc_hw_set_out_dma(ctx);
+		clear_bit(ST_CAPT_APPLY_CFG, &fimc->state);
 	}
 	spin_unlock_irqrestore(&fimc->slock, flags);
 	return ret;
@@ -120,6 +121,36 @@ static int fimc_stop_capture(struct fimc_dev *fimc)
 	return fimc_capture_state_cleanup(fimc);
 }
 
+/**
+ * fimc_capture_config_update - apply the camera interface configuration
+ *
+ * To be called from within the interrupt handler with fimc.slock
+ * spinlock held. It updates the camera pixel crop, rotation and
+ * image flip in H/W.
+ */
+int fimc_capture_config_update(struct fimc_ctx *ctx)
+{
+	struct fimc_dev *fimc = ctx->fimc_dev;
+	int ret;
+
+	if (test_bit(ST_CAPT_APPLY_CFG, &fimc->state))
+		return 0;
+
+	spin_lock(&ctx->slock);
+	fimc_hw_set_camera_offset(fimc, &ctx->s_frame);
+	ret = fimc_set_scaler_info(ctx);
+	if (ret == 0) {
+		fimc_hw_set_prescaler(ctx);
+		fimc_hw_set_mainscaler(ctx);
+		fimc_hw_set_target_format(ctx);
+		fimc_hw_set_rotation(ctx);
+		fimc_prepare_dma_offset(ctx, &ctx->d_frame);
+		fimc_hw_set_out_dma(ctx);
+		set_bit(ST_CAPT_APPLY_CFG, &fimc->state);
+	}
+	spin_unlock(&ctx->slock);
+	return ret;
+}
 
 static int start_streaming(struct vb2_queue *q, unsigned int count)
 {
@@ -319,6 +350,8 @@ int fimc_capture_ctrls_create(struct fimc_dev *fimc)
 				    fimc->pipeline.sensor->ctrl_handler);
 }
 
+static int fimc_capture_set_default_format(struct fimc_dev *fimc);
+
 static int fimc_capture_open(struct file *file)
 {
 	struct fimc_dev *fimc = video_drvdata(file);
@@ -347,6 +380,9 @@ static int fimc_capture_open(struct file *file)
 			return ret;
 		}
 		ret = fimc_capture_ctrls_create(fimc);
+
+		if (!ret && !fimc->vid_cap.user_subdev_api)
+			ret = fimc_capture_set_default_format(fimc);
 	}
 	return ret;
 }
@@ -384,7 +420,6 @@ static int fimc_capture_mmap(struct file *file, struct vm_area_struct *vma)
 	return vb2_mmap(&fimc->vid_cap.vbq, vma);
 }
 
-/* video device file operations */
 static const struct v4l2_file_operations fimc_capture_fops = {
 	.owner		= THIS_MODULE,
 	.open		= fimc_capture_open,
@@ -394,6 +429,147 @@ static const struct v4l2_file_operations fimc_capture_fops = {
 	.mmap		= fimc_capture_mmap,
 };
 
+/*
+ * Format and crop negotiation helpers
+ */
+
+static struct fimc_fmt *fimc_capture_try_format(struct fimc_ctx *ctx,
+						u32 *width, u32 *height,
+						u32 *code, u32 *fourcc, int pad)
+{
+	bool rotation = ctx->rotation == 90 || ctx->rotation == 270;
+	struct fimc_dev *fimc = ctx->fimc_dev;
+	struct samsung_fimc_variant *var = fimc->variant;
+	struct fimc_pix_limit *pl = var->pix_limit;
+	struct fimc_frame *dst = &ctx->d_frame;
+	u32 depth, min_w, max_w, min_h, align_h = 3;
+	u32 mask = FMT_FLAGS_CAM;
+	struct fimc_fmt *ffmt;
+
+	/* Color conversion from/to JPEG is not supported */
+	if (code && ctx->s_frame.fmt && pad == FIMC_SD_PAD_SOURCE &&
+	    fimc_fmt_is_jpeg(ctx->s_frame.fmt->color))
+		*code = V4L2_MBUS_FMT_JPEG_1X8;
+
+	if (fourcc && *fourcc != V4L2_PIX_FMT_JPEG && pad != FIMC_SD_PAD_SINK)
+		mask |= FMT_FLAGS_M2M;
+
+	ffmt = fimc_find_format(fourcc, code, mask, 0);
+	if (WARN_ON(!ffmt))
+		return NULL;
+	if (code)
+		*code = ffmt->mbus_code;
+	if (fourcc)
+		*fourcc = ffmt->fourcc;
+
+	if (pad == FIMC_SD_PAD_SINK) {
+		max_w = fimc_fmt_is_jpeg(ffmt->color) ?
+			pl->scaler_dis_w : pl->scaler_en_w;
+		/* Apply the camera input interface pixel constraints */
+		v4l_bound_align_image(width, max_t(u32, *width, 32), max_w, 4,
+				      height, max_t(u32, *height, 32),
+				      FIMC_CAMIF_MAX_HEIGHT,
+				      fimc_fmt_is_jpeg(ffmt->color) ? 3 : 1,
+				      0);
+		return ffmt;
+	}
+	/* Can't scale or crop in transparent (JPEG) transfer mode */
+	if (fimc_fmt_is_jpeg(ffmt->color)) {
+		*width  = ctx->s_frame.f_width;
+		*height = ctx->s_frame.f_height;
+		return ffmt;
+	}
+	/* Apply the scaler and the output DMA constraints */
+	max_w = rotation ? pl->out_rot_en_w : pl->out_rot_dis_w;
+	min_w = ctx->state & FIMC_DST_CROP ? dst->width : var->min_out_pixsize;
+	min_h = ctx->state & FIMC_DST_CROP ? dst->height : var->min_out_pixsize;
+	if (fimc->id == 1 && var->pix_hoff)
+		align_h = fimc_fmt_is_rgb(ffmt->color) ? 0 : 1;
+
+	depth = fimc_get_format_depth(ffmt);
+	v4l_bound_align_image(width, min_w, max_w,
+			      ffs(var->min_out_pixsize) - 1,
+			      height, min_h, FIMC_CAMIF_MAX_HEIGHT,
+			      align_h,
+			      64/(ALIGN(depth, 8)));
+
+	dbg("pad%d: code: 0x%x, %dx%d. dst fmt: %dx%d",
+	    pad, code ? *code : 0, *width, *height,
+	    dst->f_width, dst->f_height);
+
+	return ffmt;
+}
+
+static void fimc_capture_try_crop(struct fimc_ctx *ctx, struct v4l2_rect *r,
+				  int pad)
+{
+	bool rotate = ctx->rotation == 90 || ctx->rotation == 270;
+	struct fimc_dev *fimc = ctx->fimc_dev;
+	struct samsung_fimc_variant *var = fimc->variant;
+	struct fimc_pix_limit *pl = var->pix_limit;
+	struct fimc_frame *sink = &ctx->s_frame;
+	u32 max_w, max_h, min_w = 0, min_h = 0, min_sz;
+	u32 align_sz = 0, align_h = 4;
+	u32 max_sc_h, max_sc_v;
+
+	/* In JPEG transparent transfer mode cropping is not supported */
+	if (fimc_fmt_is_jpeg(ctx->d_frame.fmt->color)) {
+		r->width  = sink->f_width;
+		r->height = sink->f_height;
+		r->left   = r->top = 0;
+		return;
+	}
+	if (pad == FIMC_SD_PAD_SOURCE) {
+		if (ctx->rotation != 90 && ctx->rotation != 270)
+			align_h = 1;
+		max_sc_h = min(SCALER_MAX_HRATIO, 1 << (ffs(sink->width) - 3));
+		max_sc_v = min(SCALER_MAX_VRATIO, 1 << (ffs(sink->height) - 1));
+		min_sz = var->min_out_pixsize;
+	} else {
+		u32 depth = fimc_get_format_depth(sink->fmt);
+		align_sz = 64/ALIGN(depth, 8);
+		min_sz = var->min_inp_pixsize;
+		min_w = min_h = min_sz;
+		max_sc_h = max_sc_v = 1;
+	}
+	/*
+	 * For the crop rectangle at source pad the following constraints
+	 * must be met:
+	 * - it must fit in the sink pad format rectangle (f_width/f_height);
+	 * - maximum downscaling ratio is 64;
+	 * - maximum crop size depends if the rotator is used or not;
+	 * - the sink pad format width/height must be 4 multiple of the
+	 *   prescaler ratios determined by sink pad size and source pad crop,
+	 *   the prescaler ratio is returned by fimc_get_scaler_factor().
+	 */
+	max_w = min_t(u32,
+		      rotate ? pl->out_rot_en_w : pl->out_rot_dis_w,
+		      rotate ? sink->f_height : sink->f_width);
+	max_h = min_t(u32, FIMC_CAMIF_MAX_HEIGHT, sink->f_height);
+	if (pad == FIMC_SD_PAD_SOURCE) {
+		min_w = min_t(u32, max_w, sink->f_width / max_sc_h);
+		min_h = min_t(u32, max_h, sink->f_height / max_sc_v);
+		if (rotate) {
+			swap(max_sc_h, max_sc_v);
+			swap(min_w, min_h);
+		}
+	}
+	v4l_bound_align_image(&r->width, min_w, max_w, ffs(min_sz) - 1,
+			      &r->height, min_h, max_h, align_h,
+			      align_sz);
+	/* Adjust left/top if cropping rectangle is out of bounds */
+	r->left = clamp_t(u32, r->left, 0, sink->f_width - r->width);
+	r->top  = clamp_t(u32, r->top, 0, sink->f_height - r->height);
+	r->left = round_down(r->left, var->hor_offs_align);
+
+	dbg("pad%d: (%d,%d)/%dx%d, sink fmt: %dx%d",
+	    pad, r->left, r->top, r->width, r->height,
+	    sink->f_width, sink->f_height);
+}
+
+/*
+ * The video node ioctl operations
+ */
 static int fimc_vidioc_querycap_capture(struct file *file, void *priv,
 					struct v4l2_capability *cap)
 {
@@ -424,11 +600,81 @@ static int fimc_cap_enum_fmt_mplane(struct file *file, void *priv,
 	return 0;
 }
 
+/**
+ * fimc_pipeline_try_format - negotiate and/or set formats at pipeline
+ *                            elements
+ * @ctx: FIMC capture context
+ * @tfmt: media bus format to try/set on subdevs
+ * @fmt_id: fimc pixel format id corresponding to returned @tfmt (output)
+ * @set: true to set format on subdevs, false to try only
+ */
+static int fimc_pipeline_try_format(struct fimc_ctx *ctx,
+				    struct v4l2_mbus_framefmt *tfmt,
+				    struct fimc_fmt **fmt_id,
+				    bool set)
+{
+	struct fimc_dev *fimc = ctx->fimc_dev;
+	struct v4l2_subdev *sd = fimc->pipeline.sensor;
+	struct v4l2_subdev *csis = fimc->pipeline.csis;
+	struct v4l2_subdev_format sfmt;
+	struct v4l2_mbus_framefmt *mf = &sfmt.format;
+	struct fimc_fmt *ffmt = NULL;
+	int ret, i = 0;
+
+	if (WARN_ON(!sd || !tfmt))
+		return -EINVAL;
 
+	memset(&sfmt, 0, sizeof(sfmt));
+	sfmt.format = *tfmt;
+
+	sfmt.which = set ? V4L2_SUBDEV_FORMAT_ACTIVE : V4L2_SUBDEV_FORMAT_TRY;
+	while (1) {
+		ffmt = fimc_find_format(NULL, mf->code != 0 ? &mf->code : NULL,
+					FMT_FLAGS_CAM, i++);
+		if (ffmt == NULL) {
+			/*
+			 * Notify user-space if common pixel code for
+			 * host and sensor does not exist.
+			 */
+			return -EINVAL;
+		}
+		mf->code = tfmt->code = ffmt->mbus_code;
 
+		ret = v4l2_subdev_call(sd, pad, set_fmt, NULL, &sfmt);
+		if (ret)
+			return ret;
+		if (mf->code != tfmt->code) {
+			mf->code = 0;
+			continue;
+		}
+		if (mf->width != tfmt->width || mf->width != tfmt->width) {
+			u32 fcc = ffmt->fourcc;
+			tfmt->width  = mf->width;
+			tfmt->height = mf->height;
+			ffmt = fimc_capture_try_format(ctx,
+					       &tfmt->width, &tfmt->height,
+					       NULL, &fcc, FIMC_SD_PAD_SOURCE);
+			if (ffmt && ffmt->mbus_code)
+				mf->code = ffmt->mbus_code;
+			if (mf->width != tfmt->width || mf->width != tfmt->width)
+				continue;
+			tfmt->code = mf->code;
+		}
+		if (csis)
+			ret = v4l2_subdev_call(csis, pad, set_fmt, NULL, &sfmt);
 
+		if (mf->code == tfmt->code &&
+		    mf->width == tfmt->width && mf->width == tfmt->width)
+			break;
+	}
 
+	if (fmt_id && ffmt)
+		*fmt_id = ffmt;
+	*tfmt = *mf;
 
+	dbg("code: 0x%x, %dx%d, %p", mf->code, mf->width, mf->height, ffmt);
+	return 0;
+}
 
 static int fimc_cap_g_fmt_mplane(struct file *file, void *fh,
 				 struct v4l2_format *f)
@@ -445,55 +691,114 @@ static int fimc_cap_g_fmt_mplane(struct file *file, void *fh,
 static int fimc_cap_try_fmt_mplane(struct file *file, void *fh,
 				   struct v4l2_format *f)
 {
+	struct v4l2_pix_format_mplane *pix = &f->fmt.pix_mp;
 	struct fimc_dev *fimc = video_drvdata(file);
 	struct fimc_ctx *ctx = fimc->vid_cap.ctx;
+	struct v4l2_mbus_framefmt mf;
+	struct fimc_fmt *ffmt = NULL;
+
+	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
+		return -EINVAL;
+
+	if (pix->pixelformat == V4L2_PIX_FMT_JPEG) {
+		fimc_capture_try_format(ctx, &pix->width, &pix->height,
+					NULL, &pix->pixelformat,
+					FIMC_SD_PAD_SINK);
+		ctx->s_frame.f_width  = pix->width;
+		ctx->s_frame.f_height = pix->height;
+	}
+	ffmt = fimc_capture_try_format(ctx, &pix->width, &pix->height,
+				       NULL, &pix->pixelformat,
+				       FIMC_SD_PAD_SOURCE);
+	if (!ffmt)
+		return -EINVAL;
+
+	if (!fimc->vid_cap.user_subdev_api) {
+		mf.width  = pix->width;
+		mf.height = pix->height;
+		mf.code   = ffmt->mbus_code;
+		fimc_md_graph_lock(fimc);
+		fimc_pipeline_try_format(ctx, &mf, &ffmt, false);
+		fimc_md_graph_unlock(fimc);
+
+		pix->width	 = mf.width;
+		pix->height	 = mf.height;
+		if (ffmt)
+			pix->pixelformat = ffmt->fourcc;
+	}
 
+	fimc_adjust_mplane_format(ffmt, pix->width, pix->height, pix);
 	return 0;
 }
 
-static int fimc_cap_s_fmt_mplane(struct file *file, void *priv,
-				 struct v4l2_format *f)
+static int fimc_capture_set_format(struct fimc_dev *fimc, struct v4l2_format *f)
 {
-	struct fimc_dev *fimc = video_drvdata(file);
 	struct fimc_ctx *ctx = fimc->vid_cap.ctx;
-	struct v4l2_pix_format_mplane *pix;
-	struct fimc_frame *frame;
-	int ret;
-	int i;
+	struct v4l2_pix_format_mplane *pix = &f->fmt.pix_mp;
+	struct v4l2_mbus_framefmt *mf = &fimc->vid_cap.mf;
+	struct fimc_frame *ff = &ctx->d_frame;
+	struct fimc_fmt *s_fmt = NULL;
+	int ret, i;
 
 	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
 		return -EINVAL;
-
-	if (vb2_is_busy(&fimc->vid_cap.vbq) || fimc_capture_active(fimc))
+	if (vb2_is_busy(&fimc->vid_cap.vbq))
 		return -EBUSY;
 
-	frame = &ctx->d_frame;
-
-	pix = &f->fmt.pix_mp;
-	frame->fmt = fimc_find_format(&pix->pixelformat, NULL,
-				      FMT_FLAGS_M2M | FMT_FLAGS_CAM, 0);
-	if (WARN(frame->fmt == NULL, "Pixel format lookup failed\n"))
+	/* Pre-configure format at camera interface input, for JPEG only */
+	if (pix->pixelformat == V4L2_PIX_FMT_JPEG) {
+		fimc_capture_try_format(ctx, &pix->width, &pix->height,
+					NULL, &pix->pixelformat,
+					FIMC_SD_PAD_SINK);
+		ctx->s_frame.f_width  = pix->width;
+		ctx->s_frame.f_height = pix->height;
+	}
+	/* Try the format at the scaler and the DMA output */
+	ff->fmt = fimc_capture_try_format(ctx, &pix->width, &pix->height,
+					  NULL, &pix->pixelformat,
+					  FIMC_SD_PAD_SOURCE);
+	if (!ff->fmt)
 		return -EINVAL;
-
-	for (i = 0; i < frame->fmt->colplanes; i++) {
-		frame->payload[i] =
-			(pix->width * pix->height * frame->fmt->depth[i]) >> 3;
+	/* Try to match format at the host and the sensor */
+	if (!fimc->vid_cap.user_subdev_api) {
+		mf->code   = ff->fmt->mbus_code;
+		mf->width  = pix->width;
+		mf->height = pix->height;
+
+		fimc_md_graph_lock(fimc);
+		ret = fimc_pipeline_try_format(ctx, mf, &s_fmt, true);
+		fimc_md_graph_unlock(fimc);
+		if (ret)
+			return ret;
+		pix->width  = mf->width;
+		pix->height = mf->height;
+	}
+	fimc_adjust_mplane_format(ff->fmt, pix->width, pix->height, pix);
+	for (i = 0; i < ff->fmt->colplanes; i++)
+		ff->payload[i] =
+			(pix->width * pix->height * ff->fmt->depth[i]) / 8;
+
+	set_frame_bounds(ff, pix->width, pix->height);
+	/* Reset the composition rectangle if not yet configured */
+	if (!(ctx->state & FIMC_DST_CROP))
+		set_frame_crop(ff, 0, 0, pix->width, pix->height);
+
+	/* Reset cropping and set format at the camera interface input */
+	if (!fimc->vid_cap.user_subdev_api) {
+		ctx->s_frame.fmt = s_fmt;
+		set_frame_bounds(&ctx->s_frame, pix->width, pix->height);
+		set_frame_crop(&ctx->s_frame, 0, 0, pix->width, pix->height);
 	}
 
-	/* Output DMA frame pixel size and offsets. */
-	frame->f_width = pix->plane_fmt[0].bytesperline * 8
-			/ frame->fmt->depth[0];
-	frame->f_height = pix->height;
-	frame->width	= pix->width;
-	frame->height	= pix->height;
-	frame->o_width	= pix->width;
-	frame->o_height = pix->height;
-	frame->offs_h	= 0;
-	frame->offs_v	= 0;
+	return ret;
+}
 
-	ctx->state |= (FIMC_PARAMS | FIMC_DST_FMT);
+static int fimc_cap_s_fmt_mplane(struct file *file, void *priv,
+				 struct v4l2_format *f)
+{
+	struct fimc_dev *fimc = video_drvdata(file);
 
-	return ret;
+	return fimc_capture_set_format(fimc, f);
 }
 
 static int fimc_cap_enum_input(struct file *file, void *priv,
@@ -522,22 +827,83 @@ static int fimc_cap_g_input(struct file *file, void *priv, unsigned int *i)
 	return 0;
 }
 
+/**
+ * fimc_pipeline_validate - check for formats inconsistencies
+ *                          between source and sink pad of each link
+ *
+ * Return 0 if all formats match or -EPIPE otherwise.
+ */
+static int fimc_pipeline_validate(struct fimc_dev *fimc)
+{
+	struct v4l2_subdev_format sink_fmt, src_fmt;
+	struct fimc_vid_cap *vid_cap = &fimc->vid_cap;
+	struct v4l2_subdev *sd;
+	struct media_pad *pad;
+	int ret;
+
+	/* Start with the video capture node pad */
+	pad = media_entity_remote_source(&vid_cap->vd_pad);
+	if (pad == NULL)
+		return -EPIPE;
+	/* FIMC.{N} subdevice */
+	sd = media_entity_to_v4l2_subdev(pad->entity);
+
+	while (1) {
+		/* Retrieve format at the sink pad */
+		pad = &sd->entity.pads[0];
+		if (!(pad->flags & MEDIA_PAD_FL_SINK))
+			break;
+		/* Don't call FIMC subdev operation to avoid nested locking */
+		if (sd == fimc->vid_cap.subdev) {
+			struct fimc_frame *ff = &vid_cap->ctx->s_frame;
+			sink_fmt.format.width = ff->f_width;
+			sink_fmt.format.height = ff->f_height;
+			sink_fmt.format.code = ff->fmt ? ff->fmt->mbus_code : 0;
+		} else {
+			sink_fmt.pad = pad->index;
+			sink_fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
+			ret = v4l2_subdev_call(sd, pad, get_fmt, NULL, &sink_fmt);
+			if (ret < 0 && ret != -ENOIOCTLCMD)
+				return -EPIPE;
+		}
+		/* Retrieve format at the source pad */
+		pad = media_entity_remote_source(pad);
+		if (pad == NULL ||
+		    media_entity_type(pad->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
+			break;
+
+		sd = media_entity_to_v4l2_subdev(pad->entity);
+		src_fmt.pad = pad->index;
+		src_fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
+		ret = v4l2_subdev_call(sd, pad, get_fmt, NULL, &src_fmt);
+		if (ret < 0 && ret != -ENOIOCTLCMD)
+			return -EPIPE;
+
+		if (src_fmt.format.width != sink_fmt.format.width ||
+		    src_fmt.format.height != sink_fmt.format.height ||
+		    src_fmt.format.code != sink_fmt.format.code)
+			return -EPIPE;
+	}
+	return 0;
+}
+
 static int fimc_cap_streamon(struct file *file, void *priv,
 			     enum v4l2_buf_type type)
 {
 	struct fimc_dev *fimc = video_drvdata(file);
-	struct fimc_ctx *ctx = fimc->vid_cap.ctx;
 	struct fimc_pipeline *p = &fimc->pipeline;
+	int ret;
 
 	if (fimc_capture_active(fimc))
 		return -EBUSY;
 
-	if (!(ctx->state & FIMC_DST_FMT)) {
-		v4l2_err(fimc->vid_cap.vfd, "Format is not set\n");
-		return -EINVAL;
-	}
 	media_entity_pipeline_start(&p->sensor->entity, p->pipe);
 
+	if (fimc->vid_cap.user_subdev_api) {
+		ret = fimc_pipeline_validate(fimc);
+		if (ret)
+			return ret;
+	}
 	return vb2_streamon(&fimc->vid_cap.vbq, type);
 }
 
@@ -624,35 +990,16 @@ static int fimc_cap_s_crop(struct file *file, void *fh, struct v4l2_crop *cr)
 {
 	struct fimc_dev *fimc = video_drvdata(file);
 	struct fimc_ctx *ctx = fimc->vid_cap.ctx;
-	struct fimc_frame *f;
-	int ret = -EINVAL;
-
-	if (fimc_capture_active(fimc))
-		return -EBUSY;
-
-	ret = fimc_try_crop(ctx, cr);
-	if (ret)
-		return ret;
-
-	if (!(ctx->state & FIMC_DST_FMT)) {
-		v4l2_err(fimc->vid_cap.vfd, "Capture format is not set\n");
-		return -EINVAL;
-	}
+	struct fimc_frame *ff;
+	unsigned long flags;
 
-	f = &ctx->s_frame;
-	/* Check for the pixel scaling ratio when cropping input image. */
-	ret = fimc_check_scaler_ratio(cr->c.width, cr->c.height,
-				      ctx->d_frame.width, ctx->d_frame.height,
-				      ctx->rotation);
-	if (ret) {
-		v4l2_err(fimc->vid_cap.vfd, "Out of the scaler range\n");
-		return ret;
-	}
+	fimc_capture_try_crop(ctx, &cr->c, FIMC_SD_PAD_SINK);
+	ff = &ctx->s_frame;
 
-	f->offs_h = cr->c.left;
-	f->offs_v = cr->c.top;
-	f->width  = cr->c.width;
-	f->height = cr->c.height;
+	spin_lock_irqsave(&fimc->slock, flags);
+	set_frame_crop(ff, cr->c.left, cr->c.top, cr->c.width, cr->c.height);
+	set_bit(ST_CAPT_APPLY_CFG, &fimc->state);
+	spin_unlock_irqrestore(&fimc->slock, flags);
 
 	return 0;
 }
@@ -683,14 +1030,16 @@ static const struct v4l2_ioctl_ops fimc_capture_ioctl_ops = {
 	.vidioc_g_input			= fimc_cap_g_input,
 };
 
-/* Media operations */
+/* Capture subdev media entity operations */
 static int fimc_link_setup(struct media_entity *entity,
 			   const struct media_pad *local,
 			   const struct media_pad *remote, u32 flags)
 {
-	struct video_device *vd = media_entity_to_video_device(entity);
-	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(remote->entity);
-	struct fimc_dev *fimc = video_get_drvdata(vd);
+	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
+	struct fimc_dev *fimc = v4l2_get_subdevdata(sd);
+
+	if (media_entity_type(remote->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
+		return -EINVAL;
 
 	if (WARN_ON(fimc == NULL))
 		return 0;
@@ -710,10 +1059,241 @@ static int fimc_link_setup(struct media_entity *entity,
 	return 0;
 }
 
-static const struct media_entity_operations fimc_media_ops = {
+static const struct media_entity_operations fimc_sd_media_ops = {
 	.link_setup = fimc_link_setup,
 };
 
+static int fimc_subdev_enum_mbus_code(struct v4l2_subdev *sd,
+				      struct v4l2_subdev_fh *fh,
+				      struct v4l2_subdev_mbus_code_enum *code)
+{
+	struct fimc_fmt *fmt;
+
+	fmt = fimc_find_format(NULL, NULL, FMT_FLAGS_CAM, code->index);
+	if (!fmt)
+		return -EINVAL;
+	code->code = fmt->mbus_code;
+	return 0;
+}
+
+static int fimc_subdev_get_fmt(struct v4l2_subdev *sd,
+			       struct v4l2_subdev_fh *fh,
+			       struct v4l2_subdev_format *fmt)
+{
+	struct fimc_dev *fimc = v4l2_get_subdevdata(sd);
+	struct fimc_ctx *ctx = fimc->vid_cap.ctx;
+	struct v4l2_mbus_framefmt *mf;
+	struct fimc_frame *ff;
+
+	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
+		mf = v4l2_subdev_get_try_format(fh, fmt->pad);
+		fmt->format = *mf;
+		return 0;
+	}
+	mf = &fmt->format;
+	mf->colorspace = V4L2_COLORSPACE_JPEG;
+	ff = fmt->pad == FIMC_SD_PAD_SINK ? &ctx->s_frame : &ctx->d_frame;
+
+	mutex_lock(&fimc->lock);
+	/* The pixel code is same on both input and output pad */
+	if (!WARN_ON(ctx->s_frame.fmt == NULL))
+		mf->code = ctx->s_frame.fmt->mbus_code;
+	mf->width  = ff->f_width;
+	mf->height = ff->f_height;
+	mutex_unlock(&fimc->lock);
+
+	return 0;
+}
+
+static int fimc_subdev_set_fmt(struct v4l2_subdev *sd,
+			       struct v4l2_subdev_fh *fh,
+			       struct v4l2_subdev_format *fmt)
+{
+	struct fimc_dev *fimc = v4l2_get_subdevdata(sd);
+	struct v4l2_mbus_framefmt *mf = &fmt->format;
+	struct fimc_ctx *ctx = fimc->vid_cap.ctx;
+	struct fimc_frame *ff;
+	struct fimc_fmt *ffmt;
+
+	dbg("pad%d: code: 0x%x, %dx%d",
+	    fmt->pad, mf->code, mf->width, mf->height);
+
+	if (fmt->pad == FIMC_SD_PAD_SOURCE &&
+	    vb2_is_busy(&fimc->vid_cap.vbq))
+		return -EBUSY;
+
+	mutex_lock(&fimc->lock);
+	ffmt = fimc_capture_try_format(ctx, &mf->width, &mf->height,
+				       &mf->code, NULL, fmt->pad);
+	mutex_unlock(&fimc->lock);
+	mf->colorspace = V4L2_COLORSPACE_JPEG;
+
+	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
+		mf = v4l2_subdev_get_try_format(fh, fmt->pad);
+		*mf = fmt->format;
+		return 0;
+	}
+	ff = fmt->pad == FIMC_SD_PAD_SINK ?
+		&ctx->s_frame : &ctx->d_frame;
+
+	mutex_lock(&fimc->lock);
+	set_frame_bounds(ff, mf->width, mf->height);
+	ff->fmt = ffmt;
+
+	/* Reset the crop rectangle if required. */
+	if (!(fmt->pad == FIMC_SD_PAD_SOURCE && (ctx->state & FIMC_DST_CROP)))
+		set_frame_crop(ff, 0, 0, mf->width, mf->height);
+
+	if (fmt->pad == FIMC_SD_PAD_SINK)
+		ctx->state &= ~FIMC_DST_CROP;
+	mutex_unlock(&fimc->lock);
+	return 0;
+}
+
+static int fimc_subdev_get_crop(struct v4l2_subdev *sd,
+				struct v4l2_subdev_fh *fh,
+				struct v4l2_subdev_crop *crop)
+{
+	struct fimc_dev *fimc = v4l2_get_subdevdata(sd);
+	struct fimc_ctx *ctx = fimc->vid_cap.ctx;
+	struct v4l2_rect *r = &crop->rect;
+	struct fimc_frame *ff;
+
+	if (crop->which == V4L2_SUBDEV_FORMAT_TRY) {
+		crop->rect = *v4l2_subdev_get_try_crop(fh, crop->pad);
+		return 0;
+	}
+	ff = crop->pad == FIMC_SD_PAD_SINK ?
+		&ctx->s_frame : &ctx->d_frame;
+
+	mutex_lock(&fimc->lock);
+	r->left	  = ff->offs_h;
+	r->top	  = ff->offs_v;
+	r->width  = ff->width;
+	r->height = ff->height;
+	mutex_unlock(&fimc->lock);
+
+	dbg("ff:%p, pad%d: l:%d, t:%d, %dx%d, f_w: %d, f_h: %d",
+	    ff, crop->pad, r->left, r->top, r->width, r->height,
+	    ff->f_width, ff->f_height);
+
+	return 0;
+}
+
+static int fimc_subdev_set_crop(struct v4l2_subdev *sd,
+				struct v4l2_subdev_fh *fh,
+				struct v4l2_subdev_crop *crop)
+{
+	struct fimc_dev *fimc = v4l2_get_subdevdata(sd);
+	struct fimc_ctx *ctx = fimc->vid_cap.ctx;
+	struct v4l2_rect *r = &crop->rect;
+	struct fimc_frame *ff;
+	unsigned long flags;
+
+	dbg("(%d,%d)/%dx%d", r->left, r->top, r->width, r->height);
+
+	ff = crop->pad == FIMC_SD_PAD_SOURCE ?
+		&ctx->d_frame : &ctx->s_frame;
+
+	mutex_lock(&fimc->lock);
+	fimc_capture_try_crop(ctx, r, crop->pad);
+
+	if (crop->which == V4L2_SUBDEV_FORMAT_TRY) {
+		mutex_lock(&fimc->lock);
+		*v4l2_subdev_get_try_crop(fh, crop->pad) = *r;
+		return 0;
+	}
+	spin_lock_irqsave(&fimc->slock, flags);
+	set_frame_crop(ff, r->left, r->top, r->width, r->height);
+	if (crop->pad == FIMC_SD_PAD_SOURCE)
+		ctx->state |= FIMC_DST_CROP;
+
+	set_bit(ST_CAPT_APPLY_CFG, &fimc->state);
+	spin_unlock_irqrestore(&fimc->slock, flags);
+
+	dbg("pad%d: (%d,%d)/%dx%d", crop->pad, r->left, r->top,
+	    r->width, r->height);
+
+	mutex_unlock(&fimc->lock);
+	return 0;
+}
+
+static struct v4l2_subdev_pad_ops fimc_subdev_pad_ops = {
+	.enum_mbus_code = fimc_subdev_enum_mbus_code,
+	.get_fmt = fimc_subdev_get_fmt,
+	.set_fmt = fimc_subdev_set_fmt,
+	.get_crop = fimc_subdev_get_crop,
+	.set_crop = fimc_subdev_set_crop,
+};
+
+static struct v4l2_subdev_ops fimc_subdev_ops = {
+	.pad = &fimc_subdev_pad_ops,
+};
+
+static int fimc_create_capture_subdev(struct fimc_dev *fimc,
+				      struct v4l2_device *v4l2_dev)
+{
+	struct v4l2_subdev *sd;
+	int ret;
+
+	sd = kzalloc(sizeof(*sd), GFP_KERNEL);
+	if (!sd)
+		return -ENOMEM;
+
+	v4l2_subdev_init(sd, &fimc_subdev_ops);
+	sd->flags = V4L2_SUBDEV_FL_HAS_DEVNODE;
+	snprintf(sd->name, sizeof(sd->name), "FIMC.%d", fimc->pdev->id);
+
+	fimc->vid_cap.sd_pads[FIMC_SD_PAD_SINK].flags = MEDIA_PAD_FL_SINK;
+	fimc->vid_cap.sd_pads[FIMC_SD_PAD_SOURCE].flags = MEDIA_PAD_FL_SOURCE;
+	ret = media_entity_init(&sd->entity, FIMC_SD_PADS_NUM,
+				fimc->vid_cap.sd_pads, 0);
+	if (ret)
+		goto me_err;
+	ret = v4l2_device_register_subdev(v4l2_dev, sd);
+	if (ret)
+		goto sd_err;
+
+	fimc->vid_cap.subdev = sd;
+	v4l2_set_subdevdata(sd, fimc);
+	sd->entity.ops = &fimc_sd_media_ops;
+	return 0;
+sd_err:
+	media_entity_cleanup(&sd->entity);
+me_err:
+	kfree(sd);
+	return ret;
+}
+
+static void fimc_destroy_capture_subdev(struct fimc_dev *fimc)
+{
+	struct v4l2_subdev *sd = fimc->vid_cap.subdev;
+
+	if (!sd)
+		return;
+	media_entity_cleanup(&sd->entity);
+	v4l2_device_unregister_subdev(sd);
+	kfree(sd);
+	sd = NULL;
+}
+
+/* Set default format at the sensor and host interface */
+static int fimc_capture_set_default_format(struct fimc_dev *fimc)
+{
+	struct v4l2_format fmt = {
+		.type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE,
+		.fmt.pix_mp = {
+			.width		= 640,
+			.height		= 480,
+			.pixelformat	= V4L2_PIX_FMT_YUYV,
+			.field		= V4L2_FIELD_NONE,
+			.colorspace	= V4L2_COLORSPACE_JPEG,
+		},
+	};
+
+	return fimc_capture_set_format(fimc, &fmt);
+}
+
 /* fimc->lock must be already initialized */
 int fimc_register_capture_device(struct fimc_dev *fimc,
 				 struct v4l2_device *v4l2_dev)
@@ -721,7 +1301,6 @@ int fimc_register_capture_device(struct fimc_dev *fimc,
 	struct video_device *vfd;
 	struct fimc_vid_cap *vid_cap;
 	struct fimc_ctx *ctx;
-	struct fimc_frame *fr;
 	struct vb2_queue *q;
 	int ret = -ENOMEM;
 
@@ -733,12 +1312,8 @@ int fimc_register_capture_device(struct fimc_dev *fimc,
 	ctx->in_path	 = FIMC_CAMERA;
 	ctx->out_path	 = FIMC_DMA;
 	ctx->state	 = FIMC_CTX_CAP;
-
-	/* Default format of the output frames */
-	fr = &ctx->d_frame;
-	fr->fmt = fimc_find_format(NULL, NULL, FMT_FLAGS_CAM, 0);
-	fr->width = fr->f_width = fr->o_width = 640;
-	fr->height = fr->f_height = fr->o_height = 480;
+	ctx->s_frame.fmt = fimc_find_format(NULL, NULL, FMT_FLAGS_CAM, 0);
+	ctx->d_frame.fmt = fimc_find_format(NULL, NULL, FMT_FLAGS_CAM, 0);
 
 	vfd = video_device_alloc();
 	if (!vfd) {
@@ -783,11 +1358,15 @@ int fimc_register_capture_device(struct fimc_dev *fimc,
 	ret = media_entity_init(&vfd->entity, 1, &fimc->vid_cap.vd_pad, 0);
 	if (ret)
 		goto err_ent;
+	ret = fimc_create_capture_subdev(fimc, v4l2_dev);
+	if (ret)
+		goto err_sd_reg;
 
-	vfd->entity.ops = &fimc_media_ops;
 	vfd->ctrl_handler = &ctx->ctrl_handler;
 	return 0;
 
+err_sd_reg:
+	media_entity_cleanup(&vfd->entity);
 err_ent:
 	video_device_release(vfd);
 err_vd_alloc:
@@ -805,6 +1384,7 @@ void fimc_unregister_capture_device(struct fimc_dev *fimc)
 		   not registered */
 		video_unregister_device(vfd);
 	}
+	fimc_destroy_capture_subdev(fimc);
 	kfree(fimc->vid_cap.ctx);
 	fimc->vid_cap.ctx = NULL;
 }
diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index 39d4897..ffcccb2 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -372,6 +372,8 @@ static void fimc_capture_irq_handler(struct fimc_dev *fimc)
 		set_bit(ST_CAPT_RUN, &fimc->state);
 	}
 
+	fimc_capture_config_update(cap->ctx);
+
 	dbg("frame: %d, active_buf_cnt: %d",
 	    fimc_hw_get_frame_index(fimc), cap->active_buf_cnt);
 }
@@ -1198,12 +1200,11 @@ static int fimc_m2m_g_crop(struct file *file, void *fh, struct v4l2_crop *cr)
 	return 0;
 }
 
-int fimc_try_crop(struct fimc_ctx *ctx, struct v4l2_crop *cr)
+static int fimc_m2m_try_crop(struct fimc_ctx *ctx, struct v4l2_crop *cr)
 {
 	struct fimc_dev *fimc = ctx->fimc_dev;
 	struct fimc_frame *f;
 	u32 min_size, halign, depth = 0;
-	bool is_capture_ctx;
 	int i;
 
 	if (cr->c.top < 0 || cr->c.left < 0) {
@@ -1211,13 +1212,9 @@ int fimc_try_crop(struct fimc_ctx *ctx, struct v4l2_crop *cr)
 			"doesn't support negative values for top & left\n");
 		return -EINVAL;
 	}
-
-	is_capture_ctx = fimc_ctx_state_is_set(FIMC_CTX_CAP, ctx);
-
 	if (cr->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
-		f = is_capture_ctx ? &ctx->s_frame : &ctx->d_frame;
-	else if (cr->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE &&
-		 !is_capture_ctx)
+		f = &ctx->d_frame;
+	else if (cr->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
 		f = &ctx->s_frame;
 	else
 		return -EINVAL;
@@ -1226,15 +1223,10 @@ int fimc_try_crop(struct fimc_ctx *ctx, struct v4l2_crop *cr)
 		fimc->variant->min_inp_pixsize : fimc->variant->min_out_pixsize;
 
 	/* Get pixel alignment constraints. */
-	if (is_capture_ctx) {
-		min_size = 16;
-		halign = 4;
-	} else {
-		if (fimc->id == 1 && fimc->variant->pix_hoff)
-			halign = fimc_fmt_is_rgb(f->fmt->color) ? 0 : 1;
-		else
-			halign = ffs(min_size) - 1;
-	}
+	if (fimc->id == 1 && fimc->variant->pix_hoff)
+		halign = fimc_fmt_is_rgb(f->fmt->color) ? 0 : 1;
+	else
+		halign = ffs(min_size) - 1;
 
 	for (i = 0; i < f->fmt->colplanes; i++)
 		depth += f->fmt->depth[i];
@@ -1251,7 +1243,7 @@ int fimc_try_crop(struct fimc_ctx *ctx, struct v4l2_crop *cr)
 		cr->c.top = f->o_height - cr->c.height;
 
 	cr->c.left = round_down(cr->c.left, min_size);
-	cr->c.top  = round_down(cr->c.top, is_capture_ctx ? 16 : 8);
+	cr->c.top  = round_down(cr->c.top, fimc->variant->hor_offs_align);
 
 	dbg("l:%d, t:%d, w:%d, h:%d, f_w: %d, f_h: %d",
 	    cr->c.left, cr->c.top, cr->c.width, cr->c.height,
@@ -1267,7 +1259,7 @@ static int fimc_m2m_s_crop(struct file *file, void *fh, struct v4l2_crop *cr)
 	struct fimc_frame *f;
 	int ret;
 
-	ret = fimc_try_crop(ctx, cr);
+	ret = fimc_m2m_try_crop(ctx, cr);
 	if (ret)
 		return ret;
 
diff --git a/drivers/media/video/s5p-fimc/fimc-core.h b/drivers/media/video/s5p-fimc/fimc-core.h
index 2935068..e4520b2 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.h
+++ b/drivers/media/video/s5p-fimc/fimc-core.h
@@ -43,6 +43,7 @@
 #define SCALER_MAX_HRATIO	64
 #define SCALER_MAX_VRATIO	64
 #define DMA_MIN_SIZE		8
+#define FIMC_CAMIF_MAX_HEIGHT	0x2000
 
 /* indices to the clocks array */
 enum {
@@ -92,9 +93,11 @@ enum fimc_color_fmt {
 	S5P_FIMC_CBYCRY422,
 	S5P_FIMC_CRYCBY422,
 	S5P_FIMC_YCBCR444_LOCAL,
+	S5P_FIMC_JPEG = 0x40,
 };
 
-#define fimc_fmt_is_rgb(x) ((x) & 0x10)
+#define fimc_fmt_is_rgb(x) (!!((x) & 0x10))
+#define fimc_fmt_is_jpeg(x) (!!((x) & 0x40))
 
 #define IS_M2M(__strt) ((__strt) == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE || \
 			__strt == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
@@ -116,9 +119,10 @@ enum fimc_color_fmt {
 #define	FIMC_DST_ADDR		(1 << 2)
 #define	FIMC_SRC_FMT		(1 << 3)
 #define	FIMC_DST_FMT		(1 << 4)
-#define	FIMC_CTX_M2M		(1 << 5)
-#define	FIMC_CTX_CAP		(1 << 6)
-#define	FIMC_CTX_SHUT		(1 << 7)
+#define	FIMC_DST_CROP		(1 << 5)
+#define	FIMC_CTX_M2M		(1 << 16)
+#define	FIMC_CTX_CAP		(1 << 17)
+#define	FIMC_CTX_SHUT		(1 << 18)
 
 /* Image conversion flags */
 #define	FIMC_IN_DMA_ACCESS_TILED	(1 << 0)
@@ -293,12 +297,18 @@ struct fimc_m2m_device {
 	int			refcnt;
 };
 
+#define FIMC_SD_PAD_SINK	0
+#define FIMC_SD_PAD_SOURCE	1
+#define FIMC_SD_PADS_NUM	2
+
 /**
  * struct fimc_vid_cap - camera capture device information
  * @ctx: hardware context data
  * @vfd: video device node for camera capture mode
+ * @subdev: subdev exposing the FIMC processing block
  * @vd_pad: fimc video capture node pad
- * @fmt: Media Bus format configured at selected image sensor
+ * @sd_pads: fimc video processing block pads
+ * @mf: media bus format at the FIMC camera input (and the scaler output) pad
  * @pending_buf_q: the pending buffer queue head
  * @active_buf_q: the queue head of buffers scheduled in hardware
  * @vbq: the capture am video buffer queue
@@ -315,8 +325,10 @@ struct fimc_vid_cap {
 	struct fimc_ctx			*ctx;
 	struct vb2_alloc_ctx		*alloc_ctx;
 	struct video_device		*vfd;
+	struct v4l2_subdev		*subdev;
 	struct media_pad		vd_pad;
-	struct v4l2_mbus_framefmt	fmt;
+	struct v4l2_mbus_framefmt	mf;
+	struct media_pad		sd_pads[FIMC_SD_PADS_NUM];
 	struct list_head		pending_buf_q;
 	struct list_head		active_buf_q;
 	struct vb2_queue		vbq;
@@ -498,6 +510,33 @@ struct fimc_ctx {
 
 #define fh_to_ctx(__fh) container_of(__fh, struct fimc_ctx, fh)
 
+static inline void set_frame_bounds(struct fimc_frame *f, u32 width, u32 height)
+{
+	f->o_width  = width;
+	f->o_height = height;
+	f->f_width  = width;
+	f->f_height = height;
+}
+
+static inline void set_frame_crop(struct fimc_frame *f,
+				  u32 left, u32 top, u32 width, u32 height)
+{
+	f->offs_h = left;
+	f->offs_v = top;
+	f->width  = width;
+	f->height = height;
+}
+
+static inline u32 fimc_get_format_depth(struct fimc_fmt *ff)
+{
+	u32 i, depth = 0;
+
+	if (ff != NULL)
+		for (i = 0; i < ff->colplanes; i++)
+			depth += ff->depth[i];
+	return depth;
+}
+
 static inline bool fimc_capture_active(struct fimc_dev *fimc)
 {
 	unsigned long flags;
@@ -649,7 +688,6 @@ int fimc_hw_set_camera_type(struct fimc_dev *fimc,
 /* fimc-core.c */
 int fimc_vidioc_enum_fmt_mplane(struct file *file, void *priv,
 				struct v4l2_fmtdesc *f);
-int fimc_try_crop(struct fimc_ctx *ctx, struct v4l2_crop *cr);
 int fimc_ctrls_create(struct fimc_ctx *ctx);
 void fimc_ctrls_delete(struct fimc_ctx *ctx);
 void fimc_ctrls_activate(struct fimc_ctx *ctx, bool active);
@@ -684,6 +722,7 @@ int fimc_vid_cap_buf_queue(struct fimc_dev *fimc,
 			     struct fimc_vid_buffer *fimc_vb);
 int fimc_capture_suspend(struct fimc_dev *fimc);
 int fimc_capture_resume(struct fimc_dev *fimc);
+int fimc_capture_config_update(struct fimc_ctx *ctx);
 
 /* Locking: the caller holds fimc->slock */
 static inline void fimc_activate_capture(struct fimc_ctx *ctx)
diff --git a/drivers/media/video/s5p-fimc/fimc-mdevice.c b/drivers/media/video/s5p-fimc/fimc-mdevice.c
index 5bb2c0d..6fb19c0 100644
--- a/drivers/media/video/s5p-fimc/fimc-mdevice.c
+++ b/drivers/media/video/s5p-fimc/fimc-mdevice.c
@@ -430,11 +430,19 @@ static int __fimc_md_create_fimc_links(struct fimc_md *fmd,
 			continue;
 
 		flags = (i == fimc_id) ? MEDIA_LNK_FL_ENABLED : 0;
-		sink = &fmd->fimc[i]->vid_cap.vfd->entity;
-		ret = media_entity_create_link(source, 0, sink, 0, flags);
+		sink = &fmd->fimc[i]->vid_cap.subdev->entity;
+		ret = media_entity_create_link(source, pad, sink,
+					      FIMC_SD_PAD_SINK, flags);
 		if (ret)
 			return ret;
 
+		/* Notify FIMC capture subdev entity */
+		src_pad = sensor ? 0 : CSIS_PAD_SOURCE;
+		ret = media_entity_call(sink, link_setup, &sink->pads[0],
+					&source->pads[src_pad], flags);
+		if (ret)
+			break;
+
 		v4l2_info(&fmd->v4l2_dev, "created link [%s] %c> [%s]",
 			  source->name, flags ? '=' : '-', sink->name);
 
@@ -468,10 +476,10 @@ static int fimc_md_create_links(struct fimc_md *fmd)
 	struct v4l2_subdev *sensor, *csis;
 	struct s5p_fimc_isp_info *pdata;
 	struct fimc_sensor_info *s_info;
-	struct media_entity *source;
-	int fimc_id = 0;
-	int i, pad;
+	struct media_entity *source, *sink;
+	int i, pad, fimc_id = 0;
 	int ret = 0;
+	u32 flags;
 
 	for (i = 0; i < fmd->num_sensors; i++) {
 		if (fmd->sensor[i].subdev == NULL)
@@ -528,6 +536,19 @@ static int fimc_md_create_links(struct fimc_md *fmd)
 		ret = __fimc_md_create_fimc_links(fmd, source, sensor, pad,
 						 fimc_id++);
 	}
+	/* Create immutable links between each FIMC's subdev and video node */
+	flags = MEDIA_LNK_FL_IMMUTABLE | MEDIA_LNK_FL_ENABLED;
+	for (i = 0; i < FIMC_MAX_DEVS; i++) {
+		if (!fmd->fimc[i])
+			continue;
+		source = &fmd->fimc[i]->vid_cap.subdev->entity;
+		sink = &fmd->fimc[i]->vid_cap.vfd->entity;
+		ret = media_entity_create_link(source, FIMC_SD_PAD_SOURCE,
+					      sink, 0, flags);
+		if (ret)
+			break;
+	}
+
 	return ret;
 }
 
@@ -636,15 +657,15 @@ int fimc_md_set_camclk(struct v4l2_subdev *sd, bool on)
 static int fimc_md_link_notify(struct media_pad *source,
 			       struct media_pad *sink, u32 flags)
 {
-	struct video_device *vid_dev;
+	struct v4l2_subdev *sd;
 	struct fimc_dev *fimc;
 	int ret = 0;
 
-	if (WARN_ON(media_entity_type(sink->entity) != MEDIA_ENT_T_DEVNODE))
+	if (media_entity_type(sink->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
 		return 0;
 
-	vid_dev = media_entity_to_video_device(sink->entity);
-	fimc = video_get_drvdata(vid_dev);
+	sd = media_entity_to_v4l2_subdev(sink->entity);
+	fimc = v4l2_get_subdevdata(sd);
 
 	if (!(flags & MEDIA_LNK_FL_ENABLED)) {
 		ret = __fimc_pipeline_shutdown(fimc);
diff --git a/drivers/media/video/s5p-fimc/fimc-reg.c b/drivers/media/video/s5p-fimc/fimc-reg.c
index 50937b4..a1fff02 100644
--- a/drivers/media/video/s5p-fimc/fimc-reg.c
+++ b/drivers/media/video/s5p-fimc/fimc-reg.c
@@ -572,7 +572,7 @@ int fimc_hw_set_camera_source(struct fimc_dev *fimc,
 
 	if (cam->bus_type == FIMC_ITU_601 || cam->bus_type == FIMC_ITU_656) {
 		for (i = 0; i < ARRAY_SIZE(pix_desc); i++) {
-			if (fimc->vid_cap.fmt.code == pix_desc[i].pixelcode) {
+			if (fimc->vid_cap.mf.code == pix_desc[i].pixelcode) {
 				cfg = pix_desc[i].cisrcfmt;
 				bus_width = pix_desc[i].bus_width;
 				break;
@@ -582,7 +582,7 @@ int fimc_hw_set_camera_source(struct fimc_dev *fimc,
 		if (i == ARRAY_SIZE(pix_desc)) {
 			v4l2_err(fimc->vid_cap.vfd,
 				 "Camera color format not supported: %d\n",
-				 fimc->vid_cap.fmt.code);
+				 fimc->vid_cap.mf.code);
 			return -EINVAL;
 		}
 
@@ -642,12 +642,12 @@ int fimc_hw_set_camera_type(struct fimc_dev *fimc,
 			cfg |= S5P_CIGCTRL_SELCAM_MIPI_A;
 
 		/* TODO: add remaining supported formats. */
-		if (vid_cap->fmt.code == V4L2_MBUS_FMT_VYUY8_2X8) {
+		if (vid_cap->mf.code == V4L2_MBUS_FMT_VYUY8_2X8) {
 			tmp = S5P_CSIIMGFMT_YCBCR422_8BIT;
 		} else {
 			v4l2_err(fimc->vid_cap.vfd,
 				 "Not supported camera pixel format: %d",
-				 vid_cap->fmt.code);
+				 vid_cap->mf.code);
 			return -EINVAL;
 		}
 		tmp |= (cam->csi_data_align == 32) << 8;
-- 
1.7.6

