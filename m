Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:39880 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535AbbCaNyl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Mar 2015 09:54:41 -0400
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
	rpurdie@rpsys.net, sakari.ailus@iki.fi, s.nawrocki@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH v4 05/12] leds: Add driver for AAT1290 flash LED controller
Date: Tue, 31 Mar 2015 15:52:41 +0200
Message-id: <1427809965-25540-6-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1427809965-25540-1-git-send-email-j.anaszewski@samsung.com>
References: <1427809965-25540-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds a driver for the 1.5A Step-Up Current Regulator
for Flash LEDs. The device is programmed through a Skyworks proprietary
AS2Cwire serial digital interface.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Bryan Wu <cooloney@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 drivers/leds/Kconfig        |    8 +
 drivers/leds/Makefile       |    1 +
 drivers/leds/leds-aat1290.c |  372 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 381 insertions(+)
 create mode 100644 drivers/leds/leds-aat1290.c

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index f9fbeb5..c3b5b027 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -42,6 +42,14 @@ config LEDS_88PM860X
 	  This option enables support for on-chip LED drivers found on Marvell
 	  Semiconductor 88PM8606 PMIC.
 
+config LEDS_AAT1290
+	tristate "LED support for the AAT1290"
+	depends on LEDS_CLASS_FLASH
+	depends on GPIOLIB
+	depends on OF
+	help
+	 This option enables support for the LEDs on the AAT1290.
+
 config LEDS_LM3530
 	tristate "LCD Backlight driver for LM3530"
 	depends on LEDS_CLASS
diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
index 9413fdb..0b3fd0e 100644
--- a/drivers/leds/Makefile
+++ b/drivers/leds/Makefile
@@ -7,6 +7,7 @@ obj-$(CONFIG_LEDS_TRIGGERS)		+= led-triggers.o
 
 # LED Platform Drivers
 obj-$(CONFIG_LEDS_88PM860X)		+= leds-88pm860x.o
+obj-$(CONFIG_LEDS_AAT1290)		+= leds-aat1290.o
 obj-$(CONFIG_LEDS_BD2802)		+= leds-bd2802.o
 obj-$(CONFIG_LEDS_LOCOMO)		+= leds-locomo.o
 obj-$(CONFIG_LEDS_LM3530)		+= leds-lm3530.o
