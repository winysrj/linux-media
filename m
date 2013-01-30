Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:28718 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756078Ab3A3RXl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Jan 2013 12:23:41 -0500
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MHG00L4K8B3ACU0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 31 Jan 2013 02:23:40 +0900 (KST)
Received: from amdc1344.digital.local ([106.116.147.32])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MHG00A7W8B4SV70@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 31 Jan 2013 02:23:39 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, sw0312.kim@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 2/5] s5p-fimc: Set default image format at device open()
Date: Wed, 30 Jan 2013 18:23:22 +0100
Message-id: <1359566606-31394-3-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1359566606-31394-1-git-send-email-s.nawrocki@samsung.com>
References: <1359566606-31394-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make sure a valid image format is initially set on both the CAPTURE
and the OUTPUT buffer queue.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-fimc/fimc-core.c |   20 +---
 drivers/media/platform/s5p-fimc/fimc-core.h |    5 +-
 drivers/media/platform/s5p-fimc/fimc-m2m.c  |  131 +++++++++++++++------------
 3 files changed, 75 insertions(+), 81 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/fimc-core.c b/drivers/media/platform/s5p-fimc/fimc-core.c
index a962541..29f7bb7 100644
--- a/drivers/media/platform/s5p-fimc/fimc-core.c
+++ b/drivers/media/platform/s5p-fimc/fimc-core.c
@@ -525,7 +525,6 @@ static int __fimc_s_ctrl(struct fimc_ctx *ctx, struct v4l2_ctrl *ctrl)
 {
 	struct fimc_dev *fimc = ctx->fimc_dev;
 	const struct fimc_variant *variant = fimc->variant;
-	unsigned int flags = FIMC_DST_FMT | FIMC_SRC_FMT;
 	int ret = 0;
 
 	if (ctrl->flags & V4L2_CTRL_FLAG_INACTIVE)
@@ -541,8 +540,7 @@ static int __fimc_s_ctrl(struct fimc_ctx *ctx, struct v4l2_ctrl *ctrl)
 		break;
 
 	case V4L2_CID_ROTATE:
-		if (fimc_capture_pending(fimc) ||
-		    (ctx->state & flags) == flags) {
+		if (fimc_capture_pending(fimc)) {
 			ret = fimc_check_scaler_ratio(ctx, ctx->s_frame.width,
 					ctx->s_frame.height, ctx->d_frame.width,
 					ctx->d_frame.height, ctrl->val);
@@ -709,22 +707,6 @@ void __fimc_get_format(struct fimc_frame *frame, struct v4l2_format *f)
 	}
 }
 
-void fimc_fill_frame(struct fimc_frame *frame, struct v4l2_format *f)
-{
-	struct v4l2_pix_format_mplane *pixm = &f->fmt.pix_mp;
-
-	frame->f_width  = pixm->plane_fmt[0].bytesperline;
-	if (frame->fmt->colplanes == 1)
-		frame->f_width = (frame->f_width * 8) / frame->fmt->depth[0];
-	frame->f_height	= pixm->height;
-	frame->width    = pixm->width;
-	frame->height   = pixm->height;
-	frame->o_width  = pixm->width;
-	frame->o_height = pixm->height;
-	frame->offs_h   = 0;
-	frame->offs_v   = 0;
-}
-
 /**
  * fimc_adjust_mplane_format - adjust bytesperline/sizeimage for each plane
  * @fmt: fimc pixel format description (input)
diff --git a/drivers/media/platform/s5p-fimc/fimc-core.h b/drivers/media/platform/s5p-fimc/fimc-core.h
index cf760c3..412d507 100644
--- a/drivers/media/platform/s5p-fimc/fimc-core.h
+++ b/drivers/media/platform/s5p-fimc/fimc-core.h
@@ -112,9 +112,7 @@ enum fimc_color_fmt {
 
 /* The hardware context state. */
 #define	FIMC_PARAMS		(1 << 0)
-#define	FIMC_SRC_FMT		(1 << 3)
-#define	FIMC_DST_FMT		(1 << 4)
-#define	FIMC_COMPOSE		(1 << 5)
+#define	FIMC_COMPOSE		(1 << 1)
 #define	FIMC_CTX_M2M		(1 << 16)
 #define	FIMC_CTX_CAP		(1 << 17)
 #define	FIMC_CTX_SHUT		(1 << 18)
@@ -654,7 +652,6 @@ int fimc_prepare_addr(struct fimc_ctx *ctx, struct vb2_buffer *vb,
 		      struct fimc_frame *frame, struct fimc_addr *paddr);
 void fimc_prepare_dma_offset(struct fimc_ctx *ctx, struct fimc_frame *f);
 void fimc_set_yuv_order(struct fimc_ctx *ctx);
-void fimc_fill_frame(struct fimc_frame *frame, struct v4l2_format *f);
 void fimc_capture_irq_handler(struct fimc_dev *fimc, int deq_buf);
 
 int fimc_register_m2m_device(struct fimc_dev *fimc,
diff --git a/drivers/media/platform/s5p-fimc/fimc-m2m.c b/drivers/media/platform/s5p-fimc/fimc-m2m.c
index 1eabd7e..f3d535c 100644
--- a/drivers/media/platform/s5p-fimc/fimc-m2m.c
+++ b/drivers/media/platform/s5p-fimc/fimc-m2m.c
@@ -1,8 +1,8 @@
 /*
  * Samsung S5P/EXYNOS4 SoC series FIMC (video postprocessor) driver
  *
- * Copyright (C) 2012 Samsung Electronics Co., Ltd.
- * Sylwester Nawrocki, <s.nawrocki@samsung.com>
+ * Copyright (C) 2012 - 2013 Samsung Electronics Co., Ltd.
+ * Sylwester Nawrocki <s.nawrocki@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published
@@ -160,8 +160,7 @@ static void fimc_device_run(void *priv)
 	fimc_hw_set_output_addr(fimc, &df->paddr, -1);
 
 	fimc_activate_capture(ctx);
-	ctx->state &= (FIMC_CTX_M2M | FIMC_CTX_CAP |
-		       FIMC_SRC_FMT | FIMC_DST_FMT);
+	ctx->state &= (FIMC_CTX_M2M | FIMC_CTX_CAP);
 	fimc_hw_activate_input_dma(fimc, true);
 
 dma_unlock:
@@ -309,8 +308,6 @@ static int fimc_try_fmt_mplane(struct fimc_ctx *ctx, struct v4l2_format *f)
 	if (!IS_M2M(f->type))
 		return -EINVAL;
 
-	dbg("w: %d, h: %d", pix->width, pix->height);
-
 	fmt = fimc_find_format(&pix->pixelformat, NULL,
 			       get_m2m_fmt_flags(f->type), 0);
 	if (WARN(fmt == NULL, "Pixel format lookup failed"))
@@ -350,19 +347,39 @@ static int fimc_m2m_try_fmt_mplane(struct file *file, void *fh,
 				   struct v4l2_format *f)
 {
 	struct fimc_ctx *ctx = fh_to_ctx(fh);
-
 	return fimc_try_fmt_mplane(ctx, f);
 }
 
+static void __set_frame_format(struct fimc_frame *frame, struct fimc_fmt *fmt,
+			       struct v4l2_pix_format_mplane *pixm)
+{
+	int i;
+
+	for (i = 0; i < fmt->colplanes; i++) {
+		frame->bytesperline[i] = pixm->plane_fmt[i].bytesperline;
+		frame->payload[i] = pixm->plane_fmt[i].sizeimage;
+	}
+
+	frame->f_width = pixm->width;
+	frame->f_height	= pixm->height;
+	frame->o_width = pixm->width;
+	frame->o_height = pixm->height;
+	frame->width = pixm->width;
+	frame->height = pixm->height;
+	frame->offs_h = 0;
+	frame->offs_v = 0;
+	frame->fmt = fmt;
+}
+
 static int fimc_m2m_s_fmt_mplane(struct file *file, void *fh,
 				 struct v4l2_format *f)
 {
 	struct fimc_ctx *ctx = fh_to_ctx(fh);
 	struct fimc_dev *fimc = ctx->fimc_dev;
+	struct fimc_fmt *fmt;
 	struct vb2_queue *vq;
 	struct fimc_frame *frame;
-	struct v4l2_pix_format_mplane *pix;
-	int i, ret = 0;
+	int ret;
 
 	ret = fimc_try_fmt_mplane(ctx, f);
 	if (ret)
@@ -380,31 +397,16 @@ static int fimc_m2m_s_fmt_mplane(struct file *file, void *fh,
 	else
 		frame = &ctx->d_frame;
 
-	pix = &f->fmt.pix_mp;
-	frame->fmt = fimc_find_format(&pix->pixelformat, NULL,
-				      get_m2m_fmt_flags(f->type), 0);
-	if (!frame->fmt)
+	fmt = fimc_find_format(&f->fmt.pix_mp.pixelformat, NULL,
+			       get_m2m_fmt_flags(f->type), 0);
+	if (!fmt)
 		return -EINVAL;
 
+	__set_frame_format(frame, fmt, &f->fmt.pix_mp);
+
 	/* Update RGB Alpha control state and value range */
 	fimc_alpha_ctrl_update(ctx);
 
-	for (i = 0; i < frame->fmt->colplanes; i++) {
-		frame->bytesperline[i] = pix->plane_fmt[i].bytesperline;
-		frame->payload[i] = pix->plane_fmt[i].sizeimage;
-	}
-
-	fimc_fill_frame(frame, f);
-
-	ctx->scaler.enabled = 1;
-
-	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
-		fimc_ctx_state_set(FIMC_PARAMS | FIMC_DST_FMT, ctx);
-	else
-		fimc_ctx_state_set(FIMC_PARAMS | FIMC_SRC_FMT, ctx);
-
-	dbg("f_w: %d, f_h: %d", frame->f_width, frame->f_height);
-
 	return 0;
 }
 
@@ -412,7 +414,6 @@ static int fimc_m2m_reqbufs(struct file *file, void *fh,
 			    struct v4l2_requestbuffers *reqbufs)
 {
 	struct fimc_ctx *ctx = fh_to_ctx(fh);
-
 	return v4l2_m2m_reqbufs(file, ctx->m2m_ctx, reqbufs);
 }
 
@@ -420,7 +421,6 @@ static int fimc_m2m_querybuf(struct file *file, void *fh,
 			     struct v4l2_buffer *buf)
 {
 	struct fimc_ctx *ctx = fh_to_ctx(fh);
-
 	return v4l2_m2m_querybuf(file, ctx->m2m_ctx, buf);
 }
 
@@ -428,7 +428,6 @@ static int fimc_m2m_qbuf(struct file *file, void *fh,
 			 struct v4l2_buffer *buf)
 {
 	struct fimc_ctx *ctx = fh_to_ctx(fh);
-
 	return v4l2_m2m_qbuf(file, ctx->m2m_ctx, buf);
 }
 
@@ -436,7 +435,6 @@ static int fimc_m2m_dqbuf(struct file *file, void *fh,
 			  struct v4l2_buffer *buf)
 {
 	struct fimc_ctx *ctx = fh_to_ctx(fh);
-
 	return v4l2_m2m_dqbuf(file, ctx->m2m_ctx, buf);
 }
 
@@ -444,7 +442,6 @@ static int fimc_m2m_expbuf(struct file *file, void *fh,
 			    struct v4l2_exportbuffer *eb)
 {
 	struct fimc_ctx *ctx = fh_to_ctx(fh);
-
 	return v4l2_m2m_expbuf(file, ctx->m2m_ctx, eb);
 }
 
@@ -453,15 +450,6 @@ static int fimc_m2m_streamon(struct file *file, void *fh,
 			     enum v4l2_buf_type type)
 {
 	struct fimc_ctx *ctx = fh_to_ctx(fh);
-
-	/* The source and target color format need to be set */
-	if (V4L2_TYPE_IS_OUTPUT(type)) {
-		if (!fimc_ctx_state_is_set(FIMC_SRC_FMT, ctx))
-			return -EINVAL;
-	} else if (!fimc_ctx_state_is_set(FIMC_DST_FMT, ctx)) {
-		return -EINVAL;
-	}
-
 	return v4l2_m2m_streamon(file, ctx->m2m_ctx, type);
 }
 
@@ -469,7 +457,6 @@ static int fimc_m2m_streamoff(struct file *file, void *fh,
 			    enum v4l2_buf_type type)
 {
 	struct fimc_ctx *ctx = fh_to_ctx(fh);
-
 	return v4l2_m2m_streamoff(file, ctx->m2m_ctx, type);
 }
 
@@ -577,20 +564,18 @@ static int fimc_m2m_s_crop(struct file *file, void *fh, const struct v4l2_crop *
 		&ctx->s_frame : &ctx->d_frame;
 
 	/* Check to see if scaling ratio is within supported range */
-	if (fimc_ctx_state_is_set(FIMC_DST_FMT | FIMC_SRC_FMT, ctx)) {
-		if (cr.type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
-			ret = fimc_check_scaler_ratio(ctx, cr.c.width,
-					cr.c.height, ctx->d_frame.width,
-					ctx->d_frame.height, ctx->rotation);
-		} else {
-			ret = fimc_check_scaler_ratio(ctx, ctx->s_frame.width,
-					ctx->s_frame.height, cr.c.width,
-					cr.c.height, ctx->rotation);
-		}
-		if (ret) {
-			v4l2_err(&fimc->m2m.vfd, "Out of scaler range\n");
-			return -EINVAL;
-		}
+	if (cr.type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		ret = fimc_check_scaler_ratio(ctx, cr.c.width,
+				cr.c.height, ctx->d_frame.width,
+				ctx->d_frame.height, ctx->rotation);
+	} else {
+		ret = fimc_check_scaler_ratio(ctx, ctx->s_frame.width,
+				ctx->s_frame.height, cr.c.width,
+				cr.c.height, ctx->rotation);
+	}
+	if (ret) {
+		v4l2_err(&fimc->m2m.vfd, "Out of scaler range\n");
+		return -EINVAL;
 	}
 
 	f->offs_h = cr.c.left;
@@ -653,6 +638,29 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	return vb2_queue_init(dst_vq);
 }
 
+static int fimc_m2m_set_default_format(struct fimc_ctx *ctx)
+{
+	struct v4l2_pix_format_mplane pixm = {
+		.pixelformat	= V4L2_PIX_FMT_RGB32,
+		.width		= 800,
+		.height		= 600,
+		.plane_fmt[0]	= {
+			.bytesperline = 800 * 4,
+			.sizeimage = 800 * 4 * 600,
+		},
+	};
+	struct fimc_fmt *fmt;
+
+	fmt = fimc_find_format(&pixm.pixelformat, NULL, FMT_FLAGS_M2M, 0);
+	if (!fmt)
+		return -EINVAL;
+
+	__set_frame_format(&ctx->s_frame, fmt, &pixm);
+	__set_frame_format(&ctx->d_frame, fmt, &pixm);
+
+	return 0;
+}
+
 static int fimc_m2m_open(struct file *file)
 {
 	struct fimc_dev *fimc = video_drvdata(file);
@@ -697,6 +705,7 @@ static int fimc_m2m_open(struct file *file)
 	ctx->flags = 0;
 	ctx->in_path = FIMC_IO_DMA;
 	ctx->out_path = FIMC_IO_DMA;
+	ctx->scaler.enabled = 1;
 
 	ctx->m2m_ctx = v4l2_m2m_ctx_init(fimc->m2m.m2m_dev, ctx, queue_init);
 	if (IS_ERR(ctx->m2m_ctx)) {
@@ -707,9 +716,15 @@ static int fimc_m2m_open(struct file *file)
 	if (fimc->m2m.refcnt++ == 0)
 		set_bit(ST_M2M_RUN, &fimc->state);
 
+	ret = fimc_m2m_set_default_format(ctx);
+	if (ret < 0)
+		goto error_m2m_ctx;
+
 	mutex_unlock(&fimc->lock);
 	return 0;
 
+error_m2m_ctx:
+	v4l2_m2m_ctx_release(ctx->m2m_ctx);
 error_c:
 	fimc_ctrls_delete(ctx);
 error_fh:
-- 
1.7.9.5

