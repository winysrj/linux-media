Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:32021 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755958Ab0ERJXd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 May 2010 05:23:33 -0400
From: "Zhang, Xiaolin" <xiaolin.zhang@intel.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Tue, 18 May 2010 17:23:20 +0800
Subject: [PATCH v3 5/8] V4L2 subdev patchset for Intel Moorestown Camera
 Imaging Subsystem
Message-ID: <33AB447FBD802F4E932063B962385B351E895731@shsmsx501.ccr.corp.intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>From 9c2160917def0545c3a55dddef6c3ead770a1cb1 Mon Sep 17 00:00:00 2001
From: Xiaolin Zhang <xiaolin.zhang@intel.com>
Date: Tue, 18 May 2010 15:25:06 +0800
Subject: [PATCH 5/8] This patch is to add 5MP raw camera (s5k4e1) support which is based
 on the video4linux2 sub-dev driver framework.

Signed-off-by: Xiaolin Zhang <xiaolin.zhang@intel.com>
---
 drivers/media/video/s5k4e1.c |  717 ++++++++++++++++++++++++++++++++++++++++++
 drivers/media/video/s5k4e1.h |  573 +++++++++++++++++++++++++++++++++
 2 files changed, 1290 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/s5k4e1.c
 create mode 100644 drivers/media/video/s5k4e1.h

