Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:58961 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750707AbdLKQPX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Dec 2017 11:15:23 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: magnus.damm@gmail.com, geert@glider.be, mchehab@kernel.org,
        hverkuil@xs4all.nl, linux-renesas-soc@vger.kernel.org,
        linux-media@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 03/10] v4l: platform: Add Renesas CEU driver
Date: Mon, 11 Dec 2017 18:15:23 +0200
Message-ID: <2710170.YbEgzp5Yxe@avalon>
In-Reply-To: <1510743363-25798-4-git-send-email-jacopo+renesas@jmondi.org>
References: <1510743363-25798-1-git-send-email-jacopo+renesas@jmondi.org> <1510743363-25798-4-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

Thank you for the patch.

On Wednesday, 15 November 2017 12:55:56 EET Jacopo Mondi wrote:
> Add driver for Renesas Capture Engine Unit (CEU).
> 
> The CEU interface supports capturing 'data' (YUV422) and 'images'
> (NV[12|21|16|61]).
> 
> This driver aims to replace the soc_camera based sh_mobile_ceu one.

s/soc_camera based/soc_camera-based/

> Tested with ov7670 camera sensor, providing YUYV_2X8 data on Renesas RZ
> platform GR-Peach.
> 
> Tested with ov7725 camera sensor on SH4 platform Migo-R.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> ---
>  drivers/media/platform/Kconfig       |    9 +
>  drivers/media/platform/Makefile      |    2 +
>  drivers/media/platform/renesas-ceu.c | 1768 +++++++++++++++++++++++++++++++
>  3 files changed, 1779 insertions(+)
>  create mode 100644 drivers/media/platform/renesas-ceu.c

[snip]

> diff --git a/drivers/media/platform/renesas-ceu.c
> b/drivers/media/platform/renesas-ceu.c new file mode 100644
> index 0000000..aaba3cd
> --- /dev/null
> +++ b/drivers/media/platform/renesas-ceu.c
> @@ -0,0 +1,1768 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/*
> + * V4L2 Driver for Renesas Capture Engine Unit (CEU) interface
> + *
> + * Copyright (C) 2017 Jacopo Mondi <jacopo+renesas@jmondi.org>
> + *
> + * Based on soc-camera driver "soc_camera/sh_mobile_ceu_camera.c"
> + * Copyright (C) 2008 Magnus Damm
> + *
> + * Based on V4L2 Driver for PXA camera host - "pxa_camera.c",
> + * Copyright (C) 2006, Sascha Hauer, Pengutronix
> + * Copyright (C) 2008, Guennadi Liakhovetski <kernel@pengutronix.de>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.

You can use an SPDX header instead of a copyright text. Start the file with

// SPDX-License-Identifier: GPL-2.0+

and remove this paragraph.

> + */

[snip]

> +/* mbus configuration flags */
> +#define CEU_BUS_FLAGS (V4L2_MBUS_MASTER		     |  \
> +			V4L2_MBUS_PCLK_SAMPLE_RISING |	\
> +			V4L2_MBUS_HSYNC_ACTIVE_HIGH  |	\
> +			V4L2_MBUS_HSYNC_ACTIVE_LOW   |	\
> +			V4L2_MBUS_VSYNC_ACTIVE_HIGH  |	\
> +			V4L2_MBUS_VSYNC_ACTIVE_LOW   |	\
> +			V4L2_MBUS_DATA_ACTIVE_HIGH)
> +
> +#define CEU_MAX_WIDTH	2560
> +#define CEU_MAX_HEIGHT	1920
> +#define CEU_W_MAX(w)	((w) < CEU_MAX_WIDTH ? (w) : CEU_MAX_WIDTH)
> +#define CEU_H_MAX(h)	((h) < CEU_MAX_HEIGHT ? (h) : CEU_MAX_HEIGHT)
> +
> +/* ------------------------------------------------------------------------
> + * CEU formats
> + */
> +
> +/**
> + * ceu_bus_fmt - describe a 8-bits yuyv format the sensor can produce
> + *
> + * @mbus_code: bus format code
> + * @fmt_order: CEU_CAMCR.DTARY ordering of input components (Y, Cb, Cr)
> + * @fmt_order_swap: swapped CEU_CAMCR.DTARY ordering of input components
> + *		    (Y, Cr, Cb)
> + * @swapped: does Cr appear before Cb?
> + * @bps: number of bits sent over bus for each sample
> + * @bpp: number of bits per pixels unit
> + */
> +struct ceu_mbus_fmt {
> +	u32	mbus_code;
> +	u32	fmt_order;
> +	u32	fmt_order_swap;
> +	bool	swapped;
> +	u8	bps;
> +	u8	bpp;
> +};
> +
> +/**
> + * ceu_buffer - Link vb2 buffer to the list of available buffers

If you use kerneldoc comments please make them compile. You need to document 
the structure fields and function arguments.

> + */
> +struct ceu_buffer {
> +	struct vb2_v4l2_buffer vb;
> +	struct list_head queue;
> +};
> +
> +static inline struct ceu_buffer *vb2_to_ceu(struct vb2_v4l2_buffer *vbuf)
> +{
> +	return container_of(vbuf, struct ceu_buffer, vb);
> +}
> +
> +/**
> + * ceu_subdev - Wraps v4l2 sub-device and provides async subdevice.
> + */
> +struct ceu_subdev {
> +	struct v4l2_subdev *v4l2_sd;
> +	struct v4l2_async_subdev asd;
> +
> +	/* per-subdevice mbus configuration options */
> +	unsigned int mbus_flags;
> +	struct ceu_mbus_fmt mbus_fmt;
> +};
> +
> +static struct ceu_subdev *to_ceu_subdev(struct v4l2_async_subdev *asd)
> +{
> +	return container_of(asd, struct ceu_subdev, asd);
> +}
> +
> +/**
> + * ceu_device - CEU device instance
> + */
> +struct ceu_device {
> +	struct device		*dev;
> +	struct video_device	vdev;
> +	struct v4l2_device	v4l2_dev;
> +
> +	/* subdevices descriptors */
> +	struct ceu_subdev	*subdevs;
> +	/* the subdevice currently in use */
> +	struct ceu_subdev	*sd;
> +	unsigned int		sd_index;
> +	unsigned int		num_sd;
> +
> +	/* currently configured field and pixel format */
> +	enum v4l2_field	field;
> +	struct v4l2_pix_format_mplane v4l2_pix;
> +
> +	/* async subdev notification helpers */
> +	struct v4l2_async_notifier notifier;
> +	/* pointers to "struct ceu_subdevice -> asd" */
> +	struct v4l2_async_subdev **asds;
> +
> +	/* vb2 queue, capture buffer list and active buffer pointer */
> +	struct vb2_queue	vb2_vq;
> +	struct list_head	capture;
> +	struct vb2_v4l2_buffer	*active;
> +	unsigned int		sequence;
> +
> +	/* mlock - locks on open/close and vb2 operations */

Lock documentation should usually explain what data is protected by the lock.

> +	struct mutex	mlock;
> +
> +	/* lock - lock access to capture buffer queue and active buffer */
> +	spinlock_t	lock;
> +
> +	/* base - CEU memory base address */
> +	void __iomem	*base;
> +};
> +
> +static inline struct ceu_device *v4l2_to_ceu(struct v4l2_device *v4l2_dev)
> +{
> +	return container_of(v4l2_dev, struct ceu_device, v4l2_dev);
> +}
> +
> +/* ------------------------------------------------------------------------
> + * CEU memory output formats
> + */
> +
> +/**
> + * ceu_fmt - describe a memory output format supported by CEU interface
> + *
> + * @fourcc: memory layout fourcc format code
> + * @bpp: bit for each pixel stored in memory

Do you mean number of bits ?

> + */
> +struct ceu_fmt {
> +	u32	fourcc;
> +	u8	bpp;

This will take 32 bits anyway due to alignment constraints, I'd make the field 
an unsigned int.

> +};
> +
> +/**
> + * ceu_format_list - List of supported memory output formats
> + *
> + * If sensor provides any YUYV bus format, all the following planar memory
> + * formats are available thanks to CEU re-ordering and sub-sampling
> + * capabilities.
> + */
> +static const struct ceu_fmt ceu_fmt_list[] = {
> +	{
> +		.fourcc	= V4L2_PIX_FMT_NV16,
> +		.bpp	= 16,
> +	},
> +	{
> +		.fourcc = V4L2_PIX_FMT_NV61,
> +		.bpp	= 16,
> +	},
> +	{
> +		.fourcc	= V4L2_PIX_FMT_NV12,
> +		.bpp	= 12,
> +	},
> +	{
> +		.fourcc	= V4L2_PIX_FMT_NV21,
> +		.bpp	= 12,
> +	},
> +	{
> +		.fourcc	= V4L2_PIX_FMT_YUYV,
> +		.bpp	= 16,
> +	},
> +};
> +
> +static const struct ceu_fmt *get_ceu_fmt_from_fourcc(unsigned int fourcc)
> +{
> +	const struct ceu_fmt *fmt = &ceu_fmt_list[0];
> +	unsigned int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(ceu_fmt_list); i++, fmt++)
> +		if (fmt->fourcc == fourcc)
> +			return fmt;
> +
> +	return NULL;
> +}
> +
> +static inline bool ceu_is_fmt_planar(struct v4l2_pix_format_mplane *pix)

