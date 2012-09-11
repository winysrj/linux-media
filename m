Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:61132 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757317Ab2IKKsH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Sep 2012 06:48:07 -0400
Received: by mail-ob0-f174.google.com with SMTP id uo13so487437obb.19
        for <linux-media@vger.kernel.org>; Tue, 11 Sep 2012 03:48:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1347291000-340-11-git-send-email-p.zabel@pengutronix.de>
References: <1347291000-340-1-git-send-email-p.zabel@pengutronix.de>
	<1347291000-340-11-git-send-email-p.zabel@pengutronix.de>
Date: Tue, 11 Sep 2012 12:48:06 +0200
Message-ID: <CACKLOr0EUmAEYFtiQV_SZOcjEGOWrBD=ijNeyUZWK4LqwmqHQA@mail.gmail.com>
Subject: Re: [PATCH v4 10/16] media: coda: fix sizeimage setting in try_fmt
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
> VIDIOC_TRY_FMT would incorrectly return bytesperline * height,
> instead of width * height * 3 / 2.
>
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  drivers/media/platform/coda.c |   10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
> index fe8a397..e8ed427 100644
> --- a/drivers/media/platform/coda.c
> +++ b/drivers/media/platform/coda.c
> @@ -407,8 +407,8 @@ static int vidioc_try_fmt(struct coda_dev *dev, struct v4l2_format *f)
>                                       W_ALIGN, &f->fmt.pix.height,
>                                       MIN_H, MAX_H, H_ALIGN, S_ALIGN);
>                 f->fmt.pix.bytesperline = round_up(f->fmt.pix.width, 2);
> -               f->fmt.pix.sizeimage = f->fmt.pix.height *
> -                                       f->fmt.pix.bytesperline;
> +               f->fmt.pix.sizeimage = f->fmt.pix.width *
> +                                       f->fmt.pix.height * 3 / 2;
>         } else { /*encoded formats h.264/mpeg4 */
>                 f->fmt.pix.bytesperline = 0;
>                 f->fmt.pix.sizeimage = CODA_MAX_FRAME_SIZE;
> @@ -492,11 +492,7 @@ static int vidioc_s_fmt(struct coda_ctx *ctx, struct v4l2_format *f)
>         q_data->fmt = find_format(ctx->dev, f);
>         q_data->width = f->fmt.pix.width;
>         q_data->height = f->fmt.pix.height;
> -       if (q_data->fmt->fourcc == V4L2_PIX_FMT_YUV420) {
> -               q_data->sizeimage = q_data->width * q_data->height * 3 / 2;
> -       } else { /* encoded format h.264/mpeg-4 */
> -               q_data->sizeimage = CODA_MAX_FRAME_SIZE;
> -       }
> +       q_data->sizeimage = f->fmt.pix.sizeimage;
>
>         v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
>                 "Setting format for type %d, wxh: %dx%d, fmt: %d\n",
> --
> 1.7.10.4
>

Tested-by: Javier Martin <javier.martin@vista-silicon.com

-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
