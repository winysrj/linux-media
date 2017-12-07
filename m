Return-path: <linux-media-owner@vger.kernel.org>
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>, kernel@pengutronix.de,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 1/3] [media] coda: round up frame sizes to multiples of 16 for MPEG-4 decoder
Date: Thu,  7 Dec 2017 15:59:49 +0100
Message-Id: <20171207145951.15450-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We need internal frames to be rounded up to full macroblocks for MPEG-4
decoding as well.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-bit.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index bfc4ecf6f068b..87002bede5ea1 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -395,6 +395,7 @@ static int coda_alloc_framebuffers(struct coda_ctx *ctx,
 
 	if (ctx->codec->src_fourcc == V4L2_PIX_FMT_H264 ||
 	    ctx->codec->dst_fourcc == V4L2_PIX_FMT_H264 ||
+	    ctx->codec->src_fourcc == V4L2_PIX_FMT_MPEG4 ||
 	    ctx->codec->dst_fourcc == V4L2_PIX_FMT_MPEG4) {
 		width = round_up(q_data->width, 16);
 		height = round_up(q_data->height, 16);
-- 
2.11.0
