Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:13307 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759087Ab3E1N6D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 May 2013 09:58:03 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MNI00D6YHCZBK00@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 28 May 2013 14:58:00 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: 'John Sheu' <sheu@google.com>, linux-media@vger.kernel.org
Cc: mchehab@redhat.com, pawel@osciak.com
References: <1369356108-15865-1-git-send-email-sheu@google.com>
In-reply-to: <1369356108-15865-1-git-send-email-sheu@google.com>
Subject: RE: [PATCH] [media] v4l2: mem2mem: save irq flags correctly
Date: Tue, 28 May 2013 15:57:56 +0200
Message-id: <019601ce5bab$5b5eae70$121c0b50$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sheu,

Thank you for this patch. May I also ask you to add me to Cc of next mem2mem
patches, as I am the mem2mem submaintainer?

Best wishes,
-- 
Kamil Debski
Linux Kernel Developer
Samsung R&D Institute Poland


> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of John Sheu
> Sent: Friday, May 24, 2013 2:42 AM
> To: linux-media@vger.kernel.org
> Cc: mchehab@redhat.com; pawel@osciak.com; John Sheu
> Subject: [PATCH] [media] v4l2: mem2mem: save irq flags correctly
> 
> Save flags correctly when taking spinlocks in v4l2_m2m_try_schedule.
> 
> Signed-off-by: John Sheu <sheu@google.com>

Acked-by: Kamil Debski <k.debski@samsung.com>

> ---
>  drivers/media/v4l2-core/v4l2-mem2mem.c | 19 +++++++++++--------
>  1 file changed, 11 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c
> b/drivers/media/v4l2-core/v4l2-mem2mem.c
> index 66f599f..3606ff2 100644
> --- a/drivers/media/v4l2-core/v4l2-mem2mem.c
> +++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
> @@ -205,7 +205,7 @@ static void v4l2_m2m_try_run(struct v4l2_m2m_dev
> *m2m_dev)  static void v4l2_m2m_try_schedule(struct v4l2_m2m_ctx
> *m2m_ctx)  {
>  	struct v4l2_m2m_dev *m2m_dev;
> -	unsigned long flags_job, flags;
> +	unsigned long flags_job, flags_out, flags_cap;
> 
>  	m2m_dev = m2m_ctx->m2m_dev;
>  	dprintk("Trying to schedule a job for m2m_ctx: %p\n", m2m_ctx);
> @@ -223,23 +223,26 @@ static void v4l2_m2m_try_schedule(struct
> v4l2_m2m_ctx *m2m_ctx)
>  		return;
>  	}
> 
> -	spin_lock_irqsave(&m2m_ctx->out_q_ctx.rdy_spinlock, flags);
> +	spin_lock_irqsave(&m2m_ctx->out_q_ctx.rdy_spinlock, flags_out);
>  	if (list_empty(&m2m_ctx->out_q_ctx.rdy_queue)) {
> -		spin_unlock_irqrestore(&m2m_ctx->out_q_ctx.rdy_spinlock,
> flags);
> +		spin_unlock_irqrestore(&m2m_ctx->out_q_ctx.rdy_spinlock,
> +					flags_out);
>  		spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags_job);
>  		dprintk("No input buffers available\n");
>  		return;
>  	}
> -	spin_lock_irqsave(&m2m_ctx->cap_q_ctx.rdy_spinlock, flags);
> +	spin_lock_irqsave(&m2m_ctx->cap_q_ctx.rdy_spinlock, flags_cap);
>  	if (list_empty(&m2m_ctx->cap_q_ctx.rdy_queue)) {
> -		spin_unlock_irqrestore(&m2m_ctx->cap_q_ctx.rdy_spinlock,
> flags);
> -		spin_unlock_irqrestore(&m2m_ctx->out_q_ctx.rdy_spinlock,
> flags);
> +		spin_unlock_irqrestore(&m2m_ctx->cap_q_ctx.rdy_spinlock,
> +					flags_cap);
> +		spin_unlock_irqrestore(&m2m_ctx->out_q_ctx.rdy_spinlock,
> +					flags_out);
>  		spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags_job);
>  		dprintk("No output buffers available\n");
>  		return;
>  	}
> -	spin_unlock_irqrestore(&m2m_ctx->cap_q_ctx.rdy_spinlock, flags);
> -	spin_unlock_irqrestore(&m2m_ctx->out_q_ctx.rdy_spinlock, flags);
> +	spin_unlock_irqrestore(&m2m_ctx->cap_q_ctx.rdy_spinlock,
> flags_cap);
> +	spin_unlock_irqrestore(&m2m_ctx->out_q_ctx.rdy_spinlock,
> flags_out);
> 
>  	if (m2m_dev->m2m_ops->job_ready
>  		&& (!m2m_dev->m2m_ops->job_ready(m2m_ctx->priv))) {
> --
> 1.8.2.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media"
> in the body of a message to majordomo@vger.kernel.org More majordomo
> info at  http://vger.kernel.org/majordomo-info.html


