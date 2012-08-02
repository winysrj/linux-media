Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.meprolight.com ([194.90.149.17]:32115 "EHLO meprolight.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752281Ab2HBPl4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Aug 2012 11:41:56 -0400
From: Alex Gershgorin <alexg@meprolight.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: <g.liakhovetski@gmx.de>, <linux-media@vger.kernel.org>,
	Alex Gershgorin <alexg@meprolight.com>
Subject: [PATCH v3] mt9v022: Add support for mt9v024
Date: Thu, 2 Aug 2012 18:32:41 +0300
Message-ID: <1343921561-671-1-git-send-email-alexg@meprolight.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Driver for mt9v022 camera sensor is fully compatible for mt9v024 camera sensor
with the exception of several registers which have been changed addresses.
mt9v024 also has improved and additional features, but they are currently not in use.

Signed-off-by: Alex Gershgorin <alexg@meprolight.com>
---
 drivers/media/video/Kconfig   |    2 +-
 drivers/media/video/mt9v022.c |   36 +++++++++++++++++++++++++++++++-----
 2 files changed, 32 insertions(+), 6 deletions(-)

Changes for v2:
         Fixed comment from Guennadi.

Changes for v3:
         Added patch descriptions.


diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index c128fac..3ce905c 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -1058,7 +1058,7 @@ config SOC_CAMERA_MT9T112
 	  This driver supports MT9T112 cameras from Aptina.
 
 config SOC_CAMERA_MT9V022
-	tristate "mt9v022 support"
+	tristate "mt9v022 and mt9v024 support"
 	depends on SOC_CAMERA && I2C
 	select GPIO_PCA953X if MT9V022_PCA9536_SWITCH
 	help
diff --git a/drivers/media/video/mt9v022.c b/drivers/media/video/mt9v022.c
index 7247924..b67ce7f 100644
--- a/drivers/media/video/mt9v022.c
+++ b/drivers/media/video/mt9v022.c
@@ -57,6 +57,10 @@ MODULE_PARM_DESC(sensor_type, "Sensor type: \"colour\" or \"monochrome\"");
 #define MT9V022_AEC_AGC_ENABLE		0xAF
 #define MT9V022_MAX_TOTAL_SHUTTER_WIDTH	0xBD
 
+/* mt9v024 partial list register addresses changes with respect to mt9v022 */
+#define MT9V024_PIXCLK_FV_LV		0x72
+#define MT9V024_MAX_TOTAL_SHUTTER_WIDTH	0xAD
+
 /* Progressive scan, master, defaults */
 #define MT9V022_CHIP_CONTROL_DEFAULT	0x188
 
@@ -67,6 +71,8 @@ MODULE_PARM_DESC(sensor_type, "Sensor type: \"colour\" or \"monochrome\"");
 #define MT9V022_COLUMN_SKIP		1
 #define MT9V022_ROW_SKIP		4
 
+#define is_mt9v024(id) (id == 0x1324)
+
 /* MT9V022 has only one fixed colorspace per pixelcode */
 struct mt9v022_datafmt {
 	enum v4l2_mbus_pixelcode	code;
@@ -101,6 +107,22 @@ static const struct mt9v022_datafmt mt9v022_monochrome_fmts[] = {
 	{V4L2_MBUS_FMT_Y8_1X8, V4L2_COLORSPACE_JPEG},
 };
 
+/* only registers with different addresses on different mt9v02x sensors */
+struct mt9v02x_register {
+	u8	max_total_shutter_width;
+	u8	pixclk_fv_lv;
+};
+
+static const struct mt9v02x_register mt9v022_register = {
+	.max_total_shutter_width	= MT9V022_MAX_TOTAL_SHUTTER_WIDTH,
+	.pixclk_fv_lv			= MT9V022_PIXCLK_FV_LV,
+};
+
+static const struct mt9v02x_register mt9v024_register = {
+	.max_total_shutter_width	= MT9V024_MAX_TOTAL_SHUTTER_WIDTH,
+	.pixclk_fv_lv			= MT9V024_PIXCLK_FV_LV,
+};
+
 struct mt9v022 {
 	struct v4l2_subdev subdev;
 	struct v4l2_ctrl_handler hdl;
@@ -117,6 +139,7 @@ struct mt9v022 {
 	struct v4l2_rect rect;	/* Sensor window */
 	const struct mt9v022_datafmt *fmt;
 	const struct mt9v022_datafmt *fmts;
+	const struct mt9v02x_register *reg;
 	int num_fmts;
 	int model;	/* V4L2_IDENT_MT9V022* codes from v4l2-chip-ident.h */
 	u16 chip_control;
@@ -185,7 +208,7 @@ static int mt9v022_init(struct i2c_client *client)
 	if (!ret)
 		ret = reg_write(client, MT9V022_TOTAL_SHUTTER_WIDTH, 480);
 	if (!ret)
-		ret = reg_write(client, MT9V022_MAX_TOTAL_SHUTTER_WIDTH, 480);
+		ret = reg_write(client, mt9v022->reg->max_total_shutter_width, 480);
 	if (!ret)
 		/* default - auto */
 		ret = reg_clear(client, MT9V022_BLACK_LEVEL_CALIB_CTRL, 1);
@@ -238,7 +261,7 @@ static int mt9v022_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
 	ret = reg_read(client, MT9V022_AEC_AGC_ENABLE);
 	if (ret >= 0) {
 		if (ret & 1) /* Autoexposure */
-			ret = reg_write(client, MT9V022_MAX_TOTAL_SHUTTER_WIDTH,
+			ret = reg_write(client, mt9v022->reg->max_total_shutter_width,
 					rect.height + mt9v022->y_skip_top + 43);
 		else
 			ret = reg_write(client, MT9V022_TOTAL_SHUTTER_WIDTH,
@@ -573,14 +596,17 @@ static int mt9v022_video_probe(struct i2c_client *client)
 	/* Read out the chip version register */
 	data = reg_read(client, MT9V022_CHIP_VERSION);
 
-	/* must be 0x1311 or 0x1313 */
-	if (data != 0x1311 && data != 0x1313) {
+	/* must be 0x1311, 0x1313 or 0x1324 */
+	if (data != 0x1311 && data != 0x1313 && data != 0x1324) {
 		ret = -ENODEV;
 		dev_info(&client->dev, "No MT9V022 found, ID register 0x%x\n",
 			 data);
 		goto ei2c;
 	}
 
+	mt9v022->reg = is_mt9v024(data) ? &mt9v024_register :
+			&mt9v022_register;
+
 	/* Soft reset */
 	ret = reg_write(client, MT9V022_RESET, 1);
 	if (ret < 0)
@@ -728,7 +754,7 @@ static int mt9v022_s_mbus_config(struct v4l2_subdev *sd,
 	if (!(flags & V4L2_MBUS_VSYNC_ACTIVE_HIGH))
 		pixclk |= 0x2;
 
-	ret = reg_write(client, MT9V022_PIXCLK_FV_LV, pixclk);
+	ret = reg_write(client, mt9v022->reg->pixclk_fv_lv, pixclk);
 	if (ret < 0)
 		return ret;
 
-- 
1.7.0.4

