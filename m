Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:43898 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756748Ab0ERJZl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 May 2010 05:25:41 -0400
From: "Zhang, Xiaolin" <xiaolin.zhang@intel.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Tue, 18 May 2010 17:23:48 +0800
Subject: [PATCH v3 7/8] V4L2 subdev patchset for Intel Moorestown Camera
 Imaging Subsystem
Message-ID: <33AB447FBD802F4E932063B962385B351E895734@shsmsx501.ccr.corp.intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>From 9e72b71fd1c980bedd177590abe8faf24fc2c3b5 Mon Sep 17 00:00:00 2001
From: Xiaolin Zhang <xiaolin.zhang@intel.com>
Date: Tue, 18 May 2010 15:26:57 +0800
Subject: [PATCH 7/8] This patch is to add Renesas R2A30419BX VCM (for KMOT) driver support
 which is based on the video4linux2 sub-dev driver framework.

Signed-off-by: Xiaolin Zhang <xiaolin.zhang@intel.com>
---
 drivers/media/video/s5k4e1_motor.c |  413 ++++++++++++++++++++++++++++++++++++
 drivers/media/video/s5k4e1_motor.h |   90 ++++++++
 2 files changed, 503 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/s5k4e1_motor.c
 create mode 100644 drivers/media/video/s5k4e1_motor.h

