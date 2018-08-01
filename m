Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:43338 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbeHAXii (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 1 Aug 2018 19:38:38 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, kernel@collabora.com,
        paul.kocialkowski@bootlin.com, maxime.ripard@bootlin.com,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH v3 3/4] v4l2-mem2mem: Avoid calling .device_run in v4l2_m2m_job_finish
Date: Wed,  1 Aug 2018 18:50:25 -0300
Message-Id: <20180801215026.27809-4-ezequiel@collabora.com>
In-Reply-To: <20180801215026.27809-1-ezequiel@collabora.com>
References: <20180801215026.27809-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v4l2_m2m_job_finish() is typically called in interrupt context.

Some implementation of .device_run might sleep, and so it's
desirable to avoid calling it directly from
v4l2_m2m_job_finish(), thus avoiding .device_run from running
in interrupt context.

Implement a deferred context that calls v4l2_m2m_try_run,
and gets scheduled by v4l2_m2m_job_finish().

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 drivers/media/v4l2-core/v4l2-mem2mem.c | 36 +++++++++++++++++++++++---
 1 file changed, 33 insertions(+), 3 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
index da82d151dd20..0bf4deefa899 100644
--- a/drivers/media/v4l2-core/v4l2-mem2mem.c
+++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
@@ -69,6 +69,7 @@ static const char * const m2m_entity_name[] = {
  * @curr_ctx:		currently running instance
  * @job_queue:		instances queued to run
  * @job_spinlock:	protects job_queue
+ * @job_work:		worker to run queued jobs.
  * @m2m_ops:		driver callbacks
  */
 struct v4l2_m2m_dev {
@@ -85,6 +86,7 @@ struct v4l2_m2m_dev {
 
 	struct list_head	job_queue;
 	spinlock_t		job_spinlock;
+	struct work_struct	job_work;
 
 	const struct v4l2_m2m_ops *m2m_ops;
 };
@@ -224,10 +226,11 @@ EXPORT_SYMBOL(v4l2_m2m_get_curr_priv);
 /**
  * v4l2_m2m_try_run() - select next job to perform and run it if possible
  * @m2m_dev: per-device context
+ * @try_lock: indicates if the queue lock should be taken
  *
  * Get next transaction (if present) from the waiting jobs list and run it.
  */
-static void v4l2_m2m_try_run(struct v4l2_m2m_dev *m2m_dev)
+static void v4l2_m2m_try_run(struct v4l2_m2m_dev *m2m_dev, bool try_lock)
 {
 	unsigned long flags;
 
@@ -250,7 +253,20 @@ static void v4l2_m2m_try_run(struct v4l2_m2m_dev *m2m_dev)
 	spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags);
 
 	dprintk("Running job on m2m_ctx: %p\n", m2m_dev->curr_ctx);
+
+	/*
+	 * A m2m context lock is taken only after a m2m context
+	 * is picked from the queue and marked as running.
+	 * The lock is only needed if v4l2_m2m_try_run is called
+	 * from the async worker.
+	 */
+	if (try_lock && m2m_dev->curr_ctx->q_lock)
+		mutex_lock(m2m_dev->curr_ctx->q_lock);
+
 	m2m_dev->m2m_ops->device_run(m2m_dev->curr_ctx->priv);
+
+	if (try_lock && m2m_dev->curr_ctx->q_lock)
+		mutex_unlock(m2m_dev->curr_ctx->q_lock);
 }
 
 /*
@@ -340,10 +356,22 @@ void v4l2_m2m_try_schedule(struct v4l2_m2m_ctx *m2m_ctx)
 	struct v4l2_m2m_dev *m2m_dev = m2m_ctx->m2m_dev;
 
 	__v4l2_m2m_try_queue(m2m_dev, m2m_ctx);
-	v4l2_m2m_try_run(m2m_dev);
+	v4l2_m2m_try_run(m2m_dev, false);
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_try_schedule);
 
+/**
+ * v4l2_m2m_device_run_work() - run pending jobs for the context
+ * @work: Work structure used for scheduling the execution of this function.
+ */
+static void v4l2_m2m_device_run_work(struct work_struct *work)
+{
+	struct v4l2_m2m_dev *m2m_dev =
+		container_of(work, struct v4l2_m2m_dev, job_work);
+
+	v4l2_m2m_try_run(m2m_dev, true);
+}
+
 /**
  * v4l2_m2m_cancel_job() - cancel pending jobs for the context
  * @m2m_ctx: m2m context with jobs to be canceled
@@ -403,7 +431,8 @@ void v4l2_m2m_job_finish(struct v4l2_m2m_dev *m2m_dev,
 	/* This instance might have more buffers ready, but since we do not
 	 * allow more than one job on the job_queue per instance, each has
 	 * to be scheduled separately after the previous one finishes. */
-	v4l2_m2m_try_schedule(m2m_ctx);
+	__v4l2_m2m_try_queue(m2m_dev, m2m_ctx);
+	schedule_work(&m2m_dev->job_work);
 }
 EXPORT_SYMBOL(v4l2_m2m_job_finish);
 
@@ -837,6 +866,7 @@ struct v4l2_m2m_dev *v4l2_m2m_init(const struct v4l2_m2m_ops *m2m_ops)
 	m2m_dev->m2m_ops = m2m_ops;
 	INIT_LIST_HEAD(&m2m_dev->job_queue);
 	spin_lock_init(&m2m_dev->job_spinlock);
+	INIT_WORK(&m2m_dev->job_work, v4l2_m2m_device_run_work);
 
 	return m2m_dev;
 }
-- 
2.18.0
