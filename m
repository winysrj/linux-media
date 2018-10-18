Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:55678 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729794AbeJSCEr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 Oct 2018 22:04:47 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, kernel@collabora.com,
        paul.kocialkowski@bootlin.com, maxime.ripard@bootlin.com,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH v5 3/5] v4l2-mem2mem: Simplify exiting the function in __v4l2_m2m_try_schedule
Date: Thu, 18 Oct 2018 15:02:22 -0300
Message-Id: <20181018180224.3392-4-ezequiel@collabora.com>
In-Reply-To: <20181018180224.3392-1-ezequiel@collabora.com>
References: <20181018180224.3392-1-ezequiel@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@linux.intel.com>

The __v4l2_m2m_try_schedule function acquires and releases multiple
spinlocks. Simplify unlocking the job lock by adding labels to unlock
the lock and exit the function.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 drivers/media/v4l2-core/v4l2-mem2mem.c | 29 ++++++++++++--------------
 1 file changed, 13 insertions(+), 16 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
index bc72243eb91d..0665a97ed89e 100644
--- a/drivers/media/v4l2-core/v4l2-mem2mem.c
+++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
@@ -297,51 +297,48 @@ static void __v4l2_m2m_try_queue(struct v4l2_m2m_dev *m2m_dev,
 
 	/* If the context is aborted then don't schedule it */
 	if (m2m_ctx->job_flags & TRANS_ABORT) {
-		spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags_job);
 		dprintk("Aborted context\n");
-		return;
+		goto job_unlock;
 	}
 
 	if (m2m_ctx->job_flags & TRANS_QUEUED) {
-		spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags_job);
 		dprintk("On job queue already\n");
-		return;
+		goto job_unlock;
 	}
 
 	spin_lock_irqsave(&m2m_ctx->out_q_ctx.rdy_spinlock, flags_out);
 	if (list_empty(&m2m_ctx->out_q_ctx.rdy_queue)
 	    && !m2m_ctx->out_q_ctx.buffered) {
-		spin_unlock_irqrestore(&m2m_ctx->out_q_ctx.rdy_spinlock,
-					flags_out);
-		spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags_job);
 		dprintk("No input buffers available\n");
-		return;
+		goto out_unlock;
 	}
 	spin_lock_irqsave(&m2m_ctx->cap_q_ctx.rdy_spinlock, flags_cap);
 	if (list_empty(&m2m_ctx->cap_q_ctx.rdy_queue)
 	    && !m2m_ctx->cap_q_ctx.buffered) {
-		spin_unlock_irqrestore(&m2m_ctx->cap_q_ctx.rdy_spinlock,
-					flags_cap);
-		spin_unlock_irqrestore(&m2m_ctx->out_q_ctx.rdy_spinlock,
-					flags_out);
-		spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags_job);
 		dprintk("No output buffers available\n");
-		return;
+		goto cap_unlock;
 	}
 	spin_unlock_irqrestore(&m2m_ctx->cap_q_ctx.rdy_spinlock, flags_cap);
 	spin_unlock_irqrestore(&m2m_ctx->out_q_ctx.rdy_spinlock, flags_out);
 
 	if (m2m_dev->m2m_ops->job_ready
 		&& (!m2m_dev->m2m_ops->job_ready(m2m_ctx->priv))) {
-		spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags_job);
 		dprintk("Driver not ready\n");
-		return;
+		goto job_unlock;
 	}
 
 	list_add_tail(&m2m_ctx->queue, &m2m_dev->job_queue);
 	m2m_ctx->job_flags |= TRANS_QUEUED;
 
 	spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags_job);
+	return;
+
+cap_unlock:
+	spin_unlock_irqrestore(&m2m_ctx->cap_q_ctx.rdy_spinlock, flags_cap);
+out_unlock:
+	spin_unlock_irqrestore(&m2m_ctx->out_q_ctx.rdy_spinlock, flags_out);
+job_unlock:
+	spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags_job);
 }
 
 /**
-- 
2.19.1
