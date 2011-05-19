Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.128.26]:42061 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753475Ab1ESKlj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 May 2011 06:41:39 -0400
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, nkanchev@mm-sol.com,
	g.liakhovetski@gmx.de, hverkuil@xs4all.nl, dacohen@gmail.com,
	riverful@gmail.com, andrew.b.adams@gmail.com, shpark7@stanford.edu
Subject: [PATCH 3/3] adp1653: Add driver for LED flash controller
Date: Thu, 19 May 2011 13:41:26 +0300
Message-Id: <1305801686-32360-3-git-send-email-sakari.ailus@maxwell.research.nokia.com>
In-Reply-To: <4DD4F3CA.3040300@maxwell.research.nokia.com>
References: <4DD4F3CA.3040300@maxwell.research.nokia.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This patch adds the driver for the adp1653 LED flash controller. This
controller supports a high power led in flash and torch modes and an
indicator light, sometimes also called privacy light.

The adp1653 is used on the Nokia N900.

Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Signed-off-by: Tuukka Toivonen <tuukkat76@gmail.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: David Cohen <dacohen@gmail.com>
---
 drivers/media/video/Kconfig   |    7 +
 drivers/media/video/Makefile  |    2 +
 drivers/media/video/adp1653.c |  481 +++++++++++++++++++++++++++++++++++++++++
 include/media/adp1653.h       |  126 +++++++++++
 4 files changed, 616 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/adp1653.c
 create mode 100644 include/media/adp1653.h

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 00f51dd..c004dbb 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -344,6 +344,13 @@ config VIDEO_TCM825X
 	  This is a driver for the Toshiba TCM825x VGA camera sensor.
 	  It is used for example in Nokia N800.
 
+config VIDEO_ADP1653
+	tristate "ADP1653 flash support"
+	depends on I2C && VIDEO_V4L2 && MEDIA_CONTROLLER
+	---help---
+	  This is a driver for the ADP1653 flash controller. It is used for
+	  example in Nokia N900.
+
 config VIDEO_SAA7110
 	tristate "Philips SAA7110 video decoder"
 	depends on VIDEO_V4L2 && I2C
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index ace5d8b..abdf021 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -131,6 +131,8 @@ obj-$(CONFIG_VIDEO_VIA_CAMERA) += via-camera.o
 
 obj-$(CONFIG_VIDEO_OMAP3)	+= omap3isp/
 
+obj-$(CONFIG_VIDEO_ADP1653)	+= adp1653.o
+
 obj-$(CONFIG_USB_ZR364XX)       += zr364xx.o
 obj-$(CONFIG_USB_STKWEBCAM)     += stkwebcam.o
 