diff --git a/drivers/media/video/s5k4e1_motor.c b/drivers/media/video/s5k4e1_motor.c
new file mode 100644
index 0000000..7ed1b77
--- /dev/null
+++ b/drivers/media/video/s5k4e1_motor.c
@@ -0,0 +1,413 @@
+/*
+ * Support for Moorestown Langwell Camera Imaging ISP subsystem.
+ *
+ * Copyright (c) 2009 Intel Corporation. All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ *
+ *
+ * Xiaolin Zhang <xiaolin.zhang@intel.com>
+ */
+
+#include <linux/i2c.h>
+#include <linux/delay.h>
+#include <linux/slab.h>
+#include <media/v4l2-device.h>
+
+#include "s5k4e1_motor.h"
+
+static int s5k4e1_motor_debug;
+module_param(s5k4e1_motor_debug, int, 0644);
+MODULE_PARM_DESC(s5k4e1_motor_debug, "Debug level (0-1)");
+
+#define dprintk(level, fmt, arg...) \
+    do {			\
+	if (s5k4e1_motor_debug >= level) \
+		printk(KERN_DEBUG "mrstisp@%s: " fmt "\n", __func__, ## arg); \
+    } while (0)
+
+#define eprintk(fmt, arg...)	\
+	printk(KERN_ERR "mrstisp@%s: line %d: " fmt "\n",	\
+	       __func__, __LINE__, ## arg);
+
+static inline struct s5k4e1_motor *to_motor_config(struct v4l2_subdev *sd)
+{
+	return container_of(sd, struct s5k4e1_motor, sd);
+}
+
+static int motor_read(struct i2c_client *c, u32 *reg)
+{
+	int ret;
+	struct i2c_msg msg;
+	u8 msgbuf[3];
+
+	msgbuf[0] = 0;
+	msgbuf[1] = 0;
+	msgbuf[2] = 0;
+
+	memset(&msg, 0, sizeof(msg));
+	msg.addr = c->addr;
+	msg.buf = msgbuf;
+	msg.len = 3;
+	msg.flags = I2C_M_RD;
+
+	ret = i2c_transfer(c->adapter, &msg, 1);
+
+	*reg = (msgbuf[0] << 16 | msgbuf[1] << 8 | msgbuf[2]);
+
+	ret = (ret == 1) ? 0 : -1;
+	return ret;
+}
+
+static int motor_write(struct i2c_client *c, u32 reg)
+{
+	int ret;
+	struct i2c_msg msg;
+	u8 msgbuf[3];
+
+	memset(&msg, 0, sizeof(msg));
+	msgbuf[0] = (reg & 0x00FFFFFFFF) >> 16;
+	msgbuf[1] = (reg & 0x0000FFFF) >> 8 ;
+	msgbuf[2] = reg;
+
+	msg.addr = c->addr;
+	msg.flags = 0;
+	msg.buf = msgbuf;
+	msg.len = 3;
+
+	ret = i2c_transfer(c->adapter, &msg, 1);
+
+	ret = (ret == 1) ? 0 : -1;
+	return ret;
+}
+
+static int s5k4e1_motor_goto_position(struct i2c_client *c,
+				      unsigned short code,
+				      struct s5k4e1_motor *config,
+				      unsigned int step)
+{
+	int max_code, min_code;
+	int timeout = 25; /*TODO: check the timeout time */
+	u8 cmdh, cmdl, finished;
+	u32 cmd = 0, val = 0;
+
+	max_code = config->macro_code;
+	min_code = config->infin_code;
+
+	if (code > max_code)
+		code = max_code;
+	if (code < min_code)
+		code = min_code;
+
+	cmdh = MOTOR_DAC_CTRL_MODE_1 | (code >> 8); /* PS EN x x M W TD9 TD8*/
+	cmdl = code; /* TD7 ~ TD0 */
+	cmd |= (cmdh << 16) | (cmdl << 8);
+
+	dprintk(1, "cmdh: %x, cmdl: %x, cmd: %x", cmdh, cmdl, cmd);
+	dprintk(1, "DAC code: %x", code);
+
+	motor_write(c, cmd);
+	finished = 0;
+	while ((!finished) && timeout--) {
+		msleep(1);
+		motor_read(c, &val);
+		cmdh = val >> 16;
+		cmdl = val >> 8;
+
+		dprintk(1, "cmdh & MOTOR_F = %x", cmdh & MOTOR_F);
+		finished = cmdh & MOTOR_F;
+		finished = (finished) ? 0 : 1;
+	};
+
+	if (finished) {
+		dprintk(1, "Moving from code %x to code %x takes %d ms.",
+		       config->cur_code, code, 25-timeout);
+		return 0;
+	} else {
+		eprintk("Unable to move motor to step %d, TIMEOUT!!", step);
+		return -1;
+	}
+
+}
+
+static int s5k4e1_motor_wakeup(struct i2c_client *client)
+{
+	/* hardware wakeup: set PS = 1 */
+	return motor_write(client, 0xC00000);
+}
+
+static int s5k4e1_motor_init(struct i2c_client *client,
+						struct s5k4e1_motor *config)
+{
+
+	int ret;
+	int infin_cur, macro_cur;
+	int step_res, step_time;
+	int val;
+
+	infin_cur = max(MOTOR_INFIN_CUR, MOTOR_DAC_MIN_CUR);
+	macro_cur = min(MOTOR_MACRO_CUR, MOTOR_DAC_MAX_CUR);
+	step_res = 1 << MOTOR_STEP_SHIFT;
+	step_time = MOTOR_STEP_TIME;
+
+	config->infin_cur = infin_cur;
+	config->macro_cur = macro_cur;
+
+	config->infin_code = MOTOR_INFIN_CODE;
+	config->macro_code = MOTOR_MACRO_CODE;
+
+	config->max_step = ((config->macro_code - config->infin_code)
+			    >> MOTOR_STEP_SHIFT) + 1;
+	config->step_res = step_res;
+	config->step_time = step_time;
+
+	dprintk(1, "max_step: %d, step_res: %d, step_time: %d",
+		config->max_step, step_res, step_time);
+
+	val = (MOTOR_DAC_CTRL_MODE_0 << 16) | (step_res << 8) | step_time;
+	ret = motor_write(client, val);
+
+	ret |= s5k4e1_motor_goto_position(client, config->infin_code,
+					  config, 0);
+	if (!ret) {
+		config->cur_code = config->infin_code;
+		dprintk(1, "Motor initialization success!");
+	} else
+		eprintk("Error while initializing motor!!!");
+
+	return ret;
+}
+
+static int s5k4e1_motor_get_focus(struct i2c_client *c,
+			   unsigned int *step,
+			   struct s5k4e1_motor *config)
+{
+	int ret_step;
+
+	ret_step = ((config->cur_code - config->infin_code)
+		    >> MOTOR_STEP_SHIFT);
+
+	if (ret_step <= config->max_step)
+		*step = ret_step;
+	else
+		*step = config->max_step;
+
+	return 0;
+}
+
+static int s5k4e1_motor_set_focus(struct i2c_client *c,
+			   unsigned int step,
+			   struct s5k4e1_motor *config)
+{
+	int s_code, ret;
+	int max_step = config->max_step;
+	unsigned int val = step;
+
+	if (val > max_step)
+		val = max_step;
+
+	s_code = (val << MOTOR_STEP_SHIFT);
+	s_code += config->infin_code;
+
+	ret = s5k4e1_motor_goto_position(c, s_code, config, step);
+	if (!ret)
+		config->cur_code = s_code;
+
+	return ret;
+}
+
+static int s5k4e1_motor_g_ctrl(struct v4l2_subdev *sd,
+			       struct v4l2_control *ctrl)
+{
+	int ret = -EINVAL;
+	struct i2c_client *c = v4l2_get_subdevdata(sd);
+	struct s5k4e1_motor *config = to_motor_config(sd);
+	if (!sd || !ctrl)
+		return ret;
+
+	switch (ctrl->id) {
+	case V4L2_CID_FOCUS_ABSOLUTE:
+		ret = s5k4e1_motor_get_focus(c, &ctrl->value, config);
+		if (ret) {
+			eprintk("error call s5k4e1_motor_get_focue");
+			return ret;
+		}
+		break;
+	default:
+		dprintk(1, "not supported ctrl id");
+		break;
+	}
+	return ret;
+}
+
+static int s5k4e1_motor_s_ctrl(struct v4l2_subdev *sd,
+			       struct v4l2_control *ctrl)
+{
+	int ret = -EINVAL;
+	struct i2c_client *c = v4l2_get_subdevdata(sd);
+	struct s5k4e1_motor *config = to_motor_config(sd);
+	if (!sd || !ctrl)
+		return ret;
+
+	switch (ctrl->id) {
+	case V4L2_CID_FOCUS_ABSOLUTE:
+		ret = s5k4e1_motor_set_focus(c, ctrl->value, config);
+		if (ret) {
+			eprintk("error call s5k4e1_motor_set_focue");
+			return ret;
+		}
+		break;
+	default:
+		dprintk(1, "not supported ctrl id");
+		break;
+	}
+	return ret;
+}
+
+static int s5k4e1_motor_queryctrl(struct v4l2_subdev *sd,
+			    struct v4l2_queryctrl *qc)
+{
+	int ret = -EINVAL;
+	struct s5k4e1_motor *config;
+	if (!sd)
+		return -ENODEV;
+	if (!qc)
+		return ret;
+	config = to_motor_config(sd);
+
+	switch (qc->id) {
+	case V4L2_CID_FOCUS_ABSOLUTE:
+		ret = v4l2_ctrl_query_fill(qc, 0, config->max_step,
+				 config->max_step, config->macro_code);
+		break;
+	default:
+		dprintk(1, "not supported queryctrl id");
+		break;
+	}
+	return ret;
+}
+
+static const struct v4l2_subdev_core_ops s5k4e1_motor_core_ops = {
+	.g_ctrl = s5k4e1_motor_g_ctrl,
+	.s_ctrl = s5k4e1_motor_s_ctrl,
+	.queryctrl = s5k4e1_motor_queryctrl,
+};
+
+static const struct v4l2_subdev_ops s5k4e1_motor_ops = {
+	.core = &s5k4e1_motor_core_ops,
+};
+
+static int s5k4e1_motor_detect(struct i2c_client *client)
+{
+	struct i2c_adapter *adapter = client->adapter;
+	int adap_id = i2c_adapter_id(adapter);
+
+	if (!i2c_check_functionality(adapter, I2C_FUNC_I2C)) {
+		eprintk("error i2c check func");
+		return -ENODEV;
+	}
+
+	if (adap_id != 1) {
+		eprintk("adap_id != 1");
+		return -ENODEV;
+	}
+
+	if (s5k4e1_motor_wakeup(client))
+		eprintk("unable to wakeup s5k4e1 motor.");
+
+	return 0;
+}
+
+static int s5k4e1_motor_probe(struct i2c_client *client,
+			const struct i2c_device_id *id)
+{
+	struct s5k4e1_motor *info;
+	struct v4l2_subdev *sd;
+	int ret = -1;
+
+	v4l_info(client, "chip found @ 0x%x (%s)\n",
+		 client->addr << 1, client->adapter->name);
+
+	info = kzalloc(sizeof(struct s5k4e1_motor), GFP_KERNEL);
+	if (!info) {
+		eprintk("fail to malloc for ci_motor");
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ret = s5k4e1_motor_detect(client);
+	if (ret) {
+		eprintk("error s5k4e1_motor_detect");
+		goto out_free;
+	}
+
+	sd = &info->sd;
+	v4l2_i2c_subdev_init(sd, client, &s5k4e1_motor_ops);
+
+	ret = s5k4e1_motor_init(client, info);
+	if (ret) {
+		eprintk("error calling s5k4e1_motor_init");
+		goto out_free;
+	}
+
+	ret = 0;
+	goto out;
+
+out_free:
+	kfree(info);
+out:
+	return ret;
+}
+
+static int s5k4e1_motor_remove(struct i2c_client *client)
+{
+	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+
+	v4l2_device_unregister_subdev(sd);
+	kfree(to_motor_config(sd));
+	return 0;
+}
+
+static const struct i2c_device_id s5k4e1_motor_id[] = {
+	{"s5k4e1_motor", 0},
+	{}
+};
+MODULE_DEVICE_TABLE(i2c, s5k4e1_motor_id);
+
+static struct i2c_driver s5k4e1_motor_i2c_driver = {
+	.driver = {
+		.name = "s5k4e1_motor",
+	},
+	.probe = s5k4e1_motor_probe,
+	.remove = s5k4e1_motor_remove,
+	.id_table = s5k4e1_motor_id,
+};
+
+static int __init s5k4e1_motor_drv_init(void)
+{
+	return i2c_add_driver(&s5k4e1_motor_i2c_driver);
+}
+
+static void __exit s5k4e1_motor_drv_cleanup(void)
+{
+	i2c_del_driver(&s5k4e1_motor_i2c_driver);
+}
+
+module_init(s5k4e1_motor_drv_init);
+module_exit(s5k4e1_motor_drv_cleanup);
+
+MODULE_AUTHOR("Xiaolin Zhang <xiaolin.zhang@intel.com>");
+MODULE_DESCRIPTION("A low-level driver for Samsung S5K4E1 sensor motor");
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/video/s5k4e1_motor.h b/drivers/media/video/s5k4e1_motor.h
new file mode 100644
index 0000000..b4a2aa1
--- /dev/null
+++ b/drivers/media/video/s5k4e1_motor.h
@@ -0,0 +1,90 @@
+/*
+ * Support for Moorestown Langwell Camera Imaging ISP subsystem.
+ *
+ * Copyright (c) 2009 Intel Corporation. All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ *
+ *
+ * Xiaolin Zhang <xiaolin.zhang@intel.com>
+ */
+
+#include <media/v4l2-subdev.h>
+#include <linux/kernel.h>
+
+/* DAC output max current (mA) */
+#define MOTOR_DAC_MAX_CUR	125
+/* DAC output min current (mA) */
+#define MOTOR_DAC_MIN_CUR	1
+/* DAC max code (Hex) */
+#define MOTOR_DAC_CODE_MAX 	0x3FF
+/* DAC min code (Hex) */
+#define MOTOR_DAC_CODE_MIN	0x0
+
+/* VCM start code (Hex) */
+#define MOTOR_INFIN_CODE	0x120
+/* VCM stop code (Hex) */
+#define MOTOR_MACRO_CODE	0x205
+
+#define MOTOR_STEP_SHIFT	4	/* Step res = 2^4 = 10H */
+#define MOTOR_STEP_TIME		20	/* Step time = 50us x 20d = 1ms */
+
+/* VCM start current (mA) */
+#define MOTOR_INFIN_CUR		((MOTOR_DAC_MAX_CUR / MOTOR_DAC_CODE_MAX) \
+				 * MOTOR_INFIN_CODE + 1)
+/* VCM max current for Macro (mA) */
+#define MOTOR_MACRO_CUR		((MOTOR_DAC_MAX_CUR / MOTOR_DAC_CODE_MAX) \
+				 * MOTOR_MACRO_CODE + 1)
+
+
+#define MOTOR_DAC_BIT_RES	10
+#define MOTOR_DAC_MAX_CODE	((1 << MOTOR_DAC_BIT_RES) - 1)
+
+#define MOTOR_STEP_SHIFT	4
+
+
+/* DAC register related define */
+#define MOTOR_PS	(1 << 7) /* power save */
+#define MOTOR_EN	(1 << 6) /* out pin status*/
+#define MOTOR_M		(1 << 3) /* mode select */
+#define MOTOR_W		(1 << 2) /* register address */
+#define MOTOR_F		(1 << 4) /* finish flag */
+
+#define MOTOR_DAC_CODE_L(x)	(x & 0xff)
+#define MOTOR_DAC_CODE_H(x)	((x >> 8) & 0xf3)
+
+/* Step mode setting */
+#define MOTOR_DAC_CTRL_MODE_0	0xCC
+/* DAC code setting */
+#define MOTOR_DAC_CTRL_MODE_1	0xC8
+
+#define S5K4E1_MOTOR_ADDR	(0x18 >> 1)
+/*#define POWER_EN_PIN	7*/
+#define GPIO_AF_PD	95
+
+#define DEBUG	0
+
+struct s5k4e1_motor{
+	/*struct i2c_client *motor;*/
+	unsigned int infin_cur;
+	unsigned int infin_code;
+	unsigned int macro_cur;
+	unsigned int macro_code;
+	unsigned int max_step;
+	unsigned int cur_code;
+	unsigned int step_res;
+	unsigned int step_time;
+	struct v4l2_subdev sd;
+};
-- 
1.6.3.2

