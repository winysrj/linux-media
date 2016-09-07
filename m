Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:8897 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754547AbcIGKbs (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Sep 2016 06:31:48 -0400
Received: from nauris.fi.intel.com (nauris.localdomain [192.168.240.2])
        by paasikivi.fi.intel.com (Postfix) with ESMTP id 8ADF122E8A
        for <linux-media@vger.kernel.org>; Wed,  7 Sep 2016 13:31:23 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 5/7] smiapp: Provide a common function to obtain native pixel array size
Date: Wed,  7 Sep 2016 13:30:13 +0300
Message-Id: <1473244215-19432-6-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1473244215-19432-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1473244215-19432-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The same pixel array size is required for the active format of each
sub-device sink pad and try format of each sink pad of each opened file
handle as well as for the native size rectangle.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c | 39 +++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 20 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 346b677..4bb0b296 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2153,6 +2153,15 @@ static int smiapp_set_crop(struct v4l2_subdev *subdev,
 	return 0;
 }
 
+static void smiapp_get_native_size(struct smiapp_sensor *sensor,
+				    struct v4l2_rect *r)
+{
+	r->top = 0;
+	r->left = 0;
+	r->width = sensor->limits[SMIAPP_LIMIT_X_ADDR_MAX] + 1;
+	r->height = sensor->limits[SMIAPP_LIMIT_Y_ADDR_MAX] + 1;
+}
+
 static int __smiapp_get_selection(struct v4l2_subdev *subdev,
 				  struct v4l2_subdev_pad_config *cfg,
 				  struct v4l2_subdev_selection *sel)
@@ -2184,17 +2193,12 @@ static int __smiapp_get_selection(struct v4l2_subdev *subdev,
 	switch (sel->target) {
 	case V4L2_SEL_TGT_CROP_BOUNDS:
 	case V4L2_SEL_TGT_NATIVE_SIZE:
-		if (ssd == sensor->pixel_array) {
-			sel->r.left = sel->r.top = 0;
-			sel->r.width =
-				sensor->limits[SMIAPP_LIMIT_X_ADDR_MAX] + 1;
-			sel->r.height =
-				sensor->limits[SMIAPP_LIMIT_Y_ADDR_MAX] + 1;
-		} else if (sel->pad == ssd->sink_pad) {
+		if (ssd == sensor->pixel_array)
+			smiapp_get_native_size(sensor, &sel->r);
+		else if (sel->pad == ssd->sink_pad)
 			sel->r = sink_fmt;
-		} else {
+		else
 			sel->r = *comp;
-		}
 		break;
 	case V4L2_SEL_TGT_CROP:
 	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
@@ -2549,10 +2553,8 @@ static void smiapp_create_subdev(struct smiapp_sensor *sensor,
 		 sizeof(ssd->sd.name), "%s %s %d-%4.4x", sensor->minfo.name,
 		 name, i2c_adapter_id(client->adapter), client->addr);
 
-	ssd->sink_fmt.width =
-		sensor->limits[SMIAPP_LIMIT_X_ADDR_MAX] + 1;
-	ssd->sink_fmt.height =
-		sensor->limits[SMIAPP_LIMIT_Y_ADDR_MAX] + 1;
+	smiapp_get_native_size(sensor, &ssd->sink_fmt);
+
 	ssd->compose.width = ssd->sink_fmt.width;
 	ssd->compose.height = ssd->sink_fmt.height;
 	ssd->crop[ssd->source_pad] = ssd->compose;
@@ -2826,16 +2828,13 @@ static int smiapp_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
 		struct v4l2_rect *try_crop = v4l2_subdev_get_try_crop(sd, fh->pad, i);
 		struct v4l2_rect *try_comp;
 
-		try_fmt->width = sensor->limits[SMIAPP_LIMIT_X_ADDR_MAX] + 1;
-		try_fmt->height = sensor->limits[SMIAPP_LIMIT_Y_ADDR_MAX] + 1;
+		smiapp_get_native_size(sensor, try_crop);
+
+		try_fmt->width = try_crop->width;
+		try_fmt->height = try_crop->height;
 		try_fmt->code = mbus_code;
 		try_fmt->field = V4L2_FIELD_NONE;
 
-		try_crop->top = 0;
-		try_crop->left = 0;
-		try_crop->width = try_fmt->width;
-		try_crop->height = try_fmt->height;
-
 		if (ssd != sensor->pixel_array)
 			continue;
 
-- 
2.7.4

