Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:41874 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754810AbeFNKwH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Jun 2018 06:52:07 -0400
Date: Thu, 14 Jun 2018 12:51:51 +0200
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
Message-ID: <20180614105151.GY12198@hirez.programming.kicks-ass.net>
References: <20180613074745.14750-1-thellstrom@vmware.com>
 <20180613074745.14750-2-thellstrom@vmware.com>
 <20180613095012.GW12198@hirez.programming.kicks-ass.net>
 <69f3dee9-4782-bc90-3ee2-813ac6835c4a@vmware.com>
 <20180613131000.GX12198@hirez.programming.kicks-ass.net>
 <9afd482d-7082-fa17-5e34-179a652376e5@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9afd482d-7082-fa17-5e34-179a652376e5@vmware.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jun 13, 2018 at 04:05:43PM +0200, Thomas Hellstrom wrote:
> In short, with Wait-Die (before the patch) it's the process _taking_ the
> contended lock that backs off if necessary. No preemption required. With
> Wound-Wait, it's the process _holding_ the contended lock that gets wounded
> (preempted), and it needs to back off at its own discretion but no later
> than when it's going to sleep on another ww mutex. That point is where we
> intercept the preemption request. We're preempting the transaction rather
> than the process.

This:

  Wait-die:
    The newer transactions are killed when:
      It (= the newer transaction) makes a reqeust for a lock being held
      by an older transactions

  Wound-wait:
    The newer transactions are killed when:
      An older transaction makes a request for a lock being held by the
      newer transactions

Would make for an excellent comment somewhere. No talking about
preemption, although I think I know what you mean with it, that is not
how preemption is normally used.

In scheduling speak preemption is when we pick a runnable (but !running)
task to run instead of the current running task.  In this case however,
our T2 is blocked on a lock acquisition (one owned by our T1) and T1 is
the only runnable task. Only when T1's progress is inhibited by T2 (T1
wants a lock held by T2) do we wound/wake T2.

In any case, I had a little look at the current ww_mutex code and ended
up with the below patch that hopefully clarifies things a little.

---
diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
index f44f658ae629..a20c04619b2a 100644
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -244,6 +244,10 @@ void __sched mutex_lock(struct mutex *lock)
 EXPORT_SYMBOL(mutex_lock);
 #endif
 
+/*
+ * Associate the ww_mutex @ww with the context @ww_ctx under which we acquired
+ * it.
+ */
 static __always_inline void
 ww_mutex_lock_acquired(struct ww_mutex *ww, struct ww_acquire_ctx *ww_ctx)
 {
@@ -282,26 +286,36 @@ ww_mutex_lock_acquired(struct ww_mutex *ww, struct ww_acquire_ctx *ww_ctx)
 	DEBUG_LOCKS_WARN_ON(ww_ctx->ww_class != ww->ww_class);
 #endif
 	ww_ctx->acquired++;
+	lock->ctx = ctx;
 }
 
+/*
+ * Determine if context @a is 'after' context @b. IOW, @a should be wounded in
+ * favour of @b.
+ */
 static inline bool __sched
 __ww_ctx_stamp_after(struct ww_acquire_ctx *a, struct ww_acquire_ctx *b)
 {
-	return a->stamp - b->stamp <= LONG_MAX &&
-	       (a->stamp != b->stamp || a > b);
+
+	return (signed long)(a->stamp - b->stamp) > 0;
 }
 
 /*
- * Wake up any waiters that may have to back off when the lock is held by the
- * given context.
+ * We just acquired @lock under @ww_ctx, if there are later contexts waiting
+ * behind us on the wait-list, wake them up so they can wound themselves.
  *
- * Due to the invariants on the wait list, this can only affect the first
- * waiter with a context.
+ * See __ww_mutex_add_waiter() for the list-order construction; basically the
+ * list is ordered by stamp smallest (oldest) first, so if there is a later
+ * (younger) stamp on the list behind us, wake it so it can wound itself.
+ *
+ * Because __ww_mutex_add_waiter() and __ww_mutex_check_stamp() wake any
+ * but the earliest context, this can only affect the first waiter (with a
+ * context).
  *
  * The current task must not be on the wait list.
  */
 static void __sched
