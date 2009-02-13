Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:44570 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752704AbZBMUyJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Feb 2009 15:54:09 -0500
From: Dominic Curran <dcurran@ti.com>
To: "linux-omap" <linux-omap@vger.kernel.org>
Subject: [OMAPZOOM][PATCH v2 1/3] LV8093: Add driver for LV8093 lens actuator.
Date: Fri, 13 Feb 2009 14:54:02 -0600
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902131454.02531.dcurran@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Dominic Curran <dcurran@ti.com>
Subject: [OMAPZOOM][PATCH v2 1/3] LV8093: Add driver for LV8093 lens actuator.

Support for the Sanyo LV8093CS piezo-actuator lens driver.
The lens position cannot be read back from this device, and it
only takes relative positions.  Thus it:
 - Supports the VIDIOC_G_CTRL ioctl to return BUSY bit (0 - Ready, ~0 - Busy)
 - Supports the VIDIOC_S_CTRL ioctl with the V4L2_CID_FOCUS_RELATIVE control ID.

One relative step requested through the V4L2_CID_FOCUS_RELATIVE control will
produce a 5.0um step @ 5.2mm/s of the lens.

Signed-off-by: Kraig Proehl <kraig.proehl@hp.com>
Signed-off-by: Dominic Curran <dcurran@ti.com>
---
 drivers/media/video/lv8093.c |  595 +++++++++++++++++++++++++++++++++++++++++++
 drivers/media/video/lv8093.h |   92 ++++++
 2 files changed, 687 insertions(+)

