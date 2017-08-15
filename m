Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60928 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753704AbdHOKl5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Aug 2017 06:41:57 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: linux-leds@vger.kernel.org, jacek.anaszewski@gmail.com,
        laurent.pinchart@ideasonboard.com, Johan Hovold <johan@kernel.org>,
        Alex Elder <elder@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        greybus-dev@lists.linaro.org, devel@driverdev.osuosl.org,
        viresh.kumar@linaro.org, Rui Miguel Silva <rmfrfs@gmail.com>
Subject: [PATCH v3.1 2/3] v4l2-flash-led-class: Create separate sub-devices for indicators
Date: Tue, 15 Aug 2017 13:41:53 +0300
Message-Id: <20170815104153.11207-1-sakari.ailus@linux.intel.com>
In-Reply-To: <20170810154947.2283-3-sakari.ailus@linux.intel.com>
References: <20170810154947.2283-3-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The V4L2 flash interface allows controlling multiple LEDs through a single
sub-devices if, and only if, these LEDs are of different types. This
approach scales badly for flash controllers that drive multiple flash LEDs
or for LED specific associations. Essentially, the original assumption of a
LED driver chip that drives a single flash LED and an indicator LED is no
longer valid.

Address the matter by registering one sub-device per LED.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Jacek Anaszewski <jacek.anaszewski@gmail.com>
Acked-by: Pavel Machek <pavel@ucw.cz>
Reviewed-by: Rui Miguel Silva <rmfrfs@gmail.com> (for greybus/light)
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
since v3:

- Fix v4l2_flash_init() static inline function arguments used when the V4L2
  flash LED class is disabled; they were different from the real one.

 drivers/leds/leds-aat1290.c                    |   4 +-
 drivers/leds/leds-max77693.c                   |   4 +-
 drivers/media/v4l2-core/v4l2-flash-led-class.c | 113 +++++++++++++++----------
 drivers/staging/greybus/light.c                |  23 +++--
 include/media/v4l2-flash-led-class.h           |  40 ++++++---
 5 files changed, 117 insertions(+), 67 deletions(-)

