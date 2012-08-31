Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36994 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179Ab2HaIL1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Aug 2012 04:11:27 -0400
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
Subject: [PATCH v3 07/16] media: coda: stop all queues in case of lockup
Date: Fri, 31 Aug 2012 10:11:01 +0200
Message-Id: <1346400670-16002-8-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1346400670-16002-1-git-send-email-p.zabel@pengutronix.de>
References: <1346400670-16002-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a 1 second timeout for each PIC_RUN command to the CODA. In
case it locks up, stop all queues and dequeue remaining buffers.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
Changes since v2:
 - Call cancel_delayed_work in coda_stop_streaming instead of coda_irq_handler.
---
 drivers/media/platform/coda.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index 7bc2d87..6e3f026 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -137,6 +137,7 @@ struct coda_dev {
 	struct vb2_alloc_ctx	*alloc_ctx;
 	struct list_head	instances;
 	unsigned long		instance_mask;
+	struct delayed_work	timeout;
 };
 
 struct coda_params {
@@ -723,6 +724,9 @@ static void coda_device_run(void *m2m_priv)
 				CODA7_REG_BIT_AXI_SRAM_USE);
 	}
 
+	/* 1 second timeout in case CODA locks up */
+	schedule_delayed_work(&dev->timeout, HZ);
+
 	coda_command_async(ctx, CODA_COMMAND_PIC_RUN);
 }
 
@@ -1221,6 +1225,8 @@ static int coda_stop_streaming(struct vb2_queue *q)
 	}
 
 	if (!ctx->rawstreamon && !ctx->compstreamon) {
+		cancel_delayed_work(&dev->timeout);
+
 		v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
 			 "%s: sent command 'SEQ_END' to coda\n", __func__);
 		if (coda_command_sync(ctx, CODA_COMMAND_SEQ_END)) {
@@ -1565,6 +1571,20 @@ static irqreturn_t coda_irq_handler(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
+static void coda_timeout(struct work_struct *work)
+{
+	struct coda_ctx *ctx;
+	struct coda_dev *dev = container_of(to_delayed_work(work),
+					    struct coda_dev, timeout);
+
+	v4l2_err(&dev->v4l2_dev, "CODA PIC_RUN timeout, stopping all streams\n");
+
+	list_for_each_entry(ctx, &dev->instances, list) {
+		v4l2_m2m_streamoff(NULL, ctx->m2m_ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
+		v4l2_m2m_streamoff(NULL, ctx->m2m_ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
+	}
+}
+
 static u32 coda_supported_firmwares[] = {
 	CODA_FIRMWARE_VERNUM(CODA_DX6, 2, 2, 5),
 	CODA_FIRMWARE_VERNUM(CODA_7541, 13, 4, 29),
@@ -1836,6 +1856,7 @@ static int __devinit coda_probe(struct platform_device *pdev)
 
 	spin_lock_init(&dev->irqlock);
 	INIT_LIST_HEAD(&dev->instances);
+	INIT_DELAYED_WORK(&dev->timeout, coda_timeout);
 
 	dev->plat_dev = pdev;
 	dev->clk_per = devm_clk_get(&pdev->dev, "per");
-- 
1.7.10.4

