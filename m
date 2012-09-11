Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:42236 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755701Ab2IKKmn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Sep 2012 06:42:43 -0400
Received: by obbuo13 with SMTP id uo13so482727obb.19
        for <linux-media@vger.kernel.org>; Tue, 11 Sep 2012 03:42:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1347291000-340-9-git-send-email-p.zabel@pengutronix.de>
References: <1347291000-340-1-git-send-email-p.zabel@pengutronix.de>
	<1347291000-340-9-git-send-email-p.zabel@pengutronix.de>
Date: Tue, 11 Sep 2012 12:42:42 +0200
Message-ID: <CACKLOr3VS1L=zssMjp0OuCG6-oQHBEXDB+P9bnsP1NHCFEqRkQ@mail.gmail.com>
Subject: Re: [PATCH v4 08/16] media: coda: enable user pointer support
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
> USERPTR buffer support is provided by the videobuf2 framework.
>
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  drivers/media/platform/coda.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
> index 7f6ec3a..e0595ce 100644
> --- a/drivers/media/platform/coda.c
> +++ b/drivers/media/platform/coda.c
> @@ -1345,7 +1345,7 @@ static int coda_queue_init(void *priv, struct vb2_queue *src_vq,
>
>         memset(src_vq, 0, sizeof(*src_vq));
>         src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
> -       src_vq->io_modes = VB2_MMAP;
> +       src_vq->io_modes = VB2_MMAP | VB2_USERPTR;
>         src_vq->drv_priv = ctx;
>         src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
>         src_vq->ops = &coda_qops;
> @@ -1357,7 +1357,7 @@ static int coda_queue_init(void *priv, struct vb2_queue *src_vq,
>
>         memset(dst_vq, 0, sizeof(*dst_vq));
>         dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> -       dst_vq->io_modes = VB2_MMAP;
> +       dst_vq->io_modes = VB2_MMAP | VB2_USERPTR;
>         dst_vq->drv_priv = ctx;
>         dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
>         dst_vq->ops = &coda_qops;
> --
> 1.7.10.4
>

Acked-by: Javier Martin <javier.martin@vista-silicon.com

-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
