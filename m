Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:17481 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496AbbETOKr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 May 2015 10:10:47 -0400
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
	rpurdie@rpsys.net, sakari.ailus@iki.fi, s.nawrocki@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH v8 2/8] leds: max77693: add support for V4L2 Flash sub-device
Date: Wed, 20 May 2015 16:10:09 +0200
Message-id: <1432131015-22397-3-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1432131015-22397-1-git-send-email-j.anaszewski@samsung.com>
References: <1432131015-22397-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for V4L2 Flash sub-device to the max77693 LED Flash class
driver. The support allows for V4L2 Flash sub-device to take the control
of the LED Flash class device.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Bryan Wu <cooloney@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/leds/leds-max77693.c |  129 ++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 123 insertions(+), 6 deletions(-)

diff --git a/drivers/leds/leds-max77693.c b/drivers/leds/leds-max77693.c
index eecaa92..4fcd7f0 100644
--- a/drivers/leds/leds-max77693.c
+++ b/drivers/leds/leds-max77693.c
@@ -20,6 +20,7 @@
 #include <linux/regmap.h>
 #include <linux/slab.h>
 #include <linux/workqueue.h>
+#include <media/v4l2-flash-led-class.h>
 
 #define MODE_OFF		0
 #define MODE_FLASH(a)		(1 << (a))
