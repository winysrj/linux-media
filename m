Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:34354 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728401AbeJEOqu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 5 Oct 2018 10:46:50 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Tomasz Figa <tfiga@chromium.org>, snawrocki@kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 06/11] exynos-gsc: replace v4l2_crop by v4l2_selection
Date: Fri,  5 Oct 2018 09:49:06 +0200
Message-Id: <20181005074911.47574-7-hverkuil@xs4all.nl>
In-Reply-To: <20181005074911.47574-1-hverkuil@xs4all.nl>
References: <20181005074911.47574-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Replace the use of struct v4l2_crop by struct v4l2_selection.
Also drop the unused gsc_g_crop function.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/exynos-gsc/gsc-core.c | 57 ++++++++------------
 drivers/media/platform/exynos-gsc/gsc-core.h |  3 +-
 drivers/media/platform/exynos-gsc/gsc-m2m.c  | 23 ++++----
 3 files changed, 33 insertions(+), 50 deletions(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
index 838c5c53de37..0fa3ec04ab7b 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.c
+++ b/drivers/media/platform/exynos-gsc/gsc-core.c
@@ -541,20 +541,7 @@ void gsc_check_crop_change(u32 tmp_w, u32 tmp_h, u32 *w, u32 *h)
 	}
 }
 
-int gsc_g_crop(struct gsc_ctx *ctx, struct v4l2_crop *cr)
-{
-	struct gsc_frame *frame;
-
-	frame = ctx_get_frame(ctx, cr->type);
-	if (IS_ERR(frame))
-		return PTR_ERR(frame);
-
-	cr->c = frame->crop;
-
-	return 0;
-}
-
-int gsc_try_crop(struct gsc_ctx *ctx, struct v4l2_crop *cr)
+int gsc_try_selection(struct gsc_ctx *ctx, struct v4l2_selection *s)
 {
 	struct gsc_frame *f;
 	struct gsc_dev *gsc = ctx->gsc_dev;
@@ -562,25 +549,25 @@ int gsc_try_crop(struct gsc_ctx *ctx, struct v4l2_crop *cr)
 	u32 mod_x = 0, mod_y = 0, tmp_w, tmp_h;
 	u32 min_w, min_h, max_w, max_h;
 
-	if (cr->c.top < 0 || cr->c.left < 0) {
+	if (s->r.top < 0 || s->r.left < 0) {
 		pr_err("doesn't support negative values for top & left\n");
 		return -EINVAL;
 	}
-	pr_debug("user put w: %d, h: %d", cr->c.width, cr->c.height);
+	pr_debug("user put w: %d, h: %d", s->r.width, s->r.height);
 
-	if (cr->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
+	if (s->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		f = &ctx->d_frame;
-	else if (cr->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
+	else if (s->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
 		f = &ctx->s_frame;
 	else
 		return -EINVAL;
 
 	max_w = f->f_width;
 	max_h = f->f_height;
-	tmp_w = cr->c.width;
-	tmp_h = cr->c.height;
+	tmp_w = s->r.width;
+	tmp_h = s->r.height;
 
-	if (V4L2_TYPE_IS_OUTPUT(cr->type)) {
+	if (V4L2_TYPE_IS_OUTPUT(s->type)) {
 		if ((is_yuv422(f->fmt->color) && f->fmt->num_comp == 1) ||
 		    is_rgb(f->fmt->color))
 			min_w = 32;
@@ -602,8 +589,8 @@ int gsc_try_crop(struct gsc_ctx *ctx, struct v4l2_crop *cr)
 			max_h = f->f_width;
 			min_w = variant->pix_min->target_rot_en_w;
 			min_h = variant->pix_min->target_rot_en_h;
-			tmp_w = cr->c.height;
-			tmp_h = cr->c.width;
+			tmp_w = s->r.height;
+			tmp_h = s->r.width;
 		} else {
 			min_w = variant->pix_min->target_rot_dis_w;
 			min_h = variant->pix_min->target_rot_dis_h;
@@ -616,29 +603,29 @@ int gsc_try_crop(struct gsc_ctx *ctx, struct v4l2_crop *cr)
 	v4l_bound_align_image(&tmp_w, min_w, max_w, mod_x,
 			      &tmp_h, min_h, max_h, mod_y, 0);
 
-	if (!V4L2_TYPE_IS_OUTPUT(cr->type) &&
-		(ctx->gsc_ctrls.rotate->val == 90 ||
-		ctx->gsc_ctrls.rotate->val == 270))
+	if (!V4L2_TYPE_IS_OUTPUT(s->type) &&
+	    (ctx->gsc_ctrls.rotate->val == 90 ||
+	     ctx->gsc_ctrls.rotate->val == 270))
 		gsc_check_crop_change(tmp_h, tmp_w,
-					&cr->c.width, &cr->c.height);
+					&s->r.width, &s->r.height);
 	else
 		gsc_check_crop_change(tmp_w, tmp_h,
-					&cr->c.width, &cr->c.height);
+					&s->r.width, &s->r.height);
 
 
 	/* adjust left/top if cropping rectangle is out of bounds */
 	/* Need to add code to algin left value with 2's multiple */
-	if (cr->c.left + tmp_w > max_w)
-		cr->c.left = max_w - tmp_w;
-	if (cr->c.top + tmp_h > max_h)
-		cr->c.top = max_h - tmp_h;
+	if (s->r.left + tmp_w > max_w)
+		s->r.left = max_w - tmp_w;
+	if (s->r.top + tmp_h > max_h)
+		s->r.top = max_h - tmp_h;
 
 	if ((is_yuv420(f->fmt->color) || is_yuv422(f->fmt->color)) &&
-		cr->c.left & 1)
-			cr->c.left -= 1;
+	    s->r.left & 1)
+		s->r.left -= 1;
 
 	pr_debug("Aligned l:%d, t:%d, w:%d, h:%d, f_w: %d, f_h: %d",
-	    cr->c.left, cr->c.top, cr->c.width, cr->c.height, max_w, max_h);
+		 s->r.left, s->r.top, s->r.width, s->r.height, max_w, max_h);
 
 	return 0;
 }
diff --git a/drivers/media/platform/exynos-gsc/gsc-core.h b/drivers/media/platform/exynos-gsc/gsc-core.h
index 715d9c9d8d30..c81f0a17d286 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.h
+++ b/drivers/media/platform/exynos-gsc/gsc-core.h
@@ -392,8 +392,7 @@ int gsc_try_fmt_mplane(struct gsc_ctx *ctx, struct v4l2_format *f);
 void gsc_set_frame_size(struct gsc_frame *frame, int width, int height);
 int gsc_g_fmt_mplane(struct gsc_ctx *ctx, struct v4l2_format *f);
 void gsc_check_crop_change(u32 tmp_w, u32 tmp_h, u32 *w, u32 *h);
-int gsc_g_crop(struct gsc_ctx *ctx, struct v4l2_crop *cr);
-int gsc_try_crop(struct gsc_ctx *ctx, struct v4l2_crop *cr);
+int gsc_try_selection(struct gsc_ctx *ctx, struct v4l2_selection *s);
 int gsc_cal_prescaler_ratio(struct gsc_variant *var, u32 src, u32 dst,
 							u32 *ratio);
 void gsc_get_prescaler_shfactor(u32 hratio, u32 vratio, u32 *sh);
diff --git a/drivers/media/platform/exynos-gsc/gsc-m2m.c b/drivers/media/platform/exynos-gsc/gsc-m2m.c
index cc5d690818e1..c757f5d98bcc 100644
--- a/drivers/media/platform/exynos-gsc/gsc-m2m.c
+++ b/drivers/media/platform/exynos-gsc/gsc-m2m.c
@@ -494,30 +494,27 @@ static int gsc_m2m_s_selection(struct file *file, void *fh,
 {
 	struct gsc_frame *frame;
 	struct gsc_ctx *ctx = fh_to_ctx(fh);
-	struct v4l2_crop cr;
 	struct gsc_variant *variant = ctx->gsc_dev->variant;
+	struct v4l2_selection sel = *s;
 	int ret;
 
-	cr.type = s->type;
-	cr.c = s->r;
-
 	if ((s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE) &&
 	    (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT))
 		return -EINVAL;
 
-	ret = gsc_try_crop(ctx, &cr);
+	ret = gsc_try_selection(ctx, &sel);
 	if (ret)
 		return ret;
 
 	if (s->flags & V4L2_SEL_FLAG_LE &&
-	    !is_rectangle_enclosed(&cr.c, &s->r))
+	    !is_rectangle_enclosed(&sel.r, &s->r))
 		return -ERANGE;
 
 	if (s->flags & V4L2_SEL_FLAG_GE &&
-	    !is_rectangle_enclosed(&s->r, &cr.c))
+	    !is_rectangle_enclosed(&s->r, &sel.r))
 		return -ERANGE;
 
-	s->r = cr.c;
+	s->r = sel.r;
 
 	switch (s->target) {
 	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
@@ -539,15 +536,15 @@ static int gsc_m2m_s_selection(struct file *file, void *fh,
 	/* Check to see if scaling ratio is within supported range */
 	if (gsc_ctx_state_is_set(GSC_DST_FMT | GSC_SRC_FMT, ctx)) {
 		if (s->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
-			ret = gsc_check_scaler_ratio(variant, cr.c.width,
-				cr.c.height, ctx->d_frame.crop.width,
+			ret = gsc_check_scaler_ratio(variant, sel.r.width,
+				sel.r.height, ctx->d_frame.crop.width,
 				ctx->d_frame.crop.height,
 				ctx->gsc_ctrls.rotate->val, ctx->out_path);
 		} else {
 			ret = gsc_check_scaler_ratio(variant,
 				ctx->s_frame.crop.width,
-				ctx->s_frame.crop.height, cr.c.width,
-				cr.c.height, ctx->gsc_ctrls.rotate->val,
+				ctx->s_frame.crop.height, sel.r.width,
+				sel.r.height, ctx->gsc_ctrls.rotate->val,
 				ctx->out_path);
 		}
 
@@ -557,7 +554,7 @@ static int gsc_m2m_s_selection(struct file *file, void *fh,
 		}
 	}
 
-	frame->crop = cr.c;
+	frame->crop = sel.r;
 
 	gsc_ctx_state_lock_set(GSC_PARAMS, ctx);
 	return 0;
-- 
2.18.0
