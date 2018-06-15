Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-by2nam03on0061.outbound.protection.outlook.com ([104.47.42.61]:2752
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755816AbeFOMJK (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Jun 2018 08:09:10 -0400
From: Thomas Hellstrom <thellstrom@vmware.com>
To: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        peterz@infradead.org
Cc: Ingo Molnar <mingo@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
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
        linaro-mm-sig@lists.linaro.org,
        Thomas Hellstrom <thellstrom@vmware.com>
Subject: [PATCH 1/2] locking: WW mutex cleanup
Date: Fri, 15 Jun 2018 14:08:26 +0200
Message-Id: <20180615120827.3989-1-thellstrom@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Peter Ziljstra <peterz@infradead.org>

Make the WW mutex code more readable by adding comments, splitting up
functions and pointing out that we're actually using the Wait-Die
algorithm.

Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Gustavo Padovan <gustavo@padovan.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Sean Paul <seanpaul@chromium.org>
Cc: David Airlie <airlied@linux.ie>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Kate Stewart <kstewart@linuxfoundation.org>
Cc: Philippe Ombredanne <pombredanne@nexb.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-doc@vger.kernel.org
Cc: linux-media@vger.kernel.org
Cc: linaro-mm-sig@lists.linaro.org
Co-authored-by: Thomas Hellstrom <thellstrom@vmware.com>
Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
---
 Documentation/locking/ww-mutex-design.txt |  12 +-
 include/linux/ww_mutex.h                  |  28 ++---
 kernel/locking/mutex.c                    | 202 ++++++++++++++++++------------
 3 files changed, 145 insertions(+), 97 deletions(-)

diff --git a/Documentation/locking/ww-mutex-design.txt b/Documentation/locking/ww-mutex-design.txt
index 34c3a1b50b9a..2fd7f2a2af21 100644
--- a/Documentation/locking/ww-mutex-design.txt
+++ b/Documentation/locking/ww-mutex-design.txt
@@ -32,10 +32,10 @@ the oldest task) wins, and the one with the higher reservation id (i.e. the
 younger task) unlocks all of the buffers that it has already locked, and then
 tries again.
 
-In the RDBMS literature this deadlock handling approach is called wait/wound:
+In the RDBMS literature this deadlock handling approach is called wait/die:
 The older tasks waits until it can acquire the contended lock. The younger tasks
 needs to back off and drop all the locks it is currently holding, i.e. the
-younger task is wounded.
+younger task dies.
 
 Concepts
 --------
@@ -56,9 +56,9 @@ Furthermore there are three different class of w/w lock acquire functions:
 
 * Normal lock acquisition with a context, using ww_mutex_lock.
 
-* Slowpath lock acquisition on the contending lock, used by the wounded task
-  after having dropped all already acquired locks. These functions have the
-  _slow postfix.
+* Slowpath lock acquisition on the contending lock, used by the task that just
+  killed its transaction after having dropped all already acquired locks.
+  These functions have the _slow postfix.
 
   From a simple semantics point-of-view the _slow functions are not strictly
   required, since simply calling the normal ww_mutex_lock functions on the
@@ -220,7 +220,7 @@ mutexes are a natural fit for such a case for two reasons:
 
 Note that this approach differs in two important ways from the above methods:
 - Since the list of objects is dynamically constructed (and might very well be
-  different when retrying due to hitting the -EDEADLK wound condition) there's
+  different when retrying due to hitting the -EDEADLK die condition) there's
   no need to keep any object on a persistent list when it's not locked. We can
   therefore move the list_head into the object itself.
 - On the other hand the dynamic object list construction also means that the -EALREADY return
diff --git a/include/linux/ww_mutex.h b/include/linux/ww_mutex.h
index 39fda195bf78..f82fce2229c8 100644
--- a/include/linux/ww_mutex.h
+++ b/include/linux/ww_mutex.h
@@ -6,7 +6,7 @@
  *
  *  Copyright (C) 2004, 2005, 2006 Red Hat, Inc., Ingo Molnar <mingo@redhat.com>
  *
- * Wound/wait implementation:
+ * Wait/Die implementation:
  *  Copyright (C) 2013 Canonical Ltd.
  *
  * This file contains the main data structure and API definitions.
