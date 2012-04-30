Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:43119 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354Ab2D3Okk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Apr 2012 10:40:40 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt2 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M3A00LO7RG0CX30@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 30 Apr 2012 15:40:48 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M3A000KVRFLK0@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 30 Apr 2012 15:40:36 +0100 (BST)
Date: Mon, 30 Apr 2012 16:40:33 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH] s5p-fimc: Use selection API in place of crop operations
To: linux-media@vger.kernel.org
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kuyngmin Park <kyungmin.park@samsung.com>
Message-id: <1335796833-30909-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace deprecated crop operations with the selection API.
Original crop ioctls are supported through a compatibility
layer at the v4l2 core.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kuyngmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-capture.c |  176 ++++++++++++++++-----------
 drivers/media/video/s5p-fimc/fimc-core.h    |    2 +-
 2 files changed, 109 insertions(+), 69 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index e7d9833..4550713 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -615,8 +615,13 @@ static struct fimc_fmt *fimc_capture_try_format(struct fimc_ctx *ctx,
 	}
 	/* Apply the scaler and the output DMA constraints */
 	max_w = rotation ? pl->out_rot_en_w : pl->out_rot_dis_w;
-	min_w = ctx->state & FIMC_DST_CROP ? dst->width : var->min_out_pixsize;
-	min_h = ctx->state & FIMC_DST_CROP ? dst->height : var->min_out_pixsize;
+	if (ctx->state & FIMC_COMPOSE) {
+		min_w = dst->offs_h + dst->width;
+		min_h = dst->offs_v + dst->height;
+	} else {
+		min_w = var->min_out_pixsize;
+		min_h = var->min_out_pixsize;
+	}
 	if (var->min_vsize_align == 1 && !rotation)
 		align_h = fimc_fmt_is_rgb(ffmt->color) ? 0 : 1;
 
@@ -634,8 +639,9 @@ static struct fimc_fmt *fimc_capture_try_format(struct fimc_ctx *ctx,
 	return ffmt;
 }
 
