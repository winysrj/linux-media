Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:36792 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943AbcFXJJr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jun 2016 05:09:47 -0400
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
Subject: [PATCH 6/9] async: Add a convenience wrapper for waiting on implicit dma-buf
Date: Fri, 24 Jun 2016 10:08:50 +0100
Message-Id: <1466759333-4703-7-git-send-email-chris@chris-wilson.co.uk>
In-Reply-To: <1466759333-4703-1-git-send-email-chris@chris-wilson.co.uk>
References: <1466759333-4703-1-git-send-email-chris@chris-wilson.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

dma-buf implicitly track their (DMA) rendering using a
reservation_object, which tracks ether the last write (in an exclusive
fence) or the current renders (with a set of shared fences). To wait
upon a reservation object in conjunction with other sources,
kfence_add_reservation() extracts the DMA fences from the object and
adds the individual waits for the kfence.

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
 kernel/async.c         | 65 ++++++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 65 insertions(+), 5 deletions(-)

diff --git a/include/linux/kfence.h b/include/linux/kfence.h
index 1abec5e6b23c..2f01eb052e4d 100644
--- a/include/linux/kfence.h
+++ b/include/linux/kfence.h
@@ -17,6 +17,7 @@
 struct completion;
 struct fence;
 enum hrtimer_mode;
+struct reservation_object;
 
 struct kfence {
 	wait_queue_head_t wait;
@@ -34,6 +35,10 @@ extern int kfence_add_completion(struct kfence *fence,
 extern int kfence_add_dma(struct kfence *fence,
 			  struct fence *dma,
 			  gfp_t gfp);
+extern int kfence_add_reservation(struct kfence *fence,
+				  struct reservation_object *resv,
+				  bool write,
+				  gfp_t gfp);
 extern int kfence_add_delay(struct kfence *fence,
 			    clockid_t clock, enum hrtimer_mode mode,
 			    ktime_t delay, u64 slack,
diff --git a/kernel/async.c b/kernel/async.c
index 5d02445e36b7..1fa1f39b5a74 100644
--- a/kernel/async.c
+++ b/kernel/async.c
@@ -54,9 +54,10 @@ asynchronous and synchronous parts of the kernel.
 #include <linux/kfence.h>
 #include <linux/ktime.h>
 #include <linux/export.h>
-#include <linux/wait.h>
+#include <linux/reservation.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
+#include <linux/wait.h>
 #include <linux/workqueue.h>
 
 #include "workqueue_internal.h"
@@ -123,11 +124,17 @@ static atomic_t entry_count;
  * allowing multiple pending / signals to be sent before the kfence is
  * complete.
  *
- *	kfence_add() / kfence_add_completion() / kfence_add_dma()
+ *	kfence_add() / kfence_add_completion()
+ *	/ kfence_add_dma()
+ *
+ * sets the kfence to wait upon another fence or completion respectively. To
+ * wait upon DMA activity, either use
  *
- * sets the kfence to wait upon another fence, completion, or DMA fence
- * respectively. To set the fence to wait for at least a certain period of
- * time, or until after a certain point in time, use
+ * 	kfence_add_dma() or kfence_add_reservation()
+ *
+ * depending on the manner of DMA activity tracking.  To set the fence to wait
+ * for at least a certain period of time, or until after a certain point in
+ * time, use
  *
  * 	kfence_add_timer()
  *
@@ -547,6 +554,54 @@ int kfence_add_dma(struct kfence *fence, struct fence *dma, gfp_t gfp)
 EXPORT_SYMBOL_GPL(kfence_add_dma);
 
 /**
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
+int kfence_add_reservation(struct kfence *fence,
+			   struct reservation_object *resv,
+			   bool write,
+			   gfp_t gfp)
+{
+	struct fence *excl, **shared;
+	unsigned count, i;
+	int ret;
+
+	ret = reservation_object_get_fences_rcu(resv, &excl, &count, &shared);
+	if (ret)
+		return ret;
+
+	if (write) {
+		for (i = 0; i < count; i++) {
+			ret |= kfence_add_dma(fence, shared[i], gfp);
+			if (ret < 0)
+				goto out;
+		}
+	}
+
+	if (excl)
+		ret |= kfence_add_dma(fence, excl, gfp);
+
+out:
+	fence_put(excl);
+	for (i = 0; i < count; i++)
+		fence_put(shared[i]);
+	kfree(shared);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(kfence_add_reservation);
+
+/**
  * kfence_add_delay - set the fence to wait for a period of time
  * @fence: this kfence
  * @clock: which clock to program
-- 
2.8.1

