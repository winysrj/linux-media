Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:43730 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756090Ab2I0Wwv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Sep 2012 18:52:51 -0400
From: Anatolij Gustschin <agust@denx.de>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] mt9v022: support required register settings in snapshot mode
Date: Fri, 28 Sep 2012 00:52:42 +0200
Message-Id: <1348786362-28586-1-git-send-email-agust@denx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some camera systems cannot operate mt9v022 in normal mode and use
only the snapshot mode. The TechNote for mt9v022 (TN0960) and mt9v024
(TN-09-225) describes required register settings when configuring the
snapshot operation. The snapshot mode requires that certain automatic
functions of the image sensor should be disabled or set to fixed values.

According to the TechNote bit 2 and bit 9 in the register 0x20 must be
set in snapshot mode and unset for normal operation. This applies for
mt9v022 Rev.3 and mt9v024. Add required reg. 0x20 settings dependent on
sensor chip version.

Signed-off-by: Anatolij Gustschin <agust@denx.de>
---
 drivers/media/i2c/soc_camera/mt9v022.c |   31 ++++++++++++++++++++++++++++---
 1 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/soc_camera/mt9v022.c b/drivers/media/i2c/soc_camera/mt9v022.c
index 8feaddc..2abe999 100644
--- a/drivers/media/i2c/soc_camera/mt9v022.c
+++ b/drivers/media/i2c/soc_camera/mt9v022.c
@@ -51,6 +51,7 @@ MODULE_PARM_DESC(sensor_type, "Sensor type: \"colour\" or \"monochrome\"");
 #define MT9V022_PIXEL_OPERATION_MODE	0x0f
 #define MT9V022_LED_OUT_CONTROL		0x1b
 #define MT9V022_ADC_MODE_CONTROL	0x1c
+#define MT9V022_REG32			0x20
 #define MT9V022_ANALOG_GAIN		0x35
 #define MT9V022_BLACK_LEVEL_CALIB_CTRL	0x47
 #define MT9V022_PIXCLK_FV_LV		0x74
@@ -79,7 +80,8 @@ MODULE_PARM_DESC(sensor_type, "Sensor type: \"colour\" or \"monochrome\"");
 #define MT9V022_VERTICAL_BLANKING_MAX	3000
 #define MT9V022_VERTICAL_BLANKING_DEF	45
 
-#define is_mt9v024(id) (id == 0x1324)
+#define is_mt9v022_rev3(id)	(id == 0x1313)
+#define is_mt9v024(id)		(id == 0x1324)
 
 /* MT9V022 has only one fixed colorspace per pixelcode */
 struct mt9v022_datafmt {
@@ -153,6 +155,7 @@ struct mt9v022 {
 	int num_fmts;
 	int model;	/* V4L2_IDENT_MT9V022* codes from v4l2-chip-ident.h */
 	u16 chip_control;
+	u16 chip_version;
 	unsigned short y_skip_top;	/* Lines to skip at the top */
 };
 
@@ -235,12 +238,32 @@ static int mt9v022_s_stream(struct v4l2_subdev *sd, int enable)
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct mt9v022 *mt9v022 = to_mt9v022(client);
 
-	if (enable)
+	if (enable) {
 		/* Switch to master "normal" mode */
 		mt9v022->chip_control &= ~0x10;
-	else
+		if (is_mt9v022_rev3(mt9v022->chip_version) ||
+		    is_mt9v024(mt9v022->chip_version)) {
+			/*
+			 * Unset snapshot mode specific settings: clear bit 9
+			 * and bit 2 in reg. 0x20 when in normal mode.
+			 */
+			if (reg_clear(client, MT9V022_REG32, 0x204))
+				return -EIO;
+		}
+	} else {
 		/* Switch to snapshot mode */
 		mt9v022->chip_control |= 0x10;
+		if (is_mt9v022_rev3(mt9v022->chip_version) ||
+		    is_mt9v024(mt9v022->chip_version)) {
+			/*
+			 * Required settings for snapshot mode: set bit 9
+			 * (RST enable) and bit 2 (CR enable) in reg. 0x20
+			 * See TechNote TN0960 or TN-09-225.
+			 */
+			if (reg_set(client, MT9V022_REG32, 0x204))
+				return -EIO;
+		}
+	}
 
 	if (reg_write(client, MT9V022_CHIP_CONTROL, mt9v022->chip_control) < 0)
 		return -EIO;
@@ -652,6 +675,8 @@ static int mt9v022_video_probe(struct i2c_client *client)
 		goto ei2c;
 	}
 
+	mt9v022->chip_version = data;
+
 	mt9v022->reg = is_mt9v024(data) ? &mt9v024_register :
 			&mt9v022_register;
 
-- 
1.7.1