-__ww_mutex_wakeup_for_backoff(struct mutex *lock, struct ww_acquire_ctx *ww_ctx)
+__ww_mutex_wakeup_for_wound(struct mutex *lock, struct ww_acquire_ctx *ww_ctx)
 {
 	struct mutex_waiter *cur;
 
@@ -322,16 +336,14 @@ __ww_mutex_wakeup_for_backoff(struct mutex *lock, struct ww_acquire_ctx *ww_ctx)
 }
 
 /*
- * After acquiring lock with fastpath or when we lost out in contested
- * slowpath, set ctx and wake up any waiters so they can recheck.
+ * After acquiring lock with fastpath, where we do not hold wait_lock, set ctx
+ * and wake up any waiters so they can recheck.
  */
 static __always_inline void
 ww_mutex_set_context_fastpath(struct ww_mutex *lock, struct ww_acquire_ctx *ctx)
 {
 	ww_mutex_lock_acquired(lock, ctx);
 
-	lock->ctx = ctx;
-
 	/*
 	 * The lock->ctx update should be visible on all cores before
 	 * the atomic read is done, otherwise contended waiters might be
@@ -352,25 +364,10 @@ ww_mutex_set_context_fastpath(struct ww_mutex *lock, struct ww_acquire_ctx *ctx)
 	 * so they can see the new lock->ctx.
 	 */
 	spin_lock(&lock->base.wait_lock);
-	__ww_mutex_wakeup_for_backoff(&lock->base, ctx);
+	__ww_mutex_wakeup_for_wound(&lock->base, ctx);
 	spin_unlock(&lock->base.wait_lock);
 }
 
-/*
- * After acquiring lock in the slowpath set ctx.
- *
- * Unlike for the fast path, the caller ensures that waiters are woken up where
- * necessary.
- *
- * Callers must hold the mutex wait_lock.
- */
-static __always_inline void
-ww_mutex_set_context_slowpath(struct ww_mutex *lock, struct ww_acquire_ctx *ctx)
-{
-	ww_mutex_lock_acquired(lock, ctx);
-	lock->ctx = ctx;
-}
-
 #ifdef CONFIG_MUTEX_SPIN_ON_OWNER
 
 static inline
@@ -646,20 +643,30 @@ void __sched ww_mutex_unlock(struct ww_mutex *lock)
 }
 EXPORT_SYMBOL(ww_mutex_unlock);
 
+/*
+ * Check the wound condition for the current lock acquire.  If we're trying to
+ * acquire a lock already held by an older context, wound ourselves.
+ *
+ * Since __ww_mutex_add_waiter() orders the wait-list on stamp, we only have to
+ * look at waiters before us in the wait-list.
+ */
 static inline int __sched
