Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:54713 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753621AbcADM0Q (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jan 2016 07:26:16 -0500
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: devicetree@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Enrico Butera <ebutera@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Enric Balletbo i Serra <eballetbo@gmail.com>,
	Rob Herring <robh+dt@kernel.org>,
	Eduard Gavin <egavinc@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org,
	Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH 03/10] [media] tvp5150: Add pad-level subdev operations
Date: Mon,  4 Jan 2016 09:25:25 -0300
Message-Id: <1451910332-23385-4-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1451910332-23385-1-git-send-email-javier@osg.samsung.com>
References: <1451910332-23385-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

This patch enables the tvp5150 decoder driver to be used with the media
controller framework by adding pad-level subdev operations and init the
media entity pad.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
---

 drivers/media/i2c/tvp5150.c | 60 +++++++++++++++++++++++++++++++++------------
 1 file changed, 45 insertions(+), 15 deletions(-)

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index b3b34e24db13..82fba9d46f30 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -35,6 +35,7 @@ MODULE_PARM_DESC(debug, "Debug level (0-2)");
 
 struct tvp5150 {
 	struct v4l2_subdev sd;
+	struct media_pad pad;
 	struct v4l2_ctrl_handler hdl;
 	struct v4l2_rect rect;
 
@@ -818,17 +819,6 @@ static v4l2_std_id tvp5150_read_std(struct v4l2_subdev *sd)
 	}
 }
 
-static int tvp5150_enum_mbus_code(struct v4l2_subdev *sd,
-		struct v4l2_subdev_pad_config *cfg,
-		struct v4l2_subdev_mbus_code_enum *code)
-{
-	if (code->pad || code->index)
-		return -EINVAL;
-
-	code->code = MEDIA_BUS_FMT_UYVY8_2X8;
-	return 0;
-}
-
 static int tvp5150_fill_fmt(struct v4l2_subdev *sd,
 		struct v4l2_subdev_pad_config *cfg,
 		struct v4l2_subdev_format *format)
@@ -841,13 +831,11 @@ static int tvp5150_fill_fmt(struct v4l2_subdev *sd,
 
 	f = &format->format;
 
-	tvp5150_reset(sd, 0);
-
 	f->width = decoder->rect.width;
-	f->height = decoder->rect.height;
+	f->height = decoder->rect.height / 2;
 
 	f->code = MEDIA_BUS_FMT_UYVY8_2X8;
-	f->field = V4L2_FIELD_SEQ_TB;
+	f->field = V4L2_FIELD_ALTERNATE;
 	f->colorspace = V4L2_COLORSPACE_SMPTE170M;
 
 	v4l2_dbg(1, debug, sd, "width = %d, height = %d\n", f->width,
@@ -948,6 +936,39 @@ static int tvp5150_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
 	return 0;
 }
 
+ /****************************************************************************
+			V4L2 subdev pad ops
+ ****************************************************************************/
+
+static int tvp5150_enum_mbus_code(struct v4l2_subdev *sd,
+				  struct v4l2_subdev_pad_config *cfg,
+				  struct v4l2_subdev_mbus_code_enum *code)
+{
+	if (code->index)
+		return -EINVAL;
+
+	code->code = MEDIA_BUS_FMT_UYVY8_2X8;
+	return 0;
+}
+
+static int tvp5150_enum_frame_size(struct v4l2_subdev *sd,
+				   struct v4l2_subdev_pad_config *cfg,
+				   struct v4l2_subdev_frame_size_enum *fse)
+{
+	struct tvp5150 *decoder = to_tvp5150(sd);
+
+	if (fse->index >= 8 || fse->code != MEDIA_BUS_FMT_UYVY8_2X8)
+		return -EINVAL;
+
+	fse->code = MEDIA_BUS_FMT_UYVY8_2X8;
+	fse->min_width = decoder->rect.width;
+	fse->max_width = decoder->rect.width;
+	fse->min_height = decoder->rect.height / 2;
+	fse->max_height = decoder->rect.height / 2;
+
+	return 0;
+}
+
 /****************************************************************************
 			I2C Command
  ****************************************************************************/
@@ -1088,6 +1109,7 @@ static const struct v4l2_subdev_vbi_ops tvp5150_vbi_ops = {
 
 static const struct v4l2_subdev_pad_ops tvp5150_pad_ops = {
 	.enum_mbus_code = tvp5150_enum_mbus_code,
+	.enum_frame_size = tvp5150_enum_frame_size,
 	.set_fmt = tvp5150_fill_fmt,
 	.get_fmt = tvp5150_fill_fmt,
 };
@@ -1165,6 +1187,14 @@ static int tvp5150_probe(struct i2c_client *c,
 		return -ENOMEM;
 	sd = &core->sd;
 	v4l2_i2c_subdev_init(sd, c, &tvp5150_ops);
+	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	core->pad.flags = MEDIA_PAD_FL_SOURCE;
+	res = media_entity_pads_init(&sd->entity, 1, &core->pad);
+	if (res < 0)
+		return res;
+#endif
 
 	res = tvp5150_detect_version(core);
 	if (res < 0)
-- 
2.4.3