diff --git a/drivers/leds/leds-aat1290.c b/drivers/leds/leds-aat1290.c
new file mode 100644
index 0000000..acfae35
--- /dev/null
+++ b/drivers/leds/leds-aat1290.c
@@ -0,0 +1,372 @@
+/*
+ *	LED Flash class driver for the AAT1290
+ *	1.5A Step-Up Current Regulator for Flash LEDs
+ *
+ *	Copyright (C) 2015, Samsung Electronics Co., Ltd.
+ *	Author: Jacek Anaszewski <j.anaszewski@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ */
+
+#include <linux/delay.h>
+#include <linux/gpio/consumer.h>
+#include <linux/led-class-flash.h>
+#include <linux/leds.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/workqueue.h>
+
+#define AAT1290_MOVIE_MODE_CURRENT_ADDR	17
+#define AAT1290_MAX_MM_CURR_PERCENT_0	16
+#define AAT1290_MAX_MM_CURR_PERCENT_100	1
+
+#define AAT1290_FLASH_SAFETY_TIMER_ADDR	18
+
+#define AAT1290_MOVIE_MODE_CONFIG_ADDR	19
+#define AAT1290_MOVIE_MODE_OFF		1
+#define AAT1290_MOVIE_MODE_ON		3
+
+#define AAT1290_MM_CURRENT_RATIO_ADDR	20
+#define AAT1290_MM_TO_FL_1_92		1
+
+#define AAT1290_MM_TO_FL_RATIO		1000 / 1920
+#define AAT1290_MAX_MM_CURRENT(fl_max)	(fl_max * AAT1290_MM_TO_FL_RATIO)
+
+#define AAT1290_LATCH_TIME_MIN_US	500
+#define AAT1290_LATCH_TIME_MAX_US	1000
+#define AAT1290_EN_SET_TICK_TIME_US	1
+#define AAT1290_FLEN_OFF_DELAY_TIME_US	10
+#define AAT1290_FLASH_TM_NUM_LEVELS	16
+#define AAT1290_MM_CURRENT_SCALE_SIZE	15
+
+
+struct aat1290_led {
+	/* platform device data */
+	struct platform_device *pdev;
+	/* secures access to the device */
+	struct mutex lock;
+
+	/* corresponding LED Flash class device */
+	struct led_classdev_flash fled_cdev;
+
+	/* FLEN pin */
+	struct gpio_desc *gpio_fl_en;
+	/* EN|SET pin  */
+	struct gpio_desc *gpio_en_set;
+
+	/* maximum flash timeout */
+	u32 max_flash_tm;
+	/* maximum LED current in flash mode */
+	u32 max_flash_current;
+	/* device mode */
+	bool movie_mode;
+
+	/* brightness cache */
+	unsigned int torch_brightness;
+	/* assures led-triggers compatibility */
+	struct work_struct work_brightness_set;
+};
+
+static struct aat1290_led *fled_cdev_to_led(
+				struct led_classdev_flash *fled_cdev)
+{
+	return container_of(fled_cdev, struct aat1290_led, fled_cdev);
+}
+
+static void aat1290_as2cwire_write(struct aat1290_led *led, int addr, int value)
+{
+	int i;
+
+	gpiod_direction_output(led->gpio_fl_en, 0);
+	gpiod_direction_output(led->gpio_en_set, 0);
+
+	udelay(AAT1290_FLEN_OFF_DELAY_TIME_US);
+
+	/* write address */
+	for (i = 0; i < addr; ++i) {
+		udelay(AAT1290_EN_SET_TICK_TIME_US);
+		gpiod_direction_output(led->gpio_en_set, 0);
+		udelay(AAT1290_EN_SET_TICK_TIME_US);
+		gpiod_direction_output(led->gpio_en_set, 1);
+	}
+
+	usleep_range(AAT1290_LATCH_TIME_MIN_US, AAT1290_LATCH_TIME_MAX_US);
+
+	/* write data */
+	for (i = 0; i < value; ++i) {
+		udelay(AAT1290_EN_SET_TICK_TIME_US);
+		gpiod_direction_output(led->gpio_en_set, 0);
+		udelay(AAT1290_EN_SET_TICK_TIME_US);
+		gpiod_direction_output(led->gpio_en_set, 1);
+	}
+
+	usleep_range(AAT1290_LATCH_TIME_MIN_US, AAT1290_LATCH_TIME_MAX_US);
+}
+
+static void aat1290_set_flash_safety_timer(struct aat1290_led *led,
+					unsigned int micro_sec)
+{
+	struct led_classdev_flash *fled_cdev = &led->fled_cdev;
+	struct led_flash_setting *flash_tm = &fled_cdev->timeout;
+	int flash_tm_reg = AAT1290_FLASH_TM_NUM_LEVELS -
+				(micro_sec / flash_tm->step) + 1;
+
+	aat1290_as2cwire_write(led, AAT1290_FLASH_SAFETY_TIMER_ADDR,
+							flash_tm_reg);
+}
+
+static void aat1290_brightness_set(struct aat1290_led *led,
+					enum led_brightness brightness)
+{
+	mutex_lock(&led->lock);
+
+	if (brightness == 0) {
+		gpiod_direction_output(led->gpio_fl_en, 0);
+		gpiod_direction_output(led->gpio_en_set, 0);
+		led->movie_mode = false;
+		goto unlock;
+	}
+
+	if (!led->movie_mode) {
+		aat1290_as2cwire_write(led, AAT1290_MM_CURRENT_RATIO_ADDR,
+					AAT1290_MM_TO_FL_1_92);
+		led->movie_mode = true;
+	}
+
+	aat1290_as2cwire_write(led, AAT1290_MOVIE_MODE_CURRENT_ADDR,
+				AAT1290_MAX_MM_CURR_PERCENT_0 - brightness);
+	aat1290_as2cwire_write(led, AAT1290_MOVIE_MODE_CONFIG_ADDR,
+				AAT1290_MOVIE_MODE_ON);
+unlock:
+	mutex_unlock(&led->lock);
+}
+
+/* LED subsystem callbacks */
+
+static void aat1290_brightness_set_work(struct work_struct *work)
+{
+	struct aat1290_led *led =
+		container_of(work, struct aat1290_led, work_brightness_set);
+
+	aat1290_brightness_set(led, led->torch_brightness);
+}
+
+static void aat1290_led_brightness_set(struct led_classdev *led_cdev,
+					enum led_brightness brightness)
+{
+	struct led_classdev_flash *fled_cdev = lcdev_to_flcdev(led_cdev);
+	struct aat1290_led *led = fled_cdev_to_led(fled_cdev);
+
+	led->torch_brightness = brightness;
+	schedule_work(&led->work_brightness_set);
+}
+
+static int aat1290_led_brightness_set_sync(struct led_classdev *led_cdev,
+					enum led_brightness brightness)
+{
+	struct led_classdev_flash *fled_cdev = lcdev_to_flcdev(led_cdev);
+	struct aat1290_led *led = fled_cdev_to_led(fled_cdev);
+
+	aat1290_brightness_set(led, brightness);
+
+	return 0;
+}
+
+static int aat1290_led_flash_strobe_set(struct led_classdev_flash *fled_cdev,
+					 bool state)
+
+{
+	struct aat1290_led *led = fled_cdev_to_led(fled_cdev);
+	struct led_classdev *led_cdev = &fled_cdev->led_cdev;
+	struct led_flash_setting *timeout = &fled_cdev->timeout;
+
+	mutex_lock(&led->lock);
+
+	if (state == 0) {
+		gpiod_direction_output(led->gpio_fl_en, 0);
+		gpiod_direction_output(led->gpio_en_set, 0);
+		goto done;
+	}
+
+	aat1290_set_flash_safety_timer(led, timeout->val);
+
+	gpiod_direction_output(led->gpio_fl_en, 1);
+
+done:
+	/*
+	 * To reenter movie mode after a flash event the part must be cycled
+	 * off and back on to reset the movie mode and reprogrammed via the
+	 * AS2Cwire. Therefore the brightness and movie_mode properties needs
+	 * to be updated here to reflect the actual state.
+	 */
+	led_cdev->brightness = 0;
+	led->movie_mode = false;
+
+	mutex_unlock(&led->lock);
+
+	return 0;
+}
+
+static int aat1290_led_flash_timeout_set(struct led_classdev_flash *fled_cdev,
+						u32 timeout)
+{
+	/*
+	 * Don't do anything - flash timeout is cached in the led-class-flash
+	 * core and will be applied in the strobe_set op, as writing the
+	 * safety timer register spuriously turns the torch mode on.
+	 */
+
+	return 0;
+}
+
+static int aat1290_led_parse_dt(struct aat1290_led *led)
+{
+	struct led_classdev *led_cdev = &led->fled_cdev.led_cdev;
+	struct device *dev = &led->pdev->dev;
+	struct device_node *child_node;
+	int ret = 0;
+
+	led->gpio_fl_en = devm_gpiod_get(dev, "flen");
+	if (IS_ERR(led->gpio_fl_en)) {
+		ret = PTR_ERR(led->gpio_fl_en);
+		dev_err(dev, "Unable to claim gpio \"flen\".\n");
+		return ret;
+	}
+
+	led->gpio_en_set = devm_gpiod_get(dev, "enset");
+	if (IS_ERR(led->gpio_en_set)) {
+		ret = PTR_ERR(led->gpio_en_set);
+		dev_err(dev, "Unable to claim gpio \"enset\".\n");
+		return ret;
+	}
+
+	child_node = of_get_next_available_child(dev->of_node, NULL);
+	if (!child_node) {
+		dev_err(dev, "No DT child node found for connected LED.\n");
+		return -EINVAL;
+	}
+
+	led_cdev->name = of_get_property(child_node, "label", NULL) ? :
+						child_node->name;
+
+	ret = of_property_read_u32(child_node, "flash-max-microamp",
+				&led->max_flash_current);
+	if (ret < 0) {
+		dev_err(dev,
+			"Error reading \"flash-max-microamp\" DT property\n");
+		return ret;
+	}
+
+	ret = of_property_read_u32(child_node, "flash-timeout-us",
+				&led->max_flash_tm);
+	if (ret < 0) {
+		dev_err(dev,
+			"Error reading \"flash-timeout-us\" DT property\n");
+		return ret;
+	}
+
+	return ret;
+}
+
+static void aat1290_init_flash_timeout(struct aat1290_led *led)
+{
+	struct led_classdev_flash *fled_cdev = &led->fled_cdev;
+	struct led_flash_setting *setting;
+
+	/* Init flash timeout setting */
+	setting = &fled_cdev->timeout;
+	setting->min = led->max_flash_tm / AAT1290_FLASH_TM_NUM_LEVELS;
+	setting->max = setting->min * AAT1290_FLASH_TM_NUM_LEVELS;
+	setting->step = setting->min;
+	setting->val = setting->max;
+}
+
+static const struct led_flash_ops flash_ops = {
+	.strobe_set = aat1290_led_flash_strobe_set,
+	.timeout_set = aat1290_led_flash_timeout_set,
+};
+
+static int aat1290_led_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct aat1290_led *led;
+	struct led_classdev *led_cdev;
+	struct led_classdev_flash *fled_cdev;
+	int ret;
+
+	led = devm_kzalloc(dev, sizeof(*led), GFP_KERNEL);
+	if (!led)
+		return -ENOMEM;
+
+	led->pdev = pdev;
+	platform_set_drvdata(pdev, led);
+
+	fled_cdev = &led->fled_cdev;
+	fled_cdev->ops = &flash_ops;
+	led_cdev = &fled_cdev->led_cdev;
+
+	ret = aat1290_led_parse_dt(led);
+	if (ret < 0)
+		return ret;
+
+	mutex_init(&led->lock);
+
+	/* Initialize LED Flash class device */
+	led_cdev->brightness_set = aat1290_led_brightness_set;
+	led_cdev->brightness_set_sync = aat1290_led_brightness_set_sync;
+	led_cdev->max_brightness = AAT1290_MM_CURRENT_SCALE_SIZE;
+	led_cdev->flags |= LED_DEV_CAP_FLASH;
+	INIT_WORK(&led->work_brightness_set, aat1290_brightness_set_work);
+
+	aat1290_init_flash_timeout(led);
+
+	/* Register LED Flash class device */
+	ret = led_classdev_flash_register(&pdev->dev, fled_cdev);
+	if (ret < 0)
+		goto err_flash_register;
+
+	return 0;
+
+err_flash_register:
+	mutex_destroy(&led->lock);
+
+	return ret;
+}
+
+static int aat1290_led_remove(struct platform_device *pdev)
+{
+	struct aat1290_led *led = platform_get_drvdata(pdev);
+
+	led_classdev_flash_unregister(&led->fled_cdev);
+	cancel_work_sync(&led->work_brightness_set);
+
+	mutex_destroy(&led->lock);
+
+	return 0;
+}
+
+static const struct of_device_id aat1290_led_dt_match[] = {
+	{ .compatible = "skyworks,aat1290" },
+	{},
+};
+
+static struct platform_driver aat1290_led_driver = {
+	.probe		= aat1290_led_probe,
+	.remove		= aat1290_led_remove,
+	.driver		= {
+		.name	= "aat1290",
+		.owner	= THIS_MODULE,
+		.of_match_table = aat1290_led_dt_match,
+	},
+};
+
+module_platform_driver(aat1290_led_driver);
+
+MODULE_AUTHOR("Jacek Anaszewski <j.anaszewski@samsung.com>");
+MODULE_DESCRIPTION("Skyworks Current Regulator for Flash LEDs");
+MODULE_LICENSE("GPL v2");
-- 
1.7.9.5

