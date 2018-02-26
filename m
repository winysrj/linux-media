Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:44286 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753298AbeBZO2N (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Feb 2018 09:28:13 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH 2/2] media: tw9910: solve coding style issues
Date: Mon, 26 Feb 2018 09:28:08 -0500
Message-Id: <876e32e5dd6e08320288862440e3e8a9542b5d9b.1519655282.git.mchehab@s-opensource.com>
In-Reply-To: <054d8830ac07d865c2973971af29b7caad593914.1519655282.git.mchehab@s-opensource.com>
References: <054d8830ac07d865c2973971af29b7caad593914.1519655282.git.mchehab@s-opensource.com>
In-Reply-To: <054d8830ac07d865c2973971af29b7caad593914.1519655282.git.mchehab@s-opensource.com>
References: <054d8830ac07d865c2973971af29b7caad593914.1519655282.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As we're adding this as a new driver, make checkpatch happier by
solving several style issues, using --fix-inplace at strict mode.

Some issues required manual work.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/i2c/tw9910.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/media/i2c/tw9910.c b/drivers/media/i2c/tw9910.c
index 96792df45fb0..cc5d383fc6b8 100644
--- a/drivers/media/i2c/tw9910.c
+++ b/drivers/media/i2c/tw9910.c
@@ -339,6 +339,7 @@ static int tw9910_mask_set(struct i2c_client *client, u8 command,
 			   u8 mask, u8 set)
 {
 	s32 val = i2c_smbus_read_byte_data(client, command);
+
 	if (val < 0)
 		return val;
 
@@ -389,7 +390,7 @@ static int tw9910_set_hsync(struct i2c_client *client)
 
 	/* So far only revisions 0 and 1 have been seen */
 	/* bit 2 - 0 */
-	if (1 == priv->revision)
+	if (priv->revision == 1)
 		ret = tw9910_mask_set(client, HSLOWCTL, 0x77,
 				      (HSYNC_START & 0x0007) << 4 |
 				      (HSYNC_END   & 0x0007));
@@ -511,10 +512,10 @@ static int tw9910_s_std(struct v4l2_subdev *sd, v4l2_std_id norm)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct tw9910_priv *priv = to_tw9910(client);
-	const unsigned hact = 720;
-	const unsigned hdelay = 15;
-	unsigned vact;
-	unsigned vdelay;
+	const unsigned int hact = 720;
+	const unsigned int hdelay = 15;
+	unsigned int vact;
+	unsigned int vdelay;
 	int ret;
 
 	if (!(norm & (V4L2_STD_NTSC | V4L2_STD_PAL)))
@@ -532,16 +533,16 @@ static int tw9910_s_std(struct v4l2_subdev *sd, v4l2_std_id norm)
 	}
 	if (!ret)
 		ret = i2c_smbus_write_byte_data(client, CROP_HI,
-			((vdelay >> 2) & 0xc0) |
+						((vdelay >> 2) & 0xc0) |
 			((vact >> 4) & 0x30) |
 			((hdelay >> 6) & 0x0c) |
 			((hact >> 8) & 0x03));
 	if (!ret)
 		ret = i2c_smbus_write_byte_data(client, VDELAY_LO,
-			vdelay & 0xff);
+						vdelay & 0xff);
 	if (!ret)
 		ret = i2c_smbus_write_byte_data(client, VACTIVE_LO,
-			vact & 0xff);
+						vact & 0xff);
 
 	return ret;
 }
@@ -731,7 +732,7 @@ static int tw9910_set_frame(struct v4l2_subdev *sd, u32 *width, u32 *height)
 }
 
 static int tw9910_get_selection(struct v4l2_subdev *sd,
-		struct v4l2_subdev_pad_config *cfg,
+				struct v4l2_subdev_pad_config *cfg,
 		struct v4l2_subdev_selection *sel)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
@@ -756,7 +757,7 @@ static int tw9910_get_selection(struct v4l2_subdev *sd,
 }
 
 static int tw9910_get_fmt(struct v4l2_subdev *sd,
-		struct v4l2_subdev_pad_config *cfg,
+			  struct v4l2_subdev_pad_config *cfg,
 		struct v4l2_subdev_format *format)
 {
 	struct v4l2_mbus_framefmt *mf = &format->format;
@@ -807,7 +808,7 @@ static int tw9910_s_fmt(struct v4l2_subdev *sd,
 }
 
 static int tw9910_set_fmt(struct v4l2_subdev *sd,
-		struct v4l2_subdev_pad_config *cfg,
+			  struct v4l2_subdev_pad_config *cfg,
 		struct v4l2_subdev_format *format)
 {
 	struct v4l2_mbus_framefmt *mf = &format->format;
@@ -818,9 +819,9 @@ static int tw9910_set_fmt(struct v4l2_subdev *sd,
 	if (format->pad)
 		return -EINVAL;
 
-	if (V4L2_FIELD_ANY == mf->field) {
+	if (mf->field == V4L2_FIELD_ANY) {
 		mf->field = V4L2_FIELD_INTERLACED_BT;
-	} else if (V4L2_FIELD_INTERLACED_BT != mf->field) {
+	} else if (mf->field != V4L2_FIELD_INTERLACED_BT) {
 		dev_err(&client->dev, "Field type %d invalid.\n", mf->field);
 		return -EINVAL;
 	}
@@ -870,8 +871,7 @@ static int tw9910_video_probe(struct i2c_client *client)
 	priv->revision = GET_REV(id);
 	id = GET_ID(id);
 
-	if (0x0B != id ||
-	    0x01 < priv->revision) {
+	if (id != 0x0b || priv->revision > 0x01) {
 		dev_err(&client->dev,
 			"Product ID error %x:%x\n",
 			id, priv->revision);
@@ -899,7 +899,7 @@ static const struct v4l2_subdev_core_ops tw9910_subdev_core_ops = {
 };
 
 static int tw9910_enum_mbus_code(struct v4l2_subdev *sd,
-		struct v4l2_subdev_pad_config *cfg,
+				 struct v4l2_subdev_pad_config *cfg,
 		struct v4l2_subdev_mbus_code_enum *code)
 {
 	if (code->pad || code->index)
-- 
2.14.3
