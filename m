Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:46849 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754667AbdDENJ5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Apr 2017 09:09:57 -0400
From: Lucas Stach <l.stach@pengutronix.de>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, kernel@pengutronix.de,
        patchwork-lst@pengutronix.de
Subject: [PATCH 1/3] [media] coda: use correct offset for mvcol buffer
Date: Wed,  5 Apr 2017 15:09:53 +0200
Message-Id: <20170405130955.30513-1-l.stach@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The mvcol buffer needs to be placed behind the chroma plane(s), so
use the real offset including any required rounding.

Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
---
 drivers/media/platform/coda/coda-bit.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index 466a44e4549e..36062fc494e3 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -387,14 +387,16 @@ static int coda_alloc_framebuffers(struct coda_ctx *ctx,
 
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
@@ -408,9 +410,7 @@ static int coda_alloc_framebuffers(struct coda_ctx *ctx,
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