@@ -28,9 +28,9 @@ struct ww_class {
 struct ww_acquire_ctx {
 	struct task_struct *task;
 	unsigned long stamp;
-	unsigned acquired;
+	unsigned int acquired;
 #ifdef CONFIG_DEBUG_MUTEXES
-	unsigned done_acquire;
+	unsigned int done_acquire;
 	struct ww_class *ww_class;
 	struct ww_mutex *contending_lock;
 #endif
@@ -38,8 +38,8 @@ struct ww_acquire_ctx {
 	struct lockdep_map dep_map;
 #endif
 #ifdef CONFIG_DEBUG_WW_MUTEX_SLOWPATH
-	unsigned deadlock_inject_interval;
-	unsigned deadlock_inject_countdown;
+	unsigned int deadlock_inject_interval;
+	unsigned int deadlock_inject_countdown;
 #endif
 };
 
@@ -102,7 +102,7 @@ static inline void ww_mutex_init(struct ww_mutex *lock,
  *
  * Context-based w/w mutex acquiring can be done in any order whatsoever within
  * a given lock class. Deadlocks will be detected and handled with the
- * wait/wound logic.
+ * wait/die logic.
  *
  * Mixing of context-based w/w mutex acquiring and single w/w mutex locking can
  * result in undetected deadlocks and is so forbidden. Mixing different contexts
@@ -195,13 +195,13 @@ static inline void ww_acquire_fini(struct ww_acquire_ctx *ctx)
  * Lock the w/w mutex exclusively for this task.
  *
  * Deadlocks within a given w/w class of locks are detected and handled with the
- * wait/wound algorithm. If the lock isn't immediately avaiable this function
+ * wait/die algorithm. If the lock isn't immediately available this function
  * will either sleep until it is (wait case). Or it selects the current context
- * for backing off by returning -EDEADLK (wound case). Trying to acquire the
+ * for backing off by returning -EDEADLK (die case). Trying to acquire the
  * same lock with the same context twice is also detected and signalled by
  * returning -EALREADY. Returns 0 if the mutex was successfully acquired.
  *
- * In the wound case the caller must release all currently held w/w mutexes for
+ * In the die case the caller must release all currently held w/w mutexes for
  * the given context and then wait for this contending lock to be available by
  * calling ww_mutex_lock_slow. Alternatively callers can opt to not acquire this
  * lock and proceed with trying to acquire further w/w mutexes (e.g. when
@@ -226,14 +226,14 @@ extern int /* __must_check */ ww_mutex_lock(struct ww_mutex *lock, struct ww_acq
  * Lock the w/w mutex exclusively for this task.
  *
  * Deadlocks within a given w/w class of locks are detected and handled with the
- * wait/wound algorithm. If the lock isn't immediately avaiable this function
+ * wait/die algorithm. If the lock isn't immediately available this function
  * will either sleep until it is (wait case). Or it selects the current context
- * for backing off by returning -EDEADLK (wound case). Trying to acquire the
+ * for backing off by returning -EDEADLK (die case). Trying to acquire the
  * same lock with the same context twice is also detected and signalled by
  * returning -EALREADY. Returns 0 if the mutex was successfully acquired. If a
  * signal arrives while waiting for the lock then this function returns -EINTR.
  *
- * In the wound case the caller must release all currently held w/w mutexes for
+ * In the die case the caller must release all currently held w/w mutexes for
  * the given context and then wait for this contending lock to be available by
  * calling ww_mutex_lock_slow_interruptible. Alternatively callers can opt to
  * not acquire this lock and proceed with trying to acquire further w/w mutexes
@@ -256,7 +256,7 @@ extern int __must_check ww_mutex_lock_interruptible(struct ww_mutex *lock,
  * @lock: the mutex to be acquired
  * @ctx: w/w acquire context
  *
- * Acquires a w/w mutex with the given context after a wound case. This function
+ * Acquires a w/w mutex with the given context after a die case. This function
  * will sleep until the lock becomes available.
  *
  * The caller must have released all w/w mutexes already acquired with the
@@ -290,7 +290,7 @@ ww_mutex_lock_slow(struct ww_mutex *lock, struct ww_acquire_ctx *ctx)
  * @lock: the mutex to be acquired
  * @ctx: w/w acquire context
  *
- * Acquires a w/w mutex with the given context after a wound case. This function
+ * Acquires a w/w mutex with the given context after a die case. This function
  * will sleep until the lock becomes available and returns 0 when the lock has
  * been acquired. If a signal arrives while waiting for the lock then this
  * function returns -EINTR.
diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
index 2048359f33d2..412b4fc08235 100644
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -243,6 +243,17 @@ void __sched mutex_lock(struct mutex *lock)
 EXPORT_SYMBOL(mutex_lock);
 #endif
 
+/*
+ * Wait-Die:
+ *   The newer transactions are killed when:
+ *     It (the new transaction) makes a request for a lock being held
+ *     by an older transaction.
+ */
+
+/*
+ * Associate the ww_mutex @ww with the context @ww_ctx under which we acquired
+ * it.
+ */
 static __always_inline void
 ww_mutex_lock_acquired(struct ww_mutex *ww, struct ww_acquire_ctx *ww_ctx)
 {
@@ -281,26 +292,53 @@ ww_mutex_lock_acquired(struct ww_mutex *ww, struct ww_acquire_ctx *ww_ctx)
 	DEBUG_LOCKS_WARN_ON(ww_ctx->ww_class != ww->ww_class);
 #endif
 	ww_ctx->acquired++;
+	ww->ctx = ww_ctx;
 }
 
+/*
+ * Determine if context @a is 'after' context @b. IOW, @a is a younger
+ * transaction than @b and depending on algorithm either needs to wait for
+ * @b or die.
+ */
 static inline bool __sched
 __ww_ctx_stamp_after(struct ww_acquire_ctx *a, struct ww_acquire_ctx *b)
 {
-	return a->stamp - b->stamp <= LONG_MAX &&
-	       (a->stamp != b->stamp || a > b);
+
+	return (signed long)(a->stamp - b->stamp) > 0;
+}
+
+/*
+ * Wait-Die; wake a younger waiter context (when locks held) such that it can
+ * die.
+ *
+ * Among waiters with context, only the first one can have other locks acquired
+ * already (ctx->acquired > 0), because __ww_mutex_add_waiter() and
+ * __ww_mutex_check_kill() wake any but the earliest context.
+ */
+static bool __sched
+__ww_mutex_die(struct mutex *lock, struct mutex_waiter *waiter,
+	       struct ww_acquire_ctx *ww_ctx)
+{
+	if (waiter->ww_ctx->acquired > 0 &&
+			__ww_ctx_stamp_after(waiter->ww_ctx, ww_ctx)) {
+		debug_mutex_wake_waiter(lock, waiter);
+		wake_up_process(waiter->task);
+	}
+
+	return true;
 }
 
 /*
- * Wake up any waiters that may have to back off when the lock is held by the
- * given context.
+ * We just acquired @lock under @ww_ctx, if there are later contexts waiting
+ * behind us on the wait-list, check if they need to die.
  *
- * Due to the invariants on the wait list, this can only affect the first
- * waiter with a context.
+ * See __ww_mutex_add_waiter() for the list-order construction; basically the
+ * list is ordered by stamp, smallest (oldest) first.
  *
  * The current task must not be on the wait list.
  */
 static void __sched
-__ww_mutex_wakeup_for_backoff(struct mutex *lock, struct ww_acquire_ctx *ww_ctx)
+__ww_mutex_check_waiters(struct mutex *lock, struct ww_acquire_ctx *ww_ctx)
 {
 	struct mutex_waiter *cur;
 
@@ -310,30 +348,23 @@ __ww_mutex_wakeup_for_backoff(struct mutex *lock, struct ww_acquire_ctx *ww_ctx)
 		if (!cur->ww_ctx)
 			continue;
 
-		if (cur->ww_ctx->acquired > 0 &&
-		    __ww_ctx_stamp_after(cur->ww_ctx, ww_ctx)) {
-			debug_mutex_wake_waiter(lock, cur);
-			wake_up_process(cur->task);
-		}
-
-		break;
+		if (__ww_mutex_die(lock, cur, ww_ctx))
+			break;
 	}
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
-	 * the atomic read is done, otherwise contended waiters might be
+	 * the WAITERS check is done, otherwise contended waiters might be
 	 * missed. The contended waiters will either see ww_ctx == NULL
 	 * and keep spinning, or it will acquire wait_lock, add itself
 	 * to waiter list and sleep.
@@ -347,29 +378,14 @@ ww_mutex_set_context_fastpath(struct ww_mutex *lock, struct ww_acquire_ctx *ctx)
 		return;
 
 	/*
-	 * Uh oh, we raced in fastpath, wake up everyone in this case,
-	 * so they can see the new lock->ctx.
+	 * Uh oh, we raced in fastpath, check if any of the waiters need to
+	 * die.
 	 */
 	spin_lock(&lock->base.wait_lock);
-	__ww_mutex_wakeup_for_backoff(&lock->base, ctx);
+	__ww_mutex_check_waiters(&lock->base, ctx);
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
@@ -645,37 +661,73 @@ void __sched ww_mutex_unlock(struct ww_mutex *lock)
 }
 EXPORT_SYMBOL(ww_mutex_unlock);
 
+
+static __always_inline int __sched
+__ww_mutex_kill(struct mutex *lock, struct ww_acquire_ctx *ww_ctx)
+{
+	if (ww_ctx->acquired > 0) {
+#ifdef CONFIG_DEBUG_MUTEXES
+		struct ww_mutex *ww;
+
+		ww = container_of(lock, struct ww_mutex, base);
+		DEBUG_LOCKS_WARN_ON(ww_ctx->contending_lock);
+		ww_ctx->contending_lock = ww;
+#endif
+		return -EDEADLK;
+	}
+
+	return 0;
+}
+
+
+/*
+ * Check whether we need to kill the transaction for the current lock acquire.
+ *
+ * Wait-Die: If we're trying to acquire a lock already held by an older
+ *           context, kill ourselves.
+ *
+ * Since __ww_mutex_add_waiter() orders the wait-list on stamp, we only have to
+ * look at waiters before us in the wait-list.
+ */
 static inline int __sched
-__ww_mutex_lock_check_stamp(struct mutex *lock, struct mutex_waiter *waiter,
-			    struct ww_acquire_ctx *ctx)
+__ww_mutex_check_kill(struct mutex *lock, struct mutex_waiter *waiter,
+		      struct ww_acquire_ctx *ctx)
 {
 	struct ww_mutex *ww = container_of(lock, struct ww_mutex, base);
 	struct ww_acquire_ctx *hold_ctx = READ_ONCE(ww->ctx);
 	struct mutex_waiter *cur;
 
+	if (ctx->acquired == 0)
+		return 0;
+
 	if (hold_ctx && __ww_ctx_stamp_after(ctx, hold_ctx))
-		goto deadlock;
+		return __ww_mutex_kill(lock, ctx);
 
 	/*
 	 * If there is a waiter in front of us that has a context, then its
-	 * stamp is earlier than ours and we must back off.
+	 * stamp is earlier than ours and we must kill ourself.
 	 */
 	cur = waiter;
 	list_for_each_entry_continue_reverse(cur, &lock->wait_list, list) {
-		if (cur->ww_ctx)
-			goto deadlock;
+		if (!cur->ww_ctx)
+			continue;
+
+		return __ww_mutex_kill(lock, ctx);
 	}
 
 	return 0;
-
-deadlock:
-#ifdef CONFIG_DEBUG_MUTEXES
-	DEBUG_LOCKS_WARN_ON(ctx->contending_lock);
-	ctx->contending_lock = ww;
-#endif
-	return -EDEADLK;
 }
 
+/*
+ * Add @waiter to the wait-list, keep the wait-list ordered by stamp, smallest
+ * first. Such that older contexts are preferred to acquire the lock over
+ * younger contexts.
+ *
+ * Waiters without context are interspersed in FIFO order.
+ *
+ * Furthermore, for Wait-Die kill ourself immediately when possible (there are
+ * older contexts already waiting) to avoid unnecessary waiting.
+ */
 static inline int __sched
 __ww_mutex_add_waiter(struct mutex_waiter *waiter,
 		      struct mutex *lock,
@@ -692,7 +744,7 @@ __ww_mutex_add_waiter(struct mutex_waiter *waiter,
 	/*
 	 * Add the waiter before the first waiter with a higher stamp.
 	 * Waiters without a context are skipped to avoid starving
-	 * them.
+	 * them. Wait-Die waiters may die here.
 	 */
 	pos = &lock->wait_list;
 	list_for_each_entry_reverse(cur, &lock->wait_list, list) {
@@ -700,34 +752,27 @@ __ww_mutex_add_waiter(struct mutex_waiter *waiter,
 			continue;
 
 		if (__ww_ctx_stamp_after(ww_ctx, cur->ww_ctx)) {
-			/* Back off immediately if necessary. */
-			if (ww_ctx->acquired > 0) {
-#ifdef CONFIG_DEBUG_MUTEXES
-				struct ww_mutex *ww;
+			/*
+			 * Wait-Die: if we find an older context waiting, there
+			 * is no point in queueing behind it, as we'd have to
+			 * die the moment it would acquire the lock.
+			 */
+			int ret = __ww_mutex_kill(lock, ww_ctx);
 
-				ww = container_of(lock, struct ww_mutex, base);
-				DEBUG_LOCKS_WARN_ON(ww_ctx->contending_lock);
-				ww_ctx->contending_lock = ww;
-#endif
-				return -EDEADLK;
-			}
+			if (ret)
+				return ret;
 
 			break;
 		}
 
 		pos = &cur->list;
 
-		/*
-		 * Wake up the waiter so that it gets a chance to back
-		 * off.
-		 */
-		if (cur->ww_ctx->acquired > 0) {
-			debug_mutex_wake_waiter(lock, cur);
-			wake_up_process(cur->task);
-		}
+		/* Wait-Die: ensure younger waiters die. */
+		__ww_mutex_die(lock, cur, ww_ctx);
 	}
 
 	list_add_tail(&waiter->list, pos);
+
 	return 0;
 }
 
@@ -771,7 +816,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 	 */
 	if (__mutex_trylock(lock)) {
 		if (use_ww_ctx && ww_ctx)
-			__ww_mutex_wakeup_for_backoff(lock, ww_ctx);
+			__ww_mutex_check_waiters(lock, ww_ctx);
 
 		goto skip_wait;
 	}
@@ -789,10 +834,13 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		waiter.ww_ctx = MUTEX_POISON_WW_CTX;
 #endif
 	} else {
-		/* Add in stamp order, waking up waiters that must back off. */
+		/*
+		 * Add in stamp order, waking up waiters that must kill
+		 * themselves.
+		 */
 		ret = __ww_mutex_add_waiter(&waiter, lock, ww_ctx);
 		if (ret)
-			goto err_early_backoff;
+			goto err_early_kill;
 
 		waiter.ww_ctx = ww_ctx;
 	}
@@ -814,7 +862,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 			goto acquired;
 
 		/*
-		 * Check for signals and wound conditions while holding
+		 * Check for signals and kill conditions while holding
 		 * wait_lock. This ensures the lock cancellation is ordered
 		 * against mutex_unlock() and wake-ups do not go missing.
 		 */
@@ -823,8 +871,8 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 			goto err;
 		}
 
-		if (use_ww_ctx && ww_ctx && ww_ctx->acquired > 0) {
-			ret = __ww_mutex_lock_check_stamp(lock, &waiter, ww_ctx);
+		if (use_ww_ctx && ww_ctx) {
+			ret = __ww_mutex_check_kill(lock, &waiter, ww_ctx);
 			if (ret)
 				goto err;
 		}
@@ -869,7 +917,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 	lock_acquired(&lock->dep_map, ip);
 
 	if (use_ww_ctx && ww_ctx)
-		ww_mutex_set_context_slowpath(ww, ww_ctx);
+		ww_mutex_lock_acquired(ww, ww_ctx);
 
 	spin_unlock(&lock->wait_lock);
 	preempt_enable();
@@ -878,7 +926,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 err:
 	__set_current_state(TASK_RUNNING);
 	mutex_remove_waiter(lock, &waiter, current);
-err_early_backoff:
+err_early_kill:
 	spin_unlock(&lock->wait_lock);
 	debug_mutex_free_waiter(&waiter);
 	mutex_release(&lock->dep_map, 1, ip);
-- 
2.14.3