No need for the inline keyword, the compiler should be smart enough to decide.

> +{
> +	switch (pix->pixelformat) {
> +	case V4L2_PIX_FMT_YUYV:
> +		return false;
> +	case V4L2_PIX_FMT_NV16:
> +	case V4L2_PIX_FMT_NV61:
> +	case V4L2_PIX_FMT_NV12:
> +	case V4L2_PIX_FMT_NV21:
> +		return true;
> +	}
> +
> +	return true;

Maybe a default case instead ?

> +}

[snip]

> +/**
> + * ceu_soft_reset() - Software reset the CEU interface
> + */
> +static int ceu_soft_reset(struct ceu_device *ceudev)
> +{
> +	unsigned int reset_done;
> +	unsigned int i;
> +
> +	ceu_write(ceudev, CEU_CAPSR, CEU_CAPSR_CPKIL);
> +
> +	reset_done = 0;
> +	for (i = 0; i < 1000 && !reset_done; i++) {
> +		udelay(1);
> +		if (!(ceu_read(ceudev, CEU_CSTSR) & CEU_CSTRST_CPTON))
> +			reset_done++;
> +	}

How many iterations does this typically require ? Wouldn't a sleep be better 
than a delay ? As far as I can tell the ceu_soft_reset() function is only 
called with interrupts disabled (in interrupt context) from ceu_capture() in 
an error path, and that code should be reworked to make it possible to sleep 
if a reset takes too long.

> +	if (!reset_done) {
> +		v4l2_err(&ceudev->v4l2_dev, "soft reset time out\n");

How about dev_err() instead ?

> +		return -EIO;
> +	}
> +
> +	reset_done = 0;
> +	for (i = 0; i < 1000; i++) {
> +		udelay(1);
> +		if (!(ceu_read(ceudev, CEU_CAPSR) & CEU_CAPSR_CPKIL))
> +			return 0;
> +	}
> +
> +	/* if we get here, CEU has not reset properly */
> +	return -EIO;
> +}
> +
> +/* ------------------------------------------------------------------------
> + * CEU Capture Operations
> + */
> +
> +/**
> + * ceu_capture() - Trigger start of a capture sequence
> + *
> + * Return value doesn't reflect the success/failure to queue the new
> buffer,
> + * but rather the status of the previous capture.
> + */
> +static int ceu_capture(struct ceu_device *ceudev)
> +{
> +	struct v4l2_pix_format_mplane *pix = &ceudev->v4l2_pix;
> +	dma_addr_t phys_addr_top;
> +	u32 status;
> +
> +	/* Clean interrupt status and re-enable interrupts */
> +	status = ceu_read(ceudev, CEU_CETCR);
> +	ceu_write(ceudev, CEU_CEIER,
> +		  ceu_read(ceudev, CEU_CEIER) & ~CEU_CEIER_MASK);
> +	ceu_write(ceudev, CEU_CETCR, ~status & CEU_CETCR_MAGIC);
> +	ceu_write(ceudev, CEU_CEIER, CEU_CEIER_MASK);

I wonder why there's a need to disable and reenable interrupts here.

> +	ceu_write(ceudev, CEU_CAPCR,
> +		  ceu_read(ceudev, CEU_CAPCR) & ~CEU_CAPCR_CTNCP);
> +
> +	/*
> +	 * When a VBP interrupt occurs, a capture end interrupt does not occur
> +	 * and the image of that frame is not captured correctly.
> +	 */
> +	if (status & CEU_CEIER_VBP) {
> +		v4l2_err(&ceudev->v4l2_dev,
> +			 "VBP interrupt while capturing\n");
> +		ceu_soft_reset(ceudev);
> +		return -EIO;
> +	} else if (!ceudev->active) {
> +		v4l2_err(&ceudev->v4l2_dev,
> +			 "No available buffers for capture\n");
> +		return -EINVAL;
> +	}
> +
> +	phys_addr_top =
> +		vb2_dma_contig_plane_dma_addr(&ceudev->active->vb2_buf, 0);
> +	ceu_write(ceudev, CEU_CDAYR, phys_addr_top);
> +
> +	/* Ignore CbCr plane in data sync mode */
> +	if (ceu_is_fmt_planar(pix)) {
> +		phys_addr_top =
> +			vb2_dma_contig_plane_dma_addr(&ceudev->active->vb2_buf,
> +						      1);
> +		ceu_write(ceudev, CEU_CDACR, phys_addr_top);
> +	}
> +
> +	/*
> +	 * Trigger new capture start: once per each frame, as we work in
> +	 * one-frame capture mode
> +	 */
> +	ceu_write(ceudev, CEU_CAPSR, CEU_CAPSR_CE);
> +
> +	return 0;
> +}
> +
> +static irqreturn_t ceu_irq(int irq, void *data)
> +{
> +	struct ceu_device *ceudev = data;
> +	struct vb2_v4l2_buffer *vbuf;
> +	struct ceu_buffer *buf;
> +	int ret;
> +
> +	spin_lock(&ceudev->lock);
> +	vbuf = ceudev->active;
> +	if (!vbuf)
> +		/* Stale interrupt from a released buffer */
> +		goto out;

Shouldn't you at least clear the interrupt source (done at the beginning of 
the ceu_capture() function) in this case ? I'd move the handling of the 
interrupt status from ceu_capture() to here and pass the status to the capture 
function. Or even handle the status here completely, as status handling isn't 
needed when ceu_capture() is called from ceu_start_streaming().

