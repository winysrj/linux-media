Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34719 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696AbcFXJJm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jun 2016 05:09:42 -0400
From: Chris Wilson <chris@chris-wilson.co.uk>
To: linux-kernel@vger.kernel.org
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
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
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org
Subject: [PATCH 2/9] async: Introduce kfence, a N:M completion mechanism
Date: Fri, 24 Jun 2016 10:08:46 +0100
Message-Id: <1466759333-4703-3-git-send-email-chris@chris-wilson.co.uk>
In-Reply-To: <1466759333-4703-1-git-send-email-chris@chris-wilson.co.uk>
References: <1466759333-4703-1-git-send-email-chris@chris-wilson.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Completions are a simple synchronization mechanism, suitable for 1:M
barriers where many waiters maybe waiting for a single event. In
situations where a single waiter needs to wait for multiple events they
could wait on a list of individual completions. If many waiters need the
same set of completion events, they each need to wait upon their own list.
The kfence abstracts this by itself being able to wait upon many events
before signaling its own completion. A kfence may wait upon completions
or other kfences, so long as there are no cycles in the dependency graph.

The kfence is a one-shot flag, signaling that work has progressed passed
a certain point and the waiters may proceed. Unlike completions, kfences
are expected to live inside more complex graphs and form the basis for
parallel execution of interdependent tasks and so are referenced counted.

kfences provide both signaling and waiting routines:

	kfence_pending()

indicates that the kfence should itself wait for another signal. A
kfence created by kfence_create() starts in the pending state.

	kfence_signal()

undoes the earlier pending notification and allows the fence to complete
if all pending events have then been signaled.

	kfence_wait()

allows the caller to sleep (uninterruptibly) until the fence is complete.

This interface is very similar to completions, with the exception of
allowing multiple pending / signals to be sent before the kfence is
complete.

	kfence_add() / kfence_add_completion()

sets the kfence to wait upon another fence, or completion respectively.

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
 include/linux/kfence.h                |  41 +++
 kernel/async.c                        | 358 +++++++++++++++++++++++++
 lib/Kconfig.debug                     |  23 ++
 lib/Makefile                          |   1 +
 lib/test-kfence.c                     | 475 ++++++++++++++++++++++++++++++++++
 tools/testing/selftests/lib/kfence.sh |  10 +
 6 files changed, 908 insertions(+)
 create mode 100644 include/linux/kfence.h
 create mode 100644 lib/test-kfence.c
 create mode 100755 tools/testing/selftests/lib/kfence.sh

diff --git a/include/linux/kfence.h b/include/linux/kfence.h
new file mode 100644
index 000000000000..82eba8aacd02
--- /dev/null
+++ b/include/linux/kfence.h
@@ -0,0 +1,41 @@
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
+extern struct kfence *kfence_create(gfp_t gfp);
+extern struct kfence *kfence_get(struct kfence *fence);
+extern int kfence_add(struct kfence *fence, struct kfence *after, gfp_t gfp);
+extern int kfence_add_completion(struct kfence *fence,
+				 struct completion *x,
+				 gfp_t gfp);
+extern void kfence_pending(struct kfence *fence);
+extern void kfence_signal(struct kfence *fence);
+extern void kfence_wait(struct kfence *fence);
+static inline bool kfence_complete(struct kfence *fence)
+{
+	return atomic_read(&fence->pending) < 0;
+}
+extern void kfence_put(struct kfence *fence);
+
+#endif /* _KFENCE_H_ */
diff --git a/kernel/async.c b/kernel/async.c
index d2edd6efec56..d0bcb7cc4884 100644
--- a/kernel/async.c
+++ b/kernel/async.c
@@ -50,6 +50,7 @@ asynchronous and synchronous parts of the kernel.
 
 #include <linux/async.h>
 #include <linux/atomic.h>
+#include <linux/kfence.h>
 #include <linux/ktime.h>
 #include <linux/export.h>
 #include <linux/wait.h>
@@ -82,6 +83,363 @@ static DECLARE_WAIT_QUEUE_HEAD(async_done);
 
 static atomic_t entry_count;
 
