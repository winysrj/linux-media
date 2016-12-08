Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:35141 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753088AbcLHPxu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Dec 2016 10:53:50 -0500
Message-ID: <1481212429.2673.7.camel@pengutronix.de>
Subject: Re: [PATCH 7/9] [media] coda: fix frame index to returned error
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Michael Tretter <m.tretter@pengutronix.de>
Cc: linux-media@vger.kernel.org
Date: Thu, 08 Dec 2016 16:53:49 +0100
In-Reply-To: <20161208152416.16031-7-m.tretter@pengutronix.de>
References: <20161208152416.16031-1-m.tretter@pengutronix.de>
         <20161208152416.16031-7-m.tretter@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Donnerstag, den 08.12.2016, 16:24 +0100 schrieb Michael Tretter:
> display_idx refers to the frame that will be returned in the next round.
> The currently processed frame is ctx->display_idx and errors should be
> reported for this frame.
> 
> Signed-off-by: Michael Tretter <m.tretter@pengutronix.de>
> ---
>  drivers/media/platform/coda/coda-bit.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
> index b662504..309eb4e 100644
> --- a/drivers/media/platform/coda/coda-bit.c
> +++ b/drivers/media/platform/coda/coda-bit.c
> @@ -2057,7 +2057,7 @@ static void coda_finish_decode(struct coda_ctx *ctx)
>  		}
>  		vb2_set_plane_payload(&dst_buf->vb2_buf, 0, payload);
>  
> -		coda_m2m_buf_done(ctx, dst_buf, ctx->frame_errors[display_idx] ?
> +		coda_m2m_buf_done(ctx, dst_buf, ctx->frame_errors[ctx->display_idx] ?
>  				  VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
>  
>  		v4l2_dbg(1, coda_debug, &dev->v4l2_dev,

Acked-by: Philipp Zabel <p.zabel@pengutronix.de>

regards
Philipp

