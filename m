Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:5093 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752141AbdI0SZd (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Sep 2017 14:25:33 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 07/13] staging: atomisp: Remove ->gpio_ctrl() callback
Date: Wed, 27 Sep 2017 21:25:02 +0300
Message-Id: <20170927182508.52119-8-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20170927182508.52119-1-andriy.shevchenko@linux.intel.com>
References: <20170927182508.52119-1-andriy.shevchenko@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is redundant callback which does nothing in upstreamed version of
the driver.

Remove it along with user call places.

Mostly done with help of coccinelle.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/staging/media/atomisp/i2c/gc0310.c                     | 4 ----
 drivers/staging/media/atomisp/i2c/gc2235.c                     | 4 ----
 drivers/staging/media/atomisp/i2c/mt9m114.c                    | 4 ----
 drivers/staging/media/atomisp/i2c/ov2680.c                     | 4 ----
 drivers/staging/media/atomisp/i2c/ov2722.c                     | 4 ----
 drivers/staging/media/atomisp/i2c/ov5693/ov5693.c              | 4 ----
 drivers/staging/media/atomisp/i2c/ov8858.c                     | 4 ----
 drivers/staging/media/atomisp/include/linux/atomisp_platform.h | 2 --
 8 files changed, 30 deletions(-)

diff --git a/drivers/staging/media/atomisp/i2c/gc0310.c b/drivers/staging/media/atomisp/i2c/gc0310.c
index 0e6fcf44b656..672a28c060f6 100644
--- a/drivers/staging/media/atomisp/i2c/gc0310.c
+++ b/drivers/staging/media/atomisp/i2c/gc0310.c
@@ -771,10 +771,6 @@ static int gpio_ctrl(struct v4l2_subdev *sd, bool flag)
 	if (!dev || !dev->platform_data)
 		return -ENODEV;
 
-	/* Non-gmin platforms use the legacy callback */
-	if (dev->platform_data->gpio_ctrl)
-		return dev->platform_data->gpio_ctrl(sd, flag);
-
 	/* GPIO0 == "reset" (active low), GPIO1 == "power down" */
 	if (flag) {
 		/* Pulse reset, then release power down */
diff --git a/drivers/staging/media/atomisp/i2c/gc2235.c b/drivers/staging/media/atomisp/i2c/gc2235.c
index 94b93ccc6aeb..81b23b55f73a 100644
--- a/drivers/staging/media/atomisp/i2c/gc2235.c
+++ b/drivers/staging/media/atomisp/i2c/gc2235.c
@@ -571,10 +571,6 @@ static int gpio_ctrl(struct v4l2_subdev *sd, bool flag)
 	if (!dev || !dev->platform_data)
 		return -ENODEV;
 
-	/* Non-gmin platforms use the legacy callback */
-	if (dev->platform_data->gpio_ctrl)
-		return dev->platform_data->gpio_ctrl(sd, flag);
-
 	ret |= dev->platform_data->gpio1_ctrl(sd, !flag);
 	usleep_range(60, 90);
 	return dev->platform_data->gpio0_ctrl(sd, flag);
diff --git a/drivers/staging/media/atomisp/i2c/mt9m114.c b/drivers/staging/media/atomisp/i2c/mt9m114.c
index 4ac1ad045283..4968deae2525 100644
--- a/drivers/staging/media/atomisp/i2c/mt9m114.c
+++ b/drivers/staging/media/atomisp/i2c/mt9m114.c
@@ -480,10 +480,6 @@ static int gpio_ctrl(struct v4l2_subdev *sd, bool flag)
 	if (!dev || !dev->platform_data)
 		return -ENODEV;
 
-	/* Non-gmin platforms use the legacy callback */
-	if (dev->platform_data->gpio_ctrl)
-		return dev->platform_data->gpio_ctrl(sd, flag);
-
 	/* Note: current modules wire only one GPIO signal (RESET#),
 	 * but the schematic wires up two to the connector.  BIOS
 	 * versions have been unfortunately inconsistent with which
diff --git a/drivers/staging/media/atomisp/i2c/ov2680.c b/drivers/staging/media/atomisp/i2c/ov2680.c
index a42adeeb748c..162150055770 100644
--- a/drivers/staging/media/atomisp/i2c/ov2680.c
+++ b/drivers/staging/media/atomisp/i2c/ov2680.c
@@ -871,10 +871,6 @@ static int gpio_ctrl(struct v4l2_subdev *sd, bool flag)
 	if (!dev || !dev->platform_data)
 		return -ENODEV;
 
-	/* Non-gmin platforms use the legacy callback */
-	if (dev->platform_data->gpio_ctrl)
-		return dev->platform_data->gpio_ctrl(sd, flag);
-
 	/* The OV2680 documents only one GPIO input (#XSHUTDN), but
 	 * existing integrations often wire two (reset/power_down)
 	 * because that is the way other sensors work.  There is no
diff --git a/drivers/staging/media/atomisp/i2c/ov2722.c b/drivers/staging/media/atomisp/i2c/ov2722.c
index 1b7012f47303..6c1057542aea 100644
--- a/drivers/staging/media/atomisp/i2c/ov2722.c
+++ b/drivers/staging/media/atomisp/i2c/ov2722.c
@@ -677,10 +677,6 @@ static int gpio_ctrl(struct v4l2_subdev *sd, bool flag)
 	if (!dev || !dev->platform_data)
 		return -ENODEV;
 
-	/* Non-gmin platforms use the legacy callback */
-	if (dev->platform_data->gpio_ctrl)
-		return dev->platform_data->gpio_ctrl(sd, flag);
-
 	/* Note: the GPIO order is asymmetric: always RESET#
 	 * before PWDN# when turning it on or off.
 	 */
diff --git a/drivers/staging/media/atomisp/i2c/ov5693/ov5693.c b/drivers/staging/media/atomisp/i2c/ov5693/ov5693.c
index 357821af4db0..8d5b4c3ea55d 100644
--- a/drivers/staging/media/atomisp/i2c/ov5693/ov5693.c
+++ b/drivers/staging/media/atomisp/i2c/ov5693/ov5693.c
@@ -1332,10 +1332,6 @@ static int gpio_ctrl(struct v4l2_subdev *sd, bool flag)
 	if (!dev || !dev->platform_data)
 		return -ENODEV;
 
-	/* Non-gmin platforms use the legacy callback */
-	if (dev->platform_data->gpio_ctrl)
-		return dev->platform_data->gpio_ctrl(sd, flag);
-
 	return dev->platform_data->gpio0_ctrl(sd, flag);
 }
 
