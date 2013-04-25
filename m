Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:54826 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757104Ab3DYOUw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Apr 2013 10:20:52 -0400
Date: Thu, 25 Apr 2013 16:20:46 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
cc: mchehab@redhat.com,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
	phil.edworthy@renesas.com, matsu@igel.co.jp,
	vladimir.barinov@cogentembedded.com
Subject: Re: [PATCH v2 1/4] V4L2: soc_camera: Renesas R-Car VIN driver
In-Reply-To: <201304200231.31802.sergei.shtylyov@cogentembedded.com>
Message-ID: <Pine.LNX.4.64.1304201201370.10520@axis700.grange>
References: <201304200231.31802.sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sergei

Thanks for the patch.

On Sat, 20 Apr 2013, Sergei Shtylyov wrote:

> From: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
> 
> Add Renesas R-Car VIN (Video In) V4L2 driver.
> 
> Based on the patch by Phil Edworthy <phil.edworthy@renesas.com>.
> 
> Signed-off-by: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
> [Sergei: removed deprecated IRQF_DISABLED flag.]
> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
> 
> ---
> Changes since the original posting:
> - added IRQF_SHARED flag in devm_request_irq() call (since on R8A7778 VIN0/1
>   share the same IRQ) and removed deprecated IRQF_DISABLED flag.
> 
>  drivers/media/platform/soc_camera/Kconfig    |    7 
>  drivers/media/platform/soc_camera/Makefile   |    1 
>  drivers/media/platform/soc_camera/rcar_vin.c | 1784 +++++++++++++++++++++++++++
>  include/linux/platform_data/camera-rcar.h    |   25 
>  4 files changed, 1817 insertions(+)
> 
> Index: renesas/drivers/media/platform/soc_camera/Kconfig
> ===================================================================
> --- renesas.orig/drivers/media/platform/soc_camera/Kconfig
> +++ renesas/drivers/media/platform/soc_camera/Kconfig
> @@ -45,6 +45,13 @@ config VIDEO_PXA27x
>  	---help---
>  	  This is a v4l2 driver for the PXA27x Quick Capture Interface
>  
> +config VIDEO_RCAR_VIN
> +	tristate "R-Car Video Input (VIN) support"
> +	depends on VIDEO_DEV && SOC_CAMERA && (ARCH_R8A7778 || ARCH_R8A7779)
> +	select VIDEOBUF2_DMA_CONTIG
> +	---help---
> +	  This is a v4l2 driver for the R-Car VIN Interface
> +
>  config VIDEO_SH_MOBILE_CSI2
>  	tristate "SuperH Mobile MIPI CSI-2 Interface driver"
>  	depends on VIDEO_DEV && SOC_CAMERA && HAVE_CLK
> Index: renesas/drivers/media/platform/soc_camera/Makefile
> ===================================================================
> --- renesas.orig/drivers/media/platform/soc_camera/Makefile
> +++ renesas/drivers/media/platform/soc_camera/Makefile
> @@ -10,5 +10,6 @@ obj-$(CONFIG_VIDEO_OMAP1)		+= omap1_came
>  obj-$(CONFIG_VIDEO_PXA27x)		+= pxa_camera.o
>  obj-$(CONFIG_VIDEO_SH_MOBILE_CEU)	+= sh_mobile_ceu_camera.o
>  obj-$(CONFIG_VIDEO_SH_MOBILE_CSI2)	+= sh_mobile_csi2.o
> +obj-$(CONFIG_VIDEO_RCAR_VIN)		+= rcar_vin.o
>  
>  ccflags-y += -I$(srctree)/drivers/media/i2c/soc_camera
> Index: renesas/drivers/media/platform/soc_camera/rcar_vin.c
> ===================================================================
> --- /dev/null
> +++ renesas/drivers/media/platform/soc_camera/rcar_vin.c
> @@ -0,0 +1,1784 @@
> +/*
> + * SoC-camera host driver for Renesas R-Car VIN unit
> + *
> + * Copyright (C) 2011-2013 Renesas Solutions Corp.
> + * Copyright (C) 2013 Cogent Embedded, Inc., <source@cogentembedded.com>
> + *
> + * Based on V4L2 Driver for SuperH Mobile CEU interface "sh_mobile_ceu_camera.c"
> + *
> + * Copyright (C) 2008 Magnus Damm
> + *
> + * This program is free software; you can redistribute  it and/or modify it
> + * under  the terms of  the GNU General  Public License as published by the
> + * Free Software Foundation;  either version 2 of the  License, or (at your
> + * option) any later version.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/interrupt.h>
> +#include <linux/slab.h>
> +#include <linux/delay.h>
> +#include <linux/platform_device.h>
> +#include <linux/pm_runtime.h>
> +#include <linux/platform_data/camera-rcar.h>
> +
> +#include <media/videobuf2-dma-contig.h>
> +#include <media/soc_camera.h>
> +#include <media/soc_mediabus.h>

I always suggest to sort headers alphabetically, then it is easier to 
avoid duplicates and adding new ones goes to "random" places in the list, 
instead of piling up at the bottom, reducing the chance of a merge 
conflict.

I also strongly suspent some #include <media/v4l2-*.h> headers are missing 
above.

> +
> +#define DRV_NAME "rcar_vin"
> +
> +/* Register offsets for R-Сar VIN */
> +#define VNMC_REG	0x00	/* Video n Main Control Register */
> +#define VNMS_REG	0x04	/* Video n Module Status Register */
> +#define VNFC_REG	0x08	/* Video n Frame Capture Register */
> +#define VNSLPRC_REG	0x0C	/* Video n Start Line Pre-Clip Register */
> +#define VNELPRC_REG	0x10	/* Video n End Line Pre-Clip Register */
> +#define VNSPPRC_REG	0x14	/* Video n Start Pixel Pre-Clip Register */
> +#define VNEPPRC_REG	0x18	/* Video n End Pixel Pre-Clip Register */
> +#define VNSLPOC_REG	0x1C	/* Video n Start Line Post-Clip Register */
> +#define VNELPOC_REG	0x20	/* Video n End Line Post-Clip Register */
> +#define VNSPPOC_REG	0x24	/* Video n Start Pixel Post-Clip Register */
> +#define VNEPPOC_REG	0x28	/* Video n End Pixel Post-Clip Register */
> +#define VNIS_REG	0x2C	/* Video n Image Stride Register */
> +#define VNMB_REG(m)	(0x30 + ((m) << 2)) /* Video n Memory Base m Register */
> +#define VNIE_REG	0x40	/* Video n Interrupt Enable Register */
> +#define VNINTS_REG	0x44	/* Video n Interrupt Status Register */
> +#define VNSI_REG	0x48	/* Video n Scanline Interrupt Register */
> +#define VNMTC_REG	0x4C	/* Video n Memory Transfer Control Register */
> +#define VNYS_REG	0x50	/* Video n Y Scale Register */
> +#define VNXS_REG	0x54	/* Video n X Scale Register */
> +#define VNDMR_REG	0x58	/* Video n Data Mode Register */
> +#define VNDMR2_REG	0x5C	/* Video n Data Mode Register 2 */
> +#define VNUVAOF_REG	0x60	/* Video n UV Address Offset Register */
> +
> +/* Register bit fields for R-Сar VIN */
> +/* Video n Main Control Register bits */
> +#define VNMC_FOC		(1 << 21)
> +#define VNMC_YCAL		(1 << 19)
> +#define VNMC_INF_YUV8_BT656	(0 << 16)
> +#define VNMC_INF_YUV8_BT601	(1 << 16)
> +#define VNMC_INF_YUV16		(5 << 16)
> +#define VNMC_VUP		(1 << 10)
> +#define VNMC_IM_ODD		(0 << 3)
> +#define VNMC_IM_ODD_EVEN	(1 << 3)
> +#define VNMC_IM_EVEN		(2 << 3)
> +#define VNMC_IM_FULL		(3 << 3)
> +#define VNMC_BPS		(1 << 1)
> +#define VNMC_ME			(1 << 0)
> +
> +/* Video n Module Status Register bits */
> +#define VNMS_FBS_MASK		(3 << 3)
> +#define VNMS_FBS_SHIFT		3
> +#define VNMS_AV			(1 << 1)
> +#define VNMS_CA			(1 << 0)
> +
> +/* Video n Frame Capture Register bits */
> +#define VNFC_C_FRAME		(1 << 1)
> +#define VNFC_S_FRAME		(1 << 0)
> +
> +/* Video n Interrupt Enable Register bits */
> +#define VNIE_FIE		(1 << 4)
> +#define VNIE_EFE		(1 << 1)
> +
> +/* Video n Data Mode Register bits */
> +#define VNDMR_EXRGB		(1 << 8)
> +#define VNDMR_BPSM		(1 << 4)
> +#define VNDMR_DTMD_YCSEP	(1 << 1)
> +#define VNDMR_DTMD_ARGB1555	(1 << 0)
> +
> +/* Video n Data Mode Register 2 bits */
> +#define VNDMR2_VPS		(1 << 30)
> +#define VNDMR2_HPS		(1 << 29)
> +#define VNDMR2_FTEV		(1 << 17)
> +
> +#define VIN_MAX_WIDTH		2048
> +#define VIN_MAX_HEIGHT		2048
> +
> +enum rcar_vin_state {
> +	STOPPED = 0,
> +	RUNNING,
> +	STOPPING,
> +};
> +
> +struct rcar_vin_priv {
> +	void __iomem			*base;
> +	spinlock_t			lock;
> +	int				sequence;
> +	/* State of the VIN module in capturing mode */
> +	enum rcar_vin_state		state;
> +	struct rcar_vin_platform_data	*pdata;
> +	struct soc_camera_host		ici;
> +	struct soc_camera_device	*icd;
> +	struct list_head		capture;
> +#define MAX_BUFFER_NUM			3
> +	struct vb2_buffer		*queue_buf[MAX_BUFFER_NUM];
> +	struct vb2_alloc_ctx		*alloc_ctx;
> +	enum v4l2_field			field;
> +	bool				data_through;
> +	unsigned int			vb_count;
> +	unsigned int			nr_hw_slots;
> +	bool				request_to_stop;
> +	struct completion		capture_stop;
> +};
> +
> +#define is_continuous_transfer(priv)	(priv->vb_count > MAX_BUFFER_NUM ? \
> +					 true : false)

