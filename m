Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:37153 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374AbcGLXCV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jul 2016 19:02:21 -0400
Date: Tue, 12 Jul 2016 20:02:02 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Inki Dae <inki.dae@samsung.com>,
	Joonyoung Shim <jy0922.shim@samsung.com>,
	Seung-Woo Kim <sw0312.kim@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	David Airlie <airlied@linux.ie>, Kukjin Kim <kgene@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Kamil Debski <k.debski@samsung.com>
Subject: Re: [PATCH 2/2] [media] s5p-g2d: Replace old driver with DRM
 version
Message-ID: <20160712200202.7496445e@recife.lan>
In-Reply-To: <1464096493-13378-2-git-send-email-k.kozlowski@samsung.com>
References: <1464096493-13378-1-git-send-email-k.kozlowski@samsung.com>
	<1464096493-13378-2-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I suspect that you'll be applying this one via DRM tree, so:

Em Tue, 24 May 2016 15:28:13 +0200
Krzysztof Kozlowski <k.kozlowski@samsung.com> escreveu:

> Remove the old non-DRM driver because it is now entirely supported by
> exynos_drm_g2d driver.
> 
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Kamil Debski <k.debski@samsung.com>
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Acked-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

PS.: If you prefer to apply this one via my tree, I'm ok too. Just
let me know when the first patch gets merged upstream.

Regards,
Mauro

