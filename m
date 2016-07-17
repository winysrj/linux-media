Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36811 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbcGQM66 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2016 08:58:58 -0400
From: Chris Wilson <chris@chris-wilson.co.uk>
To: linux-kernel@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org,
	Chris Wilson <chris@chris-wilson.co.uk>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Tejun Heo <tj@kernel.org>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Andrey Ryabinin <aryabinin@virtuozzo.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
	"David S. Miller" <davem@davemloft.net>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Alexander Potapenko <glider@google.com>,
	linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org
Subject: [PATCH v2 1/7] kfence: Introduce kfence, a N:M completion mechanism
Date: Sun, 17 Jul 2016 13:58:01 +0100
Message-Id: <1468760287-731-2-git-send-email-chris@chris-wilson.co.uk>
In-Reply-To: <1468760287-731-1-git-send-email-chris@chris-wilson.co.uk>
References: <1466759333-4703-1-git-send-email-chris@chris-wilson.co.uk>
 <1468760287-731-1-git-send-email-chris@chris-wilson.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Completions are a simple synchronization mechanism, suitable for 1:M
barriers where many waiters maybe waiting for a single event. However,
some event driven mechanisms require a graph of events where one event
may depend upon several earlier events. The kfence extends the struct
completion to be able to asynchronously wait upon several event sources,
including completions and other fences forming the basis on which an
acyclic dependency graph can be built. Most often this is used to create
a set of interdependent tasks that can be run concurrently but yet
serialised where necessary. For example, the kernel init sequence has
many tasks that could be run in parallel so long as their dependencies
on previous tasks have been completed. Similarly we have the problem of
assigning interdependent tasks to multiple hardware execution engines,
be they used for rendering or for display. kfences provides a building
block which can be used for determining an order in which tasks can
execute.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: linux-kernel@vger.kernel.org
Cc: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org
Cc: linaro-mm-sig@lists.linaro.org
---
 include/linux/kfence.h                |  64 ++++
 kernel/Makefile                       |   2 +-
 kernel/kfence.c                       | 431 +++++++++++++++++++++++++++
 lib/Kconfig.debug                     |  23 ++
 lib/Makefile                          |   1 +
 lib/test-kfence.c                     | 536 ++++++++++++++++++++++++++++++++++
 tools/testing/selftests/lib/kfence.sh |  10 +
 7 files changed, 1066 insertions(+), 1 deletion(-)
 create mode 100644 include/linux/kfence.h
 create mode 100644 kernel/kfence.c
 create mode 100644 lib/test-kfence.c
 create mode 100755 tools/testing/selftests/lib/kfence.sh

diff --git a/include/linux/kfence.h b/include/linux/kfence.h
new file mode 100644
index 000000000000..6e32385b3b8c
--- /dev/null
+++ b/include/linux/kfence.h
@@ -0,0 +1,64 @@
+/*
+ * kfence.h - library routines for N:M synchronisation points
+ *
+ * Copyright (C) 2016 Intel Corporation
+ *
+ * This file is released under the GPLv2.
+ *
+ */
+
+#ifndef _KFENCE_H_
+#define _KFENCE_H_
+
+#include <linux/gfp.h>
+#include <linux/kref.h>
+#include <linux/notifier.h> /* for NOTIFY_DONE */
+#include <linux/wait.h>
+
+struct completion;
+
+struct kfence {
+	wait_queue_head_t wait;
+	unsigned long flags;
+	struct kref kref;
+	atomic_t pending;
+};
+
+#define KFENCE_CHECKED_BIT	0 /* used internally for DAG checking */
+#define KFENCE_PRIVATE_BIT	1 /* available for use by owner */
+#define KFENCE_MASK		(~3)
+
+#define __kfence_call __aligned(4)
+typedef int (*kfence_notify_t)(struct kfence *);
+
+void kfence_init(struct kfence *fence, kfence_notify_t fn);
+
+struct kfence *kfence_get(struct kfence *fence);
+void kfence_put(struct kfence *fence);
+
+void kfence_await(struct kfence *fence);
+int kfence_await_kfence(struct kfence *fence,
+			struct kfence *after,
+			gfp_t gfp);
+int kfence_await_completion(struct kfence *fence,
+			    struct completion *x,
+			    gfp_t gfp);
+void kfence_complete(struct kfence *fence);
+void kfence_wake_up_all(struct kfence *fence);
+void kfence_wait(struct kfence *fence);
+
+/**
+ * kfence_done - report when the fence has been passed
+ * @fence: the kfence to query
+ *
+ * kfence_done() reports true when the fence is no longer waiting for any
+ * events and has completed its fence-complete notification.
+ *
+ * Returns true when the fence has been passed, false otherwise.
+ */
+static inline bool kfence_done(const struct kfence *fence)
+{
+	return atomic_read(&fence->pending) < 0;
+}
+
+#endif /* _KFENCE_H_ */
diff --git a/kernel/Makefile b/kernel/Makefile
index e2ec54e2b952..ff11f31b7ec9 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -9,7 +9,7 @@ obj-y     = fork.o exec_domain.o panic.o \
 	    extable.o params.o \
 	    kthread.o sys_ni.o nsproxy.o \
 	    notifier.o ksysfs.o cred.o reboot.o \