simpler:

+#define is_continuous_transfer(priv)	(priv->vb_count > MAX_BUFFER_NUM)

> +
> +struct rcar_vin_buffer {
> +	struct vb2_buffer		vb;
> +	struct list_head		list;
> +};
> +
> +#define to_buf_list(vb2_buffer)		(&(container_of((vb2_buffer), \
> +						struct rcar_vin_buffer, \
> +						vb))->list)

parenthesis around container_of() above don't make much sense. You can 
just drop them:

+#define to_buf_list(vb2_buffer)		(&container_of((vb2_buffer), \
+						struct rcar_vin_buffer, \
+						vb)->list)

> +
> +struct rcar_vin_cam {
> +	/* VIN offsets within the camera output, before the VIN scaler */
> +	unsigned int			vin_left;
> +	unsigned int			vin_top;
> +	/* Client output, as seen by the VIN */
> +	unsigned int			width;
> +	unsigned int			height;
> +	/*
> +	 * User window from S_CROP / G_CROP, produced by client cropping and
> +	 * scaling, VIN scaling and VIN cropping, mapped back onto the client
> +	 * input window
> +	 */
> +	struct v4l2_rect		subrect;
> +	/* Camera cropping rectangle */
> +	struct v4l2_rect		rect;
> +	const struct soc_mbus_pixelfmt	*extra_fmt;
> +	enum v4l2_mbus_pixelcode	code;

You don't use the "code" field.

> +};
> +
> +/*
> + * .queue_setup() is called to check whether the driver can accept the
> + *		  requested number of buffers and to fill in plane sizes
> + *		  for the current frame format if required
> + */
> +static int rcar_vin_videobuf_setup(struct vb2_queue *vq,
> +				   const struct v4l2_format *fmt,
> +				   unsigned int *count,
> +				   unsigned int *num_planes,
> +				   unsigned int sizes[], void *alloc_ctxs[])
> +{
> +	struct soc_camera_device *icd = soc_camera_from_vb2q(vq);
> +	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
> +	struct rcar_vin_priv *priv = ici->priv;
> +	s32 bytes_per_line;
> +	unsigned int height;
> +
> +	if (fmt) {
> +		const struct soc_camera_format_xlate *xlate;
> +
> +		xlate = soc_camera_xlate_by_fourcc(icd,
> +						   fmt->fmt.pix.pixelformat);
> +		if (!xlate)
> +			return -EINVAL;
> +		bytes_per_line = soc_mbus_bytes_per_line(fmt->fmt.pix.width,
> +							 xlate->host_fmt);
> +		height = fmt->fmt.pix.height;
> +	} else {
> +		/* Called from VIDIOC_REQBUFS or in compatibility mode */
> +		bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
> +						icd->current_fmt->host_fmt);
> +		height = icd->user_height;

In this case icd->sizeimage already contains the correct value.

> +	}
> +	if (bytes_per_line < 0)
> +		return bytes_per_line;
> +
> +	sizes[0] = bytes_per_line * height;

This isn't right for planar formats, like NV16. Please, use 
soc_mbus_image_size(). See the CEU driver for an example.

> +	alloc_ctxs[0] = priv->alloc_ctx;
> +
> +	if (!vq->num_buffers)
> +		priv->sequence = 0;
> +
> +	if (!*count)
> +		*count = 2;
> +	priv->vb_count = *count;
> +
> +	*num_planes = 1;
> +
> +	/* Number of hardware slots */
> +	if (priv->vb_count > MAX_BUFFER_NUM)
> +		priv->nr_hw_slots = MAX_BUFFER_NUM;
> +	else
> +		priv->nr_hw_slots = 1;

Is this really correct: with up to 3 buffers only one HW slot is used?

> +
> +	dev_dbg(icd->parent, "count=%d, size=%u\n", *count, sizes[0]);
> +
> +	return 0;
> +}
> +
> +static void rcar_vin_setup(struct rcar_vin_priv *priv)
> +{
> +	struct soc_camera_device *icd = priv->icd;
> +	struct rcar_vin_cam *cam = icd->host_priv;
> +	u32 vnmc, dmr, interrupts;
> +	int progressive = 0, input_is_yuv = 0, output_is_yuv = 0;

All these variables can be bool.

> +
> +	switch (priv->field) {
> +	case V4L2_FIELD_TOP:
> +		vnmc = VNMC_IM_ODD;
> +		break;
> +	case V4L2_FIELD_BOTTOM:
> +		vnmc = VNMC_IM_EVEN;
> +		break;
> +	case V4L2_FIELD_INTERLACED:
> +	case V4L2_FIELD_INTERLACED_TB:
> +		vnmc = VNMC_IM_FULL;
> +		break;
> +	case V4L2_FIELD_INTERLACED_BT:
> +		vnmc = VNMC_IM_FULL | VNMC_FOC;
> +		break;
> +	case V4L2_FIELD_NONE:
> +		if (is_continuous_transfer(priv)) {
> +			vnmc = VNMC_IM_ODD_EVEN;
> +			progressive = 1;
> +		} else
> +			vnmc = VNMC_IM_ODD;

Doesn't checkpatch.pl produce a warning / error for missing braces above? 
If it doesn't I won't either :-)

> +		break;
> +	default:
> +		vnmc = VNMC_IM_ODD;
> +		break;
> +	}
> +
> +	/* input interface */
> +	switch (icd->current_fmt->code) {
> +	case V4L2_MBUS_FMT_YUYV8_1X16:
> +		/* BT.601/BT.1358 16bit YCbCr422 */
> +		vnmc |= VNMC_INF_YUV16;
> +		input_is_yuv = 1;
> +		break;
> +	case V4L2_MBUS_FMT_YUYV8_2X8:
> +		input_is_yuv = 1;
> +		/* BT.656 8bit YCbCr422 or BT.601 8bit YCbCr422 */
> +		vnmc |= priv->pdata->flags & RCAR_VIN_BT656 ?
> +			VNMC_INF_YUV8_BT656 : VNMC_INF_YUV8_BT601;

Let's clarify this. By BT.656 you mean embedded synchronisation patterns, 
right? In that case HSYNC and VSYNC signals aren't used. But in your 
.set_bus_param() method you only support V4L2_MBUS_PARALLEL and not 
V4L2_MBUS_BT656. And what do you call BT601? A bus with sync signals used?

> +	default:
> +		break;
> +	}
> +
> +	/* output format */
> +	switch (icd->current_fmt->host_fmt->fourcc) {
> +	case V4L2_PIX_FMT_NV16:
> +		iowrite32(((cam->width * cam->height) + 0x7f) & ~0x7f,
> +			  priv->base + VNUVAOF_REG);

Superfluous parenthesis around multiplication.

> +		dmr = VNDMR_DTMD_YCSEP;
> +		output_is_yuv = 1;
> +		break;
> +	case V4L2_PIX_FMT_YUYV:
> +		dmr = VNDMR_BPSM;
> +		output_is_yuv = 1;
> +		break;
> +	case V4L2_PIX_FMT_UYVY:
> +		dmr = 0;
> +		output_is_yuv = 1;
> +		break;
> +	case V4L2_PIX_FMT_RGB555X:
> +		dmr = VNDMR_DTMD_ARGB1555;
> +		break;
> +	case V4L2_PIX_FMT_RGB565:
> +		dmr = 0;
> +		break;
> +	case V4L2_PIX_FMT_RGB32:
> +		dmr = VNDMR_EXRGB;
> +		break;
> +	default:
> +		dev_warn(icd->parent, "Invalid fourcc format (0x%x)\n",
> +			 icd->current_fmt->host_fmt->fourcc);
> +		dmr = ioread32(priv->base + VNDMR_REG);
> +		vnmc = ioread32(priv->base + VNMC_REG);

Strange, you cannot actually get here - the driver doesn't support 
pass-through, still, you issue a warning but attempt to continue?

> +		break;
> +	}
> +
> +	/* Always update on field change */
> +	vnmc |= VNMC_VUP;
> +
> +	/* If input and output use the same colorspace, use bypass mode */
> +	if (input_is_yuv == output_is_yuv)
> +		vnmc |= VNMC_BPS;
> +
> +	/* progressive or interlaced mode */
> +	interrupts = progressive ? VNIE_FIE | VNIE_EFE : VNIE_EFE;
> +
> +	/* ack interrupts */
> +	iowrite32(interrupts, priv->base + VNINTS_REG);
> +	/* enable interrupts */
> +	iowrite32(interrupts, priv->base + VNIE_REG);
> +	/* start capturing */
> +	iowrite32(dmr, priv->base + VNDMR_REG);
> +	iowrite32(vnmc | VNMC_ME, priv->base + VNMC_REG);
> +}
> +
> +static void rcar_vin_capture(struct rcar_vin_priv *priv)
> +{
> +	if (is_continuous_transfer(priv))
> +		/* Continuous Frame Capture Mode */
> +		iowrite32(VNFC_C_FRAME, priv->base + VNFC_REG);
> +	else
> +		/* Single Frame Capture Mode */
> +		iowrite32(VNFC_S_FRAME, priv->base + VNFC_REG);
> +}
> +
> +static void rcar_vin_request_capture_stop(struct rcar_vin_priv *priv)
> +{
> +	priv->state = STOPPING;
> +
> +	/* set continuous & single transfer off */
> +	iowrite32(0, priv->base + VNFC_REG);
> +	/* disable capture (release DMA buffer), reset */
> +	iowrite32(ioread32(priv->base + VNMC_REG) & ~VNMC_ME,
> +		  priv->base + VNMC_REG);
> +
> +	/* update the status if stopped already */
> +	if (!(ioread32(priv->base + VNMS_REG) & VNMS_CA))
> +		priv->state = STOPPED;
> +}
> +
> +static int rcar_vin_get_free_hw_slot(struct rcar_vin_priv *priv)
> +{
> +	int slot;
> +
> +	for (slot = 0; slot < priv->nr_hw_slots; slot++)
> +		if (priv->queue_buf[slot] == NULL)
> +			return slot;
> +
> +	return -1;
> +}
> +
> +static int rcar_vin_hw_ready(struct rcar_vin_priv *priv)
> +{
> +	/* Ensure all HW slots are filled */
> +	return rcar_vin_get_free_hw_slot(priv) < 0 ? 1 : 0;
> +}
> +
> +/* Moves a buffer from the queue to the HW slots */
> +static int rcar_vin_fill_hw_slot(struct rcar_vin_priv *priv)
> +{
> +	struct vb2_buffer *vb;
> +	dma_addr_t phys_addr_top;
> +	int slot;
> +
> +	if (list_empty(&priv->capture))
> +		return 0;
> +
> +	/* Find a free HW slot */
> +	slot = rcar_vin_get_free_hw_slot(priv);
> +	if (slot < 0)
> +		return 0;
> +
> +	vb = &list_entry(priv->capture.next, struct rcar_vin_buffer, list)->vb;
> +	list_del_init(to_buf_list(vb));
> +	priv->queue_buf[slot] = vb;
> +	phys_addr_top = vb2_dma_contig_plane_dma_addr(vb, 0);
> +	iowrite32(phys_addr_top, priv->base + VNMB_REG(slot));
> +
> +	return 1;
> +}
> +
> +static void rcar_vin_videobuf_queue(struct vb2_buffer *vb)
> +{
> +	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2_queue);
> +	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
> +	struct rcar_vin_priv *priv = ici->priv;
> +	unsigned long size;
> +	unsigned long flags;
> +	int bytes_per_line;
> +
> +	bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
> +						 icd->current_fmt->host_fmt);
> +	if (bytes_per_line < 0)
> +		goto error;
> +
> +	size = icd->user_height * bytes_per_line;

