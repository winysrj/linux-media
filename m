Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:59029 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751312AbdGQKnY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Jul 2017 06:43:24 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] [media] coda: wake up capture queue on encoder stop after output streamoff
Date: Mon, 17 Jul 2017 12:43:15 +0200
Message-Id: <20170717104315.3797-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If an encoder stop command is issued after the output queue has already
stopped streaming, the qsequence counter has been reset to 0. Always
wake up the capture queue if the output queue is not streaming.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index a55e9875e5619..cb378d98d134b 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -933,7 +933,7 @@ static int coda_encoder_cmd(struct file *file, void *fh,
 	ctx->bit_stream_param |= CODA_BIT_STREAM_END_FLAG;
 
 	/* If there is no buffer in flight, wake up */
-	if (ctx->qsequence == ctx->osequence) {
+	if (!ctx->streamon_out || ctx->qsequence == ctx->osequence) {
 		dst_vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx,
 					 V4L2_BUF_TYPE_VIDEO_CAPTURE);
 		dst_vq->last_buffer_dequeued = true;
-- 
2.11.0