> ---
>  MAINTAINERS                               |   8 -
>  drivers/gpu/drm/exynos/Kconfig            |   1 -
>  drivers/media/platform/Kconfig            |  12 -
>  drivers/media/platform/Makefile           |   1 -
>  drivers/media/platform/s5p-g2d/Makefile   |   3 -
>  drivers/media/platform/s5p-g2d/g2d-hw.c   | 117 -----
>  drivers/media/platform/s5p-g2d/g2d-regs.h | 122 -----
>  drivers/media/platform/s5p-g2d/g2d.c      | 800 ------------------------------
>  drivers/media/platform/s5p-g2d/g2d.h      |  91 ----
>  9 files changed, 1155 deletions(-)
>  delete mode 100644 drivers/media/platform/s5p-g2d/Makefile
>  delete mode 100644 drivers/media/platform/s5p-g2d/g2d-hw.c
>  delete mode 100644 drivers/media/platform/s5p-g2d/g2d-regs.h
>  delete mode 100644 drivers/media/platform/s5p-g2d/g2d.c
>  delete mode 100644 drivers/media/platform/s5p-g2d/g2d.h
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 243c0811a4d8..01763419c6a1 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1616,14 +1616,6 @@ L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
>  S:	Maintained
>  F:	arch/arm/mach-s5pv210/
>  
> -ARM/SAMSUNG S5P SERIES 2D GRAPHICS ACCELERATION (G2D) SUPPORT
> -M:	Kyungmin Park <kyungmin.park@samsung.com>
> -M:	Kamil Debski <k.debski@samsung.com>
> -L:	linux-arm-kernel@lists.infradead.org
> -L:	linux-media@vger.kernel.org
> -S:	Maintained
> -F:	drivers/media/platform/s5p-g2d/
> -
>  ARM/SAMSUNG S5P SERIES Multi Format Codec (MFC) SUPPORT
>  M:	Kyungmin Park <kyungmin.park@samsung.com>
>  M:	Kamil Debski <k.debski@samsung.com>
> diff --git a/drivers/gpu/drm/exynos/Kconfig b/drivers/gpu/drm/exynos/Kconfig
> index d814b3048ee5..b0eb20ba1b28 100644
> --- a/drivers/gpu/drm/exynos/Kconfig
> +++ b/drivers/gpu/drm/exynos/Kconfig
> @@ -95,7 +95,6 @@ comment "Sub-drivers"
>  
>  config DRM_EXYNOS_G2D
>  	bool "G2D"
> -	depends on VIDEO_SAMSUNG_S5P_G2D=n
>  	select FRAME_VECTOR
>  	help
>  	  Choose this option if you want to use Exynos G2D for DRM.
> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> index 84e041c0a70e..171005c53d62 100644
> --- a/drivers/media/platform/Kconfig
> +++ b/drivers/media/platform/Kconfig
> @@ -161,18 +161,6 @@ config VIDEO_MEM2MEM_DEINTERLACE
>  	help
>  	    Generic deinterlacing V4L2 driver.
>  
> -config VIDEO_SAMSUNG_S5P_G2D
> -	tristate "Samsung S5P and EXYNOS4 G2D 2d graphics accelerator driver"
> -	depends on VIDEO_DEV && VIDEO_V4L2
> -	depends on ARCH_S5PV210 || ARCH_EXYNOS || COMPILE_TEST
> -	depends on HAS_DMA
> -	select VIDEOBUF2_DMA_CONTIG
> -	select V4L2_MEM2MEM_DEV
> -	default n
> -	---help---
> -	  This is a v4l2 driver for Samsung S5P and EXYNOS4 G2D
> -	  2d graphics accelerator.
> -
>  config VIDEO_SAMSUNG_S5P_JPEG
>  	tristate "Samsung S5P/Exynos3250/Exynos4 JPEG codec driver"
>  	depends on VIDEO_DEV && VIDEO_V4L2
> diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
> index bbb7bd1eb268..ad5e26a0bd17 100644
> --- a/drivers/media/platform/Makefile
> +++ b/drivers/media/platform/Makefile
> @@ -32,7 +32,6 @@ obj-$(CONFIG_VIDEO_SAMSUNG_S5P_JPEG)	+= s5p-jpeg/
>  obj-$(CONFIG_VIDEO_SAMSUNG_S5P_MFC)	+= s5p-mfc/
>  obj-$(CONFIG_VIDEO_SAMSUNG_S5P_TV)	+= s5p-tv/
>  
> -obj-$(CONFIG_VIDEO_SAMSUNG_S5P_G2D)	+= s5p-g2d/
>  obj-$(CONFIG_VIDEO_SAMSUNG_EXYNOS_GSC)	+= exynos-gsc/
>  
>  obj-$(CONFIG_VIDEO_STI_BDISP)		+= sti/bdisp/
> diff --git a/drivers/media/platform/s5p-g2d/Makefile b/drivers/media/platform/s5p-g2d/Makefile
> deleted file mode 100644
> index 2c48c416a804..000000000000
> --- a/drivers/media/platform/s5p-g2d/Makefile
> +++ /dev/null
> @@ -1,3 +0,0 @@
> -s5p-g2d-objs := g2d.o g2d-hw.o
> -
> -obj-$(CONFIG_VIDEO_SAMSUNG_S5P_G2D)	+= s5p-g2d.o
> diff --git a/drivers/media/platform/s5p-g2d/g2d-hw.c b/drivers/media/platform/s5p-g2d/g2d-hw.c
> deleted file mode 100644
> index e87bd93811d4..000000000000
> --- a/drivers/media/platform/s5p-g2d/g2d-hw.c
> +++ /dev/null
> @@ -1,117 +0,0 @@
> -/*
> - * Samsung S5P G2D - 2D Graphics Accelerator Driver
> - *
> - * Copyright (c) 2011 Samsung Electronics Co., Ltd.
> - * Kamil Debski, <k.debski@samsung.com>
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by the
> - * Free Software Foundation; either version 2 of the
> - * License, or (at your option) any later version
> - */
> -
> -#include <linux/io.h>
> -
> -#include "g2d.h"
> -#include "g2d-regs.h"
> -
> -#define w(x, a)	writel((x), d->regs + (a))
> -#define r(a)	readl(d->regs + (a))
> -
> -/* g2d_reset clears all g2d registers */
> -void g2d_reset(struct g2d_dev *d)
> -{
> -	w(1, SOFT_RESET_REG);
> -}
> -
> -void g2d_set_src_size(struct g2d_dev *d, struct g2d_frame *f)
> -{
> -	u32 n;
> -
> -	w(0, SRC_SELECT_REG);
> -	w(f->stride & 0xFFFF, SRC_STRIDE_REG);
> -
> -	n = f->o_height & 0xFFF;
> -	n <<= 16;
> -	n |= f->o_width & 0xFFF;
> -	w(n, SRC_LEFT_TOP_REG);
> -
> -	n = f->bottom & 0xFFF;
> -	n <<= 16;
> -	n |= f->right & 0xFFF;
> -	w(n, SRC_RIGHT_BOTTOM_REG);
> -
> -	w(f->fmt->hw, SRC_COLOR_MODE_REG);
> -}
> -
> -void g2d_set_src_addr(struct g2d_dev *d, dma_addr_t a)
> -{
> -	w(a, SRC_BASE_ADDR_REG);
> -}
> -
> -void g2d_set_dst_size(struct g2d_dev *d, struct g2d_frame *f)
> -{
> -	u32 n;
> -
> -	w(0, DST_SELECT_REG);
> -	w(f->stride & 0xFFFF, DST_STRIDE_REG);
> -
> -	n = f->o_height & 0xFFF;
> -	n <<= 16;
> -	n |= f->o_width & 0xFFF;
> -	w(n, DST_LEFT_TOP_REG);
> -
> -	n = f->bottom & 0xFFF;
> -	n <<= 16;
> -	n |= f->right & 0xFFF;
> -	w(n, DST_RIGHT_BOTTOM_REG);
> -
> -	w(f->fmt->hw, DST_COLOR_MODE_REG);
> -}
> -
> -void g2d_set_dst_addr(struct g2d_dev *d, dma_addr_t a)
> -{
> -	w(a, DST_BASE_ADDR_REG);
> -}
> -
> -void g2d_set_rop4(struct g2d_dev *d, u32 r)
> -{
> -	w(r, ROP4_REG);
> -}
> -
> -void g2d_set_flip(struct g2d_dev *d, u32 r)
> -{
> -	w(r, SRC_MSK_DIRECT_REG);
> -}
> -
> -void g2d_set_v41_stretch(struct g2d_dev *d, struct g2d_frame *src,
> -					struct g2d_frame *dst)
> -{
> -	w(DEFAULT_SCALE_MODE, SRC_SCALE_CTRL_REG);
> -
> -	/* inversed scaling factor: src is numerator */
> -	w((src->c_width << 16) / dst->c_width, SRC_XSCALE_REG);
> -	w((src->c_height << 16) / dst->c_height, SRC_YSCALE_REG);
> -}
> -
> -void g2d_set_cmd(struct g2d_dev *d, u32 c)
> -{
> -	w(c, BITBLT_COMMAND_REG);
> -}
> -
> -void g2d_start(struct g2d_dev *d)
> -{
> -	/* Clear cache */
> -	if (d->variant->hw_rev == TYPE_G2D_3X)
> -		w(0x7, CACHECTL_REG);
> -
> -	/* Enable interrupt */
> -	w(1, INTEN_REG);
> -	/* Start G2D engine */
> -	w(1, BITBLT_START_REG);
> -}
> -
> -void g2d_clear_int(struct g2d_dev *d)
> -{
> -	w(1, INTC_PEND_REG);
> -}
> diff --git a/drivers/media/platform/s5p-g2d/g2d-regs.h b/drivers/media/platform/s5p-g2d/g2d-regs.h
> deleted file mode 100644
> index 9bf31ad35d47..000000000000
> --- a/drivers/media/platform/s5p-g2d/g2d-regs.h
> +++ /dev/null
> @@ -1,122 +0,0 @@
> -/*
> - * Samsung S5P G2D - 2D Graphics Accelerator Driver
> - *
> - * Copyright (c) 2011 Samsung Electronics Co., Ltd.
> - * Kamil Debski, <k.debski@samsung.com>
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by the
> - * Free Software Foundation; either version 2 of the
> - * License, or (at your option) any later version
> - */
> -
> -/* General Registers */
> -#define SOFT_RESET_REG		0x0000	/* Software reset reg */
> -#define INTEN_REG		0x0004	/* Interrupt Enable reg */
> -#define INTC_PEND_REG		0x000C	/* Interrupt Control Pending reg */
> -#define FIFO_STAT_REG		0x0010	/* Command FIFO Status reg */
> -#define AXI_ID_MODE_REG		0x0014	/* AXI Read ID Mode reg */
> -#define CACHECTL_REG		0x0018	/* Cache & Buffer clear reg */
> -#define AXI_MODE_REG		0x001C	/* AXI Mode reg */
> -
> -/* Command Registers */
> -#define BITBLT_START_REG	0x0100	/* BitBLT Start reg */
> -#define BITBLT_COMMAND_REG	0x0104	/* Command reg for BitBLT */
> -
> -/* Parameter Setting Registers (Rotate & Direction) */
> -#define ROTATE_REG		0x0200	/* Rotation reg */
> -#define SRC_MSK_DIRECT_REG	0x0204	/* Src and Mask Direction reg */
> -#define DST_PAT_DIRECT_REG	0x0208	/* Dest and Pattern Direction reg */
> -
> -/* Parameter Setting Registers (Src) */
> -#define SRC_SELECT_REG		0x0300	/* Src Image Selection reg */
> -#define SRC_BASE_ADDR_REG	0x0304	/* Src Image Base Address reg */
> -#define SRC_STRIDE_REG		0x0308	/* Src Stride reg */
> -#define SRC_COLOR_MODE_REG	0x030C	/* Src Image Color Mode reg */
> -#define SRC_LEFT_TOP_REG	0x0310	/* Src Left Top Coordinate reg */
> -#define SRC_RIGHT_BOTTOM_REG	0x0314	/* Src Right Bottom Coordinate reg */
> -#define SRC_SCALE_CTRL_REG	0x0328	/* Src Scaling type select */
> -#define SRC_XSCALE_REG		0x032c	/* Src X Scaling ratio */
> -#define SRC_YSCALE_REG		0x0330	/* Src Y Scaling ratio */
> -
> -/* Parameter Setting Registers (Dest) */
> -#define DST_SELECT_REG		0x0400	/* Dest Image Selection reg */
> -#define DST_BASE_ADDR_REG	0x0404	/* Dest Image Base Address reg */
> -#define DST_STRIDE_REG		0x0408	/* Dest Stride reg */
> -#define DST_COLOR_MODE_REG	0x040C	/* Dest Image Color Mode reg */
> -#define DST_LEFT_TOP_REG	0x0410	/* Dest Left Top Coordinate reg */
> -#define DST_RIGHT_BOTTOM_REG	0x0414	/* Dest Right Bottom Coordinate reg */
> -
> -/* Parameter Setting Registers (Pattern) */
> -#define PAT_BASE_ADDR_REG	0x0500	/* Pattern Image Base Address reg */
> -#define PAT_SIZE_REG		0x0504	/* Pattern Image Size reg */
> -#define PAT_COLOR_MODE_REG	0x0508	/* Pattern Image Color Mode reg */
> -#define PAT_OFFSET_REG		0x050C	/* Pattern Left Top Coordinate reg */
> -#define PAT_STRIDE_REG		0x0510	/* Pattern Stride reg */
> -
> -/* Parameter Setting Registers (Mask) */
> -#define MASK_BASE_ADDR_REG	0x0520	/* Mask Base Address reg */
> -#define MASK_STRIDE_REG		0x0524	/* Mask Stride reg */
> -
> -/* Parameter Setting Registers (Clipping Window) */
> -#define CW_LT_REG		0x0600	/* LeftTop coordinates of Clip Window */
> -#define CW_RB_REG		0x0604	/* RightBottom coordinates of Clip
> -								Window */
> -
> -/* Parameter Setting Registers (ROP & Alpha Setting) */
> -#define THIRD_OPERAND_REG	0x0610	/* Third Operand Selection reg */
> -#define ROP4_REG		0x0614	/* Raster Operation reg */
> -#define ALPHA_REG		0x0618	/* Alpha value, Fading offset value */
> -
> -/* Parameter Setting Registers (Color) */
> -#define FG_COLOR_REG		0x0700	/* Foreground Color reg */
> -#define BG_COLOR_REG		0x0704	/* Background Color reg */
> -#define BS_COLOR_REG		0x0708	/* Blue Screen Color reg */
> -
> -/* Parameter Setting Registers (Color Key) */
> -#define SRC_COLORKEY_CTRL_REG	0x0710	/* Src Colorkey control reg */
> -#define SRC_COLORKEY_DR_MIN_REG	0x0714	/* Src Colorkey Decision Reference
> -								Min reg */
> -#define SRC_COLORKEY_DR_MAX_REG	0x0718	/* Src Colorkey Decision Reference
> -								Max reg */
> -#define DST_COLORKEY_CTRL_REG	0x071C	/* Dest Colorkey control reg */
> -#define DST_COLORKEY_DR_MIN_REG	0x0720	/* Dest Colorkey Decision Reference
> -								Min reg */
> -#define DST_COLORKEY_DR_MAX_REG	0x0724	/* Dest Colorkey Decision Reference
> -								Max reg */
> -
> -/* Color mode values */
> -
> -#define ORDER_XRGB		0
> -#define ORDER_RGBX		1
> -#define ORDER_XBGR		2
> -#define ORDER_BGRX		3
> -
> -#define MODE_XRGB_8888		0
> -#define MODE_ARGB_8888		1
> -#define MODE_RGB_565		2
> -#define MODE_XRGB_1555		3
> -#define MODE_ARGB_1555		4
> -#define MODE_XRGB_4444		5
> -#define MODE_ARGB_4444		6
> -#define MODE_PACKED_RGB_888	7
> -
> -#define COLOR_MODE(o, m)	(((o) << 4) | (m))
> -
> -/* ROP4 operation values */
> -#define ROP4_COPY		0xCCCC
> -#define ROP4_INVERT		0x3333
> -
> -/* Hardware limits */
> -#define MAX_WIDTH		8000
> -#define MAX_HEIGHT		8000
> -
> -#define G2D_TIMEOUT		500
> -
> -#define DEFAULT_WIDTH		100
> -#define DEFAULT_HEIGHT		100
> -
> -#define DEFAULT_SCALE_MODE	(2 << 0)
> -
> -/* Command mode register values */
> -#define CMD_V3_ENABLE_STRETCH	(1 << 4)
> diff --git a/drivers/media/platform/s5p-g2d/g2d.c b/drivers/media/platform/s5p-g2d/g2d.c
> deleted file mode 100644
> index 612d1ea514f1..000000000000
> --- a/drivers/media/platform/s5p-g2d/g2d.c
> +++ /dev/null
> @@ -1,800 +0,0 @@
> -/*
> - * Samsung S5P G2D - 2D Graphics Accelerator Driver
> - *
> - * Copyright (c) 2011 Samsung Electronics Co., Ltd.
> - * Kamil Debski, <k.debski@samsung.com>
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by the
> - * Free Software Foundation; either version 2 of the
> - * License, or (at your option) any later version
> - */
> -
> -#include <linux/module.h>
> -#include <linux/fs.h>
> -#include <linux/timer.h>
> -#include <linux/sched.h>
> -#include <linux/slab.h>
> -#include <linux/clk.h>
> -#include <linux/interrupt.h>
> -#include <linux/of.h>
> -
> -#include <linux/platform_device.h>
> -#include <media/v4l2-mem2mem.h>
> -#include <media/v4l2-device.h>
> -#include <media/v4l2-ioctl.h>
> -#include <media/videobuf2-v4l2.h>
> -#include <media/videobuf2-dma-contig.h>
> -
> -#include "g2d.h"
> -#include "g2d-regs.h"
> -
> -#define fh2ctx(__fh) container_of(__fh, struct g2d_ctx, fh)
> -
> -static struct g2d_fmt formats[] = {
> -	{
> -		.name	= "XRGB_8888",
> -		.fourcc	= V4L2_PIX_FMT_RGB32,
> -		.depth	= 32,
> -		.hw	= COLOR_MODE(ORDER_XRGB, MODE_XRGB_8888),
> -	},
> -	{
> -		.name	= "RGB_565",
> -		.fourcc	= V4L2_PIX_FMT_RGB565X,
> -		.depth	= 16,
> -		.hw	= COLOR_MODE(ORDER_XRGB, MODE_RGB_565),
> -	},
> -	{
> -		.name	= "XRGB_1555",
> -		.fourcc	= V4L2_PIX_FMT_RGB555X,
> -		.depth	= 16,
> -		.hw	= COLOR_MODE(ORDER_XRGB, MODE_XRGB_1555),
> -	},
> -	{
> -		.name	= "XRGB_4444",
> -		.fourcc	= V4L2_PIX_FMT_RGB444,
> -		.depth	= 16,
> -		.hw	= COLOR_MODE(ORDER_XRGB, MODE_XRGB_4444),
> -	},
> -	{
> -		.name	= "PACKED_RGB_888",
> -		.fourcc	= V4L2_PIX_FMT_RGB24,
> -		.depth	= 24,
> -		.hw	= COLOR_MODE(ORDER_XRGB, MODE_PACKED_RGB_888),
> -	},
> -};
> -#define NUM_FORMATS ARRAY_SIZE(formats)
> -
> -static struct g2d_frame def_frame = {
> -	.width		= DEFAULT_WIDTH,
> -	.height		= DEFAULT_HEIGHT,
> -	.c_width	= DEFAULT_WIDTH,
> -	.c_height	= DEFAULT_HEIGHT,
> -	.o_width	= 0,
> -	.o_height	= 0,
> -	.fmt		= &formats[0],
> -	.right		= DEFAULT_WIDTH,
> -	.bottom		= DEFAULT_HEIGHT,
> -};
> -
> -static struct g2d_fmt *find_fmt(struct v4l2_format *f)
> -{
> -	unsigned int i;
> -	for (i = 0; i < NUM_FORMATS; i++) {
> -		if (formats[i].fourcc == f->fmt.pix.pixelformat)
> -			return &formats[i];
> -	}
> -	return NULL;
> -}
> -
> -
> -static struct g2d_frame *get_frame(struct g2d_ctx *ctx,
> -							enum v4l2_buf_type type)
> -{
> -	switch (type) {
> -	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
> -		return &ctx->in;
> -	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
> -		return &ctx->out;
> -	default:
> -		return ERR_PTR(-EINVAL);
> -	}
> -}
> -
> -static int g2d_queue_setup(struct vb2_queue *vq,
> -			   unsigned int *nbuffers, unsigned int *nplanes,
> -			   unsigned int sizes[], void *alloc_ctxs[])
> -{
> -	struct g2d_ctx *ctx = vb2_get_drv_priv(vq);
> -	struct g2d_frame *f = get_frame(ctx, vq->type);
> -
> -	if (IS_ERR(f))
> -		return PTR_ERR(f);
> -
> -	sizes[0] = f->size;
> -	*nplanes = 1;
> -	alloc_ctxs[0] = ctx->dev->alloc_ctx;
> -
> -	if (*nbuffers == 0)
> -		*nbuffers = 1;
> -
> -	return 0;
> -}
> -
> -static int g2d_buf_prepare(struct vb2_buffer *vb)
> -{
> -	struct g2d_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
> -	struct g2d_frame *f = get_frame(ctx, vb->vb2_queue->type);
> -
> -	if (IS_ERR(f))
> -		return PTR_ERR(f);
> -	vb2_set_plane_payload(vb, 0, f->size);
> -	return 0;
> -}
> -
> -static void g2d_buf_queue(struct vb2_buffer *vb)
> -{
> -	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
> -	struct g2d_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
> -	v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vbuf);
> -}
> -
> -static struct vb2_ops g2d_qops = {
> -	.queue_setup	= g2d_queue_setup,
> -	.buf_prepare	= g2d_buf_prepare,
> -	.buf_queue	= g2d_buf_queue,
> -};
> -
> -static int queue_init(void *priv, struct vb2_queue *src_vq,
> -						struct vb2_queue *dst_vq)
> -{
> -	struct g2d_ctx *ctx = priv;
> -	int ret;
> -
> -	src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
> -	src_vq->io_modes = VB2_MMAP | VB2_USERPTR;
> -	src_vq->drv_priv = ctx;
> -	src_vq->ops = &g2d_qops;
> -	src_vq->mem_ops = &vb2_dma_contig_memops;
> -	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
> -	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
> -	src_vq->lock = &ctx->dev->mutex;
> -
> -	ret = vb2_queue_init(src_vq);
> -	if (ret)
> -		return ret;
> -
> -	dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> -	dst_vq->io_modes = VB2_MMAP | VB2_USERPTR;
> -	dst_vq->drv_priv = ctx;
> -	dst_vq->ops = &g2d_qops;
> -	dst_vq->mem_ops = &vb2_dma_contig_memops;
> -	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
> -	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
> -	dst_vq->lock = &ctx->dev->mutex;
> -
> -	return vb2_queue_init(dst_vq);
> -}
> -
> -static int g2d_s_ctrl(struct v4l2_ctrl *ctrl)
> -{
> -	struct g2d_ctx *ctx = container_of(ctrl->handler, struct g2d_ctx,
> -								ctrl_handler);
> -	unsigned long flags;
> -
> -	spin_lock_irqsave(&ctx->dev->ctrl_lock, flags);
> -	switch (ctrl->id) {
> -	case V4L2_CID_COLORFX:
> -		if (ctrl->val == V4L2_COLORFX_NEGATIVE)
> -			ctx->rop = ROP4_INVERT;
> -		else
> -			ctx->rop = ROP4_COPY;
> -		break;
> -
> -	case V4L2_CID_HFLIP:
> -		ctx->flip = ctx->ctrl_hflip->val | (ctx->ctrl_vflip->val << 1);
> -		break;
> -
> -	}
> -	spin_unlock_irqrestore(&ctx->dev->ctrl_lock, flags);
> -	return 0;
> -}
> -
> -static const struct v4l2_ctrl_ops g2d_ctrl_ops = {
> -	.s_ctrl		= g2d_s_ctrl,
> -};
> -
> -static int g2d_setup_ctrls(struct g2d_ctx *ctx)
> -{
> -	struct g2d_dev *dev = ctx->dev;
> -
> -	v4l2_ctrl_handler_init(&ctx->ctrl_handler, 3);
> -
> -	ctx->ctrl_hflip = v4l2_ctrl_new_std(&ctx->ctrl_handler, &g2d_ctrl_ops,
> -						V4L2_CID_HFLIP, 0, 1, 1, 0);
> -
> -	ctx->ctrl_vflip = v4l2_ctrl_new_std(&ctx->ctrl_handler, &g2d_ctrl_ops,
> -						V4L2_CID_VFLIP, 0, 1, 1, 0);
> -
> -	v4l2_ctrl_new_std_menu(
> -		&ctx->ctrl_handler,
> -		&g2d_ctrl_ops,
> -		V4L2_CID_COLORFX,
> -		V4L2_COLORFX_NEGATIVE,
> -		~((1 << V4L2_COLORFX_NONE) | (1 << V4L2_COLORFX_NEGATIVE)),
> -		V4L2_COLORFX_NONE);
> -
> -	if (ctx->ctrl_handler.error) {
> -		int err = ctx->ctrl_handler.error;
> -		v4l2_err(&dev->v4l2_dev, "g2d_setup_ctrls failed\n");
> -		v4l2_ctrl_handler_free(&ctx->ctrl_handler);
> -		return err;
> -	}
> -
> -	v4l2_ctrl_cluster(2, &ctx->ctrl_hflip);
> -
> -	return 0;
> -}
> -
> -static int g2d_open(struct file *file)
> -{
> -	struct g2d_dev *dev = video_drvdata(file);
> -	struct g2d_ctx *ctx = NULL;
> -	int ret = 0;
> -
> -	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
> -	if (!ctx)
> -		return -ENOMEM;
> -	ctx->dev = dev;
> -	/* Set default formats */
> -	ctx->in		= def_frame;
> -	ctx->out	= def_frame;
> -
> -	if (mutex_lock_interruptible(&dev->mutex)) {
> -		kfree(ctx);
> -		return -ERESTARTSYS;
> -	}
> -	ctx->fh.m2m_ctx = v4l2_m2m_ctx_init(dev->m2m_dev, ctx, &queue_init);
> -	if (IS_ERR(ctx->fh.m2m_ctx)) {
> -		ret = PTR_ERR(ctx->fh.m2m_ctx);
> -		mutex_unlock(&dev->mutex);
> -		kfree(ctx);
> -		return ret;
> -	}
> -	v4l2_fh_init(&ctx->fh, video_devdata(file));
> -	file->private_data = &ctx->fh;
> -	v4l2_fh_add(&ctx->fh);
> -
> -	g2d_setup_ctrls(ctx);
> -
> -	/* Write the default values to the ctx struct */
> -	v4l2_ctrl_handler_setup(&ctx->ctrl_handler);
> -
> -	ctx->fh.ctrl_handler = &ctx->ctrl_handler;
> -	mutex_unlock(&dev->mutex);
> -
> -	v4l2_info(&dev->v4l2_dev, "instance opened\n");
> -	return 0;
> -}
> -
> -static int g2d_release(struct file *file)
> -{
> -	struct g2d_dev *dev = video_drvdata(file);
> -	struct g2d_ctx *ctx = fh2ctx(file->private_data);
> -
> -	v4l2_ctrl_handler_free(&ctx->ctrl_handler);
> -	v4l2_fh_del(&ctx->fh);
> -	v4l2_fh_exit(&ctx->fh);
> -	kfree(ctx);
> -	v4l2_info(&dev->v4l2_dev, "instance closed\n");
> -	return 0;
> -}
> -
> -
> -static int vidioc_querycap(struct file *file, void *priv,
> -				struct v4l2_capability *cap)
> -{
> -	strncpy(cap->driver, G2D_NAME, sizeof(cap->driver) - 1);
> -	strncpy(cap->card, G2D_NAME, sizeof(cap->card) - 1);
> -	cap->bus_info[0] = 0;
> -	cap->device_caps = V4L2_CAP_VIDEO_M2M | V4L2_CAP_STREAMING;
> -	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
> -	return 0;
> -}
> -
> -static int vidioc_enum_fmt(struct file *file, void *prv, struct v4l2_fmtdesc *f)
> -{
> -	struct g2d_fmt *fmt;
> -	if (f->index >= NUM_FORMATS)
> -		return -EINVAL;
> -	fmt = &formats[f->index];
> -	f->pixelformat = fmt->fourcc;
> -	strncpy(f->description, fmt->name, sizeof(f->description) - 1);
> -	return 0;
> -}
> -
> -static int vidioc_g_fmt(struct file *file, void *prv, struct v4l2_format *f)
> -{
> -	struct g2d_ctx *ctx = prv;
> -	struct vb2_queue *vq;
> -	struct g2d_frame *frm;
> -
> -	vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
> -	if (!vq)
> -		return -EINVAL;
> -	frm = get_frame(ctx, f->type);
> -	if (IS_ERR(frm))
> -		return PTR_ERR(frm);
> -
> -	f->fmt.pix.width		= frm->width;
> -	f->fmt.pix.height		= frm->height;
> -	f->fmt.pix.field		= V4L2_FIELD_NONE;
> -	f->fmt.pix.pixelformat		= frm->fmt->fourcc;
> -	f->fmt.pix.bytesperline		= (frm->width * frm->fmt->depth) >> 3;
> -	f->fmt.pix.sizeimage		= frm->size;
> -	return 0;
> -}
> -
> -static int vidioc_try_fmt(struct file *file, void *prv, struct v4l2_format *f)
> -{
> -	struct g2d_fmt *fmt;
> -	enum v4l2_field *field;
> -
> -	fmt = find_fmt(f);
> -	if (!fmt)
> -		return -EINVAL;
> -
> -	field = &f->fmt.pix.field;
> -	if (*field == V4L2_FIELD_ANY)
> -		*field = V4L2_FIELD_NONE;
> -	else if (*field != V4L2_FIELD_NONE)
> -		return -EINVAL;
> -
> -	if (f->fmt.pix.width > MAX_WIDTH)
> -		f->fmt.pix.width = MAX_WIDTH;
> -	if (f->fmt.pix.height > MAX_HEIGHT)
> -		f->fmt.pix.height = MAX_HEIGHT;
> -
> -	if (f->fmt.pix.width < 1)
> -		f->fmt.pix.width = 1;
> -	if (f->fmt.pix.height < 1)
> -		f->fmt.pix.height = 1;
> -
> -	f->fmt.pix.bytesperline = (f->fmt.pix.width * fmt->depth) >> 3;
> -	f->fmt.pix.sizeimage = f->fmt.pix.height * f->fmt.pix.bytesperline;
> -	return 0;
> -}
> -
> -static int vidioc_s_fmt(struct file *file, void *prv, struct v4l2_format *f)
> -{
> -	struct g2d_ctx *ctx = prv;
> -	struct g2d_dev *dev = ctx->dev;
> -	struct vb2_queue *vq;
> -	struct g2d_frame *frm;
> -	struct g2d_fmt *fmt;
> -	int ret = 0;
> -
> -	/* Adjust all values accordingly to the hardware capabilities
> -	 * and chosen format. */
> -	ret = vidioc_try_fmt(file, prv, f);
> -	if (ret)
> -		return ret;
> -	vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
> -	if (vb2_is_busy(vq)) {
> -		v4l2_err(&dev->v4l2_dev, "queue (%d) bust\n", f->type);
> -		return -EBUSY;
> -	}
> -	frm = get_frame(ctx, f->type);
> -	if (IS_ERR(frm))
> -		return PTR_ERR(frm);
> -	fmt = find_fmt(f);
> -	if (!fmt)
> -		return -EINVAL;
> -	frm->width	= f->fmt.pix.width;
> -	frm->height	= f->fmt.pix.height;
> -	frm->size	= f->fmt.pix.sizeimage;
> -	/* Reset crop settings */
> -	frm->o_width	= 0;
> -	frm->o_height	= 0;
> -	frm->c_width	= frm->width;
> -	frm->c_height	= frm->height;
> -	frm->right	= frm->width;
> -	frm->bottom	= frm->height;
> -	frm->fmt	= fmt;
> -	frm->stride	= f->fmt.pix.bytesperline;
> -	return 0;
> -}
> -
> -static int vidioc_cropcap(struct file *file, void *priv,
> -					struct v4l2_cropcap *cr)
> -{
> -	struct g2d_ctx *ctx = priv;
> -	struct g2d_frame *f;
> -
> -	f = get_frame(ctx, cr->type);
> -	if (IS_ERR(f))
> -		return PTR_ERR(f);
> -
> -	cr->bounds.left		= 0;
> -	cr->bounds.top		= 0;
> -	cr->bounds.width	= f->width;
> -	cr->bounds.height	= f->height;
> -	cr->defrect		= cr->bounds;
> -	return 0;
> -}
> -
> -static int vidioc_g_crop(struct file *file, void *prv, struct v4l2_crop *cr)
> -{
> -	struct g2d_ctx *ctx = prv;
> -	struct g2d_frame *f;
> -
> -	f = get_frame(ctx, cr->type);
> -	if (IS_ERR(f))
> -		return PTR_ERR(f);
> -
> -	cr->c.left	= f->o_height;
> -	cr->c.top	= f->o_width;
> -	cr->c.width	= f->c_width;
> -	cr->c.height	= f->c_height;
> -	return 0;
> -}
> -
> -static int vidioc_try_crop(struct file *file, void *prv, const struct v4l2_crop *cr)
> -{
> -	struct g2d_ctx *ctx = prv;
> -	struct g2d_dev *dev = ctx->dev;
> -	struct g2d_frame *f;
> -
> -	f = get_frame(ctx, cr->type);
> -	if (IS_ERR(f))
> -		return PTR_ERR(f);
> -
> -	if (cr->c.top < 0 || cr->c.left < 0) {
> -		v4l2_err(&dev->v4l2_dev,
> -			"doesn't support negative values for top & left\n");
> -		return -EINVAL;
> -	}
> -
> -	return 0;
> -}
> -
> -static int vidioc_s_crop(struct file *file, void *prv, const struct v4l2_crop *cr)
> -{
> -	struct g2d_ctx *ctx = prv;
> -	struct g2d_frame *f;
> -	int ret;
> -
> -	ret = vidioc_try_crop(file, prv, cr);
> -	if (ret)
> -		return ret;
> -	f = get_frame(ctx, cr->type);
> -	if (IS_ERR(f))
> -		return PTR_ERR(f);
> -
> -	f->c_width	= cr->c.width;
> -	f->c_height	= cr->c.height;
> -	f->o_width	= cr->c.left;
> -	f->o_height	= cr->c.top;
> -	f->bottom	= f->o_height + f->c_height;
> -	f->right	= f->o_width + f->c_width;
> -	return 0;
> -}
> -
> -static void job_abort(void *prv)
> -{
> -	struct g2d_ctx *ctx = prv;
> -	struct g2d_dev *dev = ctx->dev;
> -
> -	if (dev->curr == NULL) /* No job currently running */
> -		return;
> -
> -	wait_event_timeout(dev->irq_queue,
> -			   dev->curr == NULL,
> -			   msecs_to_jiffies(G2D_TIMEOUT));
> -}
> -
> -static void device_run(void *prv)
> -{
> -	struct g2d_ctx *ctx = prv;
> -	struct g2d_dev *dev = ctx->dev;
> -	struct vb2_buffer *src, *dst;
> -	unsigned long flags;
> -	u32 cmd = 0;
> -
> -	dev->curr = ctx;
> -
> -	src = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
> -	dst = v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
> -
> -	clk_enable(dev->gate);
> -	g2d_reset(dev);
> -
> -	spin_lock_irqsave(&dev->ctrl_lock, flags);
> -
> -	g2d_set_src_size(dev, &ctx->in);
> -	g2d_set_src_addr(dev, vb2_dma_contig_plane_dma_addr(src, 0));
> -
> -	g2d_set_dst_size(dev, &ctx->out);
> -	g2d_set_dst_addr(dev, vb2_dma_contig_plane_dma_addr(dst, 0));
> -
> -	g2d_set_rop4(dev, ctx->rop);
> -	g2d_set_flip(dev, ctx->flip);
> -
> -	if (ctx->in.c_width != ctx->out.c_width ||
> -		ctx->in.c_height != ctx->out.c_height) {
> -		if (dev->variant->hw_rev == TYPE_G2D_3X)
> -			cmd |= CMD_V3_ENABLE_STRETCH;
> -		else
> -			g2d_set_v41_stretch(dev, &ctx->in, &ctx->out);
> -	}
> -
> -	g2d_set_cmd(dev, cmd);
> -	g2d_start(dev);
> -
> -	spin_unlock_irqrestore(&dev->ctrl_lock, flags);
> -}
> -
> -static irqreturn_t g2d_isr(int irq, void *prv)
> -{
> -	struct g2d_dev *dev = prv;
> -	struct g2d_ctx *ctx = dev->curr;
> -	struct vb2_v4l2_buffer *src, *dst;
> -
> -	g2d_clear_int(dev);
> -	clk_disable(dev->gate);
> -
> -	BUG_ON(ctx == NULL);
> -
> -	src = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
> -	dst = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
> -
> -	BUG_ON(src == NULL);
> -	BUG_ON(dst == NULL);
> -
> -	dst->timecode = src->timecode;
> -	dst->vb2_buf.timestamp = src->vb2_buf.timestamp;
> -	dst->flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
> -	dst->flags |=
> -		src->flags & V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
> -
> -	v4l2_m2m_buf_done(src, VB2_BUF_STATE_DONE);
> -	v4l2_m2m_buf_done(dst, VB2_BUF_STATE_DONE);
> -	v4l2_m2m_job_finish(dev->m2m_dev, ctx->fh.m2m_ctx);
> -
> -	dev->curr = NULL;
> -	wake_up(&dev->irq_queue);
> -	return IRQ_HANDLED;
> -}
> -
> -static const struct v4l2_file_operations g2d_fops = {
> -	.owner		= THIS_MODULE,
> -	.open		= g2d_open,
> -	.release	= g2d_release,
> -	.poll		= v4l2_m2m_fop_poll,
> -	.unlocked_ioctl	= video_ioctl2,
> -	.mmap		= v4l2_m2m_fop_mmap,
> -};
> -
> -static const struct v4l2_ioctl_ops g2d_ioctl_ops = {
> -	.vidioc_querycap	= vidioc_querycap,
> -
> -	.vidioc_enum_fmt_vid_cap	= vidioc_enum_fmt,
> -	.vidioc_g_fmt_vid_cap		= vidioc_g_fmt,
> -	.vidioc_try_fmt_vid_cap		= vidioc_try_fmt,
> -	.vidioc_s_fmt_vid_cap		= vidioc_s_fmt,
> -
> -	.vidioc_enum_fmt_vid_out	= vidioc_enum_fmt,
> -	.vidioc_g_fmt_vid_out		= vidioc_g_fmt,
> -	.vidioc_try_fmt_vid_out		= vidioc_try_fmt,
> -	.vidioc_s_fmt_vid_out		= vidioc_s_fmt,
> -
> -	.vidioc_reqbufs			= v4l2_m2m_ioctl_reqbufs,
> -	.vidioc_querybuf		= v4l2_m2m_ioctl_querybuf,
> -	.vidioc_qbuf			= v4l2_m2m_ioctl_qbuf,
> -	.vidioc_dqbuf			= v4l2_m2m_ioctl_dqbuf,
> -
> -	.vidioc_streamon		= v4l2_m2m_ioctl_streamon,
> -	.vidioc_streamoff		= v4l2_m2m_ioctl_streamoff,
> -
> -	.vidioc_g_crop			= vidioc_g_crop,
> -	.vidioc_s_crop			= vidioc_s_crop,
> -	.vidioc_cropcap			= vidioc_cropcap,
> -};
> -
> -static struct video_device g2d_videodev = {
> -	.name		= G2D_NAME,
> -	.fops		= &g2d_fops,
> -	.ioctl_ops	= &g2d_ioctl_ops,
> -	.minor		= -1,
> -	.release	= video_device_release,
> -	.vfl_dir	= VFL_DIR_M2M,
> -};
> -
> -static struct v4l2_m2m_ops g2d_m2m_ops = {
> -	.device_run	= device_run,
> -	.job_abort	= job_abort,
> -};
> -
> -static const struct of_device_id exynos_g2d_match[];
> -
> -static int g2d_probe(struct platform_device *pdev)
> -{
> -	struct g2d_dev *dev;
> -	struct video_device *vfd;
> -	struct resource *res;
> -	const struct of_device_id *of_id;
> -	int ret = 0;
> -
> -	dev = devm_kzalloc(&pdev->dev, sizeof(*dev), GFP_KERNEL);
> -	if (!dev)
> -		return -ENOMEM;
> -
> -	spin_lock_init(&dev->ctrl_lock);
> -	mutex_init(&dev->mutex);
> -	atomic_set(&dev->num_inst, 0);
> -	init_waitqueue_head(&dev->irq_queue);
> -
> -	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -
> -	dev->regs = devm_ioremap_resource(&pdev->dev, res);
> -	if (IS_ERR(dev->regs))
> -		return PTR_ERR(dev->regs);
> -
> -	dev->clk = clk_get(&pdev->dev, "sclk_fimg2d");
> -	if (IS_ERR(dev->clk)) {
> -		dev_err(&pdev->dev, "failed to get g2d clock\n");
> -		return -ENXIO;
> -	}
> -
> -	ret = clk_prepare(dev->clk);
> -	if (ret) {
> -		dev_err(&pdev->dev, "failed to prepare g2d clock\n");
> -		goto put_clk;
> -	}
> -
> -	dev->gate = clk_get(&pdev->dev, "fimg2d");
> -	if (IS_ERR(dev->gate)) {
> -		dev_err(&pdev->dev, "failed to get g2d clock gate\n");
> -		ret = -ENXIO;
> -		goto unprep_clk;
> -	}
> -
> -	ret = clk_prepare(dev->gate);
> -	if (ret) {
> -		dev_err(&pdev->dev, "failed to prepare g2d clock gate\n");
> -		goto put_clk_gate;
> -	}
> -
> -	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> -	if (!res) {
> -		dev_err(&pdev->dev, "failed to find IRQ\n");
> -		ret = -ENXIO;
> -		goto unprep_clk_gate;
> -	}
> -
> -	dev->irq = res->start;
> -
> -	ret = devm_request_irq(&pdev->dev, dev->irq, g2d_isr,
> -						0, pdev->name, dev);
> -	if (ret) {
> -		dev_err(&pdev->dev, "failed to install IRQ\n");
> -		goto put_clk_gate;
> -	}
> -
> -	dev->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
> -	if (IS_ERR(dev->alloc_ctx)) {
> -		ret = PTR_ERR(dev->alloc_ctx);
> -		goto unprep_clk_gate;
> -	}
> -
> -	ret = v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
> -	if (ret)
> -		goto alloc_ctx_cleanup;
> -	vfd = video_device_alloc();
> -	if (!vfd) {
> -		v4l2_err(&dev->v4l2_dev, "Failed to allocate video device\n");
> -		ret = -ENOMEM;
> -		goto unreg_v4l2_dev;
> -	}
> -	*vfd = g2d_videodev;
> -	vfd->lock = &dev->mutex;
> -	vfd->v4l2_dev = &dev->v4l2_dev;
> -	ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);
> -	if (ret) {
> -		v4l2_err(&dev->v4l2_dev, "Failed to register video device\n");
> -		goto rel_vdev;
> -	}
> -	video_set_drvdata(vfd, dev);
> -	snprintf(vfd->name, sizeof(vfd->name), "%s", g2d_videodev.name);
> -	dev->vfd = vfd;
> -	v4l2_info(&dev->v4l2_dev, "device registered as /dev/video%d\n",
> -								vfd->num);
> -	platform_set_drvdata(pdev, dev);
> -	dev->m2m_dev = v4l2_m2m_init(&g2d_m2m_ops);
> -	if (IS_ERR(dev->m2m_dev)) {
> -		v4l2_err(&dev->v4l2_dev, "Failed to init mem2mem device\n");
> -		ret = PTR_ERR(dev->m2m_dev);
> -		goto unreg_video_dev;
> -	}
> -
> -	def_frame.stride = (def_frame.width * def_frame.fmt->depth) >> 3;
> -
> -	of_id = of_match_node(exynos_g2d_match, pdev->dev.of_node);
> -	if (!of_id) {
> -		ret = -ENODEV;
> -		goto unreg_video_dev;
> -	}
> -	dev->variant = (struct g2d_variant *)of_id->data;
> -
> -	return 0;
> -
> -unreg_video_dev:
> -	video_unregister_device(dev->vfd);
> -rel_vdev:
> -	video_device_release(vfd);
> -unreg_v4l2_dev:
> -	v4l2_device_unregister(&dev->v4l2_dev);
> -alloc_ctx_cleanup:
> -	vb2_dma_contig_cleanup_ctx(dev->alloc_ctx);
> -unprep_clk_gate:
> -	clk_unprepare(dev->gate);
> -put_clk_gate:
> -	clk_put(dev->gate);
> -unprep_clk:
> -	clk_unprepare(dev->clk);
> -put_clk:
> -	clk_put(dev->clk);
> -
> -	return ret;
> -}
> -
> -static int g2d_remove(struct platform_device *pdev)
> -{
> -	struct g2d_dev *dev = platform_get_drvdata(pdev);
> -
> -	v4l2_info(&dev->v4l2_dev, "Removing " G2D_NAME);
> -	v4l2_m2m_release(dev->m2m_dev);
> -	video_unregister_device(dev->vfd);
> -	v4l2_device_unregister(&dev->v4l2_dev);
> -	vb2_dma_contig_cleanup_ctx(dev->alloc_ctx);
> -	clk_unprepare(dev->gate);
> -	clk_put(dev->gate);
> -	clk_unprepare(dev->clk);
> -	clk_put(dev->clk);
> -	return 0;
> -}
> -
> -static struct g2d_variant g2d_drvdata_v3x = {
> -	.hw_rev = TYPE_G2D_3X, /* Revision 3.0 for S5PV210 and Exynos4210 */
> -};
> -
> -static struct g2d_variant g2d_drvdata_v4x = {
> -	.hw_rev = TYPE_G2D_4X, /* Revision 4.1 for Exynos4X12 and Exynos5 */
> -};
> -
> -static const struct of_device_id exynos_g2d_match[] = {
> -	{
> -		.compatible = "samsung,s5pv210-g2d",
> -		.data = &g2d_drvdata_v3x,
> -	}, {
> -		.compatible = "samsung,exynos4212-g2d",
> -		.data = &g2d_drvdata_v4x,
> -	},
> -	{},
> -};
> -MODULE_DEVICE_TABLE(of, exynos_g2d_match);
> -
> -static struct platform_driver g2d_pdrv = {
> -	.probe		= g2d_probe,
> -	.remove		= g2d_remove,
> -	.driver		= {
> -		.name = G2D_NAME,
> -		.of_match_table = exynos_g2d_match,
> -	},
> -};
> -
> -module_platform_driver(g2d_pdrv);
> -
> -MODULE_AUTHOR("Kamil Debski <k.debski@samsung.com>");
> -MODULE_DESCRIPTION("S5P G2D 2d graphics accelerator driver");
> -MODULE_LICENSE("GPL");
> diff --git a/drivers/media/platform/s5p-g2d/g2d.h b/drivers/media/platform/s5p-g2d/g2d.h
> deleted file mode 100644
> index e31df541aa62..000000000000
> --- a/drivers/media/platform/s5p-g2d/g2d.h
> +++ /dev/null
> @@ -1,91 +0,0 @@
> -/*
> - * Samsung S5P G2D - 2D Graphics Accelerator Driver
> - *
> - * Copyright (c) 2011 Samsung Electronics Co., Ltd.
> - * Kamil Debski, <k.debski@samsung.com>
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by the
> - * Free Software Foundation; either version 2 of the
> - * License, or (at your option) any later version
> - */
> -
> -#include <linux/platform_device.h>
> -#include <media/v4l2-device.h>
> -#include <media/v4l2-ctrls.h>
> -
> -#define G2D_NAME "s5p-g2d"
> -#define TYPE_G2D_3X 3
> -#define TYPE_G2D_4X 4
> -
> -struct g2d_dev {
> -	struct v4l2_device	v4l2_dev;
> -	struct v4l2_m2m_dev	*m2m_dev;
> -	struct video_device	*vfd;
> -	struct mutex		mutex;
> -	spinlock_t		ctrl_lock;
> -	atomic_t		num_inst;
> -	struct vb2_alloc_ctx	*alloc_ctx;
> -	void __iomem		*regs;
> -	struct clk		*clk;
> -	struct clk		*gate;
> -	struct g2d_ctx		*curr;
> -	struct g2d_variant	*variant;
> -	int irq;
> -	wait_queue_head_t	irq_queue;
> -};
> -
> -struct g2d_frame {
> -	/* Original dimensions */
> -	u32	width;
> -	u32	height;
> -	/* Crop size */
> -	u32	c_width;
> -	u32	c_height;
> -	/* Offset */
> -	u32	o_width;
> -	u32	o_height;
> -	/* Image format */
> -	struct g2d_fmt *fmt;
> -	/* Variables that can calculated once and reused */
> -	u32	stride;
> -	u32	bottom;
> -	u32	right;
> -	u32	size;
> -};
> -
> -struct g2d_ctx {
> -	struct v4l2_fh fh;
> -	struct g2d_dev		*dev;
> -	struct g2d_frame	in;
> -	struct g2d_frame	out;
> -	struct v4l2_ctrl	*ctrl_hflip;
> -	struct v4l2_ctrl	*ctrl_vflip;
> -	struct v4l2_ctrl_handler ctrl_handler;
> -	u32 rop;
> -	u32 flip;
> -};
> -
> -struct g2d_fmt {
> -	char	*name;
> -	u32	fourcc;
> -	int	depth;
> -	u32	hw;
> -};
> -
> -struct g2d_variant {
> -	unsigned short hw_rev;
> -};
> -
> -void g2d_reset(struct g2d_dev *d);
> -void g2d_set_src_size(struct g2d_dev *d, struct g2d_frame *f);
> -void g2d_set_src_addr(struct g2d_dev *d, dma_addr_t a);
> -void g2d_set_dst_size(struct g2d_dev *d, struct g2d_frame *f);
> -void g2d_set_dst_addr(struct g2d_dev *d, dma_addr_t a);
> -void g2d_start(struct g2d_dev *d);
> -void g2d_clear_int(struct g2d_dev *d);
> -void g2d_set_rop4(struct g2d_dev *d, u32 r);
> -void g2d_set_flip(struct g2d_dev *d, u32 r);
> -void g2d_set_v41_stretch(struct g2d_dev *d,
> -			struct g2d_frame *src, struct g2d_frame *dst);
> -void g2d_set_cmd(struct g2d_dev *d, u32 c);


-- 
Thanks,
Mauro
