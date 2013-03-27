Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:57154 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465Ab3C0VGb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Mar 2013 17:06:31 -0400
Received: by mail-ea0-f174.google.com with SMTP id m14so1470273eaj.19
        for <linux-media@vger.kernel.org>; Wed, 27 Mar 2013 14:06:30 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 4/9] em28xx: move sensor code to a separate source code file em28xx-camera.c
Date: Wed, 27 Mar 2013 22:06:31 +0100
Message-Id: <1364418396-8191-5-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1364418396-8191-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1364418396-8191-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

em28xx-cards.c is very large and the sensor/camera related code is growing,
so move this code to a separate source code file em28xx-camera.c.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/Makefile        |    2 +-
 drivers/media/usb/em28xx/em28xx-camera.c |  189 ++++++++++++++++++++++++++++++
 drivers/media/usb/em28xx/em28xx-cards.c  |  160 -------------------------
 drivers/media/usb/em28xx/em28xx.h        |    4 +
 4 Dateien geändert, 194 Zeilen hinzugefügt(+), 161 Zeilen entfernt(-)
 create mode 100644 drivers/media/usb/em28xx/em28xx-camera.c

diff --git a/drivers/media/usb/em28xx/Makefile b/drivers/media/usb/em28xx/Makefile
index 634fb92..ad6d485 100644
--- a/drivers/media/usb/em28xx/Makefile
+++ b/drivers/media/usb/em28xx/Makefile
@@ -1,5 +1,5 @@
 em28xx-y +=	em28xx-video.o em28xx-i2c.o em28xx-cards.o
-em28xx-y +=	em28xx-core.o  em28xx-vbi.o
+em28xx-y +=	em28xx-core.o  em28xx-vbi.o em28xx-camera.o
 
 em28xx-alsa-objs := em28xx-audio.o
 em28xx-rc-objs := em28xx-input.o
diff --git a/drivers/media/usb/em28xx/em28xx-camera.c b/drivers/media/usb/em28xx/em28xx-camera.c
new file mode 100644
index 0000000..28dd848
--- /dev/null
+++ b/drivers/media/usb/em28xx/em28xx-camera.c
@@ -0,0 +1,189 @@
+/*
+   em28xx-camera.c - driver for Empia EM25xx/27xx/28xx USB video capture devices
+
+   Copyright (C) 2009 Mauro Carvalho Chehab <mchehab@infradead.org>
+   Copyright (C) 2013 Frank Schäfer <fschaefer.oss@googlemail.com>
+
+   This program is free software; you can redistribute it and/or modify
+   it under the terms of the GNU General Public License as published by
+   the Free Software Foundation; either version 2 of the License, or
+   (at your option) any later version.
+
+   This program is distributed in the hope that it will be useful,
+   but WITHOUT ANY WARRANTY; without even the implied warranty of
+   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+   GNU General Public License for more details.
+
+   You should have received a copy of the GNU General Public License
+   along with this program; if not, write to the Free Software
+   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+*/
+
+#include <linux/i2c.h>
+#include <media/mt9v011.h>
+#include <media/v4l2-common.h>
+
+#include "em28xx.h"
+
+
+/* FIXME: Should be replaced by a proper mt9m111 driver */
+static int em28xx_initialize_mt9m111(struct em28xx *dev)
+{
+	int i;
+	unsigned char regs[][3] = {
+		{ 0x0d, 0x00, 0x01, },  /* reset and use defaults */
+		{ 0x0d, 0x00, 0x00, },
+		{ 0x0a, 0x00, 0x21, },
+		{ 0x21, 0x04, 0x00, },  /* full readout speed, no row/col skipping */
+	};
+
+	for (i = 0; i < ARRAY_SIZE(regs); i++)
+		i2c_master_send(&dev->i2c_client[dev->def_i2c_bus],
+				&regs[i][0], 3);
+
+	return 0;
+}
+
+
+/* FIXME: Should be replaced by a proper mt9m001 driver */
+static int em28xx_initialize_mt9m001(struct em28xx *dev)
+{
+	int i;
+	unsigned char regs[][3] = {
+		{ 0x0d, 0x00, 0x01, },
+		{ 0x0d, 0x00, 0x00, },
+		{ 0x04, 0x05, 0x00, },	/* hres = 1280 */
+		{ 0x03, 0x04, 0x00, },  /* vres = 1024 */
+		{ 0x20, 0x11, 0x00, },
+		{ 0x06, 0x00, 0x10, },
+		{ 0x2b, 0x00, 0x24, },
+		{ 0x2e, 0x00, 0x24, },
+		{ 0x35, 0x00, 0x24, },
+		{ 0x2d, 0x00, 0x20, },
+		{ 0x2c, 0x00, 0x20, },
+		{ 0x09, 0x0a, 0xd4, },
+		{ 0x35, 0x00, 0x57, },
+	};
+
+	for (i = 0; i < ARRAY_SIZE(regs); i++)
+		i2c_master_send(&dev->i2c_client[dev->def_i2c_bus],
+				&regs[i][0], 3);
+
+	return 0;
+}
+
+
+/*
+ * This method works for webcams with Micron sensors
+ */
+int em28xx_detect_sensor(struct em28xx *dev)
+{
+	int ret;
+	char *name;
+	u8 reg;
+	__be16 id_be;
+	u16 id;
+
+	/* Micron sensor detection */
+	dev->i2c_client[dev->def_i2c_bus].addr = 0xba >> 1;
+	reg = 0;
+	i2c_master_send(&dev->i2c_client[dev->def_i2c_bus], &reg, 1);
+	ret = i2c_master_recv(&dev->i2c_client[dev->def_i2c_bus],
+			      (char *)&id_be, 2);
+	if (ret != 2)
+		return -EINVAL;
+
+	id = be16_to_cpu(id_be);
+	switch (id) {
+	case 0x8232:		/* mt9v011 640x480 1.3 Mpix sensor */
+	case 0x8243:		/* mt9v011 rev B 640x480 1.3 Mpix sensor */
+		name = "mt9v011";
+		dev->em28xx_sensor = EM28XX_MT9V011;
+		break;
+	case 0x143a:    /* MT9M111 as found in the ECS G200 */
+		name = "mt9m111";
+		dev->em28xx_sensor = EM28XX_MT9M111;
+		break;
+	case 0x8431:
+		name = "mt9m001";
+		dev->em28xx_sensor = EM28XX_MT9M001;
+		break;
+	default:
+		em28xx_info("unknown Micron sensor detected: 0x%04x\n", id);
+		return -EINVAL;
+	}
+
+	em28xx_info("sensor %s detected\n", name);
+
+	return 0;
+}
+
+int em28xx_init_camera(struct em28xx *dev)
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
diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 7bb760e..ad20790 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -34,7 +34,6 @@
 #include <media/saa7115.h>
 #include <media/tvp5150.h>
 #include <media/tvaudio.h>
