Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:40657 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727500AbeJSUVe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Oct 2018 16:21:34 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org,
        Steve Longerbeam <slongerbeam@gmail.com>
Cc: Nicolas Dufresne <nicolas@ndufresne.ca>,
        Tim Harvey <tharvey@gateworks.com>, kernel@pengutronix.de
Subject: [PATCH v4 05/22] gpu: ipu-v3: image-convert: Prevent race between run and unprepare
Date: Fri, 19 Oct 2018 14:15:22 +0200
Message-Id: <20181019121539.12778-6-p.zabel@pengutronix.de>
In-Reply-To: <20181019121539.12778-1-p.zabel@pengutronix.de>
References: <20181019121539.12778-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Steve Longerbeam <slongerbeam@gmail.com>

Prevent possible race by parallel threads between ipu_image_convert_run()
and ipu_image_convert_unprepare(). This involves setting ctx->aborting
to true unconditionally so that no new job runs can be queued during
unprepare, and holding the ctx->aborting flag until the context is freed.

Note that the "normal" ipu_image_convert_abort() case (e.g. not during
context unprepare) should clear the ctx->aborting flag after aborting
any active run and clearing the context's pending queue. This is because
it should be possible to continue to use the conversion context and queue
more runs after an abort.

Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
---
New since v3.
---
 drivers/gpu/ipu-v3/ipu-image-convert.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/ipu-v3/ipu-image-convert.c b/drivers/gpu/ipu-v3/ipu-image-convert.c
index 41fb62b88c54..6c15bf8efaa2 100644
--- a/drivers/gpu/ipu-v3/ipu-image-convert.c
+++ b/drivers/gpu/ipu-v3/ipu-image-convert.c
@@ -1524,7 +1524,7 @@ int ipu_image_convert_queue(struct ipu_image_convert_run *run)
 EXPORT_SYMBOL_GPL(ipu_image_convert_queue);
 
 /* Abort any active or pending conversions for this context */
-void ipu_image_convert_abort(struct ipu_image_convert_ctx *ctx)
+static void __ipu_image_convert_abort(struct ipu_image_convert_ctx *ctx)
 {
 	struct ipu_image_convert_chan *chan = ctx->chan;
 	struct ipu_image_convert_priv *priv = chan->priv;
@@ -1551,7 +1551,7 @@ void ipu_image_convert_abort(struct ipu_image_convert_ctx *ctx)
 
 	need_abort = (run_count || active_run);
 
-	ctx->aborting = need_abort;
+	ctx->aborting = true;
 
 	spin_unlock_irqrestore(&chan->irqlock, flags);
 
@@ -1572,7 +1572,11 @@ void ipu_image_convert_abort(struct ipu_image_convert_ctx *ctx)
 		dev_warn(priv->ipu->dev, "%s: timeout\n", __func__);
 		force_abort(ctx);
 	}
+}
 
+void ipu_image_convert_abort(struct ipu_image_convert_ctx *ctx)
+{
+	__ipu_image_convert_abort(ctx);
 	ctx->aborting = false;
 }
 EXPORT_SYMBOL_GPL(ipu_image_convert_abort);
@@ -1586,7 +1590,7 @@ void ipu_image_convert_unprepare(struct ipu_image_convert_ctx *ctx)
 	bool put_res;
 
 	/* make sure no runs are hanging around */
-	ipu_image_convert_abort(ctx);
+	__ipu_image_convert_abort(ctx);
 
 	dev_dbg(priv->ipu->dev, "%s: task %u: removing ctx %p\n", __func__,
 		chan->ic_task, ctx);
-- 
2.19.0
