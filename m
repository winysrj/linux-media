Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:57647 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755701Ab0ERJXM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 May 2010 05:23:12 -0400
From: "Zhang, Xiaolin" <xiaolin.zhang@intel.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Tue, 18 May 2010 17:22:58 +0800
Subject: [PATCH v3 3/8] V4L2 subdev patchset for Intel Moorestown Camera
 Imaging Subsystem
Message-ID: <33AB447FBD802F4E932063B962385B351E89572F@shsmsx501.ccr.corp.intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>From 77c6856881ae269e1d3a58be3581d9f131037010 Mon Sep 17 00:00:00 2001
From: Xiaolin Zhang <xiaolin.zhang@intel.com>
Date: Tue, 18 May 2010 15:22:59 +0800
Subject: [PATCH 3/8] This patch is to add 5MP raw camera (ov5630) support which is based
 on the video4linux2 sub-dev driver framework.

Signed-off-by: Xiaolin Zhang <xiaolin.zhang@intel.com>
---
 drivers/media/video/ov5630.c |  734 ++++++++++++++++++++++++++++++++++++++++++
 drivers/media/video/ov5630.h |  635 ++++++++++++++++++++++++++++++++++++
 2 files changed, 1369 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/ov5630.c
 create mode 100644 drivers/media/video/ov5630.h

