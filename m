Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35265 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205AbcGQM7B (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2016 08:59:01 -0400
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
Subject: [PATCH v2 2/7] kfence: Wrap hrtimer to provide a time source for a kfence
Date: Sun, 17 Jul 2016 13:58:02 +0100
Message-Id: <1468760287-731-3-git-send-email-chris@chris-wilson.co.uk>
In-Reply-To: <1468760287-731-1-git-send-email-chris@chris-wilson.co.uk>
References: <1466759333-4703-1-git-send-email-chris@chris-wilson.co.uk>
 <1468760287-731-1-git-send-email-chris@chris-wilson.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A common requirement when scheduling a task is that it should be not be
begun until a certain point in time is passed (e.g.
queue_delayed_work()).  kfence_await_hrtimer() causes the kfence to
asynchronously wait until after the appropriate time before being woken.

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
 kernel/kfence.c        | 58 ++++++++++++++++++++++++++++++++++++++++++++++++++
 lib/test-kfence.c      | 44 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 107 insertions(+)

diff --git a/include/linux/kfence.h b/include/linux/kfence.h
index 6e32385b3b8c..76a2f95dfb70 100644
--- a/include/linux/kfence.h
+++ b/include/linux/kfence.h
@@ -16,6 +16,7 @@
 #include <linux/wait.h>
 
 struct completion;
+enum hrtimer_mode;
 
 struct kfence {
 	wait_queue_head_t wait;
@@ -43,6 +44,10 @@ int kfence_await_kfence(struct kfence *fence,
 int kfence_await_completion(struct kfence *fence,
 			    struct completion *x,
 			    gfp_t gfp);
+int kfence_await_hrtimer(struct kfence *fence,
+			 clockid_t clock, enum hrtimer_mode mode,
+			 ktime_t delay, u64 slack,
+			 gfp_t gfp);
 void kfence_complete(struct kfence *fence);
 void kfence_wake_up_all(struct kfence *fence);
 void kfence_wait(struct kfence *fence);
diff --git a/kernel/kfence.c b/kernel/kfence.c
index 693af9da545a..59c27910a749 100644
--- a/kernel/kfence.c
+++ b/kernel/kfence.c
@@ -48,6 +48,9 @@
  * - kfence_await_completion(): the kfence asynchronously waits upon a
  *   completion
  *
+ * - kfence_await_hrtimer(): the kfence asynchronously wait for an expiration
+ *   of a timer
+ *
  * A kfence is initialised using kfence_init(), and starts off awaiting an
  * event. Once you have finished setting up the fence, including adding
  * all of its asynchronous waits, call kfence_complete().
@@ -429,3 +432,58 @@ int kfence_await_completion(struct kfence *fence,
 	return pending;
 }
 EXPORT_SYMBOL_GPL(kfence_await_completion);
+
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
+	kfence_complete(cb->fence);
+	kfence_put(cb->fence);
+	kfree(cb);
+
+	return HRTIMER_NORESTART;
+}
+
+/**
+ * kfence_await_hrtimer - set the fence to wait for a period of time
+ * @fence: this kfence
+ * @clock: which clock to program
+ * @mode: delay given as relative or absolute
+ * @delay: how long or until what time to wait
+ * @slack: how much slack that may be applied to the delay
+ *
+ * kfence_await_hrtimer() causes the @fence to wait for a a period of time, or
+ * until a certain point in time. It is a convenience wrapper around
+ * hrtimer_start_range_ns(). For more details on @clock, @mode, @delay and
+ * @slack please consult the hrtimer documentation.
+ *
+ * Returns 1 if the delay was sucessfuly added to the @fence, or a negative
+ * error code on failure.
+ */
+int kfence_await_hrtimer(struct kfence *fence,
+			 clockid_t clock, enum hrtimer_mode mode,
+			 ktime_t delay, u64 slack,
+			 gfp_t gfp)
+{
+	struct timer_cb *cb;
+
+	cb = kmalloc(sizeof(*cb), gfp);
+	if (!cb)
+		return -ENOMEM;
+
+	cb->fence = kfence_get(fence);
+	kfence_await(fence);
+
+	hrtimer_init(&cb->timer, clock, mode);
+	cb->timer.function = timer_kfence_wake;
+
+	hrtimer_start_range_ns(&cb->timer, delay, slack, mode);
+	return 1;
+}
+EXPORT_SYMBOL_GPL(kfence_await_hrtimer);
diff --git a/lib/test-kfence.c b/lib/test-kfence.c
index b40719fce967..1b0853fda7c3 100644
--- a/lib/test-kfence.c
+++ b/lib/test-kfence.c
@@ -352,6 +352,44 @@ static int __init test_completion(void)
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
+	fence = alloc_kfence();
+	if (!fence)
+		return -ENOMEM;
+
+	delay = ktime_get();
+
+	ret = kfence_await_hrtimer(fence, CLOCK_MONOTONIC, HRTIMER_MODE_REL,
+				   ms_to_ktime(1), 1 << 10,
+				   GFP_KERNEL);
+	if (ret < 0)
+		return ret;
+	if (ret == 0)
+		return -EINVAL;
+
+	kfence_complete(fence);
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
@@ -522,6 +560,12 @@ static int __init test_kfence_init(void)
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

