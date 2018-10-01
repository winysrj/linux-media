Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:45785 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728928AbeJARDT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 1 Oct 2018 13:03:19 -0400
Subject: Re: [PATCH v3 2/3] media: meson: add v4l2 m2m video decoder driver
To: Maxime Jourdan <mjourdan@baylibre.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org
References: <20180928142816.4311-1-mjourdan@baylibre.com>
 <20180928142816.4311-3-mjourdan@baylibre.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <6fb97945-e63a-b98b-bf07-0a5088ac7232@xs4all.nl>
Date: Mon, 1 Oct 2018 12:25:59 +0200
MIME-Version: 1.0
In-Reply-To: <20180928142816.4311-3-mjourdan@baylibre.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/28/2018 04:28 PM, Maxime Jourdan wrote:
> Amlogic SoCs feature a powerful video decoder unit able to
> decode many formats, with a performance of usually up to 4k60.
> 
> This is a driver for this IP that is based around the v4l2 m2m framework.
> 
> It features decoding for:
> - MPEG 1
> - MPEG 2
> 
> Supported SoCs are: GXBB (S905), GXL (S905X/W/D), GXM (S912)
> 
> There is also a hardware bitstream parser (ESPARSER) that is handled here.
> 
> Signed-off-by: Maxime Jourdan <mjourdan@baylibre.com>
> ---
>  drivers/media/platform/Kconfig                |   10 +
>  drivers/media/platform/meson/Makefile         |    1 +
>  drivers/media/platform/meson/vdec/Makefile    |    8 +
>  .../media/platform/meson/vdec/codec_mpeg12.c  |  209 ++++
>  .../media/platform/meson/vdec/codec_mpeg12.h  |   14 +
>  drivers/media/platform/meson/vdec/dos_regs.h  |   98 ++
>  drivers/media/platform/meson/vdec/esparser.c  |  322 ++++++
>  drivers/media/platform/meson/vdec/esparser.h  |   32 +
>  drivers/media/platform/meson/vdec/vdec.c      | 1024 +++++++++++++++++
>  drivers/media/platform/meson/vdec/vdec.h      |  251 ++++
>  drivers/media/platform/meson/vdec/vdec_1.c    |  231 ++++
>  drivers/media/platform/meson/vdec/vdec_1.h    |   14 +
>  .../media/platform/meson/vdec/vdec_helpers.c  |  412 +++++++
>  .../media/platform/meson/vdec/vdec_helpers.h  |   48 +
>  .../media/platform/meson/vdec/vdec_platform.c |  101 ++
>  .../media/platform/meson/vdec/vdec_platform.h |   30 +
>  16 files changed, 2805 insertions(+)
>  create mode 100644 drivers/media/platform/meson/vdec/Makefile
>  create mode 100644 drivers/media/platform/meson/vdec/codec_mpeg12.c
>  create mode 100644 drivers/media/platform/meson/vdec/codec_mpeg12.h
>  create mode 100644 drivers/media/platform/meson/vdec/dos_regs.h
>  create mode 100644 drivers/media/platform/meson/vdec/esparser.c
>  create mode 100644 drivers/media/platform/meson/vdec/esparser.h
>  create mode 100644 drivers/media/platform/meson/vdec/vdec.c
>  create mode 100644 drivers/media/platform/meson/vdec/vdec.h
>  create mode 100644 drivers/media/platform/meson/vdec/vdec_1.c
>  create mode 100644 drivers/media/platform/meson/vdec/vdec_1.h
>  create mode 100644 drivers/media/platform/meson/vdec/vdec_helpers.c
>  create mode 100644 drivers/media/platform/meson/vdec/vdec_helpers.h
>  create mode 100644 drivers/media/platform/meson/vdec/vdec_platform.c
>  create mode 100644 drivers/media/platform/meson/vdec/vdec_platform.h
>

<snip>