Again - this multiplication isn't good enough.

> +
> +	if (vb2_plane_size(vb, 0) < size) {
> +		dev_err(icd->parent, "Buffer #%d too small (%lu < %lu)\n",
> +			vb->v4l2_buf.index, vb2_plane_size(vb, 0), size);
> +		goto error;
> +	}
> +
> +	vb2_set_plane_payload(vb, 0, size);
> +
> +	dev_dbg(icd->parent, "%s (vb=0x%p) 0x%p %lu\n", __func__,
> +		vb, vb2_plane_vaddr(vb, 0), vb2_get_plane_payload(vb, 0));
> +
> +	spin_lock_irqsave(&priv->lock, flags);

Saving IRQ flags doesn't hurt, but I don't think this function can be 
called with interrupts disabled.

> +
> +	list_add_tail(to_buf_list(vb), &priv->capture);
> +	rcar_vin_fill_hw_slot(priv);
> +
> +	/* If we weren't running, and have enough buffers, start capturing! */
> +	if (priv->state != RUNNING && rcar_vin_hw_ready(priv)) {
> +		priv->request_to_stop = false;
> +		init_completion(&priv->capture_stop);
> +		priv->state = RUNNING;
> +		rcar_vin_setup(priv);
> +		rcar_vin_capture(priv);
> +	}
> +
> +	spin_unlock_irqrestore(&priv->lock, flags);
> +
> +	return;
> +
> +error:
> +	vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);
> +}
> +
> +static void rcar_vin_videobuf_release(struct vb2_buffer *vb)
> +{
> +	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2_queue);
> +	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
> +	struct rcar_vin_priv *priv = ici->priv;
> +	unsigned int i;
> +	unsigned long flags;
> +	int buf_in_use = 0;
> +
> +	spin_lock_irqsave(&priv->lock, flags);

Ditto

> +
> +	/* Is the buffer in use by the VIN hardware? */
> +	for (i = 0; i < MAX_BUFFER_NUM; i++) {
> +		if (priv->queue_buf[i] == vb) {
> +			buf_in_use = 1;
> +			break;
> +		}
> +	}
> +
> +	if (buf_in_use) {
> +		while (priv->state != STOPPED) {
> +
> +			/* issue stop if running */
> +			if (priv->state == RUNNING)
> +				rcar_vin_request_capture_stop(priv);
> +
> +			/* wait until capturing has been stopped */
> +			if (priv->state == STOPPING) {
> +				priv->request_to_stop = true;
> +				spin_unlock_irqrestore(&priv->lock, flags);
> +				wait_for_completion(&priv->capture_stop);
> +				spin_lock_irqsave(&priv->lock, flags);
> +			}
> +		}
> +		/*
> +		 * Capturing has now stopped. The buffer we have been asked
> +		 * to release could be any of the current buffers in use, so
> +		 * release all buffers that are in use by HW
> +		 */
> +		for (i = 0; i < MAX_BUFFER_NUM; i++) {
> +			if (priv->queue_buf[i]) {
> +				vb2_buffer_done(priv->queue_buf[i],
> +					VB2_BUF_STATE_ERROR);
> +				priv->queue_buf[i] = NULL;
> +			}
> +		}
> +	} else if (to_buf_list(vb)->next)

Don't think ->next can ever be NULL - you initialise the list head in your 
.buf_init().

> +		list_del_init(to_buf_list(vb));
> +
> +	spin_unlock_irqrestore(&priv->lock, flags);
> +}
> +
> +static int rcar_vin_videobuf_init(struct vb2_buffer *vb)
> +{
> +	INIT_LIST_HEAD(to_buf_list(vb));
> +	return 0;
> +}
> +
> +static int rcar_vin_stop_streaming(struct vb2_queue *vq)
> +{
> +	struct soc_camera_device *icd = soc_camera_from_vb2q(vq);
> +	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
> +	struct rcar_vin_priv *priv = ici->priv;
> +	struct list_head *buf_head, *tmp;
> +
> +	spin_lock_irq(&priv->lock);
> +	list_for_each_safe(buf_head, tmp, &priv->capture)
> +		list_del_init(buf_head);
> +	spin_unlock_irq(&priv->lock);
> +
> +	return 0;
> +}
> +
> +static struct vb2_ops rcar_vin_vb2_ops = {
> +	.queue_setup	= rcar_vin_videobuf_setup,
> +	.buf_init	= rcar_vin_videobuf_init,
> +	.buf_cleanup	= rcar_vin_videobuf_release,
> +	.buf_queue	= rcar_vin_videobuf_queue,
> +	.stop_streaming	= rcar_vin_stop_streaming,
> +	.wait_prepare	= soc_camera_unlock,
> +	.wait_finish	= soc_camera_lock,
> +};
> +
> +static irqreturn_t rcar_vin_irq(int irq, void *data)
> +{
> +	struct rcar_vin_priv *priv = data;
> +	u32 int_status;
> +	bool can_run = false, hw_stopped;
> +	int slot;
> +	unsigned int handled = 0;
> +
> +	spin_lock(&priv->lock);
> +
> +	int_status = ioread32(priv->base + VNINTS_REG);
> +	if (!int_status)
> +		goto done;
> +	/* ack interrupts */
> +	iowrite32(int_status, priv->base + VNINTS_REG);
> +	handled = 1;
> +
> +	/* nothing to do if capture status is 'STOPPED' */
> +	if (priv->state == STOPPED)
> +		goto done;
> +
> +	hw_stopped = !(ioread32(priv->base + VNMS_REG) & VNMS_CA);
> +
> +	if (!priv->request_to_stop) {
> +		if (is_continuous_transfer(priv))
> +			slot = (ioread32(priv->base + VNMS_REG) &
> +				VNMS_FBS_MASK) >> VNMS_FBS_SHIFT;
> +		else
> +			slot = 0;
> +
> +		priv->queue_buf[slot]->v4l2_buf.field = priv->field;
> +		priv->queue_buf[slot]->v4l2_buf.sequence = priv->sequence++;
> +		do_gettimeofday(&priv->queue_buf[slot]->v4l2_buf.timestamp);
> +		vb2_buffer_done(priv->queue_buf[slot], VB2_BUF_STATE_DONE);
> +		priv->queue_buf[slot] = NULL;
> +
> +		if (priv->state != STOPPING)
> +			can_run = rcar_vin_fill_hw_slot(priv);
> +
> +		if (hw_stopped || !can_run)
> +			priv->state = STOPPED;
> +		else
> +			rcar_vin_capture(priv);
> +
> +	} else if (hw_stopped) {
> +		priv->state = STOPPED;
> +		priv->request_to_stop = false;
> +		complete(&priv->capture_stop);
> +	}
> +
> +done:
> +	spin_unlock(&priv->lock);
> +
> +	return IRQ_RETVAL(handled);
> +}
> +
> +static int rcar_vin_add_device(struct soc_camera_device *icd)
> +{
> +	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
> +	struct rcar_vin_priv *priv = ici->priv;
> +	int i;
> +
> +	if (priv->icd)
> +		return -EBUSY;
> +
> +	for (i = 0; i < MAX_BUFFER_NUM; i++)
> +		priv->queue_buf[i] = NULL;
> +
> +	pm_runtime_get_sync(ici->v4l2_dev.dev);
> +	priv->icd = icd;
> +
> +	dev_dbg(icd->parent, "R-Car VIN driver attached to camera %d\n",
> +		icd->devnum);
> +
> +	return 0;
> +}
> +
> +static void rcar_vin_remove_device(struct soc_camera_device *icd)
> +{
> +	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
> +	struct rcar_vin_priv *priv = ici->priv;
> +	struct vb2_buffer *vb;
> +	int i;
> +
> +	BUG_ON(icd != priv->icd);

We're trying to avoid any unjustified use of BUG*() macros. Please, just 
print a warning and return here.

> +
> +	/* disable capture, disable interrupts */
> +	iowrite32(ioread32(priv->base + VNMC_REG) & ~VNMC_ME,
> +		  priv->base + VNMC_REG);
> +	iowrite32(0, priv->base + VNIE_REG);
> +
> +	priv->state = STOPPED;
> +	priv->request_to_stop = false;
> +
> +	/* make sure active buffer is cancelled */
> +	spin_lock_irq(&priv->lock);
> +	for (i = 0; i < MAX_BUFFER_NUM; i++) {
> +		vb = priv->queue_buf[i];
> +		if (vb) {
> +			list_del_init(to_buf_list(vb));
> +			vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);

Wondering, whether it's safe to call vb2_buffer_done() with interrupts 
disabled. It calls the queue .finish() method, with a comment "sync 
buffers," which to me indicates, that that might sleep. Yes, other drivers 
do that too, so, we can keep it until it explodes...

> +			vb = NULL;

The last line is redundant.

> +		}
> +	}
> +	spin_unlock_irq(&priv->lock);
> +
> +	pm_runtime_put_sync(ici->v4l2_dev.dev);

