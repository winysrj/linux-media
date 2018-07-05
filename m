Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:53019 "EHLO
        relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753345AbeGEWJY (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 5 Jul 2018 18:09:24 -0400
Subject: Re: [PATCH 16/16] media: imx: add mem2mem device
To: Philipp Zabel <p.zabel@pengutronix.de>,
        <linux-media@vger.kernel.org>
CC: <kernel@pengutronix.de>, Steve Longerbeam <slongerbeam@gmail.com>
References: <20180622155217.29302-1-p.zabel@pengutronix.de>
 <20180622155217.29302-17-p.zabel@pengutronix.de>
From: Steve Longerbeam <steve_longerbeam@mentor.com>
Message-ID: <8b4ea4ab-0500-9daa-e6e1-031e7d7a0517@mentor.com>
Date: Thu, 5 Jul 2018 15:09:20 -0700
MIME-Version: 1.0
In-Reply-To: <20180622155217.29302-17-p.zabel@pengutronix.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,


On 06/22/2018 08:52 AM, Philipp Zabel wrote:
> Add a single imx-media mem2mem video device that uses the IPU IC PP
> (image converter post processing) task for scaling and colorspace
> conversion.
> On i.MX6Q/DL SoCs with two IPUs currently only the first IPU is used.
>
> The hardware only supports writing to destination buffers up to
> 1024x1024 pixels in a single pass, so the mem2mem video device is
> limited to this resolution. After fixing the tiling code it should
> be possible to extend this to arbitrary sizes by rendering multiple
> tiles per frame.
>
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>   drivers/staging/media/imx/Kconfig             |   1 +
>   drivers/staging/media/imx/Makefile            |   1 +
>   drivers/staging/media/imx/imx-media-dev.c     |  11 +
>   drivers/staging/media/imx/imx-media-mem2mem.c | 953 ++++++++++++++++++
>   drivers/staging/media/imx/imx-media.h         |  10 +
>   5 files changed, 976 insertions(+)
>   create mode 100644 drivers/staging/media/imx/imx-media-mem2mem.c
>
> diff --git a/drivers/staging/media/imx/Kconfig b/drivers/staging/media/imx/Kconfig
> index bfc17de56b17..07013cb3cb66 100644
> --- a/drivers/staging/media/imx/Kconfig
> +++ b/drivers/staging/media/imx/Kconfig
> @@ -6,6 +6,7 @@ config VIDEO_IMX_MEDIA
>   	depends on HAS_DMA
>   	select VIDEOBUF2_DMA_CONTIG
>   	select V4L2_FWNODE
> +	select V4L2_MEM2MEM_DEV
>   	---help---
>   	  Say yes here to enable support for video4linux media controller
>   	  driver for the i.MX5/6 SOC.
> diff --git a/drivers/staging/media/imx/Makefile b/drivers/staging/media/imx/Makefile
> index 698a4210316e..f2e722d0fa19 100644
> --- a/drivers/staging/media/imx/Makefile
> +++ b/drivers/staging/media/imx/Makefile
> @@ -6,6 +6,7 @@ imx-media-ic-objs := imx-ic-common.o imx-ic-prp.o imx-ic-prpencvf.o
>   obj-$(CONFIG_VIDEO_IMX_MEDIA) += imx-media.o
>   obj-$(CONFIG_VIDEO_IMX_MEDIA) += imx-media-common.o
>   obj-$(CONFIG_VIDEO_IMX_MEDIA) += imx-media-capture.o
> +obj-$(CONFIG_VIDEO_IMX_MEDIA) += imx-media-mem2mem.o
>   obj-$(CONFIG_VIDEO_IMX_MEDIA) += imx-media-vdic.o
>   obj-$(CONFIG_VIDEO_IMX_MEDIA) += imx-media-ic.o
>   
> diff --git a/drivers/staging/media/imx/imx-media-dev.c b/drivers/staging/media/imx/imx-media-dev.c
> index 289d775c4820..7a9aabcae3ee 100644
> --- a/drivers/staging/media/imx/imx-media-dev.c
> +++ b/drivers/staging/media/imx/imx-media-dev.c
> @@ -359,6 +359,17 @@ static int imx_media_probe_complete(struct v4l2_async_notifier *notifier)
>   		goto unlock;
>   
>   	ret = v4l2_device_register_subdev_nodes(&imxmd->v4l2_dev);
> +	if (ret)
> +		goto unlock;
> +
> +	/* TODO: check whether we have IC subdevices first */
> +	imxmd->m2m_vdev = imx_media_mem2mem_device_init(imxmd);
> +	if (IS_ERR(imxmd->m2m_vdev)) {
> +		ret = PTR_ERR(imxmd->m2m_vdev);
> +		goto unlock;
> +	}
> +
> +	ret = imx_media_mem2mem_device_register(imxmd->m2m_vdev);
>   unlock:
>   	mutex_unlock(&imxmd->mutex);
>   	if (ret)
> diff --git a/drivers/staging/media/imx/imx-media-mem2mem.c b/drivers/staging/media/imx/imx-media-mem2mem.c
> new file mode 100644
> index 000000000000..8830f77f0407
> --- /dev/null
> +++ b/drivers/staging/media/imx/imx-media-mem2mem.c
> @@ -0,0 +1,953 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * i.MX IPUv3 mem2mem Scaler/CSC driver
> + *
> + * Copyright (C) 2011 Pengutronix, Sascha Hauer
> + * Copyright (C) 2018 Pengutronix, Philipp Zabel
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +#include <linux/module.h>
> +#include <linux/delay.h>
> +#include <linux/fs.h>
> +#include <linux/version.h>
> +#include <linux/sched.h>
> +#include <linux/slab.h>
> +#include <video/imx-ipu-v3.h>
> +#include <video/imx-ipu-image-convert.h>
> +
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-mem2mem.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-ioctl.h>
> +#include <media/videobuf2-dma-contig.h>
> +
> +#include "imx-media.h"
> +
> +#define MIN_W 16
> +#define MIN_H 16
> +#define MAX_W 4096
> +#define MAX_H 4096
> +
> +#define fh_to_ctx(__fh)	container_of(__fh, struct mem2mem_ctx, fh)
> +
> +enum {
> +	V4L2_M2M_SRC = 0,
> +	V4L2_M2M_DST = 1,
> +};
> +
> +struct mem2mem_priv {
> +	struct imx_media_video_dev vdev;
> +
> +	struct v4l2_m2m_dev   *m2m_dev;
> +	struct device         *dev;
> +
> +	struct imx_media_dev  *md;
> +
> +	struct mutex          mutex;       /* mem2mem device mutex */
> +
> +	atomic_t              num_inst;
> +};
> +
> +#define to_mem2mem_priv(v) container_of(v, struct mem2mem_priv, vdev)
> +
> +/* Per-queue, driver-specific private data */
> +struct mem2mem_q_data {
> +	struct v4l2_pix_format	cur_fmt;
> +	struct v4l2_rect	rect;
> +};
> +
> +struct mem2mem_ctx {
> +	struct mem2mem_priv	*priv;
> +
> +	struct v4l2_fh		fh;
> +	struct mem2mem_q_data	q_data[2];
> +	int			error;
> +	struct ipu_image_convert_ctx *icc;
> +
> +	struct v4l2_ctrl_handler ctrl_hdlr;
> +	int rotate;
> +	bool hflip;
> +	bool vflip;
> +	enum ipu_rotate_mode	rot_mode;
> +};
> +
> +static struct mem2mem_q_data *get_q_data(struct mem2mem_ctx *ctx,
> +					 enum v4l2_buf_type type)
> +{
> +	if (V4L2_TYPE_IS_OUTPUT(type))
> +		return &ctx->q_data[V4L2_M2M_SRC];
> +	else
> +		return &ctx->q_data[V4L2_M2M_DST];
> +}
> +
> +/*
> + * mem2mem callbacks
> + */
> +
> +static void job_abort(void *_ctx)
> +{
> +	struct mem2mem_ctx *ctx = _ctx;
> +
> +	if (ctx->icc)
> +		ipu_image_convert_abort(ctx->icc);
> +}
> +
> +static void mem2mem_ic_complete(struct ipu_image_convert_run *run, void *_ctx)
> +{
> +	struct mem2mem_ctx *ctx = _ctx;
> +	struct mem2mem_priv *priv = ctx->priv;
> +	struct vb2_v4l2_buffer *src_buf, *dst_buf;
> +
> +	src_buf = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
> +	dst_buf = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
> +
> +	dst_buf->vb2_buf.timestamp = src_buf->vb2_buf.timestamp;
> +	dst_buf->timecode = src_buf->timecode;
> +
> +	v4l2_m2m_buf_done(src_buf, run->status ? VB2_BUF_STATE_ERROR :
> +						 VB2_BUF_STATE_DONE);
> +	v4l2_m2m_buf_done(dst_buf, run->status ? VB2_BUF_STATE_ERROR :
> +						 VB2_BUF_STATE_DONE);
> +
> +	v4l2_m2m_job_finish(priv->m2m_dev, ctx->fh.m2m_ctx);
> +	kfree(run);
> +}
> +
> +static void device_run(void *_ctx)
> +{
> +	struct mem2mem_ctx *ctx = _ctx;
> +	struct mem2mem_priv *priv = ctx->priv;
> +	struct vb2_v4l2_buffer *src_buf, *dst_buf;
> +	struct ipu_image_convert_run *run;
> +	int ret;
> +
> +	src_buf = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
> +	dst_buf = v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
> +
> +	run = kzalloc(sizeof(*run), GFP_KERNEL);
> +	if (!run)
> +		goto err;
> +
> +	run->ctx = ctx->icc;
> +	run->in_phys = vb2_dma_contig_plane_dma_addr(&src_buf->vb2_buf, 0);
> +	run->out_phys = vb2_dma_contig_plane_dma_addr(&dst_buf->vb2_buf, 0);
> +
> +	ret = ipu_image_convert_queue(run);
> +	if (ret < 0) {
> +		v4l2_err(ctx->priv->vdev.vfd->v4l2_dev,
> +			 "%s: failed to queue: %d\n", __func__, ret);
> +		goto err;
> +	}
> +
> +	return;
> +
> +err:
> +	v4l2_m2m_buf_done(src_buf, VB2_BUF_STATE_ERROR);
> +	v4l2_m2m_buf_done(dst_buf, VB2_BUF_STATE_ERROR);
> +	v4l2_m2m_job_finish(priv->m2m_dev, ctx->fh.m2m_ctx);
> +}
> +
> +/*
> + * Video ioctls
> + */
> +static int vidioc_querycap(struct file *file, void *priv,
> +			   struct v4l2_capability *cap)
> +{
> +	strncpy(cap->driver, "imx-media-mem2mem", sizeof(cap->driver) - 1);
> +	strncpy(cap->card, "imx-media-mem2mem", sizeof(cap->card) - 1);
> +	strncpy(cap->bus_info, "platform:imx-media-mem2mem",
> +		sizeof(cap->bus_info) - 1);
> +	cap->device_caps = V4L2_CAP_VIDEO_M2M | V4L2_CAP_STREAMING;
> +	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
> +
> +	return 0;
> +}
> +
> +static int mem2mem_enum_fmt(struct file *file, void *fh,
> +			    struct v4l2_fmtdesc *f)
> +{
> +	u32 fourcc;
> +	int ret;
> +
> +	ret = imx_media_enum_format(&fourcc, f->index, CS_SEL_ANY);
> +	if (ret)
> +		return ret;
> +
> +	f->pixelformat = fourcc;
> +
> +	return 0;
> +}
> +
> +static int mem2mem_g_fmt(struct file *file, void *priv, struct v4l2_format *f)
> +{
> +	struct mem2mem_ctx *ctx = fh_to_ctx(priv);
> +	struct mem2mem_q_data *q_data;
> +
> +	q_data = get_q_data(ctx, f->type);
> +
> +	f->fmt.pix = q_data->cur_fmt;
> +
> +	return 0;
> +}
> +
> +static int mem2mem_try_fmt(struct file *file, void *priv,
> +			   struct v4l2_format *f)
> +{
> +	const struct imx_media_pixfmt *cc;
> +	struct mem2mem_ctx *ctx = fh_to_ctx(priv);
> +	struct mem2mem_q_data *q_data = get_q_data(ctx, f->type);
> +	unsigned int walign, halign;
> +	u32 stride;
> +
> +	cc = imx_media_find_format(f->fmt.pix.pixelformat, CS_SEL_ANY, false);
> +	if (!cc) {
> +		f->fmt.pix.pixelformat = V4L2_PIX_FMT_RGB32;
> +		cc = imx_media_find_format(V4L2_PIX_FMT_RGB32, CS_SEL_RGB,
> +					   false);
> +	}
> +
> +	/*
> +	 * Horizontally/vertically chroma subsampled formats must have even
> +	 * width/height.
> +	 */
> +	switch (f->fmt.pix.pixelformat) {
> +	case V4L2_PIX_FMT_YUV420:
> +	case V4L2_PIX_FMT_YVU420:
> +	case V4L2_PIX_FMT_NV12:
> +		walign = 1;
> +		halign = 1;
> +		break;
> +	case V4L2_PIX_FMT_YUV422P:
> +	case V4L2_PIX_FMT_NV16:
> +		walign = 1;
> +		halign = 0;
> +		break;
> +	default:

The default case should init walign, otherwise for OUTPUT direction,
walign may not get initialized at all, see below...

> +		halign = 0;
> +		break;
> +	}
> +	if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
> +		/*
> +		 * The IC burst reads 8 pixels at a time. Reading beyond the
> +		 * end of the line is usually acceptable. Those pixels are
> +		 * ignored, unless the IC has to write the scaled line in
> +		 * reverse.
> +		 */
> +		if (!ipu_rot_mode_is_irt(ctx->rot_mode) &&
> +		    ctx->rot_mode && IPU_ROT_BIT_HFLIP)
> +			walign = 3;

This looks wrong. Do you mean:

if (ipu_rot_mode_is_irt(ctx->rot_mode) || (ctx->rot_mode & IPU_ROT_BIT_HFLIP))
     walign = 3;
else
     walign = 1;


That is, require 8 byte width alignment for IRT or if HFLIP is enabled.


Also, why not simply call ipu_image_convert_adjust() in
mem2mem_try_fmt()? If there is something missing in the former
function, then it should be added there, instead of adding the
missing checks in mem2mem_try_fmt().

  
Steve

> +	} else {
> +		if (ipu_rot_mode_is_irt(ctx->rot_mode)) {
> +			switch (f->fmt.pix.pixelformat) {
> +			case V4L2_PIX_FMT_YUV420:
> +			case V4L2_PIX_FMT_YVU420:
> +			case V4L2_PIX_FMT_YUV422P:
> +				/*
> +				 * Align to 16x16 pixel blocks for planar 4:2:0
> +				 * chroma subsampled formats to guarantee
> +				 * 8-byte aligned line start addresses in the
> +				 * chroma planes.
> +				 */
> +				walign = 4;
> +				halign = 4;
> +				break;
> +			default:
> +				/*
> +				 * Align to 8x8 pixel IRT block size for all
> +				 * other formats.
> +				 */
> +				walign = 3;
> +				halign = 3;
> +				break;
> +			}
> +		} else {
> +			/*
> +			 * The IC burst writes 8 pixels at a time.
> +			 *
> +			 * TODO: support unaligned width with via
> +			 * V4L2_SEL_TGT_COMPOSE_PADDED.
> +			 */
> +			walign = 3;
> +		}
> +	}
> +	v4l_bound_align_image(&f->fmt.pix.width, MIN_W, MAX_W, walign,
> +			      &f->fmt.pix.height, MIN_H, MAX_H, halign, 0);
> +
> +	stride = cc->planar ? f->fmt.pix.width
> +			    : (f->fmt.pix.width * cc->bpp) >> 3;
> +	switch (f->fmt.pix.pixelformat) {
> +	case V4L2_PIX_FMT_YUV420:
> +	case V4L2_PIX_FMT_YVU420:
> +	case V4L2_PIX_FMT_YUV422P:
> +		stride = round_up(stride, 16);
> +		break;
> +	default:
> +		stride = round_up(stride, 8);
> +		break;
> +	}
> +
> +	f->fmt.pix.field = V4L2_FIELD_NONE;
> +	f->fmt.pix.bytesperline = stride;
> +	f->fmt.pix.sizeimage = cc->planar ?
> +			       (stride * f->fmt.pix.height * cc->bpp) >> 3 :
> +			       stride * f->fmt.pix.height;
> +
> +	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
> +		f->fmt.pix.colorspace = q_data->cur_fmt.colorspace;
> +		f->fmt.pix.ycbcr_enc = q_data->cur_fmt.ycbcr_enc;
> +		f->fmt.pix.xfer_func = q_data->cur_fmt.xfer_func;
> +		f->fmt.pix.quantization = q_data->cur_fmt.quantization;
> +	} else if (f->fmt.pix.colorspace == V4L2_COLORSPACE_DEFAULT) {
> +		f->fmt.pix.colorspace = V4L2_COLORSPACE_SRGB;
> +		f->fmt.pix.ycbcr_enc = V4L2_YCBCR_ENC_DEFAULT;
> +		f->fmt.pix.xfer_func = V4L2_XFER_FUNC_DEFAULT;
> +		f->fmt.pix.quantization = V4L2_QUANTIZATION_DEFAULT;
> +	}
> +
> +	return 0;
> +}
> +
> +static int mem2mem_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
> +{
> +	struct mem2mem_q_data *q_data;
> +	struct mem2mem_ctx *ctx = fh_to_ctx(priv);
> +	struct vb2_queue *vq;
> +	int ret;
> +
> +	vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
> +	if (vb2_is_busy(vq)) {
> +		v4l2_err(ctx->priv->vdev.vfd->v4l2_dev, "%s queue busy\n",
> +			 __func__);
> +		return -EBUSY;
> +	}
> +
> +	q_data = get_q_data(ctx, f->type);
> +
> +	ret = mem2mem_try_fmt(file, priv, f);
> +	if (ret < 0)
> +		return ret;
> +
> +	q_data->cur_fmt.width = f->fmt.pix.width;
> +	q_data->cur_fmt.height = f->fmt.pix.height;
> +	q_data->cur_fmt.pixelformat = f->fmt.pix.pixelformat;
> +	q_data->cur_fmt.field = f->fmt.pix.field;
> +	q_data->cur_fmt.bytesperline = f->fmt.pix.bytesperline;
> +	q_data->cur_fmt.sizeimage = f->fmt.pix.sizeimage;
> +
> +	/* Reset cropping/composing rectangle */
> +	q_data->rect.left = 0;
> +	q_data->rect.top = 0;
> +	q_data->rect.width = q_data->cur_fmt.width;
> +	q_data->rect.height = q_data->cur_fmt.height;
> +
> +	if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
> +		/* Set colorimetry on the output queue */
> +		q_data->cur_fmt.colorspace = f->fmt.pix.colorspace;
> +		q_data->cur_fmt.ycbcr_enc = f->fmt.pix.ycbcr_enc;
> +		q_data->cur_fmt.xfer_func = f->fmt.pix.xfer_func;
> +		q_data->cur_fmt.quantization = f->fmt.pix.quantization;
> +		/* Propagate colorimetry to the capture queue */
> +		q_data = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
> +		q_data->cur_fmt.colorspace = f->fmt.pix.colorspace;
> +		q_data->cur_fmt.ycbcr_enc = f->fmt.pix.ycbcr_enc;
> +		q_data->cur_fmt.xfer_func = f->fmt.pix.xfer_func;
> +		q_data->cur_fmt.quantization = f->fmt.pix.quantization;
> +	}
> +
> +	/*
> +	 * TODO: Setting colorimetry on the capture queue is currently not
> +	 * supported by the V4L2 API
> +	 */
> +
> +	return 0;
> +}
> +
> +static int mem2mem_g_selection(struct file *file, void *priv,
> +			       struct v4l2_selection *s)
> +{
> +	struct mem2mem_ctx *ctx = fh_to_ctx(priv);
> +	struct mem2mem_q_data *q_data;
> +
> +	switch (s->target) {
> +	case V4L2_SEL_TGT_CROP:
> +	case V4L2_SEL_TGT_CROP_DEFAULT:
> +	case V4L2_SEL_TGT_CROP_BOUNDS:
> +		if (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
> +			return -EINVAL;
> +		q_data = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
> +		break;
> +	case V4L2_SEL_TGT_COMPOSE:
> +	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
> +	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
> +	case V4L2_SEL_TGT_COMPOSE_PADDED:
> +		if (s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +			return -EINVAL;
> +		q_data = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	if (s->target == V4L2_SEL_TGT_CROP ||
> +	    s->target == V4L2_SEL_TGT_COMPOSE) {
> +		s->r = q_data->rect;
> +	} else {
> +		s->r.left = 0;
> +		s->r.top = 0;
> +		s->r.width = q_data->cur_fmt.width;
> +		s->r.height = q_data->cur_fmt.height;
> +	}
> +
> +	return 0;
> +}
> +
> +static int mem2mem_s_selection(struct file *file, void *priv,
> +			       struct v4l2_selection *s)
> +{
> +	struct mem2mem_ctx *ctx = fh_to_ctx(priv);
> +	struct mem2mem_q_data *q_data;
> +
> +	switch (s->target) {
> +	case V4L2_SEL_TGT_CROP:
> +		if (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
> +			return -EINVAL;
> +		break;
> +	case V4L2_SEL_TGT_COMPOSE:
> +		if (s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +			return -EINVAL;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	if (s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE ||
> +	    s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
> +		return -EINVAL;
> +
> +	q_data = get_q_data(ctx, s->type);
> +
> +	/* The input's frame width to the IC must be a multiple of 8 pixels
> +	 * When performing resizing the frame width must be multiple of burst
> +	 * size - 8 or 16 pixels as defined by CB#_BURST_16 parameter.
> +	 */
> +	if (s->flags & V4L2_SEL_FLAG_GE)
> +		s->r.width = round_up(s->r.width, 8);
> +	if (s->flags & V4L2_SEL_FLAG_LE)
> +		s->r.width = round_down(s->r.width, 8);
> +	s->r.width = clamp_t(unsigned int, s->r.width, 8,
> +			     round_down(q_data->cur_fmt.width, 8));
> +	s->r.height = clamp_t(unsigned int, s->r.height, 1,
> +			      q_data->cur_fmt.height);
> +	s->r.left = clamp_t(unsigned int, s->r.left, 0,
> +			    q_data->cur_fmt.width - s->r.width);
> +	s->r.top = clamp_t(unsigned int, s->r.top, 0,
> +			   q_data->cur_fmt.height - s->r.height);
> +
> +	/* V4L2_SEL_FLAG_KEEP_CONFIG is only valid for subdevices */
> +	q_data->rect = s->r;
> +
> +	return 0;
> +}
> +
> +static const struct v4l2_ioctl_ops mem2mem_ioctl_ops = {
> +	.vidioc_querycap	= vidioc_querycap,
> +
> +	.vidioc_enum_fmt_vid_cap = mem2mem_enum_fmt,
> +	.vidioc_g_fmt_vid_cap	= mem2mem_g_fmt,
> +	.vidioc_try_fmt_vid_cap	= mem2mem_try_fmt,
> +	.vidioc_s_fmt_vid_cap	= mem2mem_s_fmt,
> +
> +	.vidioc_enum_fmt_vid_out = mem2mem_enum_fmt,
> +	.vidioc_g_fmt_vid_out	= mem2mem_g_fmt,
> +	.vidioc_try_fmt_vid_out	= mem2mem_try_fmt,
> +	.vidioc_s_fmt_vid_out	= mem2mem_s_fmt,
> +
> +	.vidioc_g_selection	= mem2mem_g_selection,
> +	.vidioc_s_selection	= mem2mem_s_selection,
> +
> +	.vidioc_reqbufs		= v4l2_m2m_ioctl_reqbufs,
> +	.vidioc_querybuf	= v4l2_m2m_ioctl_querybuf,
> +
> +	.vidioc_qbuf		= v4l2_m2m_ioctl_qbuf,
> +	.vidioc_expbuf		= v4l2_m2m_ioctl_expbuf,
> +	.vidioc_dqbuf		= v4l2_m2m_ioctl_dqbuf,
> +	.vidioc_create_bufs	= v4l2_m2m_ioctl_create_bufs,
> +
> +	.vidioc_streamon	= v4l2_m2m_ioctl_streamon,
> +	.vidioc_streamoff	= v4l2_m2m_ioctl_streamoff,
> +};
> +
> +/*
> + * Queue operations
> + */
> +
> +static int mem2mem_queue_setup(struct vb2_queue *vq, unsigned int *nbuffers,
> +			       unsigned int *nplanes, unsigned int sizes[],
> +			       struct device *alloc_devs[])
> +{
> +	struct mem2mem_ctx *ctx = vb2_get_drv_priv(vq);
> +	struct mem2mem_q_data *q_data;
> +	unsigned int count = *nbuffers;
> +	struct v4l2_pix_format *pix;
> +
> +	q_data = get_q_data(ctx, vq->type);
> +	pix = &q_data->cur_fmt;
> +
> +	*nplanes = 1;
> +	*nbuffers = count;
> +	sizes[0] = pix->sizeimage;
> +
> +	dev_dbg(ctx->priv->dev, "get %d buffer(s) of size %d each.\n",
> +		count, pix->sizeimage);
> +
> +	return 0;
> +}
> +
> +static int mem2mem_buf_prepare(struct vb2_buffer *vb)
> +{
> +	struct mem2mem_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
> +	struct mem2mem_q_data *q_data;
> +	struct v4l2_pix_format *pix;
> +	unsigned int plane_size, payload;
> +
> +	dev_dbg(ctx->priv->dev, "type: %d\n", vb->vb2_queue->type);
> +
> +	q_data = get_q_data(ctx, vb->vb2_queue->type);
> +	pix = &q_data->cur_fmt;
> +	plane_size = pix->sizeimage;
> +
> +	if (vb2_plane_size(vb, 0) < plane_size) {
> +		dev_dbg(ctx->priv->dev,
> +			"%s data will not fit into plane (%lu < %lu)\n",
> +			__func__, vb2_plane_size(vb, 0), (long)plane_size);
> +		return -EINVAL;
> +	}
> +
> +	payload = pix->bytesperline * pix->height;
> +	if (pix->pixelformat == V4L2_PIX_FMT_YUV420 ||
> +	    pix->pixelformat == V4L2_PIX_FMT_YVU420 ||
> +	    pix->pixelformat == V4L2_PIX_FMT_NV12)
> +		payload = payload * 3 / 2;
> +	else if (pix->pixelformat == V4L2_PIX_FMT_YUV422P ||
> +		 pix->pixelformat == V4L2_PIX_FMT_NV16)
> +		payload *= 2;
> +
> +	vb2_set_plane_payload(vb, 0, payload);
> +
> +	return 0;
> +}
> +
> +static void mem2mem_buf_queue(struct vb2_buffer *vb)
> +{
> +	struct mem2mem_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
> +
> +	v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, to_vb2_v4l2_buffer(vb));
> +}
> +
> +static void ipu_image_from_q_data(struct ipu_image *im,
> +				  struct mem2mem_q_data *q_data)
> +{
> +	im->pix.width = q_data->cur_fmt.width;
> +	im->pix.height = q_data->cur_fmt.height;
> +	im->pix.bytesperline = q_data->cur_fmt.bytesperline;
> +	im->pix.pixelformat = q_data->cur_fmt.pixelformat;
> +	im->rect = q_data->rect;
> +}
> +
> +static int mem2mem_start_streaming(struct vb2_queue *q, unsigned int count)
> +{
> +	const enum ipu_ic_task ic_task = IC_TASK_POST_PROCESSOR;
> +	struct mem2mem_ctx *ctx = vb2_get_drv_priv(q);
> +	struct mem2mem_priv *priv = ctx->priv;
> +	struct ipu_soc *ipu = priv->md->ipu[0];
> +	struct mem2mem_q_data *q_data;
> +	struct vb2_queue *other_q;
> +	struct ipu_image in, out;
> +
> +	other_q = v4l2_m2m_get_vq(ctx->fh.m2m_ctx,
> +				  (q->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) ?
> +				  V4L2_BUF_TYPE_VIDEO_OUTPUT :
> +				  V4L2_BUF_TYPE_VIDEO_CAPTURE);
> +	if (!vb2_is_streaming(other_q))
> +		return 0;
> +
> +	if (ctx->icc) {
> +		v4l2_warn(ctx->priv->vdev.vfd->v4l2_dev, "removing old ICC\n");
> +		ipu_image_convert_unprepare(ctx->icc);
> +	}
> +
> +	q_data = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
> +	ipu_image_from_q_data(&in, q_data);
> +
> +	q_data = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
> +	ipu_image_from_q_data(&out, q_data);
> +
> +	ctx->icc = ipu_image_convert_prepare(ipu, ic_task, &in, &out,
> +					     ctx->rot_mode,
> +					     mem2mem_ic_complete, ctx);
> +	if (IS_ERR(ctx->icc)) {
> +		struct vb2_v4l2_buffer *buf;
> +		int ret = PTR_ERR(ctx->icc);
> +
> +		ctx->icc = NULL;
> +		v4l2_err(ctx->priv->vdev.vfd->v4l2_dev, "%s: error %d\n",
> +			 __func__, ret);
> +		while ((buf = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx)))
> +			v4l2_m2m_buf_done(buf, VB2_BUF_STATE_QUEUED);
> +		while ((buf = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx)))
> +			v4l2_m2m_buf_done(buf, VB2_BUF_STATE_QUEUED);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static void mem2mem_stop_streaming(struct vb2_queue *q)
> +{
> +	struct mem2mem_ctx *ctx = vb2_get_drv_priv(q);
> +	struct vb2_v4l2_buffer *buf;
> +
> +	if (ctx->icc) {
> +		ipu_image_convert_unprepare(ctx->icc);
> +		ctx->icc = NULL;
> +	}
> +
> +	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
> +		while ((buf = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx)))
> +			v4l2_m2m_buf_done(buf, VB2_BUF_STATE_ERROR);
> +	} else {
> +		while ((buf = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx)))
> +			v4l2_m2m_buf_done(buf, VB2_BUF_STATE_ERROR);
> +	}
> +}
> +
> +static const struct vb2_ops mem2mem_qops = {
> +	.queue_setup	= mem2mem_queue_setup,
> +	.buf_prepare	= mem2mem_buf_prepare,
> +	.buf_queue	= mem2mem_buf_queue,
> +	.wait_prepare	= vb2_ops_wait_prepare,
> +	.wait_finish	= vb2_ops_wait_finish,
> +	.start_streaming = mem2mem_start_streaming,
> +	.stop_streaming = mem2mem_stop_streaming,
> +};
> +
> +static int queue_init(void *priv, struct vb2_queue *src_vq,
> +		      struct vb2_queue *dst_vq)
> +{
> +	struct mem2mem_ctx *ctx = priv;
> +	int ret;
> +
> +	memset(src_vq, 0, sizeof(*src_vq));
> +	src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
> +	src_vq->io_modes = VB2_MMAP | VB2_DMABUF;
> +	src_vq->drv_priv = ctx;
> +	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
> +	src_vq->ops = &mem2mem_qops;
> +	src_vq->mem_ops = &vb2_dma_contig_memops;
> +	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
> +	src_vq->lock = &ctx->priv->mutex;
> +	src_vq->dev = ctx->priv->dev;
> +
> +	ret = vb2_queue_init(src_vq);
> +	if (ret)
> +		return ret;
> +
> +	memset(dst_vq, 0, sizeof(*dst_vq));
> +	dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +	dst_vq->io_modes = VB2_MMAP | VB2_DMABUF;
> +	dst_vq->drv_priv = ctx;
> +	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
> +	dst_vq->ops = &mem2mem_qops;
> +	dst_vq->mem_ops = &vb2_dma_contig_memops;
> +	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
> +	dst_vq->lock = &ctx->priv->mutex;
> +	dst_vq->dev = ctx->priv->dev;
> +
> +	return vb2_queue_init(dst_vq);
> +}
> +
> +static int mem2mem_s_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	struct mem2mem_ctx *ctx = container_of(ctrl->handler,
> +					       struct mem2mem_ctx, ctrl_hdlr);
> +	enum ipu_rotate_mode rot_mode;
> +	int rotate;
> +	bool hflip, vflip;
> +	int ret = 0;
> +
> +	rotate = ctx->rotate;
> +	hflip = ctx->hflip;
> +	vflip = ctx->vflip;
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_HFLIP:
> +		hflip = ctrl->val;
> +		break;
> +	case V4L2_CID_VFLIP:
> +		vflip = ctrl->val;
> +		break;
> +	case V4L2_CID_ROTATE:
> +		rotate = ctrl->val;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	ret = ipu_degrees_to_rot_mode(&rot_mode, rotate, hflip, vflip);
> +	if (ret)
> +		return ret;
> +
> +	if (rot_mode != ctx->rot_mode) {
> +		struct vb2_queue *cap_q;
> +
> +		cap_q = v4l2_m2m_get_vq(ctx->fh.m2m_ctx,
> +					V4L2_BUF_TYPE_VIDEO_CAPTURE);
> +		if (vb2_is_streaming(cap_q))
> +			return -EBUSY;
> +
> +		ctx->rot_mode = rot_mode;
> +		ctx->rotate = rotate;
> +		ctx->hflip = hflip;
> +		ctx->vflip = vflip;
> +	}
> +
> +	return 0;
> +}
> +
> +static const struct v4l2_ctrl_ops mem2mem_ctrl_ops = {
> +	.s_ctrl = mem2mem_s_ctrl,
> +};
> +
> +static int mem2mem_init_controls(struct mem2mem_ctx *ctx)
> +{
> +	struct v4l2_ctrl_handler *hdlr = &ctx->ctrl_hdlr;
> +	int ret;
> +
> +	v4l2_ctrl_handler_init(hdlr, 3);
> +
> +	v4l2_ctrl_new_std(hdlr, &mem2mem_ctrl_ops, V4L2_CID_HFLIP,
> +			  0, 1, 1, 0);
> +	v4l2_ctrl_new_std(hdlr, &mem2mem_ctrl_ops, V4L2_CID_VFLIP,
> +			  0, 1, 1, 0);
> +	v4l2_ctrl_new_std(hdlr, &mem2mem_ctrl_ops, V4L2_CID_ROTATE,
> +			  0, 270, 90, 0);
> +
> +	if (hdlr->error) {
> +		ret = hdlr->error;
> +		goto out_free;
> +	}
> +
> +	v4l2_ctrl_handler_setup(hdlr);
> +	return 0;
> +
> +out_free:
> +	v4l2_ctrl_handler_free(hdlr);
> +	return ret;
> +}
> +
> +#define DEFAULT_WIDTH	720
> +#define DEFAULT_HEIGHT	576
> +static const struct mem2mem_q_data mem2mem_q_data_default = {
> +	.cur_fmt = {
> +		.width = DEFAULT_WIDTH,
> +		.height = DEFAULT_HEIGHT,
> +		.pixelformat = V4L2_PIX_FMT_YUV420,
> +		.field = V4L2_FIELD_NONE,
> +		.bytesperline = DEFAULT_WIDTH,
> +		.sizeimage = DEFAULT_WIDTH * DEFAULT_HEIGHT * 3 / 2,
> +		.colorspace = V4L2_COLORSPACE_SRGB,
> +	},
> +	.rect = {
> +		.width = DEFAULT_WIDTH,
> +		.height = DEFAULT_HEIGHT,
> +	},
> +};
> +
> +/*
> + * File operations
> + */
> +static int mem2mem_open(struct file *file)
> +{
> +	struct mem2mem_priv *priv = video_drvdata(file);
> +	struct mem2mem_ctx *ctx = NULL;
> +	int ret;
> +
> +	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
> +	if (!ctx)
> +		return -ENOMEM;
> +
> +	ctx->rot_mode = IPU_ROTATE_NONE;
> +
> +	v4l2_fh_init(&ctx->fh, video_devdata(file));
> +	file->private_data = &ctx->fh;
> +	v4l2_fh_add(&ctx->fh);
> +	ctx->priv = priv;
> +
> +	ctx->fh.m2m_ctx = v4l2_m2m_ctx_init(priv->m2m_dev, ctx,
> +					    &queue_init);
> +	if (IS_ERR(ctx->fh.m2m_ctx)) {
> +		ret = PTR_ERR(ctx->fh.m2m_ctx);
> +		goto err_ctx;
> +	}
> +
> +	ret = mem2mem_init_controls(ctx);
> +	if (ret)
> +		goto err_ctrls;
> +
> +	ctx->fh.ctrl_handler = &ctx->ctrl_hdlr;
> +
> +	ctx->q_data[V4L2_M2M_SRC] = mem2mem_q_data_default;
> +	ctx->q_data[V4L2_M2M_DST] = mem2mem_q_data_default;
> +
> +	atomic_inc(&priv->num_inst);
> +
> +	dev_dbg(priv->dev, "Created instance %p, m2m_ctx: %p\n", ctx,
> +		ctx->fh.m2m_ctx);
> +
> +	return 0;
> +
> +err_ctrls:
> +	v4l2_m2m_ctx_release(ctx->fh.m2m_ctx);
> +err_ctx:
> +	v4l2_fh_del(&ctx->fh);
> +	v4l2_fh_exit(&ctx->fh);
> +	kfree(ctx);
> +	return ret;
> +}
> +
> +static int mem2mem_release(struct file *file)
> +{
> +	struct mem2mem_priv *priv = video_drvdata(file);
> +	struct mem2mem_ctx *ctx = fh_to_ctx(file->private_data);
> +
> +	dev_dbg(priv->dev, "Releasing instance %p\n", ctx);
> +
> +	v4l2_m2m_ctx_release(ctx->fh.m2m_ctx);
> +	v4l2_fh_del(&ctx->fh);
> +	v4l2_fh_exit(&ctx->fh);
> +	kfree(ctx);
> +
> +	atomic_dec(&priv->num_inst);
> +
> +	return 0;
> +}
> +
> +static const struct v4l2_file_operations mem2mem_fops = {
> +	.owner		= THIS_MODULE,
> +	.open		= mem2mem_open,
> +	.release	= mem2mem_release,
> +	.poll		= v4l2_m2m_fop_poll,
> +	.unlocked_ioctl	= video_ioctl2,
> +	.mmap		= v4l2_m2m_fop_mmap,
> +};
> +
> +static struct v4l2_m2m_ops m2m_ops = {
> +	.device_run	= device_run,
> +	.job_abort	= job_abort,
> +};
> +
> +static const struct video_device mem2mem_videodev_template = {
> +	.name		= "ipu0_ic_pp mem2mem",
> +	.fops		= &mem2mem_fops,
> +	.ioctl_ops	= &mem2mem_ioctl_ops,
> +	.minor		= -1,
> +	.release	= video_device_release,
> +	.vfl_dir	= VFL_DIR_M2M,
> +	.tvnorms	= V4L2_STD_NTSC | V4L2_STD_PAL | V4L2_STD_SECAM,
> +	.device_caps	= V4L2_CAP_VIDEO_M2M | V4L2_CAP_STREAMING,
> +};
> +
> +int imx_media_mem2mem_device_register(struct imx_media_video_dev *vdev)
> +{
> +	struct mem2mem_priv *priv = to_mem2mem_priv(vdev);
> +	struct video_device *vfd = vdev->vfd;
> +	int ret;
> +
> +	vfd->v4l2_dev = &priv->md->v4l2_dev;
> +
> +	ret = video_register_device(vfd, VFL_TYPE_GRABBER, -1);
> +	if (ret) {
> +		v4l2_err(vfd->v4l2_dev, "Failed to register video device\n");
> +		return ret;
> +	}
> +
> +	v4l2_info(vfd->v4l2_dev, "Registered %s as /dev/%s\n", vfd->name,
> +		  video_device_node_name(vfd));
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(imx_media_mem2mem_device_register);
> +
> +void imx_media_mem2mem_device_unregister(struct imx_media_video_dev *vdev)
> +{
> +	struct mem2mem_priv *priv = to_mem2mem_priv(vdev);
> +	struct video_device *vfd = priv->vdev.vfd;
> +
> +	mutex_lock(&priv->mutex);
> +
> +	if (video_is_registered(vfd)) {
> +		video_unregister_device(vfd);
> +		media_entity_cleanup(&vfd->entity);
> +	}
> +
> +	mutex_unlock(&priv->mutex);
> +}
> +EXPORT_SYMBOL_GPL(imx_media_mem2mem_device_unregister);
> +
> +struct imx_media_video_dev *
> +imx_media_mem2mem_device_init(struct imx_media_dev *md)
> +{
> +	struct mem2mem_priv *priv;
> +	struct video_device *vfd;
> +	int ret;
> +
> +	priv = devm_kzalloc(md->md.dev, sizeof(*priv), GFP_KERNEL);
> +	if (!priv)
> +		return ERR_PTR(-ENOMEM);
> +
> +	priv->md = md;
> +	priv->dev = md->md.dev;
> +
> +	mutex_init(&priv->mutex);
> +	atomic_set(&priv->num_inst, 0);
> +
> +	vfd = video_device_alloc();
> +	if (!vfd)
> +		return ERR_PTR(-ENOMEM);
> +
> +	*vfd = mem2mem_videodev_template;
> +	snprintf(vfd->name, sizeof(vfd->name), "ipu_ic_pp mem2mem");
> +	vfd->lock = &priv->mutex;
> +	priv->vdev.vfd = vfd;
> +
> +	INIT_LIST_HEAD(&priv->vdev.list);
> +
> +	video_set_drvdata(vfd, priv);
> +
> +	priv->m2m_dev = v4l2_m2m_init(&m2m_ops);
> +	if (IS_ERR(priv->m2m_dev)) {
> +		ret = PTR_ERR(priv->m2m_dev);
> +		v4l2_err(&md->v4l2_dev, "Failed to init mem2mem device: %d\n",
> +			 ret);
> +		return ERR_PTR(ret);
> +	}
> +
> +	return &priv->vdev;
> +}
> +EXPORT_SYMBOL_GPL(imx_media_mem2mem_device_init);
> +
> +void imx_media_mem2mem_device_remove(struct imx_media_video_dev *vdev)
> +{
> +	struct mem2mem_priv *priv = to_mem2mem_priv(vdev);
> +
> +	v4l2_m2m_release(priv->m2m_dev);
> +}
> +EXPORT_SYMBOL_GPL(imx_media_mem2mem_device_remove);
> +
> +MODULE_DESCRIPTION("i.MX IPUv3 mem2mem scaler/CSC driver");
> +MODULE_AUTHOR("Sascha Hauer <s.hauer@pengutronix.de>");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/staging/media/imx/imx-media.h b/drivers/staging/media/imx/imx-media.h
> index e945e0ed6dd6..dc24ed37f050 100644
> --- a/drivers/staging/media/imx/imx-media.h
> +++ b/drivers/staging/media/imx/imx-media.h
> @@ -149,6 +149,9 @@ struct imx_media_dev {
>   	/* for async subdev registration */
>   	struct list_head asd_list;
>   	struct v4l2_async_notifier subdev_notifier;
> +
> +	/* IC scaler/CSC mem2mem video device */
> +	struct imx_media_video_dev *m2m_vdev;
>   };
>   
>   enum codespace_sel {
> @@ -262,6 +265,13 @@ void imx_media_capture_device_set_format(struct imx_media_video_dev *vdev,
>   					 struct v4l2_pix_format *pix);
>   void imx_media_capture_device_error(struct imx_media_video_dev *vdev);
>   
> +/* imx-media-mem2mem.c */
> +struct imx_media_video_dev *
> +imx_media_mem2mem_device_init(struct imx_media_dev *dev);
> +void imx_media_mem2mem_device_remove(struct imx_media_video_dev *vdev);
> +int imx_media_mem2mem_device_register(struct imx_media_video_dev *vdev);
> +void imx_media_mem2mem_device_unregister(struct imx_media_video_dev *vdev);
> +
>   /* subdev group ids */
>   #define IMX_MEDIA_GRP_ID_CSI2      BIT(8)
>   #define IMX_MEDIA_GRP_ID_CSI_BIT   9