-#include <media/mt9v011.h>
 #include <media/i2c-addr.h>
 #include <media/tveeprom.h>
 #include <media/v4l2-common.h>
@@ -2264,95 +2263,6 @@ static inline void em28xx_set_model(struct em28xx *dev)
 	dev->def_i2c_bus = dev->board.def_i2c_bus;
 }
 
-
-/* FIXME: Should be replaced by a proper mt9m111 driver */
-static int em28xx_initialize_mt9m111(struct em28xx *dev)
-{
-	int i;
-	unsigned char regs[][3] = {
-		{ 0x0d, 0x00, 0x01, },  /* reset and use defaults */
-		{ 0x0d, 0x00, 0x00, },
-		{ 0x0a, 0x00, 0x21, },
-		{ 0x21, 0x04, 0x00, },  /* full readout speed, no row/col skipping */
-	};
-
-	for (i = 0; i < ARRAY_SIZE(regs); i++)
-		i2c_master_send(&dev->i2c_client[dev->def_i2c_bus], &regs[i][0], 3);
-
-	return 0;
-}
-
-
-/* FIXME: Should be replaced by a proper mt9m001 driver */
-static int em28xx_initialize_mt9m001(struct em28xx *dev)
-{
-	int i;
-	unsigned char regs[][3] = {
-		{ 0x0d, 0x00, 0x01, },
-		{ 0x0d, 0x00, 0x00, },
-		{ 0x04, 0x05, 0x00, },	/* hres = 1280 */
-		{ 0x03, 0x04, 0x00, },  /* vres = 1024 */
-		{ 0x20, 0x11, 0x00, },
-		{ 0x06, 0x00, 0x10, },
-		{ 0x2b, 0x00, 0x24, },
-		{ 0x2e, 0x00, 0x24, },
-		{ 0x35, 0x00, 0x24, },
-		{ 0x2d, 0x00, 0x20, },
-		{ 0x2c, 0x00, 0x20, },
-		{ 0x09, 0x0a, 0xd4, },
-		{ 0x35, 0x00, 0x57, },
-	};
-
-	for (i = 0; i < ARRAY_SIZE(regs); i++)
-		i2c_master_send(&dev->i2c_client[dev->def_i2c_bus], &regs[i][0], 3);
-
-	return 0;
-}
-
-/*
- * This method works for webcams with Micron sensors
- */
-static int em28xx_detect_sensor(struct em28xx *dev)
-{
-	int rc;
-	char *sensor_name;
-	unsigned char cmd;
-	__be16 version_be;
-	u16 version;
-
-	/* Micron sensor detection */
-	dev->i2c_client[dev->def_i2c_bus].addr = 0xba >> 1;
-	cmd = 0;
-	i2c_master_send(&dev->i2c_client[dev->def_i2c_bus], &cmd, 1);
-	rc = i2c_master_recv(&dev->i2c_client[dev->def_i2c_bus], (char *)&version_be, 2);
-	if (rc != 2)
-		return -EINVAL;
-
-	version = be16_to_cpu(version_be);
-	switch (version) {
-	case 0x8232:		/* mt9v011 640x480 1.3 Mpix sensor */
-	case 0x8243:		/* mt9v011 rev B 640x480 1.3 Mpix sensor */
-		sensor_name = "mt9v011";
-		dev->em28xx_sensor = EM28XX_MT9V011;
-		break;
-	case 0x143a:    /* MT9M111 as found in the ECS G200 */
-		sensor_name = "mt9m111";
-		dev->em28xx_sensor = EM28XX_MT9M111;
-		break;
-	case 0x8431:
-		sensor_name = "mt9m001";
-		dev->em28xx_sensor = EM28XX_MT9M001;
-		break;
-	default:
-		printk("Unknown Micron Sensor 0x%04x\n", version);
-		return -EINVAL;
-	}
-
-	em28xx_info("sensor %s detected\n", sensor_name);
-
-	return 0;
-}
-
 /* Since em28xx_pre_card_setup() requires a proper dev->model,
  * this won't work for boards with generic PCI IDs
  */
