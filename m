Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:58057 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933041AbeF1PrT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Jun 2018 11:47:19 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: kernel@pengutronix.de,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>
Subject: [PATCH 2/2] media: coda: fix reorder detection for unknown levels
Date: Thu, 28 Jun 2018 17:47:09 +0200
Message-Id: <20180628154709.29953-2-p.zabel@pengutronix.de>
In-Reply-To: <20180628154709.29953-1-p.zabel@pengutronix.de>
References: <20180628154709.29953-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Whether reordering should be enabled only depends on the h.264 profile.
Stop parsing the level and drop the debug message, profile and level
can now be determined via read-only decoder controls.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-bit.c | 25 ++++---------------------
 1 file changed, 4 insertions(+), 21 deletions(-)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index 68ed2a564ad1..94ba3cc3bf14 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -1582,10 +1582,8 @@ static int coda_decoder_reqbufs(struct coda_ctx *ctx,
 
 static bool coda_reorder_enable(struct coda_ctx *ctx)
 {
-	const char * const *profile_names;
-	const char * const *level_names;
 	struct coda_dev *dev = ctx->dev;
-	int profile, level;
+	int profile;
 
 	if (dev->devtype->product != CODA_HX4 &&
 	    dev->devtype->product != CODA_7541 &&
@@ -1599,24 +1597,9 @@ static bool coda_reorder_enable(struct coda_ctx *ctx)
 		return true;
 
 	profile = coda_h264_profile(ctx->params.h264_profile_idc);
-	if (profile < 0) {
-		v4l2_warn(&dev->v4l2_dev, "Invalid H264 Profile: %d\n",
-			 ctx->params.h264_profile_idc);
-		return false;
-	}
-
-	level = coda_h264_level(ctx->params.h264_level_idc);
-	if (level < 0) {
-		v4l2_warn(&dev->v4l2_dev, "Invalid H264 Level: %d\n",
-			 ctx->params.h264_level_idc);
-		return false;
-	}
-
-	profile_names = v4l2_ctrl_get_menu(V4L2_CID_MPEG_VIDEO_H264_PROFILE);
-	level_names = v4l2_ctrl_get_menu(V4L2_CID_MPEG_VIDEO_H264_LEVEL);
-
-	v4l2_dbg(1, coda_debug, &dev->v4l2_dev, "H264 Profile/Level: %s L%s\n",
-		 profile_names[profile], level_names[level]);
+	if (profile < 0)
+		v4l2_warn(&dev->v4l2_dev, "Unknown H264 Profile: %u\n",
+			  ctx->params.h264_profile_idc);
 
 	/* Baseline profile does not support reordering */
 	return profile > V4L2_MPEG_VIDEO_H264_PROFILE_BASELINE;
-- 
2.17.1
