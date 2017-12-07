Return-path: <linux-media-owner@vger.kernel.org>
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michael Tretter <m.tretter@pengutronix.de>,
        kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] [media] coda: fix capture TRY_FMT for YUYV with non-MB-aligned widths
Date: Thu,  7 Dec 2017 12:11:11 +0100
Message-Id: <20171207111111.6110-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since bytesperline always fulfills VDOA width requirements, detile the
whole buffer instead of limiting to visible width. This stops TRY_FMT
from returning -EINVAL for YUYV capture buffers that are not a multiple
of 16 wide.

An alternative would be to always round up width to stride, as we report
the valid image rectange via G_SELECTION (V4L2_SEL_TGT_COMPOSE_DEFAULT),
but that would require all applications to handle the compose default
rectangle properly.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-common.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 46a628a548d9f..e8a7554a61d24 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -486,8 +486,8 @@ static int coda_try_fmt_vdoa(struct coda_ctx *ctx, struct v4l2_format *f,
 		return 0;
 	}
 
-	err = vdoa_context_configure(NULL, f->fmt.pix.width, f->fmt.pix.height,
-				     f->fmt.pix.pixelformat);
+	err = vdoa_context_configure(NULL, round_up(f->fmt.pix.width, 16),
+				     f->fmt.pix.height, f->fmt.pix.pixelformat);
 	if (err) {
 		*use_vdoa = false;
 		return 0;
@@ -730,7 +730,8 @@ static int coda_s_fmt(struct coda_ctx *ctx, struct v4l2_format *f,
 	if (ctx->tiled_map_type == GDI_TILED_FRAME_MB_RASTER_MAP &&
 	    !coda_try_fmt_vdoa(ctx, f, &ctx->use_vdoa) &&
 	    ctx->use_vdoa)
-		vdoa_context_configure(ctx->vdoa, f->fmt.pix.width,
+		vdoa_context_configure(ctx->vdoa,
+				       round_up(f->fmt.pix.width, 16),
 				       f->fmt.pix.height,
 				       f->fmt.pix.pixelformat);
 	else
-- 
2.11.0
