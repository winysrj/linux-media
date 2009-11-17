Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:64156 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754478AbZKQAuF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Nov 2009 19:50:05 -0500
Subject: Re: [PATCH 17/21] workqueue: simple reimplementation of
 SINGLE_THREAD workqueue
From: Andy Walls <awalls@radix.net>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	jeff@garzik.org, mingo@elte.hu, akpm@linux-foundation.org,
	jens.axboe@oracle.com, rusty@rustcorp.com.au,
	cl@linux-foundation.org, dhowells@redhat.com,
	arjan@linux.intel.com, torvalds@linux-foundation.org,
	avi@redhat.com, peterz@infradead.org, andi@firstfloor.org,
	fweisbec@gmail.com
In-Reply-To: <1258391726-30264-18-git-send-email-tj@kernel.org>
References: <1258391726-30264-1-git-send-email-tj@kernel.org>
	 <1258391726-30264-18-git-send-email-tj@kernel.org>
Content-Type: text/plain
Date: Mon, 16 Nov 2009 19:47:52 -0500
Message-Id: <1258418872.4096.28.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2009-11-17 at 02:15 +0900, Tejun Heo wrote:
> SINGLE_THREAD workqueues are used to reduce the number of worker
> threads and ease synchronization.  The first reason will be irrelevant
> with concurrency managed workqueue implementation.  Simplify
> SINGLE_THREAD implementation by creating the workqueues the same but
> making the worker grab mutex before actually executing works on the
> workqueue.  In the long run, most SINGLE_THREAD workqueues will be
> replaced with generic ones.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> 
> ---
> kernel/workqueue.c |  151 ++++++++++++++++++----------------------------------
>  1 files changed, 52 insertions(+), 99 deletions(-)
> 
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 5392939..82b03a1 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -33,6 +33,7 @@
>  #include <linux/kallsyms.h>
>  #include <linux/debug_locks.h>
>  #include <linux/lockdep.h>
> +#include <linux/mutex.h>
>  
>  /*
>   * Structure fields follow one of the following exclusion rules.
> @@ -71,6 +72,7 @@ struct workqueue_struct {
>  	struct cpu_workqueue_struct *cpu_wq;	/* I: cwq's */
>  	struct list_head	list;		/* W: list of all workqueues */
>  	const char		*name;		/* I: workqueue name */
> +	struct mutex		single_thread_mutex; /* for SINGLE_THREAD wq */
>  #ifdef CONFIG_LOCKDEP
>  	struct lockdep_map	lockdep_map;
>  #endif


> @@ -410,6 +387,8 @@ EXPORT_SYMBOL_GPL(queue_delayed_work_on);
>  static void process_one_work(struct cpu_workqueue_struct *cwq,
>  			     struct work_struct *work)
>  {
> +	struct workqueue_struct *wq = cwq->wq;
> +	bool single_thread = wq->flags & WQ_SINGLE_THREAD;
>  	work_func_t f = work->func;
>  #ifdef CONFIG_LOCKDEP
>  	/*
> @@ -430,11 +409,18 @@ static void process_one_work(struct cpu_workqueue_struct *cwq,
>  
>  	BUG_ON(get_wq_data(work) != cwq);
>  	work_clear_pending(work);
> -	lock_map_acquire(&cwq->wq->lockdep_map);
> +	lock_map_acquire(&wq->lockdep_map);
>  	lock_map_acquire(&lockdep_map);
> -	f(work);
> +
> +	if (unlikely(single_thread)) {
> +		mutex_lock(&wq->single_thread_mutex);
> +		f(work);
> +		mutex_unlock(&wq->single_thread_mutex);
> +	} else
> +		f(work);
> +

An important property of the single threaded workqueue, upon which the
cx18 driver relies, is that work objects will be processed strictly in
the order in which they were queued.  The cx18 driver has a pool of
"work orders" and multiple active work orders can be queued up on the
workqueue especially if multiple streams are active.  If these work
orders were to be processed out of order, video artifacts would result
in video display applications.


With multiple work handling threads, I don't think the 

	mutex_lock(&wq->single_thread_mutex);
	f(work);
	
here can guarantee work requests from the workqueue will always be
processed in the order they are received.

Am I missing something?

Regards,
Andy

