Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:48142 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752115Ab2GURQa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Jul 2012 13:16:30 -0400
Subject: Re: [PATCH 1/2] kthread_worker: reorganize to prepare for
 flush_kthread_work() reimplementation
From: Andy Walls <awalls@md.metrocast.net>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
	ivtv-devel@ivtvdriver.org, linux-media@vger.kernel.org,
	Grant Likely <grant.likely@secretlab.ca>,
	spi-devel-general@lists.sourceforge.net,
	Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 21 Jul 2012 13:13:27 -0400
In-Reply-To: <20120719211541.GB32763@google.com>
References: <20120719211510.GA32763@google.com>
	 <20120719211541.GB32763@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1342890808.2504.3.camel@palomino.walls.org>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2012-07-19 at 14:15 -0700, Tejun Heo wrote:
> From c9bba34243a86fb3ac82d1bdd0ce4bf796b79559 Mon Sep 17 00:00:00 2001
> From: Tejun Heo <tj@kernel.org>
> Date: Thu, 19 Jul 2012 13:52:53 -0700
> 
> Make the following two non-functional changes.
> 
> * Separate out insert_kthread_work() from queue_kthread_work().
> 
> * Relocate struct kthread_flush_work and kthread_flush_work_fn()
>   definitions above flush_kthread_work().
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
>  kernel/kthread.c |   40 ++++++++++++++++++++++++----------------
>  1 files changed, 24 insertions(+), 16 deletions(-)
> 
> diff --git a/kernel/kthread.c b/kernel/kthread.c
> index 3d3de63..7b8a678 100644
> --- a/kernel/kthread.c
> +++ b/kernel/kthread.c
> @@ -378,6 +378,17 @@ repeat:
>  }
>  EXPORT_SYMBOL_GPL(kthread_worker_fn);
>  
> +/* insert @work before @pos in @worker */

Hi Tejun,

Would a comment that the caller should be holding worker->lock be useful
here?  Anyway, comment or not:

Acked-by: Andy Walls <awall@md.metrocast.net>

Regards,
Andy

> +static void insert_kthread_work(struct kthread_worker *worker,
> +			       struct kthread_work *work,
> +			       struct list_head *pos)
> +{
> +	list_add_tail(&work->node, pos);
> +	work->queue_seq++;
> +	if (likely(worker->task))
> +		wake_up_process(worker->task);
> +}
> +
>  /**
>   * queue_kthread_work - queue a kthread_work
>   * @worker: target kthread_worker
> @@ -395,10 +406,7 @@ bool queue_kthread_work(struct kthread_worker *worker,
>  
>  	spin_lock_irqsave(&worker->lock, flags);
>  	if (list_empty(&work->node)) {
> -		list_add_tail(&work->node, &worker->work_list);
> -		work->queue_seq++;
> -		if (likely(worker->task))
> -			wake_up_process(worker->task);
> +		insert_kthread_work(worker, work, &worker->work_list);
>  		ret = true;
>  	}
>  	spin_unlock_irqrestore(&worker->lock, flags);
> @@ -406,6 +414,18 @@ bool queue_kthread_work(struct kthread_worker *worker,
>  }
>  EXPORT_SYMBOL_GPL(queue_kthread_work);
>  
> +struct kthread_flush_work {
> +	struct kthread_work	work;
> +	struct completion	done;
> +};
> +
> +static void kthread_flush_work_fn(struct kthread_work *work)
> +{
> +	struct kthread_flush_work *fwork =
> +		container_of(work, struct kthread_flush_work, work);
> +	complete(&fwork->done);
> +}
> +
>  /**
>   * flush_kthread_work - flush a kthread_work
>   * @work: work to flush
> @@ -436,18 +456,6 @@ void flush_kthread_work(struct kthread_work *work)
>  }
>  EXPORT_SYMBOL_GPL(flush_kthread_work);
>  
> -struct kthread_flush_work {
> -	struct kthread_work	work;
> -	struct completion	done;
> -};
> -
> -static void kthread_flush_work_fn(struct kthread_work *work)
> -{
> -	struct kthread_flush_work *fwork =
> -		container_of(work, struct kthread_flush_work, work);
> -	complete(&fwork->done);
> -}
> -
>  /**
>   * flush_kthread_worker - flush all current works on a kthread_worker
>   * @worker: worker to flush


