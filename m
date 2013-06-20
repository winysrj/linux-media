Return-path: <linux-media-owner@vger.kernel.org>
Received: from adelie.canonical.com ([91.189.90.139]:34890 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965276Ab3FTLc0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Jun 2013 07:32:26 -0400
Subject: [PATCH v5 2/7] mutex: add support for wound/wait style locks, v5
To: linux-kernel@vger.kernel.org
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: linux-arch@vger.kernel.org, peterz@infradead.org, x86@kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	robclark@gmail.com, rostedt@goodmis.org, daniel@ffwll.ch,
	tglx@linutronix.de, mingo@kernel.org, linux-media@vger.kernel.org
Date: Thu, 20 Jun 2013 13:31:11 +0200
Message-ID: <20130620113111.4001.47384.stgit@patser>
In-Reply-To: <20130620112811.4001.86934.stgit@patser>
References: <20130620112811.4001.86934.stgit@patser>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

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
Changes since v2:
 - Renamed everything to ww_mutex. (mlankhorst)
 - Added ww_acquire_ctx and ww_class. (mlankhorst)
 - Added a lot of checks for wrong api usage. (mlankhorst)
 - Documentation updates. (danvet)
Changes since v3:
 - Small documentation fixes (robclark)
 - Memory barrier fix (danvet)
Changes since v4:
 - Remove ww_mutex_unlock_single and ww_mutex_lock_single.
 - Rename ww_mutex_trylock_single to ww_mutex_trylock.
 - Remove separate implementations of ww_mutex_lock_slow*, normal
   functions can be used. Inline versions still exist for extra
   debugging.
 - Cleanup unneeded memory barriers, add comment to the remaining
   smp_mb().

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Rob Clark <robdclark@gmail.com>
---
 Documentation/ww-mutex-design.txt |  343 ++++++++++++++++++++++++++++++++++++
 include/linux/mutex-debug.h       |    1 
 include/linux/mutex.h             |  355 +++++++++++++++++++++++++++++++++++++
 kernel/mutex.c                    |  318 +++++++++++++++++++++++++++++++--
 lib/debug_locks.c                 |    2 
 5 files changed, 1002 insertions(+), 17 deletions(-)
 create mode 100644 Documentation/ww-mutex-design.txt

diff --git a/Documentation/ww-mutex-design.txt b/Documentation/ww-mutex-design.txt
new file mode 100644
index 0000000..379739c
--- /dev/null
+++ b/Documentation/ww-mutex-design.txt
@@ -0,0 +1,343 @@
+Wait/Wound Deadlock-Proof Mutex Design
+======================================
+
+Please read mutex-design.txt first, as it applies to wait/wound mutexes too.
+
+Motivation for WW-Mutexes
+-------------------------
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
+makes.	Which results in the potential for deadlock.  The problem gets
+more complex when you consider that the kernel may need to migrate the
+buffer(s) into VRAM before the GPU operates on the buffer(s), which
+may in turn require evicting some other buffers (and you don't want to
+evict other buffers which are already queued up to the GPU), but for a
+simplified understanding of the problem you can ignore this.
+
+The algorithm that TTM came up with for dealing with this problem is quite
+simple.  For each group of buffers (execbuf) that need to be locked, the caller
+would be assigned a unique reservation id/ticket, from a global counter.  In
+case of deadlock while locking all the buffers associated with a execbuf, the
+one with the lowest reservation ticket (i.e. the oldest task) wins, and the one
+with the higher reservation id (i.e. the younger task) unlocks all of the
+buffers that it has already locked, and then tries again.
+
+In the RDBMS literature this deadlock handling approach is called wait/wound:
+The older tasks waits until it can acquire the contended lock. The younger tasks
+needs to back off and drop all the locks it is currently holding, i.e. the
+younger task is wounded.
+
+Concepts
+--------
+
+Compared to normal mutexes two additional concepts/objects show up in the lock
+interface for w/w mutexes:
+
+Acquire context: To ensure eventual forward progress it is important the a task
+trying to acquire locks doesn't grab a new reservation id, but keeps the one it
+acquired when starting the lock acquisition. This ticket is stored in the
+acquire context. Furthermore the acquire context keeps track of debugging state
+to catch w/w mutex interface abuse.
+
+W/w class: In contrast to normal mutexes the lock class needs to be explicit for
+w/w mutexes, since it is required to initialize the acquire context.
+
+Furthermore there are three different class of w/w lock acquire functions:
+
+* Normal lock acquisition with a context, using ww_mutex_lock.
+
+* Slowpath lock acquisition on the contending lock, used by the wounded task
+  after having dropped all already acquired locks. These functions have the
+  _slow postfix.
+
+  From a simple semantics point-of-view the _slow functions are not strictly
+  required, since simply calling the normal ww_mutex_lock functions on the
+  contending lock (after having dropped all other already acquired locks) will
+  work correctly. After all if no other ww mutex has been acquired yet there's
+  no deadlock potential and hence the ww_mutex_lock call will block and not
+  prematurely return -EDEADLK. The advantage of the _slow functions is in
+  interface safety:
+  - ww_mutex_lock has a __must_check int return type, whereas ww_mutex_lock_slow
+    has a void return type. Note that since ww mutex code needs loops/retries
+    anyway the __must_check doesn't result in spurious warnings, even though the
+    very first lock operation can never fail.
+  - When full debugging is enabled ww_mutex_lock_slow checks that all acquired
+    ww mutex have been released (preventing deadlocks) and makes sure that we
+    block on the contending lock (preventing spinning through the -EDEADLK
+    slowpath until the contended lock can be acquired).
+
+* Functions to only acquire a single w/w mutex, which results in the exact same
+  semantics as a normal mutex. This is done by calling ww_mutex_lock with a NULL
+  context.
+
+  Again this is not strictly required. But often you only want to acquire a
+  single lock in which case it's pointless to set up an acquire context (and so
+  better to avoid grabbing a deadlock avoidance ticket).
+
+Of course, all the usual variants for handling wake-ups due to signals are also
+provided.
+
+Usage
+-----
+
+Three different ways to acquire locks within the same w/w class. Common
+definitions for methods #1 and #2:
+
+static DEFINE_WW_CLASS(ww_class);
+
+struct obj {
+	struct ww_mutex lock;
+	/* obj data */
+};
+
+struct obj_entry {
+	struct list_head head;
+	struct obj *obj;
+};
+
+Method 1, using a list in execbuf->buffers that's not allowed to be reordered.
+This is useful if a list of required objects is already tracked somewhere.
+Furthermore the lock helper can use propagate the -EALREADY return code back to
+the caller as a signal that an object is twice on the list. This is useful if
+the list is constructed from userspace input and the ABI requires userspace to
+not have duplicate entries (e.g. for a gpu commandbuffer submission ioctl).
+
+int lock_objs(struct list_head *list, struct ww_acquire_ctx *ctx)
+{
+	struct obj *res_obj = NULL;
+	struct obj_entry *contended_entry = NULL;
+	struct obj_entry *entry;
+
+	ww_acquire_init(ctx, &ww_class);
+
+retry:
+	list_for_each_entry (entry, list, head) {
+		if (entry->obj == res_obj) {
+			res_obj = NULL;
+			continue;
+		}
+		ret = ww_mutex_lock(&entry->obj->lock, ctx);
+		if (ret < 0) {
+			contended_entry = entry;
+			goto err;
+		}
+	}
+
+	ww_acquire_done(ctx);
+	return 0;
+
+err:
+	list_for_each_entry_continue_reverse (entry, list, head)
+		ww_mutex_unlock(&entry->obj->lock);
+
+	if (res_obj)
+		ww_mutex_unlock(&res_obj->lock);
+
+	if (ret == -EDEADLK) {
+		/* we lost out in a seqno race, lock and retry.. */
+		ww_mutex_lock_slow(&contended_entry->obj->lock, ctx);
+		res_obj = contended_entry->obj;
+		goto retry;
+	}
+	ww_acquire_fini(ctx);
+
+	return ret;
+}
+
+Method 2, using a list in execbuf->buffers that can be reordered. Same semantics
+of duplicate entry detection using -EALREADY as method 1 above. But the
+list-reordering allows for a bit more idiomatic code.
+
+int lock_objs(struct list_head *list, struct ww_acquire_ctx *ctx)
+{
+	struct obj_entry *entry, *entry2;
+
+	ww_acquire_init(ctx, &ww_class);
+
+	list_for_each_entry (entry, list, head) {
+		ret = ww_mutex_lock(&entry->obj->lock, ctx);
+		if (ret < 0) {
+			entry2 = entry;
+
+			list_for_each_entry_continue_reverse (entry2, list, head)
+				ww_mutex_unlock(&entry2->obj->lock);
+
+			if (ret != -EDEADLK) {
+				ww_acquire_fini(ctx);
+				return ret;
+			}
+
+			/* we lost out in a seqno race, lock and retry.. */
+			ww_mutex_lock_slow(&entry->obj->lock, ctx);
+
+			/*
+			 * Move buf to head of the list, this will point
+			 * buf->next to the first unlocked entry,
+			 * restarting the for loop.
+			 */
+			list_del(&entry->head);
+			list_add(&entry->head, list);
+		}
+	}
+
+	ww_acquire_done(ctx);
+	return 0;
+}
+
+Unlocking works the same way for both methods #1 and #2:
+
+void unlock_objs(struct list_head *list, struct ww_acquire_ctx *ctx)
+{
+	struct obj_entry *entry;
+
+	list_for_each_entry (entry, list, head)
+		ww_mutex_unlock(&entry->obj->lock);
+
+	ww_acquire_fini(ctx);
+}
+
+Method 3 is useful if the list of objects is constructed ad-hoc and not upfront,
+e.g. when adjusting edges in a graph where each node has its own ww_mutex lock,
+and edges can only be changed when holding the locks of all involved nodes. w/w
+mutexes are a natural fit for such a case for two reasons:
+- They can handle lock-acquisition in any order which allows us to start walking
+  a graph from a starting point and then iteratively discovering new edges and
+  locking down the nodes those edges connect to.
+- Due to the -EALREADY return code signalling that a given objects is already
+  held there's no need for additional book-keeping to break cycles in the graph
+  or keep track off which looks are already held (when using more than one node
+  as a starting point).
+
+Note that this approach differs in two important ways from the above methods:
+- Since the list of objects is dynamically constructed (and might very well be
+  different when retrying due to hitting the -EDEADLK wound condition) there's
+  no need to keep any object on a persistent list when it's not locked. We can
+  therefore move the list_head into the object itself.
+- On the other hand the dynamic object list construction also means that the -EALREADY return
+  code can't be propagated.
+
+Note also that methods #1 and #2 and method #3 can be combined, e.g. to first lock a
+list of starting nodes (passed in from userspace) using one of the above
+methods. And then lock any additional objects affected by the operations using
+method #3 below. The backoff/retry procedure will be a bit more involved, since
+when the dynamic locking step hits -EDEADLK we also need to unlock all the
+objects acquired with the fixed list. But the w/w mutex debug checks will catch
+any interface misuse for these cases.
+
+Also, method 3 can't fail the lock acquisition step since it doesn't return
+-EALREADY. Of course this would be different when using the _interruptible
+variants, but that's outside of the scope of these examples here.
+
+struct obj {
+	struct ww_mutex ww_mutex;
+	struct list_head locked_list;
+};
+
+static DEFINE_WW_CLASS(ww_class);
+
+void __unlock_objs(struct list_head *list)
+{
+	struct obj *entry, *temp;
+
+	list_for_each_entry_safe (entry, temp, list, locked_list) {
+		/* need to do that before unlocking, since only the current lock holder is
+		allowed to use object */
+		list_del(&entry->locked_list);
+		ww_mutex_unlock(entry->ww_mutex)
+	}
+}
+
+void lock_objs(struct list_head *list, struct ww_acquire_ctx *ctx)
+{
+	struct obj *obj;
+
+	ww_acquire_init(ctx, &ww_class);
+
+retry:
+	/* re-init loop start state */
+	loop {
+		/* magic code which walks over a graph and decides which objects
+		 * to lock */
+
+		ret = ww_mutex_lock(obj->ww_mutex, ctx);
+		if (ret == -EALREADY) {
+			/* we have that one already, get to the next object */
+			continue;
+		}
+		if (ret == -EDEADLK) {
+			__unlock_objs(list);
+
+			ww_mutex_lock_slow(obj, ctx);
+			list_add(&entry->locked_list, list);
+			goto retry;
+		}
+
+		/* locked a new object, add it to the list */
+		list_add_tail(&entry->locked_list, list);
+	}
+
+	ww_acquire_done(ctx);
+	return 0;
+}
+
+void unlock_objs(struct list_head *list, struct ww_acquire_ctx *ctx)
+{
+	__unlock_objs(list);
+	ww_acquire_fini(ctx);
+}
+
+Method 4: Only lock one single objects. In that case deadlock detection and
+prevention is obviously overkill, since with grabbing just one lock you can't
+produce a deadlock within just one class. To simplify this case the w/w mutex
+api can be used with a NULL context.
+
+Implementation Details
+----------------------
+
+Design:
+  ww_mutex currently encapsulates a struct mutex, this means no extra overhead for
+  normal mutex locks, which are far more common. As such there is only a small
+  increase in code size if wait/wound mutexes are not used.
+
+  In general, not much contention is expected. The locks are typically used to
+  serialize access to resources for devices. The only way to make wakeups
+  smarter would be at the cost of adding a field to struct mutex_waiter. This
+  would add overhead to all cases where normal mutexes are used, and
+  ww_mutexes are generally less performance sensitive.
+
+Lockdep:
+  Special care has been taken to warn for as many cases of api abuse
+  as possible. Some common api abuses will be caught with
+  CONFIG_DEBUG_MUTEXES, but CONFIG_PROVE_LOCKING is recommended.
+
+  Some of the errors which will be warned about:
+   - Forgetting to call ww_acquire_fini or ww_acquire_init.
+   - Attempting to lock more mutexes after ww_acquire_done.
+   - Attempting to lock the wrong mutex after -EDEADLK and
+     unlocking all mutexes.
+   - Attempting to lock the right mutex after -EDEADLK,
+     before unlocking all mutexes.
+
+   - Calling ww_mutex_lock_slow before -EDEADLK was returned.
+
+   - Unlocking mutexes with the wrong unlock function.
+   - Calling one of the ww_acquire_* twice on the same context.
+   - Using a different ww_class for the mutex than for the ww_acquire_ctx.
+   - Normal lockdep errors that can result in deadlocks.
+
+  Some of the lockdep errors that can result in deadlocks:
+   - Calling ww_acquire_init to initialize a second ww_acquire_ctx before
+     having called ww_acquire_fini on the first.
+   - 'normal' deadlocks that can occur.
+
+FIXME: Update this section once we have the TASK_DEADLOCK task state flag magic
+implemented.
diff --git a/include/linux/mutex-debug.h b/include/linux/mutex-debug.h
index 731d77d..4ac8b19 100644
--- a/include/linux/mutex-debug.h
+++ b/include/linux/mutex-debug.h
@@ -3,6 +3,7 @@
 
 #include <linux/linkage.h>
 #include <linux/lockdep.h>
