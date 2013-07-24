Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:53577 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105Ab3GXPEv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Jul 2013 11:04:51 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Katsuya MATSUBARA <matsu@igel.co.jp>, linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org, hverkuil@xs4all.nl, sakari.ailus@iki.fi
Subject: Re: [PATCH v2 5/5] v4l: Renesas R-Car VSP1 driver
Date: Wed, 24 Jul 2013 17:05:43 +0200
Message-ID: <3737951.fX1QYhsRI3@avalon>
In-Reply-To: <20130724.193839.163790917.matsu@igel.co.jp>
References: <1374072882-14598-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1374072882-14598-6-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <20130724.193839.163790917.matsu@igel.co.jp>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart3885685.ncbDHhtpAO"
Content-Transfer-Encoding: 7Bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.

--nextPart3885685.ncbDHhtpAO
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi Matsubara-san,

On Wednesday 24 July 2013 19:38:39 Katsuya MATSUBARA wrote:
> Hi Laurent,
> 
> Thank you for your great work for VSP1.
> Some comments below.

Thank you for the review.

> From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> Date: Wed, 17 Jul 2013 16:54:42 +0200
> 
> (snip)
> 
> > +++ b/drivers/media/platform/vsp1/vsp1_drv.c
> > +/*
> > + * vsp1_drv.c  --  R-Car VSP1 Driver
> > + *
> > + * Copyright (C) 2013 Renesas Corporation
> > + *
> > + * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License as published by
> > + * the Free Software Foundation; either version 2 of the License, or
> > + * (at your option) any later version.
> > + */
> > +
> > +#include <linux/clk.h>
> > +#include <linux/delay.h>
> > +#include <linux/device.h>
> > +#include <linux/interrupt.h>
> > +#include <linux/module.h>
> > +#include <linux/platform_device.h>
> > +#include <linux/videodev2.h>
> > +
> > +#include "vsp1.h"
> > +#include "vsp1_lif.h"
> > +#include "vsp1_rwpf.h"
> > +#include "vsp1_uds.h"
> > +
> > +/*
> > -------------------------------------------------------------------------
> > ---- + * Interrupt Handling
> > + */
> > +
> > +static irqreturn_t vsp1_irq_handler(int irq, void *data)
> > +{
> > +	struct vsp1_device *vsp1 = data;
> > +	irqreturn_t ret = IRQ_NONE;
> > +	unsigned int i;
> > +
> > +	for (i = 0; i < VPS1_MAX_WPF; ++i) {
> > +		struct vsp1_rwpf *wpf = vsp1->wpf[i];
> > +		struct vsp1_pipeline *pipe;
> > +		u32 status;
> > +
> > +		if (wpf == NULL)
> > +			continue;
> > +
> > +		pipe = to_vsp1_pipeline(&wpf->entity.subdev.entity);
> > +		status = vsp1_read(vsp1, VI6_WPF_IRQ_STA(i));
> > +		vsp1_write(vsp1, VI6_WPF_IRQ_STA(i), ~status);
> 
> The value set into the VI6_WPF_IRQ_STA register should be masked with
> VI6_WFP_IRQ_STA_FRE since unused (upper) bits in the register must be
> written with 0.

Good point. I'll fix that.

> > +static int vsp1_create_links(struct vsp1_device *vsp1, struct vsp1_entity
> > *sink) +{
> > +	struct media_entity *entity = &sink->subdev.entity;
> > +	struct vsp1_entity *source;
> > +	unsigned int pad;
> > +	int ret;
> > +
> > +	list_for_each_entry(source, &vsp1->entities, list_dev) {
> > +		u32 flags;
> > +
> > +		if (source->type == sink->type)
> > +			continue;
> > +
> > +		if (source->type == VSP1_ENTITY_LIF ||
> > +		    source->type == VSP1_ENTITY_WPF)
> > +			continue;
> > +
> > +		flags = source->type == VSP1_ENTITY_RPF &&
> > +			sink->type == VSP1_ENTITY_WPF &&
> > +			source->index == sink->index
> > +		      ? MEDIA_LNK_FL_ENABLED : 0;
> > +
> > +		for (pad = 0; pad < entity->num_pads; ++pad) {
> > +			if (!(entity->pads[pad].flags & MEDIA_PAD_FL_SINK))
> > +				continue;
> > +
> > +			ret = media_entity_create_link(&source->subdev.entity,
> > +						       source->source_pad,
> > +						       entity, pad, flags);
> > +			if (ret < 0)
> > +				return ret;
> 
> This initialization enables some of links as the initial status.
> I think link_setup() for each linked entity should be invoked here
> to set up the sink value in the vsp_entity structure.
> 
> (snip)
> 
> > +++ b/drivers/media/platform/vsp1/vsp1_regs.h
> > @@ -0,0 +1,581 @@
> > +/*
> > + * vsp1_regs.h  --  R-Car VSP1 Registers Definitions
> > + *
> > + * Copyright (C) 2013 Renesas Electronics Corporation
> > + *
> > + * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2
> > + * as published by the Free Software Foundation.
> > + */
> > +
> > +#ifndef __VSP1_REGS_H__
> > +#define __VSP1_REGS_H__
> > +
> 
> (snip)
> 
> > +/*
> > -------------------------------------------------------------------------
> > ---- + * HGO Control Registers
> > + */
> > +
> > +#define VI6_HGO_OFFSET			0x3000
> > +#define VI6_HGO_SIZE			0x3004
> > +#define VI6_HGO_MODE			0x3008
> > +#define VI6_HGO_LB_TH			0x300c
> > +#define VI6_HGO_LBn_H			(0x3010 + (n) * 8)
> > +#define VI6_HGO_LBn_V			(0x3014 + (n) * 8)
> 
> It looks like the 'n' argument is missing for VI6_HGO_LBn_H
> and VI6_HGO_LBn_V.

Will fix as well.

> > +#define VI6_HGO_R_HISTO			0x3030
> > +#define VI6_HGO_R_MAXMIN		0x3130
> > +#define VI6_HGO_R_SUM			0x3134
> > +#define VI6_HGO_R_LB_DET		0x3138
> > +#define VI6_HGO_G_HISTO			0x3140
> > +#define VI6_HGO_G_MAXMIN		0x3240
> > +#define VI6_HGO_G_SUM			0x3244
> > +#define VI6_HGO_G_LB_DET		0x3248
> > +#define VI6_HGO_B_HISTO			0x3250
> > +#define VI6_HGO_B_MAXMIN		0x3350
> > +#define VI6_HGO_B_SUM			0x3354
> > +#define VI6_HGO_B_LB_DET		0x3358
> > +#define VI6_HGO_REGRST			0x33fc
> > +
> > +/*
> > -------------------------------------------------------------------------
> > ---- + * HGT Control Registers
> > + */
> > +
> > +#define VI6_HGT_OFFSET			0x3400
> > +#define VI6_HGT_SIZE			0x3404
> > +#define VI6_HGT_MODE			0x3408
> > +#define VI6_HGT_HUE_AREA(n)		(0x340c + (n) * 4)
> > +#define VI6_HGT_LB_TH			0x3424
> > +#define VI6_HGT_LBn_H			(0x3438 + (n) * 8)
> > +#define VI6_HGT_LBn_V			(0x342c + (n) * 8)
> 
> The 'n' arguments for VI6_HGT_LBn_H and VI6_HGT_LBn_H are missing too.

Will fix as well.

> (snip)
> 
> > +++ b/drivers/media/platform/vsp1/vsp1_video.c
> > @@ -0,0 +1,1129 @@
> > +/*
> > + * vsp1_video.c  --  R-Car VSP1 Video Node
> > + *
> > + * Copyright (C) 2013 Renesas Corporation
> > + *
> > + * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License as published by
> > + * the Free Software Foundation; either version 2 of the License, or
> > + * (at your option) any later version.
> > + */
> > +
> 
> (snip)
> 
> > +static int __vsp1_video_try_format(struct vsp1_video *video,
> > +				   struct v4l2_pix_format_mplane *pix,
> > +				   const struct vsp1_format_info **fmtinfo)
> > +{
> > +	const struct vsp1_format_info *info;
> > +	unsigned int width = pix->width;
> > +	unsigned int height = pix->height;
> > +	unsigned int i;
> > +
> > +	/* Retrieve format information and select the default format if the
> > +	 * requested format isn't supported.
> > +	 */
> > +	info = vsp1_get_format_info(pix->pixelformat);
> > +	if (info == NULL)
> > +		info = vsp1_get_format_info(VSP1_VIDEO_DEF_FORMAT);
> > +
> > +	pix->pixelformat = info->fourcc;
> > +	pix->colorspace = V4L2_COLORSPACE_SRGB;
> > +	pix->field = V4L2_FIELD_NONE;
> > +	memset(pix->reserved, 0, sizeof(pix->reserved));
> > +
> > +	/* Align the width and height for YUV 4:2:2 and 4:2:0 formats. */
> > +	width = round_down(width, info->hsub);
> > +	height = round_down(height, info->vsub);
> > +
> > +	/* Clamp the width and height. */
> > +	pix->width = clamp(width, VSP1_VIDEO_MIN_WIDTH, 
VSP1_VIDEO_MAX_WIDTH);
> > +	pix->height = clamp(height, VSP1_VIDEO_MIN_HEIGHT,
> > +			    VSP1_VIDEO_MAX_HEIGHT);
> > +
> > +	/* Compute and clamp the stride and image size. */
> > +	for (i = 0; i < max(info->planes, 2U); ++i) {
> > +		unsigned int hsub = i > 0 ? info->hsub : 1;
> > +		unsigned int vsub = i > 0 ? info->vsub : 1;
> > +		unsigned int bpl;
> > +
> > +		bpl = clamp_t(unsigned int, pix->plane_fmt[i].bytesperline,
> > +			      pix->width / hsub * info->bpp[i] / 8,
> > +			      round_down(65535U, 128));
> > +
> > +		pix->plane_fmt[i].bytesperline = round_up(bpl, 128);
> 
> I am not sure why 'bytesperlines' should be aligned to 128 bytes. VSP1
> doesn't seem to have this limitation.

If I recall correctly, strides lower than 128 pixels resulted in corruption in 
the output image. Please see the attached file for an example. That was in the 
beginning of VSP1 development so the problem might have been unrelated and 
fixed by something completely different, it would be worth it retrying with 
different alignment values.

> > +		pix->plane_fmt[i].sizeimage = bpl * pix->height / vsub;
> 
> If the round up for bytesperlines is required, sizeimage should be
> calculated with 'bytesperline' rather than 'bpl'.

Indeed, I will fix that.

> Actually, I had been implementing a V4L2 MEM2MEM driver for VIO6, which is
> an older version of the VSP1 used by many of the current Renesas SoCs.
>
> VSP1 should be compatible with VIO6, so I rebased my work onto your
> implementation. I will post a patch to add support of VIO6 for your code
> once it is finished.

That would be great, thank you. By the way, I plan to post patches to enable 
HST, HSI, SRU and LUT support next week.

-- 
Regards,

Laurent Pinchart

--nextPart3885685.ncbDHhtpAO
Content-Disposition: attachment; filename="frame-000007.png"
Content-Transfer-Encoding: base64
Content-Type: image/png; name="frame-000007.png"

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
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAPAKAPi4ez7bT3sAAGBTAHze
Fb3yy/7Nfv91d0uH3jwAEgAAtgiABCABAKBhACQACQAADQMgAQAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAUzV0AAGwRAHcBJAAANAyABCABAKBhACQACQAADQMgAUgAAGgYAAlAAgBAwwBIABIAABoGQAKQ
AADQMAASgAQAgIYBkAAkAAA0DIAEIAEAoGEAJAAJAAANAyABSAAAaBgACUACAEDDAEgAEgAAGgZA
ApAAANAwABKABACAhgGQACQAADQMgAQgAQCgYQAkAAkAAA0DIAFIAABoGAAJQAIAQMMASAAAAAAA
AAAAAAAAAKvNGAAAtgiAMQAJAAANAyABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAPDKAfi4ez7bT3sAAGBTAHzeFb3yy/7Nfv91d0uH3jwAEgAA
tgiABCABAKBhACQACQAADQMgAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACAxgFQBwCA
LQKgDkACAEDDAEgAEgAAGgZAApAAANAwABIAAAAAAAAAAAAAAMBqMwYAgC0CYAxAAgBAwwBIABIA
ABoGQAKQAADQMAASgAQAgIYBkAAkAAA0DIAEIAEAoGEAJAAJAAANAyABSAAAaBgACUACAEDDAEgA
EgAAGgZAApAAANAwABKABACAhgGQACQAADQMgAQgAQCgYQAkAAkAAA0DIAEAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAPDCAHzcPZ/tpz0AALApAD7vil75Zf9mv/+6u6VDbx4ACQAAWwRAApAA
ANAwABKABACAhgGQACQAADQMgAQgAQCgYQAkAAkAAA0DIAFIAABoGAAJQAIAQMMASAASAAAaBkAC
AAAAAAAAAAAAAABYbcYAALBFAIwBSAAAaBgACUACAEDDAEgAEgAAGgZAAgAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAB3AMDegADYIgD2BpQAANAwABIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABoAABzAQCwRQDMBZAAANAwABKABACAhgGQACQA
ADQMgAQAAAAAAAAAAAAAALDajAEAYIsAGAOQAADQMAASAAAAAAAAAAAAAADAajMGAIAtAmAMQAIA
QMMASAAAAAAAAAAAAAAAAKvNGAAAtgiAMQAJAAANAyABSAAAaBgACUACAEDDAEgAEgAAGgZAApAA
ANAwABKABACAhgGQACQAADQMgAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAwEr7uHs+2097AABgUwB83hW98sv+
zX7/dXdLh948ABIAALYIgAQgAQCgYQAkAAkAAA0DIAFIAABoGAAJQAIAQMMASAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAC8
OgA+7p7P9tMeAADYFACfd0Wv/LJ/s99/3d3SoTcPgAQAgC0CIAEAAAAAAAAAAAAAAKw2YwAA2CIA
xgAkAAA0DIAEIAEAoGEAJAAJAAANAyABSAAAaBgACUACAEDDAEgAEgAAGgZAApAAANAwABKABACA
hgGQACQAADQMgAQgAQCgYQAkAAkAAA0DIAFIAABoGAAJQAIAQMMASAAAAAAAAAAAAAAAAKvNGAAA
tgiAMQAJAAANAyABSAAAaBgACUACAEDDAEgAEgAAGgZAApAAANAwABIAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAaA4AlYAA2CIAKgElAAA0DIAEIAEAoGEAJAAJAAAN
AyABSAAAaBgACUACAEDDAEgAEgAAGgZAApAAANAwABKABACAhgGQACQAADQMgAQgAQCgYQAkAAkA
AA0DIAFIAABoGAAJQAIAQMMASAASAAAaBkACkAAA0DAAEoAEAICGAZAAJAAANAyABCABAKBhACQA
CQAADQMgAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAIDmAFAJCIAt
AqASUAIAQMMASAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADgQvu4ez7bT3sA
AGBTAHzeFb3yy/7Nfv91d0uH3jwAEgAAtgiABAAAAAAAAAAAAAAAsNqMAQBgiwAYA5AAANAwABKA
BACAhgGQACQAADQMgAQgAQCgYQAkAAkAAA0DIAEAAAAAAAAAAAAAAKw2YwAA2CIAxgAkAAA0DIAE
IAEAoGEAJAAJAAANAyABSAAAaBgACUACAEDDAEgAEgAAGgZAApAAANAwABKABACAhgGQACQAADQM
gAQAAAAAAAAAAAAAALDajAEAYIsAGAOQAADQMAASgAQAgIYBkAAkAAA0DIAEIAEAoGEAJAAJAAAN
AyABSAAAaBgACUACAEDDAEgAEgAAGgZAApAAANAwABKABACAhgGQACQAADQMgAQgAQCgYQAkAAkA
AA0DIAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AADAD27/D4hQ45L5yriVAAAAJXRFWHRkYXRlOmNyZWF0ZQAyMDEzLTA2LTEzVDAxOjI2OjI0KzAy
OjAw5DR9ywAAACV0RVh0ZGF0ZTptb2RpZnkAMjAxMy0wNi0xM1QwMToyNjoyNCswMjowMJVpxXcA
AAAASUVORK5CYII=

--nextPart3885685.ncbDHhtpAO--