+/**
+ * DOC: kfence overview
+ *
+ * kfences provide synchronisation barriers between multiple processes.
+ * They are very similar to completions, or a pthread_barrier. Where
+ * kfence differs from completions is their ability to track multiple
+ * event sources rather than being a singular "completion event". Similar
+ * to completions, multiple processes or other kfences can listen or wait
+ * upon a kfence to signal its completion.
+ *
+ * The kfence is a one-shot flag, signaling that work has progressed passed
+ * a certain point (as measured by completion of all events the kfence is
+ * listening for) and the waiters upon kfence may proceed.
+ *
+ * kfences provide both signaling and waiting routines:
+ *
+ *	kfence_pending()
+ *
+ * indicates that the kfence should itself wait for another signal. A
+ * kfence created by kfence_create() starts in the pending state.
+ *
+ *	kfence_signal()
+ *
+ * undoes the earlier pending notification and allows the fence to complete
+ * if all pending events have then been signaled.
+ *
+ *	kfence_wait()
+ *
+ * allows the caller to sleep (uninterruptibly) until the fence is complete.
+ * Meanwhile,
+ *
+ * 	kfence_complete()
+ *
+ * reports whether or not the kfence has been passed.
+ *
+ * This interface is very similar to completions, with the exception of
+ * allowing multiple pending / signals to be sent before the kfence is
+ * complete.
+ *
+ *	kfence_add() / kfence_add_completion()
+ *
+ * sets the kfence to wait upon another fence, or completion respectively.
+ *
+ * Unlike completions, kfences are expected to live inside more complex graphs
+ * and form the basis for parallel execution of interdependent and so are
+ * reference counted. A kfence may be created using,
+ *
+ * 	kfence_create()
+ *
+ * The fence starts off pending a single signal. Once you have finished
+ * setting up the fence, use kfence_signal() to allow it to wait upon
+ * its event sources.
+ *
+ * Use
+ *
+ *	kfence_get() / kfence_put
+ *
+ * to acquire or release a reference on kfence respectively.
+ */
+
+#define KFENCE_CHECKED_BIT	0
+
+static void kfence_free(struct kref *kref)
+{
+	struct kfence *fence = container_of(kref, typeof(*fence), kref);
+
+	WARN_ON(atomic_read(&fence->pending) > 0);
+
+	kfree(fence);
+}
+
+/**
+ * kfence_put - release a reference to a kfence
+ * @fence: the kfence being disposed of
+ */
+void kfence_put(struct kfence *fence)
+{
+	if (fence)
+		kref_put(&fence->kref, kfence_free);
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
+	if (fence)
+		kref_get(&fence->kref);
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
+	/* To prevent unbounded recursion as we traverse the graph
+	 * of kfences, we move the task_list from this ready fence
+	 * to the tail of the current fence we are signaling.
+	 */
+	spin_lock_irqsave_nested(&x->lock, flags, 1 + !!continuation);
+	if (continuation)
+		list_splice_tail_init(&x->task_list, continuation);
+	else while (!list_empty(&x->task_list))
+		__wake_up_locked_key(x, TASK_NORMAL, &x->task_list);
+	spin_unlock_irqrestore(&x->lock, flags);
+}
+
+static void __kfence_signal(struct kfence *fence,
+			    struct list_head *continuation)
+{
+	if (!atomic_dec_and_test(&fence->pending))
+		return;
+
+	atomic_dec(&fence->pending);
+	__kfence_wake_up_all(fence, continuation);
+}
+
+/**
+ * kfence_pending - mark the fence as pending a signal
+ * @fence: the kfence to be signaled
+ *
+ */
+void kfence_pending(struct kfence *fence)
+{
+	WARN_ON(atomic_inc_return(&fence->pending) <= 1);
+}
+EXPORT_SYMBOL_GPL(kfence_pending);
+
+/**
+ * kfence_signal - signal the fence
+ * @fence: the kfence to be signaled
+ *
+ */
+void kfence_signal(struct kfence *fence)
+{
+	__kfence_signal(fence, NULL);
+}
+EXPORT_SYMBOL_GPL(kfence_signal);
+
+/**
+ * kfence_wait - wait upon a fence to be completed
+ * @fence: the kfence to wait upon
+ *
+ */
+void kfence_wait(struct kfence *fence)
+{
+	wait_event(fence->wait, kfence_complete(fence));
+}
+EXPORT_SYMBOL_GPL(kfence_wait);
+
+static void kfence_init(struct kfence *fence)
+{
+	init_waitqueue_head(&fence->wait);
+	kref_init(&fence->kref);
+	atomic_set(&fence->pending, 1);
+	fence->flags = 0;
+}
+
+/**
+ * kfence_create - create a fence
+ * @gfp: the allowed allocation type
+ *
+ * A fence is created with a reference count of one, and pending a signal.
+ * After you have completed setting up the fence for use, call kfence_signal()
+ * to signal completion.
+ *
+ * Returns the newly allocated fence, or NULL on error.
+ */
+struct kfence *kfence_create(gfp_t gfp)
+{
+	struct kfence *fence;
+
+	fence = kmalloc(sizeof(*fence), gfp);
+	if (!fence)
+		return NULL;
+
+	kfence_init(fence);
+	return fence;
+}
+EXPORT_SYMBOL_GPL(kfence_create);
+
+static int kfence_wake(wait_queue_t *wq, unsigned mode, int flags, void *key)
+{
+	list_del(&wq->task_list);
+	__kfence_signal(wq->private, key);
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
+	spin_lock_irqsave(&async_lock, flags);
+	err = __kfence_check_if_after(fence, signaler);
+	__kfence_clear_checked_bit(fence);
+	spin_unlock_irqrestore(&async_lock, flags);
+
+	return err;
+}
+
+/**
+ * kfence_add - set one fence to wait upon another
+ * @fence: this kfence
+ * @signaler: target kfence to wait upon
+ * @gfp: the allowed allocation type
+ *
+ * kfence_add() causes the @fence to wait upon completion of @signaler.
+ * Internally the @fence is marked as pending a signal from @signaler.
+ *
+ * Returns 1 if the @fence was added to the waiqueue of @signaler, 0
+ * if @signaler was already complete, or a negative error code.
+ */
+int kfence_add(struct kfence *fence, struct kfence *signaler, gfp_t gfp)
+{
+	wait_queue_t *wq;
+	unsigned long flags;
+	int pending;
+
+	if (!signaler || kfence_complete(signaler))
+		return 0;
+
+	/* The dependency graph must be acyclic */
+	if (unlikely(kfence_check_if_after(fence, signaler)))
+		return -EINVAL;
+
+	wq = kmalloc(sizeof(*wq), gfp);
+	if (unlikely(!wq)) {
+		if (!gfpflags_allow_blocking(gfp))
+			return -ENOMEM;
+
+		kfence_wait(signaler);
+		return 0;
+	}
+
+	wq->flags = 0;
+	wq->func = kfence_wake;
+	wq->private = kfence_get(fence);
+
+	kfence_pending(fence);
+
+	spin_lock_irqsave(&signaler->wait.lock, flags);
+	if (likely(!kfence_complete(signaler))) {
+		__add_wait_queue_tail(&signaler->wait, wq);
+		pending = 1;
+	} else {
+		INIT_LIST_HEAD(&wq->task_list);
+		kfence_wake(wq, 0, 0, NULL);
+		pending = 0;
+	}
+	spin_unlock_irqrestore(&signaler->wait.lock, flags);
+
+	return pending;
+}
+EXPORT_SYMBOL_GPL(kfence_add);
+
+/**
+ * kfence_add_completion - set the fence to wait upon a completion
+ * @fence: this kfence
+ * @x: target completion to wait upon
+ * @gfp: the allowed allocation type
+ *
+ * kfence_add_completiond() causes the @fence to wait upon a completion.
+ * Internally the @fence is marked as pending a signal from @x.
+ *
+ * Returns 1 if the @fence was added to the waiqueue of @x, 0
+ * if @x was already complete, or a negative error code.
+ */
+int kfence_add_completion(struct kfence *fence, struct completion *x, gfp_t gfp)
+{
+	wait_queue_t *wq;
+	unsigned long flags;
+	int pending;
+
+	if (!x || completion_done(x))
+		return 0;
+
+	wq = kmalloc(sizeof(*wq), gfp);
+	if (unlikely(!wq)) {
+		if (!gfpflags_allow_blocking(gfp))
+			return -ENOMEM;
+
+		wait_for_completion(x);
+		return 0;
+	}
+
+	wq->flags = 0;
+	wq->func = kfence_wake;
+	wq->private = kfence_get(fence);
+
+	kfence_pending(fence);
+
+	spin_lock_irqsave(&x->wait.lock, flags);
+	if (likely(!READ_ONCE(x->done))) {
+		__add_wait_queue_tail(&x->wait, wq);
+		pending = 1;
+	} else {
+		INIT_LIST_HEAD(&wq->task_list);
+		kfence_wake(wq, 0, 0, NULL);
+		pending = 0;
+	}
+	spin_unlock_irqrestore(&x->wait.lock, flags);
+
+	return pending;
+}
+EXPORT_SYMBOL_GPL(kfence_add_completion);
+
 static async_cookie_t lowest_in_progress(struct async_domain *domain)
 {
 	struct list_head *pending;
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index f7b17daf8e4d..47319f501954 100644
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
 config ASYNC_DOMAIN_SELFTEST
 	tristate "Asynchronous domain self tests"
 	depends on DEBUG_KERNEL
diff --git a/lib/Makefile b/lib/Makefile
index 23cdb9885e45..82e8b5f77c44 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -28,6 +28,7 @@ lib-y := ctype.o string.o vsprintf.o cmdline.o \
 	 earlycpio.o seq_buf.o nmi_backtrace.o nodemask.o
 
 obj-$(CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS) += usercopy.o
+obj-$(CONFIG_KFENCE_SELFTEST) += test-kfence.o
 obj-$(CONFIG_ASYNC_DOMAIN_SELFTEST) += test-async-domain.o
 lib-$(CONFIG_MMU) += ioremap.o
 lib-$(CONFIG_SMP) += cpumask.o
diff --git a/lib/test-kfence.c b/lib/test-kfence.c
new file mode 100644
index 000000000000..1d9e4a5a2184
--- /dev/null
+++ b/lib/test-kfence.c
@@ -0,0 +1,475 @@
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
+static int __init test_self(void)
+{
+	struct kfence *fence;
+
+	/* Test kfence signaling and completion testing */
+	pr_debug("%s\n", __func__);
+
+	fence = kfence_create(GFP_KERNEL);
+	if (!fence)
+		return -ENOMEM;
+
+	if (kfence_complete(fence))
+		return -EINVAL;
+
+	kfence_signal(fence);
+
+	if (!kfence_complete(fence))
+		return -EINVAL;
+
+	kfence_wait(fence);
+	if (!kfence_complete(fence))
+		return -EINVAL;
+
+	kfence_put(fence);
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
+	A = kfence_create(GFP_KERNEL);
+	if (kfence_add(A, A, GFP_KERNEL) != -EINVAL) {
+		pr_err("recursive cycle not detected (AA)\n");
+		return -EINVAL;
+	}
+
+	B = kfence_create(GFP_KERNEL);
+
+	kfence_add(A, B, GFP_KERNEL);
+	if (kfence_add(B, A, GFP_KERNEL) != -EINVAL) {
+		pr_err("single depth cycle not detected (BAB)\n");
+		return -EINVAL;
+	}
+
+	C = kfence_create(GFP_KERNEL);
+	kfence_add(B, C, GFP_KERNEL);
+	if (kfence_add(C, A, GFP_KERNEL) != -EINVAL) {
+		pr_err("cycle not detected (BA, CB, AC)\n");
+		return -EINVAL;
+	}
+
+	kfence_signal(A);
+	kfence_put(A);
+
+	kfence_signal(B);
+	kfence_put(B);
+
+	kfence_signal(C);
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
+	A = kfence_create(GFP_KERNEL);
+	B = kfence_create(GFP_KERNEL);
+	if (!A || !B)
+		return -ENOMEM;
+
+	ret = kfence_add(A, B, GFP_KERNEL);
+	if (ret < 0)
+		return ret;
+	if (ret == 0)
+		return -EINVAL;
+
+	kfence_signal(A);
+	if (kfence_complete(A))
+		return -EINVAL;
+
+	kfence_signal(B);
+	if (!kfence_complete(B))
+		return -EINVAL;
+
+	if (!kfence_complete(A))
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
+	A = kfence_create(GFP_KERNEL);
+	B = kfence_create(GFP_KERNEL);
+	C = kfence_create(GFP_KERNEL);
+	if (!A || !B || !C)
+		return -ENOMEM;
+
+	ret = kfence_add(A, B, GFP_KERNEL);
+	if (ret < 0)
+		return ret;
+	if (ret == 0)
+		return -EINVAL;
+
+	ret = kfence_add(B, C, GFP_KERNEL);
+	if (ret < 0)
+		return ret;
+	if (ret == 0)
+		return -EINVAL;
+
+	kfence_signal(A);
+	if (kfence_complete(A))
+		return -EINVAL;
+
+	kfence_signal(B);
+	if (kfence_complete(B))
+		return -EINVAL;
+
+	if (kfence_complete(A))
+		return -EINVAL;
+
+	kfence_signal(C);
+	if (!kfence_complete(C))
+		return -EINVAL;
+
+	if (!kfence_complete(B))
+		return -EINVAL;
+
+	if (!kfence_complete(A))
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
+	A = kfence_create(GFP_KERNEL);
+	B = kfence_create(GFP_KERNEL);
+	C = kfence_create(GFP_KERNEL);
+	if (!A || !B || !C)
+		return -ENOMEM;
+
+	ret = kfence_add(A, C, GFP_KERNEL);
+	if (ret < 0)
+		return ret;
+	if (ret == 0)
+		return -EINVAL;
+
+	ret = kfence_add(B, C, GFP_KERNEL);
+	if (ret < 0)
+		return ret;
+	if (ret == 0)
+		return -EINVAL;
+
+	kfence_signal(A);
+	kfence_signal(B);
+
+	if (kfence_complete(A))
+		return -EINVAL;
+
+	if (kfence_complete(B))
+		return -EINVAL;
+
+	kfence_signal(C);
+	if (!kfence_complete(C))
+		return -EINVAL;
+
+	if (!kfence_complete(B))
+		return -EINVAL;
+
+	if (!kfence_complete(A))
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
+	A = kfence_create(GFP_KERNEL);
+	B = kfence_create(GFP_KERNEL);
+	C = kfence_create(GFP_KERNEL);
+	if (!A || !B || !C)
+		return -ENOMEM;
+
+	ret = kfence_add(C, A, GFP_KERNEL);
+	if (ret < 0)
+		return ret;
+	if (ret == 0)
+		return -EINVAL;
+
+	ret = kfence_add(C, B, GFP_KERNEL);
+	if (ret < 0)
+		return ret;
+	if (ret == 0)
+		return -EINVAL;
+
+	kfence_signal(C);
+	if (kfence_complete(C))
+		return -EINVAL;
+
+	kfence_signal(A);
+	kfence_signal(B);
+
+	if (!kfence_complete(A))
+		return -EINVAL;
+
+	if (!kfence_complete(B))
+		return -EINVAL;
+
+	if (!kfence_complete(C))
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
+	fence = kfence_create(GFP_KERNEL);
+	if (!fence)
+		return -ENOMEM;
+
+	ret = kfence_add_completion(fence, &x, GFP_KERNEL);
+	if (ret < 0)
+		return ret;
+	if (ret == 0)
+		return -EINVAL;
+
+	kfence_signal(fence);
+	if (kfence_complete(fence))
+		return -EINVAL;
+
+	complete_all(&x);
+	if (!kfence_complete(fence))
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
+	kfence_signal(ipc->out);
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
+	fences = kmalloc(sizeof(*fences)*nfences, GFP_KERNEL);
+	if (!fences)
+		return -ENOMEM;
+
+	for (i = 0; i < nfences; i++) {
+		fences[i] = kfence_create(GFP_KERNEL);
+		if (!fences[i])
+			return -ENOMEM;
+
+		if (i > 0) {
+			ret = kfence_add(fences[i], fences[i-1], GFP_KERNEL);
+			if (ret < 0)
+				return ret;
+		}
+	}
+
+	for (i = nfences; --i; ) {
+		kfence_signal(fences[i]);
+		if (kfence_complete(fences[i]))
+			return -EINVAL;
+	}
+
+	kfence_signal(fences[0]);
+	for (i = 0; i < nfences; i++) {
+		if (!kfence_complete(fences[i]))
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
+	ipc.in = kfence_create(GFP_KERNEL);
+	ipc.out = kfence_create(GFP_KERNEL);
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
+	kfence_signal(ipc.in);
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

