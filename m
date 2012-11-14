Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:40685 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755190Ab2KNR7E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Nov 2012 12:59:04 -0500
Received: by mail-la0-f46.google.com with SMTP id h6so573592lag.19
        for <linux-media@vger.kernel.org>; Wed, 14 Nov 2012 09:59:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1352760432-7194-2-git-send-email-sakari.ailus@iki.fi>
References: <20121112224655.GP25623@valkosipuli.retiisi.org.uk>
	<1352760432-7194-2-git-send-email-sakari.ailus@iki.fi>
Date: Wed, 14 Nov 2012 09:59:02 -0800
Message-ID: <CAPqfFkBg8jBtJah_VG9C4RJPpYTCEucdpFvtibr1OpUoxNRTXw@mail.gmail.com>
Subject: Re: [PATCH 2/3] tcm825x: Remove driver
From: David Cohen <dacohen@gmail.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 12, 2012 at 2:47 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
>
> Remove tcm825x driver. It uses the obsolete V4L2 int device framework, and
> can only work with omap24xxcam driver.
>
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>

I wonder if you will ever fix and send it again :)

Acked-by: David Cohen <dacohen@gmail.com>

> ---
>  drivers/media/i2c/Kconfig   |    8 -
>  drivers/media/i2c/Makefile  |    1 -
>  drivers/media/i2c/tcm825x.c |  937 -------------------------------------------
>  drivers/media/i2c/tcm825x.h |  200 ---------
>  4 files changed, 0 insertions(+), 1146 deletions(-)
>  delete mode 100644 drivers/media/i2c/tcm825x.c
>  delete mode 100644 drivers/media/i2c/tcm825x.h
>
> diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
> index 24d78e2..aa8f18c 100644
> --- a/drivers/media/i2c/Kconfig
> +++ b/drivers/media/i2c/Kconfig
> @@ -475,14 +475,6 @@ config VIDEO_MT9V032
>           This is a Video4Linux2 sensor-level driver for the Micron
>           MT9V032 752x480 CMOS sensor.
>
> -config VIDEO_TCM825X
> -       tristate "TCM825x camera sensor support"
> -       depends on I2C && VIDEO_V4L2
> -       depends on MEDIA_CAMERA_SUPPORT
> -       ---help---
> -         This is a driver for the Toshiba TCM825x VGA camera sensor.
> -         It is used for example in Nokia N800.
> -
>  config VIDEO_SR030PC30
>         tristate "Siliconfile SR030PC30 sensor support"
>         depends on I2C && VIDEO_V4L2
> diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
> index b1d62df..eb1757f 100644
> --- a/drivers/media/i2c/Makefile
> +++ b/drivers/media/i2c/Makefile
> @@ -47,7 +47,6 @@ obj-$(CONFIG_VIDEO_VP27SMPX) += vp27smpx.o
>  obj-$(CONFIG_VIDEO_UPD64031A) += upd64031a.o
>  obj-$(CONFIG_VIDEO_UPD64083) += upd64083.o
>  obj-$(CONFIG_VIDEO_OV7670)     += ov7670.o
> -obj-$(CONFIG_VIDEO_TCM825X) += tcm825x.o
>  obj-$(CONFIG_VIDEO_TVEEPROM) += tveeprom.o
>  obj-$(CONFIG_VIDEO_MT9M032) += mt9m032.o
>  obj-$(CONFIG_VIDEO_MT9P031) += mt9p031.o
> diff --git a/drivers/media/i2c/tcm825x.c b/drivers/media/i2c/tcm825x.c
> deleted file mode 100644
> index 9252529..0000000
> --- a/drivers/media/i2c/tcm825x.c
> +++ /dev/null
> @@ -1,937 +0,0 @@
> -/*
> - * drivers/media/i2c/tcm825x.c
> - *
> - * TCM825X camera sensor driver.
> - *
> - * Copyright (C) 2007 Nokia Corporation.
> - *
> - * Contact: Sakari Ailus <sakari.ailus@nokia.com>
> - *
> - * Based on code from David Cohen <david.cohen@indt.org.br>
> - *
> - * This driver was based on ov9640 sensor driver from MontaVista
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License
> - * version 2 as published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it will be useful, but
> - * WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> - * General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software
> - * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
> - * 02110-1301 USA
> - */
> -
> -#include <linux/i2c.h>
> -#include <linux/module.h>
> -#include <media/v4l2-int-device.h>
> -
> -#include "tcm825x.h"
> -
> -/*
> - * The sensor has two fps modes: the lower one just gives half the fps
> - * at the same xclk than the high one.
> - */
> -#define MAX_FPS 30
> -#define MIN_FPS 8
> -#define MAX_HALF_FPS (MAX_FPS / 2)
> -#define HIGH_FPS_MODE_LOWER_LIMIT 14
> -#define DEFAULT_FPS MAX_HALF_FPS
> -
> -struct tcm825x_sensor {
> -       const struct tcm825x_platform_data *platform_data;
> -       struct v4l2_int_device *v4l2_int_device;
> -       struct i2c_client *i2c_client;
> -       struct v4l2_pix_format pix;
> -       struct v4l2_fract timeperframe;
> -};
> -
> -/* list of image formats supported by TCM825X sensor */
> -static const struct v4l2_fmtdesc tcm825x_formats[] = {
> -       {
> -               .description = "YUYV (YUV 4:2:2), packed",
> -               .pixelformat = V4L2_PIX_FMT_UYVY,
> -       }, {
> -               /* Note:  V4L2 defines RGB565 as:
> -                *
> -                *      Byte 0                    Byte 1
> -                *      g2 g1 g0 r4 r3 r2 r1 r0   b4 b3 b2 b1 b0 g5 g4 g3
> -                *
> -                * We interpret RGB565 as:
> -                *
> -                *      Byte 0                    Byte 1
> -                *      g2 g1 g0 b4 b3 b2 b1 b0   r4 r3 r2 r1 r0 g5 g4 g3
> -                */
> -               .description = "RGB565, le",
> -               .pixelformat = V4L2_PIX_FMT_RGB565,
> -       },
> -};
> -
> -#define TCM825X_NUM_CAPTURE_FORMATS    ARRAY_SIZE(tcm825x_formats)
> -
> -/*
> - * TCM825X register configuration for all combinations of pixel format and
> - * image size
> - */
> -static const struct tcm825x_reg subqcif        =       { 0x20, TCM825X_PICSIZ };
> -static const struct tcm825x_reg qcif   =       { 0x18, TCM825X_PICSIZ };
> -static const struct tcm825x_reg cif    =       { 0x14, TCM825X_PICSIZ };
> -static const struct tcm825x_reg qqvga  =       { 0x0c, TCM825X_PICSIZ };
> -static const struct tcm825x_reg qvga   =       { 0x04, TCM825X_PICSIZ };
> -static const struct tcm825x_reg vga    =       { 0x00, TCM825X_PICSIZ };
> -
> -static const struct tcm825x_reg yuv422 =       { 0x00, TCM825X_PICFMT };
> -static const struct tcm825x_reg rgb565 =       { 0x02, TCM825X_PICFMT };
> -
> -/* Our own specific controls */
> -#define V4L2_CID_ALC                           V4L2_CID_PRIVATE_BASE
> -#define V4L2_CID_H_EDGE_EN                     V4L2_CID_PRIVATE_BASE + 1
> -#define V4L2_CID_V_EDGE_EN                     V4L2_CID_PRIVATE_BASE + 2
> -#define V4L2_CID_LENS                          V4L2_CID_PRIVATE_BASE + 3
> -#define V4L2_CID_MAX_EXPOSURE_TIME             V4L2_CID_PRIVATE_BASE + 4
> -#define V4L2_CID_LAST_PRIV                     V4L2_CID_MAX_EXPOSURE_TIME
> -
> -/*  Video controls  */
> -static struct vcontrol {
> -       struct v4l2_queryctrl qc;
> -       u16 reg;
> -       u16 start_bit;
> -} video_control[] = {
> -       {
> -               {
> -                       .id = V4L2_CID_GAIN,
> -                       .type = V4L2_CTRL_TYPE_INTEGER,
> -                       .name = "Gain",
> -                       .minimum = 0,
> -                       .maximum = 63,
> -                       .step = 1,
> -               },
> -               .reg = TCM825X_AG,
> -               .start_bit = 0,
> -       },
> -       {
> -               {
> -                       .id = V4L2_CID_RED_BALANCE,
> -                       .type = V4L2_CTRL_TYPE_INTEGER,
> -                       .name = "Red Balance",
> -                       .minimum = 0,
> -                       .maximum = 255,
> -                       .step = 1,
> -               },
> -               .reg = TCM825X_MRG,
> -               .start_bit = 0,
> -       },
> -       {
> -               {
> -                       .id = V4L2_CID_BLUE_BALANCE,
> -                       .type = V4L2_CTRL_TYPE_INTEGER,
> -                       .name = "Blue Balance",
> -                       .minimum = 0,
> -                       .maximum = 255,
> -                       .step = 1,
> -               },
> -               .reg = TCM825X_MBG,
> -               .start_bit = 0,
> -       },
> -       {
> -               {
> -                       .id = V4L2_CID_AUTO_WHITE_BALANCE,
> -                       .type = V4L2_CTRL_TYPE_BOOLEAN,
> -                       .name = "Auto White Balance",
> -                       .minimum = 0,
> -                       .maximum = 1,
> -                       .step = 0,
> -               },
> -               .reg = TCM825X_AWBSW,
> -               .start_bit = 7,
> -       },
> -       {
> -               {
> -                       .id = V4L2_CID_EXPOSURE,
> -                       .type = V4L2_CTRL_TYPE_INTEGER,
> -                       .name = "Exposure Time",
> -                       .minimum = 0,
> -                       .maximum = 0x1fff,
> -                       .step = 1,
> -               },
> -               .reg = TCM825X_ESRSPD_U,
> -               .start_bit = 0,
> -       },
> -       {
> -               {
> -                       .id = V4L2_CID_HFLIP,
> -                       .type = V4L2_CTRL_TYPE_BOOLEAN,
> -                       .name = "Mirror Image",
> -                       .minimum = 0,
> -                       .maximum = 1,
> -                       .step = 0,
> -               },
> -               .reg = TCM825X_H_INV,
> -               .start_bit = 6,
> -       },
> -       {
> -               {
> -                       .id = V4L2_CID_VFLIP,
> -                       .type = V4L2_CTRL_TYPE_BOOLEAN,
> -                       .name = "Vertical Flip",
> -                       .minimum = 0,
> -                       .maximum = 1,
> -                       .step = 0,
> -               },
> -               .reg = TCM825X_V_INV,
> -               .start_bit = 7,
> -       },
> -       /* Private controls */
> -       {
> -               {
> -                       .id = V4L2_CID_ALC,
> -                       .type = V4L2_CTRL_TYPE_BOOLEAN,
> -                       .name = "Auto Luminance Control",
> -                       .minimum = 0,
> -                       .maximum = 1,
> -                       .step = 0,
> -               },
> -               .reg = TCM825X_ALCSW,
> -               .start_bit = 7,
> -       },
> -       {
> -               {
> -                       .id = V4L2_CID_H_EDGE_EN,
> -                       .type = V4L2_CTRL_TYPE_INTEGER,
> -                       .name = "Horizontal Edge Enhancement",
> -                       .minimum = 0,
> -                       .maximum = 0xff,
> -                       .step = 1,
> -               },
> -               .reg = TCM825X_HDTG,
> -               .start_bit = 0,
> -       },
> -       {
> -               {
> -                       .id = V4L2_CID_V_EDGE_EN,
> -                       .type = V4L2_CTRL_TYPE_INTEGER,
> -                       .name = "Vertical Edge Enhancement",
> -                       .minimum = 0,
> -                       .maximum = 0xff,
> -                       .step = 1,
> -               },
> -               .reg = TCM825X_VDTG,
> -               .start_bit = 0,
> -       },
> -       {
> -               {
> -                       .id = V4L2_CID_LENS,
> -                       .type = V4L2_CTRL_TYPE_INTEGER,
> -                       .name = "Lens Shading Compensation",
> -                       .minimum = 0,
> -                       .maximum = 0x3f,
> -                       .step = 1,
> -               },
> -               .reg = TCM825X_LENS,
> -               .start_bit = 0,
> -       },
> -       {
> -               {
> -                       .id = V4L2_CID_MAX_EXPOSURE_TIME,
> -                       .type = V4L2_CTRL_TYPE_INTEGER,
> -                       .name = "Maximum Exposure Time",
> -                       .minimum = 0,
> -                       .maximum = 0x3,
> -                       .step = 1,
> -               },
> -               .reg = TCM825X_ESRLIM,
> -               .start_bit = 5,
> -       },
> -};
> -
> -
> -static const struct tcm825x_reg *tcm825x_siz_reg[NUM_IMAGE_SIZES] =
> -{ &subqcif, &qqvga, &qcif, &qvga, &cif, &vga };
> -
> -static const struct tcm825x_reg *tcm825x_fmt_reg[NUM_PIXEL_FORMATS] =
> -{ &yuv422, &rgb565 };
> -
> -/*
> - * Read a value from a register in an TCM825X sensor device.  The value is
> - * returned in 'val'.
> - * Returns zero if successful, or non-zero otherwise.
> - */
> -static int tcm825x_read_reg(struct i2c_client *client, int reg)
> -{
> -       int err;
> -       struct i2c_msg msg[2];
> -       u8 reg_buf, data_buf = 0;
> -
> -       if (!client->adapter)
> -               return -ENODEV;
> -
> -       msg[0].addr = client->addr;
> -       msg[0].flags = 0;
> -       msg[0].len = 1;
> -       msg[0].buf = &reg_buf;
> -       msg[1].addr = client->addr;
> -       msg[1].flags = I2C_M_RD;
> -       msg[1].len = 1;
> -       msg[1].buf = &data_buf;
> -
> -       reg_buf = reg;
> -
> -       err = i2c_transfer(client->adapter, msg, 2);
> -       if (err < 0)
> -               return err;
> -       return data_buf;
> -}
> -
> -/*
> - * Write a value to a register in an TCM825X sensor device.
> - * Returns zero if successful, or non-zero otherwise.
> - */
> -static int tcm825x_write_reg(struct i2c_client *client, u8 reg, u8 val)
> -{
> -       int err;
> -       struct i2c_msg msg[1];
> -       unsigned char data[2];
> -
> -       if (!client->adapter)
> -               return -ENODEV;
> -
> -       msg->addr = client->addr;
> -       msg->flags = 0;
> -       msg->len = 2;
> -       msg->buf = data;
> -       data[0] = reg;
> -       data[1] = val;
> -       err = i2c_transfer(client->adapter, msg, 1);
> -       if (err >= 0)
> -               return 0;
> -       return err;
> -}
> -
> -static int __tcm825x_write_reg_mask(struct i2c_client *client,
> -                                   u8 reg, u8 val, u8 mask)
> -{
> -       int rc;
> -
> -       /* need to do read - modify - write */
> -       rc = tcm825x_read_reg(client, reg);
> -       if (rc < 0)
> -               return rc;
> -
> -       rc &= (~mask);  /* Clear the masked bits */
> -       val &= mask;    /* Enforce mask on value */
> -       val |= rc;
> -
> -       /* write the new value to the register */
> -       rc = tcm825x_write_reg(client, reg, val);
> -       if (rc)
> -               return rc;
> -
> -       return 0;
> -}
> -
> -#define tcm825x_write_reg_mask(client, regmask, val)                   \
> -       __tcm825x_write_reg_mask(client, TCM825X_ADDR((regmask)), val,  \
> -                                TCM825X_MASK((regmask)))
> -
> -
> -/*
> - * Initialize a list of TCM825X registers.
> - * The list of registers is terminated by the pair of values
> - * { TCM825X_REG_TERM, TCM825X_VAL_TERM }.
> - * Returns zero if successful, or non-zero otherwise.
> - */
> -static int tcm825x_write_default_regs(struct i2c_client *client,
> -                                     const struct tcm825x_reg *reglist)
> -{
> -       int err;
> -       const struct tcm825x_reg *next = reglist;
> -
> -       while (!((next->reg == TCM825X_REG_TERM)
> -                && (next->val == TCM825X_VAL_TERM))) {
> -               err = tcm825x_write_reg(client, next->reg, next->val);
> -               if (err) {
> -                       dev_err(&client->dev, "register writing failed\n");
> -                       return err;
> -               }
> -               next++;
> -       }
> -
> -       return 0;
> -}
> -
> -static struct vcontrol *find_vctrl(int id)
> -{
> -       int i;
> -
> -       if (id < V4L2_CID_BASE)
> -               return NULL;
> -
> -       for (i = 0; i < ARRAY_SIZE(video_control); i++)
> -               if (video_control[i].qc.id == id)
> -                       return &video_control[i];
> -
> -       return NULL;
> -}
> -
> -/*
> - * Find the best match for a requested image capture size.  The best match
> - * is chosen as the nearest match that has the same number or fewer pixels
> - * as the requested size, or the smallest image size if the requested size
> - * has fewer pixels than the smallest image.
> - */
> -static enum image_size tcm825x_find_size(struct v4l2_int_device *s,
> -                                        unsigned int width,
> -                                        unsigned int height)
> -{
> -       enum image_size isize;
> -       unsigned long pixels = width * height;
> -       struct tcm825x_sensor *sensor = s->priv;
> -
> -       for (isize = subQCIF; isize < VGA; isize++) {
> -               if (tcm825x_sizes[isize + 1].height
> -                   * tcm825x_sizes[isize + 1].width > pixels) {
> -                       dev_dbg(&sensor->i2c_client->dev, "size %d\n", isize);
> -
> -                       return isize;
> -               }
> -       }
> -
> -       dev_dbg(&sensor->i2c_client->dev, "format default VGA\n");
> -
> -       return VGA;
> -}
> -
> -/*
> - * Configure the TCM825X for current image size, pixel format, and
> - * frame period. fper is the frame period (in seconds) expressed as a
> - * fraction. Returns zero if successful, or non-zero otherwise. The
> - * actual frame period is returned in fper.
> - */
> -static int tcm825x_configure(struct v4l2_int_device *s)
> -{
> -       struct tcm825x_sensor *sensor = s->priv;
> -       struct v4l2_pix_format *pix = &sensor->pix;
> -       enum image_size isize = tcm825x_find_size(s, pix->width, pix->height);
> -       struct v4l2_fract *fper = &sensor->timeperframe;
> -       enum pixel_format pfmt;
> -       int err;
> -       u32 tgt_fps;
> -       u8 val;
> -
> -       /* common register initialization */
> -       err = tcm825x_write_default_regs(
> -               sensor->i2c_client, sensor->platform_data->default_regs());
> -       if (err)
> -               return err;
> -
> -       /* configure image size */
> -       val = tcm825x_siz_reg[isize]->val;
> -       dev_dbg(&sensor->i2c_client->dev,
> -               "configuring image size %d\n", isize);
> -       err = tcm825x_write_reg_mask(sensor->i2c_client,
> -                                    tcm825x_siz_reg[isize]->reg, val);
> -       if (err)
> -               return err;
> -
> -       /* configure pixel format */
> -       switch (pix->pixelformat) {
> -       default:
> -       case V4L2_PIX_FMT_RGB565:
> -               pfmt = RGB565;
> -               break;
> -       case V4L2_PIX_FMT_UYVY:
> -               pfmt = YUV422;
> -               break;
> -       }
> -
> -       dev_dbg(&sensor->i2c_client->dev,
> -               "configuring pixel format %d\n", pfmt);
> -       val = tcm825x_fmt_reg[pfmt]->val;
> -
> -       err = tcm825x_write_reg_mask(sensor->i2c_client,
> -                                    tcm825x_fmt_reg[pfmt]->reg, val);
> -       if (err)
> -               return err;
> -
> -       /*
> -        * For frame rate < 15, the FPS reg (addr 0x02, bit 7) must be
> -        * set. Frame rate will be halved from the normal.
> -        */
> -       tgt_fps = fper->denominator / fper->numerator;
> -       if (tgt_fps <= HIGH_FPS_MODE_LOWER_LIMIT) {
> -               val = tcm825x_read_reg(sensor->i2c_client, 0x02);
> -               val |= 0x80;
> -               tcm825x_write_reg(sensor->i2c_client, 0x02, val);
> -       }
> -
> -       return 0;
> -}
> -
> -static int ioctl_queryctrl(struct v4l2_int_device *s,
> -                               struct v4l2_queryctrl *qc)
> -{
> -       struct vcontrol *control;
> -
> -       control = find_vctrl(qc->id);
> -
> -       if (control == NULL)
> -               return -EINVAL;
> -
> -       *qc = control->qc;
> -
> -       return 0;
> -}
> -
> -static int ioctl_g_ctrl(struct v4l2_int_device *s,
> -                            struct v4l2_control *vc)
> -{
> -       struct tcm825x_sensor *sensor = s->priv;
> -       struct i2c_client *client = sensor->i2c_client;
> -       int val, r;
> -       struct vcontrol *lvc;
> -
> -       /* exposure time is special, spread across 2 registers */
> -       if (vc->id == V4L2_CID_EXPOSURE) {
> -               int val_lower, val_upper;
> -
> -               val_upper = tcm825x_read_reg(client,
> -                                            TCM825X_ADDR(TCM825X_ESRSPD_U));
> -               if (val_upper < 0)
> -                       return val_upper;
> -               val_lower = tcm825x_read_reg(client,
> -                                            TCM825X_ADDR(TCM825X_ESRSPD_L));
> -               if (val_lower < 0)
> -                       return val_lower;
> -
> -               vc->value = ((val_upper & 0x1f) << 8) | (val_lower);
> -               return 0;
> -       }
> -
> -       lvc = find_vctrl(vc->id);
> -       if (lvc == NULL)
> -               return -EINVAL;
> -
> -       r = tcm825x_read_reg(client, TCM825X_ADDR(lvc->reg));
> -       if (r < 0)
> -               return r;
> -       val = r & TCM825X_MASK(lvc->reg);
> -       val >>= lvc->start_bit;
> -
> -       if (val < 0)
> -               return val;
> -
> -       if (vc->id == V4L2_CID_HFLIP || vc->id == V4L2_CID_VFLIP)
> -               val ^= sensor->platform_data->is_upside_down();
> -
> -       vc->value = val;
> -       return 0;
> -}
> -
> -static int ioctl_s_ctrl(struct v4l2_int_device *s,
> -                            struct v4l2_control *vc)
> -{
> -       struct tcm825x_sensor *sensor = s->priv;
> -       struct i2c_client *client = sensor->i2c_client;
> -       struct vcontrol *lvc;
> -       int val = vc->value;
> -
> -       /* exposure time is special, spread across 2 registers */
> -       if (vc->id == V4L2_CID_EXPOSURE) {
> -               int val_lower, val_upper;
> -               val_lower = val & TCM825X_MASK(TCM825X_ESRSPD_L);
> -               val_upper = (val >> 8) & TCM825X_MASK(TCM825X_ESRSPD_U);
> -
> -               if (tcm825x_write_reg_mask(client,
> -                                          TCM825X_ESRSPD_U, val_upper))
> -                       return -EIO;
> -
> -               if (tcm825x_write_reg_mask(client,
> -                                          TCM825X_ESRSPD_L, val_lower))
> -                       return -EIO;
> -
> -               return 0;
> -       }
> -
> -       lvc = find_vctrl(vc->id);
> -       if (lvc == NULL)
> -               return -EINVAL;
> -
> -       if (vc->id == V4L2_CID_HFLIP || vc->id == V4L2_CID_VFLIP)
> -               val ^= sensor->platform_data->is_upside_down();
> -
> -       val = val << lvc->start_bit;
> -       if (tcm825x_write_reg_mask(client, lvc->reg, val))
> -               return -EIO;
> -
> -       return 0;
> -}
> -
> -static int ioctl_enum_fmt_cap(struct v4l2_int_device *s,
> -                                  struct v4l2_fmtdesc *fmt)
> -{
> -       int index = fmt->index;
> -
> -       switch (fmt->type) {
> -       case V4L2_BUF_TYPE_VIDEO_CAPTURE:
> -               if (index >= TCM825X_NUM_CAPTURE_FORMATS)
> -                       return -EINVAL;
> -               break;
> -
> -       default:
> -               return -EINVAL;
> -       }
> -
> -       fmt->flags = tcm825x_formats[index].flags;
> -       strlcpy(fmt->description, tcm825x_formats[index].description,
> -               sizeof(fmt->description));
> -       fmt->pixelformat = tcm825x_formats[index].pixelformat;
> -
> -       return 0;
> -}
> -
> -static int ioctl_try_fmt_cap(struct v4l2_int_device *s,
> -                            struct v4l2_format *f)
> -{
> -       struct tcm825x_sensor *sensor = s->priv;
> -       enum image_size isize;
> -       int ifmt;
> -       struct v4l2_pix_format *pix = &f->fmt.pix;
> -
> -       isize = tcm825x_find_size(s, pix->width, pix->height);
> -       dev_dbg(&sensor->i2c_client->dev, "isize = %d num_capture = %lu\n",
> -               isize, (unsigned long)TCM825X_NUM_CAPTURE_FORMATS);
> -
> -       pix->width = tcm825x_sizes[isize].width;
> -       pix->height = tcm825x_sizes[isize].height;
> -
> -       for (ifmt = 0; ifmt < TCM825X_NUM_CAPTURE_FORMATS; ifmt++)
> -               if (pix->pixelformat == tcm825x_formats[ifmt].pixelformat)
> -                       break;
> -
> -       if (ifmt == TCM825X_NUM_CAPTURE_FORMATS)
> -               ifmt = 0;       /* Default = YUV 4:2:2 */
> -
> -       pix->pixelformat = tcm825x_formats[ifmt].pixelformat;
> -       pix->field = V4L2_FIELD_NONE;
> -       pix->bytesperline = pix->width * TCM825X_BYTES_PER_PIXEL;
> -       pix->sizeimage = pix->bytesperline * pix->height;
> -       pix->priv = 0;
> -       dev_dbg(&sensor->i2c_client->dev, "format = 0x%08x\n",
> -               pix->pixelformat);
> -
> -       switch (pix->pixelformat) {
> -       case V4L2_PIX_FMT_UYVY:
> -       default:
> -               pix->colorspace = V4L2_COLORSPACE_JPEG;
> -               break;
> -       case V4L2_PIX_FMT_RGB565:
> -               pix->colorspace = V4L2_COLORSPACE_SRGB;
> -               break;
> -       }
> -
> -       return 0;
> -}
> -
> -static int ioctl_s_fmt_cap(struct v4l2_int_device *s,
> -                               struct v4l2_format *f)
> -{
> -       struct tcm825x_sensor *sensor = s->priv;
> -       struct v4l2_pix_format *pix = &f->fmt.pix;
> -       int rval;
> -
> -       rval = ioctl_try_fmt_cap(s, f);
> -       if (rval)
> -               return rval;
> -
> -       rval = tcm825x_configure(s);
> -
> -       sensor->pix = *pix;
> -
> -       return rval;
> -}
> -
> -static int ioctl_g_fmt_cap(struct v4l2_int_device *s,
> -                               struct v4l2_format *f)
> -{
> -       struct tcm825x_sensor *sensor = s->priv;
> -
> -       f->fmt.pix = sensor->pix;
> -
> -       return 0;
> -}
> -
> -static int ioctl_g_parm(struct v4l2_int_device *s,
> -                            struct v4l2_streamparm *a)
> -{
> -       struct tcm825x_sensor *sensor = s->priv;
> -       struct v4l2_captureparm *cparm = &a->parm.capture;
> -
> -       if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> -               return -EINVAL;
> -
> -       memset(a, 0, sizeof(*a));
> -       a->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> -
> -       cparm->capability = V4L2_CAP_TIMEPERFRAME;
> -       cparm->timeperframe = sensor->timeperframe;
> -
> -       return 0;
> -}
> -
> -static int ioctl_s_parm(struct v4l2_int_device *s,
> -                            struct v4l2_streamparm *a)
> -{
> -       struct tcm825x_sensor *sensor = s->priv;
> -       struct v4l2_fract *timeperframe = &a->parm.capture.timeperframe;
> -       u32 tgt_fps;    /* target frames per secound */
> -       int rval;
> -
> -       if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> -               return -EINVAL;
> -
> -       if ((timeperframe->numerator == 0)
> -           || (timeperframe->denominator == 0)) {
> -               timeperframe->denominator = DEFAULT_FPS;
> -               timeperframe->numerator = 1;
> -       }
> -
> -       tgt_fps = timeperframe->denominator / timeperframe->numerator;
> -
> -       if (tgt_fps > MAX_FPS) {
> -               timeperframe->denominator = MAX_FPS;
> -               timeperframe->numerator = 1;
> -       } else if (tgt_fps < MIN_FPS) {
> -               timeperframe->denominator = MIN_FPS;
> -               timeperframe->numerator = 1;
> -       }
> -
> -       sensor->timeperframe = *timeperframe;
> -
> -       rval = tcm825x_configure(s);
> -
> -       return rval;
> -}
> -
> -static int ioctl_s_power(struct v4l2_int_device *s, int on)
> -{
> -       struct tcm825x_sensor *sensor = s->priv;
> -
> -       return sensor->platform_data->power_set(on);
> -}
> -
> -/*
> - * Given the image capture format in pix, the nominal frame period in
> - * timeperframe, calculate the required xclk frequency.
> - *
> - * TCM825X input frequency characteristics are:
> - *     Minimum 11.9 MHz, Typical 24.57 MHz and maximum 25/27 MHz
> - */
> -
> -static int ioctl_g_ifparm(struct v4l2_int_device *s, struct v4l2_ifparm *p)
> -{
> -       struct tcm825x_sensor *sensor = s->priv;
> -       struct v4l2_fract *timeperframe = &sensor->timeperframe;
> -       u32 tgt_xclk;   /* target xclk */
> -       u32 tgt_fps;    /* target frames per secound */
> -       int rval;
> -
> -       rval = sensor->platform_data->ifparm(p);
> -       if (rval)
> -               return rval;
> -
> -       tgt_fps = timeperframe->denominator / timeperframe->numerator;
> -
> -       tgt_xclk = (tgt_fps <= HIGH_FPS_MODE_LOWER_LIMIT) ?
> -               (2457 * tgt_fps) / MAX_HALF_FPS :
> -               (2457 * tgt_fps) / MAX_FPS;
> -       tgt_xclk *= 10000;
> -
> -       tgt_xclk = min(tgt_xclk, (u32)TCM825X_XCLK_MAX);
> -       tgt_xclk = max(tgt_xclk, (u32)TCM825X_XCLK_MIN);
> -
> -       p->u.bt656.clock_curr = tgt_xclk;
> -
> -       return 0;
> -}
> -
> -static int ioctl_g_needs_reset(struct v4l2_int_device *s, void *buf)
> -{
> -       struct tcm825x_sensor *sensor = s->priv;
> -
> -       return sensor->platform_data->needs_reset(s, buf, &sensor->pix);
> -}
> -
> -static int ioctl_reset(struct v4l2_int_device *s)
> -{
> -       return -EBUSY;
> -}
> -
> -static int ioctl_init(struct v4l2_int_device *s)
> -{
> -       return tcm825x_configure(s);
> -}
> -
> -static int ioctl_dev_exit(struct v4l2_int_device *s)
> -{
> -       return 0;
> -}
> -
> -static int ioctl_dev_init(struct v4l2_int_device *s)
> -{
> -       struct tcm825x_sensor *sensor = s->priv;
> -       int r;
> -
> -       r = tcm825x_read_reg(sensor->i2c_client, 0x01);
> -       if (r < 0)
> -               return r;
> -       if (r == 0) {
> -               dev_err(&sensor->i2c_client->dev, "device not detected\n");
> -               return -EIO;
> -       }
> -       return 0;
> -}
> -
> -static struct v4l2_int_ioctl_desc tcm825x_ioctl_desc[] = {
> -       { vidioc_int_dev_init_num,
> -         (v4l2_int_ioctl_func *)ioctl_dev_init },
> -       { vidioc_int_dev_exit_num,
> -         (v4l2_int_ioctl_func *)ioctl_dev_exit },
> -       { vidioc_int_s_power_num,
> -         (v4l2_int_ioctl_func *)ioctl_s_power },
> -       { vidioc_int_g_ifparm_num,
> -         (v4l2_int_ioctl_func *)ioctl_g_ifparm },
> -       { vidioc_int_g_needs_reset_num,
> -         (v4l2_int_ioctl_func *)ioctl_g_needs_reset },
> -       { vidioc_int_reset_num,
> -         (v4l2_int_ioctl_func *)ioctl_reset },
> -       { vidioc_int_init_num,
> -         (v4l2_int_ioctl_func *)ioctl_init },
> -       { vidioc_int_enum_fmt_cap_num,
> -         (v4l2_int_ioctl_func *)ioctl_enum_fmt_cap },
> -       { vidioc_int_try_fmt_cap_num,
> -         (v4l2_int_ioctl_func *)ioctl_try_fmt_cap },
> -       { vidioc_int_g_fmt_cap_num,
> -         (v4l2_int_ioctl_func *)ioctl_g_fmt_cap },
> -       { vidioc_int_s_fmt_cap_num,
> -         (v4l2_int_ioctl_func *)ioctl_s_fmt_cap },
> -       { vidioc_int_g_parm_num,
> -         (v4l2_int_ioctl_func *)ioctl_g_parm },
> -       { vidioc_int_s_parm_num,
> -         (v4l2_int_ioctl_func *)ioctl_s_parm },
> -       { vidioc_int_queryctrl_num,
> -         (v4l2_int_ioctl_func *)ioctl_queryctrl },
> -       { vidioc_int_g_ctrl_num,
> -         (v4l2_int_ioctl_func *)ioctl_g_ctrl },
> -       { vidioc_int_s_ctrl_num,
> -         (v4l2_int_ioctl_func *)ioctl_s_ctrl },
> -};
> -
> -static struct v4l2_int_slave tcm825x_slave = {
> -       .ioctls = tcm825x_ioctl_desc,
> -       .num_ioctls = ARRAY_SIZE(tcm825x_ioctl_desc),
> -};
> -
> -static struct tcm825x_sensor tcm825x;
> -
> -static struct v4l2_int_device tcm825x_int_device = {
> -       .module = THIS_MODULE,
> -       .name = TCM825X_NAME,
> -       .priv = &tcm825x,
> -       .type = v4l2_int_type_slave,
> -       .u = {
> -               .slave = &tcm825x_slave,
> -       },
> -};
> -
> -static int tcm825x_probe(struct i2c_client *client,
> -                        const struct i2c_device_id *did)
> -{
> -       struct tcm825x_sensor *sensor = &tcm825x;
> -
> -       if (i2c_get_clientdata(client))
> -               return -EBUSY;
> -
> -       sensor->platform_data = client->dev.platform_data;
> -
> -       if (sensor->platform_data == NULL
> -           || !sensor->platform_data->is_okay())
> -               return -ENODEV;
> -
> -       sensor->v4l2_int_device = &tcm825x_int_device;
> -
> -       sensor->i2c_client = client;
> -       i2c_set_clientdata(client, sensor);
> -
> -       /* Make the default capture format QVGA RGB565 */
> -       sensor->pix.width = tcm825x_sizes[QVGA].width;
> -       sensor->pix.height = tcm825x_sizes[QVGA].height;
> -       sensor->pix.pixelformat = V4L2_PIX_FMT_RGB565;
> -
> -       return v4l2_int_device_register(sensor->v4l2_int_device);
> -}
> -
> -static int tcm825x_remove(struct i2c_client *client)
> -{
> -       struct tcm825x_sensor *sensor = i2c_get_clientdata(client);
> -
> -       if (!client->adapter)
> -               return -ENODEV; /* our client isn't attached */
> -
> -       v4l2_int_device_unregister(sensor->v4l2_int_device);
> -
> -       return 0;
> -}
> -
> -static const struct i2c_device_id tcm825x_id[] = {
> -       { "tcm825x", 0 },
> -       { }
> -};
> -MODULE_DEVICE_TABLE(i2c, tcm825x_id);
> -
> -static struct i2c_driver tcm825x_i2c_driver = {
> -       .driver = {
> -               .name = TCM825X_NAME,
> -       },
> -       .probe  = tcm825x_probe,
> -       .remove = tcm825x_remove,
> -       .id_table = tcm825x_id,
> -};
> -
> -static struct tcm825x_sensor tcm825x = {
> -       .timeperframe = {
> -               .numerator   = 1,
> -               .denominator = DEFAULT_FPS,
> -       },
> -};
> -
> -static int __init tcm825x_init(void)
> -{
> -       int rval;
> -
> -       rval = i2c_add_driver(&tcm825x_i2c_driver);
> -       if (rval)
> -               printk(KERN_INFO "%s: failed registering " TCM825X_NAME "\n",
> -                      __func__);
> -
> -       return rval;
> -}
> -
> -static void __exit tcm825x_exit(void)
> -{
> -       i2c_del_driver(&tcm825x_i2c_driver);
> -}
> -
> -/*
> - * FIXME: Menelaus isn't ready (?) at module_init stage, so use
> - * late_initcall for now.
> - */
> -late_initcall(tcm825x_init);
> -module_exit(tcm825x_exit);
> -
> -MODULE_AUTHOR("Sakari Ailus <sakari.ailus@nokia.com>");
> -MODULE_DESCRIPTION("TCM825x camera sensor driver");
> -MODULE_LICENSE("GPL");
> diff --git a/drivers/media/i2c/tcm825x.h b/drivers/media/i2c/tcm825x.h
> deleted file mode 100644
> index 8ebab95..0000000
> --- a/drivers/media/i2c/tcm825x.h
> +++ /dev/null
> @@ -1,200 +0,0 @@
> -/*
> - * drivers/media/i2c/tcm825x.h
> - *
> - * Register definitions for the TCM825X CameraChip.
> - *
> - * Author: David Cohen (david.cohen@indt.org.br)
> - *
> - * This file is licensed under the terms of the GNU General Public License
> - * version 2. This program is licensed "as is" without any warranty of any
> - * kind, whether express or implied.
> - *
> - * This file was based on ov9640.h from MontaVista
> - */
> -
> -#ifndef TCM825X_H
> -#define TCM825X_H
> -
> -#include <linux/videodev2.h>
> -
> -#include <media/v4l2-int-device.h>
> -
> -#define TCM825X_NAME "tcm825x"
> -
> -#define TCM825X_MASK(x)  x & 0x00ff
> -#define TCM825X_ADDR(x) (x & 0xff00) >> 8
> -
> -/* The TCM825X I2C sensor chip has a fixed slave address of 0x3d. */
> -#define TCM825X_I2C_ADDR       0x3d
> -
> -/*
> - * define register offsets for the TCM825X sensor chip
> - * OFFSET(8 bits) + MASK(8 bits)
> - * MASK bit 4 and 3 are used when the register uses more than one address
> - */
> -#define TCM825X_FPS            0x0280
> -#define TCM825X_ACF            0x0240
> -#define TCM825X_DOUTBUF                0x020C
> -#define TCM825X_DCLKP          0x0202
> -#define TCM825X_ACFDET         0x0201
> -#define TCM825X_DOUTSW         0x0380
> -#define TCM825X_DATAHZ         0x0340
> -#define TCM825X_PICSIZ         0x033c
> -#define TCM825X_PICFMT         0x0302
> -#define TCM825X_V_INV          0x0480
> -#define TCM825X_H_INV          0x0440
> -#define TCM825X_ESRLSW         0x0430
> -#define TCM825X_V_LENGTH       0x040F
> -#define TCM825X_ALCSW          0x0580
> -#define TCM825X_ESRLIM         0x0560
> -#define TCM825X_ESRSPD_U        0x051F
> -#define TCM825X_ESRSPD_L        0x06FF
> -#define TCM825X_AG             0x07FF
> -#define TCM825X_ESRSPD2         0x06FF
> -#define TCM825X_ALCMODE         0x0830
> -#define TCM825X_ALCH            0x080F
> -#define TCM825X_ALCL            0x09FF
> -#define TCM825X_AWBSW           0x0A80
> -#define TCM825X_MRG             0x0BFF
> -#define TCM825X_MBG             0x0CFF
> -#define TCM825X_GAMSW           0x0D80
> -#define TCM825X_HDTG            0x0EFF
> -#define TCM825X_VDTG            0x0FFF
> -#define TCM825X_HDTCORE         0x10F0
> -#define TCM825X_VDTCORE         0x100F
> -#define TCM825X_CONT            0x11FF
> -#define TCM825X_BRIGHT          0x12FF
> -#define TCM825X_VHUE            0x137F
> -#define TCM825X_UHUE            0x147F
> -#define TCM825X_VGAIN           0x153F
> -#define TCM825X_UGAIN           0x163F
> -#define TCM825X_UVCORE          0x170F
> -#define TCM825X_SATU            0x187F
> -#define TCM825X_MHMODE          0x1980
> -#define TCM825X_MHLPFSEL        0x1940
> -#define TCM825X_YMODE           0x1930
> -#define TCM825X_MIXHG           0x1907
> -#define TCM825X_LENS            0x1A3F
> -#define TCM825X_AGLIM           0x1BE0
> -#define TCM825X_LENSRPOL        0x1B10
> -#define TCM825X_LENSRGAIN       0x1B0F
> -#define TCM825X_ES100S          0x1CFF
> -#define TCM825X_ES120S          0x1DFF
> -#define TCM825X_DMASK           0x1EC0
> -#define TCM825X_CODESW          0x1E20
> -#define TCM825X_CODESEL         0x1E10
> -#define TCM825X_TESPIC          0x1E04
> -#define TCM825X_PICSEL          0x1E03
> -#define TCM825X_HNUM            0x20FF
> -#define TCM825X_VOUTPH          0x287F
> -#define TCM825X_ESROUT          0x327F
> -#define TCM825X_ESROUT2         0x33FF
> -#define TCM825X_AGOUT           0x34FF
> -#define TCM825X_DGOUT           0x353F
> -#define TCM825X_AGSLOW1         0x39C0
> -#define TCM825X_FLLSMODE        0x3930
> -#define TCM825X_FLLSLIM         0x390F
> -#define TCM825X_DETSEL          0x3AF0
> -#define TCM825X_ACDETNC         0x3A0F
> -#define TCM825X_AGSLOW2         0x3BC0
> -#define TCM825X_DG              0x3B3F
> -#define TCM825X_REJHLEV         0x3CFF
> -#define TCM825X_ALCLOCK         0x3D80
> -#define TCM825X_FPSLNKSW        0x3D40
> -#define TCM825X_ALCSPD          0x3D30
> -#define TCM825X_REJH            0x3D03
> -#define TCM825X_SHESRSW         0x3E80
> -#define TCM825X_ESLIMSEL        0x3E40
> -#define TCM825X_SHESRSPD        0x3E30
> -#define TCM825X_ELSTEP          0x3E0C
> -#define TCM825X_ELSTART         0x3E03
> -#define TCM825X_AGMIN           0x3FFF
> -#define TCM825X_PREGRG          0x423F
> -#define TCM825X_PREGBG          0x433F
> -#define TCM825X_PRERG           0x443F
> -#define TCM825X_PREBG           0x453F
> -#define TCM825X_MSKBR           0x477F
> -#define TCM825X_MSKGR           0x487F
> -#define TCM825X_MSKRB           0x497F
> -#define TCM825X_MSKGB           0x4A7F
> -#define TCM825X_MSKRG           0x4B7F
> -#define TCM825X_MSKBG           0x4C7F
> -#define TCM825X_HDTCSW          0x4D80
> -#define TCM825X_VDTCSW          0x4D40
> -#define TCM825X_DTCYL           0x4D3F
> -#define TCM825X_HDTPSW          0x4E80
> -#define TCM825X_VDTPSW          0x4E40
> -#define TCM825X_DTCGAIN         0x4E3F
> -#define TCM825X_DTLLIMSW        0x4F10
> -#define TCM825X_DTLYLIM         0x4F0F
> -#define TCM825X_YLCUTLMSK       0x5080
> -#define TCM825X_YLCUTL          0x503F
> -#define TCM825X_YLCUTHMSK       0x5180
> -#define TCM825X_YLCUTH          0x513F
> -#define TCM825X_UVSKNC          0x527F
> -#define TCM825X_UVLJ            0x537F
> -#define TCM825X_WBGMIN          0x54FF
> -#define TCM825X_WBGMAX          0x55FF
> -#define TCM825X_WBSPDUP         0x5603
> -#define TCM825X_ALLAREA         0x5820
> -#define TCM825X_WBLOCK          0x5810
> -#define TCM825X_WB2SP           0x580F
> -#define TCM825X_KIZUSW          0x5920
> -#define TCM825X_PBRSW           0x5910
> -#define TCM825X_ABCSW           0x5903
> -#define TCM825X_PBDLV           0x5AFF
> -#define TCM825X_PBC1LV          0x5BFF
> -
> -#define TCM825X_NUM_REGS       (TCM825X_ADDR(TCM825X_PBC1LV) + 1)
> -
> -#define TCM825X_BYTES_PER_PIXEL 2
> -
> -#define TCM825X_REG_TERM 0xff          /* terminating list entry for reg */
> -#define TCM825X_VAL_TERM 0xff          /* terminating list entry for val */
> -
> -/* define a structure for tcm825x register initialization values */
> -struct tcm825x_reg {
> -       u8 val;
> -       u16 reg;
> -};
> -
> -enum image_size { subQCIF = 0, QQVGA, QCIF, QVGA, CIF, VGA };
> -enum pixel_format { YUV422 = 0, RGB565 };
> -#define NUM_IMAGE_SIZES 6
> -#define NUM_PIXEL_FORMATS 2
> -
> -#define TCM825X_XCLK_MIN       11900000
> -#define TCM825X_XCLK_MAX       25000000
> -
> -struct capture_size {
> -       unsigned long width;
> -       unsigned long height;
> -};
> -
> -struct tcm825x_platform_data {
> -       /* Is the sensor usable? Doesn't yet mean it's there, but you
> -        * can try! */
> -       int (*is_okay)(void);
> -       /* Set power state, zero is off, non-zero is on. */
> -       int (*power_set)(int power);
> -       /* Default registers written after power-on or reset. */
> -       const struct tcm825x_reg *(*default_regs)(void);
> -       int (*needs_reset)(struct v4l2_int_device *s, void *buf,
> -                          struct v4l2_pix_format *fmt);
> -       int (*ifparm)(struct v4l2_ifparm *p);
> -       int (*is_upside_down)(void);
> -};
> -
> -/* Array of image sizes supported by TCM825X.  These must be ordered from
> - * smallest image size to largest.
> - */
> -static const struct capture_size tcm825x_sizes[] = {
> -       { 128,  96 }, /* subQCIF */
> -       { 160, 120 }, /* QQVGA */
> -       { 176, 144 }, /* QCIF */
> -       { 320, 240 }, /* QVGA */
> -       { 352, 288 }, /* CIF */
> -       { 640, 480 }, /* VGA */
> -};
> -
> -#endif /* ifndef TCM825X_H */
> --
> 1.7.2.5
>
