Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:51735 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727506AbeJSUVe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Oct 2018 16:21:34 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org,
        Steve Longerbeam <slongerbeam@gmail.com>
Cc: Nicolas Dufresne <nicolas@ndufresne.ca>,
        Tim Harvey <tharvey@gateworks.com>, kernel@pengutronix.de
Subject: [PATCH v4 06/22] gpu: ipu-v3: image-convert: Only wait for abort completion if active run
Date: Fri, 19 Oct 2018 14:15:23 +0200
Message-Id: <20181019121539.12778-7-p.zabel@pengutronix.de>
In-Reply-To: <20181019121539.12778-1-p.zabel@pengutronix.de>
References: <20181019121539.12778-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Steve Longerbeam <slongerbeam@gmail.com>

Only wait for the ctx->aborted completion if there is an active run
in progress, otherwise the wait will just timeout after 10 seconds.
If there is no active run in progress, the done queue just needs to
be emptied.

Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
---
New since v3.
---
 drivers/gpu/ipu-v3/ipu-image-convert.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/ipu-v3/ipu-image-convert.c b/drivers/gpu/ipu-v3/ipu-image-convert.c
index 6c15bf8efaa2..e3e032252604 100644
--- a/drivers/gpu/ipu-v3/ipu-image-convert.c
+++ b/drivers/gpu/ipu-v3/ipu-image-convert.c
@@ -1562,9 +1562,14 @@ static void __ipu_image_convert_abort(struct ipu_image_convert_ctx *ctx)
 		return;
 	}
 
+	if (!active_run) {
+		empty_done_q(chan);
+		return;
+	}
+
 	dev_dbg(priv->ipu->dev,
-		"%s: task %u: wait for completion: %d runs, active run %p\n",
-		__func__, chan->ic_task, run_count, active_run);
+		"%s: task %u: wait for completion: %d runs\n",
+		__func__, chan->ic_task, run_count);
 
 	ret = wait_for_completion_timeout(&ctx->aborted,
 					  msecs_to_jiffies(10000));
-- 
2.19.0
