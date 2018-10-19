Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:45155 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727501AbeJSUVe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Oct 2018 16:21:34 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org,
        Steve Longerbeam <slongerbeam@gmail.com>
Cc: Nicolas Dufresne <nicolas@ndufresne.ca>,
        Tim Harvey <tharvey@gateworks.com>, kernel@pengutronix.de
Subject: [PATCH v4 07/22] gpu: ipu-v3: image-convert: Allow reentrancy into abort
Date: Fri, 19 Oct 2018 14:15:24 +0200
Message-Id: <20181019121539.12778-8-p.zabel@pengutronix.de>
In-Reply-To: <20181019121539.12778-1-p.zabel@pengutronix.de>
References: <20181019121539.12778-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Steve Longerbeam <slongerbeam@gmail.com>

Allow reentrancy into ipu_image_convert_abort(), by moving re-init
of ctx->aborted completion under the spin lock, and only if there is
an active run, and complete all waiters do_bh(). Note:
ipu_image_convert_unprepare() is still _not_ reentrant, and can't
be made reentrant.

Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
---
New since v3.
---
 drivers/gpu/ipu-v3/ipu-image-convert.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/ipu-v3/ipu-image-convert.c b/drivers/gpu/ipu-v3/ipu-image-convert.c
index e3e032252604..abd8afb22b48 100644
--- a/drivers/gpu/ipu-v3/ipu-image-convert.c
+++ b/drivers/gpu/ipu-v3/ipu-image-convert.c
@@ -896,7 +896,7 @@ static irqreturn_t do_bh(int irq, void *dev_id)
 			dev_dbg(priv->ipu->dev,
 				"%s: task %u: signaling abort for ctx %p\n",
 				__func__, chan->ic_task, ctx);
-			complete(&ctx->aborted);
+			complete_all(&ctx->aborted);
 		}
 	}
 
@@ -1533,8 +1533,6 @@ static void __ipu_image_convert_abort(struct ipu_image_convert_ctx *ctx)
 	int run_count, ret;
 	bool need_abort;
 
-	reinit_completion(&ctx->aborted);
-
 	spin_lock_irqsave(&chan->irqlock, flags);
 
 	/* move all remaining pending runs in this context to done_q */
@@ -1549,6 +1547,9 @@ static void __ipu_image_convert_abort(struct ipu_image_convert_ctx *ctx)
 	active_run = (chan->current_run && chan->current_run->ctx == ctx) ?
 		chan->current_run : NULL;
 
+	if (active_run)
+		reinit_completion(&ctx->aborted);
+
 	need_abort = (run_count || active_run);
 
 	ctx->aborting = true;
-- 
2.19.0
