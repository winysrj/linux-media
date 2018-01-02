Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:50622 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751505AbeABNqI (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 2 Jan 2018 08:46:08 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: magnus.damm@gmail.com, geert@glider.be, mchehab@kernel.org,
        hverkuil@xs4all.nl, robh+dt@kernel.org, mark.rutland@arm.com,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/9] v4l: platform: Add Renesas CEU driver
Date: Tue, 02 Jan 2018 15:46:27 +0200
Message-ID: <1538398.BnUWTlhJjz@avalon>
In-Reply-To: <1514469681-15602-4-git-send-email-jacopo+renesas@jmondi.org>
References: <1514469681-15602-1-git-send-email-jacopo+renesas@jmondi.org> <1514469681-15602-4-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

Thank you for the patch.

On Thursday, 28 December 2017 16:01:15 EET Jacopo Mondi wrote:
> Add driver for Renesas Capture Engine Unit (CEU).
> 
> The CEU interface supports capturing 'data' (YUV422) and 'images'
> (NV[12|21|16|61]).
> 
> This driver aims to replace the soc_camera-based sh_mobile_ceu one.
> 
> Tested with ov7670 camera sensor, providing YUYV_2X8 data on Renesas RZ
> platform GR-Peach.
> 
> Tested with ov7725 camera sensor on SH4 platform Migo-R.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> ---
>  drivers/media/platform/Kconfig       |    9 +
>  drivers/media/platform/Makefile      |    1 +
>  drivers/media/platform/renesas-ceu.c | 1652 ++++++++++++++++++++++++++++++
>  3 files changed, 1662 insertions(+)
>  create mode 100644 drivers/media/platform/renesas-ceu.c

[snip]

> diff --git a/drivers/media/platform/renesas-ceu.c
> b/drivers/media/platform/renesas-ceu.c new file mode 100644
> index 0000000..76d12f0
> --- /dev/null
> +++ b/drivers/media/platform/renesas-ceu.c
> @@ -0,0 +1,1652 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/*
> + * V4L2 Driver for Renesas Capture Engine Unit (CEU) interface
> + * Copyright (C) 2017/18 Jacopo Mondi <jacopo+renesas@jmondi.org>
> + *
> + * Based on soc-camera driver "soc_camera/sh_mobile_ceu_camera.c"
> + * Copyright (C) 2008 Magnus Damm
> + *
> + * Based on V4L2 Driver for PXA camera host - "pxa_camera.c",
> + * Copyright (C) 2006, Sascha Hauer, Pengutronix
> + * Copyright (C) 2008, Guennadi Liakhovetski <kernel@pengutronix.de>
> + */
> +
> +#include <linux/delay.h>
> +#include <linux/device.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/err.h>
> +#include <linux/errno.h>
> +#include <linux/io.h>
> +#include <linux/interrupt.h>

N comes before O :-)

> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/mm.h>
> +#include <linux/of.h>
> +#include <linux/of_graph.h>
> +#include <linux/of_device.h>

And D before G.

> +#include <linux/platform_device.h>
> +#include <linux/pm_runtime.h>
> +#include <linux/slab.h>
> +#include <linux/time.h>
> +#include <linux/videodev2.h>
> +
> +#include <media/v4l2-async.h>
> +#include <media/v4l2-common.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-dev.h>
> +#include <media/v4l2-fwnode.h>
> +#include <media/v4l2-ioctl.h>
> +#include <media/v4l2-image-sizes.h>

And M before O.

> +#include <media/v4l2-mediabus.h>
> +#include <media/videobuf2-dma-contig.h>
> +
> +#include <media/drv-intf/renesas-ceu.h>

[snip]

> +/*
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
> +	/* platform specific mask with all IRQ sources flagged */
> +	u32			irq_mask;
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
> +	/* mlock - lock device suspend/resume and videobuf2 operations */

In my review of v1 I commented that lock documentation should explain what 
data is protected by the lock. As my point seems not to have come across it 
must not have been clear enough, I'll try to fix that.

The purpose of a lock is to protect from concurrent access to a resource. In 
device drivers resources are in most cases either in-memory data or device 
registers. To design a good locking scheme you need to ask yourself what 
resources can be accessed concurrently, and then protect all accesses to those 
resources using locking primitives. Some accesses don't need to be protected 
(for instance it's common to initialize structure fields in the probe function 
where no concurrent access from userspace can occur as device nodes are not 
registered yet), and locking can then be omitted in a case by case basis.

