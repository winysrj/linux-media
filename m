Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:33152 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753775Ab0C1Hrq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Mar 2010 03:47:46 -0400
From: "Zhang, Xiaolin" <xiaolin.zhang@intel.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "Zhu, Daniel" <daniel.zhu@intel.com>,
	"Yu, Jinlu" <jinlu.yu@intel.com>,
	"Wang, Wen W" <wen.w.wang@intel.com>,
	"Huang, Kai" <kai.huang@intel.com>,
	"Hu, Gang A" <gang.a.hu@intel.com>,
	"Ba, Zheng" <zheng.ba@intel.com>,
	"Zhang, Xiaolin" <xiaolin.zhang@intel.com>
Date: Sun, 28 Mar 2010 15:47:37 +0800
Subject: [PATCH v2 5/10] V4L2 patches for Intel Moorestown Camera Imaging
 Drivers
Message-ID: <33AB447FBD802F4E932063B962385B351D6D534F@shsmsx501.ccr.corp.intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>From 51bb9c1b42f8c92a5b01cdd24141ac1117a4c076 Mon Sep 17 00:00:00 2001
From: Xiaolin Zhang <xiaolin.zhang@intel.com>
Date: Sun, 28 Mar 2010 14:03:26 +0800
Subject: [PATCH 05/10] this patch is the 1.3mp camera (ov9665) sensor subdev driver fro interl moorestown camera imaging.

Signed-off-by: Xiaolin Zhang <xiaolin.zhang@intel.com>
---
 drivers/media/video/mrstci/mrstov9665/Kconfig      |    9 +
 drivers/media/video/mrstci/mrstov9665/Makefile     |    3 +
 drivers/media/video/mrstci/mrstov9665/mrstov9665.c |  710 ++++++++++++++++++++
 drivers/media/video/mrstci/mrstov9665/ov9665.h     |  253 +++++++
 4 files changed, 975 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/mrstci/mrstov9665/Kconfig
 create mode 100644 drivers/media/video/mrstci/mrstov9665/Makefile
 create mode 100644 drivers/media/video/mrstci/mrstov9665/mrstov9665.c
 create mode 100644 drivers/media/video/mrstci/mrstov9665/ov9665.h

