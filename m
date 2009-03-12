Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49127 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbZCLLaf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Mar 2009 07:30:35 -0400
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 3/5] mt9m001: allow setting of bus width from board code
Date: Thu, 12 Mar 2009 12:27:17 +0100
Message-Id: <1236857239-2146-4-git-send-email-s.hauer@pengutronix.de>
In-Reply-To: <1236857239-2146-3-git-send-email-s.hauer@pengutronix.de>
References: <1236857239-2146-1-git-send-email-s.hauer@pengutronix.de>
 <1236857239-2146-2-git-send-email-s.hauer@pengutronix.de>
 <1236857239-2146-3-git-send-email-s.hauer@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch removes the phytec specific setting of the bus width
and switches to the more generic query_bus_param/set_bus_param
hooks

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 drivers/media/video/Kconfig   |    7 --
 drivers/media/video/mt9m001.c |  143 +++++++++++-----------------------------
 2 files changed, 40 insertions(+), 110 deletions(-)

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 19cf3b8..5fc1531 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -728,13 +728,6 @@ config SOC_CAMERA_MT9M001
 	  This driver supports MT9M001 cameras from Micron, monochrome
 	  and colour models.
 
-config MT9M001_PCA9536_SWITCH
-	bool "pca9536 datawidth switch for mt9m001"
-	depends on SOC_CAMERA_MT9M001 && GENERIC_GPIO
-	help
-	  Select this if your MT9M001 camera uses a PCA9536 I2C GPIO
-	  extender to switch between 8 and 10 bit datawidth modes
-
 config SOC_CAMERA_MT9M111
 	tristate "mt9m111 and mt9m112 support"
 	depends on SOC_CAMERA && I2C
diff --git a/drivers/media/video/mt9m001.c b/drivers/media/video/mt9m001.c
index c1bf75e..d3bc84c 100644
--- a/drivers/media/video/mt9m001.c
+++ b/drivers/media/video/mt9m001.c
@@ -12,7 +12,6 @@
 #include <linux/slab.h>
 #include <linux/i2c.h>
 #include <linux/log2.h>
-#include <linux/gpio.h>
 
 #include <media/v4l2-common.h>
 #include <media/v4l2-chip-ident.h>
@@ -73,9 +72,7 @@ struct mt9m001 {
 	struct i2c_client *client;
 	struct soc_camera_device icd;
 	int model;	/* V4L2_IDENT_MT9M001* codes from v4l2-chip-ident.h */
-	int switch_gpio;
 	unsigned char autoexposure;
-	unsigned char datawidth;
 };
 
 static int reg_read(struct soc_camera_device *icd, const u8 reg)
@@ -181,92 +178,28 @@ static int mt9m001_stop_capture(struct soc_camera_device *icd)
 	return 0;
 }
 
-static int bus_switch_request(struct mt9m001 *mt9m001,
-			      struct soc_camera_link *icl)
-{
-#ifdef CONFIG_MT9M001_PCA9536_SWITCH
-	int ret;
-	unsigned int gpio = icl->gpio;
-
-	if (gpio_is_valid(gpio)) {
-		/* We have a data bus switch. */
-		ret = gpio_request(gpio, "mt9m001");
-		if (ret < 0) {
-			dev_err(&mt9m001->client->dev, "Cannot get GPIO %u\n",
-				gpio);
-			return ret;
-		}
-
-		ret = gpio_direction_output(gpio, 0);
-		if (ret < 0) {
-			dev_err(&mt9m001->client->dev,
-				"Cannot set GPIO %u to output\n", gpio);
-			gpio_free(gpio);
-			return ret;
-		}
-	}
-
-	mt9m001->switch_gpio = gpio;
-#else
-	mt9m001->switch_gpio = -EINVAL;
-#endif
-	return 0;
-}
-
-static void bus_switch_release(struct mt9m001 *mt9m001)
-{
-#ifdef CONFIG_MT9M001_PCA9536_SWITCH
-	if (gpio_is_valid(mt9m001->switch_gpio))
-		gpio_free(mt9m001->switch_gpio);
-#endif
-}
-
-static int bus_switch_act(struct mt9m001 *mt9m001, int go8bit)
-{
-#ifdef CONFIG_MT9M001_PCA9536_SWITCH
-	if (!gpio_is_valid(mt9m001->switch_gpio))
-		return -ENODEV;
-
-	gpio_set_value_cansleep(mt9m001->switch_gpio, go8bit);
-	return 0;
-#else
-	return -ENODEV;
-#endif
-}
-
-static int bus_switch_possible(struct mt9m001 *mt9m001)
-{
-#ifdef CONFIG_MT9M001_PCA9536_SWITCH
-	return gpio_is_valid(mt9m001->switch_gpio);
-#else
-	return 0;
-#endif
-}
-
 static int mt9m001_set_bus_param(struct soc_camera_device *icd,
 				 unsigned long flags)
 {
 	struct mt9m001 *mt9m001 = container_of(icd, struct mt9m001, icd);
-	unsigned int width_flag = flags & SOCAM_DATAWIDTH_MASK;
-	int ret;
+	struct soc_camera_link *icl = mt9m001->client->dev.platform_data;
+	unsigned long width_flag = flags & SOCAM_DATAWIDTH_MASK;
 
-	/* Flags validity verified in test_bus_param */
+	/* Only one width bit may be set */
+	if (!is_power_of_2(width_flag))
+		return -EINVAL;
 
-	if ((mt9m001->datawidth != 10 && (width_flag == SOCAM_DATAWIDTH_10)) ||
-	    (mt9m001->datawidth != 9  && (width_flag == SOCAM_DATAWIDTH_9)) ||
-	    (mt9m001->datawidth != 8  && (width_flag == SOCAM_DATAWIDTH_8))) {
-		/* Well, we actually only can do 10 or 8 bits... */
-		if (width_flag == SOCAM_DATAWIDTH_9)
-			return -EINVAL;
-		ret = bus_switch_act(mt9m001,
-				     width_flag == SOCAM_DATAWIDTH_8);
-		if (ret < 0)
-			return ret;
+	if (icl->set_bus_param)
+		return icl->set_bus_param(icl, width_flag);
 
-		mt9m001->datawidth = width_flag == SOCAM_DATAWIDTH_8 ? 8 : 10;
-	}
+	/*
+	 * Without board specific bus width settings we only support the
+	 * sensors native bus width
+	 */
+	if (width_flag == SOCAM_DATAWIDTH_10)
+		return 0;
 
-	return 0;
+	return -EINVAL;
 }
 
 static unsigned long mt9m001_query_bus_param(struct soc_camera_device *icd)
