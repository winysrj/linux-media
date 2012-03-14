Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:33670 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758550Ab2CNUSO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Mar 2012 16:18:14 -0400
Received: by bkcik5 with SMTP id ik5so1602122bkc.19
        for <linux-media@vger.kernel.org>; Wed, 14 Mar 2012 13:18:12 -0700 (PDT)
Message-ID: <4F60FD00.4060509@gmail.com>
Date: Wed, 14 Mar 2012 21:18:08 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Sunyoung Kang <sy0816.kang@samsung.com>
CC: linux-media@vger.kernel.org,
	'Mauro Carvalho Chehab' <mchehab@infradead.org>,
	jonghun.han@samsung.com, khw0178.kim@samsung.com,
	sungchun.kang@samsung.com, younglak1004.kim@samsung.com,
	kgene.kim@samsung.com, a.sim@samsung.com
Subject: Re: [PATCH] media: rotator: Add new image rotator driver for EXYNOS
References: <06a301ccf6df$70c28d40$5247a7c0$%kang@samsung.com> <4F4E9692.2000602@gmail.com> <000f01cd01b5$14787780$3d696680$%kang@samsung.com>
In-Reply-To: <000f01cd01b5$14787780$3d696680$%kang@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/14/2012 08:35 AM, Sunyoung Kang wrote:
> Hi Sylwester
> 
> Thank you for your comment and sorry for late answer.

You're welcome, no problem at all. Thanks for addressing my comments.

>> Hi Sunyoung,
>>
>> Please see my comments below (just a quick review)...
>>
>> On 02/29/2012 01:41 PM, Sunyoung Kang wrote:
>>>
>>> This patch adds support image rotator driver for EXYNOS
>>> SoCs and this is including following:
>>> 1) Image format
>>>     : RGB565/888, YUV422 1p, YUV420 2p/3p
>>> 2) Rotation
>>>     : 0/90/180/270 degree and X/Y Flip
>>>
>>> Signed-off-by: Ayoung Sim<a.sim@samsung.com>
>>> Signed-off-by: Sunyoung Kang<sy0816.kang@samsung.com>
>>> ---
>>> NOTE:
>>> This patch has been created based on following
>>> - media: media-dev: Add media devices for EXYNOS5 by Sungchun Kang
>>> - media: fimc-lite: Add new driver for camera interface by Sungchun Kang
>>>
>>> Dear Mauro,
>>>
>>> I couldn't find your review on Sungchun Kang's patches has been submitted 2weeks ago.
>>> Since this is based on them, we _really_ need your comments on that.
>>
>> I'm going to review those patches, just need to find time for that.
>> I have some serious doubts to your high level driver design, plus we will need
>> to agree on the code reuse with the s5p-fimc driver, since some devices are
>> common for exynos4 and exynos5. And you seem to just have ignored that fact.
>>
>> It is always better to consult as early as possible, to avoid significant time
>> waste, when lot's of code has to be rewritten.
>>
> 
> And we created exynos directory for EXYNOS IPs including new one like g-scaler 
> and rotator, and put this rotator into it. Do you have any idea for this new 
> rotator driver location?

I think creating new drivers/media/exynos directory is just fine. It sounds
reasonable, given many various multimedia IPs in the Exynos SoCs. 
Maybe we should move some of the existing media/s5p-* drivers under common
'exynos' directory. The files' layout is not much of an issue, I was more 
concerned about how you chose to code the interactions between various drivers.

I'm wondering whether this driver could also support rotator available in 
exynos4210+ SoCs. Have you perhaps had a look what rotator IP differences across
these SoCs ? I'm not asking you to work on that at this moment, I'm fine with 
this driver supporting only exynos5 for initial version for kernel 3.5. 
It would be good to take a look at that issue though.

Then the driver would be in drivers/media/exynos/rotator, but supporting 
SoCs starting from exynos4210, and maybe s5pv210. BTW, do you know if s5pv210
is also known as exynos3110 ? Or are those different SoCs ?


