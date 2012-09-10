Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47396 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753746Ab2IJPaO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Sep 2012 11:30:14 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Javier Martin <javier.martin@vista-silicon.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Richard Zhao <richard.zhao@freescale.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v4 09/16] media: coda: wait for picture run completion in start/stop_streaming
Date: Mon, 10 Sep 2012 17:29:53 +0200
Message-Id: <1347291000-340-10-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1347291000-340-1-git-send-email-p.zabel@pengutronix.de>
References: <1347291000-340-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While the CODA is running a PIC_RUN command, its registers are
not to be touched.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
Changes since v3:
 - Complete dev->done in coda_timeout.
---
 drivers/media/platform/coda.c |   42 ++++++++++++++++++++++++++++++++---------
 1 file changed, 33 insertions(+), 9 deletions(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index e0595ce..fe8a397 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -137,6 +137,7 @@ struct coda_dev {
 	struct list_head	instances;
 	unsigned long		instance_mask;
 	struct delayed_work	timeout;
+	struct completion	done;
 };
 
 struct coda_params {
@@ -726,6 +727,7 @@ static void coda_device_run(void *m2m_priv)
 	/* 1 second timeout in case CODA locks up */
 	schedule_delayed_work(&dev->timeout, HZ);
 
+	INIT_COMPLETION(dev->done);
 	coda_command_async(ctx, CODA_COMMAND_PIC_RUN);
 }
 
@@ -970,6 +972,10 @@ static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
 	if (!(ctx->rawstreamon & ctx->compstreamon))
 		return 0;
 
+	if (coda_isbusy(dev))
+		if (wait_for_completion_interruptible_timeout(&dev->done, HZ) <= 0)
+			return -EBUSY;
+
 	ctx->gopcounter = ctx->params.gop_size - 1;
 
 	q_data_src = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
@@ -1224,20 +1230,29 @@ static int coda_stop_streaming(struct vb2_queue *q)
 		ctx->compstreamon = 0;
 	}
 
-	if (!ctx->rawstreamon && !ctx->compstreamon) {
-		cancel_delayed_work(&dev->timeout);
+	/* Don't stop the coda unless both queues are off */
+	if (ctx->rawstreamon || ctx->compstreamon)
+		return 0;
 
-		v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
-			 "%s: sent command 'SEQ_END' to coda\n", __func__);
-		if (coda_command_sync(ctx, CODA_COMMAND_SEQ_END)) {
-			v4l2_err(&ctx->dev->v4l2_dev,
-				 "CODA_COMMAND_SEQ_END failed\n");
-			return -ETIMEDOUT;
+	if (coda_isbusy(dev)) {
+		if (wait_for_completion_interruptible_timeout(&dev->done, HZ) <= 0) {
+			v4l2_warn(&dev->v4l2_dev,
+				  "%s: timeout, sending SEQ_END anyway\n", __func__);
 		}
+	}
+
+	cancel_delayed_work(&dev->timeout);
 
-		coda_free_framebuffers(ctx);
+	v4l2_dbg(1, coda_debug, &dev->v4l2_dev,
+		 "%s: sent command 'SEQ_END' to coda\n", __func__);
+	if (coda_command_sync(ctx, CODA_COMMAND_SEQ_END)) {
+		v4l2_err(&dev->v4l2_dev,
+			 "CODA_COMMAND_SEQ_END failed\n");
+		return -ETIMEDOUT;
 	}
 
+	coda_free_framebuffers(ctx);
+
 	return 0;
 }
 
@@ -1524,6 +1539,8 @@ static irqreturn_t coda_irq_handler(int irq, void *data)
 		return IRQ_NONE;
 	}
 
+	complete(&dev->done);
+
 	src_buf = v4l2_m2m_src_buf_remove(ctx->m2m_ctx);
 	dst_buf = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx);
 
@@ -1579,6 +1596,11 @@ static void coda_timeout(struct work_struct *work)
 	struct coda_dev *dev = container_of(to_delayed_work(work),
 					    struct coda_dev, timeout);
 
+	if (completion_done(&dev->done))
+		return;
+
+	complete(&dev->done);
+
 	v4l2_err(&dev->v4l2_dev, "CODA PIC_RUN timeout, stopping all streams\n");
 
 	mutex_lock(&dev->dev_mutex);
@@ -1861,6 +1883,8 @@ static int __devinit coda_probe(struct platform_device *pdev)
 	spin_lock_init(&dev->irqlock);
 	INIT_LIST_HEAD(&dev->instances);
 	INIT_DELAYED_WORK(&dev->timeout, coda_timeout);
+	init_completion(&dev->done);
+	complete(&dev->done);
 
 	dev->plat_dev = pdev;
 	dev->clk_per = devm_clk_get(&pdev->dev, "per");
-- 
1.7.10.4