-	    async.o range.o smpboot.o
+	    async.o kfence.o range.o smpboot.o
 
 obj-$(CONFIG_MULTIUSER) += groups.o
 
diff --git a/kernel/kfence.c b/kernel/kfence.c
new file mode 100644
index 000000000000..693af9da545a
--- /dev/null
+++ b/kernel/kfence.c
@@ -0,0 +1,431 @@
+/*
+ * (C) Copyright 2016 Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+
+#include <linux/kfence.h>
+#include <linux/slab.h>
+
+/**
+ * DOC: kfence overview
+ *
+ * kfences provide synchronisation barriers between multiple tasks. They are
+ * very similar to completions, or the OpenGL fence synchronisation object.
+ * Where kfences differ from completions is their ability to track multiple
+ * event sources rather than being a singular "completion event". Similar to
+ * completions multiple processes can wait upon a kfence. However, unlike
+ * completions, a kfence can wait upon other kfences allowing for a graph
+ * of interdependent events.
+ *
+ * Each kfence is a one-shot flag, signaling that work has progressed past
+ * a certain point (as measured by completion of all events the kfence is
+ * listening for) and the waiters upon that kfence may proceed.
+ *
+ * kfences provide both signaling and waiting routines:
+ *
+ * - kfence_await(): indicates that the kfence is asynchronously waiting for
+ *   another event.
+ *
+ * - kfence_complete(): undoes the earlier await and marks the fence as done
+ *   if all of its pending events have been completed.
+ *
+ * - kfence_done(): reports whether or not the kfence has been passed.
+ *
+ * - kfence_wait(): allows the caller to sleep (uninterruptibly) until the
+ *   fence is passed.
+ *
+ * This interface is very similar to completions, with the exception of
+ * allowing the fence to await multiple events. kfences can wait upon other
+ * fences or other hardware events, building an ordered dependency graph:
+ *
+ * - kfence_await_kfence(): the kfence asynchronously waits upon completion
+ *   of another kfence
+ *
+ * - kfence_await_completion(): the kfence asynchronously waits upon a
+ *   completion
+ *
+ * A kfence is initialised using kfence_init(), and starts off awaiting an
+ * event. Once you have finished setting up the fence, including adding
+ * all of its asynchronous waits, call kfence_complete().
+ *
+ * Unlike completions, kfences are expected to live inside more complex graphs
+ * and form the basis for parallel execution of interdependent tasks and so are
+ * reference counted. Use kfence_get() and kfence_put() to acquire or release
+ * a reference to the kfence respectively.
+ *
+ * The kfence can be embedded inside a larger structure and be used as part
+ * of its event driven mechanism. As such kfence_init() can be passed a
+ * callback function that will be called first when the kfence is completed,
+ * and again when the kfence is to be freed. If no callback is provided, the
+ * kfence will be freed using kfree() when its reference count hits zero -
+ * if it is embedded inside another structure and no callback is provided,
+ * it must be the first member of its parent struct.
+ *
+ * The fence-completed notification is called before any listeners upon the
+ * fence are signaled, or any waiters woken. You can defer their wake up by
+ * returning NOTIFY_OK from the fence-completed notification and calling
+ * kfence_wake_up_all() later when ready.
+ */
+
+static DEFINE_SPINLOCK(kfence_lock);
+
+static int __kfence_notify(struct kfence *fence)
+{
+	kfence_notify_t fn;
+
+	fn = (kfence_notify_t)(fence->flags & KFENCE_MASK);
+	return fn(fence);
+}
+
+static void kfence_free(struct kref *kref)
+{
+	struct kfence *fence = container_of(kref, typeof(*fence), kref);
+
+	WARN_ON(atomic_read(&fence->pending) > 0);
+
+	if (fence->flags & KFENCE_MASK)
+		WARN_ON(__kfence_notify(fence) != NOTIFY_DONE);
+	else
+		kfree(fence);
+}
+
+/**
+ * kfence_put - release a reference to a kfence
+ * @fence: the kfence being disposed of
+ *
+ * kfence_put() decrements the reference count on the @fence, and when
+ * it hits zero the fence will be freed.
+ */
+void kfence_put(struct kfence *fence)
+{
+	kref_put(&fence->kref, kfence_free);
+}
+EXPORT_SYMBOL_GPL(kfence_put);
+
+/**
+ * kfence_get - acquire a reference to a kfence
+ * @fence: the kfence being used
+ *
+ * Returns the pointer to the kfence, with its reference count incremented.
+ */
+struct kfence *kfence_get(struct kfence *fence)
+{
+	kref_get(&fence->kref);
+	return fence;
+}
+EXPORT_SYMBOL_GPL(kfence_get);
+
+static void __kfence_wake_up_all(struct kfence *fence,
+				 struct list_head *continuation)
+{
+	wait_queue_head_t *x = &fence->wait;
+	unsigned long flags;
+
+	atomic_dec(&fence->pending);
+
+	/*
+	 * To prevent unbounded recursion as we traverse the graph of kfences,
+	 * we move the task_list from this the next ready fence to the tail of
+	 * the original fence's task_list (and so added to the list to be
+	 * woken).
+	 */
+	smp_mb__before_spinlock();
+	spin_lock_irqsave_nested(&x->lock, flags, 1 + !!continuation);
+	if (continuation) {
+		list_splice_tail_init(&x->task_list, continuation);
+	} else {
+		while (!list_empty(&x->task_list))
+			__wake_up_locked_key(x, TASK_NORMAL, &x->task_list);
+	}
+	spin_unlock_irqrestore(&x->lock, flags);
+}
+
+/**
+ * kfence_wake_up_all - wake all waiters upon a fence
+ * @fence: the kfence to signal
+ *
+ * If the fence-complete notification is deferred, when the callback is
+ * complete it should call kfence_wake_up_all() to wake up all waiters
+ * upon the fence.
+ *
+ * It is invalid to call kfence_wake_up_all() at any time other than from
+ * inside a deferred fence-complete notification.
+ */
+void kfence_wake_up_all(struct kfence *fence)
+{
+	WARN_ON(atomic_read(&fence->pending) != 0);
+	__kfence_wake_up_all(fence, NULL);
+}
+
+static void __kfence_complete(struct kfence *fence,
+			      struct list_head *continuation)
+{
+	if (!atomic_dec_and_test(&fence->pending))
+		return;
+
+	if (fence->flags & KFENCE_MASK && __kfence_notify(fence) != NOTIFY_DONE)
+		return;
+
+	__kfence_wake_up_all(fence, continuation);
+}
+
+/**
+ * kfence_await - increment the count of events being asynchronously waited upon
+ * @fence: the kfence
+ *
+ * kfence_await() indicates that the @fence is waiting upon the completion
+ * of an event. The @fence may wait upon multiple events concurrently.
+ * When that event is complete, a corresponding call to kfence_complete()
+ * should be made.
+ */
+void kfence_await(struct kfence *fence)
+{
+	WARN_ON(atomic_inc_return(&fence->pending) <= 1);
+}
+EXPORT_SYMBOL_GPL(kfence_await);
+
+/**
+ * kfence_complete - decrement the count of events waited upon
+ * @fence: the kfence
+ *
+ * When all event sources for the @fence are completed, i.e. the event count
+ * hits zero, all waiters upon the @fence are woken up.
+ */
+void kfence_complete(struct kfence *fence)
+{
+	if (WARN_ON(kfence_done(fence)))
+		return;
+
+	__kfence_complete(fence, NULL);
+}
+EXPORT_SYMBOL_GPL(kfence_complete);
+
+/**
+ * kfence_wait - wait upon a fence to be completed
+ * @fence: the kfence to wait upon
+ *
+ * Blocks (uninterruptibly waits) until the @fence event counter reaches zero
+ * and then also waits for the fence-completed notification to finish.
+ */
+void kfence_wait(struct kfence *fence)
+{
+	wait_event(fence->wait, kfence_done(fence));
+}
+EXPORT_SYMBOL_GPL(kfence_wait);
+
+/**
+ * kfence_init - initialize a fence for embedded use within a struct
+ * @fence: this kfence
+ * @fn: a callback function for when the fence is complete, and when the
+ * fence is released
+ *
+ * This function initialises the @fence for use embedded within a parent
+ * structure. The optional @fn hook is first called when the fence is completed
+ * (when all its pending event count hits 0) and again when the fence is
+ * to be freed. Note that the @fn will be called from atomic context. The @fn
+ * is stored inside the fence mixed with some flags, and so the @fn must
+ * be aligned using the __kfence_call function attribute.
+ *
+ * If the @fn is not provided, the kfence must be the first member in its
+ * parent struct as it will be freed using kfree().
+ *
+ * fence-complete notification: @fn will be called when the pending event
+ * count hits 0, however the fence is not completed unless the callback
+ * returns NOTIFY_DONE. During this notification callback fence_done() reports
+ * false. You can suspend completion of the fence by returning
+ * NOTIFY_OK instead and then later calling kfence_wake_up_all().
+ *
+ * fence-release notification: @fn will be called when the reference count
+ * hits 0, fence_done() will report true.
+ */
+void kfence_init(struct kfence *fence, kfence_notify_t fn)
+{
+	BUG_ON((unsigned long)fn & ~KFENCE_MASK);
+
+	init_waitqueue_head(&fence->wait);
+	kref_init(&fence->kref);
+	atomic_set(&fence->pending, 1);
+	fence->flags = (unsigned long)fn;
+}
+EXPORT_SYMBOL_GPL(kfence_init);
+
+static int kfence_wake(wait_queue_t *wq, unsigned mode, int flags, void *key)
+{
+	list_del(&wq->task_list);
+	__kfence_complete(wq->private, key);
+	kfence_put(wq->private);
+	kfree(wq);
+	return 0;
+}
+
+static bool __kfence_check_if_after(struct kfence *fence,
+				    const struct kfence * const signaler)
+{
+	wait_queue_t *wq;
+
+	if (__test_and_set_bit(KFENCE_CHECKED_BIT, &fence->flags))
+		return false;
+
+	if (fence == signaler)
+		return true;
+
+	list_for_each_entry(wq, &fence->wait.task_list, task_list) {
+		if (wq->func != kfence_wake)
+			continue;
+
+		if (__kfence_check_if_after(wq->private, signaler))
+			return true;
+	}
+
+	return false;
+}
+
+static void __kfence_clear_checked_bit(struct kfence *fence)
+{
+	wait_queue_t *wq;
+
+	if (!__test_and_clear_bit(KFENCE_CHECKED_BIT, &fence->flags))
+		return;
+
+	list_for_each_entry(wq, &fence->wait.task_list, task_list) {
+		if (wq->func != kfence_wake)
+			continue;
+
+		__kfence_clear_checked_bit(wq->private);
+	}
+}
+
+static bool kfence_check_if_after(struct kfence *fence,
+				  const struct kfence * const signaler)
+{
+	unsigned long flags;
+	bool err;
+
+	if (!config_enabled(CONFIG_KFENCE_CHECK_DAG))
+		return false;
+
+	spin_lock_irqsave(&kfence_lock, flags);
+	err = __kfence_check_if_after(fence, signaler);
+	__kfence_clear_checked_bit(fence);
+	spin_unlock_irqrestore(&kfence_lock, flags);
+
+	return err;
+}
+
+static wait_queue_t *__kfence_create_wq(struct kfence *fence, gfp_t gfp)
+{
+	wait_queue_t *wq;
+
+	wq = kmalloc(sizeof(*wq), gfp);
+	if (unlikely(!wq))
+		return NULL;
+
+	INIT_LIST_HEAD(&wq->task_list);
+	wq->flags = 0;
+	wq->func = kfence_wake;
+	wq->private = kfence_get(fence);
+
+	kfence_await(fence);
+
+	return wq;
+}
+
+/**
+ * kfence_await_kfence - set one fence to wait upon another
+ * @fence: this kfence
+ * @signaler: target kfence to wait upon
+ * @gfp: the allowed allocation mask
+ *
+ * kfence_await_kfence() causes the @fence to asynchronously wait upon the
+ * completion of @signaler.
+ *
+ * Returns 1 if the @fence was added to the waitqueue of @signaler, 0
+ * if @signaler was already complete, or a negative error code.
+ */
+int kfence_await_kfence(struct kfence *fence,
+			struct kfence *signaler,
+			gfp_t gfp)
+{
+	wait_queue_t *wq;
+	unsigned long flags;
+	int pending;
+
+	if (kfence_done(signaler))
+		return 0;
+
+	/* The dependency graph must be acyclic. */
+	if (unlikely(kfence_check_if_after(fence, signaler)))
+		return -EINVAL;
+
+	wq = __kfence_create_wq(fence, gfp);
+	if (unlikely(!wq)) {
+		if (!gfpflags_allow_blocking(gfp))
+			return -ENOMEM;
+
+		kfence_wait(signaler);
+		return 0;
+	}
+
+	spin_lock_irqsave(&signaler->wait.lock, flags);
+	if (likely(!kfence_done(signaler))) {
+		__add_wait_queue_tail(&signaler->wait, wq);
+		pending = 1;
+	} else {
+		kfence_wake(wq, 0, 0, NULL);
+		pending = 0;
+	}
+	spin_unlock_irqrestore(&signaler->wait.lock, flags);
+
+	return pending;
+}
+EXPORT_SYMBOL_GPL(kfence_await_kfence);
+
+/**
+ * kfence_await_completion - set the fence to wait upon a completion
+ * @fence: this kfence
+ * @x: target completion to wait upon
+ * @gfp: the allowed allocation mask
+ *
+ * kfence_await_completion() causes the @fence to asynchronously wait upon
+ * the completion.
+ *
+ * Returns 1 if the @fence was added to the waitqueue of @x, 0
+ * if @x was already complete, or a negative error code.
+ */
+int kfence_await_completion(struct kfence *fence,
+			    struct completion *x,
+			    gfp_t gfp)
+{
+	wait_queue_t *wq;
+	unsigned long flags;
+	int pending;
+
+	if (completion_done(x))
+		return 0;
+
+	wq = __kfence_create_wq(fence, gfp);
+	if (unlikely(!wq)) {
+		if (!gfpflags_allow_blocking(gfp))
+			return -ENOMEM;
+
+		wait_for_completion(x);
+		return 0;
+	}
+
+	spin_lock_irqsave(&x->wait.lock, flags);
+	if (likely(!READ_ONCE(x->done))) {
+		__add_wait_queue_tail(&x->wait, wq);
+		pending = 1;
+	} else {
+		kfence_wake(wq, 0, 0, NULL);
+		pending = 0;
+	}
+	spin_unlock_irqrestore(&x->wait.lock, flags);
+
+	return pending;
+}
+EXPORT_SYMBOL_GPL(kfence_await_completion);
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index b9cfdbfae9aa..df1182d41f06 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1763,6 +1763,29 @@ config KPROBES_SANITY_TEST
 
 	  Say N if you are unsure.
 
