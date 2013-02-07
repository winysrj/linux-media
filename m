Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f201.google.com ([209.85.214.201]:60603 "EHLO
	mail-ob0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757465Ab3BGADj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Feb 2013 19:03:39 -0500
Received: by mail-ob0-f201.google.com with SMTP id un3so387720obb.4
        for <linux-media@vger.kernel.org>; Wed, 06 Feb 2013 16:03:39 -0800 (PST)
From: John Sheu <sheu@google.com>
To: linux-media@vger.kernel.org
Cc: John Sheu <sheu@chromium.org>, John Sheu <sheu@google.com>
Subject: [PATCH 1/3] [media] v4l2-mem2mem: use CAPTURE queue lock
Date: Wed,  6 Feb 2013 16:03:00 -0800
Message-Id: <1360195382-32317-1-git-send-email-sheu@google.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: John Sheu <sheu@chromium.org>

In v4l2_m2m_try_schedule(), use the CAPTURE queue lock when accessing
the CAPTURE queue, instead of relying on just holding the OUTPUT queue
lock.

Signed-off-by: John Sheu <sheu@google.com>
---
 drivers/media/v4l2-core/v4l2-mem2mem.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
index 438ea45..c52a2c5 100644
--- a/drivers/media/v4l2-core/v4l2-mem2mem.c
+++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
@@ -230,12 +230,15 @@ static void v4l2_m2m_try_schedule(struct v4l2_m2m_ctx *m2m_ctx)
 		dprintk("No input buffers available\n");
 		return;
 	}
+	spin_lock_irqsave(&m2m_ctx->cap_q_ctx.rdy_spinlock, flags);
 	if (list_empty(&m2m_ctx->cap_q_ctx.rdy_queue)) {
+		spin_unlock_irqrestore(&m2m_ctx->cap_q_ctx.rdy_spinlock, flags);
 		spin_unlock_irqrestore(&m2m_ctx->out_q_ctx.rdy_spinlock, flags);
 		spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags_job);
 		dprintk("No output buffers available\n");
 		return;
 	}
+	spin_unlock_irqrestore(&m2m_ctx->cap_q_ctx.rdy_spinlock, flags);
 	spin_unlock_irqrestore(&m2m_ctx->out_q_ctx.rdy_spinlock, flags);
 
 	if (m2m_dev->m2m_ops->job_ready
-- 
1.8.1