>>>    drivers/media/video/exynos/Kconfig                |    1 +
>>>    drivers/media/video/exynos/Makefile               |    1 +
>>>    drivers/media/video/exynos/rotator/Kconfig        |   12 +
>>>    drivers/media/video/exynos/rotator/Makefile       |    9 +
>>>    drivers/media/video/exynos/rotator/rotator-core.c | 1490 +++++++++++++++++++++
>>>    drivers/media/video/exynos/rotator/rotator-regs.c |  215 +++
>>>    drivers/media/video/exynos/rotator/rotator-regs.h |   70 +
>>>    drivers/media/video/exynos/rotator/rotator.h      |  325 +++++
>>>    8 files changed, 2123 insertions(+), 0 deletions(-)
>>>    create mode 100644 drivers/media/video/exynos/rotator/Kconfig
>>>    create mode 100644 drivers/media/video/exynos/rotator/Makefile
>>>    create mode 100644 drivers/media/video/exynos/rotator/rotator-core.c
>>>    create mode 100644 drivers/media/video/exynos/rotator/rotator-regs.c
>>>    create mode 100644 drivers/media/video/exynos/rotator/rotator-regs.h
>>>    create mode 100644 drivers/media/video/exynos/rotator/rotator.h
>>>
>>> diff --git a/drivers/media/video/exynos/Kconfig b/drivers/media/video/exynos/Kconfig
>>> index a84097d..38a885d 100644
>>> --- a/drivers/media/video/exynos/Kconfig
>>> +++ b/drivers/media/video/exynos/Kconfig
>>> @@ -12,6 +12,7 @@ config VIDEO_EXYNOS
>>>    if VIDEO_EXYNOS
>>>    	source "drivers/media/video/exynos/mdev/Kconfig"
>>>    	source "drivers/media/video/exynos/fimc-lite/Kconfig"
>>> +	source "drivers/media/video/exynos/rotator/Kconfig"
>>
>> Shouldn't you just include here
>>
>> 	source "drivers/media/video/exynos/Kconfig"
>>
>> and handle individual devices under drivers/media/video/exynos/Kconfig ?
>>
> 
> We found that Kconfig uses like this in almost of sub-directory structure.
 
OK, just a suggestion.