+config KFENCE_SELFTEST
+	tristate "Kfence self tests"
+	depends on DEBUG_KERNEL
+	default n
+	help
+	  This option provides a kernel modules that can be used to test
+	  the kfence handling. This option is not useful for distributions
+	  or general kernels, but only for kernel developers working on the
+	  kfence and async_domain facility.
+
+	  Say N if you are unsure.
+
+config KFENCE_CHECK_DAG
+	bool "Check that kfence are only used with directed acyclic graphs"
+	depends on DEBUG_KERNEL
+	default n
+	help
+	  This option enforces that kfences are only used with directed acyclic
+	  graphs (DAG), as otherwise the cycles in the graph means that they
+	  will never be signaled (or the corresponding task executed).
+
+	  Say N if you are unsure.
+
 config BACKTRACE_SELF_TEST
 	tristate "Self test for the backtrace code"
 	depends on DEBUG_KERNEL
diff --git a/lib/Makefile b/lib/Makefile
index ff6a7a6c6395..943781cfe8d1 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -28,6 +28,7 @@ lib-y := ctype.o string.o vsprintf.o cmdline.o \
 	 earlycpio.o seq_buf.o nmi_backtrace.o nodemask.o
 
 obj-$(CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS) += usercopy.o
+obj-$(CONFIG_KFENCE_SELFTEST) += test-kfence.o
 lib-$(CONFIG_MMU) += ioremap.o
 lib-$(CONFIG_SMP) += cpumask.o
 lib-$(CONFIG_HAS_DMA) += dma-noop.o
