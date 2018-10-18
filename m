Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:55684 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729137AbeJSCEu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 Oct 2018 22:04:50 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, kernel@collabora.com,
        paul.kocialkowski@bootlin.com, maxime.ripard@bootlin.com,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH v5 4/5] v4l2-mem2mem: Avoid calling .device_run in v4l2_m2m_job_finish
Date: Thu, 18 Oct 2018 15:02:23 -0300
Message-Id: <20181018180224.3392-5-ezequiel@collabora.com>
In-Reply-To: <20181018180224.3392-1-ezequiel@collabora.com>
References: <20181018180224.3392-1-ezequiel@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v4l2_m2m_job_finish() is typically called when
DMA operations complete, in interrupt handlers or DMA
completion callbacks. Calling .device_run from v4l2_m2m_job_finish
creates a nasty re-entrancy path into the driver.

Moreover, some implementation of .device_run might need to sleep,
as is the case for drivers supporting the Request API,
where controls are applied via v4l2_ctrl_request_setup,
which takes the ctrl handler mutex.

This commit adds a deferred context that calls v4l2_m2m_try_run,
and gets scheduled by v4l2_m2m_job_finish().

Before this change, device_run would be called from these
paths:

vb2_m2m_request_queue, or
v4l2_m2m_streamon, or
v4l2_m2m_qbuf
  v4l2_m2m_try_schedule
    v4l2_m2m_try_run
      .device_run

v4l2_m2m_job_finish
  v4l2_m2m_try_run
    .device_run

After this change, the latter is now gone and instead:

v4l2_m2m_device_run_work
  v4l2_m2m_try_run
    .device_run

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 drivers/media/v4l2-core/v4l2-mem2mem.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
index 0665a97ed89e..2b250fd10531 100644
--- a/drivers/media/v4l2-core/v4l2-mem2mem.c
+++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
@@ -87,6 +87,7 @@ static const char * const m2m_entity_name[] = {
  * @curr_ctx:		currently running instance
  * @job_queue:		instances queued to run
  * @job_spinlock:	protects job_queue
+ * @job_work:		worker to run queued jobs.
  * @m2m_ops:		driver callbacks
  */
 struct v4l2_m2m_dev {
@@ -103,6 +104,7 @@ struct v4l2_m2m_dev {
 
 	struct list_head	job_queue;
 	spinlock_t		job_spinlock;
+	struct work_struct	job_work;
 
 	const struct v4l2_m2m_ops *m2m_ops;
 };
@@ -244,6 +246,9 @@ EXPORT_SYMBOL(v4l2_m2m_get_curr_priv);
  * @m2m_dev: per-device context
  *
  * Get next transaction (if present) from the waiting jobs list and run it.
+ *
+ * Note that this function can run on a given v4l2_m2m_ctx context,
+ * but call .device_run for another context.
  */
 static void v4l2_m2m_try_run(struct v4l2_m2m_dev *m2m_dev)
 {
@@ -362,6 +367,18 @@ void v4l2_m2m_try_schedule(struct v4l2_m2m_ctx *m2m_ctx)
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
+	v4l2_m2m_try_run(m2m_dev);
+}
+
 /**
  * v4l2_m2m_cancel_job() - cancel pending jobs for the context
  * @m2m_ctx: m2m context with jobs to be canceled
@@ -421,7 +438,12 @@ void v4l2_m2m_job_finish(struct v4l2_m2m_dev *m2m_dev,
 	/* This instance might have more buffers ready, but since we do not
 	 * allow more than one job on the job_queue per instance, each has
 	 * to be scheduled separately after the previous one finishes. */
-	v4l2_m2m_try_schedule(m2m_ctx);
+	__v4l2_m2m_try_queue(m2m_dev, m2m_ctx);
+
+	/* We might be running in atomic context,
+	 * but the job must be run in non-atomic context.
+	 */
+	schedule_work(&m2m_dev->job_work);
 }
 EXPORT_SYMBOL(v4l2_m2m_job_finish);
 
@@ -863,6 +885,7 @@ struct v4l2_m2m_dev *v4l2_m2m_init(const struct v4l2_m2m_ops *m2m_ops)
 	m2m_dev->m2m_ops = m2m_ops;
 	INIT_LIST_HEAD(&m2m_dev->job_queue);
 	spin_lock_init(&m2m_dev->job_spinlock);
+	INIT_WORK(&m2m_dev->job_work, v4l2_m2m_device_run_work);
 
 	return m2m_dev;
 }
-- 
2.19.1
