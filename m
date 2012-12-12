Return-path: <linux-media-owner@vger.kernel.org>
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:27694
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754129Ab2LLPwy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Dec 2012 10:52:54 -0500
From: Florian Neuhaus <florian.neuhaus@reberinformatik.ch>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Sakari Ailus <sakari.ailus@iki.fi>,
	David Cohen <dacohen@gmail.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: [PATCH v2] ad5820: Voice coil motor controller driver
Date: Wed, 12 Dec 2012 15:52:47 +0000
Message-ID: <6EE9CD707FBED24483D4CB0162E85467100BE413@AM2PRD0710MB375.eurprd07.prod.outlook.com>
Content-Language: de-DE
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Laurent Pinchart wrote on 2012-11-15:

> This is the ad5820 driver I've told you about. The code is compile-tested only
> as I haven't had time to try it on an N900 (the only device I own that
> includes an ad5820).
> 
> It should be quite easy to adapt the driver to support both the ad5820
> and the ad5821. Would you have time to give it a try ?

I finally adapted the patch to work with ad5821 and ad5398. I tested it on a 3.5 kernel
on the beagleboard-xm and only with the ad5821! I neither found a datasheet for the
ad5820 on the web...
The patch though can be applied against your current omap3isp/next branch.
I made it work without a separate regulator (mentioned as "VANA"), since we control
the power by just setting the x-shutdown-flag in the register.
I guess there was a bug by calling the ad5820_detect-function too early, so I rewrote
it to use the v4l2_subdev_internal_ops for detection.

As this is my first patch I ever wrote for the community: Is it gross to add me as a
co-author?

Signed-off-by: Florian Neuhaus <florian.neuhaus@reberinformatik.ch>
---
 drivers/media/i2c/Kconfig  |    9 +
 drivers/media/i2c/Makefile |    1 +
 drivers/media/i2c/ad5820.c |  561 ++++++++++++++++++++++++++++++++++++++++++++
 include/media/ad5820.h     |   39 +++
 4 files changed, 610 insertions(+)
 create mode 100644 drivers/media/i2c/ad5820.c
 create mode 100644 include/media/ad5820.h

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 24d78e2..fad22e6 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -534,6 +534,15 @@ config VIDEO_AS3645A
 	  This is a driver for the AS3645A and LM3555 flash controllers. It has
 	  build in control for flash, torch and indicator LEDs.
 
