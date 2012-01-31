Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qw0-f53.google.com ([209.85.216.53]:36105 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794Ab2AaFHn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Jan 2012 00:07:43 -0500
Received: by qafk1 with SMTP id k1so2228667qaf.19
        for <linux-media@vger.kernel.org>; Mon, 30 Jan 2012 21:07:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <008b01ccdf54$962229d0$c2667d70$%debski@samsung.com>
References: <1327917523-29836-1-git-send-email-sachin.kamat@linaro.org>
	<201201301311.48370.laurent.pinchart@ideasonboard.com>
	<008b01ccdf54$962229d0$c2667d70$%debski@samsung.com>
Date: Tue, 31 Jan 2012 10:37:42 +0530
Message-ID: <CAK9yfHxSFqD=wTKDrt25Gw2uvMWw+eKBmNeO_HQbOE5ycMG3rw@mail.gmail.com>
Subject: Re: [PATCH][media] s5p-g2d: Add HFLIP and VFLIP support
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Kamil Debski <k.debski@samsung.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, mchehab@infradead.org,
	kyungmin.park@samsung.com, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent, Sylwester and Kamil,

Thank you for your comments and suggestions.
I will re-send the patch with the following 2 changes:

1. Error checking done only once at the end of the init call.
2. Modification in switch case as suggested by Kamil.

Regards
Sachin

On 30 January 2012 19:09, Kamil Debski <k.debski@samsung.com> wrote:
> Hi Laurent and Sachin,
>
> Thanks for the patch and for your comments.
>
>> From: Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com]
>> Sent: 30 January 2012 13:12
>>
>> Hi Sashin,
>>
>> Thanks for the patch.
>>
>> On Monday 30 January 2012 10:58:43 Sachin Kamat wrote:
>> > This patch adds support for flipping the image horizontally and vertically.
>> >
>> > Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
>> > ---
>> >  drivers/media/video/s5p-g2d/g2d-hw.c |    5 +++
>> >  drivers/media/video/s5p-g2d/g2d.c    |   47 +++++++++++++++++++++++++----
>> --
>> >  drivers/media/video/s5p-g2d/g2d.h    |    3 ++
>> >  3 files changed, 46 insertions(+), 9 deletions(-)
>>
>> [snip]
>>
>> > diff --git a/drivers/media/video/s5p-g2d/g2d.c
>> > b/drivers/media/video/s5p-g2d/g2d.c index febaa67..dea9701 100644
>> > --- a/drivers/media/video/s5p-g2d/g2d.c
>> > +++ b/drivers/media/video/s5p-g2d/g2d.c
>> > @@ -178,6 +178,7 @@ static int g2d_s_ctrl(struct v4l2_ctrl *ctrl)
>> >  {
>> >     struct g2d_ctx *ctx = container_of(ctrl->handler, struct g2d_ctx,
>> >                                                             ctrl_handler);
>> > +
>> >     switch (ctrl->id) {
>> >     case V4L2_CID_COLORFX:
>> >             if (ctrl->val == V4L2_COLORFX_NEGATIVE)
>> > @@ -185,6 +186,21 @@ static int g2d_s_ctrl(struct v4l2_ctrl *ctrl)
>> >             else
>> >                     ctx->rop = ROP4_COPY;
>> >             break;
>> > +
>> > +   case V4L2_CID_HFLIP:
>> > +           if (ctrl->val == 1)
>> > +                   ctx->hflip = 1;
>> > +           else
>> > +                   ctx->hflip = 0;
>> > +           break;
>> > +
>> > +   case V4L2_CID_VFLIP:
>> > +           if (ctrl->val == 1)
>> > +                   ctx->vflip = (1 << 1);
>> > +           else
>> > +                   ctx->vflip = 0;
>> > +           break;
>
> I think that
>
> case V4L2_CID_HFLIP:
>        ctx->hflip = ctrl->val;
>        break;
>
> case V4L2_CID_VFLIP:
>        ctx->vflip = (ctrl->val << 1);
>        break;
>
> will be sufficient, as flip controls have min=0 and max=1 which makes
> them safe to use.
>
>> > +
>> >     default:
>> >             v4l2_err(&ctx->dev->v4l2_dev, "unknown control\n");
>> >             return -EINVAL;
>> > @@ -200,11 +216,9 @@ int g2d_setup_ctrls(struct g2d_ctx *ctx)
>> >  {
>> >     struct g2d_dev *dev = ctx->dev;
>> >
>> > -   v4l2_ctrl_handler_init(&ctx->ctrl_handler, 1);
>> > -   if (ctx->ctrl_handler.error) {
>> > -           v4l2_err(&dev->v4l2_dev, "v4l2_ctrl_handler_init failed\n");
>> > -           return ctx->ctrl_handler.error;
>> > -   }
>> > +   v4l2_ctrl_handler_init(&ctx->ctrl_handler, 3);
>> > +   if (ctx->ctrl_handler.error)
>> > +           goto error;
>>
>> There's not need to verify ctx->ctrl_handler.error after every call to
>> v4l2_ctrl_handler_init() or v4l2_ctrl_new_*(). You can verify it once only
>> after initialization all controls.
>
> I agree.
>
>> >
>> >     v4l2_ctrl_new_std_menu(
>> >             &ctx->ctrl_handler,
>> > @@ -214,12 +228,25 @@ int g2d_setup_ctrls(struct g2d_ctx *ctx)
>> >             ~((1 << V4L2_COLORFX_NONE) | (1 << V4L2_COLORFX_NEGATIVE)),
>> >             V4L2_COLORFX_NONE);
>> >
>> > -   if (ctx->ctrl_handler.error) {
>> > -           v4l2_err(&dev->v4l2_dev, "v4l2_ctrl_handler_init failed\n");
>> > -           return ctx->ctrl_handler.error;
>> > -   }
>> > +   if (ctx->ctrl_handler.error)
>> > +           goto error;
>> > +
>> > +   v4l2_ctrl_new_std(&ctx->ctrl_handler, &g2d_ctrl_ops,
>> > +                                           V4L2_CID_HFLIP, 0, 1, 1, 0);
>> > +   if (ctx->ctrl_handler.error)
>> > +           goto error;
>> > +
>> > +   v4l2_ctrl_new_std(&ctx->ctrl_handler, &g2d_ctrl_ops,
>> > +                                           V4L2_CID_VFLIP, 0, 1, 1, 0);
>>
>> As a single register controls hflip and vflip, you should group the two
>> controls in a cluster.
>
> I think it doesn't matter in this use case. As register are not written
> in the g2d_s_ctrl. Because the driver uses multiple context it modifies
> the appropriate values in its context structure and registers are written
> when the transaction is run.
>
> Also there is no logical connection between horizontal and vertical flip.
> I think this is the case when using clusters. Here one is independent from
> another.
>
>>
>> > +   if (ctx->ctrl_handler.error)
>> > +           goto error;
>> >
>> >     return 0;
>> > +
>> > +error:
>> > +   v4l2_err(&dev->v4l2_dev, "v4l2_ctrl_handler_init failed\n");
>> > +   return ctx->ctrl_handler.error;
>> > +
>> >  }
>> >
>> >  static int g2d_open(struct file *file)
>> > @@ -564,6 +591,8 @@ static void device_run(void *prv)
>> >     g2d_set_dst_addr(dev, vb2_dma_contig_plane_dma_addr(dst, 0));
>> >
>> >     g2d_set_rop4(dev, ctx->rop);
>> > +   g2d_set_flip(dev, ctx->hflip | ctx->vflip);
>> > +
>>
>> Is this called for every frame, or once at stream start only ? In the later
>> case, this means that hflip and vflip won't be changeable during streaming.
>> Is
>> that on purpose ?
>>
>> >     if (ctx->in.c_width != ctx->out.c_width ||
>> >             ctx->in.c_height != ctx->out.c_height)
>> >             cmd |= g2d_cmd_stretch(1);
>> > diff --git a/drivers/media/video/s5p-g2d/g2d.h
>> > b/drivers/media/video/s5p-g2d/g2d.h index 5eae901..b3be3c8 100644
>> > --- a/drivers/media/video/s5p-g2d/g2d.h
>> > +++ b/drivers/media/video/s5p-g2d/g2d.h
>> > @@ -59,6 +59,8 @@ struct g2d_ctx {
>> >     struct g2d_frame        out;
>> >     struct v4l2_ctrl_handler ctrl_handler;
>> >     u32 rop;
>> > +   u32 hflip;
>> > +   u32 vflip;
>> >  };
>> >
>> >  struct g2d_fmt {
>> > @@ -77,6 +79,7 @@ void g2d_set_dst_addr(struct g2d_dev *d, dma_addr_t a);
>> >  void g2d_start(struct g2d_dev *d);
>> >  void g2d_clear_int(struct g2d_dev *d);
>> >  void g2d_set_rop4(struct g2d_dev *d, u32 r);
>> > +void g2d_set_flip(struct g2d_dev *d, u32 r);
>> >  u32 g2d_cmd_stretch(u32 e);
>> >  void g2d_set_cmd(struct g2d_dev *d, u32 c);
>>
>
> Best wishes,
> --
> Kamil Debski
> Linux Platform Group
> Samsung Poland R&D Center
>



-- 
With warm regards,
Sachin
