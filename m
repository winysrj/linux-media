Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:31934 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753319AbZD3I0K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Apr 2009 04:26:10 -0400
From: "Zhang, Xiaolin" <xiaolin.zhang@intel.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "Johnson, Charles F" <charles.f.johnson@intel.com>
Date: Thu, 30 Apr 2009 16:24:56 +0800
Subject: [PATCH 4/5] V4L2 patches for Intel Moorestown Camera Imaging Drivers
Message-ID: <0A882F4D99BBF6449D58E61AAFD7EDD61379393E@pdsmsx502.ccr.corp.intel.com>
References: <90b950fc0904292317m500820efv66755aed31b46853@mail.gmail.com>
 <5A47E75E594F054BAF48C5E4FC4B92AB030548BA1B@dbde02.ent.ti.com>    
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>From 115b53d1f5016363667cad629b327491d6a026da Mon Sep 17 00:00:00 2001
From: Xiaolin Zhang <xiaolin.zhang@intel.com>
Date: Thu, 30 Apr 2009 13:24:15 +0800
Subject: [PATCH] 5MP camera sensor driver (ov5630, RAW sensor) on Interl Moorestown
 platform.
 Signed-off-by: Xiaolin Zhang <xiaolin.zhang@intel.com>

---
 drivers/media/video/Makefile                       |    1 +
 drivers/media/video/mrstci/Kconfig                 |    2 +
 drivers/media/video/mrstci/mrstov5630/Kconfig      |    9 +
 drivers/media/video/mrstci/mrstov5630/Makefile     |    4 +
 drivers/media/video/mrstci/mrstov5630/ov5630.c     |  783 ++++++++++++++++++++
 drivers/media/video/mrstci/mrstov5630/ov5630.h     |  673 +++++++++++++++++
 .../media/video/mrstci/mrstov5630/ov5630_motor.c   |  212 ++++++
 .../media/video/mrstci/mrstov5630/ov5630_motor.h   |   79 ++
 8 files changed, 1763 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/mrstci/mrstov5630/Kconfig
 create mode 100644 drivers/media/video/mrstci/mrstov5630/Makefile
 create mode 100644 drivers/media/video/mrstci/mrstov5630/ov5630.c
 create mode 100644 drivers/media/video/mrstci/mrstov5630/ov5630.h
 create mode 100644 drivers/media/video/mrstci/mrstov5630/ov5630_motor.c
 create mode 100644 drivers/media/video/mrstci/mrstov5630/ov5630_motor.h

diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index eed3965..348eda8 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -154,6 +154,7 @@ obj-$(CONFIG_USB_VIDEO_CLASS)       += uvc/
 obj-$(CONFIG_VIDEO_MRST_ISP) += mrstci/mrstisp/
 obj-$(CONFIG_VIDEO_MRST_SENSOR) += mrstci/mrstsensor/
 obj-$(CONFIG_VIDEO_MRST_OV2650) += mrstci/mrstov2650/
+obj-$(CONFIG_VIDEO_MRST_OV5630) += mrstci/mrstov5630/

 EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core
 EXTRA_CFLAGS += -Idrivers/media/dvb/frontends
diff --git a/drivers/media/video/mrstci/Kconfig b/drivers/media/video/mrstci/Kconfig
index 1ad479b..803813b 100644
--- a/drivers/media/video/mrstci/Kconfig
+++ b/drivers/media/video/mrstci/Kconfig
@@ -13,5 +13,7 @@ source "drivers/media/video/mrstci/mrstisp/Kconfig"
 source "drivers/media/video/mrstci/mrstsensor/Kconfig"

 source "drivers/media/video/mrstci/mrstov2650/Kconfig"
+
+source "drivers/media/video/mrstci/mrstov5630/Kconfig"
 endif # VIDEO_MRSTCI

