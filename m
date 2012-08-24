Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49321 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759797Ab2HXQSK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Aug 2012 12:18:10 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Javier Martin <javier.martin@vista-silicon.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Richard Zhao <richard.zhao@linaro.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 07/12] media: coda: stop all queues in case of lockup
Date: Fri, 24 Aug 2012 18:17:53 +0200
Message-Id: <1345825078-3688-8-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1345825078-3688-1-git-send-email-p.zabel@pengutronix.de>
References: <1345825078-3688-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a 1 second timeout for each PIC_RUN command to the CODA. In
case it locks up, stop all queues and dequeue remaining buffers.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/video/coda.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/media/video/coda.c b/drivers/media/video/coda.c
index 831cd37..e2c4585 100644
--- a/drivers/media/video/coda.c
+++ b/drivers/media/video/coda.c
@@ -139,6 +139,7 @@ struct coda_dev {
 	struct vb2_alloc_ctx	*alloc_ctx;
 	struct list_head	instances;
 	unsigned long		instance_mask;
+	struct delayed_work	timeout;
 };
 
 struct coda_params {
@@ -730,6 +731,9 @@ static void coda_device_run(void *m2m_priv)
 				CODA7_REG_BIT_AXI_SRAM_USE);
 	}
 
+	/* 1 second timeout in case CODA locks up */
+	schedule_delayed_work(&dev->timeout, HZ);
+
 	coda_command_async(ctx, CODA_COMMAND_PIC_RUN);
 }
 
@@ -1500,6 +1504,8 @@ static irqreturn_t coda_irq_handler(int irq, void *data)
 	u32 wr_ptr, start_ptr;
 	struct coda_ctx *ctx;
 
+	__cancel_delayed_work(&dev->timeout);
+
 	/* read status register to attend the IRQ */
 	coda_read(dev, CODA_REG_BIT_INT_STATUS);
 	coda_write(dev, CODA_REG_BIT_INT_CLEAR_SET,
@@ -1572,6 +1578,20 @@ static irqreturn_t coda_irq_handler(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
+void coda_timeout(struct work_struct *work)
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
@@ -1844,6 +1864,7 @@ static int __devinit coda_probe(struct platform_device *pdev)
 
 	spin_lock_init(&dev->irqlock);
 	INIT_LIST_HEAD(&dev->instances);
+	INIT_DELAYED_WORK(&dev->timeout, coda_timeout);
 
 	dev->plat_dev = pdev;
 	dev->clk_per = devm_clk_get(&pdev->dev, "per");
-- 
1.7.10.4

