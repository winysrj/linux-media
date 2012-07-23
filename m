Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:54149 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752911Ab2GWGSO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jul 2012 02:18:14 -0400
Received: by wgbdr13 with SMTP id dr13so5486326wgb.1
        for <linux-media@vger.kernel.org>; Sun, 22 Jul 2012 23:18:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FFF20D3.4020806@gmail.com>
References: <1341484061-10914-1-git-send-email-shaik.ameer@samsung.com>
	<1341484061-10914-2-git-send-email-shaik.ameer@samsung.com>
	<4FFF20D3.4020806@gmail.com>
Date: Mon, 23 Jul 2012 11:48:12 +0530
Message-ID: <CAFSwF2f7QmdgYM_PEU7ZqFezOx2nj4gSRKo+pedseaJZw_8sVA@mail.gmail.com>
Subject: Re: [PATCH v2 01/01] media: gscaler: Add new driver for generic scaler
From: Shaik Ameer Basha <ameersk@gmail.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Shaik Ameer Basha <shaik.ameer@samsung.com>,
	linux-media@vger.kernel.org, sungchun.kang@samsung.com,
	khw0178.kim@samsung.com, sy0816.kang@samsung.com,
	s.nawrocki@samsung.com, posciak@google.com, alim.akhtar@gmail.com,
	prashanth.g@samsung.com, joshi@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

thanks for your review comments...
I will update the Gscaler driver code with the other two set of review
comments you posted earlier...

however, i have some doubts in this set of review comments.
please find my comments inline...

