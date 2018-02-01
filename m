Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:7524 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751526AbeBAPow (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 1 Feb 2018 10:44:52 -0500
From: Andy Yeh <andy.yeh@intel.com>
To: linux-media@vger.kernel.org
Cc: andy.yeh@intel.com, sakari.ailus@linux.intel.com,
        tfiga@chromium.org, Alan Chiang <alanx.chiang@intel.com>
Subject: [PATCH v5 1/2] media: dw9807: Add dw9807 vcm driver
Date: Thu,  1 Feb 2018 23:48:03 +0800
Message-Id: <1517500083-12075-1-git-send-email-andy.yeh@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Alan Chiang <alanx.chiang@intel.com>

DW9807 is a 10 bit DAC from Dongwoon, designed for linear
control of voice coil motor.

This driver creates a V4L2 subdevice and
provides control to set the desired focus.

Signed-off-by: Andy Yeh <andy.yeh@intel.com>
---
since v1:
- changed author.
since v2:
- addressed outstanding comments.
- enabled sequential write to update 2 registers in a single transaction.
since v3:
- addressed comments for v3.
- Remove redundant codes and declar some variables as constant variable.
- separate DT binding to another patch
since v4:
- Remove unnecessary typecast
- Put the temporary and loop variables in the end of the declaration

 MAINTAINERS                |   7 +
 drivers/media/i2c/Kconfig  |  10 ++
 drivers/media/i2c/Makefile |   1 +
 drivers/media/i2c/dw9807.c | 320 +++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 338 insertions(+)
 create mode 100644 drivers/media/i2c/dw9807.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 845fc25..a339bb5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4385,6 +4385,13 @@ T:	git git://linuxtv.org/media_tree.git
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
index cb5d7ff..fd01842 100644
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
index 548a9ef..1b62639 100644
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
index 0000000..95626e9
--- /dev/null
+++ b/drivers/media/i2c/dw9807.c
@@ -0,0 +1,320 @@
+// Copyright (C) 2018 Intel Corporation
+// SPDX-License-Identifier: GPL-2.0
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
+#define DW9807_CTL_ADDR		0x02
+/*
+ * DW9807 separates two registers to control the VCM position.
+ * One for MSB value, another is LSB value.
+ */
+#define DW9807_MSB_ADDR		0x03
+#define DW9807_LSB_ADDR		0x04
+#define DW9807_STATUS_ADDR	0x05
+#define DW9807_MODE_ADDR	0x06
+#define DW9807_RESONANCE_ADDR	0x07
+
+#define MAX_RETRY		10
+
+struct dw9807_device {
+	struct v4l2_ctrl_handler ctrls_vcm;
+	struct v4l2_subdev sd;
+	u16 current_val;
+};
+
+static inline struct dw9807_device *sd_to_dw9807_vcm(struct v4l2_subdev *subdev)
+{
+	return container_of(subdev, struct dw9807_device, sd);
+}
+
+static int dw9807_i2c_check(struct i2c_client *client)
+{
+	const char status_addr = DW9807_STATUS_ADDR;
+	char status_result = 0x1;
+	int ret;
+
+	ret = i2c_master_send(client, (const char *)&status_addr, sizeof(status_addr));
+	if (ret != sizeof(status_addr)) {
+		dev_err(&client->dev, "I2C write STATUS address fail ret = %d\n",
+			ret);
+		return -EIO;
+	}
+
+	ret = i2c_master_recv(client, (char *)&status_result, sizeof(status_result));
+	if (ret != sizeof(status_result)) {
+		dev_err(&client->dev, "I2C read STATUS value fail ret=%d\n",
+			ret);
+		return -EIO;
+	}
+
+	return status_result;
+}
+
+static int dw9807_set_dac(struct i2c_client *client, u16 data)
+{
+	const char tx_data[3] = {
+		DW9807_MSB_ADDR, ((data >> 8) & 0x03), (data & 0xFF) };
+	int ret, retry = 0;
+
+	/*
+	 * According to the datasheet, need to check the bus status before we
+	 * write VCM position. This ensure that we really write the value
+	 * into the register
+	 */
+	while (dw9807_i2c_check(client) != 0) {
+		if (MAX_RETRY == ++retry) {
+			dev_err(&client->dev, "Cannot do the write operation because VCM is busy\n");
+			return -EIO;
+		}
+		usleep_range(DW9807_CTRL_DELAY_US, DW9807_CTRL_DELAY_US + 10);
+	}
+
+	/* Write VCM position to registers */
+	ret = i2c_master_send(client, tx_data, sizeof(tx_data));
+	if (ret != sizeof(tx_data)) {
+		dev_err(&client->dev, "I2C write MSB fail\n");
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static int dw9807_set_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct dw9807_device *dev_vcm = container_of(ctrl->handler, struct dw9807_device, ctrls_vcm);
+
+	if (ctrl->id == V4L2_CID_FOCUS_ABSOLUTE) {
+		struct i2c_client *client = v4l2_get_subdevdata(&dev_vcm->sd);
+
+		dev_vcm->current_val = ctrl->val;
+		return dw9807_set_dac(client, ctrl->val);
+	}
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
+	int rval;
+
+	rval = pm_runtime_get_sync(sd->dev);
+	if (rval < 0) {
+		pm_runtime_put_noidle(sd->dev);
+		return rval;
+	}
+
+	return 0;
+}
+
+static int dw9807_close(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
+{
+	pm_runtime_put(sd->dev);
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
+	struct i2c_client *client = v4l2_get_subdevdata(&dev_vcm->sd);
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
+	v4l2_i2c_subdev_init(&dw9807_dev->sd, client, &dw9807_ops);
+	dw9807_dev->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+	dw9807_dev->sd.internal_ops = &dw9807_int_ops;
+
+	rval = dw9807_init_controls(dw9807_dev);
+	if (rval)
+		goto err_cleanup;
+
+	rval = media_entity_pads_init(&dw9807_dev->sd.entity, 0, NULL);
+	if (rval < 0)
+		goto err_cleanup;
+
+	dw9807_dev->sd.entity.function = MEDIA_ENT_F_LENS;
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
+	const char tx_data[2] = { DW9807_CTL_ADDR, 0x01 };
+	int ret, val;
+
+	for (val = dw9807_dev->current_val & ~(DW9807_CTRL_STEPS - 1);
+	     val >= 0; val -= DW9807_CTRL_STEPS) {
+		ret = dw9807_set_dac(client, val);
+		if (ret)
+			dev_err_once(dev, "%s I2C failure: %d", __func__, ret);
+		usleep_range(DW9807_CTRL_DELAY_US, DW9807_CTRL_DELAY_US + 10);
+	}
+
+	/* Power down */
+	ret = i2c_master_send(client, tx_data, sizeof(tx_data));
+
+	if (ret != sizeof(tx_data)) {
+		dev_err(&client->dev, "I2C write CTL fail\n");
+		return -EIO;
+	}
+
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
+	const char tx_data[2] = { DW9807_CTL_ADDR, 0x00 };
+	int ret, val;
+
+	/* Power on */
+	ret = i2c_master_send(client, tx_data, sizeof(tx_data));
+	if (ret != sizeof(tx_data)) {
+		dev_err(&client->dev, "I2C write CTL fail\n");
+		return -EIO;
+	}
+
+	for (val = dw9807_dev->current_val % DW9807_CTRL_STEPS;
+	     val < dw9807_dev->current_val + DW9807_CTRL_STEPS - 1;
+	     val += DW9807_CTRL_STEPS) {
+		ret = dw9807_set_dac(client, val);
+		if (ret)
+			dev_err_ratelimited(dev, "%s I2C failure: %d",
+						__func__, ret);
+		usleep_range(DW9807_CTRL_DELAY_US, DW9807_CTRL_DELAY_US + 10);
+	}
+
+	return 0;
+}
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
+};
+
+module_i2c_driver(dw9807_i2c_driver);
+
+MODULE_AUTHOR("Chiang, Alan <alanx.chiang@intel.com>");
+MODULE_DESCRIPTION("DW9807 VCM driver");
+MODULE_LICENSE("GPL v2");
-- 
2.7.4
