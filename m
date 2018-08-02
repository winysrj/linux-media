Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37708 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726862AbeHBMVM (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Aug 2018 08:21:12 -0400
Received: by mail-wr1-f68.google.com with SMTP id u12-v6so1582378wrr.4
        for <linux-media@vger.kernel.org>; Thu, 02 Aug 2018 03:30:28 -0700 (PDT)
Message-ID: <bdc722d622b73317ed9429a5c822bc9080f6ecb3.camel@baylibre.com>
Subject: Re: [RFC 1/4] media: meson: add v4l2 m2m video decoder driver
From: Jerome Brunet <jbrunet@baylibre.com>
To: Maxime Jourdan <maxi.jourdan@wanadoo.fr>,
        linux-media@vger.kernel.org
Cc: linux-amlogic@lists.infradead.org
Date: Thu, 02 Aug 2018 12:30:24 +0200
In-Reply-To: <20180801193320.25313-2-maxi.jourdan@wanadoo.fr>
References: <20180801193320.25313-1-maxi.jourdan@wanadoo.fr>
         <20180801193320.25313-2-maxi.jourdan@wanadoo.fr>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2018-08-01 at 21:33 +0200, Maxime Jourdan wrote:
> Amlogic SoCs feature a powerful video decoder unit able to
> decode many formats, with a performance of usually up to 4k60.
> 
> This is a driver for this IP that is based around the v4l2 m2m framework.
> 
> It features decoding for:
> - MPEG 1/2/4, H.264, MJPEG, (partial) HEVC 8-bit
> 
> Even though they are supported in hardware, it doesn't leverage support for:
> - HEVC 10-bit, VP9, VC1 (all those are in TODOs)
> 
> The code was made in such a way to allow easy inclusion of those formats in the future.
> Supported SoCs are: GXBB (S905), GXL (S905X/W/D), GXM (S912)
> 
> Specifically, two of the vdec units are enabled within this driver:
> 
> - VDEC_1: can decode MPEG 1/2/4, H.264, MJPEG
> - VDEC_HEVC: can decode HEVC
> 
> There is also a hardware bitstream parser (ESPARSER) that is handled here.
> 
> Signed-off-by: Maxime Jourdan <maxi.jourdan@wanadoo.fr>
> ---
>  drivers/media/platform/Kconfig                |   10 +
>  drivers/media/platform/meson/Makefile         |    1 +
>  drivers/media/platform/meson/vdec/Makefile    |    7 +
>  drivers/media/platform/meson/vdec/canvas.c    |   69 +
>  drivers/media/platform/meson/vdec/canvas.h    |   42 +
>  .../media/platform/meson/vdec/codec_h264.c    |  376 +++++
>  .../media/platform/meson/vdec/codec_h264.h    |   13 +
>  .../media/platform/meson/vdec/codec_helpers.c |   45 +
>  .../media/platform/meson/vdec/codec_helpers.h |    8 +
>  .../media/platform/meson/vdec/codec_hevc.c    | 1383 +++++++++++++++++
>  .../media/platform/meson/vdec/codec_hevc.h    |   13 +
>  .../media/platform/meson/vdec/codec_mjpeg.c   |  203 +++
>  .../media/platform/meson/vdec/codec_mjpeg.h   |   13 +
>  .../media/platform/meson/vdec/codec_mpeg12.c  |  183 +++
>  .../media/platform/meson/vdec/codec_mpeg12.h  |   13 +
>  .../media/platform/meson/vdec/codec_mpeg4.c   |  213 +++
>  .../media/platform/meson/vdec/codec_mpeg4.h   |   13 +
>  drivers/media/platform/meson/vdec/esparser.c  |  320 ++++
>  drivers/media/platform/meson/vdec/esparser.h  |   16 +
>  drivers/media/platform/meson/vdec/hevc_regs.h |  742 +++++++++
>  drivers/media/platform/meson/vdec/vdec.c      | 1009 ++++++++++++
>  drivers/media/platform/meson/vdec/vdec.h      |  152 ++
>  drivers/media/platform/meson/vdec/vdec_1.c    |  266 ++++
>  drivers/media/platform/meson/vdec/vdec_1.h    |   13 +
>  drivers/media/platform/meson/vdec/vdec_hevc.c |  188 +++
>  drivers/media/platform/meson/vdec/vdec_hevc.h |   22 +
>  .../media/platform/meson/vdec/vdec_platform.c |  273 ++++
>  .../media/platform/meson/vdec/vdec_platform.h |   29 +
>  28 files changed, 5635 insertions(+)

Ouch!

Your architecture seems pretty modular. Maybe you could split this patch a
little ? One patch of the 'backbone' then one for each codec ? 

>  create mode 100644 drivers/media/platform/meson/vdec/Makefile
>  create mode 100644 drivers/media/platform/meson/vdec/canvas.c
>  create mode 100644 drivers/media/platform/meson/vdec/canvas.h
>  create mode 100644 drivers/media/platform/meson/vdec/codec_h264.c
>  create mode 100644 drivers/media/platform/meson/vdec/codec_h264.h
>  create mode 100644 drivers/media/platform/meson/vdec/codec_helpers.c
>  create mode 100644 drivers/media/platform/meson/vdec/codec_helpers.h
>  create mode 100644 drivers/media/platform/meson/vdec/codec_hevc.c
>  create mode 100644 drivers/media/platform/meson/vdec/codec_hevc.h
>  create mode 100644 drivers/media/platform/meson/vdec/codec_mjpeg.c
>  create mode 100644 drivers/media/platform/meson/vdec/codec_mjpeg.h
>  create mode 100644 drivers/media/platform/meson/vdec/codec_mpeg12.c
>  create mode 100644 drivers/media/platform/meson/vdec/codec_mpeg12.h
>  create mode 100644 drivers/media/platform/meson/vdec/codec_mpeg4.c
>  create mode 100644 drivers/media/platform/meson/vdec/codec_mpeg4.h
>  create mode 100644 drivers/media/platform/meson/vdec/esparser.c
>  create mode 100644 drivers/media/platform/meson/vdec/esparser.h
>  create mode 100644 drivers/media/platform/meson/vdec/hevc_regs.h
>  create mode 100644 drivers/media/platform/meson/vdec/vdec.c
>  create mode 100644 drivers/media/platform/meson/vdec/vdec.h
>  create mode 100644 drivers/media/platform/meson/vdec/vdec_1.c
>  create mode 100644 drivers/media/platform/meson/vdec/vdec_1.h
>  create mode 100644 drivers/media/platform/meson/vdec/vdec_hevc.c
>  create mode 100644 drivers/media/platform/meson/vdec/vdec_hevc.h
>  create mode 100644 drivers/media/platform/meson/vdec/vdec_platform.c
>  create mode 100644 drivers/media/platform/meson/vdec/vdec_platform.h
> 
> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> index 2728376b04b5..42d600b118e2 100644
> --- a/drivers/media/platform/Kconfig
> +++ b/drivers/media/platform/Kconfig
> @@ -482,6 +482,16 @@ config VIDEO_QCOM_VENUS
>  	  on various Qualcomm SoCs.
>  	  To compile this driver as a module choose m here.
>  
> +config VIDEO_AML_MESON_VDEC
> +	tristate "AMLogic video decoder driver"
> +	depends on VIDEO_DEV && VIDEO_V4L2 && HAS_DMA
> +	depends on (ARCH_MESON) || COMPILE_TEST
> +	select VIDEOBUF2_DMA_CONTIG
> +	select V4L2_MEM2MEM_DEV
> +	---help---
> +	Support for the video decoder found in gxbb/gxl/gxm chips.
> +	Can decode MPEG 1/2/4, H.264, MJPEG, HEVC 8-bit.
> +
>  endif # V4L_MEM2MEM_DRIVERS
>  
>  # TI VIDEO PORT Helper Modules
> diff --git a/drivers/media/platform/meson/Makefile b/drivers/media/platform/meson/Makefile
> index 597beb8f34d1..5c935c2c0c68 100644
> --- a/drivers/media/platform/meson/Makefile
> +++ b/drivers/media/platform/meson/Makefile
> @@ -1 +1,2 @@
>  obj-$(CONFIG_VIDEO_MESON_AO_CEC)	+= ao-cec.o
> +obj-$(CONFIG_VIDEO_AML_MESON_VDEC)	+= vdec/
> diff --git a/drivers/media/platform/meson/vdec/Makefile b/drivers/media/platform/meson/vdec/Makefile
> new file mode 100644
> index 000000000000..9f506bce86e1
> --- /dev/null
> +++ b/drivers/media/platform/meson/vdec/Makefile
> @@ -0,0 +1,7 @@
> +# SPDX-License-Identifier: GPL-2.0
> +# Makefile for AMLogic meson video decoder driver
> +
> +meson-vdec-objs += vdec.o vdec_1.o vdec_hevc.o esparser.o canvas.o codec_helpers.o codec_mpeg12.o codec_h264.o codec_hevc.o vdec_platform.o codec_mpeg4.o codec_mjpeg.o
> +
> +obj-$(CONFIG_VIDEO_AML_MESON_VDEC) += meson-vdec.o
> +
> diff --git a/drivers/media/platform/meson/vdec/canvas.c b/drivers/media/platform/meson/vdec/canvas.c
> new file mode 100644
> index 000000000000..92a8cf72a888
> --- /dev/null
> +++ b/drivers/media/platform/meson/vdec/canvas.c
> @@ -0,0 +1,69 @@
> +/*
> + * Copyright (C) 2016 BayLibre, SAS
> + * Author: Neil Armstrong <narmstrong@baylibre.com>
> + * Copyright (C) 2015 Amlogic, Inc. All rights reserved.
> + * Copyright (C) 2014 Endless Mobile
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation; either version 2 of the
> + * License, or (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, see <http://www.gnu.org/licenses/>.
> + */

SPDX instead ?

> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <asm/io.h>
> +#include "canvas.h"
> +
> +/* XXX: There is already a canvas implementation in the DRM subsystem but it's
> + * tied to it. This one is almost entirely copied from it.
> + * We should have a generic canvas provider for meson.
> + */

I suppose this will go away with :
https://lkml.kernel.org/r/20180801185128.23440-1-maxi.jourdan@wanadoo.fr

? If yes, it would have been better to send a version using it directly.

> +
> +/**
> + * DOC: Canvas
> + *
> + * CANVAS is a memory zone where physical memory frames information
> + * are stored for the VIU to scanout.
> + */
> +
> +/* DMC Registers */
> +#define DMC_CAV_LUT_DATAL	0x48 /* 0x12 offset in data sheet */
> +#define CANVAS_WIDTH_LBIT	29
> +#define CANVAS_WIDTH_LWID       3
> +#define DMC_CAV_LUT_DATAH	0x4c /* 0x13 offset in data sheet */
> +#define CANVAS_WIDTH_HBIT       0
> +#define CANVAS_HEIGHT_BIT       9
> +#define CANVAS_BLKMODE_BIT      24
> +#define DMC_CAV_LUT_ADDR	0x50 /* 0x14 offset in data sheet */
> +#define CANVAS_LUT_WR_EN        (0x2 << 8)
> +#define CANVAS_LUT_RD_EN        (0x1 << 8)
> +
> +void vdec_canvas_setup(void __iomem *dmc_base,
> +			uint32_t canvas_index, uint32_t addr,
> +			uint32_t stride, uint32_t height,
> +			unsigned int wrap,
> +			unsigned int blkmode)
> +{
> +	writel_relaxed((((addr + 7) >> 3)) |
> +		(((stride + 7) >> 3) << CANVAS_WIDTH_LBIT), dmc_base + DMC_CAV_LUT_DATAL);
> +
> +	writel_relaxed(((((stride + 7) >> 3) >> CANVAS_WIDTH_LWID) <<
> +						CANVAS_WIDTH_HBIT) |
> +		(height << CANVAS_HEIGHT_BIT) |
> +		(wrap << 22) |
> +		(blkmode << CANVAS_BLKMODE_BIT) | (7 << 26), dmc_base + DMC_CAV_LUT_DATAH);
> +
> +	writel_relaxed(CANVAS_LUT_WR_EN | canvas_index, dmc_base + DMC_CAV_LUT_ADDR);
> +
> +	/* Force a read-back to make sure everything is flushed. */
> +	readl_relaxed(dmc_base + DMC_CAV_LUT_DATAH);
> +}
> diff --git a/drivers/media/platform/meson/vdec/canvas.h b/drivers/media/platform/meson/vdec/canvas.h
> new file mode 100644
> index 000000000000..b8b5409f90ba
> --- /dev/null
> +++ b/drivers/media/platform/meson/vdec/canvas.h
> @@ -0,0 +1,42 @@
> +/*
> + * Copyright (C) 2016 BayLibre, SAS
> + * Author: Neil Armstrong <narmstrong@baylibre.com>
> + * Copyright (C) 2014 Endless Mobile
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation; either version 2 of the
> + * License, or (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +/* Canvas LUT Memory */
> +
> +#ifndef __MESON_CANVAS_H
> +#define __MESON_CANVAS_H
> +
> +#define MESON_CANVAS_ID_OSD1	0x4e
> +
> +/* Canvas configuration. */
> +#define MESON_CANVAS_WRAP_NONE	0x00
> +#define	MESON_CANVAS_WRAP_X	0x01
> +#define	MESON_CANVAS_WRAP_Y	0x02
> +
> +#define	MESON_CANVAS_BLKMODE_LINEAR	0x00
> +#define	MESON_CANVAS_BLKMODE_32x32	0x01
> +#define	MESON_CANVAS_BLKMODE_64x64	0x02
> +
> +void vdec_canvas_setup(void __iomem *dmc_base,
> +			uint32_t canvas_index, uint32_t addr,
> +			uint32_t stride, uint32_t height,
> +			unsigned int wrap,
> +			unsigned int blkmode);
> +
> +#endif /* __MESON_CANVAS_H */
> diff --git a/drivers/media/platform/meson/vdec/codec_h264.c b/drivers/media/platform/meson/vdec/codec_h264.c
> new file mode 100644
> index 000000000000..97621cd38e4d
> --- /dev/null
> +++ b/drivers/media/platform/meson/vdec/codec_h264.c
> @@ -0,0 +1,376 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/*
> + * Copyright (C) 2018 Maxime Jourdan <maxi.jourdan@wanadoo.fr>
> + */
> +
> +#include <media/v4l2-mem2mem.h>
> +#include <media/videobuf2-dma-contig.h>
> +
> +#include "codec_h264.h"
> +#include "codec_helpers.h"
> +#include "canvas.h"
> +
> +#define SIZE_EXT_FW	(SZ_1K * 20)
> +#define SIZE_WORKSPACE	0x1ee000
> +#define SIZE_SEI	(SZ_1K * 8)
> +
> +/* Offset added by the firmware which must be substracted
> + * from the workspace paddr
> + */
> +#define DEF_BUF_START_ADDR 0x1000000
> +
> +/* DOS registers */
> +#define ASSIST_MBOX1_CLR_REG 0x01d4
> +#define ASSIST_MBOX1_MASK    0x01d8
> +
> +#define LMEM_DMA_CTRL 0x0d40
> +
> +#define PSCALE_CTRL 0x2444
> +
> +#define MDEC_PIC_DC_CTRL   0x2638
> +#define ANC0_CANVAS_ADDR   0x2640
> +#define MDEC_PIC_DC_THRESH 0x26e0
> +
> +#define AV_SCRATCH_0  0x2700
> +#define AV_SCRATCH_1  0x2704
> +#define AV_SCRATCH_2  0x2708
> +#define AV_SCRATCH_3  0x270c
> +#define AV_SCRATCH_4  0x2710
> +#define AV_SCRATCH_5  0x2714
> +#define AV_SCRATCH_6  0x2718
> +#define AV_SCRATCH_7  0x271c
> +#define AV_SCRATCH_8  0x2720
> +#define AV_SCRATCH_9  0x2724
> +#define AV_SCRATCH_D  0x2734
> +#define AV_SCRATCH_F  0x273c
> +#define AV_SCRATCH_G  0x2740
> +#define AV_SCRATCH_H  0x2744
> +#define AV_SCRATCH_I  0x2748
> +#define AV_SCRATCH_J  0x274c
> +	#define SEI_DATA_READY BIT(15)
> +
> +#define POWER_CTL_VLD 0x3020
> +
> +#define DCAC_DMA_CTRL 0x3848
> +
> +#define DOS_SW_RESET0 0xfc00
> +
> +struct codec_h264 {
> +	/* H.264 decoder requires an extended firmware loaded in contiguous RAM */
> +	void      *ext_fw_vaddr;
> +	dma_addr_t ext_fw_paddr;
> +
> +	/* Buffer for the H.264 Workspace */
> +	void      *workspace_vaddr;
> +	dma_addr_t workspace_paddr;
> +	
> +	/* Buffer for the H.264 references MV */
> +	void      *ref_vaddr;
> +	dma_addr_t ref_paddr;
> +	u32	   ref_size;
> +
> +	/* Buffer for parsed SEI data ; > M8 ? */
> +	void      *sei_vaddr;
> +	dma_addr_t sei_paddr;
> +
> +	/* Housekeeping thread for recycling buffers into the hardware */
> +	struct task_struct *buffers_thread;
> +};
> +
> +static void codec_h264_recycle_first(struct vdec_session *sess)
> +{
> +	struct vdec_core *core = sess->core;
> +	struct vdec_buffer *tmp;
> +
> +	tmp = list_first_entry(&sess->bufs_recycle, struct vdec_buffer, list);
> +
> +	/* Tell the decoder he can recycle this buffer.
> +	 * AV_SCRATCH_8 serves the same purpose.
> +	 */
> +	if (!readl_relaxed(core->dos_base + AV_SCRATCH_7))
> +		writel_relaxed(tmp->index + 1, core->dos_base + AV_SCRATCH_7);
> +	else
> +		writel_relaxed(tmp->index + 1, core->dos_base + AV_SCRATCH_8);
> +
> +	dev_dbg(core->dev, "Buffer %d recycled\n", tmp->index);
> +
> +	list_del(&tmp->list);
> +	kfree(tmp);
> +}
> +
> +static int codec_h264_buffers_thread(void *data)
> +{
> +	struct vdec_session *sess = data;
> +	struct vdec_core *core = sess->core;
> +
> +	while (!kthread_should_stop()) {
> +		mutex_lock(&sess->bufs_recycle_lock);
> +		while (!list_empty(&sess->bufs_recycle) &&
> +		       (!readl_relaxed(core->dos_base + AV_SCRATCH_7) ||
> +		        !readl_relaxed(core->dos_base + AV_SCRATCH_8)))
> +		{
> +			codec_h264_recycle_first(sess);
> +		}
> +		mutex_unlock(&sess->bufs_recycle_lock);
> +
> +		usleep_range(5000, 10000);
> +	}
> +
> +	return 0;
> +}
> +
> +static int codec_h264_start(struct vdec_session *sess) {
> +	u32 workspace_offset;
> +	struct vdec_core *core = sess->core;
> +	struct codec_h264 *h264 = sess->priv;
> +
> +	/* Allocate some memory for the H.264 decoder's state */
> +	h264->workspace_vaddr =
> +		dma_alloc_coherent(core->dev, SIZE_WORKSPACE, &h264->workspace_paddr, GFP_KERNEL);
> +	if (!h264->workspace_vaddr) {
> +		dev_err(core->dev, "Failed to request H.264 Workspace\n");
> +		return -ENOMEM;
> +	}
> +
> +	/* Allocate some memory for the H.264 SEI dump */
> +	h264->sei_vaddr =
> +		dma_alloc_coherent(core->dev, SIZE_SEI, &h264->sei_paddr, GFP_KERNEL);
> +	if (!h264->sei_vaddr) {
> +		dev_err(core->dev, "Failed to request H.264 SEI\n");
> +		return -ENOMEM;
> +	}
> +
> +	while (readl_relaxed(core->dos_base + DCAC_DMA_CTRL) & 0x8000) { }
> +	while (readl_relaxed(core->dos_base + LMEM_DMA_CTRL) & 0x8000) { }

Is this guarantee to exit at some point or is there a risk of staying stuck here
forever ?

I think regmap has some helper function for polling with a timeout.

> +
> +	writel_relaxed((1<<7) | (1<<6) | (1<<4), core->dos_base + DOS_SW_RESET0);
> +	writel_relaxed(0, core->dos_base + DOS_SW_RESET0);
> +	readl_relaxed(core->dos_base + DOS_SW_RESET0);
> +
> +	writel_relaxed((1<<7) | (1<<6) | (1<<4), core->dos_base + DOS_SW_RESET0);
> +	writel_relaxed(0, core->dos_base + DOS_SW_RESET0);
> +	writel_relaxed((1<<9) | (1<<8), core->dos_base + DOS_SW_RESET0);
> +	writel_relaxed(0, core->dos_base + DOS_SW_RESET0);
> +	readl_relaxed(core->dos_base + DOS_SW_RESET0);
> +
> +	writel_relaxed(readl_relaxed(core->dos_base + POWER_CTL_VLD) | (1 << 9) | (1 << 6), core->dos_base + POWER_CTL_VLD);
> +
> +	writel_relaxed(0, core->dos_base + PSCALE_CTRL);
> +	writel_relaxed(0, core->dos_base + AV_SCRATCH_0);
> +
> +	workspace_offset = h264->workspace_paddr - DEF_BUF_START_ADDR;
> +	writel_relaxed(workspace_offset, core->dos_base + AV_SCRATCH_1);
> +	writel_relaxed(h264->ext_fw_paddr, core->dos_base + AV_SCRATCH_G);
> +	writel_relaxed(h264->sei_paddr - workspace_offset, core->dos_base + AV_SCRATCH_I);

Do we have any idea what all the above does ? I suppose, it mostly comes from
reverse engineering the vendor kernel. If possible, a few comments would be
nice.

In general, instead of (1 << x), you could write BIT(x) 

> +
> +	writel_relaxed(0, core->dos_base + AV_SCRATCH_7);
> +	writel_relaxed(0, core->dos_base + AV_SCRATCH_8);
> +	writel_relaxed(0, core->dos_base + AV_SCRATCH_9);
> +
> +	/* Enable "error correction", don't know what it means */
> +	writel_relaxed((readl_relaxed(core->dos_base + AV_SCRATCH_F) & 0xffffffc3) | (1 << 4), core->dos_base + AV_SCRATCH_F);
> +
> +	/* Enable IRQ */
> +	writel_relaxed(1, core->dos_base + ASSIST_MBOX1_CLR_REG);
> +	writel_relaxed(1, core->dos_base + ASSIST_MBOX1_MASK);
> +
> +	/* Enable 2-plane output */
> +	writel_relaxed(readl_relaxed(core->dos_base + MDEC_PIC_DC_CTRL) | (1 << 17), core->dos_base + MDEC_PIC_DC_CTRL);
> +
> +	writel_relaxed(0x404038aa, core->dos_base + MDEC_PIC_DC_THRESH);
> +	
> +	writel_relaxed((1<<12)|(1<<11), core->dos_base + DOS_SW_RESET0);
> +	writel_relaxed(0, core->dos_base + DOS_SW_RESET0);
> +
> +	readl_relaxed(core->dos_base + DOS_SW_RESET0);
> +	
> +	h264->buffers_thread = kthread_run(codec_h264_buffers_thread, sess, "buffers_done");
> +	
> +	return 0;
> +}
> +
> +static int codec_h264_stop(struct vdec_session *sess)
> +{
> +	struct codec_h264 *h264 = sess->priv;
> +	struct vdec_core *core = sess->core;
> +
> +	kthread_stop(h264->buffers_thread);
> +
> +	if (h264->ext_fw_vaddr)
> +		dma_free_coherent(core->dev, SIZE_EXT_FW, h264->ext_fw_vaddr, h264->ext_fw_paddr);
> +	
> +	if (h264->workspace_vaddr)
> +		dma_free_coherent(core->dev, SIZE_WORKSPACE, h264->workspace_vaddr, h264->workspace_paddr);
> +	
> +	if (h264->ref_vaddr)
> +		dma_free_coherent(core->dev, h264->ref_size, h264->ref_vaddr, h264->ref_paddr);
> +	
> +	if (h264->sei_vaddr)
> +		dma_free_coherent(core->dev, SIZE_SEI, h264->sei_vaddr, h264->sei_paddr);
> +
> +	kfree(h264);
> +	sess->priv = 0;
> +	
> +	return 0;
> +}
> +
> +static int codec_h264_load_extended_firmware(struct vdec_session *sess, const u8 *data, u32 len)
> +{
> +	struct codec_h264 *h264;
> +	struct vdec_core *core = sess->core;
> +	
> +	h264 = kzalloc(sizeof(*h264), GFP_KERNEL);
> +	if (!h264)
> +		return -ENOMEM;
> +		
> +	sess->priv = h264;
> +
> +	if (len != SIZE_EXT_FW)
> +		return -EINVAL;
> +	
> +	h264->ext_fw_vaddr = dma_alloc_coherent(core->dev, SIZE_EXT_FW, &h264->ext_fw_paddr, GFP_KERNEL);
> +	if (!h264->ext_fw_vaddr) {
> +		dev_err(core->dev, "Couldn't allocate memory for H.264 extended firmware\n");
> +		return -ENOMEM;
> +	}
> +
> +	memcpy(h264->ext_fw_vaddr, data, SIZE_EXT_FW);
> +
> +	return 0;
> +}
> +
> +/* Configure the H.264 decoder when the esparser finished parsing
> + * the first buffer.
> + */
> +static void codec_h264_set_param(struct vdec_session *sess) {
> +	u32 max_reference_size;
> +	u32 parsed_info, mb_width, mb_height, mb_total;
> +	u32 mb_mv_byte;
> +	u32 actual_dpb_size = v4l2_m2m_num_dst_bufs_ready(sess->m2m_ctx);
> +	u32 max_dpb_size = 4;
> +	struct vdec_core *core = sess->core;
> +	struct codec_h264 *h264 = sess->priv;
> +
> +	writel_relaxed(0, core->dos_base + AV_SCRATCH_7);
> +	writel_relaxed(0, core->dos_base + AV_SCRATCH_8);
> +	writel_relaxed(0, core->dos_base + AV_SCRATCH_9);
> +
> +	parsed_info = readl_relaxed(core->dos_base + AV_SCRATCH_1);
> +
> +	/* Total number of 16x16 macroblocks */

What the about defining the filter shift and width, using GENMASK() maybe ?

> +	mb_total = (parsed_info >> 8) & 0xffff;
> +
> +	/* Size of Motion Vector per macroblock ? */
> +	mb_mv_byte = (parsed_info & 0x80000000) ? 24 : 96;

#define FOO_MB_SIZE BIT(28)
(parsed_info & FOO_MB_SIZE) ?

> +
> +	/* Number of macroblocks per line */
> +	mb_width = parsed_info & 0xff;
> +
> +	/* Number of macroblock lines */
> +	mb_height = mb_total / mb_width;
> +
> +	max_reference_size = (parsed_info >> 24) & 0x7f;
> +
> +	/* Align to a multiple of 4 macroblocks */
> +	mb_width = (mb_width + 3) & 0xfffffffc;
> +	mb_height = (mb_height + 3) & 0xfffffffc;
> +	mb_total = mb_width * mb_height;
> +
> +	codec_helper_set_canvases(sess, core->dos_base + ANC0_CANVAS_ADDR);
> +
> +	if (max_reference_size >= max_dpb_size)
> +		max_dpb_size = max_reference_size;
> +
> +	max_reference_size++;
> +
> +	h264->ref_size = mb_total * mb_mv_byte * max_reference_size;
> +	h264->ref_vaddr = dma_alloc_coherent(core->dev, h264->ref_size, &h264->ref_paddr, GFP_ATOMIC);
> +
> +	/* Address to store the references' MVs ? */
> +	writel_relaxed(h264->ref_paddr, core->dos_base + AV_SCRATCH_1);
> +
> +	/* End of ref MV */
> +	writel_relaxed(h264->ref_paddr + h264->ref_size, core->dos_base + AV_SCRATCH_4);
> +
> +	writel_relaxed((max_reference_size << 24) | (actual_dpb_size << 16) | (max_dpb_size << 8), core->dos_base + AV_SCRATCH_0);

I know it is not always easy, especially with very little documentation, but
could you #define a bit more the content of the registers:

something like 
#define BAR_MAX_REF_SHIFT 24

You get the idea ..

> +}
> +
> +static void codec_h264_frames_ready(struct vdec_session *sess, u32 status)
> +{
> +	struct vdec_core *core = sess->core;
> +	int error_count;
> +	int error;
> +	int num_frames;
> +	int frame_status;
> +	unsigned int buffer_index;
> +	int i;
> +
> +	error_count = readl_relaxed(core->dos_base + AV_SCRATCH_D);
> +	num_frames = (status >> 8) & 0xff;
> +	if (error_count) {
> +		dev_warn(core->dev,
> +			"decoder error(s) happened, count %d\n", error_count);
> +		writel_relaxed(0, core->dos_base + AV_SCRATCH_D);
> +	}
> +
> +	for (i = 0; i < num_frames; i++) {
> +		frame_status = readl_relaxed(core->dos_base + AV_SCRATCH_1 + i*4);
> +		buffer_index = frame_status & 0x1f;
> +		error = frame_status & 0x200;
> +
> +		/* A buffer decode error means it was decoded,
> +		 * but part of the picture will have artifacts.
> +		 * Typical reason is a temporarily corrupted bitstream
> +		 */
> +		if (error)
> +			dev_dbg(core->dev, "Buffer %d decode error: %08X\n",
> +				buffer_index, error);
> +
> +		vdec_dst_buf_done_idx(sess, buffer_index);
> +	}
> +}
> +
> +static irqreturn_t codec_h264_threaded_isr(struct vdec_session *sess)
> +{
> +	u32 status;
> +	u8 cmd;
> +	struct vdec_core *core = sess->core;
> +
> +	status = readl_relaxed(core->dos_base + AV_SCRATCH_0);
> +	cmd = status & 0xff;
> +
> +	if (cmd == 1) {

Same kind of comment, could define those command somewhere to this a bit more
readable ?

> +		codec_h264_set_param(sess);
> +	} else if (cmd == 2) {
> +		codec_h264_frames_ready(sess, status);
> +		writel_relaxed(0, core->dos_base + AV_SCRATCH_0);
> +	} else if (cmd != 0) {
> +		dev_warn(core->dev, "Unexpected cmd: %08X\n", cmd);
> +		writel_relaxed(0, core->dos_base + AV_SCRATCH_0);
> +	}
> +
> +	/* Decoder has some SEI data for us ; ignore */
> +	if (readl_relaxed(core->dos_base + AV_SCRATCH_J) & SEI_DATA_READY)
> +		writel_relaxed(0, core->dos_base + AV_SCRATCH_J);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static irqreturn_t codec_h264_isr(struct vdec_session *sess)
> +{
> +	struct vdec_core *core = sess->core;
> +
> +	writel_relaxed(1, core->dos_base + ASSIST_MBOX1_CLR_REG);
> +
> +	return IRQ_WAKE_THREAD;
> +}
> +
> +struct vdec_codec_ops codec_h264_ops = {
> +	.start = codec_h264_start,
> +	.stop = codec_h264_stop,
> +	.load_extended_firmware = codec_h264_load_extended_firmware,
> +	.isr = codec_h264_isr,
> +	.threaded_isr = codec_h264_threaded_isr,
> +	.notify_dst_buffer = vdec_queue_recycle,
> +};
> +
> diff --git a/drivers/media/platform/meson/vdec/codec_h264.h b/drivers/media/platform/meson/vdec/codec_h264.h
> new file mode 100644
> index 000000000000..1a159131b1bf
> --- /dev/null
> +++ b/drivers/media/platform/meson/vdec/codec_h264.h
> @@ -0,0 +1,13 @@
> +/* SPDX-License-Identifier: GPL-2.0+ */
> +/*
> + * Copyright (C) 2018 Maxime Jourdan <maxi.jourdan@wanadoo.fr>
> + */
> +
> +#ifndef __MESON_VDEC_CODEC_H264_H_
> +#define __MESON_VDEC_CODEC_H264_H_
> +
> +#include "vdec.h"
> +
> +extern struct vdec_codec_ops codec_h264_ops;
> +
> +#endif
> \ No newline at end of file
> diff --git a/drivers/media/platform/meson/vdec/codec_helpers.c b/drivers/media/platform/meson/vdec/codec_helpers.c
> new file mode 100644
> index 000000000000..99064331d124
> --- /dev/null
> +++ b/drivers/media/platform/meson/vdec/codec_helpers.c
> @@ -0,0 +1,45 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/*
> + * Copyright (C) 2018 Maxime Jourdan <maxi.jourdan@wanadoo.fr>
> + */
> +
> +#include <media/v4l2-mem2mem.h>
> +#include <media/videobuf2-dma-contig.h>
> +
> +#include "codec_helpers.h"
> +#include "canvas.h"
> +
> +void codec_helper_set_canvases(struct vdec_session *sess, void *reg_base)
> +{
> +	struct vdec_core *core = sess->core;
> +	u32 width = ALIGN(sess->width, 64);
> +	u32 height = ALIGN(sess->height, 64);
> +	struct v4l2_m2m_buffer *buf;
> +
> +	/* Setup NV12 canvases for Decoded Picture Buffer (dpb)
> +	 * Map them to the user buffers' planes
> +	 */
> +	v4l2_m2m_for_each_dst_buf(sess->m2m_ctx, buf) {
> +		u32 buf_idx    = buf->vb.vb2_buf.index;
> +		u32 cnv_y_idx  = 128 + buf_idx * 2;
> +		u32 cnv_uv_idx = cnv_y_idx + 1;
> +		dma_addr_t buf_y_paddr  =
> +			vb2_dma_contig_plane_dma_addr(&buf->vb.vb2_buf, 0);
> +		dma_addr_t buf_uv_paddr =
> +			vb2_dma_contig_plane_dma_addr(&buf->vb.vb2_buf, 1);
> +
> +		/* Y plane */
> +		vdec_canvas_setup(core->dmc_base, cnv_y_idx, buf_y_paddr,
> +			width, height, MESON_CANVAS_WRAP_NONE,
> +			MESON_CANVAS_BLKMODE_LINEAR);
> +
> +		/* U/V plane */
> +		vdec_canvas_setup(core->dmc_base, cnv_uv_idx, buf_uv_paddr,
> +			width, height / 2, MESON_CANVAS_WRAP_NONE,
> +			MESON_CANVAS_BLKMODE_LINEAR);
> +
> +		writel_relaxed(((cnv_uv_idx) << 16) |
> +			       ((cnv_uv_idx) << 8)  |
> +				(cnv_y_idx), reg_base + buf_idx * 4);
> +	}
> +}
> \ No newline at end of file
> diff --git a/drivers/media/platform/meson/vdec/codec_helpers.h b/drivers/media/platform/meson/vdec/codec_helpers.h
> new file mode 100644
> index 000000000000..0a778ba0de65
> --- /dev/null
> +++ b/drivers/media/platform/meson/vdec/codec_helpers.h
> @@ -0,0 +1,8 @@
> +#ifndef __MESON_VDEC_CODEC_HELPERS_H_
> +#define __MESON_VDEC_CODEC_HELPERS_H_
> +
> +#include "vdec.h"
> +
> +void codec_helper_set_canvases(struct vdec_session *sess, void *reg_base);
> +
> +#endif
> \ No newline at end of file
> diff --git a/drivers/media/platform/meson/vdec/codec_hevc.c b/drivers/media/platform/meson/vdec/codec_hevc.c
> new file mode 100644
> index 000000000000..cf3e80a3851f
> --- /dev/null
> +++ b/drivers/media/platform/meson/vdec/codec_hevc.c
> @@ -0,0 +1,1383 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/*
> + * Copyright (C) 2018 Maxime Jourdan <maxi.jourdan@wanadoo.fr>
> + * Copyright (C) 2015 Amlogic, Inc. All rights reserved.
> + */
> +
> +#include <media/v4l2-mem2mem.h>
> +#include <media/videobuf2-dma-contig.h>
> +
> +#include "codec_hevc.h"
> +#include "canvas.h"
> +#include "hevc_regs.h"
> +
> +/* DOS registers */
> +#define ASSIST_MBOX1_CLR_REG 0x01d4
> +#define ASSIST_MBOX1_MASK    0x01d8
> +
> +#define DOS_SW_RESET3        0xfcd0
> +
> +/* HEVC reg mapping */
> +#define HEVC_DEC_STATUS_REG	HEVC_ASSIST_SCRATCH_0
> +	#define HEVC_ACTION_DONE	0xff
> +#define HEVC_RPM_BUFFER		HEVC_ASSIST_SCRATCH_1
> +#define HEVC_DECODE_INFO	HEVC_ASSIST_SCRATCH_1
> +#define HEVC_SHORT_TERM_RPS	HEVC_ASSIST_SCRATCH_2
> +#define HEVC_VPS_BUFFER		HEVC_ASSIST_SCRATCH_3
> +#define HEVC_SPS_BUFFER		HEVC_ASSIST_SCRATCH_4
> +#define HEVC_PPS_BUFFER		HEVC_ASSIST_SCRATCH_5
> +#define HEVC_SAO_UP		HEVC_ASSIST_SCRATCH_6
> +#define HEVC_STREAM_SWAP_BUFFER HEVC_ASSIST_SCRATCH_7
> +#define H265_MMU_MAP_BUFFER	HEVC_ASSIST_SCRATCH_7
> +#define HEVC_STREAM_SWAP_BUFFER2 HEVC_ASSIST_SCRATCH_8
> +#define HEVC_sao_mem_unit	HEVC_ASSIST_SCRATCH_9
> +#define HEVC_SAO_ABV		HEVC_ASSIST_SCRATCH_A
> +#define HEVC_sao_vb_size	HEVC_ASSIST_SCRATCH_B
> +#define HEVC_SAO_VB		HEVC_ASSIST_SCRATCH_C
> +#define HEVC_SCALELUT		HEVC_ASSIST_SCRATCH_D
> +#define HEVC_WAIT_FLAG		HEVC_ASSIST_SCRATCH_E
> +#define RPM_CMD_REG		HEVC_ASSIST_SCRATCH_F
> +#define LMEM_DUMP_ADR		HEVC_ASSIST_SCRATCH_F
> +#define DEBUG_REG1		HEVC_ASSIST_SCRATCH_G
> +#define HEVC_DECODE_MODE2	HEVC_ASSIST_SCRATCH_H
> +#define NAL_SEARCH_CTL		HEVC_ASSIST_SCRATCH_I
> +#define HEVC_DECODE_MODE	HEVC_ASSIST_SCRATCH_J
> +	#define DECODE_MODE_SINGLE 0
> +#define DECODE_STOP_POS		HEVC_ASSIST_SCRATCH_K
> +#define HEVC_AUX_ADR		HEVC_ASSIST_SCRATCH_L
> +#define HEVC_AUX_DATA_SIZE	HEVC_ASSIST_SCRATCH_M
> +#define HEVC_DECODE_SIZE	HEVC_ASSIST_SCRATCH_N
> +
> +#define HEVCD_MPP_ANC2AXI_TBL_DATA (0x3464 * 4)
> +
> +#define HEVC_CM_BODY_START_ADDR	(0x3626 * 4)
> +#define HEVC_CM_BODY_LENGTH	(0x3627 * 4)
> +#define HEVC_CM_HEADER_LENGTH	(0x3629 * 4)
> +#define HEVC_CM_HEADER_OFFSET	(0x362b * 4)
> +
> +#define AMRISC_MAIN_REQ		 0x04
> +
> +/* HEVC Constants */
> +#define MAX_REF_PIC_NUM		24
> +#define MAX_REF_ACTIVE		16
> +#define MPRED_MV_BUF_SIZE	0x120000
> +#define MAX_TILE_COL_NUM	10
> +#define MAX_TILE_ROW_NUM	20
> +#define MAX_SLICE_NUM		800
> +#define INVALID_POC		0x80000000
> +
> +/* HEVC Workspace layout */
> +#define IPP_OFFSET       0x00
> +#define SAO_ABV_OFFSET   (IPP_OFFSET + 0x4000)
> +#define SAO_VB_OFFSET    (SAO_ABV_OFFSET + 0x30000)
> +#define SH_TM_RPS_OFFSET (SAO_VB_OFFSET + 0x30000)
> +#define VPS_OFFSET       (SH_TM_RPS_OFFSET + 0x800)
> +#define SPS_OFFSET       (VPS_OFFSET + 0x800)
> +#define PPS_OFFSET       (SPS_OFFSET + 0x800)
> +#define SAO_UP_OFFSET    (PPS_OFFSET + 0x2000)
> +#define SWAP_BUF_OFFSET  (SAO_UP_OFFSET + 0x800)
> +#define SWAP_BUF2_OFFSET (SWAP_BUF_OFFSET + 0x800)
> +#define SCALELUT_OFFSET  (SWAP_BUF2_OFFSET + 0x800)
> +#define DBLK_PARA_OFFSET (SCALELUT_OFFSET + 0x8000)
> +#define DBLK_DATA_OFFSET (DBLK_PARA_OFFSET + 0x20000)
> +#define MMU_VBH_OFFSET   (DBLK_DATA_OFFSET + 0x40000)
> +#define MPRED_ABV_OFFSET (MMU_VBH_OFFSET + 0x5000)
> +#define MPRED_MV_OFFSET  (MPRED_ABV_OFFSET + 0x8000)
> +#define RPM_OFFSET       (MPRED_MV_OFFSET + MPRED_MV_BUF_SIZE * MAX_REF_PIC_NUM)
> +#define LMEM_OFFSET      (RPM_OFFSET + 0x100)
> +
> +/* ISR decode status */
> +#define HEVC_DEC_IDLE                        0x0
> +#define HEVC_NAL_UNIT_VPS                    0x1
> +#define HEVC_NAL_UNIT_SPS                    0x2
> +#define HEVC_NAL_UNIT_PPS                    0x3
> +#define HEVC_NAL_UNIT_CODED_SLICE_SEGMENT    0x4
> +#define HEVC_CODED_SLICE_SEGMENT_DAT         0x5
> +#define HEVC_SLICE_DECODING                  0x6
> +#define HEVC_NAL_UNIT_SEI                    0x7
> +#define HEVC_SLICE_SEGMENT_DONE              0x8
> +#define HEVC_NAL_SEARCH_DONE                 0x9
> +#define HEVC_DECPIC_DATA_DONE                0xa
> +#define HEVC_DECPIC_DATA_ERROR               0xb
> +#define HEVC_SEI_DAT                         0xc
> +#define HEVC_SEI_DAT_DONE                    0xd
> +
> +/* RPM misc_flag0 */
> +#define PCM_LOOP_FILTER_DISABLED_FLAG_BIT		0
> +#define PCM_ENABLE_FLAG_BIT				1
> +#define LOOP_FILER_ACROSS_TILES_ENABLED_FLAG_BIT	2
> +#define PPS_LOOP_FILTER_ACROSS_SLICES_ENABLED_FLAG_BIT	3
> +#define DEBLOCKING_FILTER_OVERRIDE_ENABLED_FLAG_BIT	4
> +#define PPS_DEBLOCKING_FILTER_DISABLED_FLAG_BIT		5
> +#define DEBLOCKING_FILTER_OVERRIDE_FLAG_BIT		6
> +#define SLICE_DEBLOCKING_FILTER_DISABLED_FLAG_BIT	7
> +#define SLICE_SAO_LUMA_FLAG_BIT				8
> +#define SLICE_SAO_CHROMA_FLAG_BIT			9
> +#define SLICE_LOOP_FILTER_ACROSS_SLICES_ENABLED_FLAG_BIT 10
> +
> +/* Buffer sizes */
> +#define SIZE_WORKSPACE ALIGN(LMEM_OFFSET + 0xA00, 64 * SZ_1K)
> +#define SIZE_AUX (SZ_1K * 16)
> +#define SIZE_FRAME_MMU (0x1200 * 4)
> +#define RPM_SIZE 0x80
> +#define RPS_USED_BIT 14
> +
> +#define PARSER_CMD_SKIP_CFG_0 0x0000090b
> +#define PARSER_CMD_SKIP_CFG_1 0x1b14140f
> +#define PARSER_CMD_SKIP_CFG_2 0x001b1910
> +static const uint16_t parser_cmd[] = {
> +	0x0401,	0x8401,	0x0800,	0x0402,
> +	0x9002,	0x1423,	0x8CC3,	0x1423,
> +	0x8804,	0x9825,	0x0800,	0x04FE,
> +	0x8406,	0x8411,	0x1800,	0x8408,
> +	0x8409,	0x8C2A,	0x9C2B,	0x1C00,
> +	0x840F,	0x8407,	0x8000,	0x8408,
> +	0x2000,	0xA800,	0x8410,	0x04DE,
> +	0x840C,	0x840D,	0xAC00,	0xA000,
> +	0x08C0,	0x08E0,	0xA40E,	0xFC00,
> +	0x7C00
> +};
> +
> +/* Data received from the HW in this form, do not rearrange */
> +union rpm_param {
> +	struct {
> +		uint16_t data[RPM_SIZE];
> +	} l;
> +	struct {
> +		uint16_t CUR_RPS[MAX_REF_ACTIVE];
> +		uint16_t num_ref_idx_l0_active;
> +		uint16_t num_ref_idx_l1_active;
> +		uint16_t slice_type;
> +		uint16_t slice_temporal_mvp_enable_flag;
> +		uint16_t dependent_slice_segment_flag;
> +		uint16_t slice_segment_address;
> +		uint16_t num_title_rows_minus1;
> +		uint16_t pic_width_in_luma_samples;
> +		uint16_t pic_height_in_luma_samples;
> +		uint16_t log2_min_coding_block_size_minus3;
> +		uint16_t log2_diff_max_min_coding_block_size;
> +		uint16_t log2_max_pic_order_cnt_lsb_minus4;
> +		uint16_t POClsb;
> +		uint16_t collocated_from_l0_flag;
> +		uint16_t collocated_ref_idx;
> +		uint16_t log2_parallel_merge_level;
> +		uint16_t five_minus_max_num_merge_cand;
> +		uint16_t sps_num_reorder_pics_0;
> +		uint16_t modification_flag;
> +		uint16_t tiles_flags;
> +		uint16_t num_tile_columns_minus1;
> +		uint16_t num_tile_rows_minus1;
> +		uint16_t tile_width[8];
> +		uint16_t tile_height[8];
> +		uint16_t misc_flag0;
> +		uint16_t pps_beta_offset_div2;
> +		uint16_t pps_tc_offset_div2;
> +		uint16_t slice_beta_offset_div2;
> +		uint16_t slice_tc_offset_div2;
> +		uint16_t pps_cb_qp_offset;
> +		uint16_t pps_cr_qp_offset;
> +		uint16_t first_slice_segment_in_pic_flag;
> +		uint16_t m_temporalId;
> +		uint16_t m_nalUnitType;
> +		uint16_t vui_num_units_in_tick_hi;
> +		uint16_t vui_num_units_in_tick_lo;
> +		uint16_t vui_time_scale_hi;
> +		uint16_t vui_time_scale_lo;
> +		uint16_t bit_depth;
> +		uint16_t profile_etc;
> +		uint16_t sei_frame_field_info;
> +		uint16_t video_signal_type;
> +		uint16_t modification_list[0x20];
> +		uint16_t conformance_window_flag;
> +		uint16_t conf_win_left_offset;
> +		uint16_t conf_win_right_offset;
> +		uint16_t conf_win_top_offset;
> +		uint16_t conf_win_bottom_offset;
> +		uint16_t chroma_format_idc;
> +		uint16_t color_description;
> +		uint16_t aspect_ratio_idc;
> +		uint16_t sar_width;
> +		uint16_t sar_height;
> +	} p;
> +};
> +
> +enum nal_unit_type {
> +	NAL_UNIT_CODED_SLICE_BLA	= 16,
> +	NAL_UNIT_CODED_SLICE_BLANT	= 17,
> +	NAL_UNIT_CODED_SLICE_BLA_N_LP	= 18,
> +	NAL_UNIT_CODED_SLICE_IDR	= 19,
> +	NAL_UNIT_CODED_SLICE_IDR_N_LP	= 20,
> +};
> +
> +enum slice_type {
> +	B_SLICE = 0,
> +	P_SLICE = 1,
> +	I_SLICE = 2,
> +};
> +
> +/* Refers to a frame being decoded */
> +struct hevc_frame {
> +	struct list_head list;
> +	struct vb2_v4l2_buffer *vbuf;
> +	u32 poc;
> +
> +	int referenced;
> +	u32 num_reorder_pic;
> +
> +	u32 cur_slice_idx;
> +	u32 cur_slice_type;
> +
> +	/* 2 lists (L0/L1) ; 800 slices ; 16 refs */
> +	u32 ref_poc_list[2][MAX_SLICE_NUM][16];
> +	u32 ref_num[2];
> +};
> +
> +struct hevc_tile {
> +	int width;
> +	int height;
> +	int start_cu_x;
> +	int start_cu_y;
> +
> +	dma_addr_t sao_vb_start_addr;
> +	dma_addr_t sao_abv_start_addr;
> +};
> +
> +struct codec_hevc {
> +	/* Current decoding status provided by the ISR */
> +	u32 dec_status;
> +
> +	/* Buffer for the HEVC Workspace */
> +	void      *workspace_vaddr;
> +	dma_addr_t workspace_paddr;
> +
> +	/* AUX buffer */
> +	void      *aux_vaddr;
> +	dma_addr_t aux_paddr;
> +
> +	/* Frame MMU buffer (>= GXL) ; unused for now */
> +	void      *frame_mmu_vaddr;
> +	dma_addr_t frame_mmu_paddr;
> +
> +	/* Contains many information parsed from the bitstream */
> +	union rpm_param rpm_param;
> +
> +	/* Information computed from the RPM */
> +	u32 lcu_size; // Largest Coding Unit
> +	u32 lcu_x_num;
> +	u32 lcu_y_num;
> +	u32 lcu_total;
> +
> +	/* Current Frame being handled */
> +	struct hevc_frame *cur_frame;
> +	u32 curr_poc;
> +	/* Collocated Reference Picture */
> +	struct hevc_frame *col_frame;
> +	u32 col_poc;
> +
> +	/* All ref frames used by the HW at a given time */
> +	struct list_head ref_frames_list;
> +	u32 frames_num;
> +
> +	/* Resolution reported by the hardware */
> +	u32 width;
> +	u32 height;
> +
> +	u32 iPrevTid0POC;
> +	u32 slice_segment_addr;
> +	u32 slice_addr;
> +	u32 ldc_flag;
> +
> +	/* Tiles */
> +	u32 num_tile_col;
> +	u32 num_tile_row;
> +	struct hevc_tile m_tile[MAX_TILE_ROW_NUM][MAX_TILE_COL_NUM];
> +	u32 tile_start_lcu_x;
> +	u32 tile_start_lcu_y;
> +	u32 tile_width_lcu;
> +	u32 tile_height_lcu;
> +};
> +
> +static u32 codec_hevc_num_pending_bufs(struct vdec_session *sess)
> +{
> +	struct codec_hevc *hevc;
> +	u32 ret;
> +
> +	mutex_lock(&sess->codec_lock);
> +	hevc = sess->priv;
> +	if (!hevc) {
> +		mutex_unlock(&sess->codec_lock);
> +		return 0;
> +	}
> +
> +	ret = hevc->frames_num;
> +	mutex_unlock(&sess->codec_lock);
> +
> +	return ret;
> +}
> +
> +/* Update the L0 and L1 reference lists for a given frame */
> +static void codec_hevc_update_frame_refs(struct vdec_session *sess, struct hevc_frame *frame)
> +{
> +	struct codec_hevc *hevc = sess->priv;
> +	union rpm_param *params = &hevc->rpm_param;
> +	int i;
> +	int num_neg = 0;
> +	int num_pos = 0;
> +	int total_num;
> +	int num_ref_idx_l0_active =
> +		(params->p.num_ref_idx_l0_active > MAX_REF_ACTIVE) ?
> +		MAX_REF_ACTIVE : params->p.num_ref_idx_l0_active;
> +	int num_ref_idx_l1_active =
> +		(params->p.num_ref_idx_l1_active > MAX_REF_ACTIVE) ?
> +		MAX_REF_ACTIVE : params->p.num_ref_idx_l1_active;
> +	int ref_picset0[16] = { 0 };
> +	int ref_picset1[16] = { 0 };
> +
> +	for (i = 0; i < 16; i++) {
> +		frame->ref_poc_list[0][frame->cur_slice_idx][i] = 0;
> +		frame->ref_poc_list[1][frame->cur_slice_idx][i] = 0;
> +	}
> +
> +	for (i = 0; i < 16; i++) {
> +		u16 cur_rps = params->p.CUR_RPS[i];
> +		int delt = cur_rps & ((1 << (RPS_USED_BIT - 1)) - 1);

Looks like using GENMASK would make things a bit more readable here.

> +
> +		if (cur_rps & 0x8000)

BIT(15) ? any idea what this is ? could we define this ?

Same comment in general for the rest of the patch. If you can replace mask and
bit calculation with related macro and define things a bit more, it would be
nice.

> +			break;
> +
> +		if (!((cur_rps >> RPS_USED_BIT) & 1))
> +			continue;
> +
> +		if ((cur_rps >> (RPS_USED_BIT - 1)) & 1) {
> +			ref_picset0[num_neg] =
> +			       frame->poc - ((1 << (RPS_USED_BIT - 1)) - delt);
> +			num_neg++;
> +		} else {
> +			ref_picset1[num_pos] = frame->poc + delt;
> +			num_pos++;
> +		}
> +	}
> +
> +	total_num = num_neg + num_pos;
> +
> +	if (total_num <= 0)
> +		goto end;
> +
> +	for (i = 0; i < num_ref_idx_l0_active; i++) {
> +		int cIdx;

Could we avoid cAmEl case ?

> +		if (params->p.modification_flag & 0x1)
> +			cIdx = params->p.modification_list[i];
> +		else
> +			cIdx = i % total_num;
> +
> +		frame->ref_poc_list[0][frame->cur_slice_idx][i] =
> +			cIdx >= num_neg ? ref_picset1[cIdx - num_neg] :
> +			ref_picset0[cIdx];
> +	}
> +
> +	if (params->p.slice_type != B_SLICE)
> +		goto end;
> +
> +	if (params->p.modification_flag & 0x2) {
> +		for (i = 0; i < num_ref_idx_l1_active; i++) {
> +			int cIdx;
> +			if (params->p.modification_flag & 0x1)
> +				cIdx =
> +				params->p.modification_list[num_ref_idx_l0_active + i];
> +			else
> +				cIdx = params->p.modification_list[i];
> +
> +			frame->ref_poc_list[1][frame->cur_slice_idx][i] =
> +				(cIdx >= num_pos) ? ref_picset0[cIdx - num_pos]
> +				: ref_picset1[cIdx];
> +		}
> +	} else {
> +		for (i = 0; i < num_ref_idx_l1_active; i++) {
> +			int cIdx = i % total_num;
> +			frame->ref_poc_list[1][frame->cur_slice_idx][i] =
> +				cIdx >= num_pos ? ref_picset0[cIdx - num_pos] :
> +				ref_picset1[cIdx];
> +		}
> +	}
> +
> +end:
> +	frame->ref_num[0] = num_ref_idx_l0_active;
> +	frame->ref_num[1] = num_ref_idx_l1_active;
> +
> +	dev_dbg(sess->core->dev,
> +		"Frame %u; slice %u; slice_type %u; num_l0 %u; num_l1 %u\n",
> +		frame->poc, frame->cur_slice_idx, params->p.slice_type,
> +		frame->ref_num[0], frame->ref_num[1]);
> +}
> +
> +static void codec_hevc_update_ldc_flag(struct codec_hevc *hevc)
> +{
> +	struct hevc_frame *frame = hevc->cur_frame;
> +	u32 slice_type = frame->cur_slice_type;
> +	int i;
> +
> +	hevc->ldc_flag = 0;
> +
> +	if (slice_type == I_SLICE)
> +		return;
> +
> +	hevc->ldc_flag = 1;
> +	for (i = 0; (i < frame->ref_num[0]) && hevc->ldc_flag; i++) {
> +		if (frame->ref_poc_list[0][frame->cur_slice_idx][i] > frame->poc) {
> +			hevc->ldc_flag = 0;
> +			break;
> +		}
> +	}
> +
> +	if (slice_type == P_SLICE)
> +		return;
> +
> +	for (i = 0; (i < frame->ref_num[1]) && hevc->ldc_flag; i++) {
> +		if (frame->ref_poc_list[1][frame->cur_slice_idx][i] > frame->poc) {
> +			hevc->ldc_flag = 0;
> +			break;
> +		}
> +	}
> +}
> +
> +/* Tag "old" frames that are no longer referenced */
> +static void codec_hevc_update_referenced(struct codec_hevc *hevc)
> +{
> +	union rpm_param *param = &hevc->rpm_param;
> +	struct hevc_frame *frame;
> +	int i;
> +	u32 curr_poc = hevc->curr_poc;
> +
> +	list_for_each_entry(frame, &hevc->ref_frames_list, list) {
> +		int is_referenced = 0;
> +		u32 poc_tmp;
> +
> +		if (!frame->referenced)
> +			continue;
> +
> +		for (i = 0; i < MAX_REF_ACTIVE; i++) {
> +			int delt;
> +			if (param->p.CUR_RPS[i] & 0x8000)
> +				break;
> +
> +			delt = param->p.CUR_RPS[i] & ((1 << (RPS_USED_BIT - 1)) - 1);
> +			if (param->p.CUR_RPS[i] & (1 << (RPS_USED_BIT - 1))) {
> +				poc_tmp = curr_poc - ((1 << (RPS_USED_BIT - 1)) - delt);
> +			} else
> +				poc_tmp = curr_poc + delt;
> +			if (poc_tmp == frame->poc) {
> +				is_referenced = 1;
> +				break;
> +			}
> +		}
> +
> +		frame->referenced = is_referenced;
> +	}
> +}
> +
> +static struct hevc_frame *codec_hevc_get_lowest_poc_frame(struct codec_hevc *hevc)
> +{
> +	struct hevc_frame *tmp, *ret = NULL;
> +	u32 poc = INT_MAX;
> +
> +	list_for_each_entry(tmp, &hevc->ref_frames_list, list) {
> +		if (tmp->poc < poc) {
> +			ret = tmp;
> +			poc = tmp->poc;
> +		}
> +	}
> +
> +	return ret;
> +}
> +
> +/* Try to output as many frames as possible */
> +static void codec_hevc_output_frames(struct vdec_session *sess)
> +{
> +	struct hevc_frame *tmp;
> +	struct codec_hevc *hevc = sess->priv;
> +
> +	while ((tmp = codec_hevc_get_lowest_poc_frame(hevc))) {
> +		if (tmp->referenced || tmp->num_reorder_pic >= hevc->frames_num)
> +			break;
> +
> +		dev_dbg(sess->core->dev, "DONE frame poc %u; vbuf %u\n",
> +			tmp->poc, tmp->vbuf->vb2_buf.index);
> +		vdec_dst_buf_done(sess, tmp->vbuf);
> +		list_del(&tmp->list);
> +		kfree(tmp);
> +		hevc->frames_num--;
> +	}
> +}
> +
> +/* Configure part of the IP responsible for frame buffer decompression */
> +static  void codec_hevc_setup_decode_head(struct vdec_session *sess)
> +{
> +	struct vdec_core *core = sess->core;
> +
> +	/* TODO */
> +	writel_relaxed(0, core->dos_base + HEVCD_MPP_DECOMP_CTL1);
> +	writel_relaxed(0, core->dos_base + HEVCD_MPP_DECOMP_CTL2);
> +	writel_relaxed(0, core->dos_base + HEVC_CM_BODY_LENGTH);
> +	writel_relaxed(0, core->dos_base + HEVC_CM_HEADER_OFFSET);
> +	writel_relaxed(0, core->dos_base + HEVC_CM_HEADER_LENGTH);
> +}
> +
> +static void codec_hevc_setup_buffers_gxbb(struct vdec_session *sess)
> +{
> +	struct vdec_core *core = sess->core;
> +	struct v4l2_m2m_buffer *buf;
> +	u32 buf_size = v4l2_m2m_num_dst_bufs_ready(sess->m2m_ctx);
> +	dma_addr_t buf_y_paddr = 0;
> +	dma_addr_t buf_uv_paddr = 0;
> +	u32 idx = 0;
> +	u32 val;
> +	int i;
> +
> +	writel_relaxed(0, core->dos_base + HEVCD_MPP_ANC2AXI_TBL_CONF_ADDR);
> +
> +	v4l2_m2m_for_each_dst_buf(sess->m2m_ctx, buf) {
> +		idx = buf->vb.vb2_buf.index;
> +		buf_y_paddr  = vb2_dma_contig_plane_dma_addr(&buf->vb.vb2_buf, 0);
> +		buf_uv_paddr = vb2_dma_contig_plane_dma_addr(&buf->vb.vb2_buf, 1);
> +
> +		val = buf_y_paddr | ((idx * 2) << 8) | 1;
> +		writel_relaxed(val, core->dos_base + HEVCD_MPP_ANC2AXI_TBL_CMD_ADDR);
> +		val = buf_uv_paddr | ((idx * 2 + 1) << 8) | 1;
> +		writel_relaxed(val, core->dos_base + HEVCD_MPP_ANC2AXI_TBL_CMD_ADDR);
> +	}
> +
> +	val = buf_y_paddr | ((idx * 2) << 8) | 1;
> +	/* Fill the remaining unused slots with the last buffer's Y addr */
> +	for (i = buf_size; i < MAX_REF_PIC_NUM; ++i)
> +		writel_relaxed(val, core->dos_base + HEVCD_MPP_ANC2AXI_TBL_CMD_ADDR);
> +
> +	writel_relaxed(1, core->dos_base + HEVCD_MPP_ANC2AXI_TBL_CONF_ADDR);
> +	writel_relaxed(1, core->dos_base + HEVCD_MPP_ANC_CANVAS_ACCCONFIG_ADDR);
> +	for (i = 0; i < 32; ++i)
> +		writel_relaxed(0, core->dos_base + HEVCD_MPP_ANC_CANVAS_DATA_ADDR);
> +}
> +
> +static void codec_hevc_setup_buffers_gxl(struct vdec_session *sess)
> +{
> +	struct vdec_core *core = sess->core;
> +	struct v4l2_m2m_buffer *buf;
> +	u32 buf_size = v4l2_m2m_num_dst_bufs_ready(sess->m2m_ctx);
> +	dma_addr_t buf_y_paddr = 0;
> +	dma_addr_t buf_uv_paddr = 0;
> +	int i;
> +
> +	writel_relaxed((1 << 2) | (1 << 1), core->dos_base + HEVCD_MPP_ANC2AXI_TBL_CONF_ADDR);
> +
> +	v4l2_m2m_for_each_dst_buf(sess->m2m_ctx, buf) {
> +		buf_y_paddr  = vb2_dma_contig_plane_dma_addr(&buf->vb.vb2_buf, 0);
> +		buf_uv_paddr = vb2_dma_contig_plane_dma_addr(&buf->vb.vb2_buf, 1);
> +
> +		writel_relaxed(buf_y_paddr  >> 5, core->dos_base + HEVCD_MPP_ANC2AXI_TBL_DATA);
> +		writel_relaxed(buf_uv_paddr >> 5, core->dos_base + HEVCD_MPP_ANC2AXI_TBL_DATA);
> +	}
> +
> +	/* Fill the remaining unused slots with the last buffer's Y addr */
> +	for (i = buf_size; i < MAX_REF_PIC_NUM; ++i) {
> +		writel_relaxed(buf_y_paddr  >> 5, core->dos_base + HEVCD_MPP_ANC2AXI_TBL_DATA);
> +		//writel_relaxed(buf_uv_paddr >> 5, core->dos_base + HEVCD_MPP_ANC2AXI_TBL_DATA);

Clean up ?

> +	}
> +
> +	writel_relaxed(1, core->dos_base + HEVCD_MPP_ANC2AXI_TBL_CONF_ADDR);
> +	writel_relaxed(1, core->dos_base + HEVCD_MPP_ANC_CANVAS_ACCCONFIG_ADDR);
> +	for (i = 0; i < 32; ++i)
> +		writel_relaxed(0, core->dos_base + HEVCD_MPP_ANC_CANVAS_DATA_ADDR);
> +}
> +
> +static int codec_hevc_setup_workspace(struct vdec_session *sess)
> +{
> +	struct vdec_core *core = sess->core;
> +	struct codec_hevc *hevc = sess->priv;
> +
> +	/* Allocate some memory for the HEVC decoder's state */
> +	hevc->workspace_vaddr = dma_alloc_coherent(core->dev, SIZE_WORKSPACE, &hevc->workspace_paddr, GFP_KERNEL);
> +	if (!hevc->workspace_vaddr) {
> +		dev_err(core->dev, "Failed to allocate HEVC Workspace\n");
> +		return -ENOMEM;
> +	}
> +
> +	writel_relaxed(hevc->workspace_paddr + IPP_OFFSET, core->dos_base + HEVCD_IPP_LINEBUFF_BASE);
> +	writel_relaxed(hevc->workspace_paddr + RPM_OFFSET, core->dos_base + HEVC_RPM_BUFFER);
> +	writel_relaxed(hevc->workspace_paddr + SH_TM_RPS_OFFSET, core->dos_base + HEVC_SHORT_TERM_RPS);
> +	writel_relaxed(hevc->workspace_paddr + VPS_OFFSET, core->dos_base + HEVC_VPS_BUFFER);
> +	writel_relaxed(hevc->workspace_paddr + SPS_OFFSET, core->dos_base + HEVC_SPS_BUFFER);
> +	writel_relaxed(hevc->workspace_paddr + PPS_OFFSET, core->dos_base + HEVC_PPS_BUFFER);
> +	writel_relaxed(hevc->workspace_paddr + SAO_UP_OFFSET, core->dos_base + HEVC_SAO_UP);
> +
> +	/* MMU */
> +	//writel_relaxed(hevc->frame_mmu_paddr, core->dos_base + H265_MMU_MAP_BUFFER);
> +	/* No MMU */
> +	writel_relaxed(hevc->workspace_paddr + SWAP_BUF_OFFSET, core->dos_base + HEVC_STREAM_SWAP_BUFFER);
> +
> +	writel_relaxed(hevc->workspace_paddr + SWAP_BUF2_OFFSET, core->dos_base + HEVC_STREAM_SWAP_BUFFER2);
> +	writel_relaxed(hevc->workspace_paddr + SCALELUT_OFFSET, core->dos_base + HEVC_SCALELUT);
> +	writel_relaxed(hevc->workspace_paddr + DBLK_PARA_OFFSET, core->dos_base + HEVC_DBLK_CFG4);
> +	writel_relaxed(hevc->workspace_paddr + DBLK_DATA_OFFSET, core->dos_base + HEVC_DBLK_CFG5);
> +
> +	return 0;
> +}
> +
> +static int codec_hevc_start(struct vdec_session *sess)
> +{
> +	struct vdec_core *core = sess->core;
> +	struct codec_hevc *hevc;
> +	int ret;
> +	int i;
> +
> +	hevc = kzalloc(sizeof(*hevc), GFP_KERNEL);
> +	if (!hevc)
> +		return -ENOMEM;
> +
> +	sess->priv = hevc;
> +	INIT_LIST_HEAD(&hevc->ref_frames_list);
> +	hevc->curr_poc = INVALID_POC;
> +
> +	ret = codec_hevc_setup_workspace(sess);
> +	if (ret)
> +		goto free_hevc;
> +
> +	writel_relaxed(0x5a5a55aa, core->dos_base + HEVC_PARSER_VERSION);
> +	writel_relaxed((1 << 14), core->dos_base + DOS_SW_RESET3);
> +	writel_relaxed(0, core->dos_base + HEVC_CABAC_CONTROL);
> +	writel_relaxed(0, core->dos_base + HEVC_PARSER_CORE_CONTROL);
> +	writel_relaxed(readl_relaxed(core->dos_base + HEVC_STREAM_CONTROL) | 1, core->dos_base + HEVC_STREAM_CONTROL);
> +	writel_relaxed(0x00000100, core->dos_base + HEVC_SHIFT_STARTCODE);
> +	writel_relaxed(0x00000300, core->dos_base + HEVC_SHIFT_EMULATECODE);
> +	writel_relaxed((readl_relaxed(core->dos_base + HEVC_PARSER_INT_CONTROL) & 0x03ffffff) |
> +			(3 << 29) | (2 << 26) | (1 << 24) | (1 << 22) | (1 << 7) | (1 << 4) | 1, core->dos_base + HEVC_PARSER_INT_CONTROL);
> +	writel_relaxed(readl_relaxed(core->dos_base + HEVC_SHIFT_STATUS) | (1 << 1) | 1, core->dos_base + HEVC_SHIFT_STATUS);
> +	writel_relaxed((3 << 6) | (2 << 4) | (2 << 1) | 1, core->dos_base + HEVC_SHIFT_CONTROL);
> +	writel_relaxed(1, core->dos_base + HEVC_CABAC_CONTROL);
> +	writel_relaxed(1, core->dos_base + HEVC_PARSER_CORE_CONTROL);
> +	writel_relaxed(0, core->dos_base + HEVC_DEC_STATUS_REG);
> +
> +	writel_relaxed(0, core->dos_base + HEVC_IQIT_SCALELUT_WR_ADDR);
> +	for (i = 0; i < 1024; ++i)
> +		writel_relaxed(0, core->dos_base + HEVC_IQIT_SCALELUT_DATA);
> +
> +	writel_relaxed(0, core->dos_base + HEVC_DECODE_SIZE);
> +
> +	writel_relaxed((1 << 16), core->dos_base + HEVC_PARSER_CMD_WRITE);
> +	for (i = 0; i < ARRAY_SIZE(parser_cmd); ++i)
> +		writel_relaxed(parser_cmd[i], core->dos_base + HEVC_PARSER_CMD_WRITE);
> +
> +	writel_relaxed(PARSER_CMD_SKIP_CFG_0, core->dos_base + HEVC_PARSER_CMD_SKIP_0);
> +	writel_relaxed(PARSER_CMD_SKIP_CFG_1, core->dos_base + HEVC_PARSER_CMD_SKIP_1);
> +	writel_relaxed(PARSER_CMD_SKIP_CFG_2, core->dos_base + HEVC_PARSER_CMD_SKIP_2);
> +	writel_relaxed((1 << 5) | (1 << 2) | 1, core->dos_base + HEVC_PARSER_IF_CONTROL);
> +
> +	writel_relaxed(1, core->dos_base + HEVCD_IPP_TOP_CNTL);
> +	writel_relaxed((1 << 1), core->dos_base + HEVCD_IPP_TOP_CNTL);
> +
> +	/* Enable 2-plane reference read mode for MC */
> +	if (sess->fmt_cap->pixfmt == V4L2_PIX_FMT_NV12M)
> +		writel_relaxed(1 << 31, core->dos_base + HEVCD_MPP_DECOMP_CTL1);
> +
> +	writel_relaxed(1, core->dos_base + HEVC_WAIT_FLAG);
> +
> +	/* clear mailbox interrupt */
> +	writel_relaxed(1, core->dos_base + HEVC_ASSIST_MBOX1_CLR_REG);
> +	/* enable mailbox interrupt */
> +	writel_relaxed(1, core->dos_base + HEVC_ASSIST_MBOX1_MASK);
> +	/* disable PSCALE for hardware sharing */
> +	writel_relaxed(0, core->dos_base + HEVC_PSCALE_CTRL);
> +	/* Let the uCode do all the parsing */
> +	writel_relaxed(0xc, core->dos_base + NAL_SEARCH_CTL);
> +
> +	writel_relaxed(0, core->dos_base + DECODE_STOP_POS);
> +	writel_relaxed(DECODE_MODE_SINGLE, core->dos_base + HEVC_DECODE_MODE);
> +	writel_relaxed(0, core->dos_base + HEVC_DECODE_MODE2);
> +
> +	/* AUX buffers */
> +	hevc->aux_vaddr = dma_alloc_coherent(core->dev, SIZE_AUX, &hevc->aux_paddr, GFP_KERNEL);
> +	if (!hevc->aux_vaddr) {
> +		dev_err(core->dev, "Failed to request HEVC AUX\n");
> +		ret = -ENOMEM;
> +		goto free_hevc;
> +	}
> +
> +	writel_relaxed(hevc->aux_paddr, core->dos_base + HEVC_AUX_ADR);
> +	writel_relaxed((((SIZE_AUX) >> 4) << 16) | 0, core->dos_base + HEVC_AUX_DATA_SIZE);
> +
> +	if (core->platform->revision == VDEC_REVISION_GXBB)
> +		codec_hevc_setup_buffers_gxbb(sess);
> +	else
> +		codec_hevc_setup_buffers_gxl(sess);
> +
> +	if (sess->fmt_cap->pixfmt != V4L2_PIX_FMT_NV12M)
> +		codec_hevc_setup_decode_head(sess);
> +
> +	return 0;
> +
> +free_hevc:
> +	kfree(hevc);
> +	return ret;
> +}
> +
> +static void codec_hevc_flush_output(struct vdec_session *sess)
> +{
> +	struct codec_hevc *hevc = sess->priv;
> +	struct hevc_frame *tmp, *n;
> +
> +	list_for_each_entry_safe(tmp, n, &hevc->ref_frames_list, list) {
> +		vdec_dst_buf_done(sess, tmp->vbuf);
> +		list_del(&tmp->list);
> +		kfree(tmp);
> +		hevc->frames_num--;
> +	}
> +}
> +
> +static int codec_hevc_stop(struct vdec_session *sess)
> +{
> +	struct codec_hevc *hevc = sess->priv;
> +	struct vdec_core *core = sess->core;
> +
> +	mutex_lock(&sess->codec_lock);
> +	codec_hevc_flush_output(sess);
> +
> +	if (hevc->workspace_vaddr) {
> +		dma_free_coherent(core->dev, SIZE_WORKSPACE,
> +				  hevc->workspace_vaddr,
> +				  hevc->workspace_paddr);
> +		hevc->workspace_vaddr = 0;
> +	}
> +
> +	if (hevc->frame_mmu_vaddr) {
> +		dma_free_coherent(core->dev, SIZE_FRAME_MMU,
> +				  hevc->frame_mmu_vaddr,
> +				  hevc->frame_mmu_paddr);
> +		hevc->frame_mmu_vaddr = 0;
> +	}
> +
> +	if (hevc->aux_vaddr) {
> +		dma_free_coherent(core->dev, SIZE_AUX,
> +				  hevc->aux_vaddr, hevc->aux_paddr);
> +		hevc->aux_vaddr = 0;
> +	}
> +
> +	kfree(hevc);
> +	sess->priv = 0;
> +	mutex_unlock(&sess->codec_lock);
> +
> +	return 0;
> +}
> +
> +static void codec_hevc_update_tiles(struct vdec_session *sess)
> +{
> +	struct codec_hevc *hevc = sess->priv;
> +	struct vdec_core *core = sess->core;
> +	u32 sao_mem_unit = (hevc->lcu_size == 16 ? 9 : hevc->lcu_size == 32 ? 14 : 24) << 4;
> +	u32 pic_height_cu = (hevc->height + hevc->lcu_size - 1) / hevc->lcu_size;
> +	u32 pic_width_cu = (hevc->width + hevc->lcu_size - 1) / hevc->lcu_size;
> +	u32 sao_vb_size = (sao_mem_unit + (2 << 4)) * pic_height_cu;
> +	u32 tiles_flags = hevc->rpm_param.p.tiles_flags;
> +
> +	if (tiles_flags & 1) {
> +		/* TODO; The samples I'm using have tiles_flags == 0 */
> +		return;
> +	}
> +
> +	hevc->num_tile_col = 1;
> +	hevc->num_tile_row = 1;
> +	hevc->m_tile[0][0].width = pic_width_cu;
> +	hevc->m_tile[0][0].height = pic_height_cu;
> +	hevc->m_tile[0][0].start_cu_x = 0;
> +	hevc->m_tile[0][0].start_cu_y = 0;
> +	hevc->m_tile[0][0].sao_vb_start_addr = hevc->workspace_paddr + SAO_VB_OFFSET;
> +	hevc->m_tile[0][0].sao_abv_start_addr = hevc->workspace_paddr + SAO_ABV_OFFSET;
> +	
> +	hevc->tile_start_lcu_x = 0;
> +	hevc->tile_start_lcu_y = 0;
> +	hevc->tile_width_lcu = pic_width_cu;
> +	hevc->tile_height_lcu = pic_height_cu;
> +
> +	writel_relaxed(sao_mem_unit, core->dos_base + HEVC_sao_mem_unit);
> +	writel_relaxed(hevc->workspace_paddr + SAO_ABV_OFFSET, core->dos_base + HEVC_SAO_ABV);
> +	writel_relaxed(sao_vb_size, core->dos_base + HEVC_sao_vb_size);
> +	writel_relaxed(hevc->workspace_paddr + SAO_VB_OFFSET, core->dos_base + HEVC_SAO_VB);
> +}
> +
> +static struct hevc_frame * codec_hevc_get_frame_by_poc(struct codec_hevc *hevc, u32 poc)
> +{
> +	struct hevc_frame *tmp;
> +
> +	list_for_each_entry(tmp, &hevc->ref_frames_list, list) {
> +		if (tmp->poc == poc)
> +			return tmp;
> +	}
> +
> +	return NULL;
> +}
> +
> +static struct hevc_frame * codec_hevc_prepare_new_frame(struct vdec_session *sess)
> +{
> +	struct vb2_v4l2_buffer *vbuf;
> +	struct hevc_frame *new_frame = NULL;
> +	struct codec_hevc *hevc = sess->priv;
> +	union rpm_param *params = &hevc->rpm_param;
> +
> +	vbuf = v4l2_m2m_dst_buf_remove(sess->m2m_ctx);
> +	if (!vbuf) {
> +		dev_warn(sess->core->dev, "Couldn't remove dst buf\n");
> +		return NULL;
> +	}
> +
> +	new_frame = kzalloc(sizeof(*new_frame), GFP_KERNEL);
> +	if (!new_frame)
> +		return NULL;
> +
> +	new_frame->vbuf = vbuf;
> +	new_frame->referenced = 1;
> +	new_frame->poc = hevc->curr_poc;
> +	new_frame->cur_slice_type = params->p.slice_type;
> +	new_frame->num_reorder_pic = params->p.sps_num_reorder_pics_0;
> +
> +	list_add_tail(&new_frame->list, &hevc->ref_frames_list);
> +	hevc->frames_num++;
> +
> +	return new_frame;
> +}
> +
> +static void codec_hevc_set_sao(struct vdec_session *sess, struct hevc_frame *frame)
> +{
> +	struct vdec_core *core = sess->core;
> +	struct codec_hevc *hevc = sess->priv;
> +	union rpm_param *param = &hevc->rpm_param;
> +	dma_addr_t buf_y_paddr = vb2_dma_contig_plane_dma_addr(&frame->vbuf->vb2_buf, 0);
> +	dma_addr_t buf_u_v_paddr = vb2_dma_contig_plane_dma_addr(&frame->vbuf->vb2_buf, 1);
> +	u32 misc_flag0 = param->p.misc_flag0;
> +	u32 slice_deblocking_filter_disabled_flag;
> +	u32 val, val_2;
> +
> +	val = (readl_relaxed(core->dos_base + HEVC_SAO_CTRL0) & ~0xf) | ilog2(hevc->lcu_size);
> +	writel_relaxed(val, core->dos_base + HEVC_SAO_CTRL0);
> +
> +	writel_relaxed(hevc->width | (hevc->height << 16), core->dos_base + HEVC_SAO_PIC_SIZE);
> +	writel_relaxed((hevc->lcu_x_num - 1) | (hevc->lcu_y_num - 1) << 16, core->dos_base + HEVC_SAO_PIC_SIZE_LCU);
> +
> +	writel_relaxed(buf_y_paddr, core->dos_base + HEVC_SAO_Y_START_ADDR);
> +	writel_relaxed(vdec_get_output_size(sess), core->dos_base + HEVC_SAO_Y_LENGTH);
> +	writel_relaxed(buf_u_v_paddr, core->dos_base + HEVC_SAO_C_START_ADDR);
> +	writel_relaxed((vdec_get_output_size(sess) / 2), core->dos_base + HEVC_SAO_C_LENGTH);
> +
> +	writel_relaxed(buf_y_paddr, core->dos_base + HEVC_SAO_Y_WPTR);
> +	writel_relaxed(buf_u_v_paddr, core->dos_base + HEVC_SAO_C_WPTR);
> +
> +	if (frame->cur_slice_idx == 0) {
> +		writel_relaxed(hevc->width | (hevc->height << 16), core->dos_base + HEVC_DBLK_CFG2);
> +
> +		val = 0;
> +		if ((misc_flag0 >> PCM_ENABLE_FLAG_BIT) & 0x1)
> +			val |= ((misc_flag0 >> PCM_LOOP_FILTER_DISABLED_FLAG_BIT) & 0x1) << 3;
> +
> +		val |= (param->p.pps_cb_qp_offset & 0x1f) << 4;
> +		val |= (param->p.pps_cr_qp_offset & 0x1f) << 9;
> +		val |= (hevc->lcu_size == 64) ? 0 : ((hevc->lcu_size == 32) ? 1 : 2);
> +		writel_relaxed(val, core->dos_base + HEVC_DBLK_CFG1);
> +	}
> +
> +	val = readl_relaxed(core->dos_base + HEVC_SAO_CTRL1) & ~0x3ff3;
> +	if (sess->fmt_cap->pixfmt == V4L2_PIX_FMT_NV12M)
> +		val |= 0xff0 | /* Set endianness for 2-bytes swaps (nv12) */
> +			0x1;   /* disable cm compression */
> +	else
> +		val |= 0x3000 | /* 64x32 block mode */
> +			0x880 | /* 64-bit Big Endian */
> +			0x2;    /* Disable double write */
> +
> +	writel_relaxed(val, core->dos_base + HEVC_SAO_CTRL1);
> +
> +	/* set them all 0 for H265_NV21 (no down-scale) */
> +	val = readl_relaxed(core->dos_base + HEVC_SAO_CTRL5) & ~0xff0000;
> +	writel_relaxed(val, core->dos_base + HEVC_SAO_CTRL5);
> +
> +	val = readl_relaxed(core->dos_base + HEVCD_IPP_AXIIF_CONFIG) & ~0x30;
> +	val |= 0xf;
> +	if (sess->fmt_cap->pixfmt != V4L2_PIX_FMT_NV12M)
> +		val |= 0x30; /* 64x32 block mode */
> +
> +	writel_relaxed(val, core->dos_base + HEVCD_IPP_AXIIF_CONFIG);
> +
> +	val = 0;
> +	val_2 = readl_relaxed(core->dos_base + HEVC_SAO_CTRL0);
> +	val_2 &= (~0x300);
> +
> +	/* TODO: handle tiles here if enabled */
> +	slice_deblocking_filter_disabled_flag = (misc_flag0 >>
> +			SLICE_DEBLOCKING_FILTER_DISABLED_FLAG_BIT) & 0x1;
> +	if ((misc_flag0 & (1 << DEBLOCKING_FILTER_OVERRIDE_ENABLED_FLAG_BIT))
> +		&& (misc_flag0 & (1 << DEBLOCKING_FILTER_OVERRIDE_FLAG_BIT))) {
> +		val |= slice_deblocking_filter_disabled_flag << 2;
> +
> +		if (!slice_deblocking_filter_disabled_flag) {
> +			val |= (param->p.slice_beta_offset_div2 & 0xf) << 3;
> +			val |= (param->p.slice_tc_offset_div2 & 0xf) << 7;
> +		}
> +	} else {
> +		val |=
> +			((misc_flag0 >>
> +			  PPS_DEBLOCKING_FILTER_DISABLED_FLAG_BIT) & 0x1) << 2;
> +
> +		if (((misc_flag0 >> PPS_DEBLOCKING_FILTER_DISABLED_FLAG_BIT) &
> +			 0x1) == 0) {
> +			val |= (param->p.pps_beta_offset_div2 & 0xf) << 3;
> +			val |= (param->p.pps_tc_offset_div2 & 0xf) << 7;
> +		}
> +	}
> +	if ((misc_flag0 & (1 << PPS_LOOP_FILTER_ACROSS_SLICES_ENABLED_FLAG_BIT))
> +		&& ((misc_flag0 & (1 << SLICE_SAO_LUMA_FLAG_BIT))
> +			|| (misc_flag0 & (1 << SLICE_SAO_CHROMA_FLAG_BIT))
> +			|| (!slice_deblocking_filter_disabled_flag))) {
> +		val |=
> +			((misc_flag0 >>
> +			  SLICE_LOOP_FILTER_ACROSS_SLICES_ENABLED_FLAG_BIT)
> +			 & 0x1)	<< 1;
> +		val_2 |=
> +			((misc_flag0 >>
> +			  SLICE_LOOP_FILTER_ACROSS_SLICES_ENABLED_FLAG_BIT)
> +			& 0x1) << 9;
> +	} else {
> +		val |=
> +			((misc_flag0 >>
> +			  PPS_LOOP_FILTER_ACROSS_SLICES_ENABLED_FLAG_BIT)
> +			 & 0x1) << 1;
> +		val_2 |=
> +			((misc_flag0 >>
> +			  PPS_LOOP_FILTER_ACROSS_SLICES_ENABLED_FLAG_BIT)
> +			 & 0x1) << 9;
> +	}
> +
> +	writel_relaxed(val, core->dos_base + HEVC_DBLK_CFG9);
> +	writel_relaxed(val_2, core->dos_base + HEVC_SAO_CTRL0);
> +}
> +
> +static dma_addr_t codec_hevc_get_frame_mv_paddr(struct codec_hevc *hevc, struct hevc_frame *frame)
> +{
> +	return hevc->workspace_paddr + MPRED_MV_OFFSET +
> +		(frame->vbuf->vb2_buf.index * MPRED_MV_BUF_SIZE);
> +}
> +
> +/* Update the necessary information for motion prediction with the current slice */
> +static void codec_hevc_set_mpred(struct vdec_session *sess, struct hevc_frame *frame, struct hevc_frame *col_frame)
> +{
> +	struct vdec_core *core = sess->core;
> +	struct codec_hevc *hevc = sess->priv;
> +	union rpm_param *param = &hevc->rpm_param;
> +	u32 *ref_num = frame->ref_num;
> +	u32 *ref_poc_l0 = frame->ref_poc_list[0][frame->cur_slice_idx];
> +	u32 *ref_poc_l1 = frame->ref_poc_list[1][frame->cur_slice_idx];
> +	u32 lcu_size_log2 = ilog2(hevc->lcu_size);
> +	u32 mv_mem_unit = lcu_size_log2 == 6 ? 0x200 : lcu_size_log2 == 5 ? 0x80 : 0x20;
> +	u32 slice_segment_address = param->p.slice_segment_address;
> +	u32 max_num_merge_cand = 5 - param->p.five_minus_max_num_merge_cand;
> +	u32 plevel = param->p.log2_parallel_merge_level;
> +	u32 col_from_l0_flag = param->p.collocated_from_l0_flag;
> +	u32 tmvp_flag = param->p.slice_temporal_mvp_enable_flag;
> +	u32 is_next_slice_segment = param->p.dependent_slice_segment_flag ? 1 : 0;
> +	u32 slice_type = param->p.slice_type;
> +	dma_addr_t col_mv_rd_start_addr, col_mv_rd_ptr, col_mv_rd_end_addr;
> +	dma_addr_t mpred_mv_wr_ptr;
> +	u32 mv_rd_en = 1;
> +	u32 val;
> +	int i;
> +
> +	val = readl_relaxed(core->dos_base + HEVC_MPRED_CURR_LCU);
> +
> +	col_mv_rd_start_addr = codec_hevc_get_frame_mv_paddr(hevc, col_frame);
> +	mpred_mv_wr_ptr = codec_hevc_get_frame_mv_paddr(hevc, frame) + (hevc->slice_addr * mv_mem_unit);
> +	col_mv_rd_ptr = col_mv_rd_start_addr + (hevc->slice_addr * mv_mem_unit);
> +	col_mv_rd_end_addr = col_mv_rd_start_addr + ((hevc->lcu_x_num * hevc->lcu_y_num) * mv_mem_unit);
> +
> +	writel_relaxed(codec_hevc_get_frame_mv_paddr(hevc, frame), core->dos_base + HEVC_MPRED_MV_WR_START_ADDR);
> +	writel_relaxed(col_mv_rd_start_addr, core->dos_base + HEVC_MPRED_MV_RD_START_ADDR);
> +
> +	val = ((hevc->lcu_x_num - hevc->tile_width_lcu) * mv_mem_unit);
> +	writel_relaxed(val, core->dos_base + HEVC_MPRED_MV_WR_ROW_JUMP);
> +	writel_relaxed(val, core->dos_base + HEVC_MPRED_MV_RD_ROW_JUMP);
> +
> +	if (slice_type == I_SLICE)
> +		mv_rd_en = 0;
> +
> +	val = slice_type |
> +			  1 << 2 | // new pic
> +			  1 << 3 | // new tile
> +			  is_next_slice_segment << 4 |
> +			  tmvp_flag << 5 |
> +			  hevc->ldc_flag << 6 |
> +			  col_from_l0_flag << 7 |
> +			  1 << 9 |
> +			  1 << 10 |
> +			  mv_rd_en << 11 |
> +			  1 << 13 |
> +			  lcu_size_log2 << 16 |
> +			  3 << 20 | plevel << 24;
> +	writel_relaxed(val, core->dos_base + HEVC_MPRED_CTRL0);
> +
> +	val = max_num_merge_cand | 2 << 4 | 3 << 8 | 5 << 12 | 36 << 16;
> +	writel_relaxed(val, core->dos_base + HEVC_MPRED_CTRL1);
> +
> +	writel_relaxed(hevc->width | (hevc->height << 16), core->dos_base + HEVC_MPRED_PIC_SIZE);
> +
> +	val = ((hevc->lcu_x_num - 1) | (hevc->lcu_y_num - 1) << 16);
> +	writel_relaxed(val, core->dos_base + HEVC_MPRED_PIC_SIZE_LCU);
> +	val = (hevc->tile_start_lcu_x | hevc->tile_start_lcu_y << 16);
> +	writel_relaxed(val, core->dos_base + HEVC_MPRED_TILE_START);
> +	val = (hevc->tile_width_lcu | hevc->tile_height_lcu << 16);
> +	writel_relaxed(val, core->dos_base + HEVC_MPRED_TILE_SIZE_LCU);
> +
> +	writel_relaxed((ref_num[1] << 8) | ref_num[0], core->dos_base + HEVC_MPRED_REF_NUM);
> +	writel_relaxed((1 << ref_num[0]) - 1, core->dos_base + HEVC_MPRED_REF_EN_L0);
> +	writel_relaxed((1 << ref_num[1]) - 1, core->dos_base + HEVC_MPRED_REF_EN_L1);
> +
> +	writel_relaxed(hevc->curr_poc, core->dos_base + HEVC_MPRED_CUR_POC);
> +	writel_relaxed(hevc->col_poc, core->dos_base + HEVC_MPRED_COL_POC);
> +
> +	for (i = 0; i < MAX_REF_ACTIVE; ++i) {
> +		writel_relaxed(ref_poc_l0[i], core->dos_base + HEVC_MPRED_L0_REF00_POC + i * 4);
> +		writel_relaxed(ref_poc_l1[i], core->dos_base + HEVC_MPRED_L1_REF00_POC + i * 4);
> +	}
> +
> +	if (slice_segment_address == 0) {
> +		writel_relaxed(hevc->workspace_paddr + MPRED_ABV_OFFSET, core->dos_base + HEVC_MPRED_ABV_START_ADDR);
> +		writel_relaxed(mpred_mv_wr_ptr, core->dos_base + HEVC_MPRED_MV_WPTR);
> +		writel_relaxed(col_mv_rd_start_addr, core->dos_base + HEVC_MPRED_MV_RPTR);
> +	} else {
> +		writel_relaxed(col_mv_rd_ptr, core->dos_base + HEVC_MPRED_MV_RPTR);
> +	}
> +
> +	writel_relaxed(col_mv_rd_end_addr, core->dos_base + HEVC_MPRED_MV_RD_END_ADDR);
> +}
> +
> +/*  motion compensation reference cache controller */
> +static void codec_hevc_set_mcrcc(struct vdec_session *sess)
> +{
> +	struct vdec_core *core = sess->core;
> +	struct codec_hevc *hevc = sess->priv;
> +	u32 val, val_2;
> +	int l0_cnt = hevc->cur_frame->ref_num[0];
> +	int l1_cnt = hevc->cur_frame->ref_num[1];
> +
> +	/* reset mcrcc */
> +	writel_relaxed(0x02, core->dos_base + HEVCD_MCRCC_CTL1);
> +
> +	if (hevc->cur_frame->cur_slice_type == I_SLICE) {
> +		/* remove reset -- disables clock */
> +		writel_relaxed(0, core->dos_base + HEVCD_MCRCC_CTL1);
> +		return;
> +	}
> +
> +	if (hevc->cur_frame->cur_slice_type == P_SLICE) {
> +		writel_relaxed(1 << 1, core->dos_base + HEVCD_MPP_ANC_CANVAS_ACCCONFIG_ADDR);
> +		val = readl_relaxed(core->dos_base + HEVCD_MPP_ANC_CANVAS_DATA_ADDR);
> +		val &= 0xffff;
> +		val |= (val << 16);
> +		writel_relaxed(val, core->dos_base + HEVCD_MCRCC_CTL2);
> +
> +		if (l0_cnt == 1) {
> +			writel_relaxed(val, core->dos_base + HEVCD_MCRCC_CTL3);
> +		} else {
> +			val = readl_relaxed(core->dos_base + HEVCD_MPP_ANC_CANVAS_DATA_ADDR);
> +			val &= 0xffff;
> +			val |= (val << 16);
> +			writel_relaxed(val, core->dos_base + HEVCD_MCRCC_CTL3);
> +		}
> +	} else { /* B_SLICE */
> +		writel_relaxed(0, core->dos_base + HEVCD_MPP_ANC_CANVAS_ACCCONFIG_ADDR);
> +		val = readl_relaxed(core->dos_base + HEVCD_MPP_ANC_CANVAS_DATA_ADDR);
> +		val &= 0xffff;
> +		val |= (val << 16);
> +		writel_relaxed(val, core->dos_base + HEVCD_MCRCC_CTL2);
> +
> +		writel_relaxed((16 << 8) | (1 << 1), core->dos_base + HEVCD_MPP_ANC_CANVAS_ACCCONFIG_ADDR);
> +		val_2 = readl_relaxed(core->dos_base + HEVCD_MPP_ANC_CANVAS_DATA_ADDR);
> +		val_2 &= 0xffff;
> +		val_2 |= (val_2 << 16);
> +		if (val == val_2 && l1_cnt > 1) {
> +			val_2 = readl_relaxed(core->dos_base + HEVCD_MPP_ANC_CANVAS_DATA_ADDR);
> +			val_2 &= 0xffff;
> +			val_2 |= (val_2 << 16);
> +		}
> +		writel_relaxed(val, core->dos_base + HEVCD_MCRCC_CTL3);
> +	}
> +
> +	/* enable mcrcc progressive-mode */
> +	writel_relaxed(0xff0, core->dos_base + HEVCD_MCRCC_CTL1);
> +}
> +
> +static void codec_hevc_set_ref_list(struct vdec_session *sess,
> +				u32 ref_num, u32 *ref_poc_list)
> +{
> +	struct codec_hevc *hevc = sess->priv;
> +	struct hevc_frame *ref_frame;
> +	struct vdec_core *core = sess->core;
> +	int i;
> +	u32 ref_frame_id;
> +
> +	for (i = 0; i < ref_num; i++) {
> +		ref_frame = codec_hevc_get_frame_by_poc(hevc, ref_poc_list[i]);
> +
> +		if (!ref_frame) {
> +			dev_warn(core->dev, "Couldn't find ref. frame %u\n",
> +				ref_poc_list[i]);
> +			continue;
> +		}
> +
> +		ref_frame_id = ref_frame->vbuf->vb2_buf.index * 2;
> +		dev_dbg(core->dev, "Programming ref poc %u\n", ref_poc_list[i]);
> +
> +		writel_relaxed(((ref_frame_id + 1) << 16) |
> +				((ref_frame_id + 1) << 8) |
> +				ref_frame_id,
> +				core->dos_base + HEVCD_MPP_ANC_CANVAS_DATA_ADDR);
> +	}
> +}
> +
> +static void codec_hevc_set_mc(struct vdec_session *sess, struct hevc_frame *frame)
> +{
> +	struct vdec_core *core = sess->core;
> +
> +	if (frame->cur_slice_type == I_SLICE)
> +		return;
> +
> +	writel_relaxed(1, core->dos_base + HEVCD_MPP_ANC_CANVAS_ACCCONFIG_ADDR);
> +	codec_hevc_set_ref_list(sess, frame->ref_num[0],
> +		frame->ref_poc_list[0][frame->cur_slice_idx]);
> +
> +	if (frame->cur_slice_type == P_SLICE)
> +		return;
> +
> +	writel_relaxed((16 << 8) | 1, core->dos_base + HEVCD_MPP_ANC_CANVAS_ACCCONFIG_ADDR);
> +	codec_hevc_set_ref_list(sess, frame->ref_num[1],
> +		frame->ref_poc_list[1][frame->cur_slice_idx]);
> +}
> +
> +static void codec_hevc_update_col_frame(struct codec_hevc *hevc)
> +{
> +	struct hevc_frame *cur_frame = hevc->cur_frame;
> +	union rpm_param *param = &hevc->rpm_param;
> +	u32 list_no = 0;
> +	u32 col_ref = param->p.collocated_ref_idx;
> +	u32 col_from_l0 = param->p.collocated_from_l0_flag;
> +
> +	if (cur_frame->cur_slice_type == B_SLICE)
> +		list_no = 1 - col_from_l0;
> +
> +	if (col_ref >= cur_frame->ref_num[list_no])
> +		hevc->col_poc = INVALID_POC;
> +	else
> +		hevc->col_poc = cur_frame->ref_poc_list[list_no][cur_frame->cur_slice_idx][col_ref];
> +
> +	if (cur_frame->cur_slice_type == I_SLICE)
> +		goto end;
> +
> +	if (hevc->col_poc != INVALID_POC)
> +		hevc->col_frame = codec_hevc_get_frame_by_poc(hevc, hevc->col_poc);
> +	else
> +		hevc->col_frame = hevc->cur_frame;
> +
> +end:
> +	if (!hevc->col_frame)
> +		hevc->col_frame = hevc->cur_frame;
> +}
> +
> +static void codec_hevc_update_pocs(struct vdec_session *sess)
> +{
> +	struct codec_hevc *hevc = sess->priv;
> +	union rpm_param *param = &hevc->rpm_param;
> +	u32 nal_unit_type = param->p.m_nalUnitType;
> +	u32 temporal_id = param->p.m_temporalId & 0x7;
> +	int iMaxPOClsb = 1 << (param->p.log2_max_pic_order_cnt_lsb_minus4 + 4);
> +	int iPrevPOClsb;
> +	int iPrevPOCmsb;
> +	int iPOCmsb;
> +	int iPOClsb = param->p.POClsb;
> +
> +	if (nal_unit_type == NAL_UNIT_CODED_SLICE_IDR ||
> +	    nal_unit_type == NAL_UNIT_CODED_SLICE_IDR_N_LP) {
> +		hevc->curr_poc = 0;
> +		if ((temporal_id - 1) == 0)
> +			hevc->iPrevTid0POC = hevc->curr_poc;
> +
> +		return;
> +	}
> +
> +	iPrevPOClsb = hevc->iPrevTid0POC % iMaxPOClsb;
> +	iPrevPOCmsb = hevc->iPrevTid0POC - iPrevPOClsb;
> +
> +	if ((iPOClsb < iPrevPOClsb) && ((iPrevPOClsb - iPOClsb) >= (iMaxPOClsb / 2)))
> +		iPOCmsb = iPrevPOCmsb + iMaxPOClsb;
> +	else if ((iPOClsb > iPrevPOClsb) && ((iPOClsb - iPrevPOClsb) > (iMaxPOClsb / 2)))
> +		iPOCmsb = iPrevPOCmsb - iMaxPOClsb;
> +	else
> +		iPOCmsb = iPrevPOCmsb;
> +
> +	if (nal_unit_type == NAL_UNIT_CODED_SLICE_BLA   ||
> +	    nal_unit_type == NAL_UNIT_CODED_SLICE_BLANT ||
> +	    nal_unit_type == NAL_UNIT_CODED_SLICE_BLA_N_LP)
> +		iPOCmsb = 0;
> +
> +	hevc->curr_poc = (iPOCmsb + iPOClsb);
> +	if ((temporal_id - 1) == 0)
> +		hevc->iPrevTid0POC = hevc->curr_poc;
> +}
> +
> +static int codec_hevc_process_segment_header(struct vdec_session *sess)
> +{
> +	struct codec_hevc *hevc = sess->priv;
> +	union rpm_param *param = &hevc->rpm_param;
> +	u32 slice_segment_address = param->p.slice_segment_address;
> +
> +	if (param->p.first_slice_segment_in_pic_flag == 0) {
> +		hevc->slice_segment_addr = param->p.slice_segment_address;
> +		if (!param->p.dependent_slice_segment_flag)
> +			hevc->slice_addr = hevc->slice_segment_addr;
> +	} else {
> +		hevc->slice_segment_addr = 0;
> +		hevc->slice_addr = 0;
> +	}
> +
> +	codec_hevc_update_pocs(sess);
> +
> +	/* First slice: new frame */
> +	if (slice_segment_address == 0) {
> +		codec_hevc_update_referenced(hevc);
> +		codec_hevc_output_frames(sess);
> +
> +		hevc->cur_frame = codec_hevc_prepare_new_frame(sess);
> +		if (!hevc->cur_frame) {
> +			dev_err(sess->core->dev_dec,
> +				"No destination buffer available\n");
> +			return -1;
> +		}
> +
> +		codec_hevc_update_tiles(sess);
> +	} else {
> +		hevc->cur_frame->cur_slice_idx++;
> +	}
> +
> +	return 0;
> +}
> +
> +static int codec_hevc_process_rpm(struct vdec_session *sess)
> +{
> +	struct vdec_core *core = sess->core;
> +	struct codec_hevc *hevc = sess->priv;
> +	union rpm_param *rpm_param = &hevc->rpm_param;
> +	u32 lcu_x_num_div, lcu_y_num_div;
> +
> +	if (rpm_param->p.bit_depth &&
> +	    sess->fmt_cap->pixfmt == V4L2_PIX_FMT_NV12M) {
> +		dev_err(sess->core->dev_dec,
> +		    "V4L2_PIX_FMT_NV12M is only compatible with HEVC 8-bit\n");
> +		return -EINVAL;
> +	}
> +
> +	hevc->width  = rpm_param->p.pic_width_in_luma_samples;
> +	hevc->height = rpm_param->p.pic_height_in_luma_samples;
> +
> +	/*if (hevc->width  != sess->width ||
> +	    hevc->height != sess->height) {
> +		dev_err(sess->core->dev_dec,
> +			"Size mismatch: bitstream %ux%u ; driver %ux%u\n",
> +			hevc->width, hevc->height,
> +			sess->width, sess->height);
> +		return -EINVAL;
> +	}*/
> +
> +	hevc->lcu_size = 1 << (rpm_param->p.log2_min_coding_block_size_minus3 +
> +		3 + rpm_param->p.log2_diff_max_min_coding_block_size);
> +
> +	lcu_x_num_div = (hevc->width / hevc->lcu_size);
> +	lcu_y_num_div = (hevc->height / hevc->lcu_size);
> +	hevc->lcu_x_num = ((hevc->width % hevc->lcu_size) == 0) ? lcu_x_num_div : lcu_x_num_div + 1;
> +	hevc->lcu_y_num = ((hevc->height % hevc->lcu_size) == 0) ? lcu_y_num_div : lcu_y_num_div + 1;
> +	hevc->lcu_total = hevc->lcu_x_num * hevc->lcu_y_num;
> +
> +	dev_dbg(core->dev, "lcu_size = %u ; lcu_x_num = %u; lcu_y_num = %u",
> +		hevc->lcu_size, hevc->lcu_x_num, hevc->lcu_y_num);
> +
> +	return 0;
> +}
> +
> +/* The RPM section within the workspace contains
> + * many information regarding the parsed bitstream
> + */
> +static void codec_hevc_fetch_rpm(struct vdec_session *sess)
> +{
> +	struct codec_hevc *hevc = sess->priv;
> +	u16 *rpm_vaddr = hevc->workspace_vaddr + RPM_OFFSET;
> +	int i, j;
> +
> +	for (i = 0; i < RPM_SIZE; i += 4)
> +		for (j = 0; j < 4; j++)
> +			hevc->rpm_param.l.data[i + j] = rpm_vaddr[i + 3 - j];
> +}
> +
> +static irqreturn_t codec_hevc_threaded_isr(struct vdec_session *sess)
> +{
> +	struct vdec_core *core = sess->core;
> +	struct codec_hevc *hevc;
> +
> +	mutex_lock(&sess->codec_lock);
> +	hevc = sess->priv;
> +	if (!hevc)
> +		goto unlock;
> +
> +	if (hevc->dec_status != HEVC_SLICE_SEGMENT_DONE) {
> +		dev_err(core->dev_dec, "Unrecognized dec_status: %08X\n",
> +			hevc->dec_status);
> +		vdec_abort(sess);
> +		goto unlock;
> +	}
> +
> +	codec_hevc_fetch_rpm(sess);
> +	if (codec_hevc_process_rpm(sess)) {
> +		vdec_abort(sess);
> +		goto unlock;
> +	}
> +
> +	if (codec_hevc_process_segment_header(sess)) {
> +		vdec_abort(sess);
> +		goto unlock;
> +	}
> +
> +	codec_hevc_update_frame_refs(sess, hevc->cur_frame);
> +	codec_hevc_update_col_frame(hevc);
> +	codec_hevc_update_ldc_flag(hevc);
> +	codec_hevc_set_mc(sess, hevc->cur_frame);
> +	codec_hevc_set_mcrcc(sess);
> +	codec_hevc_set_mpred(sess, hevc->cur_frame, hevc->col_frame);
> +	codec_hevc_set_sao(sess, hevc->cur_frame);
> +
> +	writel_relaxed(readl_relaxed(core->dos_base + HEVC_WAIT_FLAG) | 2, core->dos_base + HEVC_WAIT_FLAG);
> +	writel_relaxed(HEVC_CODED_SLICE_SEGMENT_DAT, core->dos_base + HEVC_DEC_STATUS_REG);
> +
> +	/* Interrupt the firmware's processor */
> +	writel_relaxed(AMRISC_MAIN_REQ, core->dos_base + HEVC_MCPU_INTR_REQ);
> +
> +unlock:
> +	mutex_unlock(&sess->codec_lock);
> +	return IRQ_HANDLED;
> +}
> +
> +static irqreturn_t codec_hevc_isr(struct vdec_session *sess)
> +{
> +	struct vdec_core *core = sess->core;
> +	struct codec_hevc *hevc = sess->priv;
> +
> +	hevc->dec_status = readl_relaxed(core->dos_base + HEVC_DEC_STATUS_REG);
> +
> +	return IRQ_WAKE_THREAD;
> +}
> +
> +struct vdec_codec_ops codec_hevc_ops = {
> +	.start = codec_hevc_start,
> +	.stop = codec_hevc_stop,
> +	.isr = codec_hevc_isr,
> +	.threaded_isr = codec_hevc_threaded_isr,
> +	.num_pending_bufs = codec_hevc_num_pending_bufs,
> +};
> \ No newline at end of file
> diff --git a/drivers/media/platform/meson/vdec/codec_hevc.h b/drivers/media/platform/meson/vdec/codec_hevc.h
> new file mode 100644
> index 000000000000..1cf009b4c603
> --- /dev/null
> +++ b/drivers/media/platform/meson/vdec/codec_hevc.h
> @@ -0,0 +1,13 @@
> +/* SPDX-License-Identifier: GPL-2.0+ */
> +/*
> + * Copyright (C) 2018 Maxime Jourdan <maxi.jourdan@wanadoo.fr>
> + */
> +
> +#ifndef __MESON_VDEC_CODEC_HEVC_H_
> +#define __MESON_VDEC_CODEC_HEVC_H_
> +
> +#include "vdec.h"
> +
> +extern struct vdec_codec_ops codec_hevc_ops;
> +
> +#endif
> \ No newline at end of file
> diff --git a/drivers/media/platform/meson/vdec/codec_mjpeg.c b/drivers/media/platform/meson/vdec/codec_mjpeg.c
> new file mode 100644
> index 000000000000..57b56d7b1e70
> --- /dev/null
> +++ b/drivers/media/platform/meson/vdec/codec_mjpeg.c
> @@ -0,0 +1,203 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/*
> + * Copyright (C) 2018 Maxime Jourdan <maxi.jourdan@wanadoo.fr>
> + */
> +
> +#include <media/v4l2-mem2mem.h>
> +#include <media/videobuf2-dma-contig.h>
> +
> +#include "codec_mjpeg.h"
> +#include "codec_helpers.h"
> +
> +/* DOS registers */
> +#define VDEC_ASSIST_AMR1_INT8	0x00b4
> +
> +#define ASSIST_MBOX1_CLR_REG	0x01d4
> +#define ASSIST_MBOX1_MASK	0x01d8
> +
> +#define MCPU_INTR_MSK		0x0c10
> +
> +#define PSCALE_RST		0x2440
> +#define PSCALE_CTRL		0x2444
> +#define PSCALE_BMEM_ADDR	0x247c
> +#define PSCALE_BMEM_DAT		0x2480
> +
> +#define MDEC_PIC_DC_CTRL	0x2638
> +
> +#define AV_SCRATCH_0		0x2700
> +#define AV_SCRATCH_1		0x2704
> +#define MREG_DECODE_PARAM	0x2708
> +#define AV_SCRATCH_4		0x2710
> +#define MREG_TO_AMRISC		0x2720
> +#define MREG_FROM_AMRISC	0x2724
> +
> +#define DOS_SW_RESET0		0xfc00

I think this is not the first time you've defined this.
Maybe this (and other re-used register offsets) needs to be in some header ?

> +
> +struct codec_mjpeg {
> +	/* Housekeeping thread for marking buffers to DONE
> +	 * and recycling them into the hardware
> +	 */
> +	struct task_struct *buffers_thread;
> +};
> +
> +static int codec_mjpeg_buffers_thread(void *data)
> +{
> +	struct vdec_buffer *tmp;
> +	struct vdec_session *sess = data;
> +	struct vdec_core *core = sess->core;;
> +
> +	while (!kthread_should_stop()) {
> +		mutex_lock(&sess->bufs_recycle_lock);
> +		while (!list_empty(&sess->bufs_recycle) &&
> +		       !readl_relaxed(core->dos_base + MREG_TO_AMRISC))
> +		{
> +			tmp = list_first_entry(&sess->bufs_recycle, struct vdec_buffer, list);
> +
> +			/* Tell the decoder he can recycle this buffer */
> +			writel_relaxed(tmp->index + 1, core->dos_base + MREG_TO_AMRISC);
> +
> +			dev_dbg(core->dev, "Buffer %d recycled\n", tmp->index);
> +
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
> +/* 4 point triangle */
> +static const uint32_t filt_coef[] = {
> +	0x20402000, 0x20402000, 0x1f3f2101, 0x1f3f2101,
> +	0x1e3e2202, 0x1e3e2202, 0x1d3d2303, 0x1d3d2303,
> +	0x1c3c2404, 0x1c3c2404, 0x1b3b2505, 0x1b3b2505,
> +	0x1a3a2606, 0x1a3a2606, 0x19392707, 0x19392707,
> +	0x18382808, 0x18382808, 0x17372909, 0x17372909,
> +	0x16362a0a, 0x16362a0a, 0x15352b0b, 0x15352b0b,
> +	0x14342c0c, 0x14342c0c, 0x13332d0d, 0x13332d0d,
> +	0x12322e0e, 0x12322e0e, 0x11312f0f, 0x11312f0f,
> +	0x10303010
> +};
> +
> +static void codec_mjpeg_init_scaler(struct vdec_core *core)
> +{
> +	int i;
> +
> +	/* PSCALE cbus bmem enable */
> +	writel_relaxed(0xc000, core->dos_base + PSCALE_CTRL);
> +
> +	writel_relaxed(0, core->dos_base + PSCALE_BMEM_ADDR);
> +	for (i = 0; i < ARRAY_SIZE(filt_coef); ++i) {
> +		writel_relaxed(0, core->dos_base + PSCALE_BMEM_DAT);
> +		writel_relaxed(filt_coef[i], core->dos_base + PSCALE_BMEM_DAT);
> +	}
> +
> +	writel_relaxed(74, core->dos_base + PSCALE_BMEM_ADDR);
> +	writel_relaxed(0x0008, core->dos_base + PSCALE_BMEM_DAT);
> +	writel_relaxed(0x60000000, core->dos_base + PSCALE_BMEM_DAT);
> +
> +	writel_relaxed(82, core->dos_base + PSCALE_BMEM_ADDR);
> +	writel_relaxed(0x0008, core->dos_base + PSCALE_BMEM_DAT);
> +	writel_relaxed(0x60000000, core->dos_base + PSCALE_BMEM_DAT);
> +
> +	writel_relaxed(78, core->dos_base + PSCALE_BMEM_ADDR);
> +	writel_relaxed(0x0008, core->dos_base + PSCALE_BMEM_DAT);
> +	writel_relaxed(0x60000000, core->dos_base + PSCALE_BMEM_DAT);
> +
> +	writel_relaxed(86, core->dos_base + PSCALE_BMEM_ADDR);
> +	writel_relaxed(0x0008, core->dos_base + PSCALE_BMEM_DAT);
> +	writel_relaxed(0x60000000, core->dos_base + PSCALE_BMEM_DAT);
> +
> +	writel_relaxed(73, core->dos_base + PSCALE_BMEM_ADDR);
> +	writel_relaxed(0x10000, core->dos_base + PSCALE_BMEM_DAT);
> +	writel_relaxed(81, core->dos_base + PSCALE_BMEM_ADDR);
> +	writel_relaxed(0x10000, core->dos_base + PSCALE_BMEM_DAT);
> +
> +	writel_relaxed(77, core->dos_base + PSCALE_BMEM_ADDR);
> +	writel_relaxed(0x10000, core->dos_base + PSCALE_BMEM_DAT);
> +	writel_relaxed(85, core->dos_base + PSCALE_BMEM_ADDR);
> +	writel_relaxed(0x10000, core->dos_base + PSCALE_BMEM_DAT);
> +
> +	writel_relaxed((1 << 10), core->dos_base + DOS_SW_RESET0);
> +	writel_relaxed(0, core->dos_base + DOS_SW_RESET0);
> +
> +	writel_relaxed(0x7, core->dos_base + PSCALE_RST);
> +	writel_relaxed(0, core->dos_base + PSCALE_RST);
> +}
> +
> +static int codec_mjpeg_start(struct vdec_session *sess)
> +{
> +	struct vdec_core *core = sess->core;
> +	struct codec_mjpeg *mjpeg = sess->priv;
> +
> +	mjpeg = kzalloc(sizeof(*mjpeg), GFP_KERNEL);
> +	if (!mjpeg)
> +		return -ENOMEM;
> +
> +	sess->priv = mjpeg;
> +
> +	writel_relaxed((1 << 7) | (1 << 6), core->dos_base + DOS_SW_RESET0);
> +	writel_relaxed(0, core->dos_base + DOS_SW_RESET0);
> +
> +	writel_relaxed(12, core->dos_base + AV_SCRATCH_0);
> +	writel_relaxed(0x031a, core->dos_base + AV_SCRATCH_1);
> +
> +	codec_helper_set_canvases(sess, core->dos_base + AV_SCRATCH_4);
> +	codec_mjpeg_init_scaler(core);
> +
> +	writel_relaxed(0, core->dos_base + MREG_TO_AMRISC);
> +	writel_relaxed(0, core->dos_base + MREG_FROM_AMRISC);
> +	writel_relaxed(0xffff, core->dos_base + MCPU_INTR_MSK);
> +	writel_relaxed((sess->height << 4) | 0x8000, core->dos_base + MREG_DECODE_PARAM);
> +	writel_relaxed(1, core->dos_base + ASSIST_MBOX1_CLR_REG);
> +	writel_relaxed(1, core->dos_base + ASSIST_MBOX1_MASK);
> +	writel_relaxed(8, core->dos_base + VDEC_ASSIST_AMR1_INT8);
> +
> +	/* Enable 2-plane output */
> +	writel_relaxed(readl_relaxed(core->dos_base + MDEC_PIC_DC_CTRL) | (1 << 17), core->dos_base + MDEC_PIC_DC_CTRL);
> +
> +	mjpeg->buffers_thread = kthread_run(codec_mjpeg_buffers_thread, sess, "buffers_done");
> +
> +	return 0;
> +}
> +
> +static int codec_mjpeg_stop(struct vdec_session *sess)
> +{
> +	struct codec_mjpeg *mjpeg = sess->priv;
> +
> +	kthread_stop(mjpeg->buffers_thread);
> +
> +	kfree(mjpeg);
> +	sess->priv = 0;
> +
> +	return 0;
> +}
> +
> +static irqreturn_t codec_mjpeg_isr(struct vdec_session *sess)
> +{
> +	u32 reg;
> +	u32 buffer_index;
> +	struct vdec_core *core = sess->core;
> +
> +	writel_relaxed(1, core->dos_base + ASSIST_MBOX1_CLR_REG);
> +
> +	reg = readl_relaxed(core->dos_base + MREG_FROM_AMRISC);
> +	if (!(reg & 0x7))
> +		return IRQ_HANDLED;
> +
> +	buffer_index = ((reg & 0x7) - 1) & 3;
> +	vdec_dst_buf_done_idx(sess, buffer_index);
> +
> +	writel_relaxed(0, core->dos_base + MREG_FROM_AMRISC);
> +	return IRQ_HANDLED;
> +}
> +
> +struct vdec_codec_ops codec_mjpeg_ops = {
> +	.start = codec_mjpeg_start,
> +	.stop = codec_mjpeg_stop,
> +	.isr = codec_mjpeg_isr,
> +	.notify_dst_buffer = vdec_queue_recycle,
> +};
> diff --git a/drivers/media/platform/meson/vdec/codec_mjpeg.h b/drivers/media/platform/meson/vdec/codec_mjpeg.h
> new file mode 100644
> index 000000000000..1164c61396dc
> --- /dev/null
> +++ b/drivers/media/platform/meson/vdec/codec_mjpeg.h
> @@ -0,0 +1,13 @@
> +/* SPDX-License-Identifier: GPL-2.0+ */
> +/*
> + * Copyright (C) 2018 Maxime Jourdan <maxi.jourdan@wanadoo.fr>
> + */
> +
> +#ifndef __MESON_VDEC_CODEC_MJPEG_H_
> +#define __MESON_VDEC_CODEC_MJPEG_H_
> +
> +#include "vdec.h"
> +
> +extern struct vdec_codec_ops codec_mjpeg_ops;
> +
> +#endif
> \ No newline at end of file
> diff --git a/drivers/media/platform/meson/vdec/codec_mpeg12.c b/drivers/media/platform/meson/vdec/codec_mpeg12.c
> new file mode 100644
> index 000000000000..8682adc24d6d
> --- /dev/null
> +++ b/drivers/media/platform/meson/vdec/codec_mpeg12.c
> @@ -0,0 +1,183 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/*
> + * Copyright (C) 2018 Maxime Jourdan <maxi.jourdan@wanadoo.fr>
> + */
> +
> +#include <media/v4l2-mem2mem.h>
> +#include <media/videobuf2-dma-contig.h>
> +
> +#include "codec_mpeg12.h"
> +#include "codec_helpers.h"
> +
> +#define SIZE_WORKSPACE	(2 * SZ_64K)
> +#define SIZE_CCBUF	(5 * SZ_1K)
> +
> +/* DOS registers */
> +#define ASSIST_MBOX1_CLR_REG 0x01d4
> +#define ASSIST_MBOX1_MASK    0x01d8
> +
> +#define PSCALE_CTRL 0x2444
> +
> +#define MDEC_PIC_DC_CTRL   0x2638
> +
> +#define AV_SCRATCH_0		0x2700
> +#define MREG_SEQ_INFO		0x2710
> +#define MREG_PIC_INFO		0x2714
> +#define MREG_PIC_WIDTH		0x2718
> +#define MREG_PIC_HEIGHT		0x271c
> +#define MREG_BUFFERIN		0x2720
> +#define MREG_BUFFEROUT		0x2724
> +#define MREG_CMD		0x2728
> +#define MREG_CO_MV_START	0x272c
> +#define MREG_ERROR_COUNT	0x2730
> +#define MREG_FRAME_OFFSET	0x2734
> +#define MREG_WAIT_BUFFER	0x2738
> +#define MREG_FATAL_ERROR	0x273c
> +
> +#define MPEG1_2_REG	0x3004
> +#define PIC_HEAD_INFO	0x300c
> +#define POWER_CTL_VLD	0x3020
> +#define M4_CONTROL_REG	0x30a4
> +
> +#define DOS_SW_RESET0 0xfc00
> +
> +struct codec_mpeg12 {
> +	/* Buffer for the MPEG1/2 Workspace */
> +	void      *workspace_vaddr;
> +	dma_addr_t workspace_paddr;
> +
> +	/* Housekeeping thread for recycling buffers into the hardware */
> +	struct task_struct *buffers_thread;
> +};
> +
> +static int codec_mpeg12_buffers_thread(void *data)
> +{
> +	struct vdec_buffer *tmp;
> +	struct vdec_session *sess = data;
> +	struct vdec_core *core = sess->core;;
> +
> +	while (!kthread_should_stop()) {
> +		mutex_lock(&sess->bufs_recycle_lock);
> +		while (!list_empty(&sess->bufs_recycle) &&
> +		       !readl_relaxed(core->dos_base + MREG_BUFFERIN))
> +		{
> +			tmp = list_first_entry(&sess->bufs_recycle, struct vdec_buffer, list);
> +
> +			/* Tell the decoder he can recycle this buffer */
> +			writel_relaxed(tmp->index + 1, core->dos_base + MREG_BUFFERIN);
> +
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
> +static int codec_mpeg12_start(struct vdec_session *sess) {
> +	struct vdec_core *core = sess->core;
> +	struct codec_mpeg12 *mpeg12 = sess->priv;
> +	int ret;
> +
> +	mpeg12 = kzalloc(sizeof(*mpeg12), GFP_KERNEL);
> +	if (!mpeg12)
> +		return -ENOMEM;
> +
> +	sess->priv = mpeg12;
> +
> +	/* Allocate some memory for the MPEG1/2 decoder's state */
> +	mpeg12->workspace_vaddr = dma_alloc_coherent(core->dev, SIZE_WORKSPACE, &mpeg12->workspace_paddr, GFP_KERNEL);
> +	if (!mpeg12->workspace_vaddr) {
> +		dev_err(core->dev, "Failed to request MPEG 1/2 Workspace\n");
> +		ret = -ENOMEM;
> +		goto free_mpeg12;
> +	}
> +
> +	writel_relaxed((1<<9) | (1<<8) | (1<<7) | (1<<6) | (1<<4), core->dos_base + DOS_SW_RESET0);
> +	writel_relaxed(0, core->dos_base + DOS_SW_RESET0);
> +	readl_relaxed(core->dos_base + DOS_SW_RESET0);
> +
> +	writel_relaxed((1 << 4), core->dos_base + POWER_CTL_VLD);
> +
> +	codec_helper_set_canvases(sess, core->dos_base + AV_SCRATCH_0);
> +	writel_relaxed(mpeg12->workspace_paddr + SIZE_CCBUF, core->dos_base + MREG_CO_MV_START);
> +
> +	writel_relaxed(0, core->dos_base + MPEG1_2_REG);
> +	writel_relaxed(0, core->dos_base + PSCALE_CTRL);
> +	writel_relaxed(0x380, core->dos_base + PIC_HEAD_INFO);
> +	writel_relaxed(0, core->dos_base + M4_CONTROL_REG);
> +	writel_relaxed(1, core->dos_base + ASSIST_MBOX1_CLR_REG);
> +	writel_relaxed(0, core->dos_base + MREG_BUFFERIN);
> +	writel_relaxed(0, core->dos_base + MREG_BUFFEROUT);
> +	writel_relaxed((sess->width << 16) | sess->height, core->dos_base + MREG_CMD);
> +	writel_relaxed(0, core->dos_base + MREG_ERROR_COUNT);
> +	writel_relaxed(0, core->dos_base + MREG_FATAL_ERROR);
> +	writel_relaxed(0, core->dos_base + MREG_WAIT_BUFFER);
> +
> +	/* Enable NV21 */
> +	writel_relaxed(readl_relaxed(core->dos_base + MDEC_PIC_DC_CTRL) | (1 << 17), core->dos_base + MDEC_PIC_DC_CTRL);
> +
> +	mpeg12->buffers_thread = kthread_run(codec_mpeg12_buffers_thread, sess, "buffers_done");
> +
> +	return 0;
> +
> +free_mpeg12:
> +	kfree(mpeg12);
> +	return ret;
> +}
> +
> +static int codec_mpeg12_stop(struct vdec_session *sess)
> +{
> +	struct codec_mpeg12 *mpeg12 = sess->priv;
> +	struct vdec_core *core = sess->core;
> +
> +	kthread_stop(mpeg12->buffers_thread);
> +
> +	if (mpeg12->workspace_vaddr) {
> +		dma_free_coherent(core->dev, SIZE_WORKSPACE, mpeg12->workspace_vaddr, mpeg12->workspace_paddr);
> +		mpeg12->workspace_vaddr = 0;
> +	}
> +
> +	kfree(mpeg12);
> +	sess->priv = 0;
> +
> +	return 0;
> +}
> +
> +static irqreturn_t codec_mpeg12_isr(struct vdec_session *sess)
> +{
> +	u32 reg;
> +	u32 buffer_index;
> +	struct vdec_core *core = sess->core;
> +
> +	writel_relaxed(1, core->dos_base + ASSIST_MBOX1_CLR_REG);
> +
> +	reg = readl_relaxed(core->dos_base + MREG_FATAL_ERROR);
> +	if (reg == 1)
> +		dev_err(core->dev, "MPEG12 fatal error\n");
> +
> +	reg = readl_relaxed(core->dos_base + MREG_BUFFEROUT);
> +	if (!reg)
> +		return IRQ_HANDLED;
> +
> +	if ((reg >> 16) & 0xfe)
> +		goto end;
> +
> +	buffer_index = ((reg & 0xf) - 1) & 7;
> +	vdec_dst_buf_done_idx(sess, buffer_index);
> +
> +end:
> +	writel_relaxed(0, core->dos_base + MREG_BUFFEROUT);
> +	return IRQ_HANDLED;
> +}
> +
> +struct vdec_codec_ops codec_mpeg12_ops = {
> +	.start = codec_mpeg12_start,
> +	.stop = codec_mpeg12_stop,
> +	.isr = codec_mpeg12_isr,
> +	.notify_dst_buffer = vdec_queue_recycle,
> +};
> +
> diff --git a/drivers/media/platform/meson/vdec/codec_mpeg12.h b/drivers/media/platform/meson/vdec/codec_mpeg12.h
> new file mode 100644
> index 000000000000..7dc37adc0100
> --- /dev/null
> +++ b/drivers/media/platform/meson/vdec/codec_mpeg12.h
> @@ -0,0 +1,13 @@
> +/* SPDX-License-Identifier: GPL-2.0+ */
> +/*
> + * Copyright (C) 2018 Maxime Jourdan <maxi.jourdan@wanadoo.fr>
> + */
> +
> +#ifndef __MESON_VDEC_CODEC_MPEG12_H_
> +#define __MESON_VDEC_CODEC_MPEG12_H_
> +
> +#include "vdec.h"
> +
> +extern struct vdec_codec_ops codec_mpeg12_ops;
> +
> +#endif
> \ No newline at end of file
> diff --git a/drivers/media/platform/meson/vdec/codec_mpeg4.c b/drivers/media/platform/meson/vdec/codec_mpeg4.c
> new file mode 100644
> index 000000000000..739b97e6024b
> --- /dev/null
> +++ b/drivers/media/platform/meson/vdec/codec_mpeg4.c
> @@ -0,0 +1,213 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/*
> + * Copyright (C) 2018 Maxime Jourdan <maxi.jourdan@wanadoo.fr>
> + */
> +
> +#include <media/v4l2-mem2mem.h>
> +#include <media/videobuf2-dma-contig.h>
> +
> +#include "codec_mpeg4.h"
> +#include "codec_helpers.h"
> +#include "canvas.h"
> +
> +#define SIZE_WORKSPACE		(1 * SZ_1M)
> +#define DCAC_BUFF_START_IP	0x02b00000
> +
> +/* DOS registers */
> +#define ASSIST_MBOX1_CLR_REG 0x01d4
> +#define ASSIST_MBOX1_MASK    0x01d8
> +
> +#define PSCALE_CTRL 0x2444
> +
> +#define MDEC_PIC_DC_CTRL   0x2638
> +#define MDEC_PIC_DC_THRESH 0x26e0
> +
> +#define AV_SCRATCH_0        0x2700
> +#define MP4_PIC_RATIO       0x2714
> +#define MP4_RATE            0x270c
> +#define AV_SCRATCH_4        0x2710
> +#define MP4_ERR_COUNT       0x2718
> +#define MP4_PIC_WH          0x271c
> +#define MREG_BUFFERIN       0x2720
> +#define MREG_BUFFEROUT      0x2724
> +#define MP4_NOT_CODED_CNT   0x2728
> +#define MP4_VOP_TIME_INC    0x272c
> +#define MP4_OFFSET_REG      0x2730
> +#define MP4_SYS_RATE        0x2738
> +#define MEM_OFFSET_REG      0x273c
> +#define AV_SCRATCH_G        0x2740
> +#define MREG_FATAL_ERROR    0x2754
> +
> +#define DOS_SW_RESET0 0xfc00
> +
> +struct codec_mpeg4 {
> +	/* Buffer for the MPEG1/2 Workspace */
> +	void      *workspace_vaddr;
> +	dma_addr_t workspace_paddr;
> +
> +	/* Housekeeping thread for recycling buffers into the hardware */
> +	struct task_struct *buffers_thread;
> +};
> +
> +static int codec_mpeg4_buffers_thread(void *data)
> +{
> +	struct vdec_buffer *tmp;
> +	struct vdec_session *sess = data;
> +	struct vdec_core *core = sess->core;;
> +
> +	while (!kthread_should_stop()) {
> +		mutex_lock(&sess->bufs_recycle_lock);
> +		while (!list_empty(&sess->bufs_recycle) &&
> +		       !readl_relaxed(core->dos_base + MREG_BUFFERIN))
> +		{
> +			tmp = list_first_entry(&sess->bufs_recycle, struct vdec_buffer, list);
> +
> +			/* Tell the decoder he can recycle this buffer */
> +			writel_relaxed(~(1 << tmp->index), core->dos_base + MREG_BUFFERIN);
> +
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
> +/* The MPEG4 canvas regs are not contiguous,
> + * handle it specifically instead of using the helper
> + * AV_SCRATCH_0 - AV_SCRATCH_3  ;  AV_SCRATCH_G - AV_SCRATCH_J
> + */
> +void codec_mpeg4_set_canvases(struct vdec_session *sess) {
> +	struct v4l2_m2m_buffer *buf;
> +	struct vdec_core *core = sess->core;
> +	void *current_reg = core->dos_base + AV_SCRATCH_0;
> +	u32 width = ALIGN(sess->width, 64);
> +	u32 height = ALIGN(sess->height, 64);
> +
> +	/* Setup NV12 canvases for Decoded Picture Buffer (dpb)
> +	 * Map them to the user buffers' planes
> +	 */
> +	v4l2_m2m_for_each_dst_buf(sess->m2m_ctx, buf) {
> +		u32 buf_idx    = buf->vb.vb2_buf.index;
> +		u32 cnv_y_idx  = buf_idx * 2;
> +		u32 cnv_uv_idx = buf_idx * 2 + 1;
> +		dma_addr_t buf_y_paddr  =
> +			vb2_dma_contig_plane_dma_addr(&buf->vb.vb2_buf, 0);
> +		dma_addr_t buf_uv_paddr =
> +			vb2_dma_contig_plane_dma_addr(&buf->vb.vb2_buf, 1);
> +
> +		/* Y plane */
> +		vdec_canvas_setup(core->dmc_base, cnv_y_idx, buf_y_paddr, width, height, MESON_CANVAS_WRAP_NONE, MESON_CANVAS_BLKMODE_LINEAR);
> +
> +		/* U/V plane */
> +		vdec_canvas_setup(core->dmc_base, cnv_uv_idx, buf_uv_paddr, width, height / 2, MESON_CANVAS_WRAP_NONE, MESON_CANVAS_BLKMODE_LINEAR);
> +
> +		writel_relaxed(((cnv_uv_idx) << 16) |
> +			       ((cnv_uv_idx) << 8)  |
> +				(cnv_y_idx), current_reg);
> +
> +		current_reg += 4;
> +		if (current_reg == core->dos_base + AV_SCRATCH_4)
> +			current_reg = core->dos_base + AV_SCRATCH_G;
> +	}
> +}
> +
> +static int codec_mpeg4_start(struct vdec_session *sess) {
> +	struct vdec_core *core = sess->core;
> +	struct codec_mpeg4 *mpeg4 = sess->priv;
> +	int ret;
> +
> +	mpeg4 = kzalloc(sizeof(*mpeg4), GFP_KERNEL);
> +	if (!mpeg4)
> +		return -ENOMEM;
> +
> +	sess->priv = mpeg4;
> +
> +	/* Allocate some memory for the MPEG4 decoder's state */
> +	mpeg4->workspace_vaddr = dma_alloc_coherent(core->dev, SIZE_WORKSPACE, &mpeg4->workspace_paddr, GFP_KERNEL);
> +	if (!mpeg4->workspace_vaddr) {
> +		dev_err(core->dev, "Failed to request MPEG4 Workspace\n");
> +		ret = -ENOMEM;
> +		goto free_mpeg4;
> +	}
> +
> +	writel_relaxed((1<<7) | (1<<6), core->dos_base + DOS_SW_RESET0);
> +	writel_relaxed(0, core->dos_base + DOS_SW_RESET0);
> +	readl_relaxed(core->dos_base + DOS_SW_RESET0);
> +
> +	codec_mpeg4_set_canvases(sess);
> +
> +	writel_relaxed(mpeg4->workspace_paddr - DCAC_BUFF_START_IP, core->dos_base + MEM_OFFSET_REG);
> +	writel_relaxed(0, core->dos_base + PSCALE_CTRL);
> +	writel_relaxed(0, core->dos_base + MP4_NOT_CODED_CNT);
> +	writel_relaxed(0, core->dos_base + MREG_BUFFERIN);
> +	writel_relaxed(0, core->dos_base + MREG_BUFFEROUT);
> +	writel_relaxed(0, core->dos_base + MREG_FATAL_ERROR);
> +	writel_relaxed(1, core->dos_base + ASSIST_MBOX1_CLR_REG);
> +	writel_relaxed(1, core->dos_base + ASSIST_MBOX1_MASK);
> +	writel_relaxed(0x404038aa, core->dos_base + MDEC_PIC_DC_THRESH);
> +
> +	/* Enable NV21 */
> +	writel_relaxed(readl_relaxed(core->dos_base + MDEC_PIC_DC_CTRL) | (1 << 17), core->dos_base + MDEC_PIC_DC_CTRL);
> +
> +	mpeg4->buffers_thread = kthread_run(codec_mpeg4_buffers_thread, sess, "buffers_done");
> +
> +	return 0;
> +
> +free_mpeg4:
> +	kfree(mpeg4);
> +	return ret;
> +}
> +
> +static int codec_mpeg4_stop(struct vdec_session *sess)
> +{
> +	struct codec_mpeg4 *mpeg4 = sess->priv;
> +	struct vdec_core *core = sess->core;
> +
> +	kthread_stop(mpeg4->buffers_thread);
> +
> +	if (mpeg4->workspace_vaddr) {
> +		dma_free_coherent(core->dev, SIZE_WORKSPACE, mpeg4->workspace_vaddr, mpeg4->workspace_paddr);
> +		mpeg4->workspace_vaddr = 0;
> +	}
> +
> +	kfree(mpeg4);
> +	sess->priv = 0;
> +
> +	return 0;
> +}
> +
> +static irqreturn_t codec_mpeg4_isr(struct vdec_session *sess)
> +{
> +	u32 reg;
> +	u32 buffer_index;
> +	struct vdec_core *core = sess->core;
> +
> +	reg = readl_relaxed(core->dos_base + MREG_FATAL_ERROR);
> +	if (reg == 1)
> +		dev_err(core->dev, "mpeg4 fatal error\n");
> +
> +	reg = readl_relaxed(core->dos_base + MREG_BUFFEROUT);
> +	if (reg) {
> +		readl_relaxed(core->dos_base + MP4_NOT_CODED_CNT);
> +		readl_relaxed(core->dos_base + MP4_VOP_TIME_INC);
> +		buffer_index = reg & 0x7;
> +		vdec_dst_buf_done_idx(sess, buffer_index);
> +		writel_relaxed(0, core->dos_base + MREG_BUFFEROUT);
> +	}
> +
> +	writel_relaxed(1, core->dos_base + ASSIST_MBOX1_CLR_REG);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +struct vdec_codec_ops codec_mpeg4_ops = {
> +	.start = codec_mpeg4_start,
> +	.stop = codec_mpeg4_stop,
> +	.isr = codec_mpeg4_isr,
> +	.notify_dst_buffer = vdec_queue_recycle,
> +};
> +
> diff --git a/drivers/media/platform/meson/vdec/codec_mpeg4.h b/drivers/media/platform/meson/vdec/codec_mpeg4.h
> new file mode 100644
> index 000000000000..a30ceed8b2a3
> --- /dev/null
> +++ b/drivers/media/platform/meson/vdec/codec_mpeg4.h
> @@ -0,0 +1,13 @@
> +/* SPDX-License-Identifier: GPL-2.0+ */
> +/*
> + * Copyright (C) 2018 Maxime Jourdan <maxi.jourdan@wanadoo.fr>
> + */
> +
> +#ifndef __MESON_VDEC_CODEC_MPEG4_H_
> +#define __MESON_VDEC_CODEC_MPEG4_H_
> +
> +#include "vdec.h"
> +
> +extern struct vdec_codec_ops codec_mpeg4_ops;
> +
> +#endif
> \ No newline at end of file
> diff --git a/drivers/media/platform/meson/vdec/esparser.c b/drivers/media/platform/meson/vdec/esparser.c
> new file mode 100644
> index 000000000000..400d6d5650ae
> --- /dev/null
> +++ b/drivers/media/platform/meson/vdec/esparser.c
> @@ -0,0 +1,320 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/*
> + * Copyright (C) 2018 Maxime Jourdan <maxi.jourdan@wanadoo.fr>
> + */
> +
> +#include <linux/init.h>
> +#include <linux/ioctl.h>
> +#include <linux/list.h>
> +#include <linux/module.h>
> +#include <linux/of_device.h>
> +#include <linux/platform_device.h>
> +#include <linux/reset.h>
> +#include <media/videobuf2-dma-contig.h>
> +#include <media/v4l2-mem2mem.h>
> +
> +#include "esparser.h"
> +
> +/* PARSER REGS (CBUS) */
> +#define PARSER_CONTROL 0x00
> +	#define ES_PACK_SIZE_BIT	8
> +	#define ES_WRITE		BIT(5)
> +	#define ES_SEARCH		BIT(1)
> +	#define ES_PARSER_START		BIT(0)
> +#define PARSER_FETCH_ADDR 0x4
> +#define PARSER_FETCH_CMD  0x8
> +#define PARSER_CONFIG 0x14
> +	#define PS_CFG_MAX_FETCH_CYCLE_BIT  0
> +	#define PS_CFG_STARTCODE_WID_24_BIT 10
> +	#define PS_CFG_MAX_ES_WR_CYCLE_BIT  12
> +	#define PS_CFG_PFIFO_EMPTY_CNT_BIT  16
> +#define PFIFO_WR_PTR 0x18
> +#define PFIFO_RD_PTR 0x1c
> +#define PARSER_SEARCH_PATTERN 0x24
> +	#define ES_START_CODE_PATTERN 0x00000100
> +#define PARSER_SEARCH_MASK 0x28
> +	#define ES_START_CODE_MASK	0xffffff00
> +	#define FETCH_ENDIAN_BIT	  27
> +#define PARSER_INT_ENABLE 0x2c
> +	#define PARSER_INT_HOST_EN_BIT 8
> +#define PARSER_INT_STATUS 0x30
> +	#define PARSER_INTSTAT_SC_FOUND 1
> +#define PARSER_ES_CONTROL 0x5c
> +#define PARSER_VIDEO_START_PTR 0x80
> +#define PARSER_VIDEO_END_PTR 0x84
> +#define PARSER_VIDEO_HOLE 0x90
> +
> +/* STBUF regs */
> +#define VLD_MEM_VIFIFO_BUF_CNTL 0x3120
> +	#define MEM_BUFCTRL_MANUAL	BIT(1)
> +
> +#define SEARCH_PATTERN_LEN   512
> +
> +static DECLARE_WAIT_QUEUE_HEAD(wq);
> +static int search_done;
> +
> +/* Buffer to send to the ESPARSER to signal End Of Stream.
> + * Credits to Endless Mobile.
> + */
> +#define EOS_TAIL_BUF_SIZE 1024
> +static const u8 eos_tail_data[] = {
> +	0x00, 0x00, 0x00, 0x01, 0x06, 0x05, 0xff, 0xe4, 0xdc, 0x45, 0xe9, 0xbd, 0xe6, 0xd9, 0x48, 0xb7,
> +	0x96, 0x2c, 0xd8, 0x20, 0xd9, 0x23, 0xee, 0xef, 0x78, 0x32, 0x36, 0x34, 0x20, 0x2d, 0x20, 0x63,
> +	0x6f, 0x72, 0x65, 0x20, 0x36, 0x37, 0x20, 0x72, 0x31, 0x31, 0x33, 0x30, 0x20, 0x38, 0x34, 0x37,
> +	0x35, 0x39, 0x37, 0x37, 0x20, 0x2d, 0x20, 0x48, 0x2e, 0x32, 0x36, 0x34, 0x2f, 0x4d, 0x50, 0x45,
> +	0x47, 0x2d, 0x34, 0x20, 0x41, 0x56, 0x43, 0x20, 0x63, 0x6f, 0x64, 0x65, 0x63, 0x20, 0x2d, 0x20,
> +	0x43, 0x6f, 0x70, 0x79, 0x6c, 0x65, 0x66, 0x74, 0x20, 0x32, 0x30, 0x30, 0x33, 0x2d, 0x32, 0x30,
> +	0x30, 0x39, 0x20, 0x2d, 0x20, 0x68, 0x74, 0x74, 0x70, 0x3a, 0x2f, 0x2f, 0x77, 0x77, 0x77, 0x2e,
> +	0x76, 0x69, 0x64, 0x65, 0x6f, 0x6c, 0x61, 0x6e, 0x2e, 0x6f, 0x72, 0x67, 0x2f, 0x78, 0x32, 0x36,
> +	0x34, 0x2e, 0x68, 0x74, 0x6d, 0x6c, 0x20, 0x2d, 0x20, 0x6f, 0x70, 0x74, 0x69, 0x6f, 0x6e, 0x73,
> +	0x3a, 0x20, 0x63, 0x61, 0x62, 0x61, 0x63, 0x3d, 0x31, 0x20, 0x72, 0x65, 0x66, 0x3d, 0x31, 0x20,
> +	0x64, 0x65, 0x62, 0x6c, 0x6f, 0x63, 0x6b, 0x3d, 0x31, 0x3a, 0x30, 0x3a, 0x30, 0x20, 0x61, 0x6e,
> +	0x61, 0x6c, 0x79, 0x73, 0x65, 0x3d, 0x30, 0x78, 0x31, 0x3a, 0x30, 0x78, 0x31, 0x31, 0x31, 0x20,
> +	0x6d, 0x65, 0x3d, 0x68, 0x65, 0x78, 0x20, 0x73, 0x75, 0x62, 0x6d, 0x65, 0x3d, 0x36, 0x20, 0x70,
> +	0x73, 0x79, 0x5f, 0x72, 0x64, 0x3d, 0x31, 0x2e, 0x30, 0x3a, 0x30, 0x2e, 0x30, 0x20, 0x6d, 0x69,
> +	0x78, 0x65, 0x64, 0x5f, 0x72, 0x65, 0x66, 0x3d, 0x30, 0x20, 0x6d, 0x65, 0x5f, 0x72, 0x61, 0x6e,
> +	0x67, 0x65, 0x3d, 0x31, 0x36, 0x20, 0x63, 0x68, 0x72, 0x6f, 0x6d, 0x61, 0x5f, 0x6d, 0x65, 0x3d,
> +	0x31, 0x20, 0x74, 0x72, 0x65, 0x6c, 0x6c, 0x69, 0x73, 0x3d, 0x30, 0x20, 0x38, 0x78, 0x38, 0x64,
> +	0x63, 0x74, 0x3d, 0x30, 0x20, 0x63, 0x71, 0x6d, 0x3d, 0x30, 0x20, 0x64, 0x65, 0x61, 0x64, 0x7a,
> +	0x6f, 0x6e, 0x65, 0x3d, 0x32, 0x31, 0x2c, 0x31, 0x31, 0x20, 0x63, 0x68, 0x72, 0x6f, 0x6d, 0x61,
> +	0x5f, 0x71, 0x70, 0x5f, 0x6f, 0x66, 0x66, 0x73, 0x65, 0x74, 0x3d, 0x2d, 0x32, 0x20, 0x74, 0x68,
> +	0x72, 0x65, 0x61, 0x64, 0x73, 0x3d, 0x31, 0x20, 0x6e, 0x72, 0x3d, 0x30, 0x20, 0x64, 0x65, 0x63,
> +	0x69, 0x6d, 0x61, 0x74, 0x65, 0x3d, 0x31, 0x20, 0x6d, 0x62, 0x61, 0x66, 0x66, 0x3d, 0x30, 0x20,
> +	0x62, 0x66, 0x72, 0x61, 0x6d, 0x65, 0x73, 0x3d, 0x30, 0x20, 0x6b, 0x65, 0x79, 0x69, 0x6e, 0x74,
> +	0x3d, 0x32, 0x35, 0x30, 0x20, 0x6b, 0x65, 0x79, 0x69, 0x6e, 0x74, 0x5f, 0x6d, 0x69, 0x6e, 0x3d,
> +	0x32, 0x35, 0x20, 0x73, 0x63, 0x65, 0x6e, 0x65, 0x63, 0x75, 0x74, 0x3d, 0x34, 0x30, 0x20, 0x72,
> +	0x63, 0x3d, 0x61, 0x62, 0x72, 0x20, 0x62, 0x69, 0x74, 0x72, 0x61, 0x74, 0x65, 0x3d, 0x31, 0x30,
> +	0x20, 0x72, 0x61, 0x74, 0x65, 0x74, 0x6f, 0x6c, 0x3d, 0x31, 0x2e, 0x30, 0x20, 0x71, 0x63, 0x6f,
> +	0x6d, 0x70, 0x3d, 0x30, 0x2e, 0x36, 0x30, 0x20, 0x71, 0x70, 0x6d, 0x69, 0x6e, 0x3d, 0x31, 0x30,
> +	0x20, 0x71, 0x70, 0x6d, 0x61, 0x78, 0x3d, 0x35, 0x31, 0x20, 0x71, 0x70, 0x73, 0x74, 0x65, 0x70,
> +	0x3d, 0x34, 0x20, 0x69, 0x70, 0x5f, 0x72, 0x61, 0x74, 0x69, 0x6f, 0x3d, 0x31, 0x2e, 0x34, 0x30,
> +	0x20, 0x61, 0x71, 0x3d, 0x31, 0x3a, 0x31, 0x2e, 0x30, 0x30, 0x00, 0x80, 0x00, 0x00, 0x00, 0x01,
> +	0x67, 0x4d, 0x40, 0x0a, 0x9a, 0x74, 0xf4, 0x20, 0x00, 0x00, 0x03, 0x00, 0x20, 0x00, 0x00, 0x06,
> +	0x51, 0xe2, 0x44, 0xd4, 0x00, 0x00, 0x00, 0x01, 0x68, 0xee, 0x32, 0xc8, 0x00, 0x00, 0x00, 0x01,
> +	0x65, 0x88, 0x80, 0x20, 0x00, 0x08, 0x7f, 0xea, 0x6a, 0xe2, 0x99, 0xb6, 0x57, 0xae, 0x49, 0x30,
> +	0xf5, 0xfe, 0x5e, 0x46, 0x0b, 0x72, 0x44, 0xc4, 0xe1, 0xfc, 0x62, 0xda, 0xf1, 0xfb, 0xa2, 0xdb,
> +	0xd6, 0xbe, 0x5c, 0xd7, 0x24, 0xa3, 0xf5, 0xb9, 0x2f, 0x57, 0x16, 0x49, 0x75, 0x47, 0x77, 0x09,
> +	0x5c, 0xa1, 0xb4, 0xc3, 0x4f, 0x60, 0x2b, 0xb0, 0x0c, 0xc8, 0xd6, 0x66, 0xba, 0x9b, 0x82, 0x29,
> +	0x33, 0x92, 0x26, 0x99, 0x31, 0x1c, 0x7f, 0x9b
> +};
> +
> +static irqreturn_t esparser_isr(int irq, void *dev)
> +{
> +	int int_status;
> +	struct vdec_core *core = dev;
> +
> +	int_status = readl_relaxed(core->esparser_base + PARSER_INT_STATUS);
> +	writel_relaxed(int_status, core->esparser_base + PARSER_INT_STATUS);
> +
> +	dev_dbg(core->dev, "esparser_isr, status = %08X\n", int_status);
> +
> +	if (int_status & PARSER_INTSTAT_SC_FOUND) {
> +		writel_relaxed(0, core->esparser_base + PFIFO_RD_PTR);
> +		writel_relaxed(0, core->esparser_base + PFIFO_WR_PTR);
> +		search_done = 1;
> +		wake_up_interruptible(&wq);
> +	}
> +
> +	return IRQ_HANDLED;
> +}
> +
> +/* Add a start code at the end of the buffer
> + * to trigger the esparser interrupt
> + */
> +static void esparser_append_start_code(struct vb2_buffer *vb)
> +{
> +	u8 *vaddr = vb2_plane_vaddr(vb, 0) + vb2_get_plane_payload(vb, 0);
> +
> +	vaddr[0] = 0x00;
> +	vaddr[1] = 0x00;
> +	vaddr[2] = 0x01;
> +	vaddr[3] = 0xff;
> +}
> +
> +static int
> +esparser_write_data(struct vdec_core *core, dma_addr_t addr, u32 size)
> +{
> +	writel_relaxed(0, core->esparser_base + PFIFO_RD_PTR);
> +	writel_relaxed(0, core->esparser_base + PFIFO_WR_PTR);
> +	writel_relaxed(ES_WRITE | ES_PARSER_START | ES_SEARCH | (size << ES_PACK_SIZE_BIT), core->esparser_base + PARSER_CONTROL);
> +
> +	writel_relaxed(addr, core->esparser_base + PARSER_FETCH_ADDR);
> +	writel_relaxed((7 << FETCH_ENDIAN_BIT) | (size + 512), core->esparser_base + PARSER_FETCH_CMD);
> +	search_done = 0;
> +
> +	return wait_event_interruptible_timeout(wq, search_done != 0, HZ/5);
> +}
> +
> +static u32 esparser_vififo_get_free_space(struct vdec_session *sess)
> +{
> +	u32 vififo_usage;
> +	struct vdec_ops *vdec_ops = sess->fmt_out->vdec_ops;
> +	struct vdec_core *core = sess->core;
> +
> +	vififo_usage  = vdec_ops->vififo_level(sess);
> +	vififo_usage += readl_relaxed(core->esparser_base + PARSER_VIDEO_HOLE);
> +	vififo_usage += (6 * SZ_1K);
> +
> +	if (vififo_usage > sess->vififo_size) {
> +		dev_warn(sess->core->dev,
> +			"VIFIFO usage (%u) > VIFIFO size (%u)\n",
> +			vififo_usage, sess->vififo_size);
> +		return 0;
> +	}
> +
> +	return sess->vififo_size - vififo_usage;
> +}
> +
> +int esparser_queue_eos(struct vdec_session *sess)
> +{
> +	struct device *dev = sess->core->dev;
> +	struct vdec_core *core = sess->core;
> +	void *eos_vaddr;
> +	dma_addr_t eos_paddr;
> +	int ret;
> +
> +	eos_vaddr = dma_alloc_coherent(dev, EOS_TAIL_BUF_SIZE + 512, &eos_paddr, GFP_KERNEL);
> +	if (!eos_vaddr)
> +		return -ENOMEM;
> +
> +	sess->should_stop = 1;
> +
> +	memcpy(eos_vaddr, eos_tail_data, sizeof(eos_tail_data));
> +	ret = esparser_write_data(core, eos_paddr, EOS_TAIL_BUF_SIZE);
> +	dma_free_coherent(dev, EOS_TAIL_BUF_SIZE + 512,
> +			  eos_vaddr, eos_paddr);
> +
> +	return ret;
> +}
> +
> +static int esparser_queue(struct vdec_session *sess, struct vb2_v4l2_buffer *vbuf)
> +{
> +	int ret;
> +	struct vb2_buffer *vb = &vbuf->vb2_buf;
> +	struct vdec_core *core = sess->core;
> +	struct vdec_codec_ops *codec_ops = sess->fmt_out->codec_ops;
> +	u32 num_dst_bufs = v4l2_m2m_num_dst_bufs_ready(sess->m2m_ctx);
> +	u32 payload_size = vb2_get_plane_payload(vb, 0);
> +	dma_addr_t phy = vb2_dma_contig_plane_dma_addr(vb, 0);
> +
> +	if (!payload_size) {
> +		esparser_queue_eos(sess);
> +		return 0;
> +	}
> +
> +	if (codec_ops->num_pending_bufs)
> +		num_dst_bufs += codec_ops->num_pending_bufs(sess);
> +
> +	if (esparser_vififo_get_free_space(sess) < payload_size ||
> +	    atomic_read(&sess->esparser_queued_bufs) >= num_dst_bufs)
> +		return -EAGAIN;
> +
> +	v4l2_m2m_src_buf_remove_by_buf(sess->m2m_ctx, vbuf);
> +	vdec_add_ts_reorder(sess, vb->timestamp);
> +
> +	esparser_append_start_code(vb);
> +	ret = esparser_write_data(core, phy, payload_size);
> +
> +	if (ret > 0) {
> +		vbuf->flags = 0;
> +		vbuf->field = V4L2_FIELD_NONE;
> +		v4l2_m2m_buf_done(vbuf, VB2_BUF_STATE_DONE);
> +	} else if (ret <= 0) {
> +		printk("ESPARSER input parsing error\n");
> +		vdec_remove_ts(sess, vb->timestamp);
> +		v4l2_m2m_buf_done(vbuf, VB2_BUF_STATE_ERROR);
> +		writel_relaxed(0, core->esparser_base + PARSER_FETCH_CMD);
> +	}
> +
> +	if (vbuf->flags & V4L2_BUF_FLAG_LAST)
> +		esparser_queue_eos(sess);
> +
> +	return 0;
> +}
> +
> +void esparser_queue_all_src(struct work_struct *work)
> +{
> +	struct v4l2_m2m_buffer *buf, *n;
> +	struct vdec_session *sess =
> +		container_of(work, struct vdec_session, esparser_queue_work);
> +
> +	mutex_lock(&sess->lock);
> +	v4l2_m2m_for_each_src_buf_safe(sess->m2m_ctx, buf, n) {
> +		if (esparser_queue(sess, &buf->vb) < 0)
> +			break;
> +
> +		atomic_inc(&sess->esparser_queued_bufs);
> +	}
> +	mutex_unlock(&sess->lock);
> +}
> +
> +int esparser_power_up(struct vdec_session *sess)
> +{
> +	struct vdec_core *core = sess->core;
> +	struct vdec_ops *vdec_ops = sess->fmt_out->vdec_ops;
> +
> +	reset_control_reset(core->esparser_reset);
> +	writel_relaxed((10 << PS_CFG_PFIFO_EMPTY_CNT_BIT) |
> +				(1  << PS_CFG_MAX_ES_WR_CYCLE_BIT) |
> +				(16 << PS_CFG_MAX_FETCH_CYCLE_BIT),
> +				core->esparser_base + PARSER_CONFIG);
> +
> +	writel_relaxed(0, core->esparser_base + PFIFO_RD_PTR);
> +	writel_relaxed(0, core->esparser_base + PFIFO_WR_PTR);
> +
> +	writel_relaxed(ES_START_CODE_PATTERN, core->esparser_base + PARSER_SEARCH_PATTERN);
> +	writel_relaxed(ES_START_CODE_MASK,    core->esparser_base + PARSER_SEARCH_MASK);
> +
> +	writel_relaxed((10 << PS_CFG_PFIFO_EMPTY_CNT_BIT) |
> +				   (1  << PS_CFG_MAX_ES_WR_CYCLE_BIT) |
> +				   (16 << PS_CFG_MAX_FETCH_CYCLE_BIT) |
> +				   (2  << PS_CFG_STARTCODE_WID_24_BIT),
> +				   core->esparser_base + PARSER_CONFIG);
> +
> +	writel_relaxed((ES_SEARCH | ES_PARSER_START), core->esparser_base + PARSER_CONTROL);
> +
> +	writel_relaxed(sess->vififo_paddr, core->esparser_base + PARSER_VIDEO_START_PTR);
> +	writel_relaxed(sess->vififo_paddr + sess->vififo_size - 8, core->esparser_base + PARSER_VIDEO_END_PTR);
> +	writel_relaxed(readl_relaxed(core->esparser_base + PARSER_ES_CONTROL) & ~1, core->esparser_base + PARSER_ES_CONTROL);
> +	
> +	if (vdec_ops->conf_esparser)
> +		vdec_ops->conf_esparser(sess);
> +
> +	writel_relaxed(0xffff, core->esparser_base + PARSER_INT_STATUS);
> +	writel_relaxed(1 << PARSER_INT_HOST_EN_BIT, core->esparser_base + PARSER_INT_ENABLE);
> +
> +	return 0;
> +}
> +
> +int esparser_init(struct platform_device *pdev, struct vdec_core *core)
> +{
> +	struct device *dev = &pdev->dev;
> +	int ret;
> +	int irq;
> +
> +	/* TODO: name the IRQs */
> +	irq = platform_get_irq(pdev, 1);
> +	if (irq < 0) {
> +		dev_err(dev, "Failed getting ESPARSER IRQ from dtb\n");
> +		return irq;
> +	}
> +
> +	printk("Requesting IRQ %d\n", irq);
> +
> +	ret = devm_request_irq(dev, irq, esparser_isr,
> +					IRQF_SHARED,
> +					"esparserirq", core);
> +	if (ret) {
> +		dev_err(dev, "Failed requesting ESPARSER IRQ\n");
> +		return ret;
> +	}
> +
> +	core->esparser_reset = devm_reset_control_get_exclusive(dev,
> +                                                "esparser");
> +        if (IS_ERR(core->esparser_reset)) {
> +                dev_err(dev, "Failed to get esparser_reset\n");
> +                return PTR_ERR(core->esparser_reset);
> +        }
> +
> +	return 0;
> +}
> \ No newline at end of file
> diff --git a/drivers/media/platform/meson/vdec/esparser.h b/drivers/media/platform/meson/vdec/esparser.h
> new file mode 100644
> index 000000000000..f9c8b31e02b9
> --- /dev/null
> +++ b/drivers/media/platform/meson/vdec/esparser.h
> @@ -0,0 +1,16 @@
> +/* SPDX-License-Identifier: GPL-2.0+ */
> +/*
> + * Copyright (C) 2018 Maxime Jourdan <maxi.jourdan@wanadoo.fr>
> + */
> +
> +#ifndef __MESON_VDEC_ESPARSER_H_
> +#define __MESON_VDEC_ESPARSER_H_
> +
> +#include "vdec.h"
> +
> +int esparser_init(struct platform_device *pdev, struct vdec_core *core);
> +int esparser_power_up(struct vdec_session *sess);
> +int esparser_queue_eos(struct vdec_session *sess);
> +void esparser_queue_all_src(struct work_struct *work);
> +
> +#endif
> \ No newline at end of file
> diff --git a/drivers/media/platform/meson/vdec/hevc_regs.h b/drivers/media/platform/meson/vdec/hevc_regs.h
> new file mode 100644
> index 000000000000..ae9b38e463f7
> --- /dev/null
> +++ b/drivers/media/platform/meson/vdec/hevc_regs.h
> @@ -0,0 +1,742 @@
> +/* SPDX-License-Identifier: GPL-2.0+ */
> +/*
> + * Copyright (C) 2015 Amlogic, Inc. All rights reserved.
> + */
> +
> +#ifndef HEVC_REGS_HEADERS__
> +#define HEVC_REGS_HEADERS__
> +/*add from M8M2*/
> +#define HEVC_ASSIST_AFIFO_CTRL (0x3001 * 4)

Defining register this way is something amlogic does in their.
We they submitted the AXG clock controller we kindly asked them
to directly put what the offset is and drop the calculation.

Could please do the same ?

> +#define HEVC_ASSIST_AFIFO_CTRL1 (0x3002 * 4)
> +#define HEVC_ASSIST_GCLK_EN (0x3003 * 4)
> +#define HEVC_ASSIST_SW_RESET (0x3004 * 4)
> +#define HEVC_ASSIST_AMR1_INT0 (0x3025 * 4)
> +#define HEVC_ASSIST_AMR1_INT1 (0x3026 * 4)
> +#define HEVC_ASSIST_AMR1_INT2 (0x3027 * 4)
> +#define HEVC_ASSIST_AMR1_INT3 (0x3028 * 4)
> +#define HEVC_ASSIST_AMR1_INT4 (0x3029 * 4)
> +#define HEVC_ASSIST_AMR1_INT5 (0x302a * 4)
> +#define HEVC_ASSIST_AMR1_INT6 (0x302b * 4)
> +#define HEVC_ASSIST_AMR1_INT7 (0x302c * 4)
> +#define HEVC_ASSIST_AMR1_INT8 (0x302d * 4)
> +#define HEVC_ASSIST_AMR1_INT9 (0x302e * 4)
> +#define HEVC_ASSIST_AMR1_INTA (0x302f * 4)
> +#define HEVC_ASSIST_AMR1_INTB (0x3030 * 4)
> +#define HEVC_ASSIST_AMR1_INTC (0x3031 * 4)
> +#define HEVC_ASSIST_AMR1_INTD (0x3032 * 4)
> +#define HEVC_ASSIST_AMR1_INTE (0x3033 * 4)
> +#define HEVC_ASSIST_AMR1_INTF (0x3034 * 4)
> +#define HEVC_ASSIST_AMR2_INT0 (0x3035 * 4)
> +#define HEVC_ASSIST_AMR2_INT1 (0x3036 * 4)
> +#define HEVC_ASSIST_AMR2_INT2 (0x3037 * 4)
> +#define HEVC_ASSIST_AMR2_INT3 (0x3038 * 4)
> +#define HEVC_ASSIST_AMR2_INT4 (0x3039 * 4)
> +#define HEVC_ASSIST_AMR2_INT5 (0x303a * 4)
> +#define HEVC_ASSIST_AMR2_INT6 (0x303b * 4)
> +#define HEVC_ASSIST_AMR2_INT7 (0x303c * 4)
> +#define HEVC_ASSIST_AMR2_INT8 (0x303d * 4)
> +#define HEVC_ASSIST_AMR2_INT9 (0x303e * 4)
> +#define HEVC_ASSIST_AMR2_INTA (0x303f * 4)
> +#define HEVC_ASSIST_AMR2_INTB (0x3040 * 4)
> +#define HEVC_ASSIST_AMR2_INTC (0x3041 * 4)
> +#define HEVC_ASSIST_AMR2_INTD (0x3042 * 4)
> +#define HEVC_ASSIST_AMR2_INTE (0x3043 * 4)
> +#define HEVC_ASSIST_AMR2_INTF (0x3044 * 4)
> +#define HEVC_ASSIST_MBX_SSEL (0x3045 * 4)
> +#define HEVC_ASSIST_TIMER0_LO (0x3060 * 4)
> +#define HEVC_ASSIST_TIMER0_HI (0x3061 * 4)
> +#define HEVC_ASSIST_TIMER1_LO (0x3062 * 4)
> +#define HEVC_ASSIST_TIMER1_HI (0x3063 * 4)
> +#define HEVC_ASSIST_DMA_INT (0x3064 * 4)
> +#define HEVC_ASSIST_DMA_INT_MSK (0x3065 * 4)
> +#define HEVC_ASSIST_DMA_INT2 (0x3066 * 4)
> +#define HEVC_ASSIST_DMA_INT_MSK2 (0x3067 * 4)
> +#define HEVC_ASSIST_MBOX0_IRQ_REG (0x3070 * 4)
> +#define HEVC_ASSIST_MBOX0_CLR_REG (0x3071 * 4)
> +#define HEVC_ASSIST_MBOX0_MASK (0x3072 * 4)
> +#define HEVC_ASSIST_MBOX0_FIQ_SEL (0x3073 * 4)
> +#define HEVC_ASSIST_MBOX1_IRQ_REG (0x3074 * 4)
> +#define HEVC_ASSIST_MBOX1_CLR_REG (0x3075 * 4)
> +#define HEVC_ASSIST_MBOX1_MASK (0x3076 * 4)
> +#define HEVC_ASSIST_MBOX1_FIQ_SEL (0x3077 * 4)
> +#define HEVC_ASSIST_MBOX2_IRQ_REG (0x3078 * 4)
> +#define HEVC_ASSIST_MBOX2_CLR_REG (0x3079 * 4)
> +#define HEVC_ASSIST_MBOX2_MASK (0x307a * 4)
> +#define HEVC_ASSIST_MBOX2_FIQ_SEL (0x307b * 4)
> +#define HEVC_ASSIST_AXI_CTRL (0x307c * 4)
> +#define HEVC_ASSIST_AXI_STATUS (0x307d * 4)
> +#define HEVC_ASSIST_SCRATCH_0 (0x30c0 * 4)
> +#define HEVC_ASSIST_SCRATCH_1 (0x30c1 * 4)
> +#define HEVC_ASSIST_SCRATCH_2 (0x30c2 * 4)
> +#define HEVC_ASSIST_SCRATCH_3 (0x30c3 * 4)
> +#define HEVC_ASSIST_SCRATCH_4 (0x30c4 * 4)
> +#define HEVC_ASSIST_SCRATCH_5 (0x30c5 * 4)
> +#define HEVC_ASSIST_SCRATCH_6 (0x30c6 * 4)
> +#define HEVC_ASSIST_SCRATCH_7 (0x30c7 * 4)
> +#define HEVC_ASSIST_SCRATCH_8 (0x30c8 * 4)
> +#define HEVC_ASSIST_SCRATCH_9 (0x30c9 * 4)
> +#define HEVC_ASSIST_SCRATCH_A (0x30ca * 4)
> +#define HEVC_ASSIST_SCRATCH_B (0x30cb * 4)
> +#define HEVC_ASSIST_SCRATCH_C (0x30cc * 4)
> +#define HEVC_ASSIST_SCRATCH_D (0x30cd * 4)
> +#define HEVC_ASSIST_SCRATCH_E (0x30ce * 4)
> +#define HEVC_ASSIST_SCRATCH_F (0x30cf * 4)
> +#define HEVC_ASSIST_SCRATCH_G (0x30d0 * 4)
> +#define HEVC_ASSIST_SCRATCH_H (0x30d1 * 4)
> +#define HEVC_ASSIST_SCRATCH_I (0x30d2 * 4)
> +#define HEVC_ASSIST_SCRATCH_J (0x30d3 * 4)
> +#define HEVC_ASSIST_SCRATCH_K (0x30d4 * 4)
> +#define HEVC_ASSIST_SCRATCH_L (0x30d5 * 4)
> +#define HEVC_ASSIST_SCRATCH_M (0x30d6 * 4)
> +#define HEVC_ASSIST_SCRATCH_N (0x30d7 * 4)
> +#define HEVC_PARSER_VERSION (0x3100 * 4)
> +#define HEVC_STREAM_CONTROL (0x3101 * 4)
> +#define HEVC_STREAM_START_ADDR (0x3102 * 4)
> +#define HEVC_STREAM_END_ADDR (0x3103 * 4)
> +#define HEVC_STREAM_WR_PTR (0x3104 * 4)
> +#define HEVC_STREAM_RD_PTR (0x3105 * 4)
> +#define HEVC_STREAM_LEVEL (0x3106 * 4)
> +#define HEVC_STREAM_FIFO_CTL (0x3107 * 4)
> +#define HEVC_SHIFT_CONTROL (0x3108 * 4)
> +#define HEVC_SHIFT_STARTCODE (0x3109 * 4)
> +#define HEVC_SHIFT_EMULATECODE (0x310a * 4)
> +#define HEVC_SHIFT_STATUS (0x310b * 4)
> +#define HEVC_SHIFTED_DATA (0x310c * 4)
> +#define HEVC_SHIFT_BYTE_COUNT (0x310d * 4)
> +#define HEVC_SHIFT_COMMAND (0x310e * 4)
> +#define HEVC_ELEMENT_RESULT (0x310f * 4)
> +#define HEVC_CABAC_CONTROL (0x3110 * 4)
> +#define HEVC_PARSER_SLICE_INFO (0x3111 * 4)
> +#define HEVC_PARSER_CMD_WRITE (0x3112 * 4)
> +#define HEVC_PARSER_CORE_CONTROL (0x3113 * 4)
> +#define HEVC_PARSER_CMD_FETCH (0x3114 * 4)
> +#define HEVC_PARSER_CMD_STATUS (0x3115 * 4)
> +#define HEVC_PARSER_LCU_INFO (0x3116 * 4)
> +#define HEVC_PARSER_HEADER_INFO (0x3117 * 4)
> +#define HEVC_PARSER_RESULT_0 (0x3118 * 4)
> +#define HEVC_PARSER_RESULT_1 (0x3119 * 4)
> +#define HEVC_PARSER_RESULT_2 (0x311a * 4)
> +#define HEVC_PARSER_RESULT_3 (0x311b * 4)
> +#define HEVC_CABAC_TOP_INFO (0x311c * 4)
> +#define HEVC_CABAC_TOP_INFO_2 (0x311d * 4)
> +#define HEVC_CABAC_LEFT_INFO (0x311e * 4)
> +#define HEVC_CABAC_LEFT_INFO_2 (0x311f * 4)
> +#define HEVC_PARSER_INT_CONTROL (0x3120 * 4)
> +#define HEVC_PARSER_INT_STATUS (0x3121 * 4)
> +#define HEVC_PARSER_IF_CONTROL (0x3122 * 4)
> +#define HEVC_PARSER_PICTURE_SIZE (0x3123 * 4)
> +#define HEVC_PARSER_LCU_START (0x3124 * 4)
> +#define HEVC_PARSER_HEADER_INFO2 (0x3125 * 4)
> +#define HEVC_PARSER_QUANT_READ (0x3126 * 4)
> +#define HEVC_PARSER_RESERVED_27 (0x3127 * 4)
> +#define HEVC_PARSER_CMD_SKIP_0 (0x3128 * 4)
> +#define HEVC_PARSER_CMD_SKIP_1 (0x3129 * 4)
> +#define HEVC_PARSER_CMD_SKIP_2 (0x312a * 4)
> +#define HEVC_PARSER_MANUAL_CMD (0x312b * 4)
> +#define HEVC_PARSER_MEM_RD_ADDR (0x312c * 4)
> +#define HEVC_PARSER_MEM_WR_ADDR (0x312d * 4)
> +#define HEVC_PARSER_MEM_RW_DATA (0x312e * 4)
> +#define HEVC_SAO_IF_STATUS (0x3130 * 4)
> +#define HEVC_SAO_IF_DATA_Y (0x3131 * 4)
> +#define HEVC_SAO_IF_DATA_U (0x3132 * 4)
> +#define HEVC_SAO_IF_DATA_V (0x3133 * 4)
> +#define HEVC_STREAM_SWAP_ADDR (0x3134 * 4)
> +#define HEVC_STREAM_SWAP_CTRL (0x3135 * 4)
> +#define HEVC_IQIT_IF_WAIT_CNT (0x3136 * 4)
> +#define HEVC_MPRED_IF_WAIT_CNT (0x3137 * 4)
> +#define HEVC_SAO_IF_WAIT_CNT (0x3138 * 4)
> +#define HEVC_PARSER_DEBUG_IDX (0x313e * 4)
> +#define HEVC_PARSER_DEBUG_DAT (0x313f * 4)
> +#define HEVC_MPRED_VERSION (0x3200 * 4)
> +#define HEVC_MPRED_CTRL0 (0x3201 * 4)
> +#define HEVC_MPRED_CTRL1 (0x3202 * 4)
> +#define HEVC_MPRED_INT_EN (0x3203 * 4)
> +#define HEVC_MPRED_INT_STATUS (0x3204 * 4)
> +#define HEVC_MPRED_PIC_SIZE (0x3205 * 4)
> +#define HEVC_MPRED_PIC_SIZE_LCU (0x3206 * 4)
> +#define HEVC_MPRED_TILE_START (0x3207 * 4)
> +#define HEVC_MPRED_TILE_SIZE_LCU (0x3208 * 4)
> +#define HEVC_MPRED_REF_NUM (0x3209 * 4)
> +#define HEVC_MPRED_LT_REF (0x320a * 4)
> +#define HEVC_MPRED_LT_COLREF (0x320b * 4)
> +#define HEVC_MPRED_REF_EN_L0 (0x320c * 4)
> +#define HEVC_MPRED_REF_EN_L1 (0x320d * 4)
> +#define HEVC_MPRED_COLREF_EN_L0 (0x320e * 4)
> +#define HEVC_MPRED_COLREF_EN_L1 (0x320f * 4)
> +#define HEVC_MPRED_AXI_WCTRL (0x3210 * 4)
> +#define HEVC_MPRED_AXI_RCTRL (0x3211 * 4)
> +#define HEVC_MPRED_ABV_START_ADDR (0x3212 * 4)
> +#define HEVC_MPRED_MV_WR_START_ADDR (0x3213 * 4)
> +#define HEVC_MPRED_MV_RD_START_ADDR (0x3214 * 4)
> +#define HEVC_MPRED_MV_WPTR (0x3215 * 4)
> +#define HEVC_MPRED_MV_RPTR (0x3216 * 4)
> +#define HEVC_MPRED_MV_WR_ROW_JUMP (0x3217 * 4)
> +#define HEVC_MPRED_MV_RD_ROW_JUMP (0x3218 * 4)
> +#define HEVC_MPRED_CURR_LCU (0x3219 * 4)
> +#define HEVC_MPRED_ABV_WPTR (0x321a * 4)
> +#define HEVC_MPRED_ABV_RPTR (0x321b * 4)
> +#define HEVC_MPRED_CTRL2 (0x321c * 4)
> +#define HEVC_MPRED_CTRL3 (0x321d * 4)
> +#define HEVC_MPRED_MV_WLCUY (0x321e * 4)
> +#define HEVC_MPRED_MV_RLCUY (0x321f * 4)
> +#define HEVC_MPRED_L0_REF00_POC (0x3220 * 4)
> +#define HEVC_MPRED_L0_REF01_POC (0x3221 * 4)
> +#define HEVC_MPRED_L0_REF02_POC (0x3222 * 4)
> +#define HEVC_MPRED_L0_REF03_POC (0x3223 * 4)
> +#define HEVC_MPRED_L0_REF04_POC (0x3224 * 4)
> +#define HEVC_MPRED_L0_REF05_POC (0x3225 * 4)
> +#define HEVC_MPRED_L0_REF06_POC (0x3226 * 4)
> +#define HEVC_MPRED_L0_REF07_POC (0x3227 * 4)
> +#define HEVC_MPRED_L0_REF08_POC (0x3228 * 4)
> +#define HEVC_MPRED_L0_REF09_POC (0x3229 * 4)
> +#define HEVC_MPRED_L0_REF10_POC (0x322a * 4)
> +#define HEVC_MPRED_L0_REF11_POC (0x322b * 4)
> +#define HEVC_MPRED_L0_REF12_POC (0x322c * 4)
> +#define HEVC_MPRED_L0_REF13_POC (0x322d * 4)
> +#define HEVC_MPRED_L0_REF14_POC (0x322e * 4)
> +#define HEVC_MPRED_L0_REF15_POC (0x322f * 4)
> +#define HEVC_MPRED_L1_REF00_POC (0x3230 * 4)
> +#define HEVC_MPRED_L1_REF01_POC (0x3231 * 4)
> +#define HEVC_MPRED_L1_REF02_POC (0x3232 * 4)
> +#define HEVC_MPRED_L1_REF03_POC (0x3233 * 4)
> +#define HEVC_MPRED_L1_REF04_POC (0x3234 * 4)
> +#define HEVC_MPRED_L1_REF05_POC (0x3235 * 4)
> +#define HEVC_MPRED_L1_REF06_POC (0x3236 * 4)
> +#define HEVC_MPRED_L1_REF07_POC (0x3237 * 4)
> +#define HEVC_MPRED_L1_REF08_POC (0x3238 * 4)
> +#define HEVC_MPRED_L1_REF09_POC (0x3239 * 4)
> +#define HEVC_MPRED_L1_REF10_POC (0x323a * 4)
> +#define HEVC_MPRED_L1_REF11_POC (0x323b * 4)
> +#define HEVC_MPRED_L1_REF12_POC (0x323c * 4)
> +#define HEVC_MPRED_L1_REF13_POC (0x323d * 4)
> +#define HEVC_MPRED_L1_REF14_POC (0x323e * 4)
> +#define HEVC_MPRED_L1_REF15_POC (0x323f * 4)
> +#define HEVC_MPRED_PIC_SIZE_EXT (0x3240 * 4)
> +#define HEVC_MPRED_DBG_MODE0 (0x3241 * 4)
> +#define HEVC_MPRED_DBG_MODE1 (0x3242 * 4)
> +#define HEVC_MPRED_DBG2_MODE (0x3243 * 4)
> +#define HEVC_MPRED_IMP_CMD0 (0x3244 * 4)
> +#define HEVC_MPRED_IMP_CMD1 (0x3245 * 4)
> +#define HEVC_MPRED_IMP_CMD2 (0x3246 * 4)
> +#define HEVC_MPRED_IMP_CMD3 (0x3247 * 4)
> +#define HEVC_MPRED_DBG2_DATA_0 (0x3248 * 4)
> +#define HEVC_MPRED_DBG2_DATA_1 (0x3249 * 4)
> +#define HEVC_MPRED_DBG2_DATA_2 (0x324a * 4)
> +#define HEVC_MPRED_DBG2_DATA_3 (0x324b * 4)
> +#define HEVC_MPRED_DBG_DATA_0 (0x3250 * 4)
> +#define HEVC_MPRED_DBG_DATA_1 (0x3251 * 4)
> +#define HEVC_MPRED_DBG_DATA_2 (0x3252 * 4)
> +#define HEVC_MPRED_DBG_DATA_3 (0x3253 * 4)
> +#define HEVC_MPRED_DBG_DATA_4 (0x3254 * 4)
> +#define HEVC_MPRED_DBG_DATA_5 (0x3255 * 4)
> +#define HEVC_MPRED_DBG_DATA_6 (0x3256 * 4)
> +#define HEVC_MPRED_DBG_DATA_7 (0x3257 * 4)
> +#define HEVC_MPRED_CUR_POC (0x3260 * 4)
> +#define HEVC_MPRED_COL_POC (0x3261 * 4)
> +#define HEVC_MPRED_MV_RD_END_ADDR (0x3262 * 4)
> +#define HEVCD_IPP_TOP_CNTL (0x3400 * 4)
> +#define HEVCD_IPP_TOP_STATUS (0x3401 * 4)
> +#define HEVCD_IPP_TOP_FRMCONFIG (0x3402 * 4)
> +#define HEVCD_IPP_TOP_TILECONFIG1 (0x3403 * 4)
> +#define HEVCD_IPP_TOP_TILECONFIG2 (0x3404 * 4)
> +#define HEVCD_IPP_TOP_TILECONFIG3 (0x3405 * 4)
> +#define HEVCD_IPP_TOP_LCUCONFIG (0x3406 * 4)
> +#define HEVCD_IPP_TOP_FRMCTL (0x3407 * 4)
> +#define HEVCD_IPP_CONFIG (0x3408 * 4)
> +#define HEVCD_IPP_LINEBUFF_BASE (0x3409 * 4)
> +#define HEVCD_IPP_INTR_MASK (0x340a * 4)
> +#define HEVCD_IPP_AXIIF_CONFIG (0x340b * 4)
> +#define HEVCD_IPP_BITDEPTH_CONFIG (0x340c * 4)
> +#define HEVCD_IPP_SWMPREDIF_CONFIG (0x3410 * 4)
> +#define HEVCD_IPP_SWMPREDIF_STATUS (0x3411 * 4)
> +#define HEVCD_IPP_SWMPREDIF_CTBINFO (0x3412 * 4)
> +#define HEVCD_IPP_SWMPREDIF_PUINFO0 (0x3413 * 4)
> +#define HEVCD_IPP_SWMPREDIF_PUINFO1 (0x3414 * 4)
> +#define HEVCD_IPP_SWMPREDIF_PUINFO2 (0x3415 * 4)
> +#define HEVCD_IPP_SWMPREDIF_PUINFO3 (0x3416 * 4)
> +#define HEVCD_IPP_DYNCLKGATE_CONFIG (0x3420 * 4)
> +#define HEVCD_IPP_DYNCLKGATE_STATUS (0x3421 * 4)
> +#define HEVCD_IPP_DBG_SEL (0x3430 * 4)
> +#define HEVCD_IPP_DBG_DATA (0x3431 * 4)
> +#define HEVCD_MPP_ANC2AXI_TBL_CONF_ADDR (0x3460 * 4)
> +#define HEVCD_MPP_ANC2AXI_TBL_CMD_ADDR (0x3461 * 4)
> +#define HEVCD_MPP_ANC2AXI_TBL_WDATA_ADDR (0x3462 * 4)
> +#define HEVCD_MPP_ANC2AXI_TBL_RDATA_ADDR (0x3463 * 4)
> +#define HEVCD_MPP_WEIGHTPRED_CNTL_ADDR (0x347b * 4)
> +#define HEVCD_MPP_L0_WEIGHT_FLAG_ADDR (0x347c * 4)
> +#define HEVCD_MPP_L1_WEIGHT_FLAG_ADDR (0x347d * 4)
> +#define HEVCD_MPP_YLOG2WGHTDENOM_ADDR (0x347e * 4)
> +#define HEVCD_MPP_DELTACLOG2WGHTDENOM_ADDR (0x347f * 4)
> +#define HEVCD_MPP_WEIGHT_ADDR (0x3480 * 4)
> +#define HEVCD_MPP_WEIGHT_DATA (0x3481 * 4)
> +#define HEVCD_MPP_ANC_CANVAS_ACCCONFIG_ADDR (0x34c0 * 4)
> +#define HEVCD_MPP_ANC_CANVAS_DATA_ADDR (0x34c1 * 4)
> +#define HEVCD_MPP_DECOMP_CTL1 (0x34c2 * 4)
> +#define HEVCD_MPP_DECOMP_CTL2 (0x34c3 * 4)
> +#define HEVCD_MCRCC_CTL1 (0x34f0 * 4)
> +#define HEVCD_MCRCC_CTL2 (0x34f1 * 4)
> +#define HEVCD_MCRCC_CTL3 (0x34f2 * 4)
> +#define HEVCD_MCRCC_PERFMON_CTL (0x34f3 * 4)
> +#define HEVCD_MCRCC_PERFMON_DATA (0x34f4 * 4)
> +#define HEVC_DBLK_CFG0 (0x3500 * 4)
> +#define HEVC_DBLK_CFG1 (0x3501 * 4)
> +#define HEVC_DBLK_CFG2 (0x3502 * 4)
> +#define HEVC_DBLK_CFG3 (0x3503 * 4)
> +#define HEVC_DBLK_CFG4 (0x3504 * 4)
> +#define HEVC_DBLK_CFG5 (0x3505 * 4)
> +#define HEVC_DBLK_CFG6 (0x3506 * 4)
> +#define HEVC_DBLK_CFG7 (0x3507 * 4)
> +#define HEVC_DBLK_CFG8 (0x3508 * 4)
> +#define HEVC_DBLK_CFG9 (0x3509 * 4)
> +#define HEVC_DBLK_CFGA (0x350a * 4)
> +#define HEVC_DBLK_STS0 (0x350b * 4)
> +#define HEVC_DBLK_STS1 (0x350c * 4)
> +#define HEVC_SAO_VERSION (0x3600 * 4)
> +#define HEVC_SAO_CTRL0 (0x3601 * 4)
> +#define HEVC_SAO_CTRL1 (0x3602 * 4)
> +#define HEVC_SAO_INT_EN (0x3603 * 4)
> +#define HEVC_SAO_INT_STATUS (0x3604 * 4)
> +#define HEVC_SAO_PIC_SIZE (0x3605 * 4)
> +#define HEVC_SAO_PIC_SIZE_LCU (0x3606 * 4)
> +#define HEVC_SAO_TILE_START (0x3607 * 4)
> +#define HEVC_SAO_TILE_SIZE_LCU (0x3608 * 4)
> +#define HEVC_SAO_AXI_WCTRL (0x3609 * 4)
> +#define HEVC_SAO_AXI_RCTRL (0x360a * 4)
> +#define HEVC_SAO_Y_START_ADDR (0x360b * 4)
> +#define HEVC_SAO_Y_LENGTH (0x360c * 4)
> +#define HEVC_SAO_C_START_ADDR (0x360d * 4)
> +#define HEVC_SAO_C_LENGTH (0x360e * 4)
> +#define HEVC_SAO_Y_WPTR (0x360f * 4)
> +#define HEVC_SAO_C_WPTR (0x3610 * 4)
> +#define HEVC_SAO_ABV_START_ADDR (0x3611 * 4)
> +#define HEVC_SAO_VB_WR_START_ADDR (0x3612 * 4)
> +#define HEVC_SAO_VB_RD_START_ADDR (0x3613 * 4)
> +#define HEVC_SAO_ABV_WPTR (0x3614 * 4)
> +#define HEVC_SAO_ABV_RPTR (0x3615 * 4)
> +#define HEVC_SAO_VB_WPTR (0x3616 * 4)
> +#define HEVC_SAO_VB_RPTR (0x3617 * 4)
> +#define HEVC_SAO_DBG_MODE0 (0x361e * 4)
> +#define HEVC_SAO_DBG_MODE1 (0x361f * 4)
> +#define HEVC_SAO_CTRL2 (0x3620 * 4)
> +#define HEVC_SAO_CTRL3 (0x3621 * 4)
> +#define HEVC_SAO_CTRL4 (0x3622 * 4)
> +#define HEVC_SAO_CTRL5 (0x3623 * 4)
> +#define HEVC_SAO_CTRL6 (0x3624 * 4)
> +#define HEVC_SAO_CTRL7 (0x3625 * 4)
> +#define HEVC_SAO_DBG_DATA_0 (0x3630 * 4)
> +#define HEVC_SAO_DBG_DATA_1 (0x3631 * 4)
> +#define HEVC_SAO_DBG_DATA_2 (0x3632 * 4)
> +#define HEVC_SAO_DBG_DATA_3 (0x3633 * 4)
> +#define HEVC_SAO_DBG_DATA_4 (0x3634 * 4)
> +#define HEVC_SAO_DBG_DATA_5 (0x3635 * 4)
> +#define HEVC_SAO_DBG_DATA_6 (0x3636 * 4)
> +#define HEVC_SAO_DBG_DATA_7 (0x3637 * 4)
> +#define HEVC_IQIT_CLK_RST_CTRL (0x3700 * 4)
> +#define HEVC_IQIT_DEQUANT_CTRL (0x3701 * 4)
> +#define HEVC_IQIT_SCALELUT_WR_ADDR (0x3702 * 4)
> +#define HEVC_IQIT_SCALELUT_RD_ADDR (0x3703 * 4)
> +#define HEVC_IQIT_SCALELUT_DATA (0x3704 * 4)
> +#define HEVC_IQIT_SCALELUT_IDX_4 (0x3705 * 4)
> +#define HEVC_IQIT_SCALELUT_IDX_8 (0x3706 * 4)
> +#define HEVC_IQIT_SCALELUT_IDX_16_32 (0x3707 * 4)
> +#define HEVC_IQIT_STAT_GEN0 (0x3708 * 4)
> +#define HEVC_QP_WRITE (0x3709 * 4)
> +#define HEVC_IQIT_STAT_GEN1 (0x370a * 4)
> +/**/
> +
> +/*add from M8M2*/
> +#define HEVC_MC_CTRL_REG (0x3900 * 4)
> +#define HEVC_MC_MB_INFO (0x3901 * 4)
> +#define HEVC_MC_PIC_INFO (0x3902 * 4)
> +#define HEVC_MC_HALF_PEL_ONE (0x3903 * 4)
> +#define HEVC_MC_HALF_PEL_TWO (0x3904 * 4)
> +#define HEVC_POWER_CTL_MC (0x3905 * 4)
> +#define HEVC_MC_CMD (0x3906 * 4)
> +#define HEVC_MC_CTRL0 (0x3907 * 4)
> +#define HEVC_MC_PIC_W_H (0x3908 * 4)
> +#define HEVC_MC_STATUS0 (0x3909 * 4)
> +#define HEVC_MC_STATUS1 (0x390a * 4)
> +#define HEVC_MC_CTRL1 (0x390b * 4)
> +#define HEVC_MC_MIX_RATIO0 (0x390c * 4)
> +#define HEVC_MC_MIX_RATIO1 (0x390d * 4)
> +#define HEVC_MC_DP_MB_XY (0x390e * 4)
> +#define HEVC_MC_OM_MB_XY (0x390f * 4)
> +#define HEVC_PSCALE_RST (0x3910 * 4)
> +#define HEVC_PSCALE_CTRL (0x3911 * 4)
> +#define HEVC_PSCALE_PICI_W (0x3912 * 4)
> +#define HEVC_PSCALE_PICI_H (0x3913 * 4)
> +#define HEVC_PSCALE_PICO_W (0x3914 * 4)
> +#define HEVC_PSCALE_PICO_H (0x3915 * 4)
> +#define HEVC_PSCALE_PICO_START_X (0x3916 * 4)
> +#define HEVC_PSCALE_PICO_START_Y (0x3917 * 4)
> +#define HEVC_PSCALE_DUMMY (0x3918 * 4)
> +#define HEVC_PSCALE_FILT0_COEF0 (0x3919 * 4)
> +#define HEVC_PSCALE_FILT0_COEF1 (0x391a * 4)
> +#define HEVC_PSCALE_CMD_CTRL (0x391b * 4)
> +#define HEVC_PSCALE_CMD_BLK_X (0x391c * 4)
> +#define HEVC_PSCALE_CMD_BLK_Y (0x391d * 4)
> +#define HEVC_PSCALE_STATUS (0x391e * 4)
> +#define HEVC_PSCALE_BMEM_ADDR (0x391f * 4)
> +#define HEVC_PSCALE_BMEM_DAT (0x3920 * 4)
> +#define HEVC_PSCALE_DRAM_BUF_CTRL (0x3921 * 4)
> +#define HEVC_PSCALE_MCMD_CTRL (0x3922 * 4)
> +#define HEVC_PSCALE_MCMD_XSIZE (0x3923 * 4)
> +#define HEVC_PSCALE_MCMD_YSIZE (0x3924 * 4)
> +#define HEVC_PSCALE_RBUF_START_BLKX (0x3925 * 4)
> +#define HEVC_PSCALE_RBUF_START_BLKY (0x3926 * 4)
> +#define HEVC_PSCALE_PICO_SHIFT_XY (0x3928 * 4)
> +#define HEVC_PSCALE_CTRL1 (0x3929 * 4)
> +#define HEVC_PSCALE_SRCKEY_CTRL0 (0x392a * 4)
> +#define HEVC_PSCALE_SRCKEY_CTRL1 (0x392b * 4)
> +#define HEVC_PSCALE_CANVAS_RD_ADDR (0x392c * 4)
> +#define HEVC_PSCALE_CANVAS_WR_ADDR (0x392d * 4)
> +#define HEVC_PSCALE_CTRL2 (0x392e * 4)
> +#define HEVC_HDEC_MC_OMEM_AUTO (0x3930 * 4)
> +#define HEVC_HDEC_MC_MBRIGHT_IDX (0x3931 * 4)
> +#define HEVC_HDEC_MC_MBRIGHT_RD (0x3932 * 4)
> +#define HEVC_MC_MPORT_CTRL (0x3940 * 4)
> +#define HEVC_MC_MPORT_DAT (0x3941 * 4)
> +#define HEVC_MC_WT_PRED_CTRL (0x3942 * 4)
> +#define HEVC_MC_MBBOT_ST_EVEN_ADDR (0x3944 * 4)
> +#define HEVC_MC_MBBOT_ST_ODD_ADDR (0x3945 * 4)
> +#define HEVC_MC_DPDN_MB_XY (0x3946 * 4)
> +#define HEVC_MC_OMDN_MB_XY (0x3947 * 4)
> +#define HEVC_MC_HCMDBUF_H (0x3948 * 4)
> +#define HEVC_MC_HCMDBUF_L (0x3949 * 4)
> +#define HEVC_MC_HCMD_H (0x394a * 4)
> +#define HEVC_MC_HCMD_L (0x394b * 4)
> +#define HEVC_MC_IDCT_DAT (0x394c * 4)
> +#define HEVC_MC_CTRL_GCLK_CTRL (0x394d * 4)
> +#define HEVC_MC_OTHER_GCLK_CTRL (0x394e * 4)
> +#define HEVC_MC_CTRL2 (0x394f * 4)
> +#define HEVC_MDEC_PIC_DC_CTRL (0x398e * 4)
> +#define HEVC_MDEC_PIC_DC_STATUS (0x398f * 4)
> +#define HEVC_ANC0_CANVAS_ADDR (0x3990 * 4)
> +#define HEVC_ANC1_CANVAS_ADDR (0x3991 * 4)
> +#define HEVC_ANC2_CANVAS_ADDR (0x3992 * 4)
> +#define HEVC_ANC3_CANVAS_ADDR (0x3993 * 4)
> +#define HEVC_ANC4_CANVAS_ADDR (0x3994 * 4)
> +#define HEVC_ANC5_CANVAS_ADDR (0x3995 * 4)
> +#define HEVC_ANC6_CANVAS_ADDR (0x3996 * 4)
> +#define HEVC_ANC7_CANVAS_ADDR (0x3997 * 4)
> +#define HEVC_ANC8_CANVAS_ADDR (0x3998 * 4)
> +#define HEVC_ANC9_CANVAS_ADDR (0x3999 * 4)
> +#define HEVC_ANC10_CANVAS_ADDR (0x399a * 4)
> +#define HEVC_ANC11_CANVAS_ADDR (0x399b * 4)
> +#define HEVC_ANC12_CANVAS_ADDR (0x399c * 4)
> +#define HEVC_ANC13_CANVAS_ADDR (0x399d * 4)
> +#define HEVC_ANC14_CANVAS_ADDR (0x399e * 4)
> +#define HEVC_ANC15_CANVAS_ADDR (0x399f * 4)
> +#define HEVC_ANC16_CANVAS_ADDR (0x39a0 * 4)
> +#define HEVC_ANC17_CANVAS_ADDR (0x39a1 * 4)
> +#define HEVC_ANC18_CANVAS_ADDR (0x39a2 * 4)
> +#define HEVC_ANC19_CANVAS_ADDR (0x39a3 * 4)
> +#define HEVC_ANC20_CANVAS_ADDR (0x39a4 * 4)
> +#define HEVC_ANC21_CANVAS_ADDR (0x39a5 * 4)
> +#define HEVC_ANC22_CANVAS_ADDR (0x39a6 * 4)
> +#define HEVC_ANC23_CANVAS_ADDR (0x39a7 * 4)
> +#define HEVC_ANC24_CANVAS_ADDR (0x39a8 * 4)
> +#define HEVC_ANC25_CANVAS_ADDR (0x39a9 * 4)
> +#define HEVC_ANC26_CANVAS_ADDR (0x39aa * 4)
> +#define HEVC_ANC27_CANVAS_ADDR (0x39ab * 4)
> +#define HEVC_ANC28_CANVAS_ADDR (0x39ac * 4)
> +#define HEVC_ANC29_CANVAS_ADDR (0x39ad * 4)
> +#define HEVC_ANC30_CANVAS_ADDR (0x39ae * 4)
> +#define HEVC_ANC31_CANVAS_ADDR (0x39af * 4)
> +#define HEVC_DBKR_CANVAS_ADDR (0x39b0 * 4)
> +#define HEVC_DBKW_CANVAS_ADDR (0x39b1 * 4)
> +#define HEVC_REC_CANVAS_ADDR (0x39b2 * 4)
> +#define HEVC_CURR_CANVAS_CTRL (0x39b3 * 4)
> +#define HEVC_MDEC_PIC_DC_THRESH (0x39b8 * 4)
> +#define HEVC_MDEC_PICR_BUF_STATUS (0x39b9 * 4)
> +#define HEVC_MDEC_PICW_BUF_STATUS (0x39ba * 4)
> +#define HEVC_MCW_DBLK_WRRSP_CNT (0x39bb * 4)
> +#define HEVC_MC_MBBOT_WRRSP_CNT (0x39bc * 4)
> +#define HEVC_MDEC_PICW_BUF2_STATUS (0x39bd * 4)
> +#define HEVC_WRRSP_FIFO_PICW_DBK (0x39be * 4)
> +#define HEVC_WRRSP_FIFO_PICW_MC (0x39bf * 4)
> +#define HEVC_AV_SCRATCH_0 (0x39c0 * 4)
> +#define HEVC_AV_SCRATCH_1 (0x39c1 * 4)
> +#define HEVC_AV_SCRATCH_2 (0x39c2 * 4)
> +#define HEVC_AV_SCRATCH_3 (0x39c3 * 4)
> +#define HEVC_AV_SCRATCH_4 (0x39c4 * 4)
> +#define HEVC_AV_SCRATCH_5 (0x39c5 * 4)
> +#define HEVC_AV_SCRATCH_6 (0x39c6 * 4)
> +#define HEVC_AV_SCRATCH_7 (0x39c7 * 4)
> +#define HEVC_AV_SCRATCH_8 (0x39c8 * 4)
> +#define HEVC_AV_SCRATCH_9 (0x39c9 * 4)
> +#define HEVC_AV_SCRATCH_A (0x39ca * 4)
> +#define HEVC_AV_SCRATCH_B (0x39cb * 4)
> +#define HEVC_AV_SCRATCH_C (0x39cc * 4)
> +#define HEVC_AV_SCRATCH_D (0x39cd * 4)
> +#define HEVC_AV_SCRATCH_E (0x39ce * 4)
> +#define HEVC_AV_SCRATCH_F (0x39cf * 4)
> +#define HEVC_AV_SCRATCH_G (0x39d0 * 4)
> +#define HEVC_AV_SCRATCH_H (0x39d1 * 4)
> +#define HEVC_AV_SCRATCH_I (0x39d2 * 4)
> +#define HEVC_AV_SCRATCH_J (0x39d3 * 4)
> +#define HEVC_AV_SCRATCH_K (0x39d4 * 4)
> +#define HEVC_AV_SCRATCH_L (0x39d5 * 4)
> +#define HEVC_AV_SCRATCH_M (0x39d6 * 4)
> +#define HEVC_AV_SCRATCH_N (0x39d7 * 4)
> +#define HEVC_WRRSP_CO_MB (0x39d8 * 4)
> +#define HEVC_WRRSP_DCAC (0x39d9 * 4)
> +#define HEVC_WRRSP_VLD (0x39da * 4)
> +#define HEVC_MDEC_DOUBLEW_CFG0 (0x39db * 4)
> +#define HEVC_MDEC_DOUBLEW_CFG1 (0x39dc * 4)
> +#define HEVC_MDEC_DOUBLEW_CFG2 (0x39dd * 4)
> +#define HEVC_MDEC_DOUBLEW_CFG3 (0x39de * 4)
> +#define HEVC_MDEC_DOUBLEW_CFG4 (0x39df * 4)
> +#define HEVC_MDEC_DOUBLEW_CFG5 (0x39e0 * 4)
> +#define HEVC_MDEC_DOUBLEW_CFG6 (0x39e1 * 4)
> +#define HEVC_MDEC_DOUBLEW_CFG7 (0x39e2 * 4)
> +#define HEVC_MDEC_DOUBLEW_STATUS (0x39e3 * 4)
> +#define HEVC_DBLK_RST (0x3950 * 4)
> +#define HEVC_DBLK_CTRL (0x3951 * 4)
> +#define HEVC_DBLK_MB_WID_HEIGHT (0x3952 * 4)
> +#define HEVC_DBLK_STATUS (0x3953 * 4)
> +#define HEVC_DBLK_CMD_CTRL (0x3954 * 4)
> +#define HEVC_DBLK_MB_XY (0x3955 * 4)
> +#define HEVC_DBLK_QP (0x3956 * 4)
> +#define HEVC_DBLK_Y_BHFILT (0x3957 * 4)
> +#define HEVC_DBLK_Y_BHFILT_HIGH (0x3958 * 4)
> +#define HEVC_DBLK_Y_BVFILT (0x3959 * 4)
> +#define HEVC_DBLK_CB_BFILT (0x395a * 4)
> +#define HEVC_DBLK_CR_BFILT (0x395b * 4)
> +#define HEVC_DBLK_Y_HFILT (0x395c * 4)
> +#define HEVC_DBLK_Y_HFILT_HIGH (0x395d * 4)
> +#define HEVC_DBLK_Y_VFILT (0x395e * 4)
> +#define HEVC_DBLK_CB_FILT (0x395f * 4)
> +#define HEVC_DBLK_CR_FILT (0x3960 * 4)
> +#define HEVC_DBLK_BETAX_QP_SEL (0x3961 * 4)
> +#define HEVC_DBLK_CLIP_CTRL0 (0x3962 * 4)
> +#define HEVC_DBLK_CLIP_CTRL1 (0x3963 * 4)
> +#define HEVC_DBLK_CLIP_CTRL2 (0x3964 * 4)
> +#define HEVC_DBLK_CLIP_CTRL3 (0x3965 * 4)
> +#define HEVC_DBLK_CLIP_CTRL4 (0x3966 * 4)
> +#define HEVC_DBLK_CLIP_CTRL5 (0x3967 * 4)
> +#define HEVC_DBLK_CLIP_CTRL6 (0x3968 * 4)
> +#define HEVC_DBLK_CLIP_CTRL7 (0x3969 * 4)
> +#define HEVC_DBLK_CLIP_CTRL8 (0x396a * 4)
> +#define HEVC_DBLK_STATUS1 (0x396b * 4)
> +#define HEVC_DBLK_GCLK_FREE (0x396c * 4)
> +#define HEVC_DBLK_GCLK_OFF (0x396d * 4)
> +#define HEVC_DBLK_AVSFLAGS (0x396e * 4)
> +#define HEVC_DBLK_CBPY (0x3970 * 4)
> +#define HEVC_DBLK_CBPY_ADJ (0x3971 * 4)
> +#define HEVC_DBLK_CBPC (0x3972 * 4)
> +#define HEVC_DBLK_CBPC_ADJ (0x3973 * 4)
> +#define HEVC_DBLK_VHMVD (0x3974 * 4)
> +#define HEVC_DBLK_STRONG (0x3975 * 4)
> +#define HEVC_DBLK_RV8_QUANT (0x3976 * 4)
> +#define HEVC_DBLK_CBUS_HCMD2 (0x3977 * 4)
> +#define HEVC_DBLK_CBUS_HCMD1 (0x3978 * 4)
> +#define HEVC_DBLK_CBUS_HCMD0 (0x3979 * 4)
> +#define HEVC_DBLK_VLD_HCMD2 (0x397a * 4)
> +#define HEVC_DBLK_VLD_HCMD1 (0x397b * 4)
> +#define HEVC_DBLK_VLD_HCMD0 (0x397c * 4)
> +#define HEVC_DBLK_OST_YBASE (0x397d * 4)
> +#define HEVC_DBLK_OST_CBCRDIFF (0x397e * 4)
> +#define HEVC_DBLK_CTRL1 (0x397f * 4)
> +#define HEVC_MCRCC_CTL1 (0x3980 * 4)
> +#define HEVC_MCRCC_CTL2 (0x3981 * 4)
> +#define HEVC_MCRCC_CTL3 (0x3982 * 4)
> +#define HEVC_GCLK_EN (0x3983 * 4)
> +#define HEVC_MDEC_SW_RESET (0x3984 * 4)
> +
> +/*add from M8M2*/
> +#define HEVC_VLD_STATUS_CTRL (0x3c00 * 4)
> +#define HEVC_MPEG1_2_REG (0x3c01 * 4)
> +#define HEVC_F_CODE_REG (0x3c02 * 4)
> +#define HEVC_PIC_HEAD_INFO (0x3c03 * 4)
> +#define HEVC_SLICE_VER_POS_PIC_TYPE (0x3c04 * 4)
> +#define HEVC_QP_VALUE_REG (0x3c05 * 4)
> +#define HEVC_MBA_INC (0x3c06 * 4)
> +#define HEVC_MB_MOTION_MODE (0x3c07 * 4)
> +#define HEVC_POWER_CTL_VLD (0x3c08 * 4)
> +#define HEVC_MB_WIDTH (0x3c09 * 4)
> +#define HEVC_SLICE_QP (0x3c0a * 4)
> +#define HEVC_PRE_START_CODE (0x3c0b * 4)
> +#define HEVC_SLICE_START_BYTE_01 (0x3c0c * 4)
> +#define HEVC_SLICE_START_BYTE_23 (0x3c0d * 4)
> +#define HEVC_RESYNC_MARKER_LENGTH (0x3c0e * 4)
> +#define HEVC_DECODER_BUFFER_INFO (0x3c0f * 4)
> +#define HEVC_FST_FOR_MV_X (0x3c10 * 4)
> +#define HEVC_FST_FOR_MV_Y (0x3c11 * 4)
> +#define HEVC_SCD_FOR_MV_X (0x3c12 * 4)
> +#define HEVC_SCD_FOR_MV_Y (0x3c13 * 4)
> +#define HEVC_FST_BAK_MV_X (0x3c14 * 4)
> +#define HEVC_FST_BAK_MV_Y (0x3c15 * 4)
> +#define HEVC_SCD_BAK_MV_X (0x3c16 * 4)
> +#define HEVC_SCD_BAK_MV_Y (0x3c17 * 4)
> +#define HEVC_VLD_DECODE_CONTROL (0x3c18 * 4)
> +#define HEVC_VLD_REVERVED_19 (0x3c19 * 4)
> +#define HEVC_VIFF_BIT_CNT (0x3c1a * 4)
> +#define HEVC_BYTE_ALIGN_PEAK_HI (0x3c1b * 4)
> +#define HEVC_BYTE_ALIGN_PEAK_LO (0x3c1c * 4)
> +#define HEVC_NEXT_ALIGN_PEAK (0x3c1d * 4)
> +#define HEVC_VC1_CONTROL_REG (0x3c1e * 4)
> +#define HEVC_PMV1_X (0x3c20 * 4)
> +#define HEVC_PMV1_Y (0x3c21 * 4)
> +#define HEVC_PMV2_X (0x3c22 * 4)
> +#define HEVC_PMV2_Y (0x3c23 * 4)
> +#define HEVC_PMV3_X (0x3c24 * 4)
> +#define HEVC_PMV3_Y (0x3c25 * 4)
> +#define HEVC_PMV4_X (0x3c26 * 4)
> +#define HEVC_PMV4_Y (0x3c27 * 4)
> +#define HEVC_M4_TABLE_SELECT (0x3c28 * 4)
> +#define HEVC_M4_CONTROL_REG (0x3c29 * 4)
> +#define HEVC_BLOCK_NUM (0x3c2a * 4)
> +#define HEVC_PATTERN_CODE (0x3c2b * 4)
> +#define HEVC_MB_INFO (0x3c2c * 4)
> +#define HEVC_VLD_DC_PRED (0x3c2d * 4)
> +#define HEVC_VLD_ERROR_MASK (0x3c2e * 4)
> +#define HEVC_VLD_DC_PRED_C (0x3c2f * 4)
> +#define HEVC_LAST_SLICE_MV_ADDR (0x3c30 * 4)
> +#define HEVC_LAST_MVX (0x3c31 * 4)
> +#define HEVC_LAST_MVY (0x3c32 * 4)
> +#define HEVC_VLD_C38 (0x3c38 * 4)
> +#define HEVC_VLD_C39 (0x3c39 * 4)
> +#define HEVC_VLD_STATUS (0x3c3a * 4)
> +#define HEVC_VLD_SHIFT_STATUS (0x3c3b * 4)
> +#define HEVC_VOFF_STATUS (0x3c3c * 4)
> +#define HEVC_VLD_C3D (0x3c3d * 4)
> +#define HEVC_VLD_DBG_INDEX (0x3c3e * 4)
> +#define HEVC_VLD_DBG_DATA (0x3c3f * 4)
> +#define HEVC_VLD_MEM_VIFIFO_START_PTR (0x3c40 * 4)
> +#define HEVC_VLD_MEM_VIFIFO_CURR_PTR (0x3c41 * 4)
> +#define HEVC_VLD_MEM_VIFIFO_END_PTR (0x3c42 * 4)
> +#define HEVC_VLD_MEM_VIFIFO_BYTES_AVAIL (0x3c43 * 4)
> +#define HEVC_VLD_MEM_VIFIFO_CONTROL (0x3c44 * 4)
> +#define HEVC_VLD_MEM_VIFIFO_WP (0x3c45 * 4)
> +#define HEVC_VLD_MEM_VIFIFO_RP (0x3c46 * 4)
> +#define HEVC_VLD_MEM_VIFIFO_LEVEL (0x3c47 * 4)
> +#define HEVC_VLD_MEM_VIFIFO_BUF_CNTL (0x3c48 * 4)
> +#define HEVC_VLD_TIME_STAMP_CNTL (0x3c49 * 4)
> +#define HEVC_VLD_TIME_STAMP_SYNC_0 (0x3c4a * 4)
> +#define HEVC_VLD_TIME_STAMP_SYNC_1 (0x3c4b * 4)
> +#define HEVC_VLD_TIME_STAMP_0 (0x3c4c * 4)
> +#define HEVC_VLD_TIME_STAMP_1 (0x3c4d * 4)
> +#define HEVC_VLD_TIME_STAMP_2 (0x3c4e * 4)
> +#define HEVC_VLD_TIME_STAMP_3 (0x3c4f * 4)
> +#define HEVC_VLD_TIME_STAMP_LENGTH (0x3c50 * 4)
> +#define HEVC_VLD_MEM_VIFIFO_WRAP_COUNT (0x3c51 * 4)
> +#define HEVC_VLD_MEM_VIFIFO_MEM_CTL (0x3c52 * 4)
> +#define HEVC_VLD_MEM_VBUF_RD_PTR (0x3c53 * 4)
> +#define HEVC_VLD_MEM_VBUF2_RD_PTR (0x3c54 * 4)
> +#define HEVC_VLD_MEM_SWAP_ADDR (0x3c55 * 4)
> +#define HEVC_VLD_MEM_SWAP_CTL (0x3c56 * 4)
> +/**/
> +
> +/*add from M8M2*/
> +#define HEVC_VCOP_CTRL_REG (0x3e00 * 4)
> +#define HEVC_QP_CTRL_REG (0x3e01 * 4)
> +#define HEVC_INTRA_QUANT_MATRIX (0x3e02 * 4)
> +#define HEVC_NON_I_QUANT_MATRIX (0x3e03 * 4)
> +#define HEVC_DC_SCALER (0x3e04 * 4)
> +#define HEVC_DC_AC_CTRL (0x3e05 * 4)
> +#define HEVC_DC_AC_SCALE_MUL (0x3e06 * 4)
> +#define HEVC_DC_AC_SCALE_DIV (0x3e07 * 4)
> +#define HEVC_POWER_CTL_IQIDCT (0x3e08 * 4)
> +#define HEVC_RV_AI_Y_X (0x3e09 * 4)
> +#define HEVC_RV_AI_U_X (0x3e0a * 4)
> +#define HEVC_RV_AI_V_X (0x3e0b * 4)
> +#define HEVC_RV_AI_MB_COUNT (0x3e0c * 4)
> +#define HEVC_NEXT_INTRA_DMA_ADDRESS (0x3e0d * 4)
> +#define HEVC_IQIDCT_CONTROL (0x3e0e * 4)
> +#define HEVC_IQIDCT_DEBUG_INFO_0 (0x3e0f * 4)
> +#define HEVC_DEBLK_CMD (0x3e10 * 4)
> +#define HEVC_IQIDCT_DEBUG_IDCT (0x3e11 * 4)
> +#define HEVC_DCAC_DMA_CTRL (0x3e12 * 4)
> +#define HEVC_DCAC_DMA_ADDRESS (0x3e13 * 4)
> +#define HEVC_DCAC_CPU_ADDRESS (0x3e14 * 4)
> +#define HEVC_DCAC_CPU_DATA (0x3e15 * 4)
> +#define HEVC_DCAC_MB_COUNT (0x3e16 * 4)
> +#define HEVC_IQ_QUANT (0x3e17 * 4)
> +#define HEVC_VC1_BITPLANE_CTL (0x3e18 * 4)
> +
> +
> +/*add from M8M2*/
> +#define HEVC_MSP (0x3300 * 4)
> +#define HEVC_MPSR (0x3301 * 4)
> +#define HEVC_MINT_VEC_BASE (0x3302 * 4)
> +#define HEVC_MCPU_INTR_GRP (0x3303 * 4)
> +#define HEVC_MCPU_INTR_MSK (0x3304 * 4)
> +#define HEVC_MCPU_INTR_REQ (0x3305 * 4)
> +#define HEVC_MPC_P (0x3306 * 4)
> +#define HEVC_MPC_D (0x3307 * 4)
> +#define HEVC_MPC_E (0x3308 * 4)
> +#define HEVC_MPC_W (0x3309 * 4)
> +#define HEVC_MINDEX0_REG (0x330a * 4)
> +#define HEVC_MINDEX1_REG (0x330b * 4)
> +#define HEVC_MINDEX2_REG (0x330c * 4)
> +#define HEVC_MINDEX3_REG (0x330d * 4)
> +#define HEVC_MINDEX4_REG (0x330e * 4)
> +#define HEVC_MINDEX5_REG (0x330f * 4)
> +#define HEVC_MINDEX6_REG (0x3310 * 4)
> +#define HEVC_MINDEX7_REG (0x3311 * 4)
> +#define HEVC_MMIN_REG (0x3312 * 4)
> +#define HEVC_MMAX_REG (0x3313 * 4)
> +#define HEVC_MBREAK0_REG (0x3314 * 4)
> +#define HEVC_MBREAK1_REG (0x3315 * 4)
> +#define HEVC_MBREAK2_REG (0x3316 * 4)
> +#define HEVC_MBREAK3_REG (0x3317 * 4)
> +#define HEVC_MBREAK_TYPE (0x3318 * 4)
> +#define HEVC_MBREAK_CTRL (0x3319 * 4)
> +#define HEVC_MBREAK_STAUTS (0x331a * 4)
> +#define HEVC_MDB_ADDR_REG (0x331b * 4)
> +#define HEVC_MDB_DATA_REG (0x331c * 4)
> +#define HEVC_MDB_CTRL (0x331d * 4)
> +#define HEVC_MSFTINT0 (0x331e * 4)
> +#define HEVC_MSFTINT1 (0x331f * 4)
> +#define HEVC_CSP (0x3320 * 4)
> +#define HEVC_CPSR (0x3321 * 4)
> +#define HEVC_CINT_VEC_BASE (0x3322 * 4)
> +#define HEVC_CCPU_INTR_GRP (0x3323 * 4)
> +#define HEVC_CCPU_INTR_MSK (0x3324 * 4)
> +#define HEVC_CCPU_INTR_REQ (0x3325 * 4)
> +#define HEVC_CPC_P (0x3326 * 4)
> +#define HEVC_CPC_D (0x3327 * 4)
> +#define HEVC_CPC_E (0x3328 * 4)
> +#define HEVC_CPC_W (0x3329 * 4)
> +#define HEVC_CINDEX0_REG (0x332a * 4)
> +#define HEVC_CINDEX1_REG (0x332b * 4)
> +#define HEVC_CINDEX2_REG (0x332c * 4)
> +#define HEVC_CINDEX3_REG (0x332d * 4)
> +#define HEVC_CINDEX4_REG (0x332e * 4)
> +#define HEVC_CINDEX5_REG (0x332f * 4)
> +#define HEVC_CINDEX6_REG (0x3330 * 4)
> +#define HEVC_CINDEX7_REG (0x3331 * 4)
> +#define HEVC_CMIN_REG (0x3332 * 4)
> +#define HEVC_CMAX_REG (0x3333 * 4)
> +#define HEVC_CBREAK0_REG (0x3334 * 4)
> +#define HEVC_CBREAK1_REG (0x3335 * 4)
> +#define HEVC_CBREAK2_REG (0x3336 * 4)
> +#define HEVC_CBREAK3_REG (0x3337 * 4)
> +#define HEVC_CBREAK_TYPE (0x3338 * 4)
> +#define HEVC_CBREAK_CTRL (0x3339 * 4)
> +#define HEVC_CBREAK_STAUTS (0x333a * 4)
> +#define HEVC_CDB_ADDR_REG (0x333b * 4)
> +#define HEVC_CDB_DATA_REG (0x333c * 4)
> +#define HEVC_CDB_CTRL (0x333d * 4)
> +#define HEVC_CSFTINT0 (0x333e * 4)
> +#define HEVC_CSFTINT1 (0x333f * 4)
> +#define HEVC_IMEM_DMA_CTRL (0x3340 * 4)
> +#define HEVC_IMEM_DMA_ADR (0x3341 * 4)
> +#define HEVC_IMEM_DMA_COUNT (0x3342 * 4)
> +#define HEVC_WRRSP_IMEM (0x3343 * 4)
> +#define HEVC_LMEM_DMA_CTRL (0x3350 * 4)
> +#define HEVC_LMEM_DMA_ADR (0x3351 * 4)
> +#define HEVC_LMEM_DMA_COUNT (0x3352 * 4)
> +#define HEVC_WRRSP_LMEM (0x3353 * 4)
> +#define HEVC_MAC_CTRL1 (0x3360 * 4)
> +#define HEVC_ACC0REG1 (0x3361 * 4)
> +#define HEVC_ACC1REG1 (0x3362 * 4)
> +#define HEVC_MAC_CTRL2 (0x3370 * 4)
> +#define HEVC_ACC0REG2 (0x3371 * 4)
> +#define HEVC_ACC1REG2 (0x3372 * 4)
> +#define HEVC_CPU_TRACE (0x3380 * 4)
> +/**/
> +
> +#endif
> +
> diff --git a/drivers/media/platform/meson/vdec/vdec.c b/drivers/media/platform/meson/vdec/vdec.c
> new file mode 100644
> index 000000000000..b8b1edf38aae
> --- /dev/null
> +++ b/drivers/media/platform/meson/vdec/vdec.c
> @@ -0,0 +1,1009 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/*
> + * Copyright (C) 2018 Maxime Jourdan <maxi.jourdan@wanadoo.fr>
> + */
> +
> +#define DEBUG
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
> +#include "canvas.h"
> +
> +#include "vdec_1.h"
> +
> +/* 16 MiB for parsed bitstream swap exchange */
> +#define SIZE_VIFIFO (16 * SZ_1M)
> +
> +void vdec_abort(struct vdec_session *sess)
> +{
> +	printk("Aborting decoding session!\n");
> +	vb2_queue_error(&sess->m2m_ctx->cap_q_ctx.q);
> +	vb2_queue_error(&sess->m2m_ctx->out_q_ctx.q);
> +}
> +
> +static u32 get_output_size(u32 width, u32 height)
> +{
> +	return ALIGN(width * height, 64 * SZ_1K);
> +}
> +
> +u32 vdec_get_output_size(struct vdec_session *sess)
> +{
> +	return get_output_size(sess->width, sess->height);
> +}
> +
> +static int vdec_poweron(struct vdec_session *sess)
> +{
> +	int ret;
> +	struct vdec_ops *vdec_ops = sess->fmt_out->vdec_ops;
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
> +static void vdec_poweroff(struct vdec_session *sess) {
> +	struct vdec_ops *vdec_ops = sess->fmt_out->vdec_ops;
> +
> +	vdec_ops->stop(sess);
> +	clk_disable_unprepare(sess->core->dos_clk);
> +	clk_disable_unprepare(sess->core->dos_parser_clk);
> +}
> +
> +void vdec_queue_recycle(struct vdec_session *sess, struct vb2_buffer *vb)
> +{
> +	struct vdec_buffer *new_buf;
> +
> +	new_buf = kmalloc(sizeof(struct vdec_buffer), GFP_KERNEL);
> +	new_buf->index = vb->index;
> +
> +	mutex_lock(&sess->bufs_recycle_lock);
> +	list_add_tail(&new_buf->list, &sess->bufs_recycle);
> +	mutex_unlock(&sess->bufs_recycle_lock);
> +}
> +
> +void vdec_m2m_device_run(void *priv)
> +{
> +	struct vdec_session *sess = priv;
> +	schedule_work(&sess->esparser_queue_work);
> +}
> +
> +void vdec_m2m_job_abort(void *priv)
> +{
> +	struct vdec_session *sess = priv;
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
> +	struct vdec_session *sess = vb2_get_drv_priv(q);
> +	const struct vdec_format *fmt_out = sess->fmt_out;
> +	const struct vdec_format *fmt_cap = sess->fmt_cap;
> +	
> +	switch (q->type) {
> +	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
> +		sizes[0] = vdec_get_output_size(sess);
> +		sess->num_input_bufs = *num_buffers;
> +		*num_planes = fmt_out->num_planes;
> +		break;
> +	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
> +		sizes[0] = vdec_get_output_size(sess);
> +		sizes[1] = vdec_get_output_size(sess) / 2;
> +		*num_planes = fmt_cap->num_planes;
> +		*num_buffers = min(max(*num_buffers, fmt_out->min_buffers), fmt_out->max_buffers);
> +		sess->num_output_bufs = *num_buffers;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +	return 0;
> +}
> +
> +static void vdec_vb2_buf_queue(struct vb2_buffer *vb)
> +{
> +	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
> +	struct vdec_session *sess = vb2_get_drv_priv(vb->vb2_queue);
> +	struct v4l2_m2m_ctx *m2m_ctx = sess->m2m_ctx;
> +	struct vdec_codec_ops *codec_ops = sess->fmt_out->codec_ops;
> +
> +	mutex_lock(&sess->lock);
> +	v4l2_m2m_buf_queue(m2m_ctx, vbuf);
> +
> +	if (!(sess->streamon_out & sess->streamon_cap))
> +		goto unlock;
> +	
> +	if (vb->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
> +		schedule_work(&sess->esparser_queue_work);
> +	} else if (codec_ops->notify_dst_buffer)
> +		codec_ops->notify_dst_buffer(sess, vb);
> +
> +unlock:
> +	mutex_unlock(&sess->lock);
> +}
> +
> +static int vdec_start_streaming(struct vb2_queue *q, unsigned int count)
> +{
> +	struct vdec_session *sess = vb2_get_drv_priv(q);
> +	struct vb2_v4l2_buffer *buf;
> +	int ret;
> +
> +	mutex_lock(&sess->lock);
> +	
> +	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
> +		sess->streamon_out = 1;
> +	else
> +		sess->streamon_cap = 1;
> +
> +	if (!(sess->streamon_out & sess->streamon_cap)) {
> +		mutex_unlock(&sess->lock);
> +		return 0;
> +	}
> +
> +	sess->vififo_size = SIZE_VIFIFO;
> +	sess->vififo_vaddr = dma_alloc_coherent(sess->core->dev, sess->vififo_size, &sess->vififo_paddr, GFP_KERNEL);
> +	if (!sess->vififo_vaddr) {
> +		printk("Failed to request VIFIFO buffer\n");
> +		ret = -ENOMEM;
> +		goto bufs_done;
> +	}
> +
> +	sess->should_stop = 0;
> +	ret = vdec_poweron(sess);
> +	if (ret)
> +		goto vififo_free;
> +
> +	sess->sequence_cap = 0;
> +	mutex_unlock(&sess->lock);
> +
> +	return 0;
> +
> +vififo_free:
> +	dma_free_coherent(sess->core->dev, sess->vififo_size, sess->vififo_vaddr, sess->vififo_paddr);
> +bufs_done:
> +	while ((buf = v4l2_m2m_src_buf_remove(sess->m2m_ctx)))
> +		v4l2_m2m_buf_done(buf, VB2_BUF_STATE_QUEUED);
> +	while ((buf = v4l2_m2m_dst_buf_remove(sess->m2m_ctx)))
> +		v4l2_m2m_buf_done(buf, VB2_BUF_STATE_QUEUED);
> +	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
> +		sess->streamon_out = 0;
> +	else
> +		sess->streamon_cap = 0;
> +	mutex_unlock(&sess->lock);
> +	return ret;
> +}
> +
> +void vdec_stop_streaming(struct vb2_queue *q)
> +{
> +	struct vdec_session *sess = vb2_get_drv_priv(q);
> +	struct vb2_v4l2_buffer *buf;
> +
> +	mutex_lock(&sess->lock);
> +
> +	if (sess->streamon_out & sess->streamon_cap) {
> +		vdec_poweroff(sess);
> +		dma_free_coherent(sess->core->dev, sess->vififo_size, sess->vififo_vaddr, sess->vififo_paddr);
> +		INIT_LIST_HEAD(&sess->bufs);
> +		INIT_LIST_HEAD(&sess->bufs_recycle);
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
> +
> +	mutex_unlock(&sess->lock);
> +}
> +
> +static const struct vb2_ops vdec_vb2_ops = {
> +	.queue_setup = vdec_queue_setup,
> +	.start_streaming = vdec_start_streaming,
> +	.stop_streaming = vdec_stop_streaming,
> +	.buf_queue = vdec_vb2_buf_queue,
> +};
> +
> +static int
> +vdec_querycap(struct file *file, void *fh, struct v4l2_capability *cap)
> +{
> +	strlcpy(cap->driver, "meson-vdec", sizeof(cap->driver));
> +	strlcpy(cap->card, "AMLogic Video Decoder", sizeof(cap->card));
> +	strlcpy(cap->bus_info, "platform:meson-vdec", sizeof(cap->bus_info));
> +
> +	return 0;
> +}
> +
> +static const struct vdec_format *
> +find_format(const struct vdec_format *fmts, u32 size, u32 pixfmt, u32 type)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < size; i++) {
> +		if (fmts[i].pixfmt == pixfmt)
> +			break;
> +	}
> +
> +	if (i == size || fmts[i].type != type)
> +		return NULL;
> +
> +	return &fmts[i];
> +}
> +
> +static const struct vdec_format *
> +find_format_by_index(const struct vdec_format *fmts, u32 size, u32 index, u32 type)
> +{
> +	unsigned int i, k = 0;
> +
> +	if (index > size)
> +		return NULL;
> +
> +	for (i = 0; i < size; i++) {
> +		if (fmts[i].type != type)
> +			continue;
> +		if (k == index)
> +			break;
> +		k++;
> +	}
> +
> +	if (i == size)
> +		return NULL;
> +
> +	return &fmts[i];
> +}
> +
> +static const struct vdec_format *
> +vdec_try_fmt_common(const struct vdec_format *fmts, u32 size, struct v4l2_format *f)
> +{
> +	struct v4l2_pix_format_mplane *pixmp = &f->fmt.pix_mp;
> +	struct v4l2_plane_pix_format *pfmt = pixmp->plane_fmt;
> +	const struct vdec_format *fmt;
> +
> +	memset(pfmt[0].reserved, 0, sizeof(pfmt[0].reserved));
> +	memset(pixmp->reserved, 0, sizeof(pixmp->reserved));
> +
> +	fmt = find_format(fmts, size, pixmp->pixelformat, f->type);
> +	if (!fmt) {
> +		if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
> +			pixmp->pixelformat = V4L2_PIX_FMT_NV12M;
> +		else if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
> +			pixmp->pixelformat = V4L2_PIX_FMT_H264;
> +		else
> +			return NULL;
> +
> +		fmt = find_format(fmts, size, pixmp->pixelformat, f->type);
> +		pixmp->width = 1280;
> +		pixmp->height = 720;
> +	}
> +
> +	pixmp->width  = clamp(pixmp->width,  (u32)256, (u32)3840);
> +	pixmp->height = clamp(pixmp->height, (u32)144, (u32)2160);
> +
> +	if (pixmp->field == V4L2_FIELD_ANY)
> +		pixmp->field = V4L2_FIELD_NONE;
> +
> +	pixmp->num_planes = fmt->num_planes;
> +	pixmp->flags = 0;
> +
> +	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
> +		memset(pfmt[1].reserved, 0, sizeof(pfmt[1].reserved));
> +		pfmt[0].sizeimage = get_output_size(pixmp->width, pixmp->height);
> +		pfmt[0].bytesperline = ALIGN(pixmp->width, 64);
> +
> +		pfmt[1].sizeimage = get_output_size(pixmp->width, pixmp->height) / 2;
> +		pfmt[1].bytesperline = ALIGN(pixmp->width, 64);
> +	} else {
> +		pfmt[0].sizeimage = get_output_size(pixmp->width, pixmp->height);
> +		pfmt[0].bytesperline = 0;
> +	}
> +
> +
> +	return fmt;
> +}
> +
> +static int vdec_try_fmt(struct file *file, void *fh, struct v4l2_format *f)
> +{
> +	struct vdec_session *sess = container_of(file->private_data, struct vdec_session, fh);
> +
> +	vdec_try_fmt_common(sess->core->platform->formats,
> +		sess->core->platform->num_formats, f);
> +
> +	return 0;
> +}
> +
> +static int vdec_g_fmt(struct file *file, void *fh, struct v4l2_format *f)
> +{
> +	struct vdec_session *sess = container_of(file->private_data, struct vdec_session, fh);
> +	const struct vdec_format *fmt = NULL;
> +	struct v4l2_pix_format_mplane *pixmp = &f->fmt.pix_mp;
> +
> +	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
> +		fmt = sess->fmt_cap;
> +	else if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
> +		fmt = sess->fmt_out;
> +
> +	pixmp->pixelformat = fmt->pixfmt;
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
> +	vdec_try_fmt_common(sess->core->platform->formats, sess->core->platform->num_formats, f);
> +
> +	return 0;
> +}
> +
> +static int vdec_s_fmt(struct file *file, void *fh, struct v4l2_format *f)
> +{
> +	struct vdec_session *sess = container_of(file->private_data, struct vdec_session, fh);
> +	struct v4l2_pix_format_mplane *pixmp = &f->fmt.pix_mp;
> +	const struct vdec_format *formats = sess->core->platform->formats;
> +	u32 num_formats = sess->core->platform->num_formats;
> +	const struct vdec_format *fmt;
> +	struct v4l2_pix_format_mplane orig_pixmp;
> +	struct v4l2_format format;
> +	u32 pixfmt_out = 0, pixfmt_cap = 0;
> +
> +	orig_pixmp = *pixmp;
> +
> +	fmt = vdec_try_fmt_common(formats, num_formats, f);
> +
> +	if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
> +		pixfmt_out = pixmp->pixelformat;
> +		pixfmt_cap = sess->fmt_cap->pixfmt;
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
> +	vdec_try_fmt_common(formats, num_formats, &format);
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
> +	vdec_try_fmt_common(formats, num_formats, &format);
> +
> +	sess->width = format.fmt.pix_mp.width;
> +	sess->height = format.fmt.pix_mp.height;
> +
> +	if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
> +		sess->fmt_out = fmt;
> +	else if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
> +		sess->fmt_cap = fmt;
> +
> +	return 0;
> +}
> +
> +static int vdec_enum_fmt(struct file *file, void *fh, struct v4l2_fmtdesc *f)
> +{
> +	struct vdec_session *sess =
> +		container_of(file->private_data, struct vdec_session, fh);
> +	const struct vdec_platform *platform = sess->core->platform;
> +	const struct vdec_format *fmt;
> +
> +	memset(f->reserved, 0, sizeof(f->reserved));
> +
> +	fmt = find_format_by_index(platform->formats, platform->num_formats,
> +				   f->index, f->type);
> +	if (!fmt)
> +		return -EINVAL;
> +
> +	f->pixelformat = fmt->pixfmt;
> +
> +	return 0;
> +}
> +
> +static int vdec_enum_framesizes(struct file *file, void *fh,
> +				struct v4l2_frmsizeenum *fsize)
> +{
> +	struct vdec_session *sess =
> +		container_of(file->private_data, struct vdec_session, fh);
> +	const struct vdec_format *formats = sess->core->platform->formats;
> +	u32 num_formats = sess->core->platform->num_formats;
> +	const struct vdec_format *fmt;
> +
> +	fmt = find_format(formats, num_formats, fsize->pixel_format,
> +			  V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE);
> +	if (!fmt) {
> +		fmt = find_format(formats, num_formats, fsize->pixel_format,
> +				  V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE);
> +		if (!fmt)
> +			return -EINVAL;
> +	}
> +
> +	if (fsize->index)
> +		return -EINVAL;
> +
> +	fsize->type = V4L2_FRMSIZE_TYPE_STEPWISE;
> +
> +	/* TODO: Store these constants in vdec_format */
> +	fsize->stepwise.min_width = 256;
> +	fsize->stepwise.max_width = 3840;
> +	fsize->stepwise.step_width = 1;
> +	fsize->stepwise.min_height = 144;
> +	fsize->stepwise.max_height = 2160;
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
> +	struct vdec_session *sess =
> +		container_of(file->private_data, struct vdec_session, fh);
> +	int ret;
> +
> +	ret = vdec_try_decoder_cmd(file, fh, cmd);
> +	if (ret)
> +		return ret;
> +
> +	mutex_lock(&sess->lock);
> +
> +	if (!(sess->streamon_out & sess->streamon_cap))
> +		goto unlock;
> +
> +	esparser_queue_eos(sess);
> +
> +unlock:
> +	mutex_unlock(&sess->lock);
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
> +};
> +
> +static int m2m_queue_init(void *priv, struct vb2_queue *src_vq,
> +			  struct vb2_queue *dst_vq)
> +{
> +	struct vdec_session *sess = priv;
> +	int ret;
> +
> +	src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
> +	src_vq->io_modes = VB2_MMAP | VB2_DMABUF;
> +	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
> +	src_vq->ops = &vdec_vb2_ops;
> +	src_vq->mem_ops = &vb2_dma_contig_memops;
> +	src_vq->drv_priv = sess;
> +	src_vq->buf_struct_size = sizeof(struct dummy_buf);
> +	src_vq->allow_zero_bytesused = 1;
> +	src_vq->min_buffers_needed = 1;
> +	src_vq->dev = sess->core->dev;
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
> +	dst_vq->allow_zero_bytesused = 1;
> +	dst_vq->min_buffers_needed = 1;
> +	dst_vq->dev = sess->core->dev;
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
> +	struct vdec_core *core = video_drvdata(file);
> +	struct device *dev = core->dev;
> +	const struct vdec_format *formats = core->platform->formats;
> +	struct vdec_session *sess;
> +	int ret;
> +
> +	mutex_lock(&core->lock);
> +	if (core->cur_sess) {
> +		mutex_unlock(&core->lock);
> +		return -EBUSY;
> +	}
> +
> +	sess = kzalloc(sizeof(*sess), GFP_KERNEL);
> +	if (!sess) {
> +		mutex_unlock(&core->lock);
> +		return -ENOMEM;
> +	}
> +
> +	core->cur_sess = sess;
> +	mutex_unlock(&core->lock);
> +
> +	sess->core = core;
> +	sess->fmt_cap = &formats[0];
> +	sess->fmt_out = &formats[1];
> +	sess->width = 1280;
> +	sess->height = 720;
> +	INIT_LIST_HEAD(&sess->bufs);
> +	INIT_LIST_HEAD(&sess->bufs_recycle);
> +	INIT_WORK(&sess->esparser_queue_work, esparser_queue_all_src);
> +	spin_lock_init(&sess->bufs_spinlock);
> +	mutex_init(&sess->lock);
> +	mutex_init(&sess->codec_lock);
> +	mutex_init(&sess->bufs_recycle_lock);
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
> +	struct vdec_session *sess =
> +		container_of(file->private_data, struct vdec_session, fh);
> +	struct vdec_core *core = sess->core;
> +
> +	v4l2_m2m_ctx_release(sess->m2m_ctx);
> +	v4l2_m2m_release(sess->m2m_dev);
> +	v4l2_fh_del(&sess->fh);
> +	v4l2_fh_exit(&sess->fh);
> +	mutex_destroy(&sess->lock);
> +
> +	kfree(sess);
> +	core->cur_sess = NULL;
> +
> +	return 0;
> +}
> +
> +void vdec_dst_buf_done(struct vdec_session *sess, struct vb2_v4l2_buffer *vbuf)
> +{
> +	unsigned long flags;
> +	struct vdec_buffer *tmp;
> +	struct device *dev = sess->core->dev_dec;
> +
> +	spin_lock_irqsave(&sess->bufs_spinlock, flags);
> +	if (list_empty(&sess->bufs)) {
> +		dev_err(dev, "Buffer %u done but list is empty\n",
> +			vbuf->vb2_buf.index);
> +
> +		v4l2_m2m_buf_done(vbuf, VB2_BUF_STATE_ERROR);
> +		vdec_abort(sess);
> +		goto unlock;
> +	}
> +
> +	tmp = list_first_entry(&sess->bufs, struct vdec_buffer, list);
> +
> +	vbuf->vb2_buf.planes[0].bytesused = vdec_get_output_size(sess);
> +	vbuf->vb2_buf.planes[1].bytesused = vdec_get_output_size(sess) / 2;
> +	vbuf->vb2_buf.timestamp = tmp->timestamp;
> +	vbuf->sequence = sess->sequence_cap++;
> +
> +	list_del(&tmp->list);
> +	kfree(tmp);
> +
> +	if (sess->should_stop && list_empty(&sess->bufs)) {
> +		const struct v4l2_event ev = { .type = V4L2_EVENT_EOS };
> +		v4l2_event_queue_fh(&sess->fh, &ev);
> +		vbuf->flags |= V4L2_BUF_FLAG_LAST;
> +	}
> +
> +	v4l2_m2m_buf_done(vbuf, VB2_BUF_STATE_DONE);
> +
> +unlock:
> +	spin_unlock_irqrestore(&sess->bufs_spinlock, flags);
> +
> +	atomic_dec(&sess->esparser_queued_bufs);
> +	/* Buffer done probably means the vififo got freed */
> +	schedule_work(&sess->esparser_queue_work);
> +}
> +
> +static void vdec_rm_first_ts(struct vdec_session *sess)
> +{
> +	unsigned long flags;
> +	struct vdec_buffer *tmp;
> +	struct device *dev = sess->core->dev_dec;
> +
> +	spin_lock_irqsave(&sess->bufs_spinlock, flags);
> +	if (list_empty(&sess->bufs)) {
> +		dev_err(dev, "Can't rm first timestamp: list empty\n");
> +		goto unlock;
> +	}
> +
> +	tmp = list_first_entry(&sess->bufs, struct vdec_buffer, list);
> +	list_del(&tmp->list);
> +	kfree(tmp);
> +
> +unlock:
> +	spin_unlock_irqrestore(&sess->bufs_spinlock, flags);
> +}
> +
> +void vdec_dst_buf_done_idx(struct vdec_session *sess, u32 buf_idx)
> +{
> +	struct vb2_v4l2_buffer *vbuf;
> +	struct device *dev = sess->core->dev_dec;
> +
> +	vbuf = v4l2_m2m_dst_buf_remove_by_idx(sess->m2m_ctx, buf_idx);
> +	if (!vbuf) {
> +		dev_err(dev, "Buffer %u done but it doesn't exist in m2m_ctx\n",
> +			buf_idx);
> +		atomic_dec(&sess->esparser_queued_bufs);
> +		vdec_rm_first_ts(sess);
> +		return;
> +	}
> +
> +	vdec_dst_buf_done(sess, vbuf);
> +}
> +
> +/* Userspace will often queue timestamps that are not
> + * in chronological order. Rearrange them here.
> + */
> +void vdec_add_ts_reorder(struct vdec_session *sess, u64 ts)
> +{
> +	struct vdec_buffer *new_buf, *tmp;
> +	unsigned long flags;
> +
> +	new_buf = kmalloc(sizeof(*new_buf), GFP_KERNEL);
> +	new_buf->timestamp = ts;
> +	new_buf->index = -1;
> +
> +	spin_lock_irqsave(&sess->bufs_spinlock, flags);
> +	if (list_empty(&sess->bufs))
> +		goto add_core;
> +
> +	list_for_each_entry(tmp, &sess->bufs, list) {
> +		if (ts < tmp->timestamp) {
> +			list_add_tail(&new_buf->list, &tmp->list);
> +			goto unlock;
> +		}
> +	}
> +
> +add_core:
> +	list_add_tail(&new_buf->list, &sess->bufs);
> +unlock:
> +	spin_unlock_irqrestore(&sess->bufs_spinlock, flags);
> +}
> +
> +void vdec_remove_ts(struct vdec_session *sess, u64 ts)
> +{
> +	struct vdec_buffer *tmp;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&sess->bufs_spinlock, flags);
> +	list_for_each_entry(tmp, &sess->bufs, list) {
> +		if (tmp->timestamp == ts) {
> +			list_del(&tmp->list);
> +			kfree(tmp);
> +			goto unlock;
> +		}
> +	}
> +	dev_warn(sess->core->dev_dec,
> +		"Couldn't remove buffer with timestamp %llu from list\n", ts);
> +
> +unlock:
> +	spin_unlock_irqrestore(&sess->bufs_spinlock, flags);
> +}
> +
> +static const struct v4l2_file_operations vdec_fops = {
> +	.owner = THIS_MODULE,
> +	.open = vdec_open,
> +	.release = vdec_close,
> +	.unlocked_ioctl = video_ioctl2,
> +	.poll = v4l2_m2m_fop_poll,
> +	.mmap = v4l2_m2m_fop_mmap,
> +#ifdef CONFIG_COMPAT
> +	.compat_ioctl32 = v4l2_compat_ioctl32,
> +#endif
> +};
> +
> +static irqreturn_t vdec_isr(int irq, void *data)
> +{
> +	struct vdec_core *core = data;
> +	struct vdec_session *sess = core->cur_sess;
> +
> +	return sess->fmt_out->codec_ops->isr(sess);
> +}
> +
> +static irqreturn_t vdec_threaded_isr(int irq, void *data)
> +{
> +	struct vdec_core *core = data;
> +	struct vdec_session *sess = core->cur_sess;
> +
> +	return sess->fmt_out->codec_ops->threaded_isr(sess);
> +}
> +
> +static const struct of_device_id vdec_dt_match[] = {
> +	{ .compatible = "amlogic,meson-gxbb-vdec",
> +	  .data = &vdec_platform_gxbb },
> +	{ .compatible = "amlogic,meson-gxm-vdec",
> +	  .data = &vdec_platform_gxm },
> +	{ .compatible = "amlogic,meson-gxl-vdec",
> +	  .data = &vdec_platform_gxl },
> +	{}
> +};
> +MODULE_DEVICE_TABLE(of, vdec_dt_match);
> +
> +static int vdec_probe(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct video_device *vdev;
> +	struct vdec_core *core;
> +	struct resource *r;
> +	const struct of_device_id *of_id;
> +	int irq;
> +	int ret;
> +
> +	core = devm_kzalloc(dev, sizeof(*core), GFP_KERNEL);
> +	if (!core) {
> +		dev_err(dev, "No memory for devm_kzalloc\n");
> +		return -ENOMEM;
> +	}
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
> +	r = platform_get_resource_byname(pdev, IORESOURCE_MEM, "dmc");
> +	core->dmc_base = devm_ioremap(dev, r->start, resource_size(r));
> +	if (IS_ERR(core->dmc_base)) {
> +		dev_err(dev, "Couldn't remap DMC memory\n");
> +		return PTR_ERR(core->dmc_base);
> +	}
> +
> +	core->regmap_ao = syscon_regmap_lookup_by_phandle(dev->of_node,
> +						"amlogic,ao-sysctrl");
> +	if (IS_ERR(core->regmap_ao)) {
> +		dev_err(dev, "Couldn't regmap AO sysctrl\n");
> +		return PTR_ERR(core->regmap_ao);
> +	}
> +
> +	core->dos_parser_clk = devm_clk_get(dev, "dos_parser");
> +	if (IS_ERR(core->dos_parser_clk)) {

You should handle EPROBE_DEFER and not print an error in such case.
It is fairly common for the device probe to be deferred because of a clock
provider.

> +		dev_err(dev, "dos_parser clock request failed\n");
> +		return PTR_ERR(core->dos_parser_clk);
> +	}
> +
> +	core->dos_clk = devm_clk_get(dev, "dos");
> +	if (IS_ERR(core->dos_clk)) {
> +		dev_err(dev, "dos clock request failed\n");
> +		return PTR_ERR(core->dos_clk);
> +	}
> +
> +	core->vdec_1_clk = devm_clk_get(dev, "vdec_1");
> +	if (IS_ERR(core->vdec_1_clk)) {
> +		dev_err(dev, "vdec_1 clock request failed\n");
> +		return PTR_ERR(core->vdec_1_clk);
> +	}
> +
> +	core->vdec_hevc_clk = devm_clk_get(dev, "vdec_hevc");
> +	if (IS_ERR(core->vdec_hevc_clk)) {
> +		dev_err(dev, "vdec_hevc clock request failed\n");
> +		return PTR_ERR(core->vdec_hevc_clk);
> +	}
> +
> +	irq = platform_get_irq(pdev, 0);
> +	if (irq < 0)
> +		return irq;
> +		
> +	ret = devm_request_threaded_irq(core->dev, irq, vdec_isr,
> +			vdec_threaded_isr, IRQF_ONESHOT, "vdec", core);
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
> +	strlcpy(vdev->name, "meson-video-decoder", sizeof(vdev->name));
> +	vdev->release = video_device_release;
> +	vdev->fops = &vdec_fops;
> +	vdev->ioctl_ops = &vdec_ioctl_ops;
> +	vdev->vfl_dir = VFL_DIR_M2M;
> +	vdev->v4l2_dev = &core->v4l2_dev;
> +	vdev->device_caps = V4L2_CAP_VIDEO_M2M_MPLANE | V4L2_CAP_STREAMING;
> +
> +	ret = video_register_device(vdev, VFL_TYPE_GRABBER, -1);
> +	if (ret) {
> +		dev_err(dev, "Failed registering video device\n");
> +		goto err_vdev_release;
> +	}
> +
> +	of_id = of_match_node(vdec_dt_match, dev->of_node);
> +	core->platform = of_id->data;
> +	core->vdev_dec = vdev;
> +	core->dev_dec = dev;
> +	mutex_init(&core->lock);
> +
> +	video_set_drvdata(vdev, core);
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
> +	struct vdec_core *core = platform_get_drvdata(pdev);
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
> +MODULE_ALIAS("platform:meson-video-decoder");

On the target platform, the device should always be instantiated from DT
With the MODULE_DEVICE_TABLE above, I don't think you need this MODULE_ALIAS.

> +MODULE_DESCRIPTION("Meson video decoder driver for GXBB/GXL/GXM");
> +MODULE_AUTHOR("Maxime Jourdan <maxi.jourdan@wanadoo.fr>");
> +MODULE_LICENSE("GPL v2");
> diff --git a/drivers/media/platform/meson/vdec/vdec.h b/drivers/media/platform/meson/vdec/vdec.h
> new file mode 100644
> index 000000000000..b97d6b21dfb2
> --- /dev/null
> +++ b/drivers/media/platform/meson/vdec/vdec.h
> @@ -0,0 +1,152 @@
> +/* SPDX-License-Identifier: GPL-2.0+ */
> +/*
> + * Copyright (C) 2018 Maxime Jourdan <maxi.jourdan@wanadoo.fr>
> + */
> +
> +#ifndef __MESON_VDEC_CORE_H_
> +#define __MESON_VDEC_CORE_H_
> +
> +#include <linux/regmap.h>
> +#include <linux/list.h>
> +#include <media/videobuf2-v4l2.h>
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-device.h>
> +
> +#include "vdec_platform.h"
> +
> +#define REG_BUF_SIZE 21
> +
> +struct dummy_buf {
> +	struct vb2_v4l2_buffer vb;
> +	struct list_head list;
> +};
> +
> +struct vdec_buffer {
> +	struct list_head list;
> +	s32 index;
> +	u64 timestamp;
> +};
> +
> +struct vdec_session;
> +
> +struct vdec_core {
> +	void __iomem *dos_base;
> +	void __iomem *esparser_base;
> +	void __iomem *dmc_base;
> +	struct regmap *regmap_ao;
> +
> +	struct device *dev;
> +	struct device *dev_dec;
> +	const struct vdec_platform *platform;
> +
> +	struct clk *dos_parser_clk;
> +	struct clk *dos_clk;
> +	struct clk *vdec_1_clk;
> +	struct clk *vdec_hevc_clk;
> +
> +	struct reset_control *esparser_reset;
> +
> +	struct video_device *vdev_dec;
> +	struct v4l2_device v4l2_dev;
> +	
> +	struct vdec_session *cur_sess;
> +	struct mutex lock;
> +};
> +
> +/* Describes one of the VDECS (VDEC_1, VDEC_2, VDEC_HCODEC, VDEC_HEVC) */
> +struct vdec_ops {
> +	int (*start)(struct vdec_session *sess);
> +	int (*stop)(struct vdec_session *sess);
> +	void (*conf_esparser)(struct vdec_session *sess);
> +	u32 (*vififo_level)(struct vdec_session *sess);
> +};
> +
> +/* Describes one of the compression standard supported (H.264, HEVC..) */
> +struct vdec_codec_ops {
> +	int (*start)(struct vdec_session *sess);
> +	int (*stop)(struct vdec_session *sess);
> +	int (*load_extended_firmware)(struct vdec_session *sess, const u8 *data, u32 len);
> +	u32 (*num_pending_bufs)(struct vdec_session *sess);
> +	void (*notify_dst_buffer)(struct vdec_session *sess, struct vb2_buffer *vb);
> +	irqreturn_t (*isr)(struct vdec_session *sess);
> +	irqreturn_t (*threaded_isr)(struct vdec_session *sess);
> +};
> +
> +/* Describes one of the format that can be decoded/encoded */
> +struct vdec_format {
> +	u32 pixfmt;
> +	u32 num_planes;
> +	u32 type;
> +	u32 min_buffers;
> +	u32 max_buffers;
> +
> +	struct vdec_ops *vdec_ops;
> +	struct vdec_codec_ops *codec_ops;
> +
> +	char *firmware_path;
> +};
> +
> +struct vdec_session {
> +	struct vdec_core *core;
> +	
> +	struct v4l2_fh fh;
> +	struct v4l2_m2m_dev *m2m_dev;
> +	struct v4l2_m2m_ctx *m2m_ctx;
> +	struct mutex lock;
> +	struct mutex codec_lock;
> +	
> +	const struct vdec_format *fmt_out;
> +	const struct vdec_format *fmt_cap;
> +	u32 width;
> +	u32 height;
> +	u32 colorspace;
> +	u8 ycbcr_enc;
> +	u8 quantization;
> +	u8 xfer_func;
> +
> +	u32 num_input_bufs;
> +	u32 num_output_bufs;
> +
> +	/* Number of buffers currently queued into ESPARSER */
> +	atomic_t esparser_queued_bufs;
> +
> +	/* Work for the ESPARSER to process src buffers */
> +	struct work_struct esparser_queue_work;
> +
> +	/* Whether capture/output streaming are on */
> +	unsigned int streamon_cap, streamon_out;
> +	
> +	/* Capture sequence counter */
> +	unsigned int sequence_cap;
> +
> +	/* Whether userspace signaled EOS via command, empty buffer or
> +	 * V4L2_BUF_FLAG_LAST
> +	 */
> +	unsigned int should_stop;
> +
> +	/* Big contiguous area for the VIFIFO */
> +	void *vififo_vaddr;
> +	dma_addr_t vififo_paddr;
> +	u32 vififo_size;
> +
> +	/* Buffers that need to be recycled by the HW */
> +	struct list_head bufs_recycle;
> +	struct mutex bufs_recycle_lock;
> +	
> +	/* Buffers queued into the HW */
> +	struct list_head bufs;
> +	spinlock_t bufs_spinlock;
> +
> +	/* Codec private data */
> +	void *priv;
> +};
> +
> +u32 vdec_get_output_size(struct vdec_session *sess);
> +void vdec_dst_buf_done_idx(struct vdec_session *sess, u32 buf_idx);
> +void vdec_dst_buf_done(struct vdec_session *sess, struct vb2_v4l2_buffer *vbuf);
> +void vdec_add_ts_reorder(struct vdec_session *sess, u64 ts);
> +void vdec_remove_ts(struct vdec_session *sess, u64 ts);
> +void vdec_queue_recycle(struct vdec_session *sess, struct vb2_buffer *vb);
> +void vdec_abort(struct vdec_session *sess);
> +
> +#endif
> diff --git a/drivers/media/platform/meson/vdec/vdec_1.c b/drivers/media/platform/meson/vdec/vdec_1.c
> new file mode 100644
> index 000000000000..e6593a68de11
> --- /dev/null
> +++ b/drivers/media/platform/meson/vdec/vdec_1.c
> @@ -0,0 +1,266 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/*
> + * Copyright (C) 2018 Maxime Jourdan <maxi.jourdan@wanadoo.fr>
> + */
> +
> +#include <linux/firmware.h>
> +#include <linux/clk.h>
> +
> +#include "vdec_1.h"
> +
> +/* AO Registers */
> +#define AO_RTI_GEN_PWR_SLEEP0	0xe8
> +#define AO_RTI_GEN_PWR_ISO0	0xec
> +	#define GEN_PWR_VDEC_1 (BIT(3) | BIT(2))
> +
> +/* DOS Registers */
> +#define ASSIST_MBOX1_CLR_REG 0x01d4
> +#define ASSIST_MBOX1_MASK    0x01d8
> +
> +#define MPSR 0x0c04
> +#define CPSR 0x0c84
> +
> +#define IMEM_DMA_CTRL  0x0d00
> +#define IMEM_DMA_ADR   0x0d04
> +#define IMEM_DMA_COUNT 0x0d08
> +#define LMEM_DMA_CTRL  0x0d40
> +
> +#define MC_STATUS0  0x2424
> +#define MC_CTRL1    0x242c
> +
> +#define DBLK_CTRL   0x2544
> +#define DBLK_STATUS 0x254c
> +
> +#define GCLK_EN            0x260c
> +#define MDEC_PIC_DC_CTRL   0x2638
> +#define MDEC_PIC_DC_STATUS 0x263c
> +
> +#define DCAC_DMA_CTRL 0x3848
> +
> +#define DOS_SW_RESET0             0xfc00
> +#define DOS_GCLK_EN0              0xfc04
> +#define DOS_GEN_CTRL0             0xfc08
> +#define DOS_MEM_PD_VDEC           0xfcc0
> +#define DOS_VDEC_MCRCC_STALL_CTRL 0xfd00
> +
> +/* Stream Buffer (stbuf) regs (DOS) */
> +#define POWER_CTL_VLD 0x3020
> +#define VLD_MEM_VIFIFO_START_PTR 0x3100
> +#define VLD_MEM_VIFIFO_CURR_PTR 0x3104
> +#define VLD_MEM_VIFIFO_END_PTR 0x3108
> +#define VLD_MEM_VIFIFO_CONTROL 0x3110
> +	#define MEM_FIFO_CNT_BIT	16
> +	#define MEM_FILL_ON_LEVEL	BIT(10)
> +	#define MEM_CTRL_EMPTY_EN	BIT(2)
> +	#define MEM_CTRL_FILL_EN	BIT(1)
> +#define VLD_MEM_VIFIFO_WP 0x3114
> +#define VLD_MEM_VIFIFO_RP 0x3118
> +#define VLD_MEM_VIFIFO_LEVEL 0x311c
> +#define VLD_MEM_VIFIFO_BUF_CNTL 0x3120
> +	#define MEM_BUFCTRL_MANUAL	BIT(1)
> +#define VLD_MEM_VIFIFO_WRAP_COUNT 0x3144
> +
> +#define MC_SIZE			(4096 * 4)
> +
> +static int vdec_1_load_firmware(struct vdec_session *sess, const char* fwname)
> +{
> +	const struct firmware *fw;
> +	struct vdec_core *core = sess->core;
> +	struct device *dev = core->dev_dec;
> +	struct vdec_codec_ops *codec_ops = sess->fmt_out->codec_ops;
> +	static void *mc_addr;
> +	static dma_addr_t mc_addr_map;
> +	int ret;
> +	u32 i = 1000;
> +
> +	ret = request_firmware(&fw, fwname, dev);
> +	if (ret < 0)
> +		return -EINVAL;
> +
> +	if (fw->size < MC_SIZE) {
> +		dev_err(dev, "Firmware size %zu is too small. Expected %u.\n",
> +			fw->size, MC_SIZE);
> +		ret = -EINVAL;
> +		goto release_firmware;
> +	}
> +
> +	mc_addr = dma_alloc_coherent(core->dev, MC_SIZE, &mc_addr_map, GFP_KERNEL);
> +	if (!mc_addr) {
> +		dev_err(dev, "Failed allocating memory for firmware loading\n");
> +		ret = -ENOMEM;
> +		goto release_firmware;
> +	 }
> +
> +	memcpy(mc_addr, fw->data, MC_SIZE);
> +
> +	writel_relaxed(0, core->dos_base + MPSR);
> +	writel_relaxed(0, core->dos_base + CPSR);
> +
> +	writel_relaxed(readl_relaxed(core->dos_base + MDEC_PIC_DC_CTRL) & ~(1<<31), core->dos_base + MDEC_PIC_DC_CTRL);
> +
> +	writel_relaxed(mc_addr_map, core->dos_base + IMEM_DMA_ADR);
> +	writel_relaxed(MC_SIZE / 4, core->dos_base + IMEM_DMA_COUNT);
> +	writel_relaxed((0x8000 | (7 << 16)), core->dos_base + IMEM_DMA_CTRL);
> +
> +	while (--i && readl(core->dos_base + IMEM_DMA_CTRL) & 0x8000) { }
> +
> +	if (i == 0) {
> +		dev_err(dev, "Firmware load fail (DMA hang?)\n");
> +		ret = -EINVAL;
> +		goto free_mc;
> +	}
> +
> +	if (codec_ops->load_extended_firmware)
> +		codec_ops->load_extended_firmware(sess, fw->data + MC_SIZE, fw->size - MC_SIZE);
> +
> +free_mc:
> +	dma_free_coherent(core->dev, MC_SIZE, mc_addr, mc_addr_map);
> +release_firmware:
> +	release_firmware(fw);
> +	return ret;
> +}
> +
> +int vdec_1_stbuf_power_up(struct vdec_session *sess) {
> +	struct vdec_core *core = sess->core;
> +
> +	writel_relaxed(0, core->dos_base + VLD_MEM_VIFIFO_CONTROL);
> +	writel_relaxed(0, core->dos_base + VLD_MEM_VIFIFO_WRAP_COUNT);
> +	writel_relaxed(1 << 4, core->dos_base + POWER_CTL_VLD);
> +
> +	writel_relaxed(sess->vififo_paddr, core->dos_base + VLD_MEM_VIFIFO_START_PTR);
> +	writel_relaxed(sess->vififo_paddr, core->dos_base + VLD_MEM_VIFIFO_CURR_PTR);
> +	writel_relaxed(sess->vififo_paddr + sess->vififo_size - 8, core->dos_base + VLD_MEM_VIFIFO_END_PTR);
> +
> +	writel_relaxed(readl_relaxed(core->dos_base + VLD_MEM_VIFIFO_CONTROL) |  1, core->dos_base + VLD_MEM_VIFIFO_CONTROL);
> +	writel_relaxed(readl_relaxed(core->dos_base + VLD_MEM_VIFIFO_CONTROL) & ~1, core->dos_base + VLD_MEM_VIFIFO_CONTROL);
> +
> +	writel_relaxed(MEM_BUFCTRL_MANUAL, core->dos_base + VLD_MEM_VIFIFO_BUF_CNTL);
> +	writel_relaxed(sess->vififo_paddr, core->dos_base + VLD_MEM_VIFIFO_WP);
> +
> +	writel_relaxed(readl_relaxed(core->dos_base + VLD_MEM_VIFIFO_BUF_CNTL) |  1, core->dos_base + VLD_MEM_VIFIFO_BUF_CNTL);
> +	writel_relaxed(readl_relaxed(core->dos_base + VLD_MEM_VIFIFO_BUF_CNTL) & ~1, core->dos_base + VLD_MEM_VIFIFO_BUF_CNTL);
> +
> +	writel_relaxed(readl_relaxed(core->dos_base + VLD_MEM_VIFIFO_CONTROL) | (0x11 << MEM_FIFO_CNT_BIT) | MEM_FILL_ON_LEVEL | MEM_CTRL_FILL_EN | MEM_CTRL_EMPTY_EN, core->dos_base + VLD_MEM_VIFIFO_CONTROL);
> +
> +	return 0;
> +}
> +
> +static void vdec_1_conf_esparser(struct vdec_session *sess)
> +{
> +	struct vdec_core *core = sess->core;
> +
> +	/* VDEC_1 specific ESPARSER stuff */
> +	writel_relaxed(0, core->dos_base + DOS_GEN_CTRL0); // set vififo_vbuf_rp_sel=>vdec
> +	writel_relaxed(1, core->dos_base + VLD_MEM_VIFIFO_BUF_CNTL);
> +	writel_relaxed(readl_relaxed(core->dos_base + VLD_MEM_VIFIFO_BUF_CNTL) & ~1, core->dos_base + VLD_MEM_VIFIFO_BUF_CNTL);
> +}
> +
> +static u32 vdec_1_vififo_level(struct vdec_session *sess)
> +{
> +	struct vdec_core *core = sess->core;
> +
> +	return readl_relaxed(core->dos_base + VLD_MEM_VIFIFO_LEVEL);
> +}
> +
> +static int vdec_1_start(struct vdec_session *sess)
> +{
> +	int ret;
> +	struct vdec_core *core = sess->core;
> +	struct vdec_codec_ops *codec_ops = sess->fmt_out->codec_ops;
> +
> +	clk_set_rate(core->vdec_1_clk, 666666666);
> +	ret = clk_prepare_enable(core->vdec_1_clk);
> +	if (ret)
> +		return ret;
> +
> +	regmap_update_bits(core->regmap_ao, AO_RTI_GEN_PWR_SLEEP0,
> +		GEN_PWR_VDEC_1, 0);
> +	udelay(10);
> +
> +	/* Reset VDEC1 */
> +	writel_relaxed(0xfffffffc, core->dos_base + DOS_SW_RESET0);
> +	writel_relaxed(0x00000000, core->dos_base + DOS_SW_RESET0);
> +
> +	writel_relaxed(0x3ff, core->dos_base + DOS_GCLK_EN0);
> +
> +	/* VDEC Memories */
> +	writel_relaxed(0x00000000, core->dos_base + DOS_MEM_PD_VDEC);
> +	/* Remove VDEC1 Isolation */
> +	regmap_write(core->regmap_ao, AO_RTI_GEN_PWR_ISO0, 0x00000000);
> +	/* Reset DOS top registers */
> +	writel_relaxed(0x00000000, core->dos_base + DOS_VDEC_MCRCC_STALL_CTRL);
> +
> +	writel_relaxed(0x3ff, core->dos_base + GCLK_EN);
> +	writel_relaxed(readl_relaxed(core->dos_base + MDEC_PIC_DC_CTRL) & ~(1<<31), core->dos_base + MDEC_PIC_DC_CTRL);
> +
> +	vdec_1_stbuf_power_up(sess);
> +
> +	ret = vdec_1_load_firmware(sess, sess->fmt_out->firmware_path);
> +	if (ret) {
> +		clk_disable_unprepare(core->vdec_1_clk);
> +		regmap_update_bits(core->regmap_ao, AO_RTI_GEN_PWR_SLEEP0,
> +			GEN_PWR_VDEC_1, GEN_PWR_VDEC_1);
> +		return ret;
> +	}
> +
> +	codec_ops->start(sess);
> +
> +	/* Enable firmware processor */
> +	writel_relaxed(1, core->dos_base + MPSR);
> +
> +	/* Let the firmware settle */
> +	udelay(10);
> +
> +	return 0;
> +}
> +
> +static int vdec_1_stop(struct vdec_session *sess)
> +{
> +	struct vdec_core *core = sess->core;
> +	struct vdec_codec_ops *codec_ops = sess->fmt_out->codec_ops;
> +
> +	writel_relaxed(0, core->dos_base + MPSR);
> +	writel_relaxed(0, core->dos_base + CPSR);
> +
> +	codec_ops->stop(sess);
> +
> +	while (readl_relaxed(core->dos_base + IMEM_DMA_CTRL) & 0x8000) { }
> +
> +	writel_relaxed((1<<12)|(1<<11), core->dos_base + DOS_SW_RESET0);
> +	writel_relaxed(0, core->dos_base + DOS_SW_RESET0);
> +	readl_relaxed(core->dos_base + DOS_SW_RESET0);
> +
> +	writel_relaxed(0, core->dos_base + ASSIST_MBOX1_MASK);
> +
> +	writel_relaxed(readl_relaxed(core->dos_base + MDEC_PIC_DC_CTRL) | 1, core->dos_base + MDEC_PIC_DC_CTRL);
> +	writel_relaxed(readl_relaxed(core->dos_base + MDEC_PIC_DC_CTRL) & ~1, core->dos_base + MDEC_PIC_DC_CTRL);
> +	readl_relaxed(core->dos_base + MDEC_PIC_DC_STATUS);
> +
> +	writel_relaxed(3, core->dos_base + DBLK_CTRL);
> +	writel_relaxed(0, core->dos_base + DBLK_CTRL);
> +	readl_relaxed(core->dos_base + DBLK_STATUS);
> +
> +	writel_relaxed(readl_relaxed(core->dos_base + MC_CTRL1) | 0x9, core->dos_base + MC_CTRL1);
> +	writel_relaxed(readl_relaxed(core->dos_base + MC_CTRL1) & ~0x9, core->dos_base + MC_CTRL1);
> +	readl_relaxed(core->dos_base + MC_STATUS0);
> +
> +	while (readl_relaxed(core->dos_base + DCAC_DMA_CTRL) & 0x8000) { }
> +
> +	/* enable vdec1 isolation */
> +	regmap_write(core->regmap_ao, AO_RTI_GEN_PWR_ISO0, 0xc0);
> +	/* power off vdec1 memories */
> +	writel(0xffffffffUL, core->dos_base + DOS_MEM_PD_VDEC);
> +	regmap_update_bits(core->regmap_ao, AO_RTI_GEN_PWR_SLEEP0,
> +		GEN_PWR_VDEC_1, GEN_PWR_VDEC_1);
> +
> +	clk_disable_unprepare(core->vdec_1_clk);
> +
> +	return 0;
> +}
> +
> +struct vdec_ops vdec_1_ops = {
> +	.start = vdec_1_start,
> +	.stop = vdec_1_stop,
> +	.conf_esparser = vdec_1_conf_esparser,
> +	.vififo_level = vdec_1_vififo_level,
> +};
> \ No newline at end of file
> diff --git a/drivers/media/platform/meson/vdec/vdec_1.h b/drivers/media/platform/meson/vdec/vdec_1.h
> new file mode 100644
> index 000000000000..b6c8b41b4cf5
> --- /dev/null
> +++ b/drivers/media/platform/meson/vdec/vdec_1.h
> @@ -0,0 +1,13 @@
> +/* SPDX-License-Identifier: GPL-2.0+ */
> +/*
> + * Copyright (C) 2018 Maxime Jourdan <maxi.jourdan@wanadoo.fr>
> + */
> +
> +#ifndef __MESON_VDEC_VDEC_1_H_
> +#define __MESON_VDEC_VDEC_1_H_
> +
> +#include "vdec.h"
> +
> +extern struct vdec_ops vdec_1_ops;
> +
> +#endif
> \ No newline at end of file
> diff --git a/drivers/media/platform/meson/vdec/vdec_hevc.c b/drivers/media/platform/meson/vdec/vdec_hevc.c
> new file mode 100644
> index 000000000000..4f6e056beb11
> --- /dev/null
> +++ b/drivers/media/platform/meson/vdec/vdec_hevc.c
> @@ -0,0 +1,188 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/*
> + * Copyright (C) 2018 Maxime Jourdan <maxi.jourdan@wanadoo.fr>
> + */
> +
> +#include <linux/firmware.h>
> +#include <linux/clk.h>
> +
> +#include "vdec_1.h"
> +#include "hevc_regs.h"
> +
> +/* AO Registers */
> +#define AO_RTI_GEN_PWR_SLEEP0	0xe8
> +#define AO_RTI_GEN_PWR_ISO0	0xec
> +	#define GEN_PWR_VDEC_HEVC (BIT(7) | BIT(6))
> +
> +/* DOS Registers */
> +#define ASSIST_MBOX1_CLR_REG 0x01d4
> +#define ASSIST_MBOX1_MASK    0x01d8
> +
> +#define DOS_GEN_CTRL0	     0xfc08
> +#define DOS_SW_RESET3        0xfcd0
> +#define DOS_MEM_PD_HEVC      0xfccc
> +#define DOS_GCLK_EN3	     0xfcd4
> +
> +#define MC_SIZE	(4096 * 4)
> +
> +static int vdec_hevc_load_firmware(struct vdec_session *sess, const char* fwname)
> +{
> +	struct vdec_core *core = sess->core;
> +	struct device *dev = core->dev_dec;
> +	const struct firmware *fw;
> +	static void *mc_addr;
> +	static dma_addr_t mc_addr_map;
> +	int ret;
> +	u32 i = 100;
> +
> +	ret = request_firmware(&fw, fwname, dev);
> +	if (ret < 0)  {
> +		dev_err(dev, "Unable to request firmware %s\n", fwname);
> +		return ret;
> +	}
> +
> +	if (fw->size < MC_SIZE) {
> +		dev_err(dev, "Firmware size %zu is too small. Expected %u.\n",
> +			fw->size, MC_SIZE);
> +		ret = -EINVAL;
> +		goto release_firmware;
> +	}
> +
> +	mc_addr = dma_alloc_coherent(core->dev, MC_SIZE, &mc_addr_map, GFP_KERNEL);
> +	if (!mc_addr) {
> +		dev_err(dev, "Failed allocating memory for firmware loading\n");
> +		ret = -ENOMEM;
> +		goto release_firmware;
> +	 }
> +
> +	memcpy(mc_addr, fw->data, MC_SIZE);
> +
> +	writel_relaxed(0, core->dos_base + HEVC_MPSR);
> +	writel_relaxed(0, core->dos_base + HEVC_CPSR);
> +
> +	writel_relaxed(mc_addr_map, core->dos_base + HEVC_IMEM_DMA_ADR);
> +	writel_relaxed(MC_SIZE / 4, core->dos_base + HEVC_IMEM_DMA_COUNT);
> +	writel_relaxed((0x8000 | (7 << 16)), core->dos_base + HEVC_IMEM_DMA_CTRL);
> +
> +	while (--i && readl(core->dos_base + HEVC_IMEM_DMA_CTRL) & 0x8000) { }
> +
> +	if (i == 0) {
> +		dev_err(dev, "Firmware load fail (DMA hang?)\n");
> +		ret = -ENODEV;
> +	}
> +
> +	dma_free_coherent(core->dev, MC_SIZE, mc_addr, mc_addr_map);
> +release_firmware:
> +	release_firmware(fw);
> +	return ret;
> +}
> +
> +static void vdec_hevc_stbuf_init(struct vdec_session *sess)
> +{
> +	struct vdec_core *core = sess->core;
> +
> +	writel_relaxed(readl_relaxed(core->dos_base + HEVC_STREAM_CONTROL) & ~1, core->dos_base + HEVC_STREAM_CONTROL);
> +	writel_relaxed(sess->vififo_paddr, core->dos_base + HEVC_STREAM_START_ADDR);
> +	writel_relaxed(sess->vififo_paddr + sess->vififo_size, core->dos_base + HEVC_STREAM_END_ADDR);
> +	writel_relaxed(sess->vififo_paddr, core->dos_base + HEVC_STREAM_RD_PTR);
> +	writel_relaxed(sess->vififo_paddr, core->dos_base + HEVC_STREAM_WR_PTR);
> +}
> +
> +/* VDEC_HEVC specific ESPARSER configuration */
> +static void vdec_hevc_conf_esparser(struct vdec_session *sess)
> +{
> +	struct vdec_core *core = sess->core;
> +
> +	/* set vififo_vbuf_rp_sel=>vdec_hevc */
> +	writel_relaxed(3 << 1, core->dos_base + DOS_GEN_CTRL0);
> +	writel_relaxed(readl_relaxed(core->dos_base + HEVC_STREAM_CONTROL) | (1 << 3), core->dos_base + HEVC_STREAM_CONTROL);
> +	writel_relaxed(readl_relaxed(core->dos_base + HEVC_STREAM_CONTROL) | 1, core->dos_base + HEVC_STREAM_CONTROL);
> +	writel_relaxed(readl_relaxed(core->dos_base + HEVC_STREAM_FIFO_CTL) | (1 << 29), core->dos_base + HEVC_STREAM_FIFO_CTL);
> +}
> +
> +static u32 vdec_hevc_vififo_level(struct vdec_session *sess)
> +{
> +	return readl_relaxed(sess->core->dos_base + HEVC_STREAM_LEVEL);
> +}
> +
> +static int vdec_hevc_stop(struct vdec_session *sess)
> +{
> +	struct vdec_core *core = sess->core;
> +	struct vdec_codec_ops *codec_ops = sess->fmt_out->codec_ops;
> +
> +	/* Disable interrupt */
> +	writel_relaxed(0, core->dos_base + HEVC_ASSIST_MBOX1_MASK);
> +	/* Disable firmware processor */
> +	writel_relaxed(0, core->dos_base + HEVC_MPSR);
> +
> +	codec_ops->stop(sess);
> +
> +	/* Enable VDEC_HEVC Isolation */
> +	regmap_update_bits(core->regmap_ao, AO_RTI_GEN_PWR_ISO0, 0xc00, 0xc00);
> +
> +	/* VDEC_HEVC Memories */
> +	writel_relaxed(0xffffffffUL, core->dos_base + DOS_MEM_PD_HEVC);
> +
> +	regmap_update_bits(core->regmap_ao, AO_RTI_GEN_PWR_SLEEP0,
> +		GEN_PWR_VDEC_HEVC, GEN_PWR_VDEC_HEVC);
> +
> +	clk_disable_unprepare(core->vdec_hevc_clk);
> +
> +	return 0;
> +}
> +
> +static int vdec_hevc_start(struct vdec_session *sess)
> +{
> +	int ret;
> +	struct vdec_core *core = sess->core;
> +	struct vdec_codec_ops *codec_ops = sess->fmt_out->codec_ops;
> +
> +	clk_set_rate(core->vdec_hevc_clk, 666666666);
> +	ret = clk_prepare_enable(core->vdec_hevc_clk);
> +	if (ret)
> +		return ret;
> +
> +	regmap_update_bits(core->regmap_ao, AO_RTI_GEN_PWR_SLEEP0,
> +		GEN_PWR_VDEC_HEVC, 0);
> +	udelay(10);
> +
> +	/* Reset VDEC_HEVC*/
> +	writel_relaxed(0xffffffff, core->dos_base + DOS_SW_RESET3);
> +	writel_relaxed(0x00000000, core->dos_base + DOS_SW_RESET3);
> +
> +	writel_relaxed(0xffffffff, core->dos_base + DOS_GCLK_EN3);
> +
> +	/* VDEC_HEVC Memories */
> +	writel_relaxed(0x00000000, core->dos_base + DOS_MEM_PD_HEVC);
> +
> +	/* Remove VDEC_HEVC Isolation */
> +	regmap_update_bits(core->regmap_ao, AO_RTI_GEN_PWR_ISO0, 0xc00, 0);
> +
> +	writel_relaxed(0xffffffff, core->dos_base + DOS_SW_RESET3);
> +	writel_relaxed(0x00000000, core->dos_base + DOS_SW_RESET3);
> +
> +	vdec_hevc_stbuf_init(sess);
> +
> +	ret = vdec_hevc_load_firmware(sess, sess->fmt_out->firmware_path);
> +	if (ret) {
> +		vdec_hevc_stop(sess);
> +		return ret;
> +	}
> +
> +	codec_ops->start(sess);
> +
> +	writel_relaxed((1<<12)|(1<<11), core->dos_base + DOS_SW_RESET3);
> +	writel_relaxed(0, core->dos_base + DOS_SW_RESET3);
> +	readl_relaxed(core->dos_base + DOS_SW_RESET3);
> +
> +	writel_relaxed(1, core->dos_base + HEVC_MPSR);
> +
> +	return 0;
> +}
> +
> +struct vdec_ops vdec_hevc_ops = {
> +	.start = vdec_hevc_start,
> +	.stop = vdec_hevc_stop,
> +	.conf_esparser = vdec_hevc_conf_esparser,
> +	.vififo_level = vdec_hevc_vififo_level,
> +};
> \ No newline at end of file
> diff --git a/drivers/media/platform/meson/vdec/vdec_hevc.h b/drivers/media/platform/meson/vdec/vdec_hevc.h
> new file mode 100644
> index 000000000000..a90529c6bc7f
> --- /dev/null
> +++ b/drivers/media/platform/meson/vdec/vdec_hevc.h
> @@ -0,0 +1,22 @@
> +/*
> + * Copyright (C) 2018 Maxime Jourdan <maxi.jourdan@wanadoo.fr>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 and
> + * only version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + */
> +
> +#ifndef __MESON_VDEC_VDEC_HEVC_H_
> +#define __MESON_VDEC_VDEC_HEVC_H_
> +
> +#include "vdec.h"
> +
> +extern struct vdec_ops vdec_hevc_ops;
> +
> +#endif
> \ No newline at end of file
> diff --git a/drivers/media/platform/meson/vdec/vdec_platform.c b/drivers/media/platform/meson/vdec/vdec_platform.c
> new file mode 100644
> index 000000000000..92b7e45875c7
> --- /dev/null
> +++ b/drivers/media/platform/meson/vdec/vdec_platform.c
> @@ -0,0 +1,273 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/*
> + * Copyright (C) 2018 Maxime Jourdan <maxi.jourdan@wanadoo.fr>
> + */
> +
> +#include "vdec_platform.h"
> +#include "vdec.h"
> +
> +#include "vdec_1.h"
> +#include "vdec_hevc.h"
> +#include "codec_mpeg12.h"
> +#include "codec_mpeg4.h"
> +#include "codec_mjpeg.h"
> +#include "codec_h264.h"
> +#include "codec_hevc.h"
> +
> +static const struct vdec_format vdec_formats_gxbb[] = {
> +	{
> +		.pixfmt = V4L2_PIX_FMT_NV12M,
> +		.num_planes = 2,
> +		.type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE,
> +	}, {
> +		.pixfmt = V4L2_PIX_FMT_H264,
> +		.num_planes = 1,
> +		.type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE,
> +		.min_buffers = 16,
> +		.max_buffers = 32,
> +		.vdec_ops = &vdec_1_ops,
> +		.codec_ops = &codec_h264_ops,
> +		.firmware_path = "meson/gxbb/vh264_mc",
> +	}, {
> +		.pixfmt = V4L2_PIX_FMT_HEVC,
> +		.num_planes = 1,
> +		.type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE,
> +		.min_buffers = 16,
> +		.max_buffers = 24,
> +		.vdec_ops = &vdec_hevc_ops,
> +		.codec_ops = &codec_hevc_ops,
> +		.firmware_path = "meson/gx/vh265_mc",
> +	}, {
> +		.pixfmt = V4L2_PIX_FMT_MPEG1,
> +		.num_planes = 1,
> +		.type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE,
> +		.min_buffers = 8,
> +		.max_buffers = 8,
> +		.vdec_ops = &vdec_1_ops,
> +		.codec_ops = &codec_mpeg12_ops,
> +		.firmware_path = "meson/gx/vmpeg12_mc",
> +	}, {
> +		.pixfmt = V4L2_PIX_FMT_MPEG2,
> +		.num_planes = 1,
> +		.type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE,
> +		.min_buffers = 8,
> +		.max_buffers = 8,
> +		.vdec_ops = &vdec_1_ops,
> +		.codec_ops = &codec_mpeg12_ops,
> +		.firmware_path = "meson/gx/vmpeg12_mc",
> +	}, {
> +		.pixfmt = V4L2_PIX_FMT_MPEG4,
> +		.num_planes = 1,
> +		.type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE,
> +		.min_buffers = 8,
> +		.max_buffers = 8,
> +		.vdec_ops = &vdec_1_ops,
> +		.codec_ops = &codec_mpeg4_ops,
> +		.firmware_path = "meson/gx/vmpeg4_mc_5",
> +	}, {
> +		.pixfmt = V4L2_PIX_FMT_H263,
> +		.num_planes = 1,
> +		.type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE,
> +		.min_buffers = 8,
> +		.max_buffers = 8,
> +		.vdec_ops = &vdec_1_ops,
> +		.codec_ops = &codec_mpeg4_ops,
> +		.firmware_path = "meson/gx/h263_mc",
> +	}, {
> +		.pixfmt = V4L2_PIX_FMT_XVID,
> +		.num_planes = 1,
> +		.type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE,
> +		.min_buffers = 8,
> +		.max_buffers = 8,
> +		.vdec_ops = &vdec_1_ops,
> +		.codec_ops = &codec_mpeg4_ops,
> +		.firmware_path = "meson/gx/vmpeg4_mc_5",
> +	}, {
> +		.pixfmt = V4L2_PIX_FMT_MJPEG,
> +		.num_planes = 1,
> +		.type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE,
> +		.min_buffers = 4,
> +		.max_buffers = 4,
> +		.vdec_ops = &vdec_1_ops,
> +		.codec_ops = &codec_mjpeg_ops,
> +		.firmware_path = "meson/gx/vmjpeg_mc",
> +	},
> +};
> +
> +static const struct vdec_format vdec_formats_gxl[] = {
> +	{
> +		.pixfmt = V4L2_PIX_FMT_NV12M,
> +		.num_planes = 2,
> +		.type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE,
> +	}, {
> +		.pixfmt = V4L2_PIX_FMT_H264,
> +		.num_planes = 1,
> +		.type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE,
> +		.min_buffers = 16,
> +		.max_buffers = 32,
> +		.vdec_ops = &vdec_1_ops,
> +		.codec_ops = &codec_h264_ops,
> +		.firmware_path = "meson/gxl/vh264_mc",
> +	}, {
> +		.pixfmt = V4L2_PIX_FMT_HEVC,
> +		.num_planes = 1,
> +		.type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE,
> +		.min_buffers = 16,
> +		.max_buffers = 24,
> +		.vdec_ops = &vdec_hevc_ops,
> +		.codec_ops = &codec_hevc_ops,
> +		.firmware_path = "meson/gx/vh265_mc",
> +	}, {
> +		.pixfmt = V4L2_PIX_FMT_MPEG1,
> +		.num_planes = 1,
> +		.type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE,
> +		.min_buffers = 8,
> +		.max_buffers = 8,
> +		.vdec_ops = &vdec_1_ops,
> +		.codec_ops = &codec_mpeg12_ops,
> +		.firmware_path = "meson/gx/vmpeg12_mc",
> +	}, {
> +		.pixfmt = V4L2_PIX_FMT_MPEG2,
> +		.num_planes = 1,
> +		.type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE,
> +		.min_buffers = 8,
> +		.max_buffers = 8,
> +		.vdec_ops = &vdec_1_ops,
> +		.codec_ops = &codec_mpeg12_ops,
> +		.firmware_path = "meson/gx/vmpeg12_mc",
> +	}, {
> +		.pixfmt = V4L2_PIX_FMT_MPEG4,
> +		.num_planes = 1,
> +		.type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE,
> +		.min_buffers = 8,
> +		.max_buffers = 8,
> +		.vdec_ops = &vdec_1_ops,
> +		.codec_ops = &codec_mpeg4_ops,
> +		.firmware_path = "meson/gx/vmpeg4_mc_5",
> +	}, {
> +		.pixfmt = V4L2_PIX_FMT_H263,
> +		.num_planes = 1,
> +		.type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE,
> +		.min_buffers = 8,
> +		.max_buffers = 8,
> +		.vdec_ops = &vdec_1_ops,
> +		.codec_ops = &codec_mpeg4_ops,
> +		.firmware_path = "meson/gx/h263_mc",
> +	}, {
> +		.pixfmt = V4L2_PIX_FMT_XVID,
> +		.num_planes = 1,
> +		.type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE,
> +		.min_buffers = 8,
> +		.max_buffers = 8,
> +		.vdec_ops = &vdec_1_ops,
> +		.codec_ops = &codec_mpeg4_ops,
> +		.firmware_path = "meson/gx/vmpeg4_mc_5",
> +	}, {
> +		.pixfmt = V4L2_PIX_FMT_MJPEG,
> +		.num_planes = 1,
> +		.type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE,
> +		.min_buffers = 4,
> +		.max_buffers = 4,
> +		.vdec_ops = &vdec_1_ops,
> +		.codec_ops = &codec_mjpeg_ops,
> +		.firmware_path = "meson/gx/vmjpeg_mc",
> +	},
> +};
> +
> +static const struct vdec_format vdec_formats_gxm[] = {
> +	{
> +		.pixfmt = V4L2_PIX_FMT_NV12M,
> +		.num_planes = 2,
> +		.type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE,
> +	}, {
> +		.pixfmt = V4L2_PIX_FMT_H264,
> +		.num_planes = 1,
> +		.type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE,
> +		.min_buffers = 16,
> +		.max_buffers = 32,
> +		.vdec_ops = &vdec_1_ops,
> +		.codec_ops = &codec_h264_ops,
> +		.firmware_path = "meson/gxm/vh264_mc",
> +	}, {
> +		.pixfmt = V4L2_PIX_FMT_HEVC,
> +		.num_planes = 1,
> +		.type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE,
> +		.min_buffers = 16,
> +		.max_buffers = 24,
> +		.vdec_ops = &vdec_hevc_ops,
> +		.codec_ops = &codec_hevc_ops,
> +		.firmware_path = "meson/gx/vh265_mc",
> +	}, {
> +		.pixfmt = V4L2_PIX_FMT_MPEG1,
> +		.num_planes = 1,
> +		.type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE,
> +		.min_buffers = 8,
> +		.max_buffers = 8,
> +		.vdec_ops = &vdec_1_ops,
> +		.codec_ops = &codec_mpeg12_ops,
> +		.firmware_path = "meson/gx/vmpeg12_mc",
> +	}, {
> +		.pixfmt = V4L2_PIX_FMT_MPEG2,
> +		.num_planes = 1,
> +		.type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE,
> +		.min_buffers = 8,
> +		.max_buffers = 8,
> +		.vdec_ops = &vdec_1_ops,
> +		.codec_ops = &codec_mpeg12_ops,
> +		.firmware_path = "meson/gx/vmpeg12_mc",
> +	}, {
> +		.pixfmt = V4L2_PIX_FMT_MPEG4,
> +		.num_planes = 1,
> +		.type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE,
> +		.min_buffers = 8,
> +		.max_buffers = 8,
> +		.vdec_ops = &vdec_1_ops,
> +		.codec_ops = &codec_mpeg4_ops,
> +		.firmware_path = "meson/gx/vmpeg4_mc_5",
> +	}, {
> +		.pixfmt = V4L2_PIX_FMT_H263,
> +		.num_planes = 1,
> +		.type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE,
> +		.min_buffers = 8,
> +		.max_buffers = 8,
> +		.vdec_ops = &vdec_1_ops,
> +		.codec_ops = &codec_mpeg4_ops,
> +		.firmware_path = "meson/gx/h263_mc",
> +	}, {
> +		.pixfmt = V4L2_PIX_FMT_XVID,
> +		.num_planes = 1,
> +		.type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE,
> +		.min_buffers = 8,
> +		.max_buffers = 8,
> +		.vdec_ops = &vdec_1_ops,
> +		.codec_ops = &codec_mpeg4_ops,
> +		.firmware_path = "meson/gx/vmpeg4_mc_5",
> +	}, {
> +		.pixfmt = V4L2_PIX_FMT_MJPEG,
> +		.num_planes = 1,
> +		.type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE,
> +		.min_buffers = 4,
> +		.max_buffers = 4,
> +		.vdec_ops = &vdec_1_ops,
> +		.codec_ops = &codec_mjpeg_ops,
> +		.firmware_path = "meson/gx/vmjpeg_mc",
> +	},
> +};
> +
> +const struct vdec_platform vdec_platform_gxbb = {
> +	.formats = vdec_formats_gxbb,
> +	.num_formats = ARRAY_SIZE(vdec_formats_gxbb),
> +	.revision = VDEC_REVISION_GXBB,
> +};
> +
> +const struct vdec_platform vdec_platform_gxl = {
> +	.formats = vdec_formats_gxl,
> +	.num_formats = ARRAY_SIZE(vdec_formats_gxl),
> +	.revision = VDEC_REVISION_GXL,
> +};
> +
> +const struct vdec_platform vdec_platform_gxm = {
> +	.formats = vdec_formats_gxm,
> +	.num_formats = ARRAY_SIZE(vdec_formats_gxm),
> +	.revision = VDEC_REVISION_GXM,
> +};
> \ No newline at end of file
> diff --git a/drivers/media/platform/meson/vdec/vdec_platform.h b/drivers/media/platform/meson/vdec/vdec_platform.h
> new file mode 100644
> index 000000000000..d19fad38abb3
> --- /dev/null
> +++ b/drivers/media/platform/meson/vdec/vdec_platform.h
> @@ -0,0 +1,29 @@
> +/* SPDX-License-Identifier: GPL-2.0+ */
> +/*
> + * Copyright (C) 2018 Maxime Jourdan <maxi.jourdan@wanadoo.fr>
> + */
> +
> +#ifndef __MESON_VDEC_PLATFORM_H_
> +#define __MESON_VDEC_PLATFORM_H_
> +
> +#include "vdec.h"
> +
> +struct vdec_format;
> +
> +enum vdec_revision {
> +	VDEC_REVISION_GXBB,
> +	VDEC_REVISION_GXL,
> +	VDEC_REVISION_GXM,
> +};
> +
> +struct vdec_platform {
> +	const struct vdec_format *formats;
> +	const u32 num_formats;
> +	enum vdec_revision revision;
> +};
> +
> +extern const struct vdec_platform vdec_platform_gxbb;
> +extern const struct vdec_platform vdec_platform_gxm;
> +extern const struct vdec_platform vdec_platform_gxl;
> +
> +#endif
> \ No newline at end of file
