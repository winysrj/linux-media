Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:51797 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753417AbeF1K6I (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Jun 2018 06:58:08 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: kernel@pengutronix.de
Subject: [PATCH 1/3] media: coda: move framebuffer size calculation out of loop
Date: Thu, 28 Jun 2018 12:57:52 +0200
Message-Id: <20180628105754.24363-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

All internal YCbCr frame buffers are the same size, calculate ycbcr_size
once before the allocation loop.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-bit.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index 68ed2a564ad1..aae8183e1ccc 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -390,7 +390,7 @@ static int coda_alloc_framebuffers(struct coda_ctx *ctx,
 {
 	struct coda_dev *dev = ctx->dev;
 	int width, height;
-	int ysize;
+	unsigned int ysize, ycbcr_size;
 	int ret;
 	int i;
 
@@ -406,15 +406,16 @@ static int coda_alloc_framebuffers(struct coda_ctx *ctx,
 	}
 	ysize = width * height;
 
+	if (ctx->tiled_map_type == GDI_TILED_FRAME_MB_RASTER_MAP)
+		ycbcr_size = round_up(ysize, 4096) + ysize / 2;
+	else
+		ycbcr_size = ysize + ysize / 2;
+
 	/* Allocate frame buffers */
 	for (i = 0; i < ctx->num_internal_frames; i++) {
-		size_t size;
+		size_t size = ycbcr_size;
 		char *name;
 
-		if (ctx->tiled_map_type == GDI_TILED_FRAME_MB_RASTER_MAP)
-			size = round_up(ysize, 4096) + ysize / 2;
-		else
-			size = ysize + ysize / 2;
 		/* Add space for mvcol buffers */
 		if (dev->devtype->product != CODA_DX6 &&
 		    (ctx->codec->src_fourcc == V4L2_PIX_FMT_H264 ||
-- 
2.17.1
