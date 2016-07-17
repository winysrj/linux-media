Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33301 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbcGQM7I (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2016 08:59:08 -0400
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
Subject: [PATCH v2 3/7] kfence: Extend kfences for listening on DMA fences
Date: Sun, 17 Jul 2016 13:58:03 +0100
Message-Id: <1468760287-731-4-git-send-email-chris@chris-wilson.co.uk>
In-Reply-To: <1468760287-731-1-git-send-email-chris@chris-wilson.co.uk>
References: <1466759333-4703-1-git-send-email-chris@chris-wilson.co.uk>
 <1468760287-731-1-git-send-email-chris@chris-wilson.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

dma-buf provides an interfaces for receiving notifications from DMA
hardware, and for implicitly tracking fences used for rendering into
dma-buf. We want to be able to use these event sources along with kfence
for easy collection and combining with other events.

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
 drivers/dma-buf/fence.c       | 58 +++++++++++++++++++++++++++++++++++++++++++
 drivers/dma-buf/reservation.c | 48 +++++++++++++++++++++++++++++++++++
 include/linux/fence.h         |  6 +++++
 include/linux/kfence.h        |  2 ++
 include/linux/reservation.h   |  7 ++++++
 kernel/kfence.c               |  8 ++++++
 6 files changed, 129 insertions(+)

diff --git a/drivers/dma-buf/fence.c b/drivers/dma-buf/fence.c
index 7b05dbe9b296..3f06b3b1b4cc 100644
--- a/drivers/dma-buf/fence.c
+++ b/drivers/dma-buf/fence.c
@@ -22,6 +22,7 @@
 #include <linux/export.h>
 #include <linux/atomic.h>
 #include <linux/fence.h>
+#include <linux/kfence.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/fence.h>
@@ -530,3 +531,60 @@ fence_init(struct fence *fence, const struct fence_ops *ops,
 	trace_fence_init(fence);
 }
 EXPORT_SYMBOL(fence_init);
+
+struct dma_fence_cb {
+	struct fence_cb base;
+	struct kfence *fence;
+};
+
+static void dma_kfence_wake(struct fence *dma, struct fence_cb *data)
+{
+	struct dma_fence_cb *cb = container_of(data, typeof(*cb), base);
+
+	kfence_complete(cb->fence);
+	kfence_put(cb->fence);
+	kfree(cb);
+}
+
+/**
+ * kfence_await_dma_fence - set the fence to wait upon a DMA fence
+ * @fence: this kfence
+ * @dma: target DMA fence to wait upon
+ * @gfp: the allowed allocation type
+ *
+ * kfence_add_dma() causes the @fence to wait upon completion of a DMA fence.
+ *
+ * Returns 1 if the @fence was successfully to the waitqueue of @dma, 0
+ * if @dma was already signaled (and so not added), or a negative error code.
+ */
+int kfence_await_dma_fence(struct kfence *fence, struct fence *dma, gfp_t gfp)
+{
+	struct dma_fence_cb *cb;
+	int ret;
+
+	if (fence_is_signaled(dma))
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
+	kfence_await(fence);
+
+	ret = fence_add_callback(dma, &cb->base, dma_kfence_wake);
+	if (ret == 0) {
+		ret = 1;
+	} else {
+		dma_kfence_wake(dma, &cb->base);
+		if (ret == -ENOENT) /* fence already signaled */
+			ret = 0;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(kfence_await_dma_fence);
diff --git a/drivers/dma-buf/reservation.c b/drivers/dma-buf/reservation.c
index 9566a62ad8e3..138b792af0c3 100644
--- a/drivers/dma-buf/reservation.c
+++ b/drivers/dma-buf/reservation.c
@@ -543,3 +543,51 @@ unlock_retry:
 	goto retry;
 }
 EXPORT_SYMBOL_GPL(reservation_object_test_signaled_rcu);
+
+/**
+ * kfence_add_reservation - set the fence to wait upon a reservation_object
+ * @fence: this kfence
+ * @resv: target reservation_object (collection of DMA fences) to wait upon
+ * @write: Wait for read or read/write access
+ * @gfp: the allowed allocation type
+ *
+ * kfence_add_reservation() causes the @fence to wait upon completion of the
+ * reservation object (a collection of DMA fences), either for read access
+ * or for read/write access.
+ *
+ * Returns 1 if the @fence was successfully to the waitqueues of @resv, 0
+ * if @resev was already signaled (and so not added), or a negative error code.
+ */
+int kfence_await_reservation(struct kfence *fence,
+			     struct reservation_object *resv,
+			     bool write,
+			     gfp_t gfp)
+{
+	struct fence *excl, **shared;
+	unsigned int count, i;
+	int ret;
+
+	ret = reservation_object_get_fences_rcu(resv, &excl, &count, &shared);
+	if (ret)
+		return ret;
+
+	if (write) {
+		for (i = 0; i < count; i++) {
+			ret |= kfence_await_dma_fence(fence, shared[i], gfp);
+			if (ret < 0)
+				goto out;
+		}
+	}
+
+	if (excl)
+		ret |= kfence_await_dma_fence(fence, excl, gfp);
+
+out:
+	fence_put(excl);
+	for (i = 0; i < count; i++)
+		fence_put(shared[i]);
+	kfree(shared);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(kfence_await_reservation);
diff --git a/include/linux/fence.h b/include/linux/fence.h
index 2056e9fd0138..3c3bc318e826 100644
--- a/include/linux/fence.h
+++ b/include/linux/fence.h
@@ -34,6 +34,8 @@ struct fence;
 struct fence_ops;
 struct fence_cb;
 
+struct kfence;
+
 /**
  * struct fence - software synchronization primitive
  * @refcount: refcount for this fence
@@ -378,4 +380,8 @@ unsigned fence_context_alloc(unsigned num);
 			##args);					\
 	} while (0)
 
+int kfence_await_dma_fence(struct kfence *fence,
+			   struct fence *dma,
+			   gfp_t gfp);
+
 #endif /* __LINUX_FENCE_H */
diff --git a/include/linux/kfence.h b/include/linux/kfence.h
index 76a2f95dfb70..acbfc2ea7c49 100644
--- a/include/linux/kfence.h
+++ b/include/linux/kfence.h
@@ -16,6 +16,8 @@
 #include <linux/wait.h>
 
 struct completion;
+struct fence;
+struct reservation_object;
 enum hrtimer_mode;
 
 struct kfence {
diff --git a/include/linux/reservation.h b/include/linux/reservation.h
index b0f305e77b7f..1954bab95db9 100644
--- a/include/linux/reservation.h
+++ b/include/linux/reservation.h
@@ -49,6 +49,8 @@ extern struct ww_class reservation_ww_class;
 extern struct lock_class_key reservation_seqcount_class;
 extern const char reservation_seqcount_string[];
 
+struct kfence;
+
 /**
  * struct reservation_object_list - a list of shared fences
  * @rcu: for internal use
@@ -210,4 +212,9 @@ long reservation_object_wait_timeout_rcu(struct reservation_object *obj,
 bool reservation_object_test_signaled_rcu(struct reservation_object *obj,
 					  bool test_all);
 
+int kfence_await_reservation(struct kfence *fence,
+			     struct reservation_object *resv,
+			     bool write,
+			     gfp_t gfp);
+
 #endif /* _LINUX_RESERVATION_H */
diff --git a/kernel/kfence.c b/kernel/kfence.c
index 59c27910a749..4605eabc2c1b 100644
--- a/kernel/kfence.c
+++ b/kernel/kfence.c
@@ -7,7 +7,9 @@
  * of the License.
  */
 
+#include <linux/fence.h>
 #include <linux/kfence.h>
+#include <linux/reservation.h>
 #include <linux/slab.h>
 
 /**
@@ -51,6 +53,12 @@
  * - kfence_await_hrtimer(): the kfence asynchronously wait for an expiration
  *   of a timer
  *
+ * - kfence_await_dma_fence(): the kfence asynchronously waits for a DMA
+ *   (hardware signaled) fence
+ *
+ * - kfence_await_reservation(): the kfence asynchronously waits for a DMA
+ *   reservation object
+ *
  * A kfence is initialised using kfence_init(), and starts off awaiting an
  * event. Once you have finished setting up the fence, including adding
  * all of its asynchronous waits, call kfence_complete().
-- 
2.8.1

