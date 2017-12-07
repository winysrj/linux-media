Return-path: <linux-media-owner@vger.kernel.org>
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>, kernel@pengutronix.de,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 2/3] [media] coda: allocate space for mpeg4 decoder mvcol buffer
Date: Thu,  7 Dec 2017 15:59:50 +0100
Message-Id: <20171207145951.15450-2-p.zabel@pengutronix.de>
In-Reply-To: <20171207145951.15450-1-p.zabel@pengutronix.de>
References: <20171207145951.15450-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The MPEG-4 decoder mvcol buffer was registered, but its size not added
to a frame buffer allocation. This could cause the decoder to write past
the end of the allocated buffer for large frame sizes.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-bit.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index 87002bede5ea1..32db1227d0258 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -414,8 +414,10 @@ static int coda_alloc_framebuffers(struct coda_ctx *ctx,
 			size = round_up(ysize, 4096) + ysize / 2;
 		else
 			size = ysize + ysize / 2;
-		if (ctx->codec->src_fourcc == V4L2_PIX_FMT_H264 &&
-		    dev->devtype->product != CODA_DX6)
+		/* Add space for mvcol buffers */
+		if (dev->devtype->product != CODA_DX6 &&
+		    (ctx->codec->src_fourcc == V4L2_PIX_FMT_H264 ||
+		     (ctx->codec->src_fourcc == V4L2_PIX_FMT_MPEG4 && i == 0)))
 			size += ysize / 4;
 		name = kasprintf(GFP_KERNEL, "fb%d", i);
 		if (!name) {
-- 
2.11.0
