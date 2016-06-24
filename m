Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36733 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbcFXJJn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jun 2016 05:09:43 -0400
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
Subject: [PATCH 3/9] async: Extend kfence to allow struct embedding
Date: Fri, 24 Jun 2016 10:08:47 +0100
Message-Id: <1466759333-4703-4-git-send-email-chris@chris-wilson.co.uk>
In-Reply-To: <1466759333-4703-1-git-send-email-chris@chris-wilson.co.uk>
References: <1466759333-4703-1-git-send-email-chris@chris-wilson.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Provide a kfence_init() function for use for embedding the kfence into a
parent structure. kfence_init() takes an optional function pointer argument
should the caller wish to be notified when the kfence is complete. This is
useful for allowing the kfences to drive other state machinery.

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
 include/linux/kfence.h |  5 ++++
 kernel/async.c         | 52 ++++++++++++++++++++++++++++++++++++----
 lib/test-kfence.c      | 64 +++++++++++++++++++++++++++++++++++++++++++-------
 3 files changed, 109 insertions(+), 12 deletions(-)

diff --git a/include/linux/kfence.h b/include/linux/kfence.h
index 82eba8aacd02..82096bfafaa1 100644
--- a/include/linux/kfence.h
+++ b/include/linux/kfence.h
@@ -38,4 +38,9 @@ static inline bool kfence_complete(struct kfence *fence)
 }
 extern void kfence_put(struct kfence *fence);
 
+typedef void (*kfence_notify_t)(struct kfence *);
+#define __kfence_call __attribute__((aligned(4)))
+
+extern void kfence_init(struct kfence *fence, kfence_notify_t fn);
+
 #endif /* _KFENCE_H_ */
diff --git a/kernel/async.c b/kernel/async.c
index d0bcb7cc4884..db22b890711e 100644
--- a/kernel/async.c
+++ b/kernel/async.c
@@ -134,7 +134,17 @@ static atomic_t entry_count;
  *
  * The fence starts off pending a single signal. Once you have finished
  * setting up the fence, use kfence_signal() to allow it to wait upon
- * its event sources.
+ * its event sources. To embed a kfence within another struct, use
+ *
+ * 	kfence_init()
+ *
+ * This can also be used to receive a callback when the kfence is completed
+ * (pending signal count hits 0).  The callback is also called when the fence
+ * is released (the reference count hits 0, and the fence will be complete).
+ * Note that since the kfence is embedded inside another, its initial reference
+ * must not be dropped unless a callback is provided, or the kfence is the
+ * first member in the parent, and the parent was allocated by kmalloc (i.e.
+ * valid to be freed by kfree()).
  *
  * Use
  *
@@ -151,7 +161,11 @@ static void kfence_free(struct kref *kref)
 
 	WARN_ON(atomic_read(&fence->pending) > 0);
 
-	kfree(fence);
+	if (fence->flags) {
+		kfence_notify_t fn = (kfence_notify_t)fence->flags;
+		fn(fence);
+	} else
+		kfree(fence);
 }
 
 /**
@@ -203,6 +217,11 @@ static void __kfence_signal(struct kfence *fence,
 	if (!atomic_dec_and_test(&fence->pending))
 		return;
 
+	if (fence->flags) {
+		kfence_notify_t fn = (kfence_notify_t)fence->flags;
+		fn(fence);
+	}
+
 	atomic_dec(&fence->pending);
 	__kfence_wake_up_all(fence, continuation);
 }
@@ -240,7 +259,7 @@ void kfence_wait(struct kfence *fence)
 }
 EXPORT_SYMBOL_GPL(kfence_wait);
 
-static void kfence_init(struct kfence *fence)
+static void __kfence_init(struct kfence *fence)
 {
 	init_waitqueue_head(&fence->wait);
 	kref_init(&fence->kref);
@@ -266,11 +285,36 @@ struct kfence *kfence_create(gfp_t gfp)
 	if (!fence)
 		return NULL;
 
-	kfence_init(fence);
+	__kfence_init(fence);
 	return fence;
 }
 EXPORT_SYMBOL_GPL(kfence_create);
 
+/**
+ * kfence_init - initialize a fence for use embedded within a struct
+ * @fence: this kfence
+ * @fn: a callback function for when the fence is complete, and when the
+ * fence is released
+ *
+ * This function initialises the @fence for use embedded within a parent
+ * structure. The optional @fn hook is called when the fence is completed
+ * (when all of its events sources have signaled their completion, i.e.
+ * pending signal count hits 0, fence_complete() however reports false as the
+ * fence is not considered complete until after the callback returns) and when
+ * the fence is subsequently released (the reference count hits 0,
+ * fence_complete() is then true). Note carefully that @fn will be called from
+ * atomic context. Also the lower 2 bits of the function pointer are used for
+ * storing flags, so the function must be aligned to at least 4 bytes - use
+ * __kfence_call as a function attribute to ensure correct alignment.
+ */
+void kfence_init(struct kfence *fence, kfence_notify_t fn)
+{
+	__kfence_init(fence);
+	BUG_ON((unsigned long)fn & KFENCE_CHECKED_BIT);
+	fence->flags = (unsigned long)fn;
+}
+EXPORT_SYMBOL_GPL(kfence_init);
+
 static int kfence_wake(wait_queue_t *wq, unsigned mode, int flags, void *key)
 {
 	list_del(&wq->task_list);
diff --git a/lib/test-kfence.c b/lib/test-kfence.c
index 1d9e4a5a2184..0604a27f68b2 100644
--- a/lib/test-kfence.c
+++ b/lib/test-kfence.c
@@ -9,9 +9,27 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 
+static int __init __test_self(struct kfence *fence)
+{
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
+	return 0;
+}
+
 static int __init test_self(void)
 {
 	struct kfence *fence;
+	int ret;
 
 	/* Test kfence signaling and completion testing */
 	pr_debug("%s\n", __func__);
@@ -20,19 +38,43 @@ static int __init test_self(void)
 	if (!fence)
 		return -ENOMEM;
 
-	if (kfence_complete(fence))
-		return -EINVAL;
+	ret = __test_self(fence);
 
-	kfence_signal(fence);
+	kfence_put(fence);
+	return ret;
+}
 
-	if (!kfence_complete(fence))
-		return -EINVAL;
+struct test_stack {
+	struct kfence fence;
+	bool seen;
+};
 
-	kfence_wait(fence);
-	if (!kfence_complete(fence))
+static void __init __kfence_call fence_callback(struct kfence *fence)
+{
+	struct test_stack *ts = container_of(fence, typeof(*ts), fence);
+	ts->seen = true;
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
 		return -EINVAL;
+	}
 
-	kfence_put(fence);
 	return 0;
 }
 
@@ -413,6 +455,12 @@ static int __init test_kfence_init(void)
 		return ret;
 	}
 
+	ret = test_stack();
+	if (ret < 0) {
+		pr_err("stack failed\n");
+		return ret;
+	}
+
 	ret = test_dag();
 	if (ret < 0) {
 		pr_err("DAG checker failed\n");
-- 
2.8.1

