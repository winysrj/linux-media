Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50155 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525Ab2GSVQd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Jul 2012 17:16:33 -0400
Date: Thu, 19 Jul 2012 14:16:29 -0700
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
	Andy Walls <awalls@md.metrocast.net>,
	ivtv-devel@ivtvdriver.org, linux-media@vger.kernel.org,
	Grant Likely <grant.likely@secretlab.ca>,
	spi-devel-general@lists.sourceforge.net,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 2/2] kthread_worker: reimplement flush_kthread_work() to
 allow freeing the work item being executed
Message-ID: <20120719211629.GC32763@google.com>
References: <20120719211510.GA32763@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120719211510.GA32763@google.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>From 06f9a06f4aeecdb9d07014713ab41b548ae219b5 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Thu, 19 Jul 2012 13:52:53 -0700

kthread_worker provides minimalistic workqueue-like interface for
users which need a dedicated worker thread (e.g. for realtime
priority).  It has basic queue, flush_work, flush_worker operations
which mostly match the workqueue counterparts; however, due to the way
flush_work() is implemented, it has a noticeable difference of not
allowing work items to be freed while being executed.

While the current users of kthread_worker are okay with the current
behavior, the restriction does impede some valid use cases.  Also,
removing this difference isn't difficult and actually makes the code
easier to understand.

This patch reimplements flush_kthread_work() such that it uses a
flush_work item instead of queue/done sequence numbers.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/kthread.h |    8 +-----
 kernel/kthread.c        |   48 ++++++++++++++++++++++++++--------------------
 2 files changed, 29 insertions(+), 27 deletions(-)

diff --git a/include/linux/kthread.h b/include/linux/kthread.h
index 0714b24..22ccf9d 100644
--- a/include/linux/kthread.h
+++ b/include/linux/kthread.h
@@ -49,8 +49,6 @@ extern int tsk_fork_get_node(struct task_struct *tsk);
  * can be queued and flushed using queue/flush_kthread_work()
  * respectively.  Queued kthread_works are processed by a kthread
  * running kthread_worker_fn().
- *
- * A kthread_work can't be freed while it is executing.
  */
 struct kthread_work;
 typedef void (*kthread_work_func_t)(struct kthread_work *work);
@@ -59,15 +57,14 @@ struct kthread_worker {
 	spinlock_t		lock;
 	struct list_head	work_list;
 	struct task_struct	*task;
+	struct kthread_work	*current_work;
 };
 
 struct kthread_work {
 	struct list_head	node;
 	kthread_work_func_t	func;
 	wait_queue_head_t	done;
-	atomic_t		flushing;
-	int			queue_seq;
-	int			done_seq;
+	struct kthread_worker	*worker;
 };
 
 #define KTHREAD_WORKER_INIT(worker)	{				\
@@ -79,7 +76,6 @@ struct kthread_work {
 	.node = LIST_HEAD_INIT((work).node),				\
 	.func = (fn),							\
 	.done = __WAIT_QUEUE_HEAD_INITIALIZER((work).done),		\
-	.flushing = ATOMIC_INIT(0),					\
 	}
 
 #define DEFINE_KTHREAD_WORKER(worker)					\
diff --git a/kernel/kthread.c b/kernel/kthread.c
index 7b8a678..4034b2b 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -360,16 +360,12 @@ repeat:
 					struct kthread_work, node);
 		list_del_init(&work->node);
 	}
+	worker->current_work = work;
 	spin_unlock_irq(&worker->lock);
 
 	if (work) {
 		__set_current_state(TASK_RUNNING);
 		work->func(work);
-		smp_wmb();	/* wmb worker-b0 paired with flush-b1 */
-		work->done_seq = work->queue_seq;
-		smp_mb();	/* mb worker-b1 paired with flush-b0 */
-		if (atomic_read(&work->flushing))
-			wake_up_all(&work->done);
 	} else if (!freezing(current))
 		schedule();
 
@@ -384,7 +380,7 @@ static void insert_kthread_work(struct kthread_worker *worker,
 			       struct list_head *pos)
 {
 	list_add_tail(&work->node, pos);
-	work->queue_seq++;
+	work->worker = worker;
 	if (likely(worker->task))
 		wake_up_process(worker->task);
 }
@@ -434,25 +430,35 @@ static void kthread_flush_work_fn(struct kthread_work *work)
  */
 void flush_kthread_work(struct kthread_work *work)
 {
-	int seq = work->queue_seq;
+	struct kthread_flush_work fwork = {
+		KTHREAD_WORK_INIT(fwork.work, kthread_flush_work_fn),
+		COMPLETION_INITIALIZER_ONSTACK(fwork.done),
+	};
+	struct kthread_worker *worker;
+	bool noop = false;
+
+retry:
+	worker = work->worker;
+	if (!worker)
+		return;
 
-	atomic_inc(&work->flushing);
+	spin_lock_irq(&worker->lock);
+	if (work->worker != worker) {
+		spin_unlock_irq(&worker->lock);
+		goto retry;
+	}
 
-	/*
-	 * mb flush-b0 paired with worker-b1, to make sure either
-	 * worker sees the above increment or we see done_seq update.
-	 */
-	smp_mb__after_atomic_inc();
+	if (!list_empty(&work->node))
+		insert_kthread_work(worker, &fwork.work, work->node.next);
+	else if (worker->current_work == work)
+		insert_kthread_work(worker, &fwork.work, worker->work_list.next);
+	else
+		noop = true;
 
-	/* A - B <= 0 tests whether B is in front of A regardless of overflow */
-	wait_event(work->done, seq - work->done_seq <= 0);
-	atomic_dec(&work->flushing);
+	spin_unlock_irq(&worker->lock);
 
-	/*
-	 * rmb flush-b1 paired with worker-b0, to make sure our caller
-	 * sees every change made by work->func().
-	 */
-	smp_mb__after_atomic_dec();
+	if (!noop)
+		wait_for_completion(&fwork.done);
 }
 EXPORT_SYMBOL_GPL(flush_kthread_work);
 
-- 
1.7.7.3

