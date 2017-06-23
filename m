Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:40068 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753984AbdFWJ3i (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Jun 2017 05:29:38 -0400
Subject: Re: [PATCH v2 2/3] [media] coda: first step at error recovery
To: Philipp Zabel <p.zabel@pengutronix.de>, linux-media@vger.kernel.org
References: <20170608085513.26857-1-p.zabel@pengutronix.de>
 <20170608085513.26857-2-p.zabel@pengutronix.de>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>, kernel@pengutronix.de,
        patchwork-lst@pengutronix.de, Lucas Stach <l.stach@pengutronix.de>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <c294fe89-092f-65fd-9901-6c1b88cb21e0@xs4all.nl>
Date: Fri, 23 Jun 2017 11:29:32 +0200
MIME-Version: 1.0
In-Reply-To: <20170608085513.26857-2-p.zabel@pengutronix.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/08/17 10:55, Philipp Zabel wrote:
> From: Lucas Stach <l.stach@pengutronix.de>
> 
> This implements a simple handler for the case where decode did not finish
> successfully. This might be helpful during normal streaming, but for now it
> only handles the case where the context would deadlock with userspace,
> i.e. userspace issued DEC_CMD_STOP and waits for EOS, but after the failed
> decode run we would hold the context and wait for userspace to queue more
> buffers.
> 
> Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
> Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
> [p.zabel@pengutronix.de: renamed error_decode/run to run/decode_timeout]
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
> Changes since v1 [1]:
> - Rename error_run/decode callback to run/decode_timeout, as
>   this error handler is called on device_run timeouts only.
> 
> [1] https://patchwork.linuxtv.org/patch/40603

It appears the v1 version was merged, not the v2. I'm not sure if the v2 version
was posted after v1 was already merged, or if I missed this v2 series.

I'm marking this as Obsoleted, and if you want to still get these v2 changes
in, then please post a new patch.

Sorry for the mix up,

	Hans

> ---
>  drivers/media/platform/coda/coda-bit.c    | 20 ++++++++++++++++++++
>  drivers/media/platform/coda/coda-common.c |  3 +++
>  drivers/media/platform/coda/coda.h        |  1 +
>  3 files changed, 24 insertions(+)
> 
> diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
> index 325035bb0a777..795b6d7584320 100644
> --- a/drivers/media/platform/coda/coda-bit.c
> +++ b/drivers/media/platform/coda/coda-bit.c
> @@ -2198,12 +2198,32 @@ static void coda_finish_decode(struct coda_ctx *ctx)
>  	ctx->display_idx = display_idx;
>  }
>  
> +static void coda_decode_timeout(struct coda_ctx *ctx)
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
> +	.run_timeout = coda_decode_timeout,
>  	.seq_end_work = coda_seq_end_work,
>  	.release = coda_bit_release,
>  };
> diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
> index 78bd9a4ace0e4..829c7895a98a2 100644
> --- a/drivers/media/platform/coda/coda-common.c
> +++ b/drivers/media/platform/coda/coda-common.c
> @@ -1163,6 +1163,9 @@ static void coda_pic_run_work(struct work_struct *work)
>  		ctx->hold = true;
>  
>  		coda_hw_reset(ctx);
> +
> +		if (ctx->ops->run_timeout)
> +			ctx->ops->run_timeout(ctx);
>  	} else if (!ctx->aborting) {
>  		ctx->ops->finish_run(ctx);
>  	}
> diff --git a/drivers/media/platform/coda/coda.h b/drivers/media/platform/coda/coda.h
> index 76d059431ca13..c5f504d8cf67f 100644
> --- a/drivers/media/platform/coda/coda.h
> +++ b/drivers/media/platform/coda/coda.h
> @@ -183,6 +183,7 @@ struct coda_context_ops {
>  	int (*start_streaming)(struct coda_ctx *ctx);
>  	int (*prepare_run)(struct coda_ctx *ctx);
>  	void (*finish_run)(struct coda_ctx *ctx);
> +	void (*run_timeout)(struct coda_ctx *ctx);
>  	void (*seq_end_work)(struct work_struct *work);
>  	void (*release)(struct coda_ctx *ctx);
>  };
> 
