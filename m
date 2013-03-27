Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f180.google.com ([209.85.215.180]:36997 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753514Ab3C0VGl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Mar 2013 17:06:41 -0400
Received: by mail-ea0-f180.google.com with SMTP id d10so1642020eaj.25
        for <linux-media@vger.kernel.org>; Wed, 27 Mar 2013 14:06:40 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 9/9] em28xx: add basic support for OmniVision OV2640 sensors
Date: Wed, 27 Mar 2013 22:06:36 +0100
Message-Id: <1364418396-8191-10-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1364418396-8191-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1364418396-8191-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This sensor is used by the "SpeedLink Vicious And Devine Laplace webcam" and
others. It supports resolutions up to 1600x1200 (at 7-8 fps), but for
resolutions higher than 640x480, further driver changes will be necessary,
such as sensor output resolution switching (including further configuration
changes), bridge xclk adjustment and disabling of 16 bit (12 bit) output formats
at high resolutions. Image quality should also needs to be improved.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-camera.c |   49 ++++++++++++++++++++++++++++++
 drivers/media/usb/em28xx/em28xx.h        |    1 +
 2 Dateien geändert, 50 Zeilen hinzugefügt(+)

diff --git a/drivers/media/usb/em28xx/em28xx-camera.c b/drivers/media/usb/em28xx/em28xx-camera.c
index 64b70d4..73cc50a 100644
--- a/drivers/media/usb/em28xx/em28xx-camera.c
+++ b/drivers/media/usb/em28xx/em28xx-camera.c
@@ -20,6 +20,7 @@
 */
 
 #include <linux/i2c.h>
+#include <media/soc_camera.h>
 #include <media/mt9v011.h>
 #include <media/v4l2-common.h>
 
@@ -42,6 +43,13 @@ static unsigned short omnivision_sensor_addrs[] = {
 };
 
 
+static struct soc_camera_link camlink = {
+	.bus_id = 0,
+	.flags = 0,
+	.module_name = "em28xx",
+};
+
+
 /* FIXME: Should be replaced by a proper mt9m111 driver */
 static int em28xx_initialize_mt9m111(struct em28xx *dev)
 {
@@ -246,6 +254,7 @@ static int em28xx_probe_sensor_omnivision(struct em28xx *dev)
 		switch (id) {
 		case 0x2642:
 			name = "OV2640";
+			dev->em28xx_sensor = EM28XX_OV2640;
 			break;
 		case 0x7648:
 			name = "OV7648";
@@ -376,6 +385,46 @@ int em28xx_init_camera(struct em28xx *dev)
 		dev->vinctl = 0x00;
 
 		break;
+	case EM28XX_OV2640:
+	{
+		struct v4l2_subdev *subdev;
+		struct i2c_board_info ov2640_info = {
+			.type = "ov2640",
+			.flags = I2C_CLIENT_SCCB,
+			.addr = dev->i2c_client[dev->def_i2c_bus].addr,
+			.platform_data = &camlink,
+		};
+		struct v4l2_mbus_framefmt fmt;
+
+		/*
+		 * FIXME: sensor supports resolutions up to 1600x1200, but
+		 * resolution setting/switching needs to be modified to
+		 * - switch sensor output resolution (including further
+		 *   configuration changes)
+		 * - adjust bridge xclk
+		 * - disable 16 bit (12 bit) output formats on high resolutions
+		 */
+		dev->sensor_xres = 640;
+		dev->sensor_yres = 480;
+
+		subdev =
+		     v4l2_i2c_new_subdev_board(&dev->v4l2_dev,
+					       &dev->i2c_adap[dev->def_i2c_bus],
+					       &ov2640_info, NULL);
+
+		fmt.code = V4L2_MBUS_FMT_YUYV8_2X8;
+		fmt.width = 640;
+		fmt.height = 480;
+		v4l2_subdev_call(subdev, video, s_mbus_fmt, &fmt);
+
+		/* NOTE: for UXGA=1600x1200 switch to 12MHz */
+		dev->board.xclk = EM28XX_XCLK_FREQUENCY_24MHZ;
+		em28xx_write_reg(dev, EM28XX_R0F_XCLK, dev->board.xclk);
+		dev->vinmode = 0x08;
+		dev->vinctl = 0x00;
+
+		break;
+	}
 	case EM28XX_NOSENSOR:
 	default:
 		return -EINVAL;
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index a14492f..a9323b6 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -364,6 +364,7 @@ enum em28xx_sensor {
 	EM28XX_MT9V011,
 	EM28XX_MT9M001,
 	EM28XX_MT9M111,
+	EM28XX_OV2640,
 };
 
 enum em28xx_adecoder {
-- 
1.7.10.4

