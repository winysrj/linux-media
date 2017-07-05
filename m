Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f46.google.com ([209.85.215.46]:34704 "EHLO
        mail-lf0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752403AbdGEVBp (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 5 Jul 2017 17:01:45 -0400
Received: by mail-lf0-f46.google.com with SMTP id t72so514261lff.1
        for <linux-media@vger.kernel.org>; Wed, 05 Jul 2017 14:01:44 -0700 (PDT)
Subject: Re: [PATCH v6] media: platform: Renesas IMR driver
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        devicetree@vger.kernel.org, linux-media@vger.kernel.org
References: <20170623203456.503714406@cogentembedded.com>
 <1be1bbb3-1503-022a-ec15-5b9bf759dff8@xs4all.nl>
Cc: linux-renesas-soc@vger.kernel.org,
        Konstantin Kozhevnikov
        <Konstantin.Kozhevnikov@cogentembedded.com>
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <3e8157e9-9be6-902f-2481-1d0cf1e9db3e@cogentembedded.com>
Date: Thu, 6 Jul 2017 00:01:40 +0300
MIME-Version: 1.0
In-Reply-To: <1be1bbb3-1503-022a-ec15-5b9bf759dff8@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello!

On 07/03/2017 03:25 PM, Hans Verkuil wrote:

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
>> [Sergei: merged 2 original patches, added  the patch description, removed
>> unrelated parts,  added the binding document and the UAPI documentation,
>> ported the driver to the modern kernel, renamed the UAPI header file and
>> the guard macros to match the driver name, extended the copyrights, fixed
>> up Kconfig prompt/depends/help, made use of the BIT/GENMASK() macros,
>> sorted  #include's, replaced 'imr_ctx::crop' array with the 'imr_ctx::rect'
>> structure, replaced imr_{g|s}_crop() with imr_{g|s}_selection(), completely
>> rewrote imr_queue_setup(), removed 'imr_format_info::name', moved the
>> applicable code from imr_buf_queue() to imr_buf_prepare() and moved the
>> rest of imr_buf_queue() after imr_buf_finish(), assigned 'src_vq->dev' and
>> 'dst_vq->dev' in imr_queue_init(), removed imr_start_streaming(), assigned
>> 'src_vq->dev' and 'dst_vq->dev' in imr_queue_init(), clarified the math in
>> imt_tri_type_{a|b|c}_length(), clarified the pointer math and avoided casts
>> to 'void *' in imr_tri_set_type_{a|b|c}(), replaced imr_{reqbufs|querybuf|
>> dqbuf|expbuf|streamon|streamoff}() with the generic helpers, implemented
>> vidioc_{create_bufs|prepare_buf}() methods, used ALIGN() macro and merged
>> the matrix size checks and replaced kmalloc()/copy_from_user() calls with
>> memdup_user() call in imr_ioctl_map(), moved setting device capabilities
>> from imr_querycap() to imr_probe(), set the valid default queue format in
>> imr_probe(), removed leading dots and fixed grammar in the comments, fixed
>> up  the indentation  to use  tabs where possible, renamed DLSR, CMRCR.
>> DY1{0|2}, and ICR bits to match the manual, changed the prefixes of the
>> CMRCR[2]/TRI{M|C}R bits/fields to match the manual, removed non-existent
>> TRIMR.D{Y|U}D{X|V}M bits, added/used the IMR/{UV|CP}DPOR/SUSR bits/fields/
>> shifts, separated the register offset/bit #define's, sorted instruction
>> macros by opcode, removed unsupported LINE instruction, masked the register
>> address in WTL[2]/WTS instruction macros, moved the display list #define's
>> after the register #define's, removing the redundant comment, avoided
>> setting reserved bits when writing CMRCCR[2]/TRIMCR, used the SR bits
>> instead of a bare number, removed *inline* from .c file, fixed lines over
>> 80 columns, removed useless spaces, comments, parens, operators, casts,
>> braces, variables, #include's, statements, and even 1 function, added
>> useful local variable, uppercased and spelled out the abbreviations,
>> made comment wording more consistent/correct, fixed the comment typos,
>> reformatted some multiline comments, inserted empty line after declaration,
>> removed extra empty lines,  reordered some local variable desclarations,
>> removed calls to 4l2_err() on kmalloc() failure, replaced '*' with 'x'
>> in some format strings for v4l2_dbg(), fixed the error returned by
>> imr_default(), avoided code duplication in the IRQ handler, used '__packed'
>> for the UAPI structures, declared 'imr_map_desc::data' as '__u64' instead
>> of 'void *', switched to '__u{16|32}' in the UAPI header, enclosed the
>> macro parameters in parens, exchanged the values of IMR_MAP_AUTO{S|D}G
>> macros.]
>
> As Geert suggested, just replace this with a 'Based-on' line.

    OK, the list grew too long indeed. :-)

> <snip>
>
>> Index: media_tree/drivers/media/platform/rcar_imr.c
>> ===================================================================
>> --- /dev/null
>> +++ media_tree/drivers/media/platform/rcar_imr.c
>> @@ -0,0 +1,1877 @@
>
> <snip>
>
>> +/* add reference to the current configuration */
>> +static struct imr_cfg *imr_cfg_ref(struct imr_ctx *ctx)
>
> imr_cfg_ref -> imr_cfg_ref_get

    OK, but imr_cfg_get() seems a better name.

>> +{
>> +    struct imr_cfg *cfg = ctx->cfg;
>> +
>> +    BUG_ON(!cfg);
>
> Perhaps this can be replaced by:
>
>     if (WARN_ON(!cfg))
>         return NULL;

    I'm afraid imr_device_run() will cause oops in this case...

>> +    cfg->refcount++;
>> +    return cfg;
>> +}
>> +
>> +/* mesh configuration destructor */
>> +static void imr_cfg_unref(struct imr_ctx *ctx, struct imr_cfg *cfg)
>
> imr_cfg_unref -> imr_cfg_ref_put

   OK, but I'll call it imr_cfg_put().

> That follows the standard naming conventions for refcounting.
>
>> +{
>> +    struct imr_device *imr = ctx->imr;
>> +
>> +    /* no atomicity is required as operation is locked with device mutex */
>> +    if (!cfg || --cfg->refcount)
>> +        return;
>> +
>> +    /* release memory allocated for a display list */
>> +    if (cfg->dl_vaddr)
>> +        dma_free_writecombine(imr->dev, cfg->dl_size, cfg->dl_vaddr,
>> +                      cfg->dl_dma_addr);
>> +
>> +    /* destroy the configuration structure */
>> +    kfree(cfg);
>
> Add:
>     ctx->cfg = NULL;

   Thanks, makes sense indeed.

[...]
>> +static int imr_qbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
>> +{
>> +    struct imr_ctx *ctx = fh_to_ctx(priv);
>> +
>> +    /* operation is protected with a queue lock */
>> +    WARN_ON(!mutex_is_locked(&ctx->imr->mutex));
>
> It's guaranteed by the V4L2 core, so this can be dropped safely.
>
>> +
>> +    /* verify the configuration is complete */
>> +    if (!ctx->cfg) {
>> +        v4l2_err(&ctx->imr->v4l2_dev,
>> +             "stream configuration is not complete\n");
>> +        return -EINVAL;
>> +    }
>
> Shouldn't this test be done in the buf_prepare callback above? It's
> what buf_prepare is for.
>
> Then you can drop this function and use the helper function instead.

    OK, will look into this...

>> +
>> +    return v4l2_m2m_qbuf(file, ctx->m2m_ctx, buf);
>> +}
[...]
>> +static unsigned int imr_poll(struct file *file, struct poll_table_struct
>> *wait)
>> +{
>> +    struct imr_ctx        *ctx = fh_to_ctx(file->private_data);
>> +    struct imr_device    *imr = video_drvdata(file);
>> +    unsigned int        res;
>> +
>> +    if (mutex_lock_interruptible(&imr->mutex))
>> +        return -ERESTARTSYS;
>> +
>> +    res = v4l2_m2m_poll(file, ctx->m2m_ctx, wait);
>> +    mutex_unlock(&imr->mutex);
>> +
>> +    return res;
>> +}
>
> Set the struct v4l2_m2m_ctx q_lock field to imr->mutex.
>
> Then you can use v4l2_m2m_fop_poll instead.

    Will look into this.

>> +
>> +static int imr_mmap(struct file *file, struct vm_area_struct *vma)
>> +{
>> +    struct imr_device    *imr = video_drvdata(file);
>> +    struct imr_ctx        *ctx = fh_to_ctx(file->private_data);
>> +    int            ret;
>> +
>> +    /* should we protect all M2M operations with mutex? - TBD */
>> +    if (mutex_lock_interruptible(&imr->mutex))
>> +        return -ERESTARTSYS;
>> +
>> +    ret = v4l2_m2m_mmap(file, ctx->m2m_ctx, vma);
>> +
>> +    mutex_unlock(&imr->mutex);
>> +
>> +    return ret;
>> +}
>
> Use v4l2_m2m_fop_mmap. And this is one file operation where you shouldn't lock.
> The vb2 core has a special mutex to handle this.

    OK, will see.

[...]
>> +/*******************************************************************************
>>
>> + * Device probing/removal interface
>> +
>> ******************************************************************************/
>> +
>> +static int imr_probe(struct platform_device *pdev)
>> +{
>> +    struct imr_device    *imr;
>> +    struct resource        *res;
>> +    int            ret;
>> +
>> +    imr = devm_kzalloc(&pdev->dev, sizeof(*imr), GFP_KERNEL);
>> +    if (!imr)
>> +        return -ENOMEM;
>> +
>> +    mutex_init(&imr->mutex);
>> +    spin_lock_init(&imr->lock);
>> +    imr->dev = &pdev->dev;
>> +
>> +    /* memory-mapped registers */
>> +    res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +    imr->mmio = devm_ioremap_resource(&pdev->dev, res);
>> +    if (IS_ERR(imr->mmio))
>> +        return PTR_ERR(imr->mmio);
>> +
>> +    /* interrupt service routine registration */
>> +    imr->irq = ret = platform_get_irq(pdev, 0);
>> +    if (ret < 0) {
>> +        dev_err(&pdev->dev, "cannot find IRQ\n");
>> +        return ret;
>> +    }
>> +
>> +    ret = devm_request_irq(&pdev->dev, imr->irq, imr_irq_handler, 0,
>> +                   dev_name(&pdev->dev), imr);
>> +    if (ret) {
>> +        dev_err(&pdev->dev, "cannot claim IRQ %d\n", imr->irq);
>> +        return ret;
>> +    }
>> +
>> +    imr->clock = devm_clk_get(&pdev->dev, NULL);
>> +    if (IS_ERR(imr->clock)) {
>> +        dev_err(&pdev->dev, "cannot get clock\n");
>> +        return PTR_ERR(imr->clock);
>> +    }
>> +
>> +    /* create v4l2 device */
>> +    ret = v4l2_device_register(&pdev->dev, &imr->v4l2_dev);
>> +    if (ret) {
>> +        dev_err(&pdev->dev, "Failed to register v4l2 device\n");
>> +        return ret;
>> +    }
>> +
>> +    /* create mem2mem device handle */
>> +    imr->m2m_dev = v4l2_m2m_init(&imr_m2m_ops);
>> +    if (IS_ERR(imr->m2m_dev)) {
>> +        v4l2_err(&imr->v4l2_dev, "Failed to init mem2mem device\n");
>> +        ret = PTR_ERR(imr->m2m_dev);
>> +        goto device_register_rollback;
>> +    }
>> +
>> +    strlcpy(imr->video_dev.name, dev_name(&pdev->dev),
>> +        sizeof(imr->video_dev.name));
>> +    imr->video_dev.fops        = &imr_fops;
>> +    imr->video_dev.device_caps  = V4L2_CAP_VIDEO_CAPTURE |
>> +                      V4L2_CAP_VIDEO_OUTPUT |
>> +                      V4L2_CAP_VIDEO_M2M | V4L2_CAP_STREAMING;
>
> Only specify V4L2_CAP_VIDEO_M2M | V4L2_CAP_STREAMING.
> M2M cannot be combined with CAPTURE and OUTPUT.

    OK, sorry about that...

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
>>
>> + * Mapping specification descriptor
>> +
>> ******************************************************************************/
>> +
>> +struct imr_map_desc {
>> +    /* mapping types */
>> +    __u32            type;
>> +
>> +    /* total size of the mesh structure */
>> +    __u32            size;
>> +
>> +    /* map-specific user-pointer */
>> +    __u64            data;
>> +} __packed;
>> +
>> +/* regular mesh specification */
>> +#define IMR_MAP_MESH        (1 << 0)
>> +
>> +/* auto-generated source coordinates */
>> +#define IMR_MAP_AUTOSG        (1 << 1)
>> +
>> +/* auto-generated destination coordinates */
>> +#define IMR_MAP_AUTODG        (1 << 2)
>> +
>> +/* luminance correction flag */
>> +#define IMR_MAP_LUCE        (1 << 3)
>> +
>> +/* chromacity correction flag */
>
> chromacity? You probably mean just plain 'chroma'. Ditto below.

    Hm, www.translate.ru knows this word. :-)

[...]

>
> Regards,
>
>     Hans

MBR, Sergei
