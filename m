Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:2564 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224Ab0EWMiV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 May 2010 08:38:21 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Zhang, Xiaolin" <xiaolin.zhang@intel.com>
Subject: Re: [PATCH v3 3/8] V4L2 subdev patchset for Intel Moorestown Camera Imaging Subsystem
Date: Sun, 23 May 2010 14:40:04 +0200
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <33AB447FBD802F4E932063B962385B351E89572F@shsmsx501.ccr.corp.intel.com>
In-Reply-To: <33AB447FBD802F4E932063B962385B351E89572F@shsmsx501.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005231440.04552.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver is representative of the other sensor drivers, so I won't review
those. Just make the same changes there.

On Tuesday 18 May 2010 11:22:58 Zhang, Xiaolin wrote:
> From 77c6856881ae269e1d3a58be3581d9f131037010 Mon Sep 17 00:00:00 2001
> From: Xiaolin Zhang <xiaolin.zhang@intel.com>
> Date: Tue, 18 May 2010 15:22:59 +0800
> Subject: [PATCH 3/8] This patch is to add 5MP raw camera (ov5630) support which is based
>  on the video4linux2 sub-dev driver framework.
> 
> Signed-off-by: Xiaolin Zhang <xiaolin.zhang@intel.com>
> ---
>  drivers/media/video/ov5630.c |  734 ++++++++++++++++++++++++++++++++++++++++++
>  drivers/media/video/ov5630.h |  635 ++++++++++++++++++++++++++++++++++++
>  2 files changed, 1369 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/video/ov5630.c
>  create mode 100644 drivers/media/video/ov5630.h
> 
> diff --git a/drivers/media/video/ov5630.c b/drivers/media/video/ov5630.c
> new file mode 100644
> index 0000000..c4be115
> --- /dev/null
> +++ b/drivers/media/video/ov5630.c
> @@ -0,0 +1,734 @@
> +/*
> + * Support for Moorestown Langwell Camera Imaging ISP subsystem.
> + *
> + * Copyright (c) 2009 Intel Corporation. All Rights Reserved.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License version
> + * 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
> + * 02110-1301, USA.
> + *
> + *
> + * Xiaolin Zhang <xiaolin.zhang@intel.com>
> + */
> +#include <linux/i2c.h>
> +#include <linux/gpio.h>
> +#include <linux/delay.h>
> +#include <linux/videodev2.h>
> +#include <linux/slab.h>
> +#include <media/v4l2-device.h>
> +
> +#include "mrst_sensor_common.h"

As mentioned, this header should be removed.

