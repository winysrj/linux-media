Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:58410 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758819AbZDOMSS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Apr 2009 08:18:18 -0400
Date: Wed, 15 Apr 2009 14:18:21 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH 4/5] soc-camera: simplify register access routines in multiple
 sensor drivers
In-Reply-To: <Pine.LNX.4.64.0904151356480.4729@axis700.grange>
Message-ID: <Pine.LNX.4.64.0904151402540.4729@axis700.grange>
References: <Pine.LNX.4.64.0904151356480.4729@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Register access routines only need the I2C client, not the soc-camera device
context.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/mt9m001.c |  105 +++++++++++++++++---------------
 drivers/media/video/mt9m111.c |   73 ++++++++++++----------
 drivers/media/video/mt9t031.c |  135 +++++++++++++++++++++-------------------
 drivers/media/video/mt9v022.c |  135 +++++++++++++++++++++--------------------
 4 files changed, 236 insertions(+), 212 deletions(-)

diff --git a/drivers/media/video/mt9m001.c b/drivers/media/video/mt9m001.c
index 3838ff7..459c04c 100644
--- a/drivers/media/video/mt9m001.c
+++ b/drivers/media/video/mt9m001.c
@@ -75,53 +75,50 @@ struct mt9m001 {
 	unsigned char autoexposure;
 };
 
-static int reg_read(struct soc_camera_device *icd, const u8 reg)
+static int reg_read(struct i2c_client *client, const u8 reg)
 {
-	struct mt9m001 *mt9m001 = container_of(icd, struct mt9m001, icd);
-	struct i2c_client *client = mt9m001->client;
 	s32 data = i2c_smbus_read_word_data(client, reg);
 	return data < 0 ? data : swab16(data);
 }
 
