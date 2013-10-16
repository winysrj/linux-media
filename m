Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:53577 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874Ab3JPHMp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Oct 2013 03:12:45 -0400
From: Daniel Jeong <gshark.jeong@gmail.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Daniel Jeong <gshark.jeong@gmail.com>,
	<linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>
Subject: [PATCH V2] media: i2c: add driver for dual LED Flash, lm3560.
Date: Wed, 16 Oct 2013 16:12:19 +0900
Message-Id: <1381907539-22867-1-git-send-email-gshark.jeong@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

 Patch v2 deletes unnecessary codes.
 This patch adds the driver for the LM3560, dual LED Flash The
 LM3560 has two 1A constant current driver for high current
 white LEDs. It is controlled via an I2C compatible
 interface(up to 400kHz). Each flash brightness, torch
 brightness and enable/disable can be controlled
 independantly. But flash timeout and operation mode are shared.

Signed-off-by: Daniel Jeong <gshark.jeong@gmail.com>
---
 drivers/media/i2c/Kconfig  |    9 +
 drivers/media/i2c/Makefile |    1 +
 drivers/media/i2c/lm3560.c |  488 ++++++++++++++++++++++++++++++++++++++++++++
 include/media/lm3560.h     |   97 +++++++++
 4 files changed, 595 insertions(+)
 create mode 100644 drivers/media/i2c/lm3560.c
 create mode 100644 include/media/lm3560.h

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index d18be19..75c8a03 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -621,6 +621,15 @@ config VIDEO_AS3645A
 	  This is a driver for the AS3645A and LM3555 flash controllers. It has
 	  build in control for flash, torch and indicator LEDs.
 
+config VIDEO_LM3560
+	tristate "LM3560 dual flash driver support"
+	depends on I2C && VIDEO_V4L2 && MEDIA_CONTROLLER
+	depends on MEDIA_CAMERA_SUPPORT
+	select REGMAP_I2C
+	---help---
+	  This is a driver for the lm3560 dual flash controllers. It controls
+	  flash, torch LEDs.
+
 comment "Video improvement chips"
 
 config VIDEO_UPD64031A
diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
index 9f462df..e03f177 100644
--- a/drivers/media/i2c/Makefile
+++ b/drivers/media/i2c/Makefile
@@ -70,6 +70,7 @@ obj-$(CONFIG_VIDEO_S5K4ECGX)	+= s5k4ecgx.o
 obj-$(CONFIG_VIDEO_S5C73M3)	+= s5c73m3/
 obj-$(CONFIG_VIDEO_ADP1653)	+= adp1653.o
 obj-$(CONFIG_VIDEO_AS3645A)	+= as3645a.o
+obj-$(CONFIG_VIDEO_LM3560)	+= lm3560.o
 obj-$(CONFIG_VIDEO_SMIAPP_PLL)	+= smiapp-pll.o
 obj-$(CONFIG_VIDEO_AK881X)		+= ak881x.o
 obj-$(CONFIG_VIDEO_IR_I2C)  += ir-kbd-i2c.o