Do you really need the _sync version above?

> +	priv->icd = NULL;
> +
> +	dev_dbg(icd->parent, "R-Car VIN driver detached from camera %d\n",
> +		icd->devnum);
> +}
> +
> +static unsigned int size_dst(unsigned int src, unsigned int scale)
> +{
> +	unsigned int mant_pre = scale >> 12;
> +
> +	if (!src || !scale)
> +		return src;
> +	return ((mant_pre + 2 * (src - 1)) / (2 * mant_pre) - 1) *
> +		(mant_pre << 12) / scale + 1;
> +}
> +
> +static u16 calc_scale(unsigned int src, unsigned int *dst)
> +{
> +	u16 scale;
> +
> +	if (src == *dst)
> +		return 0;
> +
> +	scale = (src * 4096 / *dst) & ~7;
> +
> +	while (scale > 4096 && size_dst(src, scale) < *dst)
> +		scale -= 8;
> +
> +	*dst = size_dst(src, scale);
> +
> +	return scale;

return value of this function is unused by the caller. Generally, your use 
of these two functions is different than on CEU, you might want to get rid 
of them completely.

> +}
> +
> +/* rect is guaranteed to not exceed the scaled camera rectangle */
> +static int rcar_vin_set_rect(struct soc_camera_device *icd)
> +{
> +	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
> +	struct rcar_vin_cam *cam = icd->host_priv;
> +	struct rcar_vin_priv *priv = ici->priv;
> +	unsigned int left_offset, top_offset;
> +	unsigned char dsize;
> +	struct v4l2_rect *cam_subrect = &cam->subrect;
> +
> +	dev_dbg(icd->parent, "Crop %ux%u@%u:%u\n",
> +		icd->user_width, icd->user_height, cam->vin_left, cam->vin_top);
> +
> +	left_offset = cam->vin_left;
> +	top_offset = cam->vin_top;
> +
> +	dsize = priv->data_through ? true : false;

dsize is used below as a shift, so, it cannot be boolean (besides it is 
declared "unsigned char" above). data_through is set only for RGB32. Do 
you really need the field, cannot you just check for that single format?

> +
> +	dev_dbg(icd->parent, "Cam %ux%u@%u:%u\n",
> +		cam->width, cam->height, cam->vin_left, cam->vin_top);
> +	dev_dbg(icd->parent, "Cam subrect %ux%u@%u:%u\n",
> +		cam_subrect->width, cam_subrect->height,
> +		cam_subrect->left, cam_subrect->top);
> +
> +	/* Set Start/End Pixel/Line Pre-Clip */
> +	iowrite32(left_offset << dsize, priv->base + VNSPPRC_REG);
> +	iowrite32((left_offset + cam->width - 1) << dsize,
> +		  priv->base + VNEPPRC_REG);

Do you have to shift for all 32-bit formats, not only for RGB32? I 
understand this is related to the fact, that you don't support 
pass-through...

> +	switch (priv->field) {
> +	case V4L2_FIELD_INTERLACED:
> +	case V4L2_FIELD_INTERLACED_TB:
> +	case V4L2_FIELD_INTERLACED_BT:
> +		iowrite32(top_offset / 2, priv->base + VNSLPRC_REG);
> +		iowrite32((top_offset + cam->height) / 2 - 1,
> +			  priv->base + VNELPRC_REG);
> +		break;
> +	default:
> +		iowrite32(top_offset, priv->base + VNSLPRC_REG);
> +		iowrite32(top_offset + cam->height - 1,
> +			  priv->base + VNELPRC_REG);
> +		break;
> +	}
> +
> +	/* Set Start/End Pixel/Line Post-Clip */
> +	iowrite32(0, priv->base + VNSPPOC_REG);
> +	iowrite32(0, priv->base + VNSLPOC_REG);
> +	iowrite32((cam_subrect->width - 1) << dsize, priv->base + VNEPPOC_REG);

ditto

> +	switch (priv->field) {
> +	case V4L2_FIELD_INTERLACED:
> +	case V4L2_FIELD_INTERLACED_TB:
> +	case V4L2_FIELD_INTERLACED_BT:
> +		iowrite32(cam_subrect->height / 2 - 1,
> +			  priv->base + VNELPOC_REG);
> +		break;
> +	default:
> +		iowrite32(cam_subrect->height - 1, priv->base + VNELPOC_REG);
> +		break;
> +	}
> +
> +	iowrite32((cam->width + 0xf) & ~0xf, priv->base + VNIS_REG);

ALIGN(cam->width, 0x10)

> +
> +	return 0;
> +}
> +
> +static void capture_stop_preserve(struct rcar_vin_priv *priv, u32 *vnmc)
> +{
> +	*vnmc = ioread32(priv->base + VNMC_REG);
> +	/* module disable */
> +	iowrite32(*vnmc & ~VNMC_ME, priv->base + VNMC_REG);
> +}
> +
> +static void capture_restore(struct rcar_vin_priv *priv, u32 vnmc)
> +{
> +	unsigned long timeout = jiffies + 10 * HZ;
> +
> +	if (!(vnmc & ~VNMC_ME))
> +		/* Nothing to restore */
> +		return;

And you don't have to wait for a frame end?

> +
> +	/*
> +	 * Wait until the end of the current frame. It can take a long time,
> +	 * but if it has been aborted by a MRST1 reset, it should exit sooner.
> +	 */
> +	while ((ioread32(priv->base + VNMS_REG) & VNMS_AV) &&
> +		time_before(jiffies, timeout))
> +		msleep(1);
> +
> +	if (time_after(jiffies, timeout)) {
> +		dev_err(priv->ici.v4l2_dev.dev,
> +			"Timeout waiting for frame end! Interface problem?\n");
> +		return;
> +	}
> +
> +	iowrite32(vnmc, priv->base + VNMC_REG);
> +}
> +
> +#define VIN_MBUS_FLAGS	(V4L2_MBUS_MASTER |		\
> +			 V4L2_MBUS_PCLK_SAMPLE_RISING |	\
> +			 V4L2_MBUS_HSYNC_ACTIVE_HIGH |	\
> +			 V4L2_MBUS_HSYNC_ACTIVE_LOW |	\
> +			 V4L2_MBUS_VSYNC_ACTIVE_HIGH |	\
> +			 V4L2_MBUS_VSYNC_ACTIVE_LOW |	\
> +			 V4L2_MBUS_DATA_ACTIVE_HIGH)
> +
> +static int rcar_vin_set_bus_param(struct soc_camera_device *icd)
> +{
> +	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
> +	struct rcar_vin_priv *priv = ici->priv;
> +	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
> +	struct v4l2_mbus_config cfg = {.type = V4L2_MBUS_PARALLEL,};
> +	unsigned long common_flags;
> +	u32 vnmc;
> +	u32 val;
> +	int ret;
> +
> +	capture_stop_preserve(priv, &vnmc);
> +
> +	ret = v4l2_subdev_call(sd, video, g_mbus_config, &cfg);
> +	if (!ret) {
> +		common_flags = soc_mbus_config_compatible(&cfg, VIN_MBUS_FLAGS);
> +		if (!common_flags) {
> +			dev_warn(icd->parent,
> +				 "MBUS flags incompatible: camera 0x%x, host 0x%x\n",
> +				 cfg.flags, VIN_MBUS_FLAGS);
> +			return -EINVAL;
> +		}
> +	} else if (ret != -ENOIOCTLCMD) {
> +		return ret;
> +	} else {
> +		common_flags = VIN_MBUS_FLAGS;
> +	}
> +
> +	/* Make choises, based on platform preferences */
> +	if ((common_flags & V4L2_MBUS_HSYNC_ACTIVE_HIGH) &&
> +	    (common_flags & V4L2_MBUS_HSYNC_ACTIVE_LOW)) {
> +		if (priv->pdata->flags & RCAR_VIN_HSYNC_ACTIVE_LOW)
> +			common_flags &= ~V4L2_MBUS_HSYNC_ACTIVE_HIGH;
> +		else
> +			common_flags &= ~V4L2_MBUS_HSYNC_ACTIVE_LOW;
> +	}
> +
> +	if ((common_flags & V4L2_MBUS_VSYNC_ACTIVE_HIGH) &&
> +	    (common_flags & V4L2_MBUS_VSYNC_ACTIVE_LOW)) {
> +		if (priv->pdata->flags & RCAR_VIN_VSYNC_ACTIVE_LOW)
> +			common_flags &= ~V4L2_MBUS_VSYNC_ACTIVE_HIGH;
> +		else
> +			common_flags &= ~V4L2_MBUS_VSYNC_ACTIVE_LOW;
> +	}
> +
> +	cfg.flags = common_flags;
> +	ret = v4l2_subdev_call(sd, video, s_mbus_config, &cfg);
> +	if (ret < 0 && ret != -ENOIOCTLCMD)
> +		return ret;
> +
> +	val = priv->field == V4L2_FIELD_NONE ? VNDMR2_FTEV : 0;
> +	if (!(common_flags & V4L2_MBUS_VSYNC_ACTIVE_LOW))
> +		val |= VNDMR2_VPS;
> +	if (!(common_flags & V4L2_MBUS_HSYNC_ACTIVE_LOW))
> +		val |= VNDMR2_HPS;
> +	iowrite32(val, priv->base + VNDMR2_REG);
> +
> +	ret = rcar_vin_set_rect(icd);
> +	if (ret < 0)
> +		return ret;
> +
> +	capture_restore(priv, vnmc);
> +
> +	return 0;
> +}
> +
> +static int rcar_vin_try_bus_param(struct soc_camera_device *icd,
> +				  unsigned char buswidth)
> +{
> +	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
> +	struct v4l2_mbus_config cfg = {.type = V4L2_MBUS_PARALLEL,};
> +	int ret;
> +
> +	ret = v4l2_subdev_call(sd, video, g_mbus_config, &cfg);
> +	if (ret == -ENOIOCTLCMD)
> +		return 0;
> +	else if (ret)
> +		return ret;
> +
> +	/* check is there common mbus flags */
> +	ret = soc_mbus_config_compatible(&cfg, VIN_MBUS_FLAGS);
> +	if (ret)
> +		return 0;
> +
> +	dev_warn(icd->parent,
> +		"MBUS flags incompatible: camera 0x%x, host 0x%x\n",
> +		 cfg.flags, VIN_MBUS_FLAGS);
> +
> +	return -EINVAL;

You could check the buswidth too

> +}
> +
> +static const struct soc_mbus_pixelfmt rcar_vin_formats[] = {
> +	{
> +		.fourcc			= V4L2_PIX_FMT_NV16,
> +		.name			= "NV16",
> +		.bits_per_sample	= 16,
> +		.packing		= SOC_MBUS_PACKING_NONE,
> +		.order			= SOC_MBUS_ORDER_LE,

Please, add an explicit .layout field to all these. Especially for planar 
formats like this one, it is important to set the .layout field correctly.

> +	},
> +	{
> +		.fourcc			= V4L2_PIX_FMT_YUYV,
> +		.name			= "YUYV",
> +		.bits_per_sample	= 16,
> +		.packing		= SOC_MBUS_PACKING_NONE,
> +		.order			= SOC_MBUS_ORDER_LE,

This conversion block is identical to the respective one in 
soc_mediabus.c, which suggests to me, that no conversion is taking place 
here. Then this mode should be usable for generic 8- or 16-bit 
pass-through?

> +	},
> +	{
> +		.fourcc			= V4L2_PIX_FMT_UYVY,
> +		.name			= "UYVY",
> +		.bits_per_sample	= 16,
> +		.packing		= SOC_MBUS_PACKING_NONE,
> +		.order			= SOC_MBUS_ORDER_LE,
> +	},
> +	{
> +		.fourcc			= V4L2_PIX_FMT_RGB565,
> +		.name			= "RGB565",
> +		.bits_per_sample	= 16,
> +		.packing		= SOC_MBUS_PACKING_NONE,
> +		.order			= SOC_MBUS_ORDER_LE,
> +	},
> +	{
> +		.fourcc			= V4L2_PIX_FMT_RGB555X,
> +		.name			= "ARGB1555",
> +		.bits_per_sample	= 16,
> +		.packing		= SOC_MBUS_PACKING_NONE,
> +		.order			= SOC_MBUS_ORDER_LE,
> +	},
> +	{
> +		.fourcc			= V4L2_PIX_FMT_RGB32,
> +		.name			= "RGB888",
> +		.bits_per_sample	= 32,
> +		.packing		= SOC_MBUS_PACKING_NONE,
> +		.order			= SOC_MBUS_ORDER_LE,
> +	},
> +};
> +
> +static int client_g_rect(struct v4l2_subdev *sd, struct v4l2_rect *rect);
> +
> +static int rcar_vin_get_formats(struct soc_camera_device *icd, unsigned int idx,
> +				struct soc_camera_format_xlate *xlate)
> +{
> +	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
> +	struct device *dev = icd->parent;
> +	int ret, k, n;
> +	int formats = 0;
> +	struct rcar_vin_cam *cam;
> +	enum v4l2_mbus_pixelcode code;
> +	const struct soc_mbus_pixelfmt *fmt;
> +
> +	ret = v4l2_subdev_call(sd, video, enum_mbus_fmt, idx, &code);
> +	if (ret < 0)
> +		return 0;
> +
> +	fmt = soc_mbus_get_fmtdesc(code);
> +	if (!fmt) {
> +		dev_err(icd->parent,
> +			"Invalid format code #%u: %d\n", idx, code);
> +		return -EINVAL;

return 0, just skip an unsupported code.

> +	}
> +
> +	ret = rcar_vin_try_bus_param(icd, fmt->bits_per_sample);
> +	if (ret < 0)
> +		return 0;
> +
> +	if (!icd->host_priv) {
> +		struct v4l2_mbus_framefmt mf;
> +		struct v4l2_rect rect;
> +		struct device *dev = icd->parent;
> +		int shift;
> +
> +		/* Cache current client geometry */
> +		ret = client_g_rect(sd, &rect);
> +		if (ret < 0)
> +			return ret;
> +
> +		ret = v4l2_subdev_call(sd, video, g_mbus_fmt, &mf);
> +		if (ret < 0)
> +			return ret;
> +
> +		/*
> +		 * If sensor proposes too large format then try smaller ones:
> +		 * 1280x960, 640x480, 320x240
> +		 */
> +		for (shift = 0; shift < 3; shift++) {
> +			if (mf.width <= VIN_MAX_WIDTH &&
> +			    mf.height <= VIN_MAX_HEIGHT)
> +				break;
> +
> +			mf.width = 1280 >> shift;
> +			mf.height = 960 >> shift;
> +			ret = v4l2_device_call_until_err(sd->v4l2_dev,
> +							 soc_camera_grp_id(icd),
> +							 video, s_mbus_fmt,
> +							 &mf);
> +			if (ret < 0)
> +				return ret;
> +		}
> +
> +		if (shift == 3) {
> +			dev_err(dev,
> +				"Failed to configure the client below %ux%x\n",
> +				mf.width, mf.height);
> +			return -EIO;
> +		}
> +
> +		dev_dbg(dev, "camera fmt %ux%u\n", mf.width, mf.height);
> +
> +		cam = kzalloc(sizeof(*cam), GFP_KERNEL);
> +		if (!cam)
> +			return -ENOMEM;
> +		/*
> +		 * We are called with current camera crop,
> +		 * initialise subrect with it
> +		 */
> +		cam->rect = rect;
> +		cam->subrect = rect;
> +		cam->width = mf.width;
> +		cam->height = mf.height;
> +
> +		icd->host_priv = cam;
> +	} else {
> +		cam = icd->host_priv;
> +	}
> +
> +	/* Beginning of a pass */
> +	if (!idx)
> +		cam->extra_fmt = NULL;
> +
> +	switch (code) {
> +	case V4L2_MBUS_FMT_YUYV8_1X16:
> +	case V4L2_MBUS_FMT_YUYV8_2X8:
> +		if (cam->extra_fmt)
> +			break;
> +
> +		/* Add all our formats that can be generated by VIN */
> +		cam->extra_fmt = rcar_vin_formats;
> +
> +		n = ARRAY_SIZE(rcar_vin_formats);
> +		formats += n;
> +		for (k = 0; xlate && k < n; k++, xlate++) {
> +			xlate->host_fmt = &rcar_vin_formats[k];
> +			xlate->code = code;
> +			dev_dbg(dev, "Providing format %s using code %d\n",
> +				rcar_vin_formats[k].name, code);
> +		}
> +		break;
> +	default:
> +		return 0;

The above tells me, that VIN (or at least this driver) can only capture 
YUYV8 either over an 8- or a 16-bit bus. Isn't it possible to provide a 
pass-through mode?

> +	}
> +
> +	return formats;
> +}
> +
> +static void rcar_vin_put_formats(struct soc_camera_device *icd)
> +{
> +	kfree(icd->host_priv);
> +	icd->host_priv = NULL;
> +}
> +
> +/* Check if any dimension of r1 is smaller than respective one of r2 */
> +static bool is_smaller(struct v4l2_rect *r1, struct v4l2_rect *r2)

