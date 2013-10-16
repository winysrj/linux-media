Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:48665 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933956Ab3JPLlb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Oct 2013 07:41:31 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MUR00DEWF42S470@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 16 Oct 2013 12:41:29 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: 'Philipp Zabel' <p.zabel@pengutronix.de>,
	linux-media@vger.kernel.org
Cc: 'Mauro Carvalho Chehab' <m.chehab@samsung.com>,
	'Javier Martin' <javier.martin@vista-silicon.com>,
	'Hans Verkuil' <hans.verkuil@cisco.com>, kernel@pengutronix.de
References: <1380548093-22313-1-git-send-email-p.zabel@pengutronix.de>
 <1380548093-22313-3-git-send-email-p.zabel@pengutronix.de>
In-reply-to: <1380548093-22313-3-git-send-email-p.zabel@pengutronix.de>
Subject: RE: [PATCH v2 02/10] [media] coda: only set buffered input queue for
 decoder
Date: Wed, 16 Oct 2013 13:41:28 +0200
Message-id: <064901ceca64$a73ff510$f5bfdf30$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp, 

I know that this patch's explanation is pretty much contained in the
subject,
but could you add a short description as well?

Best wishes,
-- 
Kamil Debski
Linux Kernel Developer
Samsung R&D Institute Poland


> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Philipp Zabel
> Sent: Monday, September 30, 2013 3:35 PM
> To: linux-media@vger.kernel.org
> Cc: Mauro Carvalho Chehab; Kamil Debski; Javier Martin; Hans Verkuil;
> kernel@pengutronix.de; Philipp Zabel
> Subject: [PATCH v2 02/10] [media] coda: only set buffered input queue
> for decoder
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  drivers/media/platform/coda.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/coda.c
> b/drivers/media/platform/coda.c index 2805538..945c539 100644
> --- a/drivers/media/platform/coda.c
> +++ b/drivers/media/platform/coda.c
> @@ -1928,8 +1928,9 @@ static int coda_start_streaming(struct vb2_queue
> *q, unsigned int count)
>  	if (!(ctx->streamon_out & ctx->streamon_cap))
>  		return 0;
> 
> -	/* Allow device_run with no buffers queued and after streamoff */
> -	v4l2_m2m_set_src_buffered(ctx->m2m_ctx, true);
> +	/* Allow decoder device_run with no new buffers queued */
> +	if (ctx->inst_type == CODA_INST_DECODER)
> +		v4l2_m2m_set_src_buffered(ctx->m2m_ctx, true);
> 
>  	ctx->gopcounter = ctx->params.gop_size - 1;
>  	buf = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
> --
> 1.8.4.rc3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media"
> in the body of a message to majordomo@vger.kernel.org More majordomo
> info at  http://vger.kernel.org/majordomo-info.html

