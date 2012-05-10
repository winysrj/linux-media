Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52737 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756116Ab2EJGpg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 May 2012 02:45:36 -0400
Received: by dady13 with SMTP id y13so1308689dad.19
        for <linux-media@vger.kernel.org>; Wed, 09 May 2012 23:45:36 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, k.debski@samsung.com,
	kyungmin.park@samsung.com, sachin.kamat@linaro.org,
	patches@linaro.org
Subject: [PATCH 1/2] [media] s5p-g2d: Fix NULL pointer warnings in g2d.c file
Date: Thu, 10 May 2012 12:05:47 +0530
Message-Id: <1336631748-25160-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes the following warnings detected by sparse:
warning: Using plain integer as NULL pointer

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/video/s5p-g2d/g2d.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/video/s5p-g2d/g2d.c b/drivers/media/video/s5p-g2d/g2d.c
index 789de74..70bee1c 100644
--- a/drivers/media/video/s5p-g2d/g2d.c
+++ b/drivers/media/video/s5p-g2d/g2d.c
@@ -546,11 +546,11 @@ static void job_abort(void *prv)
 	struct g2d_dev *dev = ctx->dev;
 	int ret;
 
-	if (dev->curr == 0) /* No job currently running */
+	if (dev->curr == NULL) /* No job currently running */
 		return;
 
 	ret = wait_event_timeout(dev->irq_queue,
-		dev->curr == 0,
+		dev->curr == NULL,
 		msecs_to_jiffies(G2D_TIMEOUT));
 }
 
@@ -599,19 +599,19 @@ static irqreturn_t g2d_isr(int irq, void *prv)
 	g2d_clear_int(dev);
 	clk_disable(dev->gate);
 
-	BUG_ON(ctx == 0);
+	BUG_ON(ctx == NULL);
 
 	src = v4l2_m2m_src_buf_remove(ctx->m2m_ctx);
 	dst = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx);
 
-	BUG_ON(src == 0);
-	BUG_ON(dst == 0);
+	BUG_ON(src == NULL);
+	BUG_ON(dst == NULL);
 
 	v4l2_m2m_buf_done(src, VB2_BUF_STATE_DONE);
 	v4l2_m2m_buf_done(dst, VB2_BUF_STATE_DONE);
 	v4l2_m2m_job_finish(dev->m2m_dev, ctx->m2m_ctx);
 
-	dev->curr = 0;
+	dev->curr = NULL;
 	wake_up(&dev->irq_queue);
 	return IRQ_HANDLED;
 }
-- 
1.7.4.1

