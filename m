Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:43080 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753775Ab0C1Hr7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Mar 2010 03:47:59 -0400
From: "Zhang, Xiaolin" <xiaolin.zhang@intel.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "Zhu, Daniel" <daniel.zhu@intel.com>,
	"Yu, Jinlu" <jinlu.yu@intel.com>,
	"Wang, Wen W" <wen.w.wang@intel.com>,
	"Huang, Kai" <kai.huang@intel.com>,
	"Hu, Gang A" <gang.a.hu@intel.com>,
	"Ba, Zheng" <zheng.ba@intel.com>,
	"Zhang, Xiaolin" <xiaolin.zhang@intel.com>
Date: Sun, 28 Mar 2010 15:47:51 +0800
Subject: [PATCH v2 7/10] V4L2 patches for Intel Moorestown Camera Imaging
 Drivers
Message-ID: <33AB447FBD802F4E932063B962385B351D6D5351@shsmsx501.ccr.corp.intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>From ffd8b7e0f07391e9d44bd0c93390362fca0e6a2f Mon Sep 17 00:00:00 2001
From: Xiaolin Zhang <xiaolin.zhang@intel.com>
Date: Sun, 28 Mar 2010 14:12:41 +0800
Subject: [PATCH 07/10] this patch is the 5mp camera (ov5630) sensor lens subdev driver for intel moorestown camera imaging.

Signed-off-by: Xiaolin Zhang <xiaolin.zhang@intel.com>
---
 .../media/video/mrstci/mrstov5630_motor/Kconfig    |    9 +
 .../media/video/mrstci/mrstov5630_motor/Makefile   |    3 +
 .../mrstci/mrstov5630_motor/mrstov5630_motor.c     |  373 ++++++++++++++++++++
 .../video/mrstci/mrstov5630_motor/ov5630_motor.h   |   89 +++++
 4 files changed, 474 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/mrstci/mrstov5630_motor/Kconfig
 create mode 100644 drivers/media/video/mrstci/mrstov5630_motor/Makefile
 create mode 100644 drivers/media/video/mrstci/mrstov5630_motor/mrstov5630_motor.c
 create mode 100644 drivers/media/video/mrstci/mrstov5630_motor/ov5630_motor.h

