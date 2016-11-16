Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49737 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753885AbcKPQnS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Nov 2016 11:43:18 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 31/35] [media] tvp5150: convert it to use dev_foo() macros
Date: Wed, 16 Nov 2016 14:43:03 -0200
Message-Id: <7d3198391d6051db28e94395df88bb5a9b20c280.1479314177.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1479314177.git.mchehab@s-opensource.com>
References: <cover.1479314177.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1479314177.git.mchehab@s-opensource.com>
References: <cover.1479314177.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using v4l_foo(), use the dev_foo() macros, as
most modern media drivers.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/i2c/tvp5150.c | 49 ++++++++++++++++++++++-----------------------
 1 file changed, 24 insertions(+), 25 deletions(-)

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index 4740da39d698..569eb7c0968a 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -74,11 +74,11 @@ static int tvp5150_read(struct v4l2_subdev *sd, unsigned char addr)
 
 	rc = i2c_smbus_read_byte_data(c, addr);
 	if (rc < 0) {
-		v4l2_err(sd, "i2c i/o error: rc == %d\n", rc);
+		dev_err(sd->dev, "i2c i/o error: rc == %d\n", rc);
 		return rc;
 	}
 
-	v4l2_dbg(2, debug, sd, "tvp5150: read 0x%02x = 0x%02x\n", addr, rc);
+	dev_dbg_lvl(sd->dev, 2, debug, "tvp5150: read 0x%02x = %02x\n", addr, rc);
 
 	return rc;
 }
@@ -89,10 +89,10 @@ static int tvp5150_write(struct v4l2_subdev *sd, unsigned char addr,
 	struct i2c_client *c = v4l2_get_subdevdata(sd);
 	int rc;
 
-	v4l2_dbg(2, debug, sd, "tvp5150: writing 0x%02x 0x%02x\n", addr, value);
+	dev_dbg_lvl(sd->dev, 2, debug, "tvp5150: writing %02x %02x\n", addr, value);
 	rc = i2c_smbus_write_byte_data(c, addr, value);
 	if (rc < 0)
-		v4l2_err(sd, "i2c i/o error: rc == %d\n", rc);
+		dev_err(sd->dev, "i2c i/o error: rc == %d\n", rc);
 
 	return rc;
 }
@@ -280,8 +280,7 @@ static inline void tvp5150_selmux(struct v4l2_subdev *sd)
 		break;
 	}
 
