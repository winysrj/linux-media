Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:56723 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729842AbeIRSsB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Sep 2018 14:48:01 -0400
From: Marco Felsch <m.felsch@pengutronix.de>
To: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com
Cc: kernel@pengutronix.de, devicetree@vger.kernel.org,
        p.zabel@pengutronix.de, javierm@redhat.com,
        laurent.pinchart@ideasonboard.com, sakari.ailus@linux.intel.com,
        afshin.nasser@gmail.com, linux-media@vger.kernel.org
Subject: [PATCH v3 7/9] media: tvp5150: add FORMAT_TRY support for get/set selection handlers
Date: Tue, 18 Sep 2018 15:14:51 +0200
Message-Id: <20180918131453.21031-8-m.felsch@pengutronix.de>
In-Reply-To: <20180918131453.21031-1-m.felsch@pengutronix.de>
References: <20180918131453.21031-1-m.felsch@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since commit 10d5509c8d50 ("[media] v4l2: remove g/s_crop from video ops")
the 'which' field for set/get_selection must be FORMAT_ACTIVE. There is
no way to try different selections. The patch adds a helper function to
select the correct selection memory space (sub-device file handle or
driver state) which will be set/returned.

The TVP5150 AVID will be updated if the 'which' field is FORMAT_ACTIVE
and the requested selection rectangle differs from the already set one.

Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
---
 drivers/media/i2c/tvp5150.c | 109 +++++++++++++++++++++++++-----------
 1 file changed, 75 insertions(+), 34 deletions(-)

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index 40ecbce03e2c..b34d0e883c06 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -19,6 +19,7 @@
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-fwnode.h>
 #include <media/v4l2-mc.h>
+#include <media/v4l2-rect.h>
 
 #include "tvp5150_reg.h"
 
@@ -1007,20 +1008,40 @@ static void tvp5150_set_default(v4l2_std_id std, struct v4l2_rect *crop)
 		crop->height = TVP5150_V_MAX_OTHERS;
 }
 
