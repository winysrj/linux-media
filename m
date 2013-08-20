Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qe0-f42.google.com ([209.85.128.42]:45275 "EHLO
	mail-qe0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162Ab3HTFnV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Aug 2013 01:43:21 -0400
MIME-Version: 1.0
In-Reply-To: <52121844.3030300@xs4all.nl>
References: <1376909932-23644-1-git-send-email-shaik.ameer@samsung.com>
	<1376909932-23644-3-git-send-email-shaik.ameer@samsung.com>
	<52121844.3030300@xs4all.nl>
Date: Tue, 20 Aug 2013 11:13:20 +0530
Message-ID: <CAOD6ATqTz+xTqwXe0PvQq43fk4AiAdcMy-RwbOczU++dXZOyyQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/5] [media] exynos-mscl: Add core functionality for
 the M-Scaler driver
From: Shaik Ameer Basha <shaik.samsung@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Shaik Ameer Basha <shaik.ameer@samsung.com>,
	LMML <linux-media@vger.kernel.org>,
	linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	posciak@google.com, Arun Kumar K <arun.kk@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

+ linux-media, linux-samsung-soc

Hi Hans,

Thanks for the review.
Will address all your comments in v3.

I have only one doubt regarding try_ctrl... (addressed inline)


On Mon, Aug 19, 2013 at 6:36 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> On 08/19/2013 12:58 PM, Shaik Ameer Basha wrote:
> > This patch adds the core functionality for the M-Scaler driver.
>
> Some more comments below...
>
> >
> > Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
> > ---
> >  drivers/media/platform/exynos-mscl/mscl-core.c | 1312 ++++++++++++++++++++++++
> >  drivers/media/platform/exynos-mscl/mscl-core.h |  549 ++++++++++
> >  2 files changed, 1861 insertions(+)
> >  create mode 100644 drivers/media/platform/exynos-mscl/mscl-core.c
> >  create mode 100644 drivers/media/platform/exynos-mscl/mscl-core.h
> >
> > diff --git a/drivers/media/platform/exynos-mscl/mscl-core.c b/drivers/media/platform/exynos-mscl/mscl-core.c
> > new file mode 100644
> > index 0000000..4a3a851
> > --- /dev/null
> > +++ b/drivers/media/platform/exynos-mscl/mscl-core.c
> > @@ -0,0 +1,1312 @@
> > +/*
> > + * Copyright (c) 2013 - 2014 Samsung Electronics Co., Ltd.
> > + *           http://www.samsung.com
> > + *
> > + * Samsung EXYNOS5 SoC series M-Scaler driver
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License as published
> > + * by the Free Software Foundation, either version 2 of the License,
> > + * or (at your option) any later version.
> > + */
> > +
> > +#include <linux/clk.h>
> > +#include <linux/interrupt.h>

[snip]

> > +
> > +static int __mscl_s_ctrl(struct mscl_ctx *ctx, struct v4l2_ctrl *ctrl)
> > +{
> > +     struct mscl_dev *mscl = ctx->mscl_dev;
> > +     struct mscl_variant *variant = mscl->variant;
> > +     unsigned int flags = MSCL_DST_FMT | MSCL_SRC_FMT;
> > +     int ret = 0;
> > +
> > +     if (ctrl->flags & V4L2_CTRL_FLAG_INACTIVE)
> > +             return 0;
>
> Why would you want to do this check?

Will remove this. seems no such check is required for this driver.

>
> > +
> > +     switch (ctrl->id) {
> > +     case V4L2_CID_HFLIP:
> > +             ctx->hflip = ctrl->val;
> > +             break;
> > +
> > +     case V4L2_CID_VFLIP:
> > +             ctx->vflip = ctrl->val;
> > +             break;
> > +
> > +     case V4L2_CID_ROTATE:
> > +             if ((ctx->state & flags) == flags) {
> > +                     ret = mscl_check_scaler_ratio(variant,
> > +                                     ctx->s_frame.crop.width,
> > +                                     ctx->s_frame.crop.height,
> > +                                     ctx->d_frame.crop.width,
> > +                                     ctx->d_frame.crop.height,
> > +                                     ctx->ctrls_mscl.rotate->val);
> > +
> > +                     if (ret)
> > +                             return -EINVAL;
> > +             }
>
> I think it would be good if the try_ctrl op is implemented so you can call
> VIDIOC_EXT_TRY_CTRLS in the application to check if the ROTATE control can be
> set.

* @try_ctrl: Test whether the control's value is valid. Only relevant when
* the usual min/max/step checks are not sufficient.

As we support only 0,90,270 and the min, max and step can address these values,
does it really relevant to have try_ctrl op here ???

Regards,
Shaik Ameer Basha

>
> > +
> > +             ctx->rotation = ctrl->val;
> > +             break;
> > +
> > +     case V4L2_CID_ALPHA_COMPONENT:
> > +             ctx->d_frame.alpha = ctrl->val;
> > +             break;
> > +     }
> > +
> > +     ctx->state |= MSCL_PARAMS;
> > +     return 0;
> > +}
> > +
> > +static int mscl_s_ctrl(struct v4l2_ctrl *ctrl)
> > +{
> > +     struct mscl_ctx *ctx = ctrl_to_ctx(ctrl);
> > +     unsigned long flags;
> > +     int ret;
> > +
> > +     spin_lock_irqsave(&ctx->mscl_dev->slock, flags);
> > +     ret = __mscl_s_ctrl(ctx, ctrl);
> > +     spin_unlock_irqrestore(&ctx->mscl_dev->slock, flags);
> > +
> > +     return ret;
> > +}
> > +
> > +static const struct v4l2_ctrl_ops mscl_ctrl_ops = {
> > +     .s_ctrl = mscl_s_ctrl,
> > +};
>
> Thanks for the patches!
>
> Regards,
>
>         Hans
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
