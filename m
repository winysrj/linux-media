Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41455 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803AbZCKKJu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Mar 2009 06:09:50 -0400
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 4/4] mt9v022: allow setting of bus width from board code
Date: Wed, 11 Mar 2009 11:06:16 +0100
Message-Id: <1236765976-20581-5-git-send-email-s.hauer@pengutronix.de>
In-Reply-To: <1236765976-20581-4-git-send-email-s.hauer@pengutronix.de>
References: <1236765976-20581-1-git-send-email-s.hauer@pengutronix.de>
 <1236765976-20581-2-git-send-email-s.hauer@pengutronix.de>
 <1236765976-20581-3-git-send-email-s.hauer@pengutronix.de>
 <1236765976-20581-4-git-send-email-s.hauer@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch removes the phytec specific setting of the bus width
and switches to the more generic query_bus_param/set_bus_param
hooks

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 drivers/media/video/Kconfig   |    7 ---
 drivers/media/video/mt9v022.c |   97 +++++------------------------------------
 2 files changed, 11 insertions(+), 93 deletions(-)

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 5fc1531..071d66f 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -747,13 +747,6 @@ config SOC_CAMERA_MT9V022
 	help
 	  This driver supports MT9V022 cameras from Micron
 
-config MT9V022_PCA9536_SWITCH
-	bool "pca9536 datawidth switch for mt9v022"
-	depends on SOC_CAMERA_MT9V022 && GENERIC_GPIO
-	help
-	  Select this if your MT9V022 camera uses a PCA9536 I2C GPIO
-	  extender to switch between 8 and 10 bit datawidth modes
-
 config SOC_CAMERA_TW9910
 	tristate "tw9910 support"
 	depends on SOC_CAMERA && I2C
diff --git a/drivers/media/video/mt9v022.c b/drivers/media/video/mt9v022.c
index b04c8cb..26f97eb 100644
--- a/drivers/media/video/mt9v022.c
+++ b/drivers/media/video/mt9v022.c
@@ -209,66 +209,6 @@ static int mt9v022_stop_capture(struct soc_camera_device *icd)
 	return 0;
 }
 
