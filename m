Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:57413 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751850AbdFHIzU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Jun 2017 04:55:20 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        kernel@pengutronix.de, patchwork-lst@pengutronix.de,
        Lucas Stach <l.stach@pengutronix.de>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2 1/3] [media] coda: use correct offset for mvcol buffer
Date: Thu,  8 Jun 2017 10:55:11 +0200
Message-Id: <20170608085513.26857-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Lucas Stach <l.stach@pengutronix.de>

The mvcol buffer needs to be placed behind the chroma plane(s), so
use the real offset including any required rounding.

Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
No changes since v1 [1].

[1] https://patchwork.linuxtv.org/patch/40604
---
 drivers/media/platform/coda/coda-bit.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index 2ec41375a896f..325035bb0a777 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -427,14 +427,16 @@ static int coda_alloc_framebuffers(struct coda_ctx *ctx,
 
 	/* Register frame buffers in the parameter buffer */
 	for (i = 0; i < ctx->num_internal_frames; i++) {
-		u32 y, cb, cr;
+		u32 y, cb, cr, mvcol;
 
 		/* Start addresses of Y, Cb, Cr planes */
 		y = ctx->internal_frames[i].paddr;
 		cb = y + ysize;
 		cr = y + ysize + ysize/4;
+		mvcol = y + ysize + ysize/4 + ysize/4;
 		if (ctx->tiled_map_type == GDI_TILED_FRAME_MB_RASTER_MAP) {
 			cb = round_up(cb, 4096);
+			mvcol = cb + ysize/2;
 			cr = 0;
 			/* Packed 20-bit MSB of base addresses */
 			/* YYYYYCCC, CCyyyyyc, cccc.... */
@@ -448,9 +450,7 @@ static int coda_alloc_framebuffers(struct coda_ctx *ctx,
 		/* mvcol buffer for h.264 */
 		if (ctx->codec->src_fourcc == V4L2_PIX_FMT_H264 &&
 		    dev->devtype->product != CODA_DX6)
-			coda_parabuf_write(ctx, 96 + i,
-					   ctx->internal_frames[i].paddr +
-					   ysize + ysize/4 + ysize/4);
+			coda_parabuf_write(ctx, 96 + i, mvcol);
 	}
 
 	/* mvcol buffer for mpeg4 */
-- 
2.11.0
