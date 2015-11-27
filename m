Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:33758 "EHLO
	mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754834AbbK0Qes (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Nov 2015 11:34:48 -0500
Received: by wmec201 with SMTP id c201so77163107wme.0
        for <linux-media@vger.kernel.org>; Fri, 27 Nov 2015 08:34:45 -0800 (PST)
Subject: Re: [RESEND RFC/PATCH 6/8] media: platform: mtk-vcodec: Add Mediatek
 V4L2 Video Encoder Driver
To: Tiffany Lin <tiffany.lin@mediatek.com>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will.deacon@arm.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Hongzhou Yang <hongzhou.yang@mediatek.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>,
	Fabien Dessenne <fabien.dessenne@st.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Darren Etheridge <detheridge@ti.com>,
	Peter Griffin <peter.griffin@linaro.org>,
	Benoit Parrot <bparrot@ti.com>
References: <1447764885-23100-1-git-send-email-tiffany.lin@mediatek.com>
 <1447764885-23100-7-git-send-email-tiffany.lin@mediatek.com>
Cc: Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
	Eddie Huang <eddie.huang@mediatek.com>,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	James Liao <jamesjj.liao@mediatek.com>,
	Daniel Hsiao <daniel.hsiao@mediatek.com>,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linux-mediatek@lists.infradead.org
From: Daniel Thompson <daniel.thompson@linaro.org>
Message-ID: <56588622.8060600@linaro.org>
Date: Fri, 27 Nov 2015 16:34:42 +0000
MIME-Version: 1.0
In-Reply-To: <1447764885-23100-7-git-send-email-tiffany.lin@mediatek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tiffany/Andrew

This review is a rather more superficial than my previous one. Mostly 
I'm just commenting on some of the bits I spotted whilst trying to find 
my way around the patchset.

I hope to another more detailed review for v2 (and feel free to add me 
to Cc:).


On 17/11/15 12:54, Tiffany Lin wrote:
 > Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>
> Signed-off-by: Andrew-CT Chen <andrew-ct.chen@mediatek.com>

There is no description of what this patch does. Its not enough to have 
it on the cover letter (because that won't end up in version control). 
You need something here.


> diff --git a/drivers/media/platform/mtk-vcodec/Kconfig b/drivers/media/platform/mtk-vcodec/Kconfig
> new file mode 100644
> index 0000000..1c0b935
> --- /dev/null
> +++ b/drivers/media/platform/mtk-vcodec/Kconfig
> @@ -0,0 +1,5 @@
> +config MEDIATEK_VPU
> +	bool
> +	---help---
> +	  This driver provides downloading firmware vpu (video processor unit)
> +	  and communicating with vpu.

Haven't I seen this before (in patch 3)? Why is it being added to 
another Kconfig file?


> diff --git a/drivers/media/platform/mtk-vcodec/Makefile b/drivers/media/platform/mtk-vcodec/Makefile
> new file mode 100644
> index 0000000..c7f7174
> --- /dev/null
> +++ b/drivers/media/platform/mtk-vcodec/Makefile
> @@ -0,0 +1,12 @@
> +obj-$(CONFIG_VIDEO_MEDIATEK_VCODEC) += mtk_vcodec_intr.o \
> +				       mtk_vcodec_util.o \
> +				       mtk_vcodec_enc_drv.o \
> +				       mtk_vcodec_enc.o \
> +				       mtk_vcodec_enc_pm.o
> +
> +obj-$(CONFIG_VIDEO_MEDIATEK_VCODEC) += common/
> +
> +ccflags-y += -I$(srctree)/drivers/media/platform/mtk-vcodec/include \
> +	     -I$(srctree)/drivers/media/platform/mtk-vcodec \
> +	     -I$(srctree)/drivers/media/platform/mtk-vpu

Seems like there's a lot of directories here. Are these files 
(framework, common, vcodec, etc) so unrelated they really need to live 
in separate directories?

Why not just drivers/media/platform/mediatek?


> diff --git a/drivers/media/platform/mtk-vcodec/common/Makefile b/drivers/media/platform/mtk-vcodec/common/Makefile
> new file mode 100644
> index 0000000..477ab80
> --- /dev/null
> +++ b/drivers/media/platform/mtk-vcodec/common/Makefile
> @@ -0,0 +1,8 @@
> +obj-y += \
> +    venc_drv_if.o
> +
> +ccflags-y += \
> +    -I$(srctree)/include/ \
> +    -I$(srctree)/drivers/media/platform/mtk-vcodec \
> +    -I$(srctree)/drivers/media/platform/mtk-vcodec/include \
> +    -I$(srctree)/drivers/media/platform/mtk-vpu

As above, this appears to be a directory to hold just one file.


 > diff --git a/drivers/media/platform/mtk-vcodec/common/venc_drv_if.c 
b/drivers/media/platform/mtk-vcodec/common/venc_drv_if.c
 > new file mode 100644
 > index 0000000..9b3f025
 > --- /dev/null
 > +++ b/drivers/media/platform/mtk-vcodec/common/venc_drv_if.c
 > @@ -0,0 +1,152 @@
 > +/*
 > + * Copyright (c) 2015 MediaTek Inc.
 > + * Author: Daniel Hsiao <daniel.hsiao@mediatek.com>
 > + *         Jungchang Tsao <jungchang.tsao@mediatek.com>
 > + *
 > + * This program is free software; you can redistribute it and/or
 > + * modify
 > + * it under the terms of the GNU General Public License version 2 as
 > + * published by the Free Software Foundation.
 > + *
 > + * This program is distributed in the hope that it will be useful,
 > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
 > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 > + * GNU General Public License for more details.
 > + */
 > +
 > +#include <linux/interrupt.h>
 > +#include <linux/kernel.h>
 > +#include <linux/slab.h>
 > +
 > +#include "mtk_vcodec_drv.h"
 > +#include "mtk_vcodec_enc.h"
 > +#include "mtk_vcodec_pm.h"
 > +#include "mtk_vcodec_util.h"
 > +#include "mtk_vpu_core.h"
 > +
 > +#include "venc_drv_if.h"
 > +#include "venc_drv_base.h"
 > +
 > +
 > +int venc_if_create(void *ctx, unsigned int fourcc, unsigned long 
*handle)
 > +{
 > +	struct venc_handle *h;
 > +	char str[10];
 > +
 > +	mtk_vcodec_fmt2str(fourcc, str);
 > +
 > +	h = kzalloc(sizeof(*h), GFP_KERNEL);
 > +	if (!h)
 > +		return -ENOMEM;
 > +
 > +	h->fourcc = fourcc;
 > +	h->ctx = ctx;
 > +	mtk_vcodec_debug(h, "fmt = %s handle = %p", str, h);
 > +
 > +	switch (fourcc) {
 > +	default:
 > +		mtk_vcodec_err(h, "invalid format %s", str);
 > +		goto err_out;
 > +	}
 > +
 > +	*handle = (unsigned long)h;
 > +	return 0;
 > +
 > +err_out:
 > +	kfree(h);
 > +	return -EINVAL;
 > +}
 > +
 > +int venc_if_init(unsigned long handle)
 > +{
 > +	int ret = 0;
 > +	struct venc_handle *h = (struct venc_handle *)handle;
 > +
 > +	mtk_vcodec_debug_enter(h);
 > +
 > +	mtk_venc_lock(h->ctx);
 > +	mtk_vcodec_enc_clock_on();
 > +	vpu_enable_clock(vpu_get_plat_device(h->ctx->dev->plat_dev));
 > +	ret = h->enc_if->init(h->ctx, (unsigned long *)&h->drv_handle);
 > +	vpu_disable_clock(vpu_get_plat_device(h->ctx->dev->plat_dev));
 > +	mtk_vcodec_enc_clock_off();
 > +	mtk_venc_unlock(h->ctx);
 > +
 > +	return ret;
 > +}

To me this looks more like an obfuscation layer rather than a 
abstraction layer. I don't understand why we need to hide things from 
the V4L2 implementation that this code forms part of.

More importantly, if this code was included somewhere where it could be 
properly integrated with the device model you might be able to use the 
pm_runtime system to avoid this sort of "heroics" to manage the clocks 
anyway.


> diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_drv.h b/drivers/media/platform/mtk-vcodec/mtk_vcodec_drv.h
> new file mode 100644
> index 0000000..22239f8
> --- /dev/null
> +++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_drv.h
> @@ -0,0 +1,441 @@
> +/*
> +* Copyright (c) 2015 MediaTek Inc.
> +* Author: PC Chen <pc.chen@mediatek.com>
> +*         Tiffany Lin <tiffany.lin@mediatek.com>
> +*
> +* This program is free software; you can redistribute it and/or modify
> +* it under the terms of the GNU General Public License version 2 as
> +* published by the Free Software Foundation.
> +*
> +* This program is distributed in the hope that it will be useful,
> +* but WITHOUT ANY WARRANTY; without even the implied warranty of
> +* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +* GNU General Public License for more details.
> +*/
> +
> +#ifndef _MTK_VCODEC_DRV_H_
> +#define _MTK_VCODEC_DRV_H_
> +
> +#include <linux/platform_device.h>
> +#include <linux/videodev2.h>
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-ioctl.h>
> +#include <media/videobuf2-core.h>
> +#include <media/videobuf2-v4l2.h>
> +
> +#include "venc_drv_if.h"
> +
> +#define MTK_VCODEC_MAX_INSTANCES	32
> +#define MTK_VCODEC_MAX_FRAME_SIZE	0x800000
> +#define MTK_VIDEO_MAX_FRAME		32
> +#define MTK_MAX_CTRLS			10
> +
> +#define MTK_VCODEC_DRV_NAME		"mtk_vcodec_drv"
> +#define MTK_VCODEC_ENC_NAME		"mtk-vcodec-enc"
> +
> +#define MTK_VENC_IRQ_STATUS_SPS          0x1
> +#define MTK_VENC_IRQ_STATUS_PPS          0x2
> +#define MTK_VENC_IRQ_STATUS_FRM          0x4
> +#define MTK_VENC_IRQ_STATUS_DRAM         0x8
> +#define MTK_VENC_IRQ_STATUS_PAUSE        0x10
> +#define MTK_VENC_IRQ_STATUS_SWITCH       0x20

Probably better to use BIT(0) .. BIT(5).


> +#define MTK_VENC_IRQ_STATUS_OFFSET       0x05C
> +#define MTK_VENC_IRQ_ACK_OFFSET          0x060
> +
> +#define MTK_VCODEC_MAX_PLANES		3
> +
> +#define VDEC_HW_ACTIVE	0x10
> +#define VDEC_IRQ_CFG    0x11
> +#define VDEC_IRQ_CLR    0x10
> +
> +#define VDEC_IRQ_CFG_REG	0xa4
> +#define NUM_MAX_ALLOC_CTX  4
> +#define MTK_V4L2_BENCHMARK 0
> +#define USE_ENCODE_THREAD  1
> +
> +/**
> + * enum mtk_hw_reg_idx - MTK hw register base index
> + */
> +enum mtk_hw_reg_idx {
> +	VDEC_SYS,
> +	VDEC_MISC,
> +	VDEC_LD,
> +	VDEC_TOP,
> +	VDEC_CM,
> +	VDEC_AD,
> +	VDEC_AV,
> +	VDEC_PP,
> +	VDEC_HWD,
> +	VDEC_HWQ,
> +	VDEC_HWB,
> +	VDEC_HWG,
> +	NUM_MAX_VDEC_REG_BASE,
> +	VENC_SYS = NUM_MAX_VDEC_REG_BASE,
> +	VENC_LT_SYS,
> +	NUM_MAX_VCODEC_REG_BASE
> +};
> +
> +/**
> + * enum mtk_instance_type - The type of an MTK Vcodec instance.
> + */
> +enum mtk_instance_type {
> +	MTK_INST_DECODER		= 0,
> +	MTK_INST_ENCODER		= 1,
> +};
> +
> +/**
> + * enum mtk_instance_state - The state of an MTK Vcodec instance.
> + * @MTK_STATE_FREE - default state when instance create
> + * @MTK_STATE_CREATE - vdec instance is create
> + * @MTK_STATE_INIT - vdec instance is init
> + * @MTK_STATE_CONFIG - reserved for encoder
> + * @MTK_STATE_HEADER - vdec had sps/pps header parsed
> + * @MTK_STATE_RUNNING - vdec is decoding
> + * @MTK_STATE_FLUSH - vdec is flushing
> + * @MTK_STATE_RES_CHANGE - vdec detect resolution change
> + * @MTK_STATE_FINISH - ctx instance is stopped streaming
> + * @MTK_STATE_DEINIT - before release ctx instance
> + * @MTK_STATE_ERROR - vdec has something wrong
> + * @MTK_STATE_ABORT - abort work in working thread
> + */
> +enum mtk_instance_state {
> +	MTK_STATE_FREE		= 0,
> +	MTK_STATE_CREATE	= (1 << 0),
> +	MTK_STATE_INIT		= (1 << 1),
> +	MTK_STATE_CONFIG	= (1 << 2),
> +	MTK_STATE_HEADER	= (1 << 3),
> +	MTK_STATE_RUNNING	= (1 << 4),
> +	MTK_STATE_FLUSH		= (1 << 5),
> +	MTK_STATE_RES_CHANGE	= (1 << 6),
> +	MTK_STATE_FINISH	= (1 << 7),
> +	MTK_STATE_DEINIT	= (1 << 8),
> +	MTK_STATE_ERROR		= (1 << 9),
> +	MTK_STATE_ABORT		= (1 << 10),

This looks like it started as a state machine and somehow turned into 
flags, resulting in a state machine with 2048 states or, to give it a 
different name, a debugging nightmare.

If the start streaming operation implemented cleanup-on-error properly 
then there would only be two useful states: Started and stopped. Even 
the "sticky" error behavior looks unnecessary to me (meaning we don't 
need to track its state).


> diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
> new file mode 100644
> index 0000000..8e1b6f0
> --- /dev/null
> +++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
> @@ -0,0 +1,1773 @@
> [...]
> +static int vb2ops_venc_start_streaming(struct vb2_queue *q, unsigned int count)
> +{
> +	struct mtk_vcodec_ctx *ctx = vb2_get_drv_priv(q);
> +	struct v4l2_device *v4l2_dev = &ctx->dev->v4l2_dev;
> +	int ret;
> +#if MTK_V4L2_BENCHMARK
> +	struct timeval begin, end;
> +
> +	do_gettimeofday(&begin);
> +#endif
> +
> +	if (!(vb2_start_streaming_called(&ctx->m2m_ctx->out_q_ctx.q) &
> +	      vb2_start_streaming_called(&ctx->m2m_ctx->cap_q_ctx.q))) {
> +		mtk_v4l2_debug(1, "[%d]-> out=%d cap=%d",
> +		 ctx->idx,
> +		 vb2_start_streaming_called(&ctx->m2m_ctx->out_q_ctx.q),
> +		 vb2_start_streaming_called(&ctx->m2m_ctx->cap_q_ctx.q));
> +		return 0;
> +	}
> +
> +	if ((ctx->state & (MTK_STATE_ERROR | MTK_STATE_ABORT)))
> +		return -EINVAL;

This is the sort of thing I mean.

This sticky error behaviour means that every subsequent call to 
vb2ops_venc_start_streaming() will fail. Note also that the user will 
never try to stop streaming (which can clear the error state) because 
according to the return code it got when it tried to start streaming we 
never actually started.

This is what I mean about having two many states. From the user's 
perspective there are only two states. There needs to be a good reason 
for the driver to manage so many extra secret states internally.


> +
> +	if (ctx->state == MTK_STATE_FREE) {
> +		ret = venc_if_create(ctx,
> +				     ctx->q_data[MTK_Q_DATA_DST].fmt->fourcc,
> +				     &ctx->h_enc);
> +
> +		if (ret != 0) {
> +			ctx->state |= MTK_STATE_ERROR;
> +			v4l2_err(v4l2_dev, "invalid codec type=%x\n",
> +				 ctx->q_data[MTK_Q_DATA_DST].fmt->fourcc);
> +			v4l2_err(v4l2_dev, "venc_if_create failed=%d\n", ret);
> +			return -EINVAL;
> +		}
> +
> +		if (ctx->q_data[MTK_Q_DATA_DST].fmt->fourcc ==
> +			V4L2_PIX_FMT_H264)
> +			ctx->hdr = 1;
> +
> +		ctx->state |= MTK_STATE_CREATE;
> +	}
> +
> +	if ((ctx->state & MTK_STATE_CREATE) && !(ctx->state & MTK_STATE_INIT)) {
> +		ret = venc_if_init(ctx->h_enc);
> +		if (ret != 0) {
> +			ctx->state |= MTK_STATE_ERROR;
> +			v4l2_err(v4l2_dev, "venc_if_init failed=%d\n", ret);
> +			return -EINVAL;

This error path leaves the encoder partially constructed and relies on 
something else to tidy things up. It would be much better to tidy things 
up from this function and

Also I don't think both venc_if_create and venc_if_init are needed. They 
are only ever called one after the other and thus they only serve to 
complicate the error handling code.


> diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_util.h b/drivers/media/platform/mtk-vcodec/mtk_vcodec_util.h
> new file mode 100644
> index 0000000..a8e683a
> --- /dev/null
> +++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_util.h
> @@ -0,0 +1,66 @@
> +/*
> +* Copyright (c) 2015 MediaTek Inc.
> +* Author: PC Chen <pc.chen@mediatek.com>
> +*         Tiffany Lin <tiffany.lin@mediatek.com>
> +*
> +* This program is free software; you can redistribute it and/or modify
> +* it under the terms of the GNU General Public License version 2 as
> +* published by the Free Software Foundation.
> +*
> +* This program is distributed in the hope that it will be useful,
> +* but WITHOUT ANY WARRANTY; without even the implied warranty of
> +* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +* GNU General Public License for more details.
> +*/
> +
> +#ifndef _MTK_VCODEC_UTIL_H_
> +#define _MTK_VCODEC_UTIL_H_
> +
> +#include <linux/types.h>
> +#include <linux/dma-direction.h>
> +
> +struct mtk_vcodec_mem {
> +	size_t size;
> +	void *va;
> +	dma_addr_t dma_addr;
> +};
> +
> +extern int mtk_v4l2_dbg_level;
> +extern bool mtk_vcodec_dbg;
> +
> +#define mtk_v4l2_debug(level, fmt, args...)				 \
> +	do {								 \
> +		if (mtk_v4l2_dbg_level >= level)			 \
> +			pr_info("[MTK_V4L2] level=%d %s(),%d: " fmt "\n",\
> +				level, __func__, __LINE__, ##args);	 \
> +	} while (0)
 > +
> +#define mtk_v4l2_err(fmt, args...)                \
> +	pr_err("[MTK_V4L2][ERROR] %s:%d: " fmt "\n", __func__, __LINE__, \
> +	       ##args)

Obviously the code should be structured to make use of dev_dbg/dev_err 
possible.

However where this won't work do you really need special macros for 
this. Assuming your error messages are well written 'git grep' and the 
following should be enough:

#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt


> +#define mtk_v4l2_debug_enter()  mtk_v4l2_debug(5, "+\n")
> +#define mtk_v4l2_debug_leave()  mtk_v4l2_debug(5, "-\n")

Remove these. If you care about function entry and exit for debugging 
you should be able to use ftrace.


> +#define mtk_vcodec_debug(h, fmt, args...)				\
> +	do {								\
> +		if (mtk_vcodec_dbg)					\
> +			pr_info("[MTK_VCODEC][%d]: %s() " fmt "\n",	\
> +				((struct mtk_vcodec_ctx *)h->ctx)->idx, \
> +				__func__, ##args);			\
> +	} while (0)
> +
> +#define mtk_vcodec_err(h, fmt, args...)					\
> +	pr_err("[MTK_VCODEC][ERROR][%d]: %s() " fmt "\n",		\
> +	       ((struct mtk_vcodec_ctx *)h->ctx)->idx, __func__, ##args)
> +
> +#define mtk_vcodec_debug_enter(h)  mtk_vcodec_debug(h, "+\n")
> +#define mtk_vcodec_debug_leave(h)  mtk_vcodec_debug(h, "-\n")

All above comments apply to these too.

