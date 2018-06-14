Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-sn1nam02on0065.outbound.protection.outlook.com ([104.47.36.65]:2912
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755071AbeFNQoD (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Jun 2018 12:44:03 -0400
Subject: Re: [PATCH 1/2] locking: Implement an algorithm choice for Wound-Wait
 mutexes
To: Peter Zijlstra <peterz@infradead.org>
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
References: <20180613074745.14750-1-thellstrom@vmware.com>
 <20180613074745.14750-2-thellstrom@vmware.com>
 <20180613095012.GW12198@hirez.programming.kicks-ass.net>
 <69f3dee9-4782-bc90-3ee2-813ac6835c4a@vmware.com>
 <20180613131000.GX12198@hirez.programming.kicks-ass.net>
 <9afd482d-7082-fa17-5e34-179a652376e5@vmware.com>
 <20180614105151.GY12198@hirez.programming.kicks-ass.net>
 <dd0c5e50-ac14-912c-d31c-c2341fdd2864@vmware.com>
 <20180614144254.GB12198@hirez.programming.kicks-ass.net>
From: Thomas Hellstrom <thellstrom@vmware.com>
Message-ID: <5a1076ad-3c26-d78a-5542-9e767d81c4a6@vmware.com>
Date: Thu, 14 Jun 2018 18:43:40 +0200
MIME-Version: 1.0
In-Reply-To: <20180614144254.GB12198@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/14/2018 04:42 PM, Peter Zijlstra wrote:
> On Thu, Jun 14, 2018 at 01:48:39PM +0200, Thomas Hellstrom wrote:
>> The literature makes a distinction between "killed" and "wounded". In our
>> context, "Killed" is when a transaction actually receives an -EDEADLK and
>> needs to back off. "Wounded" is when someone (typically another transaction)
>> requests a transaction to kill itself. A wound will often, but not always,
>> lead to a kill. If the wounded transaction has finished its locking
>> sequence, or has the opportunity to grab uncontended ww mutexes or steal
>> contended (non-handoff) ww mutexes to finish its transaction it will do so
>> and never kill itself.
> Hopefully I got it all right this time; I folded your patch in and
> mucked around with it a bit, but haven't done anything except compile
> it.
>
> I left the context/transaction thing because well, that's what we called
> the thing.

Overall, I think this looks fine. I'll just fix up the FLAG_WAITERS 
setting and affected comments and do some torture testing on it.

Are you OK with adding the new feature and the cleanup in the same patch?

Thomas



>
>
> diff --git a/include/linux/ww_mutex.h b/include/linux/ww_mutex.h
> index 39fda195bf78..50ef5a10cfa0 100644
> --- a/include/linux/ww_mutex.h
> +++ b/include/linux/ww_mutex.h
> @@ -8,6 +8,8 @@
>    *
>    * Wound/wait implementation:
>    *  Copyright (C) 2013 Canonical Ltd.
> + * Choice of algorithm:
> + *  Copyright (C) 2018 WMWare Inc.
>    *
>    * This file contains the main data structure and API definitions.
>    */
> @@ -23,14 +25,17 @@ struct ww_class {
>   	struct lock_class_key mutex_key;
>   	const char *acquire_name;
>   	const char *mutex_name;
> +	unsigned int is_wait_die;
>   };
>   
>   struct ww_acquire_ctx {
>   	struct task_struct *task;
>   	unsigned long stamp;
> -	unsigned acquired;
> +	unsigned int acquired;
> +	unsigned short wounded;
> +	unsigned short is_wait_die;
>   #ifdef CONFIG_DEBUG_MUTEXES
> -	unsigned done_acquire;
> +	unsigned int done_acquire;
>   	struct ww_class *ww_class;
>   	struct ww_mutex *contending_lock;
>   #endif
> @@ -38,8 +43,8 @@ struct ww_acquire_ctx {
>   	struct lockdep_map dep_map;
>   #endif
>   #ifdef CONFIG_DEBUG_WW_MUTEX_SLOWPATH
> -	unsigned deadlock_inject_interval;
> -	unsigned deadlock_inject_countdown;
> +	unsigned int deadlock_inject_interval;
> +	unsigned int deadlock_inject_countdown;
>   #endif
>   };
>   
> @@ -58,17 +63,21 @@ struct ww_mutex {
>   # define __WW_CLASS_MUTEX_INITIALIZER(lockname, class)
>   #endif
>   
> -#define __WW_CLASS_INITIALIZER(ww_class) \
> +#define __WW_CLASS_INITIALIZER(ww_class, _is_wait_die)	    \
>   		{ .stamp = ATOMIC_LONG_INIT(0) \
>   		, .acquire_name = #ww_class "_acquire" \
> -		, .mutex_name = #ww_class "_mutex" }
> +		, .mutex_name = #ww_class "_mutex" \
> +		, .is_wait_die = _is_wait_die }
>   
>   #define __WW_MUTEX_INITIALIZER(lockname, class) \
>   		{ .base =  __MUTEX_INITIALIZER(lockname.base) \
>   		__WW_CLASS_MUTEX_INITIALIZER(lockname, class) }
>   
> +#define DEFINE_WD_CLASS(classname) \
> +	struct ww_class classname = __WW_CLASS_INITIALIZER(classname, 1)
> +
>   #define DEFINE_WW_CLASS(classname) \
> -	struct ww_class classname = __WW_CLASS_INITIALIZER(classname)
> +	struct ww_class classname = __WW_CLASS_INITIALIZER(classname, 0)
>   
>   #define DEFINE_WW_MUTEX(mutexname, ww_class) \
>   	struct ww_mutex mutexname = __WW_MUTEX_INITIALIZER(mutexname, ww_class)
> @@ -123,6 +132,8 @@ static inline void ww_acquire_init(struct ww_acquire_ctx *ctx,
>   	ctx->task = current;
>   	ctx->stamp = atomic_long_inc_return_relaxed(&ww_class->stamp);
>   	ctx->acquired = 0;
> +	ctx->wounded = false;
> +	ctx->is_wait_die = ww_class->is_wait_die;
>   #ifdef CONFIG_DEBUG_MUTEXES
>   	ctx->ww_class = ww_class;
>   	ctx->done_acquire = 0;
> diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
> index f44f658ae629..9e244af4647d 100644
> --- a/kernel/locking/mutex.c
> +++ b/kernel/locking/mutex.c
> @@ -244,6 +244,22 @@ void __sched mutex_lock(struct mutex *lock)
>   EXPORT_SYMBOL(mutex_lock);
>   #endif
>   
> +/*
> + * Wait-Die:
> + *   The newer transactions are killed when:
> + *     It (the new transaction) makes a request for a lock being held
> + *     by an older transaction.
> + *
> + * Wound-Wait:
> + *   The newer transactions are wounded when:
> + *     An older transaction makes a request for a lock being held by
> + *     the newer transaction.
> + */
> +
> +/*
> + * Associate the ww_mutex @ww with the context @ww_ctx under which we acquired
> + * it.
> + */
>   static __always_inline void
>   ww_mutex_lock_acquired(struct ww_mutex *ww, struct ww_acquire_ctx *ww_ctx)
>   {
> @@ -282,26 +298,96 @@ ww_mutex_lock_acquired(struct ww_mutex *ww, struct ww_acquire_ctx *ww_ctx)
>   	DEBUG_LOCKS_WARN_ON(ww_ctx->ww_class != ww->ww_class);
>   #endif
>   	ww_ctx->acquired++;
> +	ww->ctx = ww_ctx;
>   }
>   
> +/*
> + * Determine if context @a is 'after' context @b. IOW, @a should be wounded in
> + * favour of @b.
> + */
>   static inline bool __sched
>   __ww_ctx_stamp_after(struct ww_acquire_ctx *a, struct ww_acquire_ctx *b)
>   {
> -	return a->stamp - b->stamp <= LONG_MAX &&
> -	       (a->stamp != b->stamp || a > b);
> +
> +	return (signed long)(a->stamp - b->stamp) > 0;
>   }
>   
>   /*
> - * Wake up any waiters that may have to back off when the lock is held by the
> - * given context.
> + * Wait-Die; wake a younger waiter context (when locks held) such that it can die.
>    *
> - * Due to the invariants on the wait list, this can only affect the first
> - * waiter with a context.
> + * Among waiters with context, only the first one can have other locks acquired
> + * already (ctx->acquired > 0), because __ww_mutex_add_waiter() and
> + * __ww_mutex_check_wound() wake any but the earliest context.
> + */
> +static bool __ww_mutex_die(struct mutex *lock, struct mutex_waiter *waiter,
> +		           struct ww_acquire_ctx *ww_ctx)
> +{
> +	if (!ww_ctx->is_wait_die)
> +		return false;
> +
> +	if (waiter->ww_ctx->acquired > 0 &&
> +			__ww_ctx_stamp_after(waiter->ww_ctx, ww_ctx)) {
> +		debug_mutex_wake_waiter(lock, waiter);
> +		wake_up_process(waiter->task);
> +	}
> +
> +	return true;
> +}
> +
> +/*
> + * Wound-Wait; wound a younger @hold_ctx (if it has locks held).
> + *
> + * XXX more; explain why we too only need to wake the first.
> + */
> +static bool __ww_mutex_wound(struct mutex *lock,
> +			     struct ww_acquire_ctx *ww_ctx,
> +			     struct ww_acquire_ctx *hold_ctx)
> +{
> +	struct task_struct *owner = __mutex_owner(lock);
> +
> +	lockdep_assert_held(&lock->wait_lock);
> +
> +	/*
> +	 * Possible through __ww_mutex_add_waiter() when we race with
> +	 * ww_mutex_set_context_fastpath(). In that case we'll get here again
> +	 * through __ww_mutex_check_waiters().
> +	 */
> +	if (!hold_ctx)
> +		return false;
> +
> +	/*
> +	 * Can have !owner because of __mutex_unlock_slowpath(), but if owner,
> +	 * it cannot go away because we'll have FLAG_WAITERS set and hold
> +	 * wait_lock.
> +	 */
> +	if (!owner)
> +		return false;
> +
> +	if (ww_ctx->acquired > 0 && __ww_ctx_stamp_after(hold_ctx, ww_ctx)) {
> +		hold_ctx->wounded = 1;
> +		if (owner != current)
> +			wake_up_process(owner);
> +
> +		return true;
> +	}
> +
> +	return false;
> +}
> +
> +/*
> + * We just acquired @lock under @ww_ctx, if there are later contexts waiting
> + * behind us on the wait-list, check if they need wounding/killing.
> + *
> + * See __ww_mutex_add_waiter() for the list-order construction; basically the
> + * list is ordered by stamp, smallest (oldest) first.
> + *
> + * This relies on never mixing wait-die/wound-wait on the same wait-list; which is
> + * currently ensured by that being a ww_class property.
>    *
>    * The current task must not be on the wait list.
>    */
>   static void __sched
> -__ww_mutex_wakeup_for_backoff(struct mutex *lock, struct ww_acquire_ctx *ww_ctx)
> +__ww_mutex_check_waiters(struct mutex *lock, struct ww_acquire_ctx *ww_ctx)
>   {
>   	struct mutex_waiter *cur;
>   
> @@ -311,66 +397,50 @@ __ww_mutex_wakeup_for_backoff(struct mutex *lock, struct ww_acquire_ctx *ww_ctx)
>   		if (!cur->ww_ctx)
>   			continue;
>   
> -		if (cur->ww_ctx->acquired > 0 &&
> -		    __ww_ctx_stamp_after(cur->ww_ctx, ww_ctx)) {
> -			debug_mutex_wake_waiter(lock, cur);
> -			wake_up_process(cur->task);
> -		}
> -
> -		break;
> +		if (__ww_mutex_die(lock, cur, ww_ctx) ||
> +		    __ww_mutex_wound(lock, cur->ww_ctx, ww_ctx))
> +			break;
>   	}
>   }
>   
>   /*
> - * After acquiring lock with fastpath or when we lost out in contested
> - * slowpath, set ctx and wake up any waiters so they can recheck.
> + * After acquiring lock with fastpath, where we do not hold wait_lock, set ctx
> + * and wake up any waiters so they can recheck.
>    */
>   static __always_inline void
>   ww_mutex_set_context_fastpath(struct ww_mutex *lock, struct ww_acquire_ctx *ctx)
>   {
>   	ww_mutex_lock_acquired(lock, ctx);
>   
> -	lock->ctx = ctx;
> -
>   	/*
>   	 * The lock->ctx update should be visible on all cores before
> -	 * the atomic read is done, otherwise contended waiters might be
> +	 * the list_empty check is done, otherwise contended waiters might be
>   	 * missed. The contended waiters will either see ww_ctx == NULL
>   	 * and keep spinning, or it will acquire wait_lock, add itself
>   	 * to waiter list and sleep.
>   	 */
> -	smp_mb(); /* ^^^ */
> +	smp_mb(); /* See comments above and below. */
>   
>   	/*
> -	 * Check if lock is contended, if not there is nobody to wake up
> +	 * [W] ww->ctx = ctx	[W] list_add_tail()
> +	 *     MB		    MB
> +	 * [R] list_empty()	[R] ww->ctx
> +	 *
> +	 * The memory barrier above pairs with the memory barrier in
> +	 * __ww_mutex_add_waiter() and makes sure we either observe ww->ctx
> +	 * and/or !empty list.
>   	 */
> -	if (likely(!(atomic_long_read(&lock->base.owner) & MUTEX_FLAG_WAITERS)))
> +	if (likely(list_empty(&lock->base.wait_list)))
>   		return;
>   
>   	/*
> -	 * Uh oh, we raced in fastpath, wake up everyone in this case,
> -	 * so they can see the new lock->ctx.
> +	 * Uh oh, we raced in fastpath, check if any of the waiters need wounding.
>   	 */
>   	spin_lock(&lock->base.wait_lock);
> -	__ww_mutex_wakeup_for_backoff(&lock->base, ctx);
> +	__ww_mutex_check_waiters(&lock->base, ctx);
>   	spin_unlock(&lock->base.wait_lock);
>   }
>   
> -/*
> - * After acquiring lock in the slowpath set ctx.
> - *
> - * Unlike for the fast path, the caller ensures that waiters are woken up where
> - * necessary.
> - *
> - * Callers must hold the mutex wait_lock.
> - */
> -static __always_inline void
> -ww_mutex_set_context_slowpath(struct ww_mutex *lock, struct ww_acquire_ctx *ctx)
> -{
> -	ww_mutex_lock_acquired(lock, ctx);
> -	lock->ctx = ctx;
> -}
> -
>   #ifdef CONFIG_MUTEX_SPIN_ON_OWNER
>   
>   static inline
> @@ -646,37 +716,83 @@ void __sched ww_mutex_unlock(struct ww_mutex *lock)
>   }
>   EXPORT_SYMBOL(ww_mutex_unlock);
>   
> +
> +static __always_inline int __sched
> +__ww_mutex_kill(struct mutex *lock, struct ww_acquire_ctx *ww_ctx)
> +{
> +	if (ww_ctx->acquired > 0) {
> +#ifdef CONFIG_DEBUG_MUTEXES
> +		struct ww_mutex *ww;
> +
> +		ww = container_of(lock, struct ww_mutex, base);
> +		DEBUG_LOCKS_WARN_ON(ww_ctx->contending_lock);
> +		ww_ctx->contending_lock = ww;
> +#endif
> +		return -EDEADLK;
> +	}
> +
> +	return 0;
> +}
> +
> +
> +/*
> + * Check the wound condition for the current lock acquire.
> + *
> + * Wound-Wait: If we're wounded, kill ourself.
> + *
> + * Wait-Die: If we're trying to acquire a lock already held by an older
> + *           context, kill ourselves.
> + *
> + * Since __ww_mutex_add_waiter() orders the wait-list on stamp, we only have to
> + * look at waiters before us in the wait-list.
> + */
>   static inline int __sched
> -__ww_mutex_lock_check_stamp(struct mutex *lock, struct mutex_waiter *waiter,
> +__ww_mutex_check_wound(struct mutex *lock, struct mutex_waiter *waiter,
>   			    struct ww_acquire_ctx *ctx)
>   {
>   	struct ww_mutex *ww = container_of(lock, struct ww_mutex, base);
>   	struct ww_acquire_ctx *hold_ctx = READ_ONCE(ww->ctx);
>   	struct mutex_waiter *cur;
>   
> +	if (ctx->acquired == 0)
> +		return 0;
> +
> +	if (!ctx->is_wait_die) {
> +		if (ctx->wounded)
> +			return __ww_mutex_kill(lock, ctx);
> +
> +		return 0;
> +	}
> +
>   	if (hold_ctx && __ww_ctx_stamp_after(ctx, hold_ctx))
> -		goto deadlock;
> +		return __ww_mutex_kill(lock, ctx);
>   
>   	/*
>   	 * If there is a waiter in front of us that has a context, then its
> -	 * stamp is earlier than ours and we must back off.
> +	 * stamp is earlier than ours and we must wound ourself.
>   	 */
>   	cur = waiter;
>   	list_for_each_entry_continue_reverse(cur, &lock->wait_list, list) {
> -		if (cur->ww_ctx)
> -			goto deadlock;
> +		if (!cur->ww_ctx)
> +			continue;
> +
> +		return __ww_mutex_kill(lock, ctx);
>   	}
>   
>   	return 0;
> -
> -deadlock:
> -#ifdef CONFIG_DEBUG_MUTEXES
> -	DEBUG_LOCKS_WARN_ON(ctx->contending_lock);
> -	ctx->contending_lock = ww;
> -#endif
> -	return -EDEADLK;
>   }
>   
> +/*
> + * Add @waiter to the wait-list, keep the wait-list ordered by stamp, smallest
> + * first. Such that older contexts are preferred to acquire the lock over
> + * younger contexts.
> + *
> + * Waiters without context are interspersed in FIFO order.
> + *
> + * Furthermore, for Wait-Die kill ourself immediately when possible (there are
> + * older contexts already waiting) to avoid unnecessary waiting and for
> + * Wound-Wait ensure we wound the owning context when it is younger.
> + */
>   static inline int __sched
>   __ww_mutex_add_waiter(struct mutex_waiter *waiter,
>   		      struct mutex *lock,
> @@ -684,16 +800,21 @@ __ww_mutex_add_waiter(struct mutex_waiter *waiter,
>   {
>   	struct mutex_waiter *cur;
>   	struct list_head *pos;
> +	bool is_wait_die;
>   
>   	if (!ww_ctx) {
>   		list_add_tail(&waiter->list, &lock->wait_list);
>   		return 0;
>   	}
>   
> +	is_wait_die = ww_ctx->is_wait_die;
> +
>   	/*
>   	 * Add the waiter before the first waiter with a higher stamp.
>   	 * Waiters without a context are skipped to avoid starving
> -	 * them.
> +	 * them. Wait-Die waiters may back off here. Wound-Wait waiters
> +	 * never back off here, but they are sorted in stamp order and
> +	 * may wound the lock holder.
>   	 */
>   	pos = &lock->wait_list;
>   	list_for_each_entry_reverse(cur, &lock->wait_list, list) {
> @@ -701,16 +822,16 @@ __ww_mutex_add_waiter(struct mutex_waiter *waiter,
>   			continue;
>   
>   		if (__ww_ctx_stamp_after(ww_ctx, cur->ww_ctx)) {
> -			/* Back off immediately if necessary. */
> -			if (ww_ctx->acquired > 0) {
> -#ifdef CONFIG_DEBUG_MUTEXES
> -				struct ww_mutex *ww;
> -
> -				ww = container_of(lock, struct ww_mutex, base);
> -				DEBUG_LOCKS_WARN_ON(ww_ctx->contending_lock);
> -				ww_ctx->contending_lock = ww;
> -#endif
> -				return -EDEADLK;
> +			/*
> +			 * Wait-Die: if we find an older context waiting, there
> +			 * is no point in queueing behind it, as we'd have to
> +			 * wound ourselves the moment it would acquire the
> +			 * lock.
> +			 */
> +			if (is_wait_die) {
> +				int ret = __ww_mutex_kill(lock, ww_ctx);
> +				if (ret)
> +					return ret;
>   			}
>   
>   			break;
> @@ -718,17 +839,29 @@ __ww_mutex_add_waiter(struct mutex_waiter *waiter,
>   
>   		pos = &cur->list;
>   
> +		/* Wait-Die: ensure younger waiters die. */
> +		__ww_mutex_die(lock, cur, ww_ctx);
> +	}
> +
> +	list_add_tail(&waiter->list, pos);
> +
> +	/*
> +	 * Wound-Wait: if we're blocking on a mutex owned by a younger context,
> +	 * wound that such that we might proceed.
> +	 */
> +	if (!is_wait_die) {
> +		struct ww_mutex *ww = container_of(lock, struct ww_mutex, base);
> +
>   		/*
> -		 * Wake up the waiter so that it gets a chance to back
> -		 * off.
> +		 * See ww_mutex_set_context_fastpath(). Orders the
> +		 * list_add_tail() vs the ww->ctx load, such that either we
> +		 * or the fastpath will wound @ww->ctx.
>   		 */
> -		if (cur->ww_ctx->acquired > 0) {
> -			debug_mutex_wake_waiter(lock, cur);
> -			wake_up_process(cur->task);
> -		}
> +		smp_mb();
> +
> +		__ww_mutex_wound(lock, ww_ctx, ww->ctx);
>   	}
>   
> -	list_add_tail(&waiter->list, pos);
>   	return 0;
>   }
>   
> @@ -751,6 +884,14 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
>   	if (use_ww_ctx && ww_ctx) {
>   		if (unlikely(ww_ctx == READ_ONCE(ww->ctx)))
>   			return -EALREADY;
> +
> +		/*
> +		 * Reset the wounded flag after a kill.  No other process can
> +		 * race and wound us here since they can't have a valid owner
> +		 * pointer at this time.
> +		 */
> +		if (ww_ctx->acquired == 0)
> +			ww_ctx->wounded = 0;
>   	}
>   
>   	preempt_disable();
> @@ -772,7 +913,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
>   	 */
>   	if (__mutex_trylock(lock)) {
>   		if (use_ww_ctx && ww_ctx)
> -			__ww_mutex_wakeup_for_backoff(lock, ww_ctx);
> +			__ww_mutex_check_waiters(lock, ww_ctx);
>   
>   		goto skip_wait;
>   	}
> @@ -790,10 +931,10 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
>   		waiter.ww_ctx = MUTEX_POISON_WW_CTX;
>   #endif
>   	} else {
> -		/* Add in stamp order, waking up waiters that must back off. */
> +		/* Add in stamp order, waking up waiters that must wound themselves. */
>   		ret = __ww_mutex_add_waiter(&waiter, lock, ww_ctx);
>   		if (ret)
> -			goto err_early_backoff;
> +			goto err_early_kill;
>   
>   		waiter.ww_ctx = ww_ctx;
>   	}
> @@ -824,8 +965,8 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
>   			goto err;
>   		}
>   
> -		if (use_ww_ctx && ww_ctx && ww_ctx->acquired > 0) {
> -			ret = __ww_mutex_lock_check_stamp(lock, &waiter, ww_ctx);
> +		if (use_ww_ctx && ww_ctx) {
> +			ret = __ww_mutex_check_wound(lock, &waiter, ww_ctx);
>   			if (ret)
>   				goto err;
>   		}
> @@ -859,6 +1000,16 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
>   acquired:
>   	__set_current_state(TASK_RUNNING);
>   
> +	if (use_ww_ctx && ww_ctx) {
> +		/*
> +		 * Wound-Wait; we stole the lock (!first_waiter), check the
> +		 * waiters. This, together with XXX, ensures __ww_mutex_wound()
> +		 * only needs to check the first waiter (with context).
> +		 */
> +		if (!ww_ctx->is_wait_die && !__mutex_waiter_is_first(lock, &waiter))
> +			__ww_mutex_check_waiters(lock, ww_ctx);
> +	}
> +
>   	mutex_remove_waiter(lock, &waiter, current);
>   	if (likely(list_empty(&lock->wait_list)))
>   		__mutex_clear_flag(lock, MUTEX_FLAGS);
> @@ -870,7 +1021,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
>   	lock_acquired(&lock->dep_map, ip);
>   
>   	if (use_ww_ctx && ww_ctx)
> -		ww_mutex_set_context_slowpath(ww, ww_ctx);
> +		ww_mutex_lock_acquired(ww, ww_ctx);
>   
>   	spin_unlock(&lock->wait_lock);
>   	preempt_enable();
> @@ -879,7 +1030,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
>   err:
>   	__set_current_state(TASK_RUNNING);
>   	mutex_remove_waiter(lock, &waiter, current);
> -err_early_backoff:
> +err_early_kill:
>   	spin_unlock(&lock->wait_lock);
>   	debug_mutex_free_waiter(&waiter);
>   	mutex_release(&lock->dep_map, 1, ip);
