Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:42225 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713Ab2IMHlx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Sep 2012 03:41:53 -0400
Received: by weyx8 with SMTP id x8so1502878wey.19
        for <linux-media@vger.kernel.org>; Thu, 13 Sep 2012 00:41:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1347462158-20417-14-git-send-email-p.zabel@pengutronix.de>
References: <1347462158-20417-1-git-send-email-p.zabel@pengutronix.de>
	<1347462158-20417-14-git-send-email-p.zabel@pengutronix.de>
Date: Thu, 13 Sep 2012 09:41:52 +0200
Message-ID: <CACKLOr1p2A9bZ45G-b2sExTp3Gx5dM-f=DybJU3nZHkjp73pgg@mail.gmail.com>
Subject: Re: [PATCH v5 13/13] media: coda: set up buffers to be sized as
 negotiated with s_fmt
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

On 12 September 2012 17:02, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> This fixes a failure in vb2_qbuf in user pointer mode where
> __qbuf_userptr checks if the buffer queued by userspace is large
> enough. The failure would happen if coda_queue_setup was called
> with empty fmt (and thus set the expected buffer size to the maximum
> resolution), and userspace queues buffers of smaller size -
> corresponding to the negotiated dimensions - were queued.
> Explicitly setting sizeimage to the value negotiated via s_fmt
> fixes the issue.
>
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---

Acked-by: Javier Martin <javier.martin@vista-silicon.com>

>  drivers/media/platform/coda.c |   13 +++----------
>  1 file changed, 3 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
> index 0235f4e..0e0b4fe 100644
> --- a/drivers/media/platform/coda.c
> +++ b/drivers/media/platform/coda.c
> @@ -813,18 +813,11 @@ static int coda_queue_setup(struct vb2_queue *vq,
>                                 unsigned int sizes[], void *alloc_ctxs[])
>  {
>         struct coda_ctx *ctx = vb2_get_drv_priv(vq);
> +       struct coda_q_data *q_data;
>         unsigned int size;
>
> -       if (vq->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
> -               if (fmt)
> -                       size = fmt->fmt.pix.width *
> -                               fmt->fmt.pix.height * 3 / 2;
> -               else
> -                       size = MAX_W *
> -                               MAX_H * 3 / 2;
> -       } else {
> -               size = CODA_MAX_FRAME_SIZE;
> -       }
> +       q_data = get_q_data(ctx, vq->type);
> +       size = q_data->sizeimage;
>
>         *nplanes = 1;
>         sizes[0] = size;
> --
> 1.7.10.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
