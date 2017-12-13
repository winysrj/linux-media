Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:35990 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752102AbdLMMDG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Dec 2017 07:03:06 -0500
Subject: Re: [PATCH v1 03/10] v4l: platform: Add Renesas CEU driver
To: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        laurent.pinchart@ideasonboard.com, magnus.damm@gmail.com,
        geert@glider.be, mchehab@kernel.org
References: <1510743363-25798-1-git-send-email-jacopo+renesas@jmondi.org>
 <1510743363-25798-4-git-send-email-jacopo+renesas@jmondi.org>
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <db4d1c15-1a6c-7375-b1e1-e780b628ed04@xs4all.nl>
Date: Wed, 13 Dec 2017 13:03:03 +0100
MIME-Version: 1.0
In-Reply-To: <1510743363-25798-4-git-send-email-jacopo+renesas@jmondi.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 15/11/17 11:55, Jacopo Mondi wrote:
> Add driver for Renesas Capture Engine Unit (CEU).
> 
> The CEU interface supports capturing 'data' (YUV422) and 'images'
> (NV[12|21|16|61]).
> 
> This driver aims to replace the soc_camera based sh_mobile_ceu one.
> 
> Tested with ov7670 camera sensor, providing YUYV_2X8 data on Renesas RZ
> platform GR-Peach.
> 
> Tested with ov7725 camera sensor on SH4 platform Migo-R.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> ---
>  drivers/media/platform/Kconfig       |    9 +
>  drivers/media/platform/Makefile      |    2 +
>  drivers/media/platform/renesas-ceu.c | 1768 ++++++++++++++++++++++++++++++++++
>  3 files changed, 1779 insertions(+)
>  create mode 100644 drivers/media/platform/renesas-ceu.c
> 
> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> index 3c4f7fa..401caea 100644
> --- a/drivers/media/platform/Kconfig
> +++ b/drivers/media/platform/Kconfig
> @@ -144,6 +144,15 @@ config VIDEO_STM32_DCMI
>  	  To compile this driver as a module, choose M here: the module
>  	  will be called stm32-dcmi.
> 
> +config VIDEO_RENESAS_CEU
> +	tristate "Renesas Capture Engine Unit (CEU) driver"
> +	depends on VIDEO_DEV && VIDEO_V4L2 && HAS_DMA
> +	depends on ARCH_SHMOBILE || ARCH_R7S72100 || COMPILE_TEST
> +	select VIDEOBUF2_DMA_CONTIG
> +	select V4L2_FWNODE
> +	---help---
> +	  This is a v4l2 driver for the Renesas CEU Interface
> +
>  source "drivers/media/platform/soc_camera/Kconfig"
>  source "drivers/media/platform/exynos4-is/Kconfig"
>  source "drivers/media/platform/am437x/Kconfig"
> diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
> index 327f80a..0d1f02b 100644
> --- a/drivers/media/platform/Makefile
> +++ b/drivers/media/platform/Makefile
> @@ -27,6 +27,8 @@ obj-$(CONFIG_VIDEO_CODA) 		+= coda/
> 
>  obj-$(CONFIG_VIDEO_SH_VEU)		+= sh_veu.o
> 
> +obj-$(CONFIG_VIDEO_RENESAS_CEU)		+= renesas-ceu.o
> +
>  obj-$(CONFIG_VIDEO_MEM2MEM_DEINTERLACE)	+= m2m-deinterlace.o
> 
>  obj-$(CONFIG_VIDEO_MUX)			+= video-mux.o
> diff --git a/drivers/media/platform/renesas-ceu.c b/drivers/media/platform/renesas-ceu.c
> new file mode 100644
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
> + */
> +
> +#include <linux/completion.h>
> +#include <linux/delay.h>
> +#include <linux/device.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/err.h>
> +#include <linux/errno.h>
> +#include <linux/io.h>
> +#include <linux/init.h>
> +#include <linux/interrupt.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/mm.h>
> +#include <linux/of.h>
> +#include <linux/of_graph.h>
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
> +#include <media/v4l2-mediabus.h>
> +#include <media/videobuf2-dma-contig.h>
> +
> +#include <media/drv-intf/renesas-ceu.h>
> +
> +#define DRIVER_NAME	"renesas-ceu"
> +
> +/* ----------------------------------------------------------------------------
> + * CEU registers offsets and masks
> + */
> +#define CEU_CAPSR	0x00 /* Capture start register			*/
> +#define CEU_CAPCR	0x04 /* Capture control register		*/
> +#define CEU_CAMCR	0x08 /* Capture interface control register	*/
> +#define CEU_CAMOR	0x10 /* Capture interface offset register	*/
> +#define CEU_CAPWR	0x14 /* Capture interface width register	*/
> +#define CEU_CAIFR	0x18 /* Capture interface input format register */
> +#define CEU_CRCNTR	0x28 /* CEU register control register		*/
> +#define CEU_CRCMPR	0x2c /* CEU register forcible control register	*/
> +#define CEU_CFLCR	0x30 /* Capture filter control register		*/
> +#define CEU_CFSZR	0x34 /* Capture filter size clip register	*/
> +#define CEU_CDWDR	0x38 /* Capture destination width register	*/
> +#define CEU_CDAYR	0x3c /* Capture data address Y register		*/
> +#define CEU_CDACR	0x40 /* Capture data address C register		*/
> +#define CEU_CFWCR	0x5c /* Firewall operation control register	*/
> +#define CEU_CDOCR	0x64 /* Capture data output control register	*/
> +#define CEU_CEIER	0x70 /* Capture event interrupt enable register	*/
> +#define CEU_CETCR	0x74 /* Capture event flag clear register	*/
> +#define CEU_CSTSR	0x7c /* Capture status register			*/
> +#define CEU_CSRTR	0x80 /* Capture software reset register		*/
> +
> +/* Data synchronous fetch mode */
> +#define CEU_CAMCR_JPEG			BIT(4)
> +
> +/* Input components ordering: CEU_CAMCR.DTARY field */
> +#define CEU_CAMCR_DTARY_8_UYVY		(0x00 << 8)
> +#define CEU_CAMCR_DTARY_8_VYUY		(0x01 << 8)
> +#define CEU_CAMCR_DTARY_8_YUYV		(0x02 << 8)
> +#define CEU_CAMCR_DTARY_8_YVYU		(0x03 << 8)
> +/* TODO: input components ordering for 16 bits input */
> +
> +/* Bus transfer MTU */
> +#define CEU_CAPCR_BUS_WIDTH256		(0x3 << 20)
> +
> +/* Bus width configuration */
> +#define CEU_CAMCR_DTIF_16BITS		BIT(12)
> +
> +/* No downsampling to planar YUV420 in image fetch mode */
> +#define CEU_CDOCR_NO_DOWSAMPLE		BIT(4)
> +
> +/* Swap all input data in 8-bit, 16-bits and 32-bits units (Figure 46.45) */
> +#define CEU_CDOCR_SWAP_ENDIANNESS	(7)
> +
> +/* Capture reset and enable bits */
> +#define CEU_CAPSR_CPKIL			BIT(16)
> +#define CEU_CAPSR_CE			BIT(0)
> +
> +/* CEU operating flag bit */
> +#define CEU_CAPCR_CTNCP			BIT(16)
> +#define CEU_CSTRST_CPTON		BIT(1)
> +
> +/* Acknowledge magical interrupt sources */
> +#define CEU_CETCR_MAGIC			0x0317f313
> +/* Prohibited register access interrupt bit */
> +#define CEU_CETCR_IGRW			BIT(4)
> +/* One-frame capture end interrupt */
> +#define CEU_CEIER_CPE			BIT(0)
> +/* VBP error */
> +#define CEU_CEIER_VBP			BIT(20)
> +#define CEU_CEIER_MASK			(CEU_CEIER_CPE | CEU_CEIER_VBP)
> +
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
> +/* ----------------------------------------------------------------------------
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
> +/* ----------------------------------------------------------------------------
> + * CEU memory output formats
> + */
> +
> +/**
> + * ceu_fmt - describe a memory output format supported by CEU interface
> + *
> + * @fourcc: memory layout fourcc format code
> + * @bpp: bit for each pixel stored in memory
> + */
> +struct ceu_fmt {
> +	u32	fourcc;
> +	u8	bpp;
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
> +}
> +
> +/* ----------------------------------------------------------------------------
> + * CEU HW operations
> + */
> +static void ceu_write(struct ceu_device *priv, unsigned int reg_offs, u32 data)
> +{
> +	iowrite32(data, priv->base + reg_offs);
> +}
> +
> +static u32 ceu_read(struct ceu_device *priv, unsigned int reg_offs)
> +{
> +	return ioread32(priv->base + reg_offs);
> +}
> +
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
> +
> +	if (!reset_done) {
> +		v4l2_err(&ceudev->v4l2_dev, "soft reset time out\n");
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
> +/* ----------------------------------------------------------------------------
> + * CEU Capture Operations
> + */
> +
> +/**
> + * ceu_capture() - Trigger start of a capture sequence
> + *
> + * Return value doesn't reflect the success/failure to queue the new buffer,
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
> +
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
> +	}
> +
> +	vb2_buffer_done(&vbuf->vb2_buf,
> +			ret < 0 ? VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
> +
> +out:
> +	spin_unlock(&ceudev->lock);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +/* ----------------------------------------------------------------------------
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
> +		plane_fmt[0].sizeimage		= pix->height *
> +						  plane_fmt[0].bytesperline;
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
> + * ceu_videobuf_setup() - is called to check, whether the driver can accept the
> + *			  requested number of buffers and to fill in plane sizes
> + *			  for the current frame format, if required.
> + */
> +static int ceu_videobuf_setup(struct vb2_queue *vq, unsigned int *count,

A general request: can you replace all videobuf_ strings by vb2_?

'videobuf' generally refers to the first version of the videobuf framework (and
in fact, that's what soc_camera originally used), but I'd rather rename it here
so a grep on videobuf won't hit this driver.

> +			      unsigned int *num_planes, unsigned int sizes[],
> +			      struct device *alloc_devs[])
> +{
> +	struct ceu_device *ceudev = vb2_get_drv_priv(vq);
> +	struct v4l2_pix_format_mplane *pix = &ceudev->v4l2_pix;
> +	unsigned int i;
> +
> +	if (!vq->num_buffers)
> +		ceudev->sequence = 0;
> +
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
> +}
> +
> +static int ceu_start_streaming(struct vb2_queue *vq, unsigned int count)
> +{
> +	struct ceu_device *ceudev = vb2_get_drv_priv(vq);
> +	struct v4l2_subdev *v4l2_sd = ceudev->sd->v4l2_sd;
> +	struct ceu_buffer *buf;
> +	unsigned long irqflags;
> +	int ret = 0;
> +
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
> +
> +static const struct vb2_ops ceu_videobuf_ops = {
> +	.queue_setup	= ceu_videobuf_setup,
> +	.buf_queue	= ceu_videobuf_queue,
> +	.wait_prepare	= vb2_ops_wait_prepare,
> +	.wait_finish	= vb2_ops_wait_finish,
> +	.start_streaming = ceu_start_streaming,
> +	.stop_streaming	= ceu_stop_streaming,
> +};
> +
> +/**
> + * ----------------------------------------------------------------------------
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
> +		return 0;
> +	}
> +
> +	return (hsync && vsync && pclk && data && mode) ? common_flags : 0;
> +}
> +
> +/**
> + * ceu_test_mbus_param() - test bus parameters against sensor provided ones.
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

If at all possible, don't call this. This information should just come from
the device tree.

I want to eventually remove the g/s_mbus_config, so I'd rather not keep it here.
The soc_camera driver is one of the very few drivers that use it (the other is
pxa_camera).

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
> +}
> +
> +/**
> + * ceu_set_bus_params() - Configure CEU interface registers using bus
> + *			  parameters
> + */
> +static int ceu_set_bus_params(struct ceu_device *ceudev)
> +{
> +	u32 camcr = 0, cdocr = 0, cfzsr = 0, cdwdr = 0, capwr = 0;
> +	struct v4l2_pix_format_mplane *pix = &ceudev->v4l2_pix;
> +	struct ceu_subdev *ceu_sd = ceudev->sd;
> +	struct ceu_mbus_fmt *mbus_fmt = &ceu_sd->mbus_fmt;
> +	struct v4l2_subdev *v4l2_sd = ceu_sd->v4l2_sd;
> +	unsigned int mbus_flags = ceu_sd->mbus_flags;
> +	unsigned long common_flags = CEU_BUS_FLAGS;
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
> + * ----------------------------------------------------------------------------
> + *  CEU image formats handling
> + */
> +
> +/**
> + * ceu_try_fmt() - test format on CEU and sensor
> + *
> + * @v4l2_fmt: format to test
> + */
> +static int ceu_try_fmt(struct ceu_device *ceudev, struct v4l2_format *v4l2_fmt)
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
> +		pix->pixelformat = V4L2_PIX_FMT_NV16;
> +	}
> +
> +	ceu_fmt = get_ceu_fmt_from_fourcc(pix->pixelformat);
> +
> +	/* CFSZR requires height and width to be 4-pixel aligned */
> +	v4l_bound_align_image(&pix->width, 2, CEU_MAX_WIDTH, 2,
> +			      &pix->height, 4, CEU_MAX_HEIGHT, 2, 0);
> +
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
> +		pix->width = sd_format.format.width;
> +		pix->height = sd_format.format.height;
> +	}
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
> +static int ceu_set_fmt(struct ceu_device *ceudev, struct v4l2_format *v4l2_fmt)
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
> +
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
> + * TODO: Binary data (eg. JPEG) and raw formats through data fetch sync mode
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
> + * ----------------------------------------------------------------------------
> + *  Runtime PM Handlers
> + */
> +
> +/**
> + * ceu_runtime_suspend() - disable capture and interrupts and soft-reset.
> + *			   Turn sensor power off.
> + */
> +static int ceu_runtime_suspend(struct device *dev)
> +{
> +	struct ceu_device *ceudev = dev_get_drvdata(dev);
> +	struct v4l2_subdev *v4l2_sd = ceudev->sd->v4l2_sd;
> +
> +	v4l2_subdev_call(v4l2_sd, core, s_power, 0);
> +
> +	ceu_write(ceudev, CEU_CEIER, 0);
> +	ceu_soft_reset(ceudev);
> +
> +	return 0;
> +}
> +
> +/**
> + * ceu_runtime_resume() - soft-reset the interface and turn sensor power on.
> + */
> +static int ceu_runtime_resume(struct device *dev)
> +{
> +	struct ceu_device *ceudev = dev_get_drvdata(dev);
> +	struct v4l2_subdev *v4l2_sd = ceudev->sd->v4l2_sd;
> +
> +	v4l2_subdev_call(v4l2_sd, core, s_power, 1);
> +
> +	ceu_soft_reset(ceudev);
> +
> +	return 0;
> +}
> +
> +/**
> + * ----------------------------------------------------------------------------
> + *  File Operations
> + */
> +static int ceu_open(struct file *file)
> +{
> +	struct ceu_device *ceudev = video_drvdata(file);
> +	int ret;
> +
> +	ret = v4l2_fh_open(file);
> +	if (ret)
> +		return ret;
> +
> +	mutex_lock(&ceudev->mlock);
> +	/* Causes soft-reset and sensor power on on first open */
> +	pm_runtime_get_sync(ceudev->dev);
> +	mutex_unlock(&ceudev->mlock);
> +
> +	return 0;
> +}
> +
> +static int ceu_release(struct file *file)
> +{
> +	struct ceu_device *ceudev = video_drvdata(file);
> +
> +	vb2_fop_release(file);
> +
> +	mutex_lock(&ceudev->mlock);
> +	/* Causes soft-reset and sensor power down on last close */
> +	pm_runtime_put(ceudev->dev);
> +	mutex_unlock(&ceudev->mlock);
> +
> +	return 0;
> +}
> +
> +static const struct v4l2_file_operations ceu_fops = {
> +	.owner			= THIS_MODULE,
> +	.open			= ceu_open,
> +	.release		= ceu_release,
> +	.unlocked_ioctl		= video_ioctl2,
> +	.read			= vb2_fop_read,
> +	.mmap			= vb2_fop_mmap,
> +	.poll			= vb2_fop_poll,
> +};
> +
> +/**
> + * ----------------------------------------------------------------------------
> + *  Video Device IOCTLs
> + */
> +static int ceu_querycap(struct file *file, void *priv,
> +			struct v4l2_capability *cap)
> +{
> +	strlcpy(cap->card, "Renesas-CEU", sizeof(cap->card));
> +	strlcpy(cap->driver, DRIVER_NAME, sizeof(cap->driver));
> +	strlcpy(cap->bus_info, "platform:renesas-ceu", sizeof(cap->bus_info));
> +
> +	return 0;
> +}
> +
> +static int ceu_enum_fmt_vid_cap(struct file *file, void *priv,
> +				struct v4l2_fmtdesc *f)
> +{
> +	const struct ceu_fmt *fmt;
> +
> +	if (f->index >= ARRAY_SIZE(ceu_fmt_list) - 1)
> +		return -EINVAL;
> +
> +	fmt = &ceu_fmt_list[f->index];
> +	f->pixelformat = fmt->fourcc;
> +
> +	return 0;
> +}
> +
> +static int ceu_try_fmt_vid_cap(struct file *file, void *priv,
> +			       struct v4l2_format *f)
> +{
> +	struct ceu_device *ceudev = video_drvdata(file);
> +
> +	return ceu_try_fmt(ceudev, f);
> +}
> +
> +static int ceu_s_fmt_vid_cap(struct file *file, void *priv,
> +			     struct v4l2_format *f)
> +{
> +	struct ceu_device *ceudev = video_drvdata(file);
> +
> +	if (vb2_is_streaming(&ceudev->vb2_vq))
> +		return -EBUSY;
> +
> +	return ceu_set_fmt(ceudev, f);
> +}
> +
> +static int ceu_g_fmt_vid_cap(struct file *file, void *priv,
> +			     struct v4l2_format *f)
> +{
> +	struct ceu_device *ceudev = video_drvdata(file);
> +
> +	if (vb2_is_streaming(&ceudev->vb2_vq))
> +		return -EBUSY;

Drop this. You can always return the current format. Only *setting* the format
requires this check.

> +
> +	f->type	= V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
> +	f->fmt.pix_mp = ceudev->v4l2_pix;
> +
> +	return 0;
> +}
> +
> +static int ceu_enum_input(struct file *file, void *priv,
> +			  struct v4l2_input *inp)
> +{
> +	if (inp->index != 0)
> +		return -EINVAL;
> +
> +	inp->type = V4L2_INPUT_TYPE_CAMERA;
> +	inp->std = 0;
> +	strcpy(inp->name, "Camera");
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
> +
> +	ceudev->sd_index = i;
> +
> +	return 0;
> +}
> +
> +static int ceu_g_parm(struct file *file, void *fh, struct v4l2_streamparm *a)
> +{
> +	struct ceu_device *ceudev = video_drvdata(file);
> +
> +	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
> +		return -EINVAL;
> +
> +	return v4l2_subdev_call(ceudev->sd->v4l2_sd, video, g_parm, a);
> +}
> +
> +static int ceu_s_parm(struct file *file, void *fh, struct v4l2_streamparm *a)
> +{
> +	struct ceu_device *ceudev = video_drvdata(file);
> +
> +	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
> +		return -EINVAL;
> +
> +	return v4l2_subdev_call(ceudev->sd->v4l2_sd, video, s_parm, a);
> +}
> +
> +static int ceu_enum_framesizes(struct file *file, void *fh,
> +			       struct v4l2_frmsizeenum *fsize)
> +{
> +	struct ceu_device *ceudev = video_drvdata(file);
> +	struct ceu_subdev *ceu_sd = ceudev->sd;
> +	struct v4l2_subdev *v4l2_sd = ceu_sd->v4l2_sd;
> +	int ret;
> +
> +	struct v4l2_subdev_frame_size_enum fse = {
> +		.code	= ceu_sd->mbus_fmt.mbus_code,
> +		.index	= fsize->index,
> +		.which	= V4L2_SUBDEV_FORMAT_ACTIVE,
> +	};
> +
> +	ret = v4l2_subdev_call(v4l2_sd, pad, enum_frame_size,
> +			       NULL, &fse);
> +	if (ret)
> +		return ret;
> +
> +	fsize->type = V4L2_FRMSIZE_TYPE_DISCRETE;
> +	fsize->discrete.width = CEU_W_MAX(fse.max_width);
> +	fsize->discrete.height = CEU_H_MAX(fse.max_height);
> +
> +	return 0;
> +}
> +
> +static int ceu_enum_frameintervals(struct file *file, void *fh,
> +				   struct v4l2_frmivalenum *fival)
> +{
> +	struct ceu_device *ceudev = video_drvdata(file);
> +	struct ceu_subdev *ceu_sd = ceudev->sd;
> +	struct v4l2_subdev *v4l2_sd = ceu_sd->v4l2_sd;
> +	int ret;
> +
> +	struct v4l2_subdev_frame_interval_enum fie = {
> +		.code	= ceu_sd->mbus_fmt.mbus_code,
> +		.index = fival->index,
> +		.width = fival->width,
> +		.height = fival->height,
> +		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
> +	};
> +
> +	ret = v4l2_subdev_call(v4l2_sd, pad, enum_frame_interval, NULL,
> +			       &fie);
> +	if (ret)
> +		return ret;
> +
> +	fival->type = V4L2_FRMIVAL_TYPE_DISCRETE;
> +	fival->discrete = fie.interval;
> +
> +	return 0;
> +}
> +
> +static const struct v4l2_ioctl_ops ceu_ioctl_ops = {
> +	.vidioc_querycap		= ceu_querycap,
> +
> +	.vidioc_enum_fmt_vid_cap_mplane	= ceu_enum_fmt_vid_cap,
> +	.vidioc_try_fmt_vid_cap_mplane	= ceu_try_fmt_vid_cap,
> +	.vidioc_s_fmt_vid_cap_mplane	= ceu_s_fmt_vid_cap,
> +	.vidioc_g_fmt_vid_cap_mplane	= ceu_g_fmt_vid_cap,
> +
> +	.vidioc_enum_input		= ceu_enum_input,
> +	.vidioc_g_input			= ceu_g_input,
> +	.vidioc_s_input			= ceu_s_input,
> +
> +	.vidioc_reqbufs			= vb2_ioctl_reqbufs,
> +	.vidioc_querybuf		= vb2_ioctl_querybuf,
> +	.vidioc_qbuf			= vb2_ioctl_qbuf,
> +	.vidioc_expbuf			= vb2_ioctl_expbuf,
> +	.vidioc_dqbuf			= vb2_ioctl_dqbuf,
> +	.vidioc_create_bufs		= vb2_ioctl_create_bufs,
> +	.vidioc_prepare_buf		= vb2_ioctl_prepare_buf,
> +	.vidioc_streamon		= vb2_ioctl_streamon,
> +	.vidioc_streamoff		= vb2_ioctl_streamoff,
> +
> +	.vidioc_g_parm			= ceu_g_parm,
> +	.vidioc_s_parm			= ceu_s_parm,
> +	.vidioc_enum_framesizes		= ceu_enum_framesizes,
> +	.vidioc_enum_frameintervals	= ceu_enum_frameintervals,
> +};
> +
> +/**
> + * ceu_vdev_release() - release CEU video device memory when last reference
> + *			to this driver is closed
> + */
> +void ceu_vdev_release(struct video_device *vdev)
> +{
> +	struct ceu_device *ceudev = video_get_drvdata(vdev);
> +
> +	kfree(ceudev);
> +}
> +
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

Please add VB2_DMABUF.

> +	q->drv_priv		= ceudev;
> +	q->ops			= &ceu_videobuf_ops;
> +	q->mem_ops		= &vb2_dma_contig_memops;
> +	q->buf_struct_size	= sizeof(struct ceu_buffer);
> +	q->timestamp_flags	= V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> +	q->lock			= &ceudev->mlock;
> +	q->dev			= ceudev->v4l2_dev.dev;
> +
> +	ret = vb2_queue_init(q);
> +	if (ret)
> +		return ret;
> +
> +	/*
> +	 * Make sure at least one sensor is primary and use it to initialize
> +	 * ceu formats
> +	 */
> +	if (!ceudev->sd) {
> +		ceudev->sd = &ceudev->subdevs[0];
> +		ceudev->sd_index = 0;
> +	}
> +
> +	v4l2_sd = ceudev->sd->v4l2_sd;
> +
> +	ret = ceu_init_formats(ceudev);
> +	if (ret)
> +		return ret;
> +
> +	ret = ceu_set_default_fmt(ceudev);
> +	if (ret)
> +		return ret;
> +
> +	/* Register the video device */
> +	strncpy(vdev->name, DRIVER_NAME, strlen(DRIVER_NAME));
> +	vdev->v4l2_dev		= v4l2_dev;
> +	vdev->lock		= &ceudev->mlock;
> +	vdev->queue		= &ceudev->vb2_vq;
> +	vdev->ctrl_handler	= v4l2_sd->ctrl_handler;
> +	vdev->fops		= &ceu_fops;
> +	vdev->ioctl_ops		= &ceu_ioctl_ops;
> +	vdev->release		= ceu_vdev_release;
> +	vdev->device_caps	= V4L2_CAP_VIDEO_CAPTURE_MPLANE |

Why MPLANE? It doesn't appear to be needed since there are no multiplane
(really: multibuffer) pixelformats defined.

> +				  V4L2_CAP_STREAMING;
> +	video_set_drvdata(vdev, ceudev);
> +
> +	ret = video_register_device(vdev, VFL_TYPE_GRABBER, -1);
> +	if (ret < 0) {
> +		v4l2_err(vdev->v4l2_dev,
> +			 "video_register_device failed: %d\n", ret);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +/**
> + * ceu_parse_init_sd() - Initialize CEU subdevices and async_subdevs in
> + *			 ceu device. Both DT and platform data parsing use
> + *			 this routine.
> + *
> + * @return 0 for success, -ENOMEM for failure.
> + */
> +static int ceu_parse_init_sd(struct ceu_device *ceudev, unsigned int n_sd)
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
> +/**
> + * ceu_parse_platform_data() - Initialize async_subdevices using platform
> + *			       device provided data.
> + */
> +static int ceu_parse_platform_data(struct ceu_device *ceudev, void *pdata)
> +{
> +	struct ceu_async_subdev *async_sd;
> +	struct ceu_info *info = pdata;
> +	struct ceu_subdev *ceu_sd;
> +	unsigned int i;
> +	int ret;
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
> +/**
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
> +	if (num_ep <= 0)
> +		return 0;
> +
> +	ret = ceu_parse_init_sd(ceudev, num_ep);
> +	if (ret)
> +		return ret;
> +
> +	for (i = 0; i < num_ep; i++) {
> +		ep = of_graph_get_endpoint_by_regs(of, 0, i);
> +		if (!ep) {
> +			v4l2_err(&ceudev->v4l2_dev,
> +				 "No subdevice connected on port %u.\n", i);
> +			ret = -ENODEV;
> +			goto error_put_node;
> +		}
> +
> +		ret = v4l2_fwnode_endpoint_parse(of_fwnode_handle(ep), &fw_ep);
> +		if (ret) {
> +			v4l2_err(&ceudev->v4l2_dev,
> +				 "Unable to parse endpoint #%u.\n", i);
> +			goto error_put_node;
> +		}
> +
> +		if (fw_ep.bus_type != V4L2_MBUS_PARALLEL) {
> +			v4l2_err(&ceudev->v4l2_dev,
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
> +	if (!ceudev)
> +		return -ENOMEM;
> +
> +	platform_set_drvdata(pdev, ceudev);
> +	dev_set_drvdata(dev, ceudev);
> +	ceudev->dev = dev;
> +
> +	INIT_LIST_HEAD(&ceudev->capture);
> +	spin_lock_init(&ceudev->lock);
> +	mutex_init(&ceudev->mlock);
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (IS_ERR(res))
> +		return PTR_ERR(res);
> +
> +	base = devm_ioremap_resource(dev, res);
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
> +
> +	ceudev->notifier.v4l2_dev	= &ceudev->v4l2_dev;
> +	ceudev->notifier.subdevs	= ceudev->asds;
> +	ceudev->notifier.num_subdevs	= num_sd;
> +	ceudev->notifier.bound		= ceu_sensor_bound;
> +	ceudev->notifier.complete	= ceu_sensor_complete;
> +	ret = v4l2_async_notifier_register(&ceudev->v4l2_dev,
> +					   &ceudev->notifier);
> +	if (ret)
> +		goto error_v4l2_unregister_notifier;
> +
> +	dev_info(dev, "Renesas Capture Engine Unit\n");
> +
> +	return 0;
> +
> +error_v4l2_unregister_notifier:
> +	v4l2_async_notifier_unregister(&ceudev->notifier);
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
> +
> +#if IS_ENABLED(CONFIG_OF)
> +static const struct of_device_id ceu_of_match[] = {
> +	{ .compatible = "renesas,renesas-ceu" },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(of, ceu_of_match);
> +#endif
> +
> +static const struct dev_pm_ops ceu_pm_ops = {
> +	SET_RUNTIME_PM_OPS(ceu_runtime_suspend,
> +			   ceu_runtime_resume,
> +			   NULL)
> +};
> +
> +static struct platform_driver ceu_driver = {
> +	.driver		= {
> +		.name	= DRIVER_NAME,
> +		.pm	= &ceu_pm_ops,
> +		.of_match_table = of_match_ptr(ceu_of_match),
> +	},
> +	.probe		= ceu_probe,
> +	.remove		= ceu_remove,
> +};
> +
> +module_platform_driver(ceu_driver);
> +
> +MODULE_DESCRIPTION("Renesas CEU camera driver");
> +MODULE_AUTHOR("Jacopo Mondi <jacopo+renesas@jmondi.org>");
> +MODULE_LICENSE("GPL");
> --
> 2.7.4
> 

Regards,

	Hans
