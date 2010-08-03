Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51793 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755936Ab0HCK5y (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Aug 2010 06:57:54 -0400
From: Michael Grzeschik <m.grzeschik@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: robert.jarzmik@free.fr, g.liakhovetski@gmx.de,
	Philipp Wiesner <p.wiesner@phytec.de>,
	Michael Grzeschik <m.grzeschik@pengutronix.de>
Subject: [PATCH v2 01/11] mt9m111: Added indication that MT9M131 is supported by this driver
Date: Tue,  3 Aug 2010 12:57:39 +0200
Message-Id: <1280833069-26993-2-git-send-email-m.grzeschik@pengutronix.de>
In-Reply-To: <1280833069-26993-1-git-send-email-m.grzeschik@pengutronix.de>
References: <1280833069-26993-1-git-send-email-m.grzeschik@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Philipp Wiesner <p.wiesner@phytec.de>

Added this info to Kconfig and mt9m111.c, some comment cleanup,
replaced 'mt9m11x'-statements by clarifications or driver name.
Driver is fully compatible to mt9m131 which has only additional functions
compared to mt9m111. Those aren't used anyway at the moment.

Signed-off-by: Philipp Wiesner <p.wiesner@phytec.de>
Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
---
Changes v1 -> v2

Address comments from Guennadi Liakhovetski:
	* joined strings to one line in probe dev_err

 drivers/media/video/Kconfig   |    5 +++--
 drivers/media/video/mt9m111.c |   36 ++++++++++++++++++++++--------------
 2 files changed, 25 insertions(+), 16 deletions(-)

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index cdbbbe4..0e8cf24 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -871,10 +871,11 @@ config SOC_CAMERA_MT9M001
 	  and colour models.
 
 config SOC_CAMERA_MT9M111
-	tristate "mt9m111 and mt9m112 support"
+	tristate "mt9m111, mt9m112 and mt9m131 support"
 	depends on SOC_CAMERA && I2C
 	help
-	  This driver supports MT9M111 and MT9M112 cameras from Micron
+	  This driver supports MT9M111, MT9M112 and MT9M131 cameras from
+	  Micron/Aptina
 
 config SOC_CAMERA_MT9T031
 	tristate "mt9t031 support"
diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
index d35f536..68f3df6 100644
--- a/drivers/media/video/mt9m111.c
+++ b/drivers/media/video/mt9m111.c
@@ -1,5 +1,5 @@
 /*
- * Driver for MT9M111/MT9M112 CMOS Image Sensor from Micron
+ * Driver for MT9M111/MT9M112/MT9M131 CMOS Image Sensor from Micron/Aptina
  *
  * Copyright (C) 2008, Robert Jarzmik <robert.jarzmik@free.fr>
  *
@@ -19,11 +19,14 @@
 #include <media/soc_camera.h>
 
 /*
- * mt9m111 and mt9m112 i2c address is 0x5d or 0x48 (depending on SAddr pin)
+ * MT9M111, MT9M112 and MT9M131:
+ * i2c address is 0x48 or 0x5d (depending on SADDR pin)
  * The platform has to define i2c_board_info and call i2c_register_board_info()
  */
 
-/* mt9m111: Sensor register addresses */
+/*
+ * Sensor core register addresses (0x000..0x0ff)
+ */
 #define MT9M111_CHIP_VERSION		0x000
 #define MT9M111_ROW_START		0x001
 #define MT9M111_COLUMN_START		0x002
@@ -72,8 +75,9 @@
 #define MT9M111_CTXT_CTRL_LED_FLASH_EN	(1 << 2)
 #define MT9M111_CTXT_CTRL_VBLANK_SEL_B	(1 << 1)
 #define MT9M111_CTXT_CTRL_HBLANK_SEL_B	(1 << 0)
+
 /*
- * mt9m111: Colorpipe register addresses (0x100..0x1ff)
+ * Colorpipe register addresses (0x100..0x1ff)
  */
 #define MT9M111_OPER_MODE_CTRL		0x106
 #define MT9M111_OUTPUT_FORMAT_CTRL	0x108
@@ -109,8 +113,9 @@
 #define MT9M111_OUTFMT_SWAP_YCbCr_C_Y	(1 << 1)
 #define MT9M111_OUTFMT_SWAP_RGB_EVEN	(1 << 1)
 #define MT9M111_OUTFMT_SWAP_YCbCr_Cb_Cr	(1 << 0)
+
 /*
- * mt9m111: Camera control register addresses (0x200..0x2ff not implemented)
+ * Camera control register addresses (0x200..0x2ff not implemented)
  */
 
 #define reg_read(reg) mt9m111_reg_read(client, MT9M111_##reg)
@@ -160,7 +165,8 @@ enum mt9m111_context {
 
 struct mt9m111 {
 	struct v4l2_subdev subdev;
-	int model;	/* V4L2_IDENT_MT9M11x* codes from v4l2-chip-ident.h */
+	int model;	/* V4L2_IDENT_MT9M111 or V4L2_IDENT_MT9M112 code */
+			/* from v4l2-chip-ident.h */
 	enum mt9m111_context context;
 	struct v4l2_rect rect;
 	const struct mt9m111_datafmt *fmt;
@@ -934,7 +940,7 @@ static int mt9m111_init(struct i2c_client *client)
 	if (!ret)
 		ret = mt9m111_set_autoexposure(client, mt9m111->autoexposure);
 	if (ret)
-		dev_err(&client->dev, "mt9m11x init failed: %d\n", ret);
+		dev_err(&client->dev, "mt9m111 init failed: %d\n", ret);
 	return ret;
 }
 
@@ -970,21 +976,23 @@ static int mt9m111_video_probe(struct soc_camera_device *icd,
 	data = reg_read(CHIP_VERSION);
 
 	switch (data) {
-	case 0x143a: /* MT9M111 */
+	case 0x143a: /* MT9M111 or MT9M131 */
 		mt9m111->model = V4L2_IDENT_MT9M111;
+		dev_info(&client->dev,
+			"Detected a MT9M111/MT9M131 chip ID %x\n", data);
 		break;
 	case 0x148c: /* MT9M112 */
 		mt9m111->model = V4L2_IDENT_MT9M112;
+		dev_info(&client->dev, "Detected a MT9M112 chip ID %x\n", data);
 		break;
 	default:
 		ret = -ENODEV;
 		dev_err(&client->dev,
-			"No MT9M11x chip detected, register read %x\n", data);
+			"No MT9M111/MT9M112/MT9M131 chip detected register read %x\n",
+			data);
 		goto ei2c;
 	}
 
-	dev_info(&client->dev, "Detected a MT9M11x chip ID %x\n", data);
-
 ei2c:
 	return ret;
 }
@@ -1034,13 +1042,13 @@ static int mt9m111_probe(struct i2c_client *client,
 	int ret;
 
 	if (!icd) {
-		dev_err(&client->dev, "MT9M11x: missing soc-camera data!\n");
+		dev_err(&client->dev, "mt9m111: soc-camera data missing!\n");
 		return -EINVAL;
 	}
 
 	icl = to_soc_camera_link(icd);
 	if (!icl) {
-		dev_err(&client->dev, "MT9M11x driver needs platform data\n");
+		dev_err(&client->dev, "mt9m111: driver needs platform data\n");
 		return -EINVAL;
 	}
 
@@ -1116,6 +1124,6 @@ static void __exit mt9m111_mod_exit(void)
 module_init(mt9m111_mod_init);
 module_exit(mt9m111_mod_exit);
 
-MODULE_DESCRIPTION("Micron MT9M111/MT9M112 Camera driver");
+MODULE_DESCRIPTION("Micron/Aptina MT9M111/MT9M112/MT9M131 Camera driver");
 MODULE_AUTHOR("Robert Jarzmik");
 MODULE_LICENSE("GPL");
-- 
1.7.1

