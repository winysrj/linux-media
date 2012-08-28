Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48388 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931Ab2H1KyN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Aug 2012 06:54:13 -0400
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
Subject: [PATCH v2 09/14] media: coda: wait for picture run completion in start/stop_streaming
Date: Tue, 28 Aug 2012 12:53:56 +0200
Message-Id: <1346151241-10449-10-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1346151241-10449-1-git-send-email-p.zabel@pengutronix.de>
References: <1346151241-10449-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While the CODA is running a PIC_RUN command, its registers are
not to be touched.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/video/coda.c |   34 +++++++++++++++++++++++++++-------
 1 file changed, 27 insertions(+), 7 deletions(-)

diff --git a/drivers/media/video/coda.c b/drivers/media/video/coda.c
index 3d47935..d41df26 100644
--- a/drivers/media/video/coda.c
+++ b/drivers/media/video/coda.c
@@ -138,6 +138,7 @@ struct coda_dev {
 	struct list_head	instances;
 	unsigned long		instance_mask;
 	struct delayed_work	timeout;
+	struct completion	done;
 };
 
 struct coda_params {
@@ -727,6 +728,7 @@ static void coda_device_run(void *m2m_priv)
 	/* 1 second timeout in case CODA locks up */
 	schedule_delayed_work(&dev->timeout, HZ);
 
+	INIT_COMPLETION(dev->done);
 	coda_command_async(ctx, CODA_COMMAND_PIC_RUN);
 }
 
@@ -971,6 +973,10 @@ static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
 	if (!(ctx->rawstreamon & ctx->compstreamon))
 		return 0;
 
+	if (coda_isbusy(dev))
+		if (wait_for_completion_interruptible_timeout(&dev->done, HZ) <= 0)
+			return -EBUSY;
+
 	ctx->gopcounter = ctx->params.gop_size - 1;
 
 	q_data_src = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
@@ -1213,6 +1219,7 @@ static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
 static int coda_stop_streaming(struct vb2_queue *q)
 {
 	struct coda_ctx *ctx = vb2_get_drv_priv(q);
+	struct coda_dev *dev = ctx->dev;
 
 	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
 		v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
@@ -1224,18 +1231,27 @@ static int coda_stop_streaming(struct vb2_queue *q)
 		ctx->compstreamon = 0;
 	}
 
-	if (!ctx->rawstreamon && !ctx->compstreamon) {
-		v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
-			 "%s: sent command 'SEQ_END' to coda\n", __func__);
-		if (coda_command_sync(ctx, CODA_COMMAND_SEQ_END)) {
-			v4l2_err(&ctx->dev->v4l2_dev,
-				 "CODA_COMMAND_SEQ_END failed\n");
-			return -ETIMEDOUT;
+	/* Don't stop the coda unless both queues are off */
+	if (ctx->rawstreamon || ctx->compstreamon)
+		return 0;
+
+	if (coda_isbusy(dev)) {
+		if (wait_for_completion_interruptible_timeout(&dev->done, HZ) <= 0) {
+			v4l2_warn(&dev->v4l2_dev,
+				  "%s: timeout, sending SEQ_END anyway\n", __func__);
 		}
 
 		coda_free_framebuffers(ctx);
 	}
 
+	v4l2_dbg(1, coda_debug, &dev->v4l2_dev,
+		 "%s: sent command 'SEQ_END' to coda\n", __func__);
+	if (coda_command_sync(ctx, CODA_COMMAND_SEQ_END)) {
+		v4l2_err(&dev->v4l2_dev,
+			 "CODA_COMMAND_SEQ_END failed\n");
+		return -ETIMEDOUT;
+	}
+
 	return 0;
 }
 
@@ -1522,6 +1538,8 @@ static irqreturn_t coda_irq_handler(int irq, void *data)
 		return IRQ_NONE;
 	}
 
+	complete(&dev->done);
+
 	src_buf = v4l2_m2m_src_buf_remove(ctx->m2m_ctx);
 	dst_buf = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx);
 
@@ -1857,6 +1875,8 @@ static int __devinit coda_probe(struct platform_device *pdev)
 	spin_lock_init(&dev->irqlock);
 	INIT_LIST_HEAD(&dev->instances);
 	INIT_DELAYED_WORK(&dev->timeout, coda_timeout);
+	init_completion(&dev->done);
+	complete(&dev->done);
 
 	dev->plat_dev = pdev;
 	dev->clk_per = devm_clk_get(&pdev->dev, "per");
-- 
1.7.10.4

