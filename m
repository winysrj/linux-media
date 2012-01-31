Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:53442 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973Ab2AaJX5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Jan 2012 04:23:57 -0500
Received: by werb13 with SMTP id b13so154342wer.19
        for <linux-media@vger.kernel.org>; Tue, 31 Jan 2012 01:23:55 -0800 (PST)
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, hverkuil@xs4all.nl,
	Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH 1/2] media: tvp5150: Add cropping support.
Date: Tue, 31 Jan 2012 10:23:46 +0100
Message-Id: <1328001827-21251-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
 drivers/media/video/tvp5150.c |  127 +++++++++++++++++++++++++++++++++++++++--
 1 files changed, 122 insertions(+), 5 deletions(-)

diff --git a/drivers/media/video/tvp5150.c b/drivers/media/video/tvp5150.c
index c58c8d5..b1476f6 100644
--- a/drivers/media/video/tvp5150.c
+++ b/drivers/media/video/tvp5150.c
@@ -16,6 +16,13 @@
 
 #include "tvp5150_reg.h"
 
+#define TVP5150_H_MAX		720
+#define TVP5150_V_MAX_525_60	480
+#define TVP5150_V_MAX_OTHERS	576
+#define TVP5150_MAX_CROP_LEFT	511
+#define TVP5150_MAX_CROP_TOP	127
+#define TVP5150_CROP_SHIFT	2
+
 MODULE_DESCRIPTION("Texas Instruments TVP5150A video decoder driver");
 MODULE_AUTHOR("Mauro Carvalho Chehab");
 MODULE_LICENSE("GPL");
@@ -28,6 +35,7 @@ MODULE_PARM_DESC(debug, "Debug level (0-2)");
 struct tvp5150 {
 	struct v4l2_subdev sd;
 	struct v4l2_ctrl_handler hdl;
+	struct v4l2_rect rect;
 
 	v4l2_std_id norm;	/* Current set standard */
 	u32 input;
@@ -731,6 +739,13 @@ static int tvp5150_s_std(struct v4l2_subdev *sd, v4l2_std_id std)
 	if (decoder->norm == std)
 		return 0;
 
+	/* Change cropping height limits */
+	if (std & V4L2_STD_525_60)
+		decoder->rect.height = TVP5150_V_MAX_525_60;
+	else
+		decoder->rect.height = TVP5150_V_MAX_OTHERS;
+
+
 	return tvp5150_set_std(sd, std);
 }
 