> +	/* Prepare a new 'active' buffer and trigger a new capture */
> +	buf = vb2_to_ceu(vbuf);
> +	vbuf->vb2_buf.timestamp = ktime_get_ns();
> +
> +	if (!list_empty(&ceudev->capture)) {
> +		buf = list_first_entry(&ceudev->capture, struct ceu_buffer,
> +				       queue);
> +		list_del(&buf->queue);
> +		ceudev->active = &buf->vb;
> +	} else {
> +		ceudev->active = NULL;
> +	}
> +
> +	/*
> +	 * If the new capture started successfully, mark the previous buffer
> +	 * as "DONE".
> +	 */
> +	ret = ceu_capture(ceudev);
> +	if (!ret) {
> +		vbuf->field = ceudev->field;
> +		vbuf->sequence = ceudev->sequence++;

Shouldn't you set the sequence number even when an error occurs ? You should 
also complete all buffers with VB2_BUF_STATE_ERROR in that case, as 
ceu_capture() won't start a new capture, otherwise userspace will hang 
forever.

> +	}
> +
> +	vb2_buffer_done(&vbuf->vb2_buf,
> +			ret < 0 ? VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
> +
> +out:
> +	spin_unlock(&ceudev->lock);
> +
> +	return IRQ_HANDLED;

You shouldn't return IRQ_HANDLED if the IRQ status reported no interrupt.

> +}
> +
> +/* ------------------------------------------------------------------------
> + * CEU Videobuf operations
> + */
> +
> +/**
> + * ceu_calc_plane_sizes() - Fill 'struct v4l2_plane_pix_format' per plane
> + *			    information according to the currently configured
> + *			    pixel format.
> + */
> +static int ceu_calc_plane_sizes(struct ceu_device *ceudev,
> +				const struct ceu_fmt *ceu_fmt,
> +				struct v4l2_pix_format_mplane *pix)
> +{
> +	struct v4l2_plane_pix_format *plane_fmt = &pix->plane_fmt[0];
> +
> +	switch (pix->pixelformat) {
> +	case V4L2_PIX_FMT_YUYV:
> +		pix->num_planes			= 1;
> +		plane_fmt[0].bytesperline	= pix->width * ceu_fmt->bpp / 8;

Doesn't the driver support configurable stride ?

> +		plane_fmt[0].sizeimage		= pix->height *
> +						  plane_fmt[0].bytesperline;

Padding at the end of the image should be allowed if requested by userspace.

> +		break;
> +	case V4L2_PIX_FMT_NV16:
> +	case V4L2_PIX_FMT_NV61:
> +		pix->num_planes			= 2;
> +		plane_fmt[0].bytesperline	= pix->width;
> +		plane_fmt[0].sizeimage		= pix->height * pix->width;
> +		plane_fmt[1]			= plane_fmt[0];
> +		break;
> +	case V4L2_PIX_FMT_NV12:
> +	case V4L2_PIX_FMT_NV21:
> +		pix->num_planes			= 2;
> +		plane_fmt[0].bytesperline	= pix->width;
> +		plane_fmt[0].sizeimage		= pix->height * pix->width;
> +		plane_fmt[1].bytesperline	= pix->width;
> +		plane_fmt[1].sizeimage		= pix->height * pix->width / 2;
> +		break;
> +	default:

Can this happen ? ceu_try_fmt() should have validated the format.

> +		pix->num_planes			= 0;
> +		v4l2_err(&ceudev->v4l2_dev,
> +			 "Format 0x%x not supported\n", pix->pixelformat);
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +/*
> + * ceu_videobuf_setup() - is called to check, whether the driver can accept

s/check,/check/

> the
> + *			  requested number of buffers and to fill in plane sizes
> + *			  for the current frame format, if required.
> + */
> +static int ceu_videobuf_setup(struct vb2_queue *vq, unsigned int *count,
> +			      unsigned int *num_planes, unsigned int sizes[],
> +			      struct device *alloc_devs[])
> +{
> +	struct ceu_device *ceudev = vb2_get_drv_priv(vq);
> +	struct v4l2_pix_format_mplane *pix = &ceudev->v4l2_pix;
> +	unsigned int i;
> +
> +	if (!vq->num_buffers)
> +		ceudev->sequence = 0;

Why do you reset the sequence number here, shouldn't it be done at stream 
start instead ?

> +	if (!*count)
> +		*count = 2;
> +
> +	/* num_planes is set: just check plane sizes */
> +	if (*num_planes) {
> +		for (i = 0; i < pix->num_planes; i++) {
> +			if (sizes[i] < pix->plane_fmt[i].sizeimage)
> +				return -EINVAL;
> +		}
> +
> +		return 0;
> +	}
> +
> +	/* num_planes not set: called from REQBUFS, just set plane sizes */
> +	*num_planes = pix->num_planes;
> +	for (i = 0; i < pix->num_planes; i++)
> +		sizes[i] = pix->plane_fmt[i].sizeimage;
> +
> +	return 0;
> +}
> +
> +static void ceu_videobuf_queue(struct vb2_buffer *vb)
> +{
> +	struct ceu_device *ceudev = vb2_get_drv_priv(vb->vb2_queue);
> +	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
> +	struct v4l2_pix_format_mplane *pix = &ceudev->v4l2_pix;
> +	struct ceu_buffer *buf = vb2_to_ceu(vbuf);
> +	unsigned long irqflags;
> +	unsigned int i;
> +
> +	for (i = 0; i < pix->num_planes; i++) {
> +		if (vb2_plane_size(vb, i) < pix->plane_fmt[i].sizeimage) {
> +			v4l2_err(&ceudev->v4l2_dev,
> +				 "Buffer #%d too small (%lu < %u)\n",
> +				 vb->index, vb2_plane_size(vb, i),
> +				 pix->plane_fmt[i].sizeimage);

I wouldn't print an error message, otherwise userspace will have yet another 
way to flood the kernel log.

> +			goto error;
> +		}
> +
> +		vb2_set_plane_payload(vb, i, pix->plane_fmt[i].sizeimage);
> +	}
> +
> +	spin_lock_irqsave(&ceudev->lock, irqflags);
> +	list_add_tail(&buf->queue, &ceudev->capture);
> +	spin_unlock_irqrestore(&ceudev->lock, irqflags);
> +
> +	return;
> +
> +error:
> +	vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);

You can inline this call, get rid of the error label and the return statement.

> +}
> +
> +static int ceu_start_streaming(struct vb2_queue *vq, unsigned int count)
> +{
> +	struct ceu_device *ceudev = vb2_get_drv_priv(vq);
> +	struct v4l2_subdev *v4l2_sd = ceudev->sd->v4l2_sd;
> +	struct ceu_buffer *buf;
> +	unsigned long irqflags;
> +	int ret = 0;

No need to assign ret to 0.

> +	ret = v4l2_subdev_call(v4l2_sd, video, s_stream, 1);
> +	if (ret && ret != -ENOIOCTLCMD) {
> +		v4l2_err(&ceudev->v4l2_dev,
> +			 "Subdevice failed to start streaming: %d\n", ret);
> +		goto error_return_bufs;
> +	}
> +
> +	spin_lock_irqsave(&ceudev->lock, irqflags);
> +	ceudev->sequence = 0;
> +
> +	if (ceudev->active) {

Can this happen ?

> +		ret = -EINVAL;
> +		spin_unlock_irqrestore(&ceudev->lock, irqflags);
> +		goto error_stop_sensor;
> +	}
> +
> +	/* Grab the first available buffer and trigger the first capture. */
> +	buf = list_first_entry(&ceudev->capture, struct ceu_buffer,
> +			       queue);
> +	list_del(&buf->queue);
> +
> +	ceudev->active = &buf->vb;
> +	ret = ceu_capture(ceudev);
> +	if (ret) {
> +		spin_unlock_irqrestore(&ceudev->lock, irqflags);

You can move this call out of the error check just after ceu_capture().

> +		goto error_stop_sensor;
> +	}
> +
> +	spin_unlock_irqrestore(&ceudev->lock, irqflags);
> +
> +	return 0;
> +
> +error_stop_sensor:
> +	v4l2_subdev_call(v4l2_sd, video, s_stream, 0);
> +
> +error_return_bufs:
> +	spin_lock_irqsave(&ceudev->lock, irqflags);
> +	list_for_each_entry(buf, &ceudev->capture, queue)
> +		vb2_buffer_done(&ceudev->active->vb2_buf,
> +				VB2_BUF_STATE_QUEUED);
> +	ceudev->active = NULL;
> +	spin_unlock_irqrestore(&ceudev->lock, irqflags);
> +
> +	return ret;
> +}
> +
> +static void ceu_stop_streaming(struct vb2_queue *vq)
> +{
> +	struct ceu_device *ceudev = vb2_get_drv_priv(vq);
> +	struct v4l2_subdev *v4l2_sd = ceudev->sd->v4l2_sd;
> +	struct ceu_buffer *buf;
> +	unsigned long irqflags;
> +
> +	v4l2_subdev_call(v4l2_sd, video, s_stream, 0);
> +
> +	spin_lock_irqsave(&ceudev->lock, irqflags);
> +	if (ceudev->active) {
> +		vb2_buffer_done(&ceudev->active->vb2_buf,
> +				VB2_BUF_STATE_ERROR);
> +		ceudev->active = NULL;
> +	}
> +
> +	/* Release all queued buffers */
> +	list_for_each_entry(buf, &ceudev->capture, queue)
> +		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
> +	INIT_LIST_HEAD(&ceudev->capture);
> +
> +	spin_unlock_irqrestore(&ceudev->lock, irqflags);
> +
> +	ceu_soft_reset(ceudev);
> +}

[snip]

> +/**

Is this really kerneldoc ?

> + * ------------------------------------------------------------------------
> + *  CEU bus operations
> + */
> +static unsigned int ceu_mbus_config_compatible(
> +		const struct v4l2_mbus_config *cfg,
> +		unsigned int ceu_host_flags)
> +{
> +	unsigned int common_flags = cfg->flags & ceu_host_flags;
> +	bool hsync, vsync, pclk, data, mode;
> +
> +	switch (cfg->type) {
> +	case V4L2_MBUS_PARALLEL:
> +		hsync = common_flags & (V4L2_MBUS_HSYNC_ACTIVE_HIGH |
> +					V4L2_MBUS_HSYNC_ACTIVE_LOW);
> +		vsync = common_flags & (V4L2_MBUS_VSYNC_ACTIVE_HIGH |
> +					V4L2_MBUS_VSYNC_ACTIVE_LOW);
> +		pclk = common_flags & (V4L2_MBUS_PCLK_SAMPLE_RISING |
> +				       V4L2_MBUS_PCLK_SAMPLE_FALLING);
> +		data = common_flags & (V4L2_MBUS_DATA_ACTIVE_HIGH |
> +				       V4L2_MBUS_DATA_ACTIVE_LOW);
> +		mode = common_flags & (V4L2_MBUS_MASTER | V4L2_MBUS_SLAVE);
> +		break;
> +	default:

Can this happen ? You should reject non-parallel sensors at probe time (or 
subdev bind time).

> +		return 0;
> +	}
> +
> +	return (hsync && vsync && pclk && data && mode) ? common_flags : 0;
> +}
> +
> +/**
> + * ceu_test_mbus_param() - test bus parameters against sensor provided
> ones.
> + *
> + * @return: < 0 for errors
> + *	    0 if g_mbus_config is not supported,
> + *	    > 0  for bus configuration flags supported by (ceu AND sensor)
> + */
> +static int ceu_test_mbus_param(struct ceu_device *ceudev)
> +{
> +	struct v4l2_subdev *sd = ceudev->sd->v4l2_sd;
> +	unsigned long common_flags = CEU_BUS_FLAGS;
> +	struct v4l2_mbus_config cfg = {
> +		.type = V4L2_MBUS_PARALLEL,
> +	};
> +	int ret;
> +
> +	ret = v4l2_subdev_call(sd, video, g_mbus_config, &cfg);
> +	if (ret < 0 && ret != -ENOIOCTLCMD)
> +		return ret;
> +	else if (ret == -ENOIOCTLCMD)
> +		return 0;
> +
> +	common_flags = ceu_mbus_config_compatible(&cfg, common_flags);
> +	if (!common_flags)
> +		return -EINVAL;
> +
> +	return common_flags;

This is a legacy of soc_camera that tried to negotiate bus parameters with the 
source subdevice. We have later established that this isn't a good idea, as 
there could be components on the board that affect those settings (for 
instance inverters on the synchronization signals). This is why with DT we 
specify the bus configuration in endpoints on both sides. You should thus 
always use the bus configuration provided through DT or platform data and 
ignore the one reported by the subdev.

> +}
> +
> +/**
> + * ceu_set_bus_params() - Configure CEU interface registers using bus
> + *			  parameters
> + */
> +static int ceu_set_bus_params(struct ceu_device *ceudev)
> +{
> +	u32 camcr = 0, cdocr = 0, cfzsr = 0, cdwdr = 0, capwr = 0;

No need to assign a value to cdocr, cfzsr, cdwdr and capwr.

> +	struct v4l2_pix_format_mplane *pix = &ceudev->v4l2_pix;
> +	struct ceu_subdev *ceu_sd = ceudev->sd;
> +	struct ceu_mbus_fmt *mbus_fmt = &ceu_sd->mbus_fmt;
> +	struct v4l2_subdev *v4l2_sd = ceu_sd->v4l2_sd;
> +	unsigned int mbus_flags = ceu_sd->mbus_flags;
> +	unsigned long common_flags = CEU_BUS_FLAGS;

No need to assign a value to common_flags.

> +	int ret;
> +	struct v4l2_mbus_config cfg = {
> +		.type = V4L2_MBUS_PARALLEL,
> +	};
> +
> +	/*
> +	 * If client doesn't implement g_mbus_config, we just use our
> +	 * platform data.
> +	 */
> +	ret = ceu_test_mbus_param(ceudev);
> +	if (ret < 0)
> +		return ret;
> +	else if (ret == 0)
> +		common_flags = ceudev->sd->mbus_flags;
> +	else
> +		common_flags = ret;
> +
> +	/*
> +	 * If the we can choose between multiple alternatives select
> +	 * active high polarities.
> +	 */
> +	if ((common_flags & V4L2_MBUS_HSYNC_ACTIVE_HIGH) &&
> +	    (common_flags & V4L2_MBUS_HSYNC_ACTIVE_LOW)) {
> +		if (mbus_flags & V4L2_MBUS_HSYNC_ACTIVE_HIGH)
> +			common_flags &= ~V4L2_MBUS_HSYNC_ACTIVE_LOW;
> +		else
> +			common_flags &= ~V4L2_MBUS_HSYNC_ACTIVE_HIGH;
> +	}
> +
> +	if ((common_flags & V4L2_MBUS_VSYNC_ACTIVE_HIGH) &&
> +	    (common_flags & V4L2_MBUS_VSYNC_ACTIVE_LOW)) {
> +		if (mbus_flags & V4L2_MBUS_VSYNC_ACTIVE_HIGH)
> +			common_flags &= ~V4L2_MBUS_VSYNC_ACTIVE_LOW;
> +		else
> +			common_flags &= ~V4L2_MBUS_VSYNC_ACTIVE_HIGH;
> +	}
> +
> +	cfg.flags = common_flags;
> +	ret = v4l2_subdev_call(v4l2_sd, video, s_mbus_config, &cfg);

For the same reasons described above, don't call .s_mbus_config(), but update 
the sensor drivers to apply the configuration specified in DT or platform 
data.

> +	if (ret < 0 && ret != -ENOIOCTLCMD)
> +		return ret;
> +
> +	/* Start configuring CEU registers */
> +	ceu_write(ceudev, CEU_CAIFR, 0);
> +	ceu_write(ceudev, CEU_CFWCR, 0);
> +	ceu_write(ceudev, CEU_CRCNTR, 0);
> +	ceu_write(ceudev, CEU_CRCMPR, 0);
> +
> +	/* Set the frame capture period for both image capture and data sync */
> +	capwr = (pix->height << 16) | pix->width * mbus_fmt->bpp / 8;
> +
> +	/*
> +	 * Swap input data endianness by default.
> +	 * In data fetch mode bytes are received in chunks of 8 bytes.
> +	 * D0, D1, D2, D3, D4, D5, D6, D7 (D0 received first)
> +	 * The data is however by default written to memory in reverse order:
> +	 * D7, D6, D5, D4, D3, D2, D1, D0 (D7 written to lowest byte)
> +	 *
> +	 * Use CEU_CDOCR[2:0] to swap data ordering.
> +	 */
> +	cdocr = CEU_CDOCR_SWAP_ENDIANNESS;
> +
> +	/*
> +	 * Configure CAMCR and CDOCR:
> +	 * match input components ordering with memory output format and
> +	 * handle downsampling to YUV420.
> +	 *
> +	 * If the memory output planar format is 'swapped' (Cr before Cb) and
> +	 * input format is not, use the swapped version of CAMCR.DTARY.
> +	 *
> +	 * If the memory output planar format is not 'swapped' (Cb before Cr)
> +	 * and input format is, use the swapped version of CAMCR.DTARY.
> +	 *
> +	 * CEU by default downsample to planar YUV420 (CDCOR[4] = 0).
> +	 * If output is planar YUV422 set CDOCR[4] = 1
> +	 *
> +	 * No downsample for data fetch sync mode.
> +	 */
> +	switch (pix->pixelformat) {
> +	/* data fetch sync mode */
> +	case V4L2_PIX_FMT_YUYV:
> +		/* TODO: handle YUYV permutations through DTARY bits */
> +		camcr	|= CEU_CAMCR_JPEG;
> +		cdocr	|= CEU_CDOCR_NO_DOWSAMPLE;
> +		cfzsr	= (pix->height << 16) | pix->width;
> +		cdwdr	= pix->plane_fmt[0].bytesperline;
> +		break;
> +
> +	/* non-swapped planar image capture mode */
> +	case V4L2_PIX_FMT_NV16:
> +		cdocr	|= CEU_CDOCR_NO_DOWSAMPLE;
> +	case V4L2_PIX_FMT_NV12:
> +		if (mbus_fmt->swapped)
> +			camcr |= mbus_fmt->fmt_order_swap;
> +		else
> +			camcr |= mbus_fmt->fmt_order;
> +
> +		cfzsr	= (pix->height << 16) | pix->width;
> +		cdwdr	= pix->width;
> +		break;
> +
> +	/* swapped planar image capture mode */
> +	case V4L2_PIX_FMT_NV61:
> +		cdocr	|= CEU_CDOCR_NO_DOWSAMPLE;
> +	case V4L2_PIX_FMT_NV21:
> +		if (mbus_fmt->swapped)
> +			camcr |= mbus_fmt->fmt_order;
> +		else
> +			camcr |= mbus_fmt->fmt_order_swap;
> +
> +		cfzsr	= (pix->height << 16) | pix->width;
> +		cdwdr	= pix->width;
> +		break;
> +	}
> +
> +	camcr |= common_flags & V4L2_MBUS_VSYNC_ACTIVE_LOW ? 1 << 1 : 0;
> +	camcr |= common_flags & V4L2_MBUS_HSYNC_ACTIVE_LOW ? 1 << 0 : 0;
> +
> +	/* TODO: handle 16 bit bus width with DTIF bit in CAMCR */
> +	ceu_write(ceudev, CEU_CAMCR, camcr);
> +	ceu_write(ceudev, CEU_CDOCR, cdocr);
> +	ceu_write(ceudev, CEU_CAPCR, CEU_CAPCR_BUS_WIDTH256);
> +
> +	/*
> +	 * TODO: make CAMOR offsets configurable.
> +	 * CAMOR wants to know the number of blanks between a VS/HS signal
> +	 * and valid data. This value should actually come from the sensor...
> +	 */
> +	ceu_write(ceudev, CEU_CAMOR, 0);
> +
> +	/* TODO: 16 bit bus width require re-calculation of cdwdr and cfzsr */
> +	ceu_write(ceudev, CEU_CAPWR, capwr);
> +	ceu_write(ceudev, CEU_CFSZR, cfzsr);
> +	ceu_write(ceudev, CEU_CDWDR, cdwdr);
> +
> +	return 0;
> +}
> +
> +/**

Is this really kerneldoc ?

> + * ------------------------------------------------------------------------
> + *  CEU image formats handling
> + */
> +
> +/**
> + * ceu_try_fmt() - test format on CEU and sensor
> + *
> + * @v4l2_fmt: format to test
> + */
> +static int ceu_try_fmt(struct ceu_device *ceudev, struct v4l2_format
> *v4l2_fmt)
> +{
> +	struct v4l2_pix_format_mplane *pix = &v4l2_fmt->fmt.pix_mp;
> +	struct ceu_subdev *ceu_sd = ceudev->sd;
> +	struct v4l2_subdev *v4l2_sd = ceu_sd->v4l2_sd;
> +	struct v4l2_subdev_pad_config pad_cfg;
> +	const struct ceu_fmt *ceu_fmt;
> +	int ret;
> +
> +	struct v4l2_subdev_format sd_format = {
> +		.which = V4L2_SUBDEV_FORMAT_TRY,
> +	};
> +
> +	switch (pix->pixelformat) {
> +	case V4L2_PIX_FMT_YUYV:
> +	case V4L2_PIX_FMT_NV16:
> +	case V4L2_PIX_FMT_NV61:
> +	case V4L2_PIX_FMT_NV12:
> +	case V4L2_PIX_FMT_NV21:
> +		break;
> +
> +	default:
> +		v4l2_err(&ceudev->v4l2_dev,
> +			 "Pixel format 0x%x not supported, default to NV16\n",
> +			 pix->pixelformat);

I wouldn't print an error message, otherwise userspace will have yet another 
way to flood the kernel log.

> +		pix->pixelformat = V4L2_PIX_FMT_NV16;
> +	}
> +
> +	ceu_fmt = get_ceu_fmt_from_fourcc(pix->pixelformat);
> +
> +	/* CFSZR requires height and width to be 4-pixel aligned */
> +	v4l_bound_align_image(&pix->width, 2, CEU_MAX_WIDTH, 2,
> +			      &pix->height, 4, CEU_MAX_HEIGHT, 2, 0);

Then why do you align them to 2 ? :-)

> +	/*
> +	 * Set format on sensor sub device: bus format used to produce memory
> +	 * format is selected at initialization time
> +	 */
> +	v4l2_fill_mbus_format_mplane(&sd_format.format, pix);
> +	ret = v4l2_subdev_call(v4l2_sd, pad, set_fmt, &pad_cfg, &sd_format);
> +	if (ret)
> +		return ret;
> +
> +	/* Scale down to sensor supported sizes */
> +	if (sd_format.format.width != pix->width ||
> +	    sd_format.format.height != pix->height) {
> +		v4l2_err(&ceudev->v4l2_dev,
> +			 "Unable to apply: 0x%x - %ux%u - scale to %ux%u\n",
> +			 pix->pixelformat, pix->width, pix->height,
> +			 sd_format.format.width, sd_format.format.height);

This shouldn't print an error message to the kernel log either.

> +		pix->width = sd_format.format.width;
> +		pix->height = sd_format.format.height;
> +	}

No need for a conditional assignment, you can just write

	/* The CEU can't scale. */
	pix->width = sd_format.format.width;
	pix->height = sd_format.format.height;

> +
> +	/* Calculate per-plane sizes based on image format */
> +	v4l2_fill_pix_format_mplane(pix, &sd_format.format);
> +	pix->field = V4L2_FIELD_NONE;
> +	ret = ceu_calc_plane_sizes(ceudev, ceu_fmt, pix);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = ceu_test_mbus_param(ceudev);
> +	if (ret < 0)
> +		return ret;
> +
> +	return 0;
> +}
> +
> +/**
> + * ceu_set_fmt() - Apply the supplied format to both sensor and CEU
> + */
> +static int ceu_set_fmt(struct ceu_device *ceudev, struct v4l2_format
> *v4l2_fmt)
> +{
> +	struct ceu_subdev *ceu_sd = ceudev->sd;
> +	struct v4l2_subdev *v4l2_sd = ceu_sd->v4l2_sd;
> +	int ret;
> +
> +	struct v4l2_subdev_format format = {
> +		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
> +	};
> +
> +	ret = ceu_try_fmt(ceudev, v4l2_fmt);
> +	if (ret)
> +		return ret;
> +
> +	v4l2_fill_mbus_format_mplane(&format.format, &v4l2_fmt->fmt.pix_mp);
> +	ret = v4l2_subdev_call(v4l2_sd, pad, set_fmt, NULL, &format);
> +	if (ret)
> +		return ret;
> +
> +	ceudev->v4l2_pix = v4l2_fmt->fmt.pix_mp;
> +
> +	ret = ceu_set_bus_params(ceudev);

Do you need to do this here, can't you program the registers once at streamon 
time only ?

> +	if (ret)
> +		return ret;
> +
> +	return 0;
> +}
> +
> +/**
> + * ceu_set_default_fmt() - Apply default NV16 memory output format with VGA
> + *			   sizes.
> + */
> +static int ceu_set_default_fmt(struct ceu_device *ceudev)
> +{
> +	int ret;
> +	struct v4l2_format v4l2_fmt = {
> +		.type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE,
> +		.fmt.pix_mp = {
> +			.width		= VGA_WIDTH,
> +			.height		= VGA_HEIGHT,
> +			.field		= V4L2_FIELD_NONE,
> +			.pixelformat	= V4L2_PIX_FMT_NV16,
> +			.plane_fmt	= {
> +				[0]	= {
> +					.sizeimage = VGA_WIDTH * VGA_HEIGHT * 2,
> +					.bytesperline = VGA_WIDTH * 2,
> +				},
> +				[1]	= {
> +					.sizeimage = VGA_WIDTH * VGA_HEIGHT * 2,
> +					.bytesperline = VGA_WIDTH * 2,
> +				},
> +			},
> +		},
> +	};
> +
> +	ret = ceu_try_fmt(ceudev, &v4l2_fmt);
> +	if (ret)
> +		return ret;

I would assume the default values not to generate an error.

> +	ceudev->v4l2_pix = v4l2_fmt.fmt.pix_mp;
> +
> +	return 0;
> +}
> +
> +/**
> + * ceu_init_formats() - Query sensor for supported formats and initialize
> + *			CEU supported format list
> + *
> + * Find out if sensor can produce a permutation of 8-bits YUYV bus format.
> + * From a single 8-bits YUYV bus format the CEU can produce several memory
> + * output formats:
> + * - NV[12|21|16|61] through image fetch mode;
> + * - YUYV422 if sensor provides YUYV422
> + *
> + * TODO: Other YUYV422 permutations throug data fetch sync mode and DTARY

s/throug/through/

> + * TODO: Binary data (eg. JPEG) and raw formats through data fetch sync
> mode
> + */
> +static int ceu_init_formats(struct ceu_device *ceudev)
> +{
> +	struct ceu_subdev *ceu_sd = ceudev->sd;
> +	struct ceu_mbus_fmt *mbus_fmt = &ceu_sd->mbus_fmt;
> +	struct v4l2_subdev *v4l2_sd = ceu_sd->v4l2_sd;
> +	bool yuyv_bus_fmt = false;
> +
> +	struct v4l2_subdev_mbus_code_enum sd_mbus_fmt = {
> +		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
> +		.index = 0,
> +	};
> +
> +	/* Find out if sensor can produce any permutation of 8-bits YUYV422 */
> +	while (!yuyv_bus_fmt &&
> +	       !v4l2_subdev_call(v4l2_sd, pad, enum_mbus_code,
> +				 NULL, &sd_mbus_fmt)) {
> +		switch (sd_mbus_fmt.code) {
> +		case MEDIA_BUS_FMT_YUYV8_2X8:
> +		case MEDIA_BUS_FMT_YVYU8_2X8:
> +		case MEDIA_BUS_FMT_UYVY8_2X8:
> +		case MEDIA_BUS_FMT_VYUY8_2X8:
> +			yuyv_bus_fmt = true;
> +			break;
> +		default:
> +			/*
> +			 * Only support 8-bits YUYV bus formats at the moment;
> +			 *
> +			 * TODO: add support for binary formats (data sync
> +			 * fetch mode).
> +			 */
> +			break;
> +		}
> +
> +		sd_mbus_fmt.index++;
> +	}
> +
> +	if (!yuyv_bus_fmt)
> +		return -ENXIO;
> +
> +	/*
> +	 * Save the first encountered YUYV format as "mbus_fmt" and use it
> +	 * to output all planar YUV422 and YUV420 (NV*) formats to memory as
> +	 * well as for data synch fetch mode (YUYV - YVYU etc. ).
> +	 */
> +	mbus_fmt->mbus_code	= sd_mbus_fmt.code;
> +	mbus_fmt->bps		= 8;
> +
> +	/* Annotate the selected bus format components ordering */
> +	switch (sd_mbus_fmt.code) {
> +	case MEDIA_BUS_FMT_YUYV8_2X8:
> +		mbus_fmt->fmt_order		= CEU_CAMCR_DTARY_8_YUYV;
> +		mbus_fmt->fmt_order_swap	= CEU_CAMCR_DTARY_8_YVYU;
> +		mbus_fmt->swapped		= false;
> +		mbus_fmt->bpp			= 16;
> +		break;
> +
> +	case MEDIA_BUS_FMT_YVYU8_2X8:
> +		mbus_fmt->fmt_order		= CEU_CAMCR_DTARY_8_YVYU;
> +		mbus_fmt->fmt_order_swap	= CEU_CAMCR_DTARY_8_YUYV;
> +		mbus_fmt->swapped		= true;
> +		mbus_fmt->bpp			= 16;
> +		break;
> +
> +	case MEDIA_BUS_FMT_UYVY8_2X8:
> +		mbus_fmt->fmt_order		= CEU_CAMCR_DTARY_8_UYVY;
> +		mbus_fmt->fmt_order_swap	= CEU_CAMCR_DTARY_8_VYUY;
> +		mbus_fmt->swapped		= false;
> +		mbus_fmt->bpp			= 16;
> +		break;
> +
> +	case MEDIA_BUS_FMT_VYUY8_2X8:
> +		mbus_fmt->fmt_order		= CEU_CAMCR_DTARY_8_VYUY;
> +		mbus_fmt->fmt_order_swap	= CEU_CAMCR_DTARY_8_UYVY;
> +		mbus_fmt->swapped		= true;
> +		mbus_fmt->bpp			= 16;
> +		break;
> +	}
> +
> +	ceudev->field = V4L2_FIELD_NONE;
> +
> +	return 0;
> +}
> +
> +/**

Is this really kerneldoc ?

> + * ------------------------------------------------------------------------
> + *  Runtime PM Handlers
> + */