cropping functions have been updated to use "const" in one of their 
arguments, please, update, or switch to using exported helper functions.

Here begins the section, which is really identical (modulo name-changes) 
to the one in the sh-mobile-ceu-camera driver. Please, consider using 
functions, extracted by 
http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/63820 
instead of reimplementing. Note, that there can be some incompatibilities 
with your kernel version, since those patches are based on my latest 
snapshot, which includes clock, async, and relevant soc-camera changes.

> +{
> +	return r1->width < r2->width || r1->height < r2->height;
> +}
> +
> +/* Check if r1 fails to cover r2 */
> +static bool is_inside(struct v4l2_rect *r1, struct v4l2_rect *r2)
> +{
> +	return r1->left > r2->left || r1->top > r2->top ||
> +	       r1->left + r1->width < r2->left + r2->width ||
> +	       r1->top + r1->height < r2->top + r2->height;
> +}
> +
> +static unsigned int scale_down(unsigned int size, unsigned int scale)
> +{
> +	return (size * 4096 + scale / 2) / scale;
> +}
> +
> +static unsigned int calc_generic_scale(unsigned int input, unsigned int output)
> +{
> +	return (input * 4096 + output / 2) / output;
> +}
> +
> +/* Get and store current client crop */
> +static int client_g_rect(struct v4l2_subdev *sd, struct v4l2_rect *rect)
> +{
> +	struct v4l2_crop crop;
> +	struct v4l2_cropcap cap;
> +	int ret;
> +
> +	crop.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +
> +	ret = v4l2_subdev_call(sd, video, g_crop, &crop);
> +	if (!ret) {
> +		*rect = crop.c;
> +		return ret;
> +	}
> +
> +	/* Camera driver doesn't support .g_crop(), assume default rectangle */
> +	cap.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +
> +	ret = v4l2_subdev_call(sd, video, cropcap, &cap);
> +	if (!ret)
> +		*rect = cap.defrect;
> +
> +	return ret;
> +}
> +
> +/*
> + * Client crop has changed, update our sub-rectangle to remain within the area
> + */
> +static void update_subrect(struct rcar_vin_cam *cam)
> +{
> +	struct v4l2_rect *rect = &cam->rect, *subrect = &cam->subrect;
> +
> +	if (rect->width < subrect->width)
> +		subrect->width = rect->width;
> +
> +	if (rect->height < subrect->height)
> +		subrect->height = rect->height;
> +
> +	if (rect->left > subrect->left)
> +		subrect->left = rect->left;
> +	else if (rect->left + rect->width > subrect->left + subrect->width)
> +		subrect->left = rect->left + rect->width - subrect->width;
> +
> +	if (rect->top > subrect->top)
> +		subrect->top = rect->top;
> +	else if (rect->top + rect->height > subrect->top + subrect->height)
> +		subrect->top = rect->top + rect->height - subrect->height;
> +}
> +
> +/*
> + * The common for both scaling and cropping iterative approach is:
> + * 1. try if the client can produce exactly what requested by the user
> + * 2. if (1) failed, try to double the client image until we get one big enough
> + * 3. if (2) failed, try to request the maximum image
> + */
> +static int client_s_crop(struct soc_camera_device *icd, struct v4l2_crop *crop,
> +			 struct v4l2_crop *cam_crop)
> +{
> +	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
> +	struct v4l2_rect *rect = &crop->c, *cam_rect = &cam_crop->c;
> +	struct device *dev = sd->v4l2_dev->dev;
> +	struct rcar_vin_cam *cam = icd->host_priv;
> +	struct v4l2_cropcap cap;
> +	int ret;
> +	unsigned int width, height;
> +
> +	v4l2_subdev_call(sd, video, s_crop, crop);
> +	ret = client_g_rect(sd, cam_rect);
> +	if (ret < 0)
> +		return ret;
> +
> +	/*
> +	 * Now cam_crop contains the current camera input rectangle, and it must
> +	 * be within camera cropcap bounds
> +	 */
> +	if (!memcmp(rect, cam_rect, sizeof(*rect))) {
> +		/* Even if camera S_CROP failed, but camera rectangle matches */
> +		dev_dbg(dev, "Camera S_CROP successful for %dx%d@%d:%d\n",
> +			rect->width, rect->height, rect->left, rect->top);
> +		cam->rect = *cam_rect;
> +		return 0;
> +	}
> +
> +	/* Try to fix cropping, that camera hasn't managed to set */
> +	dev_dbg(dev, "Fix camera S_CROP for %dx%d@%d:%d to %dx%d@%d:%d\n",
> +		cam_rect->width, cam_rect->height,
> +		cam_rect->left, cam_rect->top,
> +		rect->width, rect->height, rect->left, rect->top);
> +
> +	/* We need sensor maximum rectangle */
> +	ret = v4l2_subdev_call(sd, video, cropcap, &cap);
> +	if (ret < 0)
> +		return ret;
> +
> +	/*
> +	 * Popular special case - some cameras can only handle fixed sizes like
> +	 * QVGA, VGA,... Take care to avoid infinite loop.
> +	 */
> +	width = max(cam_rect->width, 2);
> +	height = max(cam_rect->height, 2);
> +
> +	/*
> +	 * Loop as long as sensor is not covering the requested rectangle and
> +	 * is still within its bounds
> +	 */
> +	while (!ret && (is_smaller(cam_rect, rect) ||
> +			is_inside(cam_rect, rect)) &&
> +	       (cap.bounds.width > width || cap.bounds.height > height)) {
> +
> +		width <<= 1;
> +		height <<= 1;
> +
> +		cam_rect->width = width;
> +		cam_rect->height = height;
> +
> +		/*
> +		 * We do not know what capabilities the camera has to set up
> +		 * left and top borders. We could try to be smarter in iterating
> +		 * them, e.g. if camera current left is to the right of the
> +		 * target left, set it to the middle point between the current
> +		 * left and minimum left. But that would add too much
> +		 * complexity: we would have to iterate each border separately.
> +		 * Instead we just drop to the left and top bounds.
> +		 */
> +		if (cam_rect->left > rect->left)
> +			cam_rect->left = cap.bounds.left;
> +
> +		if (cam_rect->left + cam_rect->width < rect->left + rect->width)
> +			cam_rect->width = rect->left + rect->width -
> +				cam_rect->left;
> +
> +		if (cam_rect->top > rect->top)
> +			cam_rect->top = cap.bounds.top;
> +
> +		if (cam_rect->top + cam_rect->height < rect->top + rect->height)
> +			cam_rect->height = rect->top + rect->height -
> +				cam_rect->top;
> +
> +		v4l2_subdev_call(sd, video, s_crop, cam_crop);
> +		ret = client_g_rect(sd, cam_rect);
> +		dev_dbg(dev, "Camera S_CROP %d for %dx%d@%d:%d\n", ret,
> +			cam_rect->width, cam_rect->height,
> +			cam_rect->left, cam_rect->top);
> +	}
> +
> +	/* S_CROP must not modify the rectangle */
> +	if (is_smaller(cam_rect, rect) || is_inside(cam_rect, rect)) {
> +		/*
> +		 * The camera failed to configure a suitable cropping,
> +		 * we cannot use the current rectangle, set to max
> +		 */
> +		*cam_rect = cap.bounds;
> +		v4l2_subdev_call(sd, video, s_crop, cam_crop);
> +		ret = client_g_rect(sd, cam_rect);
> +		dev_dbg(dev, "Camera S_CROP %d for max %dx%d@%d:%d\n", ret,
> +			cam_rect->width, cam_rect->height,
> +			cam_rect->left, cam_rect->top);
> +	}
> +
> +	if (!ret) {
> +		cam->rect = *cam_rect;
> +
> +		dev_dbg(dev, "Update subrect for %dx%d@%d:%d to %dx%d@%d:%d\n",
> +			cam->subrect.width, cam->subrect.height,
> +			cam->subrect.left, cam->subrect.top,
> +			cam->rect.width, cam->rect.height,
> +			cam->rect.left, cam->rect.top);
> +
> +		update_subrect(cam);
> +	}
> +
> +	return ret;
> +}
> +
> +/* Iterative s_mbus_fmt, also updates cached client crop on success */
> +static int client_s_fmt(struct soc_camera_device *icd,
> +			struct v4l2_mbus_framefmt *mf, bool vin_can_scale)
> +{
> +	struct rcar_vin_cam *cam = icd->host_priv;
> +	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
> +	struct device *dev = icd->parent;
> +	unsigned int width = mf->width, height = mf->height, tmp_w, tmp_h;
> +	unsigned int max_width, max_height;
> +	struct v4l2_cropcap cap;
> +	int ret;
> +
> +	ret = v4l2_device_call_until_err(sd->v4l2_dev,
> +					 soc_camera_grp_id(icd), video,
> +					 s_mbus_fmt, mf);
> +	if (ret < 0)
> +		return ret;
> +
> +	dev_dbg(dev, "camera scaled to %ux%u\n", mf->width, mf->height);
> +
> +	if ((width == mf->width && height == mf->height) || !vin_can_scale)
> +		goto update_cache;
> +
> +	cap.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +
> +	ret = v4l2_subdev_call(sd, video, cropcap, &cap);
> +	if (ret < 0)
> +		return ret;
> +
> +	max_width = min(cap.bounds.width, VIN_MAX_WIDTH);
> +	max_height = min(cap.bounds.height, VIN_MAX_HEIGHT);
> +
> +	/* Camera set a format, but geometry is not precise, try to improve */
> +	tmp_w = mf->width;
> +	tmp_h = mf->height;
> +
> +	/* width <= max_width && height <= max_height - guaranteed by try_fmt */
> +	while ((width > tmp_w || height > tmp_h) &&
> +	       tmp_w < max_width && tmp_h < max_height) {
> +		tmp_w = min(2 * tmp_w, max_width);
> +		tmp_h = min(2 * tmp_h, max_height);
> +		mf->width = tmp_w;
> +		mf->height = tmp_h;
> +		ret = v4l2_subdev_call(sd, video, s_mbus_fmt, mf);
> +		if (ret < 0) {
> +			/* This shouldn't happen */
> +			dev_err(dev, "Client failed to set format: %d\n", ret);
> +			return ret;
> +		}
> +		dev_dbg(dev, "Camera scaled to %ux%u\n", mf->width, mf->height);
> +	}
> +
> +update_cache:
> +	ret = client_g_rect(sd, &cam->rect);
> +	if (ret < 0)
> +		return ret;
> +
> +	update_subrect(cam);
> +
> +	return 0;
> +}
> +
> +/*
> + * width - on output: user width, mapped back to input
> + * height - on output: user height, mapped back to input
> + * mf - in-/output: camera output window
> + */
> +static int client_scale(struct soc_camera_device *icd,
> +			struct v4l2_mbus_framefmt *mf,
> +			unsigned int *width, unsigned int *height,
> +			bool vin_can_scale)
> +{
> +	struct rcar_vin_cam *cam = icd->host_priv;
> +	struct device *dev = icd->parent;
> +	struct v4l2_mbus_framefmt mf_tmp = *mf;
> +	unsigned int scale_h, scale_v;
> +	int ret;
> +
> +	/*
> +	 * Apply iterative camera S_FMT for camera user window (also updates
> +	 * client crop cache and the imaginary sub-rectangle).
> +	 */
> +	ret = client_s_fmt(icd, &mf_tmp, vin_can_scale);
> +	if (ret < 0)
> +		return ret;
> +
> +	dev_dbg(dev, "camera scaled to %ux%u\n",
> +		mf_tmp.width, mf_tmp.height);
> +
> +	/* Calculate new client scales. */
> +	scale_h = calc_generic_scale(cam->rect.width, mf_tmp.width);
> +	scale_v = calc_generic_scale(cam->rect.height, mf_tmp.height);
> +
> +	mf->width = mf_tmp.width;
> +	mf->height = mf_tmp.height;
> +	mf->colorspace = mf_tmp.colorspace;
> +
> +	/*
> +	 * Calculate new VIN crop - apply camera scales to previously
> +	 * updated "effective" crop.
> +	 */
> +	*width = scale_down(cam->subrect.width, scale_h);
> +	*height = scale_down(cam->subrect.height, scale_v);
> +
> +	dev_dbg(dev, "new client sub-window %ux%u\n", *width, *height);
> +
> +	return 0;
> +}
> +
> +static int rcar_vin_set_crop(struct soc_camera_device *icd,
> +			     const struct v4l2_crop *a)
> +{
> +	struct v4l2_crop a_writable = *a;
> +	const struct v4l2_rect *rect = &a_writable.c;
> +	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
> +	struct rcar_vin_priv *priv = ici->priv;
> +	struct v4l2_crop cam_crop;
> +	struct rcar_vin_cam *cam = icd->host_priv;
> +	struct v4l2_rect *cam_rect = &cam_crop.c;
> +	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
> +	struct device *dev = icd->parent;
> +	struct v4l2_mbus_framefmt mf;
> +	u32 vnmc;
> +	int ret, i;
> +
> +	dev_dbg(dev, "S_CROP(%ux%u@%u:%u)\n", rect->width, rect->height,
> +		rect->left, rect->top);
> +
> +	/* During camera cropping its output window can change too, stop VIN */
> +	capture_stop_preserve(priv, &vnmc);
> +	dev_dbg(dev, "VNMC_REG 0x%x\n", vnmc);
> +
> +	/* Apply iterative camera S_CROP for new input window. */
> +	ret = client_s_crop(icd, &a_writable, &cam_crop);
> +	if (ret < 0)
> +		return ret;
> +
> +	dev_dbg(dev, "camera cropped to %ux%u@%u:%u\n",
> +		cam_rect->width, cam_rect->height,
> +		cam_rect->left, cam_rect->top);
> +
> +	/* On success cam_crop contains current camera crop */
> +
> +	/* Retrieve camera output window */
> +	ret = v4l2_subdev_call(sd, video, g_mbus_fmt, &mf);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (mf.width > VIN_MAX_WIDTH || mf.height > VIN_MAX_HEIGHT)
> +		return -EINVAL;
> +
> +	/* Cache camera output window */
> +	cam->width = mf.width;
> +	cam->height = mf.height;
> +
> +	icd->user_width  = cam->width;
> +	icd->user_height = cam->height;
> +
> +	cam->vin_left = rect->left & ~1;
> +	cam->vin_top = rect->top & ~1;
> +
> +	/* Use VIN cropping to crop to the new window. */
> +	ret = rcar_vin_set_rect(icd);
> +	if (ret < 0)
> +		return ret;
> +
> +	cam->subrect = *rect;
> +
> +	dev_dbg(dev, "VIN cropped to %ux%u@%u:%u\n",
> +		icd->user_width, icd->user_height,
> +		cam->vin_left, cam->vin_top);
> +
> +	/* Restore capture */
> +	for (i = 0; i < MAX_BUFFER_NUM; i++) {
> +		if (priv->queue_buf[i] && priv->state == STOPPED) {
> +			vnmc |= VNMC_ME;
> +			break;
> +		}
> +	}
> +	capture_restore(priv, vnmc);
> +
> +	/* Even if only camera cropping succeeded */
> +	return ret;
> +}
> +
> +static int rcar_vin_get_crop(struct soc_camera_device *icd,
> +			     struct v4l2_crop *a)
> +{
> +	struct rcar_vin_cam *cam = icd->host_priv;
> +
> +	a->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +	a->c = cam->subrect;
> +
> +	return 0;
> +}
> +
> +/*
> + * Calculate real client output window by applying new scales to the current
> + * client crop. New scales are calculated from the requested output format and
> + * VIN crop, mapped backed onto the client input (subrect).
> + */
> +static void calculate_client_output(struct soc_camera_device *icd,
> +				    struct v4l2_pix_format *pix,
> +				    struct v4l2_mbus_framefmt *mf)
> +{
> +	struct rcar_vin_cam *cam = icd->host_priv;
> +	struct device *dev = icd->parent;
> +	struct v4l2_rect *cam_subrect = &cam->subrect;
> +	unsigned int scale_v, scale_h;
> +
> +	if (cam_subrect->width == cam->rect.width &&
> +	    cam_subrect->height == cam->rect.height) {
> +		/* No sub-cropping */
> +		mf->width = pix->width;
> +		mf->height = pix->height;
> +		return;
> +	}
> +
> +	/* Current camera scales and subwin - cached */
> +
> +	dev_dbg(dev, "subwin %ux%u@%u:%u\n",
> +		cam_subrect->width, cam_subrect->height,
> +		cam_subrect->left, cam_subrect->top);
> +
> +	/*
> +	 * Calculate new combined scales from input sub-window to requested
> +	 * user window
> +	 */
> +
> +	scale_h = calc_generic_scale(cam_subrect->width, pix->width);
> +	scale_v = calc_generic_scale(cam_subrect->height, pix->height);
> +
> +	dev_dbg(dev, "scales %u:%u\n", scale_h, scale_v);
> +
> +	/*
> +	 * Calculate client output window by applying combined scales to real
> +	 * input window
> +	 */
> +	mf->width = scale_down(cam->rect.width, scale_h);
> +	mf->height = scale_down(cam->rect.height, scale_v);
> +}
> +
> +/* Similar to set_crop multistage iterative algorithm */
> +static int rcar_vin_set_fmt(struct soc_camera_device *icd,
> +			    struct v4l2_format *f)
> +{
> +	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
> +	struct rcar_vin_priv *priv = ici->priv;
> +	struct rcar_vin_cam *cam = icd->host_priv;
> +	struct v4l2_pix_format *pix = &f->fmt.pix;
> +	struct v4l2_mbus_framefmt mf;
> +	struct device *dev = icd->parent;
> +	__u32 pixfmt = pix->pixelformat;
> +	const struct soc_camera_format_xlate *xlate;
> +	unsigned int vin_sub_width = 0, vin_sub_height = 0;
> +	u16 scale_v, scale_h;
> +	int ret;
> +	bool can_scale;
> +	bool data_through;

What exactly does data_through mean? I thought it meant a pass-through 
mode, but it is set to true for a YUYV->RGB32 conversion, which isn't 
pass-through obviously.

> +	enum v4l2_field field;
> +
> +	dev_dbg(dev, "S_FMT(pix=0x%x, %ux%u)\n",
> +		pixfmt, pix->width, pix->height);
> +
> +	switch (pix->field) {
> +	default:
> +		pix->field = V4L2_FIELD_NONE;
> +		/* fall-through */
> +	case V4L2_FIELD_NONE:
> +	case V4L2_FIELD_TOP:
> +	case V4L2_FIELD_BOTTOM:
> +	case V4L2_FIELD_INTERLACED_TB:
> +	case V4L2_FIELD_INTERLACED_BT:
> +		field = pix->field;
> +		break;
> +	case V4L2_FIELD_INTERLACED:
> +		field = V4L2_FIELD_INTERLACED_TB;
> +		break;
> +	}
> +
> +	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
> +	if (!xlate) {
> +		dev_warn(dev, "Format %x not found\n", pixfmt);
> +		return -EINVAL;
> +	}
> +	/* Calculate client output geometry */
> +	calculate_client_output(icd, &f->fmt.pix, &mf);
> +	mf.field = pix->field;
> +	mf.colorspace = pix->colorspace;
> +	mf.code	 = xlate->code;
> +
> +	data_through = pixfmt == V4L2_PIX_FMT_RGB32;

What is "data_through" and why is RGB32 so special?

> +	can_scale = !data_through && pixfmt != V4L2_PIX_FMT_NV16;

VIN can scale _everything_ except NV16 and RGB32? I would rather use a 
positive test - check, that the requested format _is_ one of those, that 
VIN can scale.

> +
> +	dev_dbg(dev, "request camera output %ux%u\n", mf.width, mf.height);
> +
> +	ret = client_scale(icd, &mf, &vin_sub_width, &vin_sub_height,
> +			   can_scale);
> +
> +	/* Done with the camera. Now see if we can improve the result */
> +	dev_dbg(dev, "Camera %d fmt %ux%u, requested %ux%u\n",
> +		ret, mf.width, mf.height, pix->width, pix->height);
> +
> +	if (ret < 0)
> +		return ret;
> +
> +	if (mf.code != xlate->code)
> +		return -EINVAL;
> +
> +	/* Prepare VIN crop */
> +	cam->width = mf.width;
> +	cam->height = mf.height;
> +
> +	/* Use VIN scaling to scale to the requested user window. */
> +
> +	/* We cannot scale up */
> +	if (pix->width > vin_sub_width)
> +		vin_sub_width = pix->width;
> +
> +	if (pix->height > vin_sub_height)
> +		vin_sub_height = pix->height;
> +
> +	pix->colorspace = mf.colorspace;
> +
> +	if (can_scale) {
> +		/* Scale pix->{width x height} down to width x height */
> +		scale_h = calc_scale(vin_sub_width, &pix->width);
> +		scale_v = calc_scale(vin_sub_height, &pix->height);

scales are calculated but never used. If scaling isn't supported, a few 
places can be simplified.

> +	} else {
> +		pix->width = vin_sub_width;
> +		pix->height = vin_sub_height;
> +		scale_h = 0;
> +		scale_v = 0;
> +	}
> +
> +	/*
> +	 * We have calculated CFLCR, the actual configuration will be performed
> +	 * in rcar_vin_set_bus_param()
> +	 */
> +
> +	dev_dbg(dev, "W: %u : 0x%x = %u, H: %u : 0x%x = %u\n",
> +		vin_sub_width, scale_h, pix->width,
> +		vin_sub_height, scale_v, pix->height);
> +
> +	cam->code = xlate->code;
> +	icd->current_fmt = xlate;
> +
> +	priv->field = field;
> +	priv->data_through = data_through;
> +
> +	return 0;
> +}
> +
> +static int rcar_vin_try_fmt(struct soc_camera_device *icd,
> +			    struct v4l2_format *f)
> +{
> +	const struct soc_camera_format_xlate *xlate;
> +	struct v4l2_pix_format *pix = &f->fmt.pix;
> +	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
> +	struct v4l2_mbus_framefmt mf;
> +	__u32 pixfmt = pix->pixelformat;
> +	int width, height;
> +	int ret;
> +
> +	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
> +	if (!xlate) {
> +		dev_warn(icd->parent, "Format %x not found\n", pixfmt);
> +		return -EINVAL;

Don't fail here, pick up a default format.

> +	}
> +
> +	/* FIXME: calculate using depth and bus width */
> +	v4l_bound_align_image(&pix->width, 2, VIN_MAX_WIDTH, 1,
> +			      &pix->height, 4, VIN_MAX_HEIGHT, 2, 0);
> +
> +	width = pix->width;
> +	height = pix->height;
> +
> +	pix->bytesperline = soc_mbus_bytes_per_line(width, xlate->host_fmt);
> +	if ((int)pix->bytesperline < 0)
> +		return pix->bytesperline;
> +	pix->sizeimage = height * pix->bytesperline;

Just set both to 0, soc_camera.c will do the default for you.

> +
> +	/* limit to sensor capabilities */
> +	mf.width = pix->width;
> +	mf.height = pix->height;
> +	mf.field = pix->field;
> +	mf.code = xlate->code;
> +	mf.colorspace = pix->colorspace;
> +
> +	ret = v4l2_device_call_until_err(sd->v4l2_dev, soc_camera_grp_id(icd),
> +					 video, try_mbus_fmt, &mf);
> +	if (ret < 0)
> +		return ret;
> +
> +	pix->width = mf.width;
> +	pix->height = mf.height;
> +	pix->field = mf.field;
> +	pix->colorspace = mf.colorspace;
> +
> +	if (pixfmt == V4L2_PIX_FMT_NV16) {
> +		/* FIXME: check against rect_max after converting soc-camera */
> +		/* We can scale precisely, need a bigger image from camera */
> +		if (pix->width < width || pix->height < height) {
> +			/*
> +			 * We presume, the sensor behaves sanely, i.e. if
> +			 * requested a bigger rectangle, it will not return a
> +			 * smaller one.
> +			 */
> +			mf.width = VIN_MAX_WIDTH;
> +			mf.height = VIN_MAX_HEIGHT;
> +			ret = v4l2_device_call_until_err(sd->v4l2_dev,
> +							 soc_camera_grp_id(icd),
> +							 video, try_mbus_fmt,
> +							 &mf);
> +			if (ret < 0) {
> +				dev_err(icd->parent,
> +					"client try_fmt() = %d\n", ret);
> +				return ret;
> +			}
> +		}
> +		/* We will scale exactly */
> +		if (mf.width > width)
> +			pix->width = width;
> +		if (mf.height > height)
> +			pix->height = height;
> +	}
> +
> +	return ret;
> +}
> +
> +static unsigned int rcar_vin_poll(struct file *file, poll_table *pt)
> +{
> +	struct soc_camera_device *icd = file->private_data;
> +
> +	return vb2_poll(&icd->vb2_vidq, file, pt);
> +}
> +
> +static int rcar_vin_querycap(struct soc_camera_host *ici,
> +			     struct v4l2_capability *cap)
> +{
> +	strlcpy(cap->card, "R_Car_VIN", sizeof(cap->card));
> +	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
> +	return 0;
> +}
> +
> +static int rcar_vin_init_videobuf2(struct vb2_queue *vq,
> +				   struct soc_camera_device *icd)
> +{
> +	vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +	vq->io_modes = VB2_MMAP | VB2_USERPTR;
> +	vq->drv_priv = icd;
> +	vq->ops = &rcar_vin_vb2_ops;
> +	vq->mem_ops = &vb2_dma_contig_memops;
> +	vq->buf_struct_size = sizeof(struct rcar_vin_buffer);

Please, add

	vq->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;

> +
> +	return vb2_queue_init(vq);
> +}
> +
> +static struct soc_camera_host_ops rcar_vin_host_ops = {
> +	.owner		= THIS_MODULE,
> +	.add		= rcar_vin_add_device,
> +	.remove		= rcar_vin_remove_device,
> +	.get_formats	= rcar_vin_get_formats,
> +	.put_formats	= rcar_vin_put_formats,
> +	.get_crop	= rcar_vin_get_crop,
> +	.set_crop	= rcar_vin_set_crop,
> +	.try_fmt	= rcar_vin_try_fmt,
> +	.set_fmt	= rcar_vin_set_fmt,
> +	.poll		= rcar_vin_poll,
> +	.querycap	= rcar_vin_querycap,
> +	.set_bus_param	= rcar_vin_set_bus_param,
> +	.init_videobuf2	= rcar_vin_init_videobuf2,
> +};
> +
> +static int rcar_vin_probe(struct platform_device *pdev)
> +{
> +	struct rcar_vin_priv *priv;
> +	struct resource *mem;
> +	struct rcar_vin_platform_data *pdata;
> +	int irq, ret;
> +
> +	pdata = pdev->dev.platform_data;
> +	if (!pdata || !pdata->flags) {
> +		dev_err(&pdev->dev, "platform data not set\n");
> +		return -EINVAL;
> +	}
> +
> +	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (mem == NULL)
> +		return -EINVAL;
> +
> +	irq = platform_get_irq(pdev, 0);
> +	if (irq <= 0)
> +		return -EINVAL;
> +
> +	priv = devm_kzalloc(&pdev->dev, sizeof(struct rcar_vin_priv),
> +			    GFP_KERNEL);
> +	if (!priv)
> +		return -ENOMEM;
> +
> +	priv->base = devm_ioremap_resource(&pdev->dev, mem);
> +	if (IS_ERR(priv->base))
> +		return PTR_ERR(priv->base);
> +
> +	ret = devm_request_irq(&pdev->dev, irq, rcar_vin_irq, IRQF_SHARED,
> +			       dev_name(&pdev->dev), priv);
> +	if (ret)
> +		return ret;
> +
> +	priv->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
> +	if (IS_ERR(priv->alloc_ctx))
> +		return PTR_ERR(priv->alloc_ctx);
> +
> +	priv->ici.priv = priv;
> +	priv->ici.v4l2_dev.dev = &pdev->dev;
> +	priv->ici.nr = pdev->id;
> +	priv->ici.drv_name = dev_name(&pdev->dev);
> +	priv->ici.ops = &rcar_vin_host_ops;
> +
> +	priv->pdata = pdata;
> +	spin_lock_init(&priv->lock);
> +	INIT_LIST_HEAD(&priv->capture);
> +
> +	priv->state = STOPPED;
> +
> +	pm_suspend_ignore_children(&pdev->dev, true);
> +	pm_runtime_enable(&pdev->dev);
> +	pm_runtime_resume(&pdev->dev);

Maybe just a pm_runtime_enable() would be enough.

> +
> +	ret = soc_camera_host_register(&priv->ici);
> +	if (ret)
> +		goto cleanup;
> +
> +	return 0;
> +
> +cleanup:
> +	pm_runtime_disable(&pdev->dev);
> +	vb2_dma_contig_cleanup_ctx(priv->alloc_ctx);
> +
> +	return ret;
> +}
> +
> +static int rcar_vin_remove(struct platform_device *pdev)
> +{
> +	struct soc_camera_host *soc_host = to_soc_camera_host(&pdev->dev);
> +	struct rcar_vin_priv *priv = container_of(soc_host,
> +						  struct rcar_vin_priv, ici);
> +
> +	soc_camera_host_unregister(soc_host);
> +	pm_runtime_disable(&pdev->dev);
> +	vb2_dma_contig_cleanup_ctx(priv->alloc_ctx);
> +
> +	return 0;
> +}
> +
> +static struct platform_driver rcar_vin_driver = {
> +	.probe		= rcar_vin_probe,
> +	.remove		= rcar_vin_remove,
> +	.driver		= {
> +		.name		= DRV_NAME,
> +		.owner		= THIS_MODULE,
> +	},
> +};
> +
> +module_platform_driver(rcar_vin_driver);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS("platform:rcar_vin");
> +MODULE_DESCRIPTION("Renesas R-Car VIN camera host driver");
> Index: renesas/include/linux/platform_data/camera-rcar.h
> ===================================================================
> --- /dev/null
> +++ renesas/include/linux/platform_data/camera-rcar.h
> @@ -0,0 +1,25 @@
> +/*
> + * Platform data for Renesas R-Car VIN soc-camera driver
> + *
> + * Copyright (C) 2011-2013 Renesas Solutions Corp.
> + * Copyright (C) 2013 Cogent Embedded, Inc., <source@cogentembedded.com>
> + *
> + * This program is free software; you can redistribute  it and/or modify it
> + * under  the terms of  the GNU General  Public License as published by the
> + * Free Software Foundation;  either version 2 of the  License, or (at your
> + * option) any later version.
> + */
> +
> +#ifndef __CAMERA_RCAR_H_
> +#define __CAMERA_RCAR_H_
> +
> +#define RCAR_VIN_HSYNC_ACTIVE_LOW	(1 << 0)
> +#define RCAR_VIN_VSYNC_ACTIVE_LOW	(1 << 1)
> +#define RCAR_VIN_BT601			(1 << 2)
> +#define RCAR_VIN_BT656			(1 << 3)
> +
> +struct rcar_vin_platform_data {
> +	unsigned int flags;
> +};
> +
> +#endif /* __CAMERA_RCAR_H_ */
> 

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