diff --git a/lib/test-kfence.c b/lib/test-kfence.c
new file mode 100644
index 000000000000..b40719fce967
--- /dev/null
+++ b/lib/test-kfence.c
@@ -0,0 +1,536 @@
+/*
+ * Test cases for kfence facility.
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/delay.h>
+#include <linux/kfence.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+
+static struct kfence *alloc_kfence(void)
+{
+	struct kfence *fence;
+
+	fence = kmalloc(sizeof(*fence), GFP_KERNEL);
+	if (!fence)
+		return NULL;
+
+	kfence_init(fence, NULL);
+	return fence;
+}
+
+static int __init __test_self(struct kfence *fence)
+{
+	if (kfence_done(fence))
+		return -EINVAL;
+
+	kfence_complete(fence);
+	if (!kfence_done(fence))
+		return -EINVAL;
+
+	kfence_wait(fence);
+	if (!kfence_done(fence))
+		return -EINVAL;
+
+	return 0;
+}
+
+static int __init test_self(void)
+{
+	struct kfence *fence;
+	int ret;
+
+	/* Test kfence signaling and completion testing */
+	pr_debug("%s\n", __func__);
+
+	fence = alloc_kfence();
+	if (!fence)
+		return -ENOMEM;
+
+	ret = __test_self(fence);
+
+	kfence_put(fence);
+	return ret;
+}
+
+struct test_stack {
+	struct kfence fence;
+	bool seen;
+};
+
+static int __init __kfence_call fence_callback(struct kfence *fence)
+{
+	container_of(fence, typeof(struct test_stack), fence)->seen = true;
+	return NOTIFY_DONE;
+}
+
+static int __init test_stack(void)
+{
+	struct test_stack ts;
+	int ret;
+
+	/* Test kfence signaling and completion testing (on stack) */
+	pr_debug("%s\n", __func__);
+
+	ts.seen = false;
+	kfence_init(&ts.fence, fence_callback);
+
+	ret = __test_self(&ts.fence);
+	if (ret < 0)
+		return ret;
+
+	if (!ts.seen) {
+		pr_err("fence callback not executed\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int __init test_dag(void)
+{
+	struct kfence *A, *B, *C;
+
+	/* Test detection of cycles within the kfence graphs */
+	pr_debug("%s\n", __func__);
+
+	if (!config_enabled(CONFIG_KFENCE_CHECK_DAG))
+		return 0;
+
+	A = alloc_kfence();
+	if (kfence_await_kfence(A, A, GFP_KERNEL) != -EINVAL) {
+		pr_err("recursive cycle not detected (AA)\n");
+		return -EINVAL;
+	}
+
+	B = alloc_kfence();
+
+	kfence_await_kfence(A, B, GFP_KERNEL);
+	if (kfence_await_kfence(B, A, GFP_KERNEL) != -EINVAL) {
+		pr_err("single depth cycle not detected (BAB)\n");
+		return -EINVAL;
+	}
+
+	C = alloc_kfence();
+	kfence_await_kfence(B, C, GFP_KERNEL);
+	if (kfence_await_kfence(C, A, GFP_KERNEL) != -EINVAL) {
+		pr_err("cycle not detected (BA, CB, AC)\n");
+		return -EINVAL;
+	}
+
+	kfence_complete(A);
+	kfence_put(A);
+
+	kfence_complete(B);
+	kfence_put(B);
+
+	kfence_complete(C);
+	kfence_put(C);
+
+	return 0;
+}
+
+static int __init test_AB(void)
+{
+	struct kfence *A, *B;
+	int ret;
+
+	/* Test kfence (A) waiting on an event source (B) */
+	pr_debug("%s\n", __func__);
+
+	A = alloc_kfence();
+	B = alloc_kfence();
+	if (!A || !B)
+		return -ENOMEM;
+
+	ret = kfence_await_kfence(A, B, GFP_KERNEL);
+	if (ret < 0)
+		return ret;
+	if (ret == 0)
+		return -EINVAL;
+
+	kfence_complete(A);
+	if (kfence_done(A))
+		return -EINVAL;
+
+	kfence_complete(B);
+	if (!kfence_done(B))
+		return -EINVAL;
+
+	if (!kfence_done(A))
+		return -EINVAL;
+
+	kfence_put(B);
+	kfence_put(A);
+	return 0;
+}
+
+static int __init test_ABC(void)
+{
+	struct kfence *A, *B, *C;
+	int ret;
+
+	/* Test a chain of fences, A waits on B who waits on C */
+	pr_debug("%s\n", __func__);
+
+	A = alloc_kfence();
+	B = alloc_kfence();
+	C = alloc_kfence();
+	if (!A || !B || !C)
+		return -ENOMEM;
+
+	ret = kfence_await_kfence(A, B, GFP_KERNEL);
+	if (ret < 0)
+		return ret;
+	if (ret == 0)
+		return -EINVAL;
+
+	ret = kfence_await_kfence(B, C, GFP_KERNEL);
+	if (ret < 0)
+		return ret;
+	if (ret == 0)
+		return -EINVAL;
+
+	kfence_complete(A);
+	if (kfence_done(A))
+		return -EINVAL;
+
+	kfence_complete(B);
+	if (kfence_done(B))
+		return -EINVAL;
+
+	if (kfence_done(A))
+		return -EINVAL;
+
+	kfence_complete(C);
+	if (!kfence_done(C))
+		return -EINVAL;
+
+	if (!kfence_done(B))
+		return -EINVAL;
+
+	if (!kfence_done(A))
+		return -EINVAL;
+
+	kfence_put(C);
+	kfence_put(B);
+	kfence_put(A);
+	return 0;
+}
+
+static int __init test_AB_C(void)
+{
+	struct kfence *A, *B, *C;
+	int ret;
+
+	/* Test multiple fences (AB) waiting on a single event (C) */
+	pr_debug("%s\n", __func__);
+
+	A = alloc_kfence();
+	B = alloc_kfence();
+	C = alloc_kfence();
+	if (!A || !B || !C)
+		return -ENOMEM;
+
+	ret = kfence_await_kfence(A, C, GFP_KERNEL);
+	if (ret < 0)
+		return ret;
+	if (ret == 0)
+		return -EINVAL;
+
+	ret = kfence_await_kfence(B, C, GFP_KERNEL);
+	if (ret < 0)
+		return ret;
+	if (ret == 0)
+		return -EINVAL;
+
+	kfence_complete(A);
+	kfence_complete(B);
+
+	if (kfence_done(A))
+		return -EINVAL;
+
+	if (kfence_done(B))
+		return -EINVAL;
+
+	kfence_complete(C);
+	if (!kfence_done(C))
+		return -EINVAL;
+
+	if (!kfence_done(B))
+		return -EINVAL;
+
+	if (!kfence_done(A))
+		return -EINVAL;
+
+	kfence_put(C);
+	kfence_put(B);
+	kfence_put(A);
+	return 0;
+}
+
+static int __init test_C_AB(void)
+{
+	struct kfence *A, *B, *C;
+	int ret;
+
+	/* Test multiple event sources (A,B) for a single fence (C) */
+	pr_debug("%s\n", __func__);
+
+	A = alloc_kfence();
+	B = alloc_kfence();
+	C = alloc_kfence();
+	if (!A || !B || !C)
+		return -ENOMEM;
+
+	ret = kfence_await_kfence(C, A, GFP_KERNEL);
+	if (ret < 0)
+		return ret;
+	if (ret == 0)
+		return -EINVAL;
+
+	ret = kfence_await_kfence(C, B, GFP_KERNEL);
+	if (ret < 0)
+		return ret;
+	if (ret == 0)
+		return -EINVAL;
+
+	kfence_complete(C);
+	if (kfence_done(C))
+		return -EINVAL;
+
+	kfence_complete(A);
+	kfence_complete(B);
+
+	if (!kfence_done(A))
+		return -EINVAL;
+
+	if (!kfence_done(B))
+		return -EINVAL;
+
+	if (!kfence_done(C))
+		return -EINVAL;
+
+	kfence_put(C);
+	kfence_put(B);
+	kfence_put(A);
+	return 0;
+}
+
+static int __init test_completion(void)
+{
+	struct kfence *fence;
+	struct completion x;
+	int ret;
+
+	/* Test use of a completion as an event source for kfences */
+	pr_debug("%s\n", __func__);
+
+	init_completion(&x);
+
+	fence = alloc_kfence();
+	if (!fence)
+		return -ENOMEM;
+
+	ret = kfence_await_completion(fence, &x, GFP_KERNEL);
+	if (ret < 0)
+		return ret;
+	if (ret == 0)
+		return -EINVAL;
+
+	kfence_complete(fence);
+	if (kfence_done(fence))
+		return -EINVAL;
+
+	complete_all(&x);
+	if (!kfence_done(fence))
+		return -EINVAL;
+
+	kfence_put(fence);
+	return 0;
+}
+
+struct task_ipc {
+	struct work_struct work;
+	struct completion started;
+	struct kfence *in, *out;
+	int value;
+};
+
+static void __init task_ipc(struct work_struct *work)
+{
+	struct task_ipc *ipc = container_of(work, typeof(*ipc), work);
+
+	complete(&ipc->started);
+
+	kfence_wait(ipc->in);
+	smp_store_mb(ipc->value, 1);
+	kfence_complete(ipc->out);
+}
+
+static int __init test_chain(void)
+{
+	const int nfences = 4096;
+	struct kfence **fences;
+	int ret, i;
+
+	/* Test a long chain of fences */
+	pr_debug("%s\n", __func__);
+
+	fences = kmalloc_array(nfences, sizeof(*fences), GFP_KERNEL);
+	if (!fences)
+		return -ENOMEM;
+
+	for (i = 0; i < nfences; i++) {
+		fences[i] = alloc_kfence();
+		if (!fences[i])
+			return -ENOMEM;
+
+		if (i > 0) {
+			ret = kfence_await_kfence(fences[i],
+						  fences[i - 1],
+						  GFP_KERNEL);
+			if (ret < 0)
+				return ret;
+		}
+	}
+
+	for (i = nfences; --i; ) {
+		kfence_complete(fences[i]);
+		if (kfence_done(fences[i]))
+			return -EINVAL;
+	}
+
+	kfence_complete(fences[0]);
+	for (i = 0; i < nfences; i++) {
+		if (!kfence_done(fences[i]))
+			return -EINVAL;
+
+		kfence_put(fences[i]);
+	}
+	kfree(fences);
+	return 0;
+}
+
+static int __init test_ipc(void)
+{
+	struct task_ipc ipc;
+	int ret = 0;
+
+	/* Test use of kfence as an interprocess signaling mechanism */
+	pr_debug("%s\n", __func__);
+
+	ipc.in = alloc_kfence();
+	ipc.out = alloc_kfence();
+	if (!ipc.in || !ipc.out)
+		return -ENOMEM;
+
+	/* use a completion to avoid chicken-and-egg testing for kfence */
+	init_completion(&ipc.started);
+
+	ipc.value = 0;
+	INIT_WORK(&ipc.work, task_ipc);
+	schedule_work(&ipc.work);
+
+	wait_for_completion(&ipc.started);
+
+	usleep_range(1000, 2000);
+	if (READ_ONCE(ipc.value)) {
+		pr_err("worker updated value before kfence was signaled\n");
+		ret = -EINVAL;
+	}
+
+	kfence_complete(ipc.in);
+	kfence_wait(ipc.out);
+
+	if (!READ_ONCE(ipc.value)) {
+		pr_err("worker signaled kfence before value was posted\n");
+		ret = -EINVAL;
+	}
+
+	flush_work(&ipc.work);
+	kfence_put(ipc.in);
+	kfence_put(ipc.out);
+	return ret;
+}
+
+static int __init test_kfence_init(void)
+{
+	int ret;
+
+	pr_info("Testing kfences\n");
+
+	ret = test_self();
+	if (ret < 0) {
+		pr_err("self failed\n");
+		return ret;
+	}
+
+	ret = test_stack();
+	if (ret < 0) {
+		pr_err("stack failed\n");
+		return ret;
+	}
+
+	ret = test_dag();
+	if (ret < 0) {
+		pr_err("DAG checker failed\n");
+		return ret;
+	}
+
+	ret = test_AB();
+	if (ret < 0) {
+		pr_err("AB failed\n");
+		return ret;
+	}
+
+	ret = test_ABC();
+	if (ret < 0) {
+		pr_err("ABC failed\n");
+		return ret;
+	}
+
+	ret = test_AB_C();
+	if (ret < 0) {
+		pr_err("AB_C failed\n");
+		return ret;
+	}
+
+	ret = test_C_AB();
+	if (ret < 0) {
+		pr_err("C_AB failed\n");
+		return ret;
+	}
+
+	ret = test_chain();
+	if (ret < 0) {
+		pr_err("chain failed\n");
+		return ret;
+	}
+
+	ret = test_ipc();
+	if (ret < 0) {
+		pr_err("ipc failed\n");
+		return ret;
+	}
+
+	ret = test_completion();
+	if (ret < 0) {
+		pr_err("completion failed\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+static void __exit test_kfence_cleanup(void)
+{
+}
+
+module_init(test_kfence_init);
+module_exit(test_kfence_cleanup);
+
+MODULE_AUTHOR("Intel Corporation");
+MODULE_LICENSE("GPL");
diff --git a/tools/testing/selftests/lib/kfence.sh b/tools/testing/selftests/lib/kfence.sh
new file mode 100755
index 000000000000..487320c70ed1
--- /dev/null
+++ b/tools/testing/selftests/lib/kfence.sh
@@ -0,0 +1,10 @@
+#!/bin/sh
+# Runs infrastructure tests using test-kfence kernel module
+
+if /sbin/modprobe -q test-kfence; then
+	/sbin/modprobe -q -r test-kfence
+	echo "kfence: ok"
+else
+	echo "kfence: [FAIL]"
+	exit 1
+fi
-- 
2.8.1

