Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54468 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087Ab3HSKz2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Aug 2013 06:55:28 -0400
From: Shaik Ameer Basha <shaik.ameer@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: s.nawrocki@samsung.com, posciak@google.com, arun.kk@samsung.com,
	shaik.ameer@samsung.com
Subject: [PATCH v2 3/5] [media] exynos-mscl: Add m2m functionality for the M-Scaler driver
Date: Mon, 19 Aug 2013 16:28:50 +0530
Message-Id: <1376909932-23644-4-git-send-email-shaik.ameer@samsung.com>
In-Reply-To: <1376909932-23644-1-git-send-email-shaik.ameer@samsung.com>
References: <1376909932-23644-1-git-send-email-shaik.ameer@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds the memory to memory (m2m) interface functionality
for the M-Scaler driver.

Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
---
 drivers/media/platform/exynos-mscl/mscl-m2m.c |  763 +++++++++++++++++++++++++
 1 file changed, 763 insertions(+)
 create mode 100644 drivers/media/platform/exynos-mscl/mscl-m2m.c

diff --git a/drivers/media/platform/exynos-mscl/mscl-m2m.c b/drivers/media/platform/exynos-mscl/mscl-m2m.c
new file mode 100644
index 0000000..fecbb57
--- /dev/null
+++ b/drivers/media/platform/exynos-mscl/mscl-m2m.c
@@ -0,0 +1,763 @@
+/*
+ * Copyright (c) 2013 - 2014 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * Samsung EXYNOS5 SoC series M-Scaler driver
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundation, either version 2 of the License,
+ * or (at your option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/pm_runtime.h>
+#include <linux/slab.h>
+
+#include <media/v4l2-ioctl.h>
+
+#include "mscl-core.h"
+
+static int mscl_m2m_ctx_stop_req(struct mscl_ctx *ctx)
+{
+	struct mscl_ctx *curr_ctx;
+	struct mscl_dev *mscl = ctx->mscl_dev;
+	int ret;
+
+	curr_ctx = v4l2_m2m_get_curr_priv(mscl->m2m.m2m_dev);
+	if (!mscl_m2m_pending(mscl) || (curr_ctx != ctx))
+		return 0;
+
+	mscl_ctx_state_lock_set(MSCL_CTX_STOP_REQ, ctx);
+	ret = wait_event_timeout(mscl->irq_queue,
+			!mscl_ctx_state_is_set(MSCL_CTX_STOP_REQ, ctx),
+			MSCL_SHUTDOWN_TIMEOUT);
+
+	return ret == 0 ? -ETIMEDOUT : ret;
+}
+
+static int mscl_m2m_start_streaming(struct vb2_queue *q, unsigned int count)
+{
+	struct mscl_ctx *ctx = q->drv_priv;
+	int ret;
+
+	ret = pm_runtime_get_sync(&ctx->mscl_dev->pdev->dev);
+
+	return ret > 0 ? 0 : ret;
+}
+
+static int mscl_m2m_stop_streaming(struct vb2_queue *q)
+{
+	struct mscl_ctx *ctx = q->drv_priv;
+	int ret;
+
+	ret = mscl_m2m_ctx_stop_req(ctx);
+	if (ret == -ETIMEDOUT)
+		mscl_m2m_job_finish(ctx, VB2_BUF_STATE_ERROR);
+
+	pm_runtime_put(&ctx->mscl_dev->pdev->dev);
+
+	return 0;
+}
+
+void mscl_m2m_job_finish(struct mscl_ctx *ctx, int vb_state)
+{
+	struct vb2_buffer *src_vb, *dst_vb;
+
+	if (!ctx || !ctx->m2m_ctx)
+		return;
+
+	src_vb = v4l2_m2m_src_buf_remove(ctx->m2m_ctx);
+	dst_vb = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx);
+
+	if (src_vb && dst_vb) {
+		v4l2_m2m_buf_done(src_vb, vb_state);
+		v4l2_m2m_buf_done(dst_vb, vb_state);
+
+		v4l2_m2m_job_finish(ctx->mscl_dev->m2m.m2m_dev,
+							ctx->m2m_ctx);
+	}
+}
+
+
+static void mscl_m2m_job_abort(void *priv)
+{
+	struct mscl_ctx *ctx = priv;
+	int ret;
+
+	ret = mscl_m2m_ctx_stop_req(ctx);
+	if (ret == -ETIMEDOUT)
+		mscl_m2m_job_finish(ctx, VB2_BUF_STATE_ERROR);
+}
+
+static int mscl_get_bufs(struct mscl_ctx *ctx)
+{
+	struct mscl_frame *s_frame, *d_frame;
+	struct vb2_buffer *src_vb, *dst_vb;
+	int ret;
+
+	s_frame = &ctx->s_frame;
+	d_frame = &ctx->d_frame;
+
+	src_vb = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
+	ret = mscl_prepare_addr(ctx, src_vb, s_frame, &s_frame->addr);
+	if (ret)
+		return ret;
+
+	dst_vb = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
+	ret = mscl_prepare_addr(ctx, dst_vb, d_frame, &d_frame->addr);
+	if (ret)
+		return ret;
+
+	dst_vb->v4l2_buf.timestamp = src_vb->v4l2_buf.timestamp;
+
+	return 0;
+}
+
+static void mscl_m2m_device_run(void *priv)
+{
+	struct mscl_ctx *ctx = priv;
+	struct mscl_dev *mscl;
+	unsigned long flags;
+	int ret;
+	bool is_set = false;
+
+	if (WARN(!ctx, "null hardware context\n"))
+		return;
+
+	mscl = ctx->mscl_dev;
+	spin_lock_irqsave(&mscl->slock, flags);
+
+	set_bit(ST_M2M_PEND, &mscl->state);
+
+	/* Reconfigure hardware if the context has changed. */
+	if (mscl->m2m.ctx != ctx) {
+		dev_dbg(&mscl->pdev->dev,
+			"mscl->m2m.ctx = 0x%p, current_ctx = 0x%p",
+			mscl->m2m.ctx, ctx);
+		ctx->state |= MSCL_PARAMS;
+		mscl->m2m.ctx = ctx;
+	}
+
+	is_set = (ctx->state & MSCL_CTX_STOP_REQ) ? 1 : 0;
+	ctx->state &= ~MSCL_CTX_STOP_REQ;
+	if (is_set) {
+		wake_up(&mscl->irq_queue);
+		goto put_device;
+	}
+
+	ret = mscl_get_bufs(ctx);
+	if (ret) {
+		dev_dbg(&mscl->pdev->dev, "Wrong address");
+		goto put_device;
+	}
+
+	mscl_hw_address_queue_reset(ctx);
+	mscl_set_prefbuf(mscl, &ctx->s_frame);
+	mscl_hw_set_input_addr(mscl, &ctx->s_frame.addr);
+	mscl_hw_set_output_addr(mscl, &ctx->d_frame.addr);
+	mscl_hw_set_csc_coeff(ctx);
+
+	if (ctx->state & MSCL_PARAMS) {
+		mscl_hw_set_irq_mask(mscl, MSCL_INT_FRAME_END, false);
+		if (mscl_set_scaler_info(ctx)) {
+			dev_dbg(&mscl->pdev->dev, "Scaler setup error");
+			goto put_device;
+		}
+
+		mscl_hw_set_in_size(ctx);
+		mscl_hw_set_in_image_format(ctx);
+
+		mscl_hw_set_out_size(ctx);
+		mscl_hw_set_out_image_format(ctx);
+
+		mscl_hw_set_scaler_ratio(ctx);
+		mscl_hw_set_rotation(ctx);
+	}
+
+	ctx->state &= ~MSCL_PARAMS;
+	mscl_hw_enable_control(mscl, true);
+
+	spin_unlock_irqrestore(&mscl->slock, flags);
+	return;
+
+put_device:
+	ctx->state &= ~MSCL_PARAMS;
+	spin_unlock_irqrestore(&mscl->slock, flags);
+}
+
+static int mscl_m2m_queue_setup(struct vb2_queue *vq,
+			const struct v4l2_format *fmt,
+			unsigned int *num_buffers, unsigned int *num_planes,
+			unsigned int sizes[], void *allocators[])
+{
+	struct mscl_ctx *ctx = vb2_get_drv_priv(vq);
+	struct mscl_frame *frame;
+	int i;
+
+	frame = ctx_get_frame(ctx, vq->type);
+	if (IS_ERR(frame))
+		return PTR_ERR(frame);
+
+	if (!frame->fmt)
+		return -EINVAL;
+
+	*num_planes = frame->fmt->num_planes;
+	for (i = 0; i < frame->fmt->num_planes; i++) {
+		sizes[i] = frame->payload[i];
+		allocators[i] = ctx->mscl_dev->alloc_ctx;
+	}
+	return 0;
+}
+
+static int mscl_m2m_buf_prepare(struct vb2_buffer *vb)
+{
+	struct mscl_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+	struct mscl_frame *frame;
+	int i;
+
+	frame = ctx_get_frame(ctx, vb->vb2_queue->type);
+	if (IS_ERR(frame))
+		return PTR_ERR(frame);
+
+	if (!V4L2_TYPE_IS_OUTPUT(vb->vb2_queue->type)) {
+		for (i = 0; i < frame->fmt->num_planes; i++)
+			vb2_set_plane_payload(vb, i, frame->payload[i]);
+	}
+
+	return 0;
+}
+
+static void mscl_m2m_buf_queue(struct vb2_buffer *vb)
+{
+	struct mscl_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+
+	dev_dbg(&ctx->mscl_dev->pdev->dev,
+		"ctx: %p, ctx->state: 0x%x", ctx, ctx->state);
+
+	if (ctx->m2m_ctx)
+		v4l2_m2m_buf_queue(ctx->m2m_ctx, vb);
+}
+
+static struct vb2_ops mscl_m2m_qops = {
+	.queue_setup	 = mscl_m2m_queue_setup,
+	.buf_prepare	 = mscl_m2m_buf_prepare,
+	.buf_queue	 = mscl_m2m_buf_queue,
+	.wait_prepare	 = mscl_unlock,
+	.wait_finish	 = mscl_lock,
+	.stop_streaming	 = mscl_m2m_stop_streaming,
+	.start_streaming = mscl_m2m_start_streaming,
+};
+
+static int mscl_m2m_querycap(struct file *file, void *fh,
+			   struct v4l2_capability *cap)
+{
+	struct mscl_ctx *ctx = fh_to_ctx(fh);
+	struct mscl_dev *mscl = ctx->mscl_dev;
+
+	strlcpy(cap->driver, mscl->pdev->name, sizeof(cap->driver));
+	strlcpy(cap->card, mscl->pdev->name, sizeof(cap->card));
+	strlcpy(cap->bus_info, "platform", sizeof(cap->bus_info));
+	cap->device_caps = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_M2M_MPLANE |
+		V4L2_CAP_VIDEO_CAPTURE_MPLANE |	V4L2_CAP_VIDEO_OUTPUT_MPLANE;
+
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
+
+	return 0;
+}
+
+static int mscl_m2m_enum_fmt_mplane(struct file *file, void *priv,
+				struct v4l2_fmtdesc *f)
+{
+	return mscl_enum_fmt_mplane(f);
+}
+
+static int mscl_m2m_g_fmt_mplane(struct file *file, void *fh,
+			     struct v4l2_format *f)
+{
+	struct mscl_ctx *ctx = fh_to_ctx(fh);
+
+	return mscl_g_fmt_mplane(ctx, f);
+}
+
+static int mscl_m2m_try_fmt_mplane(struct file *file, void *fh,
+				  struct v4l2_format *f)
+{
+	struct mscl_ctx *ctx = fh_to_ctx(fh);
+
+	return mscl_try_fmt_mplane(ctx, f);
+}
+
+static int mscl_m2m_s_fmt_mplane(struct file *file, void *fh,
+				 struct v4l2_format *f)
+{
+	struct mscl_ctx *ctx = fh_to_ctx(fh);
+	struct vb2_queue *vq;
+	struct mscl_frame *frame;
+	struct v4l2_pix_format_mplane *pix;
+	int i, ret = 0;
+
+	ret = mscl_m2m_try_fmt_mplane(file, fh, f);
+	if (ret)
+		return ret;
+
+	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
+
+	if (vb2_is_streaming(vq)) {
+		dev_dbg(&ctx->mscl_dev->pdev->dev, "queue (%d) busy", f->type);
+		return -EBUSY;
+	}
+
+	if (V4L2_TYPE_IS_OUTPUT(f->type))
+		frame = &ctx->s_frame;
+	else
+		frame = &ctx->d_frame;
+
+	pix = &f->fmt.pix_mp;
+	frame->fmt = mscl_find_fmt(&pix->pixelformat, NULL, 0);
+	frame->colorspace = pix->colorspace;
+	if (!frame->fmt)
+		return -EINVAL;
+
+	for (i = 0; i < frame->fmt->num_planes; i++)
+		frame->payload[i] = pix->plane_fmt[i].sizeimage;
+
+	mscl_set_frame_size(frame, pix->width, pix->height);
+
+	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
+		mscl_ctx_state_lock_set(MSCL_PARAMS | MSCL_DST_FMT, ctx);
+	else
+		mscl_ctx_state_lock_set(MSCL_PARAMS | MSCL_SRC_FMT, ctx);
+
+	dev_dbg(&ctx->mscl_dev->pdev->dev, "f_w: %d, f_h: %d",
+					   frame->f_width, frame->f_height);
+
+	return 0;
+}
+
+static int mscl_m2m_reqbufs(struct file *file, void *fh,
+			  struct v4l2_requestbuffers *reqbufs)
+{
+	struct mscl_ctx *ctx = fh_to_ctx(fh);
+	struct mscl_dev *mscl = ctx->mscl_dev;
+	struct mscl_frame *frame;
+	u32 max_cnt;
+
+	max_cnt = (reqbufs->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) ?
+		mscl->variant->in_buf_cnt : mscl->variant->out_buf_cnt;
+	if (reqbufs->count > max_cnt) {
+		return -EINVAL;
+	} else if (reqbufs->count == 0) {
+		if (reqbufs->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
+			mscl_ctx_state_lock_clear(MSCL_SRC_FMT, ctx);
+		else
+			mscl_ctx_state_lock_clear(MSCL_DST_FMT, ctx);
+	}
+
+	frame = ctx_get_frame(ctx, reqbufs->type);
+
+	return v4l2_m2m_reqbufs(file, ctx->m2m_ctx, reqbufs);
+}
+
+static int mscl_m2m_expbuf(struct file *file, void *fh,
+				struct v4l2_exportbuffer *eb)
+{
+	struct mscl_ctx *ctx = fh_to_ctx(fh);
+	return v4l2_m2m_expbuf(file, ctx->m2m_ctx, eb);
+}
+
+static int mscl_m2m_querybuf(struct file *file, void *fh,
+					struct v4l2_buffer *buf)
+{
+	struct mscl_ctx *ctx = fh_to_ctx(fh);
+	return v4l2_m2m_querybuf(file, ctx->m2m_ctx, buf);
+}
+
+static int mscl_m2m_qbuf(struct file *file, void *fh,
+			  struct v4l2_buffer *buf)
+{
+	struct mscl_ctx *ctx = fh_to_ctx(fh);
+	return v4l2_m2m_qbuf(file, ctx->m2m_ctx, buf);
+}
+
+static int mscl_m2m_dqbuf(struct file *file, void *fh,
+			   struct v4l2_buffer *buf)
+{
+	struct mscl_ctx *ctx = fh_to_ctx(fh);
+	return v4l2_m2m_dqbuf(file, ctx->m2m_ctx, buf);
+}
+
+static int mscl_m2m_streamon(struct file *file, void *fh,
+			   enum v4l2_buf_type type)
+{
+	struct mscl_ctx *ctx = fh_to_ctx(fh);
+
+	/* The source and target color format need to be set */
+	if (V4L2_TYPE_IS_OUTPUT(type)) {
+		if (!mscl_ctx_state_is_set(MSCL_SRC_FMT, ctx))
+			return -EINVAL;
+	} else if (!mscl_ctx_state_is_set(MSCL_DST_FMT, ctx)) {
+		return -EINVAL;
+	}
+
+	return v4l2_m2m_streamon(file, ctx->m2m_ctx, type);
+}
+
+static int mscl_m2m_streamoff(struct file *file, void *fh,
+			    enum v4l2_buf_type type)
+{
+	struct mscl_ctx *ctx = fh_to_ctx(fh);
+	return v4l2_m2m_streamoff(file, ctx->m2m_ctx, type);
+}
+
+/* Return 1 if rectangle a is enclosed in rectangle b, or 0 otherwise. */
+static int is_rectangle_enclosed(struct v4l2_rect *a, struct v4l2_rect *b)
+{
+	if (a->left < b->left || a->top < b->top)
+		return 0;
+
+	if (a->left + a->width > b->left + b->width)
+		return 0;
+
+	if (a->top + a->height > b->top + b->height)
+		return 0;
+
+	return 1;
+}
+
+static int mscl_m2m_g_selection(struct file *file, void *fh,
+			struct v4l2_selection *s)
+{
+	struct mscl_frame *frame;
+	struct mscl_ctx *ctx = fh_to_ctx(fh);
+
+	if ((s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) &&
+	    (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE))
+		return -EINVAL;
+
+	frame = ctx_get_frame(ctx, s->type);
+	if (IS_ERR(frame))
+		return PTR_ERR(frame);
+
+	switch (s->target) {
+	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
+	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
+	case V4L2_SEL_TGT_CROP_BOUNDS:
+	case V4L2_SEL_TGT_CROP_DEFAULT:
+		s->r.left = 0;
+		s->r.top = 0;
+		s->r.width = frame->f_width;
+		s->r.height = frame->f_height;
+		return 0;
+
+	case V4L2_SEL_TGT_COMPOSE:
+	case V4L2_SEL_TGT_CROP:
+		s->r.left = frame->crop.left;
+		s->r.top = frame->crop.top;
+		s->r.width = frame->crop.width;
+		s->r.height = frame->crop.height;
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+static int mscl_m2m_s_selection(struct file *file, void *fh,
+				struct v4l2_selection *s)
+{
+	struct mscl_frame *frame;
+	struct mscl_ctx *ctx = fh_to_ctx(fh);
+	struct v4l2_crop cr;
+	struct mscl_variant *variant = ctx->mscl_dev->variant;
+	int ret;
+
+	cr.type = s->type;
+	cr.c = s->r;
+
+	if ((s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) &&
+	    (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE))
+		return -EINVAL;
+
+	ret = mscl_try_crop(ctx, &cr);
+	if (ret)
+		return ret;
+
+	if (s->flags & V4L2_SEL_FLAG_LE &&
+	    !is_rectangle_enclosed(&cr.c, &s->r))
+		return -ERANGE;
+
+	if (s->flags & V4L2_SEL_FLAG_GE &&
+	    !is_rectangle_enclosed(&s->r, &cr.c))
+		return -ERANGE;
+
+	s->r = cr.c;
+
+	switch (s->target) {
+	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
+	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
+	case V4L2_SEL_TGT_COMPOSE:
+		frame = &ctx->s_frame;
+		break;
+
+	case V4L2_SEL_TGT_CROP_BOUNDS:
+	case V4L2_SEL_TGT_CROP:
+	case V4L2_SEL_TGT_CROP_DEFAULT:
+		frame = &ctx->d_frame;
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	/* Check to see if scaling ratio is within supported range */
+	if (mscl_ctx_state_is_set(MSCL_DST_FMT | MSCL_SRC_FMT, ctx)) {
+		if (s->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+			ret = mscl_check_scaler_ratio(variant, cr.c.width,
+				cr.c.height, ctx->d_frame.crop.width,
+				ctx->d_frame.crop.height,
+				ctx->ctrls_mscl.rotate->val);
+		} else {
+			ret = mscl_check_scaler_ratio(variant,
+				ctx->s_frame.crop.width,
+				ctx->s_frame.crop.height, cr.c.width,
+				cr.c.height, ctx->ctrls_mscl.rotate->val);
+		}
+
+		if (ret) {
+			dev_dbg(&ctx->mscl_dev->pdev->dev,
+				"Out of scaler range");
+			return -EINVAL;
+		}
+	}
+
+	frame->crop = cr.c;
+
+	mscl_ctx_state_lock_set(MSCL_PARAMS, ctx);
+	return 0;
+}
+
+static const struct v4l2_ioctl_ops mscl_m2m_ioctl_ops = {
+	.vidioc_querycap		= mscl_m2m_querycap,
+	.vidioc_enum_fmt_vid_cap_mplane	= mscl_m2m_enum_fmt_mplane,
+	.vidioc_enum_fmt_vid_out_mplane	= mscl_m2m_enum_fmt_mplane,
+	.vidioc_g_fmt_vid_cap_mplane	= mscl_m2m_g_fmt_mplane,
+	.vidioc_g_fmt_vid_out_mplane	= mscl_m2m_g_fmt_mplane,
+	.vidioc_try_fmt_vid_cap_mplane	= mscl_m2m_try_fmt_mplane,
+	.vidioc_try_fmt_vid_out_mplane	= mscl_m2m_try_fmt_mplane,
+	.vidioc_s_fmt_vid_cap_mplane	= mscl_m2m_s_fmt_mplane,
+	.vidioc_s_fmt_vid_out_mplane	= mscl_m2m_s_fmt_mplane,
+	.vidioc_reqbufs			= mscl_m2m_reqbufs,
+	.vidioc_expbuf                  = mscl_m2m_expbuf,
+	.vidioc_querybuf		= mscl_m2m_querybuf,
+	.vidioc_qbuf			= mscl_m2m_qbuf,
+	.vidioc_dqbuf			= mscl_m2m_dqbuf,
+	.vidioc_streamon		= mscl_m2m_streamon,
+	.vidioc_streamoff		= mscl_m2m_streamoff,
+	.vidioc_g_selection		= mscl_m2m_g_selection,
+	.vidioc_s_selection		= mscl_m2m_s_selection
+};
+
+static int queue_init(void *priv, struct vb2_queue *src_vq,
+			struct vb2_queue *dst_vq)
+{
+	struct mscl_ctx *ctx = priv;
+	int ret;
+
+	memset(src_vq, 0, sizeof(*src_vq));
+	src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
+	src_vq->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
+	src_vq->drv_priv = ctx;
+	src_vq->ops = &mscl_m2m_qops;
+	src_vq->mem_ops = &vb2_dma_contig_memops;
+	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
+
+	ret = vb2_queue_init(src_vq);
+	if (ret)
+		return ret;
+
+	memset(dst_vq, 0, sizeof(*dst_vq));
+	dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
+	dst_vq->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
+	dst_vq->drv_priv = ctx;
+	dst_vq->ops = &mscl_m2m_qops;
+	dst_vq->mem_ops = &vb2_dma_contig_memops;
+	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
+
+	return vb2_queue_init(dst_vq);
+}
+
+static int mscl_m2m_open(struct file *file)
+{
+	struct mscl_dev *mscl = video_drvdata(file);
+	struct mscl_ctx *ctx = NULL;
+	int ret;
+
+	dev_dbg(&mscl->pdev->dev,
+		"pid: %d, state: 0x%lx", task_pid_nr(current), mscl->state);
+
+	if (mutex_lock_interruptible(&mscl->lock))
+		return -ERESTARTSYS;
+
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	if (!ctx) {
+		ret = -ENOMEM;
+		goto unlock;
+	}
+
+	v4l2_fh_init(&ctx->fh, mscl->m2m.vfd);
+	ret = mscl_ctrls_create(ctx);
+	if (ret)
+		goto error_fh;
+
+	/* Use separate control handler per file handle */
+	ctx->fh.ctrl_handler = &ctx->ctrl_handler;
+	file->private_data = &ctx->fh;
+	v4l2_fh_add(&ctx->fh);
+
+	ctx->mscl_dev = mscl;
+	/* Default color format */
+	ctx->s_frame.fmt = mscl_get_format(0);
+	ctx->d_frame.fmt = mscl_get_format(0);
+	/* Setup the device context for mem2mem mode. */
+	ctx->state = MSCL_CTX_M2M;
+	ctx->flags = 0;
+
+	ctx->m2m_ctx = v4l2_m2m_ctx_init(mscl->m2m.m2m_dev, ctx, queue_init);
+	if (IS_ERR(ctx->m2m_ctx)) {
+		dev_dbg(&mscl->pdev->dev, "Failed to initialize m2m context");
+		ret = PTR_ERR(ctx->m2m_ctx);
+		goto error_ctrls;
+	}
+
+	if (mscl->m2m.refcnt++ == 0)
+		set_bit(ST_M2M_OPEN, &mscl->state);
+
+	dev_dbg(&mscl->pdev->dev, "mscl m2m driver is opened, ctx(0x%p)", ctx);
+
+	mutex_unlock(&mscl->lock);
+	return 0;
+
+error_ctrls:
+	mscl_ctrls_delete(ctx);
+error_fh:
+	v4l2_fh_del(&ctx->fh);
+	v4l2_fh_exit(&ctx->fh);
+	kfree(ctx);
+unlock:
+	mutex_unlock(&mscl->lock);
+	return ret;
+}
+
+static int mscl_m2m_release(struct file *file)
+{
+	struct mscl_ctx *ctx = fh_to_ctx(file->private_data);
+	struct mscl_dev *mscl = ctx->mscl_dev;
+
+	dev_dbg(&mscl->pdev->dev, "pid: %d, state: 0x%lx, refcnt= %d",
+		task_pid_nr(current), mscl->state, mscl->m2m.refcnt);
+
+	mutex_lock(&mscl->lock);
+
+	v4l2_m2m_ctx_release(ctx->m2m_ctx);
+	mscl_ctrls_delete(ctx);
+	v4l2_fh_del(&ctx->fh);
+	v4l2_fh_exit(&ctx->fh);
+
+	if (--mscl->m2m.refcnt <= 0)
+		clear_bit(ST_M2M_OPEN, &mscl->state);
+	kfree(ctx);
+
+	mutex_unlock(&mscl->lock);
+	return 0;
+}
+
+static unsigned int mscl_m2m_poll(struct file *file,
+					struct poll_table_struct *wait)
+{
+	struct mscl_ctx *ctx = fh_to_ctx(file->private_data);
+	struct mscl_dev *mscl = ctx->mscl_dev;
+	int ret;
+
+	if (mutex_lock_interruptible(&mscl->lock))
+		return -ERESTARTSYS;
+
+	ret = v4l2_m2m_poll(file, ctx->m2m_ctx, wait);
+	mutex_unlock(&mscl->lock);
+
+	return ret;
+}
+
+static int mscl_m2m_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct mscl_ctx *ctx = fh_to_ctx(file->private_data);
+	struct mscl_dev *mscl = ctx->mscl_dev;
+	int ret;
+
+	if (mutex_lock_interruptible(&mscl->lock))
+		return -ERESTARTSYS;
+
+	ret = v4l2_m2m_mmap(file, ctx->m2m_ctx, vma);
+	mutex_unlock(&mscl->lock);
+
+	return ret;
+}
+
+static const struct v4l2_file_operations mscl_m2m_fops = {
+	.owner		= THIS_MODULE,
+	.open		= mscl_m2m_open,
+	.release	= mscl_m2m_release,
+	.poll		= mscl_m2m_poll,
+	.unlocked_ioctl	= video_ioctl2,
+	.mmap		= mscl_m2m_mmap,
+};
+
+static struct v4l2_m2m_ops mscl_m2m_ops = {
+	.device_run	= mscl_m2m_device_run,
+	.job_abort	= mscl_m2m_job_abort,
+};
+
+int mscl_register_m2m_device(struct mscl_dev *mscl)
+{
+	struct platform_device *pdev;
+	int ret;
+
+	if (!mscl)
+		return -ENODEV;
+
+	pdev = mscl->pdev;
+
+	mscl->vdev.fops		= &mscl_m2m_fops;
+	mscl->vdev.ioctl_ops	= &mscl_m2m_ioctl_ops;
+	mscl->vdev.release	= video_device_release_empty;
+	mscl->vdev.lock		= &mscl->lock;
+	mscl->vdev.vfl_dir	= VFL_DIR_M2M;
+	snprintf(mscl->vdev.name, sizeof(mscl->vdev.name), "%s.%d:m2m",
+					MSCL_MODULE_NAME, mscl->id);
+
+	video_set_drvdata(&mscl->vdev, mscl);
+
+	mscl->m2m.vfd = &mscl->vdev;
+	mscl->m2m.m2m_dev = v4l2_m2m_init(&mscl_m2m_ops);
+	if (IS_ERR(mscl->m2m.m2m_dev)) {
+		dev_err(&pdev->dev, "failed to initialize v4l2-m2m device\n");
+		return PTR_ERR(mscl->m2m.m2m_dev);
+	}
+
+	ret = video_register_device(&mscl->vdev, VFL_TYPE_GRABBER, -1);
+	if (ret) {
+		dev_err(&pdev->dev,
+			 "%s(): failed to register video device\n", __func__);
+		v4l2_m2m_release(mscl->m2m.m2m_dev);
+		return ret;
+	}
+
+	dev_info(&pdev->dev,
+		 "mscl m2m driver registered as /dev/video%d", mscl->vdev.num);
+	return 0;
+}
+
+void mscl_unregister_m2m_device(struct mscl_dev *mscl)
+{
+	if (mscl)
+		v4l2_m2m_release(mscl->m2m.m2m_dev);
+}
-- 
1.7.9.5

