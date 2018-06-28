Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:43923 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751757AbeF1QVW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Jun 2018 12:21:22 -0400
From: Marco Felsch <m.felsch@pengutronix.de>
To: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com
Cc: p.zabel@pengutronix.de, afshin.nasser@gmail.com,
        javierm@redhat.com, sakari.ailus@linux.intel.com,
        laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH 07/22] [media] tvp5150: add default format helper
Date: Thu, 28 Jun 2018 18:20:39 +0200
Message-Id: <20180628162054.25613-8-m.felsch@pengutronix.de>
In-Reply-To: <20180628162054.25613-1-m.felsch@pengutronix.de>
References: <20180628162054.25613-1-m.felsch@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The patch adds three macros to bundle the mbus_framefmt default
values and a helper function to set the the default crop and
mbus_framefmt values.

Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
---
 drivers/media/i2c/tvp5150.c | 42 ++++++++++++++++++++++---------------
 1 file changed, 25 insertions(+), 17 deletions(-)

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index 29eaf8166f25..c73536cfcc62 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -28,6 +28,9 @@
 #define TVP5150_MAX_CROP_LEFT	511
 #define TVP5150_MAX_CROP_TOP	127
 #define TVP5150_CROP_SHIFT	2
+#define TVP5150_MBUS_FMT	MEDIA_BUS_FMT_UYVY8_2X8
+#define TVP5150_FIELD		V4L2_FIELD_ALTERNATE
+#define TVP5150_COLORSPACE	V4L2_COLORSPACE_SMPTE170M
 
 MODULE_DESCRIPTION("Texas Instruments TVP5150A/TVP5150AM1/TVP5151 video decoder driver");
 MODULE_AUTHOR("Mauro Carvalho Chehab");
@@ -847,6 +850,18 @@ static v4l2_std_id tvp5150_read_std(struct v4l2_subdev *sd)
 	}
 }
 
+static void tvp5150_set_default(v4l2_std_id std, struct v4l2_rect *crop)
+{
+	/* Default is no cropping */
+	crop->top = 0;
+	crop->left = 0;
+	crop->width = TVP5150_H_MAX;
+	if (std & V4L2_STD_525_60)
+		crop->height = TVP5150_V_MAX_525_60;
+	else
+		crop->height = TVP5150_V_MAX_OTHERS;
+}
+
 static struct v4l2_rect *
 __tvp5150_get_pad_crop(struct tvp5150 *decoder,
 		       struct v4l2_subdev_pad_config *cfg, unsigned int pad,
@@ -863,8 +878,8 @@ __tvp5150_get_pad_crop(struct tvp5150 *decoder,
 }
 
 static int tvp5150_fill_fmt(struct v4l2_subdev *sd,
-		struct v4l2_subdev_pad_config *cfg,
-		struct v4l2_subdev_format *format)
+			    struct v4l2_subdev_pad_config *cfg,
+			    struct v4l2_subdev_format *format)
 {
 	struct v4l2_mbus_framefmt *f;
 	struct v4l2_rect *__crop;
@@ -880,12 +895,12 @@ static int tvp5150_fill_fmt(struct v4l2_subdev *sd,
 	f->width = __crop->width;
 	f->height = __crop->height / 2;
 
-	f->code = MEDIA_BUS_FMT_UYVY8_2X8;
-	f->field = V4L2_FIELD_ALTERNATE;
-	f->colorspace = V4L2_COLORSPACE_SMPTE170M;
+	f->code = TVP5150_MBUS_FMT;
+	f->field = TVP5150_FIELD;
+	f->colorspace = TVP5150_COLORSPACE;
 
 	dev_dbg_lvl(sd->dev, 1, debug, "width = %d, height = %d\n", f->width,
-			f->height);
+		    f->height);
 	return 0;
 }
 
@@ -1026,7 +1041,7 @@ static int tvp5150_enum_mbus_code(struct v4l2_subdev *sd,
 	if (code->pad || code->index)
 		return -EINVAL;
 
-	code->code = MEDIA_BUS_FMT_UYVY8_2X8;
+	code->code = TVP5150_MBUS_FMT;
 	return 0;
 }
 
@@ -1036,10 +1051,10 @@ static int tvp5150_enum_frame_size(struct v4l2_subdev *sd,
 {
 	struct tvp5150 *decoder = to_tvp5150(sd);
 
-	if (fse->index >= 8 || fse->code != MEDIA_BUS_FMT_UYVY8_2X8)
+	if (fse->index >= 8 || fse->code != TVP5150_MBUS_FMT)
 		return -EINVAL;
 
-	fse->code = MEDIA_BUS_FMT_UYVY8_2X8;
+	fse->code = TVP5150_MBUS_FMT;
 	fse->min_width = decoder->rect.width;
 	fse->max_width = decoder->rect.width;
 	fse->min_height = decoder->rect.height / 2;
@@ -1650,14 +1665,7 @@ static int tvp5150_probe(struct i2c_client *c,
 		goto err;
 	}
 
-	/* Default is no cropping */
-	core->rect.top = 0;
-	if (tvp5150_read_std(sd) & V4L2_STD_525_60)
-		core->rect.height = TVP5150_V_MAX_525_60;
-	else
-		core->rect.height = TVP5150_V_MAX_OTHERS;
-	core->rect.left = 0;
-	core->rect.width = TVP5150_H_MAX;
+	tvp5150_set_default(tvp5150_read_std(sd), &core->rect);
 
 	tvp5150_reset(sd, 0);	/* Calls v4l2_ctrl_handler_setup() */
 
-- 
2.17.1
