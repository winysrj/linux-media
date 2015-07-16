Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36028 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083AbbGPQTo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jul 2015 12:19:44 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <kamil@wypas.org>
Cc: linux-media@vger.kernel.org, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 1/3] [media] coda: move cache setup into coda9_set_frame_cache, also use it in start_encoding
Date: Thu, 16 Jul 2015 18:19:37 +0200
Message-Id: <1437063579-10064-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The frame cache should be set up correctly to encode NV12 source frames.
This was not done before, so move the cache setup out of start_decoding
into its own function and call it from both start_encoding and
start_decoding.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-bit.c | 45 +++++++++++++++++++---------------
 1 file changed, 25 insertions(+), 20 deletions(-)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index b14affc..46c7054 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -721,6 +721,26 @@ err_clk_per:
 	return ret;
 }
 
+static void coda9_set_frame_cache(struct coda_ctx *ctx, u32 fourcc)
+{
+	u32 cache_size, cache_config;
+
+	/* Luma 2x0 page, 2x6 cache, chroma 2x0 page, 2x4 cache size */
+	cache_size = 0x20262024;
+	cache_config = 2 << CODA9_CACHE_PAGEMERGE_OFFSET;
+	coda_write(ctx->dev, cache_size, CODA9_CMD_SET_FRAME_CACHE_SIZE);
+	if (fourcc == V4L2_PIX_FMT_NV12) {
+		cache_config |= 32 << CODA9_CACHE_LUMA_BUFFER_SIZE_OFFSET |
+				16 << CODA9_CACHE_CR_BUFFER_SIZE_OFFSET |
+				0 << CODA9_CACHE_CB_BUFFER_SIZE_OFFSET;
+	} else {
+		cache_config |= 32 << CODA9_CACHE_LUMA_BUFFER_SIZE_OFFSET |
+				8 << CODA9_CACHE_CR_BUFFER_SIZE_OFFSET |
+				8 << CODA9_CACHE_CB_BUFFER_SIZE_OFFSET;
+	}
+	coda_write(ctx->dev, cache_config, CODA9_CMD_SET_FRAME_CACHE_CONFIG);
+}
+
 /*
  * Encoder context operations
  */
@@ -1049,6 +1069,8 @@ static int coda_start_encoding(struct coda_ctx *ctx)
 			coda_write(dev, ctx->iram_info.buf_btp_use,
 					CODA9_CMD_SET_FRAME_AXI_BTP_ADDR);
 
+			coda9_set_frame_cache(ctx, q_data_src->fourcc);
+
 			/* FIXME */
 			coda_write(dev, ctx->internal_frames[2].paddr,
 				   CODA9_CMD_SET_FRAME_SUBSAMP_A);
@@ -1606,30 +1628,13 @@ static int __coda_start_decoding(struct coda_ctx *ctx)
 				CODA7_CMD_SET_FRAME_AXI_DBKC_ADDR);
 		coda_write(dev, ctx->iram_info.buf_ovl_use,
 				CODA7_CMD_SET_FRAME_AXI_OVL_ADDR);
-		if (dev->devtype->product == CODA_960)
+		if (dev->devtype->product == CODA_960) {
 			coda_write(dev, ctx->iram_info.buf_btp_use,
 					CODA9_CMD_SET_FRAME_AXI_BTP_ADDR);
-	}
-
-	if (dev->devtype->product == CODA_960) {
-		int cbb_size, crb_size;
-
-		coda_write(dev, -1, CODA9_CMD_SET_FRAME_DELAY);
-		/* Luma 2x0 page, 2x6 cache, chroma 2x0 page, 2x4 cache size */
-		coda_write(dev, 0x20262024, CODA9_CMD_SET_FRAME_CACHE_SIZE);
 
-		if (dst_fourcc == V4L2_PIX_FMT_NV12) {
-			cbb_size = 0;
-			crb_size = 16;
-		} else {
-			cbb_size = 8;
-			crb_size = 8;
+			coda_write(dev, -1, CODA9_CMD_SET_FRAME_DELAY);
+			coda9_set_frame_cache(ctx, dst_fourcc);
 		}
-		coda_write(dev, 2 << CODA9_CACHE_PAGEMERGE_OFFSET |
-				32 << CODA9_CACHE_LUMA_BUFFER_SIZE_OFFSET |
-				cbb_size << CODA9_CACHE_CB_BUFFER_SIZE_OFFSET |
-				crb_size << CODA9_CACHE_CR_BUFFER_SIZE_OFFSET,
-				CODA9_CMD_SET_FRAME_CACHE_CONFIG);
 	}
 
 	if (src_fourcc == V4L2_PIX_FMT_H264) {
-- 
2.1.4

