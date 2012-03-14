Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:37392 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760725Ab2CNVVM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Mar 2012 17:21:12 -0400
Received: by mail-we0-f174.google.com with SMTP id x9so2180986wej.19
        for <linux-media@vger.kernel.org>; Wed, 14 Mar 2012 14:21:11 -0700 (PDT)
Message-ID: <4F610BC4.4080408@gmail.com>
Date: Wed, 14 Mar 2012 22:21:08 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Sunyoung Kang <sy0816.kang@samsung.com>
CC: linux-media@vger.kernel.org,
	'Mauro Carvalho Chehab' <mchehab@infradead.org>,
	jonghun.han@samsung.com, khw0178.kim@samsung.com,
	sungchun.kang@samsung.com, younglak1004.kim@samsung.com,
	kgene.kim@samsung.com, a.sim@samsung.com
Subject: Re: [PATCH v2] media: rotator: Add new image rotator driver for EXYNOS
References: <001601cd01b8$873dd8c0$95b98a40$%kang@samsung.com>
In-Reply-To: <001601cd01b8$873dd8c0$95b98a40$%kang@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sunyoung,

thank you for addressing my previous comments. It looks much better now.
I have is a few more comments...

On 03/14/2012 09:00 AM, Sunyoung Kang wrote:
> This patch adds new rotator driver which is a device for
> rotation on EXYNOS SoCs.
> 
> This rotator device supports the belows as key feature.
>   1) Image format
>     : RGB565/888, YUV422 1p, YUV420 2p/3p
>   2) rotation
>     : 0/90/180/270 and X/Y Flip
> 
> Signed-off-by: Sunyoung Kang<sy0816.kang@samsung.com>
> Signed-off-by: Ayoung Sim<a.sim@samsung.com>
> ---NOTE:

It's almost right;) After the "---" there must be immediately a new
line character. So "NOTE" should be in a new line.

> This patch has been created based on following
>   - media: media-dev: Add media devices for EXYNOS5 by Sungchun Kang
>   - media: fimc-lite: Add new driver for camera interface by Sungchun Kang
> 
> Changes since v1:
>   - address comments from Sylwester Nawrocki
> 
>   drivers/media/video/exynos/Kconfig                |    1 +
>   drivers/media/video/exynos/Makefile               |    1 +
>   drivers/media/video/exynos/rotator/Kconfig        |    7 +
>   drivers/media/video/exynos/rotator/Makefile       |    9 +
>   drivers/media/video/exynos/rotator/rotator-core.c | 1344 +++++++++++++++++++++
>   drivers/media/video/exynos/rotator/rotator-regs.c |  215 ++++
>   drivers/media/video/exynos/rotator/rotator-regs.h |   70 ++
>   drivers/media/video/exynos/rotator/rotator.h      |  286 +++++
>   8 files changed, 1933 insertions(+), 0 deletions(-)
>   create mode 100644 drivers/media/video/exynos/rotator/Kconfig
>   create mode 100644 drivers/media/video/exynos/rotator/Makefile
>   create mode 100644 drivers/media/video/exynos/rotator/rotator-core.c
>   create mode 100644 drivers/media/video/exynos/rotator/rotator-regs.c
>   create mode 100644 drivers/media/video/exynos/rotator/rotator-regs.h
>   create mode 100644 drivers/media/video/exynos/rotator/rotator.h
> 
...
> diff --git a/drivers/media/video/exynos/rotator/Kconfig b/drivers/media/video/exynos/rotator/Kconfig
> new file mode 100644
> index 0000000..977423a
> --- /dev/null
> +++ b/drivers/media/video/exynos/rotator/Kconfig
> @@ -0,0 +1,7 @@
> +config VIDEO_EXYNOS_ROTATOR
> +	bool "EXYNOS Image Rotator Driver"
> +	select V4L2_MEM2MEM_DEV
> +	select VIDEOBUF2_DMA_CONTIG
> +	default n

No need, the default default already is "n".

