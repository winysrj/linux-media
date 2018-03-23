Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:16841 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752201AbeCWVS2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Mar 2018 17:18:28 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, acourbot@chromium.org
Subject: [RFC v2 07/10] v4l: m2m: Simplify exiting the function in v4l2_m2m_try_schedule
Date: Fri, 23 Mar 2018 23:17:41 +0200
Message-Id: <1521839864-10146-8-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1521839864-10146-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1521839864-10146-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The v4l2_m2m_try_schedule function acquires and releases multiple
spinlocks; simplify unlocking the job lock by adding a label to unlock the
job lock and exit the function.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-mem2mem.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
index c4f963d..9fbf778 100644
--- a/drivers/media/v4l2-core/v4l2-mem2mem.c
+++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
@@ -230,15 +230,13 @@ void v4l2_m2m_try_schedule(struct v4l2_m2m_ctx *m2m_ctx)
 
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
@@ -246,9 +244,8 @@ void v4l2_m2m_try_schedule(struct v4l2_m2m_ctx *m2m_ctx)
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
@@ -257,18 +254,16 @@ void v4l2_m2m_try_schedule(struct v4l2_m2m_ctx *m2m_ctx)
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
@@ -277,6 +272,13 @@ void v4l2_m2m_try_schedule(struct v4l2_m2m_ctx *m2m_ctx)
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
2.7.4
