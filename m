Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:32924 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941AbcFXJJq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jun 2016 05:09:46 -0400
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
Subject: [PATCH 5/9] async: Wrap hrtimer to provide a time source for a kfence
Date: Fri, 24 Jun 2016 10:08:49 +0100
Message-Id: <1466759333-4703-6-git-send-email-chris@chris-wilson.co.uk>
In-Reply-To: <1466759333-4703-1-git-send-email-chris@chris-wilson.co.uk>
References: <1466759333-4703-1-git-send-email-chris@chris-wilson.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

kfence_add_delay() is a convenience wrapper around
hrtimer_start_range_ns() to provide a time source for a kfence graph.

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
 include/linux/kfence.h |  5 +++++
 kernel/async.c         | 60 +++++++++++++++++++++++++++++++++++++++++++++++++-
 lib/test-kfence.c      | 44 ++++++++++++++++++++++++++++++++++++
 3 files changed, 108 insertions(+), 1 deletion(-)

diff --git a/include/linux/kfence.h b/include/linux/kfence.h
index d71f30c626ae..1abec5e6b23c 100644
--- a/include/linux/kfence.h
+++ b/include/linux/kfence.h
@@ -16,6 +16,7 @@
 
 struct completion;
 struct fence;
+enum hrtimer_mode;
 
 struct kfence {
 	wait_queue_head_t wait;
@@ -33,6 +34,10 @@ extern int kfence_add_completion(struct kfence *fence,
 extern int kfence_add_dma(struct kfence *fence,
 			  struct fence *dma,
 			  gfp_t gfp);
+extern int kfence_add_delay(struct kfence *fence,
+			    clockid_t clock, enum hrtimer_mode mode,
+			    ktime_t delay, u64 slack,
+			    gfp_t gfp);
 extern void kfence_pending(struct kfence *fence);
 extern void kfence_signal(struct kfence *fence);
 extern void kfence_wait(struct kfence *fence);
diff --git a/kernel/async.c b/kernel/async.c
index 01552d23a916..5d02445e36b7 100644
--- a/kernel/async.c
+++ b/kernel/async.c
@@ -126,7 +126,10 @@ static atomic_t entry_count;
  *	kfence_add() / kfence_add_completion() / kfence_add_dma()
  *
  * sets the kfence to wait upon another fence, completion, or DMA fence
- * respectively.
+ * respectively. To set the fence to wait for at least a certain period of
+ * time, or until after a certain point in time, use
+ *
+ * 	kfence_add_timer()
  *
  * Unlike completions, kfences are expected to live inside more complex graphs
  * and form the basis for parallel execution of interdependent and so are
@@ -543,6 +546,61 @@ int kfence_add_dma(struct kfence *fence, struct fence *dma, gfp_t gfp)
 }
 EXPORT_SYMBOL_GPL(kfence_add_dma);
 
+/**
+ * kfence_add_delay - set the fence to wait for a period of time
+ * @fence: this kfence
+ * @clock: which clock to program
+ * @mode: delay given as relative or absolute
+ * @delay: how long or until what time to wait
+ * @slack: how much slack that may be applied to the delay
+ *
+ * kfence_add_delay() causes the @fence to wait for a a period of time, or
+ * until a certain point in time. It is a convenience wrapper around
+ * hrtimer_start_range_ns(). For more details on @clock, @mode, @delay and
+ * @slack please consult the hrtimer documentation.
+ *
+ * Returns 1 if the delay was sucessfuly added to the @fence, or a negative
+ * error code on failure.
+ */
+struct timer_cb {
+	struct hrtimer timer;
+	struct kfence *fence;
+};
+
+static enum hrtimer_restart
+timer_kfence_wake(struct hrtimer *timer)
+{
+	struct timer_cb *cb = container_of(timer, typeof(*cb), timer);
+
+	kfence_signal(cb->fence);
+	kfence_put(cb->fence);
+	kfree(cb);
+
+	return HRTIMER_NORESTART;
+}
+
+int kfence_add_delay(struct kfence *fence,
+		     clockid_t clock, enum hrtimer_mode mode,
+		     ktime_t delay, u64 slack,
+		     gfp_t gfp)
+{
+	struct timer_cb *cb;
+
+	cb = kmalloc(sizeof(*cb), gfp);
+	if (!cb)
+		return -ENOMEM;
+
+	cb->fence = kfence_get(fence);
+	kfence_pending(fence);
+
+	hrtimer_init(&cb->timer, clock, mode);
+	cb->timer.function = timer_kfence_wake;
+
+	hrtimer_start_range_ns(&cb->timer, delay, slack, mode);
+	return 1;
+}
+EXPORT_SYMBOL_GPL(kfence_add_delay);
+
 static async_cookie_t lowest_in_progress(struct async_domain *domain)
 {
 	struct list_head *pending;
diff --git a/lib/test-kfence.c b/lib/test-kfence.c
index 0604a27f68b2..782a2cca19c5 100644
--- a/lib/test-kfence.c
+++ b/lib/test-kfence.c
@@ -341,6 +341,44 @@ static int __init test_completion(void)
 	return 0;
 }
 
+static int __init test_delay(void)
+{
+	struct kfence *fence;
+	ktime_t delay;
+	int ret;
+
+	/* Test use of a hrtimer as an event source for kfences */
+	pr_debug("%s\n", __func__);
+
+	fence = kfence_create(GFP_KERNEL);
+	if (!fence)
+		return -ENOMEM;
+
+	delay = ktime_get();
+
+	ret = kfence_add_delay(fence, CLOCK_MONOTONIC, HRTIMER_MODE_REL,
+			       ms_to_ktime(1), 1 << 10,
+			       GFP_KERNEL);
+	if (ret < 0)
+		return ret;
+	if (ret == 0)
+		return -EINVAL;
+
+	kfence_signal(fence);
+	kfence_wait(fence);
+
+	delay = ktime_sub(ktime_get(), delay);
+	kfence_put(fence);
+
+	if (!ktime_to_ms(delay)) {
+		pr_err("kfence woke too early, delay was only %lldns\n",
+		       (long long)ktime_to_ns(delay));
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 struct task_ipc {
 	struct work_struct work;
 	struct completion started;
@@ -509,6 +547,12 @@ static int __init test_kfence_init(void)
 		return ret;
 	}
 
+	ret = test_delay();
+	if (ret < 0) {
+		pr_err("delay failed\n");
+		return ret;
+	}
+
 	return 0;
 }
 
-- 
2.8.1