+#include <linux/debug_locks.h>
 
 /*
  * Mutexes - debugging helpers:
diff --git a/include/linux/mutex.h b/include/linux/mutex.h
index 9121595..f3ad181 100644
--- a/include/linux/mutex.h
+++ b/include/linux/mutex.h
@@ -10,6 +10,7 @@
 #ifndef __LINUX_MUTEX_H
 #define __LINUX_MUTEX_H
 
+#include <asm/current.h>
 #include <linux/list.h>
 #include <linux/spinlock_types.h>
 #include <linux/linkage.h>
@@ -74,6 +75,36 @@ struct mutex_waiter {
 #endif
 };
 
+struct ww_class {
+	atomic_long_t stamp;
+	struct lock_class_key acquire_key;
+	struct lock_class_key mutex_key;
+	const char *acquire_name;
+	const char *mutex_name;
+};
+
+struct ww_acquire_ctx {
+	struct task_struct *task;
+	unsigned long stamp;
+	unsigned acquired;
+#ifdef CONFIG_DEBUG_MUTEXES
+	unsigned done_acquire;
+	struct ww_class *ww_class;
+	struct ww_mutex *contending_lock;
+#endif
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	struct lockdep_map dep_map;
+#endif
+};
+
+struct ww_mutex {
+	struct mutex base;
+	struct ww_acquire_ctx *ctx;
+#ifdef CONFIG_DEBUG_MUTEXES
+	struct ww_class *ww_class;
+#endif
+};
+
 #ifdef CONFIG_DEBUG_MUTEXES
 # include <linux/mutex-debug.h>
 #else
@@ -98,8 +129,11 @@ static inline void mutex_destroy(struct mutex *lock) {}
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 # define __DEP_MAP_MUTEX_INITIALIZER(lockname) \
 		, .dep_map = { .name = #lockname }
+# define __WW_CLASS_MUTEX_INITIALIZER(lockname, ww_class) \
+		, .ww_class = &ww_class
 #else
 # define __DEP_MAP_MUTEX_INITIALIZER(lockname)
+# define __WW_CLASS_MUTEX_INITIALIZER(lockname, ww_class)
 #endif
 
 #define __MUTEX_INITIALIZER(lockname) \
@@ -109,13 +143,49 @@ static inline void mutex_destroy(struct mutex *lock) {}
 		__DEBUG_MUTEX_INITIALIZER(lockname) \
 		__DEP_MAP_MUTEX_INITIALIZER(lockname) }
 
+#define __WW_CLASS_INITIALIZER(ww_class) \
+		{ .stamp = ATOMIC_LONG_INIT(0) \
+		, .acquire_name = #ww_class "_acquire" \
+		, .mutex_name = #ww_class "_mutex" }
+
+#define __WW_MUTEX_INITIALIZER(lockname, class) \
+		{ .base = { \__MUTEX_INITIALIZER(lockname) } \
+		__WW_CLASS_MUTEX_INITIALIZER(lockname, class) }
+
 #define DEFINE_MUTEX(mutexname) \
 	struct mutex mutexname = __MUTEX_INITIALIZER(mutexname)
 
+#define DEFINE_WW_CLASS(classname) \
+	struct ww_class classname = __WW_CLASS_INITIALIZER(classname)
+
+#define DEFINE_WW_MUTEX(mutexname, ww_class) \
+	struct ww_mutex mutexname = __WW_MUTEX_INITIALIZER(mutexname, ww_class)
+
+
 extern void __mutex_init(struct mutex *lock, const char *name,
 			 struct lock_class_key *key);
 
 /**
+ * ww_mutex_init - initialize the w/w mutex
+ * @lock: the mutex to be initialized
+ * @ww_class: the w/w class the mutex should belong to
+ *
+ * Initialize the w/w mutex to unlocked state and associate it with the given
+ * class.
+ *
+ * It is not allowed to initialize an already locked mutex.
+ */
+static inline void ww_mutex_init(struct ww_mutex *lock,
+				 struct ww_class *ww_class)
+{
+	__mutex_init(&lock->base, ww_class->mutex_name, &ww_class->mutex_key);
+	lock->ctx = NULL;
+#ifdef CONFIG_DEBUG_MUTEXES
+	lock->ww_class = ww_class;
+#endif
+}
+
+/**
  * mutex_is_locked - is the mutex locked
  * @lock: the mutex to be queried
  *
@@ -133,6 +203,7 @@ static inline int mutex_is_locked(struct mutex *lock)
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 extern void mutex_lock_nested(struct mutex *lock, unsigned int subclass);
 extern void _mutex_lock_nest_lock(struct mutex *lock, struct lockdep_map *nest_lock);
+
 extern int __must_check mutex_lock_interruptible_nested(struct mutex *lock,
 					unsigned int subclass);
 extern int __must_check mutex_lock_killable_nested(struct mutex *lock,
@@ -144,7 +215,7 @@ extern int __must_check mutex_lock_killable_nested(struct mutex *lock,
 
 #define mutex_lock_nest_lock(lock, nest_lock)				\
 do {									\
-	typecheck(struct lockdep_map *, &(nest_lock)->dep_map);		\
+	typecheck(struct lockdep_map *, &(nest_lock)->dep_map);	\
 	_mutex_lock_nest_lock(lock, &(nest_lock)->dep_map);		\
 } while (0)
 
@@ -167,6 +238,288 @@ extern int __must_check mutex_lock_killable(struct mutex *lock);
  */
 extern int mutex_trylock(struct mutex *lock);
 extern void mutex_unlock(struct mutex *lock);