-static int bus_switch_request(struct mt9v022 *mt9v022, struct soc_camera_link *icl)
-{
-#ifdef CONFIG_MT9V022_PCA9536_SWITCH
-	int ret;
-	unsigned int gpio = icl->gpio;
-
-	if (gpio_is_valid(gpio)) {
-		/* We have a data bus switch. */
-		ret = gpio_request(gpio, "mt9v022");
-		if (ret < 0) {
-			dev_err(&mt9v022->client->dev, "Cannot get GPIO %u\n", gpio);
-			return ret;
-		}
-
-		ret = gpio_direction_output(gpio, 0);
-		if (ret < 0) {
-			dev_err(&mt9v022->client->dev,
-				"Cannot set GPIO %u to output\n", gpio);
-			gpio_free(gpio);
-			return ret;
-		}
-	}
-
-	mt9v022->switch_gpio = gpio;
-#else
-	mt9v022->switch_gpio = -EINVAL;
-#endif
-	return 0;
-}
-
-static void bus_switch_release(struct mt9v022 *mt9v022)
-{
-#ifdef CONFIG_MT9V022_PCA9536_SWITCH
-	if (gpio_is_valid(mt9v022->switch_gpio))
-		gpio_free(mt9v022->switch_gpio);
-#endif
-}
-
-static int bus_switch_act(struct mt9v022 *mt9v022, int go8bit)
-{
-#ifdef CONFIG_MT9V022_PCA9536_SWITCH
-	if (!gpio_is_valid(mt9v022->switch_gpio))
-		return -ENODEV;
-
-	gpio_set_value_cansleep(mt9v022->switch_gpio, go8bit);
-	return 0;
-#else
-	return -ENODEV;
-#endif
-}
-
-static int bus_switch_possible(struct mt9v022 *mt9v022)
-{
-#ifdef CONFIG_MT9V022_PCA9536_SWITCH
-	return gpio_is_valid(mt9v022->switch_gpio);
-#else
-	return 0;
-#endif
-}
-
 static int mt9v022_set_bus_param(struct soc_camera_device *icd,
 				 unsigned long flags)
 {
@@ -282,19 +222,10 @@ static int mt9v022_set_bus_param(struct soc_camera_device *icd,
 	if (!is_power_of_2(width_flag))
 		return -EINVAL;
 
-	if ((mt9v022->datawidth != 10 && (width_flag == SOCAM_DATAWIDTH_10)) ||
-	    (mt9v022->datawidth != 9  && (width_flag == SOCAM_DATAWIDTH_9)) ||
-	    (mt9v022->datawidth != 8  && (width_flag == SOCAM_DATAWIDTH_8))) {
-		/* Well, we actually only can do 10 or 8 bits... */
-		if (width_flag == SOCAM_DATAWIDTH_9)
-			return -EINVAL;
-
-		ret = bus_switch_act(mt9v022,
-				     width_flag == SOCAM_DATAWIDTH_8);
-		if (ret < 0)
+	if (icl->set_bus_param) {
+		ret = icl->set_bus_param(&mt9v022->client->dev, width_flag);
+		if (ret)
 			return ret;
-
-		mt9v022->datawidth = width_flag == SOCAM_DATAWIDTH_8 ? 8 : 10;
 	}
 
 	flags = soc_camera_apply_sensor_flags(icl, flags);
@@ -328,10 +259,14 @@ static int mt9v022_set_bus_param(struct soc_camera_device *icd,
 static unsigned long mt9v022_query_bus_param(struct soc_camera_device *icd)
 {
 	struct mt9v022 *mt9v022 = container_of(icd, struct mt9v022, icd);
-	unsigned int width_flag = SOCAM_DATAWIDTH_10;
+	struct soc_camera_link *icl = mt9v022->client->dev.platform_data;
+	unsigned int width_flag;
 
-	if (bus_switch_possible(mt9v022))
-		width_flag |= SOCAM_DATAWIDTH_8;
+	if (icl->query_bus_param)
+		width_flag = icl->query_bus_param(&mt9v022->client->dev) &
+			SOCAM_DATAWIDTH_MASK;
+	else
+		width_flag = SOCAM_DATAWIDTH_10;
 
 	return SOCAM_PCLK_SAMPLE_RISING | SOCAM_PCLK_SAMPLE_FALLING |
 		SOCAM_HSYNC_ACTIVE_HIGH | SOCAM_HSYNC_ACTIVE_LOW |
@@ -729,6 +664,7 @@ static int mt9v022_video_probe(struct soc_camera_device *icd)
 	/* Set monochrome or colour sensor type */
 	if (sensor_type && (!strcmp("colour", sensor_type) ||
 			    !strcmp("color", sensor_type))) {
+	if (1) {
 		ret = reg_write(icd, MT9V022_PIXEL_OPERATION_MODE, 4 | 0x11);
 		mt9v022->model = V4L2_IDENT_MT9V022IX7ATC;
 		icd->formats = mt9v022_colour_formats;
@@ -812,14 +748,6 @@ static int mt9v022_probe(struct i2c_client *client,
 	icd->height_max	= 480;
 	icd->y_skip_top	= 1;
 	icd->iface	= icl->bus_id;
-	/* Default datawidth - this is the only width this camera (normally)
-	 * supports. It is only with extra logic that it can support
-	 * other widths. Therefore it seems to be a sensible default. */
-	mt9v022->datawidth = 10;
-
-	ret = bus_switch_request(mt9v022, icl);
-	if (ret)
-		goto eswinit;
 
 	ret = soc_camera_device_register(icd);
 	if (ret)
@@ -828,8 +756,6 @@ static int mt9v022_probe(struct i2c_client *client,
 	return 0;
 
 eisdr:
-	bus_switch_release(mt9v022);
-eswinit:
 	kfree(mt9v022);
 	return ret;
 }
@@ -839,7 +765,6 @@ static int mt9v022_remove(struct i2c_client *client)
 	struct mt9v022 *mt9v022 = i2c_get_clientdata(client);
 
 	soc_camera_device_unregister(&mt9v022->icd);
-	bus_switch_release(mt9v022);
 	kfree(mt9v022);
 
 	return 0;
-- 
1.5.6.5

