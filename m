Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35852 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205AbcGQM7M (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2016 08:59:12 -0400
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
Subject: [PATCH v2 5/7] async: Add support for explicit fine-grained barriers
Date: Sun, 17 Jul 2016 13:58:05 +0100
Message-Id: <1468760287-731-6-git-send-email-chris@chris-wilson.co.uk>
In-Reply-To: <1468760287-731-1-git-send-email-chris@chris-wilson.co.uk>
References: <1466759333-4703-1-git-send-email-chris@chris-wilson.co.uk>
 <1468760287-731-1-git-send-email-chris@chris-wilson.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The current async-domain model supports running a multitude of
independent tasks with a coarse synchronisation point. This is
sufficient for its original purpose of allowing independent drivers to
run concurrently during various phases (booting, early resume, late
resume etc), and keep the asynchronous domain out of the synchronous
kernel domains. However, for greater exploitation, drivers themselves
want to schedule multiple tasks within a phase (or between phases) and
control the order of execution within those tasks relative to each
other. To enable this, we extend the synchronisation scheme based upon
kfences and back every task with one. Any task may now wait upon the
kfence before being scheduled, and equally the kfence may be used to
wait on the task itself (rather than waiting on the cookie for all
previous tasks to be completed).

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
 include/linux/async.h   |  60 ++++++++-
 kernel/async.c          | 234 ++++++++++++++++++++--------------
 lib/test-async-domain.c | 324 +++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 515 insertions(+), 103 deletions(-)

diff --git a/include/linux/async.h b/include/linux/async.h
index 6b0226bdaadc..e7d7289a9889 100644
--- a/include/linux/async.h
+++ b/include/linux/async.h
@@ -13,38 +13,88 @@
 #define __ASYNC_H__
 
 #include <linux/types.h>
+#include <linux/kfence.h>
 #include <linux/list.h>
 
 typedef u64 async_cookie_t;
 typedef void (*async_func_t) (void *data, async_cookie_t cookie);
+
+struct async_work {
+	struct kfence fence;
+	/* private */
+};
+
 struct async_domain {
 	struct list_head pending;
 	unsigned registered:1;
 };
 
+#define ASYNC_DOMAIN_INIT(_name, _r) {				\
+	.pending = LIST_HEAD_INIT(_name.pending),		\
+	.registered = _r						\
+}
+
 /*
  * domain participates in global async_synchronize_full
  */
 #define ASYNC_DOMAIN(_name) \
-	struct async_domain _name = { .pending = LIST_HEAD_INIT(_name.pending),	\
-				      .registered = 1 }
+	struct async_domain _name = ASYNC_DOMAIN_INIT(_name, 1)
 
 /*
  * domain is free to go out of scope as soon as all pending work is
  * complete, this domain does not participate in async_synchronize_full
  */
 #define ASYNC_DOMAIN_EXCLUSIVE(_name) \
-	struct async_domain _name = { .pending = LIST_HEAD_INIT(_name.pending), \
-				      .registered = 0 }
+	struct async_domain _name = ASYNC_DOMAIN_INIT(_name, 0)
+
+extern void init_async_domain(struct async_domain *domain, bool registered);
 
 extern async_cookie_t async_schedule(async_func_t func, void *data);
 extern async_cookie_t async_schedule_domain(async_func_t func, void *data,
 					    struct async_domain *domain);
-void async_unregister_domain(struct async_domain *domain);
+extern void async_unregister_domain(struct async_domain *domain);
 extern void async_synchronize_full(void);
 extern void async_synchronize_full_domain(struct async_domain *domain);
 extern void async_synchronize_cookie(async_cookie_t cookie);
 extern void async_synchronize_cookie_domain(async_cookie_t cookie,
 					    struct async_domain *domain);
+
 extern bool current_is_async(void);
