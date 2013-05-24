Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:40359 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757810Ab3EXAmL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 May 2013 20:42:11 -0400
Received: by mail-ye0-f201.google.com with SMTP id q9so106781yen.4
        for <linux-media@vger.kernel.org>; Thu, 23 May 2013 17:42:10 -0700 (PDT)
From: John Sheu <sheu@google.com>
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, pawel@osciak.com, John Sheu <sheu@google.com>
Subject: [PATCH] [media] v4l2: mem2mem: save irq flags correctly
Date: Thu, 23 May 2013 17:41:48 -0700
Message-Id: <1369356108-15865-1-git-send-email-sheu@google.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Save flags correctly when taking spinlocks in v4l2_m2m_try_schedule.

Signed-off-by: John Sheu <sheu@google.com>
---
 drivers/media/v4l2-core/v4l2-mem2mem.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
index 66f599f..3606ff2 100644
--- a/drivers/media/v4l2-core/v4l2-mem2mem.c
+++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
@@ -205,7 +205,7 @@ static void v4l2_m2m_try_run(struct v4l2_m2m_dev *m2m_dev)
 static void v4l2_m2m_try_schedule(struct v4l2_m2m_ctx *m2m_ctx)
 {
 	struct v4l2_m2m_dev *m2m_dev;
-	unsigned long flags_job, flags;
+	unsigned long flags_job, flags_out, flags_cap;
 
 	m2m_dev = m2m_ctx->m2m_dev;
 	dprintk("Trying to schedule a job for m2m_ctx: %p\n", m2m_ctx);
@@ -223,23 +223,26 @@ static void v4l2_m2m_try_schedule(struct v4l2_m2m_ctx *m2m_ctx)
 		return;
 	}
 
-	spin_lock_irqsave(&m2m_ctx->out_q_ctx.rdy_spinlock, flags);
+	spin_lock_irqsave(&m2m_ctx->out_q_ctx.rdy_spinlock, flags_out);
 	if (list_empty(&m2m_ctx->out_q_ctx.rdy_queue)) {
-		spin_unlock_irqrestore(&m2m_ctx->out_q_ctx.rdy_spinlock, flags);
+		spin_unlock_irqrestore(&m2m_ctx->out_q_ctx.rdy_spinlock,
+					flags_out);
 		spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags_job);
 		dprintk("No input buffers available\n");
 		return;
 	}
-	spin_lock_irqsave(&m2m_ctx->cap_q_ctx.rdy_spinlock, flags);
+	spin_lock_irqsave(&m2m_ctx->cap_q_ctx.rdy_spinlock, flags_cap);
 	if (list_empty(&m2m_ctx->cap_q_ctx.rdy_queue)) {
-		spin_unlock_irqrestore(&m2m_ctx->cap_q_ctx.rdy_spinlock, flags);
-		spin_unlock_irqrestore(&m2m_ctx->out_q_ctx.rdy_spinlock, flags);
+		spin_unlock_irqrestore(&m2m_ctx->cap_q_ctx.rdy_spinlock,
+					flags_cap);
+		spin_unlock_irqrestore(&m2m_ctx->out_q_ctx.rdy_spinlock,
+					flags_out);
 		spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags_job);
 		dprintk("No output buffers available\n");
 		return;
 	}
-	spin_unlock_irqrestore(&m2m_ctx->cap_q_ctx.rdy_spinlock, flags);
-	spin_unlock_irqrestore(&m2m_ctx->out_q_ctx.rdy_spinlock, flags);
+	spin_unlock_irqrestore(&m2m_ctx->cap_q_ctx.rdy_spinlock, flags_cap);
+	spin_unlock_irqrestore(&m2m_ctx->out_q_ctx.rdy_spinlock, flags_out);
 
 	if (m2m_dev->m2m_ops->job_ready
 		&& (!m2m_dev->m2m_ops->job_ready(m2m_ctx->priv))) {
-- 
1.8.2.1

