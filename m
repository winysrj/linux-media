Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:54062 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726865AbeGRLAe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 18 Jul 2018 07:00:34 -0400
Subject: Re: [PATCH 1/2] v4l2-core: Simplify v4l2_m2m_try_{schedule,run}
To: Ezequiel Garcia <ezequiel@collabora.com>,
        linux-media@vger.kernel.org
Cc: kernel@collabora.com, paul.kocialkowski@bootlin.com,
        maxime.ripard@bootlin.com, Hans Verkuil <hans.verkuil@cisco.com>
References: <20180712154322.30237-1-ezequiel@collabora.com>
 <20180712154322.30237-2-ezequiel@collabora.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <1a9c086f-c664-70cd-62c1-59ca24d6b2a0@xs4all.nl>
Date: Wed, 18 Jul 2018 12:23:19 +0200
MIME-Version: 1.0
In-Reply-To: <20180712154322.30237-2-ezequiel@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/07/18 17:43, Ezequiel Garcia wrote:
> v4l2_m2m_try_run() has only one caller and so it's possible
> to move its contents.
> 
> Although this de-modularization change could reduce clarity,
> in this case it allows to remove a spinlock lock/unlock pair
> and an unneeded sanity check.
> 
> Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>

This patch no longer applies, can you respin?

Regards,

	Hans

> ---
>  drivers/media/v4l2-core/v4l2-mem2mem.c | 44 ++++++--------------------
>  1 file changed, 10 insertions(+), 34 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
> index 6bce8dcd182a..c2e9c2b7dcd1 100644
> --- a/drivers/media/v4l2-core/v4l2-mem2mem.c
> +++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
> @@ -181,37 +181,6 @@ void *v4l2_m2m_get_curr_priv(struct v4l2_m2m_dev *m2m_dev)
>  }
>  EXPORT_SYMBOL(v4l2_m2m_get_curr_priv);
>  
> -/**
> - * v4l2_m2m_try_run() - select next job to perform and run it if possible
> - * @m2m_dev: per-device context
> - *
> - * Get next transaction (if present) from the waiting jobs list and run it.
> - */
> -static void v4l2_m2m_try_run(struct v4l2_m2m_dev *m2m_dev)
> -{
> -	unsigned long flags;
> -
> -	spin_lock_irqsave(&m2m_dev->job_spinlock, flags);
> -	if (NULL != m2m_dev->curr_ctx) {
> -		spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags);
> -		dprintk("Another instance is running, won't run now\n");
> -		return;
> -	}
> -
> -	if (list_empty(&m2m_dev->job_queue)) {
> -		spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags);
> -		dprintk("No job pending\n");
> -		return;
> -	}
> -
> -	m2m_dev->curr_ctx = list_first_entry(&m2m_dev->job_queue,
> -				   struct v4l2_m2m_ctx, queue);
> -	m2m_dev->curr_ctx->job_flags |= TRANS_RUNNING;
> -	spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags);
> -
> -	m2m_dev->m2m_ops->device_run(m2m_dev->curr_ctx->priv);
> -}
> -
>  void v4l2_m2m_try_schedule(struct v4l2_m2m_ctx *m2m_ctx)
>  {
>  	struct v4l2_m2m_dev *m2m_dev;
> @@ -269,15 +238,22 @@ void v4l2_m2m_try_schedule(struct v4l2_m2m_ctx *m2m_ctx)
>  	list_add_tail(&m2m_ctx->queue, &m2m_dev->job_queue);
>  	m2m_ctx->job_flags |= TRANS_QUEUED;
>  
> -	spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags_job);
> +	if (NULL != m2m_dev->curr_ctx) {
> +		spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags_job);
> +		dprintk("Another instance is running, won't run now\n");
> +		return;
> +	}
>  
> -	v4l2_m2m_try_run(m2m_dev);
> +	m2m_dev->curr_ctx = list_first_entry(&m2m_dev->job_queue,
> +				   struct v4l2_m2m_ctx, queue);
> +	m2m_dev->curr_ctx->job_flags |= TRANS_RUNNING;
> +	spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags_job);
>  
> +	m2m_dev->m2m_ops->device_run(m2m_dev->curr_ctx->priv);
>  	return;
>  
>  out_unlock:
>  	spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags_job);
> -
>  	return;
>  }
>  EXPORT_SYMBOL_GPL(v4l2_m2m_try_schedule);
> 