...
>>> diff --git a/drivers/media/video/exynos/rotator/rotator-core.c
>> b/drivers/media/video/exynos/rotator/rotator-core.c
>>> new file mode 100644
>>> index 0000000..0c91196
>>> --- /dev/null
>>> +++ b/drivers/media/video/exynos/rotator/rotator-core.c
>>> @@ -0,0 +1,1490 @@
>>> +/*
>>> + * Copyright (c) 2012 Samsung Electronics Co., Ltd.
>>> + *		http://www.samsung.com
>>> + *
>>> + * Core file for Samsung EXYNOS Image Rotator driver
>>> + *
>>> + * This program is free software; you can redistribute it and/or modify
>>> + * it under the terms of the GNU General Public License version 2 as
>>> + * published by the Free Software Foundation.
>>> +*/
>>> +
>>> +#include<linux/module.h>
>>> +#include<linux/kernel.h>
>>> +#include<linux/version.h>
>>> +#include<linux/platform_device.h>
>>> +#include<linux/interrupt.h>
>>> +#include<linux/clk.h>
>>> +#include<linux/slab.h>
>>> +
>>> +#include<media/v4l2-ioctl.h>
>>> +#include<media/videobuf2-dma-contig.h>
>>> +
>>> +#include "rotator.h"
>>> +
>>> +module_param_named(log_level, log_level, uint, 0644);
>>> +
>>> +static struct rot_fmt rot_formats[] = {
>>> +	{
>>> +		.name		= "RGB565",
>>> +		.pixelformat	= V4L2_PIX_FMT_RGB565,
>>> +		.num_planes	= 1,
>>> +		.nr_comp	= 1,
>>
>> Isn't num_comp better, to be consistent with num_planes ?
> 
> I agree it. It will be changed to num_planes.

Thanks.

>>> +		.bitperpixel	= { 16 },

And how about changing 'bitperpixel' to 'bitsperpixel ? ... :)

>>> +	}, {
>>> +		.name		= "XRGB-8888, 32 bps",
>>> +		.pixelformat	= V4L2_PIX_FMT_RGB32,
>>> +		.num_planes	= 1,
>>> +		.nr_comp	= 1,
>>> +		.bitperpixel	= { 32 },
>>> +	}, {
>>> +		.name		= "YUV 4:2:2 packed, YCbYCr",
>>> +		.pixelformat	= V4L2_PIX_FMT_YUYV,
>>> +		.num_planes	= 1,
>>> +		.nr_comp	= 1,
>>> +		.bitperpixel	= { 16 },
>>> +	}, {
>>> +		.name		= "YUV 4:2:0 non-contiguous 2-planar, Y/CbCr",
>>> +		.pixelformat	= V4L2_PIX_FMT_NV12M,
>>> +		.num_planes	= 2,
>>> +		.nr_comp	= 2,
>>> +		.bitperpixel	= { 8, 4 },
>>> +	}, {
>>> +		.name		= "YUV 4:2:0 non-contiguous 3-planar, Y/Cb/Cr",
>>> +		.pixelformat	= V4L2_PIX_FMT_YUV420M,
>>> +		.num_planes	= 3,
>>> +		.nr_comp	= 3,
>>> +		.bitperpixel	= { 8, 2, 2 },
>>> +	},
>>> +};
...
>>> +static int rot_v4l2_try_fmt_mplane(struct file *file, void *priv,
>>> +				    struct v4l2_format *f)
>>> +{
>>> +	struct rot_ctx *ctx = priv;
>>> +	struct rot_fmt *rot_fmt;
>>> +	struct v4l2_pix_format_mplane *pixm =&f->fmt.pix_mp;
>>> +	int i;
>>> +
>>> +	if (!V4L2_TYPE_IS_MULTIPLANAR(f->type)) {
>>> +		rot_err("not supported format type\n");
>>> +		return -EINVAL;
>>> +	}
>>> +
>>> +	rot_fmt = rot_find_format(f);
>>> +	if (!rot_fmt) {
>>> +		rot_err("not supported format values\n");
>>> +		return -EINVAL;
>>> +	}
>>> +
>>> +	rot_bound_align_image(ctx, rot_fmt,&pixm->width,&pixm->height);
>>> +
>>> +	pixm->num_planes = rot_fmt->num_planes;
>>> +	pixm->colorspace = 0;
>>> +
>>> +	for (i = 0; i<   pixm->num_planes; ++i) {
>>> +		pixm->plane_fmt[i].bytesperline = (pixm->width *
>>> +				rot_fmt->bitperpixel[i])>>   3;
>>> +		pixm->plane_fmt[i].sizeimage = pixm->plane_fmt[i].bytesperline
>>> +				* pixm->height;
>>> +
>>> +		rot_dbg("[%d] plane: bytesperline %d, sizeimage %d\n", i,
>>
>> v4l2_dbg() ?
>>
> Um... Is v4l2_dbg() better than rot_dbg()? OK.. I'll change it to v4l2_dbg().

My point was to remove the usage of custom debug macros and finally remove 
them, if it is possible. If everything what's needed can be achieved through 
the generic code, there may be no point in repeating the macro definitions 
in each driver.

>>> +				pixm->plane_fmt[i].bytesperline,
>>> +				pixm->plane_fmt[i].sizeimage);
>>> +	}
>>> +
>>> +	return 0;
>>> +}
...
>>> +static int rot_v4l2_g_crop(struct file *file, void *fh, struct v4l2_crop *cr)
>>> +{
>>> +	struct rot_ctx *ctx = fh;
>>> +	struct rot_frame *frame;
>>> +
>>> +	frame = ctx_get_frame(ctx, cr->type);
>>> +	if (IS_ERR(frame))
>>> +		return PTR_ERR(frame);
>>> +
>>> +	cr->c = frame->crop;
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static int rot_v4l2_s_crop(struct file *file, void *fh, struct v4l2_crop *cr)
>>> +{
>>> +	struct rot_ctx *ctx = fh;
>>> +	struct rot_frame *frame;
>>> +	struct v4l2_pix_format_mplane *pixm;
>>> +	int i;
>>> +
>>> +	frame = ctx_get_frame(ctx, cr->type);
>>> +	if (IS_ERR(frame))
>>> +		return PTR_ERR(frame);
>>> +
>>> +	if (!test_bit(CTX_PARAMS,&ctx->flags)) {
>>> +		rot_err("color format is not set\n");
>>> +		return -EINVAL;
>>> +	}
>>> +
>>> +	if (cr->c.left<   0 || cr->c.top<   0 ||
>>> +			cr->c.width<   0 || cr->c.height<   0) {
>>> +		rot_err("crop value is negative\n");
>>> +		return -EINVAL;
>>> +	}
>>> +
>>> +	pixm =&frame->pix_mp;
>>> +	rot_adjust_cropinfo(ctx, frame,&cr->c);
>>> +	rot_bound_align_image(ctx, frame->rot_fmt,&cr->c.width,&cr->c.height);
>>> +
>>> +	/* Adjust left/top if cropping rectangle is out of bounds */
>>> +	if (cr->c.left + cr->c.width>   pixm->width) {
>>> +		rot_warn("out of bound left cropping size:left %d, width %d\n",
>>> +				cr->c.left, cr->c.width);
>>> +		cr->c.left = pixm->width - cr->c.width;
>>> +	}
>>> +	if (cr->c.top + cr->c.height>   pixm->height) {
>>> +		rot_warn("out of bound top cropping size:top %d, height %d\n",
>>> +				cr->c.top, cr->c.height);
>>> +		cr->c.top = pixm->height - cr->c.height;
>>> +	}
>>> +
>>> +	frame->crop = cr->c;
>>> +
>>> +	for (i = 0; i<   frame->rot_fmt->num_planes; ++i)
>>> +		frame->bytesused[i] = (cr->c.width * cr->c.height *
>>> +				frame->rot_fmt->bitperpixel[i])>>   3;
>>> +
>>> +	return 0;
>>> +}
>>
>> It would be nice to use to the selection API right away instead, here is some
>> example for a capture device:
>>
>> http://git.infradead.org/users/kmpark/linux-2.6-
>> samsung/commitdiff/06a208bf5925df449a79b600bd33954e1d31a1d3
>>
>> I'm not quite sure right now if it is mandatory.
>>
> 
> Um.. Currently it seems not mandatory and I think rotator doesn't need to it yet.

It would be better though, VIDIOC_S/G_CROP would still have been supported
for user space application through a wrapper at the v4l core, if you implement 
in the driver only vidioc_s/g_selection handlers.

...
>>> +static void rot_m2m_device_run(void *priv)
>>> +{
>>> +	struct rot_ctx *ctx = priv;
>>> +	struct rot_frame *s_frame, *d_frame;
>>> +	struct rot_dev *rot;
>>> +	unsigned long flags, tmp;
>>> +	u32 degree = 0, flip = 0;
>>> +
>>> +	spin_lock_irqsave(&ctx->slock, flags);
>>> +
>>> +	rot = ctx->rot_dev;
>>> +
>>> +	if (test_bit(DEV_RUN,&rot->state)) {
>>> +		rot_err("Rotate is already in progress\n");
>>> +		goto run_unlock;
>>> +	}
>>> +
>>> +	if (test_bit(DEV_SUSPEND,&rot->state)) {
>>> +		rot_err("Rotate is in suspend state\n");
>>> +		goto run_unlock;
>>> +	}
>>> +
>>> +	if (test_bit(CTX_ABORT,&ctx->flags)) {
>>> +		rot_dbg("aborted rot device run\n");
>>> +		goto run_unlock;
>>> +	}
>>> +
>>> +	pm_runtime_get_sync(&ctx->rot_dev->pdev->dev);
>>> +
>>> +	if (rot->m2m.ctx != ctx)
>>
>> What is this check for ? It doesn't make sense when all you do in
>> rot->m2m.ctx != ctx case is assigning ctx's value to rot->m2m.ctx.
>>
> OK. I'll remove it.
> 
>>> +		rot->m2m.ctx = ctx;
>>> +
>>> +	s_frame =&ctx->s_frame;
>>> +	d_frame =&ctx->d_frame;
>>> +
>>> +	/* Configuration rotator registers */
>>> +	rot_hwset_image_format(rot, s_frame->rot_fmt->pixelformat);
>>> +	rot_mapping_flip(ctx,&degree,&flip);
>>> +	rot_hwset_flip(rot, flip);
>>> +	rot_hwset_rotation(rot, degree);
>>> +
>>> +	if (ctx->rotation == 90 || ctx->rotation == 270) {
>>> +		tmp                     = d_frame->pix_mp.height;
>>> +		d_frame->pix_mp.height  = d_frame->pix_mp.width;
>>> +		d_frame->pix_mp.width   = tmp;
>>> +	}
>>> +
>>> +	rot_hwset_src_imgsize(rot, s_frame);
>>> +	rot_hwset_dst_imgsize(rot, d_frame);
>>> +
>>> +	rot_hwset_src_crop(rot,&s_frame->crop);
>>> +	rot_hwset_dst_crop(rot,&d_frame->crop);
>>> +
>>> +	rot_set_frame_addr(ctx);
>>> +
>>> +	/* Enable rotator interrupt */
>>> +	rot_hwset_irq_frame_done(rot, 1);
>>> +	rot_hwset_irq_illegal_config(rot, 1);
>>
>> w00t ? :-) Why are you setting illegal configuration ? ;-)
>>
> 
> It means enabling interrupt (irq) for illegal configuration, not setting 
> illegal config. :)

Ok, now it's all clear;) I didn't look much into details, the name just
looked a bit funny at first sight.

>>> +
>>> +	set_bit(DEV_RUN,&rot->state);
>>> +	set_bit(CTX_RUN,&ctx->flags);
>>> +
>>> +	/* Start rotate operation */
>>> +	rot_hwset_start(rot);
>>> +
>>> +	/* Start watchdog timer */
>>> +	rot->wdt.timer.expires = jiffies + ROT_TIMEOUT;
>>> +	if (timer_pending(&rot->wdt.timer) == 0)
>>> +		add_timer(&rot->wdt.timer);
>>> +	else
>>> +		mod_timer(&rot->wdt.timer, rot->wdt.timer.expires);
>>> +
>>> +run_unlock:
>>> +	spin_unlock_irqrestore(&ctx->slock, flags);
>>> +}
>>> +

--

Regards,
Sylwester
