Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:36113 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932488AbbCLPrV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Mar 2015 11:47:21 -0400
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: kyungmin.park@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
	rpurdie@rpsys.net, sakari.ailus@iki.fi, s.nawrocki@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH/RFC v13 13/13] leds: aat1290: add support for V4L2 Flash
 sub-device
Date: Thu, 12 Mar 2015 16:45:14 +0100
Message-id: <1426175114-14876-14-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1426175114-14876-1-git-send-email-j.anaszewski@samsung.com>
References: <1426175114-14876-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for V4L2 Flash sub-device to the aat1290 LED Flash class
driver. The support allows for V4L2 Flash sub-device to take the control
of the LED Flash class device.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Bryan Wu <cooloney@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/leds/Kconfig        |    1 +
 drivers/leds/leds-aat1290.c |  186 ++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 185 insertions(+), 2 deletions(-)

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index 6e141d6..986876e 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -46,6 +46,7 @@ config LEDS_AAT1290
 	tristate "LED support for the AAT1290"
 	depends on LEDS_CLASS_FLASH
 	depends on OF
+	depends on PINCTRL
 	help
 	 This option enables support for the LEDs on the AAT1290.
 
diff --git a/drivers/leds/leds-aat1290.c b/drivers/leds/leds-aat1290.c
index 456f9a9d..6100b6b 100644
--- a/drivers/leds/leds-aat1290.c
+++ b/drivers/leds/leds-aat1290.c
@@ -17,9 +17,11 @@
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/of.h>
+#include <linux/pinctrl/consumer.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 #include <linux/workqueue.h>
+#include <media/v4l2-flash.h>
 
 #define AAT1290_MOVIE_MODE_CURRENT_ADDR	17
 #define AAT1290_MAX_MM_CURR_PERCENT_0	16
@@ -46,6 +48,11 @@
 
 #define AAT1290_NAME			"aat1290"
 