[snip]

> +/**

Ditto.

> + * ------------------------------------------------------------------------
> + *  File Operations
> + */

[snip]

> +/**

Ditto.

> + * -----------------------------------------------------------------------
> + *  Video Device IOCTLs
> + */
> +static int ceu_querycap(struct file *file, void *priv,
> +			struct v4l2_capability *cap)
> +{
> +	strlcpy(cap->card, "Renesas-CEU", sizeof(cap->card));
> +	strlcpy(cap->driver, DRIVER_NAME, sizeof(cap->driver));
> +	strlcpy(cap->bus_info, "platform:renesas-ceu", sizeof(cap->bus_info));

Shouldn't this distinguish between multiple instances of the same device ?

> +
> +	return 0;
> +}

[snip]

> +static int ceu_enum_input(struct file *file, void *priv,
> +			  struct v4l2_input *inp)
> +{
> +	if (inp->index != 0)
> +		return -EINVAL;

Doesn't the driver support two inputs ?

> +	inp->type = V4L2_INPUT_TYPE_CAMERA;
> +	inp->std = 0;
> +	strcpy(inp->name, "Camera");

Shouldn't this reflect the name of the input ?

> +
> +	return 0;
> +}
> +
> +static int ceu_g_input(struct file *file, void *priv, unsigned int *i)
> +{
> +	struct ceu_device *ceudev = video_drvdata(file);
> +
> +	*i = ceudev->sd_index;
> +
> +	return 0;
> +}
> +
> +static int ceu_s_input(struct file *file, void *priv, unsigned int i)
> +{
> +	struct ceu_device *ceudev = video_drvdata(file);
> +	struct ceu_subdev *ceu_sd_old;
> +	int ret;
> +
> +	if (i >= ceudev->num_sd)
> +		return -EINVAL;
> +
> +	ceu_sd_old = ceudev->sd;
> +	ceudev->sd = &ceudev->subdevs[i];
> +
> +	/* Make sure we can generate output image formats. */
> +	ret = ceu_init_formats(ceudev);
> +	if (ret) {
> +		ceudev->sd = ceu_sd_old;
> +		return -EINVAL;
> +	}
> +
> +	/* now that we're sure we can use the sensor, power off the old one */
> +	v4l2_subdev_call(ceu_sd_old->v4l2_sd, core, s_power, 0);
> +	v4l2_subdev_call(ceudev->sd->v4l2_sd, core, s_power, 1);

What if this function is called while streaming ?

> +	ceudev->sd_index = i;
> +
> +	return 0;
> +}