Index: omapzoom04/drivers/media/video/lv8093.c
===================================================================
--- /dev/null
+++ omapzoom04/drivers/media/video/lv8093.c
@@ -0,0 +1,595 @@
+/*
+ * drivers/media/video/lv8093.c
+ *
+ * LV8093 Piezo Motor (LENS) driver
+ *
+ * Copyright (C) 2008-2009 Texas Instruments.
+ * Copyright (C) 2009 Hewlett-Packard.
+ *
+ * This package is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
+ * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
+ * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
+ */
+
+#include <linux/mutex.h>
+#include <linux/i2c.h>
+#include <linux/delay.h>
+#include <linux/platform_device.h>
+#include <linux/cdev.h>
+#include <linux/device.h>
+
+#include <media/v4l2-int-device.h>
+#include <mach/gpio.h>
+
+#include "lv8093.h"
+
+static int
+lv8093_probe(struct i2c_client *client, const struct i2c_device_id *id);
+static int __exit lv8093_remove(struct i2c_client *client);
+
+struct lv8093_device {
+	const struct lv8093_platform_data *pdata;
+	struct v4l2_int_device *v4l2_int_device;
+	struct i2c_client *i2c_client;
+	int state;
+	int power_state;
+};
+
+static const struct i2c_device_id lv8093_id[] = {
+	{LV8093_NAME, 0},
+	{}
+};
+
+MODULE_DEVICE_TABLE(i2c, lv8093_id);
+
+static struct i2c_driver lv8093_i2c_driver = {
+	.driver = {
+		   .name = LV8093_NAME,
+		   .owner = THIS_MODULE,
+		   },
+	.probe = lv8093_probe,
+	.remove = __exit_p(lv8093_remove),
+	.id_table = lv8093_id,
+};
+
+static struct lv8093_device lv8093 = {
+	.state = LENS_NOT_DETECTED,
+};
+
+static struct vcontrol {
+	struct v4l2_queryctrl qc;
+} video_control[] = {
+	{
+		{
+		.id = V4L2_CID_FOCUS_RELATIVE,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "Lens Relative Position",
+		.minimum = 0,
+		.maximum = 0,
+		.step = LV8093_MAX_RELATIVE_STEP,
+		.default_value = 0,
+		}
+	,}
+};
+
+static struct i2c_driver lv8093_i2c_driver;
+
+static struct lv8093_lens_settings {
+	u8 reg;
+	u8 val;
+} lens_settings[] = {
+	{	/* Set control register */
+		.reg = CAMAF_LV8093_CTL_REG,
+		.val = CAMAF_LV8093_GATE0 |
+				CAMAF_LV8093_ENIN |
+				CAMAF_LV8093_CKSEL_ONE |
+				CAMAF_LV8093_RET2 |
+				CAMAF_LV8093_INIT_OFF,
+	},
+	{	/* Specify number of clocks per period */
+		.reg = CAMAF_LV8093_RST_REG,
+		.val = (LV8093_CLK_PER_PERIOD - 1),
+	},
+	{	/* Set the GATE_A pulse set value */
+		.reg = CAMAF_LV8093_GTAS_REG,
+		.val = (LV8093_TIME_GATEA + 1),
+	},
+	{	/* Set the GATE_B pulse reset value */
+		.reg = CAMAF_LV8093_GTBR_REG,
+		.val = (LV8093_TIME_GATEA + 1 + LV8093_TIME_OFF),
+	},
+	{	/* Set the GATE_B pulse set value */
+		.reg = CAMAF_LV8093_GTBS_REG,
+		.val = (LV8093_TIME_GATEA + 1 +
+				LV8093_TIME_OFF + LV8093_TIME_GATEB),
+	},
+	{	/* Specific the number of output pulse steps */
+		.reg = CAMAF_LV8093_STP_REG,
+		.val = LV8093_STP,
+	},
+	{	/* Set the number of swing back of init sequence performed */
+		.reg = CAMAF_LV8093_MOV_REG,
+		.val = 0,
+	},
+};
+
+/**
+ * find_vctrl - Finds the requested ID in the video control structure array
+ * @id: ID of control to search the video control array for
+ *
+ * Returns the index of the requested ID from the control structure array
+ */
+static int find_vctrl(int id)
+{
+	int i;
+
+	if (id < V4L2_CID_BASE)
+		return -EDOM;
+
+	for (i = (ARRAY_SIZE(video_control) - 1); i >= 0; i--)
+		if (video_control[i].qc.id == id)
+			break;
+	if (i < 0)
+		i = -EINVAL;
+	return i;
+}
+
+/**
+ * lv8093_reg_read - Reads a value from a register in LV8093 Piezo
+ * driver device.
+ * @client: Pointer to structure of I2C client.
+ * @value: Pointer to u16 for returning value of register to read.
+ *
+ * Returns zero if successful, or non-zero otherwise.
+ **/
+static int lv8093_reg_read(struct i2c_client *client, u8 *value)
+{
+	int err;
+	struct i2c_msg msg[1];
+
+	if (!client->adapter)
+		return -ENODEV;
+
+	msg->addr = client->addr;
+	msg->flags = I2C_M_RD;
+	msg->len = 1;
+	msg->buf = value;
+
+	err = i2c_transfer(client->adapter, msg, 1);
+
+	if (err < 0)
+		v4l_err(client, "i2c read failed with error %i", err);
+
+	return err;
+}
+
+/**
+ * lv8093_reg_write - Writes a value to a register in LV8093 Piezo
+ * driver device.
+ * @client: Pointer to structure of I2C client.
+ * @reg: Register to write.
+ * @value: Value of register to write.
+ *
+ * Returns zero or +ve if successful, -ve for error.
+ **/
+static int lv8093_reg_write(struct i2c_client *client, u8 reg, u8 value)
+{
+	int err;
+	struct i2c_msg msg[1];
+	unsigned char data[2];
+
+	if (!client->adapter)
+		return -ENODEV;
+
+	msg->addr = client->addr;
+	msg->flags = 0;
+	msg->len = 2;
+	msg->buf = data;
+
+	data[0] = reg;
+	data[1] = value;
+
+	err = i2c_transfer(client->adapter, msg, 1);
+	if (err < 0)
+		v4l_err(client, "i2c write failed with error %i", err);
+
+	return err;
+}
+
+/**
+ * lv8093_detect - Detects LV8093 Piezo driver device.
+ * @client: Pointer to structure of I2C client.
+ *
+ * Returns 0 if successful, -1 if camera is off or if test register value
+ * wasn't stored properly, or return error from lv8093_reg_write function.
+ **/
+static int lv8093_detect(struct i2c_client *client)
+{
+	int err = 0;
+	u8 rposn = 0;
+
+	err = lv8093_reg_write(client, CAMAF_LV8093_CTL_REG,
+				CAMAF_LV8093_GATE0 |
+				CAMAF_LV8093_CKSEL_ONE |
+				CAMAF_LV8093_RET2 |
+				CAMAF_LV8093_INIT_OFF);
+
+	if (err < 0) {
+		v4l_err(client, "Unable to write LV8093\n");
+		return err;
+	}
+
+	err = lv8093_reg_read(client, &rposn);
+	if (err < 0) {
+		v4l_err(client, "Unable to read LV8093\n");
+		return err;
+	}
+
+	return err;
+}
+
+/**
+ * lv8093_reginit - Initializes LV8093 Piezo driver device.
+ * @client: Pointer to structure of I2C client.
+ *
+ * Returns 0 if successful, or returns errors from lv8093_reg_write.
+ **/
+static int lv8093_reginit(struct i2c_client *client)
+{
+	int i, err = 0;
+
+	for (i = 0; i < ARRAY_SIZE(lens_settings); i++) {
+
+		err = lv8093_reg_write(client,
+				lens_settings[i].reg, lens_settings[i].val);
+
+		if (err < 0) {
+			v4l_err(client, "Unable to initialize LV8093\n");
+			return err;
+		}
+	}
+
+	return 0;
+}
+
+/**
+ * lv8093_af_setfocus - Sets the desired focus.
+ * @relpos: Relative focus position:
+ * 			-ve - Direction INFINITY.
+ * 			+ve - Direction MACRO.
+ * 			abs(relpos) gives number of steps in desired direction.
+ *
+ * Returns 0 on success, -EINVAL if camera is off or returned errors
+ * from lv8093_reg_write function.
+ **/
+int lv8093_af_setfocus(s16 relpos)
+{
+	struct lv8093_device *af_dev = &lv8093;
+	struct i2c_client *client = af_dev->i2c_client;
+	u8 data;
+	u8 num_pulses = abs(relpos);
+	int ret;
+
+	if ((af_dev->power_state == V4L2_POWER_OFF) ||
+	    (af_dev->power_state == V4L2_POWER_STANDBY))
+		return -EINVAL;
+
+	if (relpos >= 0)
+		/* Move lens in Macro direction */
+		data = CAMAF_LV8093_MAC_DIR | num_pulses;
+	else
+		/* Move lens in Infinite direction */
+		data = CAMAF_LV8093_INF_DIR | num_pulses;
+
+	ret = lv8093_reg_write(client, CAMAF_LV8093_DRVPLS_REG, data);
+	if (ret < 0) {
+		v4l_err(client, "Unable to write " LV8093_NAME
+			" lens HW\n");
+		return -EINVAL;
+	}
+
+	return ret;
+}
+
+/**
+ * lv8093_get_busy - Get busy bit.
+ * @busy: where to store the output
+ *
+ * Returns 0 on success, negative on error.
+ **/
+int lv8093_get_busy(int *busy)
+{
+	struct lv8093_device *af_dev = &lv8093;
+	struct i2c_client *client = af_dev->i2c_client;
+	int ret;
+	u8  regval;
+
+	ret = lv8093_reg_read(client, &regval);
+
+	if (ret < 0) {
+		v4l_err(client, "Unable to read " LV8093_NAME
+			" lens HW\n");
+		return -EINVAL;
+	}
+
+	*busy = regval & CAMAF_LV8093_BUSY;
+	return ret;
+}
+
+/**
+ * ioctl_queryctrl - V4L2 lens interface handler for VIDIOC_QUERYCTRL ioctl
+ * @s: pointer to standard V4L2 device structure
+ * @qc: standard V4L2 VIDIOC_QUERYCTRL ioctl structure
+ *
+ * If the requested control is supported, returns the control information
+ * from the video_control[] array.  Otherwise, returns -EINVAL if the
+ * control is not supported.
+ */
+static int ioctl_queryctrl(struct v4l2_int_device *s, struct v4l2_queryctrl *qc)
+{
+	int i;
+
+	i = find_vctrl(qc->id);
+	if (i == -EINVAL)
+		qc->flags = V4L2_CTRL_FLAG_DISABLED;
+
+	if (i < 0)
+		return -EINVAL;
+
+	*qc = video_control[i].qc;
+	return 0;
+}
+
+/**
+ * ioctl_s_ctrl - V4L2 LV8093 lens interface handler for VIDIOC_S_CTRL ioctl
+ * @s: pointer to standard V4L2 device structure
+ * @vc: standard V4L2 VIDIOC_S_CTRL ioctl structure
+ *
+ * If the requested control is supported, sets the control's current
+ * value in HW.
+ * Otherwise, returns -EINVAL if the control is not supported.
+ */
+static int ioctl_s_ctrl(struct v4l2_int_device *s, struct v4l2_control *vc)
+{
+	int retval = -EINVAL;
+	int i;
+	struct vcontrol *lvc;
+
+	i = find_vctrl(vc->id);
+	if (i < 0)
+		return -EINVAL;
+	lvc = &video_control[i];
+
+	switch (vc->id) {
+	case V4L2_CID_FOCUS_RELATIVE:
+		retval = lv8093_af_setfocus(vc->value);
+		break;
+	}
+
+	return retval;
+}
+
+/**
+ * ioctl_g_ctrl - V4L2 LV8093 lens interface handler for VIDIOC_G_CTRL ioctl
+ * @s: pointer to standard V4L2 device structure
+ * @vc: standard V4L2 VIDIOC_S_CTRL ioctl structure
+ *
+ * If the requested control is supported, sets the control's current
+ * value in HW.
+ * Otherwise, returns -EINVAL if the control is not supported.
+ */
+static int ioctl_g_ctrl(struct v4l2_int_device *s, struct v4l2_control *vc)
+{
+	int retval = -EINVAL;
+	int i;
+	struct vcontrol *lvc;
+	int busy;
+
+	i = find_vctrl(vc->id);
+	if (i < 0)
+		return -EINVAL;
+	lvc = &video_control[i];
+
+	switch (vc->id) {
+	case V4L2_CID_FOCUS_RELATIVE:
+		retval = lv8093_get_busy(&busy);
+		vc->value = busy;
+		break;
+	}
+
+	return retval;
+}
+
+/**
+ * ioctl_g_priv - V4L2 sensor interface handler for vidioc_int_g_priv_num
+ * @s: pointer to standard V4L2 device structure
+ * @p: void pointer to hold sensor's private data address
+ *
+ * Returns device's (sensor's) private data area address in p parameter
+ */
+static int ioctl_g_priv(struct v4l2_int_device *s, void *p)
+{
+	struct lv8093_device *lens = s->priv;
+
+	return lens->pdata->priv_data_set(p);
+}
+
+/**
+ * ioctl_s_power - V4L2 sensor interface handler for vidioc_int_s_power_num
+ * @s: pointer to standard V4L2 device structure
+ * @on: power state to which device is to be set
+ *
+ * Sets devices power state to requested state, if possible.
+ */
+static int ioctl_s_power(struct v4l2_int_device *s, enum v4l2_power on)
+{
+	struct lv8093_device *lens = s->priv;
+	struct i2c_client *c = lens->i2c_client;
+	int rval;
+
+	if (lens->pdata->power_set)
+		rval = lens->pdata->power_set(on);
+
+	lens->power_state = on;
+
+	if ((on == V4L2_POWER_ON) && (lens->state == LENS_NOT_DETECTED)) {
+		rval = lv8093_detect(c);
+		if (rval < 0) {
+			v4l_err(c, "Unable to detect " LV8093_NAME
+				" lens HW\n");
+			lens->state = LENS_NOT_DETECTED;
+			return rval;
+		}
+		lens->state = LENS_DETECTED;
+		pr_info(LV8093_NAME " Lens HW detected\n");
+
+		rval = lv8093_reginit(c);
+		if (rval < 0) {
+			v4l_err(c, "Unable to initialize " LV8093_NAME
+				" lens HW\n");
+			lens->state = LENS_NOT_DETECTED;
+			return rval;
+		}
+	}
+
+	if ((lens->power_state == V4L2_POWER_STANDBY) && (on == V4L2_POWER_ON)
+	    && (lens->state == LENS_DETECTED)) {
+		rval = lv8093_reginit(c);
+		if (rval < 0) {
+			v4l_err(c, "Unable to initialize " LV8093_NAME
+				" lens HW\n");
+			lens->state = LENS_NOT_DETECTED;
+			return rval;
+		}
+	}
+	return 0;
+}
+
+static struct v4l2_int_ioctl_desc lv8093_ioctl_desc[] = {
+	{.num = vidioc_int_s_power_num,
+	 .func = (v4l2_int_ioctl_func *) ioctl_s_power},
+	{.num = vidioc_int_g_priv_num,
+	 .func = (v4l2_int_ioctl_func *) ioctl_g_priv},
+	{.num = vidioc_int_queryctrl_num,
+	 .func = (v4l2_int_ioctl_func *) ioctl_queryctrl},
+	{.num = vidioc_int_s_ctrl_num,
+	 .func = (v4l2_int_ioctl_func *) ioctl_s_ctrl},
+	{.num = vidioc_int_g_ctrl_num,
+	 .func = (v4l2_int_ioctl_func *) ioctl_g_ctrl},
+};
+
+static struct v4l2_int_slave lv8093_slave = {
+	.ioctls = lv8093_ioctl_desc,
+	.num_ioctls = ARRAY_SIZE(lv8093_ioctl_desc),
+};
+
+static struct v4l2_int_device lv8093_int_device = {
+	.module = THIS_MODULE,
+	.name = LV8093_NAME,
+	.priv = &lv8093,
+	.type = v4l2_int_type_slave,
+	.u = {
+	      .slave = &lv8093_slave,
+	      },
+};
+
+/**
+ * lv8093_probe - Probes the driver for valid I2C attachment.
+ * @client: Pointer to structure of I2C client.
+ *
+ * Returns 0 if successful, or -EBUSY if unable to get client attached data.
+ **/
+static int
+lv8093_probe(struct i2c_client *client, const struct i2c_device_id *id)
+{
+	struct lv8093_device *lens = &lv8093;
+	int err;
+
+	if (i2c_get_clientdata(client)) {
+		v4l_err(client, "DTA BUSY %s\n", client->name);
+		return -EBUSY;
+	}
+
+	lens->pdata = client->dev.platform_data;
+
+	if (!lens->pdata) {
+		v4l_err(client, "no platform data?\n");
+		return -ENODEV;
+	}
+
+	lens->v4l2_int_device = &lv8093_int_device;
+
+	lens->i2c_client = client;
+	i2c_set_clientdata(client, lens);
+
+	err = v4l2_int_device_register(lens->v4l2_int_device);
+	if (err) {
+		v4l_err(client, "Failed to Register "
+		       LV8093_NAME " as V4L2 device.\n");
+		i2c_set_clientdata(client, NULL);
+	} else {
+		v4l_info(client, "Registered " LV8093_NAME
+			" as V4L2 device.\n");
+	}
+
+	return err;
+}
+
+/**
+ * lv8093_remove - Routine when device its unregistered from I2C
+ * @client: Pointer to structure of I2C client.
+ *
+ * Returns 0 if successful, or -ENODEV if the client isn't attached.
+ **/
+static int __exit lv8093_remove(struct i2c_client *client)
+{
+	struct lv8093_device *lens = i2c_get_clientdata(client);
+
+	if (!client->adapter)
+		return -ENODEV;
+
+	v4l2_int_device_unregister(lens->v4l2_int_device);
+	i2c_set_clientdata(client, NULL);
+	return 0;
+}
+
+/**
+ * lv8093_init - Module initialisation.
+ *
+ * Returns 0 if successful, or -EINVAL if device couldn't be initialized, or
+ * added as a character device.
+ **/
+static int __init lv8093_init(void)
+{
+	int err;
+
+	err = i2c_add_driver(&lv8093_i2c_driver);
+	if (err)
+		goto fail;
+	pr_info("Registered " LV8093_NAME " as i2c device.\n");
+
+	return err;
+fail:
+	pr_err("Failed to register " LV8093_NAME " as i2c driver.\n");
+	return err;
+}
+
+late_initcall(lv8093_init);
+
+/**
+ * lv8093_cleanup - Module cleanup.
+ **/
+static void __exit lv8093_cleanup(void)
+{
+	i2c_del_driver(&lv8093_i2c_driver);
+}
+
+module_exit(lv8093_cleanup);
+
+MODULE_AUTHOR("Texas Instruments");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("LV8093 LENS driver");
Index: omapzoom04/drivers/media/video/lv8093.h
===================================================================
--- /dev/null
+++ omapzoom04/drivers/media/video/lv8093.h
@@ -0,0 +1,92 @@
+/*
+ * drivers/media/video/lv8093.h
+ *
+ * Copyright (C) 2008-2009 Texas Instruments.
+ * Copyright (C) 2009 Hewlett-Packard.
+ *
+ * This package is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
+ * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
+ * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
+ *
+ * Register defines for Lens piezo-actuator device
+ *
+ */
+#ifndef CAMAF_LV8093_H
+#define CAMAF_LV8093_H
+
+#include <media/v4l2-int-device.h>
+
+/* i2c slave address = 0xE4 */
+#define LV8093_AF_I2C_ADDR			0x72
+
+#define LV8093_NAME 				"lv8093"
+#define LV8093_I2C_RETRY_COUNT		5
+
+#define CAMAF_LV8093_DISABLE		0x1
+#define CAMAF_LV8093_ENABLE	    	0x0
+#define CAMAF_LV8093_DRVPLS_REG		0x0
+#define CAMAF_LV8093_CTL_REG		0x1
+#define CAMAF_LV8093_RST_REG		0x2
+#define CAMAF_LV8093_GTAS_REG		0x3
+#define CAMAF_LV8093_GTBR_REG		0x4
+#define CAMAF_LV8093_GTBS_REG		0x5
+#define CAMAF_LV8093_STP_REG		0x6
+#define CAMAF_LV8093_MOV_REG		0x7
+#define CAMAF_LV8093_MAC_DIR        0x80
+#define CAMAF_LV8093_INF_DIR        0x00
+#define CAMAF_LV8093_GATE0          0x00
+#define CAMAF_LV8093_GATE1          0x80
+#define CAMAF_LV8093_ENIN           0x20
+#define CAMAF_LV8093_CKSEL_ONE      0x18
+#define CAMAF_LV8093_CKSEL_HALF     0x08
+#define CAMAF_LV8093_CKSEL_QTR      0x00
+#define CAMAF_LV8093_RET2           0x00
+#define CAMAF_LV8093_RET1           0x02
+#define CAMAF_LV8093_RET3           0x04
+#define CAMAF_LV8093_RET4           0x06
+#define CAMAF_LV8093_INIT_OFF       0x01
+#define CAMAF_LV8093_INIT_ON        0x00
+#define CAMAF_LV8093_BUSY           0x80
+#define CAMAF_LV8093_REGDATA(REG, DATA)  (((REG) << 8) | (DATA))
+
+#define CAMAF_LV8093_POWERDN(ARG)	(((ARG) & 0x1) << 15)
+#define CAMAF_LV8093_POWERDN_R(ARG)	(((ARG) >> 15) & 0x1)
+
+#define CAMAF_LV8093_DATA(ARG)		(((ARG) & 0xFF) << 6)
+#define CAMAF_LV8093_DATA_R(ARG)	(((ARG) >> 6) & 0xFF)
+#define CAMAF_FREQUENCY_EQ1(mclk)     	((u16)(mclk/16000))
+
+/* State of lens */
+#define LENS_DETECTED 1
+#define LENS_NOT_DETECTED 0
+
+/* Focus control values */
+#define LV8093_MAX_RELATIVE_STEP	127
+
+/* Initialization Mode Settings */
+#define LV8093_TIME_GATEA	23		/* First pulse width. */
+#define LV8093_TIME_OFF 	2		/* Off time between pulses. */
+#define LV8093_TIME_GATEB	29		/* Second pulse width. */
+#define LV8093_STP 			165		/* Pulse repetitions. */
+/* Numbers of clock periods per cycle: */
+/* 18MHz clock, period = 55.6 nsec */
+#define LV8093_CLK_PER_PERIOD	104
+
+
+
+/**
+ * struct lv8093_platform_data - platform data values and access functions
+ * @power_set: Power state access function, zero is off, non-zero is on.
+ * @priv_data_set: device private data (pointer) access function
+ */
+struct lv8093_platform_data {
+	int (*power_set)(enum v4l2_power power);
+	int (*priv_data_set)(void *);
+};
+
+#endif /* End of of CAMAF_LV8093_H */
+