@@ -62,6 +63,8 @@ struct max77693_sub_led {
 	struct led_classdev_flash fled_cdev;
 	/* assures led-triggers compatibility */
 	struct work_struct work_brightness_set;
+	/* V4L2 Flash device */
+	struct v4l2_flash *v4l2_flash;
 
 	/* brightness cache */
 	unsigned int torch_brightness;
@@ -627,7 +630,8 @@ static int max77693_led_flash_timeout_set(
 }
 
 static int max77693_led_parse_dt(struct max77693_led_device *led,
-				struct max77693_led_config_data *cfg)
+				struct max77693_led_config_data *cfg,
+				struct device_node **sub_nodes)
 {
 	struct device *dev = &led->pdev->dev;
 	struct max77693_sub_led *sub_leds = led->sub_leds;
@@ -674,6 +678,13 @@ static int max77693_led_parse_dt(struct max77693_led_device *led,
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
 
 		cfg->label[fled_id] =
@@ -786,11 +797,12 @@ static void max77693_led_validate_configuration(struct max77693_led_device *led,
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
 
@@ -838,6 +850,71 @@ static void max77693_init_flash_settings(struct max77693_sub_led *sub_led,
 	setting->val = setting->max;
 }
 
+#if IS_ENABLED(CONFIG_V4L2_FLASH_LED_CLASS)
+
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
+
+static void max77693_init_v4l2_flash_config(struct max77693_sub_led *sub_led,
+				struct max77693_led_config_data *led_cfg,
+				struct v4l2_flash_config *v4l2_sd_cfg)
+{
+	struct max77693_led_device *led = sub_led_to_led(sub_led);
+	struct device *dev = &led->pdev->dev;
+	struct max77693_dev *iodev = dev_get_drvdata(dev->parent);
+	struct i2c_client *i2c = iodev->i2c;
+	struct led_flash_setting *s;
+
+	snprintf(v4l2_sd_cfg->dev_name, sizeof(v4l2_sd_cfg->dev_name),
+		 "%s %d-%04x", sub_led->fled_cdev.led_cdev.name,
+		 i2c_adapter_id(i2c->adapter), i2c->addr);
+
+	s = &v4l2_sd_cfg->intensity;
+	s->min = TORCH_IOUT_MIN;
+	s->max = sub_led->fled_cdev.led_cdev.max_brightness * TORCH_IOUT_STEP;
+	s->step = TORCH_IOUT_STEP;
+	s->val = s->max;
+
+	/* Init flash faults config */
+	v4l2_sd_cfg->flash_faults = LED_FAULT_OVER_VOLTAGE |
+				LED_FAULT_SHORT_CIRCUIT |
+				LED_FAULT_OVER_CURRENT;
+
+	v4l2_sd_cfg->has_external_strobe = true;
+}
+
+static const struct v4l2_flash_ops v4l2_flash_ops = {
+	.external_strobe_set = max77693_led_external_strobe_set,
+};
+#else
+static inline void max77693_init_v4l2_flash_config(
+				struct max77693_sub_led *sub_led,
+				struct max77693_led_config_data *led_cfg,
+				struct v4l2_flash_config *v4l2_sd_cfg)
+{
+}
+static const struct v4l2_flash_ops v4l2_flash_ops;
+#endif
+
 static void max77693_init_fled_cdev(struct max77693_sub_led *sub_led,
 				struct max77693_led_config_data *led_cfg)
 {
@@ -870,12 +947,45 @@ static void max77693_init_fled_cdev(struct max77693_sub_led *sub_led,
 	sub_led->flash_timeout = fled_cdev->timeout.val;
 }
 
+static int max77693_register_led(struct max77693_sub_led *sub_led,
+				 struct max77693_led_config_data *led_cfg,
+				 struct device_node *sub_node)
+{
+	struct max77693_led_device *led = sub_led_to_led(sub_led);
+	struct led_classdev_flash *fled_cdev = &sub_led->fled_cdev;
+	struct device *dev = &led->pdev->dev;
+	struct v4l2_flash_config v4l2_sd_cfg = {};
+	int ret;
+
+	/* Register in the LED subsystem */
+	ret = led_classdev_flash_register(dev, fled_cdev);
+	if (ret < 0)
+		return ret;
+
+	max77693_init_v4l2_flash_config(sub_led, led_cfg, &v4l2_sd_cfg);
+
+	/* Register in the V4L2 subsystem. */
+	sub_led->v4l2_flash = v4l2_flash_init(dev, sub_node, fled_cdev,
+					      &v4l2_flash_ops, &v4l2_sd_cfg);
+	if (IS_ERR(sub_led->v4l2_flash)) {
+		ret = PTR_ERR(sub_led->v4l2_flash);
+		goto err_v4l2_flash_init;
+	}
+
+	return 0;
+
+err_v4l2_flash_init:
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
+	struct device_node *sub_nodes[2] = {};
 	struct max77693_led_config_data led_cfg = {};
 	int init_fled_cdev[2], i, ret;
 
@@ -889,7 +999,7 @@ static int max77693_led_probe(struct platform_device *pdev)
 	sub_leds = led->sub_leds;
 
 	platform_set_drvdata(pdev, led);
-	ret = max77693_led_get_configuration(led, &led_cfg);
+	ret = max77693_led_get_configuration(led, &led_cfg, sub_nodes);
 	if (ret < 0)
 		return ret;
 
@@ -911,8 +1021,12 @@ static int max77693_led_probe(struct platform_device *pdev)
 		/* Initialize LED Flash class device */
 		max77693_init_fled_cdev(&sub_leds[i], &led_cfg);
 
-		/* Register LED Flash class device */
-		ret = led_classdev_flash_register(dev, &sub_leds[i].fled_cdev);
+		/*
+		 * Register LED Flash class device and corresponding
+		 * V4L2 Flash device.
+		 */
+		ret = max77693_register_led(&sub_leds[i], &led_cfg,
+						sub_nodes[i]);
 		if (ret < 0) {
 			/*
 			 * At this moment FLED1 might have been already
@@ -931,6 +1045,7 @@ err_register_led2:
 	/* It is possible than only FLED2 was to be registered */
 	if (!init_fled_cdev[FLED1])
 		goto err_register_led1;
+	v4l2_flash_release(sub_leds[FLED1].v4l2_flash);
 	led_classdev_flash_unregister(&sub_leds[FLED1].fled_cdev);
 err_register_led1:
 	mutex_destroy(&led->lock);
@@ -944,11 +1059,13 @@ static int max77693_led_remove(struct platform_device *pdev)
 	struct max77693_sub_led *sub_leds = led->sub_leds;
 
 	if (led->iout_joint || max77693_fled_used(led, FLED1)) {
+		v4l2_flash_release(sub_leds[FLED1].v4l2_flash);
 		led_classdev_flash_unregister(&sub_leds[FLED1].fled_cdev);
 		cancel_work_sync(&sub_leds[FLED1].work_brightness_set);
 	}
 
 	if (!led->iout_joint && max77693_fled_used(led, FLED2)) {
+		v4l2_flash_release(sub_leds[FLED2].v4l2_flash);
 		led_classdev_flash_unregister(&sub_leds[FLED2].fled_cdev);
 		cancel_work_sync(&sub_leds[FLED2].work_brightness_set);
 	}
-- 
1.7.9.5