+#if IS_ENABLED(CONFIG_V4L2_FLASH_LED_CLASS)
+/* Number of AAT1290 devices in the system. */
+static unsigned int dev_count;
+#endif
+
 
 struct aat1290_led_settings {
 	struct led_flash_setting torch_brightness;
@@ -60,11 +67,17 @@ struct aat1290_led {
 
 	/* related LED Flash class device */
 	struct led_classdev_flash fled_cdev;
+	/* V4L2 Flash device */
+	struct v4l2_flash *v4l2_flash;
 
 	/* FLEN pin */
 	struct gpio_desc *gpio_fl_en;
 	/* EN|SET pin  */
 	struct gpio_desc *gpio_en_set;
+#if IS_ENABLED(CONFIG_V4L2_FLASH_LED_CLASS)
+	/* movie mode current scale */
+	int *mm_current_scale;
+#endif
 
 	/* maximum flash timeout */
 	u32 max_flash_tm;
@@ -231,11 +244,16 @@ static int aat1290_led_flash_timeout_set(struct led_classdev_flash *fled_cdev,
 	return 0;
 }
 
-static int aat1290_led_parse_dt(struct aat1290_led *led)
+static int aat1290_led_parse_dt(struct aat1290_led *led,
+			struct device_node **sub_node,
+			struct v4l2_flash_ctrl_config *v4l2_flash_config)
 {
 	struct led_classdev *led_cdev = &led->fled_cdev.led_cdev;
 	struct device *dev = &led->pdev->dev;
 	struct device_node *child_node;
+#if IS_ENABLED(CONFIG_V4L2_FLASH_LED_CLASS)
+	struct pinctrl *pinctrl;
+#endif
 	int ret = 0;
 
 	led->gpio_fl_en = devm_gpiod_get(dev, "flen");
@@ -252,6 +270,17 @@ static int aat1290_led_parse_dt(struct aat1290_led *led)
 		return ret;
 	}
 
+#if IS_ENABLED(CONFIG_V4L2_FLASH_LED_CLASS)
+	pinctrl = devm_pinctrl_get_select_default(&led->pdev->dev);
+	if (IS_ERR(pinctrl)) {
+		v4l2_flash_config->has_external_strobe = false;
+		dev_info(dev,
+			 "No support for external strobe detected.\n");
+	} else {
+		v4l2_flash_config->has_external_strobe = true;
+	}
+#endif
+
 	child_node = of_get_next_available_child(dev->of_node, NULL);
 	if (!child_node) {
 		dev_err(dev, "No DT child node found for connected LED.\n");
@@ -277,6 +306,8 @@ static int aat1290_led_parse_dt(struct aat1290_led *led)
 		return ret;
 	}
 
+	*sub_node = child_node;
+
 	return ret;
 }
 
@@ -285,6 +316,15 @@ static void aat1290_init_flash_settings(struct aat1290_led *led,
 {
 	struct led_flash_setting *setting;
 
+#if IS_ENABLED(CONFIG_V4L2_FLASH_LED_CLASS)
+	/* Init flash intensity setting */
+	setting = &s->torch_brightness;
+	setting->min = led->mm_current_scale[0];
+	setting->max = led->mm_current_scale[AAT1290_MM_CURRENT_SCALE_SIZE - 1];
+	setting->step = 1;
+	setting->val = setting->max;
+#endif
+
 	/* Init flash timeout setting */
 	setting = &s->flash_timeout;
 	setting->min = led->max_flash_tm / AAT1290_FLASH_TM_NUM_LEVELS;
@@ -293,6 +333,113 @@ static void aat1290_init_flash_settings(struct aat1290_led *led,
 	setting->val = setting->max;
 }
 
+#if IS_ENABLED(CONFIG_V4L2_FLASH_LED_CLASS)
+enum led_brightness aat1290_intensity_to_brightness(
+					struct v4l2_flash *v4l2_flash,
+					s32 intensity)
+{
+	struct led_classdev_flash *fled_cdev = v4l2_flash->fled_cdev;
+	struct aat1290_led *led = fled_cdev_to_led(fled_cdev);
+	int i;
+
+	for (i = AAT1290_MM_CURRENT_SCALE_SIZE - 1; i >= 0; --i)
+		if (intensity >= led->mm_current_scale[i])
+			return i + 1;
+
+	return 1;
+}
+
+s32 aat1290_brightness_to_intensity(struct v4l2_flash *v4l2_flash,
+					enum led_brightness brightness)
+{
+	struct led_classdev_flash *fled_cdev = v4l2_flash->fled_cdev;
+	struct aat1290_led *led = fled_cdev_to_led(fled_cdev);
+
+	return led->mm_current_scale[brightness - 1];
+}
+
+static int aat1290_led_external_strobe_set(struct v4l2_flash *v4l2_flash,
+						bool enable)
+{
+	struct aat1290_led *led = fled_cdev_to_led(v4l2_flash->fled_cdev);
+	struct led_classdev_flash *fled_cdev = v4l2_flash->fled_cdev;
+	struct led_classdev *led_cdev = &fled_cdev->led_cdev;
+	struct pinctrl *pinctrl;
+
+	gpiod_direction_output(led->gpio_fl_en, 0);
+	gpiod_direction_output(led->gpio_en_set, 0);
+
+	led->movie_mode = false;
+	led_cdev->brightness = 0;
+
+	pinctrl = devm_pinctrl_get_select(&led->pdev->dev,
+						enable ? "isp" : "host");
+	if (IS_ERR(pinctrl)) {
+		dev_warn(&led->pdev->dev, "Unable to switch strobe source.\n");
+		return PTR_ERR(pinctrl);
+	}
+
+	return 0;
+}
+
+int init_mm_current_scale(struct aat1290_led *led)
+{
+	int max_mm_current_percent[] = { 20, 22, 25, 28, 32, 36, 40, 45, 50, 56,
+						63, 71, 79, 89, 100 };
+	int i, max_mm_current = AAT1290_MAX_MM_CURRENT(led->max_flash_current);
+
+	led->mm_current_scale = devm_kzalloc(&led->pdev->dev,
+						sizeof(max_mm_current_percent),
+						GFP_KERNEL);
+	if (!led->mm_current_scale)
+		return -ENOMEM;
+
+	for (i = 0; i < AAT1290_MM_CURRENT_SCALE_SIZE; ++i)
+		led->mm_current_scale[i] = max_mm_current *
+					  max_mm_current_percent[i] / 100;
+
+	return 0;
+}
+
+static void aat1290_init_v4l2_ctrl_config(struct aat1290_led *led,
+					struct aat1290_led_settings *s,
+					struct v4l2_flash_ctrl_config *config)
+{
+	struct led_flash_setting *setting;
+	struct v4l2_ctrl_config *c;
+	char suffix[10];
+
+	if (++dev_count > 1)
+		snprintf(suffix, sizeof(suffix), "_%d", dev_count);
+
+	snprintf(config->dev_name, sizeof(config->dev_name), "%s%s",
+		 AAT1290_NAME, dev_count > 1 ? suffix : "");
+
+	c = &config->intensity;
+	setting = &s->torch_brightness;
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
+}
+
+static const struct v4l2_flash_ops v4l2_flash_ops = {
+	.external_strobe_set = aat1290_led_external_strobe_set,
+	.intensity_to_led_brightness = aat1290_intensity_to_brightness,
+	.led_brightness_to_intensity = aat1290_brightness_to_intensity,
+};
+#else
+#define aat1290_init_v4l2_ctrl_config(led, s, config)
+#define init_mm_current_scale(led) (0)
+#endif
+
 static const struct led_flash_ops flash_ops = {
 	.strobe_set = aat1290_led_flash_strobe_set,
 	.timeout_set = aat1290_led_flash_timeout_set,
@@ -301,10 +448,12 @@ static const struct led_flash_ops flash_ops = {
 static int aat1290_led_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
+	struct device_node *sub_node = NULL;
 	struct aat1290_led *led;
 	struct led_classdev *led_cdev;
 	struct led_classdev_flash *fled_cdev;
 	struct aat1290_led_settings settings;
+	struct v4l2_flash_ctrl_config v4l2_flash_config = {};
 	int ret;
 
 	led = devm_kzalloc(dev, sizeof(*led), GFP_KERNEL);
@@ -317,16 +466,27 @@ static int aat1290_led_probe(struct platform_device *pdev)
 	fled_cdev = &led->fled_cdev;
 	led_cdev = &fled_cdev->led_cdev;
 
-	ret = aat1290_led_parse_dt(led);
+	ret = aat1290_led_parse_dt(led, &sub_node, &v4l2_flash_config);
 	if (ret < 0)
 		return ret;
 
 	if (!led_cdev->name)
 		led_cdev->name = AAT1290_NAME;
 
+	/*
+	 * Init non-linear movie mode current scale basing
+	 * on the max flash current from Device Tree binding.
+	 */
+	ret = init_mm_current_scale(led);
+	if (ret < 0)
+		return ret;
+
 	/* Init flash settings */
 	aat1290_init_flash_settings(led, &settings);
 
+	/* Init V4L2 Flash controls basing on initialized settings */
+	aat1290_init_v4l2_ctrl_config(led, &settings, &v4l2_flash_config);
+
 	fled_cdev->timeout = settings.flash_timeout;
 	fled_cdev->ops = &flash_ops;
 
@@ -345,18 +505,40 @@ static int aat1290_led_probe(struct platform_device *pdev)
 
 	mutex_init(&led->lock);
 
+	led_cdev->dev->of_node = sub_node;
+
+	/* Create V4L2 Flash subdev. */
+	led->v4l2_flash = v4l2_flash_init(fled_cdev,
+					  &v4l2_flash_ops,
+					  &v4l2_flash_config);
+	if (IS_ERR(led->v4l2_flash)) {
+		ret = PTR_ERR(led->v4l2_flash);
+		goto error_v4l2_flash_init;
+	}
+
 	return 0;
+
+error_v4l2_flash_init:
+	led_classdev_flash_unregister(fled_cdev);
+	mutex_destroy(&led->lock);
+
+	return ret;
 }
 
 static int aat1290_led_remove(struct platform_device *pdev)
 {
 	struct aat1290_led *led = platform_get_drvdata(pdev);
 
+	v4l2_flash_release(led->v4l2_flash);
 	led_classdev_flash_unregister(&led->fled_cdev);
 	cancel_work_sync(&led->work_brightness_set);
 
 	mutex_destroy(&led->lock);
 
+#if IS_ENABLED(CONFIG_V4L2_FLASH_LED_CLASS)
+	--dev_count;
+#endif
+
 	return 0;
 }
 
-- 
1.7.9.5