+
+extern struct async_work *
+async_work_create(async_func_t func, void *data, gfp_t gfp);
+
+static inline struct async_work *async_work_get(struct async_work *work)
+{
+	kfence_get(&work->fence);
+	return work;
+}
+
+static inline int
+async_work_after(struct async_work *work, struct kfence *fence)
+{
+	return kfence_await_kfence(&work->fence, fence, GFP_KERNEL);
+}
+
+static inline int
+async_work_before(struct async_work *work, struct kfence *fence)
+{
+	return kfence_await_kfence(fence, &work->fence, GFP_KERNEL);
+}
+
+static inline void async_work_wait(struct async_work *work)
+{
+	kfence_wait(&work->fence);
+}
+
+static inline void async_work_put(struct async_work *work)
+{
+	kfence_put(&work->fence);
+}
+
+extern async_cookie_t queue_async_work(struct async_domain *domain,
+				       struct async_work *work,
+				       gfp_t gfp);
+extern async_cookie_t schedule_async_work(struct async_work *work);
+
 #endif
diff --git a/kernel/async.c b/kernel/async.c
index d2edd6efec56..0d695919a60d 100644
--- a/kernel/async.c
+++ b/kernel/async.c
@@ -2,6 +2,7 @@
  * async.c: Asynchronous function calls for boot performance
  *
  * (C) Copyright 2009 Intel Corporation
+ * (C) Copyright 2016 Intel Corporation
  * Author: Arjan van de Ven <arjan@linux.intel.com>
  *
  * This program is free software; you can redistribute it and/or
@@ -59,59 +60,39 @@ asynchronous and synchronous parts of the kernel.
 
 #include "workqueue_internal.h"
 
-static async_cookie_t next_cookie = 1;
-
+#define ASYNC_QUEUED_BIT	KFENCE_PRIVATE_BIT
 #define MAX_WORK		32768
-#define ASYNC_COOKIE_MAX	ULLONG_MAX	/* infinity cookie */
-
-static LIST_HEAD(async_global_pending);	/* pending from all registered doms */
-static ASYNC_DOMAIN(async_dfl_domain);
-static DEFINE_SPINLOCK(async_lock);
 
 struct async_entry {
-	struct list_head	domain_list;
-	struct list_head	global_list;
-	struct work_struct	work;
-	async_cookie_t		cookie;
-	async_func_t		func;
-	void			*data;
-	struct async_domain	*domain;
-};
-
-static DECLARE_WAIT_QUEUE_HEAD(async_done);
+	struct async_work base;
+	struct work_struct work;
 
-static atomic_t entry_count;
+	struct list_head pending_link[2];
 
-static async_cookie_t lowest_in_progress(struct async_domain *domain)
-{
-	struct list_head *pending;
-	async_cookie_t ret = ASYNC_COOKIE_MAX;
-	unsigned long flags;
+	async_cookie_t cookie;
+	async_func_t func;
+	void *data;
+};
 
-	spin_lock_irqsave(&async_lock, flags);
+static LIST_HEAD(async_global_pending);	/* pending from all registered doms */
+static ASYNC_DOMAIN(async_dfl_domain);
+static DEFINE_SPINLOCK(async_lock);
+static unsigned int async_pending_count;
 
-	if (domain)
-		pending = &domain->pending;
-	else
-		pending = &async_global_pending;
+static async_cookie_t assign_cookie(void)
+{
+	static async_cookie_t next_cookie;
 
-	if (!list_empty(pending))
-		ret = list_first_entry(pending, struct async_entry,
-				       domain_list)->cookie;
+	if (++next_cookie == 0)
+		next_cookie = 1;
 
-	spin_unlock_irqrestore(&async_lock, flags);
-	return ret;
+	return next_cookie;
 }
 
