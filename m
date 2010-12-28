Return-path: <mchehab@gaivota>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58191 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618Ab0L1Xdy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Dec 2010 18:33:54 -0500
Message-ID: <4D1A73DE.2030900@gmail.com>
Date: Wed, 29 Dec 2010 00:33:50 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Hyunwoong Kim <khw0178.kim@samsung.com>
CC: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	s.nawrocki@samsung.com
Subject: Re: [PATCH] [media] s5p-fimc: Support stop_streaming and job_abort
References: <1293523616-27421-1-git-send-email-khw0178.kim@samsung.com>
In-Reply-To: <1293523616-27421-1-git-send-email-khw0178.kim@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On 12/28/2010 09:06 AM, Hyunwoong Kim wrote:
> This patch adds callback functions, stop_streaming and job_abort,
> to abort or finish any DMA in progress. stop_streaming is called
> by videobuf2 framework and job_abort is called by m2m framework.
> ST_M2M_PEND state is added to discard the next job.
>
> Reviewed-by: Jonghun Han<jonghun.han@samsung.com>
> Signed-off-by: Hyunwoong Kim<khw0178.kim@samsung.com>
> ---
> This patch is depended on Hyunwoong Kim's last patch.
> - [PATCH v2] [media] s5p-fimc: Configure scaler registers depending on FIMC version
>
>   drivers/media/video/s5p-fimc/fimc-core.c |   41 ++++++++++++++++++++++++++++-
>   drivers/media/video/s5p-fimc/fimc-core.h |    1 +
>   2 files changed, 40 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
> index 2b65961..0eeb6a5 100644
> --- a/drivers/media/video/s5p-fimc/fimc-core.c
> +++ b/drivers/media/video/s5p-fimc/fimc-core.c
> @@ -308,6 +308,26 @@ int fimc_set_scaler_info(struct fimc_ctx *ctx)
>   	return 0;
>   }
>
> +static int stop_streaming(struct vb2_queue *q)
> +{
> +	struct fimc_ctx *ctx = q->drv_priv;
> +	struct fimc_dev *fimc = ctx->fimc_dev;
> +	unsigned long flags;
> +
> +	if (!fimc_m2m_pending(fimc))
> +		return 0;
> +
> +	spin_lock_irqsave(&fimc->slock, flags);
> +	set_bit(ST_M2M_SHUT,&fimc->state);
> +	spin_unlock_irqrestore(&fimc->slock, flags);

I think you can safely remove the spinlock protection there.
IMHO it doesn't earn as anything when set_bit is atomic.

> +
> +	wait_event_timeout(fimc->irq_queue,
> +			!test_bit(ST_M2M_SHUT,&fimc->state),
> +			FIMC_SHUTDOWN_TIMEOUT);
> +
> +	return 0;
> +}
> +
>   static void fimc_capture_handler(struct fimc_dev *fimc)
>   {
>   	struct fimc_vid_cap *cap =&fimc->vid_cap;
> @@ -359,7 +379,10 @@ static irqreturn_t fimc_isr(int irq, void *priv)
>
>   	spin_lock(&fimc->slock);
>
> -	if (test_and_clear_bit(ST_M2M_PEND,&fimc->state)) {
> +	if (test_and_clear_bit(ST_M2M_SHUT,&fimc->state)) {
> +		wake_up(&fimc->irq_queue);
> +		goto isr_unlock;
> +	} else if (test_and_clear_bit(ST_M2M_PEND,&fimc->state)) {
>   		struct vb2_buffer *src_vb, *dst_vb;
>   		struct fimc_ctx *ctx = v4l2_m2m_get_curr_priv(fimc->m2m.m2m_dev);
>
> @@ -639,7 +662,20 @@ dma_unlock:
>
>   static void fimc_job_abort(void *priv)
>   {
> -	/* Nothing done in job_abort. */
> +	struct fimc_ctx *ctx = priv;
> +	struct fimc_dev *fimc = ctx->fimc_dev;
> +	unsigned long flags;
> +
> +	if (!fimc_m2m_pending(fimc))
> +		return;
> +
> +	spin_lock_irqsave(&fimc->slock, flags);
> +	set_bit(ST_M2M_SHUT,&fimc->state);
> +	spin_unlock_irqrestore(&fimc->slock, flags);

Ditto.

Otherwise looks good.

> +
> +	wait_event_timeout(fimc->irq_queue,
> +			!test_bit(ST_M2M_SHUT,&fimc->state),
> +			FIMC_SHUTDOWN_TIMEOUT);
>   }
>
>   static int fimc_queue_setup(struct vb2_queue *vq, unsigned int *num_buffers,
> @@ -716,6 +752,7 @@ struct vb2_ops fimc_qops = {
>   	.buf_queue	 = fimc_buf_queue,
>   	.wait_prepare	 = fimc_unlock,
>   	.wait_finish	 = fimc_lock,
> +	.stop_streaming	 = stop_streaming,
>   };
>
>   static int fimc_m2m_querycap(struct file *file, void *priv,
> diff --git a/drivers/media/video/s5p-fimc/fimc-core.h b/drivers/media/video/s5p-fimc/fimc-core.h
> index d690398..150792d 100644
> --- a/drivers/media/video/s5p-fimc/fimc-core.h
> +++ b/drivers/media/video/s5p-fimc/fimc-core.h
> @@ -51,6 +51,7 @@ enum fimc_dev_flags {
>   	ST_IDLE,
>   	ST_OUTDMA_RUN,
>   	ST_M2M_PEND,
> +	ST_M2M_SHUT,
>   	/* for capture node */
>   	ST_CAPT_PEND,
>   	ST_CAPT_RUN,

--
Thanks,
Sylwester
