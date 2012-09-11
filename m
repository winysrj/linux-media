Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:34864 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757317Ab2IKKuG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Sep 2012 06:50:06 -0400
Received: by oago6 with SMTP id o6so150600oag.19
        for <linux-media@vger.kernel.org>; Tue, 11 Sep 2012 03:50:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1347291000-340-13-git-send-email-p.zabel@pengutronix.de>
References: <1347291000-340-1-git-send-email-p.zabel@pengutronix.de>
	<1347291000-340-13-git-send-email-p.zabel@pengutronix.de>
Date: Tue, 11 Sep 2012 12:50:04 +0200
Message-ID: <CACKLOr06ymPN8Upt0Z_Vdq8=qwAnXOaWd1k3nVMUB3GOCqv1+g@mail.gmail.com>
Subject: Re: [PATCH v4 12/16] media: coda: add byte size slice limit control
From: javier Martin <javier.martin@vista-silicon.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Richard Zhao <richard.zhao@freescale.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10 September 2012 17:29, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  drivers/media/platform/coda.c |   29 +++++++++++++++++++++++------
>  1 file changed, 23 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
> index 81e3401..863b96a 100644
> --- a/drivers/media/platform/coda.c
> +++ b/drivers/media/platform/coda.c
> @@ -151,6 +151,7 @@ struct coda_params {
>         enum v4l2_mpeg_video_multi_slice_mode slice_mode;
>         u32                     framerate;
>         u16                     bitrate;
> +       u32                     slice_max_bits;
>         u32                     slice_max_mb;
>  };
>
> @@ -1056,12 +1057,23 @@ static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
>                 return -EINVAL;
>         }
>
> -       value  = (ctx->params.slice_max_mb & CODA_SLICING_SIZE_MASK) << CODA_SLICING_SIZE_OFFSET;
> -       value |= (1 & CODA_SLICING_UNIT_MASK) << CODA_SLICING_UNIT_OFFSET;
> -       if (ctx->params.slice_mode == V4L2_MPEG_VIDEO_MULTI_SICE_MODE_MAX_MB)
> +       switch (ctx->params.slice_mode) {
> +       case V4L2_MPEG_VIDEO_MULTI_SLICE_MODE_SINGLE:
> +               value = 0;
> +               break;
> +       case V4L2_MPEG_VIDEO_MULTI_SICE_MODE_MAX_MB:
> +               value  = (ctx->params.slice_max_mb & CODA_SLICING_SIZE_MASK) << CODA_SLICING_SIZE_OFFSET;
> +               value |= (1 & CODA_SLICING_UNIT_MASK) << CODA_SLICING_UNIT_OFFSET;
> +               value |=  1 & CODA_SLICING_MODE_MASK;
> +               break;
> +       case V4L2_MPEG_VIDEO_MULTI_SICE_MODE_MAX_BYTES:
> +               value  = (ctx->params.slice_max_bits & CODA_SLICING_SIZE_MASK) << CODA_SLICING_SIZE_OFFSET;
> +               value |= (0 & CODA_SLICING_UNIT_MASK) << CODA_SLICING_UNIT_OFFSET;
>                 value |=  1 & CODA_SLICING_MODE_MASK;
> +               break;
> +       }
>         coda_write(dev, value, CODA_CMD_ENC_SEQ_SLICE_MODE);
> -       value  =  ctx->params.gop_size & CODA_GOP_SIZE_MASK;
> +       value = ctx->params.gop_size & CODA_GOP_SIZE_MASK;
>         coda_write(dev, value, CODA_CMD_ENC_SEQ_GOP_SIZE);
>
>         if (ctx->params.bitrate) {
> @@ -1308,6 +1320,9 @@ static int coda_s_ctrl(struct v4l2_ctrl *ctrl)
>         case V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MAX_MB:
>                 ctx->params.slice_max_mb = ctrl->val;
>                 break;
> +       case V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MAX_BYTES:
> +               ctx->params.slice_max_bits = ctrl->val * 8;
> +               break;
>         case V4L2_CID_MPEG_VIDEO_HEADER_MODE:
>                 break;
>         default:
> @@ -1346,10 +1361,12 @@ static int coda_ctrls_setup(struct coda_ctx *ctx)
>                 V4L2_CID_MPEG_VIDEO_MPEG4_P_FRAME_QP, 1, 31, 1, 2);
>         v4l2_ctrl_new_std_menu(&ctx->ctrls, &coda_ctrl_ops,
>                 V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MODE,
> -               V4L2_MPEG_VIDEO_MULTI_SICE_MODE_MAX_MB, 0,
> -               V4L2_MPEG_VIDEO_MULTI_SICE_MODE_MAX_MB);
> +               V4L2_MPEG_VIDEO_MULTI_SICE_MODE_MAX_BYTES, 0x7,
> +               V4L2_MPEG_VIDEO_MULTI_SLICE_MODE_SINGLE);

The mask must be 0x0 instead of 0x7. Otherwise you are forbidding all
the possible values for this ctrl and that won't work.

>         v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
>                 V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MAX_MB, 1, 0x3fffffff, 1, 1);
> +       v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
> +               V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MAX_BYTES, 1, 0x3fffffff, 1, 500);
>         v4l2_ctrl_new_std_menu(&ctx->ctrls, &coda_ctrl_ops,
>                 V4L2_CID_MPEG_VIDEO_HEADER_MODE,
>                 V4L2_MPEG_VIDEO_HEADER_MODE_JOINED_WITH_1ST_FRAME,
> --
> 1.7.10.4
>

Regards.

-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