diff --git a/drivers/staging/media/atomisp/i2c/ov8858.c b/drivers/staging/media/atomisp/i2c/ov8858.c
index 28f277fa2bc9..c00e5b37139f 100644
--- a/drivers/staging/media/atomisp/i2c/ov8858.c
+++ b/drivers/staging/media/atomisp/i2c/ov8858.c
@@ -769,10 +769,6 @@ static int __gpio_ctrl(struct v4l2_subdev *sd, bool flag)
 	if (!client || !dev || !dev->platform_data)
 		return -ENODEV;
 
-	/* Non-gmin platforms use the legacy callback */
-	if (dev->platform_data->gpio_ctrl)
-		return dev->platform_data->gpio_ctrl(sd, flag);
-
 	if (dev->platform_data->gpio0_ctrl)
 		return dev->platform_data->gpio0_ctrl(sd, flag);
 
diff --git a/drivers/staging/media/atomisp/include/linux/atomisp_platform.h b/drivers/staging/media/atomisp/include/linux/atomisp_platform.h
index dbac2b777dad..94ddb46d415b 100644
--- a/drivers/staging/media/atomisp/include/linux/atomisp_platform.h
+++ b/drivers/staging/media/atomisp/include/linux/atomisp_platform.h
@@ -205,7 +205,6 @@ struct camera_vcm_control {
 };
 
 struct camera_sensor_platform_data {
-	int (*gpio_ctrl)(struct v4l2_subdev *subdev, int flag);
 	int (*flisclk_ctrl)(struct v4l2_subdev *subdev, int flag);
 	int (*power_ctrl)(struct v4l2_subdev *subdev, int flag);
 	int (*csi_cfg)(struct v4l2_subdev *subdev, int flag);
@@ -214,7 +213,6 @@ struct camera_sensor_platform_data {
 	int (*platform_deinit)(void);
 	char *(*msr_file_name)(void);
 	struct atomisp_camera_caps *(*get_camera_caps)(void);
-	int (*gpio_intr_ctrl)(struct v4l2_subdev *subdev);
 
 	/* New G-Min power and GPIO interface, replaces
 	 * power/gpio_ctrl with methods to control individual
-- 
2.14.1
