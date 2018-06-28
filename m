Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:42407 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753479AbeF1K6J (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Jun 2018 06:58:09 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: kernel@pengutronix.de
Subject: [PATCH 2/3] media: coda: streamline framebuffer size calculation a bit
Date: Thu, 28 Jun 2018 12:57:53 +0200
Message-Id: <20180628105754.24363-2-p.zabel@pengutronix.de>
In-Reply-To: <20180628105754.24363-1-p.zabel@pengutronix.de>
References: <20180628105754.24363-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove the intermediate width and height variables, the calculation is
simple enough.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-bit.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index aae8183e1ccc..86e618c10221 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -389,7 +389,6 @@ static int coda_alloc_framebuffers(struct coda_ctx *ctx,
 				   struct coda_q_data *q_data, u32 fourcc)
 {
 	struct coda_dev *dev = ctx->dev;
-	int width, height;
 	unsigned int ysize, ycbcr_size;
 	int ret;
 	int i;
@@ -397,14 +396,11 @@ static int coda_alloc_framebuffers(struct coda_ctx *ctx,
 	if (ctx->codec->src_fourcc == V4L2_PIX_FMT_H264 ||
 	    ctx->codec->dst_fourcc == V4L2_PIX_FMT_H264 ||
 	    ctx->codec->src_fourcc == V4L2_PIX_FMT_MPEG4 ||
-	    ctx->codec->dst_fourcc == V4L2_PIX_FMT_MPEG4) {
-		width = round_up(q_data->width, 16);
-		height = round_up(q_data->height, 16);
-	} else {
-		width = round_up(q_data->width, 8);
-		height = q_data->height;
-	}
-	ysize = width * height;
+	    ctx->codec->dst_fourcc == V4L2_PIX_FMT_MPEG4)
+		ysize = round_up(q_data->width, 16) *
+			round_up(q_data->height, 16);
+	else
+		ysize = round_up(q_data->width, 8) * q_data->height;
 
 	if (ctx->tiled_map_type == GDI_TILED_FRAME_MB_RASTER_MAP)
 		ycbcr_size = round_up(ysize, 4096) + ysize / 2;
-- 
2.17.1
