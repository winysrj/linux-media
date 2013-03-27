Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:57025 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563Ab3C0VG3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Mar 2013 17:06:29 -0400
Received: by mail-ee0-f52.google.com with SMTP id d17so1008534eek.11
        for <linux-media@vger.kernel.org>; Wed, 27 Mar 2013 14:06:28 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 2/9] em28xx: separate sensor detection and initialization/configuration
Date: Wed, 27 Mar 2013 22:06:29 +0100
Message-Id: <1364418396-8191-3-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1364418396-8191-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1364418396-8191-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sensor detection and initialization/configuration are currently mixed together.
This works as long as all devices with a particular sensor are working with the
same board configuration. In the long run, this will be not sufficient, so
separate these both steps to make the code more flexible and future proof.
This also makes the code more consistent, because the initialization of the
MT9V011 sensor subdevice is already separated.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c |  122 ++++++++++++++++++-------------
 1 Datei geändert, 72 Zeilen hinzugefügt(+), 50 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index e41ecb5..c8ad7e5 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -2335,50 +2335,14 @@ static int em28xx_hint_sensor(struct em28xx *dev)
 	case 0x8243:		/* mt9v011 rev B 640x480 1.3 Mpix sensor */
 		sensor_name = "mt9v011";
 		dev->em28xx_sensor = EM28XX_MT9V011;
-		dev->sensor_xres = 640;
-		dev->sensor_yres = 480;
-		/*
-		 * FIXME: mt9v011 uses I2S speed as xtal clk - at least with
-		 * the Silvercrest cam I have here for testing - for higher
-		 * resolutions, a high clock cause horizontal artifacts, so we
-		 * need to use a lower xclk frequency.
-		 * Yet, it would be possible to adjust xclk depending on the
-		 * desired resolution, since this affects directly the
-		 * frame rate.
-		 */
-		dev->board.xclk = EM28XX_XCLK_FREQUENCY_4_3MHZ;
-		dev->sensor_xtal = 4300000;
-
-		/* probably means GRGB 16 bit bayer */
-		dev->vinmode = 0x0d;
-		dev->vinctl = 0x00;
-
 		break;
-
 	case 0x143a:    /* MT9M111 as found in the ECS G200 */
 		sensor_name = "mt9m111";
-		dev->board.xclk = EM28XX_XCLK_FREQUENCY_48MHZ;
 		dev->em28xx_sensor = EM28XX_MT9M111;
-		em28xx_initialize_mt9m111(dev);
-		dev->sensor_xres = 640;
-		dev->sensor_yres = 512;
-
-		dev->vinmode = 0x0a;
-		dev->vinctl = 0x00;
-
 		break;
-
 	case 0x8431:
 		sensor_name = "mt9m001";
 		dev->em28xx_sensor = EM28XX_MT9M001;
-		em28xx_initialize_mt9m001(dev);
-		dev->sensor_xres = 1280;
-		dev->sensor_yres = 1024;
-
-		/* probably means BGGR 16 bit bayer */
-		dev->vinmode = 0x0c;
-		dev->vinctl = 0x00;
-
 		break;
 	default:
 		printk("Unknown Micron Sensor 0x%04x\n", version);
@@ -2611,6 +2575,76 @@ static void em28xx_tuner_setup(struct em28xx *dev)
 	v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_frequency, &f);
 }
 
+static int em28xx_init_camera(struct em28xx *dev)
+{
+	switch (dev->em28xx_sensor) {
+	case EM28XX_MT9V011:
+	{
+		struct mt9v011_platform_data pdata;
+		struct i2c_board_info mt9v011_info = {
+			.type = "mt9v011",
+			.addr = dev->i2c_client[dev->def_i2c_bus].addr,
+			.platform_data = &pdata,
+		};
+
+		dev->sensor_xres = 640;
+		dev->sensor_yres = 480;
+
+		/*
+		 * FIXME: mt9v011 uses I2S speed as xtal clk - at least with
+		 * the Silvercrest cam I have here for testing - for higher
+		 * resolutions, a high clock cause horizontal artifacts, so we
+		 * need to use a lower xclk frequency.
+		 * Yet, it would be possible to adjust xclk depending on the
+		 * desired resolution, since this affects directly the
+		 * frame rate.
+		 */
+		dev->board.xclk = EM28XX_XCLK_FREQUENCY_4_3MHZ;
+		em28xx_write_reg(dev, EM28XX_R0F_XCLK, dev->board.xclk);
+		dev->sensor_xtal = 4300000;
+		pdata.xtal = dev->sensor_xtal;
+		if (NULL ==
+		    v4l2_i2c_new_subdev_board(&dev->v4l2_dev,
+					      &dev->i2c_adap[dev->def_i2c_bus],
+					      &mt9v011_info, NULL))
+			return -ENODEV;
+		/* probably means GRGB 16 bit bayer */
+		dev->vinmode = 0x0d;
+		dev->vinctl = 0x00;
+
+		break;
+	}
+	case EM28XX_MT9M001:
+		dev->sensor_xres = 1280;
+		dev->sensor_yres = 1024;
+
+		em28xx_initialize_mt9m001(dev);
+
+		/* probably means BGGR 16 bit bayer */
+		dev->vinmode = 0x0c;
+		dev->vinctl = 0x00;
+
+		break;
+	case EM28XX_MT9M111:
+		dev->sensor_xres = 640;
+		dev->sensor_yres = 512;
+
+		dev->board.xclk = EM28XX_XCLK_FREQUENCY_48MHZ;
+		em28xx_write_reg(dev, EM28XX_R0F_XCLK, dev->board.xclk);
+		em28xx_initialize_mt9m111(dev);
+
+		dev->vinmode = 0x0a;
+		dev->vinctl = 0x00;
+
+		break;
+	case EM28XX_NOSENSOR:
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int em28xx_hint_board(struct em28xx *dev)
 {
 	int i;
@@ -2878,20 +2912,6 @@ static void em28xx_card_setup(struct em28xx *dev)
 		v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap[dev->def_i2c_bus],
 			"tvp5150", 0, tvp5150_addrs);
 
-	if (dev->em28xx_sensor == EM28XX_MT9V011) {
-		struct mt9v011_platform_data pdata;
-		struct i2c_board_info mt9v011_info = {
-			.type = "mt9v011",
-			.addr = 0xba >> 1,
-			.platform_data = &pdata,
-		};
-
-		pdata.xtal = dev->sensor_xtal;
-		v4l2_i2c_new_subdev_board(&dev->v4l2_dev, &dev->i2c_adap[dev->def_i2c_bus],
-				&mt9v011_info, NULL);
-	}
-
-
 	if (dev->board.adecoder == EM28XX_TVAUDIO)
 		v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap[dev->def_i2c_bus],
 			"tvaudio", dev->board.tvaudio_addr, NULL);
@@ -2925,6 +2945,8 @@ static void em28xx_card_setup(struct em28xx *dev)
 	}
 
 	em28xx_tuner_setup(dev);
+
+	em28xx_init_camera(dev);
 }
 
 
-- 
1.7.10.4

