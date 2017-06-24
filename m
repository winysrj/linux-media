Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f48.google.com ([209.85.215.48]:34725 "EHLO
        mail-lf0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755136AbdFXU4M (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 24 Jun 2017 16:56:12 -0400
Received: by mail-lf0-f48.google.com with SMTP id l13so45131358lfl.1
        for <linux-media@vger.kernel.org>; Sat, 24 Jun 2017 13:56:11 -0700 (PDT)
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH v5] media: platform: Renesas IMR driver
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        devicetree@vger.kernel.org, linux-media@vger.kernel.org
References: <20170309200818.786255823@cogentembedded.com>
 <63d45493-5038-7eda-7941-553357ee757b@xs4all.nl>
Cc: linux-renesas-soc@vger.kernel.org,
        Konstantin Kozhevnikov
        <Konstantin.Kozhevnikov@cogentembedded.com>
Message-ID: <a06f0a94-56ca-c9f2-2150-f375c67dffda@cogentembedded.com>
Date: Sat, 24 Jun 2017 23:56:07 +0300
MIME-Version: 1.0
In-Reply-To: <63d45493-5038-7eda-7941-553357ee757b@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello!

On 03/17/2017 05:24 PM, Hans Verkuil wrote:

> Sorry for the long wait before I got around to reviewing this, but here
> are (finally!) my review comments.

    Addressing your comments took significant time too, and I wasn't able to 
address all of them yet...

> On 03/09/17 21:08, Sergei Shtylyov wrote:
>> From: Konstantin Kozhevnikov <Konstantin.Kozhevnikov@cogentembedded.com>
>>
>> The image renderer, or the distortion correction engine, is a drawing
>> processor with a simple instruction system capable of referencing video
>> capture data or data in an external memory as the 2D texture data and
>> performing texture mapping and drawing with respect to any shape that is
>> split into triangular objects.
>>
>> This V4L2 memory-to-memory device driver only supports image renderer light
>> extended 4 (IMR-LX4) found in the R-Car gen3 SoCs; the R-Car gen2 support
>> can be added later...
>>
>> [Sergei: merged 2 original patches, added the patch description, removed
>> unrelated parts,  added the binding document, ported the driver to the
>> modern kernel, renamed the UAPI header file and the  guard macros to match
>> the driver name, extended the copyrights, fixed up Kconfig prompt/depends/
>> help, made use of the BIT/GENMASK() macros, sorted #include's, removed
>> leading  dots and fixed grammar in the comments, fixed up indentation to
>> use tabs where possible, renamed DLSR, CMRCR.DY1{0|2}, and ICR bits to
>> match the manual, changed the prefixes of the CMRCR[2]/TRI{M|C}R bits/
>> fields to match the manual, removed non-existent TRIMR.D{Y|U}D{X|V}M bits,
>> added/used the IMR/{UV|CP}DPOR/SUSR bits/fields/shifts, separated the
>> register offset/bit #define's, sorted the instruction macros by opcode,
>> removed unsupported LINE instruction, masked the register address in
>> WTL[2]/WTS instruction macros, moved the display list #define's after
>> the register #define's, removing the redundant comment, avoided setting
>> reserved bits when writing CMRCCR[2]/TRIMCR, used the SR bits instead of
>> a bare number, used ALIGN() macro in imr_ioctl_map(), removed *inline*
>> from .c file, fixed lines over 80 columns, removed useless spaces,
>> comments, parens, operators, casts, braces, variables, #include's,
>> statements, and even 1 function, uppercased the abbreviations, made
>> comment wording more consistent/correct, fixed the comment typos,
>> reformatted some multiline comments, inserted empty line after declaration,
>> removed extra empty lines, reordered some local variable desclarations,
>> removed calls to 4l2_err() on kmalloc() failure, replaced '*' with 'x'
>> in some format strings for v4l2_dbg(), fixed the error returned by
>> imr_default(), avoided code duplication in the IRQ handler, used
>> '__packed' for the UAPI structures, enclosed the macro parameters in
>> parens, exchanged the values of IMR_MAP_AUTO{S|D}G macros.]
>>
>> Signed-off-by: Konstantin Kozhevnikov <Konstantin.Kozhevnikov@cogentembedded.com>
>> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

[...]

>> Index: media_tree/drivers/media/platform/rcar_imr.c
>> ===================================================================
>> --- /dev/null
>> +++ media_tree/drivers/media/platform/rcar_imr.c
>> @@ -0,0 +1,1943 @@
[...]
>> +/* M2M device processing queue initialization */
>> +static int imr_queue_init(void *priv, struct vb2_queue *src_vq,
>> +			  struct vb2_queue *dst_vq)
>> +{
>> +	struct imr_ctx	*ctx = priv;
>> +	int		ret;
>> +
>> +	memset(src_vq, 0, sizeof(*src_vq));
>> +	src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
>> +	src_vq->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
>> +	src_vq->drv_priv = ctx;
>> +	src_vq->buf_struct_size = sizeof(struct imr_buffer);
>> +	src_vq->ops = &imr_qops;
>> +	src_vq->mem_ops = &vb2_dma_contig_memops;
>> +	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
>> +	src_vq->lock = &ctx->imr->mutex;
[...]
>> +	ret = vb2_queue_init(src_vq);
>> +	if (ret)
>> +		return ret;
>> +
>> +	memset(dst_vq, 0, sizeof(*dst_vq));
>> +	dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>> +	dst_vq->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
>
> Drop VB2_USERPTR here and above. Not recommended to use this with dma-contig.

    Hm... but we need it -- that's what Konstantin has been actively using.

[...]
>> +/* retrieve current queue format; operation is locked? */
>> +static int imr_g_fmt(struct file *file, void *priv, struct v4l2_format *f)
>> +{
>> +	struct imr_ctx		*ctx = fh_to_ctx(priv);
>> +	struct imr_q_data	*q_data;
>> +	struct vb2_queue	*vq;
>> +
>> +	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
>> +	if (!vq)
>> +		return -EINVAL;
>> +
>> +	q_data = &ctx->queue[V4L2_TYPE_IS_OUTPUT(f->type) ? 0 : 1];
>> +
>> +	/* processing is locked? TBD */
>> +	f->fmt.pix = q_data->fmt;
>> +
>> +	return 0;
>> +}
>> +
>> +/* test particular format; operation is not locked */
>> +static int imr_try_fmt(struct file *file, void *priv, struct v4l2_format *f)
>> +{
>> +	struct imr_ctx		*ctx = fh_to_ctx(priv);
>> +	struct vb2_queue	*vq;
>> +
>> +	/* make sure we have a queue of particular type */
>> +	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
>> +	if (!vq)
>> +		return -EINVAL;
>> +
>> +	/* test if format is supported (adjust as appropriate) */
>> +	return __imr_try_fmt(ctx, f) >= 0 ? 0 : -EINVAL;
>> +}
>> +
>> +/* apply queue format; operation is locked? */
>> +static int imr_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
>> +{
>> +	struct imr_ctx		*ctx = fh_to_ctx(priv);
>> +	struct imr_q_data	*q_data;
>> +	struct vb2_queue	*vq;
>> +	int			i;
>> +
>> +	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
>> +	if (!vq)
>> +		return -EINVAL;
>> +
>> +	/* check if queue is busy */
>> +	if (vb2_is_busy(vq))
>> +		return -EBUSY;
>> +
>> +	/* test if format is supported (adjust as appropriate) */
>> +	i = __imr_try_fmt(ctx, f);
>> +	if (i < 0)
>> +		return -EINVAL;
>> +
>> +	/* format is supported; save current format in a queue-specific data */
>> +	q_data = &ctx->queue[V4L2_TYPE_IS_OUTPUT(f->type) ? 0 : 1];
>> +
>> +	/* processing is locked? TBD */
>> +	q_data->fmt = f->fmt.pix;
>> +	q_data->flags = imr_lx4_formats[i].flags;
>> +
>> +	/* set default crop factors */
>> +	if (!V4L2_TYPE_IS_OUTPUT(f->type)) {
>> +		ctx->crop[0] = 0;
>> +		ctx->crop[1] = f->fmt.pix.width - 1;
>> +		ctx->crop[2] = 0;
>> +		ctx->crop[3] = f->fmt.pix.height - 1;
>> +	}
>
> I'm pretty sure v4l2-compliance will complain about missing colorspace fields.

    Don't we have the colorspace field in q_data->fmt?

> drivers/media/platform/vim2m.c gives a good idea how to handle this for m2m
> devices.

    I didn't see much handling there... nothing seems to depend on the 
colorspace...

[...]
>> Index: media_tree/include/uapi/linux/rcar_imr.h
>> ===================================================================
>> --- /dev/null
>> +++ media_tree/include/uapi/linux/rcar_imr.h
>> @@ -0,0 +1,94 @@
>> +/*
>> + * rcar_imr.h -- R-Car IMR-LX4 Driver UAPI
>> + *
>> + * Copyright (C) 2016-2017 Cogent Embedded, Inc. <source@cogentembedded.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License, or
>> + * (at your option) any later version.
>> + */
>> +
>> +#ifndef __RCAR_IMR_H
>> +#define __RCAR_IMR_H
>> +
>> +#include <linux/videodev2.h>
>> +
>> +/*******************************************************************************
>> + * Mapping specification descriptor
>> + ******************************************************************************/
>> +
>> +struct imr_map_desc {
>> +	/* mapping types */
>> +	u32			type;
>> +
>> +	/* total size of the mesh structure */
>> +	u32			size;
>> +
>> +	/* map-specific user-pointer */
>> +	void			*data;
>
> Note that this void pointer would require compat32 support if this IP block
> can be used on a 64-bit arm.

    It was developed on ARM64. :-)
    I've changed the type to __u64 now.

>> +} __packed;
>> +
>> +/* regular mesh specification */
>> +#define IMR_MAP_MESH		(1 << 0)
>> +
>> +/* auto-generated source coordinates */
>> +#define IMR_MAP_AUTOSG		(1 << 1)
>> +
>> +/* auto-generated destination coordinates */
>> +#define IMR_MAP_AUTODG		(1 << 2)
>> +
>> +/* luminance correction flag */
>> +#define IMR_MAP_LUCE		(1 << 3)
>> +
>> +/* chromacity correction flag */
>> +#define IMR_MAP_CLCE		(1 << 4)
>> +
>> +/* vertex clockwise-mode order */
>> +#define IMR_MAP_TCM		(1 << 5)
>> +
>> +/* source coordinate decimal point position bit index */
>> +#define __IMR_MAP_UVDPOR_SHIFT	8
>> +#define __IMR_MAP_UVDPOR(v)	(((v) >> __IMR_MAP_UVDPOR_SHIFT) & 0x7)
>> +#define IMR_MAP_UVDPOR(n)	(((n) & 0x7) << __IMR_MAP_UVDPOR_SHIFT)
>> +
>> +/* destination coordinate sub-pixel mode */
>> +#define IMR_MAP_DDP		(1 << 11)
>> +
>> +/* luminance correction offset decimal point position */
>> +#define __IMR_MAP_YLDPO_SHIFT	12
>> +#define __IMR_MAP_YLDPO(v)	(((v) >> __IMR_MAP_YLDPO_SHIFT) & 0x7)
>> +#define IMR_MAP_YLDPO(n)	(((n) & 0x7) << __IMR_MAP_YLDPO_SHIFT)
>> +
>> +/* chromacity (U) correction offset decimal point position */
>> +#define __IMR_MAP_UBDPO_SHIFT	15
>> +#define __IMR_MAP_UBDPO(v)	(((v) >> __IMR_MAP_UBDPO_SHIFT) & 0x7)
>> +#define IMR_MAP_UBDPO(n)	(((n) & 0x7) << __IMR_MAP_UBDPO_SHIFT)
>> +
>> +/* chromacity (V) correction offset decimal point position */
>> +#define __IMR_MAP_VRDPO_SHIFT	18
>> +#define __IMR_MAP_VRDPO(v)	(((v) >> __IMR_MAP_VRDPO_SHIFT) & 0x7)
>> +#define IMR_MAP_VRDPO(n)	(((n) & 0x7) << __IMR_MAP_VRDPO_SHIFT)
>> +
>> +/* regular mesh specification */
>> +struct imr_mesh {
>> +	/* rectangular mesh size */
>> +	u16			rows, columns;
>> +
>> +	/* mesh parameters */
>> +	u16			x0, y0, dx, dy;
>> +} __packed;
>> +
>> +/* VBO descriptor */
>> +struct imr_vbo {
>> +	/* number of triangles */
>> +	u16			num;
>> +} __packed;
>
> Is this part of the public API? Not clear at all.

    Yes, I've tried to document it... perhaps still not well enough but I 
still didn't grasp the ReST markup enough...

>> +
>> +/*******************************************************************************
>> + * Private IOCTL codes
>> + ******************************************************************************/
>> +
>> +#define VIDIOC_IMR_MESH _IOW('V', BASE_VIDIOC_PRIVATE + 0, struct imr_map_desc)
>
> This needs to be documented. It's not clear at all how this should be used.
> A new file in Documentation/media/v4l-drivers/ is a good place to do that.
>
> I'm not sure how much of the HW documentation is public. If it is, then you can

    It's not public at all, unfortunately.

> refer to that and you just have to explain how to use this ioctl.
>
> Regards,
>
> 	Hans

MBR, Sergei