-/*
- * pick the first pending entry and run it
- */
 static void async_run_entry_fn(struct work_struct *work)
 {
-	struct async_entry *entry =
-		container_of(work, struct async_entry, work);
-	unsigned long flags;
-	ktime_t uninitialized_var(calltime), delta, rettime;
+	struct async_entry *entry = container_of(work, typeof(*entry), work);
+	ktime_t uninitialized_var(calltime);
 
 	/* 1) run (and print duration) */
 	if (initcall_debug && system_state == SYSTEM_BOOTING) {
@@ -122,8 +103,7 @@ static void async_run_entry_fn(struct work_struct *work)
 	}
 	entry->func(entry->data, entry->cookie);
 	if (initcall_debug && system_state == SYSTEM_BOOTING) {
-		rettime = ktime_get();
-		delta = ktime_sub(rettime, calltime);
+		ktime_t delta = ktime_sub(ktime_get(), calltime);
 		pr_debug("initcall %lli_%pF returned 0 after %lld usecs\n",
 			(long long)entry->cookie,
 			entry->func,
@@ -131,69 +111,81 @@ static void async_run_entry_fn(struct work_struct *work)
 	}
 
 	/* 2) remove self from the pending queues */
-	spin_lock_irqsave(&async_lock, flags);
-	list_del_init(&entry->domain_list);
-	list_del_init(&entry->global_list);
+	spin_lock_irq(&async_lock);
+	list_del(&entry->pending_link[0]);
+	list_del(&entry->pending_link[1]);
+	async_pending_count--;
+	spin_unlock_irq(&async_lock);
 
-	/* 3) free the entry */
-	kfree(entry);
-	atomic_dec(&entry_count);
+	/* 3) wake up any waiters */
+	kfence_wake_up_all(&entry->base.fence);
+	kfence_put(&entry->base.fence);
+}
 
-	spin_unlock_irqrestore(&async_lock, flags);
+__kfence_call static int async_work_notify(struct kfence *fence)
+{
+	struct async_entry *entry =
+		container_of(fence, typeof(*entry), base.fence);
+
+	if (kfence_done(fence)) {
+		kfree(entry);
+		return NOTIFY_DONE;
+	}
 
-	/* 4) wake up any waiters */
-	wake_up(&async_done);
+	queue_work(system_unbound_wq, &entry->work);
+	return NOTIFY_OK;
 }
 
-static async_cookie_t __async_schedule(async_func_t func, void *data, struct async_domain *domain)
+struct async_work *async_work_create(async_func_t func, void *data, gfp_t gfp)
 {
 	struct async_entry *entry;
-	unsigned long flags;
-	async_cookie_t newcookie;
 
-	/* allow irq-off callers */
-	entry = kzalloc(sizeof(struct async_entry), GFP_ATOMIC);
+	entry = kmalloc(sizeof(*entry), gfp);
+	if (!entry)
+		return NULL;
 
-	/*
-	 * If we're out of memory or if there's too much work
-	 * pending already, we execute synchronously.
-	 */
-	if (!entry || atomic_read(&entry_count) > MAX_WORK) {
-		kfree(entry);
-		spin_lock_irqsave(&async_lock, flags);
-		newcookie = next_cookie++;
-		spin_unlock_irqrestore(&async_lock, flags);
+	kfence_init(&entry->base.fence, async_work_notify);
 
-		/* low on memory.. run synchronously */
-		func(data, newcookie);
-		return newcookie;
-	}
-	INIT_LIST_HEAD(&entry->domain_list);
-	INIT_LIST_HEAD(&entry->global_list);
 	INIT_WORK(&entry->work, async_run_entry_fn);
 	entry->func = func;
 	entry->data = data;
-	entry->domain = domain;
 
-	spin_lock_irqsave(&async_lock, flags);
+	return &entry->base;
+}
+EXPORT_SYMBOL_GPL(async_work_create);
 
-	/* allocate cookie and queue */
-	newcookie = entry->cookie = next_cookie++;
+async_cookie_t queue_async_work(struct async_domain *domain,
+				struct async_work *work,
+				gfp_t gfp)
+{
+	struct async_entry *entry = container_of(work, typeof(*entry), base);
+	unsigned long flags;
 
-	list_add_tail(&entry->domain_list, &domain->pending);
-	if (domain->registered)
-		list_add_tail(&entry->global_list, &async_global_pending);
+	if (WARN_ON(test_and_set_bit(ASYNC_QUEUED_BIT,
+				     &entry->base.fence.flags)))
+		return 0;
 
-	atomic_inc(&entry_count);
+	spin_lock_irqsave(&async_lock, flags);
+	entry->cookie = assign_cookie();
+	list_add_tail(&entry->pending_link[0], &domain->pending);
+	INIT_LIST_HEAD(&entry->pending_link[1]);
+	if (domain->registered)
+		list_add_tail(&entry->pending_link[1], &async_global_pending);
+	async_pending_count++;
 	spin_unlock_irqrestore(&async_lock, flags);
 
 	/* mark that this task has queued an async job, used by module init */
 	current->flags |= PF_USED_ASYNC;
 
-	/* schedule for execution */
-	queue_work(system_unbound_wq, &entry->work);
+	kfence_complete(kfence_get(&entry->base.fence));
+
+	return entry->cookie;
+}
+EXPORT_SYMBOL_GPL(queue_async_work);
 
-	return newcookie;
+async_cookie_t schedule_async_work(struct async_work *work)
+{
+	return queue_async_work(&async_dfl_domain, work, GFP_KERNEL);
 }
 
 /**
@@ -206,7 +198,7 @@ static async_cookie_t __async_schedule(async_func_t func, void *data, struct asy
  */
 async_cookie_t async_schedule(async_func_t func, void *data)
 {
-	return __async_schedule(func, data, &async_dfl_domain);
+	return async_schedule_domain(func, data, &async_dfl_domain);
 }
 EXPORT_SYMBOL_GPL(async_schedule);
 
@@ -225,7 +217,27 @@ EXPORT_SYMBOL_GPL(async_schedule);
 async_cookie_t async_schedule_domain(async_func_t func, void *data,
 				     struct async_domain *domain)
 {
-	return __async_schedule(func, data, domain);
+	struct async_work *work;
+	async_cookie_t cookie = 0;
+
+	work = NULL;
+	if (READ_ONCE(async_pending_count) < MAX_WORK)
+		work = async_work_create(func, data, GFP_ATOMIC);
+	if (work) {
+		cookie = queue_async_work(domain, work, GFP_ATOMIC);
+		async_work_put(work);
+	}
+	if (!cookie) {
+		unsigned long flags;
+
+		spin_lock_irqsave(&async_lock, flags);
+		cookie = assign_cookie();
+		spin_unlock_irqrestore(&async_lock, flags);
+
+		func(data, cookie);
+	}
+
+	return cookie;
 }
 EXPORT_SYMBOL_GPL(async_schedule_domain);
 
@@ -251,10 +263,8 @@ EXPORT_SYMBOL_GPL(async_synchronize_full);
  */
 void async_unregister_domain(struct async_domain *domain)
 {
-	spin_lock_irq(&async_lock);
-	WARN_ON(!domain->registered || !list_empty(&domain->pending));
+	WARN_ON(!list_empty(&domain->pending));
 	domain->registered = 0;
-	spin_unlock_irq(&async_lock);
 }
 EXPORT_SYMBOL_GPL(async_unregister_domain);
 
@@ -267,7 +277,7 @@ EXPORT_SYMBOL_GPL(async_unregister_domain);
  */
 void async_synchronize_full_domain(struct async_domain *domain)
 {
-	async_synchronize_cookie_domain(ASYNC_COOKIE_MAX, domain);
+	async_synchronize_cookie_domain(0, domain);
 }
 EXPORT_SYMBOL_GPL(async_synchronize_full_domain);
 
@@ -282,19 +292,49 @@ EXPORT_SYMBOL_GPL(async_synchronize_full_domain);
  */
 void async_synchronize_cookie_domain(async_cookie_t cookie, struct async_domain *domain)
 {
-	ktime_t uninitialized_var(starttime), delta, endtime;
+	ktime_t uninitialized_var(starttime);
+	struct list_head *pending;
+
+	pending = domain ? &domain->pending : &async_global_pending;
 
 	if (initcall_debug && system_state == SYSTEM_BOOTING) {
 		pr_debug("async_waiting @ %i\n", task_pid_nr(current));
 		starttime = ktime_get();
 	}
 
-	wait_event(async_done, lowest_in_progress(domain) >= cookie);
+	do {
+		struct kfence *fence = NULL;
+		unsigned long flags;
 
-	if (initcall_debug && system_state == SYSTEM_BOOTING) {
-		endtime = ktime_get();
-		delta = ktime_sub(endtime, starttime);
+		spin_lock_irqsave(&async_lock, flags);
+		if (!list_empty(pending)) {
+			struct async_entry *entry;
+
+			if (cookie) {
+				entry = list_first_entry(pending,
+							 struct async_entry,
+							 pending_link[!domain]);
+				if ((s64)(cookie - entry->cookie) > 0)
+					fence = kfence_get(&entry->base.fence);
+			} else {
+				entry = list_last_entry(pending,
+							struct async_entry,
+							pending_link[!domain]);
+				cookie = entry->cookie;
+				fence = kfence_get(&entry->base.fence);
+			}
+		}
+		spin_unlock_irqrestore(&async_lock, flags);
+
+		if (!fence)
+			break;
+
+		kfence_wait(fence);
+		kfence_put(fence);
+	} while (1);
 
+	if (initcall_debug && system_state == SYSTEM_BOOTING) {
+		ktime_t delta = ktime_sub(ktime_get(), starttime);
 		pr_debug("async_continuing @ %i after %lli usec\n",
 			task_pid_nr(current),
 			(long long)ktime_to_ns(delta) >> 10);
@@ -327,3 +367,11 @@ bool current_is_async(void)
 	return worker && worker->current_func == async_run_entry_fn;
 }
 EXPORT_SYMBOL_GPL(current_is_async);
+
+void init_async_domain(struct async_domain *domain, bool registered)
+{
+	memset(domain, 0, sizeof(*domain));
+	INIT_LIST_HEAD(&domain->pending);
+	domain->registered = registered;
+}
+EXPORT_SYMBOL_GPL(init_async_domain);
diff --git a/lib/test-async-domain.c b/lib/test-async-domain.c
index 558a71414fb6..ecbeba9cd65b 100644
--- a/lib/test-async-domain.c
+++ b/lib/test-async-domain.c
@@ -7,6 +7,19 @@
 #include <linux/async.h>
 #include <linux/module.h>
 #include <linux/delay.h>
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
 
 static void task_A(void *data, async_cookie_t cookie)
 {
@@ -21,6 +34,269 @@ static void task_B(void *data, async_cookie_t cookie)
 	smp_store_mb(*result, 'B');
 }
 
+static int __init test_x(const char *name,
+			 struct async_domain *domain,
+			 async_func_t func,
+			 const long expected)
+{
+	struct async_work *A;
+	long result = 0;
+
+	A = async_work_create(func, &result, GFP_KERNEL);
+	if (!A)
+		return -ENOMEM;
+
+	queue_async_work(domain, A, GFP_KERNEL);
+	async_work_wait(A);
+	async_work_put(A);
+
+	if (READ_ONCE(result) != expected) {
+		pr_warn("%s expected %c [%ld], got %ld\n",
+			name, (char)expected, expected, result);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int __init test_A(struct async_domain *domain)
+{
+	return test_x(__func__, domain, task_A, 'A');
+}
+
+static int __init test_B(struct async_domain *domain)
+{
+	return test_x(__func__, domain, task_B, 'B');
+}
+
+static int __init test_x_fence(const char *name,
+			       struct async_domain *domain,
+			       async_func_t func,
+			       const long expected)
+{
+	struct async_work *A;
+	struct kfence *fence;
+	long result = 0;
+
+	A = async_work_create(func, &result, GFP_KERNEL);
+	if (!A)
+		return -ENOMEM;
+
+	fence = alloc_kfence();
+	if (!fence)
+		return -ENOMEM;
+
+	queue_async_work(domain, A, GFP_KERNEL);
+
+	kfence_await_kfence(fence, &A->fence, GFP_KERNEL);
+	kfence_complete(fence);
+
+	kfence_wait(fence);
+
+	async_work_put(A);
+	kfence_put(fence);
+
+	if (READ_ONCE(result) != expected) {
+		pr_warn("%s expected %c [%ld], got %ld\n",
+			name, (char)expected, expected, result);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int __init test_A_fence(struct async_domain *domain)
+{
+	return test_x_fence(__func__, domain, task_A, 'A');
+}
+
+static int __init test_B_fence(struct async_domain *domain)
+{
+	return test_x_fence(__func__, domain, task_B, 'B');
+}
+
+static int __init test_x_fence_y(const char *name,
+				 struct async_domain *domain,
+				 async_func_t x,
+				 async_func_t y,
+				 const long expected)
+{
+	struct async_work *A, *B;
+	struct kfence *fence;
+	long result = 0;
+
+	A = async_work_create(x, &result, GFP_KERNEL);
+	if (!A)
+		return -ENOMEM;
+
+	B = async_work_create(y, &result, GFP_KERNEL);
+	if (!B)
+		return -ENOMEM;
+
+	fence = alloc_kfence();
+	if (!fence)
+		return -ENOMEM;
+
+	kfence_await_kfence(fence, &A->fence, GFP_KERNEL);
+	kfence_complete(fence);
+
+	queue_async_work(domain, A, GFP_KERNEL);
+	async_work_put(A);
+
+	async_work_after(B, fence);
+	queue_async_work(domain, B, GFP_KERNEL);
+	kfence_put(fence);
+
+	async_work_wait(B);
+	async_work_put(B);
+
+	if (READ_ONCE(result) != expected) {
+		pr_warn("%s expected %c [%ld], got %ld\n",
+			name, (char)expected, expected, result);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int __init test_A_fence_B(struct async_domain *domain)
+{
+	return test_x_fence_y(__func__, domain, task_A, task_B, 'B');
+}
+
+static int __init test_B_fence_A(struct async_domain *domain)
+{
+	return test_x_fence_y(__func__, domain, task_B, task_A, 'A');
+}
+
+struct long_context {
+	struct kfence *barrier;
+	long *src;
+	long result;
+};
+
+static void task_wait(void *data, async_cookie_t cookie)
+{
+	struct long_context *ctx = data;
+
+	kfence_wait(ctx->barrier);
+	smp_store_mb(ctx->result, READ_ONCE(*ctx->src));
+}
+
+static int __init test_pause(struct async_domain *domain)
+{
+	struct long_context ctx;
+	struct async_work *A, *B;
+	const long expected = 'B';
+	long out_B = 'A';
+
+	ctx.result = 0;
+	ctx.src = &out_B;
+
+	A = async_work_create(task_wait, &ctx, GFP_KERNEL);
+	if (!A)
+		return -ENOMEM;
+
+	B = async_work_create(task_B, &out_B, GFP_KERNEL);
+	if (!B)
+		return -ENOMEM;
+
+	ctx.barrier = kfence_get(&B->fence);
+
+	queue_async_work(domain, A, GFP_KERNEL);
+	queue_async_work(domain, B, GFP_KERNEL);
+	async_work_put(B);
+
+	async_work_wait(A);
+	async_work_put(A);
+
+	if (READ_ONCE(ctx.result) != expected) {
+		pr_warn("%s expected %c [%ld], got %ld\n",
+			__func__, (char)expected, expected, ctx.result);
+		return -EINVAL;
+	}
+
+	kfence_put(ctx.barrier);
+
+	return 0;
+}
+
+static void task_signal(void *data, async_cookie_t cookie)
+{
+	struct long_context *ctx = data;
+
+	kfence_complete(ctx->barrier);
+}
+
+static int __init test_manual(struct async_domain *domain)
+{
+	struct long_context ctx;
+	struct async_work *A, *B, *C;
+	const long expected = 'B';
+	long out_B = 'A';
+
+	ctx.result = 0;
+	ctx.src = &out_B;
+	ctx.barrier = alloc_kfence();
+
+	A = async_work_create(task_wait, &ctx, GFP_KERNEL);
+	if (!A)
+		return -ENOMEM;
+
+	B = async_work_create(task_B, &out_B, GFP_KERNEL);
+	if (!B)
+		return -ENOMEM;
+
+	C = async_work_create(task_signal, &ctx, GFP_KERNEL);
+	if (!B)
+		return -ENOMEM;
+
+	async_work_after(C, &B->fence);
+
+	queue_async_work(domain, A, GFP_KERNEL);
+	queue_async_work(domain, B, GFP_KERNEL);
+	queue_async_work(domain, C, GFP_KERNEL);
+
+	async_work_wait(A);
+
+	async_work_put(C);
+	async_work_put(B);
+	async_work_put(A);
+	kfence_put(ctx.barrier);
+
+	if (READ_ONCE(ctx.result) != expected) {
+		pr_warn("%s expected %c [%ld], got %ld\n",
+			__func__, (char)expected, expected, ctx.result);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int __init test_sync(struct async_domain *domain)
+{
+	struct async_work *B;
+	const long expected = 'B';
+	long result = 0;
+
+	B = async_work_create(task_B, &result, GFP_KERNEL);
+	if (!B)
+		return -ENOMEM;
+
+	queue_async_work(domain, B, GFP_KERNEL);
+	async_work_put(B);
+
+	async_synchronize_full_domain(domain);
+
+	if (READ_ONCE(result) != expected) {
+		pr_warn("%s expected %c [%ld], got %ld\n",
+			__func__, (char)expected, expected, result);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int __init test_implicit(struct async_domain *domain)
 {
 	const long expected = 'B';
@@ -99,24 +375,62 @@ static int __init test_async_domain_init(void)
 
 	pr_info("Testing async-domains\n");
 
-	ret = test_implicit(&domain);
+	ret = test_A(&domain);
 	if (ret)
 		return ret;
 
+	ret = test_A_fence(&domain);
+	if (ret)
+		goto err;
+
+	ret = test_A_fence_B(&domain);
+	if (ret)
+		goto err;
+
+	ret = test_B(&domain);
+	if (ret)
+		goto err;
+
+	ret = test_B_fence(&domain);
+	if (ret)
+		goto err;
+
+	ret = test_B_fence_A(&domain);
+	if (ret)
+		goto err;
+
+	ret = test_pause(&domain);
+	if (ret)
+		goto err;
+
+	ret = test_manual(&domain);
+	if (ret)
+		goto err;
+
+	ret = test_sync(&domain);
+	if (ret)
+		goto err;
+
+	ret = test_implicit(&domain);
+	if (ret)
+		goto err;
+
 	ret = test_registered(&domain);
 	if (ret)
-		return ret;
+		goto err;
 
 	ret = perf_nop(1, 100);
 	if (ret)
-		return ret;
+		goto err;
 
 	ret = perf_nop(128, 1000);
 	if (ret)
-		return ret;
+		goto err;
 
+err:
+	async_synchronize_full_domain(&domain);
 	async_unregister_domain(&domain);
-	return 0;
+	return ret;
 }
 
 static void __exit test_async_domain_cleanup(void)
-- 
2.8.1