diff --git a/drivers/leds/leds-aat1290.c b/drivers/leds/leds-aat1290.c
index a21e19297745..424898e6c69d 100644
--- a/drivers/leds/leds-aat1290.c
+++ b/drivers/leds/leds-aat1290.c
@@ -432,7 +432,7 @@ static void aat1290_init_v4l2_flash_config(struct aat1290_led *led,
 	strlcpy(v4l2_sd_cfg->dev_name, led_cdev->name,
 		sizeof(v4l2_sd_cfg->dev_name));
 
-	s = &v4l2_sd_cfg->torch_intensity;
+	s = &v4l2_sd_cfg->intensity;
 	s->min = led->mm_current_scale[0];
 	s->max = led_cfg->max_mm_current;
 	s->step = 1;
@@ -504,7 +504,7 @@ static int aat1290_led_probe(struct platform_device *pdev)
 
 	/* Create V4L2 Flash subdev. */
 	led->v4l2_flash = v4l2_flash_init(dev, of_fwnode_handle(sub_node),
-					  fled_cdev, NULL, &v4l2_flash_ops,
+					  fled_cdev, &v4l2_flash_ops,
 					  &v4l2_sd_cfg);
 	if (IS_ERR(led->v4l2_flash)) {
 		ret = PTR_ERR(led->v4l2_flash);
diff --git a/drivers/leds/leds-max77693.c b/drivers/leds/leds-max77693.c
index 2d3062d53325..adf0f191f794 100644
--- a/drivers/leds/leds-max77693.c
+++ b/drivers/leds/leds-max77693.c
@@ -856,7 +856,7 @@ static void max77693_init_v4l2_flash_config(struct max77693_sub_led *sub_led,
 		 "%s %d-%04x", sub_led->fled_cdev.led_cdev.name,
 		 i2c_adapter_id(i2c->adapter), i2c->addr);
 
-	s = &v4l2_sd_cfg->torch_intensity;
+	s = &v4l2_sd_cfg->intensity;
 	s->min = TORCH_IOUT_MIN;
 	s->max = sub_led->fled_cdev.led_cdev.max_brightness * TORCH_IOUT_STEP;
 	s->step = TORCH_IOUT_STEP;
@@ -931,7 +931,7 @@ static int max77693_register_led(struct max77693_sub_led *sub_led,
 
 	/* Register in the V4L2 subsystem. */
 	sub_led->v4l2_flash = v4l2_flash_init(dev, of_fwnode_handle(sub_node),
-					      fled_cdev, NULL, &v4l2_flash_ops,
+					      fled_cdev, &v4l2_flash_ops,
 					      &v4l2_sd_cfg);
 	if (IS_ERR(sub_led->v4l2_flash)) {
 		ret = PTR_ERR(sub_led->v4l2_flash);
diff --git a/drivers/media/v4l2-core/v4l2-flash-led-class.c b/drivers/media/v4l2-core/v4l2-flash-led-class.c
index aabc85dbb8b5..4ceef217de83 100644
--- a/drivers/media/v4l2-core/v4l2-flash-led-class.c
+++ b/drivers/media/v4l2-core/v4l2-flash-led-class.c
@@ -197,7 +197,7 @@ static int v4l2_flash_s_ctrl(struct v4l2_ctrl *c)
 {
 	struct v4l2_flash *v4l2_flash = v4l2_ctrl_to_v4l2_flash(c);
 	struct led_classdev_flash *fled_cdev = v4l2_flash->fled_cdev;
-	struct led_classdev *led_cdev = &fled_cdev->led_cdev;
+	struct led_classdev *led_cdev = fled_cdev ? &fled_cdev->led_cdev : NULL;
 	struct v4l2_ctrl **ctrls = v4l2_flash->ctrls;
 	bool external_strobe;
 	int ret = 0;
@@ -299,10 +299,26 @@ static void __fill_ctrl_init_data(struct v4l2_flash *v4l2_flash,
 			  struct v4l2_flash_ctrl_data *ctrl_init_data)
 {
 	struct led_classdev_flash *fled_cdev = v4l2_flash->fled_cdev;
-	struct led_classdev *led_cdev = &fled_cdev->led_cdev;
+	struct led_classdev *led_cdev = fled_cdev ? &fled_cdev->led_cdev : NULL;
 	struct v4l2_ctrl_config *ctrl_cfg;
 	u32 mask;
 
+	/* Init INDICATOR_INTENSITY ctrl data */
+	if (v4l2_flash->iled_cdev) {
+		ctrl_init_data[INDICATOR_INTENSITY].cid =
+					V4L2_CID_FLASH_INDICATOR_INTENSITY;
+		ctrl_cfg = &ctrl_init_data[INDICATOR_INTENSITY].config;
+		__lfs_to_v4l2_ctrl_config(&flash_cfg->intensity,
+					  ctrl_cfg);
+		ctrl_cfg->id = V4L2_CID_FLASH_INDICATOR_INTENSITY;
+		ctrl_cfg->min = 0;
+		ctrl_cfg->flags = V4L2_CTRL_FLAG_VOLATILE |
+				  V4L2_CTRL_FLAG_EXECUTE_ON_WRITE;
+	}
+
+	if (!led_cdev || WARN_ON(!(led_cdev->flags & LED_DEV_CAP_FLASH)))
+		return;
+
 	/* Init FLASH_FAULT ctrl data */
 	if (flash_cfg->flash_faults) {
 		ctrl_init_data[FLASH_FAULT].cid = V4L2_CID_FLASH_FAULT;
@@ -330,27 +346,11 @@ static void __fill_ctrl_init_data(struct v4l2_flash *v4l2_flash,
 	/* Init TORCH_INTENSITY ctrl data */
 	ctrl_init_data[TORCH_INTENSITY].cid = V4L2_CID_FLASH_TORCH_INTENSITY;
 	ctrl_cfg = &ctrl_init_data[TORCH_INTENSITY].config;
-	__lfs_to_v4l2_ctrl_config(&flash_cfg->torch_intensity, ctrl_cfg);
+	__lfs_to_v4l2_ctrl_config(&flash_cfg->intensity, ctrl_cfg);
 	ctrl_cfg->id = V4L2_CID_FLASH_TORCH_INTENSITY;
 	ctrl_cfg->flags = V4L2_CTRL_FLAG_VOLATILE |
 			  V4L2_CTRL_FLAG_EXECUTE_ON_WRITE;
 
-	/* Init INDICATOR_INTENSITY ctrl data */
-	if (v4l2_flash->iled_cdev) {
-		ctrl_init_data[INDICATOR_INTENSITY].cid =
-					V4L2_CID_FLASH_INDICATOR_INTENSITY;
-		ctrl_cfg = &ctrl_init_data[INDICATOR_INTENSITY].config;
-		__lfs_to_v4l2_ctrl_config(&flash_cfg->indicator_intensity,
-					  ctrl_cfg);
-		ctrl_cfg->id = V4L2_CID_FLASH_INDICATOR_INTENSITY;
-		ctrl_cfg->min = 0;
-		ctrl_cfg->flags = V4L2_CTRL_FLAG_VOLATILE |
-				  V4L2_CTRL_FLAG_EXECUTE_ON_WRITE;
-	}
-
-	if (!(led_cdev->flags & LED_DEV_CAP_FLASH))
-		return;
-
 	/* Init FLASH_STROBE ctrl data */
 	ctrl_init_data[FLASH_STROBE].cid = V4L2_CID_FLASH_STROBE;
 	ctrl_cfg = &ctrl_init_data[FLASH_STROBE].config;
@@ -485,7 +485,9 @@ static int __sync_device_with_v4l2_controls(struct v4l2_flash *v4l2_flash)
 	struct v4l2_ctrl **ctrls = v4l2_flash->ctrls;
 	int ret = 0;
 
-	v4l2_flash_set_led_brightness(v4l2_flash, ctrls[TORCH_INTENSITY]);
+	if (ctrls[TORCH_INTENSITY])
+		v4l2_flash_set_led_brightness(v4l2_flash,
+					      ctrls[TORCH_INTENSITY]);
 
 	if (ctrls[INDICATOR_INTENSITY])
 		v4l2_flash_set_led_brightness(v4l2_flash,
@@ -527,19 +529,21 @@ static int v4l2_flash_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
 {
 	struct v4l2_flash *v4l2_flash = v4l2_subdev_to_v4l2_flash(sd);
 	struct led_classdev_flash *fled_cdev = v4l2_flash->fled_cdev;
-	struct led_classdev *led_cdev = &fled_cdev->led_cdev;
+	struct led_classdev *led_cdev = fled_cdev ? &fled_cdev->led_cdev : NULL;
 	struct led_classdev *led_cdev_ind = v4l2_flash->iled_cdev;
 	int ret = 0;
 
 	if (!v4l2_fh_is_singular(&fh->vfh))
 		return 0;
 
-	mutex_lock(&led_cdev->led_access);
+	if (led_cdev) {
+		mutex_lock(&led_cdev->led_access);
 
-	led_sysfs_disable(led_cdev);
-	led_trigger_remove(led_cdev);
+		led_sysfs_disable(led_cdev);
+		led_trigger_remove(led_cdev);
 
-	mutex_unlock(&led_cdev->led_access);
+		mutex_unlock(&led_cdev->led_access);
+	}
 
 	if (led_cdev_ind) {
 		mutex_lock(&led_cdev_ind->led_access);
@@ -556,9 +560,11 @@ static int v4l2_flash_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
 
 	return 0;
 out_sync_device:
-	mutex_lock(&led_cdev->led_access);
-	led_sysfs_enable(led_cdev);
-	mutex_unlock(&led_cdev->led_access);
+	if (led_cdev) {
+		mutex_lock(&led_cdev->led_access);
+		led_sysfs_enable(led_cdev);
+		mutex_unlock(&led_cdev->led_access);
+	}
 
 	if (led_cdev_ind) {
 		mutex_lock(&led_cdev_ind->led_access);
@@ -573,21 +579,24 @@ static int v4l2_flash_close(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
 {
 	struct v4l2_flash *v4l2_flash = v4l2_subdev_to_v4l2_flash(sd);
 	struct led_classdev_flash *fled_cdev = v4l2_flash->fled_cdev;
-	struct led_classdev *led_cdev = &fled_cdev->led_cdev;
+	struct led_classdev *led_cdev = fled_cdev ? &fled_cdev->led_cdev : NULL;
 	struct led_classdev *led_cdev_ind = v4l2_flash->iled_cdev;
 	int ret = 0;
 
 	if (!v4l2_fh_is_singular(&fh->vfh))
 		return 0;
 
-	mutex_lock(&led_cdev->led_access);
+	if (led_cdev) {
+		mutex_lock(&led_cdev->led_access);
 
-	if (v4l2_flash->ctrls[STROBE_SOURCE])
-		ret = v4l2_ctrl_s_ctrl(v4l2_flash->ctrls[STROBE_SOURCE],
+		if (v4l2_flash->ctrls[STROBE_SOURCE])
+			ret = v4l2_ctrl_s_ctrl(
+				v4l2_flash->ctrls[STROBE_SOURCE],
 				V4L2_FLASH_STROBE_SOURCE_SOFTWARE);
-	led_sysfs_enable(led_cdev);
+		led_sysfs_enable(led_cdev);
 
-	mutex_unlock(&led_cdev->led_access);
+		mutex_unlock(&led_cdev->led_access);
+	}
 
 	if (led_cdev_ind) {
 		mutex_lock(&led_cdev_ind->led_access);
@@ -605,25 +614,19 @@ static const struct v4l2_subdev_internal_ops v4l2_flash_subdev_internal_ops = {
 
 static const struct v4l2_subdev_ops v4l2_flash_subdev_ops;
 
-struct v4l2_flash *v4l2_flash_init(
+static struct v4l2_flash *__v4l2_flash_init(
 	struct device *dev, struct fwnode_handle *fwn,
-	struct led_classdev_flash *fled_cdev,
-	struct led_classdev *iled_cdev,
-	const struct v4l2_flash_ops *ops,
-	struct v4l2_flash_config *config)
+	struct led_classdev_flash *fled_cdev, struct led_classdev *iled_cdev,
+	const struct v4l2_flash_ops *ops, struct v4l2_flash_config *config)
 {
 	struct v4l2_flash *v4l2_flash;
-	struct led_classdev *led_cdev;
 	struct v4l2_subdev *sd;
 	int ret;
 
-	if (!fled_cdev || !config)
+	if (!config)
 		return ERR_PTR(-EINVAL);
 
-	led_cdev = &fled_cdev->led_cdev;
-
-	v4l2_flash = devm_kzalloc(led_cdev->dev, sizeof(*v4l2_flash),
-					GFP_KERNEL);
+	v4l2_flash = devm_kzalloc(dev, sizeof(*v4l2_flash), GFP_KERNEL);
 	if (!v4l2_flash)
 		return ERR_PTR(-ENOMEM);
 
@@ -632,7 +635,7 @@ struct v4l2_flash *v4l2_flash_init(
 	v4l2_flash->iled_cdev = iled_cdev;
 	v4l2_flash->ops = ops;
 	sd->dev = dev;
-	sd->fwnode = fwn ? fwn : dev_fwnode(led_cdev->dev);
+	sd->fwnode = fwn ? fwn : dev_fwnode(dev);
 	v4l2_subdev_init(sd, &v4l2_flash_subdev_ops);
 	sd->internal_ops = &v4l2_flash_subdev_internal_ops;
 	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
@@ -664,8 +667,26 @@ struct v4l2_flash *v4l2_flash_init(
 
 	return ERR_PTR(ret);
 }
+
+struct v4l2_flash *v4l2_flash_init(
+	struct device *dev, struct fwnode_handle *fwn,
+	struct led_classdev_flash *fled_cdev,
+	const struct v4l2_flash_ops *ops,
+	struct v4l2_flash_config *config)
+{
+	return __v4l2_flash_init(dev, fwn, fled_cdev, NULL, ops, config);
+}
 EXPORT_SYMBOL_GPL(v4l2_flash_init);
 
+struct v4l2_flash *v4l2_flash_indicator_init(
+	struct device *dev, struct fwnode_handle *fwn,
+	struct led_classdev *iled_cdev,
+	struct v4l2_flash_config *config)
+{
+	return __v4l2_flash_init(dev, fwn, NULL, iled_cdev, NULL, config);
+}
+EXPORT_SYMBOL_GPL(v4l2_flash_indicator_init);
+
 void v4l2_flash_release(struct v4l2_flash *v4l2_flash)
 {
 	struct v4l2_subdev *sd;
diff --git a/drivers/staging/greybus/light.c b/drivers/staging/greybus/light.c
index 81469d087e74..3f4148c92308 100644
--- a/drivers/staging/greybus/light.c
+++ b/drivers/staging/greybus/light.c
@@ -58,6 +58,7 @@ struct gb_light {
 	bool			ready;
 #if IS_REACHABLE(CONFIG_V4L2_FLASH_LED_CLASS)
 	struct v4l2_flash	*v4l2_flash;
+	struct v4l2_flash	*v4l2_flash_ind;
 #endif
 };
 
@@ -534,7 +535,7 @@ static int gb_lights_light_v4l2_register(struct gb_light *light)
 {
 	struct gb_connection *connection = get_conn_from_light(light);
 	struct device *dev = &connection->bundle->dev;
-	struct v4l2_flash_config sd_cfg = { {0} };
+	struct v4l2_flash_config sd_cfg = { {0} }, sd_cfg_ind = { {0} };
 	struct led_classdev_flash *fled;
 	struct led_classdev *iled = NULL;
 	struct gb_channel *channel_torch, *channel_ind, *channel_flash;
@@ -542,12 +543,12 @@ static int gb_lights_light_v4l2_register(struct gb_light *light)
 	channel_torch = get_channel_from_mode(light, GB_CHANNEL_MODE_TORCH);
 	if (channel_torch)
 		__gb_lights_channel_v4l2_config(&channel_torch->intensity_uA,
-						&sd_cfg.torch_intensity);
+						&sd_cfg.intensity);
 
 	channel_ind = get_channel_from_mode(light, GB_CHANNEL_MODE_INDICATOR);
 	if (channel_ind) {
 		__gb_lights_channel_v4l2_config(&channel_ind->intensity_uA,
-						&sd_cfg.indicator_intensity);
+						&sd_cfg_ind.intensity);
 		iled = &channel_ind->fled.led_cdev;
 	}
 
@@ -557,6 +558,8 @@ static int gb_lights_light_v4l2_register(struct gb_light *light)
 	fled = &channel_flash->fled;
 
 	snprintf(sd_cfg.dev_name, sizeof(sd_cfg.dev_name), "%s", light->name);
+	snprintf(sd_cfg_ind.dev_name, sizeof(sd_cfg_ind.dev_name),
+		 "%s indicator", light->name);
 
 	/* Set the possible values to faults, in our case all faults */
 	sd_cfg.flash_faults = LED_FAULT_OVER_VOLTAGE | LED_FAULT_TIMEOUT |
@@ -565,16 +568,26 @@ static int gb_lights_light_v4l2_register(struct gb_light *light)
 		LED_FAULT_UNDER_VOLTAGE | LED_FAULT_INPUT_VOLTAGE |
 		LED_FAULT_LED_OVER_TEMPERATURE;
 
-	light->v4l2_flash = v4l2_flash_init(dev, NULL, fled, iled,
-					    &v4l2_flash_ops, &sd_cfg);
+	light->v4l2_flash = v4l2_flash_init(dev, NULL, fled, &v4l2_flash_ops,
+					    &sd_cfg);
 	if (IS_ERR(light->v4l2_flash))
 		return PTR_ERR(light->v4l2_flash);
 
+	if (channel_ind) {
+		light->v4l2_flash_ind =
+			v4l2_flash_indicator_init(dev, NULL, iled, &sd_cfg_ind);
+		if (IS_ERR(light->v4l2_flash_ind)) {
+			v4l2_flash_release(light->v4l2_flash);
+			return PTR_ERR(light->v4l2_flash_ind);
+		}
+	}
+
 	return 0;
 }
 
 static void gb_lights_light_v4l2_unregister(struct gb_light *light)
 {
+	v4l2_flash_release(light->v4l2_flash_ind);
 	v4l2_flash_release(light->v4l2_flash);
 }
 #else
diff --git a/include/media/v4l2-flash-led-class.h b/include/media/v4l2-flash-led-class.h
index 54e31a805a88..0ec2cc77213f 100644
--- a/include/media/v4l2-flash-led-class.h
+++ b/include/media/v4l2-flash-led-class.h
@@ -56,8 +56,7 @@ struct v4l2_flash_ops {
  * struct v4l2_flash_config - V4L2 Flash sub-device initialization data
  * @dev_name:			the name of the media entity,
  *				unique in the system
- * @torch_intensity:		constraints for the LED in torch mode
- * @indicator_intensity:	constraints for the indicator LED
+ * @intensity:			non-flash strobe constraints for the LED
  * @flash_faults:		bitmask of flash faults that the LED flash class
  *				device can report; corresponding LED_FAULT* bit
  *				definitions are available in the header file
@@ -66,8 +65,7 @@ struct v4l2_flash_ops {
  */
 struct v4l2_flash_config {
 	char dev_name[32];
-	struct led_flash_setting torch_intensity;
-	struct led_flash_setting indicator_intensity;
+	struct led_flash_setting intensity;
 	u32 flash_faults;
 	unsigned int has_external_strobe:1;
 };
@@ -110,8 +108,6 @@ static inline struct v4l2_flash *v4l2_ctrl_to_v4l2_flash(struct v4l2_ctrl *c)
  * @dev:	flash device, e.g. an I2C device
  * @fwn:	fwnode_handle of the LED, may be NULL if the same as device's
  * @fled_cdev:	LED flash class device to wrap
- * @iled_cdev:	LED flash class device representing indicator LED associated
- *		with fled_cdev, may be NULL
  * @ops:	V4L2 Flash device ops
  * @config:	initialization data for V4L2 Flash sub-device
  *
@@ -124,9 +120,24 @@ static inline struct v4l2_flash *v4l2_ctrl_to_v4l2_flash(struct v4l2_ctrl *c)
 struct v4l2_flash *v4l2_flash_init(
 	struct device *dev, struct fwnode_handle *fwn,
 	struct led_classdev_flash *fled_cdev,
-	struct led_classdev *iled_cdev,
-	const struct v4l2_flash_ops *ops,
-	struct v4l2_flash_config *config);
+	const struct v4l2_flash_ops *ops, struct v4l2_flash_config *config);
+
+/**
+ * v4l2_flash_indicator_init - initialize V4L2 indicator sub-device
+ * @dev:	flash device, e.g. an I2C device
+ * @fwn:	fwnode_handle of the LED, may be NULL if the same as device's
+ * @iled_cdev:	LED flash class device representing the indicator LED
+ * @config:	initialization data for V4L2 Flash sub-device
+ *
+ * Create V4L2 Flash sub-device wrapping given LED subsystem device.
+ *
+ * Returns: A valid pointer, or, when an error occurs, the return
+ * value is encoded using ERR_PTR(). Use IS_ERR() to check and
+ * PTR_ERR() to obtain the numeric return value.
+ */
+struct v4l2_flash *v4l2_flash_indicator_init(
+	struct device *dev, struct fwnode_handle *fwn,
+	struct led_classdev *iled_cdev, struct v4l2_flash_config *config);
 
 /**
  * v4l2_flash_release - release V4L2 Flash sub-device
@@ -140,9 +151,14 @@ void v4l2_flash_release(struct v4l2_flash *v4l2_flash);
 static inline struct v4l2_flash *v4l2_flash_init(
 	struct device *dev, struct fwnode_handle *fwn,
 	struct led_classdev_flash *fled_cdev,
-	struct led_classdev *iled_cdev,
-	const struct v4l2_flash_ops *ops,
-	struct v4l2_flash_config *config)
+	const struct v4l2_flash_ops *ops, struct v4l2_flash_config *config);
+{
+	return NULL;
+}
+
+static inline struct v4l2_flash *v4l2_flash_indicator_init(
+	struct device *dev, struct fwnode_handle *fwn,
+	struct led_classdev *iled_cdev, struct v4l2_flash_config *config)
 {
 	return NULL;
 }
-- 
2.11.0
