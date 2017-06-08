Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:44453 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751871AbdFHIzV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Jun 2017 04:55:21 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        kernel@pengutronix.de, patchwork-lst@pengutronix.de,
        Lucas Stach <l.stach@pengutronix.de>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2 3/3] [media] coda/imx-vdoa: always wait for job completion
Date: Thu,  8 Jun 2017 10:55:13 +0200
Message-Id: <20170608085513.26857-3-p.zabel@pengutronix.de>
In-Reply-To: <20170608085513.26857-1-p.zabel@pengutronix.de>
References: <20170608085513.26857-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Lucas Stach <l.stach@pengutronix.de>

As long as only one CODA context is running we get alternating
device_run() and wait_for_completion() calls, but when more then one
CODA context is active, other VDOA slots can be inserted between those
calls for one context.

Make sure to wait on job completion before running a different context
and before destroying the currently active context.

Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
No changes since v1 [1].

[1] https://patchwork.linuxtv.org/patch/40605
---
 drivers/media/platform/coda/imx-vdoa.c | 49 +++++++++++++++++++++++-----------
 1 file changed, 33 insertions(+), 16 deletions(-)

diff --git a/drivers/media/platform/coda/imx-vdoa.c b/drivers/media/platform/coda/imx-vdoa.c
index 669a4c82f1ffa..df9b71621420c 100644
--- a/drivers/media/platform/coda/imx-vdoa.c
+++ b/drivers/media/platform/coda/imx-vdoa.c
@@ -101,6 +101,8 @@ struct vdoa_ctx {
 	struct vdoa_data	*vdoa;
 	struct completion	completion;
 	struct vdoa_q_data	q_data[2];
+	unsigned int		submitted_job;
+	unsigned int		completed_job;
 };
 
 static irqreturn_t vdoa_irq_handler(int irq, void *data)
@@ -114,7 +116,7 @@ static irqreturn_t vdoa_irq_handler(int irq, void *data)
 
 	curr_ctx = vdoa->curr_ctx;
 	if (!curr_ctx) {
-		dev_dbg(vdoa->dev,
+		dev_warn(vdoa->dev,
 			"Instance released before the end of transaction\n");
 		return IRQ_HANDLED;
 	}
@@ -127,19 +129,44 @@ static irqreturn_t vdoa_irq_handler(int irq, void *data)
 	} else if (!(val & VDOAIST_EOT)) {
 		dev_warn(vdoa->dev, "Spurious interrupt\n");
 	}
+	curr_ctx->completed_job++;
 	complete(&curr_ctx->completion);
 
 	return IRQ_HANDLED;
 }
 
+int vdoa_wait_for_completion(struct vdoa_ctx *ctx)
+{
+	struct vdoa_data *vdoa = ctx->vdoa;
+
+	if (ctx->submitted_job == ctx->completed_job)
+		return 0;
+
+	if (!wait_for_completion_timeout(&ctx->completion,
+					 msecs_to_jiffies(300))) {
+		dev_err(vdoa->dev,
+			"Timeout waiting for transfer result\n");
+		return -ETIMEDOUT;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(vdoa_wait_for_completion);
+
 void vdoa_device_run(struct vdoa_ctx *ctx, dma_addr_t dst, dma_addr_t src)
 {
 	struct vdoa_q_data *src_q_data, *dst_q_data;
 	struct vdoa_data *vdoa = ctx->vdoa;
 	u32 val;
 
+	if (vdoa->curr_ctx)
+		vdoa_wait_for_completion(vdoa->curr_ctx);
+
 	vdoa->curr_ctx = ctx;
 
+	reinit_completion(&ctx->completion);
+	ctx->submitted_job++;
+
 	src_q_data = &ctx->q_data[V4L2_M2M_SRC];
 	dst_q_data = &ctx->q_data[V4L2_M2M_DST];
 
@@ -177,21 +204,6 @@ void vdoa_device_run(struct vdoa_ctx *ctx, dma_addr_t dst, dma_addr_t src)
 }
 EXPORT_SYMBOL(vdoa_device_run);
 
-int vdoa_wait_for_completion(struct vdoa_ctx *ctx)
-{
-	struct vdoa_data *vdoa = ctx->vdoa;
-
-	if (!wait_for_completion_timeout(&ctx->completion,
-					 msecs_to_jiffies(300))) {
-		dev_err(vdoa->dev,
-			"Timeout waiting for transfer result\n");
-		return -ETIMEDOUT;
-	}
-
-	return 0;
-}
-EXPORT_SYMBOL(vdoa_wait_for_completion);
-
 struct vdoa_ctx *vdoa_context_create(struct vdoa_data *vdoa)
 {
 	struct vdoa_ctx *ctx;
@@ -218,6 +230,11 @@ void vdoa_context_destroy(struct vdoa_ctx *ctx)
 {
 	struct vdoa_data *vdoa = ctx->vdoa;
 
+	if (vdoa->curr_ctx == ctx) {
+		vdoa_wait_for_completion(vdoa->curr_ctx);
+		vdoa->curr_ctx = NULL;
+	}
+
 	clk_disable_unprepare(vdoa->vdoa_clk);
 	kfree(ctx);
 }
-- 
2.11.0
