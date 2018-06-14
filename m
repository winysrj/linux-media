Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:36044 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754995AbeFNKjB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Jun 2018 06:39:01 -0400
Received: by mail-wr0-f194.google.com with SMTP id f16-v6so5888068wrm.3
        for <linux-media@vger.kernel.org>; Thu, 14 Jun 2018 03:39:00 -0700 (PDT)
Date: Thu, 14 Jun 2018 12:38:52 +0200
From: Andrea Parri <andrea.parri@amarulasolutions.com>
To: Thomas Hellstrom <thellstrom@vmware.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
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
Subject: Re: [PATCH v2 1/2] locking: Implement an algorithm choice for
 Wound-Wait mutexes
Message-ID: <20180614103852.GA18216@andrea>
References: <20180614072922.8114-1-thellstrom@vmware.com>
 <20180614072922.8114-2-thellstrom@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180614072922.8114-2-thellstrom@vmware.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Thomas,

On Thu, Jun 14, 2018 at 09:29:21AM +0200, Thomas Hellstrom wrote:
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
> tag patch-18-06-14
> 
> Each thread runs 100000 batches of lock / unlock 800 ww mutexes randomly
> chosen out of 100000. Four core Intel x86_64:
> 
> Algorithm    #threads       Rollbacks  time
> Wound-Wait   4              ~100       ~17s.
> Wait-Die     4              ~150000    ~19s.
> Wound-Wait   16             ~360000    ~109s.
> Wait-Die     16             ~450000    ~82s.
> 
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Gustavo Padovan <gustavo@padovan.org>
> Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> Cc: Sean Paul <seanpaul@chromium.org>
> Cc: David Airlie <airlied@linux.ie>
> Cc: Davidlohr Bueso <dave@stgolabs.net>
> Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> Cc: Josh Triplett <josh@joshtriplett.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Kate Stewart <kstewart@linuxfoundation.org>
> Cc: Philippe Ombredanne <pombredanne@nexb.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: linux-doc@vger.kernel.org
> Cc: linux-media@vger.kernel.org
> Cc: linaro-mm-sig@lists.linaro.org
> Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
> 
> ---
> v2:
> * Update API according to review comment by Greg Kroah-Hartman.
> * Address review comments by Peter Zijlstra:
>   - Avoid _Bool in composites
>   - Fix typo
>   - Use __mutex_owner() where applicable
>   - Rely on built-in barriers for the main loop exit condition,
>     struct ww_acquire_ctx::wounded. Update code comments.
>   - Explain unlocked use of list_empty().
> ---
>  Documentation/locking/ww-mutex-design.txt |  54 ++++++++++++----
>  drivers/dma-buf/reservation.c             |   2 +-
>  drivers/gpu/drm/drm_modeset_lock.c        |   2 +-
>  include/linux/ww_mutex.h                  |  19 ++++--
>  kernel/locking/locktorture.c              |   2 +-
>  kernel/locking/mutex.c                    | 103 +++++++++++++++++++++++++++---
>  kernel/locking/test-ww_mutex.c            |   2 +-
>  lib/locking-selftest.c                    |   2 +-
>  8 files changed, 156 insertions(+), 30 deletions(-)
> 
> diff --git a/Documentation/locking/ww-mutex-design.txt b/Documentation/locking/ww-mutex-design.txt
> index 34c3a1b50b9a..b9597def9581 100644
> --- a/Documentation/locking/ww-mutex-design.txt
> +++ b/Documentation/locking/ww-mutex-design.txt
> @@ -1,4 +1,4 @@
> -Wait/Wound Deadlock-Proof Mutex Design
> +Wound/Wait Deadlock-Proof Mutex Design
>  ======================================
>  
>  Please read mutex-design.txt first, as it applies to wait/wound mutexes too.
> @@ -32,10 +32,23 @@ the oldest task) wins, and the one with the higher reservation id (i.e. the
>  younger task) unlocks all of the buffers that it has already locked, and then
>  tries again.
>  
> -In the RDBMS literature this deadlock handling approach is called wait/wound:
> -The older tasks waits until it can acquire the contended lock. The younger tasks
> -needs to back off and drop all the locks it is currently holding, i.e. the
> -younger task is wounded.
> +In the RDBMS literature, a reservation ticket is associated with a transaction.
> +and the deadlock handling approach is called Wait-Die. The name is based on
> +the actions of a locking thread when it encounters an already locked mutex.
> +If the transaction holding the lock is younger, the locking transaction waits.
> +If the transaction holding the lock is older, the locking transaction backs off
> +and dies. Hence Wait-Die.
> +There is also another algorithm called Wound-Wait:
> +If the transaction holding the lock is younger, the locking transaction
> +preempts the transaction holding the lock, requiring it to back off. It
> +Wounds the other transaction.
> +If the transaction holding the lock is older, it waits for the other
> +transaction. Hence Wound-Wait.
> +The two algorithms are both fair in that a transaction will eventually succeed.
> +However, the Wound-Wait algorithm is typically stated to generate fewer backoffs
> +compared to Wait-Die, but is, on the other hand, associated with more work than
> +Wait-Die when recovering from a backoff. Wound-Wait is also a preemptive
> +algorithm which requires a reliable way to preempt another transaction.
>  
>  Concepts
>  --------
> @@ -47,10 +60,12 @@ Acquire context: To ensure eventual forward progress it is important the a task
>  trying to acquire locks doesn't grab a new reservation id, but keeps the one it
>  acquired when starting the lock acquisition. This ticket is stored in the
>  acquire context. Furthermore the acquire context keeps track of debugging state
> -to catch w/w mutex interface abuse.
> +to catch w/w mutex interface abuse. An acquire context is representing a
> +transaction.
>  
>  W/w class: In contrast to normal mutexes the lock class needs to be explicit for
> -w/w mutexes, since it is required to initialize the acquire context.
> +w/w mutexes, since it is required to initialize the acquire context. The lock
> +class also specifies what algorithm to use, Wound-Wait or Wait-Die.
>  
>  Furthermore there are three different class of w/w lock acquire functions:
>  
> @@ -90,6 +105,12 @@ provided.
>  Usage
>  -----
>  
> +The algorithm (Wait-Die vs Wound-Wait) is chosen by using either
> +DEFINE_WW_CLASS_WDIE() for Wait-Die or DEFINE_WW_CLASS() for Wound-Wait.
> +As a rough rule of thumb, use Wound-Wait iff you typically expect the number
> +of simultaneous competing transactions to be small, and the rollback cost can
> +be substantial.
> +
>  Three different ways to acquire locks within the same w/w class. Common
>  definitions for methods #1 and #2:
>  
> @@ -312,12 +333,23 @@ Design:
>    We maintain the following invariants for the wait list:
>    (1) Waiters with an acquire context are sorted by stamp order; waiters
>        without an acquire context are interspersed in FIFO order.
> -  (2) Among waiters with contexts, only the first one can have other locks
> -      acquired already (ctx->acquired > 0). Note that this waiter may come
> -      after other waiters without contexts in the list.
> +  (2) For Wait-Die, among waiters with contexts, only the first one can have
> +      other locks acquired already (ctx->acquired > 0). Note that this waiter
> +      may come after other waiters without contexts in the list.
> +
> +  The Wound-Wait preemption is implemented with a lazy-preemption scheme:
> +  The wounded status of the transaction is checked only when there is
> +  contention for a new lock and hence a true chance of deadlock. In that
> +  situation, if the transaction is wounded, it backs off, clears the
> +  wounded status and retries. A great benefit of implementing preemption in
> +  this way is that the wounded transaction can identify a contending lock to
> +  wait for before restarting the transaction. Just blindly restarting the
> +  transaction would likely make the transaction end up in a situation where
> +  it would have to back off again.
>  
>    In general, not much contention is expected. The locks are typically used to
> -  serialize access to resources for devices.
> +  serialize access to resources for devices, and optimization focus should
> +  therefore be directed towards the uncontended cases.
>  
>  Lockdep:
>    Special care has been taken to warn for as many cases of api abuse
> diff --git a/drivers/dma-buf/reservation.c b/drivers/dma-buf/reservation.c
> index 314eb1071cce..b94a4bab2ecd 100644
> --- a/drivers/dma-buf/reservation.c
> +++ b/drivers/dma-buf/reservation.c
> @@ -46,7 +46,7 @@
>   * write-side updates.
>   */
>  
> -DEFINE_WW_CLASS(reservation_ww_class);
> +DEFINE_WW_CLASS_WDIE(reservation_ww_class);
>  EXPORT_SYMBOL(reservation_ww_class);
>  
>  struct lock_class_key reservation_seqcount_class;
> diff --git a/drivers/gpu/drm/drm_modeset_lock.c b/drivers/gpu/drm/drm_modeset_lock.c
> index 8a5100685875..ff00a814f617 100644
> --- a/drivers/gpu/drm/drm_modeset_lock.c
> +++ b/drivers/gpu/drm/drm_modeset_lock.c
> @@ -70,7 +70,7 @@
>   * lists and lookup data structures.
>   */
>  
> -static DEFINE_WW_CLASS(crtc_ww_class);
> +static DEFINE_WW_CLASS_WDIE(crtc_ww_class);
>  
>  /**
>   * drm_modeset_lock_all - take all modeset locks
> diff --git a/include/linux/ww_mutex.h b/include/linux/ww_mutex.h
> index 39fda195bf78..3880813b7db5 100644
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
> +	unsigned int is_wait_die;
>  };
>  
>  struct ww_acquire_ctx {
>  	struct task_struct *task;
>  	unsigned long stamp;
>  	unsigned acquired;
> +	unsigned int wounded;
> +	struct ww_class *ww_class;
>  #ifdef CONFIG_DEBUG_MUTEXES
>  	unsigned done_acquire;
> -	struct ww_class *ww_class;
>  	struct ww_mutex *contending_lock;
>  #endif
>  #ifdef CONFIG_DEBUG_LOCK_ALLOC
> @@ -58,17 +62,21 @@ struct ww_mutex {
>  # define __WW_CLASS_MUTEX_INITIALIZER(lockname, class)
>  #endif
>  
> -#define __WW_CLASS_INITIALIZER(ww_class) \
> +#define __WW_CLASS_INITIALIZER(ww_class, _is_wait_die)	    \
>  		{ .stamp = ATOMIC_LONG_INIT(0) \
>  		, .acquire_name = #ww_class "_acquire" \
> -		, .mutex_name = #ww_class "_mutex" }
> +		, .mutex_name = #ww_class "_mutex" \
> +		, .is_wait_die = _is_wait_die }
>  
>  #define __WW_MUTEX_INITIALIZER(lockname, class) \
>  		{ .base =  __MUTEX_INITIALIZER(lockname.base) \
>  		__WW_CLASS_MUTEX_INITIALIZER(lockname, class) }
>  
>  #define DEFINE_WW_CLASS(classname) \
> -	struct ww_class classname = __WW_CLASS_INITIALIZER(classname)
> +	struct ww_class classname = __WW_CLASS_INITIALIZER(classname, 0)
> +
> +#define DEFINE_WW_CLASS_WDIE(classname)	\
> +	struct ww_class classname = __WW_CLASS_INITIALIZER(classname, 1)
>  
>  #define DEFINE_WW_MUTEX(mutexname, ww_class) \
>  	struct ww_mutex mutexname = __WW_MUTEX_INITIALIZER(mutexname, ww_class)
> @@ -123,8 +131,9 @@ static inline void ww_acquire_init(struct ww_acquire_ctx *ctx,
>  	ctx->task = current;
>  	ctx->stamp = atomic_long_inc_return_relaxed(&ww_class->stamp);
>  	ctx->acquired = 0;
> -#ifdef CONFIG_DEBUG_MUTEXES
>  	ctx->ww_class = ww_class;
> +	ctx->wounded = false;
> +#ifdef CONFIG_DEBUG_MUTEXES
>  	ctx->done_acquire = 0;
>  	ctx->contending_lock = NULL;
>  #endif
> diff --git a/kernel/locking/locktorture.c b/kernel/locking/locktorture.c
> index 6850ffd69125..e861c1bf0e1e 100644
> --- a/kernel/locking/locktorture.c
> +++ b/kernel/locking/locktorture.c
> @@ -365,7 +365,7 @@ static struct lock_torture_ops mutex_lock_ops = {
>  };
>  
>  #include <linux/ww_mutex.h>
> -static DEFINE_WW_CLASS(torture_ww_class);
> +static DEFINE_WW_CLASS_WDIE(torture_ww_class);
>  static DEFINE_WW_MUTEX(torture_ww_mutex_0, &torture_ww_class);
>  static DEFINE_WW_MUTEX(torture_ww_mutex_1, &torture_ww_class);
>  static DEFINE_WW_MUTEX(torture_ww_mutex_2, &torture_ww_class);
> diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
> index 2048359f33d2..ffa00b5aaf03 100644
> --- a/kernel/locking/mutex.c
> +++ b/kernel/locking/mutex.c
> @@ -290,12 +290,49 @@ __ww_ctx_stamp_after(struct ww_acquire_ctx *a, struct ww_acquire_ctx *b)
>  	       (a->stamp != b->stamp || a > b);
>  }
>  
> +/*
> + * Wound the lock holder transaction if it's younger than the contending
> + * transaction, and there is a possibility of a deadlock.
> + * Also if the lock holder transaction isn't the current transaction,
> + * make sure it's woken up in case it's sleeping on another ww mutex.
> + */
> +static bool __ww_mutex_wound(struct mutex *lock,
> +			     struct ww_acquire_ctx *ww_ctx,
> +			     struct ww_acquire_ctx *hold_ctx)
> +{
> +	struct task_struct *owner = __mutex_owner(lock);
> +
> +	lockdep_assert_held(&lock->wait_lock);
> +
> +	if (owner && hold_ctx && __ww_ctx_stamp_after(hold_ctx, ww_ctx) &&
> +	    ww_ctx->acquired > 0) {
> +		hold_ctx->wounded = 1;
> +
> +		/*
> +		 * wake_up_process() paired with set_current_state() inserts
> +		 * sufficient barriers to make sure @owner either sees it's
> +		 * wounded or has a wakeup pending to re-read the wounded
> +		 * state.

IIUC, "sufficient barriers" = full memory barriers (here).  (You may
want to be more specific.)

> +		 *
> +		 * The value of hold_ctx->wounded in
> +		 * __ww_mutex_lock_check_stamp();

Missing parts/incomplete sentence?

  Andrea


> +		 */
> +		if (owner != current)
> +			wake_up_process(owner);
> +
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
> @@ -303,6 +340,7 @@ static void __sched
>  __ww_mutex_wakeup_for_backoff(struct mutex *lock, struct ww_acquire_ctx *ww_ctx)
>  {
>  	struct mutex_waiter *cur;
> +	unsigned int is_wait_die = ww_ctx->ww_class->is_wait_die;
>  
>  	lockdep_assert_held(&lock->wait_lock);
>  
> @@ -310,13 +348,14 @@ __ww_mutex_wakeup_for_backoff(struct mutex *lock, struct ww_acquire_ctx *ww_ctx)
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
> @@ -338,12 +377,18 @@ ww_mutex_set_context_fastpath(struct ww_mutex *lock, struct ww_acquire_ctx *ctx)
>  	 * and keep spinning, or it will acquire wait_lock, add itself
>  	 * to waiter list and sleep.
>  	 */
> -	smp_mb(); /* ^^^ */
> +	smp_mb(); /* See comments above and below. */
>  
>  	/*
> -	 * Check if lock is contended, if not there is nobody to wake up
> +	 * Check if lock is contended, if not there is nobody to wake up.
> +	 * We can use list_empty() unlocked here since it only compares a
> +	 * list_head field pointer to the address of the list head
> +	 * itself, similarly to how list_empty() can be considered RCU-safe.
> +	 * The memory barrier above pairs with the memory barrier in
> +	 * __ww_mutex_add_waiter and makes sure lock->ctx is visible before
> +	 * we check for waiters.
>  	 */
> -	if (likely(!(atomic_long_read(&lock->base.owner) & MUTEX_FLAG_WAITERS)))
> +	if (likely(list_empty(&lock->base.wait_list)))
>  		return;
>  
>  	/*
> @@ -653,6 +698,13 @@ __ww_mutex_lock_check_stamp(struct mutex *lock, struct mutex_waiter *waiter,
>  	struct ww_acquire_ctx *hold_ctx = READ_ONCE(ww->ctx);
>  	struct mutex_waiter *cur;
>  
> +	if (!ctx->ww_class->is_wait_die) {
> +		if (ctx->wounded)
> +			goto deadlock;
> +		else
> +			return 0;
> +	}
> +
>  	if (hold_ctx && __ww_ctx_stamp_after(ctx, hold_ctx))
>  		goto deadlock;
>  
> @@ -683,16 +735,21 @@ __ww_mutex_add_waiter(struct mutex_waiter *waiter,
>  {
>  	struct mutex_waiter *cur;
>  	struct list_head *pos;
> +	unsigned int is_wait_die;
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
> -	 * them.
> +	 * them. Wait-Die waiters may back off here. Wound-Wait waiters
> +	 * never back off here, but they are sorted in stamp order and
> +	 * may wound the lock holder.
>  	 */
>  	pos = &lock->wait_list;
>  	list_for_each_entry_reverse(cur, &lock->wait_list, list) {
> @@ -701,7 +758,7 @@ __ww_mutex_add_waiter(struct mutex_waiter *waiter,
>  
>  		if (__ww_ctx_stamp_after(ww_ctx, cur->ww_ctx)) {
>  			/* Back off immediately if necessary. */
> -			if (ww_ctx->acquired > 0) {
> +			if (is_wait_die && ww_ctx->acquired > 0) {
>  #ifdef CONFIG_DEBUG_MUTEXES
>  				struct ww_mutex *ww;
>  
> @@ -721,13 +778,28 @@ __ww_mutex_add_waiter(struct mutex_waiter *waiter,
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
> +		 * racing lock taker will see a non-empty list and call
> +		 * __ww_mutex_wake_up_for_backoff() and wound itself. The
> +		 * memory barrier pairs with the one in
> +		 * ww_mutex_set_context_fastpath().
> +		 */
> +		smp_mb();
> +		__ww_mutex_wound(lock, ww_ctx, ww->ctx);
> +	}
> +
>  	return 0;
>  }
>  
> @@ -750,6 +822,14 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
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
> +			ww_ctx->wounded = 0;
>  	}
>  
>  	preempt_disable();
> @@ -858,6 +938,11 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
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
> diff --git a/kernel/locking/test-ww_mutex.c b/kernel/locking/test-ww_mutex.c
> index 0e4cd64ad2c0..3413430611d8 100644
> --- a/kernel/locking/test-ww_mutex.c
> +++ b/kernel/locking/test-ww_mutex.c
> @@ -26,7 +26,7 @@
>  #include <linux/slab.h>
>  #include <linux/ww_mutex.h>
>  
> -static DEFINE_WW_CLASS(ww_class);
> +static DEFINE_WW_CLASS_WDIE(ww_class);
>  struct workqueue_struct *wq;
>  
>  struct test_mutex {
> diff --git a/lib/locking-selftest.c b/lib/locking-selftest.c
> index b5c1293ce147..d0abf65ba9ad 100644
> --- a/lib/locking-selftest.c
> +++ b/lib/locking-selftest.c
> @@ -29,7 +29,7 @@
>   */
>  static unsigned int debug_locks_verbose;
>  
> -static DEFINE_WW_CLASS(ww_lockdep);
> +static DEFINE_WW_CLASS_WDIE(ww_lockdep);
>  
>  static int __init setup_debug_locks_verbose(char *str)
>  {
> -- 
> 2.14.3
> 
