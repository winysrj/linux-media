Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46107 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759225Ab3EWOnK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 May 2013 10:43:10 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Javier Martin <javier.martin@vista-silicon.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 5/9] [media] coda: simplify parameter buffer setup code
Date: Thu, 23 May 2013 16:42:57 +0200
Message-Id: <1369320181-17933-6-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1369320181-17933-1-git-send-email-p.zabel@pengutronix.de>
References: <1369320181-17933-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda.c | 51 +++++++++++++++++++------------------------
 1 file changed, 23 insertions(+), 28 deletions(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index ef541b0..625ef3f 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -914,21 +914,34 @@ static void coda_free_framebuffers(struct coda_ctx *ctx)
 	}
 }
 
+static void coda_parabuf_write(struct coda_ctx *ctx, int index, u32 value)
+{
+	struct coda_dev *dev = ctx->dev;
+	u32 *p = ctx->parabuf.vaddr;
+
+	if (dev->devtype->product == CODA_DX6)
+		p[index] = value;
+	else
+		p[index ^ 1] = value;
+}
+
 static int coda_alloc_framebuffers(struct coda_ctx *ctx, struct coda_q_data *q_data, u32 fourcc)
 {
 	struct coda_dev *dev = ctx->dev;
 
 	int height = q_data->height;
-	int width = q_data->width;
-	u32 *p;
+	dma_addr_t paddr;
+	int ysize;
 	int i;
 
+	ysize = round_up(q_data->width, 8) * height;
+
 	/* Allocate frame buffers */
 	ctx->num_internal_frames = CODA_MAX_FRAMEBUFFERS;
 	for (i = 0; i < ctx->num_internal_frames; i++) {
 		ctx->internal_frames[i].size = q_data->sizeimage;
 		if (fourcc == V4L2_PIX_FMT_H264 && dev->devtype->product != CODA_DX6)
-			ctx->internal_frames[i].size += width / 2 * height / 2;
+			ctx->internal_frames[i].size += ysize/4;
 		ctx->internal_frames[i].vaddr = dma_alloc_coherent(
 				&dev->plat_dev->dev, ctx->internal_frames[i].size,
 				&ctx->internal_frames[i].paddr, GFP_KERNEL);
@@ -939,32 +952,14 @@ static int coda_alloc_framebuffers(struct coda_ctx *ctx, struct coda_q_data *q_d
 	}
 
 	/* Register frame buffers in the parameter buffer */
-	p = ctx->parabuf.vaddr;
+	for (i = 0; i < ctx->num_internal_frames; i++) {
+		paddr = ctx->internal_frames[i].paddr;
+		coda_parabuf_write(ctx, i * 3 + 0, paddr); /* Y */
+		coda_parabuf_write(ctx, i * 3 + 1, paddr + ysize); /* Cb */
+		coda_parabuf_write(ctx, i * 3 + 2, paddr + ysize + ysize/4); /* Cr */
 
-	if (dev->devtype->product == CODA_DX6) {
-		for (i = 0; i < ctx->num_internal_frames; i++) {
-			p[i * 3] = ctx->internal_frames[i].paddr; /* Y */
-			p[i * 3 + 1] = p[i * 3] + width * height; /* Cb */
-			p[i * 3 + 2] = p[i * 3 + 1] + width / 2 * height / 2; /* Cr */
-		}
-	} else {
-		for (i = 0; i < ctx->num_internal_frames; i += 2) {
-			p[i * 3 + 1] = ctx->internal_frames[i].paddr; /* Y */
-			p[i * 3] = p[i * 3 + 1] + width * height; /* Cb */
-			p[i * 3 + 3] = p[i * 3] + (width / 2) * (height / 2); /* Cr */
-
-			if (fourcc == V4L2_PIX_FMT_H264)
-				p[96 + i + 1] = p[i * 3 + 3] + (width / 2) * (height / 2);
-
-			if (i + 1 < ctx->num_internal_frames) {
-				p[i * 3 + 2] = ctx->internal_frames[i+1].paddr; /* Y */
-				p[i * 3 + 5] = p[i * 3 + 2] + width * height ; /* Cb */
-				p[i * 3 + 4] = p[i * 3 + 5] + (width / 2) * (height / 2); /* Cr */
-
-				if (fourcc == V4L2_PIX_FMT_H264)
-					p[96 + i] = p[i * 3 + 4] + (width / 2) * (height / 2);
-			}
-		}
+		if (dev->devtype->product != CODA_DX6 && fourcc == V4L2_PIX_FMT_H264)
+			coda_parabuf_write(ctx, 96 + i, ctx->internal_frames[i].paddr + ysize + ysize/4 + ysize/4);
 	}
 
 	return 0;
-- 
1.8.2.rc2

