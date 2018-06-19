Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-co1nam03on0057.outbound.protection.outlook.com ([104.47.40.57]:50284
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756648AbeFSI0J (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Jun 2018 04:26:09 -0400
From: Thomas Hellstrom <thellstrom@vmware.com>
To: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        peterz@infradead.org
Cc: linux-graphics-maintainer@vmware.com, pv-drivers@vmware.com,
        Thomas Hellstrom <thellstrom@vmware.com>,
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
Subject: [PATCH v4 2/3] locking: Implement an algorithm choice for Wound-Wait mutexes
Date: Tue, 19 Jun 2018 10:24:44 +0200
Message-Id: <20180619082445.11062-3-thellstrom@vmware.com>
In-Reply-To: <20180619082445.11062-1-thellstrom@vmware.com>
References: <20180619082445.11062-1-thellstrom@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The current Wound-Wait mutex algorithm is actually not Wound-Wait but
Wait-Die. Implement also Wound-Wait as a per-ww-class choice. Wound-Wait
is, contrary to Wait-Die a preemptive algorithm and is known to generate
fewer backoffs. Testing reveals that this is true if the
number of simultaneous contending transactions is small.
As the number of simultaneous contending threads increases, Wait-Wound
becomes inferior to Wait-Die in terms of elapsed time.
Possibly due to the larger number of held locks of sleeping transactions.

Update documentation and callers.

Timings using git://people.freedesktop.org/~thomash/ww_mutex_test
tag patch-18-06-15

Each thread runs 100000 batches of lock / unlock 800 ww mutexes randomly
chosen out of 100000. Four core Intel x86_64:

Algorithm    #threads       Rollbacks  time
Wound-Wait   4              ~100       ~17s.
Wait-Die     4              ~150000    ~19s.
Wound-Wait   16             ~360000    ~109s.
Wait-Die     16             ~450000    ~82s.

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
Co-authored-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>

---
v2:
* Update API according to review comment by Greg Kroah-Hartman.
* Address review comments by Peter Zijlstra:
  - Avoid _Bool in composites
  - Fix typo
  - Use __mutex_owner() where applicable
  - Rely on built-in barriers for the main loop exit condition,
    struct ww_acquire_ctx::wounded. Update code comments.
  - Explain unlocked use of list_empty().
v3:
* Adapt to and incorporate cleanup by Peter Zijlstra
* Remove unlocked use of list_empty().
v4:
* Move code related to adding a waiter to the lock waiter list to a
  separate function.
---
 Documentation/locking/ww-mutex-design.txt |  57 +++++++++--
 drivers/dma-buf/reservation.c             |   2 +-
 drivers/gpu/drm/drm_modeset_lock.c        |   2 +-
 include/linux/ww_mutex.h                  |  17 ++-
 kernel/locking/locktorture.c              |   2 +-
 kernel/locking/mutex.c                    | 165 +++++++++++++++++++++++++++---
 kernel/locking/test-ww_mutex.c            |   2 +-
 lib/locking-selftest.c                    |   2 +-
 8 files changed, 213 insertions(+), 36 deletions(-)

diff --git a/Documentation/locking/ww-mutex-design.txt b/Documentation/locking/ww-mutex-design.txt
index 2fd7f2a2af21..f0ed7c30e695 100644
--- a/Documentation/locking/ww-mutex-design.txt
+++ b/Documentation/locking/ww-mutex-design.txt
@@ -1,4 +1,4 @@
-Wait/Wound Deadlock-Proof Mutex Design
+Wound/Wait Deadlock-Proof Mutex Design
 ======================================
 
 Please read mutex-design.txt first, as it applies to wait/wound mutexes too.
@@ -32,10 +32,26 @@ the oldest task) wins, and the one with the higher reservation id (i.e. the
 younger task) unlocks all of the buffers that it has already locked, and then
 tries again.
 
-In the RDBMS literature this deadlock handling approach is called wait/die:
-The older tasks waits until it can acquire the contended lock. The younger tasks
-needs to back off and drop all the locks it is currently holding, i.e. the
-younger task dies.
+In the RDBMS literature, a reservation ticket is associated with a transaction.
+and the deadlock handling approach is called Wait-Die. The name is based on
+the actions of a locking thread when it encounters an already locked mutex.
+If the transaction holding the lock is younger, the locking transaction waits.
+If the transaction holding the lock is older, the locking transaction backs off
+and dies. Hence Wait-Die.
+There is also another algorithm called Wound-Wait:
+If the transaction holding the lock is younger, the locking transaction
+wounds the transaction holding the lock, requesting it to die.
+If the transaction holding the lock is older, it waits for the other
+transaction. Hence Wound-Wait.
+The two algorithms are both fair in that a transaction will eventually succeed.
+However, the Wound-Wait algorithm is typically stated to generate fewer backoffs
+compared to Wait-Die, but is, on the other hand, associated with more work than
+Wait-Die when recovering from a backoff. Wound-Wait is also a preemptive
+algorithm in that transactions are wounded by other transactions, and that
+requires a reliable way to pick up up the wounded condition and preempt the
+running transaction. Note that this is not the same as process preemption. A
+Wound-Wait transaction is considered preempted when it dies (returning
+-EDEADLK) following a wound.
 
 Concepts
 --------
@@ -47,10 +63,12 @@ Acquire context: To ensure eventual forward progress it is important the a task
 trying to acquire locks doesn't grab a new reservation id, but keeps the one it
 acquired when starting the lock acquisition. This ticket is stored in the
 acquire context. Furthermore the acquire context keeps track of debugging state
-to catch w/w mutex interface abuse.
+to catch w/w mutex interface abuse. An acquire context is representing a
+transaction.
 
 W/w class: In contrast to normal mutexes the lock class needs to be explicit for
-w/w mutexes, since it is required to initialize the acquire context.
+w/w mutexes, since it is required to initialize the acquire context. The lock
+class also specifies what algorithm to use, Wound-Wait or Wait-Die.
 
 Furthermore there are three different class of w/w lock acquire functions:
 
@@ -90,6 +108,12 @@ provided.
 Usage
 -----
 
+The algorithm (Wait-Die vs Wound-Wait) is chosen by using either
+DEFINE_WW_CLASS() (Wound-Wait) or DEFINE_WD_CLASS() (Wait-Die)
+As a rough rule of thumb, use Wound-Wait iff you
+expect the number of simultaneous competing transactions to be typically small,
+and you want to reduce the number of rollbacks.
+
 Three different ways to acquire locks within the same w/w class. Common
 definitions for methods #1 and #2:
 
@@ -312,12 +336,23 @@ Design:
   We maintain the following invariants for the wait list:
   (1) Waiters with an acquire context are sorted by stamp order; waiters
       without an acquire context are interspersed in FIFO order.
-  (2) Among waiters with contexts, only the first one can have other locks
-      acquired already (ctx->acquired > 0). Note that this waiter may come
-      after other waiters without contexts in the list.
+  (2) For Wait-Die, among waiters with contexts, only the first one can have
+      other locks acquired already (ctx->acquired > 0). Note that this waiter
+      may come after other waiters without contexts in the list.
+
+  The Wound-Wait preemption is implemented with a lazy-preemption scheme:
+  The wounded status of the transaction is checked only when there is
+  contention for a new lock and hence a true chance of deadlock. In that
+  situation, if the transaction is wounded, it backs off, clears the
+  wounded status and retries. A great benefit of implementing preemption in
+  this way is that the wounded transaction can identify a contending lock to
+  wait for before restarting the transaction. Just blindly restarting the
+  transaction would likely make the transaction end up in a situation where
+  it would have to back off again.
 
   In general, not much contention is expected. The locks are typically used to
-  serialize access to resources for devices.
+  serialize access to resources for devices, and optimization focus should
+  therefore be directed towards the uncontended cases.
 
 Lockdep:
   Special care has been taken to warn for as many cases of api abuse
diff --git a/drivers/dma-buf/reservation.c b/drivers/dma-buf/reservation.c
index 314eb1071cce..20bf90f4ee63 100644
--- a/drivers/dma-buf/reservation.c
+++ b/drivers/dma-buf/reservation.c
@@ -46,7 +46,7 @@
  * write-side updates.
  */
 
-DEFINE_WW_CLASS(reservation_ww_class);
+DEFINE_WD_CLASS(reservation_ww_class);
 EXPORT_SYMBOL(reservation_ww_class);
 
 struct lock_class_key reservation_seqcount_class;
diff --git a/drivers/gpu/drm/drm_modeset_lock.c b/drivers/gpu/drm/drm_modeset_lock.c
index 8a5100685875..638be2eb67b4 100644
--- a/drivers/gpu/drm/drm_modeset_lock.c
+++ b/drivers/gpu/drm/drm_modeset_lock.c
@@ -70,7 +70,7 @@
  * lists and lookup data structures.
  */
 
-static DEFINE_WW_CLASS(crtc_ww_class);
+static DEFINE_WD_CLASS(crtc_ww_class);
 
 /**
  * drm_modeset_lock_all - take all modeset locks
diff --git a/include/linux/ww_mutex.h b/include/linux/ww_mutex.h
index f82fce2229c8..3af7c0e03be5 100644
--- a/include/linux/ww_mutex.h
+++ b/include/linux/ww_mutex.h
@@ -8,6 +8,8 @@
  *
  * Wait/Die implementation:
  *  Copyright (C) 2013 Canonical Ltd.
+ * Choice of algorithm:
+ *  Copyright (C) 2018 WMWare Inc.
  *
  * This file contains the main data structure and API definitions.
  */
@@ -23,12 +25,15 @@ struct ww_class {
 	struct lock_class_key mutex_key;
 	const char *acquire_name;
 	const char *mutex_name;
+	unsigned int is_wait_die;
 };
 
 struct ww_acquire_ctx {
 	struct task_struct *task;
 	unsigned long stamp;
 	unsigned int acquired;
+	unsigned short wounded;
+	unsigned short is_wait_die;
 #ifdef CONFIG_DEBUG_MUTEXES
 	unsigned int done_acquire;
 	struct ww_class *ww_class;
@@ -58,17 +63,21 @@ struct ww_mutex {
 # define __WW_CLASS_MUTEX_INITIALIZER(lockname, class)
 #endif
 
-#define __WW_CLASS_INITIALIZER(ww_class) \
+#define __WW_CLASS_INITIALIZER(ww_class, _is_wait_die)	    \
 		{ .stamp = ATOMIC_LONG_INIT(0) \
 		, .acquire_name = #ww_class "_acquire" \
-		, .mutex_name = #ww_class "_mutex" }
+		, .mutex_name = #ww_class "_mutex" \
+		, .is_wait_die = _is_wait_die }
 
 #define __WW_MUTEX_INITIALIZER(lockname, class) \
 		{ .base =  __MUTEX_INITIALIZER(lockname.base) \
 		__WW_CLASS_MUTEX_INITIALIZER(lockname, class) }
 
+#define DEFINE_WD_CLASS(classname) \
+	struct ww_class classname = __WW_CLASS_INITIALIZER(classname, 1)
+
 #define DEFINE_WW_CLASS(classname) \
-	struct ww_class classname = __WW_CLASS_INITIALIZER(classname)
+	struct ww_class classname = __WW_CLASS_INITIALIZER(classname, 0)
 
 #define DEFINE_WW_MUTEX(mutexname, ww_class) \
 	struct ww_mutex mutexname = __WW_MUTEX_INITIALIZER(mutexname, ww_class)
@@ -123,6 +132,8 @@ static inline void ww_acquire_init(struct ww_acquire_ctx *ctx,
 	ctx->task = current;
 	ctx->stamp = atomic_long_inc_return_relaxed(&ww_class->stamp);
 	ctx->acquired = 0;
+	ctx->wounded = false;
+	ctx->is_wait_die = ww_class->is_wait_die;
 #ifdef CONFIG_DEBUG_MUTEXES
 	ctx->ww_class = ww_class;
 	ctx->done_acquire = 0;
diff --git a/kernel/locking/locktorture.c b/kernel/locking/locktorture.c
index 6850ffd69125..907e0325892c 100644
--- a/kernel/locking/locktorture.c
+++ b/kernel/locking/locktorture.c
@@ -365,7 +365,7 @@ static struct lock_torture_ops mutex_lock_ops = {
 };
 
 #include <linux/ww_mutex.h>
-static DEFINE_WW_CLASS(torture_ww_class);
+static DEFINE_WD_CLASS(torture_ww_class);
 static DEFINE_WW_MUTEX(torture_ww_mutex_0, &torture_ww_class);
 static DEFINE_WW_MUTEX(torture_ww_mutex_1, &torture_ww_class);
 static DEFINE_WW_MUTEX(torture_ww_mutex_2, &torture_ww_class);
diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
index 412b4fc08235..8ca83a5e3d24 100644
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -172,6 +172,21 @@ static inline bool __mutex_waiter_is_first(struct mutex *lock, struct mutex_wait
 	return list_first_entry(&lock->wait_list, struct mutex_waiter, list) == waiter;
 }
 
+/*
+ * Add @waiter to a given location in the lock wait_list and set the
+ * FLAG_WAITERS flag if it's the first waiter.
+ */
+static void __sched
+__mutex_add_waiter(struct mutex *lock, struct mutex_waiter *waiter,
+		   struct list_head *list)
+{
+	debug_mutex_add_waiter(lock, waiter, current);
+
+	list_add_tail(&waiter->list, list);
+	if (__mutex_waiter_is_first(lock, waiter))
+		__mutex_set_flag(lock, MUTEX_FLAG_WAITERS);
+}
+
 /*
  * Give up ownership to a specific task, when @task = NULL, this is equivalent
  * to a regular unlock. Sets PICKUP on a handoff, clears HANDOF, preserves
@@ -248,6 +263,11 @@ EXPORT_SYMBOL(mutex_lock);
  *   The newer transactions are killed when:
  *     It (the new transaction) makes a request for a lock being held
  *     by an older transaction.
+ *
+ * Wound-Wait:
+ *   The newer transactions are wounded when:
+ *     An older transaction makes a request for a lock being held by
+ *     the newer transaction.
  */
 
 /*
@@ -319,6 +339,9 @@ static bool __sched
 __ww_mutex_die(struct mutex *lock, struct mutex_waiter *waiter,
 	       struct ww_acquire_ctx *ww_ctx)
 {
+	if (!ww_ctx->is_wait_die)
+		return false;
+
 	if (waiter->ww_ctx->acquired > 0 &&
 			__ww_ctx_stamp_after(waiter->ww_ctx, ww_ctx)) {
 		debug_mutex_wake_waiter(lock, waiter);
@@ -328,13 +351,65 @@ __ww_mutex_die(struct mutex *lock, struct mutex_waiter *waiter,
 	return true;
 }
 
+/*
+ * Wound-Wait; wound a younger @hold_ctx if it holds the lock.
+ *
+ * Wound the lock holder if there are waiters with older transactions than
+ * the lock holders. Even if multiple waiters may wound the lock holder,
+ * it's sufficient that only one does.
+ */
+static bool __ww_mutex_wound(struct mutex *lock,
+			     struct ww_acquire_ctx *ww_ctx,
+			     struct ww_acquire_ctx *hold_ctx)
+{
+	struct task_struct *owner = __mutex_owner(lock);
+
+	lockdep_assert_held(&lock->wait_lock);
+
+	/*
+	 * Possible through __ww_mutex_add_waiter() when we race with
+	 * ww_mutex_set_context_fastpath(). In that case we'll get here again
+	 * through __ww_mutex_check_waiters().
+	 */
+	if (!hold_ctx)
+		return false;
+
+	/*
+	 * Can have !owner because of __mutex_unlock_slowpath(), but if owner,
+	 * it cannot go away because we'll have FLAG_WAITERS set and hold
+	 * wait_lock.
+	 */
+	if (!owner)
+		return false;
+
+	if (ww_ctx->acquired > 0 && __ww_ctx_stamp_after(hold_ctx, ww_ctx)) {
+		hold_ctx->wounded = 1;
+
+		/*
+		 * wake_up_process() paired with set_current_state()
+		 * inserts sufficient barriers to make sure @owner either sees
+		 * it's wounded in __ww_mutex_lock_check_stamp() or has a
+		 * wakeup pending to re-read the wounded state.
+		 */
+		if (owner != current)
+			wake_up_process(owner);
+
+		return true;
+	}
+
+	return false;
+}
+
 /*
  * We just acquired @lock under @ww_ctx, if there are later contexts waiting
- * behind us on the wait-list, check if they need to die.
+ * behind us on the wait-list, check if they need to die, or wound us.
  *
  * See __ww_mutex_add_waiter() for the list-order construction; basically the
  * list is ordered by stamp, smallest (oldest) first.
  *
+ * This relies on never mixing wait-die/wound-wait on the same wait-list;
+ * which is currently ensured by that being a ww_class property.
+ *
  * The current task must not be on the wait list.
  */
 static void __sched
@@ -348,7 +423,8 @@ __ww_mutex_check_waiters(struct mutex *lock, struct ww_acquire_ctx *ww_ctx)
 		if (!cur->ww_ctx)
 			continue;
 
-		if (__ww_mutex_die(lock, cur, ww_ctx))
+		if (__ww_mutex_die(lock, cur, ww_ctx) ||
+		    __ww_mutex_wound(lock, cur->ww_ctx, ww_ctx))
 			break;
 	}
 }
@@ -369,17 +445,23 @@ ww_mutex_set_context_fastpath(struct ww_mutex *lock, struct ww_acquire_ctx *ctx)
 	 * and keep spinning, or it will acquire wait_lock, add itself
 	 * to waiter list and sleep.
 	 */
-	smp_mb(); /* ^^^ */
+	smp_mb(); /* See comments above and below. */
 
 	/*
-	 * Check if lock is contended, if not there is nobody to wake up
+	 * [W] ww->ctx = ctx	    [W] MUTEX_FLAG_WAITERS
+	 *     MB		        MB
+	 * [R] MUTEX_FLAG_WAITERS   [R] ww->ctx
+	 *
+	 * The memory barrier above pairs with the memory barrier in
+	 * __ww_mutex_add_waiter() and makes sure we either observe ww->ctx
+	 * and/or !empty list.
 	 */
 	if (likely(!(atomic_long_read(&lock->base.owner) & MUTEX_FLAG_WAITERS)))
 		return;
 
 	/*
 	 * Uh oh, we raced in fastpath, check if any of the waiters need to
-	 * die.
+	 * die or wound us.
 	 */
 	spin_lock(&lock->base.wait_lock);
 	__ww_mutex_check_waiters(&lock->base, ctx);
@@ -681,7 +763,9 @@ __ww_mutex_kill(struct mutex *lock, struct ww_acquire_ctx *ww_ctx)
 
 
 /*
- * Check whether we need to kill the transaction for the current lock acquire.
+ * Check the wound condition for the current lock acquire.
+ *
+ * Wound-Wait: If we're wounded, kill ourself.
  *
  * Wait-Die: If we're trying to acquire a lock already held by an older
  *           context, kill ourselves.
@@ -700,6 +784,13 @@ __ww_mutex_check_kill(struct mutex *lock, struct mutex_waiter *waiter,
 	if (ctx->acquired == 0)
 		return 0;
 
+	if (!ctx->is_wait_die) {
+		if (ctx->wounded)
+			return __ww_mutex_kill(lock, ctx);
+
+		return 0;
+	}
+
 	if (hold_ctx && __ww_ctx_stamp_after(ctx, hold_ctx))
 		return __ww_mutex_kill(lock, ctx);
 
@@ -726,7 +817,8 @@ __ww_mutex_check_kill(struct mutex *lock, struct mutex_waiter *waiter,
  * Waiters without context are interspersed in FIFO order.
  *
  * Furthermore, for Wait-Die kill ourself immediately when possible (there are
- * older contexts already waiting) to avoid unnecessary waiting.
+ * older contexts already waiting) to avoid unnecessary waiting and for
+ * Wound-Wait ensure we wound the owning context when it is younger.
  */
 static inline int __sched
 __ww_mutex_add_waiter(struct mutex_waiter *waiter,
@@ -735,16 +827,21 @@ __ww_mutex_add_waiter(struct mutex_waiter *waiter,
 {
 	struct mutex_waiter *cur;
 	struct list_head *pos;
+	bool is_wait_die;
 
 	if (!ww_ctx) {
-		list_add_tail(&waiter->list, &lock->wait_list);
+		__mutex_add_waiter(lock, waiter, &lock->wait_list);
 		return 0;
 	}
 
+	is_wait_die = ww_ctx->is_wait_die;
+
 	/*
 	 * Add the waiter before the first waiter with a higher stamp.
 	 * Waiters without a context are skipped to avoid starving
-	 * them. Wait-Die waiters may die here.
+	 * them. Wait-Die waiters may die here. Wound-Wait waiters
+	 * never die here, but they are sorted in stamp order and
+	 * may wound the lock holder.
 	 */
 	pos = &lock->wait_list;
 	list_for_each_entry_reverse(cur, &lock->wait_list, list) {
@@ -757,10 +854,12 @@ __ww_mutex_add_waiter(struct mutex_waiter *waiter,
 			 * is no point in queueing behind it, as we'd have to
 			 * die the moment it would acquire the lock.
 			 */
-			int ret = __ww_mutex_kill(lock, ww_ctx);
+			if (is_wait_die) {
+				int ret = __ww_mutex_kill(lock, ww_ctx);
 
-			if (ret)
-				return ret;
+				if (ret)
+					return ret;
+			}
 
 			break;
 		}
@@ -771,7 +870,23 @@ __ww_mutex_add_waiter(struct mutex_waiter *waiter,
 		__ww_mutex_die(lock, cur, ww_ctx);
 	}
 
-	list_add_tail(&waiter->list, pos);
+	__mutex_add_waiter(lock, waiter, pos);
+
+	/*
+	 * Wound-Wait: if we're blocking on a mutex owned by a younger context,
+	 * wound that such that we might proceed.
+	 */
+	if (!is_wait_die) {
+		struct ww_mutex *ww = container_of(lock, struct ww_mutex, base);
+
+		/*
+		 * See ww_mutex_set_context_fastpath(). Orders setting
+		 * MUTEX_FLAG_WAITERS vs the ww->ctx load,
+		 * such that either we or the fastpath will wound @ww->ctx.
+		 */
+		smp_mb();
+		__ww_mutex_wound(lock, ww_ctx, ww->ctx);
+	}
 
 	return 0;
 }
@@ -795,6 +910,14 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 	if (use_ww_ctx && ww_ctx) {
 		if (unlikely(ww_ctx == READ_ONCE(ww->ctx)))
 			return -EALREADY;
+
+		/*
+		 * Reset the wounded flag after a kill. No other process can
+		 * race and wound us here since they can't have a valid owner
+		 * pointer if we don't have any locks held.
+		 */
+		if (ww_ctx->acquired == 0)
+			ww_ctx->wounded = 0;
 	}
 
 	preempt_disable();
@@ -828,7 +951,8 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 
 	if (!use_ww_ctx) {
 		/* add waiting tasks to the end of the waitqueue (FIFO): */
-		list_add_tail(&waiter.list, &lock->wait_list);
+		__mutex_add_waiter(lock, &waiter, &lock->wait_list);
+
 
 #ifdef CONFIG_DEBUG_MUTEXES
 		waiter.ww_ctx = MUTEX_POISON_WW_CTX;
@@ -847,9 +971,6 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 
 	waiter.task = current;
 
-	if (__mutex_waiter_is_first(lock, &waiter))
-		__mutex_set_flag(lock, MUTEX_FLAG_WAITERS);
-
 	set_current_state(state);
 	for (;;) {
 		/*
@@ -906,6 +1027,16 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 acquired:
 	__set_current_state(TASK_RUNNING);
 
+	if (use_ww_ctx && ww_ctx) {
+		/*
+		 * Wound-Wait; we stole the lock (!first_waiter), check the
+		 * waiters as anyone might want to wound us.
+		 */
+		if (!ww_ctx->is_wait_die &&
+		    !__mutex_waiter_is_first(lock, &waiter))
+			__ww_mutex_check_waiters(lock, ww_ctx);
+	}
+
 	mutex_remove_waiter(lock, &waiter, current);
 	if (likely(list_empty(&lock->wait_list)))
 		__mutex_clear_flag(lock, MUTEX_FLAGS);
diff --git a/kernel/locking/test-ww_mutex.c b/kernel/locking/test-ww_mutex.c
index 0e4cd64ad2c0..5b915b370d5a 100644
--- a/kernel/locking/test-ww_mutex.c
+++ b/kernel/locking/test-ww_mutex.c
@@ -26,7 +26,7 @@
 #include <linux/slab.h>
 #include <linux/ww_mutex.h>
 
-static DEFINE_WW_CLASS(ww_class);
+static DEFINE_WD_CLASS(ww_class);
 struct workqueue_struct *wq;
 
 struct test_mutex {
diff --git a/lib/locking-selftest.c b/lib/locking-selftest.c
index b5c1293ce147..1e1bbf171eca 100644
--- a/lib/locking-selftest.c
+++ b/lib/locking-selftest.c
@@ -29,7 +29,7 @@
  */
 static unsigned int debug_locks_verbose;
 
-static DEFINE_WW_CLASS(ww_lockdep);
+static DEFINE_WD_CLASS(ww_lockdep);
 
 static int __init setup_debug_locks_verbose(char *str)
 {
-- 
2.14.3
