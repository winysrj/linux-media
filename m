Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:11377 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755882AbaIWNbM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Sep 2014 09:31:12 -0400
From: Kamil Debski <k.debski@samsung.com>
To: 'Mikhail Ulyanov' <mikhail.ulyanov@cogentembedded.com>,
	horms@verge.net.au, magnus.damm@gmail.com, m.chehab@samsung.com,
	robh+dt@kernel.org, grant.likely@linaro.org
Cc: laurent.pinchart@ideasonboard.com, hans.verkuil@cisco.com,
	linux-sh@vger.kernel.org, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org
References: <1408452653-14067-2-git-send-email-mikhail.ulyanov@cogentembedded.com>
 <1408969787-23132-1-git-send-email-mikhail.ulyanov@cogentembedded.com>
In-reply-to: <1408969787-23132-1-git-send-email-mikhail.ulyanov@cogentembedded.com>
Subject: RE: [PATCH v2 1/6] V4L2: Add Renesas R-Car JPEG codec driver.
Date: Tue, 23 Sep 2014 15:31:07 +0200
Message-id: <085201cfd732$a2849bd0$e78dd370$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mikhail,

> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Mikhail Ulyanov
> Sent: Monday, August 25, 2014 2:30 PM
> 
> This patch contains driver for Renesas R-Car JPEG codec.
> 
> Cnanges since v1:
>     - s/g_fmt function simplified
>     - default format for queues added
>     - dumb vidioc functions added to be in compliance with standard
> api:
>         jpu_s_priority, jpu_g_priority
>     - standard v4l2_ctrl_subscribe_event and v4l2_event_unsubscribe
>       now in use by the same reason

The patch looks good to me. However, I would suggest using the BIT macro
and making some short functions inline.
 
> Signed-off-by: Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>
> ---
>  drivers/media/platform/Kconfig  |   11 +
>  drivers/media/platform/Makefile |    2 +
>  drivers/media/platform/jpu.c | 1628
> ++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 1641 insertions(+)
>  create mode 100644 drivers/media/platform/jpu.c
> 
> diff --git a/drivers/media/platform/Kconfig
> b/drivers/media/platform/Kconfig index 6d86646..1b8c846 100644
> --- a/drivers/media/platform/Kconfig
> +++ b/drivers/media/platform/Kconfig
> @@ -220,6 +220,17 @@ config VIDEO_RENESAS_VSP1
>  	  To compile this driver as a module, choose M here: the module
>  	  will be called vsp1.
> 
> +config VIDEO_RENESAS_JPU
> +	tristate "Renesas JPEG Processing Unit"
> +	depends on VIDEO_DEV && VIDEO_V4L2
> +	select VIDEOBUF2_DMA_CONTIG
> +	select V4L2_MEM2MEM_DEV
> +	---help---
> +	  This is a V4L2 driver for the Renesas JPEG Processing Unit.
> +
> +	  To compile this driver as a module, choose M here: the module
> +	  will be called jpu.
> +
>  config VIDEO_TI_VPE
>  	tristate "TI VPE (Video Processing Engine) driver"
>  	depends on VIDEO_DEV && VIDEO_V4L2 && SOC_DRA7XX diff --git
> a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
> index e5269da..e438534 100644
> --- a/drivers/media/platform/Makefile
> +++ b/drivers/media/platform/Makefile
> @@ -47,6 +47,8 @@ obj-$(CONFIG_SOC_CAMERA)		+= soc_camera/
> 
>  obj-$(CONFIG_VIDEO_RENESAS_VSP1)	+= vsp1/
> 
> +obj-$(CONFIG_VIDEO_RENESAS_JPU)	+= jpu.o
> +
>  obj-y	+= davinci/
> 
>  obj-$(CONFIG_ARCH_OMAP)	+= omap/
> diff --git a/drivers/media/platform/jpu.c
> b/drivers/media/platform/jpu.c new file mode 100644 index
> 0000000..da70491
> --- /dev/null
> +++ b/drivers/media/platform/jpu.c
> @@ -0,0 +1,1628 @@
> +/*
> + * Author: Mikhail Ulyanov  <source@cogentembedded.com>
> + * Copyright (C) 2014 Cogent Embedded, Inc.
> + * Copyright (C) 2014 Renesas Electronics Corporation
> + *
> + * This is based on the drivers/media/platform/s5p-jpu driver by
> + * Andrzej Pietrasiewicz and Jacek Anaszewski.
> + *
> + * This program is free software; you can redistribute it and/or
> modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/err.h>
> +#include <linux/gfp.h>
> +#include <linux/interrupt.h>
> +#include <linux/io.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_device.h>
> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
> +#include <linux/spinlock.h>
> +#include <linux/string.h>
> +#include <linux/videodev2.h>
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-event.h>
> +#include <media/v4l2-fh.h>
> +#include <media/v4l2-mem2mem.h>
> +#include <media/v4l2-ioctl.h>
> +#include <media/videobuf2-core.h>
> +#include <media/videobuf2-dma-contig.h>
> +
> +
> +#define JPU_M2M_NAME "jpu"
> +
> +#define JPU_WIDTH_MIN		16
> +#define JPU_HEIGHT_MIN		16
> +#define JPU_WIDTH_MAX		4096
> +#define JPU_HEIGHT_MAX		4096
> +#define JPU_DEFAULT_WIDTH	640
> +#define JPU_DEFAULT_HEIGHT	480
> +
> +#define JPU_ENCODE		0
> +#define JPU_DECODE		1
> +
> +/* Flags that indicate a format can be used for capture/output */
> +#define JPU_FMT_TYPE_OUTPUT	0
> +#define JPU_FMT_TYPE_CAPTURE	1
> +#define JPU_ENC_CAPTURE		(1 << 0)
> +#define JPU_ENC_OUTPUT		(1 << 1)
> +#define JPU_DEC_CAPTURE		(1 << 2)
> +#define JPU_DEC_OUTPUT		(1 << 3)