Lock documentation is essential to understand the locking scheme and should 
explain what resources are protected by the lock. It's tempting (because it's 
easy) to instead focus on what code sections the lock covers, but that's not 
how the locking scheme should be designed, and will eventually be prone to 
bugs leading to race conditions.

Obviously a lock will end up preventing multiple code sections from running at 
the same time, but that's the consequence of the locking scheme, it shouldn't 
be its cause.

> +	struct mutex	mlock;
> +
> +	/* lock - lock access to capture buffer queue and active buffer */
> +	spinlock_t	lock;
> +
> +	/* base - CEU memory base address */
> +	void __iomem	*base;
> +};

[snip]

> +/*
> + * ceu_soft_reset() - Software reset the CEU interface
> + * @ceu_device: CEU device.
> + *
> + * Returns 0 for success, -EIO for error.
> + */
> +static int ceu_soft_reset(struct ceu_device *ceudev)
> +{
> +	unsigned int i;
> +
> +	ceu_write(ceudev, CEU_CAPSR, CEU_CAPSR_CPKIL);
> +
> +	for (i = 0; i < 100; i++) {
> +		udelay(1);

How about moving the delay after the check in case the condition is true 
immediately ?

> +		if (!(ceu_read(ceudev, CEU_CSTSR) & CEU_CSTRST_CPTON))
> +			break;
> +	}
> +
> +	if (i == 100) {
> +		dev_err(ceudev->dev, "soft reset time out\n");
> +		return -EIO;
> +	}
> +
> +	for (i = 0; i < 100; i++) {
> +		udelay(1);

Same here.

> +		if (!(ceu_read(ceudev, CEU_CAPSR) & CEU_CAPSR_CPKIL))
> +			return 0;
> +	}
> +
> +	/* if we get here, CEU has not reset properly */
> +	return -EIO;
> +}
> +
> +/* CEU Capture Operations */

Just curious, why have you replaced the block comments by single-line comments 
? I pointed out that the format was wrong as you started them with /** and 
they were not kerneldoc, but I have nothing against splitting the code in 
sections with headers such as

/* --------------------------------------------------------------------------
 * CEU Capture Operations
 */

as I do so routinely in my drivers. If that's your preferred style and you 
thought I asked for a change you can switch back, if you prefer single-line 
comments that's fine with me too.

> +
> +/*
> + * ceu_hw_config() - Configure CEU interface registers
> + */
> +static int ceu_hw_config(struct ceu_device *ceudev)
> +{
> +	u32 camcr = 0, cdocr = 0, cfzsr = 0, cdwdr = 0, capwr = 0;

No need to assign a value to cdocr, cfzsr, cdwdr and capwr.

> +	struct v4l2_pix_format_mplane *pix = &ceudev->v4l2_pix;
> +	struct ceu_subdev *ceu_sd = ceudev->sd;
> +	struct ceu_mbus_fmt *mbus_fmt = &ceu_sd->mbus_fmt;
> +	unsigned int mbus_flags = ceu_sd->mbus_flags;
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

camcr is always 0 here (and in all the other cases below), so you can just 
assign the value directly, and skip the initialization when declaring it.

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
> +	camcr |= mbus_flags & V4L2_MBUS_VSYNC_ACTIVE_LOW ? 1 << 1 : 0;
> +	camcr |= mbus_flags & V4L2_MBUS_HSYNC_ACTIVE_LOW ? 1 << 0 : 0;
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

[snip]

> +	/*
> +	 * Trigger new capture start: once for each frame, as we work in
> +	 * one-frame capture mode.
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
> +	u32 status;
> +	int ret = 0;
> +
> +	/* Clean interrupt status. */
> +	status = ceu_read(ceudev, CEU_CETCR);
> +	ceu_write(ceudev, CEU_CETCR, ~ceudev->irq_mask);
> +
> +	/* Unexpected interrupt. */
> +	if (!(status & CEU_CEIER_MASK))
> +		return IRQ_NONE;
> +
> +	spin_lock(&ceudev->lock);
> +
> +	/* Stale interrupt from a released buffer, ignore it. */
> +	vbuf = ceudev->active;
> +	if (!vbuf) {
> +		spin_unlock(&ceudev->lock);
> +		return IRQ_NONE;

Shouldn't you return IRQ_HANDLED here ? The driver ignores the IRQ but has 
still handled it, so it shouldn't be flagged as an unhandled interrupt.

> +	}
> +
> +	/*
> +	 * When a VBP interrupt occurs, no capture end interrupt will occur
> +	 * and the image of that frame is not captured correctly.
> +	 */
> +	if (status & CEU_CEIER_VBP) {
> +		dev_err(ceudev->dev,
> +			"VBP interrupt: abort capture\n");

No need for a line break.

> +		ret = -EINVAL;
> +		goto error_irq_out;
> +	}
> +
> +	/* Prepare to return the 'previous' buffer. */
> +	vbuf->vb2_buf.timestamp = ktime_get_ns();
> +	vbuf->sequence = ceudev->sequence++;
> +	vbuf->field = ceudev->field;
> +
> +	/* Prepare a new 'active' buffer and trigger a new capture. */
> +	if (list_empty(&ceudev->capture))
> +		goto error_irq_out;

This isn't an error. Your code should operate correctly as the capture list is 
empty so the list_for_each_entry() in the error path will be a no-op, but it's 
still a bit confusing. How about writing this as

	/* Prepare a new 'active' buffer and trigger a new capture. */
	if (!list_empty(&ceudev->capture)) {
		buf = list_first_entry(&ceudev->capture, struct ceu_buffer,
				      queue);
		list_del(&buf->queue);
		ceudev->active = &buf->vb;

		ceu_capture(ceudev);
	}

> +
> +	buf = list_first_entry(&ceudev->capture, struct ceu_buffer, queue);
> +	list_del(&buf->queue);
> +	ceudev->active = &buf->vb;
> +
> +	ceu_capture(ceudev);
> +
> +	/* Return the 'previous' buffer */
> +	vb2_buffer_done(&vbuf->vb2_buf, VB2_BUF_STATE_DONE);
> +
> +	spin_unlock(&ceudev->lock);
> +
> +	return IRQ_HANDLED;
> +
> +error_irq_out:
> +	/* Return the 'previous' buffer and all queued ones. */
> +	vb2_buffer_done(&vbuf->vb2_buf, ret < 0 ?
> +					VB2_BUF_STATE_ERROR :
> +					VB2_BUF_STATE_DONE);

If you agree to my suggestion above you can use VB2_BUF_STATE_ERROR 
unconditionally.

> +
> +	list_for_each_entry(buf, &ceudev->capture, queue)
> +		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
> +
> +	spin_unlock(&ceudev->lock);
> +
> +	return IRQ_HANDLED;
> +}

[snip]

> +/*
> + * ceu_calc_plane_sizes() - Fill per-plane 'struct v4l2_plane_pix_format'
> + *			    information according to the currently configured
> + *			    pixel format.
> + * @ceu_device: CEU device.
> + * @ceu_fmt: Active image format.
> + * @pix: Pixel format information (store line width and image sizes)
> + *
> + * Returns 0 for success.
> + */
> +static int ceu_calc_plane_sizes(struct ceu_device *ceudev,
> +				const struct ceu_fmt *ceu_fmt,
> +				struct v4l2_pix_format_mplane *pix)
> +{
> +	unsigned int bpl, szimage;
> +
> +	switch (pix->pixelformat) {
> +	case V4L2_PIX_FMT_YUYV:
> +		pix->num_planes	= 1;
> +		bpl		= pix->width * ceu_fmt->bpp / 8;
> +		szimage		= pix->height * bpl;
> +		ceu_update_plane_sizes(&pix->plane_fmt[0], bpl, szimage);
> +		break;
> +
> +	case V4L2_PIX_FMT_NV16:
> +	case V4L2_PIX_FMT_NV61:
> +		pix->num_planes	= 2;
> +		bpl		= pix->width;
> +		szimage		= pix->height * pix->width;
> +		ceu_update_plane_sizes(&pix->plane_fmt[0], bpl, szimage);
> +		ceu_update_plane_sizes(&pix->plane_fmt[1], bpl, szimage);
> +		break;
> +
> +	case V4L2_PIX_FMT_NV12:
> +	case V4L2_PIX_FMT_NV21:
> +		pix->num_planes	= 2;
> +		bpl		= pix->width;
> +		szimage		= pix->height * pix->width;
> +		ceu_update_plane_sizes(&pix->plane_fmt[0], bpl, szimage);
> +		ceu_update_plane_sizes(&pix->plane_fmt[1], bpl, szimage / 2);
> +		break;
> +
> +	default:
> +		pix->num_planes	= 0;
> +		dev_err(ceudev->dev,
> +			"Format 0x%x not supported\n", pix->pixelformat);
> +		return -EINVAL;

I think you can remove the default case as ceu_try_fmt() should have validated 
the format already. The compiler will then likely warn so you need to keep a 
default cause, but it will never be hit, so it can default to any format you 
want. The function can then be turned into a void.

> +	}
> +
> +	return 0;
> +}