+comment "Lens controllers"
+
+config VIDEO_AD5820
+	tristate "AD5820/AD5821/AD5398 lens voice coil support"
+	depends on I2C && VIDEO_V4L2 && MEDIA_CONTROLLER
+	---help---
+	  This is a driver for the AD5820/AD5821/AD5398 camera lens voice coil.
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
index 0000000..e91d0f3
--- /dev/null
+++ b/drivers/media/i2c/ad5820.c
@@ -0,0 +1,561 @@
+/*
+ * AD5820/AD5821/AD5398 DAC driver for camera voice coil focus.
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
+struct ad5820_current_data_format {
+	int id;
+	int current_bits;
+	int current_offset;
+	int min_uA;
+	int max_uA;
+};
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
+
+	struct ad5820_current_data_format *data_format;
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
+	unsigned short val;
+	int ret;
+
+	if (!client || !client->adapter)
+		return -ENODEV;
+
+	val = cpu_to_be16(data);
+	ret = i2c_master_send(client, (char *)&val, 2);
+	if (ret < 0) {
+		dev_err(&client->dev, "write failed, error %d\n", ret);
+		return ret;
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
+	int ret;
+	u16 data = 0;
+
+	if (!client || !client->adapter)
+		return -ENODEV;
+
+	ret = i2c_master_recv(client, (char *)&data, 2);
+	if (ret < 0) {
+		dev_err(&client->dev, "read failed, error %d\n", ret);
+		return ret;
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
+	/* extended features for ad5820*/
+	if (coil->data_format->id == AD5820_ID) {
+		status = RAMP_US_TO_CODE(coil->focus_ramp_time);
+		status |= coil->focus_ramp_mode
+			? AD5820_RAMP_MODE_64_16 : AD5820_RAMP_MODE_LINEAR;
+	}
+
+	status |= coil->focus_absolute << coil->data_format->current_offset;
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
+static void ad5820_power_off(struct ad5820_device *coil)
+{
+	if (coil->xshutdown != -1)
+		gpio_set_value(coil->xshutdown, 0);
+
+	if (coil->vana)
+		regulator_disable(coil->vana);
+}
+
+static int ad5820_power_on(struct ad5820_device *coil)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(&coil->subdev);
+	int ret = 0;
+
+	if (coil->vana)
+		ret = regulator_enable(coil->vana);
+
+	if (ret < 0) {
+		dev_err(&client->dev, "regulator_enable failed %d\n", ret);
+		return ret;
+	}
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
+static int ad5820_detect(struct v4l2_subdev *subdev)
+{
+	struct ad5820_device *coil = to_ad5820_device(subdev);
+	struct i2c_client *client = v4l2_get_subdevdata(&coil->subdev);
+	const u16 status = AD5820_POWER_DOWN | 0x3ff0;
+	int ret;
+
+	if (ad5820_power_on(coil) < 0)
+		return -ENODEV;
+
+	if (ad5820_write(coil, status)) {
+		dev_err(&client->dev, "write failed\n");
+		ad5820_power_off(coil);
+		return -ENODEV;
+	}
+
+	ret = ad5820_read(coil);
+
+	if (ret < 0) {
+		dev_err(&client->dev, "read failed\n");
+		return -ENODEV;
+	}
+
+	if ((u16)ret != status) {
+		dev_err(&client->dev, "read not the expected value (%#x)\n", 
+			ret);
+		ad5820_power_off(coil);
+		return -ENODEV;
+	}
+
+	ret = __ad5820_set_power(coil, false);
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
+	.registered = ad5820_detect,
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
+static int ad5820_probe(struct i2c_client *client,
+			const struct i2c_device_id *devid)
+{
+	struct ad5820_platform_data *pdata = client->dev.platform_data;
+	struct ad5820_device *coil;
+	const struct ad5820_current_data_format *df =
+			(struct ad5820_current_data_format *)devid->driver_data;
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
+	coil->data_format = df;
+
+	coil->vana = regulator_get(&client->dev, "VANA");
+	if (IS_ERR(coil->vana))
+		dev_warn(&client->dev, "could not get regulator for vana\n");
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
+	if (coil->data_format == NULL) {
+		dev_err(&client->dev,
+			"the i2c-driver must pass a data_format struct\n");
+		goto done;
+	}
+
+	v4l2_ctrl_handler_init(&coil->ctrls,
+			       coil->data_format->id == AD5820_ID ? 
+			       (ARRAY_SIZE(ad5820_ctrls) + 1) : 1);
+
+	/* V4L2_CID_FOCUS_ABSOLUTE
+	 *
+	 * Minimum current is 0 mA, maximum is 100 mA or 120 mA, depending on
+	 * the actual device used (AD5820/AD5821/AD5398). I.e for AD5820 
+	 * 1 code is equivalent to 100/1023 = 0.0978 mA.
+	 * Nevertheless, we do not use [mA] for focus position, because it is
+	 * meaningless for user. Meaningful would be to use focus distance or
+	 * even its inverse, but since the driver doesn't have sufficiently
+	 * knowledge to do the conversion, we will just use abstract codes here.
+	 * In any case, smaller value = focus position farther from camera.
+	 * The default zero value means focus at infinity, and also least
+	 * current consumption.
+	 */
+	v4l2_ctrl_new_std(&coil->ctrls, &ad5820_ctrl_ops,
+			  V4L2_CID_FOCUS_ABSOLUTE, 0,
+			  (1 << coil->data_format->current_bits) - 1, 1, 0);
+
+	/* V4L2_CID_FOCUS_AD5820_RAMP_TIME and
+	 * V4L2_CID_FOCUS_AD5820_RAMP_MODE */
+	if (coil->data_format->id == AD5820_ID)
+		for (i = 0; i < ARRAY_SIZE(ad5820_ctrls); ++i)
+			v4l2_ctrl_new_custom(&coil->ctrls, &ad5820_ctrls[i],
+					     NULL);
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
+		if (coil->vana)
+			regulator_put(coil->vana);
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
+
+	if (coil->vana)
+		regulator_put(coil->vana);
+
+	kfree(coil);
+	return 0;
+}
+
+static const struct ad5820_current_data_format df_ad5820 = {
+	AD5820_ID,
+	10,
+	4,
+	0,
+	100000
+};
+
+static const struct ad5820_current_data_format df_ad5821 = {
+	AD5821_ID,
+	10,
+	4,
+	0,
+	120000
+};
+
+static const struct ad5820_current_data_format df_ad5398 = {
+	AD5398_ID,
+	10,
+	4,
+	0,
+	120000
+};
+
+static const struct i2c_device_id ad5820_id_table[] = {
+	{ AD5820_NAME, (kernel_ulong_t)&df_ad5820 },
+	{ AD5821_NAME, (kernel_ulong_t)&df_ad5821 },
+	{ AD5398_NAME, (kernel_ulong_t)&df_ad5398 },
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
+MODULE_AUTHOR("Florian Neuhaus <florian.neuhaus@reberinformatik.ch>");
+MODULE_DESCRIPTION("AD5820/AD5821/AD5398 camera lens driver");
+MODULE_LICENSE("GPL");
diff --git a/include/media/ad5820.h b/include/media/ad5820.h
new file mode 100644
index 0000000..7e6d1b3
--- /dev/null
+++ b/include/media/ad5820.h
@@ -0,0 +1,39 @@
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
+#define AD5821_NAME		"ad5821"
+#define AD5398_NAME		"ad5398"
+
+#define AD5820_ID		(1)
+#define AD5821_ID		(2)
+#define AD5398_ID		(3)
+
+#define AD5820_I2C_ADDR		(0x18 >> 1)
+#define AD5821_I2C_ADDR		(0x18 >> 1)
+#define AD5398_I2C_ADDR		(0x18 >> 1)
+
+struct ad5820_platform_data {
+	int xshutdown;
+};
+
+#endif /* __AD5820_H__ */
-- 
1.7.9.5

Regards,
Florian


