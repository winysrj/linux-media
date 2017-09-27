Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:44138 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752206AbdI0SZq (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Sep 2017 14:25:46 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 08/13] staging: atomisp: Remove ->power_ctrl() callback
Date: Wed, 27 Sep 2017 21:25:03 +0300
Message-Id: <20170927182508.52119-9-andriy.shevchenko@linux.intel.com>
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
 drivers/staging/media/atomisp/include/linux/atomisp_platform.h | 8 ++++----
 8 files changed, 4 insertions(+), 32 deletions(-)

diff --git a/drivers/staging/media/atomisp/i2c/gc0310.c b/drivers/staging/media/atomisp/i2c/gc0310.c
index 672a28c060f6..b6b1956293c0 100644
--- a/drivers/staging/media/atomisp/i2c/gc0310.c
+++ b/drivers/staging/media/atomisp/i2c/gc0310.c
@@ -737,10 +737,6 @@ static int power_ctrl(struct v4l2_subdev *sd, bool flag)
 	if (!dev || !dev->platform_data)
 		return -ENODEV;
 
-	/* Non-gmin platforms use the legacy callback */
-	if (dev->platform_data->power_ctrl)
-		return dev->platform_data->power_ctrl(sd, flag);
-
 	if (flag) {
 		/* The upstream module driver (written to Crystal
 		 * Cove) had this logic to pulse the rails low first.
diff --git a/drivers/staging/media/atomisp/i2c/gc2235.c b/drivers/staging/media/atomisp/i2c/gc2235.c
index 81b23b55f73a..46e063dcdc19 100644
--- a/drivers/staging/media/atomisp/i2c/gc2235.c
+++ b/drivers/staging/media/atomisp/i2c/gc2235.c
@@ -547,10 +547,6 @@ static int power_ctrl(struct v4l2_subdev *sd, bool flag)
 	if (!dev || !dev->platform_data)
 		return -ENODEV;
 
-	/* Non-gmin platforms use the legacy callback */
-	if (dev->platform_data->power_ctrl)
-		return dev->platform_data->power_ctrl(sd, flag);
-
 	if (flag) {
 		ret = dev->platform_data->v1p8_ctrl(sd, 1);
 		usleep_range(60, 90);
diff --git a/drivers/staging/media/atomisp/i2c/mt9m114.c b/drivers/staging/media/atomisp/i2c/mt9m114.c
index 4968deae2525..950627efa977 100644
--- a/drivers/staging/media/atomisp/i2c/mt9m114.c
+++ b/drivers/staging/media/atomisp/i2c/mt9m114.c
@@ -454,10 +454,6 @@ static int power_ctrl(struct v4l2_subdev *sd, bool flag)
 	if (!dev || !dev->platform_data)
 		return -ENODEV;
 
-	/* Non-gmin platforms use the legacy callback */
-	if (dev->platform_data->power_ctrl)
-		return dev->platform_data->power_ctrl(sd, flag);
-
 	if (flag) {
 		ret = dev->platform_data->v2p8_ctrl(sd, 1);
 		if (ret == 0) {
diff --git a/drivers/staging/media/atomisp/i2c/ov2680.c b/drivers/staging/media/atomisp/i2c/ov2680.c
index 162150055770..9279246cf0b1 100644
--- a/drivers/staging/media/atomisp/i2c/ov2680.c
+++ b/drivers/staging/media/atomisp/i2c/ov2680.c
@@ -846,10 +846,6 @@ static int power_ctrl(struct v4l2_subdev *sd, bool flag)
 	if (!dev || !dev->platform_data)
 		return -ENODEV;
 
-	/* Non-gmin platforms use the legacy callback */
-	if (dev->platform_data->power_ctrl)
-		return dev->platform_data->power_ctrl(sd, flag);
-
 	if (flag) {
 		ret |= dev->platform_data->v1p8_ctrl(sd, 1);
 		ret |= dev->platform_data->v2p8_ctrl(sd, 1);
diff --git a/drivers/staging/media/atomisp/i2c/ov2722.c b/drivers/staging/media/atomisp/i2c/ov2722.c
index 6c1057542aea..39296a784162 100644
--- a/drivers/staging/media/atomisp/i2c/ov2722.c
+++ b/drivers/staging/media/atomisp/i2c/ov2722.c
@@ -650,10 +650,6 @@ static int power_ctrl(struct v4l2_subdev *sd, bool flag)
 	if (!dev || !dev->platform_data)
 		return -ENODEV;
 
-	/* Non-gmin platforms use the legacy callback */
-	if (dev->platform_data->power_ctrl)
-		return dev->platform_data->power_ctrl(sd, flag);
-
 	if (flag) {
 		ret = dev->platform_data->v1p8_ctrl(sd, 1);
 		if (ret == 0) {
diff --git a/drivers/staging/media/atomisp/i2c/ov5693/ov5693.c b/drivers/staging/media/atomisp/i2c/ov5693/ov5693.c
index 8d5b4c3ea55d..33651ec0218f 100644
--- a/drivers/staging/media/atomisp/i2c/ov5693/ov5693.c
+++ b/drivers/staging/media/atomisp/i2c/ov5693/ov5693.c
@@ -1297,10 +1297,6 @@ static int power_ctrl(struct v4l2_subdev *sd, bool flag)
 	if (!dev || !dev->platform_data)
 		return -ENODEV;
 
-	/* Non-gmin platforms use the legacy callback */
-	if (dev->platform_data->power_ctrl)
-		return dev->platform_data->power_ctrl(sd, flag);
-
 	/* This driver assumes "internal DVDD, PWDNB tied to DOVDD".
 	 * In this set up only gpio0 (XSHUTDN) should be available
 	 * but in some products (for example ECS) gpio1 (PWDNB) is
diff --git a/drivers/staging/media/atomisp/i2c/ov8858.c b/drivers/staging/media/atomisp/i2c/ov8858.c
index c00e5b37139f..a13bbfb44652 100644
--- a/drivers/staging/media/atomisp/i2c/ov8858.c
+++ b/drivers/staging/media/atomisp/i2c/ov8858.c
@@ -714,10 +714,6 @@ static int __power_ctrl(struct v4l2_subdev *sd, bool flag)
 	if (!dev || !dev->platform_data)
 		return -ENODEV;
 
-	/* Non-gmin platforms use the legacy callback */
-	if (dev->platform_data->power_ctrl)
-		return dev->platform_data->power_ctrl(sd, flag);
-
 	if (dev->platform_data->v1p2_ctrl) {
 		ret = dev->platform_data->v1p2_ctrl(sd, flag);
 		if (ret) {
diff --git a/drivers/staging/media/atomisp/include/linux/atomisp_platform.h b/drivers/staging/media/atomisp/include/linux/atomisp_platform.h
index 94ddb46d415b..5ce8678dacf3 100644
--- a/drivers/staging/media/atomisp/include/linux/atomisp_platform.h
+++ b/drivers/staging/media/atomisp/include/linux/atomisp_platform.h
@@ -206,7 +206,6 @@ struct camera_vcm_control {
 
 struct camera_sensor_platform_data {
 	int (*flisclk_ctrl)(struct v4l2_subdev *subdev, int flag);
-	int (*power_ctrl)(struct v4l2_subdev *subdev, int flag);
 	int (*csi_cfg)(struct v4l2_subdev *subdev, int flag);
 	bool (*low_fps)(void);
 	int (*platform_init)(struct i2c_client *);
@@ -214,9 +213,10 @@ struct camera_sensor_platform_data {
 	char *(*msr_file_name)(void);
 	struct atomisp_camera_caps *(*get_camera_caps)(void);
 
-	/* New G-Min power and GPIO interface, replaces
-	 * power/gpio_ctrl with methods to control individual
-	 * lines as implemented on all known camera modules. */
+	/*
+	 * New G-Min power and GPIO interface to control individual
+	 * lines as implemented on all known camera modules.
+	 */
 	int (*gpio0_ctrl)(struct v4l2_subdev *subdev, int on);
 	int (*gpio1_ctrl)(struct v4l2_subdev *subdev, int on);
 	int (*v1p8_ctrl)(struct v4l2_subdev *subdev, int on);
-- 
2.14.1