diff --git a/drivers/media/video/mrstci/mrstov5630_motor/Kconfig b/drivers/media/video/mrstci/mrstov5630_motor/Kconfig
new file mode 100644
index 0000000..b6dcf62
--- /dev/null
+++ b/drivers/media/video/mrstci/mrstov5630_motor/Kconfig
@@ -0,0 +1,9 @@
+config VIDEO_MRST_OV5630_MOTOR
+       tristate "Moorestown OV5630 motor"
+       depends on I2C && VIDEO_MRST_ISP && VIDEO_MRST_OV5630
+
+       ---help---
+         Say Y here if your platform support OV5630 motor
+
+         To compile this driver as a module, choose M here: the
+         module will be called mrstov2650.ko.
diff --git a/drivers/media/video/mrstci/mrstov5630_motor/Makefile b/drivers/media/video/mrstci/mrstov5630_motor/Makefile
new file mode 100644
index 0000000..056b2a6
--- /dev/null
+++ b/drivers/media/video/mrstci/mrstov5630_motor/Makefile
@@ -0,0 +1,3 @@
+obj-$(CONFIG_VIDEO_MRST_OV2650)         += mrstov5630_motor.o
+
+EXTRA_CFLAGS   +=      -I$(src)/../include
diff --git a/drivers/media/video/mrstci/mrstov5630_motor/mrstov5630_motor.c b/drivers/media/video/mrstci/mrstov5630_motor/mrstov5630_motor.c
new file mode 100644
index 0000000..ef26985
--- /dev/null
+++ b/drivers/media/video/mrstci/mrstov5630_motor/mrstov5630_motor.c
@@ -0,0 +1,373 @@
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
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/string.h>
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/kmod.h>
+#include <linux/device.h>
+#include <linux/delay.h>
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/delay.h>
+#include <linux/i2c.h>
+#include <linux/gpio.h>
+
+#include <media/v4l2-device.h>
+#include <media/v4l2-chip-ident.h>
+#include <media/v4l2-i2c-drv.h>
+
+#include "ov5630_motor.h"
+
+static int mrstov5630_motor_debug;
+module_param(mrstov5630_motor_debug, int, 0644);
+MODULE_PARM_DESC(mrstov5630_motor_debug, "Debug level (0-1)");
+
+#define dprintk(level, fmt, arg...) do {                       \
+       if (mrstov5630_motor_debug >= level)                            \
+               printk(KERN_DEBUG "mrstisp@%s: " fmt "\n", \
+                      __func__, ## arg); } \
+       while (0)
+
+#define eprintk(fmt, arg...)   \
+       printk(KERN_ERR "mrstisp@%s: line %d: " fmt "\n",       \
+              __func__, __LINE__, ## arg);
+
+#define DBG_entering   dprintk(2, "entering");
+#define DBG_leaving    dprintk(2, "leaving");
+#define DBG_line       dprintk(2, " line: %d", __LINE__);
+
+static inline struct ov5630_motor *to_motor_config(struct v4l2_subdev *sd)
+{
+       return container_of(sd, struct ov5630_motor, sd);
+}
+
+static int motor_read(struct i2c_client *c, u16 *reg)
+{
+       int ret;
+       struct i2c_msg msg;
+       u8 msgbuf[2];
+
+       msgbuf[0] = 0;
+       msgbuf[1] = 0;
+
+       memset(&msg, 0, sizeof(msg));
+       msg.addr = c->addr;
+       msg.buf = msgbuf;
+       msg.len = 2;
+       msg.flags = I2C_M_RD;
+
+       ret = i2c_transfer(c->adapter, &msg, 1);
+       *reg = (msgbuf[0] << 8 | msgbuf[1]);
+
+       ret = (ret == 1) ? 0 : -1;
+       return ret;
+}
+
+static int motor_write(struct i2c_client *c, u16 reg)
+{
+       int ret;
+       struct i2c_msg msg;
+       u8 msgbuf[2];
+
+       memset(&msg, 0, sizeof(msg));
+       msgbuf[0] = reg >> 8;
+       msgbuf[1] = reg;
+
+       msg.addr = c->addr;
+       msg.flags = 0;
+       msg.buf = msgbuf;
+       msg.len = 2;
+
+       ret = i2c_transfer(c->adapter, &msg, 1);
+       ret = (ret == 1) ? 0 : -1;
+       return ret;
+}
+
+static int ov5630_motor_goto_position(struct i2c_client *c,
+                                     unsigned short code,
+                                     struct ov5630_motor *config)
+{
+       int max_code, min_code;
+       u8 cmdh, cmdl;
+       u16 cmd, val = 0;
+
+       max_code = config->macro_code;
+       min_code = config->infin_code;
+
+       if (code > max_code)
+               code = max_code;
+       if (code < min_code)
+               code = min_code;
+
+       cmdh = (MOTOR_DAC_CODE_H(code));
+       cmdl = (MOTOR_DAC_CODE_L(code) | MOTOR_DAC_CTRL_MODE_2(SUB_MODE_4));
+       cmd = cmdh << 8 | cmdl;
+
+       motor_write(c, cmd);
+       msleep(8);
+       motor_read(c, &val);
+
+       return (cmd == val ? 0 : -1);
+}
+
+int ov5630_motor_wakeup(void)
+{
+       return gpio_direction_output(GPIO_AF_PD, 1);
+}
+
+int ov5630_motor_standby(void)
+{
+       return gpio_direction_output(GPIO_AF_PD, 0);
+}
+
+int ov5630_motor_init(struct i2c_client *client, struct ov5630_motor *config)
+{
+       int ret;
+       int infin_cur, macro_cur;
+
+       infin_cur = MAX(MOTOR_INFIN_CUR, MOTOR_DAC_MIN_CUR);
+       macro_cur = MIN(MOTOR_MACRO_CUR, MOTOR_DAC_MAX_CUR);
+
+       config->infin_cur = infin_cur;
+       config->macro_cur = macro_cur;
+       config->infin_code = (int)((infin_cur * MOTOR_DAC_MAX_CODE)
+                                  / MOTOR_DAC_MAX_CUR);
+       config->macro_code = (int)((macro_cur * MOTOR_DAC_MAX_CODE)
+                                  / MOTOR_DAC_MAX_CUR);
+
+       config->max_step = ((config->macro_code - config->infin_code)
+                           >> MOTOR_STEP_SHIFT) + 1;
+       ret = ov5630_motor_goto_position(client, config->infin_code, config);
+       if (!ret)
+               config->cur_code = config->infin_code;
+       else
+               printk(KERN_ERR "Error while initializing motor\n");
+
+       return ret;
+}
+
+int ov5630_motor_set_focus(struct i2c_client *c, int step,
+                          struct ov5630_motor *config)
+{
+       int s_code, ret;
+       int max_step = config->max_step;
+       unsigned int val = step;
+
+       DBG_entering;
+       dprintk(1, "setting setp %d", step);
+       if (val > max_step)
+               val = max_step;
+
+       s_code = (val << MOTOR_STEP_SHIFT);
+       s_code += config->infin_code;
+
+       ret = ov5630_motor_goto_position(c, s_code, config);
+       if (!ret)
+               config->cur_code = s_code;
+
+       DBG_leaving;
+       return ret;
+}
+
+static int ov5630_motor_s_ctrl(struct v4l2_subdev *sd,
+                              struct v4l2_control *ctrl)
+{
+       struct i2c_client *c = v4l2_get_subdevdata(sd);
+       struct ov5630_motor *config = to_motor_config(sd);
+       int ret;
+
+       DBG_entering;
+       ret = ov5630_motor_set_focus(c, ctrl->value, config);
+       if (ret) {
+               eprintk("error call ov5630_motor_set_focue");
+               return ret;
+       }
+       DBG_leaving;
+       return 0;
+}
+int ov5630_motor_get_focus(struct i2c_client *c, unsigned int *step,
+                          struct ov5630_motor *config)
+{
+       int ret_step;
+
+       ret_step = ((config->cur_code - config->infin_code)
+                   >> MOTOR_STEP_SHIFT);
+
+       if (ret_step <= config->max_step)
+               *step = ret_step;
+       else
+               *step = config->max_step;
+
+       return 0;
+}
+
+static int ov5630_motor_g_ctrl(struct v4l2_subdev *sd,
+                              struct v4l2_control *ctrl)
+{
+       struct i2c_client *c = v4l2_get_subdevdata(sd);
+       struct ov5630_motor *config = to_motor_config(sd);
+       int ret;
+
+       DBG_entering;
+       ret = ov5630_motor_get_focus(c, &ctrl->value, config);
+       if (ret) {
+               eprintk("error call ov5630_motor_get_focue");
+               return ret;
+       }
+       DBG_leaving;
+       return 0;
+}
+int ov5630_motor_max_step(struct i2c_client *c, unsigned int *max_code,
+                          struct ov5630_motor *config)
+{
+       if (config->max_step != 0)
+               *max_code = config->max_step;
+       return 0;
+}
+
+static int ov5630_motor_queryctrl(struct v4l2_subdev *sd,
+                           struct v4l2_queryctrl *qc)
+{
+       struct ov5630_motor *config = to_motor_config(sd);
+
+       DBG_entering;
+
+       if (qc->id != V4L2_CID_FOCUS_ABSOLUTE)
+               return -EINVAL;
+
+       dprintk(1, "got focus range of %d", config->max_step);
+       if (config->max_step != 0)
+               qc->maximum = config->max_step;
+       DBG_leaving;
+       return 0;
+}
+static const struct v4l2_subdev_core_ops ov5630_motor_core_ops = {
+       .g_ctrl = ov5630_motor_g_ctrl,
+       .s_ctrl = ov5630_motor_s_ctrl,
+       .queryctrl = ov5630_motor_queryctrl,
+};
+
+static const struct v4l2_subdev_ops ov5630_motor_ops = {
+       .core = &ov5630_motor_core_ops,
+};
+
+static int ov5630_motor_detect(struct i2c_client *client)
+{
+       struct i2c_adapter *adapter = client->adapter;
+       int adap_id = i2c_adapter_id(adapter);
+
+       if (!i2c_check_functionality(adapter, I2C_FUNC_I2C)) {
+               eprintk("error i2c check func");
+               return -ENODEV;
+       }
+
+       if (adap_id != 1) {
+               eprintk("adap_id != 1");
+               return -ENODEV;
+       }
+
+       ov5630_motor_wakeup();
+       ssleep(1);
+
+       return 0;
+}
+
+static int ov5630_motor_probe(struct i2c_client *client,
+                       const struct i2c_device_id *id)
+{
+       struct ov5630_motor *info;
+       struct v4l2_subdev *sd;
+       int ret = -1;
+
+       DBG_entering;
+       v4l_info(client, "chip found @ 0x%x (%s)\n",
+                client->addr << 1, client->adapter->name);
+
+       info = kzalloc(sizeof(struct ov5630_motor), GFP_KERNEL);
+       if (!info) {
+               eprintk("fail to malloc for ci_motor");
+               ret = -ENOMEM;
+               goto out;
+       }
+
+       ret = ov5630_motor_detect(client);
+       if (ret) {
+               eprintk("error ov5630_motor_detect");
+               goto out_free;
+       }
+
+       sd = &info->sd;
+       v4l2_i2c_subdev_init(sd, client, &ov5630_motor_ops);
+
+       ret = ov5630_motor_init(client, info);
+       if (ret) {
+               eprintk("error calling ov5630_motor_init");
+               goto out_free;
+       }
+
+       ret = 0;
+       goto out;
+
+out_free:
+       kfree(info);
+       DBG_leaving;
+out:
+       return ret;
+}
+
+static int ov5630_motor_remove(struct i2c_client *client)
+{
+       struct v4l2_subdev *sd = i2c_get_clientdata(client);
+
+       DBG_entering;
+
+       v4l2_device_unregister_subdev(sd);
+       kfree(to_motor_config(sd));
+
+       DBG_leaving;
+       return 0;
+}
+
+static const struct i2c_device_id ov5630_motor_id[] = {
+       {"ov5630_motor", 0},
+       {}
+};
+
+MODULE_DEVICE_TABLE(i2c, ov5630_motor_id);
+
+static struct v4l2_i2c_driver_data v4l2_i2c_data = {
+       .name = "ov5630_motor",
+       .probe = ov5630_motor_probe,
+       .remove = ov5630_motor_remove,
+       .id_table = ov5630_motor_id,
+};
+
+MODULE_AUTHOR("Xiaolin Zhang <xiaolin.zhang@intel.com>");
+MODULE_DESCRIPTION("A low-level driver for OmniVision 5630 sensors");
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/video/mrstci/mrstov5630_motor/ov5630_motor.h b/drivers/media/video/mrstci/mrstov5630_motor/ov5630_motor.h
new file mode 100644
index 0000000..55804a3
--- /dev/null
+++ b/drivers/media/video/mrstci/mrstov5630_motor/ov5630_motor.h
@@ -0,0 +1,89 @@
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
+
+/* VCM start current (mA) */
+#define MOTOR_INFIN_CUR                15
+
+/* VCM max current for Macro (mA) */
+#define MOTOR_MACRO_CUR                90
+
+/* DAC output max current (mA) */
+#define MOTOR_DAC_MAX_CUR      100
+
+/* DAC output min current (mA) */
+#define MOTOR_DAC_MIN_CUR      3
+
+#define MOTOR_DAC_BIT_RES      10
+#define MOTOR_DAC_MAX_CODE     ((1 << MOTOR_DAC_BIT_RES) - 1)
+
+#define MOTOR_STEP_SHIFT       4
+
+#define MAX(x, y)      ((x) > (y) ? (x) : (y))
+#define MIN(x, y)      ((x) < (y) ? (x) : (y))
+
+/* DAC register related define */
+#define MOTOR_POWER_DOWN       (1 << 7)
+#define                PD_ENABLE       (1 << 7)
+#define                PD_DISABLE      (0)
+
+#define MOTOR_DAC_CODE_H(x)    ((x >> 4) & 0x3f)
+#define MOTOR_DAC_CODE_L(x)    ((x << 4) & 0xf0)
+
+#define MOTOR_DAC_CTRL_MODE_0  0x00
+#define MOTOR_DAC_CTRL_MODE_1(x)       (x & 0x07)
+#define MOTOR_DAC_CTRL_MODE_2(x)       ((x & 0x07) | 0x08)
+
+#define SUB_MODE_1     0x01
+#define SUB_MODE_2     0x02
+#define SUB_MODE_3     0x03
+#define SUB_MODE_4     0x04
+#define SUB_MODE_5     0x05
+#define SUB_MODE_6     0x06
+#define SUB_MODE_7     0x07
+
+#define OV5630_MOTOR_ADDR      (0x18 >> 1)
+#define POWER_EN_PIN   7
+#define GPIO_AF_PD     95
+
+struct ov5630_motor{
+       unsigned int infin_cur;
+       unsigned int infin_code;
+       unsigned int macro_cur;
+       unsigned int macro_code;
+       unsigned int max_step;
+       unsigned int cur_code;
+       struct v4l2_subdev sd;
+};
+
+extern int ov5630_motor_init(struct i2c_client *client, struct ov5630_motor
+                            *config);
+extern int ov5630_motor_standby(void);
+extern int ov5630_motor_wakeup(void);
+extern int ov5630_motor_set_focus(struct i2c_client *c, int step,
+                          struct ov5630_motor *config);
+extern int ov5630_motor_get_focus(struct i2c_client *c, unsigned int *step,
+                          struct ov5630_motor *config);
+extern int ov5630_motor_max_step(struct i2c_client *c, unsigned int *max_code,
+                          struct ov5630_motor *config);
--
1.6.3.2

