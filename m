Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:49840 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbbD3KfW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Apr 2015 06:35:22 -0400
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
	rpurdie@rpsys.net, sakari.ailus@iki.fi, s.nawrocki@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Andrzej Hajda <a.hajda@samsung.com>
Subject: [PATCH v7] leds: Add support for max77693 mfd flash cell
Date: Thu, 30 Apr 2015 12:35:10 +0200
Message-id: <1430390110-7194-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds led-flash support to Maxim max77693 chipset.
A device can be exposed to user space through LED subsystem
sysfs interface. Device supports up to two leds which can
work in flash and torch mode. The leds can be triggered
externally or by software.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Bryan Wu <cooloney@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
Fixed issues reported by 0-DAY kernel test infrastructure:

- drivers/leds/leds-max77693.c:978:3-8: No need to set .owner here. The core will do it.
	* removed the line
- drivers/leds/leds-max77693.c:193 max77693_add_mode() warn: maybe use && instead of &
  	* redesigned max77693_add_mode function


 drivers/leds/Kconfig         |   10 +
 drivers/leds/Makefile        |    1 +
 drivers/leds/leds-max77693.c |  980 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 991 insertions(+)
 create mode 100644 drivers/leds/leds-max77693.c

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index a38b17a..62be033 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -475,6 +475,16 @@ config LEDS_TLC591XX
 	  This option enables support for Texas Instruments TLC59108
 	  and TLC59116 LED controllers.
 
+config LEDS_MAX77693
+	tristate "LED support for MAX77693 Flash"
+	depends on LEDS_CLASS_FLASH
+	depends on MFD_MAX77693
+	depends on OF
+	help
+	  This option enables support for the flash part of the MAX77693
+	  multifunction device. It has build in control for two leds in flash
+	  and torch mode.
+
 config LEDS_MAX8997
 	tristate "LED support for MAX8997 PMIC"
 	depends on LEDS_CLASS && MFD_MAX8997
diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
index 749dbe3..8bddae6 100644
--- a/drivers/leds/Makefile
+++ b/drivers/leds/Makefile
@@ -53,6 +53,7 @@ obj-$(CONFIG_LEDS_MC13783)		+= leds-mc13783.o
 obj-$(CONFIG_LEDS_NS2)			+= leds-ns2.o
 obj-$(CONFIG_LEDS_NETXBIG)		+= leds-netxbig.o
 obj-$(CONFIG_LEDS_ASIC3)		+= leds-asic3.o
+obj-$(CONFIG_LEDS_MAX77693)		+= leds-max77693.o
 obj-$(CONFIG_LEDS_MAX8997)		+= leds-max8997.o
 obj-$(CONFIG_LEDS_LM355x)		+= leds-lm355x.o
 obj-$(CONFIG_LEDS_BLINKM)		+= leds-blinkm.o
