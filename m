Return-path: <mchehab@pedra>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:53024 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757174Ab1GAVUn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Jul 2011 17:20:43 -0400
Received: by fxd18 with SMTP id 18so3602118fxd.11
        for <linux-media@vger.kernel.org>; Fri, 01 Jul 2011 14:20:41 -0700 (PDT)
Message-ID: <4E0E3A20.6040002@gmail.com>
Date: Fri, 01 Jul 2011 23:20:32 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?=
	<u.kleine-koenig@pengutronix.de>
CC: linux-media@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	kernel@pengutronix.de
Subject: Re: [PATCH] media/at91sam9x5-video: new driver for the high end overlay
 on at91sam9x5
References: <1309377531-9246-1-git-send-email-u.kleine-koenig@pengutronix.de>
In-Reply-To: <1309377531-9246-1-git-send-email-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Uwe,

On 06/29/2011 09:58 PM, Uwe Kleine-König wrote:
> Signed-off-by: Uwe Kleine-König<u.kleine-koenig@pengutronix.de>
> ---
> Hello,
> 
> this is a driver that is still classified as work in progress. There are
> some known problems with it, still following the "release early, release
> often" principle I'd be happy to get some feed back from you.
> 
> Here is a list of know deficiencies:
>   - There is a hardware constraint I only noticed while testing. The
>     window/format config must only be updated once per (hardware) frame.
>     Otherwise dma might just stop without the driver noticing.
>   - device registration shouldn't happen in the driver. This should go
>     either to arch/arm/mach-at91 or the (yet to be submitted) fb driver.
>   - handle underflow errors
>     (For that the video driver needs some integration into the fb driver
>     as the underflow is reported in the fb's register space only)
>     For that reason rotation only works after enabling the "I know what I'm
>     doing" switch as rotation of a bigger video that can be played back
>     smoothly without rotation completely flattens the machine.
>   - clipping could be supported
>   - alpha blending could be supported
>   - handle more formats
> 
> Other than that there are a few questions marked with a tripple-X in the
> code.
> 
> Thanks for your time,
> Uwe
>   drivers/media/video/Kconfig            |    8 +
>   drivers/media/video/Makefile           |    1 +
>   drivers/media/video/at91sam9x5-video.c | 1440 ++++++++++++++++++++++++++++++++
>   4 files changed, 1453 insertions(+), 3 deletions(-)
>   create mode 100644 drivers/media/video/at91sam9x5-video.c
> 
> diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
> index 00f51dd..c937e4d 100644
> --- a/drivers/media/video/Kconfig
> +++ b/drivers/media/video/Kconfig
> @@ -81,6 +81,14 @@ menuconfig VIDEO_CAPTURE_DRIVERS
> 
>   if VIDEO_CAPTURE_DRIVERS&&  VIDEO_V4L2
> 
> +config VIDEO_AT91SAM9X5
> +	tristate "Support for AT91SAM9X5 Video"
> +	depends on ARCH_AT91SAM9X5
> +	depends on VIDEO_V4L2
> +	select VIDEOBUF2_DMA_CONTIG
> +	help
> +	  support for the "High End Overlay" found in Atmel's AT91SAM9X5 SoCs.
> +
>   config VIDEO_ADV_DEBUG
>   	bool "Enable advanced debug functionality"
>   	default n
> diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
> index ace5d8b..5a7620d 100644
> --- a/drivers/media/video/Makefile
> +++ b/drivers/media/video/Makefile
> @@ -105,6 +105,7 @@ obj-$(CONFIG_VIDEO_MXB) += mxb.o
>   obj-$(CONFIG_VIDEO_HEXIUM_ORION) += hexium_orion.o
>   obj-$(CONFIG_VIDEO_HEXIUM_GEMINI) += hexium_gemini.o
>   obj-$(CONFIG_VIDEO_TIMBERDALE)	+= timblogiw.o
> +obj-$(CONFIG_VIDEO_AT91SAM9X5) += at91sam9x5-video.o
> 
>   obj-$(CONFIG_VIDEOBUF_GEN) += videobuf-core.o
>   obj-$(CONFIG_VIDEOBUF_DMA_SG) += videobuf-dma-sg.o
> diff --git a/drivers/media/video/at91sam9x5-video.c b/drivers/media/video/at91sam9x5-video.c
> new file mode 100644
> index 0000000..1e5154b
> --- /dev/null
> +++ b/drivers/media/video/at91sam9x5-video.c
> @@ -0,0 +1,1440 @@
> +/*
> + * Copyright (C) 2011 Pengutronix
> + * Uwe Kleine-Koenig<u.kleine-koenig@pengutronix.de>
> + *
> + * This program is free software; you can redistribute it and/or modify it under
> + * the terms of the GNU General Public License version 2 as published by the
> + * Free Software Foundation.
> + */
> +
> +/*
> + * XXX:
> + * - handle setting of global alpha
> + * - handle more formats
> + * - complete this list :-)
> + */
> +
> +#include<linux/err.h>
> +#include<linux/fb.h>
> +#include<linux/init.h>
> +#include<linux/kernel.h>
> +#include<linux/module.h>
> +#include<linux/platform_device.h>
> +#include<linux/slab.h>
> +
> +#include<media/v4l2-common.h>
> +#include<media/v4l2-dev.h>
> +#include<media/v4l2-ioctl.h>
> +#include<media/videobuf2-dma-contig.h>
> +
> +#define debug(fmt, ...)
> +
> +#define DRIVER_NAME "at91sam9x5-video"
> +
> +#define REG_HEOCHER		0x00
> +#define REG_HEOCHER_CHEN		0x00000001
> +#define REG_HEOCHER_UPDATEEN		0x00000002
> +#define REG_HEOCHER_A2QEN		0x00000004
> +
> +#define REG_HEOCHDR		0x04
> +#define REG_HEOCHDR_CHDIS		0x00000001
> +#define REG_HEOCHDR_CHRST		0x00000100
> +
> +#define REG_HEOCHSR		0x08
> +#define REG_HEOCHSR_CHSR		0x00000001
> +#define REG_HEOCHSR_UPDATESR		0x00000002
> +#define REG_HEOCHSR_A2QSR		0x00000004
> +
> +#define REG_HEOIER		0x0c
> +#define REG_HEOIDR		0x10
> +#define REG_HEOIMR		0x14
> +#define REG_HEOISR		0x18
> +#define REG_HEOIxR_DMA			0x00000004
> +#define REG_HEOIxR_DSCR			0x00000008
> +#define REG_HEOIxR_ADD			0x00000010
> +#define REG_HEOIxR_DONE			0x00000020
> +#define REG_HEOIxR_OVR			0x00000040
> +#define REG_HEOIxR_UDMA			0x00000400
> +#define REG_HEOIxR_UDSCR		0x00000800
> +#define REG_HEOIxR_UADD			0x00001000
> +#define REG_HEOIxR_UDONE		0x00002000
> +#define REG_HEOIxR_UOVR			0x00004000
> +#define REG_HEOIxR_VDMA			0x00040000
> +#define REG_HEOIxR_VDSCR		0x00080000
> +#define REG_HEOIxR_VADD			0x00100000
> +#define REG_HEOIxR_VDONE		0x00200000
> +#define REG_HEOIxR_VOVR			0x00400000
> +
> +#define REG_HEOHEAD		0x1c
> +#define REG_HEOUHEAD		0x2c
> +#define REG_HEOVHEAD		0x3c
> +
> +#define REG_HEOADDR		0x20
> +#define REG_HEOUADDR		0x30
> +#define REG_HEOVADDR		0x40
> +
> +#define REG_HEOCTRL		0x24
> +#define REG_HEOUCTRL		0x34
> +#define REG_HEOVCTRL		0x44
> +#define REG_HEOxCTRL_DFETCH		0x00000001
> +#define REG_HEOCTRL_LFETCH		0x00000002
> +#define REG_HEOxCTRL_DMAIEN		0x00000004
> +#define REG_HEOxCTRL_DSCRIEN		0x00000008
> +#define REG_HEOxCTRL_ADDIEN		0x00000010
> +#define REG_HEOxCTRL_DONEIEN		0x00000020
> +
> +#define REG_HEONEXT		0x28
> +#define REG_HEOUNEXT		0x38
> +#define REG_HEOVNEXT		0x48
> +
> +#define REG_HEOCFG0		0x4c
> +#define REG_HEOCFG0_DLBO		0x00000100
> +#define REG_HEOCFG0_BLEN		0x00000030
> +#define REG_HEOCFG0_BLEN_INCR1			0x00000000
> +#define REG_HEOCFG0_BLEN_INCR4			0x00000010
> +#define REG_HEOCFG0_BLEN_INCR8			0x00000020
> +#define REG_HEOCFG0_BLEN_INCR16			0x00000030
> +#define REG_HEOCFG0_BLENUV		0x000000c0
> +#define REG_HEOCFG0_BLENUV_INCR1		0x00000000
> +#define REG_HEOCFG0_BLENUV_INCR4		0x00000040
> +#define REG_HEOCFG0_BLENUV_INCR8		0x00000080
> +#define REG_HEOCFG0_BLENUV_INCR16		0x000000c0
> +
> +#define REG_HEOCFG1		0x50
> +#define REG_HEOCFG1_CLUTEN		0x00000001
> +#define REG_HEOCFG1_YUVEN		0x00000002
> +#define REG_HEOCFG1_YUVMODE_12YCBCRP	0x00008000
> +
> +#define REG_HEOCFG2		0x54
> +#define REG_HEOCFG2_XPOS		0x000007ff
> +#define REG_HEOCFG2_YPOS		0x07ff0000
> +
> +#define REG_HEOCFG3		0x58
> +#define REG_HEOCFG3_XSIZE		0x000007ff
> +#define REG_HEOCFG3_YSIZE		0x07ff0000
> +
> +#define REG_HEOCFG4		0x5c
> +#define REG_HEOCFG4_XMEMSIZE		0x000007ff
> +#define REG_HEOCFG4_YMEMSIZE		0x07ff0000
> +
> +#define REG_HEOCFG5		0x60
> +#define REG_HEOCFG5_XSTRIDE		0xffffffff
> +
> +#define REG_HEOCFG6		0x64
> +#define REG_HEOCFG6_PSTRIDE		0xffffffff
> +
> +#define REG_HEOCFG7		0x68
> +#define REG_HEOCFG7_UVXSTRIDE		0xffffffff
> +
> +#define REG_HEOCFG8		0x6c
> +#define REG_HEOCFG8_UVPSTRIDE		0xffffffff
> +
> +#define REG_HEOCFG9		0x70
> +#define REG_HEOCFG10		0x74
> +#define REG_HEOCFG11		0x78
> +
> +#define REG_HEOCFG12		0x7c
> +#define REG_HEOCFG12_CRKEY		0x00000001
> +#define REG_HEOCFG12_INV		0x00000002
> +#define REG_HEOCFG12_ITER2BL		0x00000004
> +#define REG_HEOCFG12_ITER		0x00000008
> +#define REG_HEOCFG12_REVALPHA		0x00000010
> +#define REG_HEOCFG12_GAEN		0x00000020
> +#define REG_HEOCFG12_LAEN		0x00000040
> +#define REG_HEOCFG12_OVR		0x00000080
> +#define REG_HEOCFG12_DMA		0x00000100
> +#define REG_HEOCFG12_REP		0x00000200
> +#define REG_HEOCFG12_DSTKEY		0x00000400
> +#define REG_HEOCFG12_VIDPRI		0x00001000
> +#define REG_HEOCFG12_GA			0x00ff0000
> +
> +#define REG_HEOCFG13		0x80
> +#define REG_HEOCFG13_XFACTOR		0x00001fff
> +#define REG_HEOCFG13_YFACTOR		0x1fff0000
> +#define REG_HEOCFG13_SCALEN		0x80000000
> +
> +#define REG_HEOCFG14		0x84
> +#define REG_HEOCFG15		0x88
> +#define REG_HEOCFG16		0x8c
> +
> +#define valtomask(val, mask)	(((val)<<  __ffs((mask)))&  (mask))
> +#define valfrommask(val, mask)	(((val)&  (mask))>>  __ffs((mask)))
> +
> +struct at91sam9x5_video_pdata {
> +	u16 base_width;
> +	u16 base_height;
> +};
> +
> +struct at91sam9x5_video_bufinfo {
> +	struct vb2_buffer *vb;
> +	unsigned u_planeno, v_planeno;
> +	unsigned long plane_size[3];
> +};
> +
> +struct at91sam9x5_video_priv {
> +	struct platform_device *pdev;
> +
> +	/* framebuffer stuff */
> +	struct notifier_block fb_notifier;
> +	struct fb_info *fbinfo;
> +
> +	struct video_device *video_dev;
> +
> +	void __iomem *regbase;
> +	unsigned int irq;
> +
> +	struct vb2_queue queue;
> +	void *alloc_ctx;
> +
> +	struct at91sam9x5_video_bufinfo cur, next;
> +
> +	/* protects the members after lock and hardware access */
> +	spinlock_t lock;
> +
> +	enum {
> +		/* DMA not running */
> +		at91sam9x5_video_HW_IDLE,
> +		/* DMA running, unless cfgstate is BAD */
> +		at91sam9x5_video_HW_RUNNING,
> +	} hwstate;
> +
> +	enum {
> +		at91sam9x5_video_CFG_GOOD,
> +		/* the shadow registers need an update */
> +		at91sam9x5_video_CFG_GOOD_LATCH,
> +		at91sam9x5_video_CFG_BAD,
> +	} cfgstate;
> +
> +	/* if true the vid_out config in hardware doesn't match sw config */
> +	int cfgupdate;
> +
> +	int valid_config;
> +
> +	struct v4l2_pix_format fmt_vid_out_cur, fmt_vid_out_next;
> +
> +	int rotation;
> +
> +	struct v4l2_window fmt_vid_overlay;
> +
> +	/*
> +	 * For YUV formats Y data is always in plane 0. U, V are either both in
> +	 * 0, both in 1, or U in 1 or V in 2. -1 for formats that don't use U
> +	 * and V.
> +	 */
> +	int u_planeno, v_planeno;
> +
> +	unsigned long plane_size[3];
> +
> +	/*
> +	 * These are the offsets into the buffers to start the hardware for.
> +	 * Depending on rotation and overlay position this is more or less ugly
> +	 * to calculate. (y_offset is used for rgb data, too.)
> +	 */
> +	u32 y_offset, u_offset, v_offset;
> +
> +	u32 irqstat;
> +};
> +
> +static u32 at91sam9x5_video_read32(struct at91sam9x5_video_priv *priv,
> +		size_t offset)
> +{
> +	/* XXX: really use the __raw variants? */
> +	return __raw_readl(priv->regbase + offset);

I believe it is safer and more appropriate to use readl in your case.
Here is good explanation: http://www.spinics.net/lists/arm-kernel/msg125661.html

> +}
> +
> +static void at91sam9x5_video_write32(struct at91sam9x5_video_priv *priv,
> +		size_t offset, u32 val)
> +{
> +	debug("$%x := %08x, $08 == %08x\n", offset, val,
> +			at91sam9x5_video_read32(priv, REG_HEOCHSR));
> +	__raw_writel(val, priv->regbase + offset);

writel

> +	debug("$08 == %08x\n", at91sam9x5_video_read32(priv, REG_HEOCHSR));
> +}
> +
> +static int __at91sam9x5_video_buf_in_use(struct at91sam9x5_video_priv *priv,
> +		struct at91sam9x5_video_bufinfo *bi,
> +		size_t heoaddr_offset, unsigned planeno)
> +{
> +	if (planeno>= 0) {
> +		u32 heoaddr = at91sam9x5_video_read32(priv, heoaddr_offset);
> +		dma_addr_t plane_paddr =
> +			vb2_dma_contig_plane_paddr(bi->vb, planeno);
> +
> +		if (heoaddr - plane_paddr<= bi->plane_size[planeno])
> +			return 1;
> +	}
> +
> +	return 0;
> +}
> +
> +
> +static int at91sam9x5_video_buf_in_use(struct at91sam9x5_video_priv *priv,
> +		struct at91sam9x5_video_bufinfo *bi)
> +{
> +	if (__at91sam9x5_video_buf_in_use(priv, bi, REG_HEOADDR, 0))
> +		return 1;
> +	if (__at91sam9x5_video_buf_in_use(priv, bi,
> +				REG_HEOUADDR, bi->u_planeno))
> +		return 1;
> +	if (__at91sam9x5_video_buf_in_use(priv, bi,
> +				REG_HEOVADDR, bi->v_planeno))
> +		return 1;
> +
> +	return 0;
> +}
> +
> +static u32 at91sam9x5_video_handle_irqstat(struct at91sam9x5_video_priv *priv)
> +{
> +	u32 heoisr = at91sam9x5_video_read32(priv, REG_HEOISR);
> +
> +	debug("cur=%p, next=%p, heoisr=%08x\n", priv->cur.vb,
> +			priv->next.vb, heoisr);
> +	debug("cfgupdate=%d hwstate=%d cfgstate=%d\n",
> +			priv->cfgupdate, priv->hwstate, priv->cfgstate);
> +
> +	if (!priv->cur.vb) {
> +		priv->cur = priv->next;
> +		priv->next.vb = NULL;
> +	}
> +
> +	if (priv->hwstate == at91sam9x5_video_HW_IDLE&&
> +			!(at91sam9x5_video_read32(priv, REG_HEOCHSR)&
> +				REG_HEOCHSR_CHSR)) {
> +		if (priv->cur.vb) {
> +			vb2_buffer_done(priv->cur.vb, VB2_BUF_STATE_DONE);
> +			priv->cur.vb = NULL;
> +		}
> +
> +		if (priv->next.vb) {
> +			vb2_buffer_done(priv->next.vb, VB2_BUF_STATE_DONE);
> +			priv->next.vb = NULL;
> +		}
> +
> +		at91sam9x5_video_write32(priv, REG_HEOIDR,
> +				REG_HEOIxR_ADD | REG_HEOIxR_DMA |
> +				REG_HEOIxR_UADD | REG_HEOIxR_UDMA |
> +				REG_HEOIxR_VADD | REG_HEOIxR_VDMA);
> +
> +	} else if (priv->cur.vb&&  priv->next.vb) {
> +		int hwrunning = 1;
> +		if (priv->cfgstate == at91sam9x5_video_CFG_BAD&&
> +				!(at91sam9x5_video_read32(priv, REG_HEOCHSR)&
> +					REG_HEOCHSR_CHSR))
> +			hwrunning = 0;
> +
> +		if (!hwrunning || !at91sam9x5_video_buf_in_use(priv,
> +					&priv->cur)) {
> +			vb2_buffer_done(priv->cur.vb, VB2_BUF_STATE_DONE);
> +			priv->cur = priv->next;
> +			priv->next.vb = NULL;
> +		}
> +	} else if (priv->next.vb) {
> +		priv->cur = priv->next;
> +		priv->next.vb = NULL;
> +	}
> +
> +	return heoisr;
> +}
> +
> +static irqreturn_t at91sam9x5_video_irq(int irq, void *data)
> +{
> +	struct at91sam9x5_video_priv *priv = data;
> +	unsigned long flags;
> +	u32 handled, heoimr;
> +
> +	spin_lock_irqsave(&priv->lock, flags);
> +
> +	heoimr = at91sam9x5_video_read32(priv, REG_HEOIMR);
> +	handled = at91sam9x5_video_handle_irqstat(priv);
> +
> +	debug("%x, HEOCHSR = %08x\n", handled,
> +			at91sam9x5_video_read32(priv, REG_HEOCHSR));
> +
> +	spin_unlock_irqrestore(&priv->lock, flags);
> +
> +	if (handled&  heoimr)
> +		return IRQ_HANDLED;
> +	else

else could be omitted

> +		return IRQ_NONE;
> +}
> +
> +static inline int sign(int x)
> +{
> +	if (x>  0)
> +		return 1;
> +	else if (x<  0)
> +		return -1;
> +	else
> +		return 0;

Ditto.

> +}
> +
> +static void at91sam9x5_video_show_buf(struct at91sam9x5_video_priv *priv,
> +		struct vb2_buffer *vb)
> +{
> +	dma_addr_t buffer = vb2_dma_contig_plane_paddr(vb, 0);
> +	void *vaddr = vb2_plane_vaddr(vb, 0);
> +	struct v4l2_pix_format *pix =&priv->fmt_vid_out_cur;
> +	/* XXX: format dependant */
> +	size_t offset_dmadesc = ALIGN(pix->width * pix->height +
> +			ALIGN(pix->width, 2) * ALIGN(pix->height, 2) / 2, 32);
> +	u32 *dmadesc = vaddr + offset_dmadesc;
> +	u32 heocher;
> +
> +	if (priv->cfgstate == at91sam9x5_video_CFG_GOOD_LATCH) {
> +		heocher = REG_HEOCHER_UPDATEEN;
> +		priv->cfgstate = at91sam9x5_video_CFG_GOOD;
> +	} else {
> +		BUG_ON(priv->cfgstate != at91sam9x5_video_CFG_GOOD);
> +		heocher = 0;
> +	}
> +
> +	debug("vout=%ux%u, heocher=%08x\n", pix->width, pix->height, heocher);
> +
> +	dmadesc[0] = buffer + priv->y_offset;
> +	dmadesc[1] = REG_HEOxCTRL_DFETCH;
> +	dmadesc[2] = buffer + offset_dmadesc;
> +
> +	if (priv->u_planeno>= 0) {
> +		dmadesc[3] = vb2_dma_contig_plane_paddr(vb, priv->u_planeno) +
> +			priv->u_offset;
> +		dmadesc[4] = REG_HEOxCTRL_DFETCH;
> +		dmadesc[5] = buffer + offset_dmadesc + 3 * 4;
> +	}
> +
> +	if (priv->v_planeno>= 0) {
> +		dmadesc[6] = vb2_dma_contig_plane_paddr(vb, priv->v_planeno) +
> +			priv->v_offset;
> +		dmadesc[7] = REG_HEOxCTRL_DFETCH;
> +		dmadesc[8] = buffer + offset_dmadesc + 6 * 4;
> +	}
> +
> +
> +	debug("HEOCHSR = %08x\n", at91sam9x5_video_read32(priv, REG_HEOCHSR));
> +	if (likely(priv->hwstate == at91sam9x5_video_HW_RUNNING)) {
> +
> +		at91sam9x5_video_write32(priv, REG_HEOHEAD, dmadesc[2]);
> +
> +		if (priv->u_planeno>= 0)
> +			at91sam9x5_video_write32(priv,
> +					REG_HEOUHEAD, dmadesc[5]);
> +
> +		if (priv->v_planeno>= 0)
> +			at91sam9x5_video_write32(priv,
> +					REG_HEOVHEAD, dmadesc[8]);
> +
> +		at91sam9x5_video_write32(priv,
> +				REG_HEOCHER, heocher | REG_HEOCHER_A2QEN);
> +
> +	} else {
> +
> +		at91sam9x5_video_write32(priv, REG_HEOADDR, dmadesc[0]);
> +		at91sam9x5_video_write32(priv, REG_HEOCTRL, dmadesc[1]);
> +		at91sam9x5_video_write32(priv, REG_HEONEXT, dmadesc[2]);
> +
> +		if (priv->u_planeno>= 0) {
> +			at91sam9x5_video_write32(priv,
> +					REG_HEOUADDR, dmadesc[3]);
> +			at91sam9x5_video_write32(priv,
> +					REG_HEOUCTRL, dmadesc[4]);
> +			at91sam9x5_video_write32(priv,
> +					REG_HEOUNEXT, dmadesc[5]);
> +		}
> +
> +		if (priv->v_planeno>= 0) {
> +			at91sam9x5_video_write32(priv,
> +					REG_HEOVADDR, dmadesc[6]);
> +			at91sam9x5_video_write32(priv,
> +					REG_HEOVCTRL, dmadesc[7]);
> +			at91sam9x5_video_write32(priv,
> +					REG_HEOVNEXT, dmadesc[8]);
> +		}
> +
> +		at91sam9x5_video_write32(priv, REG_HEOCHER,
> +				heocher | REG_HEOCHER_CHEN);
> +
> +		priv->hwstate = at91sam9x5_video_HW_RUNNING;
> +	}
> +
> +	if (priv->cur.vb&&  at91sam9x5_video_buf_in_use(priv,&priv->cur)) {
> +		if (priv->next.vb) {
> +			/* drop next; XXX: is this an error? */
> +			debug("drop %p\n", priv->next.vb);
> +			vb2_buffer_done(priv->next.vb, VB2_BUF_STATE_ERROR);
> +		}
> +	} else {
> +		if (priv->cur.vb)
> +			vb2_buffer_done(priv->cur.vb, VB2_BUF_STATE_DONE);
> +
> +		priv->cur = priv->next;
> +	}
> +	priv->next.vb = vb;
> +	priv->next.u_planeno = priv->u_planeno;
> +	priv->next.v_planeno = priv->v_planeno;
> +	priv->next.plane_size[0] = priv->plane_size[0];
> +	priv->next.plane_size[1] = priv->plane_size[1];
> +	priv->next.plane_size[2] = priv->plane_size[2];
> +}
> +
> +static int experimental;
> +module_param(experimental, bool, 0644);
> +MODULE_PARM_DESC(experimental, "enable experimental features");
> +
> +static void at91sam9x5_video_params(unsigned width, unsigned height,
> +		int rotation, u32 *xstride, u32 *pstride, u32 *tloffset)
> +{
> +/* offset of pixel at (x, y) in the buffer */
> +#define po(x, y) ((x) + width * (y))
> +
> +	/* offsets of the edges in counter-clockwise order */
> +	const unsigned e[] = {
> +		po(0, 0),
> +		po(0, height - 1),
> +		po(width - 1, height - 1),
> +		po(width - 1, 0),
> +	};
> +
> +	/*
> +	 * offsets of the pixels next to the corresponding edges
> +	 * If edge[i] goes to the top left corner, edge_neighbour[i] is
> +	 * located just below of edge[i].
> +	 */
> +	const unsigned en[] = {
> +		po(0, 1),
> +		po(1, height - 1),
> +		po(width - 1, height - 2),
> +		po(width - 2, 0),
> +	};
> +
> +#define ro(r) ((rotation + (r)) % 4)
> +
> +	*xstride = en[ro(0)] - e[ro(3)];
> +	*pstride = e[ro(3)] - en[ro(3)];
> +	*tloffset = e[ro(0)];
> +}
> +
> +static void at91sam9x5_video_update_config_real(
> +		struct at91sam9x5_video_priv *priv)
> +{
> +	struct v4l2_pix_format *pix =&priv->fmt_vid_out_cur;
> +	struct v4l2_window *win =&priv->fmt_vid_overlay;
> +	struct v4l2_rect *rect =&win->w;
> +	/* XXX: check for overflow? */
> +	s32 right = rect->left + rect->width, bottom = rect->top + rect->height;
> +
> +	unsigned hwxpos, hwypos, hwxsize, hwysize;
> +	unsigned hwxmem_size, hwymem_size;
> +	s32 hwxstride, hwpstride;
> +	s32 hwuvxstride, hwuvpstride;
> +	s32 rotated_pixwidth, rotated_pixheight;
> +
> +	debug("vout=%ux%u, ovl=(%d,%d)+(%d,%d)\n", pix->width, pix->height,
> +			rect->left, rect->top, rect->width, rect->height);
> +
> +	if (!experimental&&  priv->rotation) {
> +		dev_info(&priv->video_dev->dev, "disable rotation\n");
> +		priv->rotation = 0;
> +	}
> +
> +	if (rect->left<  0)
> +		hwxpos = 0;
> +	else
> +		hwxpos = rect->left;

Could be rewritten as:

	hwxpos = rect->left < 0 ? 0 : rect->left;

> +
> +	if (rect->top<  0)
> +		hwypos = 0;
> +	else
> +		hwypos = rect->top;
> +
> +	if (right>  priv->fbinfo->var.xres)
> +		hwxsize = priv->fbinfo->var.xres - hwxpos;
> +	else
> +		hwxsize = right - hwxpos;
> +
> +	if (bottom>  priv->fbinfo->var.yres)
> +		hwysize = priv->fbinfo->var.yres - hwypos;
> +	else
> +		hwysize = bottom - hwypos;
> +
> +	at91sam9x5_video_write32(priv, REG_HEOCFG2,
> +			valtomask(hwxpos, REG_HEOCFG2_XPOS) |
> +			valtomask(hwypos, REG_HEOCFG2_YPOS));
> +
> +	at91sam9x5_video_write32(priv, REG_HEOCFG3,
> +			valtomask(hwxsize - 1, REG_HEOCFG3_XSIZE) |
> +			valtomask(hwysize - 1, REG_HEOCFG3_YSIZE));
> +
> +	/* XXX:
> +	 *  - clipping
> +	 */
> +	at91sam9x5_video_write32(priv, REG_HEOCFG1,
> +			REG_HEOCFG1_YUVMODE_12YCBCRP |
> +			REG_HEOCFG1_YUVEN);
> +	at91sam9x5_video_write32(priv, REG_HEOCFG12,
> +			REG_HEOCFG12_GAEN |
> +			REG_HEOCFG12_OVR |
> +			REG_HEOCFG12_DMA |
> +			REG_HEOCFG12_REP |
> +			REG_HEOCFG12_GA);
> +
> +#define vx(pos) xedge[(priv->rotation + pos) % 4]
> +#define vy(pos) yedge[(priv->rotation + pos) % 4]
> +
> +	if (priv->rotation&  1) {
> +		rotated_pixwidth = pix->height;
> +		rotated_pixheight = pix->width;
> +	} else {
> +		rotated_pixwidth = pix->width;
> +		rotated_pixheight = pix->height;
> +	}
> +
> +	hwxmem_size = rotated_pixwidth * hwxsize / rect->width;
> +	hwymem_size = rotated_pixheight * hwysize / rect->height;
> +
> +	at91sam9x5_video_write32(priv, REG_HEOCFG4,
> +			valtomask(hwxmem_size - 1, REG_HEOCFG4_XMEMSIZE) |
> +			valtomask(hwymem_size - 1, REG_HEOCFG4_YMEMSIZE));
> +
> +	at91sam9x5_video_write32(priv, REG_HEOCFG13,
> +			REG_HEOCFG13_SCALEN |
> +			valtomask(1024 * hwxmem_size / hwxsize,
> +				REG_HEOCFG13_XFACTOR) |
> +			valtomask(1024 * hwymem_size / hwysize,
> +				REG_HEOCFG13_YFACTOR));
> +
> +	at91sam9x5_video_params(pix->width, pix->height, priv->rotation,
> +			&hwxstride,&hwpstride,&priv->y_offset);
> +
> +	/* XXX: format-dependant */
> +	at91sam9x5_video_params(DIV_ROUND_UP(pix->width, 2),
> +			DIV_ROUND_UP(pix->height, 2), priv->rotation,
> +			&hwuvxstride,&hwuvpstride,&priv->u_offset);
> +
> +	at91sam9x5_video_write32(priv, REG_HEOCFG5,
> +			valtomask(hwxstride - 1, REG_HEOCFG5_XSTRIDE));
> +	at91sam9x5_video_write32(priv, REG_HEOCFG6,
> +			valtomask(hwpstride - 1, REG_HEOCFG6_PSTRIDE));
> +
> +	at91sam9x5_video_write32(priv, REG_HEOCFG7,
> +			valtomask(hwuvxstride - 1, REG_HEOCFG7_UVXSTRIDE));
> +	at91sam9x5_video_write32(priv, REG_HEOCFG8,
> +			valtomask(hwuvpstride - 1, REG_HEOCFG8_UVPSTRIDE));
> +
> +	/* XXX: format dependant */
> +	priv->u_planeno = 0;
> +	priv->v_planeno = 0;
> +	priv->u_offset += pix->width * pix->height;
> +	priv->v_offset = priv->u_offset +
> +		DIV_ROUND_UP(pix->width, 2) * DIV_ROUND_UP(pix->height, 2);
> +
> +	/* XXX: evaluate pix->colorspace */
> +	at91sam9x5_video_write32(priv, REG_HEOCFG14, 0x4c900091);
> +	at91sam9x5_video_write32(priv, REG_HEOCFG15, 0x7a5f5090);
> +	at91sam9x5_video_write32(priv, REG_HEOCFG16, 0x40040890);
> +}
> +
> +static void at91sam9x5_video_update_config(struct at91sam9x5_video_priv *priv,
> +		int overlay_only)
> +{
> +	debug("cfgupdate=%d overlay_only=%d\n", priv->cfgupdate, overlay_only);
> +
> +	at91sam9x5_video_handle_irqstat(priv);
> +
> +	if (priv->cfgupdate || overlay_only) {

To eliminate one level of indentation instead I would do here:

	if (!priv->cfgupdate && !overlay_only)
		return;

> +		struct v4l2_pix_format *pix =&priv->fmt_vid_out_cur;
> +		struct v4l2_window *win =&priv->fmt_vid_overlay;
> +		struct v4l2_rect *rect =&win->w;
> +
> +		if (!overlay_only) {
> +			*pix = priv->fmt_vid_out_next;
> +			priv->cfgupdate = 0;
> +		}
> +
> +		/* XXX: handle clipping */
> +		if (rect->width<= 0 || rect->height<= 0 ||
> +				/* vid_out is set */
> +				pix->width<= 0 ||
> +				pix->height<= 0 ||
> +				/* window is partly invisible or too small */
> +				rect->left<  0 ||
> +				rect->top<  0 ||
> +				rect->left>= (int)priv->fbinfo->var.xres - 5 ||
> +				rect->top>= (int)priv->fbinfo->var.yres - 5 ||
> +				rect->left + rect->width>
> +					(int)priv->fbinfo->var.xres ||
> +				rect->top + rect->height>
> +					(int)priv->fbinfo->var.yres) {
> +
> +			if (priv->cfgstate == at91sam9x5_video_CFG_GOOD ||
> +					priv->cfgstate ==
> +					at91sam9x5_video_CFG_GOOD_LATCH)
> +				at91sam9x5_video_write32(priv,
> +						REG_HEOCHDR, REG_HEOCHDR_CHDIS);
> +
> +			priv->cfgstate = at91sam9x5_video_CFG_BAD;
> +		} else {
> +			at91sam9x5_video_update_config_real(priv);
> +
> +			debug("hwstate=%d cfgstate=%d\n",
> +					priv->hwstate, priv->cfgstate);
> +			if (overlay_only&&  priv->hwstate ==
> +					at91sam9x5_video_HW_RUNNING) {
> +				if (priv->cfgstate ==
> +						at91sam9x5_video_CFG_BAD) {
> +					priv->cfgstate =
> +						at91sam9x5_video_CFG_GOOD_LATCH;
> +					priv->hwstate =
> +						at91sam9x5_video_HW_IDLE;
> +
> +					at91sam9x5_video_show_buf(priv,
> +							priv->cur.vb);
> +				} else
> +					at91sam9x5_video_write32(priv,
> +							REG_HEOCHER,
> +							REG_HEOCHER_UPDATEEN);
> +			} else
> +				priv->cfgstate =
> +					at91sam9x5_video_CFG_GOOD_LATCH;
> +		}
> +
> +	}
> +}
> +
> +static int at91sam9x5_video_vb_queue_setup(struct vb2_queue *q,
> +		unsigned int *num_buffers, unsigned int *num_planes,
> +		unsigned long sizes[], void *alloc_ctxs[])
> +{
> +	struct at91sam9x5_video_priv *priv =
> +		container_of(q, struct at91sam9x5_video_priv, queue);
> +	struct v4l2_pix_format *pix =&priv->fmt_vid_out_next;
> +
> +	debug("vout=%ux%u\n", pix->width, pix->height);
> +
> +	/* XXX */
> +	*num_planes = 1;
> +
> +	/*
> +	 * The last 9 (aligned) words are used for the 3 dma descriptors (3
> +	 * 32-bit words each). The additional 32 bits are for alignment.
> +	 * XXX: is that allowed and done right?
> +	 * XXX: format-dependant
> +	 */
> +	sizes[0] = pix->width * pix->height +
> +		ALIGN(pix->width, 2) * ALIGN(pix->height, 2) / 2 +
> +		10 * 32;
> +	priv->plane_size[0] = sizes[0];
> +
> +	alloc_ctxs[0] = priv->alloc_ctx;
> +
> +	return 0;
> +}
> +
> +static void at91sam9x5_video_vb_wait_prepare(struct vb2_queue *q)
> +{
> +	struct at91sam9x5_video_priv *priv =
> +		container_of(q, struct at91sam9x5_video_priv, queue);
> +	unsigned long flags;
> +
> +	debug("cfgupdate=%d hwstate=%d cfgstate=%d\n",
> +			priv->cfgupdate, priv->hwstate, priv->cfgstate);
> +	debug("bufs=%p,%p\n", priv->cur.vb, priv->next.vb);
> +	spin_lock_irqsave(&priv->lock, flags);
> +
> +	at91sam9x5_video_handle_irqstat(priv);
> +
> +	at91sam9x5_video_write32(priv, REG_HEOIER,
> +			REG_HEOIxR_ADD | REG_HEOIxR_DMA |
> +			REG_HEOIxR_UADD | REG_HEOIxR_UDMA |
> +			REG_HEOIxR_VADD | REG_HEOIxR_VDMA);

What the above two calls are intended to be doing ?

> +
> +	spin_unlock_irqrestore(&priv->lock, flags);
> +}
> +
> +static void at91sam9x5_video_vb_wait_finish(struct vb2_queue *q)
> +{
> +	struct at91sam9x5_video_priv *priv =
> +		container_of(q, struct at91sam9x5_video_priv, queue);
> +	unsigned long flags;
> +
> +	debug("cfgupdate=%d hwstate=%d cfgstate=%d\n",
> +			priv->cfgupdate, priv->hwstate, priv->cfgstate);
> +	debug("bufs=%p,%p\n", priv->cur.vb, priv->next.vb);
> +	spin_lock_irqsave(&priv->lock, flags);
> +
> +	at91sam9x5_video_write32(priv, REG_HEOIDR,
> +			REG_HEOIxR_ADD | REG_HEOIxR_DMA |
> +			REG_HEOIxR_UADD | REG_HEOIxR_UDMA |
> +			REG_HEOIxR_VADD | REG_HEOIxR_VDMA);
> +
> +	spin_unlock_irqrestore(&priv->lock, flags);
> +}
> +
> +static int at91sam9x5_video_vb_buf_prepare(struct vb2_buffer *vb)
> +{
> +	struct vb2_queue *q = vb->vb2_queue;
> +	struct at91sam9x5_video_priv *priv =
> +		container_of(q, struct at91sam9x5_video_priv, queue);
> +	struct v4l2_pix_format *pix =&priv->fmt_vid_out_cur;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&priv->lock, flags);
> +	if (priv->cfgupdate)
> +		pix =&priv->fmt_vid_out_next;
> +	spin_unlock_irqrestore(&priv->lock, flags);
> +
> +	debug("vout=%ux%u\n", pix->width, pix->height);
> +	debug("buflen=%u\n", vb->v4l2_planes[0].length);
> +
> +	/* XXX: format-dependant */
> +	if (vb->v4l2_planes[0].length<  pix->width * pix->height +
> +			ALIGN(pix->width, 2) * ALIGN(pix->height, 2) / 2 +
> +			10 * 32)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +static void at91sam9x5_video_vb_buf_queue(struct vb2_buffer *vb)
> +{
> +	struct vb2_queue *q = vb->vb2_queue;
> +	struct at91sam9x5_video_priv *priv =
> +		container_of(q, struct at91sam9x5_video_priv, queue);
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&priv->lock, flags);
> +
> +	at91sam9x5_video_update_config(priv, 0);
> +
> +	switch (priv->cfgstate) {
> +	case at91sam9x5_video_CFG_GOOD:
> +	case at91sam9x5_video_CFG_GOOD_LATCH:
> +		/* show_buf takes care of the eventual hwstate update */
> +		at91sam9x5_video_show_buf(priv, vb);
> +		break;
> +
> +	case at91sam9x5_video_CFG_BAD:
> +		vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
> +		priv->hwstate = at91sam9x5_video_HW_RUNNING;
> +		break;
> +	}
> +
> +	spin_unlock_irqrestore(&priv->lock, flags);
> +}
> +
> +const struct vb2_ops at91sam9x5_video_vb_ops = {
> +	.queue_setup = at91sam9x5_video_vb_queue_setup,
> +
> +	.wait_prepare = at91sam9x5_video_vb_wait_prepare,
> +	.wait_finish = at91sam9x5_video_vb_wait_finish,

These 2 functions are intended to unlock and lock respectively the mutex
that is used to serialize ioctl handlers, in particular DQBUF.
I'm not sure if you're doing the right thing in 
at91sam9x5_video_vb_wait_prepare/at91sam9x5_video_vb_wait_finish. 

> +
> +	.buf_prepare = at91sam9x5_video_vb_buf_prepare,
> +	.buf_queue = at91sam9x5_video_vb_buf_queue,
> +};
> +
> +static int at91sam9x5_video_vidioc_querycap(struct file *filp,
> +		void *fh, struct v4l2_capability *cap)
> +{
> +	strcpy(cap->driver, DRIVER_NAME);
> +	cap->capabilities = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING |
> +		V4L2_CAP_VIDEO_OVERLAY;
> +
> +	/* XXX */
> +	cap->version = 0;

There is no need to set this field any more. It will be overwritten
with kernel versions in __video_do_ioctl(). See this for more details:
http://git.linuxtv.org/media_tree.git?a=commit;h=33436a81b0d4d1036ffcf0edb7e3bfa65d18ad08

> +	cap->card[0] = '\0';
> +	cap->bus_info[0] = '\0';
> +
> +	return 0;
> +}
> +
> +static int at91sam9x5_video_vidioc_g_fmt_vid_out(struct file *filp,
> +		void *fh, struct v4l2_format *f)
> +{
> +	struct video_device *vdev = filp->private_data;
> +	struct at91sam9x5_video_priv *priv = video_get_drvdata(vdev);
> +	unsigned long flags;
> +
> +	if (f->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
> +		return -EINVAL;
> +
> +	spin_lock_irqsave(&priv->lock, flags);
> +
> +	f->fmt.pix = priv->fmt_vid_out_next;
> +
> +	spin_unlock_irqrestore(&priv->lock, flags);
> +	return 0;
> +}
> +
> +static int at91sam9x5_video_vidioc_s_fmt_vid_out(struct file *filp,
> +		void *fh, struct v4l2_format *f)
> +{
> +	struct video_device *vdev = filp->private_data;
> +	struct at91sam9x5_video_priv *priv = video_get_drvdata(vdev);
> +	struct v4l2_pix_format *pix =&f->fmt.pix;
> +	unsigned long flags;
> +
> +	if (f->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
> +		return -EINVAL;

This is ok but..

> +
> +	if (pix->pixelformat != V4L2_PIX_FMT_YUV420)
> +		return -EINVAL;

here you should rather do:

	pix->pixelformat = V4L2_PIX_FMT_YUV420;

and not to return any error, i.e. driver should adjust the format
to its capabilities and it then will be returned back to user application.

> +
> +	debug("vout=%ux%u\n", pix->width, pix->height);
> +
> +	spin_lock_irqsave(&priv->lock, flags);
> +
> +	priv->fmt_vid_out_next = *pix;

Rather than blindly accepting new format the driver should first
adjust it to its capabilities.

> +
> +	priv->cfgupdate = 1;
> +
> +	spin_unlock_irqrestore(&priv->lock, flags);
> +
> +	return 0;
> +}
> +
> +static int at91sam9x5_video_vidioc_g_fmt_vid_overlay(struct file *filp,
> +		void *fh, struct v4l2_format *f)
> +{
> +	struct video_device *vdev = filp->private_data;
> +	struct at91sam9x5_video_priv *priv = video_get_drvdata(vdev);
> +	unsigned long flags;
> +
> +	if (f->type != V4L2_BUF_TYPE_VIDEO_OVERLAY)
> +		return -EINVAL;
> +
> +	spin_lock_irqsave(&priv->lock, flags);
> +
> +	f->fmt.win = priv->fmt_vid_overlay;
> +
> +	spin_unlock_irqrestore(&priv->lock, flags);
> +
> +	return 0;
> +}
> +
> +static int at91sam9x5_video_vidioc_s_fmt_vid_overlay(struct file *filp,
> +		void *fh, struct v4l2_format *f)
> +{
> +	struct video_device *vdev = filp->private_data;
> +	struct at91sam9x5_video_priv *priv = video_get_drvdata(vdev);
> +	struct v4l2_window *win =&f->fmt.win;
> +	unsigned long flags;
> +
> +	if (f->type != V4L2_BUF_TYPE_VIDEO_OVERLAY)
> +		return -EINVAL;
> +
> +	debug("rect=(%d,%d)+(%d,%d)\n",
> +			win->w.left, win->w.top, win->w.width, win->w.height);
> +
> +	spin_lock_irqsave(&priv->lock, flags);
> +
> +	priv->fmt_vid_overlay = *win;
> +
> +	at91sam9x5_video_update_config(priv, 1);
> +
> +	spin_unlock_irqrestore(&priv->lock, flags);
> +
> +	return 0;
> +}
> +
> +static int at91sam9x5_video_vidioc_enum_fmt_vid_out(struct file *filp,
> +		void *fh, struct v4l2_fmtdesc *f)
> +{
> +	/* XXX: support more formats */
> +	if (f->index>  0)
> +		return -EINVAL;
> +
> +	f->pixelformat = V4L2_PIX_FMT_YUV420;
> +	return 0;
> +}
> +
> +static int at91sam9x5_video_vidioc_reqbufs(struct file *filp,
> +		void *fh, struct v4l2_requestbuffers *b)
> +{
> +	struct video_device *vdev = filp->private_data;
> +	struct at91sam9x5_video_priv *priv = video_get_drvdata(vdev);
> +	struct vb2_queue *q =&priv->queue;
> +
> +	if (b->type != q->type) {
> +		dev_err(&priv->pdev->dev, "invalid buffer type (%d != %d)\n",
> +				b->type, q->type);
> +		return -EINVAL;
> +	}
> +
> +	return vb2_reqbufs(q, b);
> +}
> +
> +static int at91sam9x5_video_vidioc_querybuf(struct file *filp,
> +		void *fh, struct v4l2_buffer *b)
> +{
> +	struct video_device *vdev = filp->private_data;
> +	struct at91sam9x5_video_priv *priv = video_get_drvdata(vdev);
> +
> +	return vb2_querybuf(&priv->queue, b);
> +}
> +
> +static int at91sam9x5_video_vidioc_qbuf(struct file *filp,
> +		void *fh, struct v4l2_buffer *b)
> +{
> +	struct video_device *vdev = filp->private_data;
> +	struct at91sam9x5_video_priv *priv = video_get_drvdata(vdev);
> +
> +	return vb2_qbuf(&priv->queue, b);
> +}
> +
> +static int at91sam9x5_video_vidioc_dqbuf(struct file *filp,
> +		void *fh, struct v4l2_buffer *b)
> +{
> +	struct video_device *vdev = filp->private_data;
> +	struct at91sam9x5_video_priv *priv = video_get_drvdata(vdev);
> +
> +	return vb2_dqbuf(&priv->queue, b, filp->f_flags&  O_NONBLOCK);
> +}
> +
> +static int at91sam9x5_video_vidioc_streamon(struct file *filp,
> +		void *fh, enum v4l2_buf_type type)
> +{
> +	struct video_device *vdev = video_devdata(filp);
> +	struct at91sam9x5_video_priv *priv = video_get_drvdata(vdev);
> +
> +	return vb2_streamon(&priv->queue, type);
> +}
> +
> +static int at91sam9x5_video_vidioc_streamoff(struct file *filp,
> +		void *fh, enum v4l2_buf_type type)
> +{
> +	struct video_device *vdev = video_devdata(filp);
> +	struct at91sam9x5_video_priv *priv = video_get_drvdata(vdev);
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&priv->lock, flags);
> +
> +	/* disable channel */
> +	at91sam9x5_video_write32(priv, REG_HEOCHDR, REG_HEOCHDR_CHDIS);
> +
> +	at91sam9x5_video_handle_irqstat(priv);
> +
> +	if (priv->cur.vb)
> +		at91sam9x5_video_write32(priv, REG_HEOIER,
> +				REG_HEOIxR_ADD | REG_HEOIxR_DMA |
> +				REG_HEOIxR_UADD | REG_HEOIxR_UDMA |
> +				REG_HEOIxR_VADD | REG_HEOIxR_VDMA);
> +
> +	priv->hwstate = at91sam9x5_video_HW_IDLE;
> +
> +	spin_unlock_irqrestore(&priv->lock, flags);
> +
> +	return vb2_streamoff(&priv->queue, type);
> +}
> +
> +static int at91sam9x5_video_vidioc_queryctrl(struct file *filp, void *fh,
> +		struct v4l2_queryctrl *a)
> +{
> +	int ret;
> +
> +	switch (a->id) {
> +	case V4L2_CID_ROTATE:
> +		ret = v4l2_ctrl_query_fill(a, 0, 270, 90, 0);
> +		break;
> +	default:
> +		ret = -EINVAL;
> +		break;
> +	}
> +
> +	return ret;
> +}
> +
> +static int at91sam9x5_video_vidioc_g_ctrl(struct file *filp, void *fh,
> +		struct v4l2_control *a)
> +{
> +	struct video_device *vdev = video_devdata(filp);
> +	struct at91sam9x5_video_priv *priv = video_get_drvdata(vdev);
> +	int ret = 0;
> +
> +	switch (a->id) {
> +	case V4L2_CID_ROTATE:
> +		a->value = 90 * priv->rotation;
> +		break;
> +	default:
> +		ret = -EINVAL;
> +		break;
> +	}
> +
> +	return ret;
> +}
> +
> +static int at91sam9x5_video_vidioc_s_ctrl(struct file *filp, void *fh,
> +		struct v4l2_control *a)
> +{
> +	struct video_device *vdev = video_devdata(filp);
> +	struct at91sam9x5_video_priv *priv = video_get_drvdata(vdev);
> +	int ret;
> +	unsigned long flags;
> +
> +	switch (a->id) {
> +	case V4L2_CID_ROTATE:
> +		if (a->value / 90 * 90 != a->value ||
> +				(a->value / 90) % 4 != a->value / 90) {
> +			ret = -EINVAL;
> +		} else {
> +			debug("rotation: %d\n", a->value);
> +			spin_lock_irqsave(&priv->lock, flags);
> +			priv->rotation = a->value / 90;
> +			at91sam9x5_video_update_config(priv, 1);
> +			spin_unlock_irqrestore(&priv->lock, flags);
> +		}
> +		break;
> +	default:
> +		ret = -EINVAL;
> +		break;
> +	}
> +
> +	return ret;
> +}

For the controls new drivers should be using the control framework, see
Documentation/video4linux/v4l2-controls.txt

> +
> +static const struct v4l2_ioctl_ops at91sam9x5_video_ioctl_ops = {
> +	.vidioc_querycap = at91sam9x5_video_vidioc_querycap,
> +	.vidioc_g_fmt_vid_out = at91sam9x5_video_vidioc_g_fmt_vid_out,
> +	.vidioc_s_fmt_vid_out = at91sam9x5_video_vidioc_s_fmt_vid_out,
> +	.vidioc_g_fmt_vid_overlay = at91sam9x5_video_vidioc_g_fmt_vid_overlay,
> +	.vidioc_s_fmt_vid_overlay = at91sam9x5_video_vidioc_s_fmt_vid_overlay,
> +	.vidioc_enum_fmt_vid_out = at91sam9x5_video_vidioc_enum_fmt_vid_out,
> +	.vidioc_reqbufs = at91sam9x5_video_vidioc_reqbufs,
> +	.vidioc_querybuf = at91sam9x5_video_vidioc_querybuf,
> +	.vidioc_qbuf = at91sam9x5_video_vidioc_qbuf,
> +	.vidioc_dqbuf = at91sam9x5_video_vidioc_dqbuf,
> +	.vidioc_streamon = at91sam9x5_video_vidioc_streamon,
> +	.vidioc_streamoff = at91sam9x5_video_vidioc_streamoff,
> +	.vidioc_queryctrl = at91sam9x5_video_vidioc_queryctrl,
> +	.vidioc_g_ctrl = at91sam9x5_video_vidioc_g_ctrl,
> +	.vidioc_s_ctrl = at91sam9x5_video_vidioc_s_ctrl,
> +};
> +
> +static int at91sam9x5_video_open(struct file *filp)
> +{
> +	struct video_device *vdev = video_devdata(filp);
> +
> +	/*
> +	 * XXX: allow only one open? Or is that already enforced by the
> +	 * framework?
> +	 */

No, it is not enforced by v4l2 core. And the driver should handle
multiple opens properly. When one process has opened the video device
other processes must be able to query the video node configuration
and need to be prevented to break any streaming in progress.

> +	filp->private_data = vdev;
> +
> +	return 0;
> +}
> +
> +static int at91sam9x5_video_release(struct file *filp)
> +{
> +	struct video_device *vdev = video_devdata(filp);
> +
> +	dev_dbg(&vdev->dev, "%s\n", __func__);
> +
> +	return 0;
> +}
> +
> +static int at91sam9x5_video_mmap(struct file *filp, struct vm_area_struct *vma)
> +{
> +	struct video_device *vdev = video_devdata(filp);
> +	struct at91sam9x5_video_priv *priv = video_get_drvdata(vdev);
> +
> +	dev_dbg(&vdev->dev, "%s\n", __func__);
> +
> +	/* returning -EIO here makes gst-launch segfault */
> +	return vb2_mmap(&priv->queue, vma);
> +}
> +
> +static struct v4l2_file_operations at91sam9x5_video_fops = {
> +	.owner = THIS_MODULE,
> +	.open = at91sam9x5_video_open,
> +	.release = at91sam9x5_video_release,
> +	.ioctl = video_ioctl2,

I think it is enforced on new drivers to use unlocked_ioctl.
I case of unlocked_ioctl you need to either serialize all
ioctl and fops individually in the driver or embed a mutex in driver's
private data structure and pass a pointer to it to your video_device
instance, before the video_device is registered.


> +	.mmap = at91sam9x5_video_mmap,
> +};
> +
> +static int at91sam9x5_video_register(struct at91sam9x5_video_priv *priv,
> +		struct fb_info *fbinfo)
> +{
> +	int ret = -ENOMEM;
> +	struct platform_device *pdev = priv->pdev;
> +	struct resource *res;
> +	const struct at91sam9x5_video_pdata *pdata =
> +		dev_get_platdata(&pdev->dev);
> +	struct vb2_queue *q =&priv->queue;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&priv->lock, flags);
> +	if (priv->fbinfo) {
> +		spin_unlock_irqrestore(&priv->lock, flags);
> +		return -EBUSY;
> +	}
> +	priv->fbinfo = fbinfo;
> +	spin_unlock_irqrestore(&priv->lock, flags);
> +
> +	/* XXX: this doesn't belong here, does it? */
> +	pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
> +
> +	if (!pdata) {
> +		dev_err(&pdev->dev, "failed to get platform data\n");
> +		goto err_get_pdata;
> +	}
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res) {
> +		dev_err(&pdev->dev, "failed to get register base\n");
> +		goto err_get_regbase;
> +	}
> +
> +	priv->regbase = ioremap(res->start, resource_size(res));
> +	if (!priv->regbase) {
> +		dev_err(&pdev->dev, "failed to remap register base\n");
> +		goto err_ioremap;
> +	}
> +
> +	/*
> +	 * XXX: video_device_alloc is just a kzalloc, so embedding struct
> +	 * video_device into struct at91sam9x5_video_priv would work, too.
> +	 * Is that allowed?
> +	 */
> +	priv->video_dev = video_device_alloc();
> +	if (!priv->video_dev) {
> +		dev_err(&pdev->dev, "failed to alloc video device for %p\n",
> +				fbinfo);
> +		goto err_video_device_alloc;
> +	}
> +
> +	priv->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
> +	if (IS_ERR(priv->alloc_ctx)) {
> +		ret = PTR_ERR(priv->alloc_ctx);
> +		dev_err(&pdev->dev, "failed to init alloc_ctx (%d)\n", ret);
> +		goto err_init_ctx;
> +	}
> +
> +	q->ops =&at91sam9x5_video_vb_ops;
> +	q->mem_ops =&vb2_dma_contig_memops;
> +	q->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
> +	q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_WRITE;
> +
> +	ret = vb2_queue_init(q);
> +	if (ret) {
> +		dev_err(&pdev->dev, "failed to init queue (%d)\n", ret);
> +		goto err_queue_init;
> +	}
> +
> +	priv->video_dev->fops =&at91sam9x5_video_fops;
> +	priv->video_dev->ioctl_ops =&at91sam9x5_video_ioctl_ops;
> +	priv->video_dev->release = video_device_release;
> +
> +	video_set_drvdata(priv->video_dev, priv);
> +
> +	/* reset channel and clear status */
> +	at91sam9x5_video_write32(priv, REG_HEOCHDR, REG_HEOCHDR_CHRST);
> +	(void)at91sam9x5_video_read32(priv, REG_HEOISR);
> +
> +	/* set maximal bursting */
> +	at91sam9x5_video_write32(priv, REG_HEOCFG0,
> +			REG_HEOCFG0_BLEN_INCR16 |
> +			REG_HEOCFG0_BLENUV_INCR16);
> +
> +	ret = platform_get_irq(pdev, 0);
> +	if (ret<= 0) {
> +		dev_err(&pdev->dev, "failed to get irq from resources (%d)\n",
> +				ret);
> +		if (!ret)
> +			ret = -ENXIO;
> +		goto err_get_irq;
> +	}
> +	priv->irq = ret;
> +
> +	ret = request_irq(priv->irq, at91sam9x5_video_irq, IRQF_SHARED,
> +			DRIVER_NAME, priv);
> +	if (ret) {
> +		dev_err(&pdev->dev, "failed to request irq (%d)\n", ret);
> +		goto err_request_irq;
> +	}
> +
> +	ret = video_register_device(priv->video_dev,
> +			/* XXX: really grabber? */ VFL_TYPE_GRABBER, -1);
> +	if (ret) {
> +		dev_err(&pdev->dev, "failed to register video device (%d)\n",
> +				ret);
> +
> +		free_irq(priv->irq, priv);
> + err_request_irq:
> + err_get_irq:
> +
> +		vb2_queue_release(q);
> +err_queue_init:
> +
> +		vb2_dma_contig_cleanup_ctx(priv->alloc_ctx);
> + err_init_ctx:
> +
> +		video_device_release(priv->video_dev);
> + err_video_device_alloc:
> +
> +		iounmap(priv->regbase);
> +
> +		priv->fbinfo = NULL;
> +	}
> + err_ioremap:
> + err_get_regbase:
> + err_get_pdata:
> +
> +	return ret;
> +}
> +
> +static void at91sam9x5_video_unregister(struct at91sam9x5_video_priv *priv)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&priv->lock, flags);
> +
> +	if (!priv->fbinfo) {
> +		spin_unlock_irqrestore(&priv->lock, flags);
> +		return;
> +	}
> +	/* XXX: handle fbinfo being NULL in various callbacks */
> +	priv->fbinfo = NULL;
> +	spin_unlock_irqrestore(&priv->lock, flags);
> +
> +	/* silence DMA */
> +	at91sam9x5_video_write32(priv, REG_HEOIDR,
> +			REG_HEOIxR_ADD | REG_HEOIxR_DMA | REG_HEOIxR_UADD |
> +			REG_HEOIxR_UDMA | REG_HEOIxR_VADD | REG_HEOIxR_VDMA);
> +
> +	video_unregister_device(priv->video_dev);
> +	free_irq(priv->irq, priv);
> +	vb2_queue_release(&priv->queue);
> +	vb2_dma_contig_cleanup_ctx(priv->alloc_ctx);
> +	video_device_release(priv->video_dev);

