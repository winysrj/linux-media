Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:22101 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751112AbeAVQWe (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Jan 2018 11:22:34 -0500
From: Andy Yeh <andy.yeh@intel.com>
To: linux-media@vger.kernel.org
Cc: andy.yeh@intel.com, sakari.ailus@linux.intel.com,
        tfiga@chromium.org
Subject: [PATCH] media: dw9807: Add dw9807 vcm driver
Date: Tue, 23 Jan 2018 00:24:57 +0800
Message-Id: <1516638297-21989-1-git-send-email-andy.yeh@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

DW9807 is a 10 bit DAC from Dongwoon, designed for linear
control of voice coil motor.

This driver creates a V4L2 subdevice and
provides control to set the desired focus.

Signed-off-by: Andy Yeh <andy.yeh@intel.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 .../bindings/media/i2c/dongwoon,dw9807.txt         |   9 +
 MAINTAINERS                                        |   7 +
 drivers/media/i2c/Kconfig                          |  10 +
 drivers/media/i2c/Makefile                         |   1 +
 drivers/media/i2c/dw9807.c                         | 387 +++++++++++++++++++++
 5 files changed, 414 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/dongwoon,dw9807.txt
 create mode 100644 drivers/media/i2c/dw9807.c

diff --git a/Documentation/devicetree/bindings/media/i2c/dongwoon,dw9807.txt b/Documentation/devicetree/bindings/media/i2c/dongwoon,dw9807.txt
new file mode 100644
index 0000000..1771cd0
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/i2c/dongwoon,dw9807.txt
@@ -0,0 +1,9 @@
+Dngwoon Anatech DW9807 voice coil lens driver
+
+DW9807 is a 10-bit DAC with current sink capability. It is intended for
+controlling voice coil lenses.
+
+Mandatory properties:
+
+- compatible: "dongwoon,dw9807"
+- reg: I2C slave address
diff --git a/MAINTAINERS b/MAINTAINERS
index 9c9db44..32b536b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4377,6 +4377,13 @@ T:	git git://linuxtv.org/media_tree.git
 S:	Maintained
 F:	drivers/media/i2c/dw9714.c
 
+DONGWOON DW9807 LENS VOICE COIL DRIVER
+M:	Sakari Ailus <sakari.ailus@linux.intel.com>
+L:	linux-media@vger.kernel.org
+T:	git git://linuxtv.org/media_tree.git
+S:	Maintained
+F:	drivers/media/i2c/dw9807.c
+
 DOUBLETALK DRIVER
 M:	"James R. Van Zandt" <jrv@vanzandt.mv.com>
 L:	blinux-list@redhat.com
diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index cabde37..bcd4bf1 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -325,6 +325,16 @@ config VIDEO_DW9714
 	  capability. This is designed for linear control of
 	  voice coil motors, controlled via I2C serial interface.
 
+config VIDEO_DW9807
+	tristate "DW9807 lens voice coil support"
+	depends on I2C && VIDEO_V4L2 && MEDIA_CONTROLLER
+	depends on VIDEO_V4L2_SUBDEV_API
+	---help---
+	  This is a driver for the DW9807 camera lens voice coil.
+	  DW9807 is a 10 bit DAC with 100mA output current sink
+	  capability. This is designed for linear control of
+	  voice coil motors, controlled via I2C serial interface.
+
 config VIDEO_SAA7110
 	tristate "Philips SAA7110 video decoder"
 	depends on VIDEO_V4L2 && I2C
diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
index cf1e0f1..4bf7d00 100644
--- a/drivers/media/i2c/Makefile
+++ b/drivers/media/i2c/Makefile
@@ -23,6 +23,7 @@ obj-$(CONFIG_VIDEO_SAA7185) += saa7185.o
 obj-$(CONFIG_VIDEO_SAA6752HS) += saa6752hs.o
 obj-$(CONFIG_VIDEO_AD5820)  += ad5820.o
 obj-$(CONFIG_VIDEO_DW9714)  += dw9714.o
+obj-$(CONFIG_VIDEO_DW9807)  += dw9807.o
 obj-$(CONFIG_VIDEO_ADV7170) += adv7170.o
 obj-$(CONFIG_VIDEO_ADV7175) += adv7175.o
 obj-$(CONFIG_VIDEO_ADV7180) += adv7180.o
diff --git a/drivers/media/i2c/dw9807.c b/drivers/media/i2c/dw9807.c
new file mode 100644
index 0000000..f068771
--- /dev/null
+++ b/drivers/media/i2c/dw9807.c
@@ -0,0 +1,387 @@
+/*
+ * Copyright (c) 2017 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/acpi.h>
+#include <linux/delay.h>
+#include <linux/i2c.h>
+#include <linux/module.h>
+#include <linux/pm_runtime.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-device.h>
+
+#define DW9807_NAME		"dw9807"
+#define DW9807_MAX_FOCUS_POS	1023
+/*
+ * This sets the minimum granularity for the focus positions.
+ * A value of 1 gives maximum accuracy for a desired focus position
+ */
+#define DW9807_FOCUS_STEPS	1
+/*
+ * This acts as the minimum granularity of lens movement.
+ * Keep this value power of 2, so the control steps can be
+ * uniformly adjusted for gradual lens movement, with desired
+ * number of control steps.
+ */
+#define DW9807_CTRL_STEPS	16
+#define DW9807_CTRL_DELAY_US	1000
+
+/*
+ * DW9807 separates two registers to control the VCM position.
+ * One for MSB value, another is LSB value.
+ */
+#define DW9807_CTL_ADDR 0x02
+#define DW9807_MSB_ADDR 0x03
+#define DW9807_LSB_ADDR 0x04
+#define DW9807_STATUS_ADDR 0x05
+#define DW9807_MODE_ADDR 0x06
+#define DW9807_RESONANCE_ADDR 0x07
+
+#define MAX_RETRY 10
+
+/* dw9807 device structure */
+struct dw9807_device {
+	struct i2c_client *client;
+	struct v4l2_ctrl_handler ctrls_vcm;
+	struct v4l2_subdev sd;
+	u16 current_val;
+};
+
+static inline struct dw9807_device *to_dw9807_vcm(struct v4l2_ctrl *ctrl)
+{
+	return container_of(ctrl->handler, struct dw9807_device, ctrls_vcm);
+}
+
+static inline struct dw9807_device *sd_to_dw9807_vcm(struct v4l2_subdev *subdev)
+{
+	return container_of(subdev, struct dw9807_device, sd);
+}
+
+static int dw9807_i2c_check(struct i2c_client *client)
+{
+	int ret;
+	int status_addr = DW9807_STATUS_ADDR;
+	u8 status_result = 0x1;
+
+	ret = i2c_master_send(client, (const char *)&status_addr,
+			sizeof(status_addr));
+	if (ret != sizeof(status_addr)) {
+		dev_err(&client->dev, "I2C write STATUS address fail ret = %d\n",
+			ret);
+		return -EIO;
+	}
+
+	ret = i2c_master_recv(client, (char *)&status_result,
+			sizeof(status_result));
+	if (ret != sizeof(status_result)) {
+		dev_err(&client->dev, "I2C read STATUS value fail ret=%d\n",
+			ret);
+		return -EIO;
+	}
+
+	return status_result;
+}
+
+static int dw9807_i2c_write(struct i2c_client *client, u16 data)
+{
+	int ret;
+	u8 tx_lsb[2];
+	u8 tx_msb[2];
+	int retry = 0;
+
+	tx_lsb[0] = DW9807_LSB_ADDR;
+	tx_lsb[1] = (u8)(data & 0xFF);
+
+	tx_msb[0] = DW9807_MSB_ADDR;
+	tx_msb[1] = (u8)((data >> 8) & 0x03);
+
+	/* According to the datasheet, need to check the bus status before we */
+	/* write VCM position. This ensure that we really write the value */
+	/* into the register */
+	while (dw9807_i2c_check(client) != 0) {
+		if (MAX_RETRY == ++retry) {
+			dev_err(&client->dev, "Cannot do the write operation because VCM is busy\n");
+			return -EIO;
+		}
+		udelay(100);
+	}
+
+	/* Write MSB value to register */
+	ret = i2c_master_send(client, (const char *)&tx_msb, sizeof(tx_msb));
+	if (ret != sizeof(tx_msb)) {
+		dev_err(&client->dev, "I2C write MSB fail\n");
+		return -EIO;
+	}
+
+	retry = 0;
+	while (dw9807_i2c_check(client) != 0) {
+		if (MAX_RETRY == ++retry) {
+			dev_err(&client->dev, "Cannot do the write operation because VCM is busy\n");
+			return -EIO;
+		}
+		udelay(100);
+	}
+
+	/* Write LSB value to register */
+	ret = i2c_master_send(client, (const char *)&tx_lsb, sizeof(tx_lsb));
+	if (ret != sizeof(tx_lsb)) {
+		dev_err(&client->dev, "I2C write LSB fail\n");
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static int dw9807_t_focus_vcm(struct dw9807_device *dw9807_dev, u16 val)
+{
+	struct i2c_client *client = dw9807_dev->client;
+
+	dw9807_dev->current_val = val;
+	return dw9807_i2c_write(client, val);
+}
+
+static int dw9807_set_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct dw9807_device *dev_vcm = to_dw9807_vcm(ctrl);
+
+	if (ctrl->id == V4L2_CID_FOCUS_ABSOLUTE)
+		return dw9807_t_focus_vcm(dev_vcm, ctrl->val);
+
+	return -EINVAL;
+}
+
+static const struct v4l2_ctrl_ops dw9807_vcm_ctrl_ops = {
+	.s_ctrl = dw9807_set_ctrl,
+};
+
+static int dw9807_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
+{
+	struct dw9807_device *dw9807_dev = sd_to_dw9807_vcm(sd);
+	struct device *dev = &dw9807_dev->client->dev;
+	int rval;
+
+	rval = pm_runtime_get_sync(dev);
+	if (rval < 0) {
+		pm_runtime_put_noidle(dev);
+		return rval;
+	}
+
+	return 0;
+}
+
+static int dw9807_close(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
+{
+	struct dw9807_device *dw9807_dev = sd_to_dw9807_vcm(sd);
+	struct device *dev = &dw9807_dev->client->dev;
+
+	pm_runtime_put(dev);
+
+	return 0;
+}
+
+static const struct v4l2_subdev_internal_ops dw9807_int_ops = {
+	.open = dw9807_open,
+	.close = dw9807_close,
+};
+
+static const struct v4l2_subdev_ops dw9807_ops = { };
+
+static void dw9807_subdev_cleanup(struct dw9807_device *dw9807_dev)
+{
+	v4l2_async_unregister_subdev(&dw9807_dev->sd);
+	v4l2_ctrl_handler_free(&dw9807_dev->ctrls_vcm);
+	media_entity_cleanup(&dw9807_dev->sd.entity);
+}
+
+static int dw9807_init_controls(struct dw9807_device *dev_vcm)
+{
+	struct v4l2_ctrl_handler *hdl = &dev_vcm->ctrls_vcm;
+	const struct v4l2_ctrl_ops *ops = &dw9807_vcm_ctrl_ops;
+	struct i2c_client *client = dev_vcm->client;
+	int ret;
+	u8 tx_data[2];
+
+	v4l2_ctrl_handler_init(hdl, 1);
+
+	v4l2_ctrl_new_std(hdl, ops, V4L2_CID_FOCUS_ABSOLUTE,
+			  0, DW9807_MAX_FOCUS_POS, DW9807_FOCUS_STEPS, 0);
+
+	dev_vcm->sd.ctrl_handler = hdl;
+	if (hdl->error) {
+		dev_err(&client->dev, "%s fail error: 0x%x\n",
+			__func__, hdl->error);
+		return hdl->error;
+	}
+
+	/* Once the v4l2 initial processes finished, performing the initial */
+	/* settings for the vcm chip */
+	/* Power down */
+	tx_data[0] = DW9807_CTL_ADDR;
+	tx_data[1] = 0x01;
+
+	ret = i2c_master_send(client, (const char *)&tx_data, sizeof(tx_data));
+
+	if (ret != sizeof(tx_data)) {
+		dev_err(&client->dev, "I2C write CTL fail\n");
+		return -EIO;
+	}
+
+	/* Power on */
+	tx_data[0] = DW9807_CTL_ADDR;
+	tx_data[1] = 0x00;
+
+	ret = i2c_master_send(client, (const char *)&tx_data, sizeof(tx_data));
+	if (ret != sizeof(tx_data)) {
+		dev_err(&client->dev, "I2C write CTL fail\n");
+		return -EIO;
+	}
+
+	udelay(100);
+	return 0;
+}
+
+static int dw9807_probe(struct i2c_client *client)
+{
+	struct dw9807_device *dw9807_dev;
+	int rval;
+
+	dw9807_dev = devm_kzalloc(&client->dev, sizeof(*dw9807_dev),
+				  GFP_KERNEL);
+	if (dw9807_dev == NULL)
+		return -ENOMEM;
+
+	dw9807_dev->client = client;
+
+	v4l2_i2c_subdev_init(&dw9807_dev->sd, client, &dw9807_ops);
+	dw9807_dev->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+	dw9807_dev->sd.internal_ops = &dw9807_int_ops;
+
+	rval = dw9807_init_controls(dw9807_dev);
+	if (rval)
+		goto err_cleanup;
+
+	rval = media_entity_init(&dw9807_dev->sd.entity, 0, NULL, 0);
+	if (rval < 0)
+		goto err_cleanup;
+
+	dw9807_dev->sd.entity.type = MEDIA_ENT_T_V4L2_SUBDEV_LENS;
+
+	rval = v4l2_async_register_subdev(&dw9807_dev->sd);
+	if (rval < 0)
+		goto err_cleanup;
+
+	pm_runtime_set_active(&client->dev);
+	pm_runtime_enable(&client->dev);
+	pm_runtime_idle(&client->dev);
+
+	return 0;
+
+err_cleanup:
+	dw9807_subdev_cleanup(dw9807_dev);
+	dev_err(&client->dev, "Probe failed: %d\n", rval);
+	return rval;
+}
+
+static int dw9807_remove(struct i2c_client *client)
+{
+	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+	struct dw9807_device *dw9807_dev = sd_to_dw9807_vcm(sd);
+
+	pm_runtime_disable(&client->dev);
+	pm_runtime_set_suspended(&client->dev);
+
+	dw9807_subdev_cleanup(dw9807_dev);
+
+	return 0;
+}
+
+/*
+ * This function sets the vcm position, so it consumes least current
+ * The lens position is gradually moved in units of DW9807_CTRL_STEPS,
+ * to make the movements smoothly.
+ */
+static int __maybe_unused dw9807_vcm_suspend(struct device *dev)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+	struct dw9807_device *dw9807_dev = sd_to_dw9807_vcm(sd);
+	int ret, val;
+
+	for (val = dw9807_dev->current_val & ~(DW9807_CTRL_STEPS - 1);
+	     val >= 0; val -= DW9807_CTRL_STEPS) {
+		ret = dw9807_i2c_write(client, val);
+		if (ret)
+			dev_err_once(dev, "%s I2C failure: %d", __func__, ret);
+		usleep_range(DW9807_CTRL_DELAY_US, DW9807_CTRL_DELAY_US + 10);
+	}
+	return 0;
+}
+
+/*
+ * This function sets the vcm position to the value set by the user
+ * through v4l2_ctrl_ops s_ctrl handler
+ * The lens position is gradually moved in units of DW9807_CTRL_STEPS,
+ * to make the movements smoothly.
+ */
+static int  __maybe_unused dw9807_vcm_resume(struct device *dev)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+	struct dw9807_device *dw9807_dev = sd_to_dw9807_vcm(sd);
+	int ret, val;
+
+	for (val = dw9807_dev->current_val % DW9807_CTRL_STEPS;
+	     val < dw9807_dev->current_val + DW9807_CTRL_STEPS - 1;
+	     val += DW9807_CTRL_STEPS) {
+		ret = dw9807_i2c_write(client, val);
+		if (ret)
+			dev_err_ratelimited(dev, "%s I2C failure: %d",
+						__func__, ret);
+		usleep_range(DW9807_CTRL_DELAY_US, DW9807_CTRL_DELAY_US + 10);
+	}
+
+	return 0;
+}
+
+static const struct i2c_device_id dw9807_id_table[] = {
+	{DW9807_NAME, 0},
+	{}
+};
+
+MODULE_DEVICE_TABLE(i2c, dw9807_id_table);
+
+static const struct of_device_id dw9807_of_table[] = {
+	{ .compatible = "dongwoon,dw9807" },
+	{ { 0 } }
+};
+MODULE_DEVICE_TABLE(of, dw9807_of_table);
+
+static const struct dev_pm_ops dw9807_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(dw9807_vcm_suspend, dw9807_vcm_resume)
+	SET_RUNTIME_PM_OPS(dw9807_vcm_suspend, dw9807_vcm_resume, NULL)
+};
+
+static struct i2c_driver dw9807_i2c_driver = {
+	.driver = {
+		.name = DW9807_NAME,
+		.pm = &dw9807_pm_ops,
+		.of_match_table = dw9807_of_table,
+	},
+	.probe_new = dw9807_probe,
+	.remove = dw9807_remove,
+	.id_table = dw9807_id_table,
+};
+
+module_i2c_driver(dw9807_i2c_driver);
+
+MODULE_DESCRIPTION("DW9807 VCM driver");
+MODULE_LICENSE("GPL v2");
-- 
2.7.4