> +	---help---
> +	  Support for Image Rotator Driver with v4l2 on EXYNOS SoCs
> diff --git a/drivers/media/video/exynos/rotator/Makefile b/drivers/media/video/exynos/rotator/Makefile
> new file mode 100644
> index 0000000..6f74403
> --- /dev/null
> +++ b/drivers/media/video/exynos/rotator/Makefile
> @@ -0,0 +1,9 @@
> +#
> +# Copyright (c) 2012 Samsung Electronics Co., Ltd.
> +#		http://www.samsung.com
> +#
> +# Licensed under GPLv2
> +#
> +
> +rotator-objs				:= rotator-core.o rotator-regs.o
> +obj-$(CONFIG_VIDEO_EXYNOS_ROTATOR)	+= rotator.o
> diff --git a/drivers/media/video/exynos/rotator/rotator-core.c b/drivers/media/video/exynos/rotator/rotator-core.c
> new file mode 100644
> index 0000000..75d28f2
> --- /dev/null
> +++ b/drivers/media/video/exynos/rotator/rotator-core.c
> @@ -0,0 +1,1344 @@
> +/*
> + * Copyright (c) 2012 Samsung Electronics Co., Ltd.
> + *		http://www.samsung.com
> + *
> + * Core file for Samsung EXYNOS Image Rotator driver
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> +*/
> +
> +#include<linux/module.h>
> +#include<linux/kernel.h>
> +#include<linux/version.h>
> +#include<linux/platform_device.h>
> +#include<linux/interrupt.h>
> +#include<linux/clk.h>
> +#include<linux/slab.h>
> +
> +#include<media/v4l2-ioctl.h>
> +#include<media/videobuf2-dma-contig.h>
> +
> +#include "rotator.h"
> +
> +int log_level;
> +module_param_named(log_level, log_level, uint, 0644);
> +
> +static struct rot_fmt rot_formats[] = {
> +	{
> +		.name		= "RGB565",
> +		.pixelformat	= V4L2_PIX_FMT_RGB565,
> +		.num_planes	= 1,
> +		.num_comp	= 1,
> +		.bitperpixel	= { 16 },
> +	}, {
> +		.name		= "XRGB-8888, 32 bps",

What 'bps' stands for ?

> +		.pixelformat	= V4L2_PIX_FMT_RGB32,
> +		.num_planes	= 1,
> +		.num_comp	= 1,
> +		.bitperpixel	= { 32 },
> +	}, {
> +		.name		= "YUV 4:2:2 packed, YCbYCr",
> +		.pixelformat	= V4L2_PIX_FMT_YUYV,
> +		.num_planes	= 1,
> +		.num_comp	= 1,
> +		.bitperpixel	= { 16 },
> +	}, {
> +		.name		= "YUV 4:2:0 non-contiguous 2-planar, Y/CbCr",
> +		.pixelformat	= V4L2_PIX_FMT_NV12M,
> +		.num_planes	= 2,
> +		.num_comp	= 2,
> +		.bitperpixel	= { 8, 4 },
> +	}, {
> +		.name		= "YUV 4:2:0 non-contiguous 3-planar, Y/Cb/Cr",
> +		.pixelformat	= V4L2_PIX_FMT_YUV420M,
> +		.num_planes	= 3,
> +		.num_comp	= 3,
> +		.bitperpixel	= { 8, 2, 2 },
> +	},
> +};
> +
...
> +static int rot_s_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	struct rot_ctx *ctx;
> +	unsigned long flags;
> +	int ret = 0;
> +
> +	ctx = container_of(ctrl->handler, struct rot_ctx, ctrl_handler);
> +	spin_lock_irqsave(&ctx->slock, flags);
> +
> +	rot_dbg("ctrl ID:%d, value:%d\n", ctrl->id, ctrl->val);
> +	switch (ctrl->id) {
> +	case V4L2_CID_VFLIP:
> +		if (ctrl->val)
> +			ctx->flip |= ROT_VFLIP;
> +		else
> +			ctx->flip&= ~ROT_VFLIP;
> +		break;
> +	case V4L2_CID_HFLIP:
> +		if (ctrl->val)
> +			ctx->flip |= ROT_HFLIP;
> +		else
> +			ctx->flip&= ~ROT_HFLIP;
> +		break;
> +	case V4L2_CID_ROTATE:
> +		ctx->rotation = ctrl->val;
> +		break;
> +	default:
> +		v4l2_err(&ctx->rot_dev->m2m.v4l2_dev, "invalid control id\n");
> +		ret = -EINVAL;

These 3 lines can be removed, rot_s_ctrl can be called only with ctrl->id
from the set of controls added to control handler.

> +	}
> +
> +	spin_unlock_irqrestore(&ctx->slock, flags);
> +
> +	return ret;
> +}
> +
> +static const struct v4l2_ctrl_ops rot_ctrl_ops = {
> +	.s_ctrl = rot_s_ctrl,
> +};
> +
> +static int rot_add_ctrls(struct rot_ctx *ctx)
> +{
> +	v4l2_ctrl_handler_init(&ctx->ctrl_handler, 4);

There are only 3 controls, so s/3/4.

> +	v4l2_ctrl_new_std(&ctx->ctrl_handler,&rot_ctrl_ops,
> +			V4L2_CID_VFLIP, 0, 1, 1, 0);
> +	v4l2_ctrl_new_std(&ctx->ctrl_handler,&rot_ctrl_ops,
> +			V4L2_CID_HFLIP, 0, 1, 1, 0);
> +	v4l2_ctrl_new_std(&ctx->ctrl_handler,&rot_ctrl_ops,
> +			V4L2_CID_ROTATE, 0, 270, 90, 0);
> +
> +	if (ctx->ctrl_handler.error) {
> +		int err = ctx->ctrl_handler.error;
> +		v4l2_err(&ctx->rot_dev->m2m.v4l2_dev,
> +				"v4l2_ctrl_handler_init failed\n");
> +		v4l2_ctrl_handler_free(&ctx->ctrl_handler);
> +		return err;
> +	}
> +
> +	return 0;
> +}
> +
> +static int rot_open(struct file *file)
> +{
> +	struct rot_dev *rot = video_drvdata(file);
> +	struct rot_ctx *ctx = NULL;

No need to initialize here.

> +	int ret;
> +
> +	ctx = kzalloc(sizeof *ctx, GFP_KERNEL);
> +	if (!ctx) {
> +		dev_err(rot->dev, "no memory for open context\n");
> +		return -ENOMEM;
> +	}
> +
> +	atomic_inc(&rot->m2m.in_use);
> +	ctx->rot_dev = rot;
> +
> +	v4l2_fh_init(&ctx->fh, rot->m2m.vfd);
> +	ret = rot_add_ctrls(ctx);
> +	if (ret)
> +		goto err_fh;
> +
> +	ctx->fh.ctrl_handler =&ctx->ctrl_handler;
> +	file->private_data =&ctx->fh;
> +	v4l2_fh_add(&ctx->fh);
> +
> +	/* Default color format */
> +	ctx->s_frame.rot_fmt =&rot_formats[0];
> +	ctx->d_frame.rot_fmt =&rot_formats[0];
> +	init_waitqueue_head(&rot->irq.wait);
> +	spin_lock_init(&ctx->slock);
> +
> +	/* Setup the device context for mem2mem mode. */
> +	ctx->m2m_ctx = v4l2_m2m_ctx_init(rot->m2m.m2m_dev, ctx, queue_init);
> +	if (IS_ERR(ctx->m2m_ctx)) {
> +		ret = -EINVAL;
> +		goto err_ctx;
> +	}
> +
> +	return 0;
> +
> +err_ctx:
> +	v4l2_fh_del(&ctx->fh);
> +err_fh:
> +	v4l2_ctrl_handler_free(&ctx->ctrl_handler);
> +	v4l2_fh_exit(&ctx->fh);
> +	atomic_dec(&rot->m2m.in_use);
> +	kfree(ctx);
> +
> +	return ret;
> +}
> +
...
> +static irqreturn_t rot_irq_handler(int irq, void *priv)
> +{
> +	struct rot_dev *rot = priv;
> +	struct rot_ctx *ctx;
> +	struct vb2_buffer *src_vb, *dst_vb;
> +	unsigned int irq_src;
> +
> +	spin_lock(&rot->slock);
> +
> +	clear_bit(DEV_RUN,&rot->state);
> +	if (timer_pending(&rot->wdt.timer))
> +		del_timer(&rot->wdt.timer);
> +
> +	rot_hwget_irq_src(rot,&irq_src);
> +	rot_hwset_irq_clear(rot,&irq_src);
> +
> +	if (irq_src != ISR_PEND_DONE) {
> +		dev_err(rot->dev, "####################\n");
> +		dev_err(rot->dev, "set SFR illegally\n");
> +		dev_err(rot->dev, "maybe the result is wrong\n");
> +		dev_err(rot->dev, "####################\n");
> +		rot_dump_register(rot);
> +	}

How about following instead:

	if (WARN_ON(irq_src != ISR_PEND_DONE),
	    "Illegal SFR configuration, the result might be wrong\n") {
		rot_dump_register(rot);
	}
?
> +
> +	ctx = v4l2_m2m_get_curr_priv(rot->m2m.m2m_dev);
> +	if (!ctx || !ctx->m2m_ctx) {
> +		dev_err(rot->dev, "current ctx is NULL\n");
> +		goto isr_unlock;
> +	}
> +
> +	clear_bit(CTX_RUN,&ctx->flags);
> +
> +	src_vb = v4l2_m2m_src_buf_remove(ctx->m2m_ctx);
> +	dst_vb = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx);
> +
> +	if (src_vb&&  dst_vb) {
> +		v4l2_m2m_buf_done(src_vb, VB2_BUF_STATE_DONE);
> +		v4l2_m2m_buf_done(dst_vb, VB2_BUF_STATE_DONE);
> +
> +		if (test_bit(DEV_SUSPEND,&rot->state)) {
> +			rot_dbg("wake up blocked process by suspend\n");
> +			wake_up(&rot->irq.wait);
> +		} else {
> +			v4l2_m2m_job_finish(rot->m2m.m2m_dev, ctx->m2m_ctx);
> +		}
> +
> +		/* Wake up from CTX_ABORT state */
> +		if (test_and_clear_bit(CTX_ABORT,&ctx->flags))
> +			wake_up(&rot->irq.wait);
> +
> +		pm_runtime_put(rot->dev);
> +	} else {
> +		dev_err(rot->dev, "failed to get the buffer done\n");
> +	}
> +
> +isr_unlock:
> +	spin_unlock(&rot->slock);
> +
> +	return IRQ_HANDLED;
> +}
> +
...
> +static void rot_m2m_device_run(void *priv)
> +{
> +	struct rot_ctx *ctx = priv;
> +	struct rot_frame *s_frame, *d_frame;
> +	struct rot_dev *rot;
> +	unsigned long flags, tmp;
> +	u32 degree = 0, flip = 0;
> +
> +	spin_lock_irqsave(&ctx->slock, flags);
> +
> +	rot = ctx->rot_dev;
> +
> +	if (test_bit(DEV_RUN,&rot->state)) {
> +		dev_err(rot->dev, "Rotator is already in progress\n");
> +		goto run_unlock;
> +	}
> +
> +	if (test_bit(DEV_SUSPEND,&rot->state)) {
> +		dev_err(rot->dev, "Rotator is in suspend state\n");
> +		goto run_unlock;
> +	}
> +
> +	if (test_bit(CTX_ABORT,&ctx->flags)) {
> +		rot_dbg("aborted rot device run\n");
> +		goto run_unlock;
> +	}
> +
> +	pm_runtime_get_sync(ctx->rot_dev->dev);
> +
> +	s_frame =&ctx->s_frame;
> +	d_frame =&ctx->d_frame;
> +
> +	/* Configuration rotator registers */
> +	rot_hwset_image_format(rot, s_frame->rot_fmt->pixelformat);
> +	rot_mapping_flip(ctx,&degree,&flip);
> +	rot_hwset_flip(rot, flip);
> +	rot_hwset_rotation(rot, degree);
> +
> +	if (ctx->rotation == 90 || ctx->rotation == 270) {
> +		tmp                     = d_frame->pix_mp.height;
> +		d_frame->pix_mp.height  = d_frame->pix_mp.width;
> +		d_frame->pix_mp.width   = tmp;

Do you mean:
		swap(d_frame->pix_mp.height, d_frame->pix_mp.width);
?

Does it mean setting rotation to 90 or 270 deg changes the output (capture)
format ? Maybe you want to do this swapping on temporary variables, that
would be used to configure the hardware ?

The rotation is a bit tricky, AFAIK the application should swap width/and 
height. And the driver should scale an image (change aspect ratio) when
width/height isn't swapped and 90/270 deg rotation is set. Or return an 
error when the device doesn't support resizing.

> +	}
> +
> +	rot_hwset_src_imgsize(rot, s_frame);
> +	rot_hwset_dst_imgsize(rot, d_frame);
> +
> +	rot_hwset_src_crop(rot,&s_frame->crop);
> +	rot_hwset_dst_crop(rot,&d_frame->crop);
> +
> +	rot_set_frame_addr(ctx);
> +
> +	/* Enable rotator interrupt */
> +	rot_hwset_irq_frame_done(rot, 1);
> +	rot_hwset_irq_illegal_config(rot, 1);
> +
> +	set_bit(DEV_RUN,&rot->state);
> +	set_bit(CTX_RUN,&ctx->flags);
> +
> +	/* Start rotate operation */
> +	rot_hwset_start(rot);
> +
> +	/* Start watchdog timer */
> +	rot->wdt.timer.expires = jiffies + ROT_TIMEOUT;
> +	if (timer_pending(&rot->wdt.timer) == 0)
> +		add_timer(&rot->wdt.timer);
> +	else
> +		mod_timer(&rot->wdt.timer, rot->wdt.timer.expires);
> +
> +run_unlock:
> +	spin_unlock_irqrestore(&ctx->slock, flags);
> +}
> +
...
> +static int rot_suspend(struct device *dev)
> +{
> +	struct rot_dev *rot;

How about assigning here directly,

	struct rot_dev *rot = dev_get_drvdata(dev);
?
> +	int ret = 0;

No need to initialize.

> +
> +	rot = dev_get_drvdata(dev);
> +	set_bit(DEV_SUSPEND,&rot->state);
> +
> +	ret = wait_event_timeout(rot->irq.wait,
> +			!test_bit(DEV_RUN,&rot->state), ROT_TIMEOUT);
> +	if (ret == 0)
> +		dev_err(rot->dev, "wait timeout\n");
> +
> +	return 0;
> +}
> +
> +static int rot_resume(struct device *dev)
> +{
> +	struct rot_dev *rot;
> +
> +	rot = dev_get_drvdata(dev);

	struct rot_dev *rot = dev_get_drvdata(dev);
 ?

> +	clear_bit(DEV_SUSPEND,&rot->state);
> +
> +	return 0;
> +}
> +
> +static int rot_runtime_suspend(struct device *dev)
> +{
> +	struct rot_dev *rot;
> +	struct platform_device *pdev;
> +
> +	pdev = to_platform_device(dev);
> +	rot = (struct rot_dev *)platform_get_drvdata(pdev);


I think, you've forgotten to update that one?

> +	clk_disable(rot->clock);
> +
> +	return 0;
> +}
> +
> +static int rot_runtime_resume(struct device *dev)
> +{
> +	struct rot_dev *rot;
> +	struct platform_device *pdev;
> +
> +	pdev = to_platform_device(dev);
> +	rot = (struct rot_dev *)platform_get_drvdata(pdev);

And here (struct rot_dev *rot = dev_get_drvdata(dev);) ?

> +	clk_enable(rot->clock);
> +
> +	return 0;
> +}
> +
> +static const struct dev_pm_ops rot_pm_ops = {
> +	.suspend		= rot_suspend,
> +	.resume			= rot_resume,
> +	.runtime_suspend	= rot_runtime_suspend,
> +	.runtime_resume		= rot_runtime_resume,
> +};
> +
> +static int rot_probe(struct platform_device *pdev)
> +{
> +	struct exynos_rot_driverdata *drv_data;
> +	struct rot_dev *rot;
> +	struct resource *res;
> +	int variant_num, ret = 0;
> +
> +	dev_info(&pdev->dev, "++%s\n", __func__);
> +	drv_data = (struct exynos_rot_driverdata *)
> +			platform_get_device_id(pdev)->driver_data;
> +
> +	if (pdev->id>= drv_data->nr_dev) {
> +		dev_err(&pdev->dev, "Invalid platform device id\n");
> +		return -EINVAL;
> +	}

If there is always only one device, is this needed ? 

> +	rot = devm_kzalloc(&pdev->dev, sizeof(struct rot_dev), GFP_KERNEL);
> +	if (!rot) {
> +		dev_err(&pdev->dev, "no memory for rotator device\n");
> +		return -ENOMEM;
> +	}
> +
> +	rot->dev =&pdev->dev;
> +	rot->id = pdev->id;
> +	variant_num = (rot->id<  0) ? 0 : rot->id;
> +	rot->variant = drv_data->variant[variant_num];
> +
> +	spin_lock_init(&rot->slock);
> +
> +	/* Get memory resource and map SFR region. */
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	rot->regs = devm_request_and_ioremap(&pdev->dev, res);
> +	if (rot->regs == NULL) {
> +		dev_err(&pdev->dev, "failed to claim register region\n");
> +		return -ENOENT;
> +	}
> +
> +	/* Get IRQ resource and register IRQ handler. */
> +	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> +	if (res == NULL) {
> +		dev_err(&pdev->dev, "failed to get IRQ resource\n");
> +		return -ENXIO;
> +	}
> +	rot->irq.num = res->start;
> +
> +	ret = devm_request_irq(&pdev->dev, rot->irq.num, rot_irq_handler, 0,

I think you can use res->start directly, and remove irq.num, since the interrupt
is now being released dynamically and we don't need to sore the interrupt number. 

> +			pdev->name, rot);
> +	if (ret) {
> +		dev_err(&pdev->dev, "failed to install irq\n");
> +		return ret;
> +	}
> +
> +	atomic_set(&rot->wdt.cnt, 0);
> +	setup_timer(&rot->wdt.timer, rot_watchdog, (unsigned long)rot);
> +
> +	rot->clock = clk_get(rot->dev, "rotator");
> +	if (IS_ERR(rot->clock)) {
> +		dev_err(&pdev->dev, "failed to get clock for rotator\n");
> +		return -ENXIO;
> +	}
> +
> +	rot->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
> +	if (IS_ERR(rot->alloc_ctx)) {
> +		dev_err(&pdev->dev, "failed to get alloc_ctx\n");
> +		ret = -EPERM;
> +		goto err;
> +	}
> +
> +	ret = rot_register_m2m_device(rot);
> +	if (ret) {
> +		dev_err(&pdev->dev, "failed to register m2m device\n");
> +		ret = -EPERM;
> +		goto err;
> +	}
> +
> +#ifdef CONFIG_PM_RUNTIME
> +	pm_runtime_enable(&pdev->dev);
> +#else
> +	rot_runtime_resume(&pdev->dev);
> +#endif

Hmm, not very pretty. At least it could be simplified to:

	pm_runtime_enable(&pdev->dev);

#ifndef CONFIG_PM_RUNTIME
	rot_runtime_resume(&pdev->dev);
#endif

> +	dev_info(&pdev->dev, "rotator registered successfully\n");
> +
> +	return 0;
> +
> +err:
> +	clk_put(rot->clock);
> +	return ret;
> +}
> +
> +static int rot_remove(struct platform_device *pdev)
> +{
> +	struct rot_dev *rot = (struct rot_dev *)platform_get_drvdata(pdev);

The is no need for casting from void *.

> +	clk_put(rot->clock);
> +#ifdef CONFIG_PM_RUNTIME
> +	pm_runtime_disable(&pdev->dev);
> +#else
> +	rot_runtime_suspend(&pdev->dev);
> +#endif

pm_runtime_disable() is a no op when CONFIG_PM_RUNTIME is disabled.
So it could be changed to:

	pm_runtime_disable(&pdev->dev);

#ifndef CONFIG_PM_RUNTIME
	rot_runtime_suspend(&pdev->dev);
#endif

> +	if (timer_pending(&rot->wdt.timer))
> +		del_timer(&rot->wdt.timer);
> +
> +	return 0;
> +}
> +
...
> +void rot_dump_register(struct rot_dev *rot)

