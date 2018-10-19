Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:56375 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727516AbeJSUVf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Oct 2018 16:21:35 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org,
        Steve Longerbeam <slongerbeam@gmail.com>
Cc: Nicolas Dufresne <nicolas@ndufresne.ca>,
        Tim Harvey <tharvey@gateworks.com>, kernel@pengutronix.de
Subject: [PATCH v4 08/22] gpu: ipu-v3: image-convert: Remove need_abort flag
Date: Fri, 19 Oct 2018 14:15:25 +0200
Message-Id: <20181019121539.12778-9-p.zabel@pengutronix.de>
In-Reply-To: <20181019121539.12778-1-p.zabel@pengutronix.de>
References: <20181019121539.12778-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Steve Longerbeam <slongerbeam@gmail.com>

The need_abort flag is not really needed anymore in
__ipu_image_convert_abort(), remove it.
No functional changes.

Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
---
New since v3.
---
 drivers/gpu/ipu-v3/ipu-image-convert.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/gpu/ipu-v3/ipu-image-convert.c b/drivers/gpu/ipu-v3/ipu-image-convert.c
index abd8afb22b48..b8a400182a00 100644
--- a/drivers/gpu/ipu-v3/ipu-image-convert.c
+++ b/drivers/gpu/ipu-v3/ipu-image-convert.c
@@ -1531,7 +1531,6 @@ static void __ipu_image_convert_abort(struct ipu_image_convert_ctx *ctx)
 	struct ipu_image_convert_run *run, *active_run, *tmp;
 	unsigned long flags;
 	int run_count, ret;
-	bool need_abort;
 
 	spin_lock_irqsave(&chan->irqlock, flags);
 
@@ -1550,13 +1549,11 @@ static void __ipu_image_convert_abort(struct ipu_image_convert_ctx *ctx)
 	if (active_run)
 		reinit_completion(&ctx->aborted);
 
-	need_abort = (run_count || active_run);
-
 	ctx->aborting = true;
 
 	spin_unlock_irqrestore(&chan->irqlock, flags);
 
-	if (!need_abort) {
+	if (!run_count && !active_run) {
 		dev_dbg(priv->ipu->dev,
 			"%s: task %u: no abort needed for ctx %p\n",
 			__func__, chan->ic_task, ctx);
-- 
2.19.0
