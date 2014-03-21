Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yh0-f53.google.com ([209.85.213.53]:58632 "EHLO
	mail-yh0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420AbaCUFAO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Mar 2014 01:00:14 -0400
MIME-Version: 1.0
In-Reply-To: <53294BF8.6090708@xs4all.nl>
References: <1395213196-25972-1-git-send-email-shaik.ameer@samsung.com>
	<1395213196-25972-4-git-send-email-shaik.ameer@samsung.com>
	<53294BF8.6090708@xs4all.nl>
Date: Fri, 21 Mar 2014 10:30:13 +0530
Message-ID: <CAOD6ATrE++=kDp7MDXPuFbxshR+P4nzcmS_k_+4TvQG22R9BMQ@mail.gmail.com>
Subject: Re: [PATCH v6 3/4] [media] exynos-scaler: Add m2m functionality for
 the SCALER driver
From: Shaik Ameer Basha <shaik.samsung@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Shaik Ameer Basha <shaik.ameer@samsung.com>,
	LMML <linux-media@vger.kernel.org>,
	linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Tomasz Figa <t.figa@samsung.com>, k.debski@samsung.com,
	Arun Kumar <arun.kk@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the review comments.

Frankly, I was not following the recent changes related to vb2 framework.
And I didn't tested the driver for v4l2-compliance :(

Will try to address all your comments in the next version of posting
and this time with v4l2-compliance :)

Regards,
Shaik Ameer Basha