diff --git a/drivers/media/i2c/lm3560.c b/drivers/media/i2c/lm3560.c
new file mode 100644
index 0000000..3317a9a
--- /dev/null
+++ b/drivers/media/i2c/lm3560.c
@@ -0,0 +1,488 @@
+/*
+ * drivers/media/i2c/lm3560.c
+ * General device driver for TI lm3560, FLASH LED Driver
+ *
+ * Copyright (C) 2013 Texas Instruments
+ *
+ * Contact: Daniel Jeong <gshark.jeong@gmail.com>
+ *			Ldd-Mlp <ldd-mlp@list.ti.com>
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
+#include <linux/delay.h>
+#include <linux/module.h>
+#include <linux/i2c.h>
+#include <linux/slab.h>
+#include <linux/mutex.h>
+#include <linux/regmap.h>
+#include <linux/videodev2.h>
+#include <media/lm3560.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-device.h>
+
+/* registers definitions */
+#define REG_ENABLE		0x10
+#define REG_TORCH_BR	0xa0
+#define REG_FLASH_BR	0xb0
+#define REG_FLASH_TOUT	0xc0
+#define REG_FLAG		0xd0
+#define REG_CONFIG1		0xe0
+
+/* Fault Mask */
+#define FAULT_TIMEOUT	(1<<0)
+#define FAULT_OVERTEMP	(1<<1)
+#define FAULT_SHORT_CIRCUIT	(1<<2)
+
+enum led_enable {
+	MODE_SHDN = 0x0,
+	MODE_TORCH = 0x2,
+	MODE_FLASH = 0x3,
+};
+
+/* struct lm3560_flash
+ *
+ * @pdata: platform data
+ * @regmap: reg. map for i2c
+ * @lock: muxtex for serial access.
+ * @led_mode: V4L2 LED mode
+ * @ctrls_led: V4L2 contols
+ * @subdev_led: V4L2 subdev
+ */
+struct lm3560_flash {
+	struct device *dev;
+	struct lm3560_platform_data *pdata;
+	struct regmap *regmap;
+	struct mutex lock;
+
+	enum v4l2_flash_led_mode led_mode;
+	struct v4l2_ctrl_handler ctrls_led[LM3560_LED_MAX];
+	struct v4l2_subdev subdev_led[LM3560_LED_MAX];
+};
+
+#define to_lm3560_flash(_ctrl, _no)	\
+	container_of(_ctrl->handler, struct lm3560_flash, ctrls_led[_no])
+
+/* enable mode control */
+static int lm3560_mode_ctrl(struct lm3560_flash *flash)
+{
+	int rval = -EINVAL;
+
+	switch (flash->led_mode) {
+	case V4L2_FLASH_LED_MODE_NONE:
+		rval = regmap_update_bits(flash->regmap,
+					  REG_ENABLE, 0x03, MODE_SHDN);
+		break;
+	case V4L2_FLASH_LED_MODE_TORCH:
+		rval = regmap_update_bits(flash->regmap,
+					  REG_ENABLE, 0x03, MODE_TORCH);
+		break;
+	case V4L2_FLASH_LED_MODE_FLASH:
+		rval = regmap_update_bits(flash->regmap,
+					  REG_ENABLE, 0x03, MODE_FLASH);
+		break;
+	}
+	return rval;
+}
+
+/* led1/2  enable/disable */
+static int lm3560_enable_ctrl(struct lm3560_flash *flash,
+			      enum lm3560_led_id led_no, bool on)
+{
+	int rval;
+
+	if (led_no == LM3560_LED0) {
+		if (on == true)
+			rval = regmap_update_bits(flash->regmap,
+						  REG_ENABLE, 0x08, 0x08);
+		else
+			rval = regmap_update_bits(flash->regmap,
+						  REG_ENABLE, 0x08, 0x00);
+	} else {
+		if (on == true)
+			rval = regmap_update_bits(flash->regmap,
+						  REG_ENABLE, 0x10, 0x10);
+		else
+			rval = regmap_update_bits(flash->regmap,
+						  REG_ENABLE, 0x10, 0x00);
+	}
+	return rval;
+}
+
+/* torch1/2 brightness control */
+static int lm3560_torch_brt_ctrl(struct lm3560_flash *flash,
+				 enum lm3560_led_id led_no, unsigned int brt)
+{
+	int rval;
+	u8 br_bits;
+
+	if (brt < LM3560_TORCH_BRT_MIN)
+		return lm3560_enable_ctrl(flash, led_no, false);
+	else
+		rval = lm3560_enable_ctrl(flash, led_no, true);
+
+	br_bits = LM3560_TORCH_BRT_uA_TO_REG(brt);
+	if (led_no == LM3560_LED0)
+		rval = regmap_update_bits(flash->regmap,
+					  REG_TORCH_BR, 0x07, br_bits);
+	else
+		rval = regmap_update_bits(flash->regmap,
+					  REG_TORCH_BR, 0x38, br_bits << 3);
+
+	return rval;
+}
+
+/* flash1/2 brightness control */
+static int lm3560_flash_brt_ctrl(struct lm3560_flash *flash,
+				 enum lm3560_led_id led_no, unsigned int brt)
+{
+	int rval;
+	u8 br_bits;
+
+	if (brt < LM3560_FLASH_BRT_MIN)
+		return lm3560_enable_ctrl(flash, led_no, false);
+	else
+		rval = lm3560_enable_ctrl(flash, led_no, true);
+
+	br_bits = LM3560_FLASH_BRT_uA_TO_REG(brt);
+	if (led_no == LM3560_LED0)
+		rval = regmap_update_bits(flash->regmap,
+					  REG_FLASH_BR, 0x0f, br_bits);
+	else
+		rval = regmap_update_bits(flash->regmap,
+					  REG_FLASH_BR, 0xf0, br_bits << 4);
+
+	return rval;
+}
+
+/* V4L2 controls  */
+static int lm3560_get_ctrl(struct v4l2_ctrl *ctrl, enum lm3560_led_id led_no)
+{
+	struct lm3560_flash *flash = to_lm3560_flash(ctrl, led_no);
+
+	mutex_lock(&flash->lock);
+
+	if (ctrl->id == V4L2_CID_FLASH_FAULT) {
+		int rval;
+		s32 fault = 0;
+		unsigned int reg_val;
+		rval = regmap_read(flash->regmap, REG_FLAG, &reg_val);
+		if (rval < 0)
+			return rval;
+		if (rval & FAULT_SHORT_CIRCUIT)
+			fault |= V4L2_FLASH_FAULT_SHORT_CIRCUIT;
+		if (rval & FAULT_OVERTEMP)
+			fault |= V4L2_FLASH_FAULT_OVER_TEMPERATURE;
+		if (rval & FAULT_TIMEOUT)
+			fault |= V4L2_FLASH_FAULT_TIMEOUT;
+		ctrl->cur.val = fault;
+		return 0;
+	}
+
+	mutex_unlock(&flash->lock);
+	return -EINVAL;
+}
+
+static int lm3560_set_ctrl(struct v4l2_ctrl *ctrl, enum lm3560_led_id led_no)
+{
+	struct lm3560_flash *flash = to_lm3560_flash(ctrl, led_no);
+	u8 tout_bits;
+	int rval = -EINVAL;
+
+	mutex_lock(&flash->lock);
+
+	switch (ctrl->id) {
+	case V4L2_CID_FLASH_LED_MODE:
+		flash->led_mode = ctrl->val;
+		if (flash->led_mode != V4L2_FLASH_LED_MODE_FLASH)
+			rval = lm3560_mode_ctrl(flash);
+		break;
+
+	case V4L2_CID_FLASH_STROBE_SOURCE:
+		rval = regmap_update_bits(flash->regmap,
+					  REG_CONFIG1, 0x04, (ctrl->val) << 2);
+		if (rval < 0)
+			goto err_out;
+		break;
+
+	case V4L2_CID_FLASH_STROBE:
+		if (flash->led_mode != V4L2_FLASH_LED_MODE_FLASH)
+			return -EBUSY;
+		flash->led_mode = V4L2_FLASH_LED_MODE_FLASH;
+		rval = lm3560_mode_ctrl(flash);
+		break;
+
+	case V4L2_CID_FLASH_STROBE_STOP:
+		if (flash->led_mode != V4L2_FLASH_LED_MODE_FLASH)
+			return -EBUSY;
+		flash->led_mode = V4L2_FLASH_LED_MODE_NONE;
+		rval = lm3560_mode_ctrl(flash);
+		break;
+
+	case V4L2_CID_FLASH_TIMEOUT:
+		tout_bits = LM3560_FLASH_TOUT_ms_TO_REG(ctrl->val);
+		rval = regmap_update_bits(flash->regmap,
+					  REG_FLASH_TOUT, 0x1f, tout_bits);
+		break;
+
+	case V4L2_CID_FLASH_INTENSITY:
+		rval = lm3560_flash_brt_ctrl(flash, led_no, ctrl->val);
+		break;
+
+	case V4L2_CID_FLASH_TORCH_INTENSITY:
+		rval = lm3560_torch_brt_ctrl(flash, led_no, ctrl->val);
+		break;
+	}
+
+	mutex_unlock(&flash->lock);
+err_out:
+	return rval;
+}
+
+static int lm3560_led1_get_ctrl(struct v4l2_ctrl *ctrl)
+{
+	return lm3560_get_ctrl(ctrl, LM3560_LED1);
+}
+
+static int lm3560_led1_set_ctrl(struct v4l2_ctrl *ctrl)
+{
+	return lm3560_set_ctrl(ctrl, LM3560_LED1);
+}
+
+static int lm3560_led0_get_ctrl(struct v4l2_ctrl *ctrl)
+{
+	return lm3560_get_ctrl(ctrl, LM3560_LED0);
+}
+
+static int lm3560_led0_set_ctrl(struct v4l2_ctrl *ctrl)
+{
+	return lm3560_set_ctrl(ctrl, LM3560_LED0);
+}
+
+static const struct v4l2_ctrl_ops lm3560_led_ctrl_ops[LM3560_LED_MAX] = {
+	[LM3560_LED0] = {
+			 .g_volatile_ctrl = lm3560_led0_get_ctrl,
+			 .s_ctrl = lm3560_led0_set_ctrl,
+			 },
+	[LM3560_LED1] = {
+			 .g_volatile_ctrl = lm3560_led1_get_ctrl,
+			 .s_ctrl = lm3560_led1_set_ctrl,
+			 }
+};
+
+static int lm3560_init_controls(struct lm3560_flash *flash,
+				enum lm3560_led_id led_no)
+{
+	struct v4l2_ctrl *fault;
+	u32 max_flash_brt = flash->pdata->max_flash_brt[led_no];
+	u32 max_torch_brt = flash->pdata->max_torch_brt[led_no];
+	struct v4l2_ctrl_handler *hdl = &flash->ctrls_led[led_no];
+	const struct v4l2_ctrl_ops *ops = &lm3560_led_ctrl_ops[led_no];
+
+	v4l2_ctrl_handler_init(hdl, 8);
+	/* flash mode */
+	v4l2_ctrl_new_std_menu(hdl, ops, V4L2_CID_FLASH_LED_MODE,
+			       V4L2_FLASH_LED_MODE_TORCH, ~0x7,
+			       V4L2_FLASH_LED_MODE_NONE);
+	flash->led_mode = V4L2_FLASH_LED_MODE_NONE;
+
+	/* flash source */
+	v4l2_ctrl_new_std_menu(hdl, ops, V4L2_CID_FLASH_STROBE_SOURCE,
+			       0x1, ~0x3, V4L2_FLASH_STROBE_SOURCE_SOFTWARE);
+
+	/* flash strobe */
+	v4l2_ctrl_new_std(hdl, ops, V4L2_CID_FLASH_STROBE, 0, 0, 0, 0);
+	/* flash strobe stop */
+	v4l2_ctrl_new_std(hdl, ops, V4L2_CID_FLASH_STROBE_STOP, 0, 0, 0, 0);
+
+	/* flash strobe timeout */
+	v4l2_ctrl_new_std(hdl, ops, V4L2_CID_FLASH_TIMEOUT,
+			  LM3560_FLASH_TOUT_MIN,
+			  flash->pdata->max_flash_timeout,
+			  LM3560_FLASH_TOUT_STEP,
+			  flash->pdata->max_flash_timeout);
+
+	/* flash brt */
+	v4l2_ctrl_new_std(hdl, ops, V4L2_CID_FLASH_INTENSITY,
+			  LM3560_FLASH_BRT_MIN, max_flash_brt,
+			  LM3560_FLASH_BRT_STEP, max_flash_brt);
+
+	/* torch brt */
+	v4l2_ctrl_new_std(hdl, ops, V4L2_CID_FLASH_TORCH_INTENSITY,
+			  LM3560_TORCH_BRT_MIN, max_torch_brt,
+			  LM3560_TORCH_BRT_STEP, max_torch_brt);
+
+	/* fault */
+	fault = v4l2_ctrl_new_std(hdl, ops, V4L2_CID_FLASH_FAULT, 0,
+				  V4L2_FLASH_FAULT_OVER_VOLTAGE
+				  | V4L2_FLASH_FAULT_OVER_TEMPERATURE
+				  | V4L2_FLASH_FAULT_SHORT_CIRCUIT
+				  | V4L2_FLASH_FAULT_TIMEOUT, 0, 0);
+	if (fault != NULL)
+		fault->flags |= V4L2_CTRL_FLAG_VOLATILE;
+
+	if (hdl->error)
+		return hdl->error;
+
+	flash->subdev_led[led_no].ctrl_handler = hdl;
+	return 0;
+}
+
+/* initialize device */
+static const struct v4l2_subdev_ops lm3560_ops = {
+	.core = NULL,
+};
+
+static const struct regmap_config lm3560_regmap = {
+	.reg_bits = 8,
+	.val_bits = 8,
+	.max_register = 0xFF,
+};
+
+static int lm3560_subdev_init(struct lm3560_flash *flash,
+			      enum lm3560_led_id led_no, char *led_name)
+{
+	struct i2c_client *client = to_i2c_client(flash->dev);
+	int rval;
+
+	v4l2_i2c_subdev_init(&flash->subdev_led[led_no], client, &lm3560_ops);
+	flash->subdev_led[led_no].flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+	strcpy(flash->subdev_led[led_no].name, led_name);
+	rval = lm3560_init_controls(flash, led_no);
+	if (rval)
+		goto err_out;
+	rval = media_entity_init(&flash->subdev_led[led_no].entity, 0, NULL, 0);
+	if (rval < 0)
+		goto err_out;
+	flash->subdev_led[led_no].entity.type = MEDIA_ENT_T_V4L2_SUBDEV_FLASH;
+
+	return rval;
+
+err_out:
+	v4l2_ctrl_handler_free(&flash->ctrls_led[led_no]);
+	return rval;
+}
+
+static int lm3560_init_device(struct lm3560_flash *flash)
+{
+	int rval;
+	unsigned int reg_val;
+
+	/* set peak current */
+	rval = regmap_update_bits(flash->regmap,
+				  REG_FLASH_TOUT, 0x60, flash->pdata->peak);
+	if (rval < 0)
+		return rval;
+	/* output disable */
+	flash->led_mode = V4L2_FLASH_LED_MODE_NONE;
+	rval = lm3560_mode_ctrl(flash);
+	if (rval < 0)
+		return rval;
+	/* Reset faults */
+	rval = regmap_read(flash->regmap, REG_FLAG, &reg_val);
+	return rval;
+}
+
+static int lm3560_probe(struct i2c_client *client,
+			const struct i2c_device_id *devid)
+{
+	struct lm3560_flash *flash;
+	struct lm3560_platform_data *pdata = dev_get_platdata(&client->dev);
+	int rval;
+
+	flash = devm_kzalloc(&client->dev, sizeof(*flash), GFP_KERNEL);
+	if (flash == NULL)
+		return -ENOMEM;
+
+	flash->regmap = devm_regmap_init_i2c(client, &lm3560_regmap);
+	if (IS_ERR(flash->regmap)) {
+		rval = PTR_ERR(flash->regmap);
+		return rval;
+	}
+
+	/* if there is no platform data, use chip default value */
+	if (pdata == NULL) {
+		pdata =
+		    kzalloc(sizeof(struct lm3560_platform_data), GFP_KERNEL);
+		if (pdata == NULL)
+			return -ENODEV;
+		pdata->peak = LM3560_PEAK_3600mA;
+		pdata->max_flash_timeout = LM3560_FLASH_TOUT_MAX;
+		/* led 1 */
+		pdata->max_flash_brt[LM3560_LED0] = LM3560_FLASH_BRT_MAX;
+		pdata->max_torch_brt[LM3560_LED0] = LM3560_TORCH_BRT_MAX;
+		/* led 2 */
+		pdata->max_flash_brt[LM3560_LED1] = LM3560_FLASH_BRT_MAX;
+		pdata->max_torch_brt[LM3560_LED1] = LM3560_TORCH_BRT_MAX;
+	}
+	flash->pdata = pdata;
+	flash->dev = &client->dev;
+	mutex_init(&flash->lock);
+
+	rval = lm3560_subdev_init(flash, LM3560_LED0, "lm3560-led0");
+	if (rval < 0)
+		return rval;
+
+	rval = lm3560_subdev_init(flash, LM3560_LED1, "lm3560-led1");
+	if (rval < 0)
+		return rval;
+
+	rval = lm3560_init_device(flash);
+	if (rval < 0)
+		return rval;
+
+	return 0;
+}
+
+static int lm3560_remove(struct i2c_client *client)
+{
+	struct v4l2_subdev *subdev = i2c_get_clientdata(client);
+	struct lm3560_flash *flash = container_of(subdev, struct lm3560_flash,
+						  subdev_led[LM3560_LED_MAX]);
+	unsigned int i;
+
+	for (i = LM3560_LED0; i < LM3560_LED_MAX; i++) {
+		v4l2_device_unregister_subdev(&flash->subdev_led[i]);
+		v4l2_ctrl_handler_free(&flash->ctrls_led[i]);
+		media_entity_cleanup(&flash->subdev_led[i].entity);
+	}
+
+	return 0;
+}
+
+static const struct i2c_device_id lm3560_id_table[] = {
+	{LM3560_NAME, 0},
+	{}
+};
+
+MODULE_DEVICE_TABLE(i2c, lm3560_id_table);
+
+static struct i2c_driver lm3560_i2c_driver = {
+	.driver = {
+		   .name = LM3560_NAME,
+		   .pm = NULL,
+		   },
+	.probe = lm3560_probe,
+	.remove = lm3560_remove,
+	.id_table = lm3560_id_table,
+};
+
+module_i2c_driver(lm3560_i2c_driver);
+
+MODULE_AUTHOR("Daniel Jeong <gshark.jeong@gmail.com>");
+MODULE_AUTHOR("Ldd Mlp <ldd-mlp@list.ti.com>");
+MODULE_DESCRIPTION("Texas Instruments LM3560 LED flash driver");
+MODULE_LICENSE("GPL");
diff --git a/include/media/lm3560.h b/include/media/lm3560.h
new file mode 100644
index 0000000..4667070
--- /dev/null
+++ b/include/media/lm3560.h
@@ -0,0 +1,97 @@
+/*
+ * include/media/lm3560.h
+ *
+ * Copyright (C) 2013 Texas Instruments
+ *
+ * Contact: Daniel Jeong <gshark.jeong@gmail.com>
+ *			Ldd-Mlp <ldd-mlp@list.ti.com>
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
+#ifndef __LM3560_H__
+#define __LM3560_H__
+
+#include <media/v4l2-subdev.h>
+
+#define LM3560_NAME	"lm3560"
+#define LM3560_I2C_ADDR	(0x53)
+
+/*  FLASH Brightness
+ *	min 62500uA, step 62500uA, max 1000000uA
+ */
+#define LM3560_FLASH_BRT_MIN 62500
+#define LM3560_FLASH_BRT_STEP 62500
+#define LM3560_FLASH_BRT_MAX 1000000
+#define LM3560_FLASH_BRT_uA_TO_REG(a)	\
+	((a) < LM3560_FLASH_BRT_MIN ? 0 :	\
+	 (((a) - LM3560_FLASH_BRT_MIN) / LM3560_FLASH_BRT_STEP))
+#define LM3560_FLASH_BRT_REG_TO_uA(a)		\
+	((a) * LM3560_FLASH_BRT_STEP + LM3560_FLASH_BRT_MIN)
+
+/*  FLASH TIMEOUT DURATION
+ *	min 32ms, step 32ms, max 1024ms
+ */
+#define LM3560_FLASH_TOUT_MIN 32
+#define LM3560_FLASH_TOUT_STEP 32
+#define LM3560_FLASH_TOUT_MAX 1024
+#define LM3560_FLASH_TOUT_ms_TO_REG(a)	\
+	((a) < LM3560_FLASH_TOUT_MIN ? 0 :	\
+	 (((a) - LM3560_FLASH_TOUT_MIN) / LM3560_FLASH_TOUT_STEP))
+#define LM3560_FLASH_TOUT_REG_TO_ms(a)		\
+	((a) * LM3560_FLASH_TOUT_STEP + LM3560_FLASH_TOUT_MIN)
+
+/*  TORCH BRT
+ *	min 31250uA, step 31250uA, max 250000uA
+ */
+#define LM3560_TORCH_BRT_MIN 31250
+#define LM3560_TORCH_BRT_STEP 31250
+#define LM3560_TORCH_BRT_MAX 250000
+#define LM3560_TORCH_BRT_uA_TO_REG(a)	\
+	((a) < LM3560_TORCH_BRT_MIN ? 0 :	\
+	 (((a) - LM3560_TORCH_BRT_MIN) / LM3560_TORCH_BRT_STEP))
+#define LM3560_TORCH_BRT_REG_TO_uA(a)		\
+	((a) * LM3560_TORCH_BRT_STEP + LM3560_TORCH_BRT_MIN)
+
+enum lm3560_led_id {
+	LM3560_LED0 = 0,
+	LM3560_LED1,
+	LM3560_LED_MAX
+};
+
+enum lm3560_peak_current {
+	LM3560_PEAK_1600mA = 0x00,
+	LM3560_PEAK_2300mA = 0x20,
+	LM3560_PEAK_3000mA = 0x40,
+	LM3560_PEAK_3600mA = 0x60
+};
+
+/* struct lm3560_platform_data
+ *
+ * @peak :  peak current
+ * @max_flash_timeout: flash timeout
+ * @max_flash_brt: flash mode led brightness
+ * @max_torch_brt: torch mode led brightness
+ */
+struct lm3560_platform_data {
+	enum lm3560_peak_current peak;
+
+	u32 max_flash_timeout;
+	u32 max_flash_brt[LM3560_LED_MAX];
+	u32 max_torch_brt[LM3560_LED_MAX];
+};
+
+#endif /* __LM3560_H__ */
-- 
1.7.9.5

