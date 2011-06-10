Return-path: <mchehab@pedra>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:41974 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758041Ab1FJShO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jun 2011 14:37:14 -0400
Date: Fri, 10 Jun 2011 20:36:56 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH/RFC 15/19] s5p-fimc: Add a subdev for the FIMC processing block
In-reply-to: <1307731020-7100-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: hans.verkuil@cisco.com, laurent.pinchart@ideasonboard.com,
	m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com, sw0312.kim@samsung.com,
	riverful.kim@samsung.com
Message-id: <1307731020-7100-16-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1307731020-7100-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This subdev interface exposes the internal scaler and color converter
functionality to user space. Resolution and media bus format can now
be configured explicitly by applications. Camera frame composition
onto the output buffer can be confgured through set/get_crop at FIMC.{n}
source pad. Additionally crop, controls and composition may be
reconfigured while streaming.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-capture.c |  463 ++++++++++++++++++++++++++-
 drivers/media/video/s5p-fimc/fimc-core.c    |    4 +
 drivers/media/video/s5p-fimc/fimc-core.h    |   33 ++-
 drivers/media/video/s5p-fimc/fimc-mdevice.c |   32 ++-
 4 files changed, 512 insertions(+), 20 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index e1b1d12..f3efdbf 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -68,6 +68,7 @@ static int fimc_start_capture(struct fimc_dev *fimc)
 		fimc_hw_set_effect(ctx);
 		fimc_hw_set_output_path(ctx);
 		fimc_hw_set_out_dma(ctx);
+		clear_bit(ST_CAPT_APPLY_CFG, &fimc->state);
 	}
 	spin_unlock_irqrestore(&fimc->slock, flags);
 	return ret;
@@ -127,6 +128,33 @@ int fimc_capture_resume(struct fimc_dev *fimc)
 	return 0;
 }
 
