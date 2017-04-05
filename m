Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:49865 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752304AbdDENtu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Apr 2017 09:49:50 -0400
Message-ID: <1491400188.2381.95.camel@pengutronix.de>
Subject: Re: [PATCH 2/3] [media] coda: first step at error recovery
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Lucas Stach <l.stach@pengutronix.de>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, kernel@pengutronix.de,
        patchwork-lst@pengutronix.de
Date: Wed, 05 Apr 2017 15:49:48 +0200
In-Reply-To: <20170405130955.30513-2-l.stach@pengutronix.de>
References: <20170405130955.30513-1-l.stach@pengutronix.de>
         <20170405130955.30513-2-l.stach@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Lucas,

On Wed, 2017-04-05 at 15:09 +0200, Lucas Stach wrote:
> This implements a simple handler for the case where decode did not finish
> sucessfully. This might be helpful during normal streaming, but for now it
> only handles the case where the context would deadlock with userspace,
> i.e. userspace issued DEC_CMD_STOP and waits for EOS, but after the failed
> decode run we would hold the context and wait for userspace to queue more
> buffers.
> 
> Signed-off-by: Lucas Stach <l.stach@pengutronix.de>

Just a naming nitpick below.

Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>

> ---
>  drivers/media/platform/coda/coda-bit.c    | 20 ++++++++++++++++++++
>  drivers/media/platform/coda/coda-common.c |  3 +++
>  drivers/media/platform/coda/coda.h        |  1 +
>  3 files changed, 24 insertions(+)
> 
> diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
> index 36062fc494e3..6a088f9343bb 100644
> --- a/drivers/media/platform/coda/coda-bit.c
> +++ b/drivers/media/platform/coda/coda-bit.c
> @@ -2113,12 +2113,32 @@ static void coda_finish_decode(struct coda_ctx *ctx)
>  	ctx->display_idx = display_idx;
>  }
>  
> +static void coda_error_decode(struct coda_ctx *ctx)

This sounds a bit like we are decoding an error code. Could we maybe
rename this any of coda_fail_decode or coda_decode_error/failure  or
similar?

> +{
> +	struct vb2_v4l2_buffer *dst_buf;
> +
> +	/*
> +	 * For now this only handles the case where we would deadlock with
> +	 * userspace, i.e. userspace issued DEC_CMD_STOP and waits for EOS,
> +	 * but after a failed decode run we would hold the context and wait for
> +	 * userspace to queue more buffers.
> +	 */
> +	if (!(ctx->bit_stream_param & CODA_BIT_STREAM_END_FLAG))
> +		return;
> +
> +	dst_buf = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
> +	dst_buf->sequence = ctx->qsequence - 1;
> +
> +	coda_m2m_buf_done(ctx, dst_buf, VB2_BUF_STATE_ERROR);
> +}
> +
>  const struct coda_context_ops coda_bit_decode_ops = {
>  	.queue_init = coda_decoder_queue_init,
>  	.reqbufs = coda_decoder_reqbufs,
>  	.start_streaming = coda_start_decoding,
>  	.prepare_run = coda_prepare_decode,
>  	.finish_run = coda_finish_decode,
> +	.error_run = coda_error_decode,

How about .fail_run to follow the <verb>_run pattern, or
.run_error/failure to break it?

>  	.seq_end_work = coda_seq_end_work,
>  	.release = coda_bit_release,
>  };
> diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
> index eb6548f46cba..0bbf155f9783 100644
> --- a/drivers/media/platform/coda/coda-common.c
> +++ b/drivers/media/platform/coda/coda-common.c
> @@ -1100,6 +1100,9 @@ static void coda_pic_run_work(struct work_struct *work)
>  		ctx->hold = true;
>  
>  		coda_hw_reset(ctx);
> +
> +		if (ctx->ops->error_run)
> +			ctx->ops->error_run(ctx);
>  	} else if (!ctx->aborting) {
>  		ctx->ops->finish_run(ctx);
>  	}
> diff --git a/drivers/media/platform/coda/coda.h b/drivers/media/platform/coda/coda.h
> index 4b831c91ae4a..799ffca72203 100644
> --- a/drivers/media/platform/coda/coda.h
> +++ b/drivers/media/platform/coda/coda.h
> @@ -180,6 +180,7 @@ struct coda_context_ops {
>  	int (*start_streaming)(struct coda_ctx *ctx);
>  	int (*prepare_run)(struct coda_ctx *ctx);
>  	void (*finish_run)(struct coda_ctx *ctx);
> +	void (*error_run)(struct coda_ctx *ctx);
>  	void (*seq_end_work)(struct work_struct *work);
>  	void (*release)(struct coda_ctx *ctx);
>  };

regards
Philipp
