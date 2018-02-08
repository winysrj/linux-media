Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:60075 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751014AbeBHMof (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Feb 2018 07:44:35 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: yong.zhi@intel.com, Yang@nauris.fi.intel.com,
        Hyungwoo <hyungwoo.yang@intel.com>, Rapolu@nauris.fi.intel.com,
        Chiranjeevi <chiranjeevi.rapolu@intel.com>, andy.yeh@intel.com
Subject: [PATCH 5/5] ov5670: Use v4l2_find_nearest_size
Date: Thu,  8 Feb 2018 14:44:28 +0200
Message-Id: <1518093868-3444-6-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1518093868-3444-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1518093868-3444-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use v4l2_find_nearest_size instead of a driver specific function to find
nearest matching size.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/ov5670.c | 34 +++-------------------------------
 1 file changed, 3 insertions(+), 31 deletions(-)

diff --git a/drivers/media/i2c/ov5670.c b/drivers/media/i2c/ov5670.c
index 9f91965..028abc8 100644
--- a/drivers/media/i2c/ov5670.c
+++ b/drivers/media/i2c/ov5670.c
@@ -2180,36 +2180,6 @@ static int ov5670_enum_frame_size(struct v4l2_subdev *sd,
 	return 0;
 }
 
-/* Calculate resolution distance */
-static int ov5670_get_reso_dist(const struct ov5670_mode *mode,
-				struct v4l2_mbus_framefmt *framefmt)
-{
-	return abs(mode->width - framefmt->width) +
-	       abs(mode->height - framefmt->height);
-}
-
-/* Find the closest supported resolution to the requested resolution */
-static const struct ov5670_mode *ov5670_find_best_fit(
-						struct ov5670 *ov5670,
-						struct v4l2_subdev_format *fmt)
-{
-	struct v4l2_mbus_framefmt *framefmt = &fmt->format;
-	int dist;
-	int cur_best_fit = 0;
-	int cur_best_fit_dist = -1;
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(supported_modes); i++) {
-		dist = ov5670_get_reso_dist(&supported_modes[i], framefmt);
-		if (cur_best_fit_dist == -1 || dist < cur_best_fit_dist) {
-			cur_best_fit_dist = dist;
-			cur_best_fit = i;
-		}
-	}
-
-	return &supported_modes[cur_best_fit];
-}
-
 static void ov5670_update_pad_format(const struct ov5670_mode *mode,
 				     struct v4l2_subdev_format *fmt)
 {
@@ -2259,7 +2229,9 @@ static int ov5670_set_pad_format(struct v4l2_subdev *sd,
 
 	fmt->format.code = MEDIA_BUS_FMT_SGRBG10_1X10;
 
-	mode = ov5670_find_best_fit(ov5670, fmt);
+	mode = v4l2_find_nearest_size(
+		supported_modes, ARRAY_SIZE(supported_modes), width, height,
+		fmt->format.width, fmt->format.height);
 	ov5670_update_pad_format(mode, fmt);
 	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
 		*v4l2_subdev_get_try_format(sd, cfg, fmt->pad) = fmt->format;
-- 
2.7.4
