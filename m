Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:44243 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754052AbeGEQDp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Jul 2018 12:03:45 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCHv16 28/34] v4l2-mem2mem: Simplify exiting the function in v4l2_m2m_try_schedule
Date: Thu,  5 Jul 2018 18:03:31 +0200
Message-Id: <20180705160337.54379-29-hverkuil@xs4all.nl>
In-Reply-To: <20180705160337.54379-1-hverkuil@xs4all.nl>
References: <20180705160337.54379-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@linux.intel.com>

The v4l2_m2m_try_schedule function acquires and releases multiple
spinlocks; simplify unlocking the job lock by adding a label to unlock the
job lock and exit the function.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-mem2mem.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
index 9bfe1c456046..114d50cf22c5 100644
--- a/drivers/media/v4l2-core/v4l2-mem2mem.c
+++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
@@ -252,15 +252,13 @@ void v4l2_m2m_try_schedule(struct v4l2_m2m_ctx *m2m_ctx)
 
 	/* If the context is aborted then don't schedule it */
 	if (m2m_ctx->job_flags & TRANS_ABORT) {
-		spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags_job);
 		dprintk("Aborted context\n");
-		return;
+		goto out_unlock;
 	}
 
 	if (m2m_ctx->job_flags & TRANS_QUEUED) {
-		spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags_job);
 		dprintk("On job queue already\n");
-		return;
+		goto out_unlock;
 	}
 
 	spin_lock_irqsave(&m2m_ctx->out_q_ctx.rdy_spinlock, flags_out);
@@ -268,9 +266,8 @@ void v4l2_m2m_try_schedule(struct v4l2_m2m_ctx *m2m_ctx)
 	    && !m2m_ctx->out_q_ctx.buffered) {
 		spin_unlock_irqrestore(&m2m_ctx->out_q_ctx.rdy_spinlock,
 					flags_out);
-		spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags_job);
 		dprintk("No input buffers available\n");
-		return;
+		goto out_unlock;
 	}
 	spin_lock_irqsave(&m2m_ctx->cap_q_ctx.rdy_spinlock, flags_cap);
 	if (list_empty(&m2m_ctx->cap_q_ctx.rdy_queue)
@@ -279,18 +276,16 @@ void v4l2_m2m_try_schedule(struct v4l2_m2m_ctx *m2m_ctx)
 					flags_cap);
 		spin_unlock_irqrestore(&m2m_ctx->out_q_ctx.rdy_spinlock,
 					flags_out);
-		spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags_job);
 		dprintk("No output buffers available\n");
-		return;
+		goto out_unlock;
 	}
 	spin_unlock_irqrestore(&m2m_ctx->cap_q_ctx.rdy_spinlock, flags_cap);
 	spin_unlock_irqrestore(&m2m_ctx->out_q_ctx.rdy_spinlock, flags_out);
 
 	if (m2m_dev->m2m_ops->job_ready
 		&& (!m2m_dev->m2m_ops->job_ready(m2m_ctx->priv))) {
-		spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags_job);
 		dprintk("Driver not ready\n");
-		return;
+		goto out_unlock;
 	}
 
 	list_add_tail(&m2m_ctx->queue, &m2m_dev->job_queue);
@@ -299,6 +294,13 @@ void v4l2_m2m_try_schedule(struct v4l2_m2m_ctx *m2m_ctx)
 	spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags_job);
 
 	v4l2_m2m_try_run(m2m_dev);
+
+	return;
+
+out_unlock:
+	spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags_job);
+
+	return;
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_try_schedule);
 
-- 
2.18.0
