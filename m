Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:3363 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384AbaELH1x (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 May 2014 03:27:53 -0400
Message-ID: <5370779A.3010501@xs4all.nl>
Date: Mon, 12 May 2014 09:26:18 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Alexander Shiyan <shc_work@mail.ru>, linux-media@vger.kernel.org
CC: linux-arm-kernel@lists.infradead.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Shawn Guo <shawn.guo@freescale.com>,
	Sascha Hauer <kernel@pengutronix.de>
Subject: Re: [PATCH] media: mx1_camera: Remove driver
References: <1399788551-8218-1-git-send-email-shc_work@mail.ru>
In-Reply-To: <1399788551-8218-1-git-send-email-shc_work@mail.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/11/2014 08:09 AM, Alexander Shiyan wrote:
> That driver hasn't been really maintained for a long time. It doesn't
> compile in any way, it includes non-existent headers, has no users,
> and marked as "broken" more than year. Due to these factors, mx1_camera
> is now removed from the tree.
> 
> Signed-off-by: Alexander Shiyan <shc_work@mail.ru>

I hadn't realized it depended on BROKEN, so:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  arch/arm/mach-imx/Makefile                      |   3 -
>  arch/arm/mach-imx/devices/Kconfig               |   3 -
>  arch/arm/mach-imx/devices/Makefile              |   1 -
>  arch/arm/mach-imx/devices/devices-common.h      |  10 -
>  arch/arm/mach-imx/devices/platform-mx1-camera.c |  42 --
>  arch/arm/mach-imx/mx1-camera-fiq-ksym.c         |  18 -
>  arch/arm/mach-imx/mx1-camera-fiq.S              |  35 -
>  drivers/media/platform/soc_camera/Kconfig       |  13 -
>  drivers/media/platform/soc_camera/Makefile      |   1 -
>  drivers/media/platform/soc_camera/mx1_camera.c  | 866 ------------------------
>  include/linux/platform_data/camera-mx1.h        |  35 -
>  11 files changed, 1027 deletions(-)
>  delete mode 100644 arch/arm/mach-imx/devices/platform-mx1-camera.c
>  delete mode 100644 arch/arm/mach-imx/mx1-camera-fiq-ksym.c
>  delete mode 100644 arch/arm/mach-imx/mx1-camera-fiq.S
>  delete mode 100644 drivers/media/platform/soc_camera/mx1_camera.c
>  delete mode 100644 include/linux/platform_data/camera-mx1.h
> 
> diff --git a/arch/arm/mach-imx/Makefile b/arch/arm/mach-imx/Makefile
> index 8dd377b..0bdec2a 100644
> --- a/arch/arm/mach-imx/Makefile
> +++ b/arch/arm/mach-imx/Makefile
> @@ -38,9 +38,6 @@ obj-y += ssi-fiq.o
>  obj-y += ssi-fiq-ksym.o
>  endif
>  
> -# Support for CMOS sensor interface
> -obj-$(CONFIG_MX1_VIDEO) += mx1-camera-fiq.o mx1-camera-fiq-ksym.o
> -
>  # i.MX1 based machines
>  obj-$(CONFIG_ARCH_MX1ADS) += mach-mx1ads.o
>  obj-$(CONFIG_MACH_SCB9328) += mach-scb9328.o
> diff --git a/arch/arm/mach-imx/devices/Kconfig b/arch/arm/mach-imx/devices/Kconfig
> index 2d260a5..846c019 100644
> --- a/arch/arm/mach-imx/devices/Kconfig
> +++ b/arch/arm/mach-imx/devices/Kconfig
> @@ -49,9 +49,6 @@ config IMX_HAVE_PLATFORM_IMX_UDC
>  config IMX_HAVE_PLATFORM_IPU_CORE
>  	bool
>  
> -config IMX_HAVE_PLATFORM_MX1_CAMERA
> -	bool
> -
>  config IMX_HAVE_PLATFORM_MX2_CAMERA
>  	bool
>  
> diff --git a/arch/arm/mach-imx/devices/Makefile b/arch/arm/mach-imx/devices/Makefile
> index 1cbc14c..d421c34 100644
> --- a/arch/arm/mach-imx/devices/Makefile
> +++ b/arch/arm/mach-imx/devices/Makefile
> @@ -18,7 +18,6 @@ obj-$(CONFIG_IMX_HAVE_PLATFORM_IMX_SSI) += platform-imx-ssi.o
>  obj-$(CONFIG_IMX_HAVE_PLATFORM_IMX_UART) += platform-imx-uart.o
>  obj-$(CONFIG_IMX_HAVE_PLATFORM_IMX_UDC) += platform-imx_udc.o
>  obj-$(CONFIG_IMX_HAVE_PLATFORM_IPU_CORE) += platform-ipu-core.o
> -obj-$(CONFIG_IMX_HAVE_PLATFORM_MX1_CAMERA) += platform-mx1-camera.o
>  obj-$(CONFIG_IMX_HAVE_PLATFORM_MX2_CAMERA) += platform-mx2-camera.o
>  obj-$(CONFIG_IMX_HAVE_PLATFORM_MXC_EHCI) += platform-mxc-ehci.o
>  obj-$(CONFIG_IMX_HAVE_PLATFORM_MXC_MMC) += platform-mxc-mmc.o
> diff --git a/arch/arm/mach-imx/devices/devices-common.h b/arch/arm/mach-imx/devices/devices-common.h
> index 61352a8..c8169da 100644
> --- a/arch/arm/mach-imx/devices/devices-common.h
> +++ b/arch/arm/mach-imx/devices/devices-common.h
> @@ -208,16 +208,6 @@ struct platform_device *__init imx_add_mx3_sdc_fb(
>  		const struct imx_ipu_core_data *data,
>  		struct mx3fb_platform_data *pdata);
>  
> -#include <linux/platform_data/camera-mx1.h>
> -struct imx_mx1_camera_data {
> -	resource_size_t iobase;
> -	resource_size_t iosize;
> -	resource_size_t irq;
> -};
> -struct platform_device *__init imx_add_mx1_camera(
> -		const struct imx_mx1_camera_data *data,
> -		const struct mx1_camera_pdata *pdata);
> -
>  #include <linux/platform_data/camera-mx2.h>
>  struct imx_mx2_camera_data {
>  	const char *devid;
> diff --git a/arch/arm/mach-imx/devices/platform-mx1-camera.c b/arch/arm/mach-imx/devices/platform-mx1-camera.c
> deleted file mode 100644
> index 2c67881..0000000
> --- a/arch/arm/mach-imx/devices/platform-mx1-camera.c
> +++ /dev/null
> @@ -1,42 +0,0 @@
> -/*
> - * Copyright (C) 2010 Pengutronix
> - * Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>
> - *
> - * This program is free software; you can redistribute it and/or modify it under
> - * the terms of the GNU General Public License version 2 as published by the
> - * Free Software Foundation.
> - */
> -#include "../hardware.h"
> -#include "devices-common.h"
> -
> -#define imx_mx1_camera_data_entry_single(soc, _size)			\
> -	{								\
> -		.iobase = soc ## _CSI ## _BASE_ADDR,			\
> -		.iosize = _size,					\
> -		.irq = soc ## _INT_CSI,					\
> -	}
> -
> -#ifdef CONFIG_SOC_IMX1
> -const struct imx_mx1_camera_data imx1_mx1_camera_data __initconst =
> -	imx_mx1_camera_data_entry_single(MX1, 10);
> -#endif /* ifdef CONFIG_SOC_IMX1 */
> -
> -struct platform_device *__init imx_add_mx1_camera(
> -		const struct imx_mx1_camera_data *data,
> -		const struct mx1_camera_pdata *pdata)
> -{
> -	struct resource res[] = {
> -		{
> -			.start = data->iobase,
> -			.end = data->iobase + data->iosize - 1,
> -			.flags = IORESOURCE_MEM,
> -		}, {
> -			.start = data->irq,
> -			.end = data->irq,
> -			.flags = IORESOURCE_IRQ,
> -		},
> -	};
> -	return imx_add_platform_device_dmamask("mx1-camera", 0,
> -			res, ARRAY_SIZE(res),
> -			pdata, sizeof(*pdata), DMA_BIT_MASK(32));
> -}
> diff --git a/arch/arm/mach-imx/mx1-camera-fiq-ksym.c b/arch/arm/mach-imx/mx1-camera-fiq-ksym.c
> deleted file mode 100644
> index fb38436..0000000
> --- a/arch/arm/mach-imx/mx1-camera-fiq-ksym.c
> +++ /dev/null
> @@ -1,18 +0,0 @@
> -/*
> - * Exported ksyms of ARCH_MX1
> - *
> - * Copyright (C) 2008, Darius Augulis <augulis.darius@gmail.com>
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License version 2 as
> - * published by the Free Software Foundation.
> - */
> -
> -#include <linux/platform_device.h>
> -#include <linux/module.h>
> -
> -#include <linux/platform_data/camera-mx1.h>
> -
> -/* IMX camera FIQ handler */
> -EXPORT_SYMBOL(mx1_camera_sof_fiq_start);
> -EXPORT_SYMBOL(mx1_camera_sof_fiq_end);
> diff --git a/arch/arm/mach-imx/mx1-camera-fiq.S b/arch/arm/mach-imx/mx1-camera-fiq.S
> deleted file mode 100644
> index 9c69aa6..0000000
> --- a/arch/arm/mach-imx/mx1-camera-fiq.S
> +++ /dev/null
> @@ -1,35 +0,0 @@
> -/*
> - *  Copyright (C) 2008 Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
> - *
> - *  Based on linux/arch/arm/lib/floppydma.S
> - *      Copyright (C) 1995, 1996 Russell King
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License version 2 as
> - * published by the Free Software Foundation.
> - */
> -#include <linux/linkage.h>
> -#include <asm/assembler.h>
> -
> -		.text
> -		.global	mx1_camera_sof_fiq_end
> -		.global	mx1_camera_sof_fiq_start
> -mx1_camera_sof_fiq_start:
> -		@ enable dma
> -		ldr	r12, [r9]
> -		orr	r12, r12, #0x00000001
> -		str	r12, [r9]
> -		@ unmask DMA interrupt
> -		ldr	r12, [r8]
> -		bic	r12, r12, r13
> -		str	r12, [r8]
> -		@ disable SOF interrupt
> -		ldr	r12, [r10]
> -		bic	r12, r12, #0x00010000
> -		str	r12, [r10]
> -		@ clear SOF flag
> -		mov	r12, #0x00010000
> -		str	r12, [r11]
> -		@ return from FIQ
> -		subs	pc, lr, #4
> -mx1_camera_sof_fiq_end:
> diff --git a/drivers/media/platform/soc_camera/Kconfig b/drivers/media/platform/soc_camera/Kconfig
> index af39c46..122e03a 100644
> --- a/drivers/media/platform/soc_camera/Kconfig
> +++ b/drivers/media/platform/soc_camera/Kconfig
> @@ -17,19 +17,6 @@ config SOC_CAMERA_PLATFORM
>  	help
>  	  This is a generic SoC camera platform driver, useful for testing
>  
> -config MX1_VIDEO
> -	bool
> -
> -config VIDEO_MX1
> -	tristate "i.MX1/i.MXL CMOS Sensor Interface driver"
> -	depends on BROKEN
> -	depends on VIDEO_DEV && ARCH_MX1 && SOC_CAMERA
> -	select FIQ
> -	select VIDEOBUF_DMA_CONTIG
> -	select MX1_VIDEO
> -	---help---
> -	  This is a v4l2 driver for the i.MX1/i.MXL CMOS Sensor Interface
> -
>  config VIDEO_MX3
>  	tristate "i.MX3x Camera Sensor Interface driver"
>  	depends on VIDEO_DEV && MX3_IPU && SOC_CAMERA
> diff --git a/drivers/media/platform/soc_camera/Makefile b/drivers/media/platform/soc_camera/Makefile
> index 8aed26d..2826382 100644
> --- a/drivers/media/platform/soc_camera/Makefile
> +++ b/drivers/media/platform/soc_camera/Makefile
> @@ -7,7 +7,6 @@ obj-$(CONFIG_SOC_CAMERA_PLATFORM)	+= soc_camera_platform.o
>  
>  # soc-camera host drivers have to be linked after camera drivers
>  obj-$(CONFIG_VIDEO_ATMEL_ISI)		+= atmel-isi.o
> -obj-$(CONFIG_VIDEO_MX1)			+= mx1_camera.o
>  obj-$(CONFIG_VIDEO_MX2)			+= mx2_camera.o
>  obj-$(CONFIG_VIDEO_MX3)			+= mx3_camera.o
>  obj-$(CONFIG_VIDEO_OMAP1)		+= omap1_camera.o
> diff --git a/drivers/media/platform/soc_camera/mx1_camera.c b/drivers/media/platform/soc_camera/mx1_camera.c
> deleted file mode 100644
> index fea3e61..0000000
> --- a/drivers/media/platform/soc_camera/mx1_camera.c
> +++ /dev/null
> @@ -1,866 +0,0 @@
> -/*
> - * V4L2 Driver for i.MXL/i.MXL camera (CSI) host
> - *
> - * Copyright (C) 2008, Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
> - * Copyright (C) 2009, Darius Augulis <augulis.darius@gmail.com>
> - *
> - * Based on PXA SoC camera driver
> - * Copyright (C) 2006, Sascha Hauer, Pengutronix
> - * Copyright (C) 2008, Guennadi Liakhovetski <kernel@pengutronix.de>
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License version 2 as
> - * published by the Free Software Foundation.
> - */
> -
> -#include <linux/clk.h>
> -#include <linux/delay.h>
> -#include <linux/device.h>
> -#include <linux/dma-mapping.h>
> -#include <linux/errno.h>
> -#include <linux/fs.h>
> -#include <linux/init.h>
> -#include <linux/interrupt.h>
> -#include <linux/io.h>
> -#include <linux/kernel.h>
> -#include <linux/mm.h>
> -#include <linux/module.h>
> -#include <linux/moduleparam.h>
> -#include <linux/platform_device.h>
> -#include <linux/sched.h>
> -#include <linux/slab.h>
> -#include <linux/time.h>
> -#include <linux/videodev2.h>
> -
> -#include <media/soc_camera.h>
> -#include <media/v4l2-common.h>
> -#include <media/v4l2-dev.h>
> -#include <media/videobuf-dma-contig.h>
> -#include <media/soc_mediabus.h>
> -
> -#include <asm/dma.h>
> -#include <asm/fiq.h>
> -#include <mach/dma-mx1-mx2.h>
> -#include <mach/hardware.h>
> -#include <mach/irqs.h>
> -#include <linux/platform_data/camera-mx1.h>
> -
> -/*
> - * CSI registers
> - */
> -#define CSICR1		0x00			/* CSI Control Register 1 */
> -#define CSISR		0x08			/* CSI Status Register */
> -#define CSIRXR		0x10			/* CSI RxFIFO Register */
> -
> -#define CSICR1_RXFF_LEVEL(x)	(((x) & 0x3) << 19)
> -#define CSICR1_SOF_POL		(1 << 17)
> -#define CSICR1_SOF_INTEN	(1 << 16)
> -#define CSICR1_MCLKDIV(x)	(((x) & 0xf) << 12)
> -#define CSICR1_MCLKEN		(1 << 9)
> -#define CSICR1_FCC		(1 << 8)
> -#define CSICR1_BIG_ENDIAN	(1 << 7)
> -#define CSICR1_CLR_RXFIFO	(1 << 5)
> -#define CSICR1_GCLK_MODE	(1 << 4)
> -#define CSICR1_DATA_POL		(1 << 2)
> -#define CSICR1_REDGE		(1 << 1)
> -#define CSICR1_EN		(1 << 0)
> -
> -#define CSISR_SFF_OR_INT	(1 << 25)
> -#define CSISR_RFF_OR_INT	(1 << 24)
> -#define CSISR_STATFF_INT	(1 << 21)
> -#define CSISR_RXFF_INT		(1 << 18)
> -#define CSISR_SOF_INT		(1 << 16)
> -#define CSISR_DRDY		(1 << 0)
> -
> -#define DRIVER_VERSION "0.0.2"
> -#define DRIVER_NAME "mx1-camera"
> -
> -#define CSI_IRQ_MASK	(CSISR_SFF_OR_INT | CSISR_RFF_OR_INT | \
> -			CSISR_STATFF_INT | CSISR_RXFF_INT | CSISR_SOF_INT)
> -
> -#define CSI_BUS_FLAGS	(V4L2_MBUS_MASTER | V4L2_MBUS_HSYNC_ACTIVE_HIGH | \
> -			V4L2_MBUS_VSYNC_ACTIVE_HIGH | V4L2_MBUS_VSYNC_ACTIVE_LOW | \
> -			V4L2_MBUS_PCLK_SAMPLE_RISING | V4L2_MBUS_PCLK_SAMPLE_FALLING | \
> -			V4L2_MBUS_DATA_ACTIVE_HIGH | V4L2_MBUS_DATA_ACTIVE_LOW)
> -
> -#define MAX_VIDEO_MEM 16	/* Video memory limit in megabytes */
> -
> -/*
> - * Structures
> - */
> -
> -/* buffer for one video frame */
> -struct mx1_buffer {
> -	/* common v4l buffer stuff -- must be first */
> -	struct videobuf_buffer		vb;
> -	enum v4l2_mbus_pixelcode	code;
> -	int				inwork;
> -};
> -
> -/*
> - * i.MX1/i.MXL is only supposed to handle one camera on its Camera Sensor
> - * Interface. If anyone ever builds hardware to enable more than
> - * one camera, they will have to modify this driver too
> - */
> -struct mx1_camera_dev {
> -	struct soc_camera_host		soc_host;
> -	struct mx1_camera_pdata		*pdata;
> -	struct mx1_buffer		*active;
> -	struct resource			*res;
> -	struct clk			*clk;
> -	struct list_head		capture;
> -
> -	void __iomem			*base;
> -	int				dma_chan;
> -	unsigned int			irq;
> -	unsigned long			mclk;
> -
> -	spinlock_t			lock;
> -};
> -
> -/*
> - *  Videobuf operations
> - */
> -static int mx1_videobuf_setup(struct videobuf_queue *vq, unsigned int *count,
> -			      unsigned int *size)
> -{
> -	struct soc_camera_device *icd = vq->priv_data;
> -
> -	*size = icd->sizeimage;
> -
> -	if (!*count)
> -		*count = 32;
> -
> -	if (*size * *count > MAX_VIDEO_MEM * 1024 * 1024)
> -		*count = (MAX_VIDEO_MEM * 1024 * 1024) / *size;
> -
> -	dev_dbg(icd->parent, "count=%d, size=%d\n", *count, *size);
> -
> -	return 0;
> -}
> -
> -static void free_buffer(struct videobuf_queue *vq, struct mx1_buffer *buf)
> -{
> -	struct soc_camera_device *icd = vq->priv_data;
> -	struct videobuf_buffer *vb = &buf->vb;
> -
> -	BUG_ON(in_interrupt());
> -
> -	dev_dbg(icd->parent, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
> -		vb, vb->baddr, vb->bsize);
> -
> -	/*
> -	 * This waits until this buffer is out of danger, i.e., until it is no
> -	 * longer in STATE_QUEUED or STATE_ACTIVE
> -	 */
> -	videobuf_waiton(vq, vb, 0, 0);
> -	videobuf_dma_contig_free(vq, vb);
> -
> -	vb->state = VIDEOBUF_NEEDS_INIT;
> -}
> -
> -static int mx1_videobuf_prepare(struct videobuf_queue *vq,
> -		struct videobuf_buffer *vb, enum v4l2_field field)
> -{
> -	struct soc_camera_device *icd = vq->priv_data;
> -	struct mx1_buffer *buf = container_of(vb, struct mx1_buffer, vb);
> -	int ret;
> -
> -	dev_dbg(icd->parent, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
> -		vb, vb->baddr, vb->bsize);
> -
> -	/* Added list head initialization on alloc */
> -	WARN_ON(!list_empty(&vb->queue));
> -
> -	BUG_ON(NULL == icd->current_fmt);
> -
> -	/*
> -	 * I think, in buf_prepare you only have to protect global data,
> -	 * the actual buffer is yours
> -	 */
> -	buf->inwork = 1;
> -
> -	if (buf->code	!= icd->current_fmt->code ||
> -	    vb->width	!= icd->user_width ||
> -	    vb->height	!= icd->user_height ||
> -	    vb->field	!= field) {
> -		buf->code	= icd->current_fmt->code;
> -		vb->width	= icd->user_width;
> -		vb->height	= icd->user_height;
> -		vb->field	= field;
> -		vb->state	= VIDEOBUF_NEEDS_INIT;
> -	}
> -
> -	vb->size = icd->sizeimage;
> -	if (0 != vb->baddr && vb->bsize < vb->size) {
> -		ret = -EINVAL;
> -		goto out;
> -	}
> -
> -	if (vb->state == VIDEOBUF_NEEDS_INIT) {
> -		ret = videobuf_iolock(vq, vb, NULL);
> -		if (ret)
> -			goto fail;
> -
> -		vb->state = VIDEOBUF_PREPARED;
> -	}
> -
> -	buf->inwork = 0;
> -
> -	return 0;
> -
> -fail:
> -	free_buffer(vq, buf);
> -out:
> -	buf->inwork = 0;
> -	return ret;
> -}
> -
> -static int mx1_camera_setup_dma(struct mx1_camera_dev *pcdev)
> -{
> -	struct videobuf_buffer *vbuf = &pcdev->active->vb;
> -	struct device *dev = pcdev->soc_host.icd->parent;
> -	int ret;
> -
> -	if (unlikely(!pcdev->active)) {
> -		dev_err(dev, "DMA End IRQ with no active buffer\n");
> -		return -EFAULT;
> -	}
> -
> -	/* setup sg list for future DMA */
> -	ret = imx_dma_setup_single(pcdev->dma_chan,
> -		videobuf_to_dma_contig(vbuf),
> -		vbuf->size, pcdev->res->start +
> -		CSIRXR, DMA_MODE_READ);
> -	if (unlikely(ret))
> -		dev_err(dev, "Failed to setup DMA sg list\n");
> -
> -	return ret;
> -}
> -
> -/* Called under spinlock_irqsave(&pcdev->lock, ...) */
> -static void mx1_videobuf_queue(struct videobuf_queue *vq,
> -						struct videobuf_buffer *vb)
> -{
> -	struct soc_camera_device *icd = vq->priv_data;
> -	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
> -	struct mx1_camera_dev *pcdev = ici->priv;
> -	struct mx1_buffer *buf = container_of(vb, struct mx1_buffer, vb);
> -
> -	dev_dbg(icd->parent, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
> -		vb, vb->baddr, vb->bsize);
> -
> -	list_add_tail(&vb->queue, &pcdev->capture);
> -
> -	vb->state = VIDEOBUF_ACTIVE;
> -
> -	if (!pcdev->active) {
> -		pcdev->active = buf;
> -
> -		/* setup sg list for future DMA */
> -		if (!mx1_camera_setup_dma(pcdev)) {
> -			unsigned int temp;
> -			/* enable SOF irq */
> -			temp = __raw_readl(pcdev->base + CSICR1) |
> -							CSICR1_SOF_INTEN;
> -			__raw_writel(temp, pcdev->base + CSICR1);
> -		}
> -	}
> -}
> -
> -static void mx1_videobuf_release(struct videobuf_queue *vq,
> -				 struct videobuf_buffer *vb)
> -{
> -	struct mx1_buffer *buf = container_of(vb, struct mx1_buffer, vb);
> -#ifdef DEBUG
> -	struct soc_camera_device *icd = vq->priv_data;
> -	struct device *dev = icd->parent;
> -
> -	dev_dbg(dev, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
> -		vb, vb->baddr, vb->bsize);
> -
> -	switch (vb->state) {
> -	case VIDEOBUF_ACTIVE:
> -		dev_dbg(dev, "%s (active)\n", __func__);
> -		break;
> -	case VIDEOBUF_QUEUED:
> -		dev_dbg(dev, "%s (queued)\n", __func__);
> -		break;
> -	case VIDEOBUF_PREPARED:
> -		dev_dbg(dev, "%s (prepared)\n", __func__);
> -		break;
> -	default:
> -		dev_dbg(dev, "%s (unknown)\n", __func__);
> -		break;
> -	}
> -#endif
> -
> -	free_buffer(vq, buf);
> -}
> -
> -static void mx1_camera_wakeup(struct mx1_camera_dev *pcdev,
> -			      struct videobuf_buffer *vb,
> -			      struct mx1_buffer *buf)
> -{
> -	/* _init is used to debug races, see comment in mx1_camera_reqbufs() */
> -	list_del_init(&vb->queue);
> -	vb->state = VIDEOBUF_DONE;
> -	v4l2_get_timestamp(&vb->ts);
> -	vb->field_count++;
> -	wake_up(&vb->done);
> -
> -	if (list_empty(&pcdev->capture)) {
> -		pcdev->active = NULL;
> -		return;
> -	}
> -
> -	pcdev->active = list_entry(pcdev->capture.next,
> -				   struct mx1_buffer, vb.queue);
> -
> -	/* setup sg list for future DMA */
> -	if (likely(!mx1_camera_setup_dma(pcdev))) {
> -		unsigned int temp;
> -
> -		/* enable SOF irq */
> -		temp = __raw_readl(pcdev->base + CSICR1) | CSICR1_SOF_INTEN;
> -		__raw_writel(temp, pcdev->base + CSICR1);
> -	}
> -}
> -
> -static void mx1_camera_dma_irq(int channel, void *data)
> -{
> -	struct mx1_camera_dev *pcdev = data;
> -	struct device *dev = pcdev->soc_host.icd->parent;
> -	struct mx1_buffer *buf;
> -	struct videobuf_buffer *vb;
> -	unsigned long flags;
> -
> -	spin_lock_irqsave(&pcdev->lock, flags);
> -
> -	imx_dma_disable(channel);
> -
> -	if (unlikely(!pcdev->active)) {
> -		dev_err(dev, "DMA End IRQ with no active buffer\n");
> -		goto out;
> -	}
> -
> -	vb = &pcdev->active->vb;
> -	buf = container_of(vb, struct mx1_buffer, vb);
> -	WARN_ON(buf->inwork || list_empty(&vb->queue));
> -	dev_dbg(dev, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
> -		vb, vb->baddr, vb->bsize);
> -
> -	mx1_camera_wakeup(pcdev, vb, buf);
> -out:
> -	spin_unlock_irqrestore(&pcdev->lock, flags);
> -}
> -
> -static struct videobuf_queue_ops mx1_videobuf_ops = {
> -	.buf_setup	= mx1_videobuf_setup,
> -	.buf_prepare	= mx1_videobuf_prepare,
> -	.buf_queue	= mx1_videobuf_queue,
> -	.buf_release	= mx1_videobuf_release,
> -};
> -
> -static void mx1_camera_init_videobuf(struct videobuf_queue *q,
> -				     struct soc_camera_device *icd)
> -{
> -	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
> -	struct mx1_camera_dev *pcdev = ici->priv;
> -
> -	videobuf_queue_dma_contig_init(q, &mx1_videobuf_ops, icd->parent,
> -				&pcdev->lock, V4L2_BUF_TYPE_VIDEO_CAPTURE,
> -				V4L2_FIELD_NONE,
> -				sizeof(struct mx1_buffer), icd, &ici->host_lock);
> -}
> -
> -static int mclk_get_divisor(struct mx1_camera_dev *pcdev)
> -{
> -	unsigned int mclk = pcdev->mclk;
> -	unsigned long div;
> -	unsigned long lcdclk;
> -
> -	lcdclk = clk_get_rate(pcdev->clk);
> -
> -	/*
> -	 * We verify platform_mclk_10khz != 0, so if anyone breaks it, here
> -	 * they get a nice Oops
> -	 */
> -	div = (lcdclk + 2 * mclk - 1) / (2 * mclk) - 1;
> -
> -	dev_dbg(pcdev->soc_host.icd->parent,
> -		"System clock %lukHz, target freq %dkHz, divisor %lu\n",
> -		lcdclk / 1000, mclk / 1000, div);
> -
> -	return div;
> -}
> -
> -static void mx1_camera_activate(struct mx1_camera_dev *pcdev)
> -{
> -	unsigned int csicr1 = CSICR1_EN;
> -
> -	dev_dbg(pcdev->soc_host.v4l2_dev.dev, "Activate device\n");
> -
> -	clk_prepare_enable(pcdev->clk);
> -
> -	/* enable CSI before doing anything else */
> -	__raw_writel(csicr1, pcdev->base + CSICR1);
> -
> -	csicr1 |= CSICR1_MCLKEN | CSICR1_FCC | CSICR1_GCLK_MODE;
> -	csicr1 |= CSICR1_MCLKDIV(mclk_get_divisor(pcdev));
> -	csicr1 |= CSICR1_RXFF_LEVEL(2); /* 16 words */
> -
> -	__raw_writel(csicr1, pcdev->base + CSICR1);
> -}
> -
> -static void mx1_camera_deactivate(struct mx1_camera_dev *pcdev)
> -{
> -	dev_dbg(pcdev->soc_host.v4l2_dev.dev, "Deactivate device\n");
> -
> -	/* Disable all CSI interface */
> -	__raw_writel(0x00, pcdev->base + CSICR1);
> -
> -	clk_disable_unprepare(pcdev->clk);
> -}
> -
> -static int mx1_camera_add_device(struct soc_camera_device *icd)
> -{
> -	dev_info(icd->parent, "MX1 Camera driver attached to camera %d\n",
> -		 icd->devnum);
> -
> -	return 0;
> -}
> -
> -static void mx1_camera_remove_device(struct soc_camera_device *icd)
> -{
> -	dev_info(icd->parent, "MX1 Camera driver detached from camera %d\n",
> -		 icd->devnum);
> -}
> -
> -/*
> - * The following two functions absolutely depend on the fact, that
> - * there can be only one camera on i.MX1/i.MXL camera sensor interface
> - */
> -static int mx1_camera_clock_start(struct soc_camera_host *ici)
> -{
> -	struct mx1_camera_dev *pcdev = ici->priv;
> -
> -	mx1_camera_activate(pcdev);
> -
> -	return 0;
> -}
> -
> -static void mx1_camera_clock_stop(struct soc_camera_host *ici)
> -{
> -	struct mx1_camera_dev *pcdev = ici->priv;
> -	unsigned int csicr1;
> -
> -	/* disable interrupts */
> -	csicr1 = __raw_readl(pcdev->base + CSICR1) & ~CSI_IRQ_MASK;
> -	__raw_writel(csicr1, pcdev->base + CSICR1);
> -
> -	/* Stop DMA engine */
> -	imx_dma_disable(pcdev->dma_chan);
> -
> -	mx1_camera_deactivate(pcdev);
> -}
> -
> -static int mx1_camera_set_bus_param(struct soc_camera_device *icd)
> -{
> -	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
> -	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
> -	struct mx1_camera_dev *pcdev = ici->priv;
> -	struct v4l2_mbus_config cfg = {.type = V4L2_MBUS_PARALLEL,};
> -	unsigned long common_flags;
> -	unsigned int csicr1;
> -	int ret;
> -
> -	/* MX1 supports only 8bit buswidth */
> -	ret = v4l2_subdev_call(sd, video, g_mbus_config, &cfg);
> -	if (!ret) {
> -		common_flags = soc_mbus_config_compatible(&cfg, CSI_BUS_FLAGS);
> -		if (!common_flags) {
> -			dev_warn(icd->parent,
> -				 "Flags incompatible: camera 0x%x, host 0x%x\n",
> -				 cfg.flags, CSI_BUS_FLAGS);
> -			return -EINVAL;
> -		}
> -	} else if (ret != -ENOIOCTLCMD) {
> -		return ret;
> -	} else {
> -		common_flags = CSI_BUS_FLAGS;
> -	}
> -
> -	/* Make choises, based on platform choice */
> -	if ((common_flags & V4L2_MBUS_VSYNC_ACTIVE_HIGH) &&
> -		(common_flags & V4L2_MBUS_VSYNC_ACTIVE_LOW)) {
> -			if (!pcdev->pdata ||
> -			     pcdev->pdata->flags & MX1_CAMERA_VSYNC_HIGH)
> -				common_flags &= ~V4L2_MBUS_VSYNC_ACTIVE_LOW;
> -			else
> -				common_flags &= ~V4L2_MBUS_VSYNC_ACTIVE_HIGH;
> -	}
> -
> -	if ((common_flags & V4L2_MBUS_PCLK_SAMPLE_RISING) &&
> -		(common_flags & V4L2_MBUS_PCLK_SAMPLE_FALLING)) {
> -			if (!pcdev->pdata ||
> -			     pcdev->pdata->flags & MX1_CAMERA_PCLK_RISING)
> -				common_flags &= ~V4L2_MBUS_PCLK_SAMPLE_FALLING;
> -			else
> -				common_flags &= ~V4L2_MBUS_PCLK_SAMPLE_RISING;
> -	}
> -
> -	if ((common_flags & V4L2_MBUS_DATA_ACTIVE_HIGH) &&
> -		(common_flags & V4L2_MBUS_DATA_ACTIVE_LOW)) {
> -			if (!pcdev->pdata ||
> -			     pcdev->pdata->flags & MX1_CAMERA_DATA_HIGH)
> -				common_flags &= ~V4L2_MBUS_DATA_ACTIVE_LOW;
> -			else
> -				common_flags &= ~V4L2_MBUS_DATA_ACTIVE_HIGH;
> -	}
> -
> -	cfg.flags = common_flags;
> -	ret = v4l2_subdev_call(sd, video, s_mbus_config, &cfg);
> -	if (ret < 0 && ret != -ENOIOCTLCMD) {
> -		dev_dbg(icd->parent, "camera s_mbus_config(0x%lx) returned %d\n",
> -			common_flags, ret);
> -		return ret;
> -	}
> -
> -	csicr1 = __raw_readl(pcdev->base + CSICR1);
> -
> -	if (common_flags & V4L2_MBUS_PCLK_SAMPLE_RISING)
> -		csicr1 |= CSICR1_REDGE;
> -	if (common_flags & V4L2_MBUS_VSYNC_ACTIVE_HIGH)
> -		csicr1 |= CSICR1_SOF_POL;
> -	if (common_flags & V4L2_MBUS_DATA_ACTIVE_LOW)
> -		csicr1 |= CSICR1_DATA_POL;
> -
> -	__raw_writel(csicr1, pcdev->base + CSICR1);
> -
> -	return 0;
> -}
> -
> -static int mx1_camera_set_fmt(struct soc_camera_device *icd,
> -			      struct v4l2_format *f)
> -{
> -	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
> -	const struct soc_camera_format_xlate *xlate;
> -	struct v4l2_pix_format *pix = &f->fmt.pix;
> -	struct v4l2_mbus_framefmt mf;
> -	int ret, buswidth;
> -
> -	xlate = soc_camera_xlate_by_fourcc(icd, pix->pixelformat);
> -	if (!xlate) {
> -		dev_warn(icd->parent, "Format %x not found\n",
> -			 pix->pixelformat);
> -		return -EINVAL;
> -	}
> -
> -	buswidth = xlate->host_fmt->bits_per_sample;
> -	if (buswidth > 8) {
> -		dev_warn(icd->parent,
> -			 "bits-per-sample %d for format %x unsupported\n",
> -			 buswidth, pix->pixelformat);
> -		return -EINVAL;
> -	}
> -
> -	mf.width	= pix->width;
> -	mf.height	= pix->height;
> -	mf.field	= pix->field;
> -	mf.colorspace	= pix->colorspace;
> -	mf.code		= xlate->code;
> -
> -	ret = v4l2_subdev_call(sd, video, s_mbus_fmt, &mf);
> -	if (ret < 0)
> -		return ret;
> -
> -	if (mf.code != xlate->code)
> -		return -EINVAL;
> -
> -	pix->width		= mf.width;
> -	pix->height		= mf.height;
> -	pix->field		= mf.field;
> -	pix->colorspace		= mf.colorspace;
> -	icd->current_fmt	= xlate;
> -
> -	return ret;
> -}
> -
> -static int mx1_camera_try_fmt(struct soc_camera_device *icd,
> -			      struct v4l2_format *f)
> -{
> -	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
> -	const struct soc_camera_format_xlate *xlate;
> -	struct v4l2_pix_format *pix = &f->fmt.pix;
> -	struct v4l2_mbus_framefmt mf;
> -	int ret;
> -	/* TODO: limit to mx1 hardware capabilities */
> -
> -	xlate = soc_camera_xlate_by_fourcc(icd, pix->pixelformat);
> -	if (!xlate) {
> -		dev_warn(icd->parent, "Format %x not found\n",
> -			 pix->pixelformat);
> -		return -EINVAL;
> -	}
> -
> -	mf.width	= pix->width;
> -	mf.height	= pix->height;
> -	mf.field	= pix->field;
> -	mf.colorspace	= pix->colorspace;
> -	mf.code		= xlate->code;
> -
> -	/* limit to sensor capabilities */
> -	ret = v4l2_subdev_call(sd, video, try_mbus_fmt, &mf);
> -	if (ret < 0)
> -		return ret;
> -
> -	pix->width	= mf.width;
> -	pix->height	= mf.height;
> -	pix->field	= mf.field;
> -	pix->colorspace	= mf.colorspace;
> -
> -	return 0;
> -}
> -
> -static int mx1_camera_reqbufs(struct soc_camera_device *icd,
> -			      struct v4l2_requestbuffers *p)
> -{
> -	int i;
> -
> -	/*
> -	 * This is for locking debugging only. I removed spinlocks and now I
> -	 * check whether .prepare is ever called on a linked buffer, or whether
> -	 * a dma IRQ can occur for an in-work or unlinked buffer. Until now
> -	 * it hadn't triggered
> -	 */
> -	for (i = 0; i < p->count; i++) {
> -		struct mx1_buffer *buf = container_of(icd->vb_vidq.bufs[i],
> -						      struct mx1_buffer, vb);
> -		buf->inwork = 0;
> -		INIT_LIST_HEAD(&buf->vb.queue);
> -	}
> -
> -	return 0;
> -}
> -
> -static unsigned int mx1_camera_poll(struct file *file, poll_table *pt)
> -{
> -	struct soc_camera_device *icd = file->private_data;
> -	struct mx1_buffer *buf;
> -
> -	buf = list_entry(icd->vb_vidq.stream.next, struct mx1_buffer,
> -			 vb.stream);
> -
> -	poll_wait(file, &buf->vb.done, pt);
> -
> -	if (buf->vb.state == VIDEOBUF_DONE ||
> -	    buf->vb.state == VIDEOBUF_ERROR)
> -		return POLLIN | POLLRDNORM;
> -
> -	return 0;
> -}
> -
> -static int mx1_camera_querycap(struct soc_camera_host *ici,
> -			       struct v4l2_capability *cap)
> -{
> -	/* cap->name is set by the friendly caller:-> */
> -	strlcpy(cap->card, "i.MX1/i.MXL Camera", sizeof(cap->card));
> -	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
> -
> -	return 0;
> -}
> -
> -static struct soc_camera_host_ops mx1_soc_camera_host_ops = {
> -	.owner		= THIS_MODULE,
> -	.add		= mx1_camera_add_device,
> -	.remove		= mx1_camera_remove_device,
> -	.clock_start	= mx1_camera_clock_start,
> -	.clock_stop	= mx1_camera_clock_stop,
> -	.set_bus_param	= mx1_camera_set_bus_param,
> -	.set_fmt	= mx1_camera_set_fmt,
> -	.try_fmt	= mx1_camera_try_fmt,
> -	.init_videobuf	= mx1_camera_init_videobuf,
> -	.reqbufs	= mx1_camera_reqbufs,
> -	.poll		= mx1_camera_poll,
> -	.querycap	= mx1_camera_querycap,
> -};
> -
> -static struct fiq_handler fh = {
> -	.name		= "csi_sof"
> -};
> -
> -static int __init mx1_camera_probe(struct platform_device *pdev)
> -{
> -	struct mx1_camera_dev *pcdev;
> -	struct resource *res;
> -	struct pt_regs regs;
> -	struct clk *clk;
> -	void __iomem *base;
> -	unsigned int irq;
> -	int err = 0;
> -
> -	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	irq = platform_get_irq(pdev, 0);
> -	if (!res || (int)irq <= 0) {
> -		err = -ENODEV;
> -		goto exit;
> -	}
> -
> -	clk = clk_get(&pdev->dev, "csi_clk");
> -	if (IS_ERR(clk)) {
> -		err = PTR_ERR(clk);
> -		goto exit;
> -	}
> -
> -	pcdev = kzalloc(sizeof(*pcdev), GFP_KERNEL);
> -	if (!pcdev) {
> -		dev_err(&pdev->dev, "Could not allocate pcdev\n");
> -		err = -ENOMEM;
> -		goto exit_put_clk;
> -	}
> -
> -	pcdev->res = res;
> -	pcdev->clk = clk;
> -
> -	pcdev->pdata = pdev->dev.platform_data;
> -
> -	if (pcdev->pdata)
> -		pcdev->mclk = pcdev->pdata->mclk_10khz * 10000;
> -
> -	if (!pcdev->mclk) {
> -		dev_warn(&pdev->dev,
> -			 "mclk_10khz == 0! Please, fix your platform data. "
> -			 "Using default 20MHz\n");
> -		pcdev->mclk = 20000000;
> -	}
> -
> -	INIT_LIST_HEAD(&pcdev->capture);
> -	spin_lock_init(&pcdev->lock);
> -
> -	/*
> -	 * Request the regions.
> -	 */
> -	if (!request_mem_region(res->start, resource_size(res), DRIVER_NAME)) {
> -		err = -EBUSY;
> -		goto exit_kfree;
> -	}
> -
> -	base = ioremap(res->start, resource_size(res));
> -	if (!base) {
> -		err = -ENOMEM;
> -		goto exit_release;
> -	}
> -	pcdev->irq = irq;
> -	pcdev->base = base;
> -
> -	/* request dma */
> -	pcdev->dma_chan = imx_dma_request_by_prio(DRIVER_NAME, DMA_PRIO_HIGH);
> -	if (pcdev->dma_chan < 0) {
> -		dev_err(&pdev->dev, "Can't request DMA for MX1 CSI\n");
> -		err = -EBUSY;
> -		goto exit_iounmap;
> -	}
> -	dev_dbg(&pdev->dev, "got DMA channel %d\n", pcdev->dma_chan);
> -
> -	imx_dma_setup_handlers(pcdev->dma_chan, mx1_camera_dma_irq, NULL,
> -			       pcdev);
> -
> -	imx_dma_config_channel(pcdev->dma_chan, IMX_DMA_TYPE_FIFO,
> -			       IMX_DMA_MEMSIZE_32, MX1_DMA_REQ_CSI_R, 0);
> -	/* burst length : 16 words = 64 bytes */
> -	imx_dma_config_burstlen(pcdev->dma_chan, 0);
> -
> -	/* request irq */
> -	err = claim_fiq(&fh);
> -	if (err) {
> -		dev_err(&pdev->dev, "Camera interrupt register failed\n");
> -		goto exit_free_dma;
> -	}
> -
> -	set_fiq_handler(&mx1_camera_sof_fiq_start, &mx1_camera_sof_fiq_end -
> -						   &mx1_camera_sof_fiq_start);
> -
> -	regs.ARM_r8 = (long)MX1_DMA_DIMR;
> -	regs.ARM_r9 = (long)MX1_DMA_CCR(pcdev->dma_chan);
> -	regs.ARM_r10 = (long)pcdev->base + CSICR1;
> -	regs.ARM_fp = (long)pcdev->base + CSISR;
> -	regs.ARM_sp = 1 << pcdev->dma_chan;
> -	set_fiq_regs(&regs);
> -
> -	mxc_set_irq_fiq(irq, 1);
> -	enable_fiq(irq);
> -
> -	pcdev->soc_host.drv_name	= DRIVER_NAME;
> -	pcdev->soc_host.ops		= &mx1_soc_camera_host_ops;
> -	pcdev->soc_host.priv		= pcdev;
> -	pcdev->soc_host.v4l2_dev.dev	= &pdev->dev;
> -	pcdev->soc_host.nr		= pdev->id;
> -	err = soc_camera_host_register(&pcdev->soc_host);
> -	if (err)
> -		goto exit_free_irq;
> -
> -	dev_info(&pdev->dev, "MX1 Camera driver loaded\n");
> -
> -	return 0;
> -
> -exit_free_irq:
> -	disable_fiq(irq);
> -	mxc_set_irq_fiq(irq, 0);
> -	release_fiq(&fh);
> -exit_free_dma:
> -	imx_dma_free(pcdev->dma_chan);
> -exit_iounmap:
> -	iounmap(base);
> -exit_release:
> -	release_mem_region(res->start, resource_size(res));
> -exit_kfree:
> -	kfree(pcdev);
> -exit_put_clk:
> -	clk_put(clk);
> -exit:
> -	return err;
> -}
> -
> -static int __exit mx1_camera_remove(struct platform_device *pdev)
> -{
> -	struct soc_camera_host *soc_host = to_soc_camera_host(&pdev->dev);
> -	struct mx1_camera_dev *pcdev = container_of(soc_host,
> -					struct mx1_camera_dev, soc_host);
> -	struct resource *res;
> -
> -	imx_dma_free(pcdev->dma_chan);
> -	disable_fiq(pcdev->irq);
> -	mxc_set_irq_fiq(pcdev->irq, 0);
> -	release_fiq(&fh);
> -
> -	clk_put(pcdev->clk);
> -
> -	soc_camera_host_unregister(soc_host);
> -
> -	iounmap(pcdev->base);
> -
> -	res = pcdev->res;
> -	release_mem_region(res->start, resource_size(res));
> -
> -	kfree(pcdev);
> -
> -	dev_info(&pdev->dev, "MX1 Camera driver unloaded\n");
> -
> -	return 0;
> -}
> -
> -static struct platform_driver mx1_camera_driver = {
> -	.driver		= {
> -		.name	= DRIVER_NAME,
> -	},
> -	.remove		= __exit_p(mx1_camera_remove),
> -};
> -
> -module_platform_driver_probe(mx1_camera_driver, mx1_camera_probe);
> -
> -MODULE_DESCRIPTION("i.MX1/i.MXL SoC Camera Host driver");
> -MODULE_AUTHOR("Paulius Zaleckas <paulius.zaleckas@teltonika.lt>");
> -MODULE_LICENSE("GPL v2");
> -MODULE_VERSION(DRIVER_VERSION);
> -MODULE_ALIAS("platform:" DRIVER_NAME);
> diff --git a/include/linux/platform_data/camera-mx1.h b/include/linux/platform_data/camera-mx1.h
> deleted file mode 100644
> index 4fd6c70..0000000
> --- a/include/linux/platform_data/camera-mx1.h
> +++ /dev/null
> @@ -1,35 +0,0 @@
> -/*
> - * mx1_camera.h - i.MX1/i.MXL camera driver header file
> - *
> - * Copyright (c) 2008, Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
> - * Copyright (C) 2009, Darius Augulis <augulis.darius@gmail.com>
> - *
> - * Based on PXA camera.h file:
> - * Copyright (C) 2003, Intel Corporation
> - * Copyright (C) 2008, Guennadi Liakhovetski <kernel@pengutronix.de>
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License version 2 as
> - * published by the Free Software Foundation.
> - */
> -
> -#ifndef __ASM_ARCH_CAMERA_H_
> -#define __ASM_ARCH_CAMERA_H_
> -
> -#define MX1_CAMERA_DATA_HIGH	1
> -#define MX1_CAMERA_PCLK_RISING	2
> -#define MX1_CAMERA_VSYNC_HIGH	4
> -
> -extern unsigned char mx1_camera_sof_fiq_start, mx1_camera_sof_fiq_end;
> -
> -/**
> - * struct mx1_camera_pdata - i.MX1/i.MXL camera platform data
> - * @mclk_10khz:	master clock frequency in 10kHz units
> - * @flags:	MX1 camera platform flags
> - */
> -struct mx1_camera_pdata {
> -	unsigned long mclk_10khz;
> -	unsigned long flags;
> -};
> -
> -#endif /* __ASM_ARCH_CAMERA_H_ */
> 