rot_dump_registers ?

> +{
> +	unsigned int tmp, i;
> +
> +	rot_dbg("dump rotator registers\n");
> +	for (i = 0; i<= ROTATOR_DST; i += 0x4) {
> +		tmp = readl(rot->regs + i);
> +		rot_dbg("0x%08x: 0x%08x", i, tmp);
> +	}
> +}
...
> diff --git a/drivers/media/video/exynos/rotator/rotator.h b/drivers/media/video/exynos/rotator/rotator.h
> new file mode 100644
> index 0000000..4034383
> --- /dev/null
> +++ b/drivers/media/video/exynos/rotator/rotator.h
> @@ -0,0 +1,286 @@
> +/*
> + * Copyright (c) 2012 Samsung Electronics Co., Ltd.
> + *		http://www.samsung.com
> + *
> + * Header file for Exynos Rotator driver
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> +*/
> +
> +#ifndef ROTATOR__H_
> +#define ROTATOR__H_
> +
> +#include<linux/delay.h>
> +#include<linux/sched.h>
> +#include<linux/spinlock.h>
> +#include<linux/types.h>
> +#include<linux/videodev2.h>
> +#include<linux/io.h>

> +#include<linux/pm_runtime.h>

Probably this one should be included explicitly only in the .c files.

> +#include<media/videobuf2-core.h>
> +#include<media/v4l2-ctrls.h>
> +#include<media/v4l2-device.h>
> +#include<media/v4l2-mem2mem.h>
> +
> +#include "rotator-regs.h"
> +
> +extern int log_level;
> +
> +#define rot_dbg(fmt, args...)						\
> +	do {								\
> +		if (log_level)						\
> +			printk(KERN_DEBUG "[%s:%d] "			\
> +			fmt, __func__, __LINE__, ##args);		\
> +	} while (0)
> +
> +/* Time to wait for frame done interrupt */
> +#define ROT_TIMEOUT			(2 * HZ)
> +#define ROT_WDT_CNT			5
> +#define MODULE_NAME		"exynos-rot"
> +#define ROT_MAX_DEVS			1

If there is no more than one hardware instance in each SoC maybe it's worth
to drop ROT_MAX_DEVS and all the code around it ?

> +
> +/* Address index */
> +#define ROT_ADDR_RGB			0
> +#define ROT_ADDR_Y			0
> +#define ROT_ADDR_CB			1
> +#define ROT_ADDR_CBCR			1
> +#define ROT_ADDR_CR			2
> +
> +/* Rotator flip direction */
> +#define ROT_NOFLIP		(1<<  0)
> +#define ROT_VFLIP		(1<<  1)
> +#define ROT_HFLIP		(1<<  2)
> +
> +/* Rotator hardware device state */
> +#define DEV_RUN			(1<<  0)
> +#define DEV_SUSPEND		(1<<  1)
> +
> +/* Rotator m2m context state */
> +#define CTX_PARAMS		(1<<  0)
> +#define CTX_STREAMING		(1<<  1)
> +#define CTX_RUN			(1<<  2)
> +#define CTX_ABORT		(1<<  3)
> +#define CTX_SRC			(1<<  4)
> +#define CTX_DST			(1<<  5)
> +
> +enum rot_irq_src {
> +	ISR_PEND_DONE = 8,
> +	ISR_PEND_ILLEGAL = 9,
> +};
> +
> +enum rot_status {
> +	ROT_IDLE,
> +	ROT_RESERVED,
> +	ROT_RUNNING,
> +	ROT_RUNNING_REMAIN,
> +};
> +
> +/*
> + * struct exynos_rot_size_limit - Rotator variant size  information
> + *
> + * @min_x: minimum pixel x size
> + * @min_y: minimum pixel y size
> + * @max_x: maximum pixel x size
> + * @max_y: maximum pixel y size
> + */
> +struct exynos_rot_size_limit {
> +	u32 min_x;
> +	u32 min_y;
> +	u32 max_x;
> +	u32 max_y;
> +	u32 align;
> +};
> +
> +struct exynos_rot_variant {
> +	struct exynos_rot_size_limit limit_rgb565;
> +	struct exynos_rot_size_limit limit_rgb888;
> +	struct exynos_rot_size_limit limit_yuv422;
> +	struct exynos_rot_size_limit limit_yuv420_2p;
> +	struct exynos_rot_size_limit limit_yuv420_3p;
> +};
> +
> +/*
> + * struct exynos_rot_driverdata - per device type driver data for init time.
> + *
> + * @variant: the variant information for this driver.
> + * @nr_dev: number of devices available in SoC
> + */
> +struct exynos_rot_driverdata {
> +	struct exynos_rot_variant	*variant[ROT_MAX_DEVS];
> +	int				nr_dev;

Probably not needed.

> +};
> +
> +/**
> + * struct rot_fmt - the driver's internal color format data
> + * @name: format description
> + * @pixelformat: the fourcc code for this format, 0 if not applicable
> + * @num_planes: number of physically non-contiguous data planes
> + * @num_comp: number of color components(ex. RGB, Y, Cb, Cr)
> + * @bitperpixel: bits per pixel
> + */
> +struct rot_fmt {
> +	char	*name;
> +	u32	pixelformat;
> +	u16	num_planes;
> +	u16	num_comp;
> +	u32	bitperpixel[VIDEO_MAX_PLANES];
> +};
> +
> +struct rot_addr {
> +	dma_addr_t	y;
> +	dma_addr_t	cb;
> +	dma_addr_t	cr;
> +};
> +
> +/*
> + * struct rot_frame - source/target frame properties
> + * @fmt:	buffer format(like virtual screen)
> + * @crop:	image size / position
> + * @addr:	buffer start address(access using ROT_ADDR_XXX)
> + * @bytesused:	image size in bytes (w x h x bpp)
> + * @cacheable:	cache property for image address
> + */
> +struct rot_frame {
> +	struct rot_fmt			*rot_fmt;
> +	struct v4l2_pix_format_mplane	pix_mp;
> +	struct v4l2_rect		crop;
> +	struct rot_addr			addr;
> +	unsigned long			bytesused[VIDEO_MAX_PLANES];
> +	bool				cacheable;

It's also unused, what was this needed for (if at all) ? 

> +};
> +
> +/*
> + * struct rot_m2m_device - v4l2 memory-to-memory device data
> + * @v4l2_dev: v4l2 device
> + * @vfd: the video device node
> + * @m2m_dev: v4l2 memory-to-memory device data
> + * @in_use: the open count
> + */
> +struct rot_m2m_device {
> +	struct v4l2_device	v4l2_dev;
> +	struct video_device	*vfd;
> +	struct v4l2_m2m_dev	*m2m_dev;
> +	atomic_t		in_use;
> +};
> +
> +/*
> + * struct rot_irq - Rotator irq information
> + * @num:	Rotator interrupt number
> + * @wait:	interrupt handler waitqueue
> + */
> +struct rot_irq {
> +	int			num;

It's unused, you can remove it.

> +	wait_queue_head_t	wait;
> +};
> +
> +struct rot_wdt {
> +	struct timer_list	timer;
> +	atomic_t		cnt;
> +};
> +
> +struct rot_ctx;
> +struct rot_vb2;
> +
> +/*
> + * struct rot_dev - the abstraction for Rotator device
> + * @dev:	pointer to the Rotator device
> + * @pdata:	pointer to the device platform data
> + * @variant:	the IP variant information
> + * @m2m:	memory-to-memory V4L2 device information
> + * @id:		Rotator device index (0..ROT_MAX_DEVS)
> + * @clock:	clock required for Rotator operation
> + * @regs:	the mapped hardware registers
> + * @regs_res:	the resource claimed for IO registers
> + * @irq:	irq information
> + * @ws:		work struct
> + * @state:	device state flags
> + * @alloc_ctx:	videobuf2 memory allocator context
> + * @rot_vb2:	videobuf2 memory allocator callbacks
> + * @slock:	the spinlock protecting this data structure
> + * @lock:	the mutex protecting this data structure
> + * @wdt:	watchdog timer information
> + */
> +struct rot_dev {
> +	struct device			*dev;
> +	struct exynos_platform_rot	*pdata;
> +	struct exynos_rot_variant	*variant;
> +	struct rot_m2m_device		m2m;
> +	int				id;
> +	struct clk			*clock;
> +	void __iomem			*regs;
> +	struct rot_irq			irq;
> +	struct work_struct		ws;

irq and ws are not used, are they ?

> +	unsigned long			state;
> +	struct vb2_alloc_ctx		*alloc_ctx;
> +	const struct rot_vb2		*vb2;
> +	spinlock_t			slock;
> +	struct mutex			lock;
> +	struct rot_wdt			wdt;
> +};
> +
> +/*
> + * rot_ctx - the abstration for Rotator open context
> + * @rot_dev:		the Rotator device this context applies to
> + * @m2m_ctx:		memory-to-memory device context
> + * @frame:		source frame properties
> + * @ctrl_handler:	v4l2 controls handler
> + * @fh:			v4l2 file handle
> + * @rotation:		image clockwise rotation in degrees
> + * @flip:		image flip mode
> + * @state:		context state flags
> + * @slock:		spinlock protecting this data structure
> + */
> +struct rot_ctx {
> +	struct rot_dev		*rot_dev;
> +	struct v4l2_m2m_ctx	*m2m_ctx;
> +	struct rot_frame	s_frame;
> +	struct rot_frame	d_frame;
> +	struct v4l2_ctrl_handler	ctrl_handler;
> +	struct v4l2_fh			fh;
> +	int			rotation;
> +	u32			flip;
> +	unsigned long		flags;
> +	spinlock_t		slock;
> +};
...
> +#endif /* ROTATOR__H_ */

Otherwise looks good.

--

Regards,
Sylwester
