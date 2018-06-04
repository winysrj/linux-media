Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:2001 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752044AbeFDI5k (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 4 Jun 2018 04:57:40 -0400
From: bingbu.cao@intel.com
To: linux-media@vger.kernel.org
Cc: sakari.ailus@linux.intel.com, tfiga@google.com, jacopo@jmondi.org,
        rajmohan.mani@intel.com, bingbu.cao@linux.intel.com,
        tian.shu.qiu@intel.com, jian.xu.zheng@intel.com
Subject: [PATCH v3 2/2] media: ak7375: Add ak7375 lens voice coil driver
Date: Mon,  4 Jun 2018 17:00:19 +0800
Message-Id: <1528102819-10485-2-git-send-email-bingbu.cao@intel.com>
In-Reply-To: <1528102819-10485-1-git-send-email-bingbu.cao@intel.com>
References: <1528102819-10485-1-git-send-email-bingbu.cao@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Bingbu Cao <bingbu.cao@intel.com>

Add a v4l2 sub-device driver for the ak7375 lens voice coil.
This is a voice coil module using the i2c bus to control the
focus position.

ak7375 can write multiple bytes of data at a time. If more
data is received instead of the stop condition after receiving
one byte of data, the address inside the chip is automatically
incremented and the data is written into the next address.

The ak7375 can control the position with 12 bits value and
consists of two 8 bit registers show as below:
register 0x00(AK7375_REG_POSITION):
    +---+---+---+---+---+---+---+---+
    |D11|D10|D09|D08|D07|D06|D05|D04|
    +---+---+---+---+---+---+---+---+
register 0x01:
    +---+---+---+---+---+---+---+---+
    |D03|D02|D01|D00|---|---|---|---|
    +---+---+---+---+---+---+---+---+

This driver support :
    - set ak7375 to standby mode once suspend and
      turn it back to active if resume
    - set the position via V4L2_CID_FOCUS_ABSOLUTE ctrl

Signed-off-by: Tianshu Qiu <tian.shu.qiu@intel.com>
Signed-off-by: Bingbu Cao <bingbu.cao@intel.com>

---
Changes from v1:
    - correct i2c write
    - add media_entity_pads_init() into probe
    - move the MAINTAINERs change into dt-bindings change
    - correct the compatible string
---
---
 drivers/media/i2c/Kconfig  |  10 ++
 drivers/media/i2c/Makefile |   1 +
 drivers/media/i2c/ak7375.c | 278 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 289 insertions(+)
 create mode 100644 drivers/media/i2c/ak7375.c

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 341452fe98df..ff3cb5afb0e1 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -326,6 +326,16 @@ config VIDEO_AD5820
 	  This is a driver for the AD5820 camera lens voice coil.
 	  It is used for example in Nokia N900 (RX-51).
 
+config VIDEO_AK7375
+	tristate "AK7375 lens voice coil support"
+	depends on I2C && VIDEO_V4L2 && MEDIA_CONTROLLER
+	depends on VIDEO_V4L2_SUBDEV_API
+	help
+	  This is a driver for the AK7375 camera lens voice coil.
+	  AK7375 is a 12 bit DAC with 120mA output current sink
+	  capability. This is designed for linear control of
+	  voice coil motors, controlled via I2C serial interface.
+
 config VIDEO_DW9714
 	tristate "DW9714 lens voice coil support"
 	depends on I2C && VIDEO_V4L2 && MEDIA_CONTROLLER
diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
index d679d57cd3b3..05b97e319ea9 100644
--- a/drivers/media/i2c/Makefile
+++ b/drivers/media/i2c/Makefile
@@ -23,6 +23,7 @@ obj-$(CONFIG_VIDEO_SAA7127) += saa7127.o
 obj-$(CONFIG_VIDEO_SAA7185) += saa7185.o
 obj-$(CONFIG_VIDEO_SAA6752HS) += saa6752hs.o
 obj-$(CONFIG_VIDEO_AD5820)  += ad5820.o
+obj-$(CONFIG_VIDEO_AK7375)  += ak7375.o
 obj-$(CONFIG_VIDEO_DW9714)  += dw9714.o
 obj-$(CONFIG_VIDEO_ADV7170) += adv7170.o
 obj-$(CONFIG_VIDEO_ADV7175) += adv7175.o
diff --git a/drivers/media/i2c/ak7375.c b/drivers/media/i2c/ak7375.c
new file mode 100644
index 000000000000..94bcadae4258
--- /dev/null
+++ b/drivers/media/i2c/ak7375.c
@@ -0,0 +1,278 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (C) 2018 Intel Corporation
+
+#include <linux/acpi.h>
+#include <linux/delay.h>
+#include <linux/i2c.h>
+#include <linux/module.h>
+#include <linux/pm_runtime.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-device.h>
+
+#define AK7375_MAX_FOCUS_POS	4095
+/*
+ * This sets the minimum granularity for the focus positions.
+ * A value of 1 gives maximum accuracy for a desired focus position
+ */
+#define AK7375_FOCUS_STEPS	1
+/*
+ * This acts as the minimum granularity of lens movement.
+ * Keep this value power of 2, so the control steps can be
+ * uniformly adjusted for gradual lens movement, with desired
+ * number of control steps.
+ */
+#define AK7375_CTRL_STEPS	64
+#define AK7375_CTRL_DELAY_US	1000
+
+#define AK7375_REG_POSITION	0x0
+#define AK7375_REG_CONT		0x2
+#define AK7375_MODE_ACTIVE	0x0
+#define AK7375_MODE_STANDBY	0x40
+
+/* ak7375 device structure */
+struct ak7375_device {
+	struct v4l2_ctrl_handler ctrls_vcm;
+	struct v4l2_subdev sd;
+	struct v4l2_ctrl *focus;
+};
+
+static inline struct ak7375_device *to_ak7375_vcm(struct v4l2_ctrl *ctrl)
+{
+	return container_of(ctrl->handler, struct ak7375_device, ctrls_vcm);
+}
+
+static inline struct ak7375_device *sd_to_ak7375_vcm(struct v4l2_subdev *subdev)
+{
+	return container_of(subdev, struct ak7375_device, sd);
+}
+
+static int ak7375_i2c_write(struct ak7375_device *ak7375,
+	u8 addr, u16 data, int size)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(&ak7375->sd);
+	int ret;
+	u8 buf[3];
+
+	if (size != 1 && size != 2)
+		return -EINVAL;
+	buf[0] = addr;
+	buf[size] = data & 0xff;
+	if (size == 2)
+		buf[1] = (data >> 8) & 0xff;
+	ret = i2c_master_send(client, (const char *)buf, size + 1);
+	if (ret < 0)
+		return ret;
+	if (ret != size + 1)
+		return -EIO;
+	return 0;
+}
+
+static int ak7375_set_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct ak7375_device *dev_vcm = to_ak7375_vcm(ctrl);
+
+	if (ctrl->id == V4L2_CID_FOCUS_ABSOLUTE)
+		return ak7375_i2c_write(dev_vcm, AK7375_REG_POSITION,
+					ctrl->val << 4, 2);
+
+	return -EINVAL;
+}
+
+static const struct v4l2_ctrl_ops ak7375_vcm_ctrl_ops = {
+	.s_ctrl = ak7375_set_ctrl,
+};
+
+static int ak7375_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
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
+static int ak7375_close(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
+{
+	pm_runtime_put(sd->dev);
+
+	return 0;
+}
+
+static const struct v4l2_subdev_internal_ops ak7375_int_ops = {
+	.open = ak7375_open,
+	.close = ak7375_close,
+};
+
+static const struct v4l2_subdev_ops ak7375_ops = { };
+
+static void ak7375_subdev_cleanup(struct ak7375_device *ak7375_dev)
+{
+	v4l2_async_unregister_subdev(&ak7375_dev->sd);
+	v4l2_ctrl_handler_free(&ak7375_dev->ctrls_vcm);
+	media_entity_cleanup(&ak7375_dev->sd.entity);
+}
+
+static int ak7375_init_controls(struct ak7375_device *dev_vcm)
+{
+	struct v4l2_ctrl_handler *hdl = &dev_vcm->ctrls_vcm;
+	const struct v4l2_ctrl_ops *ops = &ak7375_vcm_ctrl_ops;
+
+	v4l2_ctrl_handler_init(hdl, 1);
+
+	dev_vcm->focus = v4l2_ctrl_new_std(hdl, ops, V4L2_CID_FOCUS_ABSOLUTE,
+		0, AK7375_MAX_FOCUS_POS, AK7375_FOCUS_STEPS, 0);
+
+	if (hdl->error)
+		dev_err(dev_vcm->sd.dev, "%s fail error: 0x%x\n",
+			__func__, hdl->error);
+	dev_vcm->sd.ctrl_handler = hdl;
+	return hdl->error;
+}
+
+static int ak7375_probe(struct i2c_client *client)
+{
+	struct ak7375_device *ak7375_dev;
+	int val;
+
+	ak7375_dev = devm_kzalloc(&client->dev, sizeof(*ak7375_dev),
+				  GFP_KERNEL);
+	if (!ak7375_dev)
+		return -ENOMEM;
+
+	v4l2_i2c_subdev_init(&ak7375_dev->sd, client, &ak7375_ops);
+	ak7375_dev->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+	ak7375_dev->sd.internal_ops = &ak7375_int_ops;
+	ak7375_dev->sd.entity.function = MEDIA_ENT_F_LENS;
+
+	val = ak7375_init_controls(ak7375_dev);
+	if (val)
+		goto err_cleanup;
+
+	val = media_entity_pads_init(&ak7375_dev->sd.entity, 0, NULL);
+	if (val < 0)
+		goto err_cleanup;
+
+	val = v4l2_async_register_subdev(&ak7375_dev->sd);
+	if (val < 0)
+		goto err_cleanup;
+
+	pm_runtime_set_active(&client->dev);
+	pm_runtime_enable(&client->dev);
+	pm_runtime_idle(&client->dev);
+
+	return 0;
+
+err_cleanup:
+	v4l2_ctrl_handler_free(&ak7375_dev->ctrls_vcm);
+	media_entity_cleanup(&ak7375_dev->sd.entity);
+	dev_err(&client->dev, "Probe failed: %d\n", val);
+	return val;
+}
+
+static int ak7375_remove(struct i2c_client *client)
+{
+	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+	struct ak7375_device *ak7375_dev = sd_to_ak7375_vcm(sd);
+
+	ak7375_subdev_cleanup(ak7375_dev);
+	pm_runtime_disable(&client->dev);
+	pm_runtime_set_suspended(&client->dev);
+
+	return 0;
+}
+
+/*
+ * This function sets the vcm position, so it consumes least current
+ * The lens position is gradually moved in units of AK7375_CTRL_STEPS,
+ * to make the movements smoothly.
+ */
+static int __maybe_unused ak7375_vcm_suspend(struct device *dev)
+{
+
+	struct i2c_client *client = to_i2c_client(dev);
+	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+	struct ak7375_device *ak7375_dev = sd_to_ak7375_vcm(sd);
+	int ret, val;
+
+	for (val = ak7375_dev->focus->val & ~(AK7375_CTRL_STEPS - 1);
+	     val >= 0; val -= AK7375_CTRL_STEPS) {
+		ret = ak7375_i2c_write(ak7375_dev, AK7375_REG_POSITION,
+				       val << 4, 2);
+		if (ret)
+			dev_err_once(dev, "%s I2C failure: %d\n",
+				     __func__, ret);
+		usleep_range(AK7375_CTRL_DELAY_US, AK7375_CTRL_DELAY_US + 10);
+	}
+
+	ret = ak7375_i2c_write(ak7375_dev, AK7375_REG_CONT,
+			       AK7375_MODE_STANDBY, 1);
+	if (ret) {
+		dev_err(dev, "%s I2C failure: %d\n", __func__, ret);
+		return ret;
+	}
+	return 0;
+}
+
+/*
+ * This function sets the vcm position to the value set by the user
+ * through v4l2_ctrl_ops s_ctrl handler
+ * The lens position is gradually moved in units of AK7375_CTRL_STEPS,
+ * to make the movements smoothly.
+ */
+static int __maybe_unused ak7375_vcm_resume(struct device *dev)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+	struct ak7375_device *ak7375_dev = sd_to_ak7375_vcm(sd);
+	int ret, val;
+
+	ret = ak7375_i2c_write(ak7375_dev, AK7375_REG_CONT,
+		AK7375_MODE_ACTIVE, 1);
+	if (ret) {
+		dev_err(dev, "%s I2C failure: %d\n", __func__, ret);
+		return ret;
+	}
+
+	for (val = ak7375_dev->focus->val % AK7375_CTRL_STEPS;
+	     val <= ak7375_dev->focus->val;
+	     val += AK7375_CTRL_STEPS) {
+		ret = ak7375_i2c_write(ak7375_dev, AK7375_REG_POSITION,
+				       val << 4, 2);
+		if (ret)
+			dev_err_ratelimited(dev, "%s I2C failure: %d\n",
+						__func__, ret);
+		usleep_range(AK7375_CTRL_DELAY_US, AK7375_CTRL_DELAY_US + 10);
+	}
+	return 0;
+}
+
+static const struct of_device_id ak7375_of_table[] = {
+	{ .compatible = "asahi-kasei,ak7375" },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, ak7375_of_table);
+
+static const struct dev_pm_ops ak7375_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(ak7375_vcm_suspend, ak7375_vcm_resume)
+	SET_RUNTIME_PM_OPS(ak7375_vcm_suspend, ak7375_vcm_resume, NULL)
+};
+
+static struct i2c_driver ak7375_i2c_driver = {
+	.driver = {
+		.name = "ak7375",
+		.pm = &ak7375_pm_ops,
+		.of_match_table = ak7375_of_table,
+	},
+	.probe_new = ak7375_probe,
+	.remove = ak7375_remove,
+};
+module_i2c_driver(ak7375_i2c_driver);
+
+MODULE_AUTHOR("Tianshu Qiu <tian.shu.qiu@intel.com>");
+MODULE_AUTHOR("Bingbu Cao <bingbu.cao@intel.com>");
+MODULE_DESCRIPTION("AK7375 VCM driver");
+MODULE_LICENSE("GPL v2");
-- 
1.9.1
