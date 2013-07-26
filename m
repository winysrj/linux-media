Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:31236 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758147Ab3GZNCr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jul 2013 09:02:47 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MQJ00GZYO86FA20@usmailout3.samsung.com> for
 linux-media@vger.kernel.org; Fri, 26 Jul 2013 09:02:45 -0400 (EDT)
Date: Fri, 26 Jul 2013 10:02:39 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org, Kamil Debski <k.debski@samsung.com>,
	Javier Martin <javier.martin@vista-silicon.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	=?UTF-8?B?R2HDq3Rhbg==?= Carlier <gcembed@gmail.com>,
	Wei Yongjun <weiyj.lk@gmail.com>
Subject: Re: [PATCH v2 1/8] [media] coda: use vb2_set_plane_payload instead of
 setting v4l2_planes[0].bytesused directly
Message-id: <20130726100239.3fa8dee3@samsung.com>
In-reply-to: <1371801334-22324-2-git-send-email-p.zabel@pengutronix.de>
References: <1371801334-22324-1-git-send-email-p.zabel@pengutronix.de>
 <1371801334-22324-2-git-send-email-p.zabel@pengutronix.de>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

Em Fri, 21 Jun 2013 09:55:27 +0200
Philipp Zabel <p.zabel@pengutronix.de> escreveu:

> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>

Please provide a description of the patch.

Thanks!
Mauro

> ---
>  drivers/media/platform/coda.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
> index c4566c4..90f3386 100644
> --- a/drivers/media/platform/coda.c
> +++ b/drivers/media/platform/coda.c
> @@ -1662,12 +1662,12 @@ static irqreturn_t coda_irq_handler(int irq, void *data)
>  	wr_ptr = coda_read(dev, CODA_REG_BIT_WR_PTR(ctx->idx));
>  	/* Calculate bytesused field */
>  	if (dst_buf->v4l2_buf.sequence == 0) {
> -		dst_buf->v4l2_planes[0].bytesused = (wr_ptr - start_ptr) +
> -						ctx->vpu_header_size[0] +
> -						ctx->vpu_header_size[1] +
> -						ctx->vpu_header_size[2];
> +		vb2_set_plane_payload(dst_buf, 0, wr_ptr - start_ptr +
> +					ctx->vpu_header_size[0] +
> +					ctx->vpu_header_size[1] +
> +					ctx->vpu_header_size[2]);
>  	} else {
> -		dst_buf->v4l2_planes[0].bytesused = (wr_ptr - start_ptr);
> +		vb2_set_plane_payload(dst_buf, 0, wr_ptr - start_ptr);
>  	}
>  
>  	v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev, "frame size = %u\n",


-- 

Cheers,
Mauro
