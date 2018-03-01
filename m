Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0049.hostedemail.com ([216.40.44.49]:47049 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S967723AbeCALua (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 1 Mar 2018 06:50:30 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Subject: [PATCH] media: tw9910: Whitespace alignment
Date: Thu,  1 Mar 2018 03:50:22 -0800
Message-Id: <2601b3771b35242dba70e1a9e50b2f2bc3dd41d8.1519904988.git.joe@perches.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Update multiline statements to open parenthesis.
Update a ?: to a single line.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/media/i2c/tw9910.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/media/i2c/tw9910.c b/drivers/media/i2c/tw9910.c
index cc5d383fc6b8..ab32cd81ebd0 100644
--- a/drivers/media/i2c/tw9910.c
+++ b/drivers/media/i2c/tw9910.c
@@ -445,7 +445,7 @@ static const struct tw9910_scale_ctrl *tw9910_select_norm(v4l2_std_id norm,
 
 	for (i = 0; i < size; i++) {
 		tmp = abs(width - scale[i].width) +
-			abs(height - scale[i].height);
+		      abs(height - scale[i].height);
 		if (tmp < diff) {
 			diff = tmp;
 			ret = scale + i;
@@ -534,9 +534,9 @@ static int tw9910_s_std(struct v4l2_subdev *sd, v4l2_std_id norm)
 	if (!ret)
 		ret = i2c_smbus_write_byte_data(client, CROP_HI,
 						((vdelay >> 2) & 0xc0) |
-			((vact >> 4) & 0x30) |
-			((hdelay >> 6) & 0x0c) |
-			((hact >> 8) & 0x03));
+						((vact >> 4) & 0x30) |
+						((hdelay >> 6) & 0x0c) |
+						((hact >> 8) & 0x03));
 	if (!ret)
 		ret = i2c_smbus_write_byte_data(client, VDELAY_LO,
 						vdelay & 0xff);
@@ -642,8 +642,7 @@ static int tw9910_s_power(struct v4l2_subdev *sd, int on)
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct tw9910_priv *priv = to_tw9910(client);
 
-	return on ? tw9910_power_on(priv) :
-		    tw9910_power_off(priv);
+	return on ? tw9910_power_on(priv) : tw9910_power_off(priv);
 }
 
 static int tw9910_set_frame(struct v4l2_subdev *sd, u32 *width, u32 *height)
@@ -733,7 +732,7 @@ static int tw9910_set_frame(struct v4l2_subdev *sd, u32 *width, u32 *height)
 
 static int tw9910_get_selection(struct v4l2_subdev *sd,
 				struct v4l2_subdev_pad_config *cfg,
-		struct v4l2_subdev_selection *sel)
+				struct v4l2_subdev_selection *sel)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct tw9910_priv *priv = to_tw9910(client);
@@ -758,7 +757,7 @@ static int tw9910_get_selection(struct v4l2_subdev *sd,
 
 static int tw9910_get_fmt(struct v4l2_subdev *sd,
 			  struct v4l2_subdev_pad_config *cfg,
-		struct v4l2_subdev_format *format)
+			  struct v4l2_subdev_format *format)
 {
 	struct v4l2_mbus_framefmt *mf = &format->format;
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
@@ -809,7 +808,7 @@ static int tw9910_s_fmt(struct v4l2_subdev *sd,
 
 static int tw9910_set_fmt(struct v4l2_subdev *sd,
 			  struct v4l2_subdev_pad_config *cfg,
-		struct v4l2_subdev_format *format)
+			  struct v4l2_subdev_format *format)
 {
 	struct v4l2_mbus_framefmt *mf = &format->format;
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
@@ -900,7 +899,7 @@ static const struct v4l2_subdev_core_ops tw9910_subdev_core_ops = {
 
 static int tw9910_enum_mbus_code(struct v4l2_subdev *sd,
 				 struct v4l2_subdev_pad_config *cfg,
-		struct v4l2_subdev_mbus_code_enum *code)
+				 struct v4l2_subdev_mbus_code_enum *code)
 {
 	if (code->pad || code->index)
 		return -EINVAL;
-- 
2.15.0
