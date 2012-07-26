Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:38061 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345Ab2GZD5K (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jul 2012 23:57:10 -0400
Received: by vcbfk26 with SMTP id fk26so1282208vcb.19
        for <linux-media@vger.kernel.org>; Wed, 25 Jul 2012 20:57:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <501065CA.6080902@gmail.com>
References: <1343219191-3969-1-git-send-email-shaik.ameer@samsung.com>
	<1343219191-3969-5-git-send-email-shaik.ameer@samsung.com>
	<501065CA.6080902@gmail.com>
Date: Thu, 26 Jul 2012 09:27:10 +0530
Message-ID: <CAOD6AToT=RqZHNXL1CST-JKcW1ZPi6TjTprJcA_9=GY7f9nNFg@mail.gmail.com>
Subject: Re: [PATCH v3 4/5] media: gscaler: Add m2m functionality for the
 G-Scaler driver
From: Shaik Ameer Basha <shaik.samsung@gmail.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Shaik Ameer Basha <shaik.ameer@samsung.com>,
	linux-media@vger.kernel.org, sungchun.kang@samsung.com,
	khw0178.kim@samsung.com, mchehab@infradead.org,
	laurent.pinchart@ideasonboard.com, sy0816.kang@samsung.com,
	s.nawrocki@samsung.com, posciak@google.com, alim.akhtar@gmail.com,
	prashanth.g@samsung.com, joshi@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Thu, Jul 26, 2012 at 3:01 AM, Sylwester Nawrocki
<sylvester.nawrocki@gmail.com> wrote:
> On 07/25/2012 02:26 PM, Shaik Ameer Basha wrote:
>>
>> From: Sungchun Kang<sungchun.kang@samsung.com>
>>
>> This patch adds the memory to memory (m2m) interface functionality
>> for the G-Scaler driver.
>>
>> Signed-off-by: Hynwoong Kim<khw0178.kim@samsung.com>
>> Signed-off-by: Sungchun Kang<sungchun.kang@samsung.com>
>> Signed-off-by: Shaik Ameer Basha<shaik.ameer@samsung.com>
>> ---
>>   drivers/media/video/exynos-gsc/gsc-m2m.c |  781
>> ++++++++++++++++++++++++++++++
>>   1 files changed, 781 insertions(+), 0 deletions(-)
>>   create mode 100644 drivers/media/video/exynos-gsc/gsc-m2m.c
>>
>> diff --git a/drivers/media/video/exynos-gsc/gsc-m2m.c
>> b/drivers/media/video/exynos-gsc/gsc-m2m.c
>> new file mode 100644
>> index 0000000..3568d6f
>> --- /dev/null
>> +++ b/drivers/media/video/exynos-gsc/gsc-m2m.c
>> @@ -0,0 +1,781 @@
>> +/*
>> + * Copyright (c) 2011 - 2012 Samsung Electronics Co., Ltd.
>> + *             http://www.samsung.com
>> + *
>> + * Samsung EXYNOS5 SoC series G-Scaler driver
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
>> +
>> +#include<media/v4l2-ioctl.h>
>> +
>> +#include "gsc-core.h"
>> +
>> +static int gsc_m2m_ctx_stop_req(struct gsc_ctx *ctx)
>> +{
>> +       struct gsc_ctx *curr_ctx;
>> +       struct gsc_dev *gsc = ctx->gsc_dev;
>> +       int ret = 0;
>
>
> Unneded initialization.
>

Ok. I will fix this for all other unneeded initialization too...

>> +
>> +       curr_ctx = v4l2_m2m_get_curr_priv(gsc->m2m.m2m_dev);
>> +       if (!gsc_m2m_pending(gsc) || (curr_ctx != ctx))
>> +               return 0;
>> +
>> +       gsc_ctx_state_lock_set(GSC_CTX_STOP_REQ, ctx);
>> +       ret = wait_event_timeout(gsc->irq_queue,
>> +                       !gsc_ctx_state_is_set(GSC_CTX_STOP_REQ, ctx),
>> +                       GSC_SHUTDOWN_TIMEOUT);
>> +
>> +       return ret == 0 ? -ETIMEDOUT : ret;
>> +}
>> +
>> +static int gsc_m2m_start_streaming(struct vb2_queue *q, unsigned int
>> count)
>> +{
>> +       struct gsc_ctx *ctx = q->drv_priv;
>> +       int ret;
>> +
>> +       ret = pm_runtime_get_sync(&ctx->gsc_dev->pdev->dev);
>> +       return ret>  0 ? 0 : ret;
>> +}
>> +
>> +static int gsc_m2m_stop_streaming(struct vb2_queue *q)
>> +{
>> +       struct gsc_ctx *ctx = q->drv_priv;
>> +       int ret;
>> +
>> +       ret = gsc_m2m_ctx_stop_req(ctx);
>> +       if (ret == -ETIMEDOUT)
>> +               gsc_m2m_job_finish(ctx, VB2_BUF_STATE_ERROR);
>> +
>> +       pm_runtime_put(&ctx->gsc_dev->pdev->dev);
>> +
>> +       return 0;
>> +}
>> +
>> +void gsc_m2m_job_finish(struct gsc_ctx *ctx, int vb_state)
>> +{
>> +       struct vb2_buffer *src_vb, *dst_vb;
>> +
>> +       if (!ctx || !ctx->m2m_ctx)
>> +               return;
>> +
>> +       src_vb = v4l2_m2m_src_buf_remove(ctx->m2m_ctx);
>> +       dst_vb = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx);
>> +
>> +       if (src_vb&&  dst_vb) {
>>
>> +               v4l2_m2m_buf_done(src_vb, vb_state);
>> +               v4l2_m2m_buf_done(dst_vb, vb_state);
>> +
>> +               v4l2_m2m_job_finish(ctx->gsc_dev->m2m.m2m_dev,
>> +                                   ctx->m2m_ctx);
>> +       }
>> +}
>> +
>> +
>> +static void gsc_m2m_job_abort(void *priv)
>> +{
>> +       struct gsc_ctx *ctx = priv;
>> +       int ret;
>> +
>> +       ret = gsc_m2m_ctx_stop_req(ctx);
>> +       if (ret == -ETIMEDOUT)
>> +               gsc_m2m_job_finish(ctx, VB2_BUF_STATE_ERROR);
>> +}
>> +
>> +int gsc_fill_addr(struct gsc_ctx *ctx)
>> +{
>> +       struct gsc_frame *s_frame, *d_frame;
>> +       struct vb2_buffer *vb = NULL;
>> +       int ret = 0;
>
>
> Unneeded initialization.
>
>> +
>> +       s_frame =&ctx->s_frame;
>> +       d_frame =&ctx->d_frame;
>>
>> +
>> +       vb = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
>> +       ret = gsc_prepare_addr(ctx, vb, s_frame,&s_frame->addr);
>>
>> +       if (ret)
>> +               return ret;
>> +
>> +       vb = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
>> +       ret = gsc_prepare_addr(ctx, vb, d_frame,&d_frame->addr);
>> +
>> +       return ret;
>
>
> Just do:
>
>         return gsc_prepare_addr(ctx, vb, d_frame,&d_frame->addr);

I will do that.

>>
>> +}
>> +
<snip>
>> +int gsc_register_m2m_device(struct gsc_dev *gsc)
>> +{
>> +       struct video_device *vfd;
>> +       struct platform_device *pdev;
>> +       int ret = 0;
>> +
>> +       if (!gsc)
>> +               return -ENODEV;
>> +
>> +       pdev = gsc->pdev;
>> +
>> +       vfd = video_device_alloc();
>> +       if (!vfd) {
>> +               dev_err(&pdev->dev, "Failed to allocate video device\n");
>> +               return -ENOMEM;
>> +       }
>
>
> You could embed struct video_device into struct gsc_dev, rather than
> dynamically allocating it...

Yes. I can follow this.

>
>> +
>> +       vfd->fops       =&gsc_m2m_fops;
>> +       vfd->ioctl_ops  =&gsc_m2m_ioctl_ops;
>>
>> +       vfd->release    = video_device_release;
>
>
> ...and then change that to
>
>         vfd->release    = video_device_release_empty;
>

Ok. i will do that.

>> +       vfd->lock       =&gsc->lock;
>>
>> +       snprintf(vfd->name, sizeof(vfd->name), "%s.%d:m2m",
>> +                                       GSC_MODULE_NAME, gsc->id);
>> +
>> +       video_set_drvdata(vfd, gsc);
>> +
>> +       gsc->m2m.vfd = vfd;
>> +       gsc->m2m.m2m_dev = v4l2_m2m_init(&gsc_m2m_ops);
>> +       if (IS_ERR(gsc->m2m.m2m_dev)) {
>> +               dev_err(&pdev->dev, "failed to initialize v4l2-m2m
>> device\n");
>> +               ret = PTR_ERR(gsc->m2m.m2m_dev);
>> +               goto err_m2m_r1;
>> +       }
>> +
>> +       ret = video_register_device(vfd, VFL_TYPE_GRABBER, -1);
>> +       if (ret) {
>> +               dev_err(&pdev->dev,
>> +                        "%s(): failed to register video device\n",
>> __func__);
>> +               goto err_m2m_r2;
>> +       }
>> +
>> +       pr_debug("gsc m2m driver registered as /dev/video%d", vfd->num);
>> +       return 0;
>> +
>> +err_m2m_r2:
>> +       v4l2_m2m_release(gsc->m2m.m2m_dev);
>> +err_m2m_r1:
>> +       video_device_release(gsc->m2m.vfd);
>> +
>> +       return ret;
>> +}
>> +
>> +void gsc_unregister_m2m_device(struct gsc_dev *gsc)
>> +{
>> +       if (gsc)
>> +               v4l2_m2m_release(gsc->m2m.m2m_dev);
>> +}
>
>
> Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>
> --
>
> Thanks,
> Sylwester

Regards,
Shaik Ameer Basha
