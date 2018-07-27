Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:58080 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730318AbeG0O5q (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Jul 2018 10:57:46 -0400
Subject: Re: [PATCH v2 1/5] v4l2-mem2mem: Fix missing v4l2_m2m_try_run call
To: Ezequiel Garcia <ezequiel@collabora.com>,
        linux-media@vger.kernel.org
Cc: kernel@collabora.com, paul.kocialkowski@bootlin.com,
        maxime.ripard@bootlin.com, Hans Verkuil <hans.verkuil@cisco.com>,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org
References: <20180725171516.11210-1-ezequiel@collabora.com>
 <20180725171516.11210-2-ezequiel@collabora.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <c0cf528b-103a-9a92-527d-e80508734c72@xs4all.nl>
Date: Fri, 27 Jul 2018 15:35:45 +0200
MIME-Version: 1.0
In-Reply-To: <20180725171516.11210-2-ezequiel@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 25/07/18 19:15, Ezequiel Garcia wrote:
> Commit 34dbb848d5e4 ("media: mem2mem: Remove excessive try_run call")
> removed a redundant call to v4l2_m2m_try_run but instead introduced
> a bug. Consider the following case:
> 
>  1) Context A schedules, queues and runs job A.
>  2) While the m2m device is running, context B schedules
>     and queues job B. Job B cannot run, because it has to
>     wait for job A.
>  3) Job A completes, calls v4l2_m2m_job_finish, and tries
>     to queue a job for context A, but since the context is
>     empty it won't do anything.
> 
> In this scenario, queued job B will never run. Fix this by calling
> v4l2_m2m_try_run from v4l2_m2m_try_schedule.
> 
> While here, add more documentation to these functions.
> 
> Fixes: 34dbb848d5e4 ("media: mem2mem: Remove excessive try_run call")
> Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>

So just to be clear: this first patch fixes a regression and can be applied
separately from the other patches?

> ---
>  drivers/media/v4l2-core/v4l2-mem2mem.c | 32 +++++++++++++++++++++++---
>  1 file changed, 29 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
> index 5f9cd5b74cda..dfd796621b06 100644
> --- a/drivers/media/v4l2-core/v4l2-mem2mem.c
> +++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
> @@ -209,15 +209,23 @@ static void v4l2_m2m_try_run(struct v4l2_m2m_dev *m2m_dev)
>  	m2m_dev->curr_ctx->job_flags |= TRANS_RUNNING;
>  	spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags);
>  
> +	dprintk("Running job on m2m_ctx: %p\n", m2m_dev->curr_ctx);

Is this intended? It feels out of place in this patch.

>  	m2m_dev->m2m_ops->device_run(m2m_dev->curr_ctx->priv);
>  }
>  
> -void v4l2_m2m_try_schedule(struct v4l2_m2m_ctx *m2m_ctx)
> +/*
> + * __v4l2_m2m_try_queue() - queue a job
> + * @m2m_dev: m2m device
> + * @m2m_ctx: m2m context
> + *
> + * Check if this context is ready to queue a job.
> + *
> + * This function can run in interrupt context.
> + */
> +static void __v4l2_m2m_try_queue(struct v4l2_m2m_dev *m2m_dev, struct v4l2_m2m_ctx *m2m_ctx)
>  {
> -	struct v4l2_m2m_dev *m2m_dev;
>  	unsigned long flags_job, flags_out, flags_cap;
>  
> -	m2m_dev = m2m_ctx->m2m_dev;
>  	dprintk("Trying to schedule a job for m2m_ctx: %p\n", m2m_ctx);
>  
>  	if (!m2m_ctx->out_q_ctx.q.streaming
> @@ -275,7 +283,25 @@ void v4l2_m2m_try_schedule(struct v4l2_m2m_ctx *m2m_ctx)
>  	m2m_ctx->job_flags |= TRANS_QUEUED;
>  
>  	spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags_job);
> +}
> +
> +/**
> + * v4l2_m2m_try_schedule() - schedule and possibly run a job for any context
> + * @m2m_ctx: m2m context
> + *
> + * Check if this context is ready to queue a job. If suitable,
> + * run the next queued job on the mem2mem device.
> + *
> + * This function shouldn't run in interrupt context.
> + *
> + * Note that v4l2_m2m_try_schedule() can schedule one job for this context,
> + * and then run another job for another context.
> + */
> +void v4l2_m2m_try_schedule(struct v4l2_m2m_ctx *m2m_ctx)
> +{
> +	struct v4l2_m2m_dev *m2m_dev = m2m_ctx->m2m_dev;
>  
> +	__v4l2_m2m_try_queue(m2m_dev, m2m_ctx);

Why introduce __v4l2_m2m_try_queue? Why not keep it in here?

>  	v4l2_m2m_try_run(m2m_dev);
>  }
>  EXPORT_SYMBOL_GPL(v4l2_m2m_try_schedule);
> 

Regards,

	Hans
