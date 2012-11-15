Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44351 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932299Ab2KOAO5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Nov 2012 19:14:57 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Florian Neuhaus <florian.neuhaus@reberinformatik.ch>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	David Cohen <dacohen@gmail.com>, linux-media@vger.kernel.org
Subject: [PATCH] ad5820: Voice coil motor controller driver
Date: Thu, 15 Nov 2012 01:15:46 +0100
Message-Id: <1352938546-22104-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <6EE9CD707FBED24483D4CB0162E854671008F9FD@AM2PRD0710MB375.eurprd07.prod.outlook.com>
References: <6EE9CD707FBED24483D4CB0162E854671008F9FD@AM2PRD0710MB375.eurprd07.prod.outlook.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The AD5820 is a voice coil motor controller typically used to control
lens position in digital cameras.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/i2c/Kconfig  |    9 +
 drivers/media/i2c/Makefile |    1 +
 drivers/media/i2c/ad5820.c |  496 ++++++++++++++++++++++++++++++++++++++++++++
 include/media/ad5820.h     |   30 +++
 4 files changed, 536 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/i2c/ad5820.c
 create mode 100644 include/media/ad5820.h

Hi Florian,

This is the ad5820 driver I've told you about. The code is compile-tested only
as I haven't had time to try it on an N900 (the only device I own that
includes an ad5820).

It should be quite easy to adapt the driver to support both the ad5820 and the
ad5821. Would you have time to give it a try ?

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 24d78e2..65597cf 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -534,6 +534,15 @@ config VIDEO_AS3645A
 	  This is a driver for the AS3645A and LM3555 flash controllers. It has
 	  build in control for flash, torch and indicator LEDs.
 
+comment "Lens controllers"
+
+config VIDEO_AD5820
+	tristate "AD5820 lens voice coil support"
+	depends on I2C && VIDEO_V4L2 && MEDIA_CONTROLLER
+	---help---
+	  This is a driver for the AD5820 camera lens voice coil.
+	  It is used for example in Nokia RX51.
+
 comment "Video improvement chips"
 
 config VIDEO_UPD64031A
diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
index b1d62df..975cfb8 100644
--- a/drivers/media/i2c/Makefile
+++ b/drivers/media/i2c/Makefile
@@ -58,6 +58,7 @@ obj-$(CONFIG_VIDEO_SR030PC30)	+= sr030pc30.o
 obj-$(CONFIG_VIDEO_NOON010PC30)	+= noon010pc30.o
 obj-$(CONFIG_VIDEO_S5K6AA)	+= s5k6aa.o
 obj-$(CONFIG_VIDEO_S5K4ECGX)	+= s5k4ecgx.o
+obj-$(CONFIG_VIDEO_AD5820)	+= ad5820.o
 obj-$(CONFIG_VIDEO_ADP1653)	+= adp1653.o
 obj-$(CONFIG_VIDEO_AS3645A)	+= as3645a.o
 obj-$(CONFIG_VIDEO_SMIAPP_PLL)	+= smiapp-pll.o
