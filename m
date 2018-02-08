Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:58812 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750882AbeBHMof (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Feb 2018 07:44:35 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: yong.zhi@intel.com, Yang@nauris.fi.intel.com,
        Hyungwoo <hyungwoo.yang@intel.com>, Rapolu@nauris.fi.intel.com,
        Chiranjeevi <chiranjeevi.rapolu@intel.com>, andy.yeh@intel.com
Subject: [PATCH 4/5] ov13858: Use v4l2_find_nearest_size
Date: Thu,  8 Feb 2018 14:44:27 +0200
Message-Id: <1518093868-3444-5-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1518093868-3444-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1518093868-3444-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use v4l2_find_nearest_size instead of a driver specific function to find
nearest matching size.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/ov13858.c | 37 +++----------------------------------
 1 file changed, 3 insertions(+), 34 deletions(-)

diff --git a/drivers/media/i2c/ov13858.c b/drivers/media/i2c/ov13858.c
index bf7d06f..a7c42f8 100644
--- a/drivers/media/i2c/ov13858.c
+++ b/drivers/media/i2c/ov13858.c
@@ -1348,39 +1348,6 @@ static int ov13858_get_pad_format(struct v4l2_subdev *sd,
 	return ret;
 }
 
-/*
- * Calculate resolution distance
- */
-static int
-ov13858_get_resolution_dist(const struct ov13858_mode *mode,
-			    struct v4l2_mbus_framefmt *framefmt)
-{
-	return abs(mode->width - framefmt->width) +
-	       abs(mode->height - framefmt->height);
-}
-
-/*
- * Find the closest supported resolution to the requested resolution
- */
-static const struct ov13858_mode *
-ov13858_find_best_fit(struct ov13858 *ov13858,
-		      struct v4l2_subdev_format *fmt)
-{
-	int i, dist, cur_best_fit = 0, cur_best_fit_dist = -1;
-	struct v4l2_mbus_framefmt *framefmt = &fmt->format;
-
-	for (i = 0; i < ARRAY_SIZE(supported_modes); i++) {
-		dist = ov13858_get_resolution_dist(&supported_modes[i],
-						   framefmt);
-		if (cur_best_fit_dist == -1 || dist < cur_best_fit_dist) {
-			cur_best_fit_dist = dist;
-			cur_best_fit = i;
-		}
-	}
-
-	return &supported_modes[cur_best_fit];
-}
-
 static int
 ov13858_set_pad_format(struct v4l2_subdev *sd,
 		       struct v4l2_subdev_pad_config *cfg,
@@ -1401,7 +1368,9 @@ ov13858_set_pad_format(struct v4l2_subdev *sd,
 	if (fmt->format.code != MEDIA_BUS_FMT_SGRBG10_1X10)
 		fmt->format.code = MEDIA_BUS_FMT_SGRBG10_1X10;
 
-	mode = ov13858_find_best_fit(ov13858, fmt);
+	mode = v4l2_find_nearest_size(
+		supported_modes, ARRAY_SIZE(supported_modes), width, height,
+		fmt->format.width, fmt->format.height);
 	ov13858_update_pad_format(mode, fmt);
 	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
 		framefmt = v4l2_subdev_get_try_format(sd, cfg, fmt->pad);
-- 
2.7.4