diff --git a/drivers/media/video/mrstci/mrstov5630/Kconfig b/drivers/media/video/mrstci/mrstov5630/Kconfig
new file mode 100644
index 0000000..7a5a50b
--- /dev/null
+++ b/drivers/media/video/mrstci/mrstov5630/Kconfig
@@ -0,0 +1,9 @@
+config VIDEO_MRST_OV5630
+       tristate "Moorestown OV5630 RAW Sensor"
+       depends on I2C && VIDEO_MRST_ISP && VIDEO_MRST_SENSOR
+
+       ---help---
+         Say Y here if your platform support OV5630 RAW Sensor.
+
+         To compile this driver as a module, choose M here: the
+         module will be called mrstov2650.ko.
diff --git a/drivers/media/video/mrstci/mrstov5630/Makefile b/drivers/media/video/mrstci/mrstov5630/Makefile
new file mode 100644
index 0000000..9b953fd
--- /dev/null
+++ b/drivers/media/video/mrstci/mrstov5630/Makefile
@@ -0,0 +1,4 @@
+mrstov5630-objs        = ov5630_motor.o ov5630.o
+obj-$(CONFIG_VIDEO_MRST_OV5630)         += mrstov5630.o
+
+EXTRA_CFLAGS   +=      -I$(src)/../include
diff --git a/drivers/media/video/mrstci/mrstov5630/ov5630.c b/drivers/media/video/mrstci/mrstov5630/ov5630.c
new file mode 100644
index 0000000..30d6a51
--- /dev/null
+++ b/drivers/media/video/mrstci/mrstov5630/ov5630.c
@@ -0,0 +1,783 @@
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
+#include "ov5630.h"
+#include "ov5630_motor.h"
+
+static int ov5630_set_res(struct i2c_client *c, const int w, const int h);
+static struct ov5630_format_struct {
+       __u8 *desc;
+       __u32 pixelformat;
+       struct regval_list *regs;
+} ov5630_formats[] = {
+       {
+               .desc           = "Raw RGB Bayer",
+               .pixelformat    = SENSOR_MODE_BAYER,
+               .regs           = NULL,
+       },
+};
+#define N_OV5630_FMTS ARRAY_SIZE(ov5630_formats)
+
+static struct ov5630_res_struct {
+       __u8 *desc;
+       int res;
+       int width;
+       int height;
+       unsigned vflag;
+#define VARIO_EN       1
+#define VARIO_DIS      0
+       struct regval_list *regs;
+} ov5630_res[] = {
+       {
+               .desc           = "QSXGA_PLUS4",
+               .res            = SENSOR_RES_QXGA_PLUS,
+               .width          = 2592,
+               .height         = 1944,
+               .vflag          = VARIO_DIS,
+               .regs           = ov5630_res_qsxga_plus4,
+       },
+       {
+               .desc           = "1080P",
+               .res            = SENSOR_RES_1080P,
+               .width          = 1920,
+               .height         = 1080,
+               .vflag          = VARIO_DIS,
+               .regs           = ov5630_res_1080p,
+       },
+       {
+               .desc           = "XGA_PLUS",
+               .res            = SENSOR_RES_XGA_PLUS,
+               .width          = 1280,
+               .height         = 960,
+               .vflag          = VARIO_EN,
+               .regs           = ov5630_res_xga_plus,
+       },
+       {
+               .desc           = "720p",
+               .res            = SENSOR_RES_720P,
+               .width          = 1280,
+               .height         = 720,
+               .vflag          = VARIO_EN,
+               .regs           = ov5630_res_720p,
+       },
+       {
+               .desc           = "VGA",
+               .res            = SENSOR_RES_VGA,
+               .width          = 640,
+               .height         = 480,
+               .vflag          = VARIO_EN,
+               .regs           = ov5630_res_vga_ac04_bill,
+       },
+};
+
+#define N_RES (ARRAY_SIZE(ov5630_res))
+
+static int ov5630_setup(struct i2c_client *c,
+                       const struct ci_sensor_config *config);
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
+       /* Read needs two message to go */
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
+       /* Writing only needs one message */
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
+       /* If this is a reset register, wait for 1ms */
+       if (reg == OV5630_SYS && (value & 0x80))
+               msleep(3);
+
+       ret = (ret == 1) ? 0 : -1;
+       return ret;
+}
+
+static int ov5630_write_array(struct i2c_client *c, struct regval_list *vals)
+{
+       struct regval_list *p;
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
+/*
+ * Sensor specific helper function
+ */
+static int ov5630_standby(void)
+{
+       gpio_set_value(GPIO_STDBY_PIN, 1);
+       ov5630_motor_standby();
+       return 0;
+}
+
+static int ov5630_wakeup(void)
+{
+       gpio_set_value(GPIO_STDBY_PIN, 0);
+       ov5630_motor_wakeup();
+
+       return 0;
+}
+
+static int ov5630_init(struct i2c_client *c)
+{
+       int ret;
+       struct ci_sensor_config *info = i2c_get_clientdata(c);
+       char *name = "";
+
+       /* Fill the configuration structure */
+       /* Note this default configuration value */
+       info->mode = ov5630_formats[0].pixelformat;
+       info->res = ov5630_res[0].res;
+       info->type = SENSOR_TYPE_RAW;
+       info->bls = SENSOR_BLS_OFF;
+       info->gamma = SENSOR_GAMMA_OFF;
+       info->cconv = SENSOR_CCONV_OFF;
+       info->blc = SENSOR_BLC_AUTO;
+       info->agc = SENSOR_AGC_OFF;
+       info->awb = SENSOR_AWB_OFF;
+       info->aec = SENSOR_AEC_OFF;
+       info->bus_width = SENSOR_BUSWIDTH_10BIT;
+       info->ycseq = SENSOR_YCSEQ_YCBYCR;
+       info->conv422 = SENSOR_CONV422_NOCOSITED;
+       info->bpat = SENSOR_BPAT_BGBGGRGR;
+       info->field_inv = SENSOR_FIELDINV_NOSWAP;
+       info->field_sel = SENSOR_FIELDSEL_BOTH;
+       info->hpol = SENSOR_HPOL_REFPOS;
+       info->vpol = SENSOR_VPOL_NEG;
+       info->edge = SENSOR_EDGE_RISING;
+       info->flicker_freq = SENSOR_FLICKER_100;
+       info->cie_profile = SENSOR_CIEPROF_F11;
+       name = "ov5630";
+       memcpy(info->name, name, 7);
+
+       /* Reset sensor hardware, and implement the setting*/
+       ret = ov5630_write(c, (u32)OV5630_SYS, (u32)0x80);
+       ret += ov5630_write(c, (u32)OV5630_IMAGE_SYSTEM, (u32)0x00);
+
+       /* Set registers into default config value */
+       ret += ov5630_write_array(c, ov5630_def_reg);
+
+       /* Set MIPI interface */
+#ifdef OV5630_MIPI
+       ret += ov5630_write_array(c, ov5630_mipi);
+#endif
+
+       /* streaming */
+       ret += ov5630_write(c, (u32)OV5630_IMAGE_SYSTEM, (u32)0x01);
+       ret += ov5630_write(c, (u32)0x3096, (u32)0x50);
+       ssleep(1);
+
+       return ret;
+}
+
+static int distance(struct ov5630_res_struct *res, u16 w, u16 h)
+{
+       int ret;
+       if (res->width < w || res->height < h)
+               return -1;
+
+       ret = ((res->width - w) + (res->height - h));
+       return ret;
+}
+static int ov5630_try_res(struct i2c_client *c, u16 *w, u16 *h)
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
+       if ((w != NULL) && (h != NULL)) {
+               *w = p->width;
+               *h = p->height;
+       }
+
+       return 0;
+}
+
+static struct ov5630_res_struct *ov5630_find_res(int w, int h)
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
+               res_index--;   /* Take the bigger one */
+
+       return res_index;
+}
+
+static int ov5630_set_res(struct i2c_client *c, const int w, const int h)
+{
+       int ret = 0;
+       struct ov5630_res_struct *res_index;
+       struct ci_sensor_config *info = i2c_get_clientdata(c);
+       u16 width, high;
+
+       width = w;
+       high = h;
+       ret += ov5630_try_res(c, &width, &high);
+
+       res_index = ov5630_find_res(width, high);
+
+       if ((res_index->regs) && (res_index->res != info->res)) {
+               /* Soft reset camera first*/
+               ret = ov5630_write(c, (u32)OV5630_SYS, (u32)0x80);
+
+               /* software sleep/standby */
+               ret += ov5630_write(c, (u32)OV5630_IMAGE_SYSTEM, (u32)0x00);
+
+               /* Set registers into default config value */
+               ret += ov5630_write_array(c, ov5630_def_reg);
+
+               /* set image resolution */
+               ret += ov5630_write_array(c, res_index->regs);
+
+               /* Set MIPI interface */
+#ifdef OV5630_MIPI
+               ret += ov5630_write_array(c, ov5630_mipi);
+#endif
+
+               /* streaming */
+               ret = ov5630_write(c, (u32)OV5630_IMAGE_SYSTEM, (u32)0x01);
+               ret = ov5630_write(c, (u32)0x3096, (u32)0x50);
+               ssleep(2);
+       }
+       info->res = res_index->res;
+
+       return ret;
+}
+
+static struct ov5630_control {
+       struct ci_sensor_parm parm;
+       int (*query)(struct i2c_client *c, __s32 *value);
+       int (*tweak)(struct i2c_client *c, int value);
+} ov5630_controls[] = {
+};
+#define N_CONTROLS (ARRAY_SIZE(ov5630_controls))
+
+static struct ov5630_control *ov5630_find_control(__u32 id)
+{
+       int i;
+
+       for (i = 0; i < N_CONTROLS; i++)
+               if (ov5630_controls[i].parm.index == id)
+                       return ov5630_controls + i;
+       return NULL;
+}
+
+static int ov5630_queryctrl(struct i2c_client *client,
+                           struct ci_sensor_parm *parm)
+{
+       struct ov5630_control *ctrl = ov5630_find_control(parm->index);
+
+       if (ctrl == NULL)
+               return -EINVAL;
+       *parm = ctrl->parm;
+       return 0;
+}
+
+static int ov5630_g_ctrl(struct i2c_client *client, struct ci_sensor_parm *parm)
+{
+       struct ov5630_control *octrl = ov5630_find_control(parm->index);
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
+static int ov5630_s_ctrl(struct i2c_client *client, struct ci_sensor_parm *parm)
+{
+       struct ov5630_control *octrl = ov5630_find_control(parm->index);
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
+static int ov5630_get_caps(struct i2c_client *c, struct ci_sensor_caps *caps)
+{
+       if (caps == NULL)
+               return -EIO;
+
+       caps->bus_width = SENSOR_BUSWIDTH_10BIT;
+       caps->mode      = SENSOR_MODE_BAYER;
+       caps->field_inv = SENSOR_FIELDINV_NOSWAP;
+       caps->field_sel = SENSOR_FIELDSEL_BOTH;
+       caps->ycseq     = SENSOR_YCSEQ_YCBYCR;
+       caps->conv422   = SENSOR_CONV422_NOCOSITED;
+       caps->bpat      = SENSOR_BPAT_BGBGGRGR;
+       caps->hpol      = SENSOR_HPOL_REFPOS;
+       caps->vpol      = SENSOR_VPOL_NEG;
+       caps->edge      = SENSOR_EDGE_RISING;
+       caps->bls       = SENSOR_BLS_OFF;
+       caps->gamma     = SENSOR_GAMMA_OFF;
+       caps->cconv     = SENSOR_CCONV_OFF;
+       caps->res       = SENSOR_RES_QXGA_PLUS | SENSOR_RES_1080P |
+           SENSOR_RES_XGA_PLUS | SENSOR_RES_720P | SENSOR_RES_VGA;
+       caps->blc       = SENSOR_BLC_OFF;
+       caps->agc       = SENSOR_AGC_OFF;
+       caps->awb       = SENSOR_AWB_OFF;
+       caps->aec       = SENSOR_AEC_OFF;
+       caps->cie_profile = SENSOR_CIEPROF_D65 | SENSOR_CIEPROF_D75 |
+           SENSOR_CIEPROF_F11 | SENSOR_CIEPROF_F12 | SENSOR_CIEPROF_A |
+           SENSOR_CIEPROF_F2;
+       caps->flicker_freq      = SENSOR_FLICKER_100 | SENSOR_FLICKER_120;
+       caps->type      = SENSOR_TYPE_RAW;
+       /* caps->name   = "ov5630"; */
+       strcpy(caps->name, "ov5630");
+
+       return 0;
+}
+
+static int ov5630_get_config(struct i2c_client *c,
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
+static int ov5630_set_img_ctrl(struct i2c_client *c,
+                              const struct ci_sensor_config *config)
+{
+       int err = 0;
+       u32 reg_val = 0;
+       struct ci_sensor_config *info = i2c_get_clientdata(c);
+
+       switch (config->blc) {
+       case SENSOR_BLC_OFF:
+               err |= ov5630_read(c, OV5630_ISP_CTL00, &reg_val);
+               err |= ov5630_write(c, OV5630_ISP_CTL00, reg_val & 0xFE);
+               info->blc = config->blc;
+               break;
+       case SENSOR_BLC_AUTO:
+               err |= ov5630_read(c, OV5630_ISP_CTL00, &reg_val);
+               err |= ov5630_write(c, OV5630_ISP_CTL00, reg_val | 0x01);
+               info->blc = SENSOR_BLC_AUTO;
+               break;
+       default:
+               info->blc = SENSOR_BLC_AUTO;
+       }
+
+       switch (config->agc) {
+       case SENSOR_AGC_AUTO:
+               err |= ov5630_read(c, OV5630_AUTO_1, &reg_val);
+               err |= ov5630_write(c, OV5630_AUTO_1, reg_val | 0x04);
+               info->agc = config->agc;
+               break;
+       case SENSOR_AGC_OFF:
+               err |= ov5630_read(c, OV5630_AUTO_1, &reg_val);
+               err |= ov5630_write(c, OV5630_AUTO_1, reg_val & ~0x04);
+               info->agc = config->agc;
+               break;
+       default:
+               info->agc = SENSOR_AGC_OFF;
+       }
+
+       switch (config->awb) {
+       case SENSOR_AWB_AUTO:
+               err |= ov5630_read(c, OV5630_ISP_CTL00, &reg_val);
+               err |= ov5630_write(c, OV5630_ISP_CTL00, reg_val | 0x30);
+               info->awb = config->awb;
+               break;
+       case SENSOR_AWB_OFF:
+               err |= ov5630_read(c, OV5630_ISP_CTL00, &reg_val);
+               err |= ov5630_write(c, OV5630_ISP_CTL00, reg_val & ~0x30);
+               info->awb = SENSOR_AWB_OFF;
+               break;
+       default:
+               info->awb = SENSOR_AWB_OFF;
+       }
+
+       switch (config->aec) {
+       case SENSOR_AEC_AUTO:
+               err |= ov5630_read(c, OV5630_AUTO_1, &reg_val);
+               err |= ov5630_write(c, OV5630_AUTO_1, reg_val | 0xFB);
+               info->aec = config->aec;
+               break;
+       case SENSOR_AEC_OFF:
+               err |= ov5630_read(c, OV5630_AUTO_1, &reg_val);
+               err |= ov5630_write(c, OV5630_AUTO_1, reg_val & 0xF6);
+               info->aec = SENSOR_AEC_OFF;
+               break;
+       default:
+               info->aec = SENSOR_AEC_OFF;
+       }
+
+       return err;
+}
+
+static int ov5630_setup(struct i2c_client *c,
+                       const struct ci_sensor_config *config)
+{
+       int ret;
+       u16 width, high;
+       struct ov5630_res_struct *res_index;
+       struct ci_sensor_config *info = i2c_get_clientdata(c);
+
+       /* Soft reset camera first*/
+       ret = ov5630_write(c, (u32)OV5630_SYS, (u32)0x80);
+
+       /* software sleep/standby */
+       ret = ov5630_write(c, (u32)OV5630_IMAGE_SYSTEM, (u32)0x00);
+
+       /* Set registers into default config value */
+       ret = ov5630_write_array(c, ov5630_def_reg);
+
+       /* set image resolution */
+       ci_sensor_res2size(config->res, &width, &high);
+       ret += ov5630_try_res(c, &width, &high);
+       res_index = ov5630_find_res(width, high);
+       if (res_index->regs)
+               ret += ov5630_write_array(c, res_index->regs);
+       if (!ret)
+               info->res = res_index->res;
+
+       ret += ov5630_set_img_ctrl(c, config);
+
+       /* Set MIPI interface */
+#ifdef OV5630_MIPI
+       ret += ov5630_write_array(c, ov5630_mipi);
+#endif
+
+       /* streaming */
+       ret += ov5630_write(c, (u32)OV5630_IMAGE_SYSTEM, (u32)0x01);
+       ret += ov5630_write(c, (u32)0x3096, (u32)0x50);
+
+       /*Note here for the time delay */
+       ssleep(1);
+       return ret;
+}
+
+/*
+ * File operation functions
+ */
+static int ov5630_open(struct i2c_setting *c, void *priv)
+{
+       /* Just wake up sensor */
+       if (ov5630_wakeup())
+               return -EIO;
+       ov5630_init(c->sensor_client);
+       ov5630_motor_init(c->motor_client);
+       ov5630_write(c->sensor_client, (u32)OV5630_IMAGE_SYSTEM, (u32)0x00);
+       return 0;
+}
+
+static int ov5630_release(struct i2c_setting *c, void *priv)
+{
+       /* Just suspend the sensor */
+       if (ov5630_standby())
+               return -EIO;
+       return 0;
+}
+
+static int ov5630_on(struct i2c_setting *c)
+{
+       /* Software wake up sensor */
+       return ov5630_write(c->sensor_client,
+                           (u32)OV5630_IMAGE_SYSTEM, (u32)0x01);
+}
+
+static int ov5630_off(struct i2c_setting *c)
+{
+       /* Software standby sensor */
+       return ov5630_write(c->sensor_client,
+                           (u32)OV5630_IMAGE_SYSTEM, (u32)0x00);
+}
+
+static struct sensor_device ov5630 = {
+       .name   = "ov5630",
+       .type   = SENSOR_TYPE_RAW,
+       .minor  = -1,
+       .open   = ov5630_open,
+       .release = ov5630_release,
+       .on = ov5630_on,
+       .off = ov5630_off,
+       .querycap = ov5630_get_caps,
+       .get_config = ov5630_get_config,
+       .set_config = ov5630_setup,
+       .enum_parm = ov5630_queryctrl,
+       .get_parm = ov5630_g_ctrl,
+       .set_parm = ov5630_s_ctrl,
+       .try_res = ov5630_try_res,
+       .set_res = ov5630_set_res,
+       .get_ls_corr_config = NULL,
+       .mdi_get_focus = ov5630_motor_get_focus,
+       .mdi_set_focus = ov5630_motor_set_focus,
+       .mdi_max_step = ov5630_motor_max_step,
+       .mdi_calibrate = NULL,
+       .read = ov5630_read,
+       .write = ov5630_write,
+       .suspend = ov5630_standby,
+       .resume = ov5630_wakeup,
+       /* TBC */
+};
+
+/*
+ * Basic i2c stuff
+ */
+static unsigned short normal_i2c[] = {I2C_OV5630 >> 1,
+       I2C_CLIENT_END};
+I2C_CLIENT_INSMOD;
+
+static struct i2c_driver ov5630_driver;
+static int ov5630_detect(struct i2c_client *client, int kind,
+                        struct i2c_board_info *info)
+{
+       struct i2c_adapter *adapter = client->adapter;
+       int adap_id = i2c_adapter_id(adapter);
+       const char *name = "";
+       u32 value;
+
+       if (!i2c_check_functionality(adapter, I2C_FUNC_I2C))
+               return -ENODEV;
+
+       if (adap_id != 1)
+               return -ENODEV;
+
+       if (ov5630_wakeup())
+               return -ENODEV;
+
+       ov5630_read(client, (u32)OV5630_PID_H, &value);
+       if ((u8)value != 0x56)
+               return -ENODEV;
+
+       name = "i2c_ov5630";
+       strlcpy(info->type, name, I2C_NAME_SIZE);
+
+       return 0;
+}
+
+static int ov5630_probe(struct i2c_client *client,
+                       const struct i2c_device_id *id)
+{
+       int ret = -1;
+       struct ci_sensor_config *info;
+       struct i2c_client *motor;
+       struct i2c_setting *ov5630_i2c;
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
+
+       ov5630_i2c = kzalloc(sizeof(struct i2c_setting), GFP_KERNEL);
+       if (!ov5630_i2c) {
+               ret = -ENOMEM;
+               goto err_2;
+       }
+       motor = kzalloc(sizeof(struct i2c_client), GFP_KERNEL);
+       if (!motor) {
+               ret = -ENOMEM;
+               goto err_3;
+       }
+       motor->adapter = client->adapter;
+       motor->addr = OV5630_MOTOR_ADDR;
+       strlcpy(motor->name, "OV5630_MOTOR", I2C_NAME_SIZE);
+       ov5630_i2c->sensor_client = client;
+       ov5630_i2c->motor_client = motor;
+
+       ov5630.i2c = ov5630_i2c;
+       ret = sensor_register_device(&ov5630, ov5630.type);
+       if (ret)
+               goto err_4;
+
+       /*
+        * Initialization OV5630
+        * then turn into standby mode
+        */
+       ret = ov5630_standby();
+       if (ret)
+               goto err_5;
+
+       printk(KERN_INFO "Init ov5630 sensor success\n");
+       return 0;
+
+err_5:
+       sensor_unregister_device(&ov5630);
+err_4:
+       kfree(motor);
+err_3:
+       kfree(ov5630_i2c);
+err_2:
+       kfree(info);
+err_1:
+       return ret;
+}
+
+/*
+ * XXX: Need to be checked
+ */
+static int ov5630_remove(struct i2c_client *client)
+{
+       kfree(i2c_get_clientdata(client));
+       sensor_unregister_device(&ov5630);
+       return 0;
+}
+
+static const struct i2c_device_id ov5630_id[] = {
+       {"i2c_ov5630", 0},
+       {}
+};
+
+static struct i2c_driver ov5630_driver = {
+       .driver = {
+               .name = "i2c_ov5630",
+       },
+       .probe = ov5630_probe,
+       .remove = ov5630_remove,
+       .id_table = ov5630_id,
+
+       .class = I2C_CLASS_HWMON,
+       .detect = ov5630_detect,
+       .address_data = &addr_data,
+};
+
+static int __init ov5630_mod_init(void)
+{
+       printk(KERN_NOTICE "OmniVision 5630 sensor driver, initialization.\n");
+       return i2c_add_driver(&ov5630_driver);
+}
+
+static void __exit ov5630_mod_exit(void)
+{
+       i2c_del_driver(&ov5630_driver);
+}
+
+module_init(ov5630_mod_init);
+module_exit(ov5630_mod_exit);
+
+MODULE_AUTHOR("Xiaolin Zhang <xiaolin.zhang@intel.com>");
+MODULE_DESCRIPTION("A low-level driver for OmniVision 5630 sensors");
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/video/mrstci/mrstov5630/ov5630.h b/drivers/media/video/mrstci/mrstov5630/ov5630.h
new file mode 100644
index 0000000..d924584
--- /dev/null
+++ b/drivers/media/video/mrstci/mrstov5630/ov5630.h
@@ -0,0 +1,673 @@
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
+/* Should add to kernel source */
+#define I2C_DRIVERID_OV5630    1046
+/* GPIO pin on Moorestown */
+#define GPIO_SCLK_25   44
+#define GPIO_STB_PIN   47
+#define GPIO_STDBY_PIN 48
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
+static struct regval_list ov5630_def_reg[] = {
+       {0x300f, 0x00}, /*00*/
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
+       {0x300e, 0xb1/*b0*/}, /* Note this PLL setting*/
+       {0x300f, 0x10}, /*00*/
+       {0x3010, 0x07}, /*change from 0f according to SV */
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
+       /* Mark end */
+       {0xffff, 0xff},
+
+};
+
+/* MIPI register are removed by Wen */
+
+/* 2592x1944 */
+static struct regval_list ov5630_res_qsxga_plus4[] = {
+       {0x3020, 0x07},
+       {0x3021, 0xbc},
+       {0x3022, 0x0c/*0a*/},
+       {0x3023, 0xa0/*00*/},
+       {0x305c, 0x01},
+       {0x305d, 0x29},
+       {0x305e, 0x00},
+       {0x305f, 0xf7},
+
+       /* 30fps , 96 MHZ*/
+       /* {0x300f, 0x10}, */
+       {0x300f, 0x10},
+       {0x300e, 0xb1},
+       /* mipi */
+#ifdef MIPI
+       {0x30b0, 0x00},
+       {0x30b1, 0xfc},
+       {0x3603, 0x50},
+       {0x3601, 0x0F},
+       /* lan2 bit 10*/
+       {0x3010, 0x07},
+       {0x30fa, 0x01},
+       /* {0x 30f8 09 */
+       {0x3096, 0x50},
+       /* end mipi*/
+#else
+       /* parrral */
+       {0x30fa, 0x01},
+#endif
+       /* end post*/
+       {0xffff, 0xff},
+};
+
+/* 1920x1080 */
+static struct regval_list ov5630_res_1080p[] = {
+       /*res start*/
+       {0x3020, 0x04},
+       {0x3021, 0x5c},
+       {0x3022, 0x0b/*0a*/},
+       {0x3023, 0x32/*00*/},
+       {0x305c, 0x01},
+       {0x305d, 0x2c},
+       {0x3024, 0x01},
+       {0x3025, 0x6e/*70*/},
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
+       {0x3315, 0x82/*80*/},
+       {0x3316, 0x04},
+       {0x3317, 0x3c},
+
+       /* 30fps , 96 MHZ*/
+       {0x300f, 0x10}, /* 00 */
+       {0x300e, 0xb1},
+
+       /* mipi */
+#ifdef MIPI
+       {0x30b0, 0x00},
+       {0x30b1, 0xfc},
+       {0x3603, 0x50},
+       {0x3601, 0x0F},
+       /* lan2 bit 10*/
+       {0x3010, 0x07},
+       {0x30fa, 0x01},
+       /* {0x 30f8 09 */
+       {0x3096, 0x50},
+       /* end mipi*/
+#else
+       /* parrral */
+       {0x30fa, 0x01},
+#endif
+       /* end post*/
+       {0xffff, 0xff},
+};
+
+/* 1280x960 V1F2_H1F2 */
+static struct regval_list ov5630_res_xga_plus[] = {
+       {0x3020, 0x03},
+       {0x3021, 0xe4},
+       {0x3022, 0x0c/*07*/},
+       {0x3023, 0x8c/*76*/},
+       {0x305c, 0x00},
+       {0x305d, 0xb1},
+       {0x3024, 0x00},
+       {0x3025, 0x30},
+       {0x3026, 0x00},
+       {0x3027, 0x10/*14*/},
+       {0x3028, 0x0a},
+       {0x3029, 0x2f},
+       {0x302a, 0x07},
+       {0x302b, 0xa7/*a7*/},
+       {0x302c, 0x05},
+       {0x302d, 0x00},
+       {0x302e, 0x03},
+       {0x302f, 0xc0},
+
+       {0x30f8, 0x05},
+       {0x30f9, 0x13},
+       {0x3314, 0x05},
+       {0x3315, 0x02/*00*/},
+       {0x3316, 0x03},
+       {0x3317, 0xc4},
+
+       {0x300f, 0x10}, /* 00 */
+       {0x300e, 0xb1},
+
+#ifdef MIPI
+       {0x30b0, 0x00},
+       {0x30b1, 0xfc},
+       {0x3603, 0x50},
+       {0x3601, 0x0F},
+       /* lan2 bit 10*/
+       {0x3010, 0x07},
+       {0x30fa, 0x01},
+       /* {0x 30f8 09 */
+       {0x3096, 0x50},
+       /* end mipi*/
+#else
+       /* parrral */
+       {0x30fa, 0x01},
+#endif
+
+       {0xffff, 0xff},
+};
+
+/* 1280x720, V1F2 & H1F2 */
+static struct regval_list ov5630_res_720p[] = {
+       {0x3020, 0x02},
+       {0x3021, 0xf4},
+       {0x3022, 0x08},
+       {0x3023, 0x44},
+       {0x305c, 0x01},
+       {0x305d, 0x9b},
+       {0x305e, 0x01},
+       {0x305f, 0x56},
+
+       /* Crop then downscale */
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
+       /* Add this to test setting from OVT */
+       {0x300f, 0x10}, /*00*/
+       {0x300e, 0xb1},
+
+#ifdef MIPI
+       {0x30b0, 0x00},
+       {0x30b1, 0xfc},
+       {0x3603, 0x50},
+       {0x3601, 0x0F},
+       /* lan2 bit 10*/
+       {0x3010, 0x07},
+       {0x30fa, 0x01},
+       /* {0x 30f8 09 */
+       {0x3096, 0x50},
+       /* end mipi*/
+#else
+       /* parrral */
+       {0x30fa, 0x01},
+#endif
+
+       {0xffff, 0xff},
+};
+
+/*VGA 90fps*/
+static struct regval_list ov5630_res_vga_ac04_bill[] = {
+       /* res setting*/
+       {0x3020, 0x02},
+       {0x3021, 0x04},
+       {0x3022, 0x07},
+       {0x3023, 0x80},
+       {0x305c, 0x00},
+       {0x305d, 0xd7},
+       {0x3024, 0x00},
+       {0x3025, 0x2c},/*2c*/
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
+       {0x3315, 0x04},/*04*/
+       {0x3316, 0x01},
+       {0x3317, 0xe4},
+       {0x3318, 0x20},
+
+       {0x300f, 0x10/*00*/},
+       {0x30f8, 0x09},
+
+       /* to improve the VGA fps */
+       {0x300f, 0x00},
+       {0x300e, 0xb3}, /* 80 fps */
+
+       {0x3015, 0x02},
+       /* mipi */
+#ifdef MIPI
+       {0x30b0, 0x00},
+       {0x30b1, 0xfc},
+       {0x3603, 0x50},
+       {0x3601, 0x0F},
+       /* lan2 bit 10*/
+       {0x3010, 0x07},
+       {0x30fa, 0x01},
+       /* {0x 30f8 09 */
+       {0x3096, 0x50},
+       /* end mipi*/
+#else
+
+       /* parrral */
+       {0x30fa, 0x01},
+       {0x30f8, 0x09},
+       {0x3096, 0x50},
+#endif
+
+       {0xffff, 0xff},
+};
diff --git a/drivers/media/video/mrstci/mrstov5630/ov5630_motor.c b/drivers/media/video/mrstci/mrstov5630/ov5630_motor.c
new file mode 100644
index 0000000..4d82ae4
--- /dev/null
+++ b/drivers/media/video/mrstci/mrstov5630/ov5630_motor.c
@@ -0,0 +1,212 @@
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
+#include "ov5630_motor.h"
+
+#define PMIC_WRITE1(ipcbuf, reg1, val1) \
+       do { \
+               memset(&ipcbuf, 0, sizeof(struct ipc_pmic_reg_data)); \
+               ipcbuf.ioc = 0; \
+               ipcbuf.num_entries = 1; \
+               ipcbuf.pmic_reg_data[0].register_address = reg1; \
+               ipcbuf.pmic_reg_data[0].value = val1; \
+               if (ipc_pmic_register_write(&ipcbuf, 1) != 0) { \
+                       return -1; \
+               } \
+       } while (0);
+
+static struct ov5630_motor *config;
+static int motor_read(struct i2c_client *c, u16 *reg)
+{
+       int ret;
+       struct i2c_msg msg;
+       u8 msgbuf[2];
+
+       /* Read needs two message to go */
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
+
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
+       /* Writing only needs one message */
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
+
+       ret = (ret == 1) ? 0 : -1;
+       return ret;
+}
+
+static int ov5630_motor_goto_position(struct i2c_client *c,
+                                     unsigned short code)
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
+       cmdl = (MOTOR_DAC_CODE_L(code) | MOTOR_DAC_CTRL_MODE_2(SUB_MODE_7));
+       cmd = cmdh << 8 | cmdl;
+
+       motor_write(c, cmd);
+       /*Delay more than full-scale transition time 70.4ms*/
+       msleep(100);
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
+int ov5630_motor_init(struct i2c_client *client)
+{
+       int ret;
+       int infin_cur, macro_cur;
+
+       config = kzalloc(sizeof(struct ov5630_motor), GFP_KERNEL);
+       if (config == NULL) {
+               printk(KERN_ERR "Memory alloc failed\n");
+               return -1;
+       }
+
+       infin_cur = MAX(MOTOR_INFIN_CUR, MOTOR_DAC_MIN_CUR);
+       macro_cur = MIN(MOTOR_MACRO_CUR, MOTOR_DAC_MAX_CUR);
+
+       config->infin_cur = infin_cur;
+       config->macro_cur = macro_cur;
+
+       config->infin_code = (int)((infin_cur * MOTOR_DAC_MAX_CODE)
+                                  / MOTOR_DAC_MAX_CUR);
+       config->macro_code = (int)((macro_cur * MOTOR_DAC_MAX_CODE)
+                                  / MOTOR_DAC_MAX_CUR);
+
+       config->max_step = ((config->macro_code - config->infin_code)
+                           >> MOTOR_STEP_SHIFT) + 1;
+       /* Note here, maybe macro_code */
+       ret = ov5630_motor_goto_position(client, config->infin_code);
+       if (!ret)
+               config->cur_code = config->infin_code;
+       else
+               printk(KERN_ERR "Error while initializing motor\n");
+
+       return ret;
+}
+
+int ov5630_motor_set_focus(struct i2c_client *c, unsigned int *step)
+{
+       int s_code, ret;
+       int max_step = config->max_step;
+       unsigned int val = *step;
+
+       if (val > max_step)
+               val = max_step;
+
+       s_code = (val << MOTOR_STEP_SHIFT);
+       s_code += config->infin_code;
+
+       ret = ov5630_motor_goto_position(c, s_code);
+       if (!ret)
+               config->cur_code = s_code;
+
+       return ret;
+}
+
+int ov5630_motor_get_focus(struct i2c_client *c, unsigned int *step)
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
+int ov5630_motor_max_step(struct i2c_client *c, unsigned int *max_code)
+{
+       if (config->max_step != 0)
+               *max_code = config->max_step;
+       return 0;
+}
diff --git a/drivers/media/video/mrstci/mrstov5630/ov5630_motor.h b/drivers/media/video/mrstci/mrstov5630/ov5630_motor.h
new file mode 100644
index 0000000..ebd1a38
--- /dev/null
+++ b/drivers/media/video/mrstci/mrstov5630/ov5630_motor.h
@@ -0,0 +1,79 @@
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
+/* VCM start current (mA) */
+#define MOTOR_INFIN_CUR                15
+/* VCM max current for Macro (mA) */
+#define MOTOR_MACRO_CUR                90
+/* DAC output max current (mA) */
+#define MOTOR_DAC_MAX_CUR      100
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
+};
+
+extern int ov5630_motor_init(struct i2c_client *client);
+extern int ov5630_motor_standby(void);
+extern int ov5630_motor_wakeup(void);
+extern int ov5630_motor_set_focus(struct i2c_client *c, unsigned int *step);
+extern int ov5630_motor_get_focus(struct i2c_client *c, unsigned int *step);
+extern int ov5630_motor_max_step(struct i2c_client *c, unsigned int *max_code);
--
1.5.5

