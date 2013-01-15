Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:45540 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756504Ab3AOMeZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Jan 2013 07:34:25 -0500
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
To: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Subject: [PATCH 2/7] mutex: add support for reservation style locks
Date: Tue, 15 Jan 2013 13:33:59 +0100
Message-Id: <1358253244-11453-3-git-send-email-maarten.lankhorst@canonical.com>
In-Reply-To: <1358253244-11453-1-git-send-email-maarten.lankhorst@canonical.com>
References: <1358253244-11453-1-git-send-email-maarten.lankhorst@canonical.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

makes it easier to port ttm over..

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
---
 include/linux/mutex.h |  86 +++++++++++++-
 kernel/mutex.c        | 317 +++++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 387 insertions(+), 16 deletions(-)

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
index a307cc9..8282729 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -126,16 +126,119 @@ void __sched mutex_unlock(struct mutex *lock)
 
 EXPORT_SYMBOL(mutex_unlock);
 
+/**
+ * mutex_unreserve_unlock - release the mutex
+ * @lock: the mutex to be released
+ *
+ * Unlock a mutex that has been locked by this task previously
+ * with _mutex_reserve_lock*.
+ *
+ * This function must not be used in interrupt context. Unlocking
+ * of a not locked mutex is not allowed.
+ */
+void __sched mutex_unreserve_unlock(struct ticket_mutex *lock)
+{
+	/*
+	 * mark mutex as no longer part of a reservation, next
+	 * locker can set this again
+	 */
+	atomic_long_set(&lock->reservation_id, 0);
+
+	/*
+	 * The unlocking fastpath is the 0->1 transition from 'locked'
+	 * into 'unlocked' state:
+	 */
+#ifndef CONFIG_DEBUG_MUTEXES
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
+ */
+static __always_inline void
+mutex_set_reservation_fastpath(struct ticket_mutex *lock,
+			       unsigned long reservation_id, bool check_res)
+{
+	unsigned long flags;
+	struct mutex_waiter *cur;
+
+	if (check_res || config_enabled(CONFIG_DEBUG_LOCK_ALLOC)) {
+		unsigned long cur_id;
+
+		cur_id = atomic_long_xchg(&lock->reservation_id,
+					  reservation_id);
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+		if (check_res)
+			DEBUG_LOCKS_WARN_ON(cur_id &&
+					   cur_id != reservation_id);
+		else
+			DEBUG_LOCKS_WARN_ON(cur_id);
+		lockdep_assert_held(&lock->base);
+#endif
+
+		if (unlikely(cur_id == reservation_id))
+			return;
+	} else
+		atomic_long_set(&lock->reservation_id, reservation_id);
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
 static inline int __sched
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
@@ -162,6 +265,12 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
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
@@ -172,6 +281,13 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 
 		if (atomic_cmpxchg(&lock->count, 1, 0) == 1) {
 			lock_acquired(&lock->dep_map, ip);
+			if (res_slow) {
+				struct ticket_mutex *m;
+				m = container_of(lock, struct ticket_mutex, base);
+
+				mutex_set_reservation_fastpath(m, reservation_id, false);
+			}
+
 			mutex_set_owner(lock);
 			preempt_enable();
 			return 0;
@@ -227,15 +343,16 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
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
@@ -250,6 +367,28 @@ done:
 	mutex_remove_waiter(lock, &waiter, current_thread_info());
 	mutex_set_owner(lock);
 
+	if (!__builtin_constant_p(reservation_id)) {
+		struct ticket_mutex *m;
+		struct mutex_waiter *cur;
+		/*
+		 * this should get optimized out for the common case,
+		 * and is only important for _mutex_reserve_lock
+		 */
+
+		m = container_of(lock, struct ticket_mutex, base);
+		atomic_long_set(&m->reservation_id, reservation_id);
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
@@ -260,6 +399,19 @@ done:
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
@@ -267,7 +419,8 @@ void __sched
 mutex_lock_nested(struct mutex *lock, unsigned int subclass)
 {
 	might_sleep();
-	__mutex_lock_common(lock, TASK_UNINTERRUPTIBLE, subclass, NULL, _RET_IP_);
+	__mutex_lock_common(lock, TASK_UNINTERRUPTIBLE,
+			    subclass, NULL, _RET_IP_, 0, 0);
 }
 
 EXPORT_SYMBOL_GPL(mutex_lock_nested);
@@ -276,7 +429,8 @@ void __sched
 _mutex_lock_nest_lock(struct mutex *lock, struct lockdep_map *nest)
 {
 	might_sleep();
-	__mutex_lock_common(lock, TASK_UNINTERRUPTIBLE, 0, nest, _RET_IP_);
+	__mutex_lock_common(lock, TASK_UNINTERRUPTIBLE,
+			    0, nest, _RET_IP_, 0, 0);
 }
 
 EXPORT_SYMBOL_GPL(_mutex_lock_nest_lock);
@@ -285,7 +439,8 @@ int __sched
 mutex_lock_killable_nested(struct mutex *lock, unsigned int subclass)
 {
 	might_sleep();
-	return __mutex_lock_common(lock, TASK_KILLABLE, subclass, NULL, _RET_IP_);
+	return __mutex_lock_common(lock, TASK_KILLABLE,
+				   subclass, NULL, _RET_IP_, 0, 0);
 }
 EXPORT_SYMBOL_GPL(mutex_lock_killable_nested);
 
@@ -294,10 +449,63 @@ mutex_lock_interruptible_nested(struct mutex *lock, unsigned int subclass)
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
@@ -400,7 +608,8 @@ __mutex_lock_slowpath(atomic_t *lock_count)
 {
 	struct mutex *lock = container_of(lock_count, struct mutex, count);
 
-	__mutex_lock_common(lock, TASK_UNINTERRUPTIBLE, 0, NULL, _RET_IP_);
+	__mutex_lock_common(lock, TASK_UNINTERRUPTIBLE, 0,
+			    NULL, _RET_IP_, 0, 0);
 }
 
 static noinline int __sched
@@ -408,7 +617,8 @@ __mutex_lock_killable_slowpath(atomic_t *lock_count)
 {
 	struct mutex *lock = container_of(lock_count, struct mutex, count);
 
-	return __mutex_lock_common(lock, TASK_KILLABLE, 0, NULL, _RET_IP_);
+	return __mutex_lock_common(lock, TASK_KILLABLE, 0,
+				   NULL, _RET_IP_, 0, 0);
 }
 
 static noinline int __sched
@@ -416,8 +626,28 @@ __mutex_lock_interruptible_slowpath(atomic_t *lock_count)
 {
 	struct mutex *lock = container_of(lock_count, struct mutex, count);
 
-	return __mutex_lock_common(lock, TASK_INTERRUPTIBLE, 0, NULL, _RET_IP_);
+	return __mutex_lock_common(lock, TASK_INTERRUPTIBLE, 0,
+				   NULL, _RET_IP_, 0, 0);
+}
+
+static noinline int __sched
+__mutex_lock_reserve_slowpath(atomic_t *lock_count, void *rid)
+{
+	struct mutex *lock = container_of(lock_count, struct mutex, count);
+
+	return __mutex_lock_common(lock, TASK_UNINTERRUPTIBLE, 0,
+				   NULL, _RET_IP_, (unsigned long)rid, 0);
+}
+
+static noinline int __sched
+__mutex_lock_interruptible_reserve_slowpath(atomic_t *lock_count, void *rid)
+{
+	struct mutex *lock = container_of(lock_count, struct mutex, count);
+
+	return __mutex_lock_common(lock, TASK_INTERRUPTIBLE, 0,
+				   NULL, _RET_IP_, (unsigned long)rid, 0);
 }
+
 #endif
 
 /*
@@ -473,6 +703,63 @@ int __sched mutex_trylock(struct mutex *lock)
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
+	ret = __mutex_fastpath_lock_retval_arg(&lock->base.count, (void *)rid,
+					__mutex_lock_reserve_slowpath);
+
+	if (!ret) {
+		mutex_set_reservation_fastpath(lock, rid, true);
+		mutex_set_owner(&lock->base);
+	}
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
+	ret = __mutex_fastpath_lock_retval_arg(&lock->base.count, (void *)rid,
+				__mutex_lock_interruptible_reserve_slowpath);
+
+	if (!ret) {
+		mutex_set_reservation_fastpath(lock, rid, true);
+		mutex_set_owner(&lock->base);
+	}
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
-- 
1.8.0.3

