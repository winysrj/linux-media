Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:35227 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932676AbeF2MmK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Jun 2018 08:42:10 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: kernel@pengutronix.de
Subject: [PATCH] media: coda: clear hold flag on streamoff
Date: Fri, 29 Jun 2018 14:42:08 +0200
Message-Id: <20180629124208.3205-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If new buffers are queued after streamoff, the flag will be cleared
anyway, so this is mostly for the purpose of correctness.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-common.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index b86d704ae10c..7911cd669fb0 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -1634,6 +1634,7 @@ static void coda_stop_streaming(struct vb2_queue *q)
 			ctx->bitstream.vaddr, ctx->bitstream.size);
 		ctx->runcounter = 0;
 		ctx->aborting = 0;
+		ctx->hold = false;
 	}
 
 	if (!ctx->streamon_out && !ctx->streamon_cap)
-- 
2.17.1
