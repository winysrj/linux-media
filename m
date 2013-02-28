Return-path: <linux-media-owner@vger.kernel.org>
Received: from adelie.canonical.com ([91.189.90.139]:42793 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865Ab3B1KZX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Feb 2013 05:25:23 -0500
Subject: [PATCH v2 2/3] mutex: add support for reservation style locks, v2
To: linux-kernel@vger.kernel.org
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: linux-arch@vger.kernel.org, a.p.zijlstra@chello.nl,
	daniel.vetter@ffwll.ch, x86@kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	robclark@gmail.com, tglx@linutronix.de, mingo@elte.hu,
	linux-media@vger.kernel.org
Date: Thu, 28 Feb 2013 11:25:02 +0100
Message-ID: <20130228102502.15191.14146.stgit@patser>
In-Reply-To: <20130228102452.15191.22673.stgit@patser>
References: <20130228102452.15191.22673.stgit@patser>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

New version. All of the documentation has been moved from the commit log to
Documentation/reservation-mutex-design.txt

Missing at the moment, maybe TODO?

Add a lockdep check in the *_slow calls that verifies that the lock
being nested into has no nested lock any more? This would be a check
to make sure that mutex_unreserve_unlock has been called on all other
locks correctly.

Changes since RFC patch v1:
 - Updated to use atomic_long instead of atomic, since the reservation_id was a long.
 - added mutex_reserve_lock_slow and mutex_reserve_lock_intr_slow
 - removed mutex_locked_set_reservation_id (or w/e it was called)
Changes since RFC patch v2:
 - remove use of __mutex_lock_retval_arg, add warnings when using wrong combination of
   mutex_(,reserve_)lock/unlock.
Changes since v1:
 - Add __always_inline to __mutex_lock_common, otherwise reservation paths can be
   triggered from normal locks, because __builtin_constant_p might evaluate to false
   for the constant 0 in that case. Tests for this have been added in the next patch.
 - Updated documentation slightly.

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
---
 Documentation/reservation-mutex-design.txt |  136 ++++++++++++
 include/linux/mutex.h                      |   86 +++++++
 kernel/mutex.c                             |  326 +++++++++++++++++++++++++++-
 3 files changed, 531 insertions(+), 17 deletions(-)
 create mode 100644 Documentation/reservation-mutex-design.txt

diff --git a/Documentation/reservation-mutex-design.txt b/Documentation/reservation-mutex-design.txt
new file mode 100644
index 0000000..4e2866c
--- /dev/null
+++ b/Documentation/reservation-mutex-design.txt
@@ -0,0 +1,136 @@
+Reservation type mutexes
+---
+
+Please read mutex-design.txt first, as it applies to reservation mutexes too.
+
+GPU's do operations that commonly involve many buffers.  Those buffers
+can be shared across contexts/processes, exist in different memory
+domains (for example VRAM vs system memory), and so on.  And with
+PRIME / dmabuf, they can even be shared across devices.  So there are
+a handful of situations where the driver needs to wait for buffers to
+become ready.  If you think about this in terms of waiting on a buffer
+mutex for it to become available, this presents a problem because
+there is no way to guarantee that buffers appear in a execbuf/batch in
+the same order in all contexts.  That is directly under control of
+userspace, and a result of the sequence of GL calls that an application
+makes.  Which results in the potential for deadlock.  The problem gets
+more complex when you consider that the kernel may need to migrate the
+buffer(s) into VRAM before the GPU operates on the buffer(s), which
+may in turn require evicting some other buffers (and you don't want to
+evict other buffers which are already queued up to the GPU), but for a
+simplified understanding of the problem you can ignore this.
+
+The algorithm that TTM came up with for dealing with this problem is
+quite simple.  For each group of buffers (execbuf) that need to be
+locked, the caller would be assigned a unique reservation_id, from a
+global counter.  In case of deadlock while locking all the buffers
+associated with a execbuf, the one with the lowest reservation_id
+wins, and the one with the higher reservation_id unlocks all of the
+buffers that it has already locked, and then tries again.
+
+How it is used:
+---------------
+
+A very simplified version:
+
+    int lock_execbuf(execbuf, ticket)
+    {
+        struct buf *res_buf = NULL;
+
+        /* acquiring locks, before queuing up to GPU: */
+        *ticket = assign_global_seqno();
+
+    retry:
+        for (buf in execbuf->buffers) {
+            if (buf == res_buf) {
+                res_buf = NULL;
+                continue;
+            }
+            ret = mutex_reserve_lock(&buf->lock, ticket, ticket->seqno);
+            if (ret < 0)
+                goto err;
+        }
+
+        /* now everything is good to go, submit job to GPU: */
+        ...
+
+        return 0;
+
+    err:
+        for (all buf2 before buf in execbuf->buffers)
+            mutex_unreserve_unlock(&buf2->lock);
+        if (res_buf)
+            mutex_unreserve_unlock(&res_buf->lock);
+
+        if (ret == -EAGAIN) {
+            /* we lost out in a seqno race, lock and retry.. */
+            mutex_reserve_lock_slow(&buf->lock, ticket, ticket->seqno);
+            res_buf = buf;
+            goto retry;
+        }
+        release_global_seqno(ticket);
+
+        return ret;
+    }
+
+    int unlock_execbuf(execbuf, ticket)
+    {
+        /* when GPU is finished; */
+        for (buf in execbuf->buffers)
+            mutex_unreserve_unlock(&buf->lock);
+        release_global_seqno(ticket);
+    }
+
+Functions:
+----------
+
+mutex_reserve_lock, and mutex_reserve_lock_interruptible:
+  Lock a reservation_lock with a reservation_id set. reservation_id must not
+  be set to 0, since this is a special value that means no reservation_id.
+
+  Normally if reservation_id is not set, or is older than the
+  reservation_id which is currently set on the mutex, the behavior will
+  be to wait normally.  However, if  the reservation_id is newer than
+  the current reservation_id, -EAGAIN will be returned.
+
+  These functions will return -EDEADLK instead of -EAGAIN if
+  reservation_id is the same as the reservation_id that's attempted to
+  lock the mutex with, since in that case you presumably attempted to
+  lock the same lock twice.
+
+mutex_reserve_lock_slow and mutex_reserve_lock_intr_slow:
+  Similar to mutex_reserve_lock, except it won't backoff with -EAGAIN.
+  This is useful when mutex_reserve_lock failed with -EAGAIN, and you
+  unreserved all reservation_locks so no deadlock can occur.
+
+mutex_unreserve_unlock:
+   Unlock a reservation_lock reserved with one of the mutex_reserve_*lock*
+   calls.
+
+Design:
+  ticket_mutex encapsulates a struct mutex, this means no extra overhead for
+  normal mutex locks, which are far more common. As such there is only a small
+  increase in code size if reservation mutexes are not used.
+
+  In general, not much contention is expected. The locks are intended to
+  serialize access to resources for devices. The only way to make wakeups
+  smarter would be at the cost of adding a field to struct mutex_waiter. This
+  would add overhead to all cases where normal mutexes are used, and
+  ticket_mutexes are less performance sensitive. For this reason
+  mutex_reserve_lock wakes up all waiters, so they can recheck themselves.
+
+Lockdep:
+  Lockdep operates on classes of locks. Ideally there should be only 2 lockdep
+  classes, one for the reservation_id itself, and one shared across all
+  reservation mutexes.
+
+  It may seem odd that reservation_id needs a lock class, but it's needed for
+  lockdep to work correctly. Because the lock class of all reservation mutexes
+  are equal, without nesting lockdep will complain. Using multiple lockdep
+  classes will result in reduced effectiveness.
+
+  The reason only a single lockdep class is wanted for reservation mutexes is
+  because it's always nested to the reservation_id's "lock", or only a single
+  lock is taken without any nesting at all. In the latter case no more than 1
+  mutex should be locked at the same time, which lockdep can only verify
+  if the lock class is always the same.
diff --git a/include/linux/mutex.h b/include/linux/mutex.h
index 9121595..602c247 100644
--- a/include/linux/mutex.h
+++ b/include/linux/mutex.h
@@ -62,6 +62,11 @@ struct mutex {
 #endif
 };
 
+struct ticket_mutex {
+	struct mutex base;
+	atomic_long_t reservation_id;
+};
+
 /*
  * This is the control structure for tasks blocked on mutex,
  * which resides on the blocked task's kernel stack:
@@ -109,12 +114,24 @@ static inline void mutex_destroy(struct mutex *lock) {}
 		__DEBUG_MUTEX_INITIALIZER(lockname) \
 		__DEP_MAP_MUTEX_INITIALIZER(lockname) }
 
+#define __TICKET_MUTEX_INITIALIZER(lockname) \
+		{ .base = __MUTEX_INITIALIZER(lockname) \
+		, .reservation_id = ATOMIC_LONG_INIT(0) }
+
 #define DEFINE_MUTEX(mutexname) \
 	struct mutex mutexname = __MUTEX_INITIALIZER(mutexname)
 
 extern void __mutex_init(struct mutex *lock, const char *name,
 			 struct lock_class_key *key);
 
+static inline void __ticket_mutex_init(struct ticket_mutex *lock,
+				       const char *name,
+				       struct lock_class_key *key)
+{
+	__mutex_init(&lock->base, name, key);
+	atomic_long_set(&lock->reservation_id, 0);
+}
+
 /**
  * mutex_is_locked - is the mutex locked
  * @lock: the mutex to be queried
@@ -133,26 +150,91 @@ static inline int mutex_is_locked(struct mutex *lock)
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 extern void mutex_lock_nested(struct mutex *lock, unsigned int subclass);
 extern void _mutex_lock_nest_lock(struct mutex *lock, struct lockdep_map *nest_lock);
+
 extern int __must_check mutex_lock_interruptible_nested(struct mutex *lock,
 					unsigned int subclass);
 extern int __must_check mutex_lock_killable_nested(struct mutex *lock,
 					unsigned int subclass);
 
+extern int __must_check _mutex_reserve_lock(struct ticket_mutex *lock,
+					struct lockdep_map *nest_lock,
+					unsigned long reservation_id);
+
+extern int __must_check _mutex_reserve_lock_interruptible(struct ticket_mutex *,
+					struct lockdep_map *nest_lock,
+					unsigned long reservation_id);
+
+extern void _mutex_reserve_lock_slow(struct ticket_mutex *lock,
+				     struct lockdep_map *nest_lock,
+				     unsigned long reservation_id);
+
+extern int __must_check _mutex_reserve_lock_intr_slow(struct ticket_mutex *,
+					struct lockdep_map *nest_lock,
+					unsigned long reservation_id);
+
 #define mutex_lock(lock) mutex_lock_nested(lock, 0)
 #define mutex_lock_interruptible(lock) mutex_lock_interruptible_nested(lock, 0)
 #define mutex_lock_killable(lock) mutex_lock_killable_nested(lock, 0)
 
 #define mutex_lock_nest_lock(lock, nest_lock)				\
 do {									\
-	typecheck(struct lockdep_map *, &(nest_lock)->dep_map);		\
+	typecheck(struct lockdep_map *, &(nest_lock)->dep_map);	\
 	_mutex_lock_nest_lock(lock, &(nest_lock)->dep_map);		\
 } while (0)
 
+#define mutex_reserve_lock(lock, nest_lock, reservation_id)		\
+({									\
+	typecheck(struct lockdep_map *, &(nest_lock)->dep_map);	\
+	_mutex_reserve_lock(lock, &(nest_lock)->dep_map, reservation_id);	\
+})
+
+#define mutex_reserve_lock_interruptible(lock, nest_lock, reservation_id)	\
+({									\
+	typecheck(struct lockdep_map *, &(nest_lock)->dep_map);	\
+	_mutex_reserve_lock_interruptible(lock, &(nest_lock)->dep_map,	\
+					   reservation_id);		\
+})
+
+#define mutex_reserve_lock_slow(lock, nest_lock, reservation_id)	\
+do {									\
+	typecheck(struct lockdep_map *, &(nest_lock)->dep_map);	\
+	_mutex_reserve_lock_slow(lock, &(nest_lock)->dep_map, reservation_id);	\
+} while (0)
+
+#define mutex_reserve_lock_intr_slow(lock, nest_lock, reservation_id)	\
+({									\
+	typecheck(struct lockdep_map *, &(nest_lock)->dep_map);	\
+	_mutex_reserve_lock_intr_slow(lock, &(nest_lock)->dep_map,	\
+				      reservation_id);			\
+})
+
 #else
 extern void mutex_lock(struct mutex *lock);
 extern int __must_check mutex_lock_interruptible(struct mutex *lock);
 extern int __must_check mutex_lock_killable(struct mutex *lock);
 
+extern int __must_check _mutex_reserve_lock(struct ticket_mutex *lock,
+					    unsigned long reservation_id);
+extern int __must_check _mutex_reserve_lock_interruptible(struct ticket_mutex *,
+						unsigned long reservation_id);
+
+extern void _mutex_reserve_lock_slow(struct ticket_mutex *lock,
+				     unsigned long reservation_id);
+extern int __must_check _mutex_reserve_lock_intr_slow(struct ticket_mutex *,
+						unsigned long reservation_id);
+
+#define mutex_reserve_lock(lock, nest_lock, reservation_id)		\
+	_mutex_reserve_lock(lock, reservation_id)
+
+#define mutex_reserve_lock_interruptible(lock, nest_lock, reservation_id)	\
+	_mutex_reserve_lock_interruptible(lock, reservation_id)
+
+#define mutex_reserve_lock_slow(lock, nest_lock, reservation_id)	\
+	_mutex_reserve_lock_slow(lock, reservation_id)
+
+#define mutex_reserve_lock_intr_slow(lock, nest_lock, reservation_id)	\
+	_mutex_reserve_lock_intr_slow(lock, reservation_id)
+
 # define mutex_lock_nested(lock, subclass) mutex_lock(lock)
 # define mutex_lock_interruptible_nested(lock, subclass) mutex_lock_interruptible(lock)
 # define mutex_lock_killable_nested(lock, subclass) mutex_lock_killable(lock)
@@ -167,6 +249,8 @@ extern int __must_check mutex_lock_killable(struct mutex *lock);
  */
 extern int mutex_trylock(struct mutex *lock);
 extern void mutex_unlock(struct mutex *lock);
+extern void mutex_unreserve_unlock(struct ticket_mutex *lock);
+
 extern int atomic_dec_and_mutex_lock(atomic_t *cnt, struct mutex *lock);
 
 #ifndef CONFIG_HAVE_ARCH_MUTEX_CPU_RELAX
diff --git a/kernel/mutex.c b/kernel/mutex.c
index 84a5f07..d6999a5 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -127,16 +127,116 @@ void __sched mutex_unlock(struct mutex *lock)
 
 EXPORT_SYMBOL(mutex_unlock);
 
+/**
+ * mutex_unreserve_unlock - release the mutex
+ * @lock: the mutex to be released
+ *
+ * Unlock a mutex that has been locked by this task previously
+ * with _mutex_reserve_lock*.
+ *
+ * This function must not be used in interrupt context. Unlocking
+ * of a unlocked mutex is not allowed.
+ */
+void __sched mutex_unreserve_unlock(struct ticket_mutex *lock)
+{
+	/*
+	 * The unlocking fastpath is the 0->1 transition from 'locked'
+	 * into 'unlocked' state:
+	 */
+
+	/*
+	 * mark mutex as no longer part of a reservation, next
+	 * locker can set this again
+	 */
+#ifdef CONFIG_DEBUG_MUTEXES
+	unsigned long rid;
+
+	rid = atomic_long_xchg(&lock->reservation_id, 0);
+
+	/*
+	 * If this WARN_ON triggers, you used mutex_lock to acquire,
+	 * but released with mutex_unreserve_unlock in this call.
+	 */
+	DEBUG_LOCKS_WARN_ON(!rid);
+#else
+	atomic_long_set(&lock->reservation_id, 0);
+
+	/*
+	 * When debugging is enabled we must not clear the owner before time,
+	 * the slow path will always be taken, and that clears the owner field
+	 * after verifying that it was indeed current.
+	 */
+	mutex_clear_owner(&lock->base);
+#endif
+	__mutex_fastpath_unlock(&lock->base.count, __mutex_unlock_slowpath);
+}
+EXPORT_SYMBOL(mutex_unreserve_unlock);
+
+static inline int __sched
+__mutex_lock_check_reserve(struct mutex *lock, unsigned long reservation_id)
+{
+	struct ticket_mutex *m = container_of(lock, struct ticket_mutex, base);
+	unsigned long cur_id;
+
+	cur_id = atomic_long_read(&m->reservation_id);
+	if (!cur_id)
+		return 0;
+
+	if (unlikely(reservation_id == cur_id))
+		return -EDEADLK;
+
+	if (unlikely(reservation_id - cur_id <= LONG_MAX))
+		return -EAGAIN;
+
+	return 0;
+}
+
+/*
+ * after acquiring lock with fastpath or when we lost out in contested
+ * slowpath, set reservation_id and wake up any waiters so they can recheck.
+ *
+ * This function is never called when CONFIG_DEBUG_LOCK_ALLOC is set,
+ * as the fastpath and opportunistic spinning are disabled in that case.
+ */
+static __always_inline void
+mutex_set_reservation_fastpath(struct ticket_mutex *lock,
+			       unsigned long reservation_id)
+{
+	unsigned long flags;
+	struct mutex_waiter *cur;
+
+	atomic_long_set(&lock->reservation_id, reservation_id);
+
+	/*
+	 * Check if lock is contended, if not there is nobody to wake up
+	 */
+	if (likely(atomic_read(&lock->base.count) == 0))
+		return;
+
+	/*
+	 * Uh oh, we raced in fastpath, wake up everyone in this case,
+	 * so they can see the new reservation_id
+	 */
+	spin_lock_mutex(&lock->base.wait_lock, flags);
+	list_for_each_entry(cur, &lock->base.wait_list, list) {
+		debug_mutex_wake_waiter(&lock->base, cur);
+		wake_up_process(cur->task);
+	}
+	spin_unlock_mutex(&lock->base.wait_lock, flags);
+}
+
 /*
  * Lock a mutex (possibly interruptible), slowpath:
  */
-static inline int __sched
+static __always_inline int __sched
 __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
-		    struct lockdep_map *nest_lock, unsigned long ip)
+		    struct lockdep_map *nest_lock, unsigned long ip,
+		    unsigned long reservation_id, bool res_slow)
 {
 	struct task_struct *task = current;
 	struct mutex_waiter waiter;
 	unsigned long flags;
+	int ret;
 
 	preempt_disable();
 	mutex_acquire_nest(&lock->dep_map, subclass, 0, nest_lock, ip);
@@ -163,6 +263,12 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 	for (;;) {
 		struct task_struct *owner;
 
+		if (!__builtin_constant_p(reservation_id) && !res_slow) {
+			ret = __mutex_lock_check_reserve(lock, reservation_id);
+			if (ret)
+				goto err_nowait;
+		}
+
 		/*
 		 * If there's an owner, wait for it to either
 		 * release the lock or go to sleep.
@@ -173,6 +279,13 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 
 		if (atomic_cmpxchg(&lock->count, 1, 0) == 1) {
 			lock_acquired(&lock->dep_map, ip);
+			if (res_slow) {
+				struct ticket_mutex *m;
+				m = container_of(lock, struct ticket_mutex, base);
+
+				mutex_set_reservation_fastpath(m, reservation_id);
+			}
+
 			mutex_set_owner(lock);
 			preempt_enable();
 			return 0;
@@ -228,15 +341,16 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		 * TASK_UNINTERRUPTIBLE case.)
 		 */
 		if (unlikely(signal_pending_state(state, task))) {
-			mutex_remove_waiter(lock, &waiter,
-					    task_thread_info(task));
-			mutex_release(&lock->dep_map, 1, ip);
-			spin_unlock_mutex(&lock->wait_lock, flags);
+			ret = -EINTR;
+			goto err;
+		}
 
-			debug_mutex_free_waiter(&waiter);
-			preempt_enable();
-			return -EINTR;
+		if (!__builtin_constant_p(reservation_id) && !res_slow) {
+			ret = __mutex_lock_check_reserve(lock, reservation_id);
+			if (ret)
+				goto err;
 		}
+
 		__set_task_state(task, state);
 
 		/* didn't get the lock, go to sleep: */
@@ -251,6 +365,41 @@ done:
 	mutex_remove_waiter(lock, &waiter, current_thread_info());
 	mutex_set_owner(lock);
 
+	if (!__builtin_constant_p(reservation_id)) {
+		struct ticket_mutex *m = container_of(lock,
+						      struct ticket_mutex,
+						      base);
+		struct mutex_waiter *cur;
+
+		/*
+		 * this should get optimized out for the common case,
+		 * and is only important for _mutex_reserve_lock
+		 */
+
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+		unsigned long old_id;
+		old_id = atomic_long_xchg(&m->reservation_id, reservation_id);
+
+		/*
+		 * If this WARN_ON triggers, you used mutex_lock to acquire,
+		 * but released with mutex_unreserve_unlock in this call.
+		 */
+		DEBUG_LOCKS_WARN_ON(old_id);
+#else
+		atomic_long_set(&m->reservation_id, reservation_id);
+#endif
+
+		/*
+		 * give any possible sleeping processes the chance to wake up,
+		 * so they can recheck if they have to back off from
+		 * reservations
+		 */
+		list_for_each_entry(cur, &lock->wait_list, list) {
+			debug_mutex_wake_waiter(lock, cur);
+			wake_up_process(cur->task);
+		}
+	}
+
 	/* set it to 0 if there are no waiters left: */
 	if (likely(list_empty(&lock->wait_list)))
 		atomic_set(&lock->count, 0);
@@ -261,6 +410,19 @@ done:
 	preempt_enable();
 
 	return 0;
+
+err:
+	mutex_remove_waiter(lock, &waiter, task_thread_info(task));
+	spin_unlock_mutex(&lock->wait_lock, flags);
+	debug_mutex_free_waiter(&waiter);
+
+#ifdef CONFIG_MUTEX_SPIN_ON_OWNER
+err_nowait:
+#endif
+	mutex_release(&lock->dep_map, 1, ip);
+
+	preempt_enable();
+	return ret;
 }
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
@@ -268,7 +430,8 @@ void __sched
 mutex_lock_nested(struct mutex *lock, unsigned int subclass)
 {
 	might_sleep();
-	__mutex_lock_common(lock, TASK_UNINTERRUPTIBLE, subclass, NULL, _RET_IP_);
+	__mutex_lock_common(lock, TASK_UNINTERRUPTIBLE,
+			    subclass, NULL, _RET_IP_, 0, 0);
 }
 
 EXPORT_SYMBOL_GPL(mutex_lock_nested);
@@ -277,7 +440,8 @@ void __sched
 _mutex_lock_nest_lock(struct mutex *lock, struct lockdep_map *nest)
 {
 	might_sleep();
-	__mutex_lock_common(lock, TASK_UNINTERRUPTIBLE, 0, nest, _RET_IP_);
+	__mutex_lock_common(lock, TASK_UNINTERRUPTIBLE,
+			    0, nest, _RET_IP_, 0, 0);
 }
 
 EXPORT_SYMBOL_GPL(_mutex_lock_nest_lock);
@@ -286,7 +450,8 @@ int __sched
 mutex_lock_killable_nested(struct mutex *lock, unsigned int subclass)
 {
 	might_sleep();
-	return __mutex_lock_common(lock, TASK_KILLABLE, subclass, NULL, _RET_IP_);
+	return __mutex_lock_common(lock, TASK_KILLABLE,
+				   subclass, NULL, _RET_IP_, 0, 0);
 }
 EXPORT_SYMBOL_GPL(mutex_lock_killable_nested);
 
@@ -295,10 +460,63 @@ mutex_lock_interruptible_nested(struct mutex *lock, unsigned int subclass)
 {
 	might_sleep();
 	return __mutex_lock_common(lock, TASK_INTERRUPTIBLE,
-				   subclass, NULL, _RET_IP_);
+				   subclass, NULL, _RET_IP_, 0, 0);
 }
 
 EXPORT_SYMBOL_GPL(mutex_lock_interruptible_nested);