+static struct v4l2_rect *
+__tvp5150_get_pad_crop(struct tvp5150 *decoder,
+		       struct v4l2_subdev_pad_config *cfg, unsigned int pad,
+		       enum v4l2_subdev_format_whence which)
+{
+	switch (which) {
+	case V4L2_SUBDEV_FORMAT_TRY:
+		return v4l2_subdev_get_try_crop(&decoder->sd, cfg, pad);
+	case V4L2_SUBDEV_FORMAT_ACTIVE:
+		return &decoder->rect;
+	default:
+		return NULL;
+	}
+}
+
 static int tvp5150_fill_fmt(struct v4l2_subdev *sd,
 			    struct v4l2_subdev_pad_config *cfg,
 			    struct v4l2_subdev_format *format)
 {
 	struct v4l2_mbus_framefmt *f;
+	struct v4l2_rect *__crop;
 	struct tvp5150 *decoder = to_tvp5150(sd);
 
 	if (!format || (format->pad != TVP5150_PAD_VID_OUT))
 		return -EINVAL;
 
 	f = &format->format;
+	__crop = __tvp5150_get_pad_crop(decoder, cfg, format->pad,
+					format->which);
+	if (!__crop)
+		return -EINVAL;
 
-	f->width = decoder->rect.width;
-	f->height = decoder->rect.height / 2;
+	f->width = __crop->width;
+	f->height = __crop->height / 2;
 
 	f->code = TVP5150_MBUS_FMT;
 	f->field = TVP5150_FIELD;
@@ -1031,17 +1052,51 @@ static int tvp5150_fill_fmt(struct v4l2_subdev *sd,
 	return 0;
 }
 
+unsigned int tvp5150_get_hmax(struct v4l2_subdev *sd)
+{
+	struct tvp5150 *decoder = to_tvp5150(sd);
+	v4l2_std_id std;
+
+	/* Calculate height based on current standard */
+	if (decoder->norm == V4L2_STD_ALL)
+		std = tvp5150_read_std(sd);
+	else
+		std = decoder->norm;
+
+	return (std & V4L2_STD_525_60) ?
+		TVP5150_V_MAX_525_60 : TVP5150_V_MAX_OTHERS;
+}
+
+static inline void
+__tvp5150_set_selection(struct v4l2_subdev *sd, struct v4l2_rect rect)
+{
+	struct tvp5150 *decoder = to_tvp5150(sd);
+	unsigned int hmax = tvp5150_get_hmax(sd);
+
+	regmap_write(decoder->regmap, TVP5150_VERT_BLANKING_START, rect.top);
+	regmap_write(decoder->regmap, TVP5150_VERT_BLANKING_STOP,
+		     rect.top + rect.height - hmax);
+	regmap_write(decoder->regmap, TVP5150_ACT_VD_CROP_ST_MSB,
+		     rect.left >> TVP5150_CROP_SHIFT);
+	regmap_write(decoder->regmap, TVP5150_ACT_VD_CROP_ST_LSB,
+		     rect.left | (1 << TVP5150_CROP_SHIFT));
+	regmap_write(decoder->regmap, TVP5150_ACT_VD_CROP_STP_MSB,
+		     (rect.left + rect.width - TVP5150_MAX_CROP_LEFT) >>
+		     TVP5150_CROP_SHIFT);
+	regmap_write(decoder->regmap, TVP5150_ACT_VD_CROP_STP_LSB,
+		     rect.left + rect.width - TVP5150_MAX_CROP_LEFT);
+}
+
 static int tvp5150_set_selection(struct v4l2_subdev *sd,
 				 struct v4l2_subdev_pad_config *cfg,
 				 struct v4l2_subdev_selection *sel)
 {
 	struct tvp5150 *decoder = to_tvp5150(sd);
 	struct v4l2_rect rect = sel->r;
-	v4l2_std_id std;
-	int hmax;
+	struct v4l2_rect *__crop;
+	unsigned int hmax;
 
-	if (sel->which != V4L2_SUBDEV_FORMAT_ACTIVE ||
-	    sel->target != V4L2_SEL_TGT_CROP)
+	if (sel->target != V4L2_SEL_TGT_CROP)
 		return -EINVAL;
 
 	dev_dbg_lvl(sd->dev, 1, debug, "%s left=%d, top=%d, width=%d, height=%d\n",
@@ -1050,17 +1105,7 @@ static int tvp5150_set_selection(struct v4l2_subdev *sd,
 	/* tvp5150 has some special limits */
 	rect.left = clamp(rect.left, 0, TVP5150_MAX_CROP_LEFT);
 	rect.top = clamp(rect.top, 0, TVP5150_MAX_CROP_TOP);
-
-	/* Calculate height based on current standard */
-	if (decoder->norm == V4L2_STD_ALL)
-		std = tvp5150_read_std(sd);
-	else
-		std = decoder->norm;
-
-	if (std & V4L2_STD_525_60)
-		hmax = TVP5150_V_MAX_525_60;
-	else
-		hmax = TVP5150_V_MAX_OTHERS;
+	hmax = tvp5150_get_hmax(sd);
 
 	/*
 	 * alignments:
@@ -1073,20 +1118,18 @@ static int tvp5150_set_selection(struct v4l2_subdev *sd,
 			      hmax - TVP5150_MAX_CROP_TOP - rect.top,
 			      hmax - rect.top, 0, 0);
 
-	regmap_write(decoder->regmap, TVP5150_VERT_BLANKING_START, rect.top);
-	regmap_write(decoder->regmap, TVP5150_VERT_BLANKING_STOP,
-		      rect.top + rect.height - hmax);
-	regmap_write(decoder->regmap, TVP5150_ACT_VD_CROP_ST_MSB,
-		      rect.left >> TVP5150_CROP_SHIFT);
-	regmap_write(decoder->regmap, TVP5150_ACT_VD_CROP_ST_LSB,
-		      rect.left | (1 << TVP5150_CROP_SHIFT));
-	regmap_write(decoder->regmap, TVP5150_ACT_VD_CROP_STP_MSB,
-		      (rect.left + rect.width - TVP5150_MAX_CROP_LEFT) >>
-		      TVP5150_CROP_SHIFT);
-	regmap_write(decoder->regmap, TVP5150_ACT_VD_CROP_STP_LSB,
-		      rect.left + rect.width - TVP5150_MAX_CROP_LEFT);
+	__crop = __tvp5150_get_pad_crop(decoder, cfg, sel->pad,
+						  sel->which);
+
+	/*
+	 * Update output image size if the selection (crop) rectangle size or
+	 * position has been modified.
+	 */
+	if (!v4l2_rect_equal(&rect, __crop))
+		if (sel->which == V4L2_SUBDEV_FORMAT_ACTIVE)
+			__tvp5150_set_selection(sd, rect);
 
-	decoder->rect = rect;
+	*__crop = rect;
 
 	return 0;
 }
@@ -1098,9 +1141,6 @@ static int tvp5150_get_selection(struct v4l2_subdev *sd,
 	struct tvp5150 *decoder = container_of(sd, struct tvp5150, sd);
 	v4l2_std_id std;
 
-	if (sel->which != V4L2_SUBDEV_FORMAT_ACTIVE)
-		return -EINVAL;
-
 	switch (sel->target) {
 	case V4L2_SEL_TGT_CROP_BOUNDS:
 	case V4L2_SEL_TGT_CROP_DEFAULT:
@@ -1119,7 +1159,8 @@ static int tvp5150_get_selection(struct v4l2_subdev *sd,
 			sel->r.height = TVP5150_V_MAX_OTHERS;
 		return 0;
 	case V4L2_SEL_TGT_CROP:
-		sel->r = decoder->rect;
+		sel->r = *__tvp5150_get_pad_crop(decoder, cfg, sel->pad,
+						      sel->which);
 		return 0;
 	default:
 		return -EINVAL;
-- 
2.19.0
