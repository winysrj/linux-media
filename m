Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:11224 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295AbbBRQ0j (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Feb 2015 11:26:39 -0500
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org
Cc: kyungmin.park@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
	rpurdie@rpsys.net, sakari.ailus@iki.fi, s.nawrocki@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH/RFC v11 19/20] leds: max77693: add support for V4L2 Flash
 sub-device
Date: Wed, 18 Feb 2015 17:20:40 +0100
Message-id: <1424276441-3969-20-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1424276441-3969-1-git-send-email-j.anaszewski@samsung.com>
References: <1424276441-3969-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for V4L2 Flash sub-device to the max77693 LED Flash class
driver. The support allows for V4L2 Flash sub-device to take the control
of the LED Flash class device.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Bryan Wu <cooloney@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/leds/leds-max77693.c |  149 +++++++++++++++++++++++++++++++++++++++---
 1 file changed, 141 insertions(+), 8 deletions(-)

diff --git a/drivers/leds/leds-max77693.c b/drivers/leds/leds-max77693.c
index 45d50d9..af06ca7 100644
--- a/drivers/leds/leds-max77693.c
+++ b/drivers/leds/leds-max77693.c
@@ -21,6 +21,7 @@
 #include <linux/regmap.h>
 #include <linux/slab.h>
 #include <linux/workqueue.h>
+#include <media/v4l2-flash.h>
 
 #define MODE_OFF		0
 #define MODE_FLASH(a)		(1 << (a))
@@ -64,6 +65,8 @@ struct max77693_sub_led {
 	struct led_classdev_flash fled_cdev;
 	/* assures led-triggers compatibility */
 	struct work_struct work_brightness_set;
+	/* V4L2 Flash device */
+	struct v4l2_flash *v4l2_flash;
 
 	/* brightness cache */
 	unsigned int torch_brightness;
@@ -640,6 +643,32 @@ unlock:
 	return ret;
 }
 
+#if IS_ENABLED(CONFIG_V4L2_FLASH_LED_CLASS)
+static int max77693_led_external_strobe_set(
+				struct v4l2_flash *v4l2_flash,
+				bool enable)
+{
+	struct max77693_sub_led *sub_led =
+				flcdev_to_sub_led(v4l2_flash->fled_cdev);
+	struct max77693_led_device *led = sub_led_to_led(sub_led);
+	int fled_id = sub_led->fled_id;
+	int ret;
+
+	mutex_lock(&led->lock);
+
+	if (enable)
+		ret = max77693_add_mode(led, MODE_FLASH_EXTERNAL(fled_id));
+	else
+		ret = max77693_clear_mode(led, MODE_FLASH_EXTERNAL(fled_id));
+
+	mutex_unlock(&led->lock);
+
+	return ret;
+}
+#else
+#define max77693_led_external_strobe_set(v4l2_flash, enable) (NULL)
+#endif
+
 static int max77693_led_flash_fault_get(
 				struct led_classdev_flash *fled_cdev,
 				u32 *fault)
