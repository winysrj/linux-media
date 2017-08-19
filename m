Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:42822 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751586AbdHSVm3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 19 Aug 2017 17:42:29 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: javier@dowhile0.org, jacek.anaszewski@gmail.com,
        linux-leds@vger.kernel.org, devicetree@vger.kernel.org,
        Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH v2.1 2/3] leds: as3645a: Add LED flash class driver
Date: Sun, 20 Aug 2017 00:42:26 +0300
Message-Id: <20170819214226.20736-1-sakari.ailus@linux.intel.com>
In-Reply-To: <20170819212410.3084-3-sakari.ailus@linux.intel.com>
References: <20170819212410.3084-3-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@iki.fi>

Add a LED flash class driver for the as3654a flash controller. A V4L2 flash
driver for it already exists (drivers/media/i2c/as3645a.c), and this driver
is based on that.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
Well. The driver does not control explicit power resources nor it used
runtime PM. Remove references to it.

 MAINTAINERS                 |   6 +
 drivers/leds/Kconfig        |   8 +
 drivers/leds/Makefile       |   1 +
 drivers/leds/leds-as3645a.c | 763 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 778 insertions(+)
 create mode 100644 drivers/leds/leds-as3645a.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 931abca006b7..8f40ba2e5303 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2124,6 +2124,12 @@ F:	arch/arm64/
 F:	Documentation/arm64/
 
 AS3645A LED FLASH CONTROLLER DRIVER
+M:	Sakari Ailus <sakari.ailus@iki.fi>
+L:	linux-leds@vger.kernel.org
+S:	Maintained
+F:	drivers/leds/leds-as3645a.c
+
+AS3645A LED FLASH CONTROLLER DRIVER
 M:	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
 L:	linux-media@vger.kernel.org
 T:	git git://linuxtv.org/media_tree.git
diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index 594b24d410c3..bad3a4098104 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -58,6 +58,14 @@ config LEDS_AAT1290
 	help
 	 This option enables support for the LEDs on the AAT1290.
 
+config LEDS_AS3645A
+	tristate "AS3645A LED flash controller support"
+	depends on I2C && LEDS_CLASS_FLASH
+	help
+	  Enable LED flash class support for AS3645A LED flash
+	  controller. V4L2 flash API is provided as well if
+	  CONFIG_V4L2_FLASH_API is enabled.
+
 config LEDS_BCM6328
 	tristate "LED Support for Broadcom BCM6328"
 	depends on LEDS_CLASS
diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
index 909dae62ba05..7d7b26552923 100644
--- a/drivers/leds/Makefile
+++ b/drivers/leds/Makefile
@@ -8,6 +8,7 @@ obj-$(CONFIG_LEDS_TRIGGERS)		+= led-triggers.o
 # LED Platform Drivers
 obj-$(CONFIG_LEDS_88PM860X)		+= leds-88pm860x.o
 obj-$(CONFIG_LEDS_AAT1290)		+= leds-aat1290.o
+obj-$(CONFIG_LEDS_AS3645A)		+= leds-as3645a.o
 obj-$(CONFIG_LEDS_BCM6328)		+= leds-bcm6328.o
 obj-$(CONFIG_LEDS_BCM6358)		+= leds-bcm6358.o
 obj-$(CONFIG_LEDS_BD2802)		+= leds-bd2802.o