+
+/**
+ * ww_acquire_init - initialize a w/w acquire context
+ * @ctx: w/w acquire context to initialize
+ * @ww_class: w/w class of the context
+ *
+ * Initializes an context to acquire multiple mutexes of the given w/w class.
+ *
+ * Context-based w/w mutex acquiring can be done in any order whatsoever within
+ * a given lock class. Deadlocks will be detected and handled with the
+ * wait/wound logic.
+ *
+ * Mixing of context-based w/w mutex acquiring and single w/w mutex locking can
+ * result in undetected deadlocks and is so forbidden. Mixing different contexts
+ * for the same w/w class when acquiring mutexes can also result in undetected
+ * deadlocks, and is hence also forbidden. Both types of abuse will be caught by
+ * enabling CONFIG_PROVE_LOCKING.
+ *
+ * Nesting of acquire contexts for _different_ w/w classes is possible, subject
+ * to the usual locking rules between different lock classes.
+ *
+ * An acquire context must be released with ww_acquire_fini by the same task
+ * before the memory is freed. It is recommended to allocate the context itself
+ * on the stack.
+ */
+static inline void ww_acquire_init(struct ww_acquire_ctx *ctx,
+				   struct ww_class *ww_class)
+{
+	ctx->task = current;
+	ctx->stamp = atomic_long_inc_return(&ww_class->stamp);
+	ctx->acquired = 0;
+#ifdef CONFIG_DEBUG_MUTEXES
+	ctx->ww_class = ww_class;
+	ctx->done_acquire = 0;
+	ctx->contending_lock = NULL;
+#endif
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	debug_check_no_locks_freed((void *)ctx, sizeof(*ctx));
+	lockdep_init_map(&ctx->dep_map, ww_class->acquire_name,
+			 &ww_class->acquire_key, 0);
+	mutex_acquire(&ctx->dep_map, 0, 0, _RET_IP_);
+#endif
+}
+
+/**
+ * ww_acquire_done - marks the end of the acquire phase
+ * @ctx: the acquire context
+ *
+ * Marks the end of the acquire phase, any further w/w mutex lock calls using
+ * this context are forbidden.
+ *
+ * Calling this function is optional, it is just useful to document w/w mutex
+ * code and clearly designated the acquire phase from actually using the locked
+ * data structures.
+ */
+static inline void ww_acquire_done(struct ww_acquire_ctx *ctx)
+{
+#ifdef CONFIG_DEBUG_MUTEXES
+	lockdep_assert_held(ctx);
+
+	DEBUG_LOCKS_WARN_ON(ctx->done_acquire);
+	ctx->done_acquire = 1;
+#endif
+}
+
+/**
+ * ww_acquire_fini - releases a w/w acquire context
+ * @ctx: the acquire context to free
+ *
+ * Releases a w/w acquire context. This must be called _after_ all acquired w/w
+ * mutexes have been released with ww_mutex_unlock.
+ */
+static inline void ww_acquire_fini(struct ww_acquire_ctx *ctx)
+{
+#ifdef CONFIG_DEBUG_MUTEXES
+	mutex_release(&ctx->dep_map, 0, _THIS_IP_);
+
+	DEBUG_LOCKS_WARN_ON(ctx->acquired);
+	if (!config_enabled(CONFIG_PROVE_LOCKING))
+		/*
+		 * lockdep will normally handle this,
+		 * but fail without anyway
+		 */
+		ctx->done_acquire = 1;
+
+	if (!config_enabled(CONFIG_DEBUG_LOCK_ALLOC))
+		/* ensure ww_acquire_fini will still fail if called twice */
+		ctx->acquired = ~0U;
+#endif
+}
+
+extern int __must_check __ww_mutex_lock(struct ww_mutex *lock,
+					struct ww_acquire_ctx *ctx);
+extern int __must_check __ww_mutex_lock_interruptible(struct ww_mutex *lock,
+						      struct ww_acquire_ctx *ctx);
+
+/**
+ * ww_mutex_lock - acquire the w/w mutex
+ * @lock: the mutex to be acquired
+ * @ctx: w/w acquire context, or NULL to acquire only a single lock.
+ *
+ * Lock the w/w mutex exclusively for this task.
+ *
+ * Deadlocks within a given w/w class of locks are detected and handled with the
+ * wait/wound algorithm. If the lock isn't immediately avaiable this function
+ * will either sleep until it is (wait case). Or it selects the current context
+ * for backing off by returning -EDEADLK (wound case). Trying to acquire the
+ * same lock with the same context twice is also detected and signalled by
+ * returning -EALREADY. Returns 0 if the mutex was successfully acquired.
+ *
+ * In the wound case the caller must release all currently held w/w mutexes for
+ * the given context and then wait for this contending lock to be available by
+ * calling ww_mutex_lock_slow. Alternatively callers can opt to not acquire this
+ * lock and proceed with trying to acquire further w/w mutexes (e.g. when
+ * scanning through lru lists trying to free resources).
+ *
+ * The mutex must later on be released by the same task that
+ * acquired it. The task may not exit without first unlocking the mutex. Also,
+ * kernel memory where the mutex resides must not be freed with the mutex still
+ * locked. The mutex must first be initialized (or statically defined) before it
+ * can be locked. memset()-ing the mutex to 0 is not allowed. The mutex must be
+ * of the same w/w lock class as was used to initialize the acquire context.
+ *
+ * A mutex acquired with this function must be released with ww_mutex_unlock.
+ */
+static inline int ww_mutex_lock(struct ww_mutex *lock, struct ww_acquire_ctx *ctx)
+{
+	if (ctx)
+		return __ww_mutex_lock(lock, ctx);
+	else {
+		mutex_lock(&lock->base);
+		return 0;
+	}
+}
+
+/**
+ * ww_mutex_lock_interruptible - acquire the w/w mutex, interruptible
+ * @lock: the mutex to be acquired
+ * @ctx: w/w acquire context
+ *
+ * Lock the w/w mutex exclusively for this task.
+ *
+ * Deadlocks within a given w/w class of locks are detected and handled with the
+ * wait/wound algorithm. If the lock isn't immediately avaiable this function
+ * will either sleep until it is (wait case). Or it selects the current context
+ * for backing off by returning -EDEADLK (wound case). Trying to acquire the
+ * same lock with the same context twice is also detected and signalled by
+ * returning -EALREADY. Returns 0 if the mutex was successfully acquired. If a
+ * signal arrives while waiting for the lock then this function returns -EINTR.
+ *
+ * In the wound case the caller must release all currently held w/w mutexes for
+ * the given context and then wait for this contending lock to be available by
+ * calling ww_mutex_lock_slow_interruptible. Alternatively callers can opt to
+ * not acquire this lock and proceed with trying to acquire further w/w mutexes
+ * (e.g. when scanning through lru lists trying to free resources).
+ *
+ * The mutex must later on be released by the same task that
+ * acquired it. The task may not exit without first unlocking the mutex. Also,
+ * kernel memory where the mutex resides must not be freed with the mutex still
+ * locked. The mutex must first be initialized (or statically defined) before it
+ * can be locked. memset()-ing the mutex to 0 is not allowed. The mutex must be
+ * of the same w/w lock class as was used to initialize the acquire context.
+ *
+ * A mutex acquired with this function must be released with ww_mutex_unlock.
+ */
+static inline int __must_check ww_mutex_lock_interruptible(struct ww_mutex *lock,
+							   struct ww_acquire_ctx *ctx)
+{
+	if (ctx)
+		return __ww_mutex_lock_interruptible(lock, ctx);
+	else
+		return mutex_lock_interruptible(&lock->base);
+}
+
+/**
+ * ww_mutex_lock_slow - slowpath acquiring of the w/w mutex
+ * @lock: the mutex to be acquired
+ * @ctx: w/w acquire context
+ *
+ * Acquires a w/w mutex with the given context after a wound case. This function
+ * will sleep until the lock becomes available.
+ *
+ * The caller must have released all w/w mutexes already acquired with the
+ * context and then call this function on the contended lock.
+ *
+ * Afterwards the caller may continue to (re)acquire the other w/w mutexes it
+ * needs with ww_mutex_lock. Note that the -EALREADY return code from
+ * ww_mutex_lock can be used to avoid locking this contended mutex twice.
+ *
+ * It is forbidden to call this function with any other w/w mutexes associated
+ * with the context held. It is forbidden to call this on anything else than the
+ * contending mutex.
+ *
+ * Note that the slowpath lock acquiring can also be done by calling
+ * ww_mutex_lock directly. This function here is simply to help w/w mutex
+ * locking code readability by clearly denoting the slowpath.
+ */
+static inline void
+ww_mutex_lock_slow(struct ww_mutex *lock, struct ww_acquire_ctx *ctx)
+{
+	int ret;
+#ifdef CONFIG_DEBUG_MUTEXES
+	DEBUG_LOCKS_WARN_ON(!ctx->contending_lock);
+#endif
+	ret = ww_mutex_lock(lock, ctx);
+	(void)ret;
+}
+
+/**
+ * ww_mutex_lock_slow_interruptible - slowpath acquiring of the w/w mutex,
+ * 				      interruptible
+ * @lock: the mutex to be acquired
+ * @ctx: w/w acquire context
+ *
+ * Acquires a w/w mutex with the given context after a wound case. This function
+ * will sleep until the lock becomes available and returns 0 when the lock has
+ * been acquired. If a signal arrives while waiting for the lock then this
+ * function returns -EINTR.
+ *
+ * The caller must have released all w/w mutexes already acquired with the
+ * context and then call this function on the contended lock.
+ *
+ * Afterwards the caller may continue to (re)acquire the other w/w mutexes it
+ * needs with ww_mutex_lock. Note that the -EALREADY return code from
+ * ww_mutex_lock can be used to avoid locking this contended mutex twice.
+ *
+ * It is forbidden to call this function with any other w/w mutexes associated
+ * with the given context held. It is forbidden to call this on anything else
+ * than the contending mutex.
+ *
+ * Note that the slowpath lock acquiring can also be done by calling
+ * ww_mutex_lock_interruptible directly. This function here is simply to help
+ * w/w mutex locking code readability by clearly denoting the slowpath.
+ */
+static inline int __must_check
+ww_mutex_lock_slow_interruptible(struct ww_mutex *lock,
+				 struct ww_acquire_ctx *ctx)
+{
+#ifdef CONFIG_DEBUG_MUTEXES
+	DEBUG_LOCKS_WARN_ON(!ctx->contending_lock);
+#endif
+	return ww_mutex_lock_interruptible(lock, ctx);
+}
+
+extern void ww_mutex_unlock(struct ww_mutex *lock);
+
+/**
+ * ww_mutex_trylock - tries to acquire the w/w mutex without acquire context
+ * @lock: mutex to lock
+ *
+ * Trylocks a mutex without acquire context, so no deadlock detection is
+ * possible. Returns 1 if the mutex has been acquired successfully, 0 otherwise.
+ */
+static inline int __must_check ww_mutex_trylock(struct ww_mutex *lock)
+{
+	return mutex_trylock(&lock->base);
+}
+
+/***
+ * ww_mutex_destroy - mark a w/w mutex unusable
+ * @lock: the mutex to be destroyed
+ *
+ * This function marks the mutex uninitialized, and any subsequent
+ * use of the mutex is forbidden. The mutex must not be locked when
+ * this function is called.
+ */
+static inline void ww_mutex_destroy(struct ww_mutex *lock)
+{
+	mutex_destroy(&lock->base);
+}
+
+/**
+ * ww_mutex_is_locked - is the w/w mutex locked
+ * @lock: the mutex to be queried
+ *
+ * Returns 1 if the mutex is locked, 0 if unlocked.
+ */
+static inline bool ww_mutex_is_locked(struct ww_mutex *lock)
+{
+	return mutex_is_locked(&lock->base);
+}
+
 extern int atomic_dec_and_mutex_lock(atomic_t *cnt, struct mutex *lock);
 
 #ifndef CONFIG_HAVE_ARCH_MUTEX_CPU_RELAX