-static int reg_write(struct soc_camera_device *icd, const u8 reg,
+static int reg_write(struct i2c_client *client, const u8 reg,
 		     const u16 data)
 {
-	struct mt9m001 *mt9m001 = container_of(icd, struct mt9m001, icd);
-	return i2c_smbus_write_word_data(mt9m001->client, reg, swab16(data));
+	return i2c_smbus_write_word_data(client, reg, swab16(data));
 }
 
-static int reg_set(struct soc_camera_device *icd, const u8 reg,
+static int reg_set(struct i2c_client *client, const u8 reg,
 		   const u16 data)
 {
 	int ret;
 
-	ret = reg_read(icd, reg);
+	ret = reg_read(client, reg);
 	if (ret < 0)
 		return ret;
-	return reg_write(icd, reg, ret | data);
+	return reg_write(client, reg, ret | data);
 }
 
-static int reg_clear(struct soc_camera_device *icd, const u8 reg,
+static int reg_clear(struct i2c_client *client, const u8 reg,
 		     const u16 data)
 {
 	int ret;
 
-	ret = reg_read(icd, reg);
+	ret = reg_read(client, reg);
 	if (ret < 0)
 		return ret;
-	return reg_write(icd, reg, ret & ~data);
+	return reg_write(client, reg, ret & ~data);
 }
 
 static int mt9m001_init(struct soc_camera_device *icd)
 {
-	struct mt9m001 *mt9m001 = container_of(icd, struct mt9m001, icd);
-	struct soc_camera_link *icl = mt9m001->client->dev.platform_data;
+	struct i2c_client *client = to_i2c_client(icd->control);
+	struct soc_camera_link *icl = client->dev.platform_data;
 	int ret;
 
 	dev_dbg(icd->vdev->parent, "%s\n", __func__);
 
 	if (icl->power) {
-		ret = icl->power(&mt9m001->client->dev, 1);
+		ret = icl->power(&client->dev, 1);
 		if (ret < 0) {
 			dev_err(icd->vdev->parent,
 				"Platform failed to power-on the camera.\n");
@@ -131,49 +128,53 @@ static int mt9m001_init(struct soc_camera_device *icd)
 
 	/* The camera could have been already on, we reset it additionally */
 	if (icl->reset)
-		ret = icl->reset(&mt9m001->client->dev);
+		ret = icl->reset(&client->dev);
 	else
 		ret = -ENODEV;
 
 	if (ret < 0) {
 		/* Either no platform reset, or platform reset failed */
-		ret = reg_write(icd, MT9M001_RESET, 1);
+		ret = reg_write(client, MT9M001_RESET, 1);
 		if (!ret)
-			ret = reg_write(icd, MT9M001_RESET, 0);
+			ret = reg_write(client, MT9M001_RESET, 0);
 	}
 	/* Disable chip, synchronous option update */
 	if (!ret)
-		ret = reg_write(icd, MT9M001_OUTPUT_CONTROL, 0);
+		ret = reg_write(client, MT9M001_OUTPUT_CONTROL, 0);
 
 	return ret;
 }
 
 static int mt9m001_release(struct soc_camera_device *icd)
 {
-	struct mt9m001 *mt9m001 = container_of(icd, struct mt9m001, icd);
-	struct soc_camera_link *icl = mt9m001->client->dev.platform_data;
+	struct i2c_client *client = to_i2c_client(icd->control);
+	struct soc_camera_link *icl = client->dev.platform_data;
 
 	/* Disable the chip */
-	reg_write(icd, MT9M001_OUTPUT_CONTROL, 0);
+	reg_write(client, MT9M001_OUTPUT_CONTROL, 0);
 
 	if (icl->power)
-		icl->power(&mt9m001->client->dev, 0);
+		icl->power(&client->dev, 0);
 
 	return 0;
 }
 
 static int mt9m001_start_capture(struct soc_camera_device *icd)
 {
+	struct i2c_client *client = to_i2c_client(icd->control);
+
 	/* Switch to master "normal" mode */
-	if (reg_write(icd, MT9M001_OUTPUT_CONTROL, 2) < 0)
+	if (reg_write(client, MT9M001_OUTPUT_CONTROL, 2) < 0)
 		return -EIO;
 	return 0;
 }
 
 static int mt9m001_stop_capture(struct soc_camera_device *icd)
 {
+	struct i2c_client *client = to_i2c_client(icd->control);
+
 	/* Stop sensor readout */
-	if (reg_write(icd, MT9M001_OUTPUT_CONTROL, 0) < 0)
+	if (reg_write(client, MT9M001_OUTPUT_CONTROL, 0) < 0)
 		return -EIO;
 	return 0;
 }
@@ -222,28 +223,29 @@ static unsigned long mt9m001_query_bus_param(struct soc_camera_device *icd)
 static int mt9m001_set_crop(struct soc_camera_device *icd,
 			    struct v4l2_rect *rect)
 {
+	struct i2c_client *client = to_i2c_client(icd->control);
 	struct mt9m001 *mt9m001 = container_of(icd, struct mt9m001, icd);
 	int ret;
 	const u16 hblank = 9, vblank = 25;
 
 	/* Blanking and start values - default... */
-	ret = reg_write(icd, MT9M001_HORIZONTAL_BLANKING, hblank);
+	ret = reg_write(client, MT9M001_HORIZONTAL_BLANKING, hblank);
 	if (!ret)
-		ret = reg_write(icd, MT9M001_VERTICAL_BLANKING, vblank);
+		ret = reg_write(client, MT9M001_VERTICAL_BLANKING, vblank);
 
 	/* The caller provides a supported format, as verified per
 	 * call to icd->try_fmt() */
 	if (!ret)
-		ret = reg_write(icd, MT9M001_COLUMN_START, rect->left);
+		ret = reg_write(client, MT9M001_COLUMN_START, rect->left);
 	if (!ret)
-		ret = reg_write(icd, MT9M001_ROW_START, rect->top);
+		ret = reg_write(client, MT9M001_ROW_START, rect->top);
 	if (!ret)
-		ret = reg_write(icd, MT9M001_WINDOW_WIDTH, rect->width - 1);
+		ret = reg_write(client, MT9M001_WINDOW_WIDTH, rect->width - 1);
 	if (!ret)
-		ret = reg_write(icd, MT9M001_WINDOW_HEIGHT,
+		ret = reg_write(client, MT9M001_WINDOW_HEIGHT,
 				rect->height + icd->y_skip_top - 1);
 	if (!ret && mt9m001->autoexposure) {
-		ret = reg_write(icd, MT9M001_SHUTTER_WIDTH,
+		ret = reg_write(client, MT9M001_SHUTTER_WIDTH,
 				rect->height + icd->y_skip_top + vblank);
 		if (!ret) {
 			const struct v4l2_queryctrl *qctrl =
@@ -312,16 +314,16 @@ static int mt9m001_get_chip_id(struct soc_camera_device *icd,
 static int mt9m001_get_register(struct soc_camera_device *icd,
 				struct v4l2_dbg_register *reg)
 {
-	struct mt9m001 *mt9m001 = container_of(icd, struct mt9m001, icd);
+	struct i2c_client *client = to_i2c_client(icd->control);
 
 	if (reg->match.type != V4L2_CHIP_MATCH_I2C_ADDR || reg->reg > 0xff)
 		return -EINVAL;
 
-	if (reg->match.addr != mt9m001->client->addr)
+	if (reg->match.addr != client->addr)
 		return -ENODEV;
 
 	reg->size = 2;
-	reg->val = reg_read(icd, reg->reg);
+	reg->val = reg_read(client, reg->reg);
 
 	if (reg->val > 0xffff)
 		return -EIO;
@@ -332,15 +334,15 @@ static int mt9m001_get_register(struct soc_camera_device *icd,
 static int mt9m001_set_register(struct soc_camera_device *icd,
 				struct v4l2_dbg_register *reg)
 {
-	struct mt9m001 *mt9m001 = container_of(icd, struct mt9m001, icd);
+	struct i2c_client *client = to_i2c_client(icd->control);
 
 	if (reg->match.type != V4L2_CHIP_MATCH_I2C_ADDR || reg->reg > 0xff)
 		return -EINVAL;
 
-	if (reg->match.addr != mt9m001->client->addr)
+	if (reg->match.addr != client->addr)
 		return -ENODEV;
 
-	if (reg_write(icd, reg->reg, reg->val) < 0)
+	if (reg_write(client, reg->reg, reg->val) < 0)
 		return -EIO;
 
 	return 0;
@@ -416,12 +418,13 @@ static struct soc_camera_ops mt9m001_ops = {
 
 static int mt9m001_get_control(struct soc_camera_device *icd, struct v4l2_control *ctrl)
 {
+	struct i2c_client *client = to_i2c_client(icd->control);
 	struct mt9m001 *mt9m001 = container_of(icd, struct mt9m001, icd);
 	int data;
 
 	switch (ctrl->id) {
 	case V4L2_CID_VFLIP:
-		data = reg_read(icd, MT9M001_READ_OPTIONS2);
+		data = reg_read(client, MT9M001_READ_OPTIONS2);
 		if (data < 0)
 			return -EIO;
 		ctrl->value = !!(data & 0x8000);
@@ -435,6 +438,7 @@ static int mt9m001_get_control(struct soc_camera_device *icd, struct v4l2_contro
 
 static int mt9m001_set_control(struct soc_camera_device *icd, struct v4l2_control *ctrl)
 {
+	struct i2c_client *client = to_i2c_client(icd->control);
 	struct mt9m001 *mt9m001 = container_of(icd, struct mt9m001, icd);
 	const struct v4l2_queryctrl *qctrl;
 	int data;
@@ -447,9 +451,9 @@ static int mt9m001_set_control(struct soc_camera_device *icd, struct v4l2_contro
 	switch (ctrl->id) {
 	case V4L2_CID_VFLIP:
 		if (ctrl->value)
-			data = reg_set(icd, MT9M001_READ_OPTIONS2, 0x8000);
+			data = reg_set(client, MT9M001_READ_OPTIONS2, 0x8000);
 		else
-			data = reg_clear(icd, MT9M001_READ_OPTIONS2, 0x8000);
+			data = reg_clear(client, MT9M001_READ_OPTIONS2, 0x8000);
 		if (data < 0)
 			return -EIO;
 		break;
@@ -463,7 +467,7 @@ static int mt9m001_set_control(struct soc_camera_device *icd, struct v4l2_contro
 			data = ((ctrl->value - qctrl->minimum) * 8 + range / 2) / range;
 
 			dev_dbg(&icd->dev, "Setting gain %d\n", data);
-			data = reg_write(icd, MT9M001_GLOBAL_GAIN, data);
+			data = reg_write(client, MT9M001_GLOBAL_GAIN, data);
 			if (data < 0)
 				return -EIO;
 		} else {
@@ -481,8 +485,8 @@ static int mt9m001_set_control(struct soc_camera_device *icd, struct v4l2_contro
 				data = ((gain - 64) * 7 + 28) / 56 + 96;
 
 			dev_dbg(&icd->dev, "Setting gain from %d to %d\n",
-				 reg_read(icd, MT9M001_GLOBAL_GAIN), data);
-			data = reg_write(icd, MT9M001_GLOBAL_GAIN, data);
+				 reg_read(client, MT9M001_GLOBAL_GAIN), data);
+			data = reg_write(client, MT9M001_GLOBAL_GAIN, data);
 			if (data < 0)
 				return -EIO;
 		}
@@ -500,8 +504,8 @@ static int mt9m001_set_control(struct soc_camera_device *icd, struct v4l2_contro
 						 range / 2) / range + 1;
 
 			dev_dbg(&icd->dev, "Setting shutter width from %d to %lu\n",
-				 reg_read(icd, MT9M001_SHUTTER_WIDTH), shutter);
-			if (reg_write(icd, MT9M001_SHUTTER_WIDTH, shutter) < 0)
+				 reg_read(client, MT9M001_SHUTTER_WIDTH), shutter);
+			if (reg_write(client, MT9M001_SHUTTER_WIDTH, shutter) < 0)
 				return -EIO;
 			icd->exposure = ctrl->value;
 			mt9m001->autoexposure = 0;
@@ -510,7 +514,7 @@ static int mt9m001_set_control(struct soc_camera_device *icd, struct v4l2_contro
 	case V4L2_CID_EXPOSURE_AUTO:
 		if (ctrl->value) {
 			const u16 vblank = 25;
-			if (reg_write(icd, MT9M001_SHUTTER_WIDTH, icd->height +
+			if (reg_write(client, MT9M001_SHUTTER_WIDTH, icd->height +
 				      icd->y_skip_top + vblank) < 0)
 				return -EIO;
 			qctrl = soc_camera_find_qctrl(icd->ops, V4L2_CID_EXPOSURE);
@@ -529,8 +533,9 @@ static int mt9m001_set_control(struct soc_camera_device *icd, struct v4l2_contro
  * this wasn't our capture interface, so, we wait for the right one */
 static int mt9m001_video_probe(struct soc_camera_device *icd)
 {
+	struct i2c_client *client = to_i2c_client(icd->control);
 	struct mt9m001 *mt9m001 = container_of(icd, struct mt9m001, icd);
-	struct soc_camera_link *icl = mt9m001->client->dev.platform_data;
+	struct soc_camera_link *icl = client->dev.platform_data;
 	s32 data;
 	int ret;
 	unsigned long flags;
@@ -542,11 +547,11 @@ static int mt9m001_video_probe(struct soc_camera_device *icd)
 		return -ENODEV;
 
 	/* Enable the chip */
-	data = reg_write(icd, MT9M001_CHIP_ENABLE, 1);
+	data = reg_write(client, MT9M001_CHIP_ENABLE, 1);
 	dev_dbg(&icd->dev, "write: %d\n", data);
 
 	/* Read out the chip version register */
-	data = reg_read(icd, MT9M001_CHIP_VERSION);
+	data = reg_read(client, MT9M001_CHIP_VERSION);
 
 	/* must be 0x8411 or 0x8421 for colour sensor and 8431 for bw */
 	switch (data) {
diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
index cdd1ddb..fc5e2de 100644
--- a/drivers/media/video/mt9m111.c
+++ b/drivers/media/video/mt9m111.c
@@ -113,10 +113,10 @@
  * mt9m111: Camera control register addresses (0x200..0x2ff not implemented)
  */
 
-#define reg_read(reg) mt9m111_reg_read(icd, MT9M111_##reg)
-#define reg_write(reg, val) mt9m111_reg_write(icd, MT9M111_##reg, (val))
-#define reg_set(reg, val) mt9m111_reg_set(icd, MT9M111_##reg, (val))
-#define reg_clear(reg, val) mt9m111_reg_clear(icd, MT9M111_##reg, (val))
+#define reg_read(reg) mt9m111_reg_read(client, MT9M111_##reg)
+#define reg_write(reg, val) mt9m111_reg_write(client, MT9M111_##reg, (val))
+#define reg_set(reg, val) mt9m111_reg_set(client, MT9M111_##reg, (val))
+#define reg_clear(reg, val) mt9m111_reg_clear(client, MT9M111_##reg, (val))
 
 #define MT9M111_MIN_DARK_ROWS	8
 #define MT9M111_MIN_DARK_COLS	24
@@ -184,58 +184,55 @@ static int reg_page_map_set(struct i2c_client *client, const u16 reg)
 	return ret;
 }
 
-static int mt9m111_reg_read(struct soc_camera_device *icd, const u16 reg)
+static int mt9m111_reg_read(struct i2c_client *client, const u16 reg)
 {
-	struct mt9m111 *mt9m111 = container_of(icd, struct mt9m111, icd);
-	struct i2c_client *client = mt9m111->client;
 	int ret;
 
 	ret = reg_page_map_set(client, reg);
 	if (!ret)
 		ret = swab16(i2c_smbus_read_word_data(client, (reg & 0xff)));
 
-	dev_dbg(&icd->dev, "read  reg.%03x -> %04x\n", reg, ret);
+	dev_dbg(&client->dev, "read  reg.%03x -> %04x\n", reg, ret);
 	return ret;
 }
 
-static int mt9m111_reg_write(struct soc_camera_device *icd, const u16 reg,
+static int mt9m111_reg_write(struct i2c_client *client, const u16 reg,
 			     const u16 data)
 {
-	struct mt9m111 *mt9m111 = container_of(icd, struct mt9m111, icd);
-	struct i2c_client *client = mt9m111->client;
 	int ret;
 
 	ret = reg_page_map_set(client, reg);
 	if (!ret)
-		ret = i2c_smbus_write_word_data(mt9m111->client, (reg & 0xff),
+		ret = i2c_smbus_write_word_data(client, (reg & 0xff),
 						swab16(data));
-	dev_dbg(&icd->dev, "write reg.%03x = %04x -> %d\n", reg, data, ret);
+	dev_dbg(&client->dev, "write reg.%03x = %04x -> %d\n", reg, data, ret);
 	return ret;
 }
 
-static int mt9m111_reg_set(struct soc_camera_device *icd, const u16 reg,
+static int mt9m111_reg_set(struct i2c_client *client, const u16 reg,
 			   const u16 data)
 {
 	int ret;
 
-	ret = mt9m111_reg_read(icd, reg);
+	ret = mt9m111_reg_read(client, reg);
 	if (ret >= 0)
-		ret = mt9m111_reg_write(icd, reg, ret | data);
+		ret = mt9m111_reg_write(client, reg, ret | data);
 	return ret;
 }
 
-static int mt9m111_reg_clear(struct soc_camera_device *icd, const u16 reg,
+static int mt9m111_reg_clear(struct i2c_client *client, const u16 reg,
 			     const u16 data)
 {
 	int ret;
 
-	ret = mt9m111_reg_read(icd, reg);
-	return mt9m111_reg_write(icd, reg, ret & ~data);
+	ret = mt9m111_reg_read(client, reg);
+	return mt9m111_reg_write(client, reg, ret & ~data);
 }
 
 static int mt9m111_set_context(struct soc_camera_device *icd,
 			       enum mt9m111_context ctxt)
 {
+	struct i2c_client *client = to_i2c_client(icd->control);
 	int valB = MT9M111_CTXT_CTRL_RESTART | MT9M111_CTXT_CTRL_DEFECTCOR_B
 		| MT9M111_CTXT_CTRL_RESIZE_B | MT9M111_CTXT_CTRL_CTRL2_B
 		| MT9M111_CTXT_CTRL_GAMMA_B | MT9M111_CTXT_CTRL_READ_MODE_B
@@ -252,6 +249,7 @@ static int mt9m111_set_context(struct soc_camera_device *icd,
 static int mt9m111_setup_rect(struct soc_camera_device *icd,
 			      struct v4l2_rect *rect)
 {
+	struct i2c_client *client = to_i2c_client(icd->control);
 	struct mt9m111 *mt9m111 = container_of(icd, struct mt9m111, icd);
 	int ret, is_raw_format;
 	int width = rect->width;
@@ -296,6 +294,7 @@ static int mt9m111_setup_rect(struct soc_camera_device *icd,
 
 static int mt9m111_setup_pixfmt(struct soc_camera_device *icd, u16 outfmt)
 {
+	struct i2c_client *client = to_i2c_client(icd->control);
 	int ret;
 
 	ret = reg_write(OUTPUT_FORMAT_CTRL2_A, outfmt);
@@ -357,12 +356,13 @@ static int mt9m111_setfmt_yuv(struct soc_camera_device *icd)
 
 static int mt9m111_enable(struct soc_camera_device *icd)
 {
+	struct i2c_client *client = to_i2c_client(icd->control);
 	struct mt9m111 *mt9m111 = container_of(icd, struct mt9m111, icd);
-	struct soc_camera_link *icl = mt9m111->client->dev.platform_data;
+	struct soc_camera_link *icl = client->dev.platform_data;
 	int ret;
 
 	if (icl->power) {
-		ret = icl->power(&mt9m111->client->dev, 1);
+		ret = icl->power(&client->dev, 1);
 		if (ret < 0) {
 			dev_err(icd->vdev->parent,
 				"Platform failed to power-on the camera.\n");
@@ -378,8 +378,9 @@ static int mt9m111_enable(struct soc_camera_device *icd)
 
 static int mt9m111_disable(struct soc_camera_device *icd)
 {
+	struct i2c_client *client = to_i2c_client(icd->control);
 	struct mt9m111 *mt9m111 = container_of(icd, struct mt9m111, icd);
-	struct soc_camera_link *icl = mt9m111->client->dev.platform_data;
+	struct soc_camera_link *icl = client->dev.platform_data;
 	int ret;
 
 	ret = reg_clear(RESET, MT9M111_RESET_CHIP_ENABLE);
@@ -387,15 +388,15 @@ static int mt9m111_disable(struct soc_camera_device *icd)
 		mt9m111->powered = 0;
 
 	if (icl->power)
-		icl->power(&mt9m111->client->dev, 0);
+		icl->power(&client->dev, 0);
 
 	return ret;
 }
 
 static int mt9m111_reset(struct soc_camera_device *icd)
 {
-	struct mt9m111 *mt9m111 = container_of(icd, struct mt9m111, icd);
-	struct soc_camera_link *icl = mt9m111->client->dev.platform_data;
+	struct i2c_client *client = to_i2c_client(icd->control);
+	struct soc_camera_link *icl = client->dev.platform_data;
 	int ret;
 
 	ret = reg_set(RESET, MT9M111_RESET_RESET_MODE);
@@ -406,7 +407,7 @@ static int mt9m111_reset(struct soc_camera_device *icd)
 				| MT9M111_RESET_RESET_SOC);
 
 	if (icl->reset)
-		icl->reset(&mt9m111->client->dev);
+		icl->reset(&client->dev);
 
 	return ret;
 }
@@ -562,15 +563,14 @@ static int mt9m111_get_register(struct soc_camera_device *icd,
 				struct v4l2_dbg_register *reg)
 {
 	int val;
-
-	struct mt9m111 *mt9m111 = container_of(icd, struct mt9m111, icd);
+	struct i2c_client *client = to_i2c_client(icd->control);
 
 	if (reg->match.type != V4L2_CHIP_MATCH_I2C_ADDR || reg->reg > 0x2ff)
 		return -EINVAL;
-	if (reg->match.addr != mt9m111->client->addr)
+	if (reg->match.addr != client->addr)
 		return -ENODEV;
 
-	val = mt9m111_reg_read(icd, reg->reg);
+	val = mt9m111_reg_read(client, reg->reg);
 	reg->size = 2;
 	reg->val = (u64)val;
 
@@ -583,15 +583,15 @@ static int mt9m111_get_register(struct soc_camera_device *icd,
 static int mt9m111_set_register(struct soc_camera_device *icd,
 				struct v4l2_dbg_register *reg)
 {
-	struct mt9m111 *mt9m111 = container_of(icd, struct mt9m111, icd);
+	struct i2c_client *client = to_i2c_client(icd->control);
 
 	if (reg->match.type != V4L2_CHIP_MATCH_I2C_ADDR || reg->reg > 0x2ff)
 		return -EINVAL;
 
-	if (reg->match.addr != mt9m111->client->addr)
+	if (reg->match.addr != client->addr)
 		return -ENODEV;
 
-	if (mt9m111_reg_write(icd, reg->reg, reg->val) < 0)
+	if (mt9m111_reg_write(client, reg->reg, reg->val) < 0)
 		return -EIO;
 
 	return 0;
@@ -672,6 +672,7 @@ static struct soc_camera_ops mt9m111_ops = {
 
 static int mt9m111_set_flip(struct soc_camera_device *icd, int flip, int mask)
 {
+	struct i2c_client *client = to_i2c_client(icd->control);
 	struct mt9m111 *mt9m111 = container_of(icd, struct mt9m111, icd);
 	int ret;
 
@@ -692,6 +693,7 @@ static int mt9m111_set_flip(struct soc_camera_device *icd, int flip, int mask)
 
 static int mt9m111_get_global_gain(struct soc_camera_device *icd)
 {
+	struct i2c_client *client = to_i2c_client(icd->control);
 	int data;
 
 	data = reg_read(GLOBAL_GAIN);
@@ -703,6 +705,7 @@ static int mt9m111_get_global_gain(struct soc_camera_device *icd)
 
 static int mt9m111_set_global_gain(struct soc_camera_device *icd, int gain)
 {
+	struct i2c_client *client = to_i2c_client(icd->control);
 	u16 val;
 
 	if (gain > 63 * 2 * 2)
@@ -721,6 +724,7 @@ static int mt9m111_set_global_gain(struct soc_camera_device *icd, int gain)
 
 static int mt9m111_set_autoexposure(struct soc_camera_device *icd, int on)
 {
+	struct i2c_client *client = to_i2c_client(icd->control);
 	struct mt9m111 *mt9m111 = container_of(icd, struct mt9m111, icd);
 	int ret;
 
@@ -737,6 +741,7 @@ static int mt9m111_set_autoexposure(struct soc_camera_device *icd, int on)
 
 static int mt9m111_set_autowhitebalance(struct soc_camera_device *icd, int on)
 {
+	struct i2c_client *client = to_i2c_client(icd->control);
 	struct mt9m111 *mt9m111 = container_of(icd, struct mt9m111, icd);
 	int ret;
 
@@ -754,6 +759,7 @@ static int mt9m111_set_autowhitebalance(struct soc_camera_device *icd, int on)
 static int mt9m111_get_control(struct soc_camera_device *icd,
 			       struct v4l2_control *ctrl)
 {
+	struct i2c_client *client = to_i2c_client(icd->control);
 	struct mt9m111 *mt9m111 = container_of(icd, struct mt9m111, icd);
 	int data;
 
@@ -898,6 +904,7 @@ static int mt9m111_release(struct soc_camera_device *icd)
  */
 static int mt9m111_video_probe(struct soc_camera_device *icd)
 {
+	struct i2c_client *client = to_i2c_client(icd->control);
 	struct mt9m111 *mt9m111 = container_of(icd, struct mt9m111, icd);
 	s32 data;
 	int ret;
diff --git a/drivers/media/video/mt9t031.c b/drivers/media/video/mt9t031.c
index 2b0927b..f72aeb7 100644
--- a/drivers/media/video/mt9t031.c
+++ b/drivers/media/video/mt9t031.c
@@ -76,64 +76,61 @@ struct mt9t031 {
 	u16 yskip;
 };
 
-static int reg_read(struct soc_camera_device *icd, const u8 reg)
+static int reg_read(struct i2c_client *client, const u8 reg)
 {
-	struct mt9t031 *mt9t031 = container_of(icd, struct mt9t031, icd);
-	struct i2c_client *client = mt9t031->client;
 	s32 data = i2c_smbus_read_word_data(client, reg);
 	return data < 0 ? data : swab16(data);
 }
 
-static int reg_write(struct soc_camera_device *icd, const u8 reg,
+static int reg_write(struct i2c_client *client, const u8 reg,
 		     const u16 data)
 {
-	struct mt9t031 *mt9t031 = container_of(icd, struct mt9t031, icd);
-	return i2c_smbus_write_word_data(mt9t031->client, reg, swab16(data));
+	return i2c_smbus_write_word_data(client, reg, swab16(data));
 }
 
-static int reg_set(struct soc_camera_device *icd, const u8 reg,
+static int reg_set(struct i2c_client *client, const u8 reg,
 		   const u16 data)
 {
 	int ret;
 
-	ret = reg_read(icd, reg);
+	ret = reg_read(client, reg);
 	if (ret < 0)
 		return ret;
-	return reg_write(icd, reg, ret | data);
+	return reg_write(client, reg, ret | data);
 }
 
-static int reg_clear(struct soc_camera_device *icd, const u8 reg,
+static int reg_clear(struct i2c_client *client, const u8 reg,
 		     const u16 data)
 {
 	int ret;
 
-	ret = reg_read(icd, reg);
+	ret = reg_read(client, reg);
 	if (ret < 0)
 		return ret;
-	return reg_write(icd, reg, ret & ~data);
+	return reg_write(client, reg, ret & ~data);
 }
 
-static int set_shutter(struct soc_camera_device *icd, const u32 data)
+static int set_shutter(struct i2c_client *client, const u32 data)
 {
 	int ret;
 
-	ret = reg_write(icd, MT9T031_SHUTTER_WIDTH_UPPER, data >> 16);
+	ret = reg_write(client, MT9T031_SHUTTER_WIDTH_UPPER, data >> 16);
 
 	if (ret >= 0)
-		ret = reg_write(icd, MT9T031_SHUTTER_WIDTH, data & 0xffff);
+		ret = reg_write(client, MT9T031_SHUTTER_WIDTH, data & 0xffff);
 
 	return ret;
 }
 
-static int get_shutter(struct soc_camera_device *icd, u32 *data)
+static int get_shutter(struct i2c_client *client, u32 *data)
 {
 	int ret;
 
-	ret = reg_read(icd, MT9T031_SHUTTER_WIDTH_UPPER);
+	ret = reg_read(client, MT9T031_SHUTTER_WIDTH_UPPER);
 	*data = ret << 16;
 
 	if (ret >= 0)
-		ret = reg_read(icd, MT9T031_SHUTTER_WIDTH);
+		ret = reg_read(client, MT9T031_SHUTTER_WIDTH);
 	*data |= ret & 0xffff;
 
 	return ret < 0 ? ret : 0;
@@ -141,12 +138,12 @@ static int get_shutter(struct soc_camera_device *icd, u32 *data)
 
 static int mt9t031_init(struct soc_camera_device *icd)
 {
-	struct mt9t031 *mt9t031 = container_of(icd, struct mt9t031, icd);
-	struct soc_camera_link *icl = mt9t031->client->dev.platform_data;
+	struct i2c_client *client = to_i2c_client(icd->control);
+	struct soc_camera_link *icl = client->dev.platform_data;
 	int ret;
 
 	if (icl->power) {
-		ret = icl->power(&mt9t031->client->dev, 1);
+		ret = icl->power(&client->dev, 1);
 		if (ret < 0) {
 			dev_err(icd->vdev->parent,
 				"Platform failed to power-on the camera.\n");
@@ -155,44 +152,48 @@ static int mt9t031_init(struct soc_camera_device *icd)
 	}
 
 	/* Disable chip output, synchronous option update */
-	ret = reg_write(icd, MT9T031_RESET, 1);
+	ret = reg_write(client, MT9T031_RESET, 1);
 	if (ret >= 0)
-		ret = reg_write(icd, MT9T031_RESET, 0);
+		ret = reg_write(client, MT9T031_RESET, 0);
 	if (ret >= 0)
-		ret = reg_clear(icd, MT9T031_OUTPUT_CONTROL, 2);
+		ret = reg_clear(client, MT9T031_OUTPUT_CONTROL, 2);
 
 	if (ret < 0 && icl->power)
-		icl->power(&mt9t031->client->dev, 0);
+		icl->power(&client->dev, 0);
 
 	return ret >= 0 ? 0 : -EIO;
 }
 
 static int mt9t031_release(struct soc_camera_device *icd)
 {
-	struct mt9t031 *mt9t031 = container_of(icd, struct mt9t031, icd);
-	struct soc_camera_link *icl = mt9t031->client->dev.platform_data;
+	struct i2c_client *client = to_i2c_client(icd->control);
+	struct soc_camera_link *icl = client->dev.platform_data;
 
 	/* Disable the chip */
-	reg_clear(icd, MT9T031_OUTPUT_CONTROL, 2);
+	reg_clear(client, MT9T031_OUTPUT_CONTROL, 2);
 
 	if (icl->power)
-		icl->power(&mt9t031->client->dev, 0);
+		icl->power(&client->dev, 0);
 
 	return 0;
 }
 
 static int mt9t031_start_capture(struct soc_camera_device *icd)
 {
+	struct i2c_client *client = to_i2c_client(icd->control);
+
 	/* Switch to master "normal" mode */
-	if (reg_set(icd, MT9T031_OUTPUT_CONTROL, 2) < 0)
+	if (reg_set(client, MT9T031_OUTPUT_CONTROL, 2) < 0)
 		return -EIO;
 	return 0;
 }
 
 static int mt9t031_stop_capture(struct soc_camera_device *icd)
 {
+	struct i2c_client *client = to_i2c_client(icd->control);
+
 	/* Stop sensor readout */
-	if (reg_clear(icd, MT9T031_OUTPUT_CONTROL, 2) < 0)
+	if (reg_clear(client, MT9T031_OUTPUT_CONTROL, 2) < 0)
 		return -EIO;
 	return 0;
 }
@@ -200,14 +201,16 @@ static int mt9t031_stop_capture(struct soc_camera_device *icd)
 static int mt9t031_set_bus_param(struct soc_camera_device *icd,
 				 unsigned long flags)
 {
+	struct i2c_client *client = to_i2c_client(icd->control);
+
 	/* The caller should have queried our parameters, check anyway */
 	if (flags & ~MT9T031_BUS_PARAM)
 		return -EINVAL;
 
 	if (flags & SOCAM_PCLK_SAMPLE_FALLING)
-		reg_clear(icd, MT9T031_PIXEL_CLOCK_CONTROL, 0x8000);
+		reg_clear(client, MT9T031_PIXEL_CLOCK_CONTROL, 0x8000);
 	else
-		reg_set(icd, MT9T031_PIXEL_CLOCK_CONTROL, 0x8000);
+		reg_set(client, MT9T031_PIXEL_CLOCK_CONTROL, 0x8000);
 
 	return 0;
 }
@@ -235,6 +238,7 @@ static void recalculate_limits(struct soc_camera_device *icd,
 static int mt9t031_set_params(struct soc_camera_device *icd,
 			      struct v4l2_rect *rect, u16 xskip, u16 yskip)
 {
+	struct i2c_client *client = to_i2c_client(icd->control);
 	struct mt9t031 *mt9t031 = container_of(icd, struct mt9t031, icd);
 	int ret;
 	u16 xbin, ybin, width, height, left, top;
@@ -277,22 +281,22 @@ static int mt9t031_set_params(struct soc_camera_device *icd,
 	}
 
 	/* Disable register update, reconfigure atomically */
-	ret = reg_set(icd, MT9T031_OUTPUT_CONTROL, 1);
+	ret = reg_set(client, MT9T031_OUTPUT_CONTROL, 1);
 	if (ret < 0)
 		return ret;
 
 	/* Blanking and start values - default... */
-	ret = reg_write(icd, MT9T031_HORIZONTAL_BLANKING, hblank);
+	ret = reg_write(client, MT9T031_HORIZONTAL_BLANKING, hblank);
 	if (ret >= 0)
-		ret = reg_write(icd, MT9T031_VERTICAL_BLANKING, vblank);
+		ret = reg_write(client, MT9T031_VERTICAL_BLANKING, vblank);
 
 	if (yskip != mt9t031->yskip || xskip != mt9t031->xskip) {
 		/* Binning, skipping */
 		if (ret >= 0)
-			ret = reg_write(icd, MT9T031_COLUMN_ADDRESS_MODE,
+			ret = reg_write(client, MT9T031_COLUMN_ADDRESS_MODE,
 					((xbin - 1) << 4) | (xskip - 1));
 		if (ret >= 0)
-			ret = reg_write(icd, MT9T031_ROW_ADDRESS_MODE,
+			ret = reg_write(client, MT9T031_ROW_ADDRESS_MODE,
 					((ybin - 1) << 4) | (yskip - 1));
 	}
 	dev_dbg(&icd->dev, "new physical left %u, top %u\n", left, top);
@@ -300,16 +304,16 @@ static int mt9t031_set_params(struct soc_camera_device *icd,
 	/* The caller provides a supported format, as guaranteed by
 	 * icd->try_fmt_cap(), soc_camera_s_crop() and soc_camera_cropcap() */
 	if (ret >= 0)
-		ret = reg_write(icd, MT9T031_COLUMN_START, left);
+		ret = reg_write(client, MT9T031_COLUMN_START, left);
 	if (ret >= 0)
-		ret = reg_write(icd, MT9T031_ROW_START, top);
+		ret = reg_write(client, MT9T031_ROW_START, top);
 	if (ret >= 0)
-		ret = reg_write(icd, MT9T031_WINDOW_WIDTH, width - 1);
+		ret = reg_write(client, MT9T031_WINDOW_WIDTH, width - 1);
 	if (ret >= 0)
-		ret = reg_write(icd, MT9T031_WINDOW_HEIGHT,
+		ret = reg_write(client, MT9T031_WINDOW_HEIGHT,
 				height + icd->y_skip_top - 1);
 	if (ret >= 0 && mt9t031->autoexposure) {
-		ret = set_shutter(icd, height + icd->y_skip_top + vblank);
+		ret = set_shutter(client, height + icd->y_skip_top + vblank);
 		if (ret >= 0) {
 			const u32 shutter_max = MT9T031_MAX_HEIGHT + vblank;
 			const struct v4l2_queryctrl *qctrl =
@@ -324,7 +328,7 @@ static int mt9t031_set_params(struct soc_camera_device *icd,
 
 	/* Re-enable register update, commit all changes */
 	if (ret >= 0)
-		ret = reg_clear(icd, MT9T031_OUTPUT_CONTROL, 1);
+		ret = reg_clear(client, MT9T031_OUTPUT_CONTROL, 1);
 
 	return ret < 0 ? ret : 0;
 }
@@ -417,15 +421,15 @@ static int mt9t031_get_chip_id(struct soc_camera_device *icd,
 static int mt9t031_get_register(struct soc_camera_device *icd,
 				struct v4l2_dbg_register *reg)
 {
-	struct mt9t031 *mt9t031 = container_of(icd, struct mt9t031, icd);
+	struct i2c_client *client = to_i2c_client(icd->control);
 
 	if (reg->match.type != V4L2_CHIP_MATCH_I2C_ADDR || reg->reg > 0xff)
 		return -EINVAL;
 
-	if (reg->match.addr != mt9t031->client->addr)
+	if (reg->match.addr != client->addr)
 		return -ENODEV;
 
-	reg->val = reg_read(icd, reg->reg);
+	reg->val = reg_read(client, reg->reg);
 
 	if (reg->val > 0xffff)
 		return -EIO;
@@ -436,15 +440,15 @@ static int mt9t031_get_register(struct soc_camera_device *icd,
 static int mt9t031_set_register(struct soc_camera_device *icd,
 				struct v4l2_dbg_register *reg)
 {
-	struct mt9t031 *mt9t031 = container_of(icd, struct mt9t031, icd);
+	struct i2c_client *client = to_i2c_client(icd->control);
 
 	if (reg->match.type != V4L2_CHIP_MATCH_I2C_ADDR || reg->reg > 0xff)
 		return -EINVAL;
 
-	if (reg->match.addr != mt9t031->client->addr)
+	if (reg->match.addr != client->addr)
 		return -ENODEV;
 
-	if (reg_write(icd, reg->reg, reg->val) < 0)
+	if (reg_write(client, reg->reg, reg->val) < 0)
 		return -EIO;
 
 	return 0;
@@ -528,18 +532,19 @@ static struct soc_camera_ops mt9t031_ops = {
 
 static int mt9t031_get_control(struct soc_camera_device *icd, struct v4l2_control *ctrl)
 {
+	struct i2c_client *client = to_i2c_client(icd->control);
 	struct mt9t031 *mt9t031 = container_of(icd, struct mt9t031, icd);
 	int data;
 
 	switch (ctrl->id) {
 	case V4L2_CID_VFLIP:
-		data = reg_read(icd, MT9T031_READ_MODE_2);
+		data = reg_read(client, MT9T031_READ_MODE_2);
 		if (data < 0)
 			return -EIO;
 		ctrl->value = !!(data & 0x8000);
 		break;
 	case V4L2_CID_HFLIP:
-		data = reg_read(icd, MT9T031_READ_MODE_2);
+		data = reg_read(client, MT9T031_READ_MODE_2);
 		if (data < 0)
 			return -EIO;
 		ctrl->value = !!(data & 0x4000);
@@ -553,6 +558,7 @@ static int mt9t031_get_control(struct soc_camera_device *icd, struct v4l2_contro
 
 static int mt9t031_set_control(struct soc_camera_device *icd, struct v4l2_control *ctrl)
 {
+	struct i2c_client *client = to_i2c_client(icd->control);
 	struct mt9t031 *mt9t031 = container_of(icd, struct mt9t031, icd);
 	const struct v4l2_queryctrl *qctrl;
 	int data;
@@ -565,17 +571,17 @@ static int mt9t031_set_control(struct soc_camera_device *icd, struct v4l2_contro
 	switch (ctrl->id) {
 	case V4L2_CID_VFLIP:
 		if (ctrl->value)
-			data = reg_set(icd, MT9T031_READ_MODE_2, 0x8000);
+			data = reg_set(client, MT9T031_READ_MODE_2, 0x8000);
 		else
-			data = reg_clear(icd, MT9T031_READ_MODE_2, 0x8000);
+			data = reg_clear(client, MT9T031_READ_MODE_2, 0x8000);
 		if (data < 0)
 			return -EIO;
 		break;
 	case V4L2_CID_HFLIP:
 		if (ctrl->value)
-			data = reg_set(icd, MT9T031_READ_MODE_2, 0x4000);
+			data = reg_set(client, MT9T031_READ_MODE_2, 0x4000);
 		else
-			data = reg_clear(icd, MT9T031_READ_MODE_2, 0x4000);
+			data = reg_clear(client, MT9T031_READ_MODE_2, 0x4000);
 		if (data < 0)
 			return -EIO;
 		break;
@@ -589,7 +595,7 @@ static int mt9t031_set_control(struct soc_camera_device *icd, struct v4l2_contro
 			data = ((ctrl->value - qctrl->minimum) * 8 + range / 2) / range;
 
 			dev_dbg(&icd->dev, "Setting gain %d\n", data);
-			data = reg_write(icd, MT9T031_GLOBAL_GAIN, data);
+			data = reg_write(client, MT9T031_GLOBAL_GAIN, data);
 			if (data < 0)
 				return -EIO;
 		} else {
@@ -609,8 +615,8 @@ static int mt9t031_set_control(struct soc_camera_device *icd, struct v4l2_contro
 				data = (((gain - 64 + 7) * 32) & 0xff00) | 0x60;
 
 			dev_dbg(&icd->dev, "Setting gain from 0x%x to 0x%x\n",
-				reg_read(icd, MT9T031_GLOBAL_GAIN), data);
-			data = reg_write(icd, MT9T031_GLOBAL_GAIN, data);
+				reg_read(client, MT9T031_GLOBAL_GAIN), data);
+			data = reg_write(client, MT9T031_GLOBAL_GAIN, data);
 			if (data < 0)
 				return -EIO;
 		}
@@ -628,10 +634,10 @@ static int mt9t031_set_control(struct soc_camera_device *icd, struct v4l2_contro
 					     range / 2) / range + 1;
 			u32 old;
 
-			get_shutter(icd, &old);
+			get_shutter(client, &old);
 			dev_dbg(&icd->dev, "Setting shutter width from %u to %u\n",
 				old, shutter);
-			if (set_shutter(icd, shutter) < 0)
+			if (set_shutter(client, shutter) < 0)
 				return -EIO;
 			icd->exposure = ctrl->value;
 			mt9t031->autoexposure = 0;
@@ -641,7 +647,7 @@ static int mt9t031_set_control(struct soc_camera_device *icd, struct v4l2_contro
 		if (ctrl->value) {
 			const u16 vblank = MT9T031_VERTICAL_BLANK;
 			const u32 shutter_max = MT9T031_MAX_HEIGHT + vblank;
-			if (set_shutter(icd, icd->height +
+			if (set_shutter(client, icd->height +
 					icd->y_skip_top + vblank) < 0)
 				return -EIO;
 			qctrl = soc_camera_find_qctrl(icd->ops, V4L2_CID_EXPOSURE);
@@ -661,6 +667,7 @@ static int mt9t031_set_control(struct soc_camera_device *icd, struct v4l2_contro
  * this wasn't our capture interface, so, we wait for the right one */
 static int mt9t031_video_probe(struct soc_camera_device *icd)
 {
+	struct i2c_client *client = to_i2c_client(icd->control);
 	struct mt9t031 *mt9t031 = container_of(icd, struct mt9t031, icd);
 	s32 data;
 	int ret;
@@ -672,11 +679,11 @@ static int mt9t031_video_probe(struct soc_camera_device *icd)
 		return -ENODEV;
 
 	/* Enable the chip */
-	data = reg_write(icd, MT9T031_CHIP_ENABLE, 1);
+	data = reg_write(client, MT9T031_CHIP_ENABLE, 1);
 	dev_dbg(&icd->dev, "write: %d\n", data);
 
 	/* Read out the chip version register */
-	data = reg_read(icd, MT9T031_CHIP_VERSION);
+	data = reg_read(client, MT9T031_CHIP_VERSION);
 
 	switch (data) {
 	case 0x1621:
diff --git a/drivers/media/video/mt9v022.c b/drivers/media/video/mt9v022.c
index 412b399..be20d31 100644
--- a/drivers/media/video/mt9v022.c
+++ b/drivers/media/video/mt9v022.c
@@ -91,51 +91,49 @@ struct mt9v022 {
 	u16 chip_control;
 };
 
-static int reg_read(struct soc_camera_device *icd, const u8 reg)
+static int reg_read(struct i2c_client *client, const u8 reg)
 {
-	struct mt9v022 *mt9v022 = container_of(icd, struct mt9v022, icd);
-	struct i2c_client *client = mt9v022->client;
 	s32 data = i2c_smbus_read_word_data(client, reg);
 	return data < 0 ? data : swab16(data);
 }
 
-static int reg_write(struct soc_camera_device *icd, const u8 reg,
+static int reg_write(struct i2c_client *client, const u8 reg,
 		     const u16 data)
 {
-	struct mt9v022 *mt9v022 = container_of(icd, struct mt9v022, icd);
-	return i2c_smbus_write_word_data(mt9v022->client, reg, swab16(data));
+	return i2c_smbus_write_word_data(client, reg, swab16(data));
 }
 
-static int reg_set(struct soc_camera_device *icd, const u8 reg,
+static int reg_set(struct i2c_client *client, const u8 reg,
 		   const u16 data)
 {
 	int ret;
 
-	ret = reg_read(icd, reg);
+	ret = reg_read(client, reg);
 	if (ret < 0)
 		return ret;
-	return reg_write(icd, reg, ret | data);
+	return reg_write(client, reg, ret | data);
 }
 
-static int reg_clear(struct soc_camera_device *icd, const u8 reg,
+static int reg_clear(struct i2c_client *client, const u8 reg,
 		     const u16 data)
 {
 	int ret;
 
-	ret = reg_read(icd, reg);
+	ret = reg_read(client, reg);
 	if (ret < 0)
 		return ret;
-	return reg_write(icd, reg, ret & ~data);
+	return reg_write(client, reg, ret & ~data);
 }
 
 static int mt9v022_init(struct soc_camera_device *icd)
 {
+	struct i2c_client *client = to_i2c_client(icd->control);
 	struct mt9v022 *mt9v022 = container_of(icd, struct mt9v022, icd);
-	struct soc_camera_link *icl = mt9v022->client->dev.platform_data;
+	struct soc_camera_link *icl = client->dev.platform_data;
 	int ret;
 
 	if (icl->power) {
-		ret = icl->power(&mt9v022->client->dev, 1);
+		ret = icl->power(&client->dev, 1);
 		if (ret < 0) {
 			dev_err(icd->vdev->parent,
 				"Platform failed to power-on the camera.\n");
@@ -148,27 +146,27 @@ static int mt9v022_init(struct soc_camera_device *icd)
 	 * if available. Soft reset is done in video_probe().
 	 */
 	if (icl->reset)
-		icl->reset(&mt9v022->client->dev);
+		icl->reset(&client->dev);
 
 	/* Almost the default mode: master, parallel, simultaneous, and an
 	 * undocumented bit 0x200, which is present in table 7, but not in 8,
 	 * plus snapshot mode to disable scan for now */
 	mt9v022->chip_control |= 0x10;
-	ret = reg_write(icd, MT9V022_CHIP_CONTROL, mt9v022->chip_control);
+	ret = reg_write(client, MT9V022_CHIP_CONTROL, mt9v022->chip_control);
 	if (!ret)
-		ret = reg_write(icd, MT9V022_READ_MODE, 0x300);
+		ret = reg_write(client, MT9V022_READ_MODE, 0x300);
 
 	/* All defaults */
 	if (!ret)
 		/* AEC, AGC on */
-		ret = reg_set(icd, MT9V022_AEC_AGC_ENABLE, 0x3);
+		ret = reg_set(client, MT9V022_AEC_AGC_ENABLE, 0x3);
 	if (!ret)
-		ret = reg_write(icd, MT9V022_MAX_TOTAL_SHUTTER_WIDTH, 480);
+		ret = reg_write(client, MT9V022_MAX_TOTAL_SHUTTER_WIDTH, 480);
 	if (!ret)
 		/* default - auto */
-		ret = reg_clear(icd, MT9V022_BLACK_LEVEL_CALIB_CTRL, 1);
+		ret = reg_clear(client, MT9V022_BLACK_LEVEL_CALIB_CTRL, 1);
 	if (!ret)
-		ret = reg_write(icd, MT9V022_DIGITAL_TEST_PATTERN, 0);
+		ret = reg_write(client, MT9V022_DIGITAL_TEST_PATTERN, 0);
 
 	return ret;
 }
@@ -186,10 +184,11 @@ static int mt9v022_release(struct soc_camera_device *icd)
 
 static int mt9v022_start_capture(struct soc_camera_device *icd)
 {
+	struct i2c_client *client = to_i2c_client(icd->control);
 	struct mt9v022 *mt9v022 = container_of(icd, struct mt9v022, icd);
 	/* Switch to master "normal" mode */
 	mt9v022->chip_control &= ~0x10;
-	if (reg_write(icd, MT9V022_CHIP_CONTROL,
+	if (reg_write(client, MT9V022_CHIP_CONTROL,
 		      mt9v022->chip_control) < 0)
 		return -EIO;
 	return 0;
@@ -197,10 +196,11 @@ static int mt9v022_start_capture(struct soc_camera_device *icd)
 
 static int mt9v022_stop_capture(struct soc_camera_device *icd)
 {
+	struct i2c_client *client = to_i2c_client(icd->control);
 	struct mt9v022 *mt9v022 = container_of(icd, struct mt9v022, icd);
 	/* Switch to snapshot mode */
 	mt9v022->chip_control |= 0x10;
-	if (reg_write(icd, MT9V022_CHIP_CONTROL,
+	if (reg_write(client, MT9V022_CHIP_CONTROL,
 		      mt9v022->chip_control) < 0)
 		return -EIO;
 	return 0;
@@ -209,8 +209,9 @@ static int mt9v022_stop_capture(struct soc_camera_device *icd)
 static int mt9v022_set_bus_param(struct soc_camera_device *icd,
 				 unsigned long flags)
 {
+	struct i2c_client *client = to_i2c_client(icd->control);
 	struct mt9v022 *mt9v022 = container_of(icd, struct mt9v022, icd);
-	struct soc_camera_link *icl = mt9v022->client->dev.platform_data;
+	struct soc_camera_link *icl = client->dev.platform_data;
 	unsigned int width_flag = flags & SOCAM_DATAWIDTH_MASK;
 	int ret;
 	u16 pixclk = 0;
@@ -243,14 +244,14 @@ static int mt9v022_set_bus_param(struct soc_camera_device *icd,
 	if (!(flags & SOCAM_VSYNC_ACTIVE_HIGH))
 		pixclk |= 0x2;
 
-	ret = reg_write(icd, MT9V022_PIXCLK_FV_LV, pixclk);
+	ret = reg_write(client, MT9V022_PIXCLK_FV_LV, pixclk);
 	if (ret < 0)
 		return ret;
 
 	if (!(flags & SOCAM_MASTER))
 		mt9v022->chip_control &= ~0x8;
 
-	ret = reg_write(icd, MT9V022_CHIP_CONTROL, mt9v022->chip_control);
+	ret = reg_write(client, MT9V022_CHIP_CONTROL, mt9v022->chip_control);
 	if (ret < 0)
 		return ret;
 
@@ -282,35 +283,36 @@ static unsigned long mt9v022_query_bus_param(struct soc_camera_device *icd)
 static int mt9v022_set_crop(struct soc_camera_device *icd,
 			    struct v4l2_rect *rect)
 {
+	struct i2c_client *client = to_i2c_client(icd->control);
 	int ret;
 
 	/* Like in example app. Contradicts the datasheet though */
-	ret = reg_read(icd, MT9V022_AEC_AGC_ENABLE);
+	ret = reg_read(client, MT9V022_AEC_AGC_ENABLE);
 	if (ret >= 0) {
 		if (ret & 1) /* Autoexposure */
-			ret = reg_write(icd, MT9V022_MAX_TOTAL_SHUTTER_WIDTH,
+			ret = reg_write(client, MT9V022_MAX_TOTAL_SHUTTER_WIDTH,
 					rect->height + icd->y_skip_top + 43);
 		else
-			ret = reg_write(icd, MT9V022_TOTAL_SHUTTER_WIDTH,
+			ret = reg_write(client, MT9V022_TOTAL_SHUTTER_WIDTH,
 					rect->height + icd->y_skip_top + 43);
 	}
 	/* Setup frame format: defaults apart from width and height */
 	if (!ret)
-		ret = reg_write(icd, MT9V022_COLUMN_START, rect->left);
+		ret = reg_write(client, MT9V022_COLUMN_START, rect->left);
 	if (!ret)
-		ret = reg_write(icd, MT9V022_ROW_START, rect->top);
+		ret = reg_write(client, MT9V022_ROW_START, rect->top);
 	if (!ret)
 		/* Default 94, Phytec driver says:
 		 * "width + horizontal blank >= 660" */
-		ret = reg_write(icd, MT9V022_HORIZONTAL_BLANKING,
+		ret = reg_write(client, MT9V022_HORIZONTAL_BLANKING,
 				rect->width > 660 - 43 ? 43 :
 				660 - rect->width);
 	if (!ret)
-		ret = reg_write(icd, MT9V022_VERTICAL_BLANKING, 45);
+		ret = reg_write(client, MT9V022_VERTICAL_BLANKING, 45);
 	if (!ret)
-		ret = reg_write(icd, MT9V022_WINDOW_WIDTH, rect->width);
+		ret = reg_write(client, MT9V022_WINDOW_WIDTH, rect->width);
 	if (!ret)
-		ret = reg_write(icd, MT9V022_WINDOW_HEIGHT,
+		ret = reg_write(client, MT9V022_WINDOW_HEIGHT,
 				rect->height + icd->y_skip_top);
 
 	if (ret < 0)
@@ -396,16 +398,16 @@ static int mt9v022_get_chip_id(struct soc_camera_device *icd,
 static int mt9v022_get_register(struct soc_camera_device *icd,
 				struct v4l2_dbg_register *reg)
 {
-	struct mt9v022 *mt9v022 = container_of(icd, struct mt9v022, icd);
+	struct i2c_client *client = to_i2c_client(icd->control);
 
 	if (reg->match.type != V4L2_CHIP_MATCH_I2C_ADDR || reg->reg > 0xff)
 		return -EINVAL;
 
-	if (reg->match.addr != mt9v022->client->addr)
+	if (reg->match.addr != client->addr)
 		return -ENODEV;
 
 	reg->size = 2;
-	reg->val = reg_read(icd, reg->reg);
+	reg->val = reg_read(client, reg->reg);
 
 	if (reg->val > 0xffff)
 		return -EIO;
@@ -416,15 +418,15 @@ static int mt9v022_get_register(struct soc_camera_device *icd,
 static int mt9v022_set_register(struct soc_camera_device *icd,
 				struct v4l2_dbg_register *reg)
 {
-	struct mt9v022 *mt9v022 = container_of(icd, struct mt9v022, icd);
+	struct i2c_client *client = to_i2c_client(icd->control);
 
 	if (reg->match.type != V4L2_CHIP_MATCH_I2C_ADDR || reg->reg > 0xff)
 		return -EINVAL;
 
-	if (reg->match.addr != mt9v022->client->addr)
+	if (reg->match.addr != client->addr)
 		return -ENODEV;
 
-	if (reg_write(icd, reg->reg, reg->val) < 0)
+	if (reg_write(client, reg->reg, reg->val) < 0)
 		return -EIO;
 
 	return 0;
@@ -517,29 +519,30 @@ static struct soc_camera_ops mt9v022_ops = {
 static int mt9v022_get_control(struct soc_camera_device *icd,
 			       struct v4l2_control *ctrl)
 {
+	struct i2c_client *client = to_i2c_client(icd->control);
 	int data;
 
 	switch (ctrl->id) {
 	case V4L2_CID_VFLIP:
-		data = reg_read(icd, MT9V022_READ_MODE);
+		data = reg_read(client, MT9V022_READ_MODE);
 		if (data < 0)
 			return -EIO;
 		ctrl->value = !!(data & 0x10);
 		break;
 	case V4L2_CID_HFLIP:
-		data = reg_read(icd, MT9V022_READ_MODE);
+		data = reg_read(client, MT9V022_READ_MODE);
 		if (data < 0)
 			return -EIO;
 		ctrl->value = !!(data & 0x20);
 		break;
 	case V4L2_CID_EXPOSURE_AUTO:
-		data = reg_read(icd, MT9V022_AEC_AGC_ENABLE);
+		data = reg_read(client, MT9V022_AEC_AGC_ENABLE);
 		if (data < 0)
 			return -EIO;
 		ctrl->value = !!(data & 0x1);
 		break;
 	case V4L2_CID_AUTOGAIN:
-		data = reg_read(icd, MT9V022_AEC_AGC_ENABLE);
+		data = reg_read(client, MT9V022_AEC_AGC_ENABLE);
 		if (data < 0)
 			return -EIO;
 		ctrl->value = !!(data & 0x2);
@@ -552,6 +555,7 @@ static int mt9v022_set_control(struct soc_camera_device *icd,
 			       struct v4l2_control *ctrl)
 {
 	int data;
+	struct i2c_client *client = to_i2c_client(icd->control);
 	const struct v4l2_queryctrl *qctrl;
 
 	qctrl = soc_camera_find_qctrl(&mt9v022_ops, ctrl->id);
@@ -562,17 +566,17 @@ static int mt9v022_set_control(struct soc_camera_device *icd,
 	switch (ctrl->id) {
 	case V4L2_CID_VFLIP:
 		if (ctrl->value)
-			data = reg_set(icd, MT9V022_READ_MODE, 0x10);
+			data = reg_set(client, MT9V022_READ_MODE, 0x10);
 		else
-			data = reg_clear(icd, MT9V022_READ_MODE, 0x10);
+			data = reg_clear(client, MT9V022_READ_MODE, 0x10);
 		if (data < 0)
 			return -EIO;
 		break;
 	case V4L2_CID_HFLIP:
 		if (ctrl->value)
-			data = reg_set(icd, MT9V022_READ_MODE, 0x20);
+			data = reg_set(client, MT9V022_READ_MODE, 0x20);
 		else
-			data = reg_clear(icd, MT9V022_READ_MODE, 0x20);
+			data = reg_clear(client, MT9V022_READ_MODE, 0x20);
 		if (data < 0)
 			return -EIO;
 		break;
@@ -593,12 +597,12 @@ static int mt9v022_set_control(struct soc_camera_device *icd,
 			/* The user wants to set gain manually, hope, she
 			 * knows, what she's doing... Switch AGC off. */
 
-			if (reg_clear(icd, MT9V022_AEC_AGC_ENABLE, 0x2) < 0)
+			if (reg_clear(client, MT9V022_AEC_AGC_ENABLE, 0x2) < 0)
 				return -EIO;
 
 			dev_info(&icd->dev, "Setting gain from %d to %lu\n",
-				 reg_read(icd, MT9V022_ANALOG_GAIN), gain);
-			if (reg_write(icd, MT9V022_ANALOG_GAIN, gain) < 0)
+				 reg_read(client, MT9V022_ANALOG_GAIN), gain);
+			if (reg_write(client, MT9V022_ANALOG_GAIN, gain) < 0)
 				return -EIO;
 			icd->gain = ctrl->value;
 		}
@@ -614,13 +618,13 @@ static int mt9v022_set_control(struct soc_camera_device *icd,
 			/* The user wants to set shutter width manually, hope,
 			 * she knows, what she's doing... Switch AEC off. */
 
-			if (reg_clear(icd, MT9V022_AEC_AGC_ENABLE, 0x1) < 0)
+			if (reg_clear(client, MT9V022_AEC_AGC_ENABLE, 0x1) < 0)
 				return -EIO;
 
 			dev_dbg(&icd->dev, "Shutter width from %d to %lu\n",
-				reg_read(icd, MT9V022_TOTAL_SHUTTER_WIDTH),
+				reg_read(client, MT9V022_TOTAL_SHUTTER_WIDTH),
 				shutter);
-			if (reg_write(icd, MT9V022_TOTAL_SHUTTER_WIDTH,
+			if (reg_write(client, MT9V022_TOTAL_SHUTTER_WIDTH,
 				      shutter) < 0)
 				return -EIO;
 			icd->exposure = ctrl->value;
@@ -628,17 +632,17 @@ static int mt9v022_set_control(struct soc_camera_device *icd,
 		break;
 	case V4L2_CID_AUTOGAIN:
 		if (ctrl->value)
-			data = reg_set(icd, MT9V022_AEC_AGC_ENABLE, 0x2);
+			data = reg_set(client, MT9V022_AEC_AGC_ENABLE, 0x2);
 		else
-			data = reg_clear(icd, MT9V022_AEC_AGC_ENABLE, 0x2);
+			data = reg_clear(client, MT9V022_AEC_AGC_ENABLE, 0x2);
 		if (data < 0)
 			return -EIO;
 		break;
 	case V4L2_CID_EXPOSURE_AUTO:
 		if (ctrl->value)
-			data = reg_set(icd, MT9V022_AEC_AGC_ENABLE, 0x1);
+			data = reg_set(client, MT9V022_AEC_AGC_ENABLE, 0x1);
 		else
-			data = reg_clear(icd, MT9V022_AEC_AGC_ENABLE, 0x1);
+			data = reg_clear(client, MT9V022_AEC_AGC_ENABLE, 0x1);
 		if (data < 0)
 			return -EIO;
 		break;
@@ -650,8 +654,9 @@ static int mt9v022_set_control(struct soc_camera_device *icd,
  * this wasn't our capture interface, so, we wait for the right one */
 static int mt9v022_video_probe(struct soc_camera_device *icd)
 {
+	struct i2c_client *client = to_i2c_client(icd->control);
 	struct mt9v022 *mt9v022 = container_of(icd, struct mt9v022, icd);
-	struct soc_camera_link *icl = mt9v022->client->dev.platform_data;
+	struct soc_camera_link *icl = client->dev.platform_data;
 	s32 data;
 	int ret;
 	unsigned long flags;
@@ -661,7 +666,7 @@ static int mt9v022_video_probe(struct soc_camera_device *icd)
 		return -ENODEV;
 
 	/* Read out the chip version register */
-	data = reg_read(icd, MT9V022_CHIP_VERSION);
+	data = reg_read(client, MT9V022_CHIP_VERSION);
 
 	/* must be 0x1311 or 0x1313 */
 	if (data != 0x1311 && data != 0x1313) {
@@ -672,12 +677,12 @@ static int mt9v022_video_probe(struct soc_camera_device *icd)
 	}
 
 	/* Soft reset */
-	ret = reg_write(icd, MT9V022_RESET, 1);
+	ret = reg_write(client, MT9V022_RESET, 1);
 	if (ret < 0)
 		goto ei2c;
 	/* 15 clock cycles */
 	udelay(200);
-	if (reg_read(icd, MT9V022_RESET)) {
+	if (reg_read(client, MT9V022_RESET)) {
 		dev_err(&icd->dev, "Resetting MT9V022 failed!\n");
 		goto ei2c;
 	}
@@ -685,11 +690,11 @@ static int mt9v022_video_probe(struct soc_camera_device *icd)
 	/* Set monochrome or colour sensor type */
 	if (sensor_type && (!strcmp("colour", sensor_type) ||
 			    !strcmp("color", sensor_type))) {
-		ret = reg_write(icd, MT9V022_PIXEL_OPERATION_MODE, 4 | 0x11);
+		ret = reg_write(client, MT9V022_PIXEL_OPERATION_MODE, 4 | 0x11);
 		mt9v022->model = V4L2_IDENT_MT9V022IX7ATC;
 		icd->formats = mt9v022_colour_formats;
 	} else {
-		ret = reg_write(icd, MT9V022_PIXEL_OPERATION_MODE, 0x11);
+		ret = reg_write(client, MT9V022_PIXEL_OPERATION_MODE, 0x11);
 		mt9v022->model = V4L2_IDENT_MT9V022IX7ATM;
 		icd->formats = mt9v022_monochrome_formats;
 	}
-- 
1.5.4

