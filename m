Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:39003 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760446AbZD3I00 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Apr 2009 04:26:26 -0400
From: "Zhang, Xiaolin" <xiaolin.zhang@intel.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "Johnson, Charles F" <charles.f.johnson@intel.com>
Date: Thu, 30 Apr 2009 16:25:54 +0800
Subject: [PATCH 5/5] V4L2 patches for Intel Moorestown Camera Imaging Drivers
Message-ID: <0A882F4D99BBF6449D58E61AAFD7EDD613793940@pdsmsx502.ccr.corp.intel.com>
References: <90b950fc0904292317m500820efv66755aed31b46853@mail.gmail.com>
 <5A47E75E594F054BAF48C5E4FC4B92AB030548BA1B@dbde02.ent.ti.com>     
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>From eb2cf7ea5a94412e0c0e2655d0d091b15a7d7ef0 Mon Sep 17 00:00:00 2001
From: Xiaolin Zhang <xiaolin.zhang@intel.com>
Date: Thu, 30 Apr 2009 13:27:34 +0800
Subject: [PATCH] 1.3MP camera sensor driver (ov9665) on Intel moorestown platform.
 Signed-off-by: Xiaolin Zhang <xiaolin.zhang@intel.com>

---
 drivers/media/video/Makefile                       |    1 +
 drivers/media/video/mrstci/Kconfig                 |    3 +
 drivers/media/video/mrstci/mrstov9665/Kconfig      |    9 +
 drivers/media/video/mrstci/mrstov9665/Makefile     |    3 +
 drivers/media/video/mrstci/mrstov9665/mrstov9665.c |  694 ++++++++++++++++++++
 drivers/media/video/mrstci/mrstov9665/ov9665.h     |  244 +++++++
 6 files changed, 954 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/mrstci/mrstov9665/Kconfig
 create mode 100644 drivers/media/video/mrstci/mrstov9665/Makefile
 create mode 100644 drivers/media/video/mrstci/mrstov9665/mrstov9665.c
 create mode 100644 drivers/media/video/mrstci/mrstov9665/ov9665.h

diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index 348eda8..060f95d 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -155,6 +155,7 @@ obj-$(CONFIG_VIDEO_MRST_ISP) += mrstci/mrstisp/
 obj-$(CONFIG_VIDEO_MRST_SENSOR) += mrstci/mrstsensor/
 obj-$(CONFIG_VIDEO_MRST_OV2650) += mrstci/mrstov2650/
 obj-$(CONFIG_VIDEO_MRST_OV5630) += mrstci/mrstov5630/
+obj-$(CONFIG_VIDEO_MRST_OV5630) += mrstci/mrstov9665/

 EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core
 EXTRA_CFLAGS += -Idrivers/media/dvb/frontends
diff --git a/drivers/media/video/mrstci/Kconfig b/drivers/media/video/mrstci/Kconfig
index 803813b..da81c3e 100644
--- a/drivers/media/video/mrstci/Kconfig
+++ b/drivers/media/video/mrstci/Kconfig
@@ -15,5 +15,8 @@ source "drivers/media/video/mrstci/mrstsensor/Kconfig"
 source "drivers/media/video/mrstci/mrstov2650/Kconfig"

 source "drivers/media/video/mrstci/mrstov5630/Kconfig"
+
+source "drivers/media/video/mrstci/mrstov9665/Kconfig"
+
 endif # VIDEO_MRSTCI