diff --git a/drivers/media/video/s5k4e1.c b/drivers/media/video/s5k4e1.c
new file mode 100644
index 0000000..fc47cec
--- /dev/null
+++ b/drivers/media/video/s5k4e1.c
@@ -0,0 +1,717 @@
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
+#include <linux/gpio.h>
+#include <linux/delay.h>
+#include <linux/videodev2.h>
+#include <linux/slab.h>
+#include <media/v4l2-device.h>
+
+#include "mrst_sensor_common.h"
+#include "s5k4e1.h"
+
+static int s5k4e1_debug;
+module_param(s5k4e1_debug, int, 0644);
+MODULE_PARM_DESC(s5k4e1_debug, "Debug level (0-1)");
+
+#define dprintk(level, fmt, arg...) \
+       do { \
+               if (s5k4e1_debug >= level) \
+                       printk(KERN_DEBUG "%s: " fmt "\n", \
+                              __func__, ## arg);\
+       } while (0)
+
+#define eprintk(fmt, arg...)   \
+       printk(KERN_ERR "%s:" fmt "\n", \
+              __func__, ## arg);
+
+static inline struct ci_sensor_config *to_sensor_config(struct v4l2_subdev *sd)
+{
+       return container_of(sd, struct ci_sensor_config, sd);
+}
+
+static struct s5k4e1_res_struct {
+       __u8 *desc;
+       int res;
+       int width;
+       int height;
+       int fps;
+       bool used;
+       const struct regval_list *regs;
+} s5k4e1_res[] = {
+       {
+               .desc           = "QSXGA_PLUS4",
+               .res            = SENSOR_RES_QXGA_PLUS,
+               .width          = 2592,
+               .height         = 1944,
+               .fps            = 15,
+               .used           = 0,
+               .regs           = s5k4e1_res_qsxga_plus4,
+       },
+       {
+               .desc           = "1080P",
+               .res            = SENSOR_RES_1080P,
+               .width          = 1920,
+               .height         = 1080,
+               .fps            = 25,
+               .used           = 0,
+               .regs           = s5k4e1_res_1080p,
+       },
+       {
+               .desc           = "VGA_PLUS",
+               .res            = SENSOR_RES_VGA_PLUS,
+               .width          = 1304,
+               .height         = 980,
+               .fps            = 30,
+               .used           = 0,
+               .regs           = s5k4e1_res_vga_ac04_bill,
+       },
+       {
+               .desc           = "720p",
+               .res            = SENSOR_RES_720P,
+               .width          = 1280,
+               .height         = 720,
+               .fps            = 30,
+               .used           = 0,
+               .regs           = s5k4e1_res_720p,
+       },
+       {
+               .desc           = "VGA",
+               .res            = SENSOR_RES_VGA,
+               .width          = 640,
+               .height         = 480,
+               .used           = 0,
+               .fps            = 40,
+               .regs           = s5k4e1_res_vga_ac04_bill,
+       },
+};
+
+#define N_RES (ARRAY_SIZE(s5k4e1_res))
+
+static int s5k4e1_read(struct i2c_client *c, u32 reg, u32 *value)
+{
+       int ret;
+       int i;
+       struct i2c_msg msg[2];
+       u8 msgbuf[2];
+       u8 ret_val = 0;
+       *value = 0;
+       memset(&msg, 0, sizeof(msg));
+       msgbuf[0] = 0;
+       msgbuf[1] = 0;
+       i = 0;
+
+       msgbuf[i++] = ((u16)reg) >> 8;
+       msgbuf[i++] = ((u16)reg) & 0xff;
+       msg[0].addr = c->addr;
+       msg[0].buf = msgbuf;
+       msg[0].len = i;
+
+       msg[1].addr = c->addr;
+       msg[1].flags = I2C_M_RD;
+       msg[1].buf = &ret_val;
+       msg[1].len = 1;
+
+       ret = i2c_transfer(c->adapter, &msg[0], 2);
+       *value = ret_val;
+
+       ret = (ret == 2) ? 0 : -1;
+       dprintk(2, "reg:0x%8x, value:0x%8x - %s", reg, *value,
+               (ret ? "failed" : "succesfully"));
+       return ret;
+}
+
+static int s5k4e1_write(struct i2c_client *c, u32 reg, u32 value)
+{
+       int ret, i;
+       struct i2c_msg msg;
+       u8 msgbuf[3];
+
+       memset(&msg, 0, sizeof(msg));
+       i = 0;
+       msgbuf[i++] = ((u16)reg) >> 8;
+       msgbuf[i++] = (u16)reg & 0xff;
+       msgbuf[i++] = (u8)value;
+
+       msg.addr = c->addr;
+       msg.flags = 0;
+       msg.buf = msgbuf;
+       msg.len = i;
+
+       ret = i2c_transfer(c->adapter, &msg, 1);
+
+       if (reg == 0x0103 && (value & 0x01))
+               msleep(4);
+
+       ret = (ret == 1) ? 0 : -1;
+
+       return ret;
+}
+
+static int s5k4e1_write_array(struct i2c_client *c,
+                                       const struct regval_list *vals)
+{
+       const struct regval_list *p;
+       u32 read_val = 0;
+       int err_num = 0;
+       int i = 0;
+
+       p = vals;
+       while (p->reg_num != 0xffff) {
+               s5k4e1_write(c, (u32)p->reg_num, (u32)p->value);
+               s5k4e1_read(c, (u32)p->reg_num, &read_val);
+               if (read_val != p->value) {
+                       eprintk("0x%x write error:should be 0x%x, but 0x%x",
+                               p->reg_num, p->value, read_val);
+                       err_num++;
+               }
+               p++;
+               i++;
+       }
+       dprintk(1, "sucessfully wrote %d registers, err is %d", i,
+              err_num);
+       return 0;
+}
+
+static int s5k4e1_set_img_ctrl(struct i2c_client *c,
+                              const struct ci_sensor_config *config)
+{
+       int err = 0;
+
+       switch (config->blc) {
+       case SENSOR_BLC_AUTO:
+               break;
+       default:
+               dprintk(1, "BLC not supported,\
+                       set to BLC_AUTO by default.");
+       }
+
+       switch (config->bls) {
+       case SENSOR_BLS_OFF:
+               break;
+       default:
+               dprintk(1, "Black level not supported,\
+                       set to BLS_OFF by default.");
+       }
+
+       switch (config->agc) {
+               /* only SENSOR_AGC_OFF supported */
+       case SENSOR_AGC_OFF:
+               break;
+       default:
+               dprintk(1, "AGC not supported,\
+                       set to AGC_OFF by default.");
+       }
+
+       switch (config->awb) {
+               /* only SENSOR_AWB_OFF supported */
+       case SENSOR_AWB_OFF:
+               break;
+       default:
+               dprintk(1, "AWB not supported,\
+                       set to AWB_OFF by default.");
+       }
+
+       switch (config->aec) {
+               /* only SENSOR_AEC_OFF supported */
+       case SENSOR_AEC_OFF:
+               break;
+       default:
+               dprintk(1, "AEC not supported,\
+                       set to AEC_OFF by default.");
+       }
+
+       return err;
+}
+
+static int s5k4e1_init(struct i2c_client *c)
+{
+       int ret = 0;
+
+       ret += s5k4e1_write(c, 0x0100, (u32)0x00);
+       ret = s5k4e1_write(c, 0x0103, (u32)0x01);
+       msleep(4);
+
+       #ifdef S5K4E1_MIPI
+       ret += s5k4e1_write_array(c, s5k4e1_mipi);
+       #endif
+
+       /* streaming */
+       ret += s5k4e1_write(c, 0x0100, (u32)0x01);
+       msleep(1);
+
+       return ret;
+}
+
+static int distance(struct s5k4e1_res_struct *res, u32 w, u32 h)
+{
+       int ret;
+
+       if (res->width < w || res->height < h)
+               return -1;
+       ret = ((res->width - w) + (res->height - h));
+
+       return ret;
+}
+
+static int s5k4e1_try_res(u32 *w, u32 *h)
+{
+       struct s5k4e1_res_struct *res_index, *p = NULL;
+       int dis, last_dis = s5k4e1_res->width + s5k4e1_res->height;
+
+       for (res_index = s5k4e1_res;
+            res_index < s5k4e1_res + N_RES;
+            res_index++) {
+               if ((res_index->width < *w) || (res_index->height < *h))
+                       break;
+               dis = distance(res_index, *w, *h);
+               if (dis < last_dis) {
+                       last_dis = dis;
+                       p = res_index;
+               }
+       }
+
+       if (p == NULL)
+               p = s5k4e1_res;
+       else if ((p->width < *w) || (p->height < *h)) {
+               if (p != s5k4e1_res)
+                       p--;
+       }
+
+       if ((w != NULL) && (h != NULL)) {
+               *w = p->width;
+               *h = p->height;
+       }
+
+       return 0;
+}
+
+static struct s5k4e1_res_struct *s5k4e1_to_res(u32 w, u32 h)
+{
+       struct s5k4e1_res_struct *res_index;
+
+       for (res_index = s5k4e1_res;
+            res_index < s5k4e1_res + N_RES;
+            res_index++)
+               if ((res_index->width == w) && (res_index->height == h))
+                       break;
+
+       if (res_index >= s5k4e1_res + N_RES)
+               res_index--;
+
+       return res_index;
+}
+
+static int s5k4e1_try_fmt(struct v4l2_subdev *sd,
+                         struct v4l2_mbus_framefmt *fmt)
+{
+       return s5k4e1_try_res(&fmt->width, &fmt->height);
+}
+
+static int s5k4e1_get_fmt(struct v4l2_subdev *sd,
+                         struct v4l2_mbus_framefmt *fmt)
+{
+       struct ci_sensor_config *info = to_sensor_config(sd);
+       unsigned short width, height;
+       int index;
+
+       ci_sensor_res2size(info->res, &width, &height);
+
+       for (index = 0; index < N_RES; index++) {
+               if ((width == s5k4e1_res[index].width) &&
+                   (height == s5k4e1_res[index].height)) {
+                       s5k4e1_res[index].used = 1;
+                       continue;
+               }
+               s5k4e1_res[index].used = 0;
+       }
+
+       fmt->width = width;
+       fmt->height = height;
+       return 0;
+
+}
+
+static int s5k4e1_set_fmt(struct v4l2_subdev *sd,
+                                       struct v4l2_mbus_framefmt *fmt)
+{
+       struct i2c_client *c = v4l2_get_subdevdata(sd);
+       struct ci_sensor_config *info = to_sensor_config(sd);
+       int ret = 0;
+       struct s5k4e1_res_struct *res_index;
+       u32 width, height;
+       int index;
+
+       width = fmt->width;
+       height = fmt->height;
+
+       dprintk(1, "was told to set fmt (%d x %d) ", width, height);
+       ret = s5k4e1_try_res(&width, &height);
+
+       res_index = s5k4e1_to_res(width, height);
+
+       if (res_index->regs) {
+               ret += s5k4e1_write(c, 0x0100, (u32)0x00);
+               ret = s5k4e1_write(c, 0x0103, (u32)0xff);
+               ret += s5k4e1_write_array(c, res_index->regs);
+               ret += s5k4e1_set_img_ctrl(c, info);
+
+               #ifdef S5K4E1_MIPI
+               ret += s5k4e1_write_array(c, s5k4e1_mipi);
+               #endif
+
+               /* streaming */
+               ret = s5k4e1_write(c, 0x0100, (u32)0x01);
+               msleep(1);
+
+               info->res = res_index->res;
+
+               /* Marked current sensor res as being "used" */
+               for (index = 0; index < N_RES; index++) {
+                       if ((width == s5k4e1_res[index].width) &&
+                           (height == s5k4e1_res[index].height)) {
+                               s5k4e1_res[index].used = 1;
+                               continue;
+                       }
+                       s5k4e1_res[index].used = 0;
+               }
+
+               for (index = 0; index < N_RES; index++)
+                       dprintk(2, "index = %d, used = %d\n", index,
+                               s5k4e1_res[index].used);
+       } else {
+               eprintk("no res for (%d x %d)", width, height);
+       }
+
+       return ret;
+}
+
+static int s5k4e1_t_gain(struct v4l2_subdev *sd, int value)
+{
+       struct i2c_client *client = v4l2_get_subdevdata(sd);
+
+       s5k4e1_write(client, 0x0104, 1);
+
+       /* analog gain */
+       s5k4e1_write(client, 0x0204, value >> 8);
+       s5k4e1_write(client, 0x0205, value & 0xff);
+       s5k4e1_write(client, 0x0104, 0);
+       return 0;
+}
+
+static int s5k4e1_t_exposure(struct v4l2_subdev *sd, int value)
+{
+       struct i2c_client *client = v4l2_get_subdevdata(sd);
+
+       s5k4e1_write(client, 0x0104, 1);
+       /* fine integration time */
+       s5k4e1_write(client, 0x0200, value >> 24);
+       s5k4e1_write(client, 0x0201, (value >> 16) & 0xff);
+
+       /* coarse integration time */
+       s5k4e1_write(client, 0x0202, (value & 0xff00) >> 8);
+       s5k4e1_write(client, 0x0203, value & 0xff);
+       s5k4e1_write(client, 0x0104, 0);
+       return 0;
+}
+
+static int s5k4e1_queryctrl(struct v4l2_subdev *sd,
+                           struct v4l2_queryctrl *qc)
+{
+       int ret = -EINVAL;
+       if (!sd)
+               return -ENODEV;
+       if (!qc)
+               return ret;
+
+       switch (qc->id) {
+       case V4L2_CID_GAIN:
+       case V4L2_CID_EXPOSURE:
+               ret = v4l2_ctrl_query_fill(qc, 0, 65535, 1, 0);
+               break;
+       default:
+               dprintk(1, "unsupported queryctrl id");
+               break;
+       }
+       return ret;
+}
+
+static int s5k4e1_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
+{
+       return 0;
+}
+
+static int s5k4e1_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
+{
+       int ret = -EINVAL;
+       if (!sd)
+               return -ENODEV;
+       if (!ctrl)
+               return ret;
+
+       switch (ctrl->id) {
+       case V4L2_CID_GAIN:
+               ret = s5k4e1_t_gain(sd, ctrl->value);
+               break;
+       case V4L2_CID_EXPOSURE:
+               ret = s5k4e1_t_exposure(sd, ctrl->value);
+               break;
+       default:
+               dprintk(1, "unsupported ctrl id");
+               break;
+       }
+       return ret;
+}
+
+static int s5k4e1_s_stream(struct v4l2_subdev *sd, int enable)
+{
+       struct i2c_client *client = v4l2_get_subdevdata(sd);
+
+       if (enable)
+               s5k4e1_write(client, (u32)0x0100, 0x01);
+       else
+               s5k4e1_write(client, (u32)0x0100, 0x00);
+
+       return 0;
+}
+
+static int s5k4e1_enum_framesizes(struct v4l2_subdev *sd,
+                                 struct v4l2_frmsizeenum *fsize)
+{
+       unsigned int index = fsize->index;
+
+       if (index >= N_RES)
+               return -EINVAL;
+
+       fsize->type = V4L2_FRMSIZE_TYPE_DISCRETE;
+       fsize->discrete.width = s5k4e1_res[index].width;
+       fsize->discrete.height = s5k4e1_res[index].height;
+       fsize->reserved[0] = s5k4e1_res[index].used;
+
+       return 0;
+}
+
+static int s5k4e1_enum_frameintervals(struct v4l2_subdev *sd,
+                                     struct v4l2_frmivalenum *fival)
+{
+       unsigned int index = fival->index;
+
+       if (index >= N_RES)
+               return -EINVAL;
+
+       fival->type = V4L2_FRMIVAL_TYPE_DISCRETE;
+       fival->discrete.numerator = 1;
+       fival->discrete.denominator = s5k4e1_res[index].fps;
+       return 0;
+}
+
+static int s5k4e1_g_chip_ident(struct v4l2_subdev *sd,
+               struct v4l2_dbg_chip_ident *chip)
+{
+       struct i2c_client *client = v4l2_get_subdevdata(sd);
+
+       #define V4L2_IDENT_S5K4E1 8250
+       return v4l2_chip_ident_i2c_client(client, chip, V4L2_IDENT_S5K4E1, 0);
+}
+
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+static int s5k4e1_g_register(struct v4l2_subdev *sd,
+                            struct v4l2_dbg_register *reg)
+{
+       struct i2c_client *client = v4l2_get_subdevdata(sd);
+       unsigned char val = 0;
+       int ret;
+
+       if (!v4l2_chip_match_i2c_client(client, &reg->match))
+               return -EINVAL;
+       if (!capable(CAP_SYS_ADMIN))
+               return -EPERM;
+       ret = s5k4e1_read(client, reg->reg & 0xffff, &val);
+       reg->val = val;
+       reg->size = 1;
+       return ret;
+}
+
+static int s5k4e1_s_register(struct v4l2_subdev *sd,
+                            struct v4l2_dbg_register *reg)
+{
+       struct i2c_client *client = v4l2_get_subdevdata(sd);
+
+       if (!v4l2_chip_match_i2c_client(client, &reg->match))
+               return -EINVAL;
+       if (!capable(CAP_SYS_ADMIN))
+               return -EPERM;
+       s5k4e1_write(client, reg->reg & 0xffff, reg->val & 0xff);
+       return 0;
+}
+#endif
+
+static const struct v4l2_subdev_video_ops s5k4e1_video_ops = {
+       .try_mbus_fmt = s5k4e1_try_fmt,
+       .s_mbus_fmt = s5k4e1_set_fmt,
+       .g_mbus_fmt = s5k4e1_get_fmt,
+       .s_stream = s5k4e1_s_stream,
+       .enum_framesizes = s5k4e1_enum_framesizes,
+       .enum_frameintervals = s5k4e1_enum_frameintervals,
+};
+
+static const struct v4l2_subdev_core_ops s5k4e1_core_ops = {
+       .g_chip_ident = s5k4e1_g_chip_ident,
+       .queryctrl = s5k4e1_queryctrl,
+       .g_ctrl = s5k4e1_g_ctrl,
+       .s_ctrl = s5k4e1_s_ctrl,
+       #ifdef CONFIG_VIDEO_ADV_DEBUG
+       .g_register = s5k4e1_g_register,
+       .s_register = s5k4e1_s_register,
+       #endif
+};
+
+static const struct v4l2_subdev_ops s5k4e1_ops = {
+       .core = &s5k4e1_core_ops,
+       .video = &s5k4e1_video_ops,
+};
+
+static int s5k4e1_detect(struct i2c_client *client)
+{
+       struct i2c_adapter *adapter = client->adapter;
+       int adap_id = i2c_adapter_id(adapter);
+       u32 value;
+
+       if (!i2c_check_functionality(adapter, I2C_FUNC_I2C)) {
+               eprintk("error i2c check func");
+               return -ENODEV;
+       }
+
+       if (adap_id != 1)
+               return -ENODEV;
+
+       s5k4e1_read(client, 0x0003, &value);
+       if ((value != 0x09))
+               return -ENODEV;
+
+       s5k4e1_read(client, 0x0000, &value);
+       if ((value != 0x4e) && (value != 0x10))
+               return -ENODEV;
+
+       s5k4e1_read(client, 0x0001, &value);
+       if ((value != 0x4e) && (value != 0x10))
+               return -ENODEV;
+
+       s5k4e1_read(client, 0x0002, &value);
+       dprintk(1, "Read from 0x0002: %x", value);
+       if (value == 0x0010)
+               return -ENODEV;
+       return 0;
+}
+
+static int s5k4e1_probe(struct i2c_client *client,
+                       const struct i2c_device_id *id)
+{
+       struct ci_sensor_config *info;
+       struct v4l2_subdev *sd;
+       int ret = -1;
+
+       v4l_info(client, "chip found @ 0x%x (%s)\n",
+                client->addr << 1, client->adapter->name);
+
+       /*
+        * Setup sensor configuration structure
+        */
+       info = kzalloc(sizeof(struct ci_sensor_config), GFP_KERNEL);
+       if (!info) {
+               dprintk(0, "fail to malloc for ci_sensor_config");
+               ret = -ENOMEM;
+               goto out;
+       }
+
+       ret = s5k4e1_detect(client);
+       if (ret) {
+               dprintk(0, "error s5k4e1_detect");
+               goto out_free;
+       }
+
+       sd = &info->sd;
+       v4l2_i2c_subdev_init(sd, client, &s5k4e1_ops);
+
+       /*
+        * Initialization S5K4E1
+        */
+       ret = s5k4e1_init(client);
+       if (ret) {
+               dprintk(0, "error calling s5k4e1_init");
+               goto out_free;
+       }
+
+       dprintk(0, "Init s5k4e1 sensor successfully");
+       ret = 0;
+       goto out;
+
+out_free:
+       kfree(info);
+out:
+       return ret;
+}
+
+
+static int s5k4e1_remove(struct i2c_client *client)
+{
+       struct v4l2_subdev *sd = i2c_get_clientdata(client);
+
+       v4l2_device_unregister_subdev(sd);
+       kfree(to_sensor_config(sd));
+       return 0;
+}
+
+static const struct i2c_device_id s5k4e1_id[] = {
+       {"s5k4e1", 0},
+       {}
+};
+
+MODULE_DEVICE_TABLE(i2c, s5k4e1_id);
+
+static struct i2c_driver s5k4e1_i2c_driver = {
+       .driver = {
+               .name = "s5k4e1",
+       },
+       .probe = s5k4e1_probe,
+       .remove = s5k4e1_remove,
+       .id_table = s5k4e1_id,
+};
+
+static int __init s5k4e1_drv_init(void)
+{
+       return i2c_add_driver(&s5k4e1_i2c_driver);
+}
+
+static void __exit s5k4e1_drv_cleanup(void)
+{
+       i2c_del_driver(&s5k4e1_i2c_driver);
+}
+
+module_init(s5k4e1_drv_init);
+module_exit(s5k4e1_drv_cleanup);
+
+MODULE_AUTHOR("Xiaolin Zhang <xiaolin.zhang@intel.com>");
+MODULE_DESCRIPTION("A low-level driver for Samsung S5K4E1 sensors");
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/video/s5k4e1.h b/drivers/media/video/s5k4e1.h
new file mode 100644
index 0000000..092ea70
--- /dev/null
+++ b/drivers/media/video/s5k4e1.h
@@ -0,0 +1,573 @@
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
+#define I2C_S5K4E1     0x6C
+#define I2C_DRIVERID_S5K4E1    1046
+#define GPIO_SCLK_25   44
+#define GPIO_STB_PIN   47
+#define GPIO_STDBY_PIN 49
+#define GPIO_RESET_PIN 50
+
+struct regval_list {
+       u16 reg_num;
+       u8 value;
+};
+
+static const struct regval_list s5k4e1_res_qsxga_plus4[] = {
+       {0x0100, 0x00},
+       {0x0103, 0x01},
+       {0x3000, 0x04}, /* ct_ld_start (default = 07h) */
+       {0x3001, 0x02}, /* ct_sl_start (default = 05h) */
+       {0x3002, 0x0C}, /* ct_rx_start (default = 21h) */
+       {0x3003, 0x0E}, /* ct_cds_start (default = 23h) */
+       {0x3004, 0x2C}, /* ct_smp_width (default = 60h) */
+       {0x3005, 0x0D}, /* ct_az_width (default = 28h) */
+       {0x3006, 0x39}, /* ct_s1r_width (default = 88h) */
+       {0x3007, 0x02}, /* ct_tx_start (default = 06h) */
+       {0x3008, 0x3C}, /* ct_tx_width 1.5us (default = 7Ch) */
+       {0x3009, 0x3C}, /* ct_stx_width 1.5us (default = 7Ch) */
+       {0x300A, 0x28}, /* ct_dtx_width 1us (default = 3Eh) */
+       {0x300B, 0x15}, /* ct_rmp_rst_start (default = 44h) */
+       {0x300C, 0x15}, /* ct_rmp_sig_start (default = 48h) */
+       {0x300D, 0x02}, /* ct_rmp_lat (default = 02h) */
+       {0x300E, 0xA9}, /* D-Shut en[7], CLP On[5], LD high[4] */
+
+       {0x3010, 0x00}, /* smp_en[2]=0(00) 1(04) row_id[1:0] = 00 */
+       {0x3011, 0x7A}, /* RST_MX (288), SIG_MX (1024+352) */
+       {0x3012, 0x30}, /* SIG offset1  48 code  */
+       {0x3013, 0xA0}, /* RST offset1  160 code */
+       {0x3014, 0x00}, /* SIG offset2 */
+       {0x3015, 0x00}, /* RST offset2 */
+       {0x3016, 0x02}, /* ADC_SAT (510mV) */
+       {0x3017, 0x94}, /* RMP_INIT[3:0](RMP_REG) 1.8V MS[6:4]=1 */
+       {0x3018, 0x78}, /* rmp option - ramp connect[MSB] +RMP INIT DAC MIN */
+       {0x301D, 0xD4}, /* CLP level (default = 0Fh) */
+
+       {0x3021, 0x02}, /* inrush ctrl[1] off */
+       {0x3022, 0x44}, /* pump ring oscillator set [7:4]=CP, [3:0]=NCP  */
+       {0x3024, 0x40}, /* pix voltage 2.8V   (default = 88h) */
+       {0x3027, 0x08}, /* ntg voltage (default = 04h) */
+
+       {0x301C, 0x05}, /* Pixel Bias [3:0] (default = 03h) */
+       {0x30D8, 0x3F}, /* All tx off 2f, on 3f */
+
+       {0x3070, 0x5F}, /* [6]L-ADLC BPR, [4]ch sel, [3]L-ADLC, [2]F-ADLC */
+       {0x3071, 0x00}, /* F&L-adlc max 127 (default = 11h, max 255) */
+       {0x3080, 0x04}, /* F-ADLC filter A (default = 10h) */
+       {0x3081, 0x38}, /* F-ADLC filter B (default = 20h) */
+
+       {0x0202, 0x03}, /* coarse integration time */
+       {0x0203, 0xCF},
+       {0x0204, 0x00}, /* analog gain[msb] 0100 x8 0080 x4 */
+       {0x0205, 0x80}, /* analog gain[lsb] 0040 x2 0020 x1 */
+
+       {0x0340, 0x07}, /* Capture 07B4(1960[# of row]+12[V-blank]) */
+       {0x0341, 0xA4}, /* Preview 03E0(980[# of row]+12[V-blank]) */
+
+       {0x0342, 0x0A}, /* 2738 */
+       {0x0343, 0xB2}, /* (Same as sensor default) */
+
+       {0x3084, 0x15}, /* SYNC Mode */
+
+
+       {0x30A9, 0x01},
+       {0x0387, 0x01},
+
+       {0x30BD, 0x00},         /* SEL_CCP[0] */
+       {0x30B2, 0x08},         /* PLL P = 8 */
+       {0x30B3, 0x00},         /* PLL M[8] = 0 */
+       {0x30B5, 0x01},         /* PLL S = 0 */
+       {0x30BE, 0x1A},         /* M_PCLKDIV_AUTO[4], M_DIV_PCLK[3:0] */
+
+       {0x30BF, 0xAB},
+       {0x30C0, 0x00},         /* video_offset[7:4] 3240%12 */
+       {0x30C1, 0x01},         /* pack video enable [0] */
+       {0x30C8, 0x0C},         /* video_data_length 3260 = 2608 * 1.25 */
+       {0x30C9, 0xA8},
+       {0x30E2, 0x02},         /* num lanes[1:0] = 2 */
+       {0x30EE, 0x02},         /* DPHY enable [1] */
+       {0x30F1, 0x70},         /* DPHY BANDCTRL 800MHz=80.6MHz */
+       {0x3111, 0x86},         /* Embedded data off [5] */
+
+       {0x034C, 0x0A},
+       {0x034D, 0x20},
+       {0x044E, 0x07},
+       {0x034F, 0x98},
+
+       {0x0344, 0x00},
+       {0x0345, 0x08},
+       {0x0346, 0x00},
+       {0x0347, 0x08},
+       {0x0348, 0x0A},
+       {0x0349, 0x27},
+       {0x034A, 0x07},
+       {0x034B, 0x9F},
+
+       {0x30d9, 0x00},
+
+       {0x0305, 0x05},
+       {0x0306, 0x00},
+       {0x0307, 0x3c},
+       {0x30b5, 0x02},
+
+       {0x020E, 0x01},      /* Gr Digital Gain */
+       {0x020F, 0x00},
+       {0x0210, 0x01},     /* Red Digital Gain */
+       {0x0211, 0x00},
+       {0x0212, 0x01},     /* Blue Digital Gain */
+       {0x0213, 0x00},
+       {0x0214, 0x01},    /* Gb Digital Gain */
+       {0x0215, 0x00},
+       {0x0204, 0x00},
+       {0x0205, 0x80},
+
+       {0x30E2, 0x02},
+       {0x0305, 0x05},
+       {0x0306, 0x00},
+       {0x0307, 0x50},         /* vcc_out = 80 */
+       {0x30B5, 0x01},         /* pll_s = 1 */
+       {0x30B4, 0x50},
+
+       {0x30B2, 0x05},
+
+       {0x30BE, 0x1A},         /* DIV_M_PCLK = 5 */
+
+       {0x0100, 0x01},
+       {0xffff, 0xff},
+};
+
+static const struct regval_list s5k4e1_res_1080p[] = {
+       {0x0100, 0x00},         /* stream off */
+       {0x0103, 0x01},         /* software reset */
+
+       {0x3000, 0x04}, /* ct_ld_start (default = 07h) */
+       {0x3001, 0x02}, /* ct_sl_start (default = 05h) */
+       {0x3002, 0x0C}, /* ct_rx_start (default = 21h) */
+       {0x3003, 0x0E}, /* ct_cds_start (default = 23h) */
+       {0x3004, 0x2C}, /* ct_smp_width (default = 60h) */
+       {0x3005, 0x0D}, /* ct_az_width (default = 28h) */
+       {0x3006, 0x39}, /* ct_s1r_width (default = 88h) */
+       {0x3007, 0x02}, /* ct_tx_start (default = 06h) */
+       {0x3008, 0x3C}, /* ct_tx_width 1.5us (default = 7Ch) */
+       {0x300A, 0x28}, /* ct_dtx_width 1us (default = 3Eh) */
+       {0x300B, 0x15}, /* ct_rmp_rst_start (default = 44h) */
+       {0x300C, 0x15}, /* ct_rmp_sig_start (default = 48h) */
+       {0x300D, 0x02}, /* ct_rmp_lat (default = 02h) */
+       {0x300E, 0xA9}, /* D-Shut en[7], CLP On[5], LD high[4] */
+
+       {0x3010, 0x00}, /* smp_en[2]=0(00) 1(04) row_id[1:0] = 00 */
+       {0x3011, 0x7A}, /* RST_MX (288), SIG_MX (1024+352) */
+       {0x3012, 0x30}, /* SIG offset1  48 code */
+       {0x3013, 0xA0}, /* RST offset1  160 code */
+       {0x3014, 0x00}, /* SIG offset2 */
+       {0x3015, 0x00}, /* RST offset2 */
+       {0x3016, 0x0A}, /* ADC_SAT (510mV) */
+       {0x3017, 0x94}, /* RMP_INIT[3:0](RMP_REG) 1.8V MS[6:4]=1 */
+       {0x3018, 0x78}, /* rmp option - ramp connect[MSB] +RMP INIT DAC MIN */
+
+       {0x301D, 0xD4}, /* CLP level (default = 0Fh) */
+
+       {0x3021, 0x02}, /* inrush ctrl[1] off */
+       {0x3022, 0x41}, /* pump ring oscillator set [7:4]=CP, [3:0]=NCP */
+       {0x3024, 0x08}, /* pix voltage 2.8V   (default = 88h) */
+       {0x3027, 0x08}, /* ntg voltage (default = 04h) */
+
+       {0x301C, 0x05}, /* Pixel Bias [3:0] (default = 03h) */
+       {0x30D8, 0x3F}, /* All tx off 2f, on 3f */
+
+       {0x3070, 0x5F}, /* [6]L-ADLC BPR, [4]ch sel, [3]L-ADLC, [2]F-ADLC */
+       {0x3071, 0x00}, /* F&L-adlc max 127 (default = 11h, max 255) */
+       {0x3080, 0x04}, /* F-ADLC filter A (default = 10h) */
+       {0x3081, 0x38}, /* F-ADLC filter B (default = 20h) */
+
+       {0x0202, 0x03}, /* coarse integration time */
+       {0x0203, 0xCD},
+       {0x0204, 0x00}, /* analog gain[msb] 0100 x8 0080 x4 */
+       {0x0205, 0x80}, /* analog gain[lsb] 0040 x2 0020 x1 */
+
+       {0x0340, 0x04}, /*Capture 07B4(1960[# of row]+12[V-blank]) */
+       {0x0341, 0x44}, /*Preview 03E0(980[# of row]+12[V-blank]) */
+
+       {0x0342, 0x0A}, /* 2738 */
+       {0x0343, 0xB2}, /*(Same as sensor default) */
+
+       {0x3084, 0x15}, /* SYNC Mode */
+
+       {0x30BD, 0x00},         /* SEL_CCP[0] */
+       {0x30B2, 0x08},         /* PLL P = 8 */
+       {0x30B3, 0x00},         /* PLL M[8] = 0 */
+       {0x30B4, 0x78},         /* PLL M = 129 */
+       {0x30B5, 0x00},         /* PLL S = 0 */
+       {0x30BE, 0x1A},         /* M_PCLKDIV_AUTO[4], M_DIV_PCLK[3:0] */
+
+       {0x30BF, 0xAB},
+       {0x30C0, 0x00},         /* video_offset[7:4] 2400%12 */
+       {0x30C1, 0x01},         /* pack video enable [0] */
+       {0x30C8, 0x09},         /* video_data_length 2400 = 1920 * 1.25 */
+       {0x30C9, 0x60},
+       {0x30E2, 0x02},         /* num lanes[1:0] = 2 */
+       {0x30EE, 0x02},         /* DPHY enable [1] */
+       {0x30F1, 0x70},         /* DPHY BANDCTRL 800MHz=80.6MHz */
+       {0x3111, 0x86},         /* Embedded data off [5] */
+
+       {0x30b4, 0x20},
+       {0x30b5, 0x01},
+
+       {0x30A9, 0x01},
+       {0x0387, 0x01},
+       {0x0344, 0x01}, /*x_addr_start 344 */
+       {0x0345, 0x58},
+       {0x0348, 0x08}, /*x_addr_end 2263 */
+       {0x0349, 0xD7},
+       {0x0346, 0x01}, /*y_addr_start 440 */
+       {0x0347, 0xB8},
+       {0x034A, 0x05}, /*y_addr_end 1519 */
+       {0x034B, 0xEF},
+
+       {0x034C, 0x07}, /*x_output_size 1920 */
+       {0x034D, 0x80},
+       {0x034E, 0x04}, /*y_output_size 1080 */
+       {0x034F, 0x38},
+
+       {0x30d9, 0x00},
+
+       {0x020E, 0x01},      /*Gr Digital Gain */
+       {0x020F, 0x00},
+       {0x0210, 0x01},     /*Red Digital Gain */
+       {0x0211, 0x00},
+       {0x0212, 0x01},     /*Blue Digital Gain */
+       {0x0213, 0x00},
+       {0x0214, 0x01},    /*Gb Digital Gain */
+       {0x0215, 0x00},
+       {0x0204, 0x00},
+       {0x0205, 0x80},
+
+       {0x30E2, 0x02},
+       {0x0305, 0x05},
+       {0x0306, 0x00},
+       {0x0307, 0x50},         /*vcc_out = 80 */
+       {0x30B5, 0x01},         /*pll_s = 1 */
+       {0x30B4, 0x50},
+
+       {0x30B2, 0x05},
+       {0x30BE, 0x1A},         /*DIV_M_PCLK = 5 */
+       {0x0383, 0x01},
+       {0x0100, 0x01},         /* stream on */
+       {0xffff, 0xff},
+
+};
+
+static const struct regval_list s5k4e1_res_720p[] = {
+       {0x0100, 0x00},         /* stream off */
+       {0x0103, 0x01},         /* software reset */
+
+       {0x3000, 0x04},
+       {0x3001, 0x02},
+       {0x3002, 0x0C},
+       {0x3003, 0x0E},
+       {0x3004, 0x2C},
+       {0x3005, 0x0D},
+       {0x3006, 0x39},
+       {0x3007, 0x02},
+       {0x3008, 0x3C},
+       {0x3009, 0x3C},
+       {0x300A, 0x28},
+       {0x300B, 0x15},
+       {0x300C, 0x15},
+       {0x300D, 0x02},
+       {0x300E, 0xAB},
+
+       {0x3010, 0x00},
+       {0x3011, 0x7A},
+       {0x3012, 0x30},
+       {0x3013, 0x90},
+       {0x3014, 0x00},
+       {0x3015, 0x00},
+       {0x3016, 0x0A},
+       {0x3017, 0x84},
+       {0x3018, 0x78},
+       {0x301D, 0xD4},
+
+       {0x3021, 0x02},
+       {0x3022, 0x41},
+       {0x3024, 0x08},
+       {0x3027, 0x08},
+
+       {0x301C, 0x05}, /* Pixel Bias [3:0] (default = 03h) */
+       {0x30D8, 0x3F}, /* All tx off 2f, on 3f */
+
+       {0x3070, 0x5F},
+       {0x3071, 0x00},
+       {0x3080, 0x04},
+       {0x3081, 0x38},
+
+       {0x0202, 0x03},
+       {0x0203, 0xD8},
+       {0x0204, 0x00},
+       {0x0205, 0x80},
+
+       {0x0340, 0x02},
+       {0x0341, 0xDC},
+
+       {0x0342, 0x0A}, /*2738 */
+       {0x0343, 0xB2},
+
+       {0x0387, 0x03},
+       {0x30a9, 0x02},
+       {0x3084, 0x15},
+
+       {0x30BD, 0x00},
+       {0x30B2, 0x08},
+       {0x30B3, 0x00},
+       {0x30B4, 0x78},
+       {0x30B5, 0x00},
+       {0x30BE, 0x1A},
+
+       {0x30BF, 0xAB},
+       {0x30C0, 0x40},
+       {0x30C1, 0x01},
+       {0x30C8, 0x06},
+       {0x30C9, 0x40},
+
+       {0x30E2, 0x02},
+
+       {0x30b4, 0x20},
+       {0x30b5, 0x01},
+
+       {0x30EE, 0x02},
+       {0x30F1, 0x70},
+       {0x3111, 0x86},
+
+       {0x0344, 0x00},
+       {0x0345, 0x18},
+       {0x0348, 0x0A},
+       {0x0349, 0x17},
+       {0x0346, 0x01},
+       {0x0347, 0x04},
+       {0x034A, 0x06},
+       {0x034B, 0xA3},
+
+       {0x0380, 0x00},
+       {0x0381, 0x01},
+       {0x0382, 0x00},
+       {0x0383, 0x01},
+       {0x0384, 0x00},
+       {0x0385, 0x01},
+       {0x0386, 0x00},
+       {0x0387, 0x03},
+
+       {0x034C, 0x05}, /* x_output_size = 1280 */
+       {0x034D, 0x00},
+       {0x034E, 0x02}, /* y_output_size = 720 */
+       {0x034F, 0xD0},
+
+       {0x30d9, 0x00},
+
+       {0x020E, 0x01},
+       {0x020F, 0x00},
+       {0x0210, 0x01},
+       {0x0211, 0x00},
+       {0x0212, 0x01},
+       {0x0213, 0x00},
+       {0x0214, 0x01},
+       {0x0215, 0x00},
+       {0x0204, 0x01},
+       {0x0205, 0x00},
+
+       {0x30E2, 0x02},
+       {0x0305, 0x05},
+       {0x0306, 0x00},
+       {0x0307, 0x50},         /*vcc_out = 80 */
+       {0x30B5, 0x01},         /*pll_s = 1 */
+       {0x30B4, 0x50},
+
+       {0x30B2, 0x05},
+
+       {0x30BE, 0x15},         /*DIV_M_PCLK = 5 */
+
+       {0x0100, 0x01},         /* stream on */
+       {0xffff, 0xff},
+};
+
+/*VGA*/
+static const struct regval_list s5k4e1_res_vga_ac04_bill[] = {
+       {0x0100, 0x00},
+       {0x0103, 0x01},
+
+       {0x3000, 0x04},
+       {0x3001, 0x02},
+       {0x3002, 0x0C},
+       {0x3003, 0x0E},
+       {0x3004, 0x2C},
+       {0x3005, 0x0D},
+       {0x3006, 0x39},
+       {0x3007, 0x02},
+       {0x3008, 0x3C},
+       {0x3009, 0x3C},
+       {0x300A, 0x28},
+       {0x300B, 0x15},
+       {0x300C, 0x15},
+       {0x300D, 0x02},
+       {0x300E, 0xA8},
+
+       {0x3010, 0x00},
+       {0x3011, 0x7A},
+       {0x3012, 0x30},
+       {0x3013, 0xA0},
+       {0x3014, 0x00},
+       {0x3015, 0x00},
+       {0x3016, 0x0A},
+       {0x3017, 0x94},
+       {0x3018, 0x78},
+
+       {0x301D, 0xD4},
+
+       {0x3021, 0x02},
+       {0x3022, 0x41},
+       {0x3024, 0x08},
+       {0x3027, 0x08},
+
+       {0x301C, 0x05},
+       {0x30D8, 0x3F},
+
+       {0x3070, 0x5F},
+       {0x3071, 0x00},
+       {0x3080, 0x04},
+       {0x3081, 0x38},
+
+       {0x0202, 0x03},
+       {0x0203, 0xD4},
+       {0x0204, 0x00},
+       {0x0205, 0x20},
+
+       {0x0340, 0x03},
+       {0x0341, 0xE0},
+
+       {0x0342, 0x0A},
+       {0x0343, 0xB2},
+
+       {0x0344, 0x00},
+       {0x0345, 0x18},
+       {0x0348, 0x0A},
+       {0x0349, 0x17},
+       {0x0346, 0x00},
+       {0x0347, 0x14},
+       {0x034A, 0x07},
+       {0x034B, 0x93},
+
+       {0x034C, 0x02},
+       {0x034D, 0x80},
+       {0x034E, 0x01},
+       {0x034F, 0xE0},
+
+       {0x0380, 0x00},
+       {0x0381, 0x01},
+       {0x0382, 0x00},
+       {0x0383, 0x07},
+       {0x0384, 0x00},
+       {0x0385, 0x01},
+       {0x0386, 0x00},
+       {0x0387, 0x07},
+
+       {0x3084, 0x15},
+
+       {0x30BD, 0x00},
+
+       {0x30b3, 0x00},
+       {0x30b4, 0x57},
+       {0x30b5, 0x01},
+       {0x30f1, 0x70},
+
+       {0x30BE, 0x1A},
+
+       {0x30BF, 0xAB},
+       {0x30C0, 0x80},
+       {0x30C1, 0x01},
+       {0x30C8, 0x03},
+       {0x30C9, 0x20},
+
+       {0x30b2, 0x06},
+       {0x30E2, 0x02},
+
+       {0x30EE, 0x02},
+
+       {0x3111, 0x86},
+
+       {0x30d9, 0x00},
+
+       {0x020E, 0x01},
+       {0x020F, 0x00},
+       {0x0210, 0x01},
+       {0x0211, 0x00},
+       {0x0212, 0x01},
+       {0x0213, 0x00},
+       {0x0214, 0x01},
+       {0x0215, 0x00},
+       {0x0204, 0x01},
+       {0x0205, 0x00},
+
+       {0x30E2, 0x02},
+       {0x0305, 0x05},
+       {0x0306, 0x00},
+       {0x0307, 0x50},
+       {0x30B5, 0x01},
+       {0x30B4, 0x50},
+
+       {0x30B2, 0x05},
+       {0x30BE, 0x15},
+
+       /* 1304x980 */
+       {0x3013, 0x90},
+       {0x3017, 0x84},
+       {0x30A9, 0x02},
+       {0x300E, 0xAB},
+
+       {0x0387, 0x03},
+       {0x0344, 0x00}, /* x_addr_start = 0 */
+       {0x0345, 0x00},
+       {0x0348, 0x0A}, /* x_addr_end = 2607 */
+       {0x0349, 0x2F},
+       {0x0346, 0x00}, /* y_addr_start = 0 */
+       {0x0347, 0x00},
+       {0x034A, 0x07}, /* y_addr_end = 1959 */
+       {0x034B, 0xA7},
+       {0x0380, 0x00},
+       {0x0381, 0x01},
+       {0x0382, 0x00},
+       {0x0383, 0x01},
+       {0x0384, 0x00},
+       {0x0385, 0x01},
+       {0x0386, 0x00},
+       {0x0387, 0x03},
+       {0x034c, 0x05}, /* x_output_size = 1304 */
+       {0x034d, 0x18},
+       {0x034e, 0x03}, /* y_output_size = 980 */
+       {0x034f, 0xd4},
+       {0x30BF, 0xAB},
+       {0x30c0, 0xa0},
+       {0x30C8, 0x06}, /* x_output_size * 1.25 */
+       {0x30c9, 0x5e},
+
+       {0x0100, 0x01},
+       {0xffff, 0xff},
+};
--
1.6.3.2