[snip]

> +static int ceu_sensor_bound(struct v4l2_async_notifier *notifier,
> +			    struct v4l2_subdev *v4l2_sd,
> +			    struct v4l2_async_subdev *asd)
> +{
> +	struct v4l2_device *v4l2_dev = notifier->v4l2_dev;
> +	struct ceu_device *ceudev = v4l2_to_ceu(v4l2_dev);
> +	struct ceu_subdev *ceu_sd = to_ceu_subdev(asd);
> +
> +	if (video_is_registered(&ceudev->vdev)) {
> +		v4l2_err(&ceudev->v4l2_dev,
> +			 "Video device registered before this sub-device.\n");
> +		return -EBUSY;

Can this happen ?

> +	}
> +
> +	/* Assign subdevices in the order they appear */
> +	ceu_sd->v4l2_sd = v4l2_sd;
> +	ceudev->num_sd++;
> +
> +	return 0;
> +}
> +
> +static int ceu_sensor_complete(struct v4l2_async_notifier *notifier)
> +{
> +	struct v4l2_device *v4l2_dev = notifier->v4l2_dev;
> +	struct ceu_device *ceudev = v4l2_to_ceu(v4l2_dev);
> +	struct video_device *vdev = &ceudev->vdev;
> +	struct vb2_queue *q = &ceudev->vb2_vq;
> +	struct v4l2_subdev *v4l2_sd;
> +	int ret;
> +
> +	/* Initialize vb2 queue */
> +	q->type			= V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
> +	q->io_modes		= VB2_MMAP | VB2_USERPTR;

No dmabuf ?

> +	q->drv_priv		= ceudev;
> +	q->ops			= &ceu_videobuf_ops;
> +	q->mem_ops		= &vb2_dma_contig_memops;
> +	q->buf_struct_size	= sizeof(struct ceu_buffer);
> +	q->timestamp_flags	= V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> +	q->lock			= &ceudev->mlock;
> +	q->dev			= ceudev->v4l2_dev.dev;

[snip]

> +static int ceu_probe(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct ceu_device *ceudev;
> +	struct resource *res;
> +	void __iomem *base;
> +	unsigned int irq;
> +	int num_sd;
> +	int ret;
> +
> +	ceudev = kzalloc(sizeof(*ceudev), GFP_KERNEL);

The memory is freed in ceu_vdev_release() as expected, but that will only work 
if the video device is registered. If the subdevs are never bound, the ceudev 
memory will be leaked if you unbind the CEU device from its driver. In my 
opinion this calls for registering the video device at probe time (although 
Hans disagrees).

> +	if (!ceudev)
> +		return -ENOMEM;
> +
> +	platform_set_drvdata(pdev, ceudev);
> +	dev_set_drvdata(dev, ceudev);

You don't need the second line, platform_set_drvdata() is a wrapper around 
dev_set_drvdata().

> +	ceudev->dev = dev;
> +
> +	INIT_LIST_HEAD(&ceudev->capture);
> +	spin_lock_init(&ceudev->lock);
> +	mutex_init(&ceudev->mlock);
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (IS_ERR(res))
> +		return PTR_ERR(res);

No need for error handling here, devm_ioremap_resource() will check the res 
pointer.

> +	base = devm_ioremap_resource(dev, res);

You can assign ceudev->base directly and remove the base local variable.

> +	if (IS_ERR(base))
> +		return PTR_ERR(base);
> +	ceudev->base = base;
> +
> +	ret = platform_get_irq(pdev, 0);
> +	if (ret < 0) {
> +		dev_err(dev, "failed to get irq: %d\n", ret);
> +		return ret;
> +	}
> +	irq = ret;
> +
> +	ret = devm_request_irq(dev, irq, ceu_irq,
> +			       0, dev_name(dev), ceudev);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Unable to register CEU interrupt.\n");
> +		return ret;
> +	}
> +
> +	pm_suspend_ignore_children(dev, true);
> +	pm_runtime_enable(dev);
> +
> +	ret = v4l2_device_register(dev, &ceudev->v4l2_dev);
> +	if (ret)
> +		goto error_pm_disable;
> +
> +	if (IS_ENABLED(CONFIG_OF) && dev->of_node) {
> +		num_sd = ceu_parse_dt(ceudev);
> +	} else if (dev->platform_data) {
> +		num_sd = ceu_parse_platform_data(ceudev, dev->platform_data);
> +	} else {
> +		dev_err(dev, "CEU platform data not set and no OF support\n");
> +		ret = -EINVAL;
> +		goto error_v4l2_unregister;
> +	}
> +
> +	if (num_sd < 0) {
> +		ret = num_sd;
> +		goto error_v4l2_unregister;
> +	} else if (num_sd == 0)
> +		return 0;

You need braces around the second statement too.

[snip]

> +static const struct dev_pm_ops ceu_pm_ops = {
> +	SET_RUNTIME_PM_OPS(ceu_runtime_suspend,
> +			   ceu_runtime_resume,
> +			   NULL)

You'll probably need system PM ops eventually, but for now this isn't a 
regression so I won't complain too much.

> +};

[snip]

-- 
Regards,

Laurent Pinchart