@@ -827,11 +842,8 @@ static int tvp5150_mbus_fmt(struct v4l2_subdev *sd,
 	else
 		std = decoder->norm;
 
-	f->width = 720;
-	if (std & V4L2_STD_525_60)
-		f->height = 480;
-	else
-		f->height = 576;
+	f->width = decoder->rect.width;
+	f->height = decoder->rect.height;
 
 	f->code = V4L2_MBUS_FMT_YUYV8_2X8;
 	f->field = V4L2_FIELD_SEQ_TB;
@@ -842,6 +854,99 @@ static int tvp5150_mbus_fmt(struct v4l2_subdev *sd,
 	return 0;
 }
 
+static int tvp5150_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
+{
+	struct v4l2_rect rect = a->c;
+	struct tvp5150 *decoder = to_tvp5150(sd);
+	v4l2_std_id std;
+	int hmax;
+
+	v4l2_dbg(1, debug, sd, "%s left=%d, top=%d, width=%d, height=%d\n",
+		__func__, rect.left, rect.top, rect.width, rect.height);
+
+	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	/* tvp5150 has some special limits */
+	rect.left = clamp(rect.left, 0, TVP5150_MAX_CROP_LEFT);
+	rect.width = clamp(rect.width,
+			   TVP5150_H_MAX - TVP5150_MAX_CROP_LEFT - rect.left,
+			   TVP5150_H_MAX - rect.left);
+	rect.top = clamp(rect.top, 0, TVP5150_MAX_CROP_TOP);
+
+	/* Calculate height based on current standard */
+	if (decoder->norm == V4L2_STD_ALL)
+		std = tvp5150_read_std(sd);
+	else
+		std = decoder->norm;
+
+	if (std & V4L2_STD_525_60)
+		hmax = TVP5150_V_MAX_525_60;
+	else
+		hmax = TVP5150_V_MAX_OTHERS;
+
+	rect.height = clamp(rect.height,
+			    hmax - TVP5150_MAX_CROP_TOP - rect.top,
+			    hmax - rect.top);
+
+	tvp5150_write(sd, TVP5150_VERT_BLANKING_START, rect.top);
+	tvp5150_write(sd, TVP5150_VERT_BLANKING_STOP,
+		      rect.top + rect.height - hmax);
+	tvp5150_write(sd, TVP5150_ACT_VD_CROP_ST_MSB,
+		      rect.left >> TVP5150_CROP_SHIFT);
+	tvp5150_write(sd, TVP5150_ACT_VD_CROP_ST_LSB,
+		      rect.left | (1 << TVP5150_CROP_SHIFT));
+	tvp5150_write(sd, TVP5150_ACT_VD_CROP_STP_MSB,
+		      (rect.left + rect.width - TVP5150_MAX_CROP_LEFT) >>
+		      TVP5150_CROP_SHIFT);
+	tvp5150_write(sd, TVP5150_ACT_VD_CROP_STP_LSB,
+		      rect.left + rect.width - TVP5150_MAX_CROP_LEFT);
+
+	decoder->rect = rect;
+
+	return 0;
+}
+
+static int tvp5150_g_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
+{
+	struct tvp5150 *decoder = container_of(sd, struct tvp5150, sd);
+
+	a->c	= decoder->rect;
+	a->type	= V4L2_BUF_TYPE_VIDEO_CAPTURE;
+
+	return 0;
+}
+
+static int tvp5150_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
+{
+	struct tvp5150 *decoder = container_of(sd, struct tvp5150, sd);
+	v4l2_std_id std;
+
+	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	a->bounds.left			= 0;
+	a->bounds.top			= 0;
+	a->bounds.width			= TVP5150_H_MAX;
+
+	/* Calculate height based on current standard */
+	if (decoder->norm == V4L2_STD_ALL)
+		std = tvp5150_read_std(sd);
+	else
+		std = decoder->norm;
+
+	if (std & V4L2_STD_525_60)
+		a->bounds.height = TVP5150_V_MAX_525_60;
+	else
+		a->bounds.height = TVP5150_V_MAX_OTHERS;
+
+	a->defrect			= a->bounds;
+	a->pixelaspect.numerator	= 1;
+	a->pixelaspect.denominator	= 1;
+
+	return 0;
+}
+
 /****************************************************************************
 			I2C Command
  ****************************************************************************/
@@ -997,6 +1102,9 @@ static const struct v4l2_subdev_video_ops tvp5150_video_ops = {
 	.enum_mbus_fmt = tvp5150_enum_mbus_fmt,
 	.s_mbus_fmt = tvp5150_mbus_fmt,
 	.try_mbus_fmt = tvp5150_mbus_fmt,
+	.s_crop = tvp5150_s_crop,
+	.g_crop = tvp5150_g_crop,
+	.cropcap = tvp5150_cropcap,
 };
 
 static const struct v4l2_subdev_vbi_ops tvp5150_vbi_ops = {
@@ -1082,6 +1190,15 @@ static int tvp5150_probe(struct i2c_client *c,
 	}
 	v4l2_ctrl_handler_setup(&core->hdl);
 
+	/* Default is no cropping */
+	core->rect.top = 0;
+	if (tvp5150_read_std(sd) & V4L2_STD_525_60)
+		core->rect.height = TVP5150_V_MAX_525_60;
+	else
+		core->rect.height = TVP5150_V_MAX_OTHERS;
+	core->rect.left = 0;
+	core->rect.width = TVP5150_H_MAX;
+
 	if (debug > 1)
 		tvp5150_log_status(sd);
 	return 0;
-- 
1.7.0.4