diff --git a/drivers/media/video/mrstci/mrstov9665/Kconfig b/drivers/media/video/mrstci/mrstov9665/Kconfig
new file mode 100644
index 0000000..ba9b692
--- /dev/null
+++ b/drivers/media/video/mrstci/mrstov9665/Kconfig
@@ -0,0 +1,9 @@
+config VIDEO_MRST_OV9665
+       tristate "Moorestown OV9665 SoC Sensor"
+       depends on I2C && VIDEO_MRST_ISP
+
+       ---help---
+         Say Y here if your platform support OV9665 SoC Sensor.
+
+         To compile this driver as a module, choose M here: the
+         module will be called mrstov9665.ko.
diff --git a/drivers/media/video/mrstci/mrstov9665/Makefile b/drivers/media/video/mrstci/mrstov9665/Makefile
new file mode 100644
index 0000000..871b6bf
--- /dev/null
+++ b/drivers/media/video/mrstci/mrstov9665/Makefile
@@ -0,0 +1,3 @@
+obj-$(CONFIG_VIDEO_MRST_OV9665)         += mrstov9665.o
+
+EXTRA_CFLAGS   +=      -I$(src)/../include
diff --git a/drivers/media/video/mrstci/mrstov9665/mrstov9665.c b/drivers/media/video/mrstci/mrstov9665/mrstov9665.c
new file mode 100644
index 0000000..042f699
--- /dev/null
+++ b/drivers/media/video/mrstci/mrstov9665/mrstov9665.c
@@ -0,0 +1,710 @@
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
+#include <linux/videodev2.h>
+
+#include <media/v4l2-device.h>
+#include <media/v4l2-chip-ident.h>
+#include <media/v4l2-i2c-drv.h>
+
+#include "ci_sensor_common.h"
+#include "ov9665.h"
+
+static int mrstov9665_debug;
+module_param(mrstov9665_debug, int, 0644);
+MODULE_PARM_DESC(mrstov9665_debug, "Debug level (0-1)");
+
+#define dprintk(level, fmt, arg...) do {                       \
+       if (mrstov9665_debug >= level)                                  \
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
+static inline struct ci_sensor_config *to_sensor_config(struct v4l2_subdev *sd)
+{
+       return container_of(sd, struct ci_sensor_config, sd);
+}
+
+static struct ov9665_format_struct {
+       __u8 *desc;
+       __u32 pixelformat;
+       struct regval_list *regs;
+} ov9665_formats[] = {
+       {
+               .desc           = "YUYV 4:2:2",
+               .pixelformat    = SENSOR_MODE_BT601,
+               .regs           = NULL,
+       },
+};
+#define N_OV9665_FMTS ARRAY_SIZE(ov9665_formats)
+
+static struct ov9665_res_struct {
+       __u8 *desc;
+       int res;
+       int width;
+       int height;
+       int fps;
+       bool used;
+       struct regval_list *regs;
+} ov9665_res[] = {
+       {
+               .desc           = "SXGA",
+               .res            = SENSOR_RES_SXGA,
+               .width          = 1280,
+               .height         = 1024,
+               .fps            = 15,
+               .used           = 0,
+               .regs           = ov9665_res_sxga,
+       },
+       {
+               .desc           = "VGA",
+               .res            = SENSOR_RES_VGA,
+               .width          = 640,
+               .height         = 480,
+               .fps            = 15,
+               .used           = 0,
+               .regs           = ov9665_res_vga,
+       },
+};
+#define N_RES (ARRAY_SIZE(ov9665_res))
+
+static int ov9665_read(struct i2c_client *c, unsigned char reg,
+                      unsigned char *value)
+{
+       int ret;
+
+       ret = i2c_smbus_read_byte_data(c, reg);
+       if (ret >= 0) {
+               *value = (unsigned char) ret;
+               ret = 0;
+       }
+       return ret;
+}
+
+static int ov9665_write(struct i2c_client *c, unsigned char reg,
+                       unsigned char value)
+{
+       int ret = i2c_smbus_write_byte_data(c, reg, value);
+       if (reg == 0x12 && (value & 0x80))
+               msleep(2);
+       return ret;
+}
+
+static int ov9665_write_array(struct i2c_client *c, struct regval_list *vals)
+{
+       struct regval_list *p;
+       u8 read_val = 0;
+       int err_num = 0;
+       int i = 0;
+       p = vals;
+       while (p->reg_num != 0xff) {
+               ov9665_write(c, p->reg_num, p->value);
+               ov9665_read(c, p->reg_num, &read_val);
+               if (read_val != p->value)
+                       err_num++;
+               p++;
+               i++;
+       }
+
+       return 0;
+}
+
+static int ov9665_set_data_pin_in(struct i2c_client *client)
+{
+       int ret = 0;
+
+       ret += ov9665_write(client, 0xd5, 0x00);
+       ret += ov9665_write(client, 0xd6, 0x00);
+
+       return ret;
+}
+
+static int ov9665_set_data_pin_out(struct i2c_client *client)
+{
+       int ret = 0;
+
+       ret += ov9665_write(client, 0xd5, 0xff);
+       ret += ov9665_write(client, 0xd6, 0xff);
+
+       return ret;
+}
+
+static int ov9665_wakeup(void)
+{
+       gpio_set_value(GPIO_STDBY_PIN, 0);
+       msleep(10);
+       return 0;
+}
+
+static int ov9665_init(struct i2c_client *c)
+{
+       int ret;
+       struct v4l2_subdev *sd = i2c_get_clientdata(c);
+       struct ci_sensor_config *info = to_sensor_config(sd);
+       u8 reg = 0;
+
+       info->mode = ov9665_formats[0].pixelformat;
+       info->res = ov9665_res[0].res;
+       info->type = SENSOR_TYPE_SOC;
+       info->bls = SENSOR_BLS_OFF;
+       info->gamma = SENSOR_GAMMA_ON;
+       info->cconv = SENSOR_CCONV_ON;
+       info->blc = SENSOR_BLC_AUTO;
+       info->agc = SENSOR_AGC_AUTO;
+       info->awb = SENSOR_AWB_AUTO;
+       info->aec = SENSOR_AEC_AUTO;
+       info->bus_width = SENSOR_BUSWIDTH_8BIT_ZZ;
+       info->ycseq = SENSOR_YCSEQ_YCBYCR;
+       info->conv422 = SENSOR_CONV422_COSITED;
+       info->bpat = SENSOR_BPAT_GRGRBGBG;
+       info->field_inv = SENSOR_FIELDINV_NOSWAP;
+       info->field_sel = SENSOR_FIELDSEL_BOTH;
+       info->hpol = SENSOR_HPOL_REFPOS;
+       info->vpol = SENSOR_VPOL_POS;
+       info->edge = SENSOR_EDGE_FALLING;
+       info->flicker_freq = SENSOR_FLICKER_100;
+       info->cie_profile = 0;
+       memcpy(info->name, "ov9665", 7);
+
+       ret = ov9665_write(c, 0x12, 0x80);
+       ret += ov9665_write_array(c, ov9665_def_reg);
+
+       ov9665_read(c, 0x09, &reg);
+       reg = reg | 0x10;
+       ov9665_write(c, 0x09, reg);
+       ov9665_set_data_pin_in(c);
+       ssleep(1);
+
+       return ret;
+}
+
+static int distance(struct ov9665_res_struct *res, u32 w, u32 h)
+{
+       int ret;
+       if (res->width < w || res->height < h)
+               return -1;
+
+       ret = ((res->width - w) + (res->height - h));
+       return ret;
+}
+static int ov9665_try_res(u32 *w, u32 *h)
+{
+       struct ov9665_res_struct *res_index, *p = NULL;
+       int dis, last_dis = ov9665_res->width + ov9665_res->height;
+
+       for (res_index = ov9665_res;
+            res_index < ov9665_res + N_RES;
+            res_index++) {
+               if ((res_index->width <= *w) && (res_index->height <= *h))
+                       break;
+               dis = distance(res_index, *w, *h);
+               if (dis < last_dis) {
+                       last_dis = dis;
+                       p = res_index;
+               }
+       }
+
+       if (res_index == ov9665_res + N_RES)
+               res_index = ov9665_res + N_RES - 1;
+
+       *w = res_index->width;
+       *h = res_index->height;
+
+       return 0;
+}
+
+static struct ov9665_res_struct *ov9665_to_res(u32 w, u32 h)
+{
+       struct ov9665_res_struct *res_index;
+
+       for (res_index = ov9665_res;
+            res_index < ov9665_res + N_RES;
+            res_index++)
+               if ((res_index->width == w) && (res_index->height == h))
+                       break;
+
+       if (res_index >= ov9665_res + N_RES)
+               res_index--;
+
+       return res_index;
+}
+
+static int ov9665_try_fmt(struct v4l2_subdev *sd,
+                         struct v4l2_format *fmt)
+{
+       DBG_entering;
+       return ov9665_try_res(&fmt->fmt.pix.width, &fmt->fmt.pix.height);
+       DBG_leaving;
+}
+
+static int ov9665_get_fmt(struct v4l2_subdev *sd,
+                         struct v4l2_format *fmt)
+{
+       struct ci_sensor_config *info = to_sensor_config(sd);
+       unsigned short width, height;
+       int index;
+
+       ci_sensor_res2size(info->res, &width, &height);
+
+       /* Marked the current sensor res as being "used" */
+       for (index = 0; index < N_RES; index++) {
+               if ((width == ov9665_res[index].width) &&
+                   (height == ov9665_res[index].height)) {
+                       ov9665_res[index].used = 1;
+                       continue;
+               }
+               ov9665_res[index].used = 0;
+       }
+
+       fmt->fmt.pix.width = width;
+       fmt->fmt.pix.height = height;
+       return 0;
+}
+
+static int ov9665_set_fmt(struct v4l2_subdev *sd, struct v4l2_format *fmt)
+{
+       struct i2c_client *c = v4l2_get_subdevdata(sd);
+       struct ci_sensor_config *info = to_sensor_config(sd);
+       int ret = 0;
+       struct ov9665_res_struct *res_index;
+       u32 width, height;
+       int index;
+
+       DBG_entering;
+
+       width = fmt->fmt.pix.width;
+       height = fmt->fmt.pix.height;
+
+       ret = ov9665_try_res(&width, &height);
+       res_index = ov9665_to_res(width, height);
+
+       if ((info->res != res_index->res) && (res_index->regs)) {
+               ret = ov9665_write(c, 0x12, 0x80);
+               ret += ov9665_write_array(c, ov9665_def_reg);
+               ret += ov9665_write_array(c, res_index->regs);
+
+               for (index = 0; index < N_RES; index++) {
+                       if ((width == ov9665_res[index].width) &&
+                           (height == ov9665_res[index].height)) {
+                               ov9665_res[index].used = 1;
+                               continue;
+                       }
+                       ov9665_res[index].used = 0;
+               }
+
+               for (index = 0; index < N_RES; index++)
+                       dprintk(2, "index = %d, used = %d\n", index,
+                               ov9665_res[index].used);
+       }
+       info->res = res_index->res;
+
+       DBG_leaving;
+       return ret;
+}
+
+static int ov9665_q_hflip(struct v4l2_subdev *sd, __s32 *value)
+{
+       struct i2c_client *client = v4l2_get_subdevdata(sd);
+       int ret;
+       unsigned char v = 0;
+
+       ret = ov9665_read(client, 0x04, &v);
+       *value = ((v & 0x80) == 0x80);
+       return ret;
+}
+
+static int ov9665_t_hflip(struct v4l2_subdev *sd, int value)
+{
+       struct i2c_client *client = v4l2_get_subdevdata(sd);
+       unsigned char v = 0;
+       int ret;
+
+       value = value >= 1 ? 1 : 0;
+       ret = ov9665_read(client, 0x33, &v);
+       if (value)
+               v |= 0x08;
+       else
+               v &= ~0x08;
+       ret += ov9665_write(client, 0x33, v);
+
+       ret += ov9665_read(client, 0x04, &v);
+       if (value)
+               v |= 0x80;
+       else
+               v &= ~0x80;
+       ret += ov9665_write(client, 0x04, v);
+       msleep(10);
+       return ret;
+}
+
+static int ov9665_q_vflip(struct v4l2_subdev *sd, __s32 *value)
+{
+       struct i2c_client *client = v4l2_get_subdevdata(sd);
+       int ret;
+       unsigned char v = 0;
+
+       ret = ov9665_read(client, 0x04, &v);
+       *value = ((v & 0x40) == 0x40);
+       return ret;
+}
+
+static int ov9665_t_vflip(struct v4l2_subdev *sd, int value)
+{
+       struct i2c_client *client = v4l2_get_subdevdata(sd);
+       unsigned char v = 0;
+       int ret;
+
+       value = value >= 1 ? 1 : 0;
+       ret = ov9665_read(client, 0x04, &v);
+       if (value)
+               v |= 0x40;
+       else
+               v &= ~0x40;
+       ret += ov9665_write(client, 0x04, v);
+       msleep(10);
+       return ret;
+}
+
+static struct ov9665_control {
+       struct v4l2_queryctrl qc;
+       int (*query)(struct v4l2_subdev *sd, __s32 *value);
+       int (*tweak)(struct v4l2_subdev *sd, int value);
+} ov9665_controls[] = {
+       {
+               .qc = {
+                       .id = V4L2_CID_VFLIP,
+                       .type = V4L2_CTRL_TYPE_BOOLEAN,
+                       .name = "Vertical flip",
+                       .minimum = 0,
+                       .maximum = 1,
+                       .step = 1,
+                       .default_value = 0,
+               },
+               .tweak = ov9665_t_vflip,
+               .query = ov9665_q_vflip,
+       },
+       {
+               .qc = {
+                       .id = V4L2_CID_HFLIP,
+                       .type = V4L2_CTRL_TYPE_BOOLEAN,
+                       .name = "Horizontal mirror",
+                       .minimum = 0,
+                       .maximum = 1,
+                       .step = 1,
+                       .default_value = 0,
+               },
+               .tweak = ov9665_t_hflip,
+               .query = ov9665_q_hflip,
+       },
+};
+#define N_CONTROLS (ARRAY_SIZE(ov9665_controls))
+
+static struct ov9665_control *ov9665_find_control(__u32 id)
+{
+       int i;
+
+       for (i = 0; i < N_CONTROLS; i++)
+               if (ov9665_controls[i].qc.id == id)
+                       return ov9665_controls + i;
+       return NULL;
+}
+
+static int ov9665_queryctrl(struct v4l2_subdev *sd,
+                           struct v4l2_queryctrl *qc)
+{
+       struct ov9665_control *ctrl = ov9665_find_control(qc->id);
+
+       if (ctrl == NULL)
+               return -EINVAL;
+       *qc = ctrl->qc;
+       return 0;
+}
+
+static int ov9665_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
+{
+       struct ov9665_control *octrl = ov9665_find_control(ctrl->id);
+       int ret;
+
+       if (octrl == NULL)
+               return -EINVAL;
+       ret = octrl->query(sd, &ctrl->value);
+       if (ret >= 0)
+               return 0;
+       return ret;
+}
+
+static int ov9665_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
+{
+       struct ov9665_control *octrl = ov9665_find_control(ctrl->id);
+       int ret;
+
+       if (octrl == NULL)
+               return -EINVAL;
+       ret =  octrl->tweak(sd, ctrl->value);
+       if (ret >= 0)
+               return 0;
+       return ret;
+}
+
+static int ov9665_s_stream(struct v4l2_subdev *sd, int enable)
+{
+       struct i2c_client *client = v4l2_get_subdevdata(sd);
+       u8 reg = 0;
+
+       DBG_entering;
+       if (enable) {
+               ov9665_read(client, 0x09, &reg);
+               reg = reg & ~0x10;
+               ov9665_write(client, 0x09, reg);
+               ov9665_set_data_pin_out(client);
+               ssleep(1);
+
+       } else {
+               ov9665_read(client, 0x09, &reg);
+               reg = reg | 0x10;
+               ov9665_write(client, 0x09, reg);
+               ov9665_set_data_pin_in(client);
+       }
+
+       DBG_leaving;
+       return 0;
+}
+
+static int ov9665_enum_framesizes(struct v4l2_subdev *sd,
+                                 struct v4l2_frmsizeenum *fsize)
+{
+       unsigned int index = fsize->index;
+
+       DBG_entering;
+
+       if (index >= N_RES)
+               return -EINVAL;
+
+       fsize->type = V4L2_FRMSIZE_TYPE_DISCRETE;
+       fsize->discrete.width = ov9665_res[index].width;
+       fsize->discrete.height = ov9665_res[index].height;
+       fsize->reserved[0] = ov9665_res[index].used;
+
+       DBG_leaving;
+
+       return 0;
+}
+
+static int ov9665_enum_frameintervals(struct v4l2_subdev *sd,
+                                     struct v4l2_frmivalenum *fival)
+{
+       unsigned int index = fival->index;
+
+       DBG_entering;
+
+       if (index >= N_RES)
+               return -EINVAL;
+
+       fival->type = V4L2_FRMIVAL_TYPE_DISCRETE;
+       fival->discrete.numerator = 1;
+       fival->discrete.denominator = ov9665_res[index].fps;
+
+       DBG_leaving;
+
+       return 0;
+}
+
+static int ov9665_g_chip_ident(struct v4l2_subdev *sd,
+               struct v4l2_dbg_chip_ident *chip)
+{
+       struct i2c_client *client = v4l2_get_subdevdata(sd);
+
+#define V4L2_IDENT_OV9665 8246
+       return v4l2_chip_ident_i2c_client(client, chip, V4L2_IDENT_OV9665, 0);
+}
+
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+static int ov9665_g_register(struct v4l2_subdev *sd,
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
+       ret = ov9665_read(client, reg->reg & 0xffff, &val);
+       reg->val = val;
+       reg->size = 1;
+       return ret;
+}
+
+static int ov9665_s_register(struct v4l2_subdev *sd,
+                            struct v4l2_dbg_register *reg)
+{
+       struct i2c_client *client = v4l2_get_subdevdata(sd);
+
+       if (!v4l2_chip_match_i2c_client(client, &reg->match))
+               return -EINVAL;
+       if (!capable(CAP_SYS_ADMIN))
+               return -EPERM;
+       ov9665_write(client, reg->reg & 0xffff, reg->val & 0xff);
+       return 0;
+}
+#endif
+
+static const struct v4l2_subdev_video_ops ov9665_video_ops = {
+       .try_fmt = ov9665_try_fmt,
+       .s_fmt = ov9665_set_fmt,
+       .g_fmt = ov9665_get_fmt,
+       .s_stream = ov9665_s_stream,
+       .enum_framesizes = ov9665_enum_framesizes,
+       .enum_frameintervals = ov9665_enum_frameintervals,
+};
+
+static const struct v4l2_subdev_core_ops ov9665_core_ops = {
+       .g_chip_ident = ov9665_g_chip_ident,
+       .queryctrl = ov9665_queryctrl,
+       .g_ctrl = ov9665_g_ctrl,
+       .s_ctrl = ov9665_s_ctrl,
+       #ifdef CONFIG_VIDEO_ADV_DEBUG
+       .g_register = ov9665_g_register,
+       .s_register = ov9665_s_register,
+       #endif
+};
+
+static const struct v4l2_subdev_ops ov9665_ops = {
+       .core = &ov9665_core_ops,
+       .video = &ov9665_video_ops,
+};
+
+static int ov9665_detect(struct i2c_client *client)
+{
+       struct i2c_adapter *adapter = client->adapter;
+       int adap_id = i2c_adapter_id(adapter);
+       u8 config = 0;
+
+       if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA))
+               return -ENODEV;
+
+       if (adap_id != 1)
+               return -ENODEV;
+
+       ov9665_wakeup();
+
+       ov9665_read(client, 0x0a, &config);
+       if (config != 0x96)
+               return -ENODEV;
+
+       ov9665_read(client, 0x0b, &config);
+       if (config != 0x63)
+               return -ENODEV;
+
+       return 0;
+}
+
+static int ov9665_probe(struct i2c_client *client,
+                       const struct i2c_device_id *id)
+{
+       struct ci_sensor_config *info;
+       struct v4l2_subdev *sd;
+       int ret = -1;
+
+       DBG_entering;
+
+       info = kzalloc(sizeof(struct ci_sensor_config), GFP_KERNEL);
+       if (!info)
+               return -ENOMEM;
+
+       ret = ov9665_detect(client);
+       if (ret) {
+               kfree(info);
+               return -ENODEV;
+       }
+
+       sd = &info->sd;
+       v4l2_i2c_subdev_init(sd, client, &ov9665_ops);
+
+       ret = ov9665_init(client);
+       if (ret) {
+               eprintk("error init ov9665");
+               goto err_1;
+       }
+
+       printk(KERN_INFO "Init ov9665 sensor success\n");
+       DBG_leaving;
+       return 0;
+
+err_1:
+       kfree(info);
+       return ret;
+}
+
+static int ov9665_remove(struct i2c_client *client)
+{
+       struct v4l2_subdev *sd = i2c_get_clientdata(client);
+
+       v4l2_device_unregister_subdev(sd);
+       kfree(to_sensor_config(sd));
+
+       return 0;
+}
+
+static const struct i2c_device_id ov9665_id[] = {
+       {"ov9665", 0},
+       {}
+};
+
+MODULE_DEVICE_TABLE(i2c, ov9665_id);
+
+static struct v4l2_i2c_driver_data v4l2_i2c_data = {
+       .name = "ov9665",
+       .probe = ov9665_probe,
+       .remove = ov9665_remove,
+       .id_table = ov9665_id,
+};
+
+MODULE_AUTHOR("Xiaolin Zhang <xiaolin.zhang@intel.com>");
+MODULE_DESCRIPTION("A low-level driver for OmniVision 9665 sensors");
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/video/mrstci/mrstov9665/ov9665.h b/drivers/media/video/mrstci/mrstov9665/ov9665.h
new file mode 100644
index 0000000..06935c2
--- /dev/null
+++ b/drivers/media/video/mrstci/mrstov9665/ov9665.h
@@ -0,0 +1,253 @@
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
+#define I2C_OV9665     0x60
+#define I2C_DRIVERID_OV9665    1047
+
+#define GPIO_SCLK_25   44
+#define GPIO_STB_PIN   47
+#define GPIO_STDBY_PIN 48
+#define GPIO_RESET_PIN 50
+
+struct regval_list {
+       u8 reg_num;
+       u8 value;
+};
+
+/*
+ * Default register value
+ * 1280x1024 YUV
+ */
+static struct regval_list ov9665_def_reg[] = {
+       {0x3E, 0x80},
+       {0x12, 0x80},
+
+       {0xd5, 0xff},
+       {0xd6, 0x3f},
+
+       {0x3d, 0x3c},
+       {0x11, 0x81},
+       {0x2a, 0x00},
+       {0x2b, 0x00},
+
+       {0x3a, 0xf1},
+       {0x3b, 0x00},
+       {0x3c, 0x58},
+       {0x3e, 0x50},
+       {0x71, 0x00},
+
+       {0x15, 0x00},
+       {0x6a, 0x24},
+       {0x85, 0xe7},
+
+       {0x63, 0x01},
+
+       {0x17, 0x0c},
+       {0x18, 0x5c},
+       {0x19, 0x01},
+       {0x1a, 0x82},
+       {0x03, 0x03},
+       {0x2b, 0x00},
+
+       {0x36, 0xb4},
+       {0x65, 0x10},
+       {0x70, 0x02},
+       {0x71, 0x9f},
+       {0x64, 0x24},
+
+       {0x43, 0x00},
+       {0x5D, 0x55},
+       {0x5E, 0x57},
+       {0x5F, 0x21},
+
+       {0x24, 0x3e},
+       {0x25, 0x38},
+       {0x26, 0x72},
+
+       {0x14, 0x68},
+       {0x0C, 0x3a},
+       {0x4F, 0x9E},
+       {0x50, 0x84},
+       {0x5A, 0x67},
+
+       {0x7d, 0x30},
+       {0x7e, 0x00},
+       {0x82, 0x03},
+       {0x7f, 0x00},
+       {0x83, 0x07},
+       {0x80, 0x03},
+       {0x81, 0x04},
+
+       {0x96, 0xf0},
+       {0x97, 0x00},
+       {0x92, 0x33},
+       {0x94, 0x5a},
+       {0x93, 0x3a},
+       {0x95, 0x48},
+       {0x91, 0xfc},
+       {0x90, 0xff},
+       {0x8e, 0x4e},
+       {0x8f, 0x4e},
+       {0x8d, 0x13},
+       {0x8c, 0x0c},
+       {0x8b, 0x0c},
+       {0x86, 0x9e},
+       {0x87, 0x11},
+       {0x88, 0x22},
+       {0x89, 0x05},
+       {0x8a, 0x03},
+
+       {0x9b, 0x0e},
+       {0x9c, 0x1c},
+       {0x9d, 0x34},
+       {0x9e, 0x5a},
+       {0x9f, 0x68},
+       {0xa0, 0x76},
+       {0xa1, 0x82},
+       {0xa2, 0x8e},
+       {0xa3, 0x98},
+       {0xa4, 0xa0},
+       {0xa5, 0xb0},
+       {0xa6, 0xbe},
+       {0xa7, 0xd2},
+       {0xa8, 0xe2},
+       {0xa9, 0xee},
+       {0xaa, 0x18},
+
+       {0xAB, 0xe7},
+       {0xb0, 0x43},
+       {0xac, 0x04},
+       {0x84, 0x40},
+
+       {0xad, 0x84},
+       {0xd9, 0x24},
+       {0xda, 0x00},
+       {0xae, 0x10},
+
+       {0xab, 0xe7},
+       {0xb9, 0xa0},
+       {0xba, 0x80},
+       {0xbb, 0xa0},
+       {0xbc, 0x80},
+
+       {0xbd, 0x08},
+       {0xbe, 0x19},
+       {0xbf, 0x02},
+       {0xc0, 0x08},
+       {0xc1, 0x2a},
+       {0xc2, 0x34},
+       {0xc3, 0x2d},
+       {0xc4, 0x2d},
+       {0xc5, 0x00},
+       {0xc6, 0x98},
+       {0xc7, 0x18},
+       {0x69, 0x48},
+
+       {0x74, 0xc0},
+
+       {0x7c, 0x18},
+       {0x65, 0x11},
+       {0x66, 0x00},
+       {0x41, 0xa0},
+       {0x5b, 0x28},
+       {0x60, 0x84},
+       {0x05, 0x07},
+       {0x03, 0x03},
+       {0xd2, 0x8c},
+
+       {0xc7, 0x90},
+       {0xc8, 0x06},
+       {0xcb, 0x40},
+       {0xcc, 0x40},
+       {0xcf, 0x00},
+       {0xd0, 0x20},
+       {0xd1, 0x00},
+       {0xc7, 0x18},
+
+       {0x0d, 0x82},
+       {0x0d, 0x80},
+
+       {0x09, 0x01},
+
+       {0xff, 0xff},
+};
+
+/* 1280x1024 */
+static struct regval_list ov9665_res_sxga[] = {
+       {0x0c, 0xbc},
+       {0xff, 0xff},
+};
+
+/* 640x480 */
+static struct regval_list ov9665_res_vga[] = {
+       {0x11, 0x80},
+       {0x63, 0x00},
+
+       {0x12, 0x40},
+       {0x14, 0x30},
+       {0x0c, 0xbc},
+       {0x4d, 0x09},
+       {0x5c, 0x80},
+
+       {0x17, 0x0c},
+       {0x18, 0x5c},
+       {0x19, 0x02},
+       {0x1a, 0x3f},
+       {0x03, 0x03},
+       {0x32, 0xad},
+
+       {0x5a, 0x23},
+       {0x2b, 0x00},
+
+       {0x64, 0xa4},
+       {0x4F, 0x9e},
+       {0x50, 0x84},
+       {0x97, 0x0a},
+       {0xad, 0x82},
+       {0xd9, 0x11},
+
+       {0xb9, 0x50},
+       {0xba, 0x3c},
+       {0xbb, 0x50},
+       {0xbc, 0x3c},
+
+       {0xad, 0x80},
+       {0xd9, 0x00},
+       {0xac, 0x0f},
+       {0x84, 0x86},
+
+       {0xbd, 0x05},
+       {0xbe, 0x16},
+       {0xbf, 0x05},
+       {0xc0, 0x07},
+       {0xc1, 0x18},
+       {0xc2, 0x1f},
+       {0xc3, 0x2b},
+       {0xc4, 0x2b},
+       {0xc5, 0x00},
+
+       {0x0d, 0x92},
+       {0x0d, 0x90},
+
+       {0xff, 0xff},
+};
--
1.6.3.2