+/**
+ * fimc_capture_config_update - apply the camera interface configuration
+ *
+ * To be called from within the interrupt handler with fimc.slock
+ * spinlock held. Camera pixel crop, rotation and image flip state will
+ * be updated in the H/W.
+ */
+int fimc_capture_config_update(struct fimc_ctx *ctx)
+{
+	struct fimc_dev *fimc = ctx->fimc_dev;
+	int ret;
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
+	}
+	spin_unlock(&ctx->slock);
+	return ret;
+}
+
 static int start_streaming(struct vb2_queue *q)
 {
 	struct fimc_ctx *ctx = q->drv_priv;
@@ -443,7 +471,7 @@ static int fimc_pipeline_try_or_set_fmt(struct fimc_ctx *ctx,
 	while (ff->fmt->mbus_code != mf->code) {
 		if (mf->code != -1) {
 			ffmt = fimc_find_format(NULL, NULL, FMT_FLAGS_CAM, i++);
-			if(!ffmt)
+			if (!ffmt)
 				return -EINVAL;
 		} else {
 			ffmt = ff->fmt;
@@ -532,7 +560,7 @@ static int fimc_cap_s_fmt_mplane(struct file *file, void *priv,
 	ret = fimc_pipeline_try_or_set_fmt(ctx, frame, mf);
 	fimc_md_graph_unlock(fimc);
 	if (!ret) {
-		frame 		= &ctx->s_frame;
+		frame		= &ctx->s_frame;
 		frame->f_width	= mf->width;
 		frame->f_height	= mf->height;
 		frame->o_width	= mf->width;
@@ -571,12 +599,69 @@ static int fimc_cap_g_input(struct file *file, void *priv, unsigned int *i)
 	return 0;
 }
 
+/**
+ * fimc_pipeline_validate - check for formats inconsistencies on all links ends
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
+		/* Don't call FIMC subdev operation to avoid a deadlock */
+		if (sd == fimc->vid_cap.subdev) {
+			sink_fmt.format.width = vid_cap->ctx->s_frame.f_width;
+			sink_fmt.format.height = vid_cap->ctx->s_frame.f_height;
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
+		    src_fmt.format.height != sink_fmt.format.height)
+			return -EPIPE;
+	}
+	return 0;
+}
+
 static int fimc_cap_streamon(struct file *file, void *priv,
 			     enum v4l2_buf_type type)
 {
 	struct fimc_dev *fimc = video_drvdata(file);
 	struct fimc_ctx *ctx = fimc->vid_cap.ctx;
 	struct fimc_pipeline *p = &fimc->pipeline;
+	int ret;
 
 	if (fimc_capture_active(fimc))
 		return -EBUSY;
@@ -587,6 +672,11 @@ static int fimc_cap_streamon(struct file *file, void *priv,
 	}
 	media_entity_pipeline_start(&p->sensor->entity, p->pipe);
 
+	if (subdev_has_devnode(p->sensor)) {
+		ret = fimc_pipeline_validate(fimc);
+		if (ret)
+			return ret;
+	}
 	return vb2_streamon(&fimc->vid_cap.vbq, type);
 }
 
@@ -674,6 +764,7 @@ static int fimc_cap_s_crop(struct file *file, void *fh, struct v4l2_crop *cr)
 	struct fimc_dev *fimc = video_drvdata(file);
 	struct fimc_ctx *ctx = fimc->vid_cap.ctx;
 	struct fimc_frame *f;
+	unsigned long flags;
 	int ret = -EINVAL;
 
 	if (fimc_capture_active(fimc))
@@ -697,12 +788,15 @@ static int fimc_cap_s_crop(struct file *file, void *fh, struct v4l2_crop *cr)
 		v4l2_err(fimc->vid_cap.vfd, "Out of the scaler range\n");
 		return ret;
 	}
+	spin_lock_irqsave(&fimc->slock, flags);
 
 	f->offs_h = cr->c.left;
 	f->offs_v = cr->c.top;
 	f->width  = cr->c.width;
 	f->height = cr->c.height;
 
+	set_bit(ST_CAPT_APPLY_CFG, &fimc->state);
+	spin_unlock_irqrestore(&fimc->slock, flags);
 	return 0;
 }
 
@@ -763,6 +857,358 @@ static const struct media_entity_operations fimc_media_ops = {
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
+	if (!WARN_ON(ctx->d_frame.fmt == NULL))
+		mf->code = ctx->d_frame.fmt->mbus_code;
+	mf->width  = ff->f_width;
+	mf->height = ff->f_height;
+	mutex_unlock(&fimc->lock);
+
+	return 0;
+}
+
+static struct fimc_fmt *fimc_capture_try_format(struct fimc_ctx *ctx,
+						struct v4l2_mbus_framefmt *mf,
+						int pad)
+{
+	bool rotation = ctx->rotation == 90 || ctx->rotation == 270;
+	struct fimc_dev *fimc = ctx->fimc_dev;
+	struct samsung_fimc_variant *var = fimc->variant;
+	struct fimc_pix_limit *pl = var->pix_limit;
+	struct fimc_frame *dst = &ctx->d_frame;
+	struct fimc_fmt *ffmt;
+	u32 depth, min_w, max_w, min_h;
+
+	/* Color conversion from/to JPEG is not supported */
+	if (pad == FIMC_SD_PAD_SOURCE &&
+	    fimc_fmt_is_jpeg(ctx->s_frame.fmt->color))
+		mf->code = V4L2_MBUS_FMT_JPEG_1X8;
+
+	ffmt = fimc_find_format(NULL, mf, FMT_FLAGS_CAM, 0);
+	if (WARN_ON(!ffmt))
+		return NULL;
+	mf->code = ffmt->mbus_code;
+	if (pad == FIMC_SD_PAD_SINK) {
+		max_w = fimc_fmt_is_jpeg(ffmt->color) ?
+			pl->scaler_dis_w : pl->scaler_en_w;
+		/* Apply the camera input interface pixel constraints */
+		v4l_bound_align_image(&mf->width, 32, max_w, 4,
+				      &mf->height, 32, FIMC_CAMIF_MAX_HEIGHT, 1,
+				      0);
+		return ffmt;
+	}
+	/* Can't scale or crop in transparent (JPEG) transfer mode */
+	if (fimc_fmt_is_jpeg(ffmt->color)) {
+		mf->width  = ctx->s_frame.f_width;
+		mf->height = ctx->s_frame.f_height;
+		return 0;
+	}
+	/* Apply the scaler and the output DMA constraints */
+	max_w = rotation ? pl->out_rot_en_w : pl->out_rot_dis_w;
+	min_w = ctx->state & FIMC_DST_CROP ? dst->width : var->min_out_pixsize;
+	min_h = ctx->state & FIMC_DST_CROP ? dst->height : var->min_out_pixsize;
+
+	depth = fimc_get_format_depth(ffmt);
+	v4l_bound_align_image(&mf->width, min_w, max_w,
+			      ffs(var->min_out_pixsize) - 1,
+			      &mf->height, min_h, FIMC_CAMIF_MAX_HEIGHT,
+			      ffs(var->min_out_pixsize) - 1,
+			      64/(ALIGN(depth, 8)));
+	mf->colorspace = V4L2_COLORSPACE_JPEG;
+
+	dbg("pad%d: code: 0x%x, %dx%d. dst fmt: %dx%d",
+	    pad, mf->code, mf->width, mf->height,
+	    dst->f_width, dst->f_height);
+
+	return ffmt;
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
+	ffmt = fimc_capture_try_format(ctx, mf, fmt->pad);
+	mutex_unlock(&fimc->lock);
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
+	ff->f_width	= mf->width;
+	ff->f_height	= mf->height;
+	ff->fmt		= ffmt;
+	/* Reset the crop rectangle if required. */
+	if (!(fmt->pad == FIMC_SD_PAD_SOURCE &&
+	      (ctx->state & FIMC_DST_CROP))) {
+		ff->width    = mf->width;
+		ff->height   = mf->height;
+		ff->o_width  = mf->width;
+		ff->o_height = mf->height;
+		ff->offs_h   = ff->offs_v = 0;
+	}
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
+static int fimc_capture_try_crop(struct fimc_ctx *ctx, struct v4l2_rect *r,
+				 int pad)
+{
+	bool rotate = ctx->rotation == 90 || ctx->rotation == 270;
+	struct fimc_dev *fimc = ctx->fimc_dev;
+	struct samsung_fimc_variant *var = fimc->variant;
+	struct fimc_pix_limit *pl = var->pix_limit;
+	struct fimc_frame *sink = &ctx->s_frame;
+	u32 align_sz = 0, align_h = 4;
+	u32 max_w, max_h, min_w, min_h;
+	u32 min_sz;
+
+	/* In JPEG transparent transfer mode cropping is not supported */
+	if (fimc_fmt_is_jpeg(sink->fmt->color)) {
+		r->width  = sink->f_width;
+		r->height = sink->f_height;
+		r->left   = r->top = 0;
+		return 0;
+	}
+	if (pad == FIMC_SD_PAD_SOURCE) {
+		if (ctx->rotation != 90 && ctx->rotation != 270)
+			align_h = 1;
+		min_sz = var->min_out_pixsize;
+	} else {
+		u32 depth = fimc_get_format_depth(sink->fmt);
+		align_sz = 64/ALIGN(depth, 8);
+		min_sz = var->min_inp_pixsize;
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
+	min_w = min_t(u32, max_w, sink->f_width / SCALER_MAX_HRATIO);
+	min_h = min_t(u32, max_h, sink->f_height / SCALER_MAX_VRATIO);
+	if (rotate && pad == FIMC_SD_PAD_SOURCE)
+		swap(min_w, min_h);
+
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
+	ff->offs_h = r->left;
+	ff->offs_v = r->top;
+	ff->width  = r->width;
+	ff->height = r->height;
+
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
+	sd->owner = THIS_MODULE;
+	sd->flags = V4L2_SUBDEV_FL_HAS_DEVNODE;
+	snprintf(sd->name, sizeof(sd->name), "FIMC.%d", fimc->pdev->id);
+
+	fimc->vid_cap.sd_pads[FIMC_SD_PAD_SINK].flags = MEDIA_PAD_FL_SINK;
+	fimc->vid_cap.sd_pads[FIMC_SD_PAD_SOURCE].flags = MEDIA_PAD_FL_SOURCE;
+	ret = media_entity_init(&sd->entity, FIMC_SD_PADS_NUM,
+				fimc->vid_cap.sd_pads, 0);
+	if (ret)
+		goto error;
+	ret = v4l2_device_register_subdev(v4l2_dev, sd);
+	if (!ret) {
+		fimc->vid_cap.subdev = sd;
+		v4l2_set_subdevdata(sd, fimc);
+		return 0;
+	}
+	media_entity_cleanup(&sd->entity);
+error:
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
+}
+
+/* Set default format at the camera input, scaler and the output DMA */
+static void fimc_cap_set_default_fmt(struct fimc_ctx *ctx)
+{
+	struct fimc_fmt *fmt = fimc_find_format(NULL, NULL, FMT_FLAGS_CAM, 0);
+	struct fimc_frame *fr = &ctx->s_frame;
+
+	fr->fmt = fmt;
+	fr->o_width = fr->f_width = fr->width = 640;
+	fr->o_height = fr->f_height = fr->width = 480;
+
+	fr = &ctx->d_frame;
+	fr->fmt = fmt;
+	fr->o_width = fr->f_width = fr->width = 640;
+	fr->o_height = fr->f_height = fr->width = 480;
+}
+
 /* fimc->lock must be already initialized */
 int fimc_register_capture_device(struct fimc_dev *fimc,
 				 struct v4l2_device *v4l2_dev)
@@ -770,7 +1216,6 @@ int fimc_register_capture_device(struct fimc_dev *fimc,
 	struct video_device *vfd;
 	struct fimc_vid_cap *vid_cap;
 	struct fimc_ctx *ctx;
-	struct fimc_frame *fr;
 	struct vb2_queue *q;
 	int ret = -ENOMEM;
 
@@ -783,11 +1228,7 @@ int fimc_register_capture_device(struct fimc_dev *fimc,
 	ctx->out_path	 = FIMC_DMA;
 	ctx->state	 = FIMC_CTX_CAP;
 
-	/* Default format of the output frames */
-	fr = &ctx->d_frame;
-	fr->fmt = fimc_find_format(NULL, NULL, FMT_FLAGS_CAM, 0);
-	fr->width = fr->f_width = fr->o_width = 640;
-	fr->height = fr->f_height = fr->o_height = 480;
+	fimc_cap_set_default_fmt(ctx);
 
 	vfd = video_device_alloc();
 	if (!vfd) {
@@ -832,6 +1273,9 @@ int fimc_register_capture_device(struct fimc_dev *fimc,
 	ret = media_entity_init(&vfd->entity, 1, &fimc->vid_cap.vd_pad, 0);
 	if (ret)
 		goto err_ent;
+	ret = fimc_create_capture_subdev(fimc, v4l2_dev);
+	if (ret)
+		goto err_sd_reg;
 
 	vfd->entity.ops = &fimc_media_ops;
 	vfd->ctrl_handler = &ctx->ctrl_handler;
@@ -846,6 +1290,8 @@ int fimc_register_capture_device(struct fimc_dev *fimc,
 	return 0;
 
 err_vd_reg:
+	fimc_destroy_capture_subdev(fimc);
+err_sd_reg:
 	media_entity_cleanup(&vfd->entity);
 err_ent:
 	video_device_release(vfd);
@@ -862,5 +1308,6 @@ void fimc_unregister_capture_device(struct fimc_dev *fimc)
 		media_entity_cleanup(&vfd->entity);
 		video_unregister_device(vfd);
 	}
+	fimc_destroy_capture_subdev(fimc);
 	kfree(fimc->vid_cap.ctx);
 }
diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index e944fc4..6d5d3e1 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -361,6 +361,10 @@ void fimc_capture_irq_handler(struct fimc_dev *fimc)
 	} else {
 		set_bit(ST_CAPT_RUN, &fimc->state);
 	}
+	if (test_bit(ST_CAPT_APPLY_CFG, &fimc->state)) {
+		if (fimc_capture_config_update(cap->ctx) == 0)
+			clear_bit(ST_CAPT_APPLY_CFG, &fimc->state);
+	}
 
 	dbg("frame: %d, active_buf_cnt: %d",
 	    fimc_hw_get_frame_index(fimc), cap->active_buf_cnt);
diff --git a/drivers/media/video/s5p-fimc/fimc-core.h b/drivers/media/video/s5p-fimc/fimc-core.h
index 57d347f..3a388b0 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.h
+++ b/drivers/media/video/s5p-fimc/fimc-core.h
@@ -93,9 +93,11 @@ enum fimc_color_fmt {
 	S5P_FIMC_CBYCRY422,
 	S5P_FIMC_CRYCBY422,
 	S5P_FIMC_YCBCR444_LOCAL,
+	S5P_FIMC_JPEG = 0x40,
 };
 
-#define fimc_fmt_is_rgb(x) ((x) & 0x10)
+#define fimc_fmt_is_rgb(x) (!!((x) & 0x10))
+#define fimc_fmt_is_jpeg(x) (!!((x) & 0x40))
 
 /* Cb/Cr chrominance components order for 2 plane Y/CbCr 4:2:2 formats. */
 #define	S5P_FIMC_LSB_CRCB	S5P_CIOCTRL_ORDER422_2P_LSB_CRCB
@@ -114,9 +116,11 @@ enum fimc_color_fmt {
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
+
 
 /* Image conversion flags */
 #define	FIMC_IN_DMA_ACCESS_TILED	(1 << 0)
@@ -291,12 +295,18 @@ struct fimc_m2m_device {
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
+ * @mf: media bus format at the FIMC camera input (and the DMA output) pad
  * @pending_buf_q: the pending buffer queue head
  * @active_buf_q: the queue head of buffers scheduled in hardware
  * @vbq: the capture am video buffer queue
@@ -312,8 +322,10 @@ struct fimc_vid_cap {
 	struct fimc_ctx			*ctx;
 	struct vb2_alloc_ctx		*alloc_ctx;
 	struct video_device		*vfd;
+	struct v4l2_subdev		*subdev;
 	struct media_pad		vd_pad;
 	struct v4l2_mbus_framefmt	mf;
+	struct media_pad		sd_pads[FIMC_SD_PADS_NUM];
 	struct list_head		pending_buf_q;
 	struct list_head		active_buf_q;
 	struct vb2_queue		vbq;
@@ -492,6 +504,16 @@ struct fimc_ctx {
 
 #define fh_to_ctx(__fh) container_of(__fh, struct fimc_ctx, fh)
 
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
@@ -677,6 +699,7 @@ int fimc_vid_cap_buf_queue(struct fimc_dev *fimc,
 			     struct fimc_vid_buffer *fimc_vb);
 int fimc_capture_suspend(struct fimc_dev *fimc);
 int fimc_capture_resume(struct fimc_dev *fimc);
+int fimc_capture_config_update(struct fimc_ctx *ctx);
 
 /* Locking: the caller holds fimc->slock */
 static inline void fimc_activate_capture(struct fimc_ctx *ctx)
diff --git a/drivers/media/video/s5p-fimc/fimc-mdevice.c b/drivers/media/video/s5p-fimc/fimc-mdevice.c
index 0b46fe7..38ed74c 100644
--- a/drivers/media/video/s5p-fimc/fimc-mdevice.c
+++ b/drivers/media/video/s5p-fimc/fimc-mdevice.c
@@ -383,9 +383,11 @@ static int __fimc_md_create_fimc_links(struct fimc_md *fmd,
 	for (i = 0; i < FIMC_MAX_DEVS; i++) {
 		if (fmd->fimc[i] == NULL)
 			break;
+
 		flags = (i == fimc_id) ? MEDIA_LNK_FL_ENABLED : 0;
-		sink = &fmd->fimc[i]->vid_cap.vfd->entity;
-		rc = media_entity_create_link(source, 0, sink, 0, flags);
+		sink = &fmd->fimc[i]->vid_cap.subdev->entity;
+		rc = media_entity_create_link(source, pad, sink,
+					      FIMC_SD_PAD_SINK, flags);
 		if (rc)
 			return rc;
 
@@ -422,7 +424,7 @@ static int fimc_md_create_links(struct fimc_md *fmd)
 	struct v4l2_subdev *sensor, *csis;
 	struct s5p_fimc_isp_info *pdata;
 	struct fimc_sensor_info *s_info;
-	struct media_entity *source;
+	struct media_entity *source, *sink;
 	int fimc_id = 0;
 	int i, pad;
 	int rc = 0;
@@ -481,6 +483,22 @@ static int fimc_md_create_links(struct fimc_md *fmd)
 		rc = __fimc_md_create_fimc_links(fmd, source, sensor, pad,
 						 fimc_id++);
 	}
+
+	for (i = 0; i < FIMC_MAX_DEVS; i++) {
+		u32 flags = MEDIA_LNK_FL_IMMUTABLE | MEDIA_LNK_FL_ENABLED;
+		source = &fmd->fimc[i]->vid_cap.subdev->entity;
+		sink = &fmd->fimc[i]->vid_cap.vfd->entity;
+		rc = media_entity_create_link(source, FIMC_SD_PAD_SOURCE,
+					      sink, 0, flags);
+		if (rc)
+			break;
+		/* Notify fimc.capture entity */
+		rc = media_entity_call(sink, link_setup, &sink->pads[0],
+				&source->pads[FIMC_SD_PAD_SOURCE], flags);
+		if (rc)
+			break;
+	}
+
 	return rc;
 }
 
@@ -588,15 +606,15 @@ int fimc_md_configure_cam_clock(struct v4l2_subdev *sd, bool on)
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
-- 
1.7.5.4