[snip]

> +static int ceu_start_streaming(struct vb2_queue *vq, unsigned int count)
> +{
> +	struct ceu_device *ceudev = vb2_get_drv_priv(vq);
> +	struct v4l2_subdev *v4l2_sd = ceudev->sd->v4l2_sd;
> +	struct ceu_buffer *buf;
> +	unsigned long irqflags;
> +	int ret;
> +
> +	ret = v4l2_subdev_call(v4l2_sd, video, s_stream, 1);
> +	if (ret && ret != -ENOIOCTLCMD) {
> +		dev_dbg(ceudev->dev,
> +			"Subdevice failed to start streaming: %d\n", ret);
> +		goto error_return_bufs;
> +	}
> +
> +	/* Program the CEU interface according to the CEU image format */
> +	ret = ceu_hw_config(ceudev);
> +	if (ret)
> +		goto error_stop_sensor;

I think you should program the CEU before starting the sensor, sending video 
to an unprogrammed CEU could lead to unpleasant results (or maybe not, but 
it's better to be safe than sorry).

> +	spin_lock_irqsave(&ceudev->lock, irqflags);
> +	ceudev->sequence = 0;
> +
> +	/* Grab the first available buffer and trigger the first capture. */
> +	buf = list_first_entry(&ceudev->capture, struct ceu_buffer,
> +			       queue);
> +	if (!buf) {
> +		spin_unlock_irqrestore(&ceudev->lock, irqflags);
> +		dev_dbg(ceudev->dev,
> +			"No buffer available for capture.\n");
> +		goto error_stop_sensor;
> +	}
> +
> +	list_del(&buf->queue);
> +	ceudev->active = &buf->vb;
> +
> +	/* Clean and program interrupts for first capture. */
> +	ceu_write(ceudev, CEU_CETCR, ~ceudev->irq_mask);
> +	ceu_write(ceudev, CEU_CEIER, CEU_CEIER_MASK);
> +
> +	ceu_capture(ceudev);
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

[snip]

> +/*
> + * ceu_try_fmt() - test format on CEU and sensor
> + * @ceudev: The CEU device.
> + * @v4l2_fmt: format to test.
> + *
> + * Returns 0 for success, < 0 for errors.
> + */
> +static int ceu_try_fmt(struct ceu_device *ceudev, struct v4l2_format
> *v4l2_fmt)
> +{
> +	struct ceu_subdev *ceu_sd = ceudev->sd;
> +	struct v4l2_pix_format_mplane *pix = &v4l2_fmt->fmt.pix_mp;
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
> +		pix->pixelformat = V4L2_PIX_FMT_NV16;
> +	}
> +
> +	ceu_fmt = get_ceu_fmt_from_fourcc(pix->pixelformat);
> +
> +	/* CFSZR requires height and width to be 4-pixel aligned */
> +	v4l_bound_align_image(&pix->width, 2, CEU_MAX_WIDTH, 4,
> +			      &pix->height, 4, CEU_MAX_HEIGHT, 4, 0);
> +
> +	/*
> +	 * Set format on sensor sub device: bus format used to produce memory
> +	 * format is selected at initialization time.
> +	 */
> +	v4l2_fill_mbus_format_mplane(&sd_format.format, pix);
> +	ret = v4l2_subdev_call(v4l2_sd, pad, set_fmt, &pad_cfg, &sd_format);
> +	if (ret)
> +		return ret;
> +
> +	/* Apply sizez returned by sensor as the CEU can't scale */

Unless you were trying to document the driver in l33t speak I'd write size 
instead of sizez :)

> +	v4l2_fill_pix_format_mplane(pix, &sd_format.format);
> +
> +	/* Calculate per-plane sizes based on image format */
> +	ret = ceu_calc_plane_sizes(ceudev, ceu_fmt, pix);
> +	if (ret < 0)
> +		return ret;
> +
> +	return 0;
> +}

