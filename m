Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:60631 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751492Ab1IIPAF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 9 Sep 2011 11:00:05 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: "Ivan T . Ivanov" <iivanov@mm-sol.com>, linux-media@vger.kernel.org
Cc: Tuukka Toivonen <tuukkat76@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [RFC][PATCH] as3645a: introduce new LED Flash driver
Date: Fri,  9 Sep 2011 17:59:31 +0300
Message-Id: <020b9977ca7e8f0eabfe1b52b7f37a2105611605.1315580169.git.andriy.shevchenko@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The driver supports the AS3645A, LM3555 chips and their clones.

Accordingly to datasheet the AS3645 chip is a "1000/720mA Ultra Small High
efficient single/dual LED Flash Driver with Safety Features". LM3555 is similar
one, that has following difference - the current in the torch mode is the same
(60mA) for the levels 0, 1, and 2.

This driver is a huge rework of the previously published driver which could be
found in the MeeGo kernel package.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/media/video/Kconfig   |    7 +
 drivers/media/video/Makefile  |    1 +
 drivers/media/video/as3645a.c |  932 +++++++++++++++++++++++++++++++++++++++++
 include/media/as3645a.h       |   59 +++
 4 files changed, 999 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/as3645a.c
 create mode 100644 include/media/as3645a.h

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 6a25fad..5f1dbb1 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -498,6 +498,13 @@ config VIDEO_ADP1653
 	  This is a driver for the ADP1653 flash controller. It is used for
 	  example in Nokia N900.
 
+config VIDEO_AS3645A
+	tristate "AS3645A flash driver support"
+	depends on I2C && VIDEO_V4L2 && MEDIA_CONTROLLER
+	---help---
+	  This is a driver for the AS3645A, LM3555 flash chips and their
+	  clones.
+
 comment "Video improvement chips"
 
 config VIDEO_UPD64031A
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index 2723900..e03a1b3 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -71,6 +71,7 @@ obj-$(CONFIG_VIDEO_SR030PC30)	+= sr030pc30.o
 obj-$(CONFIG_VIDEO_NOON010PC30)	+= noon010pc30.o
 obj-$(CONFIG_VIDEO_M5MOLS)	+= m5mols/
 obj-$(CONFIG_VIDEO_ADP1653)	+= adp1653.o
+obj-$(CONFIG_VIDEO_AS3645A)	+= as3645a.o
 
 obj-$(CONFIG_SOC_CAMERA_IMX074)		+= imx074.o
 obj-$(CONFIG_SOC_CAMERA_MT9M001)	+= mt9m001.o