diff --git a/drivers/media/i2c/ad5820.c b/drivers/media/i2c/ad5820.c
new file mode 100644
index 0000000..995774f
--- /dev/null
+++ b/drivers/media/i2c/ad5820.c
@@ -0,0 +1,496 @@
+/*
+ * AD5820 DAC driver for camera voice coil focus.
+ *
+ * Copyright (C) 2008 Nokia Corporation
+ * Copyright (C) 2007 Texas Instruments
+ *
+ * Contact: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
+ *          Sakari Ailus <sakari.ailus@iki.fi>
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
+#include <linux/bitops.h>
+#include <linux/delay.h>
+#include <linux/errno.h>
+#include <linux/gpio.h>
+#include <linux/i2c.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/regulator/consumer.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+
+#include <media/ad5820.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-subdev.h>
+
+/* Register definitions */
+#define AD5820_POWER_DOWN		(1 << 15)
+#define AD5820_DAC_SHIFT		4
+#define AD5820_RAMP_MODE_LINEAR		(0 << 3)
+#define AD5820_RAMP_MODE_64_16		(1 << 3)
+
+#define CODE_TO_RAMP_US(s)		((s) == 0 ? 0 : (1 << ((s) - 1)) * 50)
+#define RAMP_US_TO_CODE(c)		fls(((c) + ((c)>>1)) / 50)
+
+struct ad5820_device {
+	struct v4l2_subdev subdev;
+
+	struct regulator *vana;
+	int xshutdown;
+
+	struct v4l2_ctrl_handler ctrls;
+	u32 focus_absolute;
+	u32 focus_ramp_time;
+	u32 focus_ramp_mode;
+
+	struct mutex power_lock;
+	int power_count;
+
+	int standby:1;
+};
+
+#define to_ad5820_device(sd)	container_of(sd, struct ad5820_device, subdev)
+
+/**
+ * @brief I2C write using i2c_transfer().
+ * @param coil - the driver data structure
+ * @param data - register value to be written
+ * @returns nonnegative on success, negative if failed
+ */
+static int ad5820_write(struct ad5820_device *coil, u16 data)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(&coil->subdev);
+	struct i2c_msg msg;
+	int r;
+
+	if (!client->adapter)
+		return -ENODEV;
+
+	data = cpu_to_be16(data);
+	msg.addr  = client->addr;
+	msg.flags = 0;
+	msg.len   = 2;
+	msg.buf   = (u8 *)&data;
+
+	r = i2c_transfer(client->adapter, &msg, 1);
+	if (r < 0) {
+		dev_err(&client->dev, "write failed, error %d\n", r);
+		return r;
+	}
+
+	return 0;
+}
+
+/**
+ * @brief I2C read using i2c_transfer().
+ * @param coil - the driver data structure
+ * @returns unsigned 16-bit register value on success, negative if failed
+ */
+static int ad5820_read(struct ad5820_device *coil)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(&coil->subdev);
+	struct i2c_msg msg;
+	int r;
+	u16 data = 0;
+
+	if (!client->adapter)
+		return -ENODEV;
+
+	msg.addr  = client->addr;
+	msg.flags = I2C_M_RD;
+	msg.len   = 2;
+	msg.buf   = (u8 *)&data;
+
+	r = i2c_transfer(client->adapter, &msg, 1);
+	if (r < 0) {
+		dev_err(&client->dev, "read failed, error %d\n", r);
+		return r;
+	}
+
+	return be16_to_cpu(data);
+}
+
+/* Calculate status word and write it to the device based on current
+ * values of V4L2 controls. It is assumed that the stored V4L2 control
+ * values are properly limited and rounded. */
+static int ad5820_update_hw(struct ad5820_device *coil)
+{
+	u16 status;
+
+	status = RAMP_US_TO_CODE(coil->focus_ramp_time);
+	status |= coil->focus_ramp_mode
+		? AD5820_RAMP_MODE_64_16 : AD5820_RAMP_MODE_LINEAR;
+	status |= coil->focus_absolute << AD5820_DAC_SHIFT;
+
+	if (coil->standby)
+		status |= AD5820_POWER_DOWN;
+
+	return ad5820_write(coil, status);
+}
+
+/* --------------------------------------------------------------------------
+ * Power handling
+ */
+
+static void ad5820_power_off(struct ad5820_device *coil)
+{
+	if (coil->xshutdown != -1)
+		gpio_set_value(coil->xshutdown, 0);
+
+	regulator_disable(coil->vana);
+}
+
+static int ad5820_power_on(struct ad5820_device *coil)
+{
+	int ret;
+
+	ret = regulator_enable(coil->vana);
+	if (ret < 0)
+		return ret;
+
+	if (coil->xshutdown != -1)
+		gpio_set_value(coil->xshutdown, 1);
+
+	return 0;
+}
+
+/* --------------------------------------------------------------------------
+ * V4L2 controls
+ */
+
+#define V4L2_CID_FOCUS_AD5820_RAMP_TIME		(V4L2_CID_USER_BASE | 0x1000)
+#define V4L2_CID_FOCUS_AD5820_RAMP_MODE		(V4L2_CID_USER_BASE | 0x1001)
+
+static int ad5820_set_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct ad5820_device *coil =
+		container_of(ctrl->handler, struct ad5820_device, ctrls);
+	u32 code;
+	int r = 0;
+
+	switch (ctrl->id) {
+	case V4L2_CID_FOCUS_ABSOLUTE:
+		coil->focus_absolute = ctrl->val;
+		return ad5820_update_hw(coil);
+
+	case V4L2_CID_FOCUS_AD5820_RAMP_TIME:
+		code = RAMP_US_TO_CODE(ctrl->val);
+		ctrl->val = CODE_TO_RAMP_US(code);
+		coil->focus_ramp_time = ctrl->val;
+		break;
+
+	case V4L2_CID_FOCUS_AD5820_RAMP_MODE:
+		coil->focus_ramp_mode = ctrl->val;
+		break;
+	}
+
+	return r;
+}
+
+static const struct v4l2_ctrl_ops ad5820_ctrl_ops = {
+	.s_ctrl = ad5820_set_ctrl,
+};
+
+static const char * const ad5820_focus_menu[] = {
+	"Linear ramp",
+	"64/16 ramp",
+};
+
+static const struct v4l2_ctrl_config ad5820_ctrls[] = {
+	{
+		.ops		= &ad5820_ctrl_ops,
+		.id		= V4L2_CID_FOCUS_AD5820_RAMP_TIME,
+		.type		= V4L2_CTRL_TYPE_INTEGER,
+		.name		= "Focus ramping time [us]",
+		.min		= 0,
+		.max		= 3200,
+		.step		= 50,
+		.def		= 0,
+		.flags		= 0,
+	},
+	{
+		.ops		= &ad5820_ctrl_ops,
+		.id		= V4L2_CID_FOCUS_AD5820_RAMP_MODE,
+		.type		= V4L2_CTRL_TYPE_MENU,
+		.name		= "Focus ramping mode",
+		.min		= 0,
+		.max		= ARRAY_SIZE(ad5820_focus_menu),
+		.step		= 0,
+		.def		= 0,
+		.flags		= 0,
+		.qmenu		= ad5820_focus_menu,
+	},
+};
+
+/* --------------------------------------------------------------------------
+ * V4L2 subdev operations
+ */
+
+static int __ad5820_set_power(struct ad5820_device *coil, bool on)
+{
+	int ret;
+
+	if (!on) {
+		/* Go to standby first as real power off my be denied by the
+		 * hardware (single power line control for both coil and
+		 * sensor).
+		 */
+		coil->standby = 1;
+		ad5820_update_hw(coil);
+		ad5820_power_off(coil);
+		return 0;
+	}
+
+	ret = ad5820_power_on(coil);
+	if (ret < 0)
+		return ret;
+
+	/* Restore the hardware settings. */
+	coil->standby = 0;
+	ret = ad5820_update_hw(coil);
+	if (ret < 0) {
+		coil->standby = 1;
+		return ret;
+	}
+
+	return 0;
+}
+
+static int ad5820_set_power(struct v4l2_subdev *subdev, int on)
+{
+	struct ad5820_device *coil = to_ad5820_device(subdev);
+	int ret = 0;
+
+	mutex_lock(&coil->power_lock);
+
+	/* If the power count is modified from 0 to != 0 or from != 0 to 0,
+	 * update the power state.
+	 */
+	if (coil->power_count == !on) {
+		ret = __ad5820_set_power(coil, !!on);
+		if (ret < 0)
+			goto done;
+	}
+
+	/* Update the power count. */
+	coil->power_count += on ? 1 : -1;
+	WARN_ON(coil->power_count < 0);
+
+done:
+	mutex_unlock(&coil->power_lock);
+	return ret;
+}
+
+static int ad5820_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
+{
+	return ad5820_set_power(sd, 1);
+}
+
+static int ad5820_close(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
+{
+	return ad5820_set_power(sd, 0);
+}
+
+static const struct v4l2_subdev_core_ops ad5820_core_ops = {
+	.s_power = ad5820_set_power,
+};
+
+static const struct v4l2_subdev_ops ad5820_ops = {
+	.core = &ad5820_core_ops,
+};
+
+static const struct v4l2_subdev_internal_ops ad5820_internal_ops = {
+	.open = ad5820_open,
+	.close = ad5820_close,
+};
+
+/* --------------------------------------------------------------------------
+ * I2C driver
+ */
+#ifdef CONFIG_PM
+
+static int ad5820_suspend(struct device *dev)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct v4l2_subdev *subdev = i2c_get_clientdata(client);
+	struct ad5820_device *coil = to_ad5820_device(subdev);
+
+	if (!coil->power_count)
+		return 0;
+
+	ad5820_power_off(coil);
+	return 0;
+}
+
+static int ad5820_resume(struct device *dev)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct v4l2_subdev *subdev = i2c_get_clientdata(client);
+	struct ad5820_device *coil = to_ad5820_device(subdev);
+
+	if (!coil->power_count)
+		return 0;
+
+	return __ad5820_set_power(coil, true);
+}
+
+#endif /* CONFIG_PM */
+
+static int ad5820_detect(struct ad5820_device *coil)
+{
+	const u16 status = AD5820_POWER_DOWN | 0x3ff0;
+	int ret;
+
+	if (ad5820_power_on(coil) < 0)
+		return -ENODEV;
+
+	if (ad5820_write(coil, status) || ad5820_read(coil) != status) {
+		ad5820_power_off(coil);
+		return -ENODEV;
+	}
+
+	__ad5820_set_power(coil, false);
+	return ret;
+}
+
+static int ad5820_probe(struct i2c_client *client,
+			const struct i2c_device_id *devid)
+{
+	struct ad5820_platform_data *pdata = client->dev.platform_data;
+	struct ad5820_device *coil;
+	unsigned int i;
+	int ret = -ENODEV;
+
+	coil = kzalloc(sizeof(*coil), GFP_KERNEL);
+	if (coil == NULL)
+		return -ENOMEM;
+
+	mutex_init(&coil->power_lock);
+	coil->focus_absolute = 0;
+	coil->focus_ramp_time = 0;
+	coil->focus_ramp_mode = 0;
+	coil->xshutdown = -1;
+
+	coil->vana = regulator_get(&client->dev, "VANA");
+	if (IS_ERR(coil->vana)) {
+		dev_err(&client->dev, "could not get regulator for vana\n");
+		goto done;
+	}
+
+	if (pdata && pdata->xshutdown != -1) {
+		ret = gpio_request_one(pdata->xshutdown, GPIOF_OUT_INIT_LOW,
+				       "ad5820_xshutdown");
+		if (ret < 0)
+			goto done;
+
+		coil->xshutdown = pdata->xshutdown;
+	}
+
+	ret = ad5820_detect(coil);
+	if (ret < 0) {
+		dev_err(&client->dev, "not detected\n");
+		goto done;
+	}
+
+	v4l2_ctrl_handler_init(&coil->ctrls, ARRAY_SIZE(ad5820_ctrls) + 1);
+
+	/* V4L2_CID_FOCUS_ABSOLUTE
+	 *
+	 * Minimum current is 0 mA, maximum is 100 mA. Thus, 1 code is
+	 * equivalent to 100/1023 = 0.0978 mA. Nevertheless, we do not use [mA]
+	 * for focus position, because it is meaningless for user. Meaningful
+	 * would be to use focus distance or even its inverse, but since the
+	 * driver doesn't have sufficiently knowledge to do the conversion, we
+	 * will just use abstract codes here. In any case, smaller value = focus
+	 * position farther from camera. The default zero value means focus at
+	 * infinity, and also least current consumption.
+	 */
+	v4l2_ctrl_new_std(&coil->ctrls, &ad5820_ctrl_ops,
+			  V4L2_CID_FOCUS_ABSOLUTE, 0, 1023, 1, 0);
+
+	/* V4L2_CID_TEST_PATTERN and V4L2_CID_MODE_* */
+	for (i = 0; i < ARRAY_SIZE(ad5820_ctrls); ++i)
+		v4l2_ctrl_new_custom(&coil->ctrls, &ad5820_ctrls[i], NULL);
+
+	if (coil->ctrls.error) {
+		ret = coil->ctrls.error;
+		goto done;
+	}
+
+	coil->subdev.ctrl_handler = &coil->ctrls;
+
+	v4l2_i2c_subdev_init(&coil->subdev, client, &ad5820_ops);
+	coil->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+	coil->subdev.internal_ops = &ad5820_internal_ops;
+
+	ret = media_entity_init(&coil->subdev.entity, 0, NULL, 0);
+	if (ret < 0)
+		goto done;
+
+	ret = 0;
+
+done:
+	if (ret < 0) {
+		v4l2_ctrl_handler_free(&coil->ctrls);
+		media_entity_cleanup(&coil->subdev.entity);
+
+		if (coil->xshutdown != -1)
+			gpio_free(coil->xshutdown);
+		regulator_put(coil->vana);
+
+		kfree(coil);
+	}
+
+	return ret;
+}
+
+static int __exit ad5820_remove(struct i2c_client *client)
+{
+	struct v4l2_subdev *subdev = i2c_get_clientdata(client);
+	struct ad5820_device *coil = to_ad5820_device(subdev);
+
+	v4l2_device_unregister_subdev(&coil->subdev);
+	v4l2_ctrl_handler_free(&coil->ctrls);
+	media_entity_cleanup(&coil->subdev.entity);
+
+	if (coil->xshutdown != -1)
+		gpio_free(coil->xshutdown);
+	regulator_put(coil->vana);
+
+	kfree(coil);
+	return 0;
+}
+
+static const struct i2c_device_id ad5820_id_table[] = {
+	{ AD5820_NAME, 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, ad5820_id_table);
+
+static SIMPLE_DEV_PM_OPS(ad5820_pm_ops, ad5820_suspend, ad5820_resume);
+
+static struct i2c_driver ad5820_i2c_driver = {
+	.driver		= {
+		.name	= AD5820_NAME,
+		.pm	= &ad5820_pm_ops,
+	},
+	.probe		= ad5820_probe,
+	.remove		= __exit_p(ad5820_remove),
+	.id_table	= ad5820_id_table,
+};
+
+module_i2c_driver(ad5820_i2c_driver);
+
+MODULE_AUTHOR("Tuukka Toivonen <tuukka.o.toivonen@nokia.com>");
+MODULE_DESCRIPTION("AD5820 camera lens driver");
+MODULE_LICENSE("GPL");
diff --git a/include/media/ad5820.h b/include/media/ad5820.h
new file mode 100644
index 0000000..2c28131
--- /dev/null
+++ b/include/media/ad5820.h
@@ -0,0 +1,30 @@
+/*
+ * AD5820 DAC driver for camera voice coil focus.
+ *
+ * Copyright (C) 2008 Nokia Corporation
+ * Copyright (C) 2007 Texas Instruments
+ *
+ * Contact: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
+ *          Sakari Ailus <sakari.ailus@iki.fi>
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
+#ifndef __AD5820_H__
+#define __AD5820_H__
+
+#define AD5820_NAME		"ad5820"
+#define AD5820_I2C_ADDR		(0x18 >> 1)
+
+struct ad5820_platform_data {
+	int xshutdown;
+};
+
+#endif /* __AD5820_H__ */
-- 
Regards,

Laurent Pinchart

