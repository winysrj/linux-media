Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:51036 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934514AbcAZMqt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jan 2016 07:46:49 -0500
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Eduard Gavin <egavinc@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org
Subject: [PATCH v3 2/2] [media] tvp5150: Add pad-level subdev operations
Date: Tue, 26 Jan 2016 09:46:24 -0300
Message-Id: <1453812384-15512-3-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1453812384-15512-1-git-send-email-javier@osg.samsung.com>
References: <1453812384-15512-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

This patch enables the tvp5150 decoder driver to be used with the media
controller framework by adding pad-level subdev operations and init the
media entity pad.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

---

Changes in v3:
- Split the format fix and the MC support in different patches.
  Suggested by Mauro Carvalho Chehab.

Changes in v2:
- Embed mbus_type into struct tvp5150. Suggested by Laurent Pinchart.
- Remove platform data support. Suggested by Laurent Pinchart.
- Check if the hsync, vsync and field even active properties are correct.
  Suggested by Laurent Pinchart.

 drivers/media/i2c/tvp5150.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index 37853bc3f0b3..e48b529c53b4 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -37,6 +37,7 @@ MODULE_PARM_DESC(debug, "Debug level (0-2)");
 
 struct tvp5150 {
 	struct v4l2_subdev sd;
+	struct media_pad pad;
 	struct v4l2_ctrl_handler hdl;
 	struct v4l2_rect rect;
 
@@ -826,17 +827,6 @@ static v4l2_std_id tvp5150_read_std(struct v4l2_subdev *sd)
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
@@ -1165,6 +1155,7 @@ static const struct v4l2_subdev_vbi_ops tvp5150_vbi_ops = {
 
 static const struct v4l2_subdev_pad_ops tvp5150_pad_ops = {
 	.enum_mbus_code = tvp5150_enum_mbus_code,
+	.enum_frame_size = tvp5150_enum_frame_size,
 	.set_fmt = tvp5150_fill_fmt,
 	.get_fmt = tvp5150_fill_fmt,
 };
@@ -1320,6 +1311,14 @@ static int tvp5150_probe(struct i2c_client *c,
 	}
 
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
2.5.0