[snip]

> +/*
> + * ceu_set_default_fmt() - Apply default NV16 memory output format with VGA
> + *			   sizes.
> + */
> +static int ceu_set_default_fmt(struct ceu_device *ceudev)
> +{
> +	struct v4l2_format v4l2_fmt = {
> +		.type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE,
> +		.fmt.pix_mp = {
> +			.width		= VGA_WIDTH,
> +			.height		= VGA_HEIGHT,
> +			.field		= V4L2_FIELD_NONE,
> +			.pixelformat	= V4L2_PIX_FMT_NV16,
> +			.num_planes	= 2,
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
> +	ceu_try_fmt(ceudev, &v4l2_fmt);

You've removed the error check here. ceu_try_fmt() shouldn't fail, but it 
calls a sensor driver subdev operation over which you have no control. It's up 
to you, but if you decide to ignore errors, I would turn this function into 
void.

I know I've asked in my review of v1 for the error check to be removed, but I 
think I had missed the fact that a subdev operation was called.

> +	ceudev->v4l2_pix = v4l2_fmt.fmt.pix_mp;
> +
> +	return 0;
> +}

[snip]


> +/* Video Device IOCTLs */
> +static int ceu_querycap(struct file *file, void *priv,
> +			struct v4l2_capability *cap)
> +{
> +	struct ceu_device *ceudev = video_drvdata(file);
> +
> +	snprintf(cap->card, sizeof(cap->card),
> +		 "Renesas CEU %s", dev_name(ceudev->dev));

You don't need to make the device name part of the card field, having it in 
bus_info is enough.

> +	strlcpy(cap->driver, DRIVER_NAME, sizeof(cap->driver));
> +	snprintf(cap->bus_info, sizeof(cap->bus_info),
> +		 "platform:renesas-ceu-%s", dev_name(ceudev->dev));
> +
> +	return 0;
> +}

[snip]

> +/*
> + * ceu_parse_init_sd() - Initialize CEU subdevices and async_subdevs in
> + *			 ceu device. Both DT and platform data parsing use
> + *			 this routine.
> + *
> + * @return 0 for success, -ENOMEM for failure.
> + */
> +static int ceu_parse_init_sd(struct ceu_device *ceudev, unsigned int n_sd)

This doesn't parse anything, how about calling it ceu_init_async_subdevs (or 
something similar) ?

> +{
> +	/* Reserve memory for 'n_sd' ceu_subdev descriptors */
> +	ceudev->subdevs = devm_kcalloc(ceudev->dev, n_sd,
> +				       sizeof(*ceudev->subdevs), GFP_KERNEL);
> +	if (!ceudev->subdevs)
> +		return -ENOMEM;
> +
> +	/*
> +	 * Reserve memory for 'n_sd' pointers to async_subdevices.
> +	 * ceudev->asds members will point to &ceu_subdev.asd
> +	 */
> +	ceudev->asds = devm_kcalloc(ceudev->dev, n_sd,
> +				    sizeof(*ceudev->asds), GFP_KERNEL);
> +	if (!ceudev->asds)
> +		return -ENOMEM;
> +
> +	ceudev->sd = NULL;
> +	ceudev->sd_index = 0;
> +	ceudev->num_sd = 0;
> +
> +	return 0;
> +}
> +
> +/*
> + * ceu_parse_platform_data() - Initialize async_subdevices using platform
> + *			       device provided data.
> + */
> +static int ceu_parse_platform_data(struct ceu_device *ceudev, void *pdata)
> +{
> +	struct ceu_async_subdev *async_sd;
> +	struct ceu_info *info = pdata;

This should be const.

You can replace void *pdata with const struct ceu_info *pdata in the function 
arguments, no need to go through a void variable.

> +	struct ceu_subdev *ceu_sd;
> +	unsigned int i;
> +	int ret;
> +
> +	if (info->num_subdevs == 0)
> +		return -ENODEV;
> +
> +	ret = ceu_parse_init_sd(ceudev, info->num_subdevs);
> +	if (ret)
> +		return ret;
> +
> +	for (i = 0; i < info->num_subdevs; i++) {
> +		/* Setup the ceu subdevice and the async subdevice */
> +		async_sd = &info->subdevs[i];
> +		ceu_sd = &ceudev->subdevs[i];
> +
> +		memset(&ceu_sd->asd, 0, sizeof(ceu_sd->asd));

Isn't the memory initialized to 0 when allocated ?

> +		INIT_LIST_HEAD(&ceu_sd->asd.list);
> +
> +		ceu_sd->mbus_flags	= async_sd->flags;
> +		ceu_sd->asd.match_type	= V4L2_ASYNC_MATCH_I2C;
> +		ceu_sd->asd.match.i2c.adapter_id = async_sd->i2c_adapter_id;
> +		ceu_sd->asd.match.i2c.address = async_sd->i2c_address;
> +
> +		ceudev->asds[i] = &ceu_sd->asd;
> +	}
> +
> +	return info->num_subdevs;
> +}
> +
> +/*
> + * ceu_parse_dt() - Initialize async_subdevs parsing device tree graph
> + */
> +static int ceu_parse_dt(struct ceu_device *ceudev)
> +{
> +	struct device_node *of = ceudev->dev->of_node;
> +	struct v4l2_fwnode_endpoint fw_ep;
> +	struct ceu_subdev *ceu_sd;
> +	struct device_node *ep;
> +	unsigned int i;
> +	int num_ep;
> +	int ret;
> +
> +	num_ep = of_graph_get_endpoint_count(of);
> +	if (!num_ep)
> +		return -ENODEV;
> +
> +	ret = ceu_parse_init_sd(ceudev, num_ep);
> +	if (ret)
> +		return ret;
> +
> +	for (i = 0; i < num_ep; i++) {
> +		ep = of_graph_get_endpoint_by_regs(of, 0, i);
> +		if (!ep) {
> +			dev_err(ceudev->dev,
> +				 "No subdevice connected on port %u.\n", i);

Shouldn't it be "on endpoint %u" ? You're only parsing port 0.

> +			ret = -ENODEV;
> +			goto error_put_node;
> +		}
> +
> +		ret = v4l2_fwnode_endpoint_parse(of_fwnode_handle(ep), &fw_ep);
> +		if (ret) {
> +			dev_err(ceudev->dev,
> +				 "Unable to parse endpoint #%u.\n", i);
> +			goto error_put_node;
> +		}
> +
> +		if (fw_ep.bus_type != V4L2_MBUS_PARALLEL) {
> +			dev_err(ceudev->dev,
> +				 "Only parallel input supported.\n");
> +			ret = -EINVAL;
> +			goto error_put_node;
> +		}
> +
> +		/* Setup the ceu subdevice and the async subdevice */
> +		ceu_sd = &ceudev->subdevs[i];
> +		memset(&ceu_sd->asd, 0, sizeof(ceu_sd->asd));
> +		INIT_LIST_HEAD(&ceu_sd->asd.list);
> +
> +		ceu_sd->mbus_flags = fw_ep.bus.parallel.flags;
> +		ceu_sd->asd.match_type = V4L2_ASYNC_MATCH_FWNODE;
> +		ceu_sd->asd.match.fwnode.fwnode =
> +			fwnode_graph_get_remote_port_parent(
> +					of_fwnode_handle(ep));
> +
> +		ceudev->asds[i] = &ceu_sd->asd;
> +		of_node_put(ep);
> +	}
> +
> +	return num_ep;
> +
> +error_put_node:
> +	of_node_put(ep);
> +	return ret;
> +}
> +
> +struct ceu_data {
> +	u32 irq_mask;
> +} ceu_data_rz = {
> +	.irq_mask = CEU_CETCR_ALL_IRQS_RZ,
> +};

You can make this const. I would also separate the structure definition from 
the variable declaration, as you will later have more instances (at least one 
for SH4).

> +
> +#if IS_ENABLED(CONFIG_OF)
> +static const struct of_device_id ceu_of_match[] = {
> +	{ .compatible = "renesas,ceu", .data = &ceu_data_rz },
> +	{ .compatible = "renesas,r7s72100-ceu", .data = &ceu_data_rz },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(of, ceu_of_match);
> +#endif
> +
> +static int ceu_probe(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct ceu_device *ceudev;
> +	struct resource *res;
> +	unsigned int irq;
> +	int num_subdevs;
> +	int ret;
> +
> +	ceudev = kzalloc(sizeof(*ceudev), GFP_KERNEL);
> +	if (!ceudev)
> +		return -ENOMEM;
> +
> +	platform_set_drvdata(pdev, ceudev);
> +	ceudev->dev = dev;
> +
> +	INIT_LIST_HEAD(&ceudev->capture);
> +	spin_lock_init(&ceudev->lock);
> +	mutex_init(&ceudev->mlock);
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	ceudev->base = devm_ioremap_resource(dev, res);
> +	if (IS_ERR(ceudev->base))

ceudev is leaked here (and in all error paths below, including the error block 
at the end of the function).

> +		return PTR_ERR(ceudev->base);
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

s/register/request/

> +		return ret;
> +	}
> +
> +	pm_suspend_ignore_children(dev, true);

Does the CEU have child devices ?

> +	pm_runtime_enable(dev);
> +
> +	ret = v4l2_device_register(dev, &ceudev->v4l2_dev);
> +	if (ret)
> +		goto error_pm_disable;
> +
> +	if (IS_ENABLED(CONFIG_OF) && dev->of_node) {
> +		const struct of_device_id *match =
> +				of_match_device(ceu_of_match, dev);
> +		struct ceu_data *ceu_data = (struct ceu_data *) match->data;

You can make this const, no space needed before match->data, and match->data 
is a void pointer so there's no need to cast it explicitly.

		const struct ceu_data *ceu_data =
			of_match_device(ceu_of_match, dev)->data;

could do.

> +
> +		ceudev->irq_mask = ceu_data->irq_mask;
> +		num_subdevs = ceu_parse_dt(ceudev);
> +	} else if (dev->platform_data) {
> +		/* Assume SH4 if booting with platform data. */
> +		ceudev->irq_mask = CEU_CETCR_ALL_IRQS_SH4;

Another option to prepare for this would be to define ceu_data_sh4 already, 
move the ceu_data variable to the top of this function, assign

		ceu_data = &ceu_data_sh4;

here, and move the ceudev->irq_mask = ceu_data->irq_mask; line after the 
num_subdevs < 0 check below.

> +		num_subdevs = ceu_parse_platform_data(ceudev,
> +						      dev->platform_data);
> +	} else {
> +		num_subdevs = -EINVAL;
> +	}
> +
> +	if (num_subdevs < 0) {
> +		ret = num_subdevs;
> +		goto error_v4l2_unregister;
> +	}
> +
> +	ceudev->notifier.v4l2_dev	= &ceudev->v4l2_dev;
> +	ceudev->notifier.subdevs	= ceudev->asds;
> +	ceudev->notifier.num_subdevs	= num_subdevs;
> +	ceudev->notifier.ops		= &ceu_notify_ops;
> +	ret = v4l2_async_notifier_register(&ceudev->v4l2_dev,
> +					   &ceudev->notifier);
> +	if (ret)
> +		goto error_v4l2_unregister;
> +
> +	dev_info(dev, "Renesas Capture Engine Unit %s\n", dev_name(dev));
> +
> +	return 0;
> +
> +error_v4l2_unregister:
> +	v4l2_device_unregister(&ceudev->v4l2_dev);
> +error_pm_disable:
> +	pm_runtime_disable(dev);
> +
> +	return ret;
> +}
> +
> +static int ceu_remove(struct platform_device *pdev)
> +{
> +	struct ceu_device *ceudev = platform_get_drvdata(pdev);
> +
> +	pm_runtime_disable(ceudev->dev);
> +
> +	v4l2_async_notifier_unregister(&ceudev->notifier);
> +
> +	v4l2_device_unregister(&ceudev->v4l2_dev);
> +
> +	video_unregister_device(&ceudev->vdev);
> +
> +	return 0;
> +}

[snip]

-- 
Regards,

Laurent Pinchart
