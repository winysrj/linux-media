Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:37476 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980Ab3GXKiz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Jul 2013 06:38:55 -0400
Received: by mail-pa0-f48.google.com with SMTP id kp1so499875pab.7
        for <linux-media@vger.kernel.org>; Wed, 24 Jul 2013 03:38:54 -0700 (PDT)
Date: Wed, 24 Jul 2013 19:38:39 +0900 (JST)
Message-Id: <20130724.193839.163790917.matsu@igel.co.jp>
To: laurent.pinchart+renesas@ideasonboard.com
Cc: linux-media@vger.kernel.org, linux-sh@vger.kernel.org,
	hverkuil@xs4all.nl, sakari.ailus@iki.fi
Subject: Re: [PATCH v2 5/5] v4l: Renesas R-Car VSP1 driver
From: Katsuya MATSUBARA <matsu@igel.co.jp>
In-Reply-To: <1374072882-14598-6-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1374072882-14598-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
	<1374072882-14598-6-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi Laurent,

Thank you for your great work for VSP1.
Some comments below.

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Date: Wed, 17 Jul 2013 16:54:42 +0200

(snip)
> +++ b/drivers/media/platform/vsp1/vsp1_drv.c
> +/*
> + * vsp1_drv.c  --  R-Car VSP1 Driver
> + *
> + * Copyright (C) 2013 Renesas Corporation
> + *
> + * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/delay.h>
> +#include <linux/device.h>
> +#include <linux/interrupt.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/videodev2.h>
> +
> +#include "vsp1.h"
> +#include "vsp1_lif.h"
> +#include "vsp1_rwpf.h"
> +#include "vsp1_uds.h"
> +
> +/* -----------------------------------------------------------------------------
> + * Interrupt Handling
> + */
> +
> +static irqreturn_t vsp1_irq_handler(int irq, void *data)
> +{
> +	struct vsp1_device *vsp1 = data;
> +	irqreturn_t ret = IRQ_NONE;
> +	unsigned int i;
> +
> +	for (i = 0; i < VPS1_MAX_WPF; ++i) {
> +		struct vsp1_rwpf *wpf = vsp1->wpf[i];
> +		struct vsp1_pipeline *pipe;
> +		u32 status;
> +
> +		if (wpf == NULL)
> +			continue;
> +
> +		pipe = to_vsp1_pipeline(&wpf->entity.subdev.entity);
> +		status = vsp1_read(vsp1, VI6_WPF_IRQ_STA(i));
> +		vsp1_write(vsp1, VI6_WPF_IRQ_STA(i), ~status);

The value set into the VI6_WPF_IRQ_STA register should be masked
with VI6_WFP_IRQ_STA_FRE since unused (upper) bits in the register
must be written with 0.

(snip)
> +static int vsp1_create_links(struct vsp1_device *vsp1, struct vsp1_entity *sink)
> +{
> +	struct media_entity *entity = &sink->subdev.entity;
> +	struct vsp1_entity *source;
> +	unsigned int pad;
> +	int ret;
> +
> +	list_for_each_entry(source, &vsp1->entities, list_dev) {
> +		u32 flags;
> +
> +		if (source->type == sink->type)
> +			continue;
> +
> +		if (source->type == VSP1_ENTITY_LIF ||
> +		    source->type == VSP1_ENTITY_WPF)
> +			continue;
> +
> +		flags = source->type == VSP1_ENTITY_RPF &&
> +			sink->type == VSP1_ENTITY_WPF &&
> +			source->index == sink->index
> +		      ? MEDIA_LNK_FL_ENABLED : 0;
> +
> +		for (pad = 0; pad < entity->num_pads; ++pad) {
> +			if (!(entity->pads[pad].flags & MEDIA_PAD_FL_SINK))
> +				continue;
> +
> +			ret = media_entity_create_link(&source->subdev.entity,
> +						       source->source_pad,
> +						       entity, pad, flags);
> +			if (ret < 0)
> +				return ret;

This initialization enables some of links as the initial status.
I think link_setup() for each linked entity should be invoked here
to set up the sink value in the vsp_entity structure.

(snip)
> +++ b/drivers/media/platform/vsp1/vsp1_regs.h
> @@ -0,0 +1,581 @@
> +/*
> + * vsp1_regs.h  --  R-Car VSP1 Registers Definitions
> + *
> + * Copyright (C) 2013 Renesas Electronics Corporation
> + *
> + * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2
> + * as published by the Free Software Foundation.
> + */
> +
> +#ifndef __VSP1_REGS_H__
> +#define __VSP1_REGS_H__
> +
(snip)
> +/* -----------------------------------------------------------------------------
> + * HGO Control Registers
> + */
> +
> +#define VI6_HGO_OFFSET			0x3000
> +#define VI6_HGO_SIZE			0x3004
> +#define VI6_HGO_MODE			0x3008
> +#define VI6_HGO_LB_TH			0x300c
> +#define VI6_HGO_LBn_H			(0x3010 + (n) * 8)
> +#define VI6_HGO_LBn_V			(0x3014 + (n) * 8)

It looks like the 'n' argument is missing for VI6_HGO_LBn_H
and VI6_HGO_LBn_V.

> +#define VI6_HGO_R_HISTO			0x3030
> +#define VI6_HGO_R_MAXMIN		0x3130
> +#define VI6_HGO_R_SUM			0x3134
> +#define VI6_HGO_R_LB_DET		0x3138
> +#define VI6_HGO_G_HISTO			0x3140
> +#define VI6_HGO_G_MAXMIN		0x3240
> +#define VI6_HGO_G_SUM			0x3244
> +#define VI6_HGO_G_LB_DET		0x3248
> +#define VI6_HGO_B_HISTO			0x3250
> +#define VI6_HGO_B_MAXMIN		0x3350
> +#define VI6_HGO_B_SUM			0x3354
> +#define VI6_HGO_B_LB_DET		0x3358
> +#define VI6_HGO_REGRST			0x33fc
> +
> +/* -----------------------------------------------------------------------------
> + * HGT Control Registers
> + */
> +
> +#define VI6_HGT_OFFSET			0x3400
> +#define VI6_HGT_SIZE			0x3404
> +#define VI6_HGT_MODE			0x3408
> +#define VI6_HGT_HUE_AREA(n)		(0x340c + (n) * 4)
> +#define VI6_HGT_LB_TH			0x3424
> +#define VI6_HGT_LBn_H			(0x3438 + (n) * 8)
> +#define VI6_HGT_LBn_V			(0x342c + (n) * 8)

The 'n' arguments for VI6_HGT_LBn_H and VI6_HGT_LBn_H are missing too.

(snip)
> +++ b/drivers/media/platform/vsp1/vsp1_video.c
> @@ -0,0 +1,1129 @@
> +/*
> + * vsp1_video.c  --  R-Car VSP1 Video Node
> + *
> + * Copyright (C) 2013 Renesas Corporation
> + *
> + * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +
(snip)
> +static int __vsp1_video_try_format(struct vsp1_video *video,
> +				   struct v4l2_pix_format_mplane *pix,
> +				   const struct vsp1_format_info **fmtinfo)
> +{
> +	const struct vsp1_format_info *info;
> +	unsigned int width = pix->width;
> +	unsigned int height = pix->height;
> +	unsigned int i;
> +
> +	/* Retrieve format information and select the default format if the
> +	 * requested format isn't supported.
> +	 */
> +	info = vsp1_get_format_info(pix->pixelformat);
> +	if (info == NULL)
> +		info = vsp1_get_format_info(VSP1_VIDEO_DEF_FORMAT);
> +
> +	pix->pixelformat = info->fourcc;
> +	pix->colorspace = V4L2_COLORSPACE_SRGB;
> +	pix->field = V4L2_FIELD_NONE;
> +	memset(pix->reserved, 0, sizeof(pix->reserved));
> +
> +	/* Align the width and height for YUV 4:2:2 and 4:2:0 formats. */
> +	width = round_down(width, info->hsub);
> +	height = round_down(height, info->vsub);
> +
> +	/* Clamp the width and height. */
> +	pix->width = clamp(width, VSP1_VIDEO_MIN_WIDTH, VSP1_VIDEO_MAX_WIDTH);
> +	pix->height = clamp(height, VSP1_VIDEO_MIN_HEIGHT,
> +			    VSP1_VIDEO_MAX_HEIGHT);
> +
> +	/* Compute and clamp the stride and image size. */
> +	for (i = 0; i < max(info->planes, 2U); ++i) {
> +		unsigned int hsub = i > 0 ? info->hsub : 1;
> +		unsigned int vsub = i > 0 ? info->vsub : 1;
> +		unsigned int bpl;
> +
> +		bpl = clamp_t(unsigned int, pix->plane_fmt[i].bytesperline,
> +			      pix->width / hsub * info->bpp[i] / 8,
> +			      round_down(65535U, 128));
> +
> +		pix->plane_fmt[i].bytesperline = round_up(bpl, 128);

I am not sure why 'bytesperlines' should be aligned to 128 bytes.
VSP1 doesn't seem to have this limitation.

> +		pix->plane_fmt[i].sizeimage = bpl * pix->height / vsub;

If the round up for bytesperlines is required, sizeimage should be
calculated with 'bytesperline' rather than 'bpl'.


Actually, I had been implementing a V4L2 MEM2MEM driver for VIO6,
which is an older version of the VSP1 used by many of the current
Renesas SoCs.
VSP1 should be compatible with VIO6, so I rebased my work onto your
implementation. I will post a patch to add support of VIO6 for your
code once it is finished.

Thanks,
---
Katsuya Matsubara / IGEL Co., Ltd
matsu@igel.co.jp
