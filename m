Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:44522 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751423AbeCUIm5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Mar 2018 04:42:57 -0400
From: Todor Tomov <todor.tomov@linaro.org>
To: sakari.ailus@linux.intel.com, linux-media@vger.kernel.org
Cc: mchehab@kernel.org, Todor Tomov <todor.tomov@linaro.org>
Subject: [PATCH] media: ov5645: Use v4l2_find_nearest_size
Date: Wed, 21 Mar 2018 16:42:36 +0800
Message-Id: <1521621756-20360-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use v4l2_find_nearest_size instead of a driver specific function to find
nearest matching size.

Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
---

This depends on [1] from Sakari. Thank you, Sakari, this is nice.

[1] https://git.linuxtv.org/sailus/media_tree.git/commit/?h=v4l2-common-size&id=83fdb8a0ab43fc86c329f63f1052e6113871a965

 drivers/media/i2c/ov5645.c | 24 +++++-------------------
 1 file changed, 5 insertions(+), 19 deletions(-)

diff --git a/drivers/media/i2c/ov5645.c b/drivers/media/i2c/ov5645.c
index d28845f..79db74c 100644
--- a/drivers/media/i2c/ov5645.c
+++ b/drivers/media/i2c/ov5645.c
@@ -959,23 +959,6 @@ __ov5645_get_pad_crop(struct ov5645 *ov5645, struct v4l2_subdev_pad_config *cfg,
 	}
 }
 
-static const struct ov5645_mode_info *
-ov5645_find_nearest_mode(unsigned int width, unsigned int height)
-{
-	int i;
-
-	for (i = ARRAY_SIZE(ov5645_mode_info_data) - 1; i >= 0; i--) {
-		if (ov5645_mode_info_data[i].width <= width &&
-		    ov5645_mode_info_data[i].height <= height)
-			break;
-	}
-
-	if (i < 0)
-		i = 0;
-
-	return &ov5645_mode_info_data[i];
-}
-
 static int ov5645_set_format(struct v4l2_subdev *sd,
 			     struct v4l2_subdev_pad_config *cfg,
 			     struct v4l2_subdev_format *format)
@@ -989,8 +972,11 @@ static int ov5645_set_format(struct v4l2_subdev *sd,
 	__crop = __ov5645_get_pad_crop(ov5645, cfg, format->pad,
 			format->which);
 
-	new_mode = ov5645_find_nearest_mode(format->format.width,
-					    format->format.height);
+	new_mode = v4l2_find_nearest_size(ov5645_mode_info_data,
+			       ARRAY_SIZE(ov5645_mode_info_data),
+			       width, height,
+			       format->format.width, format->format.height);
+
 	__crop->width = new_mode->width;
 	__crop->height = new_mode->height;
 
-- 
2.7.4
