Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:40471 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751755AbdG1N0k (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Jul 2017 09:26:40 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] [media] coda: fix decoder sequence init escape flag
Date: Fri, 28 Jul 2017 15:26:25 +0200
Message-Id: <20170728132626.25847-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

coda_command_sync calls coda_command_async, which writes the
bit_stream_param context variable into the BIT_STREAM_PARAM register,
overwriting the previously set value during coda_start_decoding. Instead
of writing to the register, set bit_stream_param to ensure that the
decoder sequence init command is executed with the escape flag set.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-bit.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index 95e4b74d5dd01..291c409339357 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -1639,9 +1639,6 @@ static int __coda_start_decoding(struct coda_ctx *ctx)
 	ctx->frm_dis_flg = 0;
 	coda_write(dev, 0, CODA_REG_BIT_FRM_DIS_FLG(ctx->reg_idx));
 
-	coda_write(dev, CODA_BIT_DEC_SEQ_INIT_ESCAPE,
-			CODA_REG_BIT_BIT_STREAM_PARAM);
-
 	coda_write(dev, bitstream_buf, CODA_CMD_DEC_SEQ_BB_START);
 	coda_write(dev, bitstream_size / 1024, CODA_CMD_DEC_SEQ_BB_SIZE);
 	val = 0;
@@ -1676,18 +1673,18 @@ static int __coda_start_decoding(struct coda_ctx *ctx)
 	if (dev->devtype->product != CODA_960)
 		coda_write(dev, 0, CODA_CMD_DEC_SEQ_SRC_SIZE);
 
-	if (coda_command_sync(ctx, CODA_COMMAND_SEQ_INIT)) {
+	ctx->bit_stream_param = CODA_BIT_DEC_SEQ_INIT_ESCAPE;
+	ret = coda_command_sync(ctx, CODA_COMMAND_SEQ_INIT);
+	ctx->bit_stream_param = 0;
+	if (ret) {
 		v4l2_err(&dev->v4l2_dev, "CODA_COMMAND_SEQ_INIT timeout\n");
-		coda_write(dev, 0, CODA_REG_BIT_BIT_STREAM_PARAM);
-		return -ETIMEDOUT;
+		return ret;
 	}
 	ctx->initialized = 1;
 
 	/* Update kfifo out pointer from coda bitstream read pointer */
 	coda_kfifo_sync_from_device(ctx);
 
-	coda_write(dev, 0, CODA_REG_BIT_BIT_STREAM_PARAM);
-
 	if (coda_read(dev, CODA_RET_DEC_SEQ_SUCCESS) == 0) {
 		v4l2_err(&dev->v4l2_dev,
 			"CODA_COMMAND_SEQ_INIT failed, error code = %d\n",
-- 
2.11.0
