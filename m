Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:42526 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750847AbeBHJmX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Feb 2018 04:42:23 -0500
From: Todor Tomov <todor.tomov@linaro.org>
To: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        hverkuil@xs4all.nl
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Todor Tomov <todor.tomov@linaro.org>
Subject: [PATCH 2/2] media: ov5645: Improve mode finding function
Date: Thu,  8 Feb 2018 11:42:00 +0200
Message-Id: <1518082920-11309-2-git-send-email-todor.tomov@linaro.org>
In-Reply-To: <1518082920-11309-1-git-send-email-todor.tomov@linaro.org>
References: <1518082920-11309-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Find the sensor mode by comparing the size of the requested image size
and the sensor mode's image size. The distance between image sizes is the
size in pixels of the non-overlapping regions between the requested size
and the frame-specified size. This logic is borrowed from et8ek8 sensor
driver.

Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
---
 drivers/media/i2c/ov5645.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/media/i2c/ov5645.c b/drivers/media/i2c/ov5645.c
index 9755562..6d06c50 100644
--- a/drivers/media/i2c/ov5645.c
+++ b/drivers/media/i2c/ov5645.c
@@ -964,18 +964,24 @@ __ov5645_get_pad_crop(struct ov5645 *ov5645, struct v4l2_subdev_pad_config *cfg,
 static const struct ov5645_mode_info *
 ov5645_find_nearest_mode(unsigned int width, unsigned int height)
 {
-	int i;
+	unsigned int max_dist_match = (unsigned int) -1;
+	int i, n = 0;
 
-	for (i = ARRAY_SIZE(ov5645_mode_info_data) - 1; i >= 0; i--) {
-		if (ov5645_mode_info_data[i].width <= width &&
-		    ov5645_mode_info_data[i].height <= height)
-			break;
+	for (i = 0; i < ARRAY_SIZE(ov5645_mode_info_data); i++) {
+		unsigned int dist = min(width, ov5645_mode_info_data[i].width)
+				* min(height, ov5645_mode_info_data[i].height);
+
+		dist = ov5645_mode_info_data[i].width *
+				ov5645_mode_info_data[i].height
+		     + width * height - 2 * dist;
+
+		if (dist < max_dist_match) {
+			n = i;
+			max_dist_match = dist;
+		}
 	}
 
-	if (i < 0)
-		i = 0;
-
-	return &ov5645_mode_info_data[i];
+	return &ov5645_mode_info_data[n];
 }
 
 static int ov5645_set_format(struct v4l2_subdev *sd,
-- 
2.7.4
