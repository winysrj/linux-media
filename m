Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:48299 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760875AbZD3I02 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Apr 2009 04:26:28 -0400
From: "Zhang, Xiaolin" <xiaolin.zhang@intel.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "Johnson, Charles F" <charles.f.johnson@intel.com>
Date: Thu, 30 Apr 2009 16:24:09 +0800
Subject: [PATCH 3/5] V4L2 patches for Intel Moorestown Camera Imaging Drivers
Message-ID: <0A882F4D99BBF6449D58E61AAFD7EDD613793939@pdsmsx502.ccr.corp.intel.com>
References: <90b950fc0904292317m500820efv66755aed31b46853@mail.gmail.com>
 <5A47E75E594F054BAF48C5E4FC4B92AB030548BA1B@dbde02.ent.ti.com>   
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>From 852df51762e8de89e3a78a86d8863700999eaeaa Mon Sep 17 00:00:00 2001
From: Xiaolin Zhang <xiaolin.zhang@intel.com>
Date: Thu, 30 Apr 2009 13:18:21 +0800
Subject: [PATCH] 2MP camera sensor driver (ov2650) on Intel Moorestown platform.
 Signed-off-by: Xiaolin Zhang <xiaolin.zhang@intel.com>

---
 drivers/media/video/Makefile                       |    1 +
 drivers/media/video/mrstci/Kconfig                 |    1 +
 drivers/media/video/mrstci/mrstov2650/Kconfig      |    9 +
 drivers/media/video/mrstci/mrstov2650/Makefile     |    3 +
 drivers/media/video/mrstci/mrstov2650/mrstov2650.c |  877 ++++++++++++++++++++
 drivers/media/video/mrstci/mrstov2650/ov2650.h     |  716 ++++++++++++++++
 6 files changed, 1607 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/mrstci/mrstov2650/Kconfig
 create mode 100644 drivers/media/video/mrstci/mrstov2650/Makefile
 create mode 100644 drivers/media/video/mrstci/mrstov2650/mrstov2650.c
 create mode 100644 drivers/media/video/mrstci/mrstov2650/ov2650.h

diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index 34a3461..eed3965 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -153,6 +153,7 @@ obj-$(CONFIG_VIDEO_AU0828) += au0828/
 obj-$(CONFIG_USB_VIDEO_CLASS)  += uvc/
 obj-$(CONFIG_VIDEO_MRST_ISP) += mrstci/mrstisp/
 obj-$(CONFIG_VIDEO_MRST_SENSOR) += mrstci/mrstsensor/
+obj-$(CONFIG_VIDEO_MRST_OV2650) += mrstci/mrstov2650/

 EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core
 EXTRA_CFLAGS += -Idrivers/media/dvb/frontends
diff --git a/drivers/media/video/mrstci/Kconfig b/drivers/media/video/mrstci/Kconfig
index bf01447..1ad479b 100644
--- a/drivers/media/video/mrstci/Kconfig
+++ b/drivers/media/video/mrstci/Kconfig
@@ -12,5 +12,6 @@ source "drivers/media/video/mrstci/mrstisp/Kconfig"

 source "drivers/media/video/mrstci/mrstsensor/Kconfig"

+source "drivers/media/video/mrstci/mrstov2650/Kconfig"
 endif # VIDEO_MRSTCI