diff --git a/drivers/media/video/ov5630.c b/drivers/media/video/ov5630.c
new file mode 100644
index 0000000..c4be115
--- /dev/null
+++ b/drivers/media/video/ov5630.c
@@ -0,0 +1,734 @@
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
+#include <linux/i2c.h>
+#include <linux/gpio.h>
+#include <linux/delay.h>
+#include <linux/videodev2.h>
+#include <linux/slab.h>
+#include <media/v4l2-device.h>
+
+#include "mrst_sensor_common.h"
+#include "ov5630.h"
+
+static int ov5630_debug;
+module_param(ov5630_debug, int, 0644);
+MODULE_PARM_DESC(ov5630_debug, "Debug level (0-1)");
+
+#define dprintk(level, fmt, arg...) do {                       \
+       if (ov5630_debug >= level)                                      \
+               printk(KERN_DEBUG "%s: " fmt "\n",      \
+                      __func__, ## arg); } \
+       while (0)
+
+#define eprintk(fmt, arg...)   \
+       printk(KERN_ERR "%s: line %d: " fmt "\n",       \
+              __func__, __LINE__, ## arg);
+
+static inline struct ci_sensor_config *to_sensor_config(struct v4l2_subdev *sd)
+{
+       return container_of(sd, struct ci_sensor_config, sd);
+}
+
+static struct ov5630_res_struct {
+       __u8 *desc;
+       int res;
+       int width;
+       int height;
+       int fps;
+       bool used;
+       const struct regval_list *regs;
+} ov5630_res[] = {
+       {
+               .desc           = "QSXGA_PLUS4",
+               .res            = SENSOR_RES_QXGA_PLUS,
+               .width          = 2592,
+               .height         = 1944,
+               .fps            = 15,
+               .used           = 0,
+               .regs           = ov5630_res_qsxga_plus4,
+       },
+       {
+               .desc           = "1080P",
+               .res            = SENSOR_RES_1080P,
+               .width          = 1920,
+               .height         = 1080,
+               .fps            = 25,
+               .used           = 0,
+               .regs           = ov5630_res_1080p,
+       },
+       {
+               .desc           = "XGA_PLUS",
+               .res            = SENSOR_RES_XGA_PLUS,
+               .width          = 1280,
+               .height         = 960,
+               .fps            = 30,
+               .used           = 0,
+               .regs           = ov5630_res_xga_plus,
+       },
+       {
+               .desc           = "720p",
+               .res            = SENSOR_RES_720P,
+               .width          = 1280,
+               .height         = 720,
+               .fps            = 34,
+               .used           = 0,
+               .regs           = ov5630_res_720p,
+       },
+       {
+               .desc           = "VGA",
+               .res            = SENSOR_RES_VGA,
+               .width          = 640,
+               .height         = 480,
+               .fps            = 39,
+               .used           = 0,
+               .regs           = ov5630_res_vga_ac04_bill,
+       },
+};
+
+#define N_RES (ARRAY_SIZE(ov5630_res))
+
+/*
+ * I2C Read & Write stuff
+ */
+static int ov5630_read(struct i2c_client *c, u32 reg, u32 *value)
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
+       return ret;
+}
+
+static int ov5630_write(struct i2c_client *c, u32 reg, u32 value)
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
+       if (reg == OV5630_SYS && (value & 0x80))
+               msleep(3);
+
+       ret = (ret == 1) ? 0 : -1;
+       return ret;
+}
+
+static int ov5630_write_array(struct i2c_client *c,
+                                       const struct regval_list *vals)
+{
+       const struct regval_list *p;
+       u32 read_val = 0;
+       int err_num = 0;
+       int i = 0;
+       p = vals;
+       while (p->reg_num != 0xffff) {
+               ov5630_write(c, (u32)p->reg_num, (u32)p->value);
+               ov5630_read(c, (u32)p->reg_num, &read_val);
+               if (read_val != p->value)
+                       err_num++;
+               p++;
+               i++;
+       }
+       return 0;
+}
+
+static int ov5630_set_img_ctrl(struct i2c_client *c,
+                              const struct ci_sensor_config *config)
+{
+       int err = 0;
+       u32 reg_val = 0;
+
+       switch (config->blc) {
+       case SENSOR_BLC_OFF:
+               err |= ov5630_read(c, OV5630_ISP_CTL00, &reg_val);
+               err |= ov5630_write(c, OV5630_ISP_CTL00, reg_val & 0xFE);
+               break;
+       case SENSOR_BLC_AUTO:
+               err |= ov5630_read(c, OV5630_ISP_CTL00, &reg_val);
+               err |= ov5630_write(c, OV5630_ISP_CTL00, reg_val | 0x01);
+               break;
+       }
+
+       switch (config->agc) {
+       case SENSOR_AGC_AUTO:
+               err |= ov5630_read(c, OV5630_AUTO_1, &reg_val);
+               err |= ov5630_write(c, OV5630_AUTO_1, reg_val | 0x04);
+               break;
+       case SENSOR_AGC_OFF:
+               err |= ov5630_read(c, OV5630_AUTO_1, &reg_val);
+               err |= ov5630_write(c, OV5630_AUTO_1, reg_val & ~0x04);
+               break;
+       }
+
+       switch (config->awb) {
+       case SENSOR_AWB_AUTO:
+               err |= ov5630_read(c, OV5630_ISP_CTL00, &reg_val);
+               err |= ov5630_write(c, OV5630_ISP_CTL00, reg_val | 0x30);
+               break;
+       case SENSOR_AWB_OFF:
+               err |= ov5630_read(c, OV5630_ISP_CTL00, &reg_val);
+               err |= ov5630_write(c, OV5630_ISP_CTL00, reg_val & ~0x30);
+               break;
+       }
+
+       switch (config->aec) {
+       case SENSOR_AEC_AUTO:
+               err |= ov5630_read(c, OV5630_AUTO_1, &reg_val);
+               err |= ov5630_write(c, OV5630_AUTO_1, reg_val | 0xFB);
+               break;
+       case SENSOR_AEC_OFF:
+               err |= ov5630_read(c, OV5630_AUTO_1, &reg_val);
+               err |= ov5630_write(c, OV5630_AUTO_1, reg_val & 0xF6);
+               break;
+       }
+
+       return err;
+}
+
+static int ov5630_init(struct i2c_client *c)
+{
+       int ret;
+
+       ret = ov5630_write(c, (u32)OV5630_SYS, (u32)0x80);
+       ret += ov5630_write(c, (u32)OV5630_IMAGE_SYSTEM, (u32)0x00);
+       ret += ov5630_write_array(c, ov5630_def_reg);
+
+       #ifdef OV5630_MIPI
+       ret += ov5630_write_array(c, ov5630_mipi);
+       #endif
+
+       ov5630_write(c, (u32)OV5630_IMAGE_SYSTEM, (u32)0x00);
+       ov5630_write(c, 0x30b0, 0x00);
+       ov5630_write(c, 0x30b1, 0x00);
+       return ret;
+}
+
+static int distance(struct ov5630_res_struct *res, u32 w, u32 h)
+{
+       int ret;
+       if (res->width < w || res->height < h)
+               return -1;
+
+       ret = ((res->width - w) + (res->height - h));
+       return ret;
+}
+static int ov5630_try_res(u32 *w, u32 *h)
+{
+       struct ov5630_res_struct *res_index, *p = NULL;
+       int dis, last_dis = ov5630_res->width + ov5630_res->height;
+
+       for (res_index = ov5630_res;
+            res_index < ov5630_res + N_RES;
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
+               p = ov5630_res;
+       else if ((p->width < *w) || (p->height < *h)) {
+               if (p != ov5630_res)
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
+static struct ov5630_res_struct *ov5630_to_res(u32 w, u32 h)
+{
+       struct ov5630_res_struct *res_index;
+
+       for (res_index = ov5630_res;
+            res_index < ov5630_res + N_RES;
+            res_index++)
+               if ((res_index->width == w) && (res_index->height == h))
+                       break;
+
+       if (res_index >= ov5630_res + N_RES)
+               res_index--;
+
+       return res_index;
+}
+
+static int ov5630_try_fmt(struct v4l2_subdev *sd,
+                         struct v4l2_mbus_framefmt *fmt)
+{
+       return ov5630_try_res(&fmt->width, &fmt->height);
+}
+
+static int ov5630_get_fmt(struct v4l2_subdev *sd,
+                         struct v4l2_mbus_framefmt *fmt)
+{
+       struct ci_sensor_config *info = to_sensor_config(sd);
+       unsigned short width, height;
+       int index;
+
+       ci_sensor_res2size(info->res, &width, &height);
+
+       /* Marked the current sensor res as being "used" */
+       for (index = 0; index < N_RES; index++) {
+               if ((width == ov5630_res[index].width) &&
+                   (height == ov5630_res[index].height)) {
+                       ov5630_res[index].used = 1;
+                       continue;
+               }
+               ov5630_res[index].used = 0;
+       }
+
+       fmt->width = width;
+       fmt->height = height;
+       return 0;
+}
+
+static int ov5630_set_fmt(struct v4l2_subdev *sd,
+                                       struct v4l2_mbus_framefmt *fmt)
+{
+       struct i2c_client *c = v4l2_get_subdevdata(sd);
+       struct ci_sensor_config *info = to_sensor_config(sd);
+       int ret = 0;
+       struct ov5630_res_struct *res_index;
+       u32 width, height;
+       int index;
+
+       width = fmt->width;
+       height = fmt->height;
+
+       dprintk(1, "was told to set fmt (%d x %d) ", width, height);
+
+       ret = ov5630_try_res(&width, &height);
+
+       dprintk(1, "setting fmt (%d x %d) ", width, height);
+
+       res_index = ov5630_to_res(width, height);
+
+
+       if (res_index->regs) {
+               ret = ov5630_write(c, (u32)OV5630_SYS, (u32)0x80);
+               ret += ov5630_write(c, (u32)OV5630_IMAGE_SYSTEM, (u32)0x00);
+               ret += ov5630_write_array(c, ov5630_def_reg);
+               ret += ov5630_write_array(c, res_index->regs);
+
+               /* set AE AEB AGC as info said */
+               ret += ov5630_set_img_ctrl(c, info);
+
+               /* Set MIPI interface */
+               #ifdef OV5630_MIPI
+               ret += ov5630_write_array(c, ov5630_mipi);
+               #endif
+
+               if (res_index->res == SENSOR_RES_VGA)
+                       ret += ov5630_write(c, (u32)0x3015, (u32)0x03);
+
+               /* streaming */
+               ret = ov5630_write(c, (u32)OV5630_IMAGE_SYSTEM, (u32)0x01);
+               ret = ov5630_write(c, (u32)0x3096, (u32)0x50);
+
+               info->res = res_index->res;
+
+               /* Marked current sensor res as being "used" */
+               for (index = 0; index < N_RES; index++) {
+                       if ((width == ov5630_res[index].width) &&
+                           (height == ov5630_res[index].height)) {
+                               ov5630_res[index].used = 1;
+                               continue;
+                       }
+                       ov5630_res[index].used = 0;
+               }
+
+               for (index = 0; index < N_RES; index++)
+                       dprintk(2, "index = %d, used = %d\n", index,
+                               ov5630_res[index].used);
+       } else {
+               eprintk("no res for (%d x %d)", width, height);
+       }
+
+       return ret;
+}
+
+static int ov5630_t_gain(struct v4l2_subdev *sd, int value)
+{
+       struct i2c_client *client = v4l2_get_subdevdata(sd);
+       u32 v;
+
+       dprintk(2, "writing gain %x to 0x3000", value);
+       ov5630_read(client, 0x3000, &v);
+       v = (v & 0x80) + value;
+       ov5630_write(client, 0x3000, v);
+       dprintk(2, "gain %x was writen to 0x3000", v);
+
+       return 0;
+}
+
+static int ov5630_t_exposure(struct v4l2_subdev *sd, int value)
+{
+       struct i2c_client *client = v4l2_get_subdevdata(sd);
+       u32 v;
+       u32 reg_val;
+
+       ov5630_read(client, 0x3013, &v);
+       dprintk(2, "0x3013 = %x", v);
+       if (v & 0x05) {
+               v = v & 0xfa;
+               ov5630_write(client, 0x3013, v);
+               ov5630_read(client, OV5630_ISP_CTL00, &reg_val);
+               ov5630_write(client, OV5630_ISP_CTL00, reg_val & ~0x30);
+       }
+       ov5630_read(client, 0x3014, &v);
+       dprintk(2, "0x3014 = %x", v);
+       ov5630_read(client, 0x3002, &v);
+       dprintk(2, "0x3002 = %x", v);
+       ov5630_read(client, 0x3003, &v);
+       dprintk(2, "0x3003 = %x", v);
+
+       dprintk(2, "writing exposure %x to 0x3002/3", value);
+
+       v = value >> 8;
+       ov5630_write(client, 0x3002, v);
+       dprintk(2, "exposure %x was writen to 0x3002", v);
+
+       v = value & 0xff;
+       ov5630_write(client, 0x3003, v);
+       dprintk(2, "exposure %x was writen to 0x3003", v);
+
+       return 0;
+}
+
+static int ov5630_queryctrl(struct v4l2_subdev *sd,
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
+               ret = v4l2_ctrl_query_fill(qc, 0, 255, 1, 0);
+               break;
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
+static int ov5630_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
+{
+       return 0;
+}
+
+static int ov5630_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
+{
+       int ret = -EINVAL;
+       if (!sd)
+               return -ENODEV;
+       if (!ctrl)
+               return ret;
+
+       switch (ctrl->id) {
+       case V4L2_CID_GAIN:
+               ret = ov5630_t_gain(sd, ctrl->value);
+               break;
+       case V4L2_CID_EXPOSURE:
+               ret = ov5630_t_exposure(sd, ctrl->value);
+               break;
+       default:
+               dprintk(1, "unsupported ctrl id");
+               break;
+       }
+       return ret;
+}
+
+static int ov5630_s_stream(struct v4l2_subdev *sd, int enable)
+{
+       struct i2c_client *client = v4l2_get_subdevdata(sd);
+
+       if (enable) {
+               ov5630_write(client, (u32)OV5630_IMAGE_SYSTEM, (u32)0x01);
+               ov5630_write(client, 0x30b0, 0xff);
+               ov5630_write(client, 0x30b1, 0xff);
+               msleep(500);
+       } else {
+               ov5630_write(client, (u32)OV5630_IMAGE_SYSTEM, (u32)0x00);
+               ov5630_write(client, 0x30b0, 0x00);
+               ov5630_write(client, 0x30b1, 0x00);
+       }
+
+       return 0;
+}
+
+static int ov5630_enum_framesizes(struct v4l2_subdev *sd,
+                                 struct v4l2_frmsizeenum *fsize)
+{
+       unsigned int index = fsize->index;
+
+       if (index >= N_RES)
+               return -EINVAL;
+
+       fsize->type = V4L2_FRMSIZE_TYPE_DISCRETE;
+       fsize->discrete.width = ov5630_res[index].width;
+       fsize->discrete.height = ov5630_res[index].height;
+       fsize->reserved[0] = ov5630_res[index].used;
+
+       return 0;
+}
+
+static int ov5630_enum_frameintervals(struct v4l2_subdev *sd,
+                                     struct v4l2_frmivalenum *fival)
+{
+       unsigned int index = fival->index;
+
+       if (index >= N_RES)
+               return -EINVAL;
+
+       fival->type = V4L2_FRMIVAL_TYPE_DISCRETE;
+       fival->discrete.numerator = 1;
+       fival->discrete.denominator = ov5630_res[index].fps;
+
+       return 0;
+}
+
+static int ov5630_g_chip_ident(struct v4l2_subdev *sd,
+               struct v4l2_dbg_chip_ident *chip)
+{
+       struct i2c_client *client = v4l2_get_subdevdata(sd);
+
+#define V4L2_IDENT_OV5630 8245
+       return v4l2_chip_ident_i2c_client(client, chip, V4L2_IDENT_OV5630, 0);
+}
+
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+static int ov5630_g_register(struct v4l2_subdev *sd,
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
+       ret = ov5630_read(client, reg->reg & 0xffff, &val);
+       reg->val = val;
+       reg->size = 1;
+       return ret;
+}
+
+static int ov5630_s_register(struct v4l2_subdev *sd,
+                            struct v4l2_dbg_register *reg)
+{
+       struct i2c_client *client = v4l2_get_subdevdata(sd);
+
+       if (!v4l2_chip_match_i2c_client(client, &reg->match))
+               return -EINVAL;
+       if (!capable(CAP_SYS_ADMIN))
+               return -EPERM;
+       ov5630_write(client, reg->reg & 0xffff, reg->val & 0xff);
+       return 0;
+}
+#endif
+
+static const struct v4l2_subdev_video_ops ov5630_video_ops = {
+       .try_mbus_fmt = ov5630_try_fmt,
+       .s_mbus_fmt = ov5630_set_fmt,
+       .g_mbus_fmt = ov5630_get_fmt,
+       .s_stream = ov5630_s_stream,
+       .enum_framesizes = ov5630_enum_framesizes,
+       .enum_frameintervals = ov5630_enum_frameintervals,
+};
+
+static const struct v4l2_subdev_core_ops ov5630_core_ops = {
+       .g_chip_ident = ov5630_g_chip_ident,
+       .queryctrl = ov5630_queryctrl,
+       .g_ctrl = ov5630_g_ctrl,
+       .s_ctrl = ov5630_s_ctrl,
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+       .g_register = ov5630_g_register,
+       .s_register = ov5630_s_register,
+#endif
+};
+
+static const struct v4l2_subdev_ops ov5630_ops = {
+       .core = &ov5630_core_ops,
+       .video = &ov5630_video_ops,
+};
+
+static int ov5630_detect(struct i2c_client *client)
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
+       if (adap_id != 1) {
+               eprintk("adap_id != 1");
+               return -ENODEV;
+       }
+
+       ov5630_read(client, (u32)OV5630_PID_H, &value);
+       if ((u8)value != 0x56) {
+               dprintk(1, "PID != 0x56, but %x", value);
+               dprintk(2, "client->addr = %x", client->addr);
+               return -ENODEV;
+       }
+
+       printk(KERN_INFO "Init ov5630 sensor success\n");
+       return 0;
+}
+
+static int ov5630_probe(struct i2c_client *client,
+                       const struct i2c_device_id *id)
+{
+       struct ci_sensor_config *info;
+       struct v4l2_subdev *sd;
+       int ret = -1;
+
+       v4l_info(client, "chip found @ 0x%x (%s)\n",
+                client->addr << 1, client->adapter->name);
+
+       info = kzalloc(sizeof(struct ci_sensor_config), GFP_KERNEL);
+       if (!info) {
+               eprintk("fail to malloc for ci_sensor_config");
+               ret = -ENOMEM;
+               goto out;
+       }
+
+       ret = ov5630_detect(client);
+       if (ret) {
+               dprintk(1, "error ov5630_detect");
+               goto out_free;
+       }
+
+       sd = &info->sd;
+       v4l2_i2c_subdev_init(sd, client, &ov5630_ops);
+
+       ret = ov5630_init(client);
+       if (ret) {
+               eprintk("error calling ov5630_init");
+               goto out_free;
+       }
+
+       ret = 0;
+       goto out;
+
+out_free:
+       kfree(info);
+out:
+       return ret;
+}
+
+static int ov5630_remove(struct i2c_client *client)
+{
+       struct v4l2_subdev *sd = i2c_get_clientdata(client);
+
+       v4l2_device_unregister_subdev(sd);
+       kfree(to_sensor_config(sd));
+
+       return 0;
+}
+
+static const struct i2c_device_id ov5630_id[] = {
+       {"ov5630", 0},
+       {}
+};
+
+MODULE_DEVICE_TABLE(i2c, ov5630_id);
+
+static struct i2c_driver ov5630_i2c_driver = {
+       .driver = {
+               .name = "ov5630",
+       },
+       .probe = ov5630_probe,
+       .remove = ov5630_remove,
+       .id_table = ov5630_id,
+};
+
+static int __init ov5630_drv_init(void)
+{
+       return i2c_add_driver(&ov5630_i2c_driver);
+}
+
+static void __exit ov5630_drv_cleanup(void)
+{
+       i2c_del_driver(&ov5630_i2c_driver);
+}
+
+module_init(ov5630_drv_init);
+module_exit(ov5630_drv_cleanup);
+
+MODULE_AUTHOR("Xiaolin Zhang <xiaolin.zhang@intel.com>");
+MODULE_DESCRIPTION("A low-level driver for OmniVision 5630 sensors");
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/video/ov5630.h b/drivers/media/video/ov5630.h
new file mode 100644
index 0000000..fc5db96
--- /dev/null
+++ b/drivers/media/video/ov5630.h
@@ -0,0 +1,635 @@
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
+#define I2C_OV5630     0x6C
+#define I2C_DRIVERID_OV5630    1046
+
+#define GPIO_SCLK_25   44
+#define GPIO_STB_PIN   47
+#define GPIO_STDBY_PIN 49
+#define GPIO_RESET_PIN 50
+
+/* System control register */
+#define OV5630_AGC             0x3000
+#define OV5630_AGCS    0x3001
+#define OV5630_AEC_H   0x3002
+#define OV5630_AEC_L   0x3003
+#define OV5630_LAEC_H  0x3004
+#define OV5630_LAEC_L  0x3005
+#define OV5630_AECS_H  0x3008
+#define OV5630_AECS_L  0x3009
+#define OV5630_PID_H   0x300A
+#define OV5630_PID_L   0x300B
+#define OV5630_SCCB_ID         0x300C
+#define OV5630_PLL_1   0x300E
+#define OV5630_PLL_2   0x300F
+#define OV5630_PLL_3   0x3010
+#define OV5630_PLL_4           0x3011
+#define OV5630_SYS             0x3012
+#define OV5630_AUTO_1  0x3013
+#define OV5630_AUTO_2  0x3014
+#define OV5630_AUTO_3  0x3015
+#define OV5630_AUTO_4  0x3016
+#define OV5630_AUTO_5  0x3017
+#define OV5630_WPT             0x3018
+#define OV5630_BPT             0x3019
+#define OV5630_VPT             0x301A
+#define OV5630_YAVG            0x301B
+#define OV5630_AECG_50 0x301C
+#define OV5630_AECG_60 0x301D
+#define OV5630_ADDVS_H 0x301E
+#define OV5630_ADDVS_L 0x301F
+#define OV5630_FRAME_LENGTH_LINES_H    0x3020
+#define OV5630_FRAME_LENGTH_LINES_L    0x3021
+#define OV5630_LINE_LENGTH_PCK_H       0x3022
+#define OV5630_LINE_LENGTH_PCK_L       0x3023
+#define OV5630_X_ADDR_START_H  0x3024
+#define OV5630_X_ADDR_START_L  0x3025
+#define OV5630_Y_ADDR_START_H  0x3026
+#define OV5630_Y_ADDR_START_L  0x3027
+#define OV5630_X_ADDR_END_H    0x3028
+#define OV5630_X_ADDR_END_L    0x3029
+#define OV5630_Y_ADDR_END_H    0x302A
+#define OV5630_Y_ADDR_END_L    0x302B
+#define OV5630_X_OUTPUT_SIZE_H 0x302C
+#define OV5630_X_OUTPUT_SIZE_L 0x302D
+#define OV5630_Y_OUTPUT_SIZE_H 0x302E
+#define OV5630_Y_OUTPUT_SIZE_L 0x302F
+#define OV5630_FRAME_CNT       0x3030
+#define OV5630_DATR_LMO_0      0x3038
+#define OV5630_DATR_LMO_1      0x3039
+#define OV5630_DATR_LMO_2      0x303A
+#define OV5630_DATR_D56        0x303D
+#define OV5630_DATR_EF 0x303E
+#define OV5630_R_SIGMA_0       0x3048
+#define OV5630_R_SIGMA_1       0x3049
+#define OV5630_R_SIGMA_2       0x304A
+#define OV5630_R_SIGMA_3       0x304B
+#define OV5630_R_SIGMA_4       0x304C
+#define OV5630_R_SIGMA_5       0x304D
+#define OV5630_D56COM  0x304E
+#define OV5630_5060TH  0x3050
+#define OV5630_LMO_TH1 0x3058
+#define OV5630_LMO_TH2 0x3059
+#define OV5630_LMO_K   0x305A
+#define OV5630_BD50ST_H        0x305C
+#define OV5630_BD50ST_L        0x305D
+#define OV5630_BD60ST_H        0x305E
+#define OV5630_BD60ST_L        0x305F
+#define OV5630_HSYNST  0x306D
+#define OV5630_HSYNED  0x306E
+#define OV5630_HSYNED_HSYNST   0x306F
+#define OV5630_TMC_RWIN0       0x3070
+#define OV5630_IO_CTRL0        0x30B0
+#define OV5630_IO_CTRL1        0x30B1
+#define OV5630_IO_CTRL2        0x30B2
+#define OV5630_DSIO_0  0x30B3
+#define OV5630_DSIO_1  0x30B4
+#define OV5630_DSIO_2  0x30B5
+#define OV5630_TMC_10  0x30B6
+#define OV5630_TMC_12  0x30B7
+#define OV5630_TMC_14  0x30B9
+#define OV5630_TMC_COM4        0x30BA
+#define OV5630_TMC_REG6C       0x30BB
+#define OV5630_TMC_REG6E       0x30BC
+#define OV5630_R_CLK_S 0x30BD
+#define OV5630_R_CLK_A 0x30BE
+#define OV5630_R_CLK_A1        0x30BF
+#define OV5630_FRS_0   0x30E0
+#define OV5630_FRS_1   0x30E1
+#define OV5630_FRS_2   0x30E2
+#define OV5630_FRS_3   0x30E3
+#define OV5630_FRS_FECNT       0x30E4
+#define OV5630_FRS_FECNT_0     0x30E5
+#define OV5630_FRS_FECNT_1     0x30E6
+#define OV5630_FRS_RFRM        0x30E7
+#define OV5630_FRS_RSTRB       0x30E8
+#define OV5630_SA1TMC  0x30E9
+#define OV5630_TMC_MISC0       0x30EA
+#define OV5630_TMC_MISC1       0x30EB
+#define OV5630_FLEX_TXP        0x30F0
+#define OV5630_FLEX_FLT        0x30F1
+#define OV5630_FLEX_TXT        0x30F2
+#define OV5630_FLEX_HBK        0x30F3
+#define OV5630_FLEX_HSG        0x30F4
+#define OV5630_FLEX_SA1SFT     0x30F5
+#define OV5630_RVSOPT  0x30F6
+#define OV5630_AUTO    0x30F7
+#define OV5630_IMAGE_TRANSFORM 0x30F8
+#define OV5630_IMAGE_LUM       0x30F9
+#define OV5630_IMAGE_SYSTEM    0x30FA
+#define OV5630_GROUP_WR        0x30FF
+
+/* CIF control register */
+#define OV5630_CIF_CTRL2       0x3202
+
+/* ISP control register */
+#define OV5630_ISP_CTL00       0x3300
+#define OV5630_ISP_CTL01       0x3301
+#define OV5630_ISP_CTL02       0x3302
+#define OV5630_ISP_03  0x3303
+#define OV5630_ISP_DIG_GAIN_MAN        0x3304
+#define OV5630_ISP_BIAS_MAN    0x3305
+#define OV5630_ISP_06  0x3306
+#define OV5630_ISP_STABLE_RANGE        0x3307
+#define OV5630_ISP_R_GAIN_MAN_1        0x3308
+#define OV5630_ISP_R_GAIN_MAN_0        0x3309
+#define OV5630_ISP_G_GAIN_MAN_1        0x330A
+#define OV5630_ISP_G_GAIN_MAN_0        0x330B
+#define OV5630_ISP_B_GAIN_MAN_1        0x330C
+#define OV5630_ISP_B_GAIN_MAN_0        0x330D
+#define OV5630_ISP_STABLE_RANGEW       0x330E
+#define OV5630_ISP_AWB_FRAME_CNT       0x330F
+#define OV5630_ISP_11  0x3311
+#define OV5630_ISP_12  0x3312
+#define OV5630_ISP_13  0x3313
+#define OV5630_ISP_HSIZE_IN_1  0x3314
+#define OV5630_ISP_HSIZE_IN_0  0x3315
+#define OV5630_ISP_VSIZE_IN_1  0x3316
+#define OV5630_ISP_VSIZE_IN_0  0x3317
+#define OV5630_ISP_18  0x3318
+#define OV5630_ISP_19  0x3319
+#define OV5630_ISP_EVEN_MAN0   0x331A
+#define OV5630_ISP_EVEN_MAN1   0x331B
+#define OV5630_ISP_EVEN_MAN2   0x331C
+#define OV5630_ISP_EVEN_MAN3   0x331D
+#define OV5630_ISP_1E  0x331E
+#define OV5630_ISP_1F  0x331F
+#define OV5630_ISP_BLC_LMT_OPTION      0x3320
+#define OV5630_ISP_BLC_THRE    0x3321
+#define OV5630_ISP_22  0x3322
+#define OV5630_ISP_23  0x3323
+#define OV5630_ISP_BLC_MAN0_1  0x3324
+#define OV5630_ISP_BLC_MAN0_0  0x3325
+#define OV5630_ISP_BLC_MAN1_1  0x3326
+#define OV5630_ISP_BLC_MAN1_0  0x3327
+#define OV5630_ISP_BLC_MAN2_1  0x3328
+#define OV5630_ISP_BLC_MAN2_0  0x3329
+#define OV5630_ISP_BLC_MAN3_1  0x332A
+#define OV5630_ISP_BLC_MAN3_0  0x332B
+#define OV5630_ISP_BLC_MAN4_1  0x332C
+#define OV5630_ISP_BLC_MAN4_0  0x332D
+#define OV5630_ISP_BLC_MAN5_1  0x332E
+#define OV5630_ISP_BLC_MAN5_0  0x332F
+#define OV5630_ISP_BLC_MAN6_1  0x3330
+#define OV5630_ISP_BLC_MAN6_0  0x3331
+#define OV5630_ISP_BLC_MAN7_1  0x3332
+#define OV5630_ISP_BLC_MAN7_0  0x3333
+#define OV5630_ISP_CD  0x33CD
+#define OV5630_ISP_FF  0x33FF
+
+/* clipping control register */
+#define OV5630_CLIP_CTRL0      0x3400
+#define OV5630_CLIP_CTRL1      0x3401
+#define OV5630_CLIP_CTRL2      0x3402
+#define OV5630_CLIP_CTRL3      0x3403
+#define OV5630_CLIP_CTRL4      0x3404
+#define OV5630_CLIP_CTRL5      0x3405
+#define OV5630_CLIP_CTRL6      0x3406
+#define OV5630_CLIP_CTRL7      0x3407
+
+/* DVP control register */
+#define OV5630_DVP_CTRL00      0x3500
+#define OV5630_DVP_CTRL01      0x3501
+#define OV5630_DVP_CTRL02      0x3502
+#define OV5630_DVP_CTRL03      0x3503
+#define OV5630_DVP_CTRL04      0x3504
+#define OV5630_DVP_CTRL05      0x3505
+#define OV5630_DVP_CTRL06      0x3506
+#define OV5630_DVP_CTRL07      0x3507
+#define OV5630_DVP_CTRL08      0x3508
+#define OV5630_DVP_CTRL09      0x3509
+#define OV5630_DVP_CTRL0A      0x350A
+#define OV5630_DVP_CTRL0B      0x350B
+#define OV5630_DVP_CTRL0C      0x350C
+#define OV5630_DVP_CTRL0D      0x350D
+#define OV5630_DVP_CTRL0E      0x350E
+#define OV5630_DVP_CTRL0F      0x350F
+#define OV5630_DVP_CTRL10      0x3510
+#define OV5630_DVP_CTRL11      0x3511
+#define OV5630_DVP_CTRL12      0x3512
+#define OV5630_DVP_CTRL13      0x3513
+#define OV5630_DVP_CTRL14      0x3514
+#define OV5630_DVP_CTRL15      0x3515
+#define OV5630_DVP_CTRL16      0x3516
+#define OV5630_DVP_CTRL17      0x3517
+#define OV5630_DVP_CTRL18      0x3518
+#define OV5630_DVP_CTRL19      0x3519
+#define OV5630_DVP_CTRL1A      0x351A
+#define OV5630_DVP_CTRL1B      0x351B
+#define OV5630_DVP_CTRL1C      0x351C
+#define OV5630_DVP_CTRL1D      0x351D
+#define OV5630_DVP_CTRL1E      0x351E
+#define OV5630_DVP_CTRL1F      0x351F
+
+/* MIPI control register */
+#define OV5630_MIPI_CTRL00     0x3600
+#define OV5630_MIPI_CTRL01     0x3601
+#define OV5630_MIPI_CTRL02     0x3602
+#define OV5630_MIPI_CTRL03     0x3603
+#define OV5630_MIPI_CTRL04     0x3604
+#define OV5630_MIPI_CTRL05     0x3605
+#define OV5630_MIPI_CTRL06     0x3606
+#define OV5630_MIPI_CTRL07     0x3607
+#define OV5630_MIPI_CTRL08     0x3608
+#define OV5630_MIPI_CTRL09     0x3609
+#define OV5630_MIPI_CTRL0A     0x360A
+#define OV5630_MIPI_CTRL0B     0x360B
+#define OV5630_MIPI_CTRL0C     0x360C
+#define OV5630_MIPI_CTRL0D     0x360D
+#define OV5630_MIPI_CTRL0E     0x360E
+#define OV5630_MIPI_CTRL0F     0x360F
+#define OV5630_MIPI_CTRL10     0x3610
+#define OV5630_MIPI_CTRL11     0x3611
+#define OV5630_MIPI_CTRL12     0x3612
+#define OV5630_MIPI_CTRL13     0x3613
+#define OV5630_MIPI_CTRL14     0x3614
+#define OV5630_MIPI_CTRL15     0x3615
+#define OV5630_MIPI_CTRL16     0x3616
+#define OV5630_MIPI_CTRL17     0x3617
+#define OV5630_MIPI_CTRL18     0x3618
+#define OV5630_MIPI_CTRL19     0x3619
+#define OV5630_MIPI_CTRL1A     0x361A
+#define OV5630_MIPI_CTRL1B     0x361B
+#define OV5630_MIPI_CTRL1C     0x361C
+#define OV5630_MIPI_CTRL1D     0x361D
+#define OV5630_MIPI_CTRL1E     0x361E
+#define OV5630_MIPI_CTRL1F     0x361F
+#define OV5630_MIPI_CTRL20     0x3620
+#define OV5630_MIPI_CTRL21     0x3621
+#define OV5630_MIPI_CTRL22     0x3622
+#define OV5630_MIPI_CTRL23     0x3623
+#define OV5630_MIPI_CTRL24     0x3624
+#define OV5630_MIPI_CTRL25     0x3625
+#define OV5630_MIPI_CTRL26     0x3626
+#define OV5630_MIPI_CTRL27     0x3627
+#define OV5630_MIPI_CTRL28     0x3628
+#define OV5630_MIPI_CTRL29     0x3629
+#define OV5630_MIPI_CTRL2A     0x362A
+#define OV5630_MIPI_CTRL2B     0x362B
+#define OV5630_MIPI_CTRL2C     0x362C
+#define OV5630_MIPI_CTRL2D     0x362D
+#define OV5630_MIPI_CTRL2E     0x362E
+#define OV5630_MIPI_CTRL2F     0x362F
+#define OV5630_MIPI_CTRL30     0x3630
+#define OV5630_MIPI_CTRL31     0x3631
+#define OV5630_MIPI_CTRL32     0x3632
+#define OV5630_MIPI_CTRL33     0x3633
+#define OV5630_MIPI_CTRL34     0x3634
+#define OV5630_MIPI_CTRL35     0x3635
+#define OV5630_MIPI_CTRL36     0x3636
+#define OV5630_MIPI_CTRL37     0x3637
+#define OV5630_MIPI_CTRL38     0x3638
+#define OV5630_MIPI_CTRL39     0x3639
+#define OV5630_MIPI_CTRL3A     0x363A
+#define OV5630_MIPI_CTRL3B     0x363B
+#define OV5630_MIPI_CTRL3C     0x363C
+#define OV5630_MIPI_CTRL3D     0x363D
+#define OV5630_MIPI_CTRL3E     0x363E
+#define OV5630_MIPI_CTRL3F     0x363F
+#define OV5630_MIPI_RO61       0x3661
+#define OV5630_MIPI_RO62       0x3662
+#define OV5630_MIPI_RO63       0x3663
+#define OV5630_MIPI_RO64       0x3664
+#define OV5630_MIPI_RO65       0x3665
+#define OV5630_MIPI_RO66       0x3666
+
+/* General definition for ov5630 */
+#define OV5630_OUTWND_MAX_H            QSXXGA_PLUS4_SIZE_H
+#define OV5630_OUTWND_MAX_V            QSXGA_PLUS4_SIZE_V
+
+struct regval_list {
+       u16 reg_num;
+       u8 value;
+};
+
+/*
+ * Default register value
+ * 5Mega Pixel, 2592x1944
+ */
+static const struct regval_list ov5630_def_reg[] = {
+       {0x300f, 0x00},
+       {0x30b2, 0x32},
+       {0x3084, 0x44},
+       {0x3016, 0x01},
+       {0x308a, 0x25},
+
+       {0x3013, 0xff},
+       {0x3015, 0x03},
+       {0x30bf, 0x02},
+
+       {0x3065, 0x50},
+       {0x3068, 0x08},
+       {0x30ac, 0x05},
+       {0x309e, 0x24},
+       {0x3091, 0x04},
+
+       {0x3075, 0x22},
+       {0x3076, 0x23},
+       {0x3077, 0x24},
+       {0x3078, 0x25},
+
+       {0x30b5, 0x0c},
+       {0x3090, 0x67},
+
+       {0x30f9, 0x11},
+       {0x3311, 0x80},
+       {0x3312, 0x1f},
+
+       {0x3103, 0x10},
+       {0x305c, 0x01},
+       {0x305d, 0x29},
+       {0x305e, 0x00},
+       {0x305f, 0xf7},
+       {0x308d, 0x0b},
+       {0x30ad, 0x20},
+       {0x3072, 0x0d},
+       {0x308b, 0x82},
+       {0x3317, 0x9c},
+       {0x3318, 0x22},
+       {0x3025, 0x20},
+       {0x3027, 0x08},
+       {0x3029, 0x3f},
+       {0x302b, 0xa3},
+       {0x3319, 0x22},
+       {0x30a1, 0xc4},
+       {0x306a, 0x05},
+       {0x3315, 0x22},
+       {0x30ae, 0x25},
+       {0x3304, 0x40},
+       {0x3099, 0x49},
+
+       {0x300e, 0xb1},
+       {0x300f, 0x10},
+       {0x3010, 0x07},
+       {0x3011, 0x40},
+       {0x30af, 0x10},
+       {0x304a, 0x00},
+       {0x304d, 0x00},
+
+       {0x304e, 0x22},
+       {0x304d, 0xa0},
+       {0x3058, 0x00},
+       {0x3059, 0xff},
+       {0x305a, 0x00},
+
+       {0x30e9, 0x04},
+       {0x3084, 0x44},
+       {0x3090, 0x67},
+       {0x30e9, 0x04},
+
+       {0x30b5, 0x1c},
+       {0x331f, 0x22},
+       {0x30ae, 0x15},
+       {0x3304, 0x4c},
+
+       {0x3300, 0xfb},
+       {0x3071, 0x34},
+       {0x30e7, 0x01},
+       {0x3302, 0x60},
+       {0x331e, 0x05},
+       {0x3321, 0x04},
+
+       {0xffff, 0xff},
+
+};
+
+/* 2592x1944 */
+static const struct regval_list ov5630_res_qsxga_plus4[] = {
+       {0x3020, 0x07},
+       {0x3021, 0xbc},
+       {0x3022, 0x0c},
+       {0x3023, 0xa0},
+       {0x305c, 0x01},
+       {0x305d, 0x29},
+       {0x305e, 0x00},
+       {0x305f, 0xf7},
+
+       {0x300f, 0x10},
+       {0x300e, 0xb1},
+       #ifdef MIPI
+       {0x30b0, 0x00},
+       {0x30b1, 0xfc},
+       {0x3603, 0x50},
+       {0x3601, 0x0F},
+       {0x3010, 0x07},
+       {0x30fa, 0x01},
+       {0x3096, 0x50},
+#else /* parrral */
+       {0x30fa, 0x01},
+#endif
+       {0xffff, 0xff},
+};
+
+/* 1920x1080 */
+static const struct regval_list ov5630_res_1080p[] = {
+       {0x3020, 0x04},
+       {0x3021, 0x5c},
+       {0x3022, 0x0b},
+       {0x3023, 0x32},
+       {0x305c, 0x01},
+       {0x305d, 0x2c},
+       {0x3024, 0x01},
+       {0x3025, 0x6e},
+       {0x3026, 0x01},
+       {0x3027, 0xb8},
+       {0x3028, 0x08},
+       {0x3029, 0xef},
+       {0x302a, 0x05},
+       {0x302b, 0xf3},
+       {0x302c, 0x07},
+       {0x302d, 0x80},
+       {0x302e, 0x04},
+       {0x302f, 0x38},
+       {0x3314, 0x07},
+       {0x3315, 0x82},
+       {0x3316, 0x04},
+       {0x3317, 0x3c},
+
+       {0x300f, 0x10},
+       {0x300e, 0xb1},
+
+       #ifdef MIPI
+       {0x30b0, 0x00},
+       {0x30b1, 0xfc},
+       {0x3603, 0x50},
+       {0x3601, 0x0F},
+       {0x3010, 0x07},
+       {0x30fa, 0x01},
+       {0x3096, 0x50},
+       #else /* parrral */
+       {0x30fa, 0x01},
+       #endif
+       {0xffff, 0xff},
+};
+
+/* 1280x960 V1F2_H1F2 */
+static const struct regval_list ov5630_res_xga_plus[] = {
+       {0x3020, 0x03},
+       {0x3021, 0xe4},
+       {0x3022, 0x0c},
+       {0x3023, 0x8c},
+       {0x305c, 0x00},
+       {0x305d, 0xb1},
+       {0x3024, 0x00},
+       {0x3025, 0x30},
+       {0x3026, 0x00},
+       {0x3027, 0x10},
+       {0x3028, 0x0a},
+       {0x3029, 0x2f},
+       {0x302a, 0x07},
+       {0x302b, 0xa7},
+       {0x302c, 0x05},
+       {0x302d, 0x00},
+       {0x302e, 0x03},
+       {0x302f, 0xc0},
+
+       {0x30f8, 0x05},
+       {0x30f9, 0x13},
+       {0x3314, 0x05},
+       {0x3315, 0x02},
+       {0x3316, 0x03},
+       {0x3317, 0xc4},
+
+       {0x300f, 0x10},
+       {0x300e, 0xb1},
+
+       #ifdef MIPI
+       {0x30b0, 0x00},
+       {0x30b1, 0xfc},
+       {0x3603, 0x50},
+       {0x3601, 0x0F},
+       {0x3010, 0x07},
+       {0x30fa, 0x01},
+       {0x3096, 0x50},
+       #else /* parrral */
+       {0x30fa, 0x01},
+       #endif
+
+       {0xffff, 0xff},
+};
+
+/* 1280x720, V1F2 & H1F2 */
+static const struct regval_list ov5630_res_720p[] = {
+       {0x3020, 0x02},
+       {0x3021, 0xf4},
+       {0x3022, 0x07},
+       {0x3023, 0x80},
+       {0x305c, 0x00},
+       {0x305d, 0xff},
+       {0x305e, 0x00},
+       {0x305f, 0xd4},
+
+       {0x3024, 0x00},
+       {0x3025, 0x2c},
+       {0x3026, 0x00},
+       {0x3027, 0xf0},
+       {0x3028, 0x0a},
+       {0x3029, 0x2f},
+       {0x302a, 0x08},
+       {0x302b, 0x97},
+
+       {0x30f8, 0x05},
+
+       {0x302c, 0x05},
+       {0x302d, 0x00},
+       {0x302e, 0x02},
+       {0x302f, 0xd0},
+
+       {0x30f9, 0x13},
+       {0x3314, 0x05},
+       {0x3315, 0x04},
+       {0x3316, 0x02},
+       {0x3317, 0xd4},
+
+       {0x300f, 0x10},
+       {0x300e, 0xb0},
+
+       #ifdef MIPI
+       {0x30b0, 0x00},
+       {0x30b1, 0xfc},
+       {0x3603, 0x50},
+       {0x3601, 0x0F},
+       {0x3010, 0x07},
+       {0x30fa, 0x01},
+       {0x3096, 0x50},
+       #else /* parrral */
+       {0x30fa, 0x01},
+       #endif
+
+       {0xffff, 0xff},
+};
+
+/*VGA 40fps now*/
+static const struct regval_list ov5630_res_vga_ac04_bill[] = {
+       {0x3020, 0x02},
+       {0x3021, 0x04},
+       {0x3022, 0x08},
+       {0x3023, 0x48},
+       {0x305c, 0x00},
+       {0x305d, 0x5e},
+       {0x3024, 0x00},
+       {0x3025, 0x2c},
+       {0x3026, 0x00},
+       {0x3027, 0x14},
+       {0x3028, 0x0a},
+       {0x3029, 0x2f},
+       {0x302a, 0x07},
+       {0x302b, 0xa3},
+       {0x302c, 0x02},
+       {0x302d, 0x80},
+       {0x302e, 0x01},
+       {0x302f, 0xe0},
+
+       {0x30b3, 0x09},
+       {0x3301, 0xc1},
+       {0x3313, 0xf1},
+       {0x3314, 0x05},
+       {0x3315, 0x04},
+       {0x3316, 0x01},
+       {0x3317, 0xe4},
+       {0x3318, 0x20},
+
+       {0x300f, 0x10},
+       {0x30f8, 0x09},
+
+       {0x300f, 0x11},
+       {0x300e, 0xb2},
+
+       {0x3015, 0x02},
+       #ifdef MIPI
+       {0x30b0, 0x00},
+       {0x30b1, 0xfc},
+       {0x3603, 0x50},
+       {0x3601, 0x0F},
+       {0x3010, 0x07},
+       {0x30fa, 0x01},
+       {0x3096, 0x50},
+       #else /* parrral */
+       {0x30fa, 0x01},
+       {0x30f8, 0x09},
+       {0x3096, 0x50},
+       #endif
+
+       {0xffff, 0xff},
+};
--
1.6.3.2