+
+int __sched
+_mutex_reserve_lock(struct ticket_mutex *lock, struct lockdep_map *nest,
+		    unsigned long reservation_id)
+{
+	DEBUG_LOCKS_WARN_ON(!reservation_id);
+
+	might_sleep();
+	return __mutex_lock_common(&lock->base, TASK_UNINTERRUPTIBLE,
+				   0, nest, _RET_IP_, reservation_id, 0);
+}
+EXPORT_SYMBOL_GPL(_mutex_reserve_lock);
+
+
+int __sched
+_mutex_reserve_lock_interruptible(struct ticket_mutex *lock,
+				  struct lockdep_map *nest,
+				  unsigned long reservation_id)
+{
+	DEBUG_LOCKS_WARN_ON(!reservation_id);
+
+	might_sleep();
+	return __mutex_lock_common(&lock->base, TASK_INTERRUPTIBLE,
+				   0, nest, _RET_IP_, reservation_id, 0);
+}
+EXPORT_SYMBOL_GPL(_mutex_reserve_lock_interruptible);
+
+void __sched
+_mutex_reserve_lock_slow(struct ticket_mutex *lock, struct lockdep_map *nest,
+			 unsigned long reservation_id)
+{
+	DEBUG_LOCKS_WARN_ON(!reservation_id);
+
+	might_sleep();
+	__mutex_lock_common(&lock->base, TASK_UNINTERRUPTIBLE, 0,
+			    nest, _RET_IP_, reservation_id, 1);
+}
+EXPORT_SYMBOL_GPL(_mutex_reserve_lock_slow);
+
+int __sched
+_mutex_reserve_lock_intr_slow(struct ticket_mutex *lock,
+			      struct lockdep_map *nest,
+			      unsigned long reservation_id)
+{
+	DEBUG_LOCKS_WARN_ON(!reservation_id);
+
+	might_sleep();
+	return __mutex_lock_common(&lock->base, TASK_INTERRUPTIBLE, 0,
+				   nest, _RET_IP_, reservation_id, 1);
+}
+EXPORT_SYMBOL_GPL(_mutex_reserve_lock_intr_slow);
+
+
 #endif
 
 /*
@@ -401,20 +619,39 @@ __mutex_lock_slowpath(atomic_t *lock_count)
 {
 	struct mutex *lock = container_of(lock_count, struct mutex, count);
 
-	__mutex_lock_common(lock, TASK_UNINTERRUPTIBLE, 0, NULL, _RET_IP_);
+	__mutex_lock_common(lock, TASK_UNINTERRUPTIBLE, 0,
+			    NULL, _RET_IP_, 0, 0);
 }
 
 static noinline int __sched
 __mutex_lock_killable_slowpath(struct mutex *lock)
 {
-	return __mutex_lock_common(lock, TASK_KILLABLE, 0, NULL, _RET_IP_);
+	return __mutex_lock_common(lock, TASK_KILLABLE, 0,
+				   NULL, _RET_IP_, 0, 0);
 }
 
 static noinline int __sched
 __mutex_lock_interruptible_slowpath(struct mutex *lock)
 {
-	return __mutex_lock_common(lock, TASK_INTERRUPTIBLE, 0, NULL, _RET_IP_);
+	return __mutex_lock_common(lock, TASK_INTERRUPTIBLE, 0,
+				   NULL, _RET_IP_, 0, 0);
+}
+
+static noinline int __sched
+__mutex_lock_reserve_slowpath(struct ticket_mutex *lock, unsigned long rid)
+{
+	return __mutex_lock_common(&lock->base, TASK_UNINTERRUPTIBLE, 0,
+				   NULL, _RET_IP_, rid, 0);
+}
+
+static noinline int __sched
+__mutex_lock_interruptible_reserve_slowpath(struct ticket_mutex *lock,
+					    unsigned long rid)
+{
+	return __mutex_lock_common(&lock->base, TASK_INTERRUPTIBLE, 0,
+				   NULL, _RET_IP_, rid, 0);
 }
+
 #endif
 
 /*
@@ -470,6 +707,63 @@ int __sched mutex_trylock(struct mutex *lock)
 }
 EXPORT_SYMBOL(mutex_trylock);
 
+#ifndef CONFIG_DEBUG_LOCK_ALLOC
+int __sched
+_mutex_reserve_lock(struct ticket_mutex *lock, unsigned long rid)
+{
+	int ret;
+
+	might_sleep();
+
+	ret = __mutex_fastpath_lock_retval(&lock->base.count);
+
+	if (likely(!ret)) {
+		mutex_set_reservation_fastpath(lock, rid);
+		mutex_set_owner(&lock->base);
+	} else
+		ret = __mutex_lock_reserve_slowpath(lock, rid);
+	return ret;
+}
+EXPORT_SYMBOL(_mutex_reserve_lock);
+
+int __sched
+_mutex_reserve_lock_interruptible(struct ticket_mutex *lock, unsigned long rid)
+{
+	int ret;
+
+	might_sleep();
+
+	ret = __mutex_fastpath_lock_retval(&lock->base.count);
+
+	if (likely(!ret)) {
+		mutex_set_reservation_fastpath(lock, rid);
+		mutex_set_owner(&lock->base);
+	} else
+		ret = __mutex_lock_interruptible_reserve_slowpath(lock, rid);
+	return ret;
+}
+EXPORT_SYMBOL(_mutex_reserve_lock_interruptible);
+
+void __sched
+_mutex_reserve_lock_slow(struct ticket_mutex *lock, unsigned long rid)
+{
+	might_sleep();
+	__mutex_lock_common(&lock->base, TASK_UNINTERRUPTIBLE,
+			    0, NULL, _RET_IP_, rid, 1);
+}
+EXPORT_SYMBOL(_mutex_reserve_lock_slow);
+
+int __sched
+_mutex_reserve_lock_intr_slow(struct ticket_mutex *lock, unsigned long rid)
+{
+	might_sleep();
+	return __mutex_lock_common(&lock->base, TASK_INTERRUPTIBLE,
+				   0, NULL, _RET_IP_, rid, 1);
+}
+EXPORT_SYMBOL(_mutex_reserve_lock_intr_slow);
+
+#endif
+
 /**
  * atomic_dec_and_mutex_lock - return holding mutex if we dec to 0
  * @cnt: the atomic which we are to dec