diff --git a/drivers/media/video/mrstci/mrstov2650/Kconfig b/drivers/media/video/mrstci/mrstov2650/Kconfig
new file mode 100644
index 0000000..cdd985b
--- /dev/null
+++ b/drivers/media/video/mrstci/mrstov2650/Kconfig
@@ -0,0 +1,9 @@
+config VIDEO_MRST_OV2650
+       tristate "Moorestown OV2650 SoC Sensor"
+       depends on I2C && VIDEO_MRST_ISP && VIDEO_MRST_SENSOR
+
+       ---help---
+         Say Y here if your platform support OV2650 SoC Sensor.
+
+         To compile this driver as a module, choose M here: the
+         module will be called mrstov2650.ko.
diff --git a/drivers/media/video/mrstci/mrstov2650/Makefile b/drivers/media/video/mrstci/mrstov2650/Makefile
new file mode 100644
index 0000000..fb16d57
--- /dev/null
+++ b/drivers/media/video/mrstci/mrstov2650/Makefile
@@ -0,0 +1,3 @@
+obj-$(CONFIG_VIDEO_MRST_OV2650)         += mrstov2650.o
+
+EXTRA_CFLAGS   +=      -I$(src)/../include
\ No newline at end of file
diff --git a/drivers/media/video/mrstci/mrstov2650/mrstov2650.c b/drivers/media/video/mrstci/mrstov2650/mrstov2650.c
new file mode 100644
index 0000000..af036cc
--- /dev/null
+++ b/drivers/media/video/mrstci/mrstov2650/mrstov2650.c
@@ -0,0 +1,877 @@
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
+#include "sensordev.h"
+#include "ov2650.h"
+
+static struct ov2650_format_struct {
+       __u8 *desc;
+       __u32 pixelformat;
+       struct regval_list *regs;
+} ov2650_formats[] = {
+       {
+               .desc           = "YUYV 4:2:2",
+               .pixelformat    = SENSOR_MODE_BT601,
+               .regs           = NULL,
+       },
+};
+#define N_OV2650_FMTS ARRAY_SIZE(ov2650_formats)
+
+static struct ov2650_res_struct {
+       __u8 *desc;
+       int res;
+       int width;
+       int height;
+       unsigned vflag;
+#define VARIO_EN       1
+#define VARIO_DIS      0
+       struct regval_list *regs;
+} ov2650_res[] = {
+       {
+               .desc           = "UXGA",
+               .res            = SENSOR_RES_UXGA,
+               .width          = 1600,
+               .height         = 1200,
+               .vflag          = VARIO_DIS,
+               .regs           = ov2650_res_uxga,
+       },
+       {
+               .desc           = "SXGA",
+               .res            = SENSOR_RES_SXGA,
+               .width          = 1280,
+               .height         = 1024,
+               .vflag          = VARIO_DIS,
+               .regs           = ov2650_res_sxga,
+       },
+       {
+               .desc           = "SVGA",
+               .res            = SENSOR_RES_SVGA,
+               .width          = 800,
+               .height         = 600,
+               .vflag          = VARIO_EN,
+               .regs           = ov2650_res_svga,
+       },
+       {
+               .desc           = "VGA",
+               .res            = SENSOR_RES_VGA,
+               .width          = 640,
+               .height         = 480,
+               .vflag          = VARIO_EN,
+               .regs           = ov2650_res_vga_vario,
+       },
+       {
+               .desc           = "QVGA",
+               .res            = SENSOR_RES_QVGA,
+               .width          = 320,
+               .height         = 240,
+               .vflag          = VARIO_EN,
+               .regs           = ov2650_res_qvga,
+       },
+};
+
+#define N_RES (ARRAY_SIZE(ov2650_res))
+
+/*
+ * I2C Read & Write stuff
+ */
+static int ov2650_read(struct i2c_client *c, u16 reg, u8 *value)
+{
+       int ret;
+       int i;
+       struct i2c_msg msg[2];
+       u8 msgbuf[2];
+       u8 ret_val = 0;
+       *value = 0;
+       /* Read needs two message to go */
+       memset(&msg, 0, sizeof(msg));
+       msgbuf[0] = 0;
+       msgbuf[1] = 0;
+       i = 0;
+       msgbuf[i++] = reg >> 8;
+       msgbuf[i++] = reg;
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
+static int ov2650_write(struct i2c_client *c, u16 reg, u8 value)
+{
+       int ret, i;
+       struct i2c_msg msg;
+       u8 msgbuf[3];
+
+       /* Writing only needs one message */
+       memset(&msg, 0, sizeof(msg));
+       i = 0;
+       msgbuf[i++] = reg >> 8;
+       msgbuf[i++] = reg;
+       msgbuf[i++] = value;
+
+       msg.addr = c->addr;
+       msg.flags = 0;
+       msg.buf = msgbuf;
+       msg.len = i;
+
+       ret = i2c_transfer(c->adapter, &msg, 1);
+
+       /* If this is a reset register, wait for 1ms */
+       if (reg == OV2650_SYS && (value & 0x80))
+               msleep(3);
+
+       ret = (ret == 1) ? 0 : -1;
+       return ret;
+}
+
+static int ov2650_write_array(struct i2c_client *c, struct regval_list *vals)
+{
+       struct regval_list *p;
+       u8 read_val = 0;
+       int err_num = 0;
+       int i = 0;
+       p = vals;
+       while (p->reg_num != 0xffff) {
+               ov2650_write(c, p->reg_num, p->value);
+               ov2650_read(c, p->reg_num, &read_val);
+               if (read_val != p->value)
+                       err_num++;
+               p++;
+               i++;
+       }
+       return 0;
+}
+
+/*
+ * Sensor specific helper function
+ */
+static int ov2650_standby(void)
+{
+       gpio_set_value(GPIO_STDBY_PIN, 1);
+       return 0;
+}
+
+static int ov2650_wakeup(void)
+{
+       gpio_set_value(GPIO_STDBY_PIN, 0);
+       return 0;
+}
+
+static int ov2650_init(struct i2c_client *c)
+{
+       int ret;
+       struct ci_sensor_config *info = i2c_get_clientdata(c);
+
+       /* Fill the configuration structure */
+       /* Note this default configuration value */
+       info->mode = ov2650_formats[0].pixelformat;
+       info->res = ov2650_res[0].res;
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
+       info->bpat = SENSOR_BPAT_BGBGGRGR;/* GRGRBGBG; */
+       info->field_inv = SENSOR_FIELDINV_NOSWAP;
+       info->field_sel = SENSOR_FIELDSEL_BOTH;
+       info->hpol = SENSOR_HPOL_REFPOS;
+       info->vpol = SENSOR_VPOL_POS;
+       info->edge = SENSOR_EDGE_RISING;
+       info->flicker_freq = SENSOR_FLICKER_100;
+       info->cie_profile = 0;
+       memcpy(info->name, "ov2650", 7);
+
+       ret = ov2650_write(c, OV2650_SYS, 0x80);
+       /* Set registers into default config value */
+       ret += ov2650_write_array(c, ov2650_def_reg);
+       ssleep(1);
+
+       return ret;
+}
+
+static int distance(struct ov2650_res_struct *res, u16 w, u16 h)
+{
+       int ret;
+       if (res->width < w || res->height < h)
+               return -1;
+
+       ret = ((res->width - w) + (res->height - h));
+       return ret;
+}
+static int ov2650_try_res(struct i2c_client *c, u16 *w, u16 *h)
+{
+       struct ov2650_res_struct *res_index, *p = NULL;
+       int dis, last_dis = ov2650_res->width + ov2650_res->height;
+
+       for (res_index = ov2650_res;
+            res_index < ov2650_res + N_RES;
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
+               p = ov2650_res;
+
+       if ((w != NULL) && (h != NULL)) {
+               *w = p->width;
+               *h = p->height;
+       }
+
+       return 0;
+}
+
+static struct ov2650_res_struct *ov2650_find_res(int w, int h)
+{
+       struct ov2650_res_struct *res_index;
+
+       for (res_index = ov2650_res;
+            res_index < ov2650_res + N_RES;
+            res_index++)
+               if ((res_index->width == w) && (res_index->height == h))
+                       break;
+
+       if (res_index >= ov2650_res + N_RES)
+               res_index--;   /* Take the bigger one */
+
+       return res_index;
+}
+
+static int ov2650_set_res(struct i2c_client *c, const int w, const int h)
+{
+       int ret = 0;
+       struct ov2650_res_struct *res_index;
+       struct ci_sensor_config *info = i2c_get_clientdata(c);
+       unsigned short width, high;
+
+       width = w;
+       high = h;
+       ret += ov2650_try_res(c, &width, &high);
+
+       res_index = ov2650_find_res(width, high);
+
+       if ((info->res != res_index->res) && (res_index->regs)) {
+               ret = ov2650_write(c, OV2650_SYS, 0x80);
+               ret += ov2650_write_array(c, ov2650_def_reg);
+               ret += ov2650_write_array(c, res_index->regs);
+               /* Add delay here to get better image */
+               ssleep(2);
+       }
+       info->res = res_index->res;
+
+       return ret;
+}
+
+static int ov2650_q_hflip(struct i2c_client *client, __s32 *value)
+{
+       int ret;
+       unsigned char v;
+
+       ret = ov2650_read(client, OV2650_TMC_6, &v);
+       *value = (v & 0x02) == 0x02;
+       return ret;
+}
+
+static int ov2650_t_hflip(struct i2c_client *client, int value)
+{
+       unsigned char v;
+       int ret;
+       unsigned char v1 = 0;
+       struct ci_sensor_config *info = i2c_get_clientdata(client);
+
+       value = value >= 1 ? 1 : 0;
+       ret = ov2650_read(client, OV2650_TMC_6, &v);
+       if (value) {
+               v |= 0x02;
+               v1 |= 0x08;
+               info->bpat = SENSOR_BPAT_GRGRBGBG;/*BGBGGRGR;*/
+       } else {
+               v &= ~0x02;
+               v1 &= ~0x08;
+               info->bpat = SENSOR_BPAT_BGBGGRGR;
+       }
+       ret += ov2650_write(client, OV2650_TMC_6, v);
+       ret += ov2650_write(client, 0x3090, v1);
+       msleep(10);  /* FIXME */
+
+       return ret;
+}
+
+static int ov2650_q_vflip(struct i2c_client *client, __s32 *value)
+{
+       int ret;
+       unsigned char v;
+
+       ret = ov2650_read(client, OV2650_TMC_6, &v);
+       *value = (v & 0x01) == 0x01;
+       return ret;
+}
+
+
+static int ov2650_t_vflip(struct i2c_client *client, int value)
+{
+       unsigned char v;
+       int ret;
+
+       value = value >= 1 ? 1 : 0;
+       ret = ov2650_read(client, OV2650_TMC_6, &v);
+       if (value)
+               v |= 0x01;
+       else
+               v &= ~0x01;
+       ret += ov2650_write(client, OV2650_TMC_6, v);
+       msleep(10);  /* FIXME */
+
+       return ret;
+}
+
+static int ov2650_t_awb(struct i2c_client *c, int value)
+{
+       unsigned char v;
+       int ret;
+       struct ci_sensor_config *info = i2c_get_clientdata(c);
+
+       value = value >= 1 ? 1 : 0;
+       ret = ov2650_read(c, OV2650_ISP_CTL_0, &v);
+       if (value & 0x01) {
+               v |= 0x30;
+               info->awb = SENSOR_AWB_AUTO;
+       } else {
+               v &= ~0x30;
+               info->awb = SENSOR_AWB_OFF;
+       }
+       ret += ov2650_write(c, OV2650_ISP_CTL_0, v);
+       msleep(10);  /* FIXME */
+
+       return ret;
+}
+
+static int ov2650_q_awb(struct i2c_client *c, int *value)
+{
+       int ret;
+       unsigned char v;
+
+       ret = ov2650_read(c, OV2650_ISP_CTL_0, &v);
+       *value = (v & 0x30) == 0x30;
+       return ret;
+}
+
+static int ov2650_t_agc(struct i2c_client *c, int value)
+{
+       unsigned char v;
+       int ret;
+       struct ci_sensor_config *info = i2c_get_clientdata(c);
+
+       value = value >= 1 ? 1 : 0;
+       ret = ov2650_read(c, OV2650_ISP_CTL_0, &v);
+       if (value & 0x01) {
+               v |= 0x10;
+               info->agc = SENSOR_AGC_AUTO;
+       } else {
+               v &= ~0x10;
+               info->agc = SENSOR_AGC_OFF;
+       }
+       ret += ov2650_write(c, OV2650_ISP_CTL_0, v);
+       msleep(10);  /* FIXME */
+
+       return ret;
+}
+
+static int ov2650_q_agc(struct i2c_client *c, int *value)
+{
+       int ret;
+       unsigned char v;
+
+       ret = ov2650_read(c, OV2650_ISP_CTL_0, &v);
+       *value = (v & 0x10) == 0x10;
+       return ret;
+}
+
+static int ov2650_t_blc(struct i2c_client *c, int value)
+{
+       unsigned char v;
+       int ret;
+
+       value = value >= 1 ? 1 : 0;
+
+       ret = ov2650_read(c, OV2650_BLCC, &v);
+       if (value & 0x01)
+               v |= 0x10;
+       else
+               v &= ~0x10;
+       ret += ov2650_write(c, OV2650_BLCC, v);
+       msleep(10);  /* FIXME */
+
+       return ret;
+}
+
+static int ov2650_q_blc(struct i2c_client *c, int *value)
+{
+       int ret;
+       unsigned char v;
+
+       ret = ov2650_read(c, OV2650_BLCC, &v);
+       *value = (v & 0x10) == 0x10;
+       return ret;
+}
+
+static struct ov2650_control {
+       struct ci_sensor_parm parm;
+       int (*query)(struct i2c_client *c, __s32 *value);
+       int (*tweak)(struct i2c_client *c, int value);
+} ov2650_controls[] = {
+       {
+               .parm = {
+                       .index = V4L2_CID_VFLIP,
+                       .type = V4L2_CTRL_TYPE_BOOLEAN,
+                       .name = "Vertical flip",
+                       .min = 0,
+                       .max = 1,
+                       .step = 1,
+                       .def_value = 0,
+               },
+               .tweak = ov2650_t_vflip,
+               .query = ov2650_q_vflip,
+       },
+       {
+               .parm = {
+                       .index = V4L2_CID_HFLIP,
+                       .type = V4L2_CTRL_TYPE_BOOLEAN,
+                       .name = "Horizontal mirror",
+                       .min = 0,
+                       .max = 1,
+                       .step = 1,
+                       .def_value = 0,
+               },
+               .tweak = ov2650_t_hflip,
+               .query = ov2650_q_hflip,
+       },
+       {
+               .parm = {
+                       .index = V4L2_CID_AUTO_WHITE_BALANCE,
+                       .type = V4L2_CTRL_TYPE_BOOLEAN,
+                       .name = "Auto White Balance",
+                       .min = 0,
+                       .max = 1,
+                       .step = 1,
+                       .def_value = 1,
+               },
+               .tweak = ov2650_t_awb,
+               .query = ov2650_q_awb,
+       },
+       {
+               .parm = {
+                       .index = V4L2_CID_AUTOGAIN,
+                       .type = V4L2_CTRL_TYPE_BOOLEAN,
+                       .name = "Auto Gain Control",
+                       .min = 0,
+                       .max = 1,
+                       .step = 1,
+                       .def_value = 1,
+               },
+               .tweak = ov2650_t_agc,
+               .query = ov2650_q_agc,
+
+       },
+       {
+               .parm = {
+                       .index = V4L2_CID_BLACK_LEVEL,
+                       .type = V4L2_CTRL_TYPE_BOOLEAN,
+                       .name = "Black Level Control",
+                       .min = 0,
+                       .max = 1,
+                       .step = 1,
+                       .def_value = 1,
+               },
+               .tweak = ov2650_t_blc,
+               .query = ov2650_q_blc,
+
+       },
+};
+#define N_CONTROLS (ARRAY_SIZE(ov2650_controls))
+
+static struct ov2650_control *ov2650_find_control(__u32 id)
+{
+       int i;
+
+       for (i = 0; i < N_CONTROLS; i++)
+               if (ov2650_controls[i].parm.index == id)
+                       return ov2650_controls + i;
+       return NULL;
+}
+
+static int ov2650_queryctrl(struct i2c_client *client,
+                           struct ci_sensor_parm *parm)
+{
+       struct ov2650_control *ctrl = ov2650_find_control(parm->index);
+
+       if (ctrl == NULL)
+               return -EINVAL;
+       *parm = ctrl->parm;
+       return 0;
+}
+
+static int ov2650_g_ctrl(struct i2c_client *client, struct ci_sensor_parm *parm)
+{
+       struct ov2650_control *octrl = ov2650_find_control(parm->index);
+       int ret;
+
+       if (octrl == NULL)
+               return -EINVAL;
+       ret = octrl->query(client, &parm->value);
+       if (ret >= 0)
+               return 0;
+       return ret;
+}
+
+static int ov2650_s_ctrl(struct i2c_client *client, struct ci_sensor_parm *parm)
+{
+       struct ov2650_control *octrl = ov2650_find_control(parm->index);
+       int ret;
+
+       if (octrl == NULL)
+               return -EINVAL;
+       ret =  octrl->tweak(client, parm->value);
+       if (ret >= 0)
+               return 0;
+       return ret;
+}
+
+static int ov2650_get_caps(struct i2c_client *c, struct ci_sensor_caps *caps)
+{
+       if (caps == NULL)
+               return -EIO;
+
+       caps->bus_width = SENSOR_BUSWIDTH_8BIT_ZZ;
+       caps->mode      = SENSOR_MODE_BT601;
+       caps->field_inv = SENSOR_FIELDINV_NOSWAP;
+       caps->field_sel = SENSOR_FIELDSEL_BOTH;
+       caps->ycseq     = SENSOR_YCSEQ_YCBYCR;
+       caps->conv422   = SENSOR_CONV422_COSITED;
+       caps->bpat      = SENSOR_BPAT_BGBGGRGR;
+       caps->hpol      = SENSOR_HPOL_REFPOS;
+       caps->vpol      = SENSOR_VPOL_POS;
+       caps->edge      = SENSOR_EDGE_RISING;
+       caps->bls       = SENSOR_BLS_OFF;
+       caps->gamma     = SENSOR_GAMMA_ON;
+       caps->cconv     = SENSOR_CCONV_ON;
+       caps->res       = SENSOR_RES_UXGA | SENSOR_RES_SXGA | SENSOR_RES_SVGA
+           | SENSOR_RES_VGA | SENSOR_RES_QVGA;
+       caps->blc       = SENSOR_BLC_AUTO;
+       caps->agc       = SENSOR_AGC_AUTO;
+       caps->awb       = SENSOR_AWB_AUTO;
+       caps->aec       = SENSOR_AEC_AUTO;
+       caps->cie_profile       = 0;
+       caps->flicker_freq      = SENSOR_FLICKER_100 | SENSOR_FLICKER_120;
+       caps->type      = SENSOR_TYPE_SOC;
+       /* caps->name   = "ov2650"; */
+       strcpy(caps->name, "ov2650");
+
+       return 0;
+}
+
+static int ov2650_get_config(struct i2c_client *c,
+                            struct ci_sensor_config *config)
+{
+       struct ci_sensor_config *info = i2c_get_clientdata(c);
+
+       if (config == NULL) {
+               printk(KERN_WARNING "sensor_get_config: NULL pointer\n");
+               return -EIO;
+       }
+
+       memcpy(config, info, sizeof(struct ci_sensor_config));
+
+       return 0;
+}
+
+static int ov2650_setup(struct i2c_client *c,
+                       const struct ci_sensor_config *config)
+{
+       int ret;
+       struct ov2650_res_struct *res_index;
+       struct ci_sensor_config *info = i2c_get_clientdata(c);
+       u16 width, high;
+
+       /* Soft reset camera first*/
+       ret = ov2650_write(c, OV2650_SYS, 0x80);
+
+       /* Set registers into default config value */
+       ret += ov2650_write_array(c, ov2650_def_reg);
+
+       /* set image resolution */
+       ci_sensor_res2size(config->res, &width, &high);
+       ret += ov2650_try_res(c, &width, &high);
+       res_index = ov2650_find_res(width, high);
+       if (res_index->regs)
+               ret += ov2650_write_array(c, res_index->regs);
+       if (!ret)
+               info->res = res_index->res;
+
+
+       if (config->blc != info->blc) {
+               ret += ov2650_t_blc(c, config->blc);
+               info->blc = config->blc;
+       }
+
+       if (config->agc != info->agc) {
+               ret += ov2650_t_agc(c, config->agc);
+               info->agc = config->agc;
+       }
+
+       if (config->awb != info->awb) {
+               ret += ov2650_t_awb(c, config->awb);
+               info->awb = config->awb;
+       }
+       /* Add some delay here to get a better image*/
+       ssleep(2);
+
+       return ret;
+}
+
+/*
+ * File operation functions
+ */
+static int ov2650_open(struct i2c_setting *c, void *priv)
+{
+       struct i2c_client *client = c->sensor_client;
+       /* Just wake up sensor */
+       if (ov2650_wakeup())
+               return -EIO;
+       ov2650_init(client);
+       /*Sleep sensor now*/
+       ov2650_write(client, 0x3086, 0x01);
+       return 0;
+}
+
+static int ov2650_release(struct i2c_setting *c, void *priv)
+{
+       /* Just suspend the sensor */
+       if (ov2650_standby())
+               return EIO;
+       return 0;
+}
+
+static int ov2650_on(struct i2c_setting *c)
+{
+       /* Software wake up sensor */
+       return ov2650_write(c->sensor_client, 0x3086, 0x00);
+}
+
+static int ov2650_off(struct i2c_setting *c)
+{
+       /* Software standby sensor */
+       return ov2650_write(c->sensor_client, 0x3086, 0x01);
+}
+
+static struct sensor_device ov2650 = {
+       .name   = "OV2650",
+       .type   = SENSOR_TYPE_SOC,
+       .minor  = -1,
+       .open   = ov2650_open,
+       .release = ov2650_release,
+       .on = ov2650_on,
+       .off = ov2650_off,
+       .querycap = ov2650_get_caps,
+       .get_config = ov2650_get_config,
+       .set_config = ov2650_setup,
+       .enum_parm = ov2650_queryctrl,
+       .get_parm = ov2650_g_ctrl,
+       .set_parm = ov2650_s_ctrl,
+       .try_res = ov2650_try_res,
+       .set_res = ov2650_set_res,
+       .suspend = ov2650_standby,
+       .resume = ov2650_wakeup,
+       .get_ls_corr_config = NULL,
+       .set_awb = NULL,
+       .set_aec = NULL,
+       .set_blc = NULL,
+       /* TBC */
+};
+
+/*
+ * Basic i2c stuff
+ */
+static unsigned short normal_i2c[] = {I2C_OV2650 >> 1, I2C_CLIENT_END};
+I2C_CLIENT_INSMOD;
+
+static struct i2c_driver ov2650_driver;
+static int ov2650_detect(struct i2c_client *client, int kind,
+                        struct i2c_board_info *info)
+{
+       struct i2c_adapter *adapter = client->adapter;
+       int adap_id = i2c_adapter_id(adapter);
+       const char *name = "";
+       u8 value;
+
+       if (!i2c_check_functionality(adapter, I2C_FUNC_I2C))
+               return -ENODEV;
+
+       if (adap_id != 1)
+               return -ENODEV;
+
+       if (ov2650_wakeup())
+               return -ENODEV;
+
+       ov2650_read(client, OV2650_PID_L, &value);
+       if (value != 0x52)
+               return -ENODEV;
+
+       name = "i2c_ov2650";
+       strlcpy(info->type, name, I2C_NAME_SIZE);
+
+       return 0;
+}
+
+static int ov2650_probe(struct i2c_client *client,
+                       const struct i2c_device_id *id)
+{
+       int ret = -1;
+       struct ci_sensor_config *info;
+       struct i2c_setting *ov2650_i2c;
+
+       /*
+        * Setup sensor configuration structure
+        */
+       info = kzalloc(sizeof(struct ci_sensor_config), GFP_KERNEL);
+       if (!info) {
+               ret = -ENOMEM;
+               goto err_1;
+       }
+
+       i2c_set_clientdata(client, info);
+       ov2650_i2c = kzalloc(sizeof(struct i2c_setting), GFP_KERNEL);
+       if (!ov2650_i2c) {
+               ret = -ENOMEM;
+               goto err_2;
+       }
+       ov2650_i2c->sensor_client = client;
+       ov2650_i2c->motor_client = NULL;
+
+       ov2650.i2c = ov2650_i2c;
+       ret = sensor_register_device(&ov2650, ov2650.type);
+       if (ret)
+               goto err_3;
+
+       /*
+        * Initialization OV2650
+        * then turn into standby mode
+        */
+       ret = ov2650_standby();
+       if (ret)
+               goto err_4;
+       printk(KERN_INFO "Init ov2650 sensor success\n");
+       return 0;
+
+err_4:
+       sensor_unregister_device(&ov2650);
+err_3:
+       kfree(ov2650_i2c);
+err_2:
+       kfree(info);
+err_1:
+       return ret;
+}
+
+/*
+ * XXX: Need to be checked
+ */
+static int ov2650_remove(struct i2c_client *client)
+{
+       kfree(i2c_get_clientdata(client));
+       sensor_unregister_device(&ov2650);
+       return 0;
+}
+
+static const struct i2c_device_id ov2650_id[] = {
+       {"i2c_ov2650", 0},
+       {}
+};
+
+static struct i2c_driver ov2650_driver = {
+       .driver = {
+               .name = "i2c_ov2650",
+       },
+       .probe = ov2650_probe,
+       .remove = ov2650_remove,
+       .id_table = ov2650_id,
+
+       .class = I2C_CLASS_HWMON,
+       .detect = ov2650_detect,
+       .address_data = &addr_data,
+};
+
+static int __init ov2650_mod_init(void)
+{
+       printk(KERN_WARNING "OmniVision 2650 sensor driver, initialization.\n");
+       return i2c_add_driver(&ov2650_driver);
+}
+
+static void __exit ov2650_mod_exit(void)
+{
+       i2c_del_driver(&ov2650_driver);
+}
+
+module_init(ov2650_mod_init);
+module_exit(ov2650_mod_exit);
+
+MODULE_AUTHOR("Xiaolin Zhang <xiaolin.zhang@intel.com>");
+MODULE_DESCRIPTION("A low-level driver for OmniVision 2650 sensors");
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/video/mrstci/mrstov2650/ov2650.h b/drivers/media/video/mrstci/mrstov2650/ov2650.h
new file mode 100644
index 0000000..b713a00
--- /dev/null
+++ b/drivers/media/video/mrstci/mrstov2650/ov2650.h
@@ -0,0 +1,716 @@
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
+#define I2C_OV2650     0x60
+/* Should add to kernel source */
+#define I2C_DRIVERID_OV2650    1047
+/* GPIO pin on Moorestown */
+#define GPIO_SCLK_25   44
+#define GPIO_STB_PIN   47
+#define GPIO_STDBY_PIN 48
+#define GPIO_RESET_PIN 50
+
+/* System control register */
+#define OV2650_AGC             0x3000
+#define OV2650_AGCS    0x3001
+#define OV2650_AEC_H   0x3002
+#define OV2650_AEC_L   0x3003
+#define OV2650_AECL    0x3004
+#define OV2650_AECS_H  0x3008
+#define OV2650_AECS_L  0x3009
+#define OV2650_PID_H   0x300A
+#define OV2650_PID_L   0x300B
+#define OV2650_SCCB            0x300C
+#define OV2650_PCLK            0x300D
+#define OV2650_PLL_1   0x300E
+#define OV2650_PLL_2   0x300F
+#define OV2650_PLL_3   0x3010
+#define OV2650_CLK             0x3011
+#define OV2650_SYS             0x3012
+#define OV2650_AUTO_1  0x3013
+#define OV2650_AUTO_2  0x3014
+#define OV2650_AUTO_3  0x3015
+#define OV2650_AUTO_4  0x3016
+#define OV2650_AUTO_5  0x3017
+#define OV2650_WPT             0x3018
+#define OV2650_BPT             0x3019
+#define OV2650_VPT             0x301A
+#define OV2650_YAVG            0x301B
+#define OV2650_AECG_50 0x301C
+#define OV2650_AECG_60 0x301D
+#define OV2650_RZM_H   0x301E
+#define OV2650_RZM_L   0x301F
+#define OV2650_HS_H            0x3020
+#define OV2650_HS_L            0x3021
+#define OV2650_VS_H            0x3022
+#define OV2650_VS_L            0x3023
+#define OV2650_HW_H            0x3024
+#define OV2650_HW_L            0x3025
+#define OV2650_VH_H            0x3026
+#define OV2650_VH_L            0x3027
+#define OV2650_HTS_H   0x3028
+#define OV2650_HTS_L   0x3029
+#define OV2650_VTS_H   0x302A
+#define OV2650_VTS_L   0x302B
+#define OV2650_EXHTS   0x302C
+#define OV2650_EXVTS_H 0x302D
+#define OV2650_EXVTS_L 0x302E
+#define OV2650_WET_0   0x3030
+#define OV2650_WET_1   0x3031
+#define OV2650_WET_2   0x3032
+#define OV2650_WET_3   0x3033
+#define OV2650_AHS_H   0x3038
+#define OV2650_AHS_L   0x3039
+#define OV2650_AVS_H   0x303A
+#define OV2650_AVS_L   0x303B
+#define OV2650_AHW_H   0x303C
+#define OV2650_AHW_L   0x303D
+#define OV2650_AVH_H   0x303E
+#define OV2650_AVH_L   0x303F
+#define OV2650_HISTO_0 0x3040
+#define OV2650_HISTO_1 0x3041
+#define OV2650_HISTO_2 0x3042
+#define OV2650_HISTO_3 0x3043
+#define OV2650_HISTO_4 0x3044
+#define OV2650_BLC9A   0x3069
+#define OV2650_BLCC            0x306C
+#define OV2650_BLCD            0x306D
+#define OV2650_BLCF            0x306F
+#define OV2650_BD50_L  0x3070
+#define OV2650_BD50_H  0x3071
+#define OV2650_BD60_L  0x3072
+#define OV2650_BD60_H  0x3073
+#define OV2650_TMC_0   0x3076
+#define OV2650_TMC_1   0x3077
+#define OV2650_TMC_2   0x3078
+#define OV2650_TMC_4   0x307A
+#define OV2650_TMC_6   0x307C
+#define OV2650_TMC_8   0x307E
+#define OV2650_TMC_I2C 0x3084
+#define OV2650_TMC_10  0x3086
+#define OV2650_TMC_11  0x3087
+#define OV2650_ISP_XO_H        0x3088
+#define OV2650_ISP_XO_L        0x3089
+#define OV2650_ISP_YO_H        0x308A
+#define OV2650_ISP_YO_L        0x308B
+#define OV2650_TMC_12  0x308C
+#define OV2650_TMC_13  0x308D
+#define OV2650_EFUSE   0x308F
+#define OV2650_IO_CTL_0        0x30B0
+#define OV2650_IO_CRL_1 0x30B1
+#define OV2650_IO_CTL_2 0x30B2
+#define OV2650_LAEC            0x30F0
+#define OV2650_GRP_EOP 0x30FF
+
+/* SC registers */
+#define OV2650_SC_CTL_0        0x3100
+#define OV2650_SC_SYN_CTL_0 0x3104
+#define OV2650_SC_SYN_CTL_1 0x3105
+#define OV2650_SC_SYN_CTL_3 0x3107
+#define OV2650_SC_SYN_CTL_4 0x3108
+
+/* DSP control register */
+#define OV2650_ISP_CTL_0       0x3300
+#define OV2650_ISP_CTL_1       0x3301
+#define OV2650_ISP_CTL_2       0x3302
+#define OV2650_ISP_CTL_3       0x3303
+#define OV2650_ISP_CTL_4       0x3304
+#define OV2650_ISP_CTL_5       0x3305
+#define OV2650_ISP_CTL_6       0x3306
+#define OV2650_ISP_CTL_7       0x3307
+#define OV2650_ISP_CTL_8       0x3308
+#define OV2650_ISP_CTL_9       0x3309
+#define OV2650_ISP_CTL_A       0x330A
+#define OV2650_ISP_CTL_B       0x330B
+#define OV2650_ISP_CTL_10      0x3310
+#define OV2650_ISP_CTL_11      0x3311
+#define OV2650_ISP_CTL_12      0x3312
+#define OV2650_ISP_CTL_13      0x3313
+#define OV2650_ISP_CTL_14      0x3314
+#define OV2650_ISP_CTL_15      0x3315
+#define OV2650_ISP_CTL_16      0x3316
+#define OV2650_ISP_CTL_17      0x3317
+#define OV2650_ISP_CTL_18      0x3318
+#define OV2650_ISP_CTL_19      0x3319
+#define OV2650_ISP_CTL_1A      0x331A
+#define OV2650_ISP_CTL_1B      0x331B
+#define OV2650_ISP_CTL_1C      0x331C
+#define OV2650_ISP_CTL_1D      0x331D
+#define OV2650_ISP_CTL_1E      0x331E
+#define OV2650_ISP_CTL_20      0x3320
+#define OV2650_ISP_CTL_21      0x3321
+#define OV2650_ISP_CTL_22      0x3322
+#define OV2650_ISP_CTL_23      0x3323
+#define OV2650_ISP_CTL_24      0x3324
+#define OV2650_ISP_CTL_27      0x3327
+#define OV2650_ISP_CTL_28      0x3328
+#define OV2650_ISP_CTL_29      0x3329
+#define OV2650_ISP_CTL_2A      0x332A
+#define OV2650_ISP_CTL_2B      0x332B
+#define OV2650_ISP_CTL_2C      0x332C
+#define OV2650_ISP_CTL_2D      0x332D
+#define OV2650_ISP_CTL_2E      0x332E
+#define OV2650_ISP_CTL_2F      0x332F
+#define OV2650_ISP_CTL_30      0x3330
+#define OV2650_ISP_CTL_31      0x3331
+#define OV2650_ISP_CTL_32      0x3332
+#define OV2650_ISP_CTL_33      0x3333
+#define OV2650_ISP_CTL_34      0x3334
+#define OV2650_ISP_CTL_35      0x3335
+#define OV2650_ISP_CTL_36      0x3336
+#define OV2650_ISP_CTL_40      0x3340
+#define OV2650_ISP_CTL_41      0x3341
+#define OV2650_ISP_CTL_42      0x3342
+#define OV2650_ISP_CTL_43      0x3343
+#define OV2650_ISP_CTL_44      0x3344
+#define OV2650_ISP_CTL_45      0x3345
+#define OV2650_ISP_CTL_46      0x3346
+#define OV2650_ISP_CTL_47      0x3347
+#define OV2650_ISP_CTL_48      0x3348
+#define OV2650_ISP_CTL_49      0x3349
+#define OV2650_ISP_CTL_4A      0x334A
+#define OV2650_ISP_CTL_4B      0x334B
+#define OV2650_ISP_CTL_4C      0x334C
+#define OV2650_ISP_CTL_4D      0x334D
+#define OV2650_ISP_CTL_4E      0x334E
+#define OV2650_ISP_CTL_4F      0x334F
+#define OV2650_ISP_CTL_50      0x3350
+#define OV2650_ISP_CTL_51      0x3351
+#define OV2650_ISP_CTL_52      0x3352
+#define OV2650_ISP_CTL_53      0x3353
+#define OV2650_ISP_CTL_54      0x3354
+#define OV2650_ISP_CTL_55      0x3355
+#define OV2650_ISP_CTL_56      0x3356
+#define OV2650_ISP_CTL_57      0x3357
+#define OV2650_ISP_CTL_58      0x3358
+#define OV2650_ISP_CTL_59      0x3359
+#define OV2650_ISP_CTL_5A      0x335A
+#define OV2650_ISP_CTL_5B      0x335B
+#define OV2650_ISP_CTL_5C      0x335C
+#define OV2650_ISP_CTL_5D      0x335D
+#define OV2650_ISP_CTL_5E      0x335E
+#define OV2650_ISP_CTL_5F      0x335F
+#define OV2650_ISP_CTL_60      0x3360
+#define OV2650_ISP_CTL_61      0x3361
+#define OV2650_ISP_CTL_62      0x3362
+#define OV2650_ISP_CTL_63      0x3363
+#define OV2650_ISP_CTL_64      0x3364
+#define OV2650_ISP_CTL_65      0x3365
+#define OV2650_ISP_CTL_6A      0x336A
+#define OV2650_ISP_CTL_6B      0x336B
+#define OV2650_ISP_CTL_6C      0x336C
+#define OV2650_ISP_CTL_6E      0x336E
+#define OV2650_ISP_CTL_71      0x3371
+#define OV2650_ISP_CTL_72      0x3372
+#define OV2650_ISP_CTL_73      0x3373
+#define OV2650_ISP_CTL_74      0x3374
+#define OV2650_ISP_CTL_75      0x3375
+#define OV2650_ISP_CTL_76      0x3376
+#define OV2650_ISP_CTL_77      0x3377
+#define OV2650_ISP_CTL_78      0x3378
+#define OV2650_ISP_CTL_79      0x3379
+#define OV2650_ISP_CTL_7A      0x337A
+#define OV2650_ISP_CTL_7B      0x337B
+#define OV2650_ISP_CTL_7C      0x337C
+#define OV2650_ISP_CTL_80      0x3380
+#define OV2650_ISP_CTL_81      0x3381
+#define OV2650_ISP_CTL_82      0x3382
+#define OV2650_ISP_CTL_83      0x3383
+#define OV2650_ISP_CTL_84      0x3384
+#define OV2650_ISP_CTL_85      0x3385
+#define OV2650_ISP_CTL_86      0x3386
+#define OV2650_ISP_CTL_87      0x3387
+#define OV2650_ISP_CTL_88      0x3388
+#define OV2650_ISP_CTL_89      0x3389
+#define OV2650_ISP_CTL_8A      0x338A
+#define OV2650_ISP_CTL_8B      0x338B
+#define OV2650_ISP_CTL_8C      0x338C
+#define OV2650_ISP_CTL_8D      0x338D
+#define OV2650_ISP_CTL_8E      0x338E
+#define OV2650_ISP_CTL_90      0x3390
+#define OV2650_ISP_CTL_91      0x3391
+#define OV2650_ISP_CTL_92      0x3392
+#define OV2650_ISP_CTL_93      0x3393
+#define OV2650_ISP_CTL_94      0x3394
+#define OV2650_ISP_CTL_95      0x3395
+#define OV2650_ISP_CTL_96      0x3396
+#define OV2650_ISP_CTL_97      0x3397
+#define OV2650_ISP_CTL_98      0x3398
+#define OV2650_ISP_CTL_99      0x3399
+#define OV2650_ISP_CTL_9A      0x339A
+#define OV2650_ISP_CTL_A0      0x33A0
+#define OV2650_ISP_CTL_A1      0x33A1
+#define OV2650_ISP_CTL_A2      0x33A2
+#define OV2650_ISP_CTL_A3      0x33A3
+#define OV2650_ISP_CTL_A4      0x33A4
+#define OV2650_ISP_CTL_A5      0x33A5
+#define OV2650_ISP_CTL_A6      0x33A6
+#define OV2650_ISP_CTL_A7      0x33A7
+#define OV2650_ISP_CTL_A8      0x33A8
+#define OV2650_ISP_CTL_AA      0x33AA
+#define OV2650_ISP_CTL_AB      0x33AB
+#define OV2650_ISP_CTL_AC      0x33AC
+#define OV2650_ISP_CTL_AD      0x33AD
+#define OV2650_ISP_CTL_AE      0x33AE
+#define OV2650_ISP_CTL_AF      0x33AF
+#define OV2650_ISP_CTL_B0      0x33B0
+#define OV2650_ISP_CTL_B1      0x33B1
+#define OV2650_ISP_CTL_B2      0x33B2
+#define OV2650_ISP_CTL_B3      0x33B3
+#define OV2650_ISP_CTL_B4      0x33B4
+#define OV2650_ISP_CTL_B5      0x33B5
+#define OV2650_ISP_CTL_B6      0x33B6
+#define OV2650_ISP_CTL_B7      0x33B7
+#define OV2650_ISP_CTL_B8      0x33B8
+#define OV2650_ISP_CTL_B9      0x33B9
+
+/* Format register */
+#define OV2650_FMT_CTL_0       0x3400
+#define OV2650_FMT_CTL_1       0x3401
+#define OV2650_FMT_CTL_2       0x3402
+#define OV2650_FMT_CTL_3       0x3403
+#define OV2650_FMT_CTL_4       0x3404
+#define OV2650_FMT_CTL_5       0x3405
+#define OV2650_FMT_CTL_6       0x3406
+#define OV2650_FMT_CTL_7       0x3407
+#define OV2650_FMT_CTL_8       0x3408
+#define OV2650_DITHER_CTL      0x3409
+#define OV2650_DVP_CTL_0       0x3600
+#define OV2650_DVP_CTL_1       0x3601
+#define OV2650_DVP_CTL_6       0x3606
+#define OV2650_DVP_CTL_7       0x3607
+#define OV2650_DVP_CTL_9       0x3609
+#define OV2650_DVP_CTL_B       0x360B
+
+/* General definition for ov2650 */
+#define OV2650_OUTWND_MAX_H            UXGA_SIZE_H
+#define OV2650_OUTWND_MAX_V            UXGA_SIZE_V
+
+struct regval_list {
+       u16 reg_num;
+       u8 value;
+};
+
+/*
+ * Default register value
+ * 1600x1200 YUV
+ */
+static struct regval_list ov2650_def_reg[] = {
+       {0x3012, 0x80},
+       {0x308c, 0x80},
+       {0x308d, 0x0e},
+       {0x360b, 0x00},
+       {0x30b0, 0xff},
+       {0x30b1, 0xff},
+       {0x30b2, 0x24},
+
+       {0x300e, 0x34},
+       {0x300f, 0xa6},
+       {0x3010, 0x81},
+       {0x3082, 0x01},
+       {0x30f4, 0x01},
+       {0x3090, 0x33},
+       {0x3091, 0xc0},
+       {0x30ac, 0x42},
+
+       {0x30d1, 0x08},
+       {0x30a8, 0x56},
+       {0x3015, 0x03},
+       {0x3093, 0x00},
+       {0x307e, 0xe5},
+       {0x3079, 0x00},
+       {0x30aa, 0x42},
+       {0x3017, 0x40},
+       {0x30f3, 0x82},
+       {0x306a, 0x0c},
+       {0x306d, 0x00},
+       {0x336a, 0x3c},
+       {0x3076, 0x6a},
+       {0x30d9, 0x8c},
+       {0x3016, 0x82},
+       {0x3601, 0x30},
+       {0x304e, 0x88},
+       {0x30f1, 0x82},
+       {0x3011, 0x02},
+
+       {0x3013, 0xf7},
+       {0x301c, 0x13},
+       {0x301d, 0x17},
+       {0x3070, 0x3e},
+       {0x3072, 0x34},
+
+       {0x30af, 0x00},
+       {0x3048, 0x1f},
+       {0x3049, 0x4e},
+       {0x304a, 0x20},
+       {0x304f, 0x20},
+       {0x304b, 0x02},
+       {0x304c, 0x00},
+       {0x304d, 0x02},
+       {0x304f, 0x20},
+       {0x30a3, 0x10},
+       {0x3013, 0xf7},
+       {0x3014, 0x44},
+       {0x3071, 0x00},
+       {0x3070, 0x3e},
+       {0x3073, 0x00},
+       {0x3072, 0x34},
+       {0x301c, 0x12},
+       {0x301d, 0x16},
+       {0x304d, 0x42},
+       {0x304a, 0x40},
+       {0x304f, 0x40},
+       {0x3095, 0x07},
+       {0x3096, 0x16},
+       {0x3097, 0x1d},
+
+       {0x3020, 0x01},
+       {0x3021, 0x18},
+       {0x3022, 0x00},
+       {0x3023, 0x0a},
+       {0x3024, 0x06},
+       {0x3025, 0x58},
+       {0x3026, 0x04},
+       {0x3027, 0xbc},
+       {0x3088, 0x06},
+       {0x3089, 0x40},
+       {0x308a, 0x04},
+       {0x308b, 0xb0},
+       {0x3316, 0x64},
+       {0x3317, 0x4b},
+       {0x3318, 0x00},
+       {0x331a, 0x64},
+       {0x331b, 0x4b},
+       {0x331c, 0x00},
+       {0x3100, 0x00},
+
+       {0x3320, 0xfa},
+       {0x3321, 0x11},
+       {0x3322, 0x92},
+       {0x3323, 0x01},
+       {0x3324, 0x97},
+       {0x3325, 0x02},
+       {0x3326, 0xff},
+       {0x3327, 0x0c},
+       {0x3328, 0x10},
+       {0x3329, 0x10},
+       {0x332a, 0x58},
+       {0x332b, 0x50},
+       {0x332c, 0xbe},
+       {0x332d, 0xe1},
+       {0x332e, 0x43},
+       {0x332f, 0x36},
+       {0x3330, 0x4d},
+       {0x3331, 0x44},
+       {0x3332, 0xf8},
+       {0x3333, 0x0a},
+       {0x3334, 0xf0},
+       {0x3335, 0xf0},
+       {0x3336, 0xf0},
+       {0x3337, 0x40},
+       {0x3338, 0x40},
+       {0x3339, 0x40},
+       {0x333a, 0x00},
+       {0x333b, 0x00},
+
+       {0x3380, 0x28},
+       {0x3381, 0x48},
+       {0x3382, 0x10},
+       {0x3383, 0x23},
+       {0x3384, 0xc0},
+       {0x3385, 0xe5},
+       {0x3386, 0xc2},
+       {0x3387, 0xb3},
+       {0x3388, 0x0e},
+       {0x3389, 0x98},
+       {0x338a, 0x01},
+
+       {0x3340, 0x0e},
+       {0x3341, 0x1a},
+       {0x3342, 0x31},
+       {0x3343, 0x45},
+       {0x3344, 0x5a},
+       {0x3345, 0x69},
+       {0x3346, 0x75},
+       {0x3347, 0x7e},
+       {0x3348, 0x88},
+       {0x3349, 0x96},
+       {0x334a, 0xa3},
+       {0x334b, 0xaf},
+       {0x334c, 0xc4},
+       {0x334d, 0xd7},
+       {0x334e, 0xe8},
+       {0x334f, 0x20},
+
+       {0x3350, 0x32},
+       {0x3351, 0x25},
+       {0x3352, 0x80},
+       {0x3353, 0x1e},
+       {0x3354, 0x00},
+       {0x3355, 0x85},
+       {0x3356, 0x32},
+       {0x3357, 0x25},
+       {0x3358, 0x80},
+       {0x3359, 0x1b},
+       {0x335a, 0x00},
+       {0x335b, 0x85},
+       {0x335c, 0x32},
+       {0x335d, 0x25},
+       {0x335e, 0x80},
+       {0x335f, 0x1b},
+       {0x3360, 0x00},
+       {0x3361, 0x85},
+       {0x3363, 0x70},
+       {0x3364, 0x7f},
+       {0x3365, 0x00},
+       {0x3366, 0x00},
+
+       {0x3301, 0xff},
+       {0x338B, 0x11},
+       {0x338c, 0x10},
+       {0x338d, 0x40},
+
+       {0x3370, 0xd0},
+       {0x3371, 0x00},
+       {0x3372, 0x00},
+       {0x3373, 0x40},
+       {0x3374, 0x10},
+       {0x3375, 0x10},
+       {0x3376, 0x04},
+       {0x3377, 0x00},
+       {0x3378, 0x04},
+       {0x3379, 0x80},
+
+       {0x3069, 0x84},
+       {0x307c, 0x10},
+       {0x3087, 0x02},
+
+       {0x3300, 0xfc},
+       {0x3302, 0x01},
+       {0x3400, 0x00},
+       {0x3606, 0x20},
+       {0x3601, 0x30},
+       {0x30f3, 0x83},
+       {0x304e, 0x88},
+
+       {0x3086, 0x0f},
+       {0x3086, 0x00},
+
+       {0xffff, 0xff},
+};
+
+/* 800x600 */
+static struct regval_list ov2650_res_svga[] = {
+
+       {0x306f, 0x14},
+       {0x302a, 0x02},
+       {0x302b, 0x84},
+       {0x3012, 0x10},
+       {0x3011, 0x01},
+
+       {0x3070, 0x5d},
+       {0x3072, 0x4d},
+
+       {0x3014, 0x84},
+       {0x301c, 0x07},
+       {0x301d, 0x09},
+       {0x3070, 0x50},
+       {0x3071, 0x00},
+       {0x3072, 0x42},
+       {0x3073, 0x00},
+
+       {0x3020, 0x01},
+       {0x3021, 0x18},
+       {0x3022, 0x00},
+       {0x3023, 0x06},
+       {0x3024, 0x06},
+       {0x3025, 0x58},
+       {0x3026, 0x02},
+       {0x3027, 0x5e},
+       {0x3088, 0x03},
+       {0x3089, 0x20},
+       {0x308a, 0x02},
+       {0x308b, 0x58},
+       {0x3316, 0x64},
+       {0x3317, 0x25},
+       {0x3318, 0x80},
+       {0x3319, 0x08},
+       {0x331a, 0x64},
+       {0x331b, 0x4b},
+       {0x331c, 0x00},
+       {0x331d, 0x38},
+       {0x3100, 0x00},
+
+       {0x3302, 0x11},
+
+       {0x3011, 0x01},
+       {0x300f, 0xa6},
+       {0x300e, 0x36},
+       {0x3010, 0x81},
+       {0x302e, 0x00},
+       {0x302d, 0x00},
+       {0x302c, 0x00},
+       {0x302b, 0x84},
+       {0x3014, 0x84},
+       {0x301c, 0x07},
+       {0x301d, 0x09},
+       {0x3070, 0x50},
+       {0x3071, 0x00},
+       {0x3072, 0x42},
+       {0x3073, 0x00},
+
+       {0x3086, 0x0f},
+       {0x3086, 0x00},
+       {0xffff, 0xff},
+};
+
+/* 640x480 */
+static struct regval_list ov2650_res_vga_vario[] = {
+       {0x306f, 0x14},
+       {0x302a, 0x02},
+       {0x302b, 0x6a},
+       {0x3012, 0x10},
+       {0x3011, 0x01},
+
+       {0x3070, 0x5d},
+       {0x3072, 0x4d},
+
+       {0x301c, 0x05},
+       {0x301d, 0x06},
+
+       {0x3020, 0x01},
+       {0x3021, 0x18},
+       {0x3022, 0x00},
+       {0x3023, 0x06},
+       {0x3024, 0x06},
+       {0x3025, 0x58},
+       {0x3026, 0x02},
+       {0x3027, 0x61},
+       {0x3088, 0x02},
+       {0x3089, 0x80},
+       {0x308a, 0x01},
+       {0x308b, 0xe0},
+       {0x3316, 0x64},
+       {0x3317, 0x25},
+       {0x3318, 0x80},
+       {0x3319, 0x08},
+       {0x331a, 0x28},
+       {0x331b, 0x1e},
+       {0x331c, 0x00},
+       {0x331d, 0x38},
+       {0x3100, 0x00},
+
+       {0x3302, 0x11},
+       {0x3011, 0x00},
+
+       {0x3086, 0x0f},
+       {0x3086, 0x00},
+       {0xffff, 0xff},
+};
+
+/* 320x240 */
+static struct regval_list ov2650_res_qvga[] = {
+       {0x306f, 0x14},
+       {0x302a, 0x02},
+       {0x301b, 0x6a},
+
+       {0x3012, 0x10},
+       {0x3011, 0x00},
+
+       {0x3070, 0x5d},
+       {0x3072, 0x4d},
+       {0x301c, 0x05},
+       {0x301d, 0x06},
+
+       {0x3023, 0x06},
+       {0x3026, 0x02},
+       {0x3027, 0x61},
+       {0x3088, 0x01},
+       {0x3089, 0x40},
+       {0x308a, 0x00},
+       {0x308b, 0xf0},
+       {0x3316, 0x64},
+       {0x3317, 0x25},
+       {0x3318, 0x80},
+       {0x3319, 0x08},
+       {0x331a, 0x14},
+       {0x331b, 0x0f},
+       {0x331c, 0x00},
+       {0x331d, 0x38},
+       {0x3100, 0x00},
+
+       {0x3302, 0x11},
+       {0x3086, 0x0f},
+       {0x3086, 0x00},
+       {0xffff, 0xff},
+};
+
+static struct regval_list ov2650_res_uxga[] = {
+       /* Note this this added by debug */
+       {0x3014, 0x84},
+       {0x301c, 0x13},
+       {0x301d, 0x17},
+       {0x3070, 0x40},
+       {0x3071, 0x00},
+       {0x3072, 0x36},
+       {0x3073, 0x00},
+
+       {0xffff, 0xff},
+};
+
+static struct regval_list ov2650_res_sxga[] = {
+       {0x3011, 0x02},
+
+       {0x3020, 0x01},
+       {0x3021, 0x18},
+       {0x3022, 0x00},
+       {0x3023, 0x0a},
+       {0x3024, 0x06},
+       {0x3025, 0x58},
+       {0x3026, 0x04},
+       {0x3027, 0xbc},
+       {0x3088, 0x05},
+       {0x3089, 0x00},
+       {0x308a, 0x04},
+       {0x308b, 0x00},
+       {0x3316, 0x64},
+       {0x3317, 0x4b},
+       {0x3318, 0x00},
+       {0x331a, 0x50},
+       {0x331b, 0x40},
+       {0x331c, 0x00},
+
+       {0x3302, 0x11},
+
+       {0x3014, 0x84},
+       {0x301c, 0x13},
+       {0x301d, 0x17},
+       {0x3070, 0x40},
+       {0x3071, 0x00},
+       {0x3072, 0x36},
+       {0x3073, 0x00},
+
+       {0x3086, 0x0f},
+       {0x3086, 0x00},
+       {0xffff, 0xff},
+};
--
1.5.5

