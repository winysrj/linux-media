Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:49282 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728404AbeJEOqt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 5 Oct 2018 10:46:49 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Tomasz Figa <tfiga@chromium.org>, snawrocki@kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 08/11] exynos4-is: convert g/s_crop to g/s_selection
Date: Fri,  5 Oct 2018 09:49:08 +0200
Message-Id: <20181005074911.47574-9-hverkuil@xs4all.nl>
In-Reply-To: <20181005074911.47574-1-hverkuil@xs4all.nl>
References: <20181005074911.47574-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Replace g/s_crop by g/s_selection and set the V4L2_FL_QUIRK_INVERTED_CROP
flag since this is one of the old drivers that predates the selection
API. Those old drivers allowed g_crop when it really shouldn't have since
g_crop returns a compose rectangle instead of a crop rectangle for the
CAPTURE stream, and vice versa for the OUTPUT stream.

Also drop the now unused vidioc_cropcap.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/exynos4-is/fimc-core.h |   6 +-
 drivers/media/platform/exynos4-is/fimc-m2m.c  | 130 ++++++++++--------
 2 files changed, 79 insertions(+), 57 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-core.h b/drivers/media/platform/exynos4-is/fimc-core.h
index 82d514df97f0..9f751a5efd64 100644
--- a/drivers/media/platform/exynos4-is/fimc-core.h
+++ b/drivers/media/platform/exynos4-is/fimc-core.h
@@ -596,12 +596,14 @@ static inline struct fimc_frame *ctx_get_frame(struct fimc_ctx *ctx,
 {
 	struct fimc_frame *frame;
 
-	if (V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE == type) {
+	if (type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE ||
+	    type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
 		if (fimc_ctx_state_is_set(FIMC_CTX_M2M, ctx))
 			frame = &ctx->s_frame;
 		else
 			return ERR_PTR(-EINVAL);
-	} else if (V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE == type) {
+	} else if (type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE ||
+		   type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
 		frame = &ctx->d_frame;
 	} else {
 		v4l2_err(ctx->fimc_dev->v4l2_dev,
diff --git a/drivers/media/platform/exynos4-is/fimc-m2m.c b/drivers/media/platform/exynos4-is/fimc-m2m.c
index a19f8b164a47..61c8177409cf 100644
--- a/drivers/media/platform/exynos4-is/fimc-m2m.c
+++ b/drivers/media/platform/exynos4-is/fimc-m2m.c
@@ -383,60 +383,80 @@ static int fimc_m2m_s_fmt_mplane(struct file *file, void *fh,
 	return 0;
 }
 
-static int fimc_m2m_cropcap(struct file *file, void *fh,
-			    struct v4l2_cropcap *cr)
+static int fimc_m2m_g_selection(struct file *file, void *fh,
+				struct v4l2_selection *s)
 {
 	struct fimc_ctx *ctx = fh_to_ctx(fh);
 	struct fimc_frame *frame;
 
-	frame = ctx_get_frame(ctx, cr->type);
+	frame = ctx_get_frame(ctx, s->type);
 	if (IS_ERR(frame))
 		return PTR_ERR(frame);
 
-	cr->bounds.left = 0;
-	cr->bounds.top = 0;
-	cr->bounds.width = frame->o_width;
-	cr->bounds.height = frame->o_height;
-	cr->defrect = cr->bounds;
-
-	return 0;
-}
-
-static int fimc_m2m_g_crop(struct file *file, void *fh, struct v4l2_crop *cr)
-{
-	struct fimc_ctx *ctx = fh_to_ctx(fh);
-	struct fimc_frame *frame;
-
-	frame = ctx_get_frame(ctx, cr->type);
-	if (IS_ERR(frame))
-		return PTR_ERR(frame);
-
-	cr->c.left = frame->offs_h;
-	cr->c.top = frame->offs_v;
-	cr->c.width = frame->width;
-	cr->c.height = frame->height;
+	switch (s->target) {
+	case V4L2_SEL_TGT_CROP:
+	case V4L2_SEL_TGT_CROP_DEFAULT:
+	case V4L2_SEL_TGT_CROP_BOUNDS:
+		if (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
+			return -EINVAL;
+		break;
+	case V4L2_SEL_TGT_COMPOSE:
+	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
+	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
+		if (s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+			return -EINVAL;
+		break;
+	default:
+		return -EINVAL;
+	}
 
+	switch (s->target) {
+	case V4L2_SEL_TGT_CROP:
+	case V4L2_SEL_TGT_COMPOSE:
+		s->r.left = frame->offs_h;
+		s->r.top = frame->offs_v;
+		s->r.width = frame->width;
+		s->r.height = frame->height;
+		break;
+	case V4L2_SEL_TGT_CROP_DEFAULT:
+	case V4L2_SEL_TGT_CROP_BOUNDS:
+	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
+	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
+		s->r.left = 0;
+		s->r.top = 0;
+		s->r.width = frame->o_width;
+		s->r.height = frame->o_height;
+		break;
+	default:
+		return -EINVAL;
+	}
 	return 0;
 }
 
-static int fimc_m2m_try_crop(struct fimc_ctx *ctx, struct v4l2_crop *cr)
+static int fimc_m2m_try_selection(struct fimc_ctx *ctx,
+				  struct v4l2_selection *s)
 {
 	struct fimc_dev *fimc = ctx->fimc_dev;
 	struct fimc_frame *f;
 	u32 min_size, halign, depth = 0;
 	int i;
 
-	if (cr->c.top < 0 || cr->c.left < 0) {
+	if (s->r.top < 0 || s->r.left < 0) {
 		v4l2_err(&fimc->m2m.vfd,
 			"doesn't support negative values for top & left\n");
 		return -EINVAL;
 	}
-	if (cr->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
+	if (s->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
 		f = &ctx->d_frame;
-	else if (cr->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
+		if (s->target != V4L2_SEL_TGT_COMPOSE)
+			return -EINVAL;
+	} else if (s->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
 		f = &ctx->s_frame;
-	else
+		if (s->target != V4L2_SEL_TGT_CROP)
+			return -EINVAL;
+	} else {
 		return -EINVAL;
+	}
 
 	min_size = (f == &ctx->s_frame) ?
 		fimc->variant->min_inp_pixsize : fimc->variant->min_out_pixsize;
@@ -450,61 +470,61 @@ static int fimc_m2m_try_crop(struct fimc_ctx *ctx, struct v4l2_crop *cr)
 	for (i = 0; i < f->fmt->memplanes; i++)
 		depth += f->fmt->depth[i];
 
-	v4l_bound_align_image(&cr->c.width, min_size, f->o_width,
+	v4l_bound_align_image(&s->r.width, min_size, f->o_width,
 			      ffs(min_size) - 1,
-			      &cr->c.height, min_size, f->o_height,
+			      &s->r.height, min_size, f->o_height,
 			      halign, 64/(ALIGN(depth, 8)));
 
 	/* adjust left/top if cropping rectangle is out of bounds */
-	if (cr->c.left + cr->c.width > f->o_width)
-		cr->c.left = f->o_width - cr->c.width;
-	if (cr->c.top + cr->c.height > f->o_height)
-		cr->c.top = f->o_height - cr->c.height;
+	if (s->r.left + s->r.width > f->o_width)
+		s->r.left = f->o_width - s->r.width;
+	if (s->r.top + s->r.height > f->o_height)
+		s->r.top = f->o_height - s->r.height;
 
-	cr->c.left = round_down(cr->c.left, min_size);
-	cr->c.top  = round_down(cr->c.top, fimc->variant->hor_offs_align);
+	s->r.left = round_down(s->r.left, min_size);
+	s->r.top  = round_down(s->r.top, fimc->variant->hor_offs_align);
 
 	dbg("l:%d, t:%d, w:%d, h:%d, f_w: %d, f_h: %d",
-	    cr->c.left, cr->c.top, cr->c.width, cr->c.height,
+	    s->r.left, s->r.top, s->r.width, s->r.height,
 	    f->f_width, f->f_height);
 
 	return 0;
 }
 
-static int fimc_m2m_s_crop(struct file *file, void *fh, const struct v4l2_crop *crop)
+static int fimc_m2m_s_selection(struct file *file, void *fh,
+				struct v4l2_selection *s)
 {
 	struct fimc_ctx *ctx = fh_to_ctx(fh);
 	struct fimc_dev *fimc = ctx->fimc_dev;
-	struct v4l2_crop cr = *crop;
 	struct fimc_frame *f;
 	int ret;
 
-	ret = fimc_m2m_try_crop(ctx, &cr);
+	ret = fimc_m2m_try_selection(ctx, s);
 	if (ret)
 		return ret;
 
-	f = (cr.type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) ?
+	f = (s->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) ?
 		&ctx->s_frame : &ctx->d_frame;
 
 	/* Check to see if scaling ratio is within supported range */
-	if (cr.type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
-		ret = fimc_check_scaler_ratio(ctx, cr.c.width,
-				cr.c.height, ctx->d_frame.width,
+	if (s->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
+		ret = fimc_check_scaler_ratio(ctx, s->r.width,
+				s->r.height, ctx->d_frame.width,
 				ctx->d_frame.height, ctx->rotation);
 	} else {
 		ret = fimc_check_scaler_ratio(ctx, ctx->s_frame.width,
-				ctx->s_frame.height, cr.c.width,
-				cr.c.height, ctx->rotation);
+				ctx->s_frame.height, s->r.width,
+				s->r.height, ctx->rotation);
 	}
 	if (ret) {
 		v4l2_err(&fimc->m2m.vfd, "Out of scaler range\n");
 		return -EINVAL;
 	}
 
-	f->offs_h = cr.c.left;
-	f->offs_v = cr.c.top;
-	f->width  = cr.c.width;
-	f->height = cr.c.height;
+	f->offs_h = s->r.left;
+	f->offs_v = s->r.top;
+	f->width  = s->r.width;
+	f->height = s->r.height;
 
 	fimc_ctx_state_set(FIMC_PARAMS, ctx);
 
@@ -528,9 +548,8 @@ static const struct v4l2_ioctl_ops fimc_m2m_ioctl_ops = {
 	.vidioc_expbuf			= v4l2_m2m_ioctl_expbuf,
 	.vidioc_streamon		= v4l2_m2m_ioctl_streamon,
 	.vidioc_streamoff		= v4l2_m2m_ioctl_streamoff,
-	.vidioc_g_crop			= fimc_m2m_g_crop,
-	.vidioc_s_crop			= fimc_m2m_s_crop,
-	.vidioc_cropcap			= fimc_m2m_cropcap
+	.vidioc_g_selection		= fimc_m2m_g_selection,
+	.vidioc_s_selection		= fimc_m2m_s_selection,
 
 };
 
@@ -717,6 +736,7 @@ int fimc_register_m2m_device(struct fimc_dev *fimc,
 	vfd->release = video_device_release_empty;
 	vfd->lock = &fimc->lock;
 	vfd->vfl_dir = VFL_DIR_M2M;
+	set_bit(V4L2_FL_QUIRK_INVERTED_CROP, &vfd->flags);
 
 	snprintf(vfd->name, sizeof(vfd->name), "fimc.%d.m2m", fimc->id);
 	video_set_drvdata(vfd, fimc);
-- 
2.18.0
