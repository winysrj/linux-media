Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:36745 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876AbcFXJJo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jun 2016 05:09:44 -0400
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
Subject: [PATCH 4/9] async: Extend kfences for listening on DMA fences
Date: Fri, 24 Jun 2016 10:08:48 +0100
Message-Id: <1466759333-4703-5-git-send-email-chris@chris-wilson.co.uk>
In-Reply-To: <1466759333-4703-1-git-send-email-chris@chris-wilson.co.uk>
References: <1466759333-4703-1-git-send-email-chris@chris-wilson.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

dma-buf provides an interfaces for receiving notifications from DMA
hardware. kfence provides a useful interface for collecting such fences
and combining them with other events.

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
 include/linux/kfence.h |  4 ++++
 kernel/async.c         | 63 ++++++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 65 insertions(+), 2 deletions(-)

diff --git a/include/linux/kfence.h b/include/linux/kfence.h
index 82096bfafaa1..d71f30c626ae 100644
--- a/include/linux/kfence.h
+++ b/include/linux/kfence.h
@@ -15,6 +15,7 @@
 #include <linux/wait.h>
 
 struct completion;
+struct fence;
 
 struct kfence {
 	wait_queue_head_t wait;
@@ -29,6 +30,9 @@ extern int kfence_add(struct kfence *fence, struct kfence *after, gfp_t gfp);
 extern int kfence_add_completion(struct kfence *fence,
 				 struct completion *x,
 				 gfp_t gfp);
+extern int kfence_add_dma(struct kfence *fence,
+			  struct fence *dma,
+			  gfp_t gfp);
 extern void kfence_pending(struct kfence *fence);
 extern void kfence_signal(struct kfence *fence);
 extern void kfence_wait(struct kfence *fence);
diff --git a/kernel/async.c b/kernel/async.c
index db22b890711e..01552d23a916 100644
--- a/kernel/async.c
+++ b/kernel/async.c
@@ -50,6 +50,7 @@ asynchronous and synchronous parts of the kernel.
 
 #include <linux/async.h>
 #include <linux/atomic.h>
+#include <linux/fence.h>
 #include <linux/kfence.h>
 #include <linux/ktime.h>
 #include <linux/export.h>
@@ -122,9 +123,10 @@ static atomic_t entry_count;
  * allowing multiple pending / signals to be sent before the kfence is
  * complete.
  *
- *	kfence_add() / kfence_add_completion()
+ *	kfence_add() / kfence_add_completion() / kfence_add_dma()
  *
- * sets the kfence to wait upon another fence, or completion respectively.
+ * sets the kfence to wait upon another fence, completion, or DMA fence
+ * respectively.
  *
  * Unlike completions, kfences are expected to live inside more complex graphs
  * and form the basis for parallel execution of interdependent and so are
@@ -484,6 +486,63 @@ int kfence_add_completion(struct kfence *fence, struct completion *x, gfp_t gfp)
 }
 EXPORT_SYMBOL_GPL(kfence_add_completion);
 
+struct dma_fence_cb {
+	struct fence_cb base;
+	struct kfence *fence;
+};
+
+static void dma_kfence_wake(struct fence *dma, struct fence_cb *data)
+{
+	struct dma_fence_cb *cb = container_of(data, typeof(*cb), base);
+	kfence_signal(cb->fence);
+	kfence_put(cb->fence);
+	kfree(cb);
+}
+
+/**
+ * kfence_add_dma - set the fence to wait upon a DMA fence
+ * @fence: this kfence
+ * @dma: target DMA fence to wait upon
+ * @gfp: the allowed allocation type
+ *
+ * kfence_add_dma() causes the @fence to wait upon completion of a DMA fence.
+ *
+ * Returns 1 if the @fence was successfully to the waitqueue of @dma, 0
+ * if @dma was already signaled (and so not added), or a negative error code.
+ */
+int kfence_add_dma(struct kfence *fence, struct fence *dma, gfp_t gfp)
+{
+	struct dma_fence_cb *cb;
+	int ret;
+
+	if (!dma || fence_is_signaled(dma))
+		return 0;
+
+	cb = kmalloc(sizeof(*cb), gfp);
+	if (!cb) {
+		if (!gfpflags_allow_blocking(gfp))
+			return -ENOMEM;
+
+		return fence_wait(dma, false);
+	}
+
+	cb->fence = kfence_get(fence);
+	kfence_pending(fence);
+
+	ret = fence_add_callback(dma, &cb->base, dma_kfence_wake);
+	if (ret == 0) {
+		/* signal fence add and is pending */
+		ret = 1;
+	} else {
+		dma_kfence_wake(dma, &cb->base);
+		if (ret == -ENOENT) /* fence already signaled */
+			ret = 0;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(kfence_add_dma);
+
 static async_cookie_t lowest_in_progress(struct async_domain *domain)
 {
 	struct list_head *pending;
-- 
2.8.1