diff --git a/drivers/leds/leds-max77693.c b/drivers/leds/leds-max77693.c
new file mode 100644
index 0000000..eecaa92
--- /dev/null
+++ b/drivers/leds/leds-max77693.c
@@ -0,0 +1,980 @@
+/*
+ * LED Flash class driver for the flash cell of max77693 mfd.
+ *
+ *	Copyright (C) 2015, Samsung Electronics Co., Ltd.
+ *
+ *	Authors: Jacek Anaszewski <j.anaszewski@samsung.com>
+ *		 Andrzej Hajda <a.hajda@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ */
+
+#include <linux/led-class-flash.h>
+#include <linux/mfd/max77693.h>
+#include <linux/mfd/max77693-private.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/platform_device.h>
+#include <linux/regmap.h>
+#include <linux/slab.h>
+#include <linux/workqueue.h>
+
+#define MODE_OFF		0
+#define MODE_FLASH(a)		(1 << (a))
+#define MODE_TORCH(a)		(1 << (2 + (a)))
+#define MODE_FLASH_EXTERNAL(a)	(1 << (4 + (a)))
+
+#define MODE_FLASH_MASK		(MODE_FLASH(FLED1) | MODE_FLASH(FLED2) | \
+				 MODE_FLASH_EXTERNAL(FLED1) | \
+				 MODE_FLASH_EXTERNAL(FLED2))
+#define MODE_TORCH_MASK		(MODE_TORCH(FLED1) | MODE_TORCH(FLED2))
+
+#define FLED1_IOUT		(1 << 0)
+#define FLED2_IOUT		(1 << 1)
+
+enum max77693_fled {
+	FLED1,
+	FLED2,
+};
+
+enum max77693_led_mode {
+	FLASH,
+	TORCH,
+};
+
+struct max77693_led_config_data {
+	const char *label[2];
+	u32 iout_torch_max[2];
+	u32 iout_flash_max[2];
+	u32 flash_timeout_max[2];
+	u32 num_leds;
+	u32 boost_mode;
+	u32 boost_vout;
+	u32 low_vsys;
+};
+
+struct max77693_sub_led {
+	/* corresponding FLED output identifier */
+	int fled_id;
+	/* corresponding LED Flash class device */
+	struct led_classdev_flash fled_cdev;
+	/* assures led-triggers compatibility */
+	struct work_struct work_brightness_set;
+
+	/* brightness cache */
+	unsigned int torch_brightness;
+	/* flash timeout cache */
+	unsigned int flash_timeout;
+	/* flash faults that may have occurred */
+	u32 flash_faults;
+};
+
+struct max77693_led_device {
+	/* parent mfd regmap */
+	struct regmap *regmap;
+	/* platform device data */
+	struct platform_device *pdev;
+	/* secures access to the device */
+	struct mutex lock;
+
+	/* sub led data */
+	struct max77693_sub_led sub_leds[2];
+
+	/* maximum torch current values for FLED outputs */
+	u32 iout_torch_max[2];
+	/* maximum flash current values for FLED outputs */
+	u32 iout_flash_max[2];
+
+	/* current flash timeout cache */
+	unsigned int current_flash_timeout;
+	/* ITORCH register cache */
+	u8 torch_iout_reg;
+	/* mode of fled outputs */
+	unsigned int mode_flags;
+	/* recently strobed fled */
+	int strobing_sub_led_id;
+	/* bitmask of FLED outputs use state (bit 0. - FLED1, bit 1. - FLED2) */
+	u8 fled_mask;
+	/* FLED modes that can be set */
+	u8 allowed_modes;
+
+	/* arrangement of current outputs */
+	bool iout_joint;
+};
+
+static u8 max77693_led_iout_to_reg(u32 ua)
+{
+	if (ua < FLASH_IOUT_MIN)
+		ua = FLASH_IOUT_MIN;
+	return (ua - FLASH_IOUT_MIN) / FLASH_IOUT_STEP;
+}
+
+static u8 max77693_flash_timeout_to_reg(u32 us)
+{
+	return (us - FLASH_TIMEOUT_MIN) / FLASH_TIMEOUT_STEP;
+}
+
+static inline struct max77693_sub_led *flcdev_to_sub_led(
+					struct led_classdev_flash *fled_cdev)
+{
+	return container_of(fled_cdev, struct max77693_sub_led, fled_cdev);
+}
+
+static inline struct max77693_led_device *sub_led_to_led(
+					struct max77693_sub_led *sub_led)
+{
+	return container_of(sub_led, struct max77693_led_device,
+				sub_leds[sub_led->fled_id]);
+}
+
+static inline u8 max77693_led_vsys_to_reg(u32 mv)
+{
+	return ((mv - MAX_FLASH1_VSYS_MIN) / MAX_FLASH1_VSYS_STEP) << 2;
+}
+
+static inline u8 max77693_led_vout_to_reg(u32 mv)
+{
+	return (mv - FLASH_VOUT_MIN) / FLASH_VOUT_STEP + FLASH_VOUT_RMIN;
+}
+
+static inline bool max77693_fled_used(struct max77693_led_device *led,
+					 int fled_id)
+{
+	u8 fled_bit = (fled_id == FLED1) ? FLED1_IOUT : FLED2_IOUT;
+
+	return led->fled_mask & fled_bit;
+}
+
+static int max77693_set_mode_reg(struct max77693_led_device *led, u8 mode)
+{
+	struct regmap *rmap = led->regmap;
+	int ret, v = 0, i;
+
+	for (i = FLED1; i <= FLED2; ++i) {
+		if (mode & MODE_TORCH(i))
+			v |= FLASH_EN_ON << TORCH_EN_SHIFT(i);
+
+		if (mode & MODE_FLASH(i)) {
+			v |= FLASH_EN_ON << FLASH_EN_SHIFT(i);
+		} else if (mode & MODE_FLASH_EXTERNAL(i)) {
+			v |= FLASH_EN_FLASH << FLASH_EN_SHIFT(i);
+			/*
+			 * Enable hw triggering also for torch mode, as some
+			 * camera sensors use torch led to fathom ambient light
+			 * conditions before strobing the flash.
+			 */
+			v |= FLASH_EN_TORCH << TORCH_EN_SHIFT(i);
+		}
+	}
+
+	/* Reset the register only prior setting flash modes */
+	if (mode & ~(MODE_TORCH(FLED1) | MODE_TORCH(FLED2))) {
+		ret = regmap_write(rmap, MAX77693_LED_REG_FLASH_EN, 0);
+		if (ret < 0)
+			return ret;
+	}
+
+	return regmap_write(rmap, MAX77693_LED_REG_FLASH_EN, v);
+}
+
+static int max77693_add_mode(struct max77693_led_device *led, u8 mode)
+{
+	u8 new_mode_flags;
+	int i, ret;
+
+	if (led->iout_joint)
+		/* Span the mode on FLED2 for joint iouts case */
+		mode |= (mode << 1);
+
+	/*
+	 * FLASH_EXTERNAL mode activates FLASHEN and TORCHEN pins in the device.
+	 * Corresponding register bit fields interfere with SW triggered modes,
+	 * thus clear them to ensure proper device configuration.
+	 */
+	for (i = FLED1; i <= FLED2; ++i)
+		if (mode & MODE_FLASH_EXTERNAL(i))
+			led->mode_flags &= (~MODE_TORCH(i) & ~MODE_FLASH(i));
+
+	new_mode_flags = mode | led->mode_flags;
+	new_mode_flags &= led->allowed_modes;
+
+	if (new_mode_flags ^ led->mode_flags)
+		led->mode_flags = new_mode_flags;
+	else
+		return 0;
+
+	ret = max77693_set_mode_reg(led, led->mode_flags);
+	if (ret < 0)
+		return ret;
+
+	/*
+	 * Clear flash mode flag after setting the mode to avoid spurious flash
+	 * strobing on each subsequent torch mode setting.
+	 */
+	if (mode & MODE_FLASH_MASK)
+		led->mode_flags &= ~mode;
+
+	return ret;
+}
+
+static int max77693_clear_mode(struct max77693_led_device *led,
+				u8 mode)
+{
+	if (led->iout_joint)
+		/* Clear mode also on FLED2 for joint iouts case */
+		mode |= (mode << 1);
+
+	led->mode_flags &= ~mode;
+
+	return max77693_set_mode_reg(led, led->mode_flags);
+}
+
+static void max77693_add_allowed_modes(struct max77693_led_device *led,
+				int fled_id, enum max77693_led_mode mode)
+{
+	if (mode == FLASH)
+		led->allowed_modes |= (MODE_FLASH(fled_id) |
+				       MODE_FLASH_EXTERNAL(fled_id));
+	else
+		led->allowed_modes |= MODE_TORCH(fled_id);
+}
+
+static void max77693_distribute_currents(struct max77693_led_device *led,
+				int fled_id, enum max77693_led_mode mode,
+				u32 micro_amp, u32 iout_max[2], u32 iout[2])
+{
+	if (!led->iout_joint) {
+		iout[fled_id] = micro_amp;
+		max77693_add_allowed_modes(led, fled_id, mode);
+		return;
+	}
+
+	iout[FLED1] = min(micro_amp, iout_max[FLED1]);
+	iout[FLED2] = micro_amp - iout[FLED1];
+
+	if (mode == FLASH)
+		led->allowed_modes &= ~MODE_FLASH_MASK;
+	else
+		led->allowed_modes &= ~MODE_TORCH_MASK;
+
+	max77693_add_allowed_modes(led, FLED1, mode);
+
+	if (iout[FLED2])
+		max77693_add_allowed_modes(led, FLED2, mode);
+}
+
+static int max77693_set_torch_current(struct max77693_led_device *led,
+				int fled_id, u32 micro_amp)
+{
+	struct regmap *rmap = led->regmap;
+	u8 iout1_reg = 0, iout2_reg = 0;
+	u32 iout[2];
+
+	max77693_distribute_currents(led, fled_id, TORCH, micro_amp,
+					led->iout_torch_max, iout);
+
+	if (fled_id == FLED1 || led->iout_joint) {
+		iout1_reg = max77693_led_iout_to_reg(iout[FLED1]);
+		led->torch_iout_reg &= TORCH_IOUT_MASK(TORCH_IOUT2_SHIFT);
+	}
+	if (fled_id == FLED2 || led->iout_joint) {
+		iout2_reg = max77693_led_iout_to_reg(iout[FLED2]);
+		led->torch_iout_reg &= TORCH_IOUT_MASK(TORCH_IOUT1_SHIFT);
+	}
+
+	led->torch_iout_reg |= ((iout1_reg << TORCH_IOUT1_SHIFT) |
+				(iout2_reg << TORCH_IOUT2_SHIFT));
+
+	return regmap_write(rmap, MAX77693_LED_REG_ITORCH,
+						led->torch_iout_reg);
+}
+
+static int max77693_set_flash_current(struct max77693_led_device *led,
+					int fled_id,
+					u32 micro_amp)
+{
+	struct regmap *rmap = led->regmap;
+	u8 iout1_reg, iout2_reg;
+	u32 iout[2];
+	int ret = -EINVAL;
+
+	max77693_distribute_currents(led, fled_id, FLASH, micro_amp,
+					led->iout_flash_max, iout);
+
+	if (fled_id == FLED1 || led->iout_joint) {
+		iout1_reg = max77693_led_iout_to_reg(iout[FLED1]);
+		ret = regmap_write(rmap, MAX77693_LED_REG_IFLASH1,
+							iout1_reg);
+		if (ret < 0)
+			return ret;
+	}
+	if (fled_id == FLED2 || led->iout_joint) {
+		iout2_reg = max77693_led_iout_to_reg(iout[FLED2]);
+		ret = regmap_write(rmap, MAX77693_LED_REG_IFLASH2,
+							iout2_reg);
+	}
+
+	return ret;
+}
+
+static int max77693_set_timeout(struct max77693_led_device *led, u32 microsec)
+{
+	struct regmap *rmap = led->regmap;
+	u8 v;
+	int ret;
+
+	v = max77693_flash_timeout_to_reg(microsec) | FLASH_TMR_LEVEL;
+
+	ret = regmap_write(rmap, MAX77693_LED_REG_FLASH_TIMER, v);
+	if (ret < 0)
+		return ret;
+
+	led->current_flash_timeout = microsec;
+
+	return 0;
+}
+
+static int max77693_get_strobe_status(struct max77693_led_device *led,
+					bool *state)
+{
+	struct regmap *rmap = led->regmap;
+	unsigned int v;
+	int ret;
+
+	ret = regmap_read(rmap, MAX77693_LED_REG_FLASH_STATUS, &v);
+	if (ret < 0)
+		return ret;
+
+	*state = v & FLASH_STATUS_FLASH_ON;
+
+	return ret;
+}
+
+static int max77693_get_flash_faults(struct max77693_sub_led *sub_led)
+{
+	struct max77693_led_device *led = sub_led_to_led(sub_led);
+	struct regmap *rmap = led->regmap;
+	unsigned int v;
+	u8 fault_open_mask, fault_short_mask;
+	int ret;
+
+	sub_led->flash_faults = 0;
+
+	if (led->iout_joint) {
+		fault_open_mask = FLASH_INT_FLED1_OPEN | FLASH_INT_FLED2_OPEN;
+		fault_short_mask = FLASH_INT_FLED1_SHORT |
+							FLASH_INT_FLED2_SHORT;
+	} else {
+		fault_open_mask = (sub_led->fled_id == FLED1) ?
+						FLASH_INT_FLED1_OPEN :
+						FLASH_INT_FLED2_OPEN;
+		fault_short_mask = (sub_led->fled_id == FLED1) ?
+						FLASH_INT_FLED1_SHORT :
+						FLASH_INT_FLED2_SHORT;
+	}
+
+	ret = regmap_read(rmap, MAX77693_LED_REG_FLASH_INT, &v);
+	if (ret < 0)
+		return ret;
+
+	if (v & fault_open_mask)
+		sub_led->flash_faults |= LED_FAULT_OVER_VOLTAGE;
+	if (v & fault_short_mask)
+		sub_led->flash_faults |= LED_FAULT_SHORT_CIRCUIT;
+	if (v & FLASH_INT_OVER_CURRENT)
+		sub_led->flash_faults |= LED_FAULT_OVER_CURRENT;
+
+	return 0;
+}
+
+static int max77693_setup(struct max77693_led_device *led,
+			 struct max77693_led_config_data *led_cfg)
+{
+	struct regmap *rmap = led->regmap;
+	int i, first_led, last_led, ret;
+	u32 max_flash_curr[2];
+	u8 v;
+
+	/*
+	 * Initialize only flash current. Torch current doesn't
+	 * require initialization as ITORCH register is written with
+	 * new value each time brightness_set op is called.
+	 */
+	if (led->iout_joint) {
+		first_led = FLED1;
+		last_led = FLED1;
+		max_flash_curr[FLED1] = led_cfg->iout_flash_max[FLED1] +
+					led_cfg->iout_flash_max[FLED2];
+	} else {
+		first_led = max77693_fled_used(led, FLED1) ? FLED1 : FLED2;
+		last_led = max77693_fled_used(led, FLED2) ? FLED2 : FLED1;
+		max_flash_curr[FLED1] = led_cfg->iout_flash_max[FLED1];
+		max_flash_curr[FLED2] = led_cfg->iout_flash_max[FLED2];
+	}
+
+	for (i = first_led; i <= last_led; ++i) {
+		ret = max77693_set_flash_current(led, i,
+					max_flash_curr[i]);
+		if (ret < 0)
+			return ret;
+	}
+
+	v = TORCH_TMR_NO_TIMER | MAX77693_LED_TRIG_TYPE_LEVEL;
+	ret = regmap_write(rmap, MAX77693_LED_REG_ITORCHTIMER, v);
+	if (ret < 0)
+		return ret;
+
+	if (led_cfg->low_vsys > 0)
+		v = max77693_led_vsys_to_reg(led_cfg->low_vsys) |
+						MAX_FLASH1_MAX_FL_EN;
+	else
+		v = 0;
+
+	ret = regmap_write(rmap, MAX77693_LED_REG_MAX_FLASH1, v);
+	if (ret < 0)
+		return ret;
+	ret = regmap_write(rmap, MAX77693_LED_REG_MAX_FLASH2, 0);
+	if (ret < 0)
+		return ret;
+
+	if (led_cfg->boost_mode == MAX77693_LED_BOOST_FIXED)
+		v = FLASH_BOOST_FIXED;
+	else
+		v = led_cfg->boost_mode | led_cfg->boost_mode << 1;
+
+	if (max77693_fled_used(led, FLED1) && max77693_fled_used(led, FLED2))
+		v |= FLASH_BOOST_LEDNUM_2;
+
+	ret = regmap_write(rmap, MAX77693_LED_REG_VOUT_CNTL, v);
+	if (ret < 0)
+		return ret;
+
+	v = max77693_led_vout_to_reg(led_cfg->boost_vout);
+	ret = regmap_write(rmap, MAX77693_LED_REG_VOUT_FLASH1, v);
+	if (ret < 0)
+		return ret;
+
+	return max77693_set_mode_reg(led, MODE_OFF);
+}
+
+static int __max77693_led_brightness_set(struct max77693_led_device *led,
+					int fled_id, enum led_brightness value)
+{
+	int ret;
+
+	mutex_lock(&led->lock);
+
+	if (value == 0) {
+		ret = max77693_clear_mode(led, MODE_TORCH(fled_id));
+		if (ret < 0)
+			dev_dbg(&led->pdev->dev,
+				"Failed to clear torch mode (%d)\n",
+				ret);
+		goto unlock;
+	}
+
+	ret = max77693_set_torch_current(led, fled_id, value * TORCH_IOUT_STEP);
+	if (ret < 0) {
+		dev_dbg(&led->pdev->dev,
+			"Failed to set torch current (%d)\n",
+			ret);
+		goto unlock;
+	}
+
+	ret = max77693_add_mode(led, MODE_TORCH(fled_id));
+	if (ret < 0)
+		dev_dbg(&led->pdev->dev,
+			"Failed to set torch mode (%d)\n",
+			ret);
+unlock:
+	mutex_unlock(&led->lock);
+	return ret;
+}
+
+static void max77693_led_brightness_set_work(
+					struct work_struct *work)
+{
+	struct max77693_sub_led *sub_led =
+			container_of(work, struct max77693_sub_led,
+					work_brightness_set);
+	struct max77693_led_device *led = sub_led_to_led(sub_led);
+
+	__max77693_led_brightness_set(led, sub_led->fled_id,
+				sub_led->torch_brightness);
+}
+
+/* LED subsystem callbacks */
+
+static int max77693_led_brightness_set_sync(
+				struct led_classdev *led_cdev,
+				enum led_brightness value)
+{
+	struct led_classdev_flash *fled_cdev = lcdev_to_flcdev(led_cdev);
+	struct max77693_sub_led *sub_led = flcdev_to_sub_led(fled_cdev);
+	struct max77693_led_device *led = sub_led_to_led(sub_led);
+
+	return __max77693_led_brightness_set(led, sub_led->fled_id, value);
+}
+
+static void max77693_led_brightness_set(
+				struct led_classdev *led_cdev,
+				enum led_brightness value)
+{
+	struct led_classdev_flash *fled_cdev = lcdev_to_flcdev(led_cdev);
+	struct max77693_sub_led *sub_led = flcdev_to_sub_led(fled_cdev);
+
+	sub_led->torch_brightness = value;
+	schedule_work(&sub_led->work_brightness_set);
+}
+
+static int max77693_led_flash_brightness_set(
+				struct led_classdev_flash *fled_cdev,
+				u32 brightness)
+{
+	struct max77693_sub_led *sub_led = flcdev_to_sub_led(fled_cdev);
+	struct max77693_led_device *led = sub_led_to_led(sub_led);
+	int ret;
+
+	mutex_lock(&led->lock);
+	ret = max77693_set_flash_current(led, sub_led->fled_id, brightness);
+	mutex_unlock(&led->lock);
+
+	return ret;
+}
+
+static int max77693_led_flash_strobe_set(
+				struct led_classdev_flash *fled_cdev,
+				bool state)
+{
+	struct max77693_sub_led *sub_led = flcdev_to_sub_led(fled_cdev);
+	struct max77693_led_device *led = sub_led_to_led(sub_led);
+	int fled_id = sub_led->fled_id;
+	int ret;
+
+	mutex_lock(&led->lock);
+
+	if (!state) {
+		ret = max77693_clear_mode(led, MODE_FLASH(fled_id));
+		goto unlock;
+	}
+
+	if (sub_led->flash_timeout != led->current_flash_timeout) {
+		ret = max77693_set_timeout(led, sub_led->flash_timeout);
+		if (ret < 0)
+			goto unlock;
+	}
+
+	led->strobing_sub_led_id = fled_id;
+
+	ret = max77693_add_mode(led, MODE_FLASH(fled_id));
+	if (ret < 0)
+		goto unlock;
+
+	ret = max77693_get_flash_faults(sub_led);
+
+unlock:
+	mutex_unlock(&led->lock);
+	return ret;
+}
+
+static int max77693_led_flash_fault_get(
+				struct led_classdev_flash *fled_cdev,
+				u32 *fault)
+{
+	struct max77693_sub_led *sub_led = flcdev_to_sub_led(fled_cdev);
+
+	*fault = sub_led->flash_faults;
+
+	return 0;
+}
+
+static int max77693_led_flash_strobe_get(
+				struct led_classdev_flash *fled_cdev,
+				bool *state)
+{
+	struct max77693_sub_led *sub_led = flcdev_to_sub_led(fled_cdev);
+	struct max77693_led_device *led = sub_led_to_led(sub_led);
+	int ret;
+
+	if (!state)
+		return -EINVAL;
+
+	mutex_lock(&led->lock);
+
+	ret = max77693_get_strobe_status(led, state);
+
+	*state = !!(*state && (led->strobing_sub_led_id == sub_led->fled_id));
+
+	mutex_unlock(&led->lock);
+
+	return ret;
+}
+
+static int max77693_led_flash_timeout_set(
+				struct led_classdev_flash *fled_cdev,
+				u32 timeout)
+{
+	struct max77693_sub_led *sub_led = flcdev_to_sub_led(fled_cdev);
+	struct max77693_led_device *led = sub_led_to_led(sub_led);
+
+	mutex_lock(&led->lock);
+	sub_led->flash_timeout = timeout;
+	mutex_unlock(&led->lock);
+
+	return 0;
+}
+
+static int max77693_led_parse_dt(struct max77693_led_device *led,
+				struct max77693_led_config_data *cfg)
+{
+	struct device *dev = &led->pdev->dev;
+	struct max77693_sub_led *sub_leds = led->sub_leds;
+	struct device_node *node = dev->of_node, *child_node;
+	struct property *prop;
+	u32 led_sources[2];
+	int i, ret, fled_id;
+
+	of_property_read_u32(node, "maxim,boost-mode", &cfg->boost_mode);
+	of_property_read_u32(node, "maxim,boost-mvout", &cfg->boost_vout);
+	of_property_read_u32(node, "maxim,mvsys-min", &cfg->low_vsys);
+
+	for_each_available_child_of_node(node, child_node) {
+		prop = of_find_property(child_node, "led-sources", NULL);
+		if (prop) {
+			const __be32 *srcs = NULL;
+
+			for (i = 0; i < ARRAY_SIZE(led_sources); ++i) {
+				srcs = of_prop_next_u32(prop, srcs,
+							&led_sources[i]);
+				if (!srcs)
+					break;
+			}
+		} else {
+			dev_err(dev,
+				"led-sources DT property missing\n");
+			of_node_put(child_node);
+			return -EINVAL;
+		}
+
+		if (i == 2) {
+			fled_id = FLED1;
+			led->fled_mask = FLED1_IOUT | FLED2_IOUT;
+		} else if (led_sources[0] == FLED1) {
+			fled_id = FLED1;
+			led->fled_mask |= FLED1_IOUT;
+		} else if (led_sources[0] == FLED2) {
+			fled_id = FLED2;
+			led->fled_mask |= FLED2_IOUT;
+		} else {
+			dev_err(dev,
+				"Wrong led-sources DT property value.\n");
+			of_node_put(child_node);
+			return -EINVAL;
+		}
+
+		sub_leds[fled_id].fled_id = fled_id;
+
+		cfg->label[fled_id] =
+			of_get_property(child_node, "label", NULL) ? :
+						child_node->name;
+
+		ret = of_property_read_u32(child_node, "led-max-microamp",
+					&cfg->iout_torch_max[fled_id]);
+		if (ret < 0) {
+			cfg->iout_torch_max[fled_id] = TORCH_IOUT_MIN;
+			dev_warn(dev, "led-max-microamp DT property missing\n");
+		}
+
+		ret = of_property_read_u32(child_node, "flash-max-microamp",
+					&cfg->iout_flash_max[fled_id]);
+		if (ret < 0) {
+			cfg->iout_flash_max[fled_id] = FLASH_IOUT_MIN;
+			dev_warn(dev,
+				 "flash-max-microamp DT property missing\n");
+		}
+
+		ret = of_property_read_u32(child_node, "flash-max-timeout-us",
+					&cfg->flash_timeout_max[fled_id]);
+		if (ret < 0) {
+			cfg->flash_timeout_max[fled_id] = FLASH_TIMEOUT_MIN;
+			dev_warn(dev,
+				 "flash-max-timeout-us DT property missing\n");
+		}
+
+		if (++cfg->num_leds == 2 ||
+		    (max77693_fled_used(led, FLED1) &&
+		     max77693_fled_used(led, FLED2))) {
+			of_node_put(child_node);
+			break;
+		}
+	}
+
+	if (cfg->num_leds == 0) {
+		dev_err(dev, "No DT child node found for connected LED(s).\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static void clamp_align(u32 *v, u32 min, u32 max, u32 step)
+{
+	*v = clamp_val(*v, min, max);
+	if (step > 1)
+		*v = (*v - min) / step * step + min;
+}
+
+static void max77693_align_iout_current(struct max77693_led_device *led,
+					u32 *iout, u32 min, u32 max, u32 step)
+{
+	int i;
+
+	if (led->iout_joint) {
+		if (iout[FLED1] > min) {
+			iout[FLED1] /= 2;
+			iout[FLED2] = iout[FLED1];
+		} else {
+			iout[FLED1] = min;
+			iout[FLED2] = 0;
+			return;
+		}
+	}
+
+	for (i = FLED1; i <= FLED2; ++i)
+		if (max77693_fled_used(led, i))
+			clamp_align(&iout[i], min, max, step);
+		else
+			iout[i] = 0;
+}
+
+static void max77693_led_validate_configuration(struct max77693_led_device *led,
+					struct max77693_led_config_data *cfg)
+{
+	u32 flash_iout_max = cfg->boost_mode ? FLASH_IOUT_MAX_2LEDS :
+					       FLASH_IOUT_MAX_1LED;
+	int i;
+
+	if (cfg->num_leds == 1 &&
+	    max77693_fled_used(led, FLED1) && max77693_fled_used(led, FLED2))
+		led->iout_joint = true;
+
+	cfg->boost_mode = clamp_val(cfg->boost_mode, MAX77693_LED_BOOST_NONE,
+			    MAX77693_LED_BOOST_FIXED);
+
+	/* Boost must be enabled if both current outputs are used */
+	if ((cfg->boost_mode == MAX77693_LED_BOOST_NONE) && led->iout_joint)
+		cfg->boost_mode = MAX77693_LED_BOOST_FIXED;
+
+	max77693_align_iout_current(led, cfg->iout_torch_max,
+			TORCH_IOUT_MIN, TORCH_IOUT_MAX, TORCH_IOUT_STEP);
+
+	max77693_align_iout_current(led, cfg->iout_flash_max,
+			FLASH_IOUT_MIN, flash_iout_max, FLASH_IOUT_STEP);
+
+	for (i = 0; i < ARRAY_SIZE(cfg->flash_timeout_max); ++i)
+		clamp_align(&cfg->flash_timeout_max[i], FLASH_TIMEOUT_MIN,
+				FLASH_TIMEOUT_MAX, FLASH_TIMEOUT_STEP);
+
+	clamp_align(&cfg->boost_vout, FLASH_VOUT_MIN, FLASH_VOUT_MAX,
+							FLASH_VOUT_STEP);
+
+	if (cfg->low_vsys)
+		clamp_align(&cfg->low_vsys, MAX_FLASH1_VSYS_MIN,
+				MAX_FLASH1_VSYS_MAX, MAX_FLASH1_VSYS_STEP);
+}
+
+static int max77693_led_get_configuration(struct max77693_led_device *led,
+				struct max77693_led_config_data *cfg)
+{
+	int ret;
+
+	ret = max77693_led_parse_dt(led, cfg);
+	if (ret < 0)
+		return ret;
+
+	max77693_led_validate_configuration(led, cfg);
+
+	memcpy(led->iout_torch_max, cfg->iout_torch_max,
+				sizeof(led->iout_torch_max));
+	memcpy(led->iout_flash_max, cfg->iout_flash_max,
+				sizeof(led->iout_flash_max));
+
+	return 0;
+}
+
+static const struct led_flash_ops flash_ops = {
+	.flash_brightness_set	= max77693_led_flash_brightness_set,
+	.strobe_set		= max77693_led_flash_strobe_set,
+	.strobe_get		= max77693_led_flash_strobe_get,
+	.timeout_set		= max77693_led_flash_timeout_set,
+	.fault_get		= max77693_led_flash_fault_get,
+};
+
+static void max77693_init_flash_settings(struct max77693_sub_led *sub_led,
+				 struct max77693_led_config_data *led_cfg)
+{
+	struct led_classdev_flash *fled_cdev = &sub_led->fled_cdev;
+	struct max77693_led_device *led = sub_led_to_led(sub_led);
+	int fled_id = sub_led->fled_id;
+	struct led_flash_setting *setting;
+
+	/* Init flash intensity setting */
+	setting = &fled_cdev->brightness;
+	setting->min = FLASH_IOUT_MIN;
+	setting->max = led->iout_joint ?
+		led_cfg->iout_flash_max[FLED1] +
+		led_cfg->iout_flash_max[FLED2] :
+		led_cfg->iout_flash_max[fled_id];
+	setting->step = FLASH_IOUT_STEP;
+	setting->val = setting->max;
+
+	/* Init flash timeout setting */
+	setting = &fled_cdev->timeout;
+	setting->min = FLASH_TIMEOUT_MIN;
+	setting->max = led_cfg->flash_timeout_max[fled_id];
+	setting->step = FLASH_TIMEOUT_STEP;
+	setting->val = setting->max;
+}
+
+static void max77693_init_fled_cdev(struct max77693_sub_led *sub_led,
+				struct max77693_led_config_data *led_cfg)
+{
+	struct max77693_led_device *led = sub_led_to_led(sub_led);
+	int fled_id = sub_led->fled_id;
+	struct led_classdev_flash *fled_cdev;
+	struct led_classdev *led_cdev;
+
+	/* Initialize LED Flash class device */
+	fled_cdev = &sub_led->fled_cdev;
+	fled_cdev->ops = &flash_ops;
+	led_cdev = &fled_cdev->led_cdev;
+
+	led_cdev->name = led_cfg->label[fled_id];
+
+	led_cdev->brightness_set = max77693_led_brightness_set;
+	led_cdev->brightness_set_sync = max77693_led_brightness_set_sync;
+	led_cdev->max_brightness = (led->iout_joint ?
+					led_cfg->iout_torch_max[FLED1] +
+					led_cfg->iout_torch_max[FLED2] :
+					led_cfg->iout_torch_max[fled_id]) /
+				   TORCH_IOUT_STEP;
+	led_cdev->flags |= LED_DEV_CAP_FLASH;
+	INIT_WORK(&sub_led->work_brightness_set,
+			max77693_led_brightness_set_work);
+
+	max77693_init_flash_settings(sub_led, led_cfg);
+
+	/* Init flash timeout cache */
+	sub_led->flash_timeout = fled_cdev->timeout.val;
+}
+
+static int max77693_led_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct max77693_dev *iodev = dev_get_drvdata(dev->parent);
+	struct max77693_led_device *led;
+	struct max77693_sub_led *sub_leds;
+	struct max77693_led_config_data led_cfg = {};
+	int init_fled_cdev[2], i, ret;
+
+	led = devm_kzalloc(dev, sizeof(*led), GFP_KERNEL);
+	if (!led)
+		return -ENOMEM;
+
+	led->pdev = pdev;
+	led->regmap = iodev->regmap;
+	led->allowed_modes = MODE_FLASH_MASK;
+	sub_leds = led->sub_leds;
+
+	platform_set_drvdata(pdev, led);
+	ret = max77693_led_get_configuration(led, &led_cfg);
+	if (ret < 0)
+		return ret;
+
+	ret = max77693_setup(led, &led_cfg);
+	if (ret < 0)
+		return ret;
+
+	mutex_init(&led->lock);
+
+	init_fled_cdev[FLED1] =
+			led->iout_joint || max77693_fled_used(led, FLED1);
+	init_fled_cdev[FLED2] =
+			!led->iout_joint && max77693_fled_used(led, FLED2);
+
+	for (i = FLED1; i <= FLED2; ++i) {
+		if (!init_fled_cdev[i])
+			continue;
+
+		/* Initialize LED Flash class device */
+		max77693_init_fled_cdev(&sub_leds[i], &led_cfg);
+
+		/* Register LED Flash class device */
+		ret = led_classdev_flash_register(dev, &sub_leds[i].fled_cdev);
+		if (ret < 0) {
+			/*
+			 * At this moment FLED1 might have been already
+			 * registered and it needs to be released.
+			 */
+			if (i == FLED2)
+				goto err_register_led2;
+			else
+				goto err_register_led1;
+		}
+	}
+
+	return 0;
+
+err_register_led2:
+	/* It is possible than only FLED2 was to be registered */
+	if (!init_fled_cdev[FLED1])
+		goto err_register_led1;
+	led_classdev_flash_unregister(&sub_leds[FLED1].fled_cdev);
+err_register_led1:
+	mutex_destroy(&led->lock);
+
+	return ret;
+}
+
+static int max77693_led_remove(struct platform_device *pdev)
+{
+	struct max77693_led_device *led = platform_get_drvdata(pdev);
+	struct max77693_sub_led *sub_leds = led->sub_leds;
+
+	if (led->iout_joint || max77693_fled_used(led, FLED1)) {
+		led_classdev_flash_unregister(&sub_leds[FLED1].fled_cdev);
+		cancel_work_sync(&sub_leds[FLED1].work_brightness_set);
+	}
+
+	if (!led->iout_joint && max77693_fled_used(led, FLED2)) {
+		led_classdev_flash_unregister(&sub_leds[FLED2].fled_cdev);
+		cancel_work_sync(&sub_leds[FLED2].work_brightness_set);
+	}
+
+	mutex_destroy(&led->lock);
+
+	return 0;
+}
+
+static const struct of_device_id max77693_led_dt_match[] = {
+	{ .compatible = "maxim,max77693-led" },
+	{},
+};
+
+static struct platform_driver max77693_led_driver = {
+	.probe		= max77693_led_probe,
+	.remove		= max77693_led_remove,
+	.driver		= {
+		.name	= "max77693-led",
+		.of_match_table = max77693_led_dt_match,
+	},
+};
+
+module_platform_driver(max77693_led_driver);
+
+MODULE_AUTHOR("Jacek Anaszewski <j.anaszewski@samsung.com>");
+MODULE_AUTHOR("Andrzej Hajda <a.hajda@samsung.com>");
+MODULE_DESCRIPTION("Maxim MAX77693 led flash driver");
+MODULE_LICENSE("GPL v2");
-- 
1.7.9.5