diff --git a/drivers/media/video/as3645a.c b/drivers/media/video/as3645a.c
new file mode 100644
index 0000000..c2e445f
--- /dev/null
+++ b/drivers/media/video/as3645a.c
@@ -0,0 +1,932 @@
+/*
+ * drivers/media/video/as3645a.c
+ * LED Flash driver for AS3645a, LM3555 and their clones.
+ *
+ * Copyright (C) 2008 Nokia Corporation
+ * Copyright (c) 2011, Intel Corporation.
+ *
+ * Based on adp1653.c by:
+ *      Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
+ *      Tuukka Toivonen <tuukkat76@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms and conditions of the GNU General Public
+ * License, version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St - Fifth Floor, Boston, MA
+ * 02110-1301 USA.
+ *
+ * NOTES:
+ * - Using only i2c strobing
+ * - Inductor peak current limit setting fixed to 1.75A
+ * - VREF offset fixed to 0V
+ * - Increasing Flash light intensity does nothing until it is strobed
+ *   (strobe control set to 1)
+ * - Strobing flash disables Torch and Indicator lights
+ * - Torch and Indicator lights are enabled by just increasing intensity
+ *   from zero
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/i2c.h>
+#include <linux/version.h>
+#include <linux/videodev2.h>
+#include <linux/kernel.h>
+#include <linux/ktime.h>
+#include <linux/delay.h>
+#include <linux/timer.h>
+#include <linux/mutex.h>
+
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
+
+#include <media/as3645a.h>
+
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-device.h>
+
+/* Register definitions */
+
+/* Read-only Design info register: Reset state: xxxx 0001 - for Senna */
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
+
+/* 0000=100ms, 0001=150ms, ... 1111=850ms */
+#define AS_INDICATOR_AND_TIMER_TIMER_SHIFT	0
+/* VREF offset (00=0V default, 01=+0.3V, 10=-0.3V, 11=+0.6V) */
+#define AS_INDICATOR_AND_TIMER_VREF_SHIFT	4
+/* Indicator LED current (00=2.5mA, 01=5mA, 10=7.5mA, 11=10mA) */
+#define AS_INDICATOR_AND_TIMER_INDICATOR_SHIFT	6
+
+/* Read / Write	(Current set register): Reset state: 0110 1001 */
+#define AS_CURRENT_SET_REG			0x03
+
+/* Assist light current (000=20mA, 001=40mA, ... 111=160mA */
+#define AS_CURRENT_ASSIST_LIGHT_SHIFT		0
+/* LED amount detection (0=disabled, 1=enabled). Default is enabled. */
+#define AS_CURRENT_LED_DETECT_SHIFT		3
+/* Flash current (0000=200mA, 0001=220mA, ... 1111=500mA */
+#define AS_CURRENT_FLASH_CURRENT_SHIFT		4
+
+/* Read / Write	(Control register): Reset state: 1011 0100 */
+#define AS_CONTROL_REG				0x04
+
+/* Output mode select, Default is external torch mode.
+ * 00=external torch mode, 01=indicator mode
+ * 10=assist light mode, 11=flash mode
+ */
+#define AS_CONTROL_OUTPUT_MODE_SELECT_SHIFT	0
+#define AS_CONTROL_OUTPUT_MODE_SELECT_MASK	0x03
+
+/* Strobe signal on/off (0=disabled, 1=enabled). Default is enabled. */
+#define AS_CONTROL_STROBE_ON_SHIFT		2
+#define AS_CONTROL_STROBE_ON_MASK		0x04
+
+/* Turn on output: indicator, assist light, flash (0=off, 1=on) */
+#define AS_CONTROL_TURN_ON_OUTPUT_SHIFT		3
+#define AS_CONTROL_TURN_ON_OUTPUT_MASK		0x08
+
+/* External torch mode allowed in standby mode (0=not allowed, 1=allowed)) */
+#define AS_CONTROL_TORCH_IN_STANDBY_SHIFT	4
+#define AS_CONTROL_TORCH_IN_STANDBY_MASK	0x10
+
+/* Strobe signal type (0=edge sensitive, 1=level sensitive) */
+#define AS_CONTROL_STROBE_TYPE_SHIFT		5
+#define AS_CONTROL_STROBE_TYPE_MASK		0x20
+/* Inductor peak current limit settings
+ * (00=1.25A, 01=1.5A, 10=1.75A default, 11=maximum 2.0A)
+ */
+#define AS_CONTROL_INDUCTOR_PEAK_SELECT_SHIFT	6
+#define AS_CONTROL_INDUCTOR_PEAK_SELECT_MASK	0xc0
+
+/* Read only (D3 is read / write) (Fault and info): Reset state: 0000 x000 */
+#define AS_FAULT_INFO_REG			0x05
+
+#define AS_FAULT_INFO_RFU			0x01
+/* Inductor peak current limit fault (1=fault, 0=no fault) */
+#define AS_FAULT_INFO_INDUCTOR_PEAK_LIMIT	0x02
+/* Indicator LED fault (1=fault, 0=no fault);
+ * fault is either short circuit or open loop
+ */
+#define AS_FAULT_INFO_INDICATOR_LED		0x04
+/* Amount of LEDs (1=two LEDs, 0=only one LED) */
+#define AS_FAULT_INFO_LED_AMOUNT		0x08
+/* Timeout fault (1=fault, 0=no fault) */
+#define AS_FAULT_INFO_TIMEOUT			0x10
+/* Over Temperature Protection (OTP) fault (1=fault, 0=no fault) */
+#define AS_FAULT_INFO_OVER_TEMPERATURE		0x20
+/* Short circuit fault (1=fault, 0=no fault) */
+#define AS_FAULT_INFO_SHORT_CIRCUIT		0x40
+/* Over voltage protection (OVP) fault (1=fault, 0=no fault) */
+#define AS_FAULT_INFO_OVER_VOLTAGE		0x80
+
+/* Operating mode */
+#define AS_MODE_EXT_TORCH	0x00
+#define AS_MODE_INDICATOR	0x01
+#define AS_MODE_ASSIST		0x02
+#define AS_MODE_FLASH		0x03
+
+/* Flash timeout */
+#define AS_TIMER_us_TO_CODE(t)				\
+	((t) < AS3645A_MIN_FLASH_LEN ? 0 :		\
+	(((t) - AS3645A_MIN_FLASH_LEN) / AS3645A_STEP_FLASH_LEN))
+#define AS_TIMER_CODE_TO_us(c)				\
+	(AS3645A_MIN_FLASH_LEN + AS3645A_STEP_FLASH_LEN * (c))
+
+/* Flash intensity */
+#define AS_FLASH_INTENSITY_mA_TO_CODE(a)		\
+	((a) < AS3645A_MIN_FLASH_INTENSITY ? 0 :	\
+	(((a) - AS3645A_MIN_FLASH_INTENSITY) / AS3645A_STEP_FLASH_INTENSITY))
+#define AS_FLASH_INTENSITY_CODE_TO_mA(c)		\
+	(AS3645A_MIN_FLASH_INTENSITY + (c) * AS3645A_STEP_FLASH_INTENSITY)
+
+/* Torch intensity */
+#define AS_TORCH_INTENSITY_mA_TO_CODE(a)		\
+	((a) < AS3645A_MIN_TORCH_INTENSITY ? 0 :	\
+	(((a) - AS3645A_MIN_TORCH_INTENSITY) / AS3645A_STEP_TORCH_INTENSITY))
+#define AS_TORCH_INTENSITY_CODE_TO_mA(c)		\
+	(AS3645A_MIN_TORCH_INTENSITY + (c) * AS3645A_STEP_TORCH_INTENSITY)
+
+/* Indicator intensity */
+#define AS_INDICATOR_INTENSITY_uA_TO_CODE(a)		\
+	((a) < AS3645A_MIN_INDICATOR_INTENSITY ? 0 :	\
+	(((a) - AS3645A_MIN_INDICATOR_INTENSITY) /	\
+	AS3645A_STEP_INDICATOR_INTENSITY))
+#define AS_INDICATOR_INTENSITY_CODE_TO_uA(c)		\
+	(AS3645A_MIN_INDICATOR_INTENSITY + (c) *	\
+	AS3645A_STEP_INDICATOR_INTENSITY)
+
+struct as3645a {
+	struct v4l2_subdev subdev;
+	struct as3645a_platform_data *platform_data;
+
+	struct v4l2_ctrl_handler ctrls;
+	struct v4l2_ctrl *led_mode;
+	struct v4l2_ctrl *strobe_source;
+	struct v4l2_ctrl *flash_timeout;
+	struct v4l2_ctrl *flash_intensity;
+	struct v4l2_ctrl *torch_intensity;
+	struct v4l2_ctrl *indicator_intensity;
+
+	struct dentry *dbgfs_root;
+
+	struct mutex power_lock;
+	int power_count;
+
+	/* Fault and info register. Faults are saved here when user
+	 * checks any fault (cleared when flash is triggered)
+	 */
+	u8 fault;
+
+	u8 vref;
+	u8 peak;
+};
+
+#define to_as3645a(sd) container_of(sd, struct as3645a, subdev)
+
+/* Return negative errno else zero on success */
+static int as3645a_write(struct as3645a *flash, u8 addr, u8 val)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(&flash->subdev);
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
+	struct i2c_client *client = v4l2_get_subdevdata(&flash->subdev);
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
+static int as3645a_hw_commit_r2(struct as3645a *flash)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(&flash->subdev);
+	u8 reg;
+	int rval;
+
+	/* Fill indicator and timeout registers. */
+	reg = AS_TIMER_us_TO_CODE(flash->flash_timeout->
+			val) << AS_INDICATOR_AND_TIMER_TIMER_SHIFT;
+	reg |= flash->vref << AS_INDICATOR_AND_TIMER_VREF_SHIFT;
+	reg |= AS_INDICATOR_INTENSITY_uA_TO_CODE(flash->indicator_intensity->
+			val) << AS_INDICATOR_AND_TIMER_INDICATOR_SHIFT;
+
+	rval = as3645a_write(flash, AS_INDICATOR_AND_TIMER_REG, reg);
+	if (rval) {
+		dev_err(&client->dev,
+			"Writing to timeout and indicator register failed\n");
+		return rval;
+	}
+
+	return 0;
+}
+
+static int as3645a_hw_commit_r3(struct as3645a *flash)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(&flash->subdev);
+	u8 reg;
+	int rval;
+
+	/* fill current set register */
+	reg = AS_FLASH_INTENSITY_mA_TO_CODE(flash->flash_intensity->
+			val) << AS_CURRENT_FLASH_CURRENT_SHIFT;
+	reg |= AS_TORCH_INTENSITY_mA_TO_CODE(flash->torch_intensity->
+			val) << AS_CURRENT_ASSIST_LIGHT_SHIFT;
+	/* always enabled */
+	reg |= 1 << AS_CURRENT_LED_DETECT_SHIFT;
+
+	rval = as3645a_write(flash, AS_CURRENT_SET_REG, reg);
+	if (rval) {
+		dev_err(&client->dev, "Writing to current register failed\n");
+		return rval;
+	}
+
+	return 0;
+}
+
+static int as3645a_hw_commit_r4(struct as3645a *flash)
+{
+	u8 reg = 0;
+	int hard = 0;
+	struct i2c_client *client = v4l2_get_subdevdata(&flash->subdev);
+	int rval;
+
+	/* Fill control register */
+	switch (flash->led_mode->val) {
+	case V4L2_FLASH_LED_MODE_FLASH:
+		/* Flash mode, light on with strobe, duration from timer */
+		reg = AS_MODE_FLASH << AS_CONTROL_OUTPUT_MODE_SELECT_SHIFT;
+		break;
+	case V4L2_FLASH_LED_MODE_TORCH:
+		/* Torch mode, light immediately on, duration indefinite */
+		reg = AS_MODE_ASSIST << AS_CONTROL_OUTPUT_MODE_SELECT_SHIFT;
+		reg |= 1 << AS_CONTROL_TURN_ON_OUTPUT_SHIFT;
+		break;
+	}
+
+	if (flash->strobe_source->val == V4L2_FLASH_STROBE_SOURCE_EXTERNAL)
+		hard = 1;
+
+	reg |= flash->peak << AS_CONTROL_INDUCTOR_PEAK_SELECT_SHIFT;
+	reg |= hard << AS_CONTROL_STROBE_ON_SHIFT;
+
+	/* Hardware-specific strobe using I/O pin, it's a self cleared action */
+	if (hard)
+		reg |= 1 << AS_CONTROL_STROBE_TYPE_SHIFT;
+
+	rval = as3645a_write(flash, AS_CONTROL_REG, reg);
+	if (rval) {
+		dev_err(&client->dev, "Writing to control register failed\n");
+		return rval;
+	}
+
+	return 0;
+}
+
+static int as3645a_strobe(struct as3645a *flash, int on)
+{
+	int hard = 0;
+	struct i2c_client *client = v4l2_get_subdevdata(&flash->subdev);
+	int rval;
+
+	if (flash->led_mode->val != V4L2_FLASH_LED_MODE_FLASH)
+		return -EBUSY;
+
+	if (flash->strobe_source->val == V4L2_FLASH_STROBE_SOURCE_EXTERNAL)
+		hard = 1;
+
+	if (flash->platform_data->setup_ext_strobe)
+		flash->platform_data->setup_ext_strobe(hard);
+
+	rval = as3645a_read(flash, AS_CONTROL_REG);
+	if (rval < 0)
+		return rval;
+
+	if (on)
+		rval |= 1 << AS_CONTROL_TURN_ON_OUTPUT_SHIFT;
+	else
+		rval &= ~(1 << AS_CONTROL_TURN_ON_OUTPUT_SHIFT);
+
+	dev_dbg(&client->dev, "%s: strobe: %s\n", __func__,
+			on ? (hard ? "external" : "software") : "off");
+
+	return as3645a_write(flash, AS_CONTROL_REG, rval);
+}
+
+static int as3645a_update_hw(struct as3645a *flash)
+{
+	int rval;
+
+	rval = as3645a_hw_commit_r2(flash);
+	if (rval)
+		return rval;
+
+	rval = as3645a_hw_commit_r3(flash);
+	if (rval)
+		return rval;
+
+	rval = as3645a_hw_commit_r4(flash);
+	if (rval)
+		return rval;
+
+	return 0;
+}
+
+/* -----------------------------------------------------------------------------
+ * V4L2 controls
+ */
+
+static int as3645a_read_fault(struct as3645a *flash)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(&flash->subdev);
+	int rval;
+
+	/* NOTE: reading register clear fault status */
+	rval = as3645a_read(flash, AS_FAULT_INFO_REG);
+	if (rval < 0)
+		return rval;
+
+	flash->fault |= rval & ~AS_FAULT_INFO_LED_AMOUNT;
+
+	if (!flash->fault)
+		return 0;
+
+	if (rval & AS_FAULT_INFO_RFU)
+		dev_err(&client->dev, "RFU fault\n");
+
+	if (rval & AS_FAULT_INFO_INDUCTOR_PEAK_LIMIT)
+		dev_err(&client->dev, "Inductor Peak limit fault\n");
+
+	if (rval & AS_FAULT_INFO_INDICATOR_LED)
+		dev_err(&client->dev, "Indicator LED fault: "
+			"Short circuit or open loop\n");
+
+	if (rval & AS_FAULT_INFO_TIMEOUT)
+		dev_err(&client->dev, "Timeout fault\n");
+
+	if (rval & AS_FAULT_INFO_OVER_TEMPERATURE)
+		dev_err(&client->dev, "Over temperature fault\n");
+
+	if (rval & AS_FAULT_INFO_SHORT_CIRCUIT)
+		dev_err(&client->dev, "Short circuit fault\n");
+
+	if (rval & AS_FAULT_INFO_OVER_VOLTAGE)
+		dev_err(&client->dev, "Over voltage fault: "
+			"Indicates missing capacitor or open connection\n");
+
+	/* Turn off the lights */
+	flash->led_mode->val = V4L2_FLASH_LED_MODE_NONE;
+
+	rval = as3645a_update_hw(flash);
+	if (rval)
+		return rval;
+
+	return flash->fault;
+}
+
+static int as3645a_get_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct as3645a *flash =
+		container_of(ctrl->handler, struct as3645a, ctrls);
+	struct i2c_client *client = v4l2_get_subdevdata(&flash->subdev);
+	int rval;
+
+	rval = as3645a_read_fault(flash);
+	if (rval < 0)
+		return rval;
+
+	switch (ctrl->id) {
+	case V4L2_CID_FLASH_FAULT:
+		ctrl->cur.val = 0;
+
+		if (flash->fault & AS_FAULT_INFO_OVER_VOLTAGE)
+			ctrl->cur.val |= V4L2_FLASH_FAULT_OVER_VOLTAGE;
+		if (flash->fault & AS_FAULT_INFO_TIMEOUT)
+			ctrl->cur.val |= V4L2_FLASH_FAULT_TIMEOUT;
+		if (flash->fault & AS_FAULT_INFO_OVER_TEMPERATURE)
+			ctrl->cur.val |= V4L2_FLASH_FAULT_OVER_TEMPERATURE;
+		if (flash->fault & AS_FAULT_INFO_SHORT_CIRCUIT)
+			ctrl->cur.val |= V4L2_FLASH_FAULT_SHORT_CIRCUIT;
+
+		flash->fault = 0;
+
+		break;
+
+	case V4L2_CID_FLASH_READY:
+		rval = as3645a_read(flash, AS_CONTROL_REG);
+		if (rval < 0)
+			return rval;
+
+		if (rval & AS_CONTROL_TURN_ON_OUTPUT_MASK)
+			return -EBUSY;
+
+		ctrl->cur.val = flash->fault ? 0 : 1;
+		if (!ctrl->cur.val)
+			dev_dbg(&client->dev, "G_CTRL: Flash was not ready!\n");
+
+		break;
+	}
+
+	dev_dbg(&client->dev, "G_CTRL %08x:%d\n", ctrl->id, ctrl->cur.val);
+
+	return 0;
+}
+
+static int as3645a_set_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct as3645a *flash =
+		container_of(ctrl->handler, struct as3645a, ctrls);
+	struct i2c_client *client = v4l2_get_subdevdata(&flash->subdev);
+	int rval;
+
+	dev_dbg(&client->dev, "S_CTRL %08x:%d\n", ctrl->id, ctrl->val);
+
+	rval = as3645a_read_fault(flash);
+	if (rval < 0)
+		return rval;
+
+	if ((rval & (AS_FAULT_INFO_INDUCTOR_PEAK_LIMIT |
+		     AS_FAULT_INFO_SHORT_CIRCUIT |
+		     AS_FAULT_INFO_OVER_TEMPERATURE |
+		     AS_FAULT_INFO_OVER_VOLTAGE)) &&
+	    (ctrl->id == V4L2_CID_FLASH_STROBE ||
+	     ctrl->id == V4L2_CID_FLASH_TORCH_INTENSITY ||
+	     ctrl->id == V4L2_CID_FLASH_LED_MODE))
+		return -EBUSY;
+
+	switch (ctrl->id) {
+	case V4L2_CID_FLASH_STROBE:
+		return as3645a_strobe(flash, 1);
+	case V4L2_CID_FLASH_STROBE_STOP:
+		return as3645a_strobe(flash, 0);
+	}
+
+	return as3645a_update_hw(flash);
+}
+
+static const struct v4l2_ctrl_ops as3645a_ctrl_ops = {
+	.g_volatile_ctrl = as3645a_get_ctrl,
+	.s_ctrl = as3645a_set_ctrl,
+};
+
+static int as3645a_init_controls(struct as3645a *flash)
+{
+	struct v4l2_ctrl *fault, *ready;
+
+	v4l2_ctrl_handler_init(&flash->ctrls, 10);
+
+	flash->led_mode = v4l2_ctrl_new_std_menu(&flash->ctrls,
+			&as3645a_ctrl_ops, V4L2_CID_FLASH_LED_MODE,
+			V4L2_FLASH_LED_MODE_TORCH, ~0x7, 0);
+	flash->strobe_source = v4l2_ctrl_new_std_menu(&flash->ctrls,
+			&as3645a_ctrl_ops, V4L2_CID_FLASH_STROBE_SOURCE,
+			V4L2_FLASH_STROBE_SOURCE_EXTERNAL, ~0x03, 0);
+	v4l2_ctrl_new_std(&flash->ctrls, &as3645a_ctrl_ops,
+			V4L2_CID_FLASH_STROBE, 0, 0, 0, 0);
+	v4l2_ctrl_new_std(&flash->ctrls, &as3645a_ctrl_ops,
+			V4L2_CID_FLASH_STROBE_STOP, 0, 0, 0, 0);
+	flash->flash_timeout = v4l2_ctrl_new_std(&flash->ctrls,
+			&as3645a_ctrl_ops, V4L2_CID_FLASH_TIMEOUT,
+			AS3645A_MIN_FLASH_LEN,
+			flash->platform_data->max_flash_timeout,
+			AS3645A_STEP_FLASH_LEN,
+			AS3645A_MIN_FLASH_LEN);
+	flash->flash_intensity = v4l2_ctrl_new_std(&flash->ctrls,
+			&as3645a_ctrl_ops, V4L2_CID_FLASH_INTENSITY,
+			AS3645A_MIN_FLASH_INTENSITY,
+			flash->platform_data->max_flash_intensity,
+			AS3645A_STEP_FLASH_INTENSITY,
+			AS3645A_MIN_FLASH_INTENSITY);
+	flash->torch_intensity = v4l2_ctrl_new_std(&flash->ctrls,
+			&as3645a_ctrl_ops, V4L2_CID_FLASH_TORCH_INTENSITY,
+			AS3645A_MIN_TORCH_INTENSITY,
+			flash->platform_data->max_torch_intensity,
+			AS3645A_STEP_TORCH_INTENSITY,
+			AS3645A_MIN_TORCH_INTENSITY);
+	flash->indicator_intensity = v4l2_ctrl_new_std(&flash->ctrls,
+			&as3645a_ctrl_ops, V4L2_CID_FLASH_INDICATOR_INTENSITY,
+			AS3645A_MIN_INDICATOR_INTENSITY,
+			flash->platform_data->max_indicator_intensity,
+			AS3645A_STEP_INDICATOR_INTENSITY,
+			AS3645A_MIN_INDICATOR_INTENSITY);
+	fault = v4l2_ctrl_new_std(&flash->ctrls, &as3645a_ctrl_ops,
+			V4L2_CID_FLASH_FAULT, 0,
+			V4L2_FLASH_FAULT_OVER_VOLTAGE
+			| V4L2_FLASH_FAULT_OVER_TEMPERATURE
+			| V4L2_FLASH_FAULT_SHORT_CIRCUIT, 0, 0);
+	ready = v4l2_ctrl_new_std(&flash->ctrls, &as3645a_ctrl_ops,
+			V4L2_CID_FLASH_READY, 0, 1, 1, 1);
+
+	if (flash->ctrls.error)
+		return flash->ctrls.error;
+
+	fault->is_volatile = 1;
+	ready->is_volatile = 1;
+
+	flash->subdev.ctrl_handler = &flash->ctrls;
+	return 0;
+}
+
+/* -----------------------------------------------------------------------------
+ * V4L2 subdev core operations
+ */
+
+/* Put device into know state. */
+static int as3645a_setup(struct as3645a *flash)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(&flash->subdev);
+	int rval;
+
+	/* Clear fault status */
+	rval = as3645a_read(flash, AS_FAULT_INFO_REG);
+	if (rval < 0)
+		return rval;
+
+	mutex_lock(&flash->ctrls.lock);
+	flash->fault = 0;
+	rval = as3645a_read_fault(flash);
+	mutex_unlock(&flash->ctrls.lock);
+	if (rval > 0) {
+		dev_err(&client->dev, "faults detected: 0x%1.1x\n", rval);
+		return -EIO;
+	}
+
+	mutex_lock(&flash->ctrls.lock);
+	rval = as3645a_update_hw(flash);
+	mutex_unlock(&flash->ctrls.lock);
+	if (rval) {
+		dev_err(&client->dev, "Update HW failed at %s\n", __func__);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static int __as3645a_set_power(struct as3645a *flash, int on)
+{
+	int ret;
+
+	ret = flash->platform_data->set_power(&flash->subdev, on);
+	if (ret < 0)
+		return ret;
+
+	if (!on)
+		return 0;
+
+	ret = as3645a_setup(flash);
+	if (ret < 0)
+		flash->platform_data->set_power(&flash->subdev, 0);
+
+	return ret;
+}
+
+static int as3645a_set_power(struct v4l2_subdev *sd, int on)
+{
+	struct as3645a *flash = to_as3645a(sd);
+	struct i2c_client *client = v4l2_get_subdevdata(&flash->subdev);
+	int rval = 0;
+
+	mutex_lock(&flash->power_lock);
+
+	/*
+	 * If the power count is modified from 0 to != 0 or from != 0 to 0,
+	 * update the power state.
+	 */
+	if (flash->power_count == !on) {
+		rval = __as3645a_set_power(flash, !!on);
+		if (rval < 0)
+			goto done;
+	}
+
+	/* Update the power count. */
+	flash->power_count += on ? 1 : -1;
+	WARN_ON(flash->power_count < 0);
+
+done:
+	mutex_unlock(&flash->power_lock);
+
+	dev_dbg(&client->dev, "Power-%s %s\n", on ? "on" : "down",
+		rval < 0 ? "fail" : "ok");
+	return rval;
+}
+
+static int as3645a_registered(struct v4l2_subdev *sd)
+{
+	struct as3645a *flash = to_as3645a(sd);
+	struct i2c_client *client = v4l2_get_subdevdata(&flash->subdev);
+	int rval, man, model, rfu, version;
+	const char *factory;
+
+	rval = as3645a_read(flash, AS_DESIGN_INFO_REG);
+	if (rval < 0)
+		return rval;
+
+	man = AS_DESIGN_INFO_FACTORY(rval);
+	model = AS_DESIGN_INFO_MODEL(rval);
+
+	rval = as3645a_read(flash, AS_VERSION_CONTROL_REG);
+	if (rval < 0)
+		return rval;
+
+	rfu = AS_VERSION_CONTROL_RFU(rval);
+	version = AS_VERSION_CONTROL_VERSION(rval);
+
+	if (model != 0x0001 || rfu != 0x0000) {		/* Check for Senna */
+		dev_err(&client->dev, "Senna not detected (model:%d rfu:%d)\n",
+			model, rfu);
+		return -ENODEV;
+	}
+
+	switch (man) {
+	case 1:
+		factory = "AMS, Austria Micro Systems";
+		break;
+	case 2:
+		factory = "ADI, Analog Devices Inc.";
+		break;
+	case 3:
+		factory = "NSC, National Semiconductor";
+		break;
+	case 4:
+		factory = "NXP";
+		break;
+	case 5:
+		factory = "TI, Texas Instrument";
+		break;
+	default:
+		factory = "Unknown";
+	}
+
+	dev_info(&client->dev, "Factory: %s(%d) Version: %d\n", factory, man,
+		version);
+
+	return 0;
+}
+
+static int as3645a_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
+{
+	return as3645a_set_power(sd, 1);
+}
+
+static int as3645a_close(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
+{
+	return as3645a_set_power(sd, 0);
+}
+
+static const struct v4l2_subdev_core_ops as3645a_core_ops = {
+	.s_power	= as3645a_set_power,
+};
+
+static const struct v4l2_subdev_ops as3645a_ops = {
+	.core = &as3645a_core_ops,
+};
+
+static const struct v4l2_subdev_internal_ops as3645a_internal_ops = {
+	.registered = as3645a_registered,
+	.open = as3645a_open,
+	.close = as3645a_close,
+};
+
+/* -----------------------------------------------------------------------------
+ *  I2C driver
+ */
+#ifdef CONFIG_PM
+
+static int as3645a_suspend(struct device *dev)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct v4l2_subdev *subdev = i2c_get_clientdata(client);
+	struct as3645a *flash = to_as3645a(subdev);
+	int rval;
+
+	if (!flash->power_count)
+		return 0;
+
+	rval = __as3645a_set_power(flash, 0);
+
+	dev_dbg(&client->dev, "Suspend %s\n", rval < 0 ? "failed" : "ok");
+
+	return rval;
+}
+
+static int as3645a_resume(struct device *dev)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct v4l2_subdev *subdev = i2c_get_clientdata(client);
+	struct as3645a *flash = to_as3645a(subdev);
+	int rval;
+
+	if (!flash->power_count)
+		return 0;
+
+	rval = __as3645a_set_power(flash, 1);
+
+	dev_dbg(&client->dev, "Resume %s\n", rval < 0 ? "fail" : "ok");
+
+	return rval;
+}
+
+#else
+
+#define as3645a_suspend	NULL
+#define as3645a_resume	NULL
+
+#endif /* CONFIG_PM */
+
+static int as3645a_regs_show(struct seq_file *sf, void *data)
+{
+	struct as3645a *flash = sf->private;
+	int ret;
+
+	ret = as3645a_read(flash, AS_INDICATOR_AND_TIMER_REG);
+	if (ret < 0)
+		return ret;
+	seq_printf(sf, "AS_INDICATOR_AND_TIMER_REG: %02X\n", ret);
+
+	ret = as3645a_read(flash, AS_CURRENT_SET_REG);
+	if (ret < 0)
+		return ret;
+	seq_printf(sf, "AS_CURRENT_SET_REG: %02X\n", ret);
+
+	ret = as3645a_read(flash, AS_CONTROL_REG);
+	if (ret < 0)
+		return ret;
+	seq_printf(sf, "AS_CONTROL_REG: %02X\n", ret);
+
+	return 0;
+}
+
+static int as3645a_regs_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, as3645a_regs_show, inode->i_private);
+}
+
+static const struct file_operations as3645a_fops_regs = {
+	.open		= as3645a_regs_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static void as3645a_dbgfs_create(struct as3645a *flash)
+{
+	struct dentry *root;
+	struct i2c_client *client = v4l2_get_subdevdata(&flash->subdev);
+
+	root = debugfs_create_dir(AS3645A_NAME, NULL);
+	if (IS_ERR(root))
+		/* Don't complain -- debugfs just isn't enabled */
+		return;
+	if (!root)
+		/* Complain -- debugfs is enabled, but it failed to
+		 * create the directory. */
+		goto err_root;
+
+	flash->dbgfs_root = root;
+
+	if (!debugfs_create_file("regs", S_IRUSR, root, flash,
+			&as3645a_fops_regs))
+		goto err_node;
+
+	return;
+
+err_node:
+	debugfs_remove_recursive(root);
+	flash->dbgfs_root = NULL;
+err_root:
+	dev_err(&client->dev, "failed to initialize debugfs\n");
+}
+
+static int as3645a_probe(struct i2c_client *client,
+			 const struct i2c_device_id *devid)
+{
+	struct as3645a *flash;
+	int ret;
+
+	/* we couldn't work without platform data */
+	if (client->dev.platform_data == NULL)
+		return -ENODEV;
+
+	flash = kzalloc(sizeof(*flash), GFP_KERNEL);
+	if (flash == NULL)
+		return -ENOMEM;
+
+	flash->platform_data = client->dev.platform_data;
+
+	/* FIXME: These are hard coded for now */
+	flash->vref = 0;	/* 0V */
+	flash->peak = 2;	/* 1.75A */
+
+	mutex_init(&flash->power_lock);
+
+	v4l2_i2c_subdev_init(&flash->subdev, client, &as3645a_ops);
+	flash->subdev.internal_ops = &as3645a_internal_ops;
+	flash->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+
+	ret = as3645a_init_controls(flash);
+	if (ret)
+		goto free_and_quit;
+
+	ret = media_entity_init(&flash->subdev.entity, 0, NULL, 0);
+	if (ret < 0)
+		goto free_and_quit;
+
+	flash->subdev.entity.type = MEDIA_ENT_T_V4L2_SUBDEV_FLASH;
+
+	as3645a_dbgfs_create(flash);
+
+	return 0;
+
+free_and_quit:
+	v4l2_ctrl_handler_free(&flash->ctrls);
+	kfree(flash);
+	return ret;
+}
+
+static int __exit as3645a_remove(struct i2c_client *client)
+{
+	struct v4l2_subdev *subdev = i2c_get_clientdata(client);
+	struct as3645a *flash = to_as3645a(subdev);
+
+	debugfs_remove_recursive(flash->dbgfs_root);
+
+	v4l2_device_unregister_subdev(subdev);
+	v4l2_ctrl_handler_free(&flash->ctrls);
+	media_entity_cleanup(&flash->subdev.entity);
+	kfree(flash);
+
+	return 0;
+}
+
+static const struct i2c_device_id as3645a_id_table[] = {
+	{ AS3645A_NAME, 0 },
+	{ },
+};
+MODULE_DEVICE_TABLE(i2c, as3645a_id_table);
+
+static const struct dev_pm_ops as3645a_pm_ops = {
+	.suspend = as3645a_suspend,
+	.resume = as3645a_resume,
+};
+
+static struct i2c_driver as3645_driver = {
+	.driver = {
+		.name = AS3645A_NAME,
+		.pm   = &as3645a_pm_ops,
+	},
+	.probe = as3645a_probe,
+	.remove = __exit_p(as3645a_remove),
+	.id_table = as3645a_id_table,
+};
+
+static __init int init_as3645(void)
+{
+	return i2c_add_driver(&as3645_driver);
+}
+
+static __exit void exit_as3645(void)
+{
+	i2c_del_driver(&as3645_driver);
+}
+
+module_init(init_as3645);
+module_exit(exit_as3645);
+
+MODULE_AUTHOR("Ivan T. Ivanov <iivanov@mm-sol.com>");
+MODULE_AUTHOR("Andy Shevchenko <andriy.shevchenko@linux.intel.com>");
+MODULE_DESCRIPTION("LED Flash driver for AS3645a, LM3555 and their clones");
+MODULE_LICENSE("GPL");
diff --git a/include/media/as3645a.h b/include/media/as3645a.h
new file mode 100644
index 0000000..26f558a
--- /dev/null
+++ b/include/media/as3645a.h
@@ -0,0 +1,59 @@
+/*
+ * include/media/as3645a.h
+ *
+ * Copyright (C) 2008 Nokia Corporation
+ * Copyright (c) 2011, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms and conditions of the GNU General Public
+ * License, version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St - Fifth Floor, Boston, MA
+ * 02110-1301 USA.
+ *
+ */
+
+#ifndef __AS3645A_H__
+#define __AS3645A_H__
+
+#include <media/v4l2-subdev.h>
+
+#define AS3645A_NAME				"as3645a"
+#define AS3645A_I2C_ADDR			(0x60 >> 1) /* W:0x60, R:0x61 */
+
+struct as3645a_platform_data {
+	int (*set_power)(struct v4l2_subdev *subdev, int on);
+
+	/* Notify an entity that triggers an external strobe */
+	int (*setup_ext_strobe)(int enable);
+
+	u32 max_flash_timeout;		/* flash light timeout in us */
+	u32 max_flash_intensity;	/* led intensity, flash mode */
+	u32 max_torch_intensity;	/* led intensity, torch mode */
+	u32 max_indicator_intensity;	/* indicator led intensity */
+};
+
+#define AS3645A_MIN_FLASH_LEN			100000	/* us */
+#define AS3645A_MAX_FLASH_LEN			850000
+#define AS3645A_STEP_FLASH_LEN			50000
+
+#define AS3645A_MIN_FLASH_INTENSITY		200	/* mA */
+#define AS3645A_MAX_FLASH_INTENSITY		500
+#define AS3645A_STEP_FLASH_INTENSITY		20
+
+#define AS3645A_MIN_TORCH_INTENSITY		20	/* mA */
+#define AS3645A_MAX_TORCH_INTENSITY		160
+#define AS3645A_STEP_TORCH_INTENSITY		20
+
+#define AS3645A_MIN_INDICATOR_INTENSITY		2500	/* uA */
+#define AS3645A_MAX_INDICATOR_INTENSITY		10000
+#define AS3645A_STEP_INDICATOR_INTENSITY	2500
+
+#endif /* __AS3645A_H__ */
-- 
1.7.5.4