@@ -2574,76 +2484,6 @@ static void em28xx_tuner_setup(struct em28xx *dev)
 	v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_frequency, &f);
 }
 
-static int em28xx_init_camera(struct em28xx *dev)
-{
-	switch (dev->em28xx_sensor) {
-	case EM28XX_MT9V011:
-	{
-		struct mt9v011_platform_data pdata;
-		struct i2c_board_info mt9v011_info = {
-			.type = "mt9v011",
-			.addr = dev->i2c_client[dev->def_i2c_bus].addr,
-			.platform_data = &pdata,
-		};
-
-		dev->sensor_xres = 640;
-		dev->sensor_yres = 480;
-
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
-		em28xx_write_reg(dev, EM28XX_R0F_XCLK, dev->board.xclk);
-		dev->sensor_xtal = 4300000;
-		pdata.xtal = dev->sensor_xtal;
-		if (NULL ==
-		    v4l2_i2c_new_subdev_board(&dev->v4l2_dev,
-					      &dev->i2c_adap[dev->def_i2c_bus],
-					      &mt9v011_info, NULL))
-			return -ENODEV;
-		/* probably means GRGB 16 bit bayer */
-		dev->vinmode = 0x0d;
-		dev->vinctl = 0x00;
-
-		break;
-	}
-	case EM28XX_MT9M001:
-		dev->sensor_xres = 1280;
-		dev->sensor_yres = 1024;
-
-		em28xx_initialize_mt9m001(dev);
-
-		/* probably means BGGR 16 bit bayer */
-		dev->vinmode = 0x0c;
-		dev->vinctl = 0x00;
-
-		break;
-	case EM28XX_MT9M111:
-		dev->sensor_xres = 640;
-		dev->sensor_yres = 512;
-
-		dev->board.xclk = EM28XX_XCLK_FREQUENCY_48MHZ;
-		em28xx_write_reg(dev, EM28XX_R0F_XCLK, dev->board.xclk);
-		em28xx_initialize_mt9m111(dev);
-
-		dev->vinmode = 0x0a;
-		dev->vinctl = 0x00;
-
-		break;
-	case EM28XX_NOSENSOR:
-	default:
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
 static int em28xx_hint_board(struct em28xx *dev)
 {
 	int i;
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index 7be008f..a14492f 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -722,6 +722,10 @@ void em28xx_release_resources(struct em28xx *dev);
 /* Provided by em28xx-vbi.c */
 extern struct vb2_ops em28xx_vbi_qops;
 
+/* Provided by em28xx-camera.c */
+int em28xx_detect_sensor(struct em28xx *dev);
+int em28xx_init_camera(struct em28xx *dev);
+
 /* printk macros */
 
 #define em28xx_err(fmt, arg...) do {\
-- 
1.7.10.4