> diff --git a/drivers/media/platform/meson/vdec/vdec.c b/drivers/media/platform/meson/vdec/vdec.c
> new file mode 100644
> index 000000000000..8a7f809e6923
> --- /dev/null
> +++ b/drivers/media/platform/meson/vdec/vdec.c
> @@ -0,0 +1,1024 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/*
> + * Copyright (C) 2018 BayLibre, SAS
> + * Author: Maxime Jourdan <mjourdan@baylibre.com>
> + */
> +
> +#include <linux/of_device.h>
> +#include <linux/clk.h>
> +#include <linux/io.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/mfd/syscon.h>
> +#include <linux/slab.h>
> +#include <media/v4l2-ioctl.h>
> +#include <media/v4l2-event.h>
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-mem2mem.h>
> +#include <media/v4l2-dev.h>
> +#include <media/videobuf2-dma-contig.h>
> +
> +#include "vdec.h"
> +#include "esparser.h"
> +#include "vdec_helpers.h"
> +
> +struct dummy_buf {
> +	struct vb2_v4l2_buffer vb;
> +	struct list_head list;
> +};
> +
> +/* 16 MiB for parsed bitstream swap exchange */
> +#define SIZE_VIFIFO SZ_16M
> +
> +static u32 get_output_size(u32 width, u32 height)
> +{
> +	return ALIGN(width * height, SZ_64K);
> +}
> +
> +u32 amvdec_get_output_size(struct amvdec_session *sess)
> +{
> +	return get_output_size(sess->width, sess->height);
> +}
> +EXPORT_SYMBOL_GPL(amvdec_get_output_size);
> +
> +static int vdec_codec_needs_recycle(struct amvdec_session *sess)
> +{
> +	struct amvdec_codec_ops *codec_ops = sess->fmt_out->codec_ops;
> +
> +	return codec_ops->can_recycle && codec_ops->recycle;
> +}
> +
> +static int vdec_recycle_thread(void *data)
> +{
> +	struct amvdec_session *sess = data;
> +	struct amvdec_core *core = sess->core;
> +	struct amvdec_codec_ops *codec_ops = sess->fmt_out->codec_ops;
> +	struct amvdec_buffer *tmp, *n;
> +
> +	while (!kthread_should_stop()) {
> +		mutex_lock(&sess->bufs_recycle_lock);
> +		list_for_each_entry_safe(tmp, n, &sess->bufs_recycle, list) {
> +			if (!codec_ops->can_recycle(core))
> +				break;
> +
> +			codec_ops->recycle(core, tmp->vb->index);
> +			list_del(&tmp->list);
> +			kfree(tmp);
> +		}
> +		mutex_unlock(&sess->bufs_recycle_lock);
> +
> +		usleep_range(5000, 10000);
> +	}
> +
> +	return 0;
> +}
> +
> +static int vdec_poweron(struct amvdec_session *sess)
> +{
> +	int ret;
> +	struct amvdec_ops *vdec_ops = sess->fmt_out->vdec_ops;
> +
> +	ret = clk_prepare_enable(sess->core->dos_parser_clk);
> +	if (ret)
> +		return ret;
> +
> +	ret = clk_prepare_enable(sess->core->dos_clk);
> +	if (ret)
> +		goto disable_dos_parser;
> +
> +	ret = vdec_ops->start(sess);
> +	if (ret)
> +		goto disable_dos;
> +
> +	esparser_power_up(sess);
> +
> +	return 0;
> +
> +disable_dos:
> +	clk_disable_unprepare(sess->core->dos_clk);
> +disable_dos_parser:
> +	clk_disable_unprepare(sess->core->dos_parser_clk);
> +
> +	return ret;
> +}
> +
> +static void vdec_wait_inactive(struct amvdec_session *sess)
> +{
> +	/* We consider 50ms with no IRQ to be inactive. */
> +	while (time_is_after_jiffies64(sess->last_irq_jiffies +
> +				       msecs_to_jiffies(50)))
> +		msleep(25);
> +}
> +
> +static void vdec_poweroff(struct amvdec_session *sess)
> +{
> +	struct amvdec_ops *vdec_ops = sess->fmt_out->vdec_ops;
> +	struct amvdec_codec_ops *codec_ops = sess->fmt_out->codec_ops;
> +
> +	vdec_wait_inactive(sess);
> +	if (codec_ops->drain)
> +		codec_ops->drain(sess);
> +
> +	vdec_ops->stop(sess);
> +	clk_disable_unprepare(sess->core->dos_clk);
> +	clk_disable_unprepare(sess->core->dos_parser_clk);
> +}
> +
> +static void
> +vdec_queue_recycle(struct amvdec_session *sess, struct vb2_buffer *vb)
> +{
> +	struct amvdec_buffer *new_buf;
> +
> +	new_buf = kmalloc(sizeof(*new_buf), GFP_KERNEL);
> +	new_buf->vb = vb;
> +
> +	mutex_lock(&sess->bufs_recycle_lock);
> +	list_add_tail(&new_buf->list, &sess->bufs_recycle);
> +	mutex_unlock(&sess->bufs_recycle_lock);
> +}
> +
> +static void vdec_m2m_device_run(void *priv)
> +{
> +	struct amvdec_session *sess = priv;
> +
> +	schedule_work(&sess->esparser_queue_work);
> +}
> +
> +static void vdec_m2m_job_abort(void *priv)
> +{
> +	struct amvdec_session *sess = priv;
> +
> +	v4l2_m2m_job_finish(sess->m2m_dev, sess->m2m_ctx);
> +}
> +
> +static const struct v4l2_m2m_ops vdec_m2m_ops = {
> +	.device_run = vdec_m2m_device_run,
> +	.job_abort = vdec_m2m_job_abort,
> +};
> +
> +static int vdec_queue_setup(struct vb2_queue *q,
> +		unsigned int *num_buffers, unsigned int *num_planes,
> +		unsigned int sizes[], struct device *alloc_devs[])
> +{
> +	struct amvdec_session *sess = vb2_get_drv_priv(q);
> +	const struct amvdec_format *fmt_out = sess->fmt_out;
> +	u32 output_size = amvdec_get_output_size(sess);
> +
> +	if (*num_planes) {
> +		switch (q->type) {
> +		case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
> +			if (*num_planes != 1 || sizes[0] < output_size)
> +				return -EINVAL;
> +			break;
> +		case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
> +			switch (sess->pixfmt_cap) {
> +			case V4L2_PIX_FMT_NV12M:
> +				if (*num_planes != 2 ||
> +				    sizes[0] < output_size ||
> +				    sizes[1] < output_size / 2)
> +					return -EINVAL;
> +				break;
> +			case V4L2_PIX_FMT_YUV420M:
> +				if (*num_planes != 3 ||
> +				    sizes[0] < output_size ||
> +				    sizes[1] < output_size / 4 ||
> +				    sizes[2] < output_size / 4)
> +					return -EINVAL;
> +				break;
> +			default:
> +				return -EINVAL;
> +			}
> +			break;

You want to clamp *num_buffers here as well (and likely update min_buffers_needed).

Note that *num_buffers in this case refers to the number of buffers that
VIDIOC_CREATE_BUFS wants to add. So the total number of buffers after this
call is actually *num_buffers + q->num_buffers.

> +		}
> +
> +		return 0;
> +	}
> +
> +	switch (q->type) {
> +	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
> +		sizes[0] = amvdec_get_output_size(sess);
> +		*num_planes = 1;
> +		break;
> +	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
> +		switch (sess->pixfmt_cap) {
> +		case V4L2_PIX_FMT_NV12M:
> +			sizes[0] = output_size;
> +			sizes[1] = output_size / 2;
> +			*num_planes = 2;
> +			break;
> +		case V4L2_PIX_FMT_YUV420M:
> +			sizes[0] = output_size;
> +			sizes[1] = output_size / 4;
> +			sizes[2] = output_size / 4;
> +			*num_planes = 3;
> +			break;
> +		default:
> +			return -EINVAL;
> +		}
> +		*num_buffers = min(max(*num_buffers, fmt_out->min_buffers),
> +				   fmt_out->max_buffers);

You can use clamp here. That's easier to read.

> +		/* The HW needs all buffers to be configured during startup */

Why? I kind of expected to see 'q->min_buffers_needed = fmt_out->min_buffers'
here. I think some more information is needed here in the comment.

> +		q->min_buffers_needed = *num_buffers;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static void vdec_vb2_buf_queue(struct vb2_buffer *vb)
> +{
> +	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
> +	struct amvdec_session *sess = vb2_get_drv_priv(vb->vb2_queue);
> +	struct v4l2_m2m_ctx *m2m_ctx = sess->m2m_ctx;
> +
> +	v4l2_m2m_buf_queue(m2m_ctx, vbuf);
> +
> +	if (!sess->streamon_out || !sess->streamon_cap)
> +		return;
> +
> +	if (vb->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE &&
> +	    vdec_codec_needs_recycle(sess))
> +		vdec_queue_recycle(sess, vb);
> +
> +	schedule_work(&sess->esparser_queue_work);
> +}
> +
> +static int vdec_start_streaming(struct vb2_queue *q, unsigned int count)
> +{
> +	struct amvdec_session *sess = vb2_get_drv_priv(q);
> +	struct amvdec_core *core = sess->core;
> +	struct vb2_v4l2_buffer *buf;
> +	int ret;
> +
> +	if (core->cur_sess && core->cur_sess != sess) {
> +		ret = -EBUSY;
> +		goto bufs_done;
> +	}
> +
> +	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
> +		sess->streamon_out = 1;
> +	else
> +		sess->streamon_cap = 1;
> +
> +	if (!sess->streamon_out || !sess->streamon_cap)
> +		return 0;
> +
> +	sess->vififo_size = SIZE_VIFIFO;
> +	sess->vififo_vaddr =
> +		dma_alloc_coherent(sess->core->dev, sess->vififo_size,
> +				   &sess->vififo_paddr, GFP_KERNEL);
> +	if (!sess->vififo_vaddr) {
> +		dev_err(sess->core->dev, "Failed to request VIFIFO buffer\n");
> +		ret = -ENOMEM;
> +		goto bufs_done;
> +	}
> +
> +	sess->should_stop = 0;
> +	sess->keyframe_found = 0;
> +	sess->last_offset = 0;
> +	sess->wrap_count = 0;
> +	sess->pixelaspect.numerator = 1;
> +	sess->pixelaspect.denominator = 1;
> +	atomic_set(&sess->esparser_queued_bufs, 0);
> +
> +	ret = vdec_poweron(sess);
> +	if (ret)
> +		goto vififo_free;
> +
> +	sess->sequence_cap = 0;
> +	if (vdec_codec_needs_recycle(sess))
> +		sess->recycle_thread = kthread_run(vdec_recycle_thread, sess,
> +						   "vdec_recycle");
> +
> +	core->cur_sess = sess;
> +
> +	return 0;
> +
> +vififo_free:
> +	dma_free_coherent(sess->core->dev, sess->vififo_size,
> +			  sess->vififo_vaddr, sess->vififo_paddr);
> +bufs_done:
> +	while ((buf = v4l2_m2m_src_buf_remove(sess->m2m_ctx)))
> +		v4l2_m2m_buf_done(buf, VB2_BUF_STATE_QUEUED);
> +	while ((buf = v4l2_m2m_dst_buf_remove(sess->m2m_ctx)))
> +		v4l2_m2m_buf_done(buf, VB2_BUF_STATE_QUEUED);
> +
> +	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
> +		sess->streamon_out = 0;
> +	else
> +		sess->streamon_cap = 0;
> +
> +	return ret;
> +}
> +
> +static void vdec_free_canvas(struct amvdec_session *sess)
> +{
> +	int i;
> +
> +	for (i = 0; i < sess->canvas_num; ++i)
> +		meson_canvas_free(sess->core->canvas, sess->canvas_alloc[i]);
> +
> +	sess->canvas_num = 0;
> +}
> +
> +static void vdec_reset_timestamps(struct amvdec_session *sess)
> +{
> +	struct amvdec_timestamp *tmp, *n;
> +
> +	list_for_each_entry_safe(tmp, n, &sess->timestamps, list) {
> +		list_del(&tmp->list);
> +		kfree(tmp);
> +	}
> +}
> +
> +static void vdec_reset_bufs_recycle(struct amvdec_session *sess)
> +{
> +	struct amvdec_buffer *tmp, *n;
> +
> +	list_for_each_entry_safe(tmp, n, &sess->bufs_recycle, list) {
> +		list_del(&tmp->list);
> +		kfree(tmp);
> +	}
> +}
> +
> +static void vdec_stop_streaming(struct vb2_queue *q)
> +{
> +	struct amvdec_session *sess = vb2_get_drv_priv(q);
> +	struct amvdec_core *core = sess->core;
> +	struct vb2_v4l2_buffer *buf;
> +
> +	if (sess->streamon_out && sess->streamon_cap) {
> +		if (vdec_codec_needs_recycle(sess))
> +			kthread_stop(sess->recycle_thread);
> +
> +		vdec_poweroff(sess);
> +		vdec_free_canvas(sess);
> +		dma_free_coherent(sess->core->dev, sess->vififo_size,
> +				  sess->vififo_vaddr, sess->vififo_paddr);
> +		vdec_reset_timestamps(sess);
> +		vdec_reset_bufs_recycle(sess);
> +		kfree(sess->priv);
> +		sess->priv = NULL;
> +		core->cur_sess = NULL;
> +	}
> +
> +	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
> +		while ((buf = v4l2_m2m_src_buf_remove(sess->m2m_ctx)))
> +			v4l2_m2m_buf_done(buf, VB2_BUF_STATE_ERROR);
> +
> +		sess->streamon_out = 0;
> +	} else {
> +		while ((buf = v4l2_m2m_dst_buf_remove(sess->m2m_ctx)))
> +			v4l2_m2m_buf_done(buf, VB2_BUF_STATE_ERROR);
> +
> +		sess->streamon_cap = 0;
> +	}
> +}
> +
> +static const struct vb2_ops vdec_vb2_ops = {
> +	.queue_setup = vdec_queue_setup,
> +	.start_streaming = vdec_start_streaming,
> +	.stop_streaming = vdec_stop_streaming,
> +	.buf_queue = vdec_vb2_buf_queue,
> +	.wait_prepare = vb2_ops_wait_prepare,
> +	.wait_finish = vb2_ops_wait_finish,
> +};
> +
> +static int
> +vdec_querycap(struct file *file, void *fh, struct v4l2_capability *cap)
> +{
> +	strlcpy(cap->driver, "meson-vdec", sizeof(cap->driver));
> +	strlcpy(cap->card, "Amlogic Video Decoder", sizeof(cap->card));
> +	strlcpy(cap->bus_info, "platform:meson-vdec", sizeof(cap->bus_info));

Replace all strlcpy/strcpy/strncpy by strscpy. That's the recommended function.

> +
> +	return 0;
> +}
> +
> +static const struct amvdec_format *
> +find_format(const struct amvdec_format *fmts, u32 size, u32 pixfmt)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < size; i++) {
> +		if (fmts[i].pixfmt == pixfmt)
> +			return &fmts[i];
> +	}
> +
> +	return NULL;
> +}
> +
> +static unsigned int
> +vdec_supports_pixfmt_cap(const struct amvdec_format *fmt_out, u32 pixfmt_cap)
> +{
> +	int i;
> +
> +	for (i = 0; fmt_out->pixfmts_cap[i]; i++)
> +		if (fmt_out->pixfmts_cap[i] == pixfmt_cap)
> +			return 1;
> +
> +	return 0;
> +}
> +
> +static const struct amvdec_format *
> +vdec_try_fmt_common(struct amvdec_session *sess, u32 size,
> +		    struct v4l2_format *f)
> +{
> +	struct v4l2_pix_format_mplane *pixmp = &f->fmt.pix_mp;
> +	struct v4l2_plane_pix_format *pfmt = pixmp->plane_fmt;
> +	const struct amvdec_format *fmts = sess->core->platform->formats;
> +	const struct amvdec_format *fmt_out;
> +
> +	memset(pfmt[0].reserved, 0, sizeof(pfmt[0].reserved));
> +	memset(pixmp->reserved, 0, sizeof(pixmp->reserved));
> +
> +	if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
> +		fmt_out = find_format(fmts, size, pixmp->pixelformat);
> +		if (!fmt_out) {
> +			pixmp->pixelformat = V4L2_PIX_FMT_MPEG2;
> +			fmt_out = find_format(fmts, size, pixmp->pixelformat);
> +		}
> +
> +		pfmt[0].sizeimage =
> +			get_output_size(pixmp->width, pixmp->height);
> +		pfmt[0].bytesperline = 0;
> +		pixmp->num_planes = 1;
> +	} else if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
> +		fmt_out = sess->fmt_out;
> +		if (!vdec_supports_pixfmt_cap(fmt_out, pixmp->pixelformat))
> +			pixmp->pixelformat = fmt_out->pixfmts_cap[0];
> +
> +		memset(pfmt[1].reserved, 0, sizeof(pfmt[1].reserved));
> +		if (pixmp->pixelformat == V4L2_PIX_FMT_NV12M) {
> +			pfmt[0].sizeimage =
> +				get_output_size(pixmp->width, pixmp->height);
> +			pfmt[0].bytesperline = ALIGN(pixmp->width, 64);
> +
> +			pfmt[1].sizeimage =
> +			      get_output_size(pixmp->width, pixmp->height) / 2;
> +			pfmt[1].bytesperline = ALIGN(pixmp->width, 64);
> +			pixmp->num_planes = 2;
> +		} else if (pixmp->pixelformat == V4L2_PIX_FMT_YUV420M) {
> +			pfmt[0].sizeimage =
> +				get_output_size(pixmp->width, pixmp->height);
> +			pfmt[0].bytesperline = ALIGN(pixmp->width, 64);
> +
> +			pfmt[1].sizeimage =
> +			      get_output_size(pixmp->width, pixmp->height) / 4;
> +			pfmt[1].bytesperline = ALIGN(pixmp->width, 64) / 2;
> +
> +			pfmt[2].sizeimage =
> +			      get_output_size(pixmp->width, pixmp->height) / 4;
> +			pfmt[2].bytesperline = ALIGN(pixmp->width, 64) / 2;
> +			pixmp->num_planes = 3;
> +		}
> +	} else {
> +		return NULL;
> +	}
> +
> +	pixmp->width  = clamp(pixmp->width,  (u32)256, fmt_out->max_width);
> +	pixmp->height = clamp(pixmp->height, (u32)144, fmt_out->max_height);
> +
> +	if (pixmp->field == V4L2_FIELD_ANY)
> +		pixmp->field = V4L2_FIELD_NONE;
> +
> +	return fmt_out;
> +}
> +
> +static int vdec_try_fmt(struct file *file, void *fh, struct v4l2_format *f)
> +{
> +	struct amvdec_session *sess =
> +		container_of(file->private_data, struct amvdec_session, fh);
> +
> +	vdec_try_fmt_common(sess, sess->core->platform->num_formats, f);
> +
> +	return 0;
> +}
> +
> +static int vdec_g_fmt(struct file *file, void *fh, struct v4l2_format *f)
> +{
> +	struct amvdec_session *sess =
> +		container_of(file->private_data, struct amvdec_session, fh);
> +	struct v4l2_pix_format_mplane *pixmp = &f->fmt.pix_mp;
> +
> +	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
> +		pixmp->pixelformat = sess->pixfmt_cap;
> +	else if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
> +		pixmp->pixelformat = sess->fmt_out->pixfmt;
> +
> +	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
> +		pixmp->width = sess->width;
> +		pixmp->height = sess->height;
> +		pixmp->colorspace = sess->colorspace;
> +		pixmp->ycbcr_enc = sess->ycbcr_enc;
> +		pixmp->quantization = sess->quantization;
> +		pixmp->xfer_func = sess->xfer_func;
> +	} else if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
> +		pixmp->width = sess->width;
> +		pixmp->height = sess->height;
> +	}
> +
> +	vdec_try_fmt_common(sess, sess->core->platform->num_formats, f);
> +
> +	return 0;
> +}
> +
> +static int vdec_s_fmt(struct file *file, void *fh, struct v4l2_format *f)
> +{
> +	struct amvdec_session *sess =
> +		container_of(file->private_data, struct amvdec_session, fh);
> +	struct v4l2_pix_format_mplane *pixmp = &f->fmt.pix_mp;
> +	u32 num_formats = sess->core->platform->num_formats;
> +	const struct amvdec_format *fmt_out;
> +	struct v4l2_pix_format_mplane orig_pixmp;
> +	struct v4l2_format format;
> +	u32 pixfmt_out = 0, pixfmt_cap = 0;
> +
> +	orig_pixmp = *pixmp;
> +
> +	fmt_out = vdec_try_fmt_common(sess, num_formats, f);
> +
> +	if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
> +		pixfmt_out = pixmp->pixelformat;
> +		pixfmt_cap = sess->pixfmt_cap;
> +	} else if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
> +		pixfmt_cap = pixmp->pixelformat;
> +		pixfmt_out = sess->fmt_out->pixfmt;
> +	}
> +
> +	memset(&format, 0, sizeof(format));
> +
> +	format.type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
> +	format.fmt.pix_mp.pixelformat = pixfmt_out;
> +	format.fmt.pix_mp.width = orig_pixmp.width;
> +	format.fmt.pix_mp.height = orig_pixmp.height;
> +	vdec_try_fmt_common(sess, num_formats, &format);
> +
> +	if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
> +		sess->width = format.fmt.pix_mp.width;
> +		sess->height = format.fmt.pix_mp.height;
> +		sess->colorspace = pixmp->colorspace;
> +		sess->ycbcr_enc = pixmp->ycbcr_enc;
> +		sess->quantization = pixmp->quantization;
> +		sess->xfer_func = pixmp->xfer_func;
> +	}
> +
> +	memset(&format, 0, sizeof(format));
> +
> +	format.type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
> +	format.fmt.pix_mp.pixelformat = pixfmt_cap;
> +	format.fmt.pix_mp.width = orig_pixmp.width;
> +	format.fmt.pix_mp.height = orig_pixmp.height;
> +	vdec_try_fmt_common(sess, num_formats, &format);
> +
> +	sess->width = format.fmt.pix_mp.width;
> +	sess->height = format.fmt.pix_mp.height;
> +
> +	if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
> +		sess->fmt_out = fmt_out;
> +	else if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
> +		sess->pixfmt_cap = format.fmt.pix_mp.pixelformat;
> +
> +	return 0;
> +}
> +
> +static int vdec_enum_fmt(struct file *file, void *fh, struct v4l2_fmtdesc *f)
> +{
> +	struct amvdec_session *sess =
> +		container_of(file->private_data, struct amvdec_session, fh);
> +	const struct vdec_platform *platform = sess->core->platform;
> +	const struct amvdec_format *fmt_out;
> +
> +	memset(f->reserved, 0, sizeof(f->reserved));
> +
> +	if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
> +		if (f->index >= platform->num_formats)
> +			return -EINVAL;
> +
> +		fmt_out = &platform->formats[f->index];
> +		f->pixelformat = fmt_out->pixfmt;
> +	} else if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
> +		fmt_out = sess->fmt_out;
> +		if (f->index >= 4 || !fmt_out->pixfmts_cap[f->index])
> +			return -EINVAL;
> +
> +		f->pixelformat = fmt_out->pixfmts_cap[f->index];
> +	} else {
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static int vdec_enum_framesizes(struct file *file, void *fh,
> +				struct v4l2_frmsizeenum *fsize)
> +{
> +	struct amvdec_session *sess =
> +		container_of(file->private_data, struct amvdec_session, fh);
> +	const struct amvdec_format *formats = sess->core->platform->formats;
> +	const struct amvdec_format *fmt;
> +	u32 num_formats = sess->core->platform->num_formats;
> +
> +	fmt = find_format(formats, num_formats, fsize->pixel_format);
> +	if (!fmt || fsize->index)
> +		return -EINVAL;
> +
> +	fsize->type = V4L2_FRMSIZE_TYPE_STEPWISE;
> +
> +	fsize->stepwise.min_width = 256;
> +	fsize->stepwise.max_width = fmt->max_width;
> +	fsize->stepwise.step_width = 1;
> +	fsize->stepwise.min_height = 144;
> +	fsize->stepwise.max_height = fmt->max_height;
> +	fsize->stepwise.step_height = 1;
> +
> +	return 0;
> +}
> +
> +static int
> +vdec_try_decoder_cmd(struct file *file, void *fh, struct v4l2_decoder_cmd *cmd)
> +{
> +	switch (cmd->cmd) {
> +	case V4L2_DEC_CMD_STOP:
> +		if (cmd->flags & V4L2_DEC_CMD_STOP_TO_BLACK)
> +			return -EINVAL;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static int
> +vdec_decoder_cmd(struct file *file, void *fh, struct v4l2_decoder_cmd *cmd)
> +{
> +	struct amvdec_session *sess =
> +		container_of(file->private_data, struct amvdec_session, fh);
> +	struct amvdec_codec_ops *codec_ops = sess->fmt_out->codec_ops;
> +	struct device *dev = sess->core->dev;
> +	int ret;
> +
> +	ret = vdec_try_decoder_cmd(file, fh, cmd);
> +	if (ret)
> +		return ret;
> +
> +	if (!(sess->streamon_out & sess->streamon_cap))
> +		return 0;
> +
> +	dev_dbg(dev, "Received V4L2_DEC_CMD_STOP\n");
> +	sess->should_stop = 1;
> +
> +	vdec_wait_inactive(sess);
> +
> +	if (codec_ops->drain) {
> +		codec_ops->drain(sess);
> +	} else if (codec_ops->eos_sequence) {
> +		u32 len;
> +		const u8 *data = codec_ops->eos_sequence(&len);
> +
> +		esparser_queue_eos(sess->core, data, len);
> +	}
> +
> +	return ret;
> +}
> +
> +static int vdec_subscribe_event(struct v4l2_fh *fh,
> +				const struct v4l2_event_subscription *sub)
> +{
> +	switch (sub->type) {
> +	case V4L2_EVENT_EOS:
> +		return v4l2_event_subscribe(fh, sub, 2, NULL);
> +	default:
> +		return -EINVAL;
> +	}
> +}
> +
> +static int vdec_cropcap(struct file *file, void *fh,
> +			struct v4l2_cropcap *crop)
> +{
> +	struct amvdec_session *sess =
> +		container_of(file->private_data, struct amvdec_session, fh);
> +
> +	if (crop->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
> +		return -EINVAL;
> +
> +	crop->pixelaspect = sess->pixelaspect;
> +	return 0;
> +}
> +
> +static const struct v4l2_ioctl_ops vdec_ioctl_ops = {
> +	.vidioc_querycap = vdec_querycap,
> +	.vidioc_enum_fmt_vid_cap_mplane = vdec_enum_fmt,
> +	.vidioc_enum_fmt_vid_out_mplane = vdec_enum_fmt,
> +	.vidioc_s_fmt_vid_cap_mplane = vdec_s_fmt,
> +	.vidioc_s_fmt_vid_out_mplane = vdec_s_fmt,
> +	.vidioc_g_fmt_vid_cap_mplane = vdec_g_fmt,
> +	.vidioc_g_fmt_vid_out_mplane = vdec_g_fmt,
> +	.vidioc_try_fmt_vid_cap_mplane = vdec_try_fmt,
> +	.vidioc_try_fmt_vid_out_mplane = vdec_try_fmt,
> +	.vidioc_reqbufs = v4l2_m2m_ioctl_reqbufs,
> +	.vidioc_querybuf = v4l2_m2m_ioctl_querybuf,
> +	.vidioc_create_bufs = v4l2_m2m_ioctl_create_bufs,
> +	.vidioc_prepare_buf = v4l2_m2m_ioctl_prepare_buf,
> +	.vidioc_qbuf = v4l2_m2m_ioctl_qbuf,
> +	.vidioc_expbuf = v4l2_m2m_ioctl_expbuf,
> +	.vidioc_dqbuf = v4l2_m2m_ioctl_dqbuf,
> +	.vidioc_streamon = v4l2_m2m_ioctl_streamon,
> +	.vidioc_streamoff = v4l2_m2m_ioctl_streamoff,
> +	.vidioc_enum_framesizes = vdec_enum_framesizes,
> +	.vidioc_subscribe_event = vdec_subscribe_event,
> +	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
> +	.vidioc_try_decoder_cmd = vdec_try_decoder_cmd,
> +	.vidioc_decoder_cmd = vdec_decoder_cmd,
> +	.vidioc_cropcap = vdec_cropcap,
> +};
> +
> +static int m2m_queue_init(void *priv, struct vb2_queue *src_vq,
> +			  struct vb2_queue *dst_vq)
> +{
> +	struct amvdec_session *sess = priv;
> +	int ret;
> +
> +	src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
> +	src_vq->io_modes = VB2_MMAP | VB2_DMABUF;
> +	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
> +	src_vq->ops = &vdec_vb2_ops;
> +	src_vq->mem_ops = &vb2_dma_contig_memops;
> +	src_vq->drv_priv = sess;
> +	src_vq->buf_struct_size = sizeof(struct dummy_buf);
> +	src_vq->min_buffers_needed = 1;
> +	src_vq->dev = sess->core->dev;
> +	src_vq->lock = &sess->lock;
> +	ret = vb2_queue_init(src_vq);
> +	if (ret)
> +		return ret;
> +
> +	dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
> +	dst_vq->io_modes = VB2_MMAP | VB2_DMABUF;
> +	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
> +	dst_vq->ops = &vdec_vb2_ops;
> +	dst_vq->mem_ops = &vb2_dma_contig_memops;
> +	dst_vq->drv_priv = sess;
> +	dst_vq->buf_struct_size = sizeof(struct dummy_buf);
> +	dst_vq->min_buffers_needed = 1;
> +	dst_vq->dev = sess->core->dev;
> +	dst_vq->lock = &sess->lock;
> +	ret = vb2_queue_init(dst_vq);
> +	if (ret) {
> +		vb2_queue_release(src_vq);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static int vdec_open(struct file *file)
> +{
> +	struct amvdec_core *core = video_drvdata(file);
> +	struct device *dev = core->dev;
> +	const struct amvdec_format *formats = core->platform->formats;
> +	struct amvdec_session *sess;
> +	int ret;
> +
> +	sess = kzalloc(sizeof(*sess), GFP_KERNEL);
> +	if (!sess)
> +		return -ENOMEM;
> +
> +	sess->core = core;
> +
> +	sess->m2m_dev = v4l2_m2m_init(&vdec_m2m_ops);
> +	if (IS_ERR(sess->m2m_dev)) {
> +		dev_err(dev, "Fail to v4l2_m2m_init\n");
> +		ret = PTR_ERR(sess->m2m_dev);
> +		goto err_free_sess;
> +	}
> +
> +	sess->m2m_ctx = v4l2_m2m_ctx_init(sess->m2m_dev, sess, m2m_queue_init);
> +	if (IS_ERR(sess->m2m_ctx)) {
> +		dev_err(dev, "Fail to v4l2_m2m_ctx_init\n");
> +		ret = PTR_ERR(sess->m2m_ctx);
> +		goto err_m2m_release;
> +	}
> +
> +	sess->pixfmt_cap = formats[0].pixfmts_cap[0];
> +	sess->fmt_out = &formats[0];
> +	sess->width = 1280;
> +	sess->height = 720;
> +	sess->pixelaspect.numerator = 1;
> +	sess->pixelaspect.denominator = 1;
> +
> +	INIT_LIST_HEAD(&sess->timestamps);
> +	INIT_LIST_HEAD(&sess->bufs_recycle);
> +	INIT_WORK(&sess->esparser_queue_work, esparser_queue_all_src);
> +	mutex_init(&sess->lock);
> +	mutex_init(&sess->bufs_recycle_lock);
> +	spin_lock_init(&sess->ts_spinlock);
> +
> +	v4l2_fh_init(&sess->fh, core->vdev_dec);
> +	v4l2_fh_add(&sess->fh);
> +	sess->fh.m2m_ctx = sess->m2m_ctx;
> +	file->private_data = &sess->fh;
> +
> +	return 0;
> +
> +err_m2m_release:
> +	v4l2_m2m_release(sess->m2m_dev);
> +err_free_sess:
> +	kfree(sess);
> +	return ret;
> +}
> +
> +static int vdec_close(struct file *file)
> +{
> +	struct amvdec_session *sess =
> +		container_of(file->private_data, struct amvdec_session, fh);
> +
> +	v4l2_m2m_ctx_release(sess->m2m_ctx);
> +	v4l2_m2m_release(sess->m2m_dev);
> +	v4l2_fh_del(&sess->fh);
> +	v4l2_fh_exit(&sess->fh);
> +
> +	mutex_destroy(&sess->lock);
> +	mutex_destroy(&sess->bufs_recycle_lock);
> +
> +	kfree(sess);
> +
> +	return 0;
> +}
> +
> +static const struct v4l2_file_operations vdec_fops = {
> +	.owner = THIS_MODULE,
> +	.open = vdec_open,
> +	.release = vdec_close,
> +	.unlocked_ioctl = video_ioctl2,
> +	.poll = v4l2_m2m_fop_poll,
> +	.mmap = v4l2_m2m_fop_mmap,
> +};
> +
> +static irqreturn_t vdec_isr(int irq, void *data)
> +{
> +	struct amvdec_core *core = data;
> +	struct amvdec_session *sess = core->cur_sess;
> +
> +	sess->last_irq_jiffies = get_jiffies_64();
> +
> +	return sess->fmt_out->codec_ops->isr(sess);
> +}
> +
> +static irqreturn_t vdec_threaded_isr(int irq, void *data)
> +{
> +	struct amvdec_core *core = data;
> +	struct amvdec_session *sess = core->cur_sess;
> +
> +	return sess->fmt_out->codec_ops->threaded_isr(sess);
> +}
> +
> +static const struct of_device_id vdec_dt_match[] = {
> +	{ .compatible = "amlogic,gxbb-vdec",
> +	  .data = &vdec_platform_gxbb },
> +	{ .compatible = "amlogic,gxm-vdec",
> +	  .data = &vdec_platform_gxm },
> +	{ .compatible = "amlogic,gxl-vdec",
> +	  .data = &vdec_platform_gxl },
> +	{}
> +};
> +MODULE_DEVICE_TABLE(of, vdec_dt_match);
> +
> +static int vdec_probe(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct video_device *vdev;
> +	struct amvdec_core *core;
> +	struct resource *r;
> +	const struct of_device_id *of_id;
> +	int irq;
> +	int ret;
> +
> +	core = devm_kzalloc(dev, sizeof(*core), GFP_KERNEL);
> +	if (!core)
> +		return -ENOMEM;
> +
> +	core->dev = dev;
> +	platform_set_drvdata(pdev, core);
> +
> +	r = platform_get_resource_byname(pdev, IORESOURCE_MEM, "dos");
> +	core->dos_base = devm_ioremap_resource(dev, r);
> +	if (IS_ERR(core->dos_base)) {
> +		dev_err(dev, "Couldn't remap DOS memory\n");
> +		return PTR_ERR(core->dos_base);
> +	}
> +
> +	r = platform_get_resource_byname(pdev, IORESOURCE_MEM, "esparser");
> +	core->esparser_base = devm_ioremap_resource(dev, r);
> +	if (IS_ERR(core->esparser_base)) {
> +		dev_err(dev, "Couldn't remap ESPARSER memory\n");
> +		return PTR_ERR(core->esparser_base);
> +	}
> +
> +	core->regmap_ao = syscon_regmap_lookup_by_phandle(dev->of_node,
> +							 "amlogic,ao-sysctrl");
> +	if (IS_ERR(core->regmap_ao)) {
> +		dev_err(dev, "Couldn't regmap AO sysctrl\n");
> +		return PTR_ERR(core->regmap_ao);
> +	}
> +
> +	core->canvas = meson_canvas_get(dev);
> +	if (!core->canvas)
> +		return PTR_ERR(core->canvas);
> +
> +	core->dos_parser_clk = devm_clk_get(dev, "dos_parser");
> +	if (IS_ERR(core->dos_parser_clk))
> +		return -EPROBE_DEFER;
> +
> +	core->dos_clk = devm_clk_get(dev, "dos");
> +	if (IS_ERR(core->dos_clk))
> +		return -EPROBE_DEFER;
> +
> +	core->vdec_1_clk = devm_clk_get(dev, "vdec_1");
> +	if (IS_ERR(core->vdec_1_clk))
> +		return -EPROBE_DEFER;
> +
> +	core->vdec_hevc_clk = devm_clk_get(dev, "vdec_hevc");
> +	if (IS_ERR(core->vdec_hevc_clk))
> +		return -EPROBE_DEFER;
> +
> +	irq = platform_get_irq_byname(pdev, "vdec");
> +	if (irq < 0)
> +		return irq;
> +
> +	ret = devm_request_threaded_irq(core->dev, irq, vdec_isr,
> +					vdec_threaded_isr, IRQF_ONESHOT,
> +					"vdec", core);
> +	if (ret)
> +		return ret;
> +
> +	ret = esparser_init(pdev, core);
> +	if (ret)
> +		return ret;
> +
> +	ret = v4l2_device_register(dev, &core->v4l2_dev);
> +	if (ret) {
> +		dev_err(dev, "Couldn't register v4l2 device\n");
> +		return -ENOMEM;
> +	}
> +
> +	vdev = video_device_alloc();
> +	if (!vdev) {
> +		ret = -ENOMEM;
> +		goto err_vdev_release;
> +	}
> +
> +	of_id = of_match_node(vdec_dt_match, dev->of_node);
> +	core->platform = of_id->data;
> +	core->vdev_dec = vdev;
> +	core->dev_dec = dev;
> +	mutex_init(&core->lock);
> +
> +	strlcpy(vdev->name, "meson-video-decoder", sizeof(vdev->name));
> +	vdev->release = video_device_release;
> +	vdev->fops = &vdec_fops;
> +	vdev->ioctl_ops = &vdec_ioctl_ops;
> +	vdev->vfl_dir = VFL_DIR_M2M;
> +	vdev->v4l2_dev = &core->v4l2_dev;
> +	vdev->lock = &core->lock;
> +	vdev->device_caps = V4L2_CAP_VIDEO_M2M_MPLANE | V4L2_CAP_STREAMING;
> +
> +	video_set_drvdata(vdev, core);
> +
> +	ret = video_register_device(vdev, VFL_TYPE_GRABBER, -1);
> +	if (ret) {
> +		dev_err(dev, "Failed registering video device\n");
> +		goto err_vdev_release;
> +	}
> +
> +	return 0;
> +
> +err_vdev_release:
> +	video_device_release(vdev);
> +	return ret;
> +}
> +
> +static int vdec_remove(struct platform_device *pdev)
> +{
> +	struct amvdec_core *core = platform_get_drvdata(pdev);
> +
> +	video_unregister_device(core->vdev_dec);
> +
> +	return 0;
> +}
> +
> +static struct platform_driver meson_vdec_driver = {
> +	.probe = vdec_probe,
> +	.remove = vdec_remove,
> +	.driver = {
> +		.name = "meson-vdec",
> +		.of_match_table = vdec_dt_match,
> +	},
> +};
> +module_platform_driver(meson_vdec_driver);
> +
> +MODULE_DESCRIPTION("Meson video decoder driver for GXBB/GXL/GXM");
> +MODULE_AUTHOR("Maxime Jourdan <mjourdan@baylibre.com>");
> +MODULE_LICENSE("GPL");

<snip>

Regards,

	Hans
