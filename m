Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44543 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101AbaFMQJN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Jun 2014 12:09:13 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 28/30] [media] coda: round up internal frames to multiples of macroblock size for h.264
Date: Fri, 13 Jun 2014 18:08:54 +0200
Message-Id: <1402675736-15379-29-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1402675736-15379-1-git-send-email-p.zabel@pengutronix.de>
References: <1402675736-15379-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

CODA7541 only supports encoding h.264 frames with width and height that are
multiples of the macroblock size.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda.c | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index 2b997bd..c65047f 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -1798,15 +1798,21 @@ static void coda_free_framebuffers(struct coda_ctx *ctx)
 static int coda_alloc_framebuffers(struct coda_ctx *ctx, struct coda_q_data *q_data, u32 fourcc)
 {
 	struct coda_dev *dev = ctx->dev;
-	int height = q_data->height;
+	int width, height;
 	dma_addr_t paddr;
 	int ysize;
 	int ret;
 	int i;
 
-	if (ctx->codec && ctx->codec->src_fourcc == V4L2_PIX_FMT_H264)
-		height = round_up(height, 16);
-	ysize = round_up(q_data->width, 8) * height;
+	if (ctx->codec && (ctx->codec->src_fourcc == V4L2_PIX_FMT_H264 ||
+	     ctx->codec->dst_fourcc == V4L2_PIX_FMT_H264)) {
+		width = round_up(q_data->width, 16);
+		height = round_up(q_data->height, 16);
+	} else {
+		width = round_up(q_data->width, 8);
+		height = q_data->height;
+	}
+	ysize = width * height;
 
 	/* Allocate frame buffers */
 	for (i = 0; i < ctx->num_internal_frames; i++) {
@@ -2429,7 +2435,16 @@ static int coda_start_encoding(struct coda_ctx *ctx)
 		value = (q_data_src->width & CODADX6_PICWIDTH_MASK) << CODADX6_PICWIDTH_OFFSET;
 		value |= (q_data_src->height & CODADX6_PICHEIGHT_MASK) << CODA_PICHEIGHT_OFFSET;
 		break;
-	default:
+	case CODA_7541:
+		if (dst_fourcc == V4L2_PIX_FMT_H264) {
+			value = (round_up(q_data_src->width, 16) &
+				 CODA7_PICWIDTH_MASK) << CODA7_PICWIDTH_OFFSET;
+			value |= (round_up(q_data_src->height, 16) &
+				  CODA7_PICHEIGHT_MASK) << CODA_PICHEIGHT_OFFSET;
+			break;
+		}
+		/* fallthrough */
+	case CODA_960:
 		value = (q_data_src->width & CODA7_PICWIDTH_MASK) << CODA7_PICWIDTH_OFFSET;
 		value |= (q_data_src->height & CODA7_PICHEIGHT_MASK) << CODA_PICHEIGHT_OFFSET;
 	}
-- 
2.0.0.rc2

