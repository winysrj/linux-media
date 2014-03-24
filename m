Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:65448 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037AbaCXTdI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Mar 2014 15:33:08 -0400
Received: by mail-ee0-f54.google.com with SMTP id d49so4852470eek.13
        for <linux-media@vger.kernel.org>; Mon, 24 Mar 2014 12:33:07 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 13/19] em28xx: move sensor parameter fields from struct em28xx to struct v4l2
Date: Mon, 24 Mar 2014 20:33:19 +0100
Message-Id: <1395689605-2705-14-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1395689605-2705-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1395689605-2705-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-camera.c | 20 ++++++++++----------
 drivers/media/usb/em28xx/em28xx-video.c  |  6 ++++--
 drivers/media/usb/em28xx/em28xx.h        | 10 ++++++----
 3 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-camera.c b/drivers/media/usb/em28xx/em28xx-camera.c
index 3a88867..12d4c03 100644
--- a/drivers/media/usb/em28xx/em28xx-camera.c
+++ b/drivers/media/usb/em28xx/em28xx-camera.c
@@ -349,8 +349,8 @@ int em28xx_init_camera(struct em28xx *dev)
 			.platform_data = &pdata,
 		};
 
-		dev->sensor_xres = 640;
-		dev->sensor_yres = 480;
+		v4l2->sensor_xres = 640;
+		v4l2->sensor_yres = 480;
 
 		/*
 		 * FIXME: mt9v011 uses I2S speed as xtal clk - at least with
@@ -363,8 +363,8 @@ int em28xx_init_camera(struct em28xx *dev)
 		 */
 		dev->board.xclk = EM28XX_XCLK_FREQUENCY_4_3MHZ;
 		em28xx_write_reg(dev, EM28XX_R0F_XCLK, dev->board.xclk);
-		dev->sensor_xtal = 4300000;
-		pdata.xtal = dev->sensor_xtal;
+		v4l2->sensor_xtal = 4300000;
+		pdata.xtal = v4l2->sensor_xtal;
 		if (NULL ==
 		    v4l2_i2c_new_subdev_board(&dev->v4l2->v4l2_dev, adap,
 					      &mt9v011_info, NULL)) {
@@ -378,8 +378,8 @@ int em28xx_init_camera(struct em28xx *dev)
 		break;
 	}
 	case EM28XX_MT9M001:
-		dev->sensor_xres = 1280;
-		dev->sensor_yres = 1024;
+		v4l2->sensor_xres = 1280;
+		v4l2->sensor_yres = 1024;
 
 		em28xx_initialize_mt9m001(dev);
 
@@ -389,8 +389,8 @@ int em28xx_init_camera(struct em28xx *dev)
 
 		break;
 	case EM28XX_MT9M111:
-		dev->sensor_xres = 640;
-		dev->sensor_yres = 512;
+		v4l2->sensor_xres = 640;
+		v4l2->sensor_yres = 512;
 
 		dev->board.xclk = EM28XX_XCLK_FREQUENCY_48MHZ;
 		em28xx_write_reg(dev, EM28XX_R0F_XCLK, dev->board.xclk);
@@ -419,8 +419,8 @@ int em28xx_init_camera(struct em28xx *dev)
 		 * - adjust bridge xclk
 		 * - disable 16 bit (12 bit) output formats on high resolutions
 		 */
-		dev->sensor_xres = 640;
-		dev->sensor_yres = 480;
+		v4l2->sensor_xres = 640;
+		v4l2->sensor_yres = 480;
 
 		subdev =
 		     v4l2_i2c_new_subdev_board(&dev->v4l2->v4l2_dev, adap,
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index abb4e8e..640c0b0 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -144,8 +144,10 @@ static struct em28xx_fmt format[] = {
 /*FIXME: maxw should be dependent of alt mode */
 static inline unsigned int norm_maxw(struct em28xx *dev)
 {
+	struct em28xx_v4l2 *v4l2 = dev->v4l2;
+
 	if (dev->board.is_webcam)
-		return dev->sensor_xres;
+		return v4l2->sensor_xres;
 
 	if (dev->board.max_range_640_480)
 		return 640;
@@ -158,7 +160,7 @@ static inline unsigned int norm_maxh(struct em28xx *dev)
 	struct em28xx_v4l2 *v4l2 = dev->v4l2;
 
 	if (dev->board.is_webcam)
-		return dev->sensor_yres;
+		return v4l2->sensor_yres;
 
 	if (dev->board.max_range_640_480)
 		return 480;
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index 1491879..f447108 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -518,6 +518,11 @@ struct em28xx_v4l2 {
 	u8 vinmode;
 	u8 vinctl;
 
+	/* Camera specific fields */
+	int sensor_xres;
+	int sensor_yres;
+	int sensor_xtal;
+
 	struct em28xx_fmt *format;
 	v4l2_std_id norm;	/* selected tv norm */
 
@@ -600,10 +605,7 @@ struct em28xx {
 
 	struct em28xx_board board;
 
-	/* Webcam specific fields */
-	enum em28xx_sensor em28xx_sensor;
-	int sensor_xres, sensor_yres;
-	int sensor_xtal;
+	enum em28xx_sensor em28xx_sensor;	/* camera specific */
 
 	/* Controls audio streaming */
 	struct work_struct wq_trigger;	/* Trigger to start/stop audio for alsa module */
-- 
1.8.4.5

