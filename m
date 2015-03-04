Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:13763 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933527AbbCDQRU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Mar 2015 11:17:20 -0500
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
	kyungmin.park@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
	rpurdie@rpsys.net, sakari.ailus@iki.fi, s.nawrocki@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH/RFC v12 19/19] leds: aat1290: add support for V4L2 Flash
 sub-device
Date: Wed, 04 Mar 2015 17:14:40 +0100
Message-id: <1425485680-8417-20-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1425485680-8417-1-git-send-email-j.anaszewski@samsung.com>
References: <1425485680-8417-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for V4L2 Flash sub-device to the aat1290 LED Flash class
driver. The support allows for V4L2 Flash sub-device to take the control
of the LED Flash class device.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Bryan Wu <cooloney@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/leds/Kconfig        |    1 +
 drivers/leds/leds-aat1290.c |  165 ++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 164 insertions(+), 2 deletions(-)

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
index 1c2d490..7e6b5d8 100644
--- a/drivers/leds/leds-aat1290.c
+++ b/drivers/leds/leds-aat1290.c
@@ -18,8 +18,10 @@
 #include <linux/mutex.h>
 #include <linux/of.h>
 #include <linux/of_gpio.h>
+#include <linux/pinctrl/consumer.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
+#include <media/v4l2-flash.h>
 #include <linux/workqueue.h>
 
 #define AAT1290_MOVIE_MODE_CURRENT_ADDR	17
@@ -60,11 +62,17 @@ struct aat1290_led {
 
 	/* related LED Flash class device */
 	struct led_classdev_flash fled_cdev;
+	/* V4L2 Flash device */
+	struct v4l2_flash *v4l2_flash;
 
 	/* FLEN pin */
 	int flen_gpio;
 	/* EN|SET pin  */
 	int en_set_gpio;
+#if IS_ENABLED(CONFIG_V4L2_FLASH_LED_CLASS)
+	/* movie mode current scale */
+	int *mm_current_scale;
+#endif
 
 	/* maximum flash timeout */
 	u32 max_flash_tm;
@@ -234,10 +242,12 @@ static int aat1290_led_flash_timeout_set(struct led_classdev_flash *fled_cdev,
 
 static int aat1290_led_parse_dt(struct aat1290_led *led,
 				struct device *dev,
-				const char **led_label)
+				const char **led_label,
+				struct v4l2_flash_ctrl_config *config)
 {
 	struct device_node *node = dev->of_node, *child_node;
 	int flen_gpio, enset_gpio, cnt_leds = 0, ret;
+	struct pinctrl *pinctrl;
 
 	flen_gpio = of_get_gpio(node, 0);
 	if (gpio_is_valid(flen_gpio)) {
@@ -269,6 +279,17 @@ static int aat1290_led_parse_dt(struct aat1290_led *led,
 	}
 	led->en_set_gpio = enset_gpio;
 
+#if IS_ENABLED(CONFIG_V4L2_FLASH_LED_CLASS)
+	pinctrl = devm_pinctrl_get_select_default(&led->pdev->dev);
+	if (IS_ERR(pinctrl)) {
+		config->has_external_strobe = false;
+		dev_info(dev,
+			 "No support for external strobe source detected.\n");
+	} else {
+		config->has_external_strobe = true;
+	}
+#endif
+
 	for_each_available_child_of_node(node, child_node) {
 		ret = of_property_read_string(child_node, "label",
 					(const char **) led_label);
@@ -312,6 +333,15 @@ static void aat1290_init_flash_settings(struct aat1290_led *led,
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
@@ -320,6 +350,101 @@ static void aat1290_init_flash_settings(struct aat1290_led *led,
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
+	struct pinctrl *pinctrl;
+
+	led->movie_mode = false;
+	gpio_set_value(led->flen_gpio, 0);
+	gpio_set_value(led->en_set_gpio, 0);
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
@@ -332,6 +457,9 @@ static int aat1290_led_probe(struct platform_device *pdev)
 	struct aat1290_led *led;
 	struct led_classdev *led_cdev;
 	struct led_classdev_flash *fled_cdev;
+#if IS_ENABLED(CONFIG_V4L2_FLASH_LED_CLASS)
+	struct v4l2_flash_ctrl_config v4l2_flash_config = {};
+#endif
 	struct aat1290_led_settings settings;
 	int ret;
 
@@ -348,13 +476,25 @@ static int aat1290_led_probe(struct platform_device *pdev)
 	fled_cdev = &led->fled_cdev;
 	led_cdev = &fled_cdev->led_cdev;
 
-	ret = aat1290_led_parse_dt(led, &pdev->dev, &led_cdev->name);
+	ret = aat1290_led_parse_dt(led, &pdev->dev, &led_cdev->name,
+							&v4l2_flash_config);
+	if (ret < 0)
+		return ret;
+
+	/*
+	 * Initialize non-linear movie mode current scale basing
+	 * on the max flash current from Device Tree binding.
+	 */
+	ret = init_mm_current_scale(led);
 	if (ret < 0)
 		return ret;
 
 	/* Init flash settings */
 	aat1290_init_flash_settings(led, &settings);
 
+	/* Init V4L2 Flash controls basing on initialized settings */
+	aat1290_init_v4l2_ctrl_config(led, &settings, &v4l2_flash_config);
+
 	fled_cdev->timeout = settings.flash_timeout;
 	fled_cdev->ops = &flash_ops;
 
@@ -373,13 +513,34 @@ static int aat1290_led_probe(struct platform_device *pdev)
 
 	mutex_init(&led->lock);
 
+	of_node_get(dev_node);
+	led_cdev->dev->of_node = dev_node;
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
+	of_node_put(dev_node);
+	led_classdev_flash_unregister(fled_cdev);
+	mutex_destroy(&led->lock);
+
+	return ret;
 }
 
 static int aat1290_led_remove(struct platform_device *pdev)
 {
 	struct aat1290_led *led = platform_get_drvdata(pdev);
 
+	v4l2_flash_release(led->v4l2_flash);
+	of_node_put(led->fled_cdev.led_cdev.dev->of_node);
 	led_classdev_flash_unregister(&led->fled_cdev);
 	cancel_work_sync(&led->work_brightness_set);
 
-- 
1.7.9.5

