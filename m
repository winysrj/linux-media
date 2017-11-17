Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout02.posteo.de ([185.67.36.66]:34269 "EHLO mout02.posteo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933700AbdKQOaY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Nov 2017 09:30:24 -0500
Received: from submission (posteo.de [89.146.220.130])
        by mout02.posteo.de (Postfix) with ESMTPS id D236720A06
        for <linux-media@vger.kernel.org>; Fri, 17 Nov 2017 15:30:21 +0100 (CET)
From: Martin Kepplinger <martink@posteo.de>
To: p.zabel@pengutronix.de
Cc: mchehab@kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Martin Kepplinger <martink@posteo.de>
Subject: [PATCH] media: coda: fix comparision of decoded frames' indexes
Date: Fri, 17 Nov 2017 15:30:10 +0100
Message-Id: <20171117143010.501-1-martink@posteo.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

At this point the driver looks the currently decoded frame's index
and compares is to VPU-specific state values. Directly before this
if and else statements the indexes are read (index for decoded and
for displayed frame).

Now what is saved in ctx->display_idx is an older value at this point!
During these index checks, the current values apply, so fix this by
taking display_idx instead of ctx->display_idx.

ctx->display_idx is updated later in the same function.

Signed-off-by: Martin Kepplinger <martink@posteo.de>
---

Please review this thoroughly, but in case I am wrong here, this is
at least very strange to read and *should* be accompanied with a
comment about what's going on with that index value!

I don't think it matter that much here because at least playing h264
worked before and works with this change, but I've tested it anyways.

thanks

                               martin


 drivers/media/platform/coda/coda-bit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index bfc4ecf6f068..fe38527a90e2 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -2089,7 +2089,7 @@ static void coda_finish_decode(struct coda_ctx *ctx)
 		/* no frame was decoded, but we might have a display frame */
 		if (display_idx >= 0 && display_idx < ctx->num_internal_frames)
 			ctx->sequence_offset++;
-		else if (ctx->display_idx < 0)
+		else if (display_idx < 0)
 			ctx->hold = true;
 	} else if (decoded_idx == -2) {
 		/* no frame was decoded, we still return remaining buffers */
-- 
2.11.0
