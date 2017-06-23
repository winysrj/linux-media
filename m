Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:38823 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752878AbdFWL5y (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Jun 2017 07:57:54 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] [media] coda: do not reassign ctx->tiled_map_type in coda_s_fmt
Date: Fri, 23 Jun 2017 13:57:27 +0200
Message-Id: <20170623115727.31390-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This smatch warning:

    coda/coda-common.c:706 coda_s_fmt() warn: missing break? reassigning 'ctx->tiled_map_type'

can be silenced by moving the ctx->tiled_map_type assignment into the
breakout condition. That way the field is not reassigned when falling
through to the next switch statement.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-common.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index f92cc7df58fb8..dfceab052a4fa 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -714,9 +714,10 @@ static int coda_s_fmt(struct coda_ctx *ctx, struct v4l2_format *f,
 		ctx->tiled_map_type = GDI_TILED_FRAME_MB_RASTER_MAP;
 		break;
 	case V4L2_PIX_FMT_NV12:
-		ctx->tiled_map_type = GDI_TILED_FRAME_MB_RASTER_MAP;
-		if (!disable_tiling)
+		if (!disable_tiling) {
+			ctx->tiled_map_type = GDI_TILED_FRAME_MB_RASTER_MAP;
 			break;
+		}
 		/* else fall through */
 	case V4L2_PIX_FMT_YUV420:
 	case V4L2_PIX_FMT_YVU420:
-- 
2.11.0
