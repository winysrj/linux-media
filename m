Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:46344 "EHLO
        lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1758176AbcJQORV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Oct 2016 10:17:21 -0400
Subject: Re: [Patch 06/35] media: ti-vpe: vpe: Do not perform job transaction
 atomically
To: Benoit Parrot <bparrot@ti.com>
References: <20160928212040.26547-1-bparrot@ti.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <e102942f-597e-9149-6216-a0c23f07405b@xs4all.nl>
Date: Mon, 17 Oct 2016 16:17:15 +0200
MIME-Version: 1.0
In-Reply-To: <20160928212040.26547-1-bparrot@ti.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/28/2016 11:20 PM, Benoit Parrot wrote:
> From: Nikhil Devshatwar <nikhil.nd@ti.com>
> 
> Current VPE driver does not start the job until all the buffers for
> a transaction are not queued. When running in multiple context, this might

I think this should be: s/not queued/queued/, right?

> increase the processing latency.
> 
> Alternate solution would be to try to continue the same context as long as
> buffers for the transaction are ready; else switch the context. This may
> increase number of context switches but it reduces latency significantly.
> 
> In this approach, the job_ready always succeeds as long as there are
> buffers on the CAPTURE and OUTPUT stream. Processing may start immediately
> as the first 2 iterations don't need extra source buffers. Shift all the
> source buffers after each iteration and remove the oldest buffer.
> 
> Also, with this removes the constraint of pre buffering 3 buffers before
> call to STREAMON in case of de-interlacing.
> 
> Signed-off-by: Nikhil Devshatwar <nikhil.nd@ti.com>
> Signed-off-by: Benoit Parrot <bparrot@ti.com>
> ---
>  drivers/media/platform/ti-vpe/vpe.c | 32 ++++++++++++++++----------------
>  1 file changed, 16 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
> index a0b29685fb69..9c38eff5df46 100644
> --- a/drivers/media/platform/ti-vpe/vpe.c
> +++ b/drivers/media/platform/ti-vpe/vpe.c
> @@ -898,15 +898,14 @@ static struct vpe_ctx *file2ctx(struct file *file)
>  static int job_ready(void *priv)
>  {
>  	struct vpe_ctx *ctx = priv;
> -	int needed = ctx->bufs_per_job;
>  
> -	if (ctx->deinterlacing && ctx->src_vbs[2] == NULL)
> -		needed += 2;	/* need additional two most recent fields */
> -
> -	if (v4l2_m2m_num_src_bufs_ready(ctx->fh.m2m_ctx) < needed)
> -		return 0;
> -
> -	if (v4l2_m2m_num_dst_bufs_ready(ctx->fh.m2m_ctx) < needed)
> +	/*
> +	 * This check is needed as this might be called directly from driver
> +	 * When called by m2m framework, this will always satisy, but when

typo: satisfy

> +	 * called from vpe_irq, this might fail. (src stream with zero buffers)
> +	 */
> +	if (v4l2_m2m_num_src_bufs_ready(ctx->fh.m2m_ctx) <= 0 ||
> +		v4l2_m2m_num_dst_bufs_ready(ctx->fh.m2m_ctx) <= 0)
>  		return 0;
>  
>  	return 1;
> @@ -1116,19 +1115,20 @@ static void device_run(void *priv)
>  	struct sc_data *sc = ctx->dev->sc;
>  	struct vpe_q_data *d_q_data = &ctx->q_data[Q_DATA_DST];
>  
> -	if (ctx->deinterlacing && ctx->src_vbs[2] == NULL) {
> -		ctx->src_vbs[2] = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
> -		WARN_ON(ctx->src_vbs[2] == NULL);
> -		ctx->src_vbs[1] = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
> -		WARN_ON(ctx->src_vbs[1] == NULL);
> -	}
> -
>  	ctx->src_vbs[0] = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
>  	WARN_ON(ctx->src_vbs[0] == NULL);
>  	ctx->dst_vb = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
>  	WARN_ON(ctx->dst_vb == NULL);
>  
>  	if (ctx->deinterlacing) {
> +
> +		if (ctx->src_vbs[2] == NULL) {
> +			ctx->src_vbs[2] = ctx->src_vbs[0];
> +			WARN_ON(ctx->src_vbs[2] == NULL);
> +			ctx->src_vbs[1] = ctx->src_vbs[0];
> +			WARN_ON(ctx->src_vbs[1] == NULL);
> +		}
> +
>  		/*
>  		 * we have output the first 2 frames through line average, we
>  		 * now switch to EDI de-interlacer
> @@ -1349,7 +1349,7 @@ static irqreturn_t vpe_irq(int irq_vpe, void *data)
>  	}
>  
>  	ctx->bufs_completed++;
> -	if (ctx->bufs_completed < ctx->bufs_per_job) {
> +	if (ctx->bufs_completed < ctx->bufs_per_job && job_ready(ctx)) {
>  		device_run(ctx);
>  		goto handled;
>  	}
> 

Regards,

	Hans
