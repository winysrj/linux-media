Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:55636 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933732AbeFMJus (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Jun 2018 05:50:48 -0400
Date: Wed, 13 Jun 2018 11:50:12 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Hellstrom <thellstrom@vmware.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Gustavo Padovan <gustavo@padovan.org>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Sean Paul <seanpaul@chromium.org>,
        David Airlie <airlied@linux.ie>,
        Davidlohr Bueso <dave@stgolabs.net>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-doc@vger.kernel.org, linux-media@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org
Subject: Re: [PATCH 1/2] locking: Implement an algorithm choice for
 Wound-Wait mutexes
Message-ID: <20180613095012.GW12198@hirez.programming.kicks-ass.net>
References: <20180613074745.14750-1-thellstrom@vmware.com>
 <20180613074745.14750-2-thellstrom@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180613074745.14750-2-thellstrom@vmware.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


/me wonders what's up with partial Cc's today..

On Wed, Jun 13, 2018 at 09:47:44AM +0200, Thomas Hellstrom wrote:
> The current Wound-Wait mutex algorithm is actually not Wound-Wait but
> Wait-Die. Implement also Wound-Wait as a per-ww-class choice. Wound-Wait
> is, contrary to Wait-Die a preemptive algorithm and is known to generate
> fewer backoffs. Testing reveals that this is true if the
> number of simultaneous contending transactions is small.
> As the number of simultaneous contending threads increases, Wait-Wound
> becomes inferior to Wait-Die in terms of elapsed time.
> Possibly due to the larger number of held locks of sleeping transactions.
> 
> Update documentation and callers.
> 
> Timings using git://people.freedesktop.org/~thomash/ww_mutex_test
> tag patch-18-06-04
> 
> Each thread runs 100000 batches of lock / unlock 800 ww mutexes randomly
> chosen out of 100000. Four core Intel x86_64:
> 
> Algorithm    #threads       Rollbacks  time
> Wound-Wait   4              ~100       ~17s.
> Wait-Die     4              ~150000    ~19s.
> Wound-Wait   16             ~360000    ~109s.
> Wait-Die     16             ~450000    ~82s.

> diff --git a/include/linux/ww_mutex.h b/include/linux/ww_mutex.h
> index 39fda195bf78..6278077f288b 100644
> --- a/include/linux/ww_mutex.h
> +++ b/include/linux/ww_mutex.h
> @@ -8,6 +8,8 @@
>   *
>   * Wound/wait implementation:
>   *  Copyright (C) 2013 Canonical Ltd.
> + * Choice of algorithm:
> + *  Copyright (C) 2018 WMWare Inc.
>   *
>   * This file contains the main data structure and API definitions.
>   */
> @@ -23,15 +25,17 @@ struct ww_class {
>  	struct lock_class_key mutex_key;
>  	const char *acquire_name;
>  	const char *mutex_name;
> +	bool is_wait_die;
>  };

No _Bool in composites please.

>  struct ww_acquire_ctx {
>  	struct task_struct *task;
>  	unsigned long stamp;
>  	unsigned acquired;
> +	bool wounded;

Again.

> +	struct ww_class *ww_class;
>  #ifdef CONFIG_DEBUG_MUTEXES
>  	unsigned done_acquire;
> -	struct ww_class *ww_class;
>  	struct ww_mutex *contending_lock;
>  #endif
>  #ifdef CONFIG_DEBUG_LOCK_ALLOC

> diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
> index 2048359f33d2..b449a012c6f9 100644
> --- a/kernel/locking/mutex.c
> +++ b/kernel/locking/mutex.c
> @@ -290,12 +290,47 @@ __ww_ctx_stamp_after(struct ww_acquire_ctx *a, struct ww_acquire_ctx *b)
>  	       (a->stamp != b->stamp || a > b);
>  }
>  
> +/*
> + * Wound the lock holder transaction if it's younger than the contending
> + * transaction, and there is a possibility of a deadlock.
> + * Also if the lock holder transaction isn't the current transaction,

Comma followed by a capital?

> + * Make sure it's woken up in case it's sleeping on another ww mutex.

> + */
> +static bool __ww_mutex_wound(struct mutex *lock,
> +			     struct ww_acquire_ctx *ww_ctx,
> +			     struct ww_acquire_ctx *hold_ctx)
> +{
> +	struct task_struct *owner =
> +		__owner_task(atomic_long_read(&lock->owner));

Did you just spell __mutex_owner() wrong?

> +
> +	lockdep_assert_held(&lock->wait_lock);
> +
> +	if (owner && hold_ctx && __ww_ctx_stamp_after(hold_ctx, ww_ctx) &&
> +	    ww_ctx->acquired > 0) {
> +		WRITE_ONCE(hold_ctx->wounded, true);
> +		if (owner != current) {
> +			/*
> +			 * wake_up_process() inserts a write memory barrier to

It does no such thing. But yes, it does ensure the wakee sees all prior
stores IFF the wakeup happened.

> +			 * make sure owner sees it is wounded before
> +			 * TASK_RUNNING in case it's sleeping on another
> +			 * ww_mutex. Note that owner points to a valid
> +			 * task_struct as long as we hold the wait_lock.
> +			 */

What exactly are you trying to say here ?

I'm thinking this is the pairing barrier to the smp_mb() below, with
your list_empty() thing? Might make sense to write a single coherent
comment and refer to the other location.

> +			wake_up_process(owner);
> +		}
> +		return true;
> +	}
> +
> +	return false;
> +}
> +
>  /*
>   * Wake up any waiters that may have to back off when the lock is held by the
>   * given context.
>   *
>   * Due to the invariants on the wait list, this can only affect the first
> - * waiter with a context.
> + * waiter with a context, unless the Wound-Wait algorithm is used where
> + * also subsequent waiters with a context main wound the lock holder.
>   *
>   * The current task must not be on the wait list.
>   */
> @@ -303,6 +338,7 @@ static void __sched
>  __ww_mutex_wakeup_for_backoff(struct mutex *lock, struct ww_acquire_ctx *ww_ctx)
>  {
>  	struct mutex_waiter *cur;
> +	bool is_wait_die = ww_ctx->ww_class->is_wait_die;
>  
>  	lockdep_assert_held(&lock->wait_lock);
>  
> @@ -310,13 +346,14 @@ __ww_mutex_wakeup_for_backoff(struct mutex *lock, struct ww_acquire_ctx *ww_ctx)
>  		if (!cur->ww_ctx)
>  			continue;
>  
> -		if (cur->ww_ctx->acquired > 0 &&
> +		if (is_wait_die && cur->ww_ctx->acquired > 0 &&
>  		    __ww_ctx_stamp_after(cur->ww_ctx, ww_ctx)) {
>  			debug_mutex_wake_waiter(lock, cur);
>  			wake_up_process(cur->task);
>  		}
>  
> -		break;
> +		if (is_wait_die || __ww_mutex_wound(lock, cur->ww_ctx, ww_ctx))
> +			break;
>  	}
>  }
>  
> @@ -338,12 +375,17 @@ ww_mutex_set_context_fastpath(struct ww_mutex *lock, struct ww_acquire_ctx *ctx)
>  	 * and keep spinning, or it will acquire wait_lock, add itself
>  	 * to waiter list and sleep.
>  	 */
> -	smp_mb(); /* ^^^ */
> +	smp_mb(); /* See comments above and below. */
>  
>  	/*
> -	 * Check if lock is contended, if not there is nobody to wake up
> +	 * Check if lock is contended, if not there is nobody to wake up.
> +	 * Checking MUTEX_FLAG_WAITERS is not enough here, 

That seems like a superfluous thing to say. It makes sense in the
context of this patch because we change the FLAG check into a list
check, but the resulting comment/code looks odd.

>							   since we need to
> +	 * order against the lock->ctx check in __ww_mutex_wound called from
> +	 * __ww_mutex_add_waiter. We can use list_empty without taking the
> +	 * wait_lock, given the memory barrier above and the list_empty
> +	 * documentation.

I don't trust documentation. Please reason about implementation.

>  	 */
> -	if (likely(!(atomic_long_read(&lock->base.owner) & MUTEX_FLAG_WAITERS)))
> +	if (likely(list_empty(&lock->base.wait_list)))
>  		return;
>  
>  	/*
> @@ -653,6 +695,17 @@ __ww_mutex_lock_check_stamp(struct mutex *lock, struct mutex_waiter *waiter,
>  	struct ww_acquire_ctx *hold_ctx = READ_ONCE(ww->ctx);
>  	struct mutex_waiter *cur;
>  
> +	/*
> +	 * If we miss a wounded == true here, we will have a pending

Explain how we can miss that.

> +	 * TASK_RUNNING and pick it up on the next schedule fall-through.
> +	 */
> +	if (!ctx->ww_class->is_wait_die) {
> +		if (READ_ONCE(ctx->wounded))
> +			goto deadlock;
> +		else
> +			return 0;
> +	}
> +
>  	if (hold_ctx && __ww_ctx_stamp_after(ctx, hold_ctx))
>  		goto deadlock;
>  
> @@ -683,12 +736,15 @@ __ww_mutex_add_waiter(struct mutex_waiter *waiter,
>  {
>  	struct mutex_waiter *cur;
>  	struct list_head *pos;
> +	bool is_wait_die;
>  
>  	if (!ww_ctx) {
>  		list_add_tail(&waiter->list, &lock->wait_list);
>  		return 0;
>  	}
>  
> +	is_wait_die = ww_ctx->ww_class->is_wait_die;
> +
>  	/*
>  	 * Add the waiter before the first waiter with a higher stamp.
>  	 * Waiters without a context are skipped to avoid starving
> @@ -701,7 +757,7 @@ __ww_mutex_add_waiter(struct mutex_waiter *waiter,
>  
>  		if (__ww_ctx_stamp_after(ww_ctx, cur->ww_ctx)) {
>  			/* Back off immediately if necessary. */
> -			if (ww_ctx->acquired > 0) {
> +			if (is_wait_die && ww_ctx->acquired > 0) {
>  #ifdef CONFIG_DEBUG_MUTEXES
>  				struct ww_mutex *ww;
>  
> @@ -721,13 +777,26 @@ __ww_mutex_add_waiter(struct mutex_waiter *waiter,
>  		 * Wake up the waiter so that it gets a chance to back
>  		 * off.
>  		 */
> -		if (cur->ww_ctx->acquired > 0) {
> +		if (is_wait_die && cur->ww_ctx->acquired > 0) {
>  			debug_mutex_wake_waiter(lock, cur);
>  			wake_up_process(cur->task);
>  		}
>  	}
>  
>  	list_add_tail(&waiter->list, pos);
> +	if (!is_wait_die) {
> +		struct ww_mutex *ww = container_of(lock, struct ww_mutex, base);
> +
> +		/*
> +		 * Make sure a racing lock taker sees a non-empty waiting list
> +		 * before we read ww->ctx, so that if we miss ww->ctx, the
> +		 * racing lock taker will call __ww_mutex_wake_up_for_backoff()
> +		 * and wound itself.
> +		 */
> +		smp_mb();
> +		__ww_mutex_wound(lock, ww_ctx, ww->ctx);
> +	}
> +
>  	return 0;
>  }
>  
> @@ -750,6 +819,14 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
>  	if (use_ww_ctx && ww_ctx) {
>  		if (unlikely(ww_ctx == READ_ONCE(ww->ctx)))
>  			return -EALREADY;
> +
> +		/*
> +		 * Reset the wounded flag after a backoff.
> +		 * No other process can race and wound us here since they
> +		 * can't have a valid owner pointer at this time
> +		 */
> +		if (ww_ctx->acquired == 0)
> +			ww_ctx->wounded = false;
>  	}
>  
>  	preempt_disable();
> @@ -858,6 +935,11 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
>  acquired:
>  	__set_current_state(TASK_RUNNING);
>  
> +	/* We stole the lock. Need to check wounded status. */
> +	if (use_ww_ctx && ww_ctx && !ww_ctx->ww_class->is_wait_die &&
> +	    !__mutex_waiter_is_first(lock, &waiter))
> +		__ww_mutex_wakeup_for_backoff(lock, ww_ctx);
> +
>  	mutex_remove_waiter(lock, &waiter, current);
>  	if (likely(list_empty(&lock->wait_list)))
>  		__mutex_clear_flag(lock, MUTEX_FLAGS);

I can't say I'm a fan. I'm already cursing the ww_mutex stuff every time
I have to look at it, and you just made it worse spagethi.
