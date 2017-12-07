Return-path: <linux-media-owner@vger.kernel.org>
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>, kernel@pengutronix.de,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 3/3] [media] coda: use correct offset for mpeg4 decoder mvcol buffer
Date: Thu,  7 Dec 2017 15:59:51 +0100
Message-Id: <20171207145951.15450-3-p.zabel@pengutronix.de>
In-Reply-To: <20171207145951.15450-1-p.zabel@pengutronix.de>
References: <20171207145951.15450-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The mvcol buffer needs to be placed behind the chroma plane(s) when
decoding MPEG-4, same as for the h.264 decoder. Use the real offset
with the required rounding.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-bit.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index 32db1227d0258..9fe113cb901f8 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -455,18 +455,16 @@ static int coda_alloc_framebuffers(struct coda_ctx *ctx,
 		coda_parabuf_write(ctx, i * 3 + 1, cb);
 		coda_parabuf_write(ctx, i * 3 + 2, cr);
 
-		/* mvcol buffer for h.264 */
-		if (ctx->codec->src_fourcc == V4L2_PIX_FMT_H264 &&
-		    dev->devtype->product != CODA_DX6)
+		if (dev->devtype->product == CODA_DX6)
+			continue;
+
+		/* mvcol buffer for h.264 and mpeg4 */
+		if (ctx->codec->src_fourcc == V4L2_PIX_FMT_H264)
 			coda_parabuf_write(ctx, 96 + i, mvcol);
+		if (ctx->codec->src_fourcc == V4L2_PIX_FMT_MPEG4 && i == 0)
+			coda_parabuf_write(ctx, 97, mvcol);
 	}
 
-	/* mvcol buffer for mpeg4 */
-	if ((dev->devtype->product != CODA_DX6) &&
-	    (ctx->codec->src_fourcc == V4L2_PIX_FMT_MPEG4))
-		coda_parabuf_write(ctx, 97, ctx->internal_frames[0].paddr +
-					    ysize + ysize/4 + ysize/4);
-
 	return 0;
 }
 
-- 
2.11.0
