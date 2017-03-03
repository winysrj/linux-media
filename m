Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:40199 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751843AbdCCMcC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 3 Mar 2017 07:32:02 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: kernel@pengutronix.de, Michael Tretter <m.tretter@pengutronix.de>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 1/4] [media] coda: Use && instead of & for non-bitfield conditions
Date: Fri,  3 Mar 2017 13:12:47 +0100
Message-Id: <20170303121250.13693-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Michael Tretter <m.tretter@pengutronix.de>

streamon and streamoff are used as boolean values, not as bitfields.
Therefore, the logical && should be used to combine them.

Signed-off-by: Michael Tretter <m.tretter@pengutronix.de>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index b411620e8999c..a7318b5a1e6ce 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -1459,7 +1459,7 @@ static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
 	}
 
 	/* Don't start the coda unless both queues are on */
-	if (!(ctx->streamon_out & ctx->streamon_cap))
+	if (!(ctx->streamon_out && ctx->streamon_cap))
 		return 0;
 
 	q_data_dst = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
-- 
2.11.0