diff --git a/kernel/mutex.c b/kernel/mutex.c
index 84a5f07..75fc7c4 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -127,16 +127,165 @@ void __sched mutex_unlock(struct mutex *lock)
 
 EXPORT_SYMBOL(mutex_unlock);
 
+/**
+ * ww_mutex_unlock - release the w/w mutex
+ * @lock: the mutex to be released
+ *
+ * Unlock a mutex that has been locked by this task previously with any of the
+ * ww_mutex_lock* functions (with or without an acquire context). It is
+ * forbidden to release the locks after releasing the acquire context.
+ *
+ * This function must not be used in interrupt context. Unlocking
+ * of a unlocked mutex is not allowed.
+ */
+void __sched ww_mutex_unlock(struct ww_mutex *lock)
+{
+	/*
+	 * The unlocking fastpath is the 0->1 transition from 'locked'
+	 * into 'unlocked' state:
+	 */
+	if (lock->ctx) {
+#ifdef CONFIG_DEBUG_MUTEXES
+		DEBUG_LOCKS_WARN_ON(!lock->ctx->acquired);
+#endif
+		if (lock->ctx->acquired > 0)
+			lock->ctx->acquired--;
+		lock->ctx = NULL;
+	}
+
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
+EXPORT_SYMBOL(ww_mutex_unlock);
+
+static inline int __sched
+__mutex_lock_check_stamp(struct mutex *lock, struct ww_acquire_ctx *ctx)
+{
+	struct ww_mutex *ww = container_of(lock, struct ww_mutex, base);
+	struct ww_acquire_ctx *hold_ctx = ACCESS_ONCE(ww->ctx);
+
+	if (!hold_ctx)
+		return 0;
+
+	if (unlikely(ctx == hold_ctx))
+		return -EALREADY;
+
+	if (ctx->stamp - hold_ctx->stamp <= LONG_MAX &&
+	    (ctx->stamp != hold_ctx->stamp || ctx > hold_ctx)) {
+#ifdef CONFIG_DEBUG_MUTEXES
+		DEBUG_LOCKS_WARN_ON(ctx->contending_lock);
+		ctx->contending_lock = ww;
+#endif
+		return -EDEADLK;
+	}
+
+	return 0;
+}
+
+static __always_inline void ww_mutex_lock_acquired(struct ww_mutex *ww,
+						   struct ww_acquire_ctx *ww_ctx)
+{
+#ifdef CONFIG_DEBUG_MUTEXES
+	/*
+	 * If this WARN_ON triggers, you used ww_mutex_lock to acquire,
+	 * but released with a normal mutex_unlock in this call.
+	 *
+	 * This should never happen, always use ww_mutex_unlock.
+	 */
+	DEBUG_LOCKS_WARN_ON(ww->ctx);
+
+	/*
+	 * Not quite done after calling ww_acquire_done() ?
+	 */
+	DEBUG_LOCKS_WARN_ON(ww_ctx->done_acquire);
+
+	if (ww_ctx->contending_lock) {
+		/*
+		 * After -EDEADLK you tried to
+		 * acquire a different ww_mutex? Bad!
+		 */
+		DEBUG_LOCKS_WARN_ON(ww_ctx->contending_lock != ww);
+
+		/*
+		 * You called ww_mutex_lock after receiving -EDEADLK,
+		 * but 'forgot' to unlock everything else first?
+		 */
+		DEBUG_LOCKS_WARN_ON(ww_ctx->acquired > 0);
+		ww_ctx->contending_lock = NULL;
+	}
+
+	/*
+	 * Naughty, using a different class will lead to undefined behavior!
+	 */
+	DEBUG_LOCKS_WARN_ON(ww_ctx->ww_class != ww->ww_class);
+#endif
+	ww_ctx->acquired++;
+}
+
+/*
+ * after acquiring lock with fastpath or when we lost out in contested
+ * slowpath, set ctx and wake up any waiters so they can recheck.
+ *
+ * This function is never called when CONFIG_DEBUG_LOCK_ALLOC is set,
+ * as the fastpath and opportunistic spinning are disabled in that case.
+ */
+static __always_inline void
+ww_mutex_set_context_fastpath(struct ww_mutex *lock,
+			       struct ww_acquire_ctx *ctx)
+{
+	unsigned long flags;
+	struct mutex_waiter *cur;
+
+	ww_mutex_lock_acquired(lock, ctx);
+
+	lock->ctx = ctx;
+
+	/*
+	 * The lock->ctx update should be visible on all cores before
+	 * the atomic read is done, otherwise contended waiters might be
+	 * missed. The contended waiters will either see ww_ctx == NULL
+	 * and keep spinning, or it will acquire wait_lock, add itself
+	 * to waiter list and sleep.
+	 */
+	smp_mb(); /* ^^^ */
+
+	/*
+	 * Check if lock is contended, if not there is nobody to wake up
+	 */
+	if (likely(atomic_read(&lock->base.count) == 0))
+		return;
+
+	/*
+	 * Uh oh, we raced in fastpath, wake up everyone in this case,
+	 * so they can see the new lock->ctx.
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
+		    struct ww_acquire_ctx *ww_ctx)
 {
 	struct task_struct *task = current;
 	struct mutex_waiter waiter;
 	unsigned long flags;
+	int ret;
 
 	preempt_disable();
 	mutex_acquire_nest(&lock->dep_map, subclass, 0, nest_lock, ip);
@@ -163,6 +312,22 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 	for (;;) {
 		struct task_struct *owner;
 
+		if (!__builtin_constant_p(ww_ctx == NULL) && ww_ctx->acquired > 0) {
+			struct ww_mutex *ww;
+
+			ww = container_of(lock, struct ww_mutex, base);
+			/*
+			 * If ww->ctx is set the contents are undefined, only
+			 * by acquiring wait_lock there is a guarantee that
+			 * they are not invalid when reading.
+			 *
+			 * As such, when deadlock detection needs to be
+			 * performed the optimistic spinning cannot be done.
+			 */
+			if (ACCESS_ONCE(ww->ctx))
+				break;
+		}
+
 		/*
 		 * If there's an owner, wait for it to either
 		 * release the lock or go to sleep.
@@ -173,6 +338,13 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 
 		if (atomic_cmpxchg(&lock->count, 1, 0) == 1) {
 			lock_acquired(&lock->dep_map, ip);
+			if (!__builtin_constant_p(ww_ctx == NULL)) {
+				struct ww_mutex *ww;
+				ww = container_of(lock, struct ww_mutex, base);
+
+				ww_mutex_set_context_fastpath(ww, ww_ctx);
+			}
+
 			mutex_set_owner(lock);
 			preempt_enable();
 			return 0;
@@ -228,15 +400,16 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
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
+		if (!__builtin_constant_p(ww_ctx == NULL) && ww_ctx->acquired > 0) {
+			ret = __mutex_lock_check_stamp(lock, ww_ctx);
+			if (ret)
+				goto err;
 		}
+
 		__set_task_state(task, state);
 
 		/* didn't get the lock, go to sleep: */
@@ -251,6 +424,30 @@ done:
 	mutex_remove_waiter(lock, &waiter, current_thread_info());
 	mutex_set_owner(lock);
 
+	if (!__builtin_constant_p(ww_ctx == NULL)) {
+		struct ww_mutex *ww = container_of(lock,
+						      struct ww_mutex,
+						      base);
+		struct mutex_waiter *cur;
+
+		/*
+		 * This branch gets optimized out for the common case,
+		 * and is only important for ww_mutex_lock.
+		 */
+
+		ww_mutex_lock_acquired(ww, ww_ctx);
+		ww->ctx = ww_ctx;
+
+		/*
+		 * Give any possible sleeping processes the chance to wake up,
+		 * so they can recheck if they have to back off.
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
@@ -261,6 +458,14 @@ done:
 	preempt_enable();
 
 	return 0;
+
+err:
+	mutex_remove_waiter(lock, &waiter, task_thread_info(task));
+	spin_unlock_mutex(&lock->wait_lock, flags);
+	debug_mutex_free_waiter(&waiter);
+	mutex_release(&lock->dep_map, 1, ip);
+	preempt_enable();
+	return ret;
 }
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
@@ -268,7 +473,8 @@ void __sched
 mutex_lock_nested(struct mutex *lock, unsigned int subclass)
 {
 	might_sleep();
-	__mutex_lock_common(lock, TASK_UNINTERRUPTIBLE, subclass, NULL, _RET_IP_);
+	__mutex_lock_common(lock, TASK_UNINTERRUPTIBLE,
+			    subclass, NULL, _RET_IP_, NULL);
 }
 
 EXPORT_SYMBOL_GPL(mutex_lock_nested);
@@ -277,7 +483,8 @@ void __sched
 _mutex_lock_nest_lock(struct mutex *lock, struct lockdep_map *nest)
 {
 	might_sleep();
-	__mutex_lock_common(lock, TASK_UNINTERRUPTIBLE, 0, nest, _RET_IP_);
+	__mutex_lock_common(lock, TASK_UNINTERRUPTIBLE,
+			    0, nest, _RET_IP_, NULL);
 }
 
 EXPORT_SYMBOL_GPL(_mutex_lock_nest_lock);
@@ -286,7 +493,8 @@ int __sched
 mutex_lock_killable_nested(struct mutex *lock, unsigned int subclass)
 {
 	might_sleep();
-	return __mutex_lock_common(lock, TASK_KILLABLE, subclass, NULL, _RET_IP_);
+	return __mutex_lock_common(lock, TASK_KILLABLE,
+				   subclass, NULL, _RET_IP_, NULL);
 }
 EXPORT_SYMBOL_GPL(mutex_lock_killable_nested);
 
@@ -295,10 +503,30 @@ mutex_lock_interruptible_nested(struct mutex *lock, unsigned int subclass)
 {
 	might_sleep();
 	return __mutex_lock_common(lock, TASK_INTERRUPTIBLE,
-				   subclass, NULL, _RET_IP_);
+				   subclass, NULL, _RET_IP_, NULL);
 }
 
 EXPORT_SYMBOL_GPL(mutex_lock_interruptible_nested);
+
+
+int __sched
+__ww_mutex_lock(struct ww_mutex *lock, struct ww_acquire_ctx *ctx)
+{
+	might_sleep();
+	return __mutex_lock_common(&lock->base, TASK_UNINTERRUPTIBLE,
+				   0, &ctx->dep_map, _RET_IP_, ctx);
+}
+EXPORT_SYMBOL_GPL(__ww_mutex_lock);
+
+int __sched
+__ww_mutex_lock_interruptible(struct ww_mutex *lock, struct ww_acquire_ctx *ctx)
+{
+	might_sleep();
+	return __mutex_lock_common(&lock->base, TASK_INTERRUPTIBLE,
+				   0, &ctx->dep_map, _RET_IP_, ctx);
+}
+EXPORT_SYMBOL_GPL(__ww_mutex_lock_interruptible);
+
 #endif
 
 /*
@@ -401,20 +629,39 @@ __mutex_lock_slowpath(atomic_t *lock_count)
 {
 	struct mutex *lock = container_of(lock_count, struct mutex, count);
 
-	__mutex_lock_common(lock, TASK_UNINTERRUPTIBLE, 0, NULL, _RET_IP_);
+	__mutex_lock_common(lock, TASK_UNINTERRUPTIBLE, 0,
+			    NULL, _RET_IP_, NULL);
 }
 
 static noinline int __sched
 __mutex_lock_killable_slowpath(struct mutex *lock)
 {
-	return __mutex_lock_common(lock, TASK_KILLABLE, 0, NULL, _RET_IP_);
+	return __mutex_lock_common(lock, TASK_KILLABLE, 0,
+				   NULL, _RET_IP_, NULL);
 }
 
 static noinline int __sched
 __mutex_lock_interruptible_slowpath(struct mutex *lock)
 {
-	return __mutex_lock_common(lock, TASK_INTERRUPTIBLE, 0, NULL, _RET_IP_);
+	return __mutex_lock_common(lock, TASK_INTERRUPTIBLE, 0,
+				   NULL, _RET_IP_, NULL);
+}
+
+static noinline int __sched
+__ww_mutex_lock_slowpath(struct ww_mutex *lock, struct ww_acquire_ctx *ctx)
+{
+	return __mutex_lock_common(&lock->base, TASK_UNINTERRUPTIBLE, 0,
+				   NULL, _RET_IP_, ctx);
 }
+
+static noinline int __sched
+__ww_mutex_lock_interruptible_slowpath(struct ww_mutex *lock,
+					    struct ww_acquire_ctx *ctx)
+{
+	return __mutex_lock_common(&lock->base, TASK_INTERRUPTIBLE, 0,
+				   NULL, _RET_IP_, ctx);
+}
+
 #endif
 
 /*
@@ -470,6 +717,45 @@ int __sched mutex_trylock(struct mutex *lock)
 }
 EXPORT_SYMBOL(mutex_trylock);
 
+#ifndef CONFIG_DEBUG_LOCK_ALLOC
+int __sched
+__ww_mutex_lock(struct ww_mutex *lock, struct ww_acquire_ctx *ctx)
+{
+	int ret;
+
+	might_sleep();
+
+	ret = __mutex_fastpath_lock_retval(&lock->base.count);
+
+	if (likely(!ret)) {
+		ww_mutex_set_context_fastpath(lock, ctx);
+		mutex_set_owner(&lock->base);
+	} else
+		ret = __ww_mutex_lock_slowpath(lock, ctx);
+	return ret;
+}
+EXPORT_SYMBOL(__ww_mutex_lock);
+
+int __sched
+__ww_mutex_lock_interruptible(struct ww_mutex *lock, struct ww_acquire_ctx *ctx)
+{
+	int ret;
+
+	might_sleep();
+
+	ret = __mutex_fastpath_lock_retval(&lock->base.count);
+
+	if (likely(!ret)) {
+		ww_mutex_set_context_fastpath(lock, ctx);
+		mutex_set_owner(&lock->base);
+	} else
+		ret = __ww_mutex_lock_interruptible_slowpath(lock, ctx);
+	return ret;
+}
+EXPORT_SYMBOL(__ww_mutex_lock_interruptible);
+
+#endif
+
 /**
  * atomic_dec_and_mutex_lock - return holding mutex if we dec to 0
  * @cnt: the atomic which we are to dec
diff --git a/lib/debug_locks.c b/lib/debug_locks.c
index f2fa60c..96c4c63 100644
--- a/lib/debug_locks.c
+++ b/lib/debug_locks.c
@@ -30,6 +30,7 @@ EXPORT_SYMBOL_GPL(debug_locks);
  * a locking bug is detected.
  */
 int debug_locks_silent;
+EXPORT_SYMBOL_GPL(debug_locks_silent);
 
 /*
  * Generic 'turn off all lock debugging' function:
@@ -44,3 +45,4 @@ int debug_locks_off(void)
 	}
 	return 0;
 }
+EXPORT_SYMBOL_GPL(debug_locks_off);