@@ -274,12 +207,14 @@ static unsigned long mt9m001_query_bus_param(struct soc_camera_device *icd)
 	struct mt9m001 *mt9m001 = container_of(icd, struct mt9m001, icd);
 	struct soc_camera_link *icl = mt9m001->client->dev.platform_data;
 	/* MT9M001 has all capture_format parameters fixed */
-	unsigned long flags = SOCAM_DATAWIDTH_10 | SOCAM_PCLK_SAMPLE_RISING |
+	unsigned long flags = SOCAM_PCLK_SAMPLE_RISING |
 		SOCAM_HSYNC_ACTIVE_HIGH | SOCAM_VSYNC_ACTIVE_HIGH |
 		SOCAM_MASTER;
 
-	if (bus_switch_possible(mt9m001))
-		flags |= SOCAM_DATAWIDTH_8;
+	if (icl->query_bus_param)
+		flags |= icl->query_bus_param(icl) & SOCAM_DATAWIDTH_MASK;
+	else
+		flags |= SOCAM_DATAWIDTH_10;
 
 	return soc_camera_apply_sensor_flags(icl, flags);
 }
@@ -583,6 +518,7 @@ static int mt9m001_video_probe(struct soc_camera_device *icd)
 	struct soc_camera_link *icl = mt9m001->client->dev.platform_data;
 	s32 data;
 	int ret;
+	unsigned long flags;
 
 	/* We must have a parent by now. And it cannot be a wrong one.
 	 * So this entire test is completely redundant. */
@@ -603,18 +539,10 @@ static int mt9m001_video_probe(struct soc_camera_device *icd)
 	case 0x8421:
 		mt9m001->model = V4L2_IDENT_MT9M001C12ST;
 		icd->formats = mt9m001_colour_formats;
-		if (gpio_is_valid(icl->gpio))
-			icd->num_formats = ARRAY_SIZE(mt9m001_colour_formats);
-		else
-			icd->num_formats = 1;
 		break;
 	case 0x8431:
 		mt9m001->model = V4L2_IDENT_MT9M001C12STM;
 		icd->formats = mt9m001_monochrome_formats;
-		if (gpio_is_valid(icl->gpio))
-			icd->num_formats = ARRAY_SIZE(mt9m001_monochrome_formats);
-		else
-			icd->num_formats = 1;
 		break;
 	default:
 		ret = -ENODEV;
@@ -623,6 +551,26 @@ static int mt9m001_video_probe(struct soc_camera_device *icd)
 		goto ei2c;
 	}
 
+	icd->num_formats = 0;
+
+	/*
+	 * This is a 10bit sensor, so by default we only allow 10bit.
+	 * The platform may support different bus widths due to
+	 * different routing of the data lines.
+	 */
+	if (icl->query_bus_param)
+		flags = icl->query_bus_param(icl);
+	else
+		flags = SOCAM_DATAWIDTH_10;
+
+	if (flags & SOCAM_DATAWIDTH_10)
+		icd->num_formats++;
+	else
+		icd->formats++;
+
+	if (flags & SOCAM_DATAWIDTH_8)
+		icd->num_formats++;
+
 	dev_info(&icd->dev, "Detected a MT9M001 chip ID %x (%s)\n", data,
 		 data == 0x8431 ? "C12STM" : "C12ST");
 
@@ -688,18 +636,10 @@ static int mt9m001_probe(struct i2c_client *client,
 	icd->height_max	= 1024;
 	icd->y_skip_top	= 1;
 	icd->iface	= icl->bus_id;
-	/* Default datawidth - this is the only width this camera (normally)
-	 * supports. It is only with extra logic that it can support
-	 * other widths. Therefore it seems to be a sensible default. */
-	mt9m001->datawidth = 10;
 	/* Simulated autoexposure. If enabled, we calculate shutter width
 	 * ourselves in the driver based on vertical blanking and frame width */
 	mt9m001->autoexposure = 1;
 
-	ret = bus_switch_request(mt9m001, icl);
-	if (ret)
-		goto eswinit;
-
 	ret = soc_camera_device_register(icd);
 	if (ret)
 		goto eisdr;
@@ -707,8 +647,6 @@ static int mt9m001_probe(struct i2c_client *client,
 	return 0;
 
 eisdr:
-	bus_switch_release(mt9m001);
-eswinit:
 	kfree(mt9m001);
 	return ret;
 }
@@ -718,7 +656,6 @@ static int mt9m001_remove(struct i2c_client *client)
 	struct mt9m001 *mt9m001 = i2c_get_clientdata(client);
 
 	soc_camera_device_unregister(&mt9m001->icd);
-	bus_switch_release(mt9m001);
 	kfree(mt9m001);
 
 	return 0;
-- 
1.5.6.5

