Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:4205 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614Ab3HSM6V (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Aug 2013 08:58:21 -0400
Message-ID: <5212165D.4010002@xs4all.nl>
Date: Mon, 19 Aug 2013 14:58:05 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Shaik Ameer Basha <shaik.ameer@samsung.com>
CC: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	s.nawrocki@samsung.com, posciak@google.com, arun.kk@samsung.com
Subject: Re: [PATCH v2 3/5] [media] exynos-mscl: Add m2m functionality for
 the M-Scaler driver
References: <1376909932-23644-1-git-send-email-shaik.ameer@samsung.com> <1376909932-23644-4-git-send-email-shaik.ameer@samsung.com>
In-Reply-To: <1376909932-23644-4-git-send-email-shaik.ameer@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/19/2013 12:58 PM, Shaik Ameer Basha wrote:
> This patch adds the memory to memory (m2m) interface functionality
> for the M-Scaler driver.

Just one small comment below...

> 
> Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
> ---
>  drivers/media/platform/exynos-mscl/mscl-m2m.c |  763 +++++++++++++++++++++++++
>  1 file changed, 763 insertions(+)
>  create mode 100644 drivers/media/platform/exynos-mscl/mscl-m2m.c
> 
> diff --git a/drivers/media/platform/exynos-mscl/mscl-m2m.c b/drivers/media/platform/exynos-mscl/mscl-m2m.c
> new file mode 100644
> index 0000000..fecbb57
> --- /dev/null
> +++ b/drivers/media/platform/exynos-mscl/mscl-m2m.c
> @@ -0,0 +1,763 @@
> +/*
> + * Copyright (c) 2013 - 2014 Samsung Electronics Co., Ltd.
> + *		http://www.samsung.com
> + *
> + * Samsung EXYNOS5 SoC series M-Scaler driver
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published
> + * by the Free Software Foundation, either version 2 of the License,
> + * or (at your option) any later version.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/pm_runtime.h>
> +#include <linux/slab.h>
> +
> +#include <media/v4l2-ioctl.h>
> +
> +#include "mscl-core.h"
> +
> +static int mscl_m2m_ctx_stop_req(struct mscl_ctx *ctx)
> +{
> +	struct mscl_ctx *curr_ctx;
> +	struct mscl_dev *mscl = ctx->mscl_dev;
> +	int ret;
> +
> +	curr_ctx = v4l2_m2m_get_curr_priv(mscl->m2m.m2m_dev);
> +	if (!mscl_m2m_pending(mscl) || (curr_ctx != ctx))
> +		return 0;
> +
> +	mscl_ctx_state_lock_set(MSCL_CTX_STOP_REQ, ctx);
> +	ret = wait_event_timeout(mscl->irq_queue,
> +			!mscl_ctx_state_is_set(MSCL_CTX_STOP_REQ, ctx),
> +			MSCL_SHUTDOWN_TIMEOUT);
> +
> +	return ret == 0 ? -ETIMEDOUT : ret;
> +}
> +
> +static int mscl_m2m_start_streaming(struct vb2_queue *q, unsigned int count)
> +{
> +	struct mscl_ctx *ctx = q->drv_priv;
> +	int ret;
> +
> +	ret = pm_runtime_get_sync(&ctx->mscl_dev->pdev->dev);
> +
> +	return ret > 0 ? 0 : ret;
> +}
> +
> +static int mscl_m2m_stop_streaming(struct vb2_queue *q)
> +{
> +	struct mscl_ctx *ctx = q->drv_priv;
> +	int ret;
> +
> +	ret = mscl_m2m_ctx_stop_req(ctx);
> +	if (ret == -ETIMEDOUT)
> +		mscl_m2m_job_finish(ctx, VB2_BUF_STATE_ERROR);
> +
> +	pm_runtime_put(&ctx->mscl_dev->pdev->dev);
> +
> +	return 0;
> +}
> +
> +void mscl_m2m_job_finish(struct mscl_ctx *ctx, int vb_state)
> +{
> +	struct vb2_buffer *src_vb, *dst_vb;
> +
> +	if (!ctx || !ctx->m2m_ctx)
> +		return;
> +
> +	src_vb = v4l2_m2m_src_buf_remove(ctx->m2m_ctx);
> +	dst_vb = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx);
> +
> +	if (src_vb && dst_vb) {
> +		v4l2_m2m_buf_done(src_vb, vb_state);
> +		v4l2_m2m_buf_done(dst_vb, vb_state);
> +
> +		v4l2_m2m_job_finish(ctx->mscl_dev->m2m.m2m_dev,
> +							ctx->m2m_ctx);
> +	}
> +}
> +
> +
> +static void mscl_m2m_job_abort(void *priv)
> +{
> +	struct mscl_ctx *ctx = priv;
> +	int ret;
> +
> +	ret = mscl_m2m_ctx_stop_req(ctx);
> +	if (ret == -ETIMEDOUT)
> +		mscl_m2m_job_finish(ctx, VB2_BUF_STATE_ERROR);
> +}
> +
> +static int mscl_get_bufs(struct mscl_ctx *ctx)
> +{
> +	struct mscl_frame *s_frame, *d_frame;
> +	struct vb2_buffer *src_vb, *dst_vb;
> +	int ret;
> +
> +	s_frame = &ctx->s_frame;
> +	d_frame = &ctx->d_frame;
> +
> +	src_vb = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
> +	ret = mscl_prepare_addr(ctx, src_vb, s_frame, &s_frame->addr);
> +	if (ret)
> +		return ret;
> +
> +	dst_vb = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
> +	ret = mscl_prepare_addr(ctx, dst_vb, d_frame, &d_frame->addr);
> +	if (ret)
> +		return ret;
> +
> +	dst_vb->v4l2_buf.timestamp = src_vb->v4l2_buf.timestamp;
> +
> +	return 0;
> +}
> +
> +static void mscl_m2m_device_run(void *priv)
> +{
> +	struct mscl_ctx *ctx = priv;
> +	struct mscl_dev *mscl;
> +	unsigned long flags;
> +	int ret;
> +	bool is_set = false;
> +
> +	if (WARN(!ctx, "null hardware context\n"))
> +		return;
> +
> +	mscl = ctx->mscl_dev;
> +	spin_lock_irqsave(&mscl->slock, flags);
> +
> +	set_bit(ST_M2M_PEND, &mscl->state);
> +
> +	/* Reconfigure hardware if the context has changed. */
> +	if (mscl->m2m.ctx != ctx) {
> +		dev_dbg(&mscl->pdev->dev,
> +			"mscl->m2m.ctx = 0x%p, current_ctx = 0x%p",
> +			mscl->m2m.ctx, ctx);
> +		ctx->state |= MSCL_PARAMS;
> +		mscl->m2m.ctx = ctx;
> +	}
> +
> +	is_set = (ctx->state & MSCL_CTX_STOP_REQ) ? 1 : 0;
> +	ctx->state &= ~MSCL_CTX_STOP_REQ;
> +	if (is_set) {
> +		wake_up(&mscl->irq_queue);
> +		goto put_device;
> +	}
> +
> +	ret = mscl_get_bufs(ctx);
> +	if (ret) {
> +		dev_dbg(&mscl->pdev->dev, "Wrong address");
> +		goto put_device;
> +	}
> +
> +	mscl_hw_address_queue_reset(ctx);
> +	mscl_set_prefbuf(mscl, &ctx->s_frame);
> +	mscl_hw_set_input_addr(mscl, &ctx->s_frame.addr);
> +	mscl_hw_set_output_addr(mscl, &ctx->d_frame.addr);
> +	mscl_hw_set_csc_coeff(ctx);
> +
> +	if (ctx->state & MSCL_PARAMS) {
> +		mscl_hw_set_irq_mask(mscl, MSCL_INT_FRAME_END, false);
> +		if (mscl_set_scaler_info(ctx)) {
> +			dev_dbg(&mscl->pdev->dev, "Scaler setup error");
> +			goto put_device;
> +		}
> +
> +		mscl_hw_set_in_size(ctx);
> +		mscl_hw_set_in_image_format(ctx);
> +
> +		mscl_hw_set_out_size(ctx);
> +		mscl_hw_set_out_image_format(ctx);
> +
> +		mscl_hw_set_scaler_ratio(ctx);
> +		mscl_hw_set_rotation(ctx);
> +	}
> +
> +	ctx->state &= ~MSCL_PARAMS;
> +	mscl_hw_enable_control(mscl, true);
> +
> +	spin_unlock_irqrestore(&mscl->slock, flags);
> +	return;
> +
> +put_device:
> +	ctx->state &= ~MSCL_PARAMS;
> +	spin_unlock_irqrestore(&mscl->slock, flags);
> +}
> +
> +static int mscl_m2m_queue_setup(struct vb2_queue *vq,
> +			const struct v4l2_format *fmt,
> +			unsigned int *num_buffers, unsigned int *num_planes,
> +			unsigned int sizes[], void *allocators[])
> +{
> +	struct mscl_ctx *ctx = vb2_get_drv_priv(vq);
> +	struct mscl_frame *frame;
> +	int i;
> +
> +	frame = ctx_get_frame(ctx, vq->type);
> +	if (IS_ERR(frame))
> +		return PTR_ERR(frame);
> +
> +	if (!frame->fmt)
> +		return -EINVAL;
> +
> +	*num_planes = frame->fmt->num_planes;
> +	for (i = 0; i < frame->fmt->num_planes; i++) {
> +		sizes[i] = frame->payload[i];
> +		allocators[i] = ctx->mscl_dev->alloc_ctx;
> +	}
> +	return 0;
> +}
> +
> +static int mscl_m2m_buf_prepare(struct vb2_buffer *vb)
> +{
> +	struct mscl_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
> +	struct mscl_frame *frame;
> +	int i;
> +
> +	frame = ctx_get_frame(ctx, vb->vb2_queue->type);
> +	if (IS_ERR(frame))
> +		return PTR_ERR(frame);
> +
> +	if (!V4L2_TYPE_IS_OUTPUT(vb->vb2_queue->type)) {
> +		for (i = 0; i < frame->fmt->num_planes; i++)
> +			vb2_set_plane_payload(vb, i, frame->payload[i]);
> +	}
> +
> +	return 0;
> +}
> +
> +static void mscl_m2m_buf_queue(struct vb2_buffer *vb)
> +{
> +	struct mscl_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
> +
> +	dev_dbg(&ctx->mscl_dev->pdev->dev,
> +		"ctx: %p, ctx->state: 0x%x", ctx, ctx->state);
> +
> +	if (ctx->m2m_ctx)
> +		v4l2_m2m_buf_queue(ctx->m2m_ctx, vb);
> +}
> +
> +static struct vb2_ops mscl_m2m_qops = {
> +	.queue_setup	 = mscl_m2m_queue_setup,
> +	.buf_prepare	 = mscl_m2m_buf_prepare,
> +	.buf_queue	 = mscl_m2m_buf_queue,
> +	.wait_prepare	 = mscl_unlock,
> +	.wait_finish	 = mscl_lock,
> +	.stop_streaming	 = mscl_m2m_stop_streaming,
> +	.start_streaming = mscl_m2m_start_streaming,
> +};
> +
> +static int mscl_m2m_querycap(struct file *file, void *fh,
> +			   struct v4l2_capability *cap)
> +{
> +	struct mscl_ctx *ctx = fh_to_ctx(fh);
> +	struct mscl_dev *mscl = ctx->mscl_dev;
> +
> +	strlcpy(cap->driver, mscl->pdev->name, sizeof(cap->driver));
> +	strlcpy(cap->card, mscl->pdev->name, sizeof(cap->card));
> +	strlcpy(cap->bus_info, "platform", sizeof(cap->bus_info));
> +	cap->device_caps = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_M2M_MPLANE |
> +		V4L2_CAP_VIDEO_CAPTURE_MPLANE |	V4L2_CAP_VIDEO_OUTPUT_MPLANE;

No V4L2_CAP_VIDEO_CAPTURE_MPLANE | V4L2_CAP_VIDEO_OUTPUT_MPLANE, it should just be
V4L2_CAP_VIDEO_M2M_MPLANE.

> +
> +	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
> +
> +	return 0;
> +}
> +

Regards,

	Hans
