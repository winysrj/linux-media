Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:34104 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753277AbeBZO2N (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Feb 2018 09:28:13 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jacopo Mondi <jacopo@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH 1/2] media: ov772x: fix whitespace issues
Date: Mon, 26 Feb 2018 09:28:07 -0500
Message-Id: <054d8830ac07d865c2973971af29b7caad593914.1519655282.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As we're adding this as a new driver, make checkpatch happier by
solving some whitespace issues, using --fix-inplace.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/i2c/ov772x.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/media/i2c/ov772x.c b/drivers/media/i2c/ov772x.c
index 3edf0cb6fd0e..16665af0c712 100644
--- a/drivers/media/i2c/ov772x.c
+++ b/drivers/media/i2c/ov772x.c
@@ -375,7 +375,7 @@
  */
 #define OV7720  0x7720
 #define OV7725  0x7721
-#define VERSION(pid, ver) ((pid<<8)|(ver&0xFF))
+#define VERSION(pid, ver) ((pid << 8) | (ver & 0xFF))
 
 /*
  * PLL multipliers
@@ -500,7 +500,6 @@ static const struct ov772x_color_format ov772x_cfmts[] = {
 	},
 };
 
-
 /*
  * window size list
  */
@@ -557,6 +556,7 @@ static int ov772x_mask_set(struct i2c_client *client, u8  command, u8  mask,
 			   u8  set)
 {
 	s32 val = ov772x_read(client, command);
+
 	if (val < 0)
 		return val;
 
@@ -919,7 +919,6 @@ static int ov772x_set_params(struct ov772x_priv *priv,
 	 * Edge Ctrl
 	 */
 	if (priv->info->edgectrl.strength & OV772X_MANUAL_EDGE_CTRL) {
-
 		/*
 		 * Manual Edge Control Mode
 		 *
@@ -1064,7 +1063,7 @@ static int ov772x_set_params(struct ov772x_priv *priv,
 }
 
 static int ov772x_get_selection(struct v4l2_subdev *sd,
-		struct v4l2_subdev_pad_config *cfg,
+				struct v4l2_subdev_pad_config *cfg,
 		struct v4l2_subdev_selection *sel)
 {
 	struct ov772x_priv *priv = to_ov772x(sd);
@@ -1087,7 +1086,7 @@ static int ov772x_get_selection(struct v4l2_subdev *sd,
 }
 
 static int ov772x_get_fmt(struct v4l2_subdev *sd,
-		struct v4l2_subdev_pad_config *cfg,
+			  struct v4l2_subdev_pad_config *cfg,
 		struct v4l2_subdev_format *format)
 {
 	struct v4l2_mbus_framefmt *mf = &format->format;
@@ -1106,7 +1105,7 @@ static int ov772x_get_fmt(struct v4l2_subdev *sd,
 }
 
 static int ov772x_set_fmt(struct v4l2_subdev *sd,
-		struct v4l2_subdev_pad_config *cfg,
+			  struct v4l2_subdev_pad_config *cfg,
 		struct v4l2_subdev_format *format)
 {
 	struct ov772x_priv *priv = to_ov772x(sd);
@@ -1219,7 +1218,7 @@ static int ov772x_enum_frame_interval(struct v4l2_subdev *sd,
 }
 
 static int ov772x_enum_mbus_code(struct v4l2_subdev *sd,
-		struct v4l2_subdev_pad_config *cfg,
+				 struct v4l2_subdev_pad_config *cfg,
 		struct v4l2_subdev_mbus_code_enum *code)
 {
 	if (code->pad || code->index >= ARRAY_SIZE(ov772x_cfmts))
@@ -1282,11 +1281,11 @@ static int ov772x_probe(struct i2c_client *client,
 	v4l2_i2c_subdev_init(&priv->subdev, client, &ov772x_subdev_ops);
 	v4l2_ctrl_handler_init(&priv->hdl, 3);
 	v4l2_ctrl_new_std(&priv->hdl, &ov772x_ctrl_ops,
-			V4L2_CID_VFLIP, 0, 1, 1, 0);
+			  V4L2_CID_VFLIP, 0, 1, 1, 0);
 	v4l2_ctrl_new_std(&priv->hdl, &ov772x_ctrl_ops,
-			V4L2_CID_HFLIP, 0, 1, 1, 0);
+			  V4L2_CID_HFLIP, 0, 1, 1, 0);
 	v4l2_ctrl_new_std(&priv->hdl, &ov772x_ctrl_ops,
-			V4L2_CID_BAND_STOP_FILTER, 0, 256, 1, 0);
+			  V4L2_CID_BAND_STOP_FILTER, 0, 256, 1, 0);
 	priv->subdev.ctrl_handler = &priv->hdl;
 	if (priv->hdl.error)
 		return priv->hdl.error;
-- 
2.14.3
