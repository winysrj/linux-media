Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35310 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753402AbcISWDM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Sep 2016 18:03:12 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: sre@kernel.org
Subject: [PATCH v3 05/18] smiapp: Provide a common function to obtain native pixel array size
Date: Tue, 20 Sep 2016 01:02:38 +0300
Message-Id: <1474322571-20290-6-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1474322571-20290-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1474322571-20290-1-git-send-email-sakari.ailus@linux.intel.com>
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
index 86c0d7c..e5d4584 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2161,6 +2161,15 @@ static int smiapp_set_crop(struct v4l2_subdev *subdev,
 	return 0;
 }
 
+static void smiapp_get_native_size(struct smiapp_subdev *ssd,
+				    struct v4l2_rect *r)
+{
+	r->top = 0;
+	r->left = 0;
+	r->width = ssd->sensor->limits[SMIAPP_LIMIT_X_ADDR_MAX] + 1;
+	r->height = ssd->sensor->limits[SMIAPP_LIMIT_Y_ADDR_MAX] + 1;
+}
+
 static int __smiapp_get_selection(struct v4l2_subdev *subdev,
 				  struct v4l2_subdev_pad_config *cfg,
 				  struct v4l2_subdev_selection *sel)
@@ -2192,17 +2201,12 @@ static int __smiapp_get_selection(struct v4l2_subdev *subdev,
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
+			smiapp_get_native_size(ssd, &sel->r);
+		else if (sel->pad == ssd->sink_pad)
 			sel->r = sink_fmt;
-		} else {
+		else
 			sel->r = *comp;
-		}
 		break;
 	case V4L2_SEL_TGT_CROP:
 	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
@@ -2564,10 +2568,8 @@ static void smiapp_create_subdev(struct smiapp_sensor *sensor,
 		 sizeof(ssd->sd.name), "%s %s %d-%4.4x", sensor->minfo.name,
 		 name, i2c_adapter_id(client->adapter), client->addr);
 
-	ssd->sink_fmt.width =
-		sensor->limits[SMIAPP_LIMIT_X_ADDR_MAX] + 1;
-	ssd->sink_fmt.height =
-		sensor->limits[SMIAPP_LIMIT_Y_ADDR_MAX] + 1;
+	smiapp_get_native_size(ssd, &ssd->sink_fmt);
+
 	ssd->compose.width = ssd->sink_fmt.width;
 	ssd->compose.height = ssd->sink_fmt.height;
 	ssd->crop[ssd->source_pad] = ssd->compose;
@@ -2840,16 +2842,13 @@ static int smiapp_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
 		struct v4l2_rect *try_crop = v4l2_subdev_get_try_crop(sd, fh->pad, i);
 		struct v4l2_rect *try_comp;
 
-		try_fmt->width = sensor->limits[SMIAPP_LIMIT_X_ADDR_MAX] + 1;
-		try_fmt->height = sensor->limits[SMIAPP_LIMIT_Y_ADDR_MAX] + 1;
+		smiapp_get_native_size(ssd, try_crop);
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
2.1.4