-static void fimc_capture_try_crop(struct fimc_ctx *ctx, struct v4l2_rect *r,
-				  int pad)
+static void fimc_capture_try_selection(struct fimc_ctx *ctx,
+				       struct v4l2_rect *r,
+				       int target)
 {
 	bool rotate = ctx->rotation == 90 || ctx->rotation == 270;
 	struct fimc_dev *fimc = ctx->fimc_dev;
@@ -653,7 +659,7 @@ static void fimc_capture_try_crop(struct fimc_ctx *ctx, struct v4l2_rect *r,
 		r->left   = r->top = 0;
 		return;
 	}
-	if (pad == FIMC_SD_PAD_SOURCE) {
+	if (target == V4L2_SEL_TGT_COMPOSE_ACTIVE) {
 		if (ctx->rotation != 90 && ctx->rotation != 270)
 			align_h = 1;
 		max_sc_h = min(SCALER_MAX_HRATIO, 1 << (ffs(sink->width) - 3));
@@ -667,8 +673,7 @@ static void fimc_capture_try_crop(struct fimc_ctx *ctx, struct v4l2_rect *r,
 		max_sc_h = max_sc_v = 1;
 	}
 	/*
-	 * For the crop rectangle at source pad the following constraints
-	 * must be met:
+	 * For the compose rectangle the following constraints must be met:
 	 * - it must fit in the sink pad format rectangle (f_width/f_height);
 	 * - maximum downscaling ratio is 64;
 	 * - maximum crop size depends if the rotator is used or not;
@@ -680,7 +685,8 @@ static void fimc_capture_try_crop(struct fimc_ctx *ctx, struct v4l2_rect *r,
 		      rotate ? pl->out_rot_en_w : pl->out_rot_dis_w,
 		      rotate ? sink->f_height : sink->f_width);
 	max_h = min_t(u32, FIMC_CAMIF_MAX_HEIGHT, sink->f_height);
-	if (pad == FIMC_SD_PAD_SOURCE) {
+
+	if (target == V4L2_SEL_TGT_COMPOSE_ACTIVE) {
 		min_w = min_t(u32, max_w, sink->f_width / max_sc_h);
 		min_h = min_t(u32, max_h, sink->f_height / max_sc_v);
 		if (rotate) {
@@ -691,13 +697,13 @@ static void fimc_capture_try_crop(struct fimc_ctx *ctx, struct v4l2_rect *r,
 	v4l_bound_align_image(&r->width, min_w, max_w, ffs(min_sz) - 1,
 			      &r->height, min_h, max_h, align_h,
 			      align_sz);
-	/* Adjust left/top if cropping rectangle is out of bounds */
+	/* Adjust left/top if crop/compose rectangle is out of bounds */
 	r->left = clamp_t(u32, r->left, 0, sink->f_width - r->width);
 	r->top  = clamp_t(u32, r->top, 0, sink->f_height - r->height);
 	r->left = round_down(r->left, var->hor_offs_align);
 
-	dbg("pad%d: (%d,%d)/%dx%d, sink fmt: %dx%d",
-	    pad, r->left, r->top, r->width, r->height,
+	dbg("target %#x: (%d,%d)/%dx%d, sink fmt: %dx%d",
+	    target, r->left, r->top, r->width, r->height,
 	    sink->f_width, sink->f_height);
 }
 
@@ -929,7 +935,7 @@ static int fimc_capture_set_format(struct fimc_dev *fimc, struct v4l2_format *f)
 
 	set_frame_bounds(ff, pix->width, pix->height);
 	/* Reset the composition rectangle if not yet configured */
-	if (!(ctx->state & FIMC_DST_CROP))
+	if (!(ctx->state & FIMC_COMPOSE))
 		set_frame_crop(ff, 0, 0, pix->width, pix->height);
 
 	fimc_capture_mark_jpeg_xfer(ctx, fimc_fmt_is_jpeg(ff->fmt->color));
@@ -1187,29 +1193,18 @@ static int fimc_cap_s_selection(struct file *file, void *fh,
 	struct v4l2_rect rect = s->r;
 	struct fimc_frame *f;
 	unsigned long flags;
-	unsigned int pad;
 
 	if (s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
 		return -EINVAL;
 
-	switch (s->target) {
-	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
-	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
-	case V4L2_SEL_TGT_COMPOSE_ACTIVE:
+	if (s->target == V4L2_SEL_TGT_COMPOSE_ACTIVE)
 		f = &ctx->d_frame;
-		pad = FIMC_SD_PAD_SOURCE;
-		break;
-	case V4L2_SEL_TGT_CROP_BOUNDS:
-	case V4L2_SEL_TGT_CROP_DEFAULT:
-	case V4L2_SEL_TGT_CROP_ACTIVE:
+	else if (s->target == V4L2_SEL_TGT_CROP_ACTIVE)
 		f = &ctx->s_frame;
-		pad = FIMC_SD_PAD_SINK;
-		break;
-	default:
+	else
 		return -EINVAL;
-	}
 
-	fimc_capture_try_crop(ctx, &rect, pad);
+	fimc_capture_try_selection(ctx, &rect, s->target);
 
 	if (s->flags & V4L2_SEL_FLAG_LE &&
 	    !enclosed_rectangle(&rect, &s->r))
@@ -1422,77 +1417,122 @@ static int fimc_subdev_set_fmt(struct v4l2_subdev *sd,
 	ff->fmt = ffmt;
 
 	/* Reset the crop rectangle if required. */
-	if (!(fmt->pad == FIMC_SD_PAD_SOURCE && (ctx->state & FIMC_DST_CROP)))
+	if (!(fmt->pad == FIMC_SD_PAD_SOURCE && (ctx->state & FIMC_COMPOSE)))
 		set_frame_crop(ff, 0, 0, mf->width, mf->height);
 
 	if (fmt->pad == FIMC_SD_PAD_SINK)
-		ctx->state &= ~FIMC_DST_CROP;
+		ctx->state &= ~FIMC_COMPOSE;
 	mutex_unlock(&fimc->lock);
 	return 0;
 }
 
-static int fimc_subdev_get_crop(struct v4l2_subdev *sd,
-				struct v4l2_subdev_fh *fh,
-				struct v4l2_subdev_crop *crop)
+static int fimc_subdev_get_selection(struct v4l2_subdev *sd,
+				     struct v4l2_subdev_fh *fh,
+				     struct v4l2_subdev_selection *sel)
 {
 	struct fimc_dev *fimc = v4l2_get_subdevdata(sd);
 	struct fimc_ctx *ctx = fimc->vid_cap.ctx;
-	struct v4l2_rect *r = &crop->rect;
-	struct fimc_frame *ff;
+	struct fimc_frame *f = &ctx->s_frame;
+	struct v4l2_rect *r = &sel->r;
+	struct v4l2_rect *try_sel;
+
+	if (sel->pad != FIMC_SD_PAD_SINK)
+		return -EINVAL;
+
+	mutex_lock(&fimc->lock);
 
-	if (crop->which == V4L2_SUBDEV_FORMAT_TRY) {
-		crop->rect = *v4l2_subdev_get_try_crop(fh, crop->pad);
+	switch (sel->target) {
+	case V4L2_SUBDEV_SEL_TGT_COMPOSE_BOUNDS:
+		f = &ctx->d_frame;
+	case V4L2_SUBDEV_SEL_TGT_CROP_BOUNDS:
+		r->width = f->o_width;
+		r->height = f->o_height;
+		r->left = 0;
+		r->top = 0;
+		mutex_unlock(&fimc->lock);
 		return 0;
+
+	case V4L2_SUBDEV_SEL_TGT_CROP_ACTUAL:
+		try_sel = v4l2_subdev_get_try_crop(fh, sel->pad);
+		break;
+	case V4L2_SUBDEV_SEL_TGT_COMPOSE_ACTUAL:
+		try_sel = v4l2_subdev_get_try_compose(fh, sel->pad);
+		f = &ctx->d_frame;
+		break;
+	default:
+		mutex_unlock(&fimc->lock);
+		return -EINVAL;
 	}
-	ff = crop->pad == FIMC_SD_PAD_SINK ?
-		&ctx->s_frame : &ctx->d_frame;
 
-	mutex_lock(&fimc->lock);
-	r->left	  = ff->offs_h;
-	r->top	  = ff->offs_v;
-	r->width  = ff->width;
-	r->height = ff->height;
-	mutex_unlock(&fimc->lock);
+	if (sel->which == V4L2_SUBDEV_FORMAT_TRY) {
+		sel->r = *try_sel;
+	} else {
+		r->left = f->offs_h;
+		r->top = f->offs_v;
+		r->width = f->width;
+		r->height = f->height;
+	}
 
-	dbg("ff:%p, pad%d: l:%d, t:%d, %dx%d, f_w: %d, f_h: %d",
-	    ff, crop->pad, r->left, r->top, r->width, r->height,
-	    ff->f_width, ff->f_height);
+	dbg("target %#x: l:%d, t:%d, %dx%d, f_w: %d, f_h: %d",
+	    sel->pad, r->left, r->top, r->width, r->height,
+	    f->f_width, f->f_height);
 
+	mutex_unlock(&fimc->lock);
 	return 0;
 }
 
-static int fimc_subdev_set_crop(struct v4l2_subdev *sd,
-				struct v4l2_subdev_fh *fh,
-				struct v4l2_subdev_crop *crop)
+static int fimc_subdev_set_selection(struct v4l2_subdev *sd,
+				     struct v4l2_subdev_fh *fh,
+				     struct v4l2_subdev_selection *sel)
 {
 	struct fimc_dev *fimc = v4l2_get_subdevdata(sd);
 	struct fimc_ctx *ctx = fimc->vid_cap.ctx;
-	struct v4l2_rect *r = &crop->rect;
-	struct fimc_frame *ff;
+	struct fimc_frame *f = &ctx->s_frame;
+	struct v4l2_rect *r = &sel->r;
+	struct v4l2_rect *try_sel;
 	unsigned long flags;
 
-	dbg("(%d,%d)/%dx%d", r->left, r->top, r->width, r->height);
-
-	ff = crop->pad == FIMC_SD_PAD_SOURCE ?
-		&ctx->d_frame : &ctx->s_frame;
+	if (sel->pad != FIMC_SD_PAD_SINK)
+		return -EINVAL;
 
 	mutex_lock(&fimc->lock);
-	fimc_capture_try_crop(ctx, r, crop->pad);
+	fimc_capture_try_selection(ctx, r, V4L2_SEL_TGT_CROP_ACTIVE);
 
-	if (crop->which == V4L2_SUBDEV_FORMAT_TRY) {
+	switch (sel->target) {
+	case V4L2_SUBDEV_SEL_TGT_COMPOSE_BOUNDS:
+		f = &ctx->d_frame;
+	case V4L2_SUBDEV_SEL_TGT_CROP_BOUNDS:
+		r->width = f->o_width;
+		r->height = f->o_height;
+		r->left = 0;
+		r->top = 0;
 		mutex_unlock(&fimc->lock);
-		*v4l2_subdev_get_try_crop(fh, crop->pad) = *r;
 		return 0;
+
+	case V4L2_SUBDEV_SEL_TGT_CROP_ACTUAL:
+		try_sel = v4l2_subdev_get_try_crop(fh, sel->pad);
+		break;
+	case V4L2_SUBDEV_SEL_TGT_COMPOSE_ACTUAL:
+		try_sel = v4l2_subdev_get_try_compose(fh, sel->pad);
+		f = &ctx->d_frame;
+		break;
+	default:
+		mutex_unlock(&fimc->lock);
+		return -EINVAL;
 	}
-	spin_lock_irqsave(&fimc->slock, flags);
-	set_frame_crop(ff, r->left, r->top, r->width, r->height);
-	if (crop->pad == FIMC_SD_PAD_SOURCE)
-		ctx->state |= FIMC_DST_CROP;
 
-	set_bit(ST_CAPT_APPLY_CFG, &fimc->state);
-	spin_unlock_irqrestore(&fimc->slock, flags);
+	if (sel->which == V4L2_SUBDEV_FORMAT_TRY) {
+		*try_sel = sel->r;
+	} else {
+		spin_lock_irqsave(&fimc->slock, flags);
+		set_frame_crop(f, r->left, r->top, r->width, r->height);
+		set_bit(ST_CAPT_APPLY_CFG, &fimc->state);
+		spin_unlock_irqrestore(&fimc->slock, flags);
+		if (sel->target == V4L2_SUBDEV_SEL_TGT_COMPOSE_ACTUAL)
+			ctx->state |= FIMC_COMPOSE;
+	}
 
-	dbg("pad%d: (%d,%d)/%dx%d", crop->pad, r->left, r->top,
+	dbg("target %#x: (%d,%d)/%dx%d", sel->target, r->left, r->top,
 	    r->width, r->height);
 
 	mutex_unlock(&fimc->lock);
@@ -1501,10 +1541,10 @@ static int fimc_subdev_set_crop(struct v4l2_subdev *sd,
 
 static struct v4l2_subdev_pad_ops fimc_subdev_pad_ops = {
 	.enum_mbus_code = fimc_subdev_enum_mbus_code,
+	.get_selection = fimc_subdev_get_selection,
+	.set_selection = fimc_subdev_set_selection,
 	.get_fmt = fimc_subdev_get_fmt,
 	.set_fmt = fimc_subdev_set_fmt,
-	.get_crop = fimc_subdev_get_crop,
-	.set_crop = fimc_subdev_set_crop,
 };
 
 static struct v4l2_subdev_ops fimc_subdev_ops = {
diff --git a/drivers/media/video/s5p-fimc/fimc-core.h b/drivers/media/video/s5p-fimc/fimc-core.h
index b5511e1..c8031b0 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.h
+++ b/drivers/media/video/s5p-fimc/fimc-core.h
@@ -114,7 +114,7 @@ enum fimc_color_fmt {
 #define	FIMC_PARAMS		(1 << 0)
 #define	FIMC_SRC_FMT		(1 << 3)
 #define	FIMC_DST_FMT		(1 << 4)
-#define	FIMC_DST_CROP		(1 << 5)
+#define	FIMC_COMPOSE		(1 << 5)
 #define	FIMC_CTX_M2M		(1 << 16)
 #define	FIMC_CTX_CAP		(1 << 17)
 #define	FIMC_CTX_SHUT		(1 << 18)
-- 
1.7.10