@@ -688,7 +717,8 @@ static int max77693_led_flash_timeout_set(
 }
 
 static int max77693_led_parse_dt(struct max77693_led_device *led,
-				struct max77693_led_config_data *cfg)
+				struct max77693_led_config_data *cfg,
+				struct device_node **sub_nodes)
 {
 	struct device *dev = &led->pdev->dev;
 	struct max77693_sub_led *sub_leds = led->sub_leds;
@@ -734,6 +764,13 @@ static int max77693_led_parse_dt(struct max77693_led_device *led,
 			return -EINVAL;
 		}
 
+		if (sub_nodes[fled_id]) {
+			dev_err(dev,
+				"Conflicting \"led-sources\" DT properties\n");
+			return -EINVAL;
+		}
+
+		sub_nodes[fled_id] = child_node;
 		sub_leds[fled_id].fled_id = fled_id;
 
 		ret = of_property_read_string(child_node, "label",
@@ -825,11 +862,12 @@ static void max77693_led_validate_configuration(struct max77693_led_device *led,
 }
 
 static int max77693_led_get_configuration(struct max77693_led_device *led,
-				struct max77693_led_config_data *cfg)
+				struct max77693_led_config_data *cfg,
+				struct device_node **sub_nodes)
 {
 	int ret;
 
-	ret = max77693_led_parse_dt(led, cfg);
+	ret = max77693_led_parse_dt(led, cfg, sub_nodes);
 	if (ret < 0)
 		return ret;
 
@@ -853,6 +891,12 @@ static const struct led_flash_ops flash_ops = {
 	.fault_get		= max77693_led_flash_fault_get,
 };
 
+#if IS_ENABLED(CONFIG_V4L2_FLASH_LED_CLASS)
+static const struct v4l2_flash_ops v4l2_flash_ops = {
+	.external_strobe_set = max77693_led_external_strobe_set,
+};
+#endif
+
 static void max77693_init_flash_settings(struct max77693_led_device *led,
 					 int fled_id,
 					 struct max77693_led_config_data *cfg,
@@ -887,6 +931,46 @@ static void max77693_init_flash_settings(struct max77693_led_device *led,
 	setting->val = setting->max;
 }
 
+#if IS_ENABLED(CONFIG_V4L2_FLASH_LED_CLASS)
+static void max77693_init_v4l2_ctrl_config(int fled_id,
+					struct max77693_led_settings *s,
+					struct v4l2_flash_ctrl_config *config)
+{
+	struct led_flash_setting *setting;
+	struct v4l2_ctrl_config *c;
+
+	c = &config->intensity;
+	setting = &s->torch_brightness;
+	c->min = setting->min;
+	c->max = setting->max;
+	c->step = setting->step;
+	c->def = setting->val;
+
+	c = &config->flash_intensity;
+	setting = &s->flash_brightness;
+	c->min = setting->min;
+	c->max = setting->max;
+	c->step = setting->step;
+	c->def = setting->val;
+
+	c = &config->flash_timeout;
+	setting = &s->flash_timeout;
+	c->min = setting->min;
+	c->max = setting->max;
+	c->step = setting->step;
+	c->def = setting->val;
+
+	/* Init flash faults config */
+	config->flash_faults =	V4L2_FLASH_FAULT_OVER_VOLTAGE |
+				V4L2_FLASH_FAULT_SHORT_CIRCUIT |
+				V4L2_FLASH_FAULT_OVER_CURRENT;
+
+	config->has_external_strobe = true;
+}
+#else
+#define max77693_init_v4l2_ctrl_config(fled_id, s, config)
+#endif
+
 static int max77693_set_available_sync_led(struct max77693_led_device *led,
 						int fled_id)
 {
@@ -906,7 +990,8 @@ static int max77693_set_available_sync_led(struct max77693_led_device *led,
 
 static void max77693_init_fled_cdev(struct max77693_led_device *led,
 				int fled_id,
-				struct max77693_led_config_data *cfg)
+				struct max77693_led_config_data *cfg,
+				struct v4l2_flash_ctrl_config *v4l2_flash_cfg)
 {
 	struct led_classdev_flash *fled_cdev;
 	struct led_classdev *led_cdev;
@@ -915,6 +1000,8 @@ static void max77693_init_fled_cdev(struct max77693_led_device *led,
 
 	/* Initialize flash settings */
 	max77693_init_flash_settings(led, fled_id, cfg, &settings);
+	/* Initialize V4L2 Flash config basing on initialized settings */
+	max77693_init_v4l2_ctrl_config(fled_id, &settings, v4l2_flash_cfg);
 
 	/* Initialize LED Flash class device */
 	fled_cdev = &sub_led->fled_cdev;
@@ -937,15 +1024,52 @@ static void max77693_init_fled_cdev(struct max77693_led_device *led,
 	sub_led->flash_timeout = fled_cdev->timeout.val;
 }
 
+static int max77693_register_led(struct max77693_sub_led *sub_led,
+				 struct v4l2_flash_ctrl_config *v4l2_flash_cfg,
+				 struct device_node *sub_node)
+{
+	struct max77693_led_device *led = sub_led_to_led(sub_led);
+	struct led_classdev_flash *fled_cdev = &sub_led->fled_cdev;
+	struct device *dev = &led->pdev->dev;
+	int ret;
+
+	/* Register in the LED subsystem */
+	ret = led_classdev_flash_register(dev, fled_cdev);
+	if (ret < 0)
+		return ret;
+
+	of_node_get(sub_node);
+	fled_cdev->led_cdev.dev->of_node = sub_node;
+
+	/* Register in the V4L2 subsystem. */
+	sub_led->v4l2_flash = v4l2_flash_init(fled_cdev, &v4l2_flash_ops,
+						v4l2_flash_cfg);
+	if (IS_ERR(sub_led->v4l2_flash)) {
+		ret = PTR_ERR(sub_led->v4l2_flash);
+		goto err_v4l2_flash_init;
+	}
+
+	return 0;
+
+err_v4l2_flash_init:
+	of_node_put(sub_node);
+	led_classdev_flash_unregister(fled_cdev);
+	return ret;
+}
+
 static int max77693_led_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct max77693_dev *iodev = dev_get_drvdata(dev->parent);
 	struct max77693_led_device *led;
 	struct max77693_sub_led *sub_leds;
+	struct device_node *sub_nodes[2] = { NULL, NULL };
 	struct max77693_led_config_data cfg = {};
+	struct v4l2_flash_ctrl_config v4l2_flash_config[2];
 	int init_fled_cdev[2], i, ret;
 
+	memset(v4l2_flash_config, 0, sizeof(v4l2_flash_config));
+
 	led = devm_kzalloc(dev, sizeof(*led), GFP_KERNEL);
 	if (!led)
 		return -ENOMEM;
@@ -955,7 +1079,7 @@ static int max77693_led_probe(struct platform_device *pdev)
 	sub_leds = led->sub_leds;
 
 	platform_set_drvdata(pdev, led);
-	ret = max77693_led_get_configuration(led, &cfg);
+	ret = max77693_led_get_configuration(led, &cfg, sub_nodes);
 	if (ret < 0)
 		return ret;
 
@@ -971,7 +1095,8 @@ static int max77693_led_probe(struct platform_device *pdev)
 	/* Initialize LED Flash class device(s) */
 	for (i = FLED1; i <= FLED2; ++i)
 		if (init_fled_cdev[i])
-			max77693_init_fled_cdev(led, i, &cfg);
+			max77693_init_fled_cdev(led, i, &cfg,
+						&v4l2_flash_config[i]);
 
 	/* Setup sub-leds available for flash strobe synchronization */
 	if (cfg.num_leds == 2)
@@ -983,12 +1108,14 @@ static int max77693_led_probe(struct platform_device *pdev)
 
 	mutex_init(&led->lock);
 
-	/* Register LED Flash class device(s) */
+	/* Register LED Flash class and related V4L2 Flash device(s) */
 	for (i = FLED1; i <= FLED2; ++i) {
 		if (!init_fled_cdev[i])
 			continue;
 
-		ret = led_classdev_flash_register(dev, &sub_leds[i].fled_cdev);
+		ret = max77693_register_led(&sub_leds[i],
+					    &v4l2_flash_config[i],
+					    sub_nodes[i]);
 		if (ret < 0) {
 			/*
 			 * At this moment FLED1 might have been already
@@ -1008,6 +1135,8 @@ err_register_led2:
 	/* It is possible than only FLED2 was to be registered */
 	if (!init_fled_cdev[FLED1])
 		goto err_register_led1;
+	v4l2_flash_release(sub_leds[FLED1].v4l2_flash);
+	of_node_put(sub_leds[FLED1].fled_cdev.led_cdev.dev->of_node);
 	led_classdev_flash_unregister(&sub_leds[FLED1].fled_cdev);
 err_register_led1:
 	mutex_destroy(&led->lock);
@@ -1021,11 +1150,15 @@ static int max77693_led_remove(struct platform_device *pdev)
 	struct max77693_sub_led *sub_leds = led->sub_leds;
 
 	if (led->iout_joint || max77693_fled_used(led, FLED1)) {
+		v4l2_flash_release(sub_leds[FLED1].v4l2_flash);
+		of_node_put(sub_leds[FLED1].fled_cdev.led_cdev.dev->of_node);
 		led_classdev_flash_unregister(&sub_leds[FLED1].fled_cdev);
 		cancel_work_sync(&sub_leds[FLED1].work_brightness_set);
 	}
 
 	if (!led->iout_joint && max77693_fled_used(led, FLED2)) {
+		v4l2_flash_release(sub_leds[FLED2].v4l2_flash);
+		of_node_put(sub_leds[FLED2].fled_cdev.led_cdev.dev->of_node);
 		led_classdev_flash_unregister(&sub_leds[FLED2].fled_cdev);
 		cancel_work_sync(&sub_leds[FLED2].work_brightness_set);
 	}
-- 
1.7.9.5