video_device_release should not be called here. If it was, double kfree would
happen on same memory area. Since in the probe() callback you do:
	
	priv->video_dev->release = video_device_release;

priv->video_dev will be freed at the right time by the device core, after 
video_unregister_device is called by the driver.
When you decide to embed struct video_device directly in driver's private
data structure the above line will have to be replaced with:

	priv->video_dev->release = video_device_release_empty;

> +	iounmap(priv->regbase);
> +}
> +
> +static int at91sam9x5_video_fb_event_notify(struct notifier_block *self,
> +		unsigned long action, void *data)
> +{
> +	struct at91sam9x5_video_priv *priv =
> +		container_of(self, struct at91sam9x5_video_priv, fb_notifier);
> +	struct fb_event *event = data;
> +	struct fb_info *fbinfo = event->info;
> +
> +	/* XXX: only do this for atmel_lcdfb devices! */
> +	switch (action) {
> +	case FB_EVENT_FB_REGISTERED:
> +		at91sam9x5_video_register(priv, fbinfo);
> +		break;
> +
> +	case FB_EVENT_FB_UNREGISTERED:
> +		at91sam9x5_video_unregister(priv);
> +		break;
> +	}
> +	return 0;
> +}
> +
> +static int __devinit at91sam9x5_video_probe(struct platform_device *pdev)
> +{
> +	int ret = -ENOMEM;
> +	size_t i;
> +	struct at91sam9x5_video_priv *priv = kzalloc(sizeof(*priv), GFP_KERNEL);
> +
> +	if (!priv) {
> +		dev_err(&pdev->dev, "failed to allocate driver private data\n");
> +		goto err_alloc_priv;
> +	}
> +
> +	priv->pdev = pdev;
> +	priv->fb_notifier.notifier_call = at91sam9x5_video_fb_event_notify;
> +
> +	platform_set_drvdata(pdev, priv);
> +
> +	spin_lock_init(&priv->lock);
> +
> +	ret = fb_register_client(&priv->fb_notifier);
> +	if (ret) {
> +		dev_err(&pdev->dev, "failed to register fb client (%d)\n", ret);
> +
> +		kfree(priv);
> +err_alloc_priv:
> +
> +		return ret;
> +	}
> +
> +	/* XXX: This is racy. If a new fb is registered then
> +	 * at91sam9x5_video_register is called twice. This should be solved
> +	 * somewhere in drivers/fb. priv->fbinfo is used to prevent multiple
> +	 * registration.
> +	 */
> +
> +	for (i = 0; i<  ARRAY_SIZE(registered_fb); ++i)
> +		if (registered_fb[i])
> +			at91sam9x5_video_register(priv, registered_fb[i]);
> +
> +	return 0;
> +}
> +
> +int __devexit at91sam9x5_video_remove(struct platform_device *pdev)
> +{
> +	struct at91sam9x5_video_priv *priv = platform_get_drvdata(pdev);
> +
> +	fb_unregister_client(&priv->fb_notifier);
> +	at91sam9x5_video_unregister(priv);
> +	kfree(priv);
> +
> +	return 0;
> +}
> +
> +static struct platform_driver at91sam9x5_video_driver = {
> +	.driver = {
> +		.name = DRIVER_NAME,
> +		.owner = THIS_MODULE,
> +	},
> +	.probe = at91sam9x5_video_probe,
> +	.remove = at91sam9x5_video_remove,
> +};
> +
> +static struct platform_device *at91sam9x5_video_device;
> +static int __init at91sam9x5_video_init(void)
> +{
> +	/* XXX: register the device in arch/arm/mach-at91 */
> +	int ret;
> +	const struct resource res[] = {
> +		{
> +			.start = 0xf8038280,
> +			.end = 0xf803833f,
> +			.flags = IORESOURCE_MEM,
> +		}, {
> +			.start = 25,
> +			.end = 25,
> +			.flags = IORESOURCE_IRQ,
> +		},
> +	};
> +	const struct at91sam9x5_video_pdata pdata = {
> +		.base_width = 800,
> +		.base_height = 480,
> +	};

What is it needed for ? Couldn't it be hard coded in the driver
or queried somehow ?

> +
> +	ret = platform_driver_register(&at91sam9x5_video_driver);
> +	if (ret) {
> +		pr_err("failed to register driver (%d)", ret);
> +		goto err_driver_register;
> +	}
> +
> +	at91sam9x5_video_device = platform_device_register_resndata(NULL,
> +			DRIVER_NAME, -1,
> +			res, ARRAY_SIZE(res),&pdata, sizeof(pdata));
> +	if (IS_ERR(at91sam9x5_video_device)) {
> +		ret = PTR_ERR(at91sam9x5_video_device);
> +		pr_err("failed to register device (%d)", ret);
> +		platform_driver_unregister(&at91sam9x5_video_driver);
> +	}
> +
> + err_driver_register:
> +	return ret;
> +}
> +module_init(at91sam9x5_video_init);
> +
> +static void __exit at91sam9x5_video_exit(void)
> +{
> +	platform_device_unregister(at91sam9x5_video_device);
> +	platform_driver_unregister(&at91sam9x5_video_driver);
> +}
> +module_exit(at91sam9x5_video_exit);
> +
> +MODULE_AUTHOR("Uwe Kleine-Koenig<u.kleine-koenig@pengutronix.de>");
> +MODULE_LICENSE("GPL v2");

--
Regards,
Sylwester Nawrocki