The BIT macro could be used here.

> +
> +/*
> + * JPEG registers and bits
> + */
> +
> +/* JPEG code mode register */
> +#define JCMOD	0x00
> +#define JCMOD_SOI_DISABLE	(1 << 8)
> +#define JCMOD_SOI_ENABLE	(0 << 8)
> +#define JCMOD_PCTR		(1 << 7)
> +#define JCMOD_MSKIP_DISABLE	(0 << 5)
> +#define JCMOD_MSKIP_ENABLE	(1 << 5)
> +#define JCMOD_DSP_ENC		(0 << 3)
> +#define JCMOD_DSP_DEC		(1 << 3)
> +#define JCMOD_REDU		(7 << 0)
> +#define JCMOD_REDU_422		(1 << 0)
> +#define JCMOD_REDU_420		(2 << 0)
> +
> +/* JPEG code command register */
> +#define JCCMD	0x04
> +#define JCCMD_SRST	(1 << 12)
> +#define JCCMD_BRST	(1 << 7)
> +#define JCCMD_JEND	(1 << 2)
> +#define JCCMD_JSRT	(1 << 0)
> +
> +/* JPEG code quantanization table number register */
> +#define JCQTN	0x0C
> +#define JCQTN_SHIFT(t)		(((t) - 1) << 1)
> +
> +/* JPEG code Huffman table number register */
> +#define JCHTN	0x10
> +#define JCHTN_AC_SHIFT(t)	(((t) << 1) - 1)
> +#define JCHTN_DC_SHIFT(t)	(((t) - 1) << 1)
> +

[snip]

> =
> +=====
> + * video ioctl operations
> + *
> +======================================================================
> =
> +=====
> + */
> +static void put_byte(unsigned long *p, u8 v) {
> +	u8 *addr = (u8 *)*p;
> +
> +	*addr = v;
> +	(*p)++;
> +}
> +
> +static void put_short_be(unsigned long *p, u16 v) {
> +	u16 *addr = (u16 *)*p;
> +
> +	*addr = cpu_to_be16(v);
> +	*p += 2;
> +}
> +
> +static void put_word_be(unsigned long *p, u32 v) {
> +	u32 *addr = (u32 *)*p;
> +
> +	*addr = cpu_to_be32(v);
> +	*p += 4;
> +}

The 3 above function could be inline.

> +
> +static void put_blob_byte(unsigned long *p, const unsigned char *blob,
> +			  unsigned int len)
> +{
> +	int i;
> +
> +	for (i = 0; i < len; i++)
> +		put_byte(p, blob[i]);
> +}

I think this function could also be inline.

> +
> +static void put_qtbl(unsigned long *p, unsigned char id,
> +		     const unsigned int *qtbl)
> +{
> +	int i;
> +
> +	put_byte(p, id);
> +	for (i = 0; i < ARRAY_SIZE(zigzag); i++)
> +		put_byte(p, *((u8 *)qtbl + zigzag[i])); }
> +
> +static void put_htbl(unsigned long *p, unsigned char tc,
> +		     const unsigned int *htbl, unsigned int len) {
> +	int i;
> +
> +	put_byte(p, tc);
> +	for (i = 0; i < len; i++)
> +		put_word_be(p, htbl[i]);
> +}
> +

[snip]

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland


