Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58024 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661AbcFRPiE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Jun 2016 11:38:04 -0400
Date: Sat, 18 Jun 2016 17:37:59 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
	pali.rohar@gmail.com, sre@kernel.org,
	kernel list <linux-kernel@vger.kernel.org>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
	linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
	aaro.koskinen@iki.fi, patrikbachan@gmail.com, serge@hallyn.com,
	linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
	devicetree@vger.kernel.org
Subject: [PATCHv4] support for AD5820 camera auto-focus coil
Message-ID: <20160618153759.GA15595@amd>
References: <20160602074544.GR26360@valkosipuli.retiisi.org.uk>
 <20160602193027.GB7984@amd>
 <20160602212746.GT26360@valkosipuli.retiisi.org.uk>
 <20160605190716.GA11321@amd>
 <575512E5.5030000@gmail.com>
 <20160611220654.GC26360@valkosipuli.retiisi.org.uk>
 <20160612084811.GA27446@amd>
 <20160612112253.GD26360@valkosipuli.retiisi.org.uk>
 <20160613191753.GA17459@amd>
 <20160617213545.GH24980@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160617213545.GH24980@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This adds support for AD5820 autofocus coil, found for example in
Nokia N900 smartphone.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

---
v2: simple cleanups, fix error paths, simplify probe

v3: more cleanups, remove printk, add include

v4: add uapi definitions

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 993dc50..77313a1 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -279,6 +279,13 @@ config VIDEO_ML86V7667
 	  To compile this driver as a module, choose M here: the
 	  module will be called ml86v7667.
 
+config VIDEO_AD5820
+	tristate "AD5820 lens voice coil support"
+	depends on I2C && VIDEO_V4L2 && MEDIA_CONTROLLER
+	---help---
+	  This is a driver for the AD5820 camera lens voice coil.
+	  It is used for example in Nokia N900 (RX-51).
+
 config VIDEO_SAA7110
 	tristate "Philips SAA7110 video decoder"
 	depends on VIDEO_V4L2 && I2C
diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
index 94f2c99..34434ae 100644
--- a/drivers/media/i2c/Makefile
+++ b/drivers/media/i2c/Makefile
@@ -19,6 +20,7 @@ obj-$(CONFIG_VIDEO_SAA717X) += saa717x.o
 obj-$(CONFIG_VIDEO_SAA7127) += saa7127.o
 obj-$(CONFIG_VIDEO_SAA7185) += saa7185.o
 obj-$(CONFIG_VIDEO_SAA6752HS) += saa6752hs.o
+obj-$(CONFIG_VIDEO_AD5820)  += ad5820.o
 obj-$(CONFIG_VIDEO_ADV7170) += adv7170.o
 obj-$(CONFIG_VIDEO_ADV7175) += adv7175.o
 obj-$(CONFIG_VIDEO_ADV7180) += adv7180.o
diff --git a/drivers/media/i2c/ad5820.c b/drivers/media/i2c/ad5820.c
new file mode 100644
index 0000000..a1be956
--- /dev/null
+++ b/drivers/media/i2c/ad5820.c
@@ -0,0 +1,430 @@
+/*
+ * drivers/media/i2c/ad5820.c
+ *
+ * AD5820 DAC driver for camera voice coil focus.
+ *
+ * Copyright (C) 2008 Nokia Corporation
+ * Copyright (C) 2007 Texas Instruments
+ * Copyright (C) 2016 Pavel Machek <pavel@ucw.cz>
+ *
+ * Contact: Tuukka Toivonen <tuukkat76@gmail.com>
+ *	    Sakari Ailus <sakari.ailus@iki.fi>
+ *
+ * Based on af_d88.c by Texas Instruments.
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
+#include <linux/errno.h>
+#include <linux/i2c.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/regulator/consumer.h>
+
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-subdev.h>
+
+#include <uapi/linux/ad5820.h>
+
+#define AD5820_NAME		"ad5820"
+
+/* Register definitions */
+#define AD5820_POWER_DOWN		(1 << 15)
+#define AD5820_DAC_SHIFT		4
+#define AD5820_RAMP_MODE_LINEAR		(0 << 3)
+#define AD5820_RAMP_MODE_64_16		(1 << 3)
+
+#define CODE_TO_RAMP_US(s)	((s) == 0 ? 0 : (1 << ((s) - 1)) * 50)
+#define RAMP_US_TO_CODE(c)	fls(((c) + ((c)>>1)) / 50)
+
+#define to_ad5820_device(sd)	container_of(sd, struct ad5820_device, subdev)
+
+struct ad5820_device {
+	struct v4l2_subdev subdev;
+	struct ad5820_platform_data *platform_data;
+	struct regulator *vana;
+
+	struct v4l2_ctrl_handler ctrls;
+	u32 focus_absolute;
+	u32 focus_ramp_time;
+	u32 focus_ramp_mode;
+
+	struct mutex power_lock;
+	int power_count;
+
+	int standby : 1;
+};
+
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
+/*
+ * Calculate status word and write it to the device based on current
+ * values of V4L2 controls. It is assumed that the stored V4L2 control
+ * values are properly limited and rounded.
+ */
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
+/*
+ * Power handling
+ */
+static int ad5820_power_off(struct ad5820_device *coil, int standby)
+{
+	int ret = 0, ret2;
+
+	/*
+	 * Go to standby first as real power off my be denied by the hardware
+	 * (single power line control for both coil and sensor).
+	 */
+	if (standby) {
+		coil->standby = 1;
+		ret = ad5820_update_hw(coil);
+	}
+
+	ret2 = regulator_disable(coil->vana);
+	if (ret)
+		return ret;
+	return ret2;
+}
+
+static int ad5820_power_on(struct ad5820_device *coil, int restore)
+{
+	int ret;
+
+	ret = regulator_enable(coil->vana);
+	if (ret < 0)
+		return ret;
+
+	if (restore) {
+		/* Restore the hardware settings. */
+		coil->standby = 0;
+		ret = ad5820_update_hw(coil);
+		if (ret)
+			goto fail;
+	}
+	return 0;
+
+fail:
+	coil->standby = 1;
+	regulator_disable(coil->vana);
+
+	return ret;
+}
+
+/*
+ * V4L2 controls
+ */
+static int ad5820_set_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct ad5820_device *coil =
+		container_of(ctrl->handler, struct ad5820_device, ctrls);
+	u32 code;
+
+	switch (ctrl->id) {
+	case V4L2_CID_FOCUS_ABSOLUTE:
+		coil->focus_absolute = ctrl->val;
+		return ad5820_update_hw(coil);
+
+	case V4L2_CID_AD5820_RAMP_TIME:
+		code = RAMP_US_TO_CODE(ctrl->val);
+		ctrl->val = CODE_TO_RAMP_US(code);
+		coil->focus_ramp_time = ctrl->val;
+		break;
+
+	case V4L2_CID_AD5820_RAMP_MODE:
+		coil->focus_ramp_mode = ctrl->val;
+		break;
+	}
+
+	return 0;
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
+		.id		= V4L2_CID_AD5820_RAMP_TIME,
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
+		.id		= V4L2_CID_AD5820_RAMP_MODE,
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
+
+static int ad5820_init_controls(struct ad5820_device *coil)
+{
+	unsigned int i;
+
+	v4l2_ctrl_handler_init(&coil->ctrls, ARRAY_SIZE(ad5820_ctrls) + 1);
+
+	/*
+	 * V4L2_CID_FOCUS_ABSOLUTE
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
+	if (coil->ctrls.error)
+		return coil->ctrls.error;
+
+	coil->focus_absolute = 0;
+	coil->focus_ramp_time = 0;
+	coil->focus_ramp_mode = 0;
+
+	coil->subdev.ctrl_handler = &coil->ctrls;
+
+	return 0;
+}
+
+/*
+ * V4L2 subdev operations
+ */
+static int ad5820_registered(struct v4l2_subdev *subdev)
+{
+	struct ad5820_device *coil = to_ad5820_device(subdev);
+
+	return ad5820_init_controls(coil);
+}
+
+static int
+ad5820_set_power(struct v4l2_subdev *subdev, int on)
+{
+	struct ad5820_device *coil = to_ad5820_device(subdev);
+	int ret = 0;
+
+	mutex_lock(&coil->power_lock);
+
+	/*
+	 * If the power count is modified from 0 to != 0 or from != 0 to 0,
+	 * update the power state.
+	 */
+	if (coil->power_count == !on) {
+		ret = on ? ad5820_power_on(coil, 1) : ad5820_power_off(coil, 1);
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
+	.registered = ad5820_registered,
+	.open = ad5820_open,
+	.close = ad5820_close,
+};
+
+/*
+ * I2C driver
+ */
+#ifdef CONFIG_PM
+
+static int ad5820_suspend(struct device *dev)
+{
+	struct i2c_client *client = container_of(dev, struct i2c_client, dev);
+	struct v4l2_subdev *subdev = i2c_get_clientdata(client);
+	struct ad5820_device *coil = to_ad5820_device(subdev);
+
+	if (!coil->power_count)
+		return 0;
+
+	return ad5820_power_off(coil, 0);
+}
+
+static int ad5820_resume(struct device *dev)
+{
+	struct i2c_client *client = container_of(dev, struct i2c_client, dev);
+	struct v4l2_subdev *subdev = i2c_get_clientdata(client);
+	struct ad5820_device *coil = to_ad5820_device(subdev);
+
+	if (!coil->power_count)
+		return 0;
+
+	return ad5820_power_on(coil, 1);
+}
+
+#else
+
+#define ad5820_suspend	NULL
+#define ad5820_resume	NULL
+
+#endif /* CONFIG_PM */
+
+static int ad5820_probe(struct i2c_client *client,
+			const struct i2c_device_id *devid)
+{
+	struct ad5820_device *coil;
+	int ret;
+
+	coil = devm_kzalloc(&client->dev, sizeof(*coil), GFP_KERNEL);
+	if (!coil)
+		return -ENOMEM;
+
+	coil->vana = devm_regulator_get(&client->dev, "VANA");
+	if (IS_ERR(coil->vana)) {
+		ret = PTR_ERR(coil->vana);
+		if (ret != -EPROBE_DEFER)
+			dev_err(&client->dev, "could not get regulator for vana\n");
+		return ret;
+	}
+	
+	mutex_init(&coil->power_lock);
+
+	v4l2_i2c_subdev_init(&coil->subdev, client, &ad5820_ops);
+	coil->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+	coil->subdev.internal_ops = &ad5820_internal_ops;
+	strcpy(coil->subdev.name, "ad5820 focus");
+
+	ret = media_entity_pads_init(&coil->subdev.entity, 0, NULL);
+	if (ret < 0)
+		goto cleanup2;
+
+	ret = v4l2_async_register_subdev(&coil->subdev);
+	if (ret < 0)
+		goto cleanup;
+
+	return ret;
+
+cleanup2:
+	mutex_destroy(&coil->power_lock);
+cleanup:
+	media_entity_cleanup(&coil->subdev.entity);
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
+	mutex_destroy(&coil->power_lock);
+	return 0;
+}
+
+static const struct i2c_device_id ad5820_id_table[] = {
+	{ AD5820_NAME, 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, ad5820_id_table);
+
+static SIMPLE_DEV_PM_OPS(ad5820_pm, ad5820_suspend, ad5820_resume);
+
+static struct i2c_driver ad5820_i2c_driver = {
+	.driver		= {
+		.name	= AD5820_NAME,
+		.pm	= &ad5820_pm,
+	},
+	.probe		= ad5820_probe,
+	.remove		= __exit_p(ad5820_remove),
+	.id_table	= ad5820_id_table,
+};
+
+module_i2c_driver(ad5820_i2c_driver);
+
+MODULE_AUTHOR("Tuukka Toivonen");
+MODULE_DESCRIPTION("AD5820 camera lens driver");
+MODULE_LICENSE("GPL");
diff --git a/include/uapi/linux/ad5820.h b/include/uapi/linux/ad5820.h
new file mode 100644
index 0000000..4e541e8
--- /dev/null
+++ b/include/uapi/linux/ad5820.h
@@ -0,0 +1,18 @@
+/*
+ * AD5820 DAC driver for camera voice coil focus.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ */
+
+#ifndef __LINUX_AD5820_H
+#define __LINUX_AD5820_H
+
+#include <linux/v4l2-controls.h>
+
+/* Control IDs specific to the AD5820 driver as defined by V4L2 */
+#define V4L2_CID_AD5820_RAMP_TIME	(V4L2_CID_AD5820_BASE + 0)
+#define V4L2_CID_AD5820_RAMP_MODE	(V4L2_CID_AD5820_BASE + 1)
+
+#endif
diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index b6a357a..015e90b 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -180,6 +181,10 @@ enum v4l2_colorfx {
  * We reserve 16 controls for this driver. */
 #define V4L2_CID_USER_TC358743_BASE		(V4L2_CID_USER_BASE + 0x1080)
 
+/* The base for the ad5820 driver controls.
+ * We reserve 16 controls for this driver. */
+#define V4L2_CID_AD5820_BASE			(V4L2_CID_USER_BASE + 0x1090)
+
 /* MPEG-class control IDs */
 /* The MPEG controls are applicable to all codec controls
  * and the 'MPEG' part of the define is historical */



-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