-	v4l2_dbg(1, debug, sd, "Selecting video route: route input=%i, output=%i "
-			"=> tvp5150 input=%i, opmode=%i\n",
+	dev_dbg_lvl(sd->dev, 1, debug, "Selecting video route: route input=%i, output=%i => tvp5150 input=%i, opmode=%i\n",
 			decoder->input, decoder->output,
 			input, opmode);
 
@@ -293,7 +292,7 @@ static inline void tvp5150_selmux(struct v4l2_subdev *sd)
 	 */
 	val = tvp5150_read(sd, TVP5150_MISC_CTL);
 	if (val < 0) {
-		v4l2_err(sd, "%s: failed with error = %d\n", __func__, val);
+		dev_err(sd->dev, "%s: failed with error = %d\n", __func__, val);
 		return;
 	}
 
@@ -611,7 +610,7 @@ static int tvp5150_g_sliced_vbi_cap(struct v4l2_subdev *sd,
 	const struct i2c_vbi_ram_value *regs = vbi_ram_default;
 	int line;
 
-	v4l2_dbg(1, debug, sd, "g_sliced_vbi_cap\n");
+	dev_dbg_lvl(sd->dev, 1, debug, "g_sliced_vbi_cap\n");
 	memset(cap, 0, sizeof *cap);
 
 	while (regs->reg != (u16)-1 ) {
@@ -649,7 +648,7 @@ static int tvp5150_set_vbi(struct v4l2_subdev *sd,
 	int pos=0;
 
 	if (std == V4L2_STD_ALL) {
-		v4l2_err(sd, "VBI can't be configured without knowing number of lines\n");
+		dev_err(sd->dev, "VBI can't be configured without knowing number of lines\n");
 		return 0;
 	} else if (std & V4L2_STD_625_50) {
 		/* Don't follow NTSC Line number convension */
@@ -697,7 +696,7 @@ static int tvp5150_get_vbi(struct v4l2_subdev *sd,
 	int i, ret = 0;
 
 	if (std == V4L2_STD_ALL) {
-		v4l2_err(sd, "VBI can't be configured without knowing number of lines\n");
+		dev_err(sd->dev, "VBI can't be configured without knowing number of lines\n");
 		return 0;
 	} else if (std & V4L2_STD_625_50) {
 		/* Don't follow NTSC Line number convension */
@@ -712,7 +711,7 @@ static int tvp5150_get_vbi(struct v4l2_subdev *sd,
 	for (i = 0; i <= 1; i++) {
 		ret = tvp5150_read(sd, reg + i);
 		if (ret < 0) {
-			v4l2_err(sd, "%s: failed with error = %d\n",
+			dev_err(sd->dev, "%s: failed with error = %d\n",
 				 __func__, ret);
 			return 0;
 		}
@@ -749,7 +748,7 @@ static int tvp5150_set_std(struct v4l2_subdev *sd, v4l2_std_id std)
 			fmt = VIDEO_STD_SECAM_BIT;
 	}
 
-	v4l2_dbg(1, debug, sd, "Set video std register to %d.\n", fmt);
+	dev_dbg_lvl(sd->dev, 1, debug, "Set video std register to %d.\n", fmt);
 	tvp5150_write(sd, TVP5150_VIDEO_STD, fmt);
 	return 0;
 }
@@ -866,7 +865,7 @@ static int tvp5150_fill_fmt(struct v4l2_subdev *sd,
 	f->field = V4L2_FIELD_ALTERNATE;
 	f->colorspace = V4L2_COLORSPACE_SMPTE170M;
 
-	v4l2_dbg(1, debug, sd, "width = %d, height = %d\n", f->width,
+	dev_dbg_lvl(sd->dev, 1, debug, "width = %d, height = %d\n", f->width,
 			f->height);
 	return 0;
 }
@@ -884,7 +883,7 @@ static int tvp5150_set_selection(struct v4l2_subdev *sd,
 	    sel->target != V4L2_SEL_TGT_CROP)
 		return -EINVAL;
 
-	v4l2_dbg(1, debug, sd, "%s left=%d, top=%d, width=%d, height=%d\n",
+	dev_dbg_lvl(sd->dev, 1, debug, "%s left=%d, top=%d, width=%d, height=%d\n",
 		__func__, rect.left, rect.top, rect.width, rect.height);
 
 	/* tvp5150 has some special limits */
@@ -1148,7 +1147,7 @@ static int tvp5150_g_register(struct v4l2_subdev *sd, struct v4l2_dbg_register *
 
 	res = tvp5150_read(sd, reg->reg & 0xff);
 	if (res < 0) {
-		v4l2_err(sd, "%s: failed with error = %d\n", __func__, res);
+		dev_err(sd->dev, "%s: failed with error = %d\n", __func__, res);
 		return res;
 	}
 
@@ -1288,21 +1287,21 @@ static int tvp5150_detect_version(struct tvp5150 *core)
 	core->dev_id = (regs[0] << 8) | regs[1];
 	core->rom_ver = (regs[2] << 8) | regs[3];
 
-	v4l2_info(sd, "tvp%04x (%u.%u) chip found @ 0x%02x (%s)\n",
+	dev_info(sd->dev, "tvp%04x (%u.%u) chip found @ 0x%02x (%s)\n",
 		  core->dev_id, regs[2], regs[3], c->addr << 1,
 		  c->adapter->name);
 
 	if (core->dev_id == 0x5150 && core->rom_ver == 0x0321) {
-		v4l2_info(sd, "tvp5150a detected.\n");
+		dev_info(sd->dev, "tvp5150a detected.\n");
 	} else if (core->dev_id == 0x5150 && core->rom_ver == 0x0400) {
-		v4l2_info(sd, "tvp5150am1 detected.\n");
+		dev_info(sd->dev, "tvp5150am1 detected.\n");
 
 		/* ITU-T BT.656.4 timing */
 		tvp5150_write(sd, TVP5150_REV_SELECT, 0);
 	} else if (core->dev_id == 0x5151 && core->rom_ver == 0x0100) {
-		v4l2_info(sd, "tvp5151 detected.\n");
+		dev_info(sd->dev, "tvp5151 detected.\n");
 	} else {
-		v4l2_info(sd, "*** unknown tvp%04x chip detected.\n",
+		dev_info(sd->dev, "*** unknown tvp%04x chip detected.\n",
 			  core->dev_id);
 	}
 
@@ -1381,7 +1380,7 @@ static int tvp5150_parse_dt(struct tvp5150 *decoder, struct device_node *np)
 	for_each_available_child_of_node(connectors, child) {
 		ret = of_property_read_u32(child, "input", &input_type);
 		if (ret) {
-			v4l2_err(&decoder->sd,
+			dev_err(decoder->sd.dev,
 				 "missing type property in node %s\n",
 				 child->name);
 			goto err_connector;
@@ -1396,7 +1395,7 @@ static int tvp5150_parse_dt(struct tvp5150 *decoder, struct device_node *np)
 
 		/* Each input connector can only be defined once */
 		if (input->name) {
-			v4l2_err(&decoder->sd,
+			dev_err(decoder->sd.dev,
 				 "input %s with same type already exists\n",
 				 input->name);
 			ret = -EINVAL;
@@ -1417,7 +1416,7 @@ static int tvp5150_parse_dt(struct tvp5150 *decoder, struct device_node *np)
 
 		ret = of_property_read_string(child, "label", &name);
 		if (ret < 0) {
-			v4l2_err(&decoder->sd,
+			dev_err(decoder->sd.dev,
 				 "missing label property in node %s\n",
 				 child->name);
 			goto err_connector;
@@ -1465,7 +1464,7 @@ static int tvp5150_probe(struct i2c_client *c,
 	if (IS_ENABLED(CONFIG_OF) && np) {
 		res = tvp5150_parse_dt(core, np);
 		if (res) {
-			v4l2_err(sd, "DT parsing error: %d\n", res);
+			dev_err(sd->dev, "DT parsing error: %d\n", res);
 			return res;
 		}
 	} else {
@@ -1549,7 +1548,7 @@ static int tvp5150_remove(struct i2c_client *c)
 	struct v4l2_subdev *sd = i2c_get_clientdata(c);
 	struct tvp5150 *decoder = to_tvp5150(sd);
 
-	v4l2_dbg(1, debug, sd,
+	dev_dbg_lvl(sd->dev, 1, debug,
 		"tvp5150.c: removing tvp5150 adapter on address 0x%x\n",
 		c->addr << 1);
 
-- 
2.7.4


