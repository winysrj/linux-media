Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:51238 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752703AbeFREki (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Jun 2018 00:40:38 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, kernel@collabora.com,
        Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kamil Debski <kamil@wypas.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH v2 1/3] rcar_jpu: Remove unrequired wait in .job_abort
Date: Mon, 18 Jun 2018 01:38:50 -0300
Message-Id: <20180618043852.13293-2-ezequiel@collabora.com>
In-Reply-To: <20180618043852.13293-1-ezequiel@collabora.com>
References: <20180618043852.13293-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As per the documentation, job_abort is not required
to wait until the current job finishes. It is redundant
to do so, as the core will perform the wait operation.

Remove the wait infrastructure completely.

Cc: Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>
Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 drivers/media/platform/rcar_jpu.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/media/platform/rcar_jpu.c b/drivers/media/platform/rcar_jpu.c
index 469a326838aa..dec696e6b974 100644
--- a/drivers/media/platform/rcar_jpu.c
+++ b/drivers/media/platform/rcar_jpu.c
@@ -198,7 +198,6 @@
  * @vfd_decoder: video device node for decoder mem2mem mode
  * @m2m_dev: v4l2 mem2mem device data
  * @curr: pointer to current context
- * @irq_queue:	interrupt handler waitqueue
  * @regs: JPEG IP registers mapping
  * @irq: JPEG IP irq
  * @clk: JPEG IP clock
@@ -213,7 +212,6 @@ struct jpu {
 	struct video_device	vfd_decoder;
 	struct v4l2_m2m_dev	*m2m_dev;
 	struct jpu_ctx		*curr;
-	wait_queue_head_t	irq_queue;
 
 	void __iomem		*regs;
 	unsigned int		irq;
@@ -1494,11 +1492,6 @@ static void jpu_device_run(void *priv)
 
 static void jpu_job_abort(void *priv)
 {
-	struct jpu_ctx *ctx = priv;
-
-	if (!wait_event_timeout(ctx->jpu->irq_queue, !ctx->jpu->curr,
-				msecs_to_jiffies(JPU_JOB_TIMEOUT)))
-		jpu_cleanup(ctx, true);
 }
 
 static const struct v4l2_m2m_ops jpu_m2m_ops = {
@@ -1584,9 +1577,6 @@ static irqreturn_t jpu_irq_handler(int irq, void *dev_id)
 
 	v4l2_m2m_job_finish(jpu->m2m_dev, curr_ctx->fh.m2m_ctx);
 
-	/* ...wakeup abort routine if needed */
-	wake_up(&jpu->irq_queue);
-
 	return IRQ_HANDLED;
 
 handled:
@@ -1620,7 +1610,6 @@ static int jpu_probe(struct platform_device *pdev)
 	if (!jpu)
 		return -ENOMEM;
 
-	init_waitqueue_head(&jpu->irq_queue);
 	mutex_init(&jpu->mutex);
 	spin_lock_init(&jpu->lock);
 	jpu->dev = &pdev->dev;
-- 
2.16.3
