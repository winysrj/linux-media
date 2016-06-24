Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:32991 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946AbcFXJJu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jun 2016 05:09:50 -0400
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
Subject: [PATCH 8/9] async: Add execution barriers
Date: Fri, 24 Jun 2016 10:08:52 +0100
Message-Id: <1466759333-4703-9-git-send-email-chris@chris-wilson.co.uk>
In-Reply-To: <1466759333-4703-1-git-send-email-chris@chris-wilson.co.uk>
References: <1466759333-4703-1-git-send-email-chris@chris-wilson.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A frequent mode of operation is fanning out N tasks to execute in
parallel, collating results, fanning out M tasks, rinse and repeat. This
is also common to the notion of the async/sync kernel domain split.
A barrier provides a mechanism by which all work queued after the
barrier must wait (i.e. not be scheduled) until all work queued before the
barrier is completed.

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
 include/linux/async.h |  4 ++++
 kernel/async.c        | 60 +++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 64 insertions(+)

diff --git a/include/linux/async.h b/include/linux/async.h
index 45d6c8323b60..64a090e3f24f 100644
--- a/include/linux/async.h
+++ b/include/linux/async.h
@@ -26,6 +26,7 @@ struct async_work {
 
 struct async_domain {
 	struct list_head pending;
+	struct kfence *barrier;
 	unsigned registered:1;
 };
 
@@ -59,6 +60,9 @@ extern void async_synchronize_cookie(async_cookie_t cookie);
 extern void async_synchronize_cookie_domain(async_cookie_t cookie,
 					    struct async_domain *domain);
 
+extern void async_barrier(void);
+extern void async_barrier_domain(struct async_domain *domain);
+
 extern bool current_is_async(void);
 
 extern struct async_work *
diff --git a/kernel/async.c b/kernel/async.c
index 83007c39a113..a22945f4b4c4 100644
--- a/kernel/async.c
+++ b/kernel/async.c
@@ -724,6 +724,12 @@ struct async_work *async_work_create(async_func_t func, void *data, gfp_t gfp)
 }
 EXPORT_SYMBOL_GPL(async_work_create);
 
+static void async_barrier_delete(struct async_domain *domain)
+{
+	kfence_put(domain->barrier);
+	domain->barrier = NULL;
+}
+
 async_cookie_t queue_async_work(struct async_domain *domain,
 				struct async_work *work,
 				gfp_t gfp)
@@ -744,6 +750,9 @@ async_cookie_t queue_async_work(struct async_domain *domain,
 	async_pending_count++;
 	spin_unlock_irqrestore(&async_lock, flags);
 
+	if (!kfence_add(&entry->base.fence, domain->barrier, gfp))
+		async_barrier_delete(domain);
+
 	/* mark that this task has queued an async job, used by module init */
 	current->flags |= PF_USED_ASYNC;
 
@@ -811,6 +820,55 @@ async_cookie_t async_schedule_domain(async_func_t func, void *data,
 }
 EXPORT_SYMBOL_GPL(async_schedule_domain);
 
+static struct kfence * __async_barrier_create(struct async_domain *domain)
+{
+	struct kfence *fence;
+	struct async_entry *entry;
+	unsigned long flags;
+	int ret;
+
+	fence = kfence_create(GFP_KERNEL);
+	if (!fence)
+		goto out_sync;
+
+	ret = 0;
+	spin_lock_irqsave(&async_lock, flags);
+	list_for_each_entry(entry, &domain->pending, pending_link[0]) {
+		ret |= kfence_add(fence, &entry->base.fence, GFP_ATOMIC);
+		if (ret < 0)
+			break;
+	}
+	spin_unlock_irqrestore(&async_lock, flags);
+	if (ret <= 0)
+		goto out_put;
+
+	kfence_add(fence, domain->barrier, GFP_KERNEL);
+	kfence_signal(fence);
+	return fence;
+
+out_put:
+	kfence_signal(fence);
+	kfence_put(fence);
+out_sync:
+	async_synchronize_full_domain(domain);
+	return NULL;
+}
+
+void async_barrier(void)
+{
+	async_barrier_domain(&async_dfl_domain);
+}
+EXPORT_SYMBOL_GPL(async_barrier);
+
+void async_barrier_domain(struct async_domain *domain)
+{
+	struct kfence *barrier = __async_barrier_create(domain);
+
+	kfence_put(domain->barrier);
+	domain->barrier = barrier;
+}
+EXPORT_SYMBOL_GPL(async_barrier_domain);
+
 /**
  * async_synchronize_full - synchronize all asynchronous function calls
  *
@@ -834,6 +892,8 @@ EXPORT_SYMBOL_GPL(async_synchronize_full);
 void async_unregister_domain(struct async_domain *domain)
 {
 	WARN_ON(!list_empty(&domain->pending));
+
+	async_barrier_delete(domain);
 	domain->registered = 0;
 }
 EXPORT_SYMBOL_GPL(async_unregister_domain);
-- 
2.8.1

