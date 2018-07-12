Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:57418 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726703AbeGLPxl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Jul 2018 11:53:41 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, kernel@collabora.com,
        paul.kocialkowski@bootlin.com, maxime.ripard@bootlin.com,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH 2/2] v4l2-mem2mem: Avoid calling .device_run in v4l2_m2m_job_finish
Date: Thu, 12 Jul 2018 12:43:22 -0300
Message-Id: <20180712154322.30237-3-ezequiel@collabora.com>
In-Reply-To: <20180712154322.30237-1-ezequiel@collabora.com>
References: <20180712154322.30237-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v4l2_m2m_job_finish() is typically called in interrupt context.

Some implementation of .device_run might sleep, and so it's
desirable to avoid calling it directly from
v4l2_m2m_job_finish(), thus avoiding .device_run from running
in interrupt context.

Implement a deferred context that gets scheduled by
v4l2_m2m_job_finish().

The worker calls v4l2_m2m_try_schedule(), which makes sure
a single job is running at the same time, so it's safe to
call it from different executions context.

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 drivers/media/v4l2-core/v4l2-mem2mem.c | 14 +++++++++++++-
 include/media/v4l2-mem2mem.h           |  2 ++
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
index c2e9c2b7dcd1..1d0e20809ffe 100644
--- a/drivers/media/v4l2-core/v4l2-mem2mem.c
+++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
@@ -258,6 +258,17 @@ void v4l2_m2m_try_schedule(struct v4l2_m2m_ctx *m2m_ctx)
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_try_schedule);
 
+/**
+ * v4l2_m2m_try_schedule_work() - run pending jobs for the context
+ * @work: Work structure used for scheduling the execution of this function.
+ */
+static void v4l2_m2m_try_schedule_work(struct work_struct *work)
+{
+	struct v4l2_m2m_ctx *m2m_ctx =
+		container_of(work, struct v4l2_m2m_ctx, job_work);
+	v4l2_m2m_try_schedule(m2m_ctx);
+}
+
 /**
  * v4l2_m2m_cancel_job() - cancel pending jobs for the context
  * @m2m_ctx: m2m context with jobs to be canceled
@@ -316,7 +327,7 @@ void v4l2_m2m_job_finish(struct v4l2_m2m_dev *m2m_dev,
 	/* This instance might have more buffers ready, but since we do not
 	 * allow more than one job on the job_queue per instance, each has
 	 * to be scheduled separately after the previous one finishes. */
-	v4l2_m2m_try_schedule(m2m_ctx);
+	schedule_work(&m2m_ctx->job_work);
 }
 EXPORT_SYMBOL(v4l2_m2m_job_finish);
 
@@ -614,6 +625,7 @@ struct v4l2_m2m_ctx *v4l2_m2m_ctx_init(struct v4l2_m2m_dev *m2m_dev,
 	m2m_ctx->priv = drv_priv;
 	m2m_ctx->m2m_dev = m2m_dev;
 	init_waitqueue_head(&m2m_ctx->finished);
+	INIT_WORK(&m2m_ctx->job_work, v4l2_m2m_try_schedule_work);
 
 	out_q_ctx = &m2m_ctx->out_q_ctx;
 	cap_q_ctx = &m2m_ctx->cap_q_ctx;
diff --git a/include/media/v4l2-mem2mem.h b/include/media/v4l2-mem2mem.h
index 3d07ba3a8262..2543fbfdd2b1 100644
--- a/include/media/v4l2-mem2mem.h
+++ b/include/media/v4l2-mem2mem.h
@@ -89,6 +89,7 @@ struct v4l2_m2m_queue_ctx {
  * @job_flags: Job queue flags, used internally by v4l2-mem2mem.c:
  *		%TRANS_QUEUED, %TRANS_RUNNING and %TRANS_ABORT.
  * @finished: Wait queue used to signalize when a job queue finished.
+ * @job_work: Worker to run queued jobs.
  * @priv: Instance private data
  *
  * The memory to memory context is specific to a file handle, NOT to e.g.
@@ -109,6 +110,7 @@ struct v4l2_m2m_ctx {
 	struct list_head		queue;
 	unsigned long			job_flags;
 	wait_queue_head_t		finished;
+	struct work_struct		job_work;
 
 	void				*priv;
 };
-- 
2.18.0.rc2