On Fri, Jul 13, 2012 at 12:39 AM, Sylwester Nawrocki
<sylvester.nawrocki@gmail.com> wrote:
> Hi Shaik,
>
> A few more remarks...
>
> On 07/05/2012 12:27 PM, Shaik Ameer Basha wrote:
>> diff --git a/drivers/media/video/exynos/gsc/gsc-core.c b/drivers/media/video/exynos/gsc/gsc-core.c
>> new file mode 100644
>> index 0000000..06bd24f
>> --- /dev/null
>> +++ b/drivers/media/video/exynos/gsc/gsc-core.c
>> @@ -0,0 +1,1304 @@
>> +/* linux/drivers/media/video/exynos/gsc/gsc-core.c
>> + *
>> + * Copyright (c) 2011 - 2012 Samsung Electronics Co., Ltd.
>> + *           http://www.samsung.com
>> + *
>> + * Samsung EXYNOS5 SoC series G-scaler driver
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published
>> + * by the Free Software Foundation, either version 2 of the License,
>> + * or (at your option) any later version.
>> + */
>> +
>> +#include<linux/module.h>
>> +#include<linux/kernel.h>
>> +#include<linux/version.h>
>> +#include<linux/types.h>
>> +#include<linux/errno.h>
>> +#include<linux/bug.h>
>> +#include<linux/interrupt.h>
>> +#include<linux/workqueue.h>
>> +#include<linux/device.h>
>> +#include<linux/platform_device.h>
>> +#include<linux/list.h>
>> +#include<linux/io.h>
>> +#include<linux/slab.h>
>> +#include<linux/clk.h>
>> +#include<media/v4l2-ioctl.h>
>> +#include<linux/of.h>
>> +#include "gsc-core.h"
>> +
>> +#define GSC_CLOCK_GATE_NAME  "gscl"
>> +
>> +int gsc_dbg;
>> +module_param(gsc_dbg, int, 0644);
>> +
>> +
>> +static struct gsc_fmt gsc_formats[] = {
>
> static const

OK. I will change that.

>
>> +     {
>> +             .name           = "RGB565",
>> +             .pixelformat    = V4L2_PIX_FMT_RGB565X,
>> +             .depth          = { 16 },
>> +             .color          = GSC_RGB,
>> +             .num_planes     = 1,
>> +             .num_comp       = 1,
>> +     }, {
> ...
>> +struct gsc_fmt *find_fmt(u32 *pixelformat, u32 *mbus_code, int index)
>> +{
>> +     struct gsc_fmt *fmt, *def_fmt = NULL;
>> +     unsigned int i;
>> +
>> +     if (index>= ARRAY_SIZE(gsc_formats))
>
>         if (index >= (int)ARRAY_SIZE(gsc_formats))

changed the function prototype to take "u32 index"....

>
> (otherwise negative indexes won't work)
>
>> +             return NULL;
>> +
>> +     for (i = 0; i<  ARRAY_SIZE(gsc_formats); ++i) {
>> +             fmt = get_format(i);
>> +             if (pixelformat&&  fmt->pixelformat == *pixelformat)
>> +                     return fmt;
>> +             if (mbus_code&&  fmt->mbus_code == *mbus_code)
>> +                     return fmt;
>> +             if (index == i)
>> +                     def_fmt = fmt;
>> +     }
>> +     return def_fmt;
>> +
>> +}
> ...
>> +int gsc_enum_fmt_mplane(struct v4l2_fmtdesc *f)
>> +{
>> +     struct gsc_fmt *fmt;
>> +
>> +     fmt = find_fmt(NULL, NULL, f->index);
>> +     if (!fmt)
>> +             return -EINVAL;
>> +
>> +     strncpy(f->description, fmt->name, sizeof(f->description) - 1);
>
>         strlcpy(f->description, fmt->name, sizeof(f->description));
>

OK. I will change that.

>> +     f->pixelformat = fmt->pixelformat;
>> +
>> +     return 0;
>> +}
>> +
>> +u32 get_plane_size(struct gsc_frame *frame, unsigned int plane)
>> +{
>> +     if (!frame || plane>= frame->fmt->num_planes) {
>> +             gsc_err("Invalid argument");
>> +             return 0;
>> +     }
>> +
>> +     return frame->payload[plane];
>> +}
>> +
>> +u32 get_plane_info(struct gsc_frame frm, u32 addr, u32 *index)
>
> Why don't you just pass a pointer to struct gsc_frame ?
> It is so inefficient this way...
>

OK. I will change that.

>> +{
>> +     if (frm.addr.y == addr) {
>> +             *index = 0;
>> +             return frm.addr.y;
>> +     } else if (frm.addr.cb == addr) {
>> +             *index = 1;
>> +             return frm.addr.cb;
>> +     } else if (frm.addr.cr == addr) {
>> +             *index = 2;
>> +             return frm.addr.cr;
>> +     } else {
>> +             gsc_err("Plane address is wrong");
>> +             return -EINVAL;
>> +     }
>> +}
>> +
>> +void gsc_set_prefbuf(struct gsc_dev *gsc, struct gsc_frame frm)
>
> Ditto.
>

OK. I will change that.

>> +{
>> +     u32 f_chk_addr, f_chk_len, s_chk_addr, s_chk_len;
>> +     f_chk_addr = f_chk_len = s_chk_addr = s_chk_len = 0;
>> +
>> +     f_chk_addr = frm.addr.y;
>> +     f_chk_len = frm.payload[0];
>> +     if (frm.fmt->num_planes == 2) {
>> +             s_chk_addr = frm.addr.cb;
>> +             s_chk_len = frm.payload[1];
>> +     } else if (frm.fmt->num_planes == 3) {
>> +             u32 low_addr, low_plane, mid_addr, mid_plane;
>> +             u32 high_addr, high_plane;
>> +             u32 t_min, t_max;
>> +
>> +             t_min = min3(frm.addr.y, frm.addr.cb, frm.addr.cr);
>> +             low_addr = get_plane_info(frm, t_min,&low_plane);
>> +             t_max = max3(frm.addr.y, frm.addr.cb, frm.addr.cr);
>> +             high_addr = get_plane_info(frm, t_max,&high_plane);
>> +
>> +             mid_plane = 3 - (low_plane + high_plane);
>> +             if (mid_plane == 0)
>> +                     mid_addr = frm.addr.y;
>> +             else if (mid_plane == 1)
>> +                     mid_addr = frm.addr.cb;
>> +             else if (mid_plane == 2)
>> +                     mid_addr = frm.addr.cr;
>> +             else
>> +                     return;
>> +
>> +             f_chk_addr = low_addr;
>> +             if (mid_addr + frm.payload[mid_plane] - low_addr>
>> +                 high_addr + frm.payload[high_plane] - mid_addr) {
>> +                     f_chk_len = frm.payload[low_plane];
>> +                     s_chk_addr = mid_addr;
>> +                     s_chk_len = high_addr +
>> +                                     frm.payload[high_plane] - mid_addr;
>> +             } else {
>> +                     f_chk_len = mid_addr +
>> +                                     frm.payload[mid_plane] - low_addr;
>> +                     s_chk_addr = high_addr;
>> +                     s_chk_len = frm.payload[high_plane];
>> +             }
>> +     }
>> +     gsc_dbg("f_addr = 0x%08x, f_len = %d, s_addr = 0x%08x, s_len = %d\n",
>> +             f_chk_addr, f_chk_len, s_chk_addr, s_chk_len);
>> +}
>> +
> ...
>> +static int gsc_m2m_querycap(struct file *file, void *fh,
>> +                        struct v4l2_capability *cap)
>> +{
>> +     struct gsc_ctx *ctx = fh_to_ctx(fh);
>> +     struct gsc_dev *gsc = ctx->gsc_dev;
>> +
>> +     strncpy(cap->driver, gsc->pdev->name, sizeof(cap->driver) - 1);
>
> strlcpy(cap->driver, gsc->pdev->name, sizeof(cap->driver));
>
>> +     strncpy(cap->card, gsc->pdev->name, sizeof(cap->card) - 1);
>
> strlcpy(cap->card, gsc->pdev->name, sizeof(cap->card));
>
>> +     cap->bus_info[0] = 0;
>
> strlcpy(cap->bus_info, "platform", sizeof(cap->bus_info));
>
>> +     cap->capabilities = V4L2_CAP_STREAMING |
>> +             V4L2_CAP_VIDEO_CAPTURE_MPLANE | V4L2_CAP_VIDEO_OUTPUT_MPLANE;
>
> Need to set device_caps as well:
>
>  cap->device_caps = V4L2_CAP_STREAMING |
>                     V4L2_CAP_VIDEO_CAPTURE_MPLANE |
>                     V4L2_CAP_VIDEO_OUTPUT_MPLANE;
>
>  cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
>

OK. I will change that.

>
> Howewer this will probably need to be
>
>  cap->device_caps = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_M2M_MPLANE;
>
> as per http://www.mail-archive.com/linux-media@vger.kernel.org/msg48498.html
> by the time this patch is to be merged (v3.7 ?).
>

currently my plan is to merge these changes in v3.6.
Isn't it possible ????


>> +
>> +     return 0;
>> +}
>> +
> [...]
>> +static int gsc_m2m_g_selection(struct file *file, void *fh,
>> +                     struct v4l2_selection *s)
>> +{
>> +     struct gsc_frame *frame;
>> +     struct gsc_ctx *ctx = fh_to_ctx(fh);
>> +
>> +     if ((s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)&&
>> +         (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE))
>> +             return -EINVAL;
>> +
>> +     frame = ctx_get_frame(ctx, s->type);
>> +     if (IS_ERR(frame))
>> +             return PTR_ERR(frame);
>> +
>> +     switch (s->target) {
>> +     case V4L2_SEL_TGT_COMPOSE_DEFAULT:
>> +     case V4L2_SEL_TGT_COMPOSE_BOUNDS:
>> +     case V4L2_SEL_TGT_CROP_BOUNDS:
>> +     case V4L2_SEL_TGT_CROP_DEFAULT:
>> +             s->r.left = 0;
>> +             s->r.top = 0;
>> +             s->r.width = frame->f_width;
>> +             s->r.height = frame->f_height;
>> +             return 0;
>> +
>> +     case V4L2_SEL_TGT_COMPOSE_ACTIVE:
>> +     case V4L2_SEL_TGT_CROP_ACTIVE:
>
> Please use V4L2_SEL_TGT_CROP/COMPOSE instead of V4L2_SEL_TGT_CROP/COMPOSE_ACTIVE
> which is being phased out.
>
> http://git.linuxtv.org/media_tree.git/commit/c133482300113b3b71fa4a1fd2118531e765b36a
>

currently, I am rebasing the code on media-next git...
http://linuxtv.org/git/mchehab/media-next.git

I am not able to find the above changes mentioned in this git...
do you want me to rebase my code on top of the patch you provided ????

Or should i use any other git repository for rebasing my code ???


>> +             s->r.left = frame->crop.left;
>> +             s->r.top = frame->crop.top;
>> +             s->r.width = frame->crop.width;
>> +             s->r.height = frame->crop.height;
>> +             return 0;
>> +     }
>> +
>> +     return -EINVAL;
>> +}
>> +
>> +static int gsc_m2m_s_selection(struct file *file, void *fh,
>> +                     struct v4l2_selection *s)
>> +{
>> +     struct gsc_frame *frame;
>> +     struct gsc_ctx *ctx = fh_to_ctx(fh);
>> +     struct v4l2_crop cr;
>> +     struct gsc_variant *variant = ctx->gsc_dev->variant;
>> +     int ret;
>> +
>> +     cr.type = s->type;
>> +     cr.c = s->r;
>> +
>> +     if ((s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)&&
>> +         (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE))
>> +             return -EINVAL;
>> +
>> +     ret = gsc_try_crop(ctx,&cr);
>> +     if (ret)
>> +             return ret;
>> +
>> +     if (s->flags&  V4L2_SEL_FLAG_LE&&
>> +         !is_rectangle_enclosed(&cr.c,&s->r))
>> +             return -ERANGE;
>> +
>> +     if (s->flags&  V4L2_SEL_FLAG_GE&&
>> +         !is_rectangle_enclosed(&s->r,&cr.c))
>> +             return -ERANGE;
>> +
>> +     s->r = cr.c;
>> +
>> +     switch (s->target) {
>> +     case V4L2_SEL_TGT_COMPOSE_BOUNDS:
>> +     case V4L2_SEL_TGT_COMPOSE_DEFAULT:
>> +     case V4L2_SEL_TGT_COMPOSE_ACTIVE:
>
> V4L2_SEL_TGT_COMPOSE_ACTIVE -> V4L2_SEL_TGT_COMPOSE
>
>> +             frame =&ctx->s_frame;
>> +             break;
>> +
>> +     case V4L2_SEL_TGT_CROP_BOUNDS:
>> +     case V4L2_SEL_TGT_CROP_ACTIVE:
>
> V4L2_SEL_TGT_CROP_ACTIVE -> V4L2_SEL_TGT_CROP
>
>> +     case V4L2_SEL_TGT_CROP_DEFAULT:
>> +             frame =&ctx->d_frame;
>> +             break;
>> +
>> +     default:
>> +             return -EINVAL;
>> +     }
>> +
>> +     /* Check to see if scaling ratio is within supported range */
>> +     if (gsc_ctx_state_is_set(GSC_DST_FMT | GSC_SRC_FMT, ctx)) {
>> +             if (s->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
>> +                     ret = gsc_check_scaler_ratio(variant, cr.c.width,
>> +                             cr.c.height, ctx->d_frame.crop.width,
>> +                             ctx->d_frame.crop.height,
>> +                             ctx->gsc_ctrls.rotate->val, ctx->out_path);
>> +             } else {
>> +                     ret = gsc_check_scaler_ratio(variant,
>> +                             ctx->s_frame.crop.width,
>> +                             ctx->s_frame.crop.height, cr.c.width,
>> +                             cr.c.height, ctx->gsc_ctrls.rotate->val,
>> +                             ctx->out_path);
>> +             }
>> +
>> +             if (ret) {
>> +                     gsc_err("Out of scaler range");
>> +                     return -EINVAL;
>> +             }
>> +     }
>> +
>> +     frame->crop = cr.c;
>> +
>> +     gsc_ctx_state_lock_set(GSC_PARAMS, ctx);
>> +     return 0;
>> +}
> [...]
>> +static int gsc_m2m_open(struct file *file)
>> +{
>> +     struct gsc_dev *gsc = video_drvdata(file);
>> +     struct gsc_ctx *ctx = NULL;
>> +     int ret;
>> +
>> +     gsc_dbg("pid: %d, state: 0x%lx", task_pid_nr(current), gsc->state);
>> +
>> +     ctx = kzalloc(sizeof *ctx, GFP_KERNEL);
>> +     if (!ctx)
>> +             return -ENOMEM;
>> +
>> +     v4l2_fh_init(&ctx->fh, gsc->m2m.vfd);
>> +     ret = gsc_ctrls_create(ctx);
>> +     if (ret)
>> +             goto error_fh;
>> +
>> +     /* Use separate control handler per file handle */
>> +     ctx->fh.ctrl_handler =&ctx->ctrl_handler;
>> +     file->private_data =&ctx->fh;
>> +     v4l2_fh_add(&ctx->fh);
>> +
>> +     ctx->gsc_dev = gsc;
>> +     /* Default color format */
>> +     ctx->s_frame.fmt = get_format(0);
>> +     ctx->d_frame.fmt = get_format(0);
>> +     /* Setup the device context for mem2mem mode. */
>> +     ctx->state |= GSC_CTX_M2M;
>> +     ctx->flags = 0;
>> +     ctx->in_path = GSC_DMA;
>> +     ctx->out_path = GSC_DMA;
>> +     spin_lock_init(&ctx->slock);
>> +
>> +     ctx->m2m_ctx = v4l2_m2m_ctx_init(gsc->m2m.m2m_dev, ctx, queue_init);
>> +     if (IS_ERR(ctx->m2m_ctx)) {
>> +             gsc_err("Failed to initialize m2m context");
>> +             ret = PTR_ERR(ctx->m2m_ctx);
>> +             goto error_fh;
>> +     }
>> +
>> +     if (gsc->m2m.refcnt++ == 0)
>> +             set_bit(ST_M2M_OPEN,&gsc->state);
>> +
>> +     gsc_dbg("gsc m2m driver is opened, ctx(0x%p)", ctx);
>> +     return 0;
>> +
>> +error_fh:
>> +     v4l2_fh_del(&ctx->fh);
>> +     v4l2_fh_exit(&ctx->fh);
>> +     kfree(ctx);
>> +     return ret;
>> +}
>> +
>> +static int gsc_m2m_release(struct file *file)
>> +{
>> +     struct gsc_ctx *ctx = fh_to_ctx(file->private_data);
>> +     struct gsc_dev *gsc = ctx->gsc_dev;
>> +
>> +     gsc_dbg("pid: %d, state: 0x%lx, refcnt= %d",
>> +             task_pid_nr(current), gsc->state, gsc->m2m.refcnt);
>> +
>> +     v4l2_m2m_ctx_release(ctx->m2m_ctx);
>> +     gsc_ctrls_delete(ctx);
>> +     v4l2_fh_del(&ctx->fh);
>> +     v4l2_fh_exit(&ctx->fh);
>> +
>> +     if (--gsc->m2m.refcnt<= 0)
>> +             clear_bit(ST_M2M_OPEN,&gsc->state);
>> +     kfree(ctx);
>> +     return 0;
>> +}
>> +
>> +static unsigned int gsc_m2m_poll(struct file *file,
>> +                                  struct poll_table_struct *wait)
>> +{
>> +     struct gsc_ctx *ctx = fh_to_ctx(file->private_data);
>> +
>> +     return v4l2_m2m_poll(file, ctx->m2m_ctx, wait);
>> +}
>> +
>> +static int gsc_m2m_mmap(struct file *file, struct vm_area_struct *vma)
>> +{
>> +     struct gsc_ctx *ctx = fh_to_ctx(file->private_data);
>> +
>> +     return v4l2_m2m_mmap(file, ctx->m2m_ctx, vma);
>> +}
>> +static const struct v4l2_file_operations gsc_m2m_fops = {
>> +     .owner          = THIS_MODULE,
>> +     .open           = gsc_m2m_open,
>> +     .release        = gsc_m2m_release,
>> +     .poll           = gsc_m2m_poll,
>> +     .unlocked_ioctl = video_ioctl2,
>> +     .mmap           = gsc_m2m_mmap,
>
> There was a change recently in the v4l2 core modules and only
> .unlocked_ioctl is serialized with the core video device mutex.
> All other file operations must be serialized explicitly in drivers.
>
> For more details see:
> http://git.infradead.org/users/kmpark/linux-samsung/commit/66ba3641dbc122c9c82f03aed9320f087730dd8f
>
> [...]
>> diff --git a/drivers/media/video/exynos/gsc/gsc-regs.c b/drivers/media/video/exynos/gsc/gsc-regs.c
>> new file mode 100644
>> index 0000000..7c5cce2
>> --- /dev/null
>> +++ b/drivers/media/video/exynos/gsc/gsc-regs.c
>> @@ -0,0 +1,579 @@
>> +/* linux/drivers/media/video/exynos/gsc/gsc-regs.c
>> + *
>> + * Copyright (c) 2011 Samsung Electronics Co., Ltd.
>> + *           http://www.samsung.com
>> + *
>> + * Samsung EXYNOS5 SoC series G-scaler driver
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published
>> + * by the Free Software Foundation, either version 2 of the License,
>> + * or (at your option) any later version.
>> + */
>> +
>> +#include<linux/io.h>
>> +#include<linux/delay.h>
>> +#include<mach/map.h>
>> +#include "gsc-core.h"
>> +
>> +void gsc_hw_set_sw_reset(struct gsc_dev *dev)
>> +{
>> +     u32 cfg = 0;
>> +
>> +     cfg |= GSC_SW_RESET_SRESET;
>> +     writel(cfg, dev->regs + GSC_SW_RESET);
>> +}
>
> Probably worth to make it an inline function and move it to some
> header, e.g.
>
> +static inline void gsc_hw_set_sw_reset(struct gsc_dev *dev)
> +{
> +       writel(GSC_SW_RESET_SRESET, dev->regs + GSC_SW_RESET);
> +}
>
> --
>
> Thanks,
> Sylwester


Thanks,
Shaik Ameer Basha