diff --git a/drivers/leds/leds-as3645a.c b/drivers/leds/leds-as3645a.c
new file mode 100644
index 000000000000..bbbbe0898233
--- /dev/null
+++ b/drivers/leds/leds-as3645a.c
@@ -0,0 +1,763 @@
+/*
+ * drivers/leds/leds-as3645a.c - AS3645A and LM3555 flash controllers driver
+ *
+ * Copyright (C) 2008-2011 Nokia Corporation
+ * Copyright (c) 2011, 2017 Intel Corporation.
+ *
+ * Based on drivers/media/i2c/as3645a.c.
+ *
+ * Contact: Sakari Ailus <sakari.ailus@iki.fi>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#include <linux/delay.h>
+#include <linux/gpio/consumer.h>
+#include <linux/i2c.h>
+#include <linux/led-class-flash.h>
+#include <linux/leds.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/of.h>
+#include <linux/slab.h>
+
+#include <media/v4l2-flash-led-class.h>
+
+#define AS_TIMER_US_TO_CODE(t)			(((t) / 1000 - 100) / 50)
+#define AS_TIMER_CODE_TO_US(c)			((50 * (c) + 100) * 1000)
+
+/* Register definitions */
+
+/* Read-only Design info register: Reset state: xxxx 0001 */
+#define AS_DESIGN_INFO_REG			0x00
+#define AS_DESIGN_INFO_FACTORY(x)		(((x) >> 4))
+#define AS_DESIGN_INFO_MODEL(x)			((x) & 0x0f)
+
+/* Read-only Version control register: Reset state: 0000 0000
+ * for first engineering samples
+ */
+#define AS_VERSION_CONTROL_REG			0x01
+#define AS_VERSION_CONTROL_RFU(x)		(((x) >> 4))
+#define AS_VERSION_CONTROL_VERSION(x)		((x) & 0x0f)
+
+/* Read / Write	(Indicator and timer register): Reset state: 0000 1111 */
+#define AS_INDICATOR_AND_TIMER_REG		0x02
+#define AS_INDICATOR_AND_TIMER_TIMEOUT_SHIFT	0
+#define AS_INDICATOR_AND_TIMER_VREF_SHIFT	4
+#define AS_INDICATOR_AND_TIMER_INDICATOR_SHIFT	6
+
+/* Read / Write	(Current set register): Reset state: 0110 1001 */
+#define AS_CURRENT_SET_REG			0x03
+#define AS_CURRENT_ASSIST_LIGHT_SHIFT		0
+#define AS_CURRENT_LED_DET_ON			(1 << 3)
+#define AS_CURRENT_FLASH_CURRENT_SHIFT		4
+
+/* Read / Write	(Control register): Reset state: 1011 0100 */
+#define AS_CONTROL_REG				0x04
+#define AS_CONTROL_MODE_SETTING_SHIFT		0
+#define AS_CONTROL_STROBE_ON			(1 << 2)
+#define AS_CONTROL_OUT_ON			(1 << 3)
+#define AS_CONTROL_EXT_TORCH_ON			(1 << 4)
+#define AS_CONTROL_STROBE_TYPE_EDGE		(0 << 5)
+#define AS_CONTROL_STROBE_TYPE_LEVEL		(1 << 5)
+#define AS_CONTROL_COIL_PEAK_SHIFT		6
+
+/* Read only (D3 is read / write) (Fault and info): Reset state: 0000 x000 */
+#define AS_FAULT_INFO_REG			0x05
+#define AS_FAULT_INFO_INDUCTOR_PEAK_LIMIT	(1 << 1)
+#define AS_FAULT_INFO_INDICATOR_LED		(1 << 2)
+#define AS_FAULT_INFO_LED_AMOUNT		(1 << 3)
+#define AS_FAULT_INFO_TIMEOUT			(1 << 4)
+#define AS_FAULT_INFO_OVER_TEMPERATURE		(1 << 5)
+#define AS_FAULT_INFO_SHORT_CIRCUIT		(1 << 6)
+#define AS_FAULT_INFO_OVER_VOLTAGE		(1 << 7)
+
+/* Boost register */
+#define AS_BOOST_REG				0x0d
+#define AS_BOOST_CURRENT_DISABLE		(0 << 0)
+#define AS_BOOST_CURRENT_ENABLE			(1 << 0)
+
+/* Password register is used to unlock boost register writing */
+#define AS_PASSWORD_REG				0x0f
+#define AS_PASSWORD_UNLOCK_VALUE		0x55
+
+#define AS_NAME					"as3645a"
+#define AS_I2C_ADDR				(0x60 >> 1) /* W:0x60, R:0x61 */
+
+#define AS_FLASH_TIMEOUT_MIN			100000	/* us */
+#define AS_FLASH_TIMEOUT_MAX			850000
+#define AS_FLASH_TIMEOUT_STEP			50000
+
+#define AS_FLASH_INTENSITY_MIN			200000	/* uA */
+#define AS_FLASH_INTENSITY_MAX_1LED		500000
+#define AS_FLASH_INTENSITY_MAX_2LEDS		400000
+#define AS_FLASH_INTENSITY_STEP			20000
+
+#define AS_TORCH_INTENSITY_MIN			20000	/* uA */
+#define AS_TORCH_INTENSITY_MAX			160000
+#define AS_TORCH_INTENSITY_STEP			20000
+
+#define AS_INDICATOR_INTENSITY_MIN		0	/* uA */
+#define AS_INDICATOR_INTENSITY_MAX		10000
+#define AS_INDICATOR_INTENSITY_STEP		2500
+
+#define AS_PEAK_mA_MAX				2000
+#define AS_PEAK_mA_TO_REG(a) \
+	((min_t(u32, AS_PEAK_mA_MAX, a) - 1250) / 250)
+
+enum as_mode {
+	AS_MODE_EXT_TORCH = 0 << AS_CONTROL_MODE_SETTING_SHIFT,
+	AS_MODE_INDICATOR = 1 << AS_CONTROL_MODE_SETTING_SHIFT,
+	AS_MODE_ASSIST = 2 << AS_CONTROL_MODE_SETTING_SHIFT,
+	AS_MODE_FLASH = 3 << AS_CONTROL_MODE_SETTING_SHIFT,
+};
+
+struct as3645a_config {
+	u32 flash_timeout_us;
+	u32 flash_max_ua;
+	u32 assist_max_ua;
+	u32 indicator_max_ua;
+	u32 voltage_reference;
+	u32 peak;
+};
+
+struct as3645a_names {
+	char flash[32];
+	char indicator[32];
+};
+
+struct as3645a {
+	struct i2c_client *client;
+
+	struct mutex mutex;
+
+	struct led_classdev_flash fled;
+	struct led_classdev iled_cdev;
+
+	struct v4l2_flash *vf;
+	struct v4l2_flash *vfind;
+
+	struct device_node *flash_node;
+	struct device_node *indicator_node;
+
+	struct as3645a_config cfg;
+
+	enum as_mode mode;
+	unsigned int timeout;
+	unsigned int flash_current;
+	unsigned int assist_current;
+	unsigned int indicator_current;
+	enum v4l2_flash_strobe_source strobe_source;
+};
+
+#define fled_to_as3645a(__fled) container_of(__fled, struct as3645a, fled)
+#define iled_cdev_to_as3645a(__iled_cdev) \
+	container_of(__iled_cdev, struct as3645a, iled_cdev)
+
+/* Return negative errno else zero on success */
+static int as3645a_write(struct as3645a *flash, u8 addr, u8 val)
+{
+	struct i2c_client *client = flash->client;
+	int rval;
+
+	rval = i2c_smbus_write_byte_data(client, addr, val);
+
+	dev_dbg(&client->dev, "Write Addr:%02X Val:%02X %s\n", addr, val,
+		rval < 0 ? "fail" : "ok");
+
+	return rval;
+}
+
+/* Return negative errno else a data byte received from the device. */
+static int as3645a_read(struct as3645a *flash, u8 addr)
+{
+	struct i2c_client *client = flash->client;
+	int rval;
+
+	rval = i2c_smbus_read_byte_data(client, addr);
+
+	dev_dbg(&client->dev, "Read Addr:%02X Val:%02X %s\n", addr, rval,
+		rval < 0 ? "fail" : "ok");
+
+	return rval;
+}
+
+/* -----------------------------------------------------------------------------
+ * Hardware configuration and trigger
+ */
+
+/**
+ * as3645a_set_config - Set flash configuration registers
+ * @flash: The flash
+ *
+ * Configure the hardware with flash, assist and indicator currents, as well as
+ * flash timeout.
+ *
+ * Return 0 on success, or a negative error code if an I2C communication error
+ * occurred.
+ */
+static int as3645a_set_current(struct as3645a *flash)
+{
+	u8 val;
+
+	val = (flash->flash_current << AS_CURRENT_FLASH_CURRENT_SHIFT)
+	    | (flash->assist_current << AS_CURRENT_ASSIST_LIGHT_SHIFT)
+	    | AS_CURRENT_LED_DET_ON;
+
+	return as3645a_write(flash, AS_CURRENT_SET_REG, val);
+}
+
+static int as3645a_set_timeout(struct as3645a *flash)
+{
+	u8 val;
+
+	val = flash->timeout << AS_INDICATOR_AND_TIMER_TIMEOUT_SHIFT;
+
+	val |= (flash->cfg.voltage_reference
+		<< AS_INDICATOR_AND_TIMER_VREF_SHIFT)
+	    |  ((flash->indicator_current ? flash->indicator_current - 1 : 0)
+		 << AS_INDICATOR_AND_TIMER_INDICATOR_SHIFT);
+
+	return as3645a_write(flash, AS_INDICATOR_AND_TIMER_REG, val);
+}
+
+/**
+ * as3645a_set_control - Set flash control register
+ * @flash: The flash
+ * @mode: Desired output mode
+ * @on: Desired output state
+ *
+ * Configure the hardware with output mode and state.
+ *
+ * Return 0 on success, or a negative error code if an I2C communication error
+ * occurred.
+ */
+static int
+as3645a_set_control(struct as3645a *flash, enum as_mode mode, bool on)
+{
+	u8 reg;
+
+	/* Configure output parameters and operation mode. */
+	reg = (flash->cfg.peak << AS_CONTROL_COIL_PEAK_SHIFT)
+	    | (on ? AS_CONTROL_OUT_ON : 0)
+	    | mode;
+
+	if (mode == AS_MODE_FLASH &&
+	    flash->strobe_source == V4L2_FLASH_STROBE_SOURCE_EXTERNAL)
+		reg |= AS_CONTROL_STROBE_TYPE_LEVEL
+		    |  AS_CONTROL_STROBE_ON;
+
+	return as3645a_write(flash, AS_CONTROL_REG, reg);
+}
+
+static int as3645a_get_fault(struct led_classdev_flash *fled, u32 *fault)
+{
+	struct as3645a *flash = fled_to_as3645a(fled);
+	int rval;
+
+	/* NOTE: reading register clears fault status */
+	rval = as3645a_read(flash, AS_FAULT_INFO_REG);
+	if (rval < 0)
+		return rval;
+
+	if (rval & AS_FAULT_INFO_INDUCTOR_PEAK_LIMIT)
+		*fault |= LED_FAULT_OVER_CURRENT;
+
+	if (rval & AS_FAULT_INFO_INDICATOR_LED)
+		*fault |= LED_FAULT_INDICATOR;
+
+	dev_dbg(&flash->client->dev, "%u connected LEDs\n",
+		rval & AS_FAULT_INFO_LED_AMOUNT ? 2 : 1);
+
+	if (rval & AS_FAULT_INFO_TIMEOUT)
+		*fault |= LED_FAULT_TIMEOUT;
+
+	if (rval & AS_FAULT_INFO_OVER_TEMPERATURE)
+		*fault |= LED_FAULT_OVER_TEMPERATURE;
+
+	if (rval & AS_FAULT_INFO_SHORT_CIRCUIT)
+		*fault |= LED_FAULT_OVER_CURRENT;
+
+	if (rval & AS_FAULT_INFO_OVER_VOLTAGE)
+		*fault |= LED_FAULT_INPUT_VOLTAGE;
+
+	return rval;
+}
+
+static unsigned int __as3645a_current_to_reg(unsigned int min, unsigned int max,
+					     unsigned int step,
+					     unsigned int val)
+{
+	if (val < min)
+		val = min;
+
+	if (val > max)
+		val = max;
+
+	return (val - min) / step;
+}
+
+static unsigned int as3645a_current_to_reg(struct as3645a *flash, bool is_flash,
+					   unsigned int ua)
+{
+	if (is_flash)
+		return __as3645a_current_to_reg(AS_TORCH_INTENSITY_MIN,
+						flash->cfg.assist_max_ua,
+						AS_TORCH_INTENSITY_STEP, ua);
+	else
+		return __as3645a_current_to_reg(AS_FLASH_INTENSITY_MIN,
+						flash->cfg.flash_max_ua,
+						AS_FLASH_INTENSITY_STEP, ua);
+}
+
+static int as3645a_set_indicator_brightness(struct led_classdev *iled_cdev,
+					    enum led_brightness brightness)
+{
+	struct as3645a *flash = iled_cdev_to_as3645a(iled_cdev);
+	int rval;
+
+	flash->indicator_current = brightness;
+
+	rval = as3645a_set_timeout(flash);
+	if (rval)
+		return rval;
+
+	return as3645a_set_control(flash, AS_MODE_INDICATOR, brightness);
+}
+
+static int as3645a_set_assist_brightness(struct led_classdev *fled_cdev,
+					 enum led_brightness brightness)
+{
+	struct led_classdev_flash *fled = lcdev_to_flcdev(fled_cdev);
+	struct as3645a *flash = fled_to_as3645a(fled);
+	int rval;
+
+	if (brightness) {
+		/* Register value 0 is 20 mA. */
+		flash->assist_current = brightness - 1;
+
+		rval = as3645a_set_current(flash);
+		if (rval)
+			return rval;
+	}
+
+	return as3645a_set_control(flash, AS_MODE_ASSIST, brightness);
+}
+
+static int as3645a_set_flash_brightness(struct led_classdev_flash *fled,
+					u32 brightness_ua)
+{
+	struct as3645a *flash = fled_to_as3645a(fled);
+
+	flash->flash_current = as3645a_current_to_reg(flash, true, brightness_ua);
+
+	return as3645a_set_current(flash);
+}
+
+static int as3645a_set_flash_timeout(struct led_classdev_flash *fled,
+				     u32 timeout_us)
+{
+	struct as3645a *flash = fled_to_as3645a(fled);
+
+	flash->timeout = AS_TIMER_US_TO_CODE(timeout_us);
+
+	return as3645a_set_timeout(flash);
+}
+
+static int as3645a_set_strobe(struct led_classdev_flash *fled, bool state)
+{
+	struct as3645a *flash = fled_to_as3645a(fled);
+
+	return as3645a_set_control(flash, AS_MODE_FLASH, state);
+}
+
+static const struct led_flash_ops as3645a_led_flash_ops = {
+	.flash_brightness_set = as3645a_set_flash_brightness,
+	.timeout_set = as3645a_set_flash_timeout,
+	.strobe_set = as3645a_set_strobe,
+	.fault_get = as3645a_get_fault,
+};
+
+static int as3645a_setup(struct as3645a *flash)
+{
+	struct device *dev = &flash->client->dev;
+	u32 fault = 0;
+	int rval;
+
+	/* clear errors */
+	rval = as3645a_read(flash, AS_FAULT_INFO_REG);
+	if (rval < 0)
+		return rval;
+
+	dev_dbg(dev, "Fault info: %02x\n", rval);
+
+	rval = as3645a_set_current(flash);
+	if (rval < 0)
+		return rval;
+
+	rval = as3645a_set_timeout(flash);
+	if (rval < 0)
+		return rval;
+
+	rval = as3645a_set_control(flash, AS_MODE_INDICATOR, false);
+	if (rval < 0)
+		return rval;
+
+	/* read status */
+	rval = as3645a_get_fault(&flash->fled, &fault);
+	if (rval < 0)
+		return rval;
+
+	dev_dbg(dev, "AS_INDICATOR_AND_TIMER_REG: %02x\n",
+		as3645a_read(flash, AS_INDICATOR_AND_TIMER_REG));
+	dev_dbg(dev, "AS_CURRENT_SET_REG: %02x\n",
+		as3645a_read(flash, AS_CURRENT_SET_REG));
+	dev_dbg(dev, "AS_CONTROL_REG: %02x\n",
+		as3645a_read(flash, AS_CONTROL_REG));
+
+	return rval & ~AS_FAULT_INFO_LED_AMOUNT ? -EIO : 0;
+}
+
+static int as3645a_detect(struct as3645a *flash)
+{
+	struct device *dev = &flash->client->dev;
+	int rval, man, model, rfu, version;
+	const char *vendor;
+
+	rval = as3645a_read(flash, AS_DESIGN_INFO_REG);
+	if (rval < 0) {
+		dev_err(dev, "can't read design info reg\n");
+		return rval;
+	}
+
+	man = AS_DESIGN_INFO_FACTORY(rval);
+	model = AS_DESIGN_INFO_MODEL(rval);
+
+	rval = as3645a_read(flash, AS_VERSION_CONTROL_REG);
+	if (rval < 0) {
+		dev_err(dev, "can't read version control reg\n");
+		return rval;
+	}
+
+	rfu = AS_VERSION_CONTROL_RFU(rval);
+	version = AS_VERSION_CONTROL_VERSION(rval);
+
+	/* Verify the chip model and version. */
+	if (model != 0x01 || rfu != 0x00) {
+		dev_err(dev, "AS3645A not detected "
+			"(model %d rfu %d)\n", model, rfu);
+		return -ENODEV;
+	}
+
+	switch (man) {
+	case 1:
+		vendor = "AMS, Austria Micro Systems";
+		break;
+	case 2:
+		vendor = "ADI, Analog Devices Inc.";
+		break;
+	case 3:
+		vendor = "NSC, National Semiconductor";
+		break;
+	case 4:
+		vendor = "NXP";
+		break;
+	case 5:
+		vendor = "TI, Texas Instrument";
+		break;
+	default:
+		vendor = "Unknown";
+	}
+
+	dev_info(dev, "Chip vendor: %s (%d) Version: %d\n", vendor,
+		 man, version);
+
+	rval = as3645a_write(flash, AS_PASSWORD_REG, AS_PASSWORD_UNLOCK_VALUE);
+	if (rval < 0)
+		return rval;
+
+	return as3645a_write(flash, AS_BOOST_REG, AS_BOOST_CURRENT_DISABLE);
+}
+
+static int as3645a_parse_node(struct as3645a *flash,
+			      struct as3645a_names *names,
+			      struct device_node *node)
+{
+	struct as3645a_config *cfg = &flash->cfg;
+	const char *name;
+	int rval;
+
+	flash->flash_node = of_get_child_by_name(node, "flash");
+	if (!flash->flash_node) {
+		dev_err(&flash->client->dev, "can't find flash node\n");
+		return -ENODEV;
+	}
+
+	rval = of_property_read_string(flash->flash_node, "label", &name);
+	if (!rval)
+		strlcpy(names->flash, name, sizeof(names->flash));
+	else
+		snprintf(names->flash, sizeof(names->flash),
+			 "%s:flash", node->name);
+
+	rval = of_property_read_u32(flash->flash_node, "flash-timeout-us",
+				    &cfg->flash_timeout_us);
+	if (rval < 0) {
+		dev_err(&flash->client->dev,
+			"can't read flash-timeout-us property for flash\n");
+		goto out_err;
+	}
+
+	rval = of_property_read_u32(flash->flash_node, "flash-max-microamp",
+				    &cfg->flash_max_ua);
+	if (rval < 0) {
+		dev_err(&flash->client->dev,
+			"can't read flash-max-microamp property for flash\n");
+		goto out_err;
+	}
+
+	rval = of_property_read_u32(flash->flash_node, "led-max-microamp",
+				    &cfg->assist_max_ua);
+	if (rval < 0) {
+		dev_err(&flash->client->dev,
+			"can't read led-max-microamp property for flash\n");
+		goto out_err;
+	}
+
+	of_property_read_u32(flash->flash_node, "voltage-reference",
+			     &cfg->voltage_reference);
+
+	of_property_read_u32(flash->flash_node, "peak-current-limit",
+			     &cfg->peak);
+	cfg->peak = AS_PEAK_mA_TO_REG(cfg->peak);
+
+	flash->indicator_node = of_get_child_by_name(node, "indicator");
+	if (!flash->indicator_node) {
+		dev_warn(&flash->client->dev,
+			 "can't find indicator node\n");
+		goto out_err;
+	}
+
+	rval = of_property_read_string(flash->indicator_node, "label", &name);
+	if (!rval)
+		strlcpy(names->indicator, name, sizeof(names->indicator));
+	else
+		snprintf(names->indicator, sizeof(names->indicator),
+			 "%s:indicator", node->name);
+
+	rval = of_property_read_u32(flash->indicator_node, "led-max-microamp",
+				    &cfg->indicator_max_ua);
+	if (rval < 0) {
+		dev_err(&flash->client->dev,
+			"can't read led-max-microamp property for indicator\n");
+		goto out_err;
+	}
+
+	return 0;
+
+out_err:
+	of_node_put(flash->flash_node);
+	of_node_put(flash->indicator_node);
+
+	return rval;
+}
+
+static int as3645a_led_class_setup(struct as3645a *flash,
+				   struct as3645a_names *names)
+{
+	struct led_classdev *fled_cdev = &flash->fled.led_cdev;
+	struct led_classdev *iled_cdev = &flash->iled_cdev;
+	struct led_flash_setting *cfg;
+	int rval;
+
+	iled_cdev->name = names->indicator;
+	iled_cdev->brightness_set_blocking = as3645a_set_indicator_brightness;
+	iled_cdev->max_brightness =
+		flash->cfg.indicator_max_ua / AS_INDICATOR_INTENSITY_STEP;
+	iled_cdev->flags = LED_CORE_SUSPENDRESUME;
+
+	rval = led_classdev_register(&flash->client->dev, iled_cdev);
+	if (rval < 0)
+		return rval;
+
+	cfg = &flash->fled.brightness;
+	cfg->min = AS_FLASH_INTENSITY_MIN;
+	cfg->max = flash->cfg.flash_max_ua;
+	cfg->step = AS_FLASH_INTENSITY_STEP;
+	cfg->val = flash->cfg.flash_max_ua;
+
+	cfg = &flash->fled.timeout;
+	cfg->min = AS_FLASH_TIMEOUT_MIN;
+	cfg->max = flash->cfg.flash_timeout_us;
+	cfg->step = AS_FLASH_TIMEOUT_STEP;
+	cfg->val = flash->cfg.flash_timeout_us;
+
+	flash->fled.ops = &as3645a_led_flash_ops;
+
+	fled_cdev->name = names->flash;
+	fled_cdev->brightness_set_blocking = as3645a_set_assist_brightness;
+	/* Value 0 is off in LED class. */
+	fled_cdev->max_brightness =
+		as3645a_current_to_reg(flash, false,
+				       flash->cfg.assist_max_ua) + 1;
+	fled_cdev->flags = LED_DEV_CAP_FLASH | LED_CORE_SUSPENDRESUME;
+
+	rval = led_classdev_flash_register(&flash->client->dev, &flash->fled);
+	if (rval) {
+		led_classdev_unregister(iled_cdev);
+		dev_err(&flash->client->dev,
+			"led_classdev_flash_register() failed, error %d\n",
+			rval);
+	}
+
+	return rval;
+}
+
+static int as3645a_v4l2_setup(struct as3645a *flash)
+{
+	struct led_classdev_flash *fled = &flash->fled;
+	struct led_classdev *led = &fled->led_cdev;
+	struct v4l2_flash_config cfg = {
+		.intensity = {
+			.min = AS_TORCH_INTENSITY_MIN,
+			.max = flash->cfg.assist_max_ua,
+			.step = AS_TORCH_INTENSITY_STEP,
+			.val = flash->cfg.assist_max_ua,
+		},
+	};
+	struct v4l2_flash_config cfgind = {
+		.intensity = {
+			.min = AS_INDICATOR_INTENSITY_MIN,
+			.max = flash->cfg.indicator_max_ua,
+			.step = AS_INDICATOR_INTENSITY_STEP,
+			.val = flash->cfg.indicator_max_ua,
+		},
+	};
+
+	strlcpy(cfg.dev_name, led->name, sizeof(cfg.dev_name));
+	strlcpy(cfgind.dev_name, flash->iled_cdev.name, sizeof(cfg.dev_name));
+
+	flash->vf = v4l2_flash_init(
+		&flash->client->dev, of_fwnode_handle(flash->flash_node),
+		&flash->fled, NULL, &cfg);
+	if (IS_ERR(flash->vf))
+		return PTR_ERR(flash->vf);
+
+	flash->vfind = v4l2_flash_indicator_init(
+		&flash->client->dev, of_fwnode_handle(flash->indicator_node),
+		&flash->iled_cdev, &cfgind);
+	if (IS_ERR(flash->vfind)) {
+		v4l2_flash_release(flash->vf);
+		return PTR_ERR(flash->vfind);
+	}
+
+	return 0;
+}
+
+static int as3645a_probe(struct i2c_client *client)
+{
+	struct as3645a_names names;
+	struct as3645a *flash;
+	int rval;
+
+	if (client->dev.of_node == NULL)
+		return -ENODEV;
+
+	flash = devm_kzalloc(&client->dev, sizeof(*flash), GFP_KERNEL);
+	if (flash == NULL)
+		return -ENOMEM;
+
+	flash->client = client;
+
+	rval = as3645a_parse_node(flash, &names, client->dev.of_node);
+	if (rval < 0)
+		return rval;
+
+	rval = as3645a_detect(flash);
+	if (rval < 0)
+		goto out_put_nodes;
+
+	mutex_init(&flash->mutex);
+	i2c_set_clientdata(client, flash);
+
+	rval = as3645a_setup(flash);
+	if (rval)
+		goto out_mutex_destroy;
+
+	rval = as3645a_led_class_setup(flash, &names);
+	if (rval)
+		goto out_mutex_destroy;
+
+	rval = as3645a_v4l2_setup(flash);
+	if (rval)
+		goto out_led_classdev_flash_unregister;
+
+	return 0;
+
+out_led_classdev_flash_unregister:
+	led_classdev_flash_unregister(&flash->fled);
+
+out_mutex_destroy:
+	mutex_destroy(&flash->mutex);
+
+out_put_nodes:
+	of_node_put(flash->flash_node);
+	of_node_put(flash->indicator_node);
+
+	return rval;
+}
+
+static int as3645a_remove(struct i2c_client *client)
+{
+	struct as3645a *flash = i2c_get_clientdata(client);
+
+	as3645a_set_control(flash, AS_MODE_EXT_TORCH, false);
+
+	v4l2_flash_release(flash->vf);
+
+	led_classdev_flash_unregister(&flash->fled);
+	led_classdev_unregister(&flash->iled_cdev);
+
+	mutex_destroy(&flash->mutex);
+
+	of_node_put(flash->flash_node);
+	of_node_put(flash->indicator_node);
+
+	return 0;
+}
+
+static const struct i2c_device_id as3645a_id_table[] = {
+	{ AS_NAME, 0 },
+	{ },
+};
+MODULE_DEVICE_TABLE(i2c, as3645a_id_table);
+
+static const struct of_device_id as3645a_of_table[] = {
+	{ .compatible = "ams,as3645a" },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, as3645a_of_table);
+
+static struct i2c_driver as3645a_i2c_driver = {
+	.driver	= {
+		.of_match_table = as3645a_of_table,
+		.name = AS_NAME,
+	},
+	.probe_new	= as3645a_probe,
+	.remove	= as3645a_remove,
+	.id_table = as3645a_id_table,
+};
+
+module_i2c_driver(as3645a_i2c_driver);
+
+MODULE_AUTHOR("Laurent Pinchart <laurent.pinchart@ideasonboard.com>");
+MODULE_AUTHOR("Sakari Ailus <sakari.ailus@iki.fi>");
+MODULE_DESCRIPTION("LED flash driver for AS3645A, LM3555 and their clones");
+MODULE_LICENSE("GPL v2");
-- 
2.11.0