diff --git a/drivers/media/video/mrstci/mrstov9665/Kconfig b/drivers/media/video/mrstci/mrstov9665/Kconfig
new file mode 100644
index 0000000..56aaffb
--- /dev/null
+++ b/drivers/media/video/mrstci/mrstov9665/Kconfig
@@ -0,0 +1,9 @@
+config VIDEO_MRST_OV9665
+       tristate "Moorestown OV9665 SoC Sensor"
+       depends on I2C && VIDEO_MRST_ISP && VIDEO_MRST_SENSOR
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
index 0000000..badc449
--- /dev/null
+++ b/drivers/media/video/mrstci/mrstov9665/mrstov9665.c
@@ -0,0 +1,694 @@
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
+#include "ov9665.h"
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
+       unsigned vflag;
+#define VARIO_EN       1
+#define VARIO_DIS      0
+       struct regval_list *regs;
+} ov9665_res[] = {
+       {
+               .desc           = "SXGA",
+               .res            = SENSOR_RES_SXGA,
+               .width          = 1280,
+               .height         = 1024,
+               .vflag          = VARIO_DIS,
+               .regs           = ov9665_res_sxga,
+       },
+       {
+               .desc           = "VGA",
+               .res            = SENSOR_RES_VGA,
+               .width          = 640,
+               .height         = 480,
+               .vflag          = VARIO_EN,
+               .regs           = ov9665_res_vga,
+       },
+};
+#define N_RES (ARRAY_SIZE(ov9665_res))
+
+/*
+ * I2C Read & Write stuff
+ */
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
+               msleep(2);  /* Wait for reset to run */
+       return ret;
+}
+
+/*
+ * Write a list of register settings; ff/ff stops the process.
+ */
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
+/*
+ * Sensor specific helper function
+ */
+static int ov9665_standby(void)
+{
+       /* Pull the pin to high to hardware standby */
+       gpio_set_value(GPIO_STDBY_PIN, 1);
+       return 0;
+}
+
+static int ov9665_wakeup(void)
+{
+       /* Pull the pin to low*/
+       gpio_set_value(GPIO_STDBY_PIN, 0);
+       msleep(10);
+       return 0;
+}
+
+static int ov9665_init(struct i2c_client *c)
+{
+       int ret;
+       struct ci_sensor_config *info = i2c_get_clientdata(c);
+
+       /* Fill the configuration structure */
+       /* Note this default configuration value */
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
+       /* Set registers into default config value */
+       ret += ov9665_write_array(c, ov9665_def_reg);
+       ssleep(1);
+
+       return ret;
+}
+
+static int distance(struct ov9665_res_struct *res, u16 w, u16 h)
+{
+       int ret;
+       if (res->width < w || res->height < h)
+               return -1;
+
+       ret = ((res->width - w) + (res->height - h));
+       return ret;
+}
+static int ov9665_try_res(struct i2c_client *c, u16 *w, u16 *h)
+{
+       struct ov9665_res_struct *res_index, *p = NULL;
+       int dis, last_dis = ov9665_res->width + ov9665_res->height;
+
+       for (res_index = ov9665_res;
+            res_index < ov9665_res + N_RES;
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
+               p = ov9665_res;
+       if ((w != NULL) && (h != NULL)) {
+               *w = p->width;
+               *h = p->height;
+       }
+
+       return 0;
+}
+
+static struct ov9665_res_struct *ov9665_find_res(int w, int h)
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
+               res_index--;   /* Take the bigger one */
+
+       return res_index;
+}
+
+static int ov9665_set_res(struct i2c_client *c, const int w, const int h)
+{
+       int ret = 0;
+       struct ov9665_res_struct *res_index;
+       struct ci_sensor_config *info = i2c_get_clientdata(c);
+       unsigned short width, high;
+
+       width = w;
+       high = h;
+       ret += ov9665_try_res(c, &width, &high);
+
+       res_index = ov9665_find_res(width, high);
+
+       if ((info->res != res_index->res) && (res_index->regs)) {
+               ret = ov9665_write(c, 0x12, 0x80);
+               ret += ov9665_write_array(c, ov9665_def_reg);
+               ret += ov9665_write_array(c, res_index->regs);
+               /* Add delay here to get better image */
+               ssleep(1);
+       }
+       info->res = res_index->res;
+
+       return ret;
+}
+
+static int ov9665_q_hflip(struct i2c_client *client, __s32 *value)
+{
+       int ret;
+       unsigned char v = 0;
+
+       ret = ov9665_read(client, 0x04, &v);
+       *value = ((v & 0x80) == 0x80);
+       return ret;
+}
+
+static int ov9665_t_hflip(struct i2c_client *client, int value)
+{
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
+       msleep(10);  /* FIXME */
+       return ret;
+}
+
+static int ov9665_q_vflip(struct i2c_client *client, __s32 *value)
+{
+       int ret;
+       unsigned char v = 0;
+
+       ret = ov9665_read(client, 0x04, &v);
+       *value = ((v & 0x40) == 0x40);
+       return ret;
+}
+
+static int ov9665_t_vflip(struct i2c_client *client, int value)
+{
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
+       msleep(10);  /* FIXME */
+       return ret;
+}
+
+static struct ov9665_control {
+       struct ci_sensor_parm parm;
+       int (*query)(struct i2c_client *c, __s32 *value);
+       int (*tweak)(struct i2c_client *c, int value);
+} ov9665_controls[] = {
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
+               .tweak = ov9665_t_vflip,
+               .query = ov9665_q_vflip,
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
+               if (ov9665_controls[i].parm.index == id)
+                       return ov9665_controls + i;
+       return NULL;
+}
+
+static int ov9665_queryctrl(struct i2c_client *client,
+                           struct ci_sensor_parm *parm)
+{
+       struct ov9665_control *ctrl = ov9665_find_control(parm->index);
+
+       if (ctrl == NULL)
+               return -EINVAL;
+       *parm = ctrl->parm;
+       return 0;
+}
+
+static int ov9665_g_ctrl(struct i2c_client *client, struct ci_sensor_parm *parm)
+{
+       struct ov9665_control *octrl = ov9665_find_control(parm->index);
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
+static int ov9665_s_ctrl(struct i2c_client *client, struct ci_sensor_parm *parm)
+{
+       struct ov9665_control *octrl = ov9665_find_control(parm->index);
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
+static int ov9665_get_caps(struct i2c_client *c, struct ci_sensor_caps *caps)
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
+       caps->bpat      = SENSOR_BPAT_GRGRBGBG;
+       caps->hpol      = SENSOR_HPOL_REFPOS;
+       caps->vpol      = SENSOR_VPOL_POS;
+       caps->edge      = SENSOR_EDGE_FALLING;
+       caps->bls       = SENSOR_BLS_OFF;
+       caps->gamma     = SENSOR_GAMMA_ON;
+       caps->cconv     = SENSOR_CCONV_ON;
+       caps->res       = SENSOR_RES_SXGA | SENSOR_RES_VGA;
+       caps->blc       = SENSOR_BLC_AUTO;
+       caps->agc       = SENSOR_AGC_AUTO;
+       caps->awb       = SENSOR_AWB_AUTO;
+       caps->aec       = SENSOR_AEC_AUTO;
+       caps->cie_profile       = 0;
+       caps->flicker_freq      = SENSOR_FLICKER_100 | SENSOR_FLICKER_120;
+       caps->type      = SENSOR_TYPE_SOC;
+       /* caps->name   = "ov9665"; */
+       strcpy(caps->name, "ov9665");
+
+       return 0;
+}
+
+static int ov9665_get_config(struct i2c_client *c,
+                            struct ci_sensor_config *config)
+{
+       struct ci_sensor_config *info = i2c_get_clientdata(c);
+
+       if (config == NULL) {
+               printk(KERN_WARNING "sensor_get_config: NULL pointer\n");
+               return -EIO;
+       }
+
+       memset(config, 0, sizeof(struct ci_sensor_config *));
+       memcpy(config, info, sizeof(struct ci_sensor_config));
+
+       return 0;
+}
+
+static int ov9665_setup(struct i2c_client *c,
+                       const struct ci_sensor_config *config)
+{
+       int ret;
+       struct ov9665_res_struct *res_index;
+       struct ci_sensor_config *info = i2c_get_clientdata(c);
+       u16 width, high;
+
+       /* Soft reset camera first*/
+       ret = ov9665_write(c, 0x12, 0x80);
+
+       /* Set registers into default config value */
+       ret += ov9665_write_array(c, ov9665_def_reg);
+
+       /* set image resolution */
+       ci_sensor_res2size(config->res, &width, &high);
+       ret += ov9665_try_res(c, &width, &high);
+       res_index = ov9665_find_res(width, high);
+       if (res_index->regs)
+               ret += ov9665_write_array(c, res_index->regs);
+       if (!ret)
+               info->res = res_index->res;
+
+       /* Add some delay here to get a better image*/
+       ssleep(1);
+
+       return ret;
+}
+
+/*
+ * File operation functions
+ */
+static int ov9665_open(struct i2c_setting *c, void *priv)
+{
+       struct i2c_client *client = c->sensor_client;
+       int ret = 0;
+       u8 reg = 0;
+       /* Just wake up sensor */
+       if (ov9665_wakeup())
+               return -EIO;
+
+       ov9665_init(client);
+       ret = ov9665_read(client, 0x09, &reg);
+       reg = reg | 0x10;
+       ret += ov9665_write(client, 0x09, reg);
+       return ret;
+}
+
+static int ov9665_release(struct i2c_setting *c, void *priv)
+{
+       /* Just suspend the sensor */
+       if (ov9665_standby())
+               return EIO;
+       return 0;
+}
+
+static int ov9665_on(struct i2c_setting *c)
+{
+       struct i2c_client *client = c->sensor_client;
+       int ret = 0;
+       u8 reg = 0;
+
+       ret = ov9665_read(client, 0x09, &reg);
+       reg = reg & ~0x10;
+       ret = ov9665_write(client, 0x09, reg);
+       return ret;
+}
+
+static int ov9665_off(struct i2c_setting *c)
+{
+       struct i2c_client *client = c->sensor_client;
+       int ret = 0;
+       u8 reg = 0;
+
+       ret = ov9665_read(client, 0x09, &reg);
+       reg = reg | 0x10;
+       ret += ov9665_write(client, 0x09, reg);
+
+       return ret;
+}
+
+static struct sensor_device ov9665 = {
+       .name   = "OV9665",
+       .type   = SENSOR_TYPE_SOC,
+       .minor  = -1,
+       .open   = ov9665_open,
+       .release = ov9665_release,
+       .on = ov9665_on,
+       .off = ov9665_off,
+       .querycap = ov9665_get_caps,
+       .get_config = ov9665_get_config,
+       .set_config = ov9665_setup,
+       .enum_parm = ov9665_queryctrl,
+       .get_parm = ov9665_g_ctrl,
+       .set_parm = ov9665_s_ctrl,
+       .try_res = ov9665_try_res,
+       .set_res = ov9665_set_res,
+       .suspend = ov9665_standby,
+       .resume = ov9665_wakeup,
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
+static unsigned short normal_i2c[] = {0x30, I2C_CLIENT_END};
+I2C_CLIENT_INSMOD;
+
+static struct i2c_driver ov9665_driver;
+static int ov9665_detect(struct i2c_client *client, int kind,
+                        struct i2c_board_info *info)
+{
+       struct i2c_adapter *adapter = client->adapter;
+       int adap_id = i2c_adapter_id(adapter);
+       const char *name = "";
+       u8 config = 0;
+
+       if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA))
+               return -ENODEV;
+
+       if (adap_id != 1)
+               return -ENODEV;
+
+       if (ov9665_wakeup())
+               return -ENODEV;
+
+       ov9665_read(client, 0x0a, &config);
+       if (config != 0x96)
+               return -ENODEV;
+
+       ov9665_read(client, 0x0b, &config);
+       if (config != 0x63)
+               return -ENODEV;
+
+       name = "i2c_ov9665";
+       strlcpy(info->type, name, I2C_NAME_SIZE);
+
+       return 0;
+}
+
+static int ov9665_probe(struct i2c_client *client,
+                       const struct i2c_device_id *id)
+{
+       int ret = -1;
+       struct ci_sensor_config *info;
+       struct i2c_setting *ov9665_i2c;
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
+       ov9665_i2c = kzalloc(sizeof(struct i2c_setting), GFP_KERNEL);
+       if (!ov9665_i2c) {
+               ret = -ENOMEM;
+               goto err_2;
+       }
+       ov9665_i2c->sensor_client = client;
+       ov9665_i2c->motor_client = NULL;
+
+       ov9665.i2c = ov9665_i2c;
+       ret = sensor_register_device(&ov9665, ov9665.type);
+       if (ret)
+               goto err_3;
+
+       /*
+        * Initialization OV9665
+        * then turn into standby mode
+        */
+       ret = ov9665_standby();
+       if (ret)
+               goto err_4;
+       printk(KERN_INFO "Init ov9665 sensor success\n");
+       return 0;
+
+err_4:
+       sensor_unregister_device(&ov9665);
+err_3:
+       kfree(ov9665_i2c);
+err_2:
+       kfree(info);
+err_1:
+       /* kfree(&ov9665); */
+       /* kfree(client); */
+       return ret;
+}
+
+/*
+ * XXX: Need to be checked
+ */
+static int ov9665_remove(struct i2c_client *client)
+{
+       kfree(i2c_get_clientdata(client));
+       sensor_unregister_device(&ov9665);
+       return 0;
+}
+
+static const struct i2c_device_id ov9665_id[] = {
+       {"i2c_ov9665", 0},
+       {}
+};
+
+static struct i2c_driver ov9665_driver = {
+       .driver = {
+               .name = "i2c_ov9665",
+       },
+       .probe = ov9665_probe,
+       .remove = ov9665_remove,
+       .id_table = ov9665_id,
+
+       .class = I2C_CLASS_HWMON,
+       .detect = ov9665_detect,
+       .address_data = &addr_data,
+};
+
+static int __init ov9665_mod_init(void)
+{
+       printk(KERN_WARNING "OmniVision 9665 sensor driver, initialization.\n");
+       return i2c_add_driver(&ov9665_driver);
+}
+
+static void __exit ov9665_mod_exit(void)
+{
+       i2c_del_driver(&ov9665_driver);
+}
+
+module_init(ov9665_mod_init);
+module_exit(ov9665_mod_exit);
+
+MODULE_AUTHOR("Xiaolin Zhang <xiaolin.zhang@intel.com>");
+MODULE_DESCRIPTION("A low-level driver for OmniVision 9665 sensors");
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/video/mrstci/mrstov9665/ov9665.h b/drivers/media/video/mrstci/mrstov9665/ov9665.h
new file mode 100644
index 0000000..7bdd9ce
--- /dev/null
+++ b/drivers/media/video/mrstci/mrstov9665/ov9665.h
@@ -0,0 +1,244 @@
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
+/* Should add to kernel source */
+#define I2C_DRIVERID_OV9665    1047
+/* GPIO pin on Moorestown */
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
+       {0x0C, 0x3a}, /* Auto detect for 50/60 */
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
+       {0xff, 0xff},
+};
+
+/* 1280x1024 */
+static struct regval_list ov9665_res_sxga[] = {
+       {0xff, 0xff},
+};
+
+/* 640x480 */
+static struct regval_list ov9665_res_vga[] = {
+       /* Fclk/4 */
+       {0x11, 0x80},
+       {0x63, 0x00},
+
+       {0x12, 0x40}, /*VGA format*/
+       {0x14, 0x50},
+       {0x0c, 0xba},
+       {0x4d, 0x09},
+       {0x5c, 0x80}, /* Full average AEC */
+
+       /* Windows setting */
+       {0x17, 0x0c},
+       {0x18, 0x5c},
+       {0x19, 0x02},
+       {0x1a, 0x3f},
+       {0x03, 0x03},
+       {0x32, 0xad},
+
+       /* 50/60Hz AEC */
+       {0x5a, 0x23},
+       {0x2b, 0x00},
+
+       {0x64, 0xa4},
+       /*
+       {0x4F, 0x4f},
+       {0x50, 0x42},
+       */
+       {0x4F, 0x9e},
+       {0x50, 0x84},
+       {0x97, 0x0a},
+       {0xad, 0x82},
+       {0xd9, 0x11},
+
+       /* Scale window */
+       {0xb9, 0x50},
+       {0xba, 0x3c},
+       {0xbb, 0x50},
+       {0xbc, 0x3c},
+
+       {0x0d, 0x92},
+       {0x0d, 0x90},
+
+       {0xff, 0xff},
+};
--
1.5.5