-__ww_mutex_lock_check_stamp(struct mutex *lock, struct mutex_waiter *waiter,
+__ww_mutex_check_stamp(struct mutex *lock, struct mutex_waiter *waiter,
 			    struct ww_acquire_ctx *ctx)
 {
 	struct ww_mutex *ww = container_of(lock, struct ww_mutex, base);
 	struct ww_acquire_ctx *hold_ctx = READ_ONCE(ww->ctx);
 	struct mutex_waiter *cur;
 
+	if (ctx->acquired == 0)
+		return 0;
+
 	if (hold_ctx && __ww_ctx_stamp_after(ctx, hold_ctx))
 		goto deadlock;
 
 	/*
 	 * If there is a waiter in front of us that has a context, then its
-	 * stamp is earlier than ours and we must back off.
+	 * stamp is earlier than ours and we must wound ourself.
 	 */
 	cur = waiter;
 	list_for_each_entry_continue_reverse(cur, &lock->wait_list, list) {
@@ -677,6 +684,14 @@ __ww_mutex_lock_check_stamp(struct mutex *lock, struct mutex_waiter *waiter,
 	return -EDEADLK;
 }
 
+/*
+ * Add @waiter to the wait-list, keep the wait-list ordered by stamp, smallest
+ * first. Such that older contexts are preferred to acquire the lock over
+ * younger contexts.
+ *
+ * Furthermore, wound ourself immediately when possible (there are older
+ * contexts already waiting) to avoid unnecessary waiting.
+ */
 static inline int __sched
 __ww_mutex_add_waiter(struct mutex_waiter *waiter,
 		      struct mutex *lock,
@@ -700,8 +715,12 @@ __ww_mutex_add_waiter(struct mutex_waiter *waiter,
 		if (!cur->ww_ctx)
 			continue;
 
+		/*
+		 * If we find an older context waiting, there is no point in
+		 * queueing behind it, as we'd have to wound ourselves the
+		 * moment it would acquire the lock.
+		 */
 		if (__ww_ctx_stamp_after(ww_ctx, cur->ww_ctx)) {
-			/* Back off immediately if necessary. */
 			if (ww_ctx->acquired > 0) {
 #ifdef CONFIG_DEBUG_MUTEXES
 				struct ww_mutex *ww;
@@ -719,8 +738,9 @@ __ww_mutex_add_waiter(struct mutex_waiter *waiter,
 		pos = &cur->list;
 
 		/*
-		 * Wake up the waiter so that it gets a chance to back
-		 * off.
+		 * When we enqueued an older context, wake all younger
+		 * contexts such that they can wound themselves, see
+		 * __ww_mutex_check_stamp().
 		 */
 		if (cur->ww_ctx->acquired > 0) {
 			debug_mutex_wake_waiter(lock, cur);
@@ -772,7 +792,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 	 */
 	if (__mutex_trylock(lock)) {
 		if (use_ww_ctx && ww_ctx)
-			__ww_mutex_wakeup_for_backoff(lock, ww_ctx);
+			__ww_mutex_wakeup_for_wound(lock, ww_ctx);
 
 		goto skip_wait;
 	}
@@ -790,10 +810,10 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		waiter.ww_ctx = MUTEX_POISON_WW_CTX;
 #endif
 	} else {
-		/* Add in stamp order, waking up waiters that must back off. */
+		/* Add in stamp order, waking up waiters that must wound themselves. */
 		ret = __ww_mutex_add_waiter(&waiter, lock, ww_ctx);
 		if (ret)
-			goto err_early_backoff;
+			goto err_early_wound;
 
 		waiter.ww_ctx = ww_ctx;
 	}
@@ -824,8 +844,8 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 			goto err;
 		}
 
-		if (use_ww_ctx && ww_ctx && ww_ctx->acquired > 0) {
-			ret = __ww_mutex_lock_check_stamp(lock, &waiter, ww_ctx);
+		if (use_ww_ctx && ww_ctx) {
+			ret = __ww_mutex_check_stamp(lock, &waiter, ww_ctx);
 			if (ret)
 				goto err;
 		}
@@ -870,7 +890,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 	lock_acquired(&lock->dep_map, ip);
 
 	if (use_ww_ctx && ww_ctx)
-		ww_mutex_set_context_slowpath(ww, ww_ctx);
+		ww_mutex_lock_acquired(ww, ww_ctx);
 
 	spin_unlock(&lock->wait_lock);
 	preempt_enable();
@@ -879,7 +899,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 err:
 	__set_current_state(TASK_RUNNING);
 	mutex_remove_waiter(lock, &waiter, current);
-err_early_backoff:
+err_early_wound:
 	spin_unlock(&lock->wait_lock);
 	debug_mutex_free_waiter(&waiter);
 	mutex_release(&lock->dep_map, 1, ip);