> +#include "ov5630.h"
> +
> +static int ov5630_debug;
> +module_param(ov5630_debug, int, 0644);
> +MODULE_PARM_DESC(ov5630_debug, "Debug level (0-1)");
> +
> +#define dprintk(level, fmt, arg...) do {                       \
> +       if (ov5630_debug >= level)                                      \
> +               printk(KERN_DEBUG "%s: " fmt "\n",      \
> +                      __func__, ## arg); } \
> +       while (0)
> +
> +#define eprintk(fmt, arg...)   \
> +       printk(KERN_ERR "%s: line %d: " fmt "\n",       \
> +              __func__, __LINE__, ## arg);
> +
> +static inline struct ci_sensor_config *to_sensor_config(struct v4l2_subdev *sd)
> +{
> +       return container_of(sd, struct ci_sensor_config, sd);

And you should make a driver-specific struct to keep the driver state.

> +}
> +
> +static struct ov5630_res_struct {
> +       __u8 *desc;
> +       int res;
> +       int width;
> +       int height;
> +       int fps;
> +       bool used;
> +       const struct regval_list *regs;
> +} ov5630_res[] = {
> +       {
> +               .desc           = "QSXGA_PLUS4",
> +               .res            = SENSOR_RES_QXGA_PLUS,
> +               .width          = 2592,
> +               .height         = 1944,
> +               .fps            = 15,
> +               .used           = 0,
> +               .regs           = ov5630_res_qsxga_plus4,
> +       },
> +       {
> +               .desc           = "1080P",
> +               .res            = SENSOR_RES_1080P,
> +               .width          = 1920,
> +               .height         = 1080,
> +               .fps            = 25,
> +               .used           = 0,
> +               .regs           = ov5630_res_1080p,
> +       },
> +       {
> +               .desc           = "XGA_PLUS",
> +               .res            = SENSOR_RES_XGA_PLUS,
> +               .width          = 1280,
> +               .height         = 960,
> +               .fps            = 30,
> +               .used           = 0,
> +               .regs           = ov5630_res_xga_plus,
> +       },
> +       {
> +               .desc           = "720p",
> +               .res            = SENSOR_RES_720P,
> +               .width          = 1280,
> +               .height         = 720,
> +               .fps            = 34,
> +               .used           = 0,
> +               .regs           = ov5630_res_720p,
> +       },
> +       {
> +               .desc           = "VGA",
> +               .res            = SENSOR_RES_VGA,
> +               .width          = 640,
> +               .height         = 480,
> +               .fps            = 39,
> +               .used           = 0,
> +               .regs           = ov5630_res_vga_ac04_bill,
> +       },
> +};
> +
> +#define N_RES (ARRAY_SIZE(ov5630_res))
> +
> +/*
> + * I2C Read & Write stuff
> + */
> +static int ov5630_read(struct i2c_client *c, u32 reg, u32 *value)
> +{
> +       int ret;
> +       int i;
> +       struct i2c_msg msg[2];
> +       u8 msgbuf[2];
> +       u8 ret_val = 0;
> +       *value = 0;
> +       memset(&msg, 0, sizeof(msg));
> +       msgbuf[0] = 0;
> +       msgbuf[1] = 0;
> +       i = 0;
> +
> +       msgbuf[i++] = ((u16)reg) >> 8;
> +       msgbuf[i++] = ((u16)reg) & 0xff;
> +       msg[0].addr = c->addr;
> +       msg[0].buf = msgbuf;
> +       msg[0].len = i;
> +
> +       msg[1].addr = c->addr;
> +       msg[1].flags = I2C_M_RD;
> +       msg[1].buf = &ret_val;
> +       msg[1].len = 1;
> +
> +       ret = i2c_transfer(c->adapter, &msg[0], 2);
> +       *value = ret_val;
> +
> +       ret = (ret == 2) ? 0 : -1;
> +       return ret;
> +}
> +
> +static int ov5630_write(struct i2c_client *c, u32 reg, u32 value)
> +{
> +       int ret, i;
> +       struct i2c_msg msg;
> +       u8 msgbuf[3];
> +
> +       memset(&msg, 0, sizeof(msg));
> +       i = 0;
> +       msgbuf[i++] = ((u16)reg) >> 8;
> +       msgbuf[i++] = (u16)reg & 0xff;
> +       msgbuf[i++] = (u8)value;
> +
> +       msg.addr = c->addr;
> +       msg.flags = 0;
> +       msg.buf = msgbuf;
> +       msg.len = i;
> +
> +       ret = i2c_transfer(c->adapter, &msg, 1);
> +
> +       if (reg == OV5630_SYS && (value & 0x80))
> +               msleep(3);
> +
> +       ret = (ret == 1) ? 0 : -1;
> +       return ret;
> +}
> +
> +static int ov5630_write_array(struct i2c_client *c,
> +                                       const struct regval_list *vals)
> +{
> +       const struct regval_list *p;
> +       u32 read_val = 0;
> +       int err_num = 0;
> +       int i = 0;
> +       p = vals;
> +       while (p->reg_num != 0xffff) {
> +               ov5630_write(c, (u32)p->reg_num, (u32)p->value);
> +               ov5630_read(c, (u32)p->reg_num, &read_val);
> +               if (read_val != p->value)
> +                       err_num++;
> +               p++;
> +               i++;
> +       }
> +       return 0;
> +}
> +
> +static int ov5630_set_img_ctrl(struct i2c_client *c,
> +                              const struct ci_sensor_config *config)
> +{
> +       int err = 0;
> +       u32 reg_val = 0;
> +
> +       switch (config->blc) {
> +       case SENSOR_BLC_OFF:
> +               err |= ov5630_read(c, OV5630_ISP_CTL00, &reg_val);
> +               err |= ov5630_write(c, OV5630_ISP_CTL00, reg_val & 0xFE);
> +               break;
> +       case SENSOR_BLC_AUTO:
> +               err |= ov5630_read(c, OV5630_ISP_CTL00, &reg_val);
> +               err |= ov5630_write(c, OV5630_ISP_CTL00, reg_val | 0x01);
> +               break;
> +       }
> +
> +       switch (config->agc) {
> +       case SENSOR_AGC_AUTO:
> +               err |= ov5630_read(c, OV5630_AUTO_1, &reg_val);
> +               err |= ov5630_write(c, OV5630_AUTO_1, reg_val | 0x04);
> +               break;
> +       case SENSOR_AGC_OFF:
> +               err |= ov5630_read(c, OV5630_AUTO_1, &reg_val);
> +               err |= ov5630_write(c, OV5630_AUTO_1, reg_val & ~0x04);
> +               break;
> +       }
> +
> +       switch (config->awb) {
> +       case SENSOR_AWB_AUTO:
> +               err |= ov5630_read(c, OV5630_ISP_CTL00, &reg_val);
> +               err |= ov5630_write(c, OV5630_ISP_CTL00, reg_val | 0x30);
> +               break;
> +       case SENSOR_AWB_OFF:
> +               err |= ov5630_read(c, OV5630_ISP_CTL00, &reg_val);
> +               err |= ov5630_write(c, OV5630_ISP_CTL00, reg_val & ~0x30);
> +               break;
> +       }
> +
> +       switch (config->aec) {
> +       case SENSOR_AEC_AUTO:
> +               err |= ov5630_read(c, OV5630_AUTO_1, &reg_val);
> +               err |= ov5630_write(c, OV5630_AUTO_1, reg_val | 0xFB);
> +               break;
> +       case SENSOR_AEC_OFF:
> +               err |= ov5630_read(c, OV5630_AUTO_1, &reg_val);
> +               err |= ov5630_write(c, OV5630_AUTO_1, reg_val & 0xF6);
> +               break;
> +       }

Replace these by controls. Auto whitebalance and autogain definitely exist
already.

> +
> +       return err;
> +}
> +
> +static int ov5630_init(struct i2c_client *c)
> +{
> +       int ret;
> +
> +       ret = ov5630_write(c, (u32)OV5630_SYS, (u32)0x80);
> +       ret += ov5630_write(c, (u32)OV5630_IMAGE_SYSTEM, (u32)0x00);
> +       ret += ov5630_write_array(c, ov5630_def_reg);
> +
> +       #ifdef OV5630_MIPI
> +       ret += ov5630_write_array(c, ov5630_mipi);
> +       #endif
> +
> +       ov5630_write(c, (u32)OV5630_IMAGE_SYSTEM, (u32)0x00);
> +       ov5630_write(c, 0x30b0, 0x00);
> +       ov5630_write(c, 0x30b1, 0x00);
> +       return ret;
> +}
> +
> +static int distance(struct ov5630_res_struct *res, u32 w, u32 h)
> +{
> +       int ret;
> +       if (res->width < w || res->height < h)
> +               return -1;
> +
> +       ret = ((res->width - w) + (res->height - h));
> +       return ret;
> +}
> +static int ov5630_try_res(u32 *w, u32 *h)
> +{
> +       struct ov5630_res_struct *res_index, *p = NULL;
> +       int dis, last_dis = ov5630_res->width + ov5630_res->height;
> +
> +       for (res_index = ov5630_res;
> +            res_index < ov5630_res + N_RES;
> +            res_index++) {
> +               if ((res_index->width < *w) || (res_index->height < *h))
> +                       break;
> +               dis = distance(res_index, *w, *h);
> +               if (dis < last_dis) {
> +                       last_dis = dis;
> +                       p = res_index;
> +               }
> +       }
> +
> +       if (p == NULL)
> +               p = ov5630_res;
> +       else if ((p->width < *w) || (p->height < *h)) {
> +               if (p != ov5630_res)
> +                       p--;
> +       }
> +
> +       if ((w != NULL) && (h != NULL)) {
> +               *w = p->width;
> +               *h = p->height;
> +       }
> +
> +       return 0;
> +}
> +
> +static struct ov5630_res_struct *ov5630_to_res(u32 w, u32 h)
> +{
> +       struct ov5630_res_struct *res_index;
> +
> +       for (res_index = ov5630_res;
> +            res_index < ov5630_res + N_RES;
> +            res_index++)
> +               if ((res_index->width == w) && (res_index->height == h))
> +                       break;
> +
> +       if (res_index >= ov5630_res + N_RES)
> +               res_index--;
> +
> +       return res_index;
> +}
> +
> +static int ov5630_try_fmt(struct v4l2_subdev *sd,
> +                         struct v4l2_mbus_framefmt *fmt)

Rename to try_mbus_fmt.

> +{

Make sure to fill in the bus format and the colorspace as well!

> +       return ov5630_try_res(&fmt->width, &fmt->height);
> +}
> +
> +static int ov5630_get_fmt(struct v4l2_subdev *sd,
> +                         struct v4l2_mbus_framefmt *fmt)
> +{
> +       struct ci_sensor_config *info = to_sensor_config(sd);
> +       unsigned short width, height;
> +       int index;
> +
> +       ci_sensor_res2size(info->res, &width, &height);
> +
> +       /* Marked the current sensor res as being "used" */
> +       for (index = 0; index < N_RES; index++) {
> +               if ((width == ov5630_res[index].width) &&
> +                   (height == ov5630_res[index].height)) {
> +                       ov5630_res[index].used = 1;
> +                       continue;
> +               }
> +               ov5630_res[index].used = 0;
> +       }
> +
> +       fmt->width = width;
> +       fmt->height = height;
> +       return 0;
> +}
> +
> +static int ov5630_set_fmt(struct v4l2_subdev *sd,
> +                                       struct v4l2_mbus_framefmt *fmt)
> +{
> +       struct i2c_client *c = v4l2_get_subdevdata(sd);
> +       struct ci_sensor_config *info = to_sensor_config(sd);
> +       int ret = 0;
> +       struct ov5630_res_struct *res_index;
> +       u32 width, height;
> +       int index;
> +
> +       width = fmt->width;
> +       height = fmt->height;
> +
> +       dprintk(1, "was told to set fmt (%d x %d) ", width, height);
> +
> +       ret = ov5630_try_res(&width, &height);
> +
> +       dprintk(1, "setting fmt (%d x %d) ", width, height);
> +
> +       res_index = ov5630_to_res(width, height);
> +
> +
> +       if (res_index->regs) {
> +               ret = ov5630_write(c, (u32)OV5630_SYS, (u32)0x80);
> +               ret += ov5630_write(c, (u32)OV5630_IMAGE_SYSTEM, (u32)0x00);
> +               ret += ov5630_write_array(c, ov5630_def_reg);
> +               ret += ov5630_write_array(c, res_index->regs);
> +
> +               /* set AE AEB AGC as info said */
> +               ret += ov5630_set_img_ctrl(c, info);
> +
> +               /* Set MIPI interface */
> +               #ifdef OV5630_MIPI
> +               ret += ov5630_write_array(c, ov5630_mipi);
> +               #endif
> +
> +               if (res_index->res == SENSOR_RES_VGA)
> +                       ret += ov5630_write(c, (u32)0x3015, (u32)0x03);
> +
> +               /* streaming */
> +               ret = ov5630_write(c, (u32)OV5630_IMAGE_SYSTEM, (u32)0x01);
> +               ret = ov5630_write(c, (u32)0x3096, (u32)0x50);
> +
> +               info->res = res_index->res;
> +
> +               /* Marked current sensor res as being "used" */
> +               for (index = 0; index < N_RES; index++) {
> +                       if ((width == ov5630_res[index].width) &&
> +                           (height == ov5630_res[index].height)) {
> +                               ov5630_res[index].used = 1;
> +                               continue;
> +                       }
> +                       ov5630_res[index].used = 0;
> +               }
> +
> +               for (index = 0; index < N_RES; index++)
> +                       dprintk(2, "index = %d, used = %d\n", index,
> +                               ov5630_res[index].used);
> +       } else {
> +               eprintk("no res for (%d x %d)", width, height);
> +       }
> +
> +       return ret;
> +}
> +
> +static int ov5630_t_gain(struct v4l2_subdev *sd, int value)
> +{
> +       struct i2c_client *client = v4l2_get_subdevdata(sd);
> +       u32 v;
> +
> +       dprintk(2, "writing gain %x to 0x3000", value);
> +       ov5630_read(client, 0x3000, &v);
> +       v = (v & 0x80) + value;
> +       ov5630_write(client, 0x3000, v);
> +       dprintk(2, "gain %x was writen to 0x3000", v);
> +
> +       return 0;
> +}
> +
> +static int ov5630_t_exposure(struct v4l2_subdev *sd, int value)
> +{
> +       struct i2c_client *client = v4l2_get_subdevdata(sd);
> +       u32 v;
> +       u32 reg_val;
> +
> +       ov5630_read(client, 0x3013, &v);
> +       dprintk(2, "0x3013 = %x", v);
> +       if (v & 0x05) {
> +               v = v & 0xfa;
> +               ov5630_write(client, 0x3013, v);
> +               ov5630_read(client, OV5630_ISP_CTL00, &reg_val);
> +               ov5630_write(client, OV5630_ISP_CTL00, reg_val & ~0x30);
> +       }
> +       ov5630_read(client, 0x3014, &v);
> +       dprintk(2, "0x3014 = %x", v);
> +       ov5630_read(client, 0x3002, &v);
> +       dprintk(2, "0x3002 = %x", v);
> +       ov5630_read(client, 0x3003, &v);
> +       dprintk(2, "0x3003 = %x", v);
> +
> +       dprintk(2, "writing exposure %x to 0x3002/3", value);
> +
> +       v = value >> 8;
> +       ov5630_write(client, 0x3002, v);
> +       dprintk(2, "exposure %x was writen to 0x3002", v);
> +
> +       v = value & 0xff;
> +       ov5630_write(client, 0x3003, v);
> +       dprintk(2, "exposure %x was writen to 0x3003", v);
> +
> +       return 0;
> +}
> +
> +static int ov5630_queryctrl(struct v4l2_subdev *sd,
> +                           struct v4l2_queryctrl *qc)
> +{
> +       int ret = -EINVAL;
> +       if (!sd)
> +               return -ENODEV;
> +       if (!qc)
> +               return ret;
> +
> +       switch (qc->id) {
> +       case V4L2_CID_GAIN:
> +               ret = v4l2_ctrl_query_fill(qc, 0, 255, 1, 0);
> +               break;
> +       case V4L2_CID_EXPOSURE:
> +               ret = v4l2_ctrl_query_fill(qc, 0, 65535, 1, 0);
> +               break;
> +       default:
> +               dprintk(1, "unsupported queryctrl id");
> +               break;
> +       }
> +       return ret;
> +}
> +
> +static int ov5630_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
> +{
> +       return 0;
> +}
> +
> +static int ov5630_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
> +{
> +       int ret = -EINVAL;
> +       if (!sd)
> +               return -ENODEV;
> +       if (!ctrl)
> +               return ret;
> +
> +       switch (ctrl->id) {
> +       case V4L2_CID_GAIN:
> +               ret = ov5630_t_gain(sd, ctrl->value);
> +               break;
> +       case V4L2_CID_EXPOSURE:
> +               ret = ov5630_t_exposure(sd, ctrl->value);
> +               break;
> +       default:
> +               dprintk(1, "unsupported ctrl id");
> +               break;
> +       }
> +       return ret;
> +}
> +
> +static int ov5630_s_stream(struct v4l2_subdev *sd, int enable)
> +{
> +       struct i2c_client *client = v4l2_get_subdevdata(sd);
> +
> +       if (enable) {
> +               ov5630_write(client, (u32)OV5630_IMAGE_SYSTEM, (u32)0x01);
> +               ov5630_write(client, 0x30b0, 0xff);
> +               ov5630_write(client, 0x30b1, 0xff);
> +               msleep(500);
> +       } else {
> +               ov5630_write(client, (u32)OV5630_IMAGE_SYSTEM, (u32)0x00);
> +               ov5630_write(client, 0x30b0, 0x00);
> +               ov5630_write(client, 0x30b1, 0x00);
> +       }
> +
> +       return 0;
> +}
> +
> +static int ov5630_enum_framesizes(struct v4l2_subdev *sd,
> +                                 struct v4l2_frmsizeenum *fsize)
> +{
> +       unsigned int index = fsize->index;
> +
> +       if (index >= N_RES)
> +               return -EINVAL;
> +
> +       fsize->type = V4L2_FRMSIZE_TYPE_DISCRETE;
> +       fsize->discrete.width = ov5630_res[index].width;
> +       fsize->discrete.height = ov5630_res[index].height;
> +       fsize->reserved[0] = ov5630_res[index].used;
> +
> +       return 0;
> +}
> +
> +static int ov5630_enum_frameintervals(struct v4l2_subdev *sd,
> +                                     struct v4l2_frmivalenum *fival)
> +{
> +       unsigned int index = fival->index;
> +
> +       if (index >= N_RES)
> +               return -EINVAL;
> +
> +       fival->type = V4L2_FRMIVAL_TYPE_DISCRETE;
> +       fival->discrete.numerator = 1;
> +       fival->discrete.denominator = ov5630_res[index].fps;
> +
> +       return 0;
> +}
> +
> +static int ov5630_g_chip_ident(struct v4l2_subdev *sd,
> +               struct v4l2_dbg_chip_ident *chip)
> +{
> +       struct i2c_client *client = v4l2_get_subdevdata(sd);
> +
> +#define V4L2_IDENT_OV5630 8245

Please add this to the v4l2-chip-ident.h header.

> +       return v4l2_chip_ident_i2c_client(client, chip, V4L2_IDENT_OV5630, 0);
> +}
> +
> +#ifdef CONFIG_VIDEO_ADV_DEBUG
> +static int ov5630_g_register(struct v4l2_subdev *sd,
> +                            struct v4l2_dbg_register *reg)
> +{
> +       struct i2c_client *client = v4l2_get_subdevdata(sd);
> +       unsigned char val = 0;
> +       int ret;
> +
> +       if (!v4l2_chip_match_i2c_client(client, &reg->match))
> +               return -EINVAL;
> +       if (!capable(CAP_SYS_ADMIN))
> +               return -EPERM;
> +       ret = ov5630_read(client, reg->reg & 0xffff, &val);
> +       reg->val = val;
> +       reg->size = 1;
> +       return ret;
> +}
> +
> +static int ov5630_s_register(struct v4l2_subdev *sd,
> +                            struct v4l2_dbg_register *reg)
> +{
> +       struct i2c_client *client = v4l2_get_subdevdata(sd);
> +
> +       if (!v4l2_chip_match_i2c_client(client, &reg->match))
> +               return -EINVAL;
> +       if (!capable(CAP_SYS_ADMIN))
> +               return -EPERM;
> +       ov5630_write(client, reg->reg & 0xffff, reg->val & 0xff);
> +       return 0;
> +}
> +#endif
> +
> +static const struct v4l2_subdev_video_ops ov5630_video_ops = {
> +       .try_mbus_fmt = ov5630_try_fmt,
> +       .s_mbus_fmt = ov5630_set_fmt,
> +       .g_mbus_fmt = ov5630_get_fmt,
> +       .s_stream = ov5630_s_stream,
> +       .enum_framesizes = ov5630_enum_framesizes,
> +       .enum_frameintervals = ov5630_enum_frameintervals,
> +};
> +
> +static const struct v4l2_subdev_core_ops ov5630_core_ops = {
> +       .g_chip_ident = ov5630_g_chip_ident,
> +       .queryctrl = ov5630_queryctrl,
> +       .g_ctrl = ov5630_g_ctrl,
> +       .s_ctrl = ov5630_s_ctrl,
> +#ifdef CONFIG_VIDEO_ADV_DEBUG
> +       .g_register = ov5630_g_register,
> +       .s_register = ov5630_s_register,
> +#endif
> +};
> +
> +static const struct v4l2_subdev_ops ov5630_ops = {
> +       .core = &ov5630_core_ops,
> +       .video = &ov5630_video_ops,
> +};
> +
> +static int ov5630_detect(struct i2c_client *client)
> +{
> +       struct i2c_adapter *adapter = client->adapter;
> +       int adap_id = i2c_adapter_id(adapter);
> +       u32 value;
> +
> +       if (!i2c_check_functionality(adapter, I2C_FUNC_I2C)) {
> +               eprintk("error i2c check func");
> +               return -ENODEV;
> +       }
> +
> +       if (adap_id != 1) {
> +               eprintk("adap_id != 1");
> +               return -ENODEV;
> +       }
> +
> +       ov5630_read(client, (u32)OV5630_PID_H, &value);
> +       if ((u8)value != 0x56) {
> +               dprintk(1, "PID != 0x56, but %x", value);
> +               dprintk(2, "client->addr = %x", client->addr);
> +               return -ENODEV;
> +       }
> +
> +       printk(KERN_INFO "Init ov5630 sensor success\n");
> +       return 0;
> +}
> +
> +static int ov5630_probe(struct i2c_client *client,
> +                       const struct i2c_device_id *id)
> +{
> +       struct ci_sensor_config *info;
> +       struct v4l2_subdev *sd;
> +       int ret = -1;
> +
> +       v4l_info(client, "chip found @ 0x%x (%s)\n",
> +                client->addr << 1, client->adapter->name);
> +
> +       info = kzalloc(sizeof(struct ci_sensor_config), GFP_KERNEL);
> +       if (!info) {
> +               eprintk("fail to malloc for ci_sensor_config");
> +               ret = -ENOMEM;
> +               goto out;
> +       }
> +
> +       ret = ov5630_detect(client);
> +       if (ret) {
> +               dprintk(1, "error ov5630_detect");
> +               goto out_free;
> +       }
> +
> +       sd = &info->sd;
> +       v4l2_i2c_subdev_init(sd, client, &ov5630_ops);
> +
> +       ret = ov5630_init(client);
> +       if (ret) {
> +               eprintk("error calling ov5630_init");
> +               goto out_free;
> +       }
> +
> +       ret = 0;
> +       goto out;
> +
> +out_free:
> +       kfree(info);
> +out:
> +       return ret;
> +}
> +
> +static int ov5630_remove(struct i2c_client *client)
> +{
> +       struct v4l2_subdev *sd = i2c_get_clientdata(client);
> +
> +       v4l2_device_unregister_subdev(sd);
> +       kfree(to_sensor_config(sd));
> +
> +       return 0;
> +}
> +
> +static const struct i2c_device_id ov5630_id[] = {
> +       {"ov5630", 0},
> +       {}
> +};
> +
> +MODULE_DEVICE_TABLE(i2c, ov5630_id);
> +
> +static struct i2c_driver ov5630_i2c_driver = {
> +       .driver = {
> +               .name = "ov5630",
> +       },
> +       .probe = ov5630_probe,
> +       .remove = ov5630_remove,
> +       .id_table = ov5630_id,
> +};
> +
> +static int __init ov5630_drv_init(void)
> +{
> +       return i2c_add_driver(&ov5630_i2c_driver);
> +}
> +
> +static void __exit ov5630_drv_cleanup(void)
> +{
> +       i2c_del_driver(&ov5630_i2c_driver);
> +}
> +
> +module_init(ov5630_drv_init);
> +module_exit(ov5630_drv_cleanup);
> +
> +MODULE_AUTHOR("Xiaolin Zhang <xiaolin.zhang@intel.com>");
> +MODULE_DESCRIPTION("A low-level driver for OmniVision 5630 sensors");
> +MODULE_LICENSE("GPL");

Regards,

	Hans


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
