Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:59987 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756466Ab3HMGyT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Aug 2013 02:54:19 -0400
Received: by mail-pd0-f170.google.com with SMTP id x10so4500500pdj.15
        for <linux-media@vger.kernel.org>; Mon, 12 Aug 2013 23:54:18 -0700 (PDT)
From: Shaik Ameer Basha <shaik.ameer@samsung.com>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, posciak@google.com
Subject: [PATCH] [media] v4l2-mem2mem: clear m2m context from job_queue before ctx streamoff
Date: Tue, 13 Aug 2013 12:28:07 +0530
Message-Id: <1376377087-19473-1-git-send-email-shaik.ameer@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When streamoff is called on the context and the context
is added to the job_queue,
1] sometimes device_run receives the empty vb2 buffers (as
   v4l2_m2m_streamoff is dropping the ready queue).
2] sometimes v4l2_m2m_job_finish may not succeed as the m2m_dev->curr_ctx
   is made NULL in the v4l2_m2m_streamoff()

The above points may stop the execution of the other queued contexts.
This patch makes sure that before streamoff is executed on any context,
that context should "not be running" or "not queued" in the job_queue.
1] If the current context is running, then abort job will be called.
2] If the current context is queued, then the context will be removed from
   the job_queue.

Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
---
 drivers/media/v4l2-core/v4l2-mem2mem.c |   59 ++++++++++++++++++++------------
 1 file changed, 38 insertions(+), 21 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
index 89b9067..7c43712 100644
--- a/drivers/media/v4l2-core/v4l2-mem2mem.c
+++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
@@ -266,6 +266,39 @@ static void v4l2_m2m_try_schedule(struct v4l2_m2m_ctx *m2m_ctx)
 }
 
 /**
+ * v4l2_m2m_cancel_job() - cancel pending jobs for the context
+ *
+ * In case of streamoff or release called on any context,
+ * 1] If the context is currently running, then abort job will be called
+ * 2] If the context is queued, then the context will be removed from
+ *    the job_queue
+ */
+static void v4l2_m2m_cancel_job(struct v4l2_m2m_ctx *m2m_ctx)
+{
+	struct v4l2_m2m_dev *m2m_dev;
+	unsigned long flags;
+
+	m2m_dev = m2m_ctx->m2m_dev;
+	spin_lock_irqsave(&m2m_dev->job_spinlock, flags);
+	if (m2m_ctx->job_flags & TRANS_RUNNING) {
+		spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags);
+		m2m_dev->m2m_ops->job_abort(m2m_ctx->priv);
+		dprintk("m2m_ctx %p running, will wait to complete", m2m_ctx);
+		wait_event(m2m_ctx->finished,
+				!(m2m_ctx->job_flags & TRANS_RUNNING));
+	} else if (m2m_ctx->job_flags & TRANS_QUEUED) {
+		list_del(&m2m_ctx->queue);
+		m2m_ctx->job_flags &= ~(TRANS_QUEUED | TRANS_RUNNING);
+		spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags);
+		dprintk("m2m_ctx: %p had been on queue and was removed\n",
+			m2m_ctx);
+	} else {
+		/* Do nothing, was not on queue/running */
+		spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags);
+	}
+}
+
+/**
  * v4l2_m2m_job_finish() - inform the framework that a job has been finished
  * and have it clean up
  *
@@ -436,6 +469,9 @@ int v4l2_m2m_streamoff(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 	unsigned long flags_job, flags;
 	int ret;
 
+	/* wait until the current context is dequeued from job_queue */
+	v4l2_m2m_cancel_job(m2m_ctx);
+
 	q_ctx = get_queue_ctx(m2m_ctx, type);
 	ret = vb2_streamoff(&q_ctx->q, type);
 	if (ret)
@@ -658,27 +694,8 @@ EXPORT_SYMBOL_GPL(v4l2_m2m_ctx_init);
  */
 void v4l2_m2m_ctx_release(struct v4l2_m2m_ctx *m2m_ctx)
 {
-	struct v4l2_m2m_dev *m2m_dev;
-	unsigned long flags;
-
-	m2m_dev = m2m_ctx->m2m_dev;
-
-	spin_lock_irqsave(&m2m_dev->job_spinlock, flags);
-	if (m2m_ctx->job_flags & TRANS_RUNNING) {
-		spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags);
-		m2m_dev->m2m_ops->job_abort(m2m_ctx->priv);
-		dprintk("m2m_ctx %p running, will wait to complete", m2m_ctx);
-		wait_event(m2m_ctx->finished, !(m2m_ctx->job_flags & TRANS_RUNNING));
-	} else if (m2m_ctx->job_flags & TRANS_QUEUED) {
-		list_del(&m2m_ctx->queue);
-		m2m_ctx->job_flags &= ~(TRANS_QUEUED | TRANS_RUNNING);
-		spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags);
-		dprintk("m2m_ctx: %p had been on queue and was removed\n",
-			m2m_ctx);
-	} else {
-		/* Do nothing, was not on queue/running */
-		spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags);
-	}
+	/* wait until the current context is dequeued from job_queue */
+	v4l2_m2m_cancel_job(m2m_ctx);
 
 	vb2_queue_release(&m2m_ctx->cap_q_ctx.q);
 	vb2_queue_release(&m2m_ctx->out_q_ctx.q);
-- 
1.7.9.5