diff --git a/drivers/media/video/adp1653.c b/drivers/media/video/adp1653.c
new file mode 100644
index 0000000..5bd64a2
--- /dev/null
+++ b/drivers/media/video/adp1653.c
@@ -0,0 +1,481 @@
+/*
+ * drivers/media/video/adp1653.c
+ *
+ * Copyright (C) 2008--2011 Nokia Corporation
+ *
+ * Contact: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
+ *
+ * Contributors:
+ *	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
+ *	Tuukka Toivonen <tuukkat76@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ * TODO:
+ * - fault interrupt handling
+ * - faster strobe (use i/o pin instead of i2c)
+ *   - should ensure that the pin is in some sane state even if not used
+ * - power doesn't need to be ON if all lights are off
+ *
+ */
+
+#include <linux/delay.h>
+#include <linux/i2c.h>
+#include <linux/slab.h>
+#include <linux/version.h>
+#include <media/adp1653.h>
+#include <media/v4l2-device.h>
+
+#define TIMEOUT_MAX		820000
+#define TIMEOUT_STEP		54600
+#define TIMEOUT_MIN		(TIMEOUT_MAX - ADP1653_REG_CONFIG_TMR_SET_MAX \
+				 * TIMEOUT_STEP)
+#define TIMEOUT_US_TO_CODE(t)	((TIMEOUT_MAX + (TIMEOUT_STEP / 2) - (t)) \
+				 / TIMEOUT_STEP)
+#define TIMEOUT_CODE_TO_US(c)	(TIMEOUT_MAX - (c) * TIMEOUT_STEP)
+
+/* Write values into ADP1653 registers. */
+static int adp1653_update_hw(struct adp1653_flash *flash)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(&flash->subdev);
+	u8 out_sel;
+	u8 config = 0;
+	int rval;
+
+	out_sel = ADP1653_INDICATOR_INTENSITY_uA_TO_REG(
+		flash->indicator_intensity->val)
+		<< ADP1653_REG_OUT_SEL_ILED_SHIFT;
+
+	switch (flash->led_mode->val) {
+	case V4L2_FLASH_LED_MODE_NONE:
+		break;
+	case V4L2_FLASH_LED_MODE_FLASH:
+		/* Flash mode, light on with strobe, duration from timer */
+		config = ADP1653_REG_CONFIG_TMR_CFG;
+		config |= TIMEOUT_US_TO_CODE(flash->flash_timeout->val)
+			  << ADP1653_REG_CONFIG_TMR_SET_SHIFT;
+		break;
+	case V4L2_FLASH_LED_MODE_TORCH:
+		/* Torch mode, light immediately on, duration indefinite */
+		out_sel |= ADP1653_FLASH_INTENSITY_mA_TO_REG(
+			flash->torch_intensity->val)
+			<< ADP1653_REG_OUT_SEL_HPLED_SHIFT;
+		break;
+	}
+
+	rval = i2c_smbus_write_byte_data(client, ADP1653_REG_OUT_SEL, out_sel);
+	if (rval < 0)
+		return rval;
+
+	rval = i2c_smbus_write_byte_data(client, ADP1653_REG_CONFIG, config);
+	if (rval < 0)
+		return rval;
+
+	return 0;
+}
+
+static int adp1653_get_fault(struct adp1653_flash *flash)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(&flash->subdev);
+	int fault;
+	int rval;
+
+	fault = i2c_smbus_read_byte_data(client, ADP1653_REG_FAULT);
+	if (IS_ERR_VALUE(fault))
+		return fault;
+
+	flash->fault |= fault;
+
+	if (!flash->fault)
+		return 0;
+
+	/* Clear faults. */
+	rval = i2c_smbus_write_byte_data(client, ADP1653_REG_OUT_SEL, 0);
+	if (IS_ERR_VALUE(rval))
+		return rval;
+
+	flash->led_mode->val = V4L2_FLASH_LED_MODE_NONE;
+
+	rval = adp1653_update_hw(flash);
+	if (IS_ERR_VALUE(rval))
+		return rval;
+
+	return flash->fault;
+}
+
+static int adp1653_strobe(struct adp1653_flash *flash, int enable)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(&flash->subdev);
+	u8 out_sel = ADP1653_INDICATOR_INTENSITY_uA_TO_REG(
+		flash->indicator_intensity->val)
+		<< ADP1653_REG_OUT_SEL_ILED_SHIFT;
+	int rval;
+
+	if (flash->led_mode->val != V4L2_FLASH_LED_MODE_FLASH)
+		return -EBUSY;
+
+	if (!enable)
+		return i2c_smbus_write_byte_data(client, ADP1653_REG_OUT_SEL,
+						 out_sel);
+
+	out_sel |= ADP1653_FLASH_INTENSITY_mA_TO_REG(
+		flash->flash_intensity->val)
+		<< ADP1653_REG_OUT_SEL_HPLED_SHIFT;
+	rval = i2c_smbus_write_byte_data(client, ADP1653_REG_OUT_SEL, out_sel);
+	if (rval)
+		return rval;
+
+	/* Software strobe using i2c */
+	rval = i2c_smbus_write_byte_data(client, ADP1653_REG_SW_STROBE,
+		ADP1653_REG_SW_STROBE_SW_STROBE);
+	if (rval)
+		return rval;
+	return i2c_smbus_write_byte_data(client, ADP1653_REG_SW_STROBE, 0);
+}
+
+/* --------------------------------------------------------------------------
+ * V4L2 controls
+ */
+
+static int adp1653_get_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct adp1653_flash *flash =
+		container_of(ctrl->handler, struct adp1653_flash, ctrls);
+	int rval;
+
+	rval = adp1653_get_fault(flash);
+	if (IS_ERR_VALUE(rval))
+		return rval;
+
+	ctrl->cur.val = 0;
+
+	if (flash->fault & ADP1653_REG_FAULT_FLT_SCP)
+		ctrl->cur.val |= V4L2_FLASH_FAULT_SHORT_CIRCUIT;
+	if (flash->fault & ADP1653_REG_FAULT_FLT_OT)
+		ctrl->cur.val |= V4L2_FLASH_FAULT_OVER_TEMPERATURE;
+	if (flash->fault & ADP1653_REG_FAULT_FLT_TMR)
+		ctrl->cur.val |= V4L2_FLASH_FAULT_TIMEOUT;
+	if (flash->fault & ADP1653_REG_FAULT_FLT_OV)
+		ctrl->cur.val |= V4L2_FLASH_FAULT_OVER_VOLTAGE;
+
+	flash->fault = 0;
+
+	return 0;
+}
+
+static int adp1653_set_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct adp1653_flash *flash =
+		container_of(ctrl->handler, struct adp1653_flash, ctrls);
+	int rval;
+
+	rval = adp1653_get_fault(flash);
+	if (IS_ERR_VALUE(rval))
+		return rval;
+	if ((rval & (ADP1653_REG_FAULT_FLT_SCP |
+		     ADP1653_REG_FAULT_FLT_OT |
+		     ADP1653_REG_FAULT_FLT_OV)) &&
+	    (ctrl->id == V4L2_CID_FLASH_STROBE ||
+	     ctrl->id == V4L2_CID_FLASH_TORCH_INTENSITY ||
+	     ctrl->id == V4L2_CID_FLASH_LED_MODE))
+		return -EBUSY;
+
+	switch (ctrl->id) {
+	case V4L2_CID_FLASH_STROBE:
+		return adp1653_strobe(flash, 1);
+	case V4L2_CID_FLASH_STROBE_STOP:
+		return adp1653_strobe(flash, 0);
+	}
+
+	return adp1653_update_hw(flash);
+}
+
+static const struct v4l2_ctrl_ops adp1653_ctrl_ops = {
+	.g_volatile_ctrl = adp1653_get_ctrl,
+	.s_ctrl = adp1653_set_ctrl,
+};
+
+static int adp1653_init_controls(struct adp1653_flash *flash)
+{
+	v4l2_ctrl_handler_init(&flash->ctrls, 9);
+
+	flash->led_mode =
+		v4l2_ctrl_new_std_menu(&flash->ctrls, &adp1653_ctrl_ops,
+				       V4L2_CID_FLASH_LED_MODE,
+				       V4L2_FLASH_LED_MODE_TORCH, ~0x7, 0);
+	v4l2_ctrl_new_std_menu(&flash->ctrls, &adp1653_ctrl_ops,
+			       V4L2_CID_FLASH_STROBE_SOURCE,
+			       V4L2_FLASH_STROBE_SOURCE_SOFTWARE, ~0x1, 0);
+	v4l2_ctrl_new_std(&flash->ctrls, &adp1653_ctrl_ops,
+			  V4L2_CID_FLASH_STROBE, 0, 0, 0, 0);
+	v4l2_ctrl_new_std(&flash->ctrls, &adp1653_ctrl_ops,
+			  V4L2_CID_FLASH_STROBE_STOP, 0, 0, 0, 0);
+	flash->flash_timeout =
+		v4l2_ctrl_new_std(&flash->ctrls, &adp1653_ctrl_ops,
+				  V4L2_CID_FLASH_TIMEOUT, TIMEOUT_MIN,
+				  flash->platform_data->max_flash_timeout,
+				  TIMEOUT_STEP,
+				  flash->platform_data->max_flash_timeout);
+	flash->flash_intensity =
+		v4l2_ctrl_new_std(&flash->ctrls, &adp1653_ctrl_ops,
+				  V4L2_CID_FLASH_INTENSITY,
+				  ADP1653_FLASH_INTENSITY_MIN,
+				  flash->platform_data->max_flash_intensity,
+				  1, flash->platform_data->max_flash_intensity);
+	flash->torch_intensity =
+		v4l2_ctrl_new_std(&flash->ctrls, &adp1653_ctrl_ops,
+				  V4L2_CID_FLASH_TORCH_INTENSITY,
+				  ADP1653_TORCH_INTENSITY_MIN,
+				  flash->platform_data->max_torch_intensity,
+				  ADP1653_FLASH_INTENSITY_STEP,
+				  flash->platform_data->max_torch_intensity);
+	flash->indicator_intensity =
+		v4l2_ctrl_new_std(&flash->ctrls, &adp1653_ctrl_ops,
+				  V4L2_CID_FLASH_INDICATOR_INTENSITY,
+				  ADP1653_INDICATOR_INTENSITY_MIN,
+				  flash->platform_data->max_indicator_intensity,
+				  ADP1653_INDICATOR_INTENSITY_STEP,
+				  ADP1653_INDICATOR_INTENSITY_MIN);
+	v4l2_ctrl_new_std(&flash->ctrls, &adp1653_ctrl_ops,
+			  V4L2_CID_FLASH_FAULT, 0, V4L2_FLASH_FAULT_OVER_VOLTAGE
+			  | V4L2_FLASH_FAULT_OVER_TEMPERATURE
+			  | V4L2_FLASH_FAULT_SHORT_CIRCUIT, 0, 0);
+
+	if (flash->ctrls.error)
+		return flash->ctrls.error;
+
+	flash->subdev.ctrl_handler = &flash->ctrls;
+	return 0;
+}
+
+/* --------------------------------------------------------------------------
+ * V4L2 subdev operations
+ */
+
+static int
+adp1653_init_device(struct adp1653_flash *flash)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(&flash->subdev);
+	int rval;
+
+	/* Clear FAULT register by writing zero to OUT_SEL */
+	rval = i2c_smbus_write_byte_data(client, ADP1653_REG_OUT_SEL, 0);
+	if (rval < 0) {
+		dev_err(&client->dev, "failed writing fault register\n");
+		return -EIO;
+	}
+
+	mutex_lock(&flash->ctrls.lock);
+	/* Reset faults before reading new ones. */
+	flash->fault = 0;
+	rval = adp1653_get_fault(flash);
+	mutex_unlock(&flash->ctrls.lock);
+	if (rval > 0) {
+		dev_err(&client->dev, "faults detected: 0x%1.1x\n", rval);
+		return -EIO;
+	}
+
+	mutex_lock(&flash->ctrls.lock);
+	rval = adp1653_update_hw(flash);
+	mutex_unlock(&flash->ctrls.lock);
+	if (rval) {
+		dev_err(&client->dev,
+			"adp1653_update_hw failed at %s\n", __func__);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static int
+__adp1653_set_power(struct adp1653_flash *flash, int on)
+{
+	int ret;
+
+	ret = flash->platform_data->power(&flash->subdev, on);
+	if (ret < 0)
+		return ret;
+
+	if (!on)
+		return 0;
+
+	ret = adp1653_init_device(flash);
+	if (ret < 0)
+		flash->platform_data->power(&flash->subdev, 0);
+
+	return ret;
+}
+
+static int
+adp1653_set_power(struct v4l2_subdev *subdev, int on)
+{
+	struct adp1653_flash *flash = to_adp1653_flash(subdev);
+	int ret = 0;
+
+	mutex_lock(&flash->power_lock);
+
+	/* If the power count is modified from 0 to != 0 or from != 0 to 0,
+	 * update the power state.
+	 */
+	if (flash->power_count == !on) {
+		ret = __adp1653_set_power(flash, !!on);
+		if (ret < 0)
+			goto done;
+	}
+
+	/* Update the power count. */
+	flash->power_count += on ? 1 : -1;
+	WARN_ON(flash->power_count < 0);
+
+done:
+	mutex_unlock(&flash->power_lock);
+	return ret;
+}
+
+static int adp1653_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
+{
+	return adp1653_set_power(sd, 1);
+}
+
+static int adp1653_close(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
+{
+	return adp1653_set_power(sd, 0);
+}
+
+static const struct v4l2_subdev_core_ops adp1653_core_ops = {
+	.s_power = adp1653_set_power,
+};
+
+static const struct v4l2_subdev_ops adp1653_ops = {
+	.core = &adp1653_core_ops,
+};
+
+static const struct v4l2_subdev_internal_ops adp1653_internal_ops = {
+	.open = adp1653_open,
+	.close = adp1653_close,
+};
+
+/* --------------------------------------------------------------------------
+ * I2C driver
+ */
+#ifdef CONFIG_PM
+
+static int adp1653_suspend(struct i2c_client *client, pm_message_t mesg)
+{
+	struct v4l2_subdev *subdev = i2c_get_clientdata(client);
+	struct adp1653_flash *flash = to_adp1653_flash(subdev);
+
+	if (!flash->power_count)
+		return 0;
+
+	return __adp1653_set_power(flash, 0);
+}
+
+static int adp1653_resume(struct i2c_client *client)
+{
+	struct v4l2_subdev *subdev = i2c_get_clientdata(client);
+	struct adp1653_flash *flash = to_adp1653_flash(subdev);
+
+	if (!flash->power_count)
+		return 0;
+
+	return __adp1653_set_power(flash, 1);
+}
+
+#else
+
+#define adp1653_suspend	NULL
+#define adp1653_resume	NULL
+
+#endif /* CONFIG_PM */
+
+static int adp1653_probe(struct i2c_client *client,
+			 const struct i2c_device_id *devid)
+{
+	struct adp1653_flash *flash;
+	int ret;
+
+	flash = kzalloc(sizeof(*flash), GFP_KERNEL);
+	if (flash == NULL)
+		return -ENOMEM;
+
+	flash->platform_data = client->dev.platform_data;
+
+	mutex_init(&flash->power_lock);
+
+	v4l2_i2c_subdev_init(&flash->subdev, client, &adp1653_ops);
+	flash->subdev.internal_ops = &adp1653_internal_ops;
+	flash->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+
+	adp1653_init_controls(flash);
+
+	ret = media_entity_init(&flash->subdev.entity, 0, NULL, 0);
+	if (ret < 0)
+		kfree(flash);
+
+	return ret;
+}
+
+static int __exit adp1653_remove(struct i2c_client *client)
+{
+	struct v4l2_subdev *subdev = i2c_get_clientdata(client);
+	struct adp1653_flash *flash = to_adp1653_flash(subdev);
+
+	v4l2_device_unregister_subdev(&flash->subdev);
+	v4l2_ctrl_handler_free(&flash->ctrls);
+	media_entity_cleanup(&flash->subdev.entity);
+	kfree(flash);
+	return 0;
+}
+
+static const struct i2c_device_id adp1653_id_table[] = {
+	{ ADP1653_NAME, 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, adp1653_id_table);
+
+static struct i2c_driver adp1653_i2c_driver = {
+	.driver		= {
+		.name	= ADP1653_NAME,
+	},
+	.probe		= adp1653_probe,
+	.remove		= __exit_p(adp1653_remove),
+	.suspend	= adp1653_suspend,
+	.resume		= adp1653_resume,
+	.id_table	= adp1653_id_table,
+};
+
+static int __init adp1653_init(void)
+{
+	int rval;
+
+	rval = i2c_add_driver(&adp1653_i2c_driver);
+	if (rval)
+		printk(KERN_ALERT "%s: failed at i2c_add_driver\n", __func__);
+
+	return rval;
+}
+
+static void __exit adp1653_exit(void)
+{
+	i2c_del_driver(&adp1653_i2c_driver);
+}
+
+module_init(adp1653_init);
+module_exit(adp1653_exit);
+
+MODULE_AUTHOR("Sakari Ailus <sakari.ailus@nokia.com>");
+MODULE_DESCRIPTION("Analog Devices ADP1653 LED flash driver");
+MODULE_LICENSE("GPL");
diff --git a/include/media/adp1653.h b/include/media/adp1653.h
new file mode 100644
index 0000000..50a1af8
--- /dev/null
+++ b/include/media/adp1653.h
@@ -0,0 +1,126 @@
+/*
+ * include/media/adp1653.h
+ *
+ * Copyright (C) 2008--2011 Nokia Corporation
+ *
+ * Contact: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
+ *
+ * Contributors:
+ *	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
+ *	Tuukka Toivonen <tuukkat76@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#ifndef ADP1653_H
+#define ADP1653_H
+
+#include <linux/i2c.h>
+#include <linux/mutex.h>
+#include <linux/videodev2.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-subdev.h>
+
+#define ADP1653_NAME				"adp1653"
+#define ADP1653_I2C_ADDR			(0x60 >> 1)
+
+/* Register definitions */
+#define ADP1653_REG_OUT_SEL			0x00
+#define ADP1653_REG_OUT_SEL_HPLED_TORCH_MIN	0x01
+#define ADP1653_REG_OUT_SEL_HPLED_TORCH_MAX	0x0b
+#define ADP1653_REG_OUT_SEL_HPLED_FLASH_MIN	0x0c
+#define ADP1653_REG_OUT_SEL_HPLED_FLASH_MAX	0x1f
+#define ADP1653_REG_OUT_SEL_HPLED_SHIFT		3
+#define ADP1653_REG_OUT_SEL_ILED_MAX		0x07
+#define ADP1653_REG_OUT_SEL_ILED_SHIFT		0
+
+#define ADP1653_REG_CONFIG			0x01
+#define ADP1653_REG_CONFIG_TMR_CFG		(1 << 4)
+#define ADP1653_REG_CONFIG_TMR_SET_MAX		0x0f
+#define ADP1653_REG_CONFIG_TMR_SET_SHIFT	0
+
+#define ADP1653_REG_SW_STROBE			0x02
+#define ADP1653_REG_SW_STROBE_SW_STROBE		(1 << 0)
+
+#define ADP1653_REG_FAULT			0x03
+#define ADP1653_REG_FAULT_FLT_SCP		(1 << 3)
+#define ADP1653_REG_FAULT_FLT_OT		(1 << 2)
+#define ADP1653_REG_FAULT_FLT_TMR		(1 << 1)
+#define ADP1653_REG_FAULT_FLT_OV		(1 << 0)
+
+#define ADP1653_INDICATOR_INTENSITY_MIN		0
+#define ADP1653_INDICATOR_INTENSITY_STEP	2500
+#define ADP1653_INDICATOR_INTENSITY_MAX		\
+	(ADP1653_REG_OUT_SEL_ILED_MAX * ADP1653_INDICATOR_INTENSITY_STEP)
+#define ADP1653_INDICATOR_INTENSITY_uA_TO_REG(a) \
+	((a) / ADP1653_INDICATOR_INTENSITY_STEP)
+#define ADP1653_INDICATOR_INTENSITY_REG_TO_uA(a) \
+	((a) * ADP1653_INDICATOR_INTENSITY_STEP)
+
+#define ADP1653_FLASH_INTENSITY_BASE		35
+#define ADP1653_FLASH_INTENSITY_STEP		15
+#define ADP1653_FLASH_INTENSITY_MIN					\
+	(ADP1653_FLASH_INTENSITY_BASE					\
+	 + ADP1653_REG_OUT_SEL_HPLED_FLASH_MIN * ADP1653_FLASH_INTENSITY_STEP)
+#define ADP1653_FLASH_INTENSITY_MAX			\
+	(ADP1653_FLASH_INTENSITY_MIN +			\
+	 (ADP1653_REG_OUT_SEL_HPLED_FLASH_MAX -		\
+	  ADP1653_REG_OUT_SEL_HPLED_FLASH_MIN + 1) *	\
+	 ADP1653_FLASH_INTENSITY_STEP)
+
+#define ADP1653_FLASH_INTENSITY_mA_TO_REG(a)				\
+	((a) < ADP1653_FLASH_INTENSITY_BASE ? 0 :			\
+	 (((a) - ADP1653_FLASH_INTENSITY_BASE) / ADP1653_FLASH_INTENSITY_STEP))
+#define ADP1653_FLASH_INTENSITY_REG_TO_mA(a)		\
+	((a) * ADP1653_FLASH_INTENSITY_STEP + ADP1653_FLASH_INTENSITY_BASE)
+
+#define ADP1653_TORCH_INTENSITY_MIN					\
+	(ADP1653_FLASH_INTENSITY_BASE					\
+	 + ADP1653_REG_OUT_SEL_HPLED_TORCH_MIN * ADP1653_FLASH_INTENSITY_STEP)
+#define ADP1653_TORCH_INTENSITY_MAX			\
+	(ADP1653_TORCH_INTENSITY_MIN +			\
+	 (ADP1653_REG_OUT_SEL_HPLED_TORCH_MAX -		\
+	  ADP1653_REG_OUT_SEL_HPLED_TORCH_MIN + 1) *	\
+	 ADP1653_FLASH_INTENSITY_STEP)
+
+struct adp1653_platform_data {
+	int (*power)(struct v4l2_subdev *sd, int on);
+
+	u32 max_flash_timeout;		/* flash light timeout in us */
+	u32 max_flash_intensity;	/* led intensity, flash mode */
+	u32 max_torch_intensity;	/* led intensity, torch mode */
+	u32 max_indicator_intensity;	/* indicator led intensity */
+};
+
+#define to_adp1653_flash(sd)	container_of(sd, struct adp1653_flash, subdev)
+
+struct adp1653_flash {
+	struct v4l2_subdev subdev;
+	struct adp1653_platform_data *platform_data;
+
+	struct v4l2_ctrl_handler ctrls;
+	struct v4l2_ctrl *led_mode;
+	struct v4l2_ctrl *flash_timeout;
+	struct v4l2_ctrl *flash_intensity;
+	struct v4l2_ctrl *torch_intensity;
+	struct v4l2_ctrl *indicator_intensity;
+
+	struct mutex power_lock;
+	int power_count;
+	int fault;
+};
+
+#endif /* ADP1653_H */
-- 
1.7.2.5

