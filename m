Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:62756 "EHLO
	mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754498AbbB0I7q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Feb 2015 03:59:46 -0500
Received: by mail-oi0-f54.google.com with SMTP id v63so14465971oia.13
        for <linux-media@vger.kernel.org>; Fri, 27 Feb 2015 00:59:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1424704813-20792-11-git-send-email-p.zabel@pengutronix.de>
References: <1424704813-20792-1-git-send-email-p.zabel@pengutronix.de> <1424704813-20792-11-git-send-email-p.zabel@pengutronix.de>
From: Jean-Michel Hautbois <jhautbois@gmail.com>
Date: Fri, 27 Feb 2015 09:59:30 +0100
Message-ID: <CAL8zT=iEZC4beWdMQD-vagRh9E7nwqprqrtRB7FVR9wpre45OQ@mail.gmail.com>
Subject: Re: [PATCH 10/12] [media] coda: fail to start streaming if userspace
 set invalid formats
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Kamil Debski <k.debski@samsung.com>,
	Peter Seiderer <ps.report@gmx.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sascha Hauer <kernel@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

2015-02-23 16:20 GMT+01:00 Philipp Zabel <p.zabel@pengutronix.de>:
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  drivers/media/platform/coda/coda-common.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
> index b42ccfc..4441179 100644
> --- a/drivers/media/platform/coda/coda-common.c
> +++ b/drivers/media/platform/coda/coda-common.c
> @@ -1282,12 +1282,23 @@ static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
>         if (!(ctx->streamon_out & ctx->streamon_cap))
>                 return 0;
>
> +       q_data_dst = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
> +       if ((q_data_src->width != q_data_dst->width &&
> +            round_up(q_data_src->width, 16) != q_data_dst->width) ||
> +           (q_data_src->height != q_data_dst->height &&
> +            round_up(q_data_src->height, 16) != q_data_dst->height)) {
> +               v4l2_err(v4l2_dev, "can't convert %dx%d to %dx%d\n",
> +                        q_data_src->width, q_data_src->height,
> +                        q_data_dst->width, q_data_dst->height);
> +               ret = -EINVAL;
> +               goto err;
> +       }
> +

Shouldn't the driver check on queues related to encoding or decoding only ?
We don't need to set correct width/height from userspace if we are
encoding, or it should be done by s_fmt itself.

Thanks,
JM