On Wed, Mar 19, 2014 at 1:19 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Thanks for this patch series!
>
> I've got some comments below...
>
> Regards,
>
>         Hans
>
> On 03/19/2014 08:13 AM, Shaik Ameer Basha wrote:
>> This patch adds memory to memory (m2m) interface functionality
>> for the SCALER driver.
>>
>> [arun.kk@samsung.com: fix compilation issues]
>>
>> Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
>> Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
>> Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> ---
>>  drivers/media/platform/exynos-scaler/scaler-m2m.c |  788 +++++++++++++++++++++
>>  1 file changed, 788 insertions(+)
>>  create mode 100644 drivers/media/platform/exynos-scaler/scaler-m2m.c
>>
>> diff --git a/drivers/media/platform/exynos-scaler/scaler-m2m.c b/drivers/media/platform/exynos-scaler/scaler-m2m.c
>> new file mode 100644
>> index 0000000..7b21a17
>> --- /dev/null
>> +++ b/drivers/media/platform/exynos-scaler/scaler-m2m.c
>> @@ -0,0 +1,788 @@
>> +/*
>> + * Copyright (c) 2014 Samsung Electronics Co., Ltd.
>> + *           http://www.samsung.com
>> + *
>> + * Samsung EXYNOS5 SoC series SCALER driver
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +
>> +#include <linux/module.h>
>> +#include <linux/pm_runtime.h>
>> +#include <linux/slab.h>
>> +
>> +#include <media/v4l2-ioctl.h>
>> +
>> +#include "scaler-regs.h"
>> +
>> +#define SCALER_DEF_PIX_FMT   V4L2_PIX_FMT_RGB32
>> +#define SCALER_DEF_WIDTH     1280
>> +#define SCALER_DEF_HEIGHT    720
>> +
>> +static int scaler_m2m_ctx_stop_req(struct scaler_ctx *ctx)
>> +{
>> +     struct scaler_ctx *curr_ctx;
>> +     struct scaler_dev *scaler = ctx->scaler_dev;
>> +     int ret;
>> +
>> +     curr_ctx = v4l2_m2m_get_curr_priv(scaler->m2m.m2m_dev);
>> +     if (!scaler_m2m_pending(scaler) || (curr_ctx != ctx))
>> +             return 0;
>> +
>> +     scaler_ctx_state_lock_set(SCALER_CTX_STOP_REQ, ctx);
>> +     ret = wait_event_timeout(scaler->irq_queue,
>> +                     !scaler_ctx_state_is_set(SCALER_CTX_STOP_REQ, ctx),
>> +                     SCALER_SHUTDOWN_TIMEOUT);
>> +
>> +     return ret == 0 ? -ETIMEDOUT : ret;
>> +}
>> +
>> +static int scaler_m2m_start_streaming(struct vb2_queue *q, unsigned int count)
>> +{
>> +     struct scaler_ctx *ctx = q->drv_priv;
>> +     int ret;
>> +
>> +     ret = pm_runtime_get_sync(&ctx->scaler_dev->pdev->dev);
>> +
>> +     return ret > 0 ? 0 : ret;
>> +}
>
> If an error occurs, then all queued buffers must be returned to the vb2
> core with vb2_buffer_done with state VB2_BUF_STATE_QUEUED. A lot of vb2
> instrumentation has been added in recent weeks to check for correct
> buffer handling, and this was one of the corner cases that was never
> handled correctly. If you compile with the VIDEO_ADV_DEBUG config option
> you'll see warnings appearing if this function returns an error and the
> buffers aren't requeued. It's a good test to do.
>
>> +
>> +static int scaler_m2m_stop_streaming(struct vb2_queue *q)
>> +{
>> +     struct scaler_ctx *ctx = q->drv_priv;
>> +     int ret;
>> +
>> +     ret = scaler_m2m_ctx_stop_req(ctx);
>> +     if (ret < 0)
>> +             scaler_m2m_job_finish(ctx, VB2_BUF_STATE_ERROR);
>> +
>> +     pm_runtime_put(&ctx->scaler_dev->pdev->dev);
>> +
>> +     return 0;
>> +}
>> +
>> +void scaler_m2m_job_finish(struct scaler_ctx *ctx, int vb_state)
>> +{
>> +     struct vb2_buffer *src_vb, *dst_vb;
>> +
>> +     if (!ctx || !ctx->m2m_ctx)
>> +             return;
>> +
>> +     src_vb = v4l2_m2m_src_buf_remove(ctx->m2m_ctx);
>> +     dst_vb = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx);
>> +
>> +     if (src_vb && dst_vb) {
>> +             v4l2_m2m_buf_done(src_vb, vb_state);
>> +             v4l2_m2m_buf_done(dst_vb, vb_state);
>> +
>> +             v4l2_m2m_job_finish(ctx->scaler_dev->m2m.m2m_dev,
>> +                                                     ctx->m2m_ctx);
>> +     }
>> +}
>> +
>> +static void scaler_m2m_job_abort(void *priv)
>> +{
>> +     struct scaler_ctx *ctx = priv;
>> +     int ret;
>> +
>> +     ret = scaler_m2m_ctx_stop_req(ctx);
>> +     if (ret < 0)
>> +             scaler_m2m_job_finish(ctx, VB2_BUF_STATE_ERROR);
>> +}
>> +
>> +static int scaler_get_bufs(struct scaler_ctx *ctx)
>> +{
>> +     struct scaler_frame *s_frame, *d_frame;
>> +     struct vb2_buffer *src_vb, *dst_vb;
>> +     int ret;
>> +
>> +     s_frame = &ctx->s_frame;
>> +     d_frame = &ctx->d_frame;
>> +
>> +     src_vb = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
>> +     ret = scaler_prepare_addr(ctx, src_vb, s_frame, &s_frame->addr);
>> +     if (ret < 0)
>> +             return ret;
>> +
>> +     dst_vb = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
>> +     ret = scaler_prepare_addr(ctx, dst_vb, d_frame, &d_frame->addr);
>> +     if (ret < 0)
>> +             return ret;
>> +
>> +     dst_vb->v4l2_buf.timestamp = src_vb->v4l2_buf.timestamp;
>> +
>> +     return 0;
>> +}
>> +
>> +static void scaler_m2m_device_run(void *priv)
>> +{
>> +     struct scaler_ctx *ctx = priv;
>> +     struct scaler_dev *scaler;
>> +     unsigned long flags;
>> +     int ret;
>> +     bool is_stopped;
>> +
>> +     if (WARN(!ctx, "Null hardware context\n"))
>> +             return;
>> +
>> +     scaler = ctx->scaler_dev;
>> +     spin_lock_irqsave(&scaler->slock, flags);
>> +
>> +     set_bit(ST_M2M_PEND, &scaler->state);
>> +
>> +     /* Reconfigure hardware if the context has changed. */
>> +     if (scaler->m2m.ctx != ctx) {
>> +             scaler_dbg(scaler, "scaler->m2m.ctx = 0x%p, current_ctx = 0x%p",
>> +                             scaler->m2m.ctx, ctx);
>> +             ctx->state |= SCALER_PARAMS;
>> +             scaler->m2m.ctx = ctx;
>> +     }
>> +
>> +     is_stopped = ctx->state & SCALER_CTX_STOP_REQ;
>> +     ctx->state &= ~SCALER_CTX_STOP_REQ;
>> +     if (is_stopped) {
>> +             wake_up(&scaler->irq_queue);
>> +             goto unlock;
>> +     }
>> +
>> +     ret = scaler_get_bufs(ctx);
>> +     if (ret < 0) {
>> +             scaler_dbg(scaler, "Wrong address\n");
>> +             goto unlock;
>> +     }
>> +
>> +     scaler_hw_address_queue_reset(ctx);
>> +     scaler_set_prefbuf(scaler, &ctx->s_frame);
>> +     scaler_hw_set_input_addr(scaler, &ctx->s_frame.addr);
>> +     scaler_hw_set_output_addr(scaler, &ctx->d_frame.addr);
>> +     scaler_hw_set_csc_coeff(ctx);
>> +
>> +     if (ctx->state & SCALER_PARAMS) {
>> +             scaler_hw_set_irq(scaler, SCALER_INT_FRAME_END, false);
>> +             if (scaler_set_scaler_info(ctx)) {
>> +                     scaler_dbg(scaler, "Scaler setup error");
>> +                     goto unlock;
>> +             }
>> +
>> +             scaler_hw_set_in_size(ctx);
>> +             scaler_hw_set_in_image_format(ctx);
>> +
>> +             scaler_hw_set_out_size(ctx);
>> +             scaler_hw_set_out_image_format(ctx);
>> +
>> +             scaler_hw_set_scaler_ratio(ctx);
>> +             scaler_hw_set_rotation(ctx);
>> +     }
>> +
>> +     ctx->state &= ~SCALER_PARAMS;
>> +     scaler_hw_enable_control(scaler, true);
>> +
>> +     spin_unlock_irqrestore(&scaler->slock, flags);
>> +     return;
>> +
>> +unlock:
>> +     ctx->state &= ~SCALER_PARAMS;
>> +     spin_unlock_irqrestore(&scaler->slock, flags);
>> +}
>> +
>> +static int scaler_m2m_queue_setup(struct vb2_queue *vq,
>> +                     const struct v4l2_format *fmt,
>> +                     unsigned int *num_buffers, unsigned int *num_planes,
>> +                     unsigned int sizes[], void *allocators[])
>> +{
>> +     struct scaler_ctx *ctx = vb2_get_drv_priv(vq);
>> +     struct scaler_frame *frame;
>> +     int i;
>> +
>> +     frame = ctx_get_frame(ctx, vq->type);
>> +     if (IS_ERR(frame))
>> +             return PTR_ERR(frame);
>> +
>> +     if (!frame->fmt)
>> +             return -EINVAL;
>> +
>> +     *num_planes = frame->fmt->num_planes;
>> +     for (i = 0; i < frame->fmt->num_planes; i++) {
>> +             sizes[i] = frame->payload[i];
>> +             allocators[i] = ctx->scaler_dev->alloc_ctx;
>> +     }
>> +     return 0;
>> +}
>> +
>> +static int scaler_m2m_buf_prepare(struct vb2_buffer *vb)
>> +{
>> +     struct scaler_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
>> +     struct scaler_frame *frame;
>> +     int i;
>> +
>> +     frame = ctx_get_frame(ctx, vb->vb2_queue->type);
>> +     if (IS_ERR(frame))
>> +             return PTR_ERR(frame);
>> +
>> +     for (i = 0; i < frame->fmt->num_planes; i++)
>> +             vb2_set_plane_payload(vb, i, frame->payload[i]);
>
> This sets the payload for buffers going to the hardware as well,
> but it should check whether the payload is large enough instead.
> I.e., if someone passes a buffer with too little data an error
> should be returned.
>
>> +
>> +     return 0;
>> +}
>> +
>> +static void scaler_m2m_buf_queue(struct vb2_buffer *vb)
>> +{
>> +     struct scaler_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
>> +
>> +     scaler_dbg(ctx->scaler_dev, "ctx: %p, ctx->state: 0x%x",
>> +                                  ctx, ctx->state);
>> +
>> +     if (ctx->m2m_ctx)
>> +             v4l2_m2m_buf_queue(ctx->m2m_ctx, vb);
>> +}
>> +
>> +static void scaler_lock(struct vb2_queue *vq)
>> +{
>> +     struct scaler_ctx *ctx = vb2_get_drv_priv(vq);
>> +     mutex_lock(&ctx->scaler_dev->lock);
>> +}
>> +
>> +static void scaler_unlock(struct vb2_queue *vq)
>> +{
>> +     struct scaler_ctx *ctx = vb2_get_drv_priv(vq);
>> +     mutex_unlock(&ctx->scaler_dev->lock);
>> +}
>> +
>> +static struct vb2_ops scaler_m2m_qops = {
>> +     .queue_setup     = scaler_m2m_queue_setup,
>> +     .buf_prepare     = scaler_m2m_buf_prepare,
>> +     .buf_queue       = scaler_m2m_buf_queue,
>> +     .wait_prepare    = scaler_unlock,
>> +     .wait_finish     = scaler_lock,
>> +     .stop_streaming  = scaler_m2m_stop_streaming,
>> +     .start_streaming = scaler_m2m_start_streaming,
>> +};
>
> Have you tested this driver with the latest v4l2-compliance?
>
> Just run 'v4l2-compliance -s' and it should work. If you find problems
> with v4l2-compliance itself, please let me know. It hasn't seen much
> testing with m2m drivers, so feedback is welcome.
>
>> +
>> +static int scaler_m2m_querycap(struct file *file, void *fh,
>> +                        struct v4l2_capability *cap)
>> +{
>> +     struct scaler_ctx *ctx = fh_to_ctx(fh);
>> +     struct scaler_dev *scaler = ctx->scaler_dev;
>> +
>> +     cap->device_caps = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_M2M_MPLANE;
>> +     cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
>> +
>> +     strlcpy(cap->driver, scaler->pdev->name, sizeof(cap->driver));
>> +     strlcpy(cap->card, scaler->pdev->name, sizeof(cap->card));
>> +     strlcpy(cap->bus_info, "platform:exynos5-scaler",
>> +                                     sizeof(cap->bus_info));
>> +
>> +     return 0;
>> +}
>> +
>> +static int scaler_m2m_enum_fmt_mplane(struct file *file, void *priv,
>> +                             struct v4l2_fmtdesc *f)
>> +{
>> +     return scaler_enum_fmt_mplane(f);
>> +}
>> +
>> +static int scaler_m2m_g_fmt_mplane(struct file *file, void *fh,
>> +                          struct v4l2_format *f)
>> +{
>> +     struct scaler_ctx *ctx = fh_to_ctx(fh);
>> +
>> +     return scaler_g_fmt_mplane(ctx, f);
>> +}
>> +
>> +static int scaler_m2m_try_fmt_mplane(struct file *file, void *fh,
>> +                               struct v4l2_format *f)
>> +{
>> +     struct scaler_ctx *ctx = fh_to_ctx(fh);
>> +
>> +     return scaler_try_fmt_mplane(ctx, f);
>> +}
>> +
>> +static int scaler_m2m_set_default_format(struct scaler_ctx *ctx)
>> +{
>> +     struct scaler_frame *frame;
>> +     u32 def_pixformat = SCALER_DEF_PIX_FMT;
>> +     int i;
>> +
>> +     frame = &ctx->s_frame;
>> +
>> +     frame->colorspace = V4L2_COLORSPACE_REC709;
>> +     frame->fmt = scaler_find_fmt(&def_pixformat, -1);
>> +     if (!frame->fmt)
>> +             return -EINVAL;
>> +
>> +     scaler_set_frame_size(frame, SCALER_DEF_WIDTH, SCALER_DEF_HEIGHT);
>> +     for (i = 0; i < frame->fmt->num_planes; i++)
>> +             frame->payload[i] = SCALER_DEF_WIDTH * SCALER_DEF_HEIGHT *
>> +                                     (frame->fmt->depth[i] / 8);
>> +
>> +     scaler_ctx_state_lock_set(SCALER_PARAMS, ctx);
>> +
>> +     /* Apply the same src frame settings to dst frame */
>> +     ctx->d_frame = ctx->s_frame;
>> +
>> +     return 0;
>> +}
>> +
>> +
>> +static int scaler_m2m_s_fmt_mplane(struct file *file, void *fh,
>> +                              struct v4l2_format *f)
>> +{
>> +     struct scaler_ctx *ctx = fh_to_ctx(fh);
>> +     struct vb2_queue *vq;
>> +     struct scaler_frame *frame;
>> +     struct v4l2_pix_format_mplane *pix;
>> +     int i, ret = 0;
>> +
>> +     ret = scaler_m2m_try_fmt_mplane(file, fh, f);
>> +     if (ret < 0)
>> +             return ret;
>> +
>> +     vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
>> +
>> +     if (vb2_is_streaming(vq)) {
>> +             scaler_dbg(ctx->scaler_dev, "queue (%d) busy", f->type);
>> +             return -EBUSY;
>> +     }
>> +
>> +     if (V4L2_TYPE_IS_OUTPUT(f->type))
>> +             frame = &ctx->s_frame;
>> +     else
>> +             frame = &ctx->d_frame;
>> +
>> +     pix = &f->fmt.pix_mp;
>> +     frame->colorspace = pix->colorspace;
>> +     frame->fmt = scaler_find_fmt(&pix->pixelformat, -1);
>> +     if (!frame->fmt)
>> +             return -EINVAL;
>> +
>> +     for (i = 0; i < frame->fmt->num_planes; i++)
>> +             frame->payload[i] = pix->plane_fmt[i].sizeimage;
>> +
>> +     scaler_set_frame_size(frame, pix->width, pix->height);
>> +     scaler_ctx_state_lock_set(SCALER_PARAMS, ctx);
>> +
>> +     scaler_dbg(ctx->scaler_dev, "f_w: %d, f_h: %d",
>> +                             frame->f_width, frame->f_height);
>> +
>> +     return 0;
>> +}
>> +
>> +static int scaler_m2m_reqbufs(struct file *file, void *fh,
>> +                       struct v4l2_requestbuffers *reqbufs)
>> +{
>> +     struct scaler_ctx *ctx = fh_to_ctx(fh);
>> +     struct scaler_dev *scaler = ctx->scaler_dev;
>> +     u32 max_cnt;
>> +
>> +     if (reqbufs->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
>> +             max_cnt = scaler->variant->in_buf_cnt;
>> +     else
>> +             max_cnt = scaler->variant->out_buf_cnt;
>> +
>> +     if (reqbufs->count > max_cnt) {
>> +             /* Adjust the count value as per driver supports */
>> +             reqbufs->count = max_cnt;
>> +     }
>> +
>> +     return v4l2_m2m_reqbufs(file, ctx->m2m_ctx, reqbufs);
>> +}
>> +
>> +static int scaler_m2m_expbuf(struct file *file, void *fh,
>> +                             struct v4l2_exportbuffer *eb)
>> +{
>> +     struct scaler_ctx *ctx = fh_to_ctx(fh);
>> +     return v4l2_m2m_expbuf(file, ctx->m2m_ctx, eb);
>> +}
>> +
>> +static int scaler_m2m_querybuf(struct file *file, void *fh,
>> +                                     struct v4l2_buffer *buf)
>> +{
>> +     struct scaler_ctx *ctx = fh_to_ctx(fh);
>> +     return v4l2_m2m_querybuf(file, ctx->m2m_ctx, buf);
>> +}
>> +
>> +static int scaler_m2m_qbuf(struct file *file, void *fh,
>> +                       struct v4l2_buffer *buf)
>> +{
>> +     struct scaler_ctx *ctx = fh_to_ctx(fh);
>> +     return v4l2_m2m_qbuf(file, ctx->m2m_ctx, buf);
>> +}
>> +
>> +static int scaler_m2m_dqbuf(struct file *file, void *fh,
>> +                        struct v4l2_buffer *buf)
>> +{
>> +     struct scaler_ctx *ctx = fh_to_ctx(fh);
>> +     return v4l2_m2m_dqbuf(file, ctx->m2m_ctx, buf);
>> +}
>> +
>> +static int scaler_m2m_streamon(struct file *file, void *fh,
>> +                        enum v4l2_buf_type type)
>> +{
>> +     struct scaler_ctx *ctx = fh_to_ctx(fh);
>> +     return v4l2_m2m_streamon(file, ctx->m2m_ctx, type);
>> +}
>> +
>> +static int scaler_m2m_streamoff(struct file *file, void *fh,
>> +                         enum v4l2_buf_type type)
>> +{
>> +     struct scaler_ctx *ctx = fh_to_ctx(fh);
>> +     return v4l2_m2m_streamoff(file, ctx->m2m_ctx, type);
>> +}
>
> v4l2-mem2mem.h defines a bunch of ioctl and file-operation helpers
> that you can use directly rather than creating these small stubs.
>
> Just set the m2m_ctx field of the v4l2_fh struct to ctx->m2m_ctx
> and you are good to go. This means that you need to do a 'container_of'
> to go from the m2m_ctx to the scaler_ctx pointer.
>
>> +
>> +/* Return 1 if rectangle a is enclosed in rectangle b, or 0 otherwise. */
>> +static int is_rectangle_enclosed(struct v4l2_rect *a, struct v4l2_rect *b)
>> +{
>> +     return !((a->left < b->left) ||
>> +              (a->top < b->top) ||
>> +              (a->left + a->width > b->left + b->width) ||
>> +              (a->top + a->height > b->top + b->height));
>> +}
>> +
>> +static int scaler_m2m_g_selection(struct file *file, void *fh,
>> +                     struct v4l2_selection *s)
>> +{
>> +     struct scaler_frame *frame;
>> +     struct scaler_ctx *ctx = fh_to_ctx(fh);
>> +
>> +     if ((s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) &&
>> +         (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE))
>> +             return -EINVAL;
>> +
>> +     frame = ctx_get_frame(ctx, s->type);
>> +     if (IS_ERR(frame))
>> +             return PTR_ERR(frame);
>> +
>> +     if (s->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
>> +             if ((s->target == V4L2_SEL_TGT_CROP_DEFAULT) ||
>> +                 (s->target == V4L2_SEL_TGT_CROP_BOUNDS)) {
>> +                     s->r.left = 0;
>> +                     s->r.top = 0;
>> +                     s->r.width = frame->f_width;
>> +                     s->r.height = frame->f_height;
>> +                     return 0;
>> +             }
>> +
>> +             if (s->target == V4L2_SEL_TGT_CROP) {
>> +                     s->r.left = frame->selection.left;
>> +                     s->r.top = frame->selection.top;
>> +                     s->r.width = frame->selection.width;
>> +                     s->r.height = frame->selection.height;
>> +                     return 0;
>> +             }
>> +     } else {
>> +             if ((s->target == V4L2_SEL_TGT_COMPOSE_DEFAULT) ||
>> +                 (s->target == V4L2_SEL_TGT_COMPOSE_BOUNDS)) {
>> +                     s->r.left = 0;
>> +                     s->r.top = 0;
>> +                     s->r.width = frame->f_width;
>> +                     s->r.height = frame->f_height;
>> +                     return 0;
>> +             }
>> +
>> +             if (s->target == V4L2_SEL_TGT_COMPOSE) {
>> +                     s->r.left = frame->selection.left;
>> +                     s->r.top = frame->selection.top;
>> +                     s->r.width = frame->selection.width;
>> +                     s->r.height = frame->selection.height;
>> +                     return 0;
>> +             }
>> +     }
>> +
>> +     return -EINVAL;
>> +}
>> +
>> +static int scaler_m2m_s_selection(struct file *file, void *fh,
>> +                             struct v4l2_selection *s)
>> +{
>> +     struct scaler_frame *frame;
>> +     struct scaler_ctx *ctx = fh_to_ctx(fh);
>> +     struct v4l2_crop cr;
>> +     struct scaler_variant *variant = ctx->scaler_dev->variant;
>> +     int ret;
>> +
>> +     cr.type = s->type;
>> +     cr.c = s->r;
>> +
>> +     if (!(((s->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) &&
>> +            (s->target == V4L2_SEL_TGT_CROP)) ||
>> +           ((s->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) &&
>> +            (s->target == V4L2_SEL_TGT_COMPOSE))))
>> +             return -EINVAL;
>> +
>> +     frame = ctx_get_frame(ctx, s->type);
>> +
>> +     ret = scaler_try_crop(ctx, &cr);
>> +     if (ret < 0)
>> +             return ret;
>> +
>> +     if (s->flags & V4L2_SEL_FLAG_LE &&
>> +         !is_rectangle_enclosed(&cr.c, &s->r))
>> +             return -ERANGE;
>> +
>> +     if (s->flags & V4L2_SEL_FLAG_GE &&
>> +         !is_rectangle_enclosed(&s->r, &cr.c))
>> +             return -ERANGE;
>> +
>> +     s->r = cr.c;
>> +
>> +     /* Check to see if scaling ratio is within supported range */
>> +     if (s->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
>> +             ret = scaler_check_scaler_ratio(variant,
>> +                     cr.c.width, cr.c.height,
>> +                     ctx->d_frame.selection.width,
>> +                     ctx->d_frame.selection.height,
>> +                     ctx->ctrls_scaler.rotate->val);
>> +     else
>> +             ret = scaler_check_scaler_ratio(variant,
>> +                     ctx->s_frame.selection.width,
>> +                     ctx->s_frame.selection.height,
>> +                     cr.c.width, cr.c.height,
>> +                     ctx->ctrls_scaler.rotate->val);
>> +
>> +     if (ret < 0) {
>> +             scaler_dbg(ctx->scaler_dev, "Out of scaler range");
>> +             return -EINVAL;
>> +     }
>> +
>> +     frame->selection = cr.c;
>> +
>> +     scaler_ctx_state_lock_set(SCALER_PARAMS, ctx);
>> +     return 0;
>> +}
>> +
>> +static const struct v4l2_ioctl_ops scaler_m2m_ioctl_ops = {
>> +     .vidioc_querycap                = scaler_m2m_querycap,
>> +     .vidioc_enum_fmt_vid_cap_mplane = scaler_m2m_enum_fmt_mplane,
>> +     .vidioc_enum_fmt_vid_out_mplane = scaler_m2m_enum_fmt_mplane,
>> +     .vidioc_g_fmt_vid_cap_mplane    = scaler_m2m_g_fmt_mplane,
>> +     .vidioc_g_fmt_vid_out_mplane    = scaler_m2m_g_fmt_mplane,
>> +     .vidioc_try_fmt_vid_cap_mplane  = scaler_m2m_try_fmt_mplane,
>> +     .vidioc_try_fmt_vid_out_mplane  = scaler_m2m_try_fmt_mplane,
>> +     .vidioc_s_fmt_vid_cap_mplane    = scaler_m2m_s_fmt_mplane,
>> +     .vidioc_s_fmt_vid_out_mplane    = scaler_m2m_s_fmt_mplane,
>> +     .vidioc_reqbufs                 = scaler_m2m_reqbufs,
>> +     .vidioc_expbuf                  = scaler_m2m_expbuf,
>> +     .vidioc_querybuf                = scaler_m2m_querybuf,
>> +     .vidioc_qbuf                    = scaler_m2m_qbuf,
>> +     .vidioc_dqbuf                   = scaler_m2m_dqbuf,
>> +     .vidioc_streamon                = scaler_m2m_streamon,
>> +     .vidioc_streamoff               = scaler_m2m_streamoff,
>> +     .vidioc_g_selection             = scaler_m2m_g_selection,
>> +     .vidioc_s_selection             = scaler_m2m_s_selection
>> +};
>> +
>> +static int queue_init(void *priv, struct vb2_queue *src_vq,
>> +                     struct vb2_queue *dst_vq)
>> +{
>> +     struct scaler_ctx *ctx = priv;
>> +     int ret;
>> +
>> +     memset(src_vq, 0, sizeof(*src_vq));
>> +     src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
>> +     src_vq->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
>> +     src_vq->drv_priv = ctx;
>> +     src_vq->ops = &scaler_m2m_qops;
>> +     src_vq->mem_ops = &vb2_dma_contig_memops;
>> +     src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
>> +
>> +     ret = vb2_queue_init(src_vq);
>> +     if (ret < 0)
>> +             return ret;
>> +
>> +     memset(dst_vq, 0, sizeof(*dst_vq));
>> +     dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
>> +     dst_vq->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
>> +     dst_vq->drv_priv = ctx;
>> +     dst_vq->ops = &scaler_m2m_qops;
>> +     dst_vq->mem_ops = &vb2_dma_contig_memops;
>> +     dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
>> +
>> +     return vb2_queue_init(dst_vq);
>> +}
>> +
>> +static int scaler_m2m_open(struct file *file)
>> +{
>> +     struct scaler_dev *scaler = video_drvdata(file);
>> +     struct scaler_ctx *ctx = NULL;
>> +     int ret;
>> +
>> +     scaler_dbg(scaler, "pid: %d, state: 0x%lx",
>> +                     task_pid_nr(current), scaler->state);
>> +
>> +     if (mutex_lock_interruptible(&scaler->lock))
>> +             return -ERESTARTSYS;
>> +
>> +     ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
>> +     if (!ctx) {
>> +             ret = -ENOMEM;
>> +             goto unlock;
>> +     }
>> +
>> +     v4l2_fh_init(&ctx->fh, scaler->m2m.vfd);
>> +     ret = scaler_ctrls_create(ctx);
>> +     if (ret < 0)
>> +             goto error_fh;
>> +
>> +     /* Use separate control handler per file handle */
>> +     ctx->fh.ctrl_handler = &ctx->ctrl_handler;
>> +     file->private_data = &ctx->fh;
>> +     v4l2_fh_add(&ctx->fh);
>> +
>> +     ctx->scaler_dev = scaler;
>> +     /* Default color format */
>> +     ctx->s_frame.fmt = scaler_get_format(0);
>> +     ctx->d_frame.fmt = scaler_get_format(0);
>> +     ctx->flags = 0;
>> +
>> +     ctx->m2m_ctx = v4l2_m2m_ctx_init(scaler->m2m.m2m_dev, ctx, queue_init);
>> +     if (IS_ERR(ctx->m2m_ctx)) {
>> +             scaler_dbg(scaler, "Failed to initialize m2m context");
>> +             ret = PTR_ERR(ctx->m2m_ctx);
>> +             goto error_ctrls;
>> +     }
>> +
>> +     /* Apply default format settings */
>> +     ret = scaler_m2m_set_default_format(ctx);
>> +     if (ret < 0) {
>> +             scaler_dbg(scaler, "Failed to set default format settings");
>> +             goto error_ctrls;
>> +     }
>> +
>> +     if (v4l2_fh_is_singular_file(file))
>> +             set_bit(ST_M2M_OPEN, &scaler->state);
>> +
>> +     scaler_dbg(scaler, "scaler m2m driver is opened, ctx(0x%p)", ctx);
>> +
>> +     mutex_unlock(&scaler->lock);
>> +     return 0;
>> +
>> +error_ctrls:
>> +     scaler_ctrls_delete(ctx);
>> +error_fh:
>> +     v4l2_fh_del(&ctx->fh);
>> +     v4l2_fh_exit(&ctx->fh);
>> +     kfree(ctx);
>> +unlock:
>> +     mutex_unlock(&scaler->lock);
>> +     return ret;
>> +}
>> +
>> +static int scaler_m2m_release(struct file *file)
>> +{
>> +     struct scaler_ctx *ctx = fh_to_ctx(file->private_data);
>> +     struct scaler_dev *scaler = ctx->scaler_dev;
>> +
>> +     scaler_dbg(scaler, "pid: %d, state: 0x%lx",
>> +                     task_pid_nr(current), scaler->state);
>> +
>> +     mutex_lock(&scaler->lock);
>> +
>> +     if (v4l2_fh_is_singular_file(file))
>> +             clear_bit(ST_M2M_OPEN, &scaler->state);
>> +
>> +     v4l2_m2m_ctx_release(ctx->m2m_ctx);
>> +     scaler_ctrls_delete(ctx);
>> +     v4l2_fh_del(&ctx->fh);
>> +     v4l2_fh_exit(&ctx->fh);
>> +
>> +     kfree(ctx);
>> +
>> +     mutex_unlock(&scaler->lock);
>> +     return 0;
>> +}
>> +
>> +static unsigned int scaler_m2m_poll(struct file *file,
>> +                                     struct poll_table_struct *wait)
>> +{
>> +     struct scaler_ctx *ctx = fh_to_ctx(file->private_data);
>> +     struct scaler_dev *scaler = ctx->scaler_dev;
>> +     int ret;
>> +
>> +     if (mutex_lock_interruptible(&scaler->lock))
>> +             return -ERESTARTSYS;
>> +
>> +     ret = v4l2_m2m_poll(file, ctx->m2m_ctx, wait);
>> +     mutex_unlock(&scaler->lock);
>> +
>> +     return ret;
>> +}
>> +
>> +static int scaler_m2m_mmap(struct file *file, struct vm_area_struct *vma)
>> +{
>> +     struct scaler_ctx *ctx = fh_to_ctx(file->private_data);
>> +     struct scaler_dev *scaler = ctx->scaler_dev;
>> +     int ret;
>> +
>> +     if (mutex_lock_interruptible(&scaler->lock))
>> +             return -ERESTARTSYS;
>> +
>> +     ret = v4l2_m2m_mmap(file, ctx->m2m_ctx, vma);
>> +     mutex_unlock(&scaler->lock);
>> +
>> +     return ret;
>> +}
>> +
>> +static const struct v4l2_file_operations scaler_m2m_fops = {
>> +     .owner          = THIS_MODULE,
>> +     .open           = scaler_m2m_open,
>> +     .release        = scaler_m2m_release,
>> +     .poll           = scaler_m2m_poll,
>> +     .unlocked_ioctl = video_ioctl2,
>> +     .mmap           = scaler_m2m_mmap,
>> +};
>> +
>> +static struct v4l2_m2m_ops scaler_m2m_ops = {
>> +     .device_run     = scaler_m2m_device_run,
>> +     .job_abort      = scaler_m2m_job_abort,
>> +};
>> +
>> +int scaler_register_m2m_device(struct scaler_dev *scaler)
>> +{
>> +     struct platform_device *pdev;
>> +     int ret;
>> +
>> +     if (!scaler)
>> +             return -ENODEV;
>> +
>> +     pdev = scaler->pdev;
>> +
>> +     scaler->vdev.fops       = &scaler_m2m_fops;
>> +     scaler->vdev.ioctl_ops  = &scaler_m2m_ioctl_ops;
>> +     scaler->vdev.release    = video_device_release_empty;
>> +     scaler->vdev.lock       = &scaler->lock;
>> +     scaler->vdev.vfl_dir    = VFL_DIR_M2M;
>> +     scaler->vdev.v4l2_dev   = &scaler->v4l2_dev;
>> +     snprintf(scaler->vdev.name, sizeof(scaler->vdev.name), "%s:m2m",
>> +                                     SCALER_MODULE_NAME);
>> +
>> +     video_set_drvdata(&scaler->vdev, scaler);
>> +
>> +     scaler->m2m.vfd = &scaler->vdev;
>> +     scaler->m2m.m2m_dev = v4l2_m2m_init(&scaler_m2m_ops);
>> +     if (IS_ERR(scaler->m2m.m2m_dev)) {
>> +             dev_err(&pdev->dev, "failed to initialize v4l2-m2m device\n");
>> +             return PTR_ERR(scaler->m2m.m2m_dev);
>> +     }
>> +
>> +     ret = video_register_device(&scaler->vdev, VFL_TYPE_GRABBER, -1);
>> +     if (ret < 0) {
>> +             dev_err(&pdev->dev,
>> +                      "%s(): failed to register video device\n", __func__);
>> +             v4l2_m2m_release(scaler->m2m.m2m_dev);
>> +             return ret;
>> +     }
>> +
>> +     dev_info(&pdev->dev, "scaler m2m driver registered as /dev/video%d",
>> +                          scaler->vdev.num);
>> +     return 0;
>> +}
>> +
>> +void scaler_unregister_m2m_device(struct scaler_dev *scaler)
>> +{
>> +     if (scaler) {
>> +             video_unregister_device(scaler->m2m.vfd);
>> +             v4l2_m2m_release(scaler->m2m.m2m_dev);
>> +     }
>> +}
>>
>
> Regards,
>
>         Hans
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
