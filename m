Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f170.google.com ([209.85.217.170]:38342 "EHLO
        mail-ua0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934173AbeCBPoY (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Mar 2018 10:44:24 -0500
Received: by mail-ua0-f170.google.com with SMTP id f5so6310556uam.5
        for <linux-media@vger.kernel.org>; Fri, 02 Mar 2018 07:44:23 -0800 (PST)
Received: from mail-ua0-f182.google.com (mail-ua0-f182.google.com. [209.85.217.182])
        by smtp.gmail.com with ESMTPSA id h128sm2234277vkd.7.2018.03.02.07.44.21
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 02 Mar 2018 07:44:21 -0800 (PST)
Received: by mail-ua0-f182.google.com with SMTP id z3so6284775uae.12
        for <linux-media@vger.kernel.org>; Fri, 02 Mar 2018 07:44:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1520002549-6564-1-git-send-email-andy.yeh@intel.com>
References: <1520002549-6564-1-git-send-email-andy.yeh@intel.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Sat, 3 Mar 2018 00:43:59 +0900
Message-ID: <CAAFQd5D1a1Wd0ns85rkg8cJwK+y9uYzaS=c46efOniuGhvFk+w@mail.gmail.com>
Subject: Re: [PATCH v6] media: imx258: Add imx258 camera sensor driver
To: Andy Yeh <andy.yeh@intel.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        jasonx.z.chen@intel.com, Alan Chiang <alanx.chiang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andy,

Thanks for the patch. Let me post some comments inline.

On Fri, Mar 2, 2018 at 11:55 PM, Andy Yeh <andy.yeh@intel.com> wrote:
> Add a V4L2 sub-device driver for the Sony IMX258 image sensor.
> This is a camera sensor using the I2C bus for control and the
> CSI-2 bus for data.
>
> Signed-off-by: Jason Chen <jasonx.z.chen@intel.com>
> Signed-off-by: Alan Chiang <alanx.chiang@intel.com>
> ---
> since v2:
> -- Update the streaming function to remove SW_STANDBY in the beginning.
> -- Adjust the delay time from 1ms to 12ms before set stream-on register.
> since v3:
> -- fix the sd.entity to make code be compiled on the mainline kernel.
> since v4:
> -- Enabled AG, DG, and Exposure time control correctly.
> since v5:
> -- Sensor vendor provided a new setting to fix different CLK issue
> -- Add one more resolution for 1048x780, used for VGA streaming
>
>  MAINTAINERS                |    7 +
>  drivers/media/i2c/Kconfig  |   11 +
>  drivers/media/i2c/Makefile |    1 +
>  drivers/media/i2c/imx258.c | 1341 ++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 1360 insertions(+)
>  create mode 100644 drivers/media/i2c/imx258.c
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index a339bb5..9f75510 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -12646,6 +12646,13 @@ S:     Maintained
>  F:     drivers/ssb/
>  F:     include/linux/ssb/
>
> +SONY IMX258 SENSOR DRIVER
> +M:     Sakari Ailus <sakari.ailus@linux.intel.com>
> +L:     linux-media@vger.kernel.org
> +T:     git git://linuxtv.org/media_tree.git
> +S:     Maintained
> +F:     drivers/media/i2c/imx258.c
> +
>  SONY IMX274 SENSOR DRIVER
>  M:     Leon Luo <leonl@leopardimaging.com>
>  L:     linux-media@vger.kernel.org
> diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
> index fd01842..bcd4bf1 100644
> --- a/drivers/media/i2c/Kconfig
> +++ b/drivers/media/i2c/Kconfig
> @@ -565,6 +565,17 @@ config VIDEO_APTINA_PLL
>  config VIDEO_SMIAPP_PLL
>         tristate
>
> +config VIDEO_IMX258
> +       tristate "Sony IMX258 sensor support"
> +       depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
> +       depends on MEDIA_CAMERA_SUPPORT
> +       ---help---
> +         This is a Video4Linux2 sensor-level driver for the Sony
> +         IMX258 camera.
> +
> +         To compile this driver as a module, choose M here: the
> +         module will be called imx258.
> +
>  config VIDEO_IMX274
>         tristate "Sony IMX274 sensor support"
>         depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
> diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
> index 1b62639..4bf7d00 100644
> --- a/drivers/media/i2c/Makefile
> +++ b/drivers/media/i2c/Makefile
> @@ -94,6 +94,7 @@ obj-$(CONFIG_VIDEO_IR_I2C)  += ir-kbd-i2c.o
>  obj-$(CONFIG_VIDEO_ML86V7667)  += ml86v7667.o
>  obj-$(CONFIG_VIDEO_OV2659)     += ov2659.o
>  obj-$(CONFIG_VIDEO_TC358743)   += tc358743.o
> +obj-$(CONFIG_VIDEO_IMX258)     += imx258.o
>  obj-$(CONFIG_VIDEO_IMX274)     += imx274.o
>
>  obj-$(CONFIG_SDR_MAX2175) += max2175.o
> diff --git a/drivers/media/i2c/imx258.c b/drivers/media/i2c/imx258.c
> new file mode 100644
> index 0000000..0418edd
> --- /dev/null
> +++ b/drivers/media/i2c/imx258.c
> @@ -0,0 +1,1341 @@
> +// Copyright (C) 2018 Intel Corporation
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include <linux/acpi.h>
> +#include <linux/delay.h>
> +#include <linux/i2c.h>
> +#include <linux/module.h>
> +#include <linux/pm_runtime.h>
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-device.h>
> +
> +#define IMX258_REG_VALUE_08BIT         1
> +#define IMX258_REG_VALUE_16BIT         2
> +#define IMX258_REG_VALUE_24BIT         3

Is there any need for these macros? Respective functions could just
take the number of bytes as the argument directly.

> +
> +#define IMX258_REG_MODE_SELECT         0x0100
> +#define IMX258_MODE_STANDBY            0x00
> +#define IMX258_MODE_STREAMING          0x01
> +
> +/* Chip ID */
> +#define IMX258_REG_CHIP_ID             0x0016
> +#define IMX258_CHIP_ID                 0x0258
> +
> +/* V_TIMING internal */
> +#define IMX258_REG_VTS                 0x0340
> +#define IMX258_VTS_30FPS               0x0c98
> +#define IMX258_VTS_MAX                 0xffff
> +
> +/*Frame Length Line*/
> +#define IMX258_FLL_MIN                 0x08a6
> +#define IMX258_FLL_MAX                 0xffff
> +#define IMX258_FLL_STEP                        1
> +#define IMX258_FLL_DEFAULT             0x0c98
> +
> +/* HBLANK control - read only */
> +#define IMX258_PPL_650MHZ              5352
> +#define IMX258_PPL_325MHZ              2676
> +
> +/* Exposure control */
> +#define IMX258_REG_EXPOSURE            0x0202
> +#define IMX258_EXPOSURE_MIN            4
> +#define IMX258_EXPOSURE_STEP           1
> +#define IMX258_EXPOSURE_DEFAULT                0x640
> +#define IMX258_EXPOSURE_MAX            65535
> +
> +/* Analog gain control */
> +#define IMX258_REG_ANALOG_GAIN         0x0204
> +#define IMX258_ANA_GAIN_MIN            0
> +#define IMX258_ANA_GAIN_MAX            0x1fff
> +#define IMX258_ANA_GAIN_STEP           1
> +#define IMX258_ANA_GAIN_DEFAULT                0x0
> +
> +/* Digital gain control */
> +#define IMX258_REG_GR_DIGITAL_GAIN     0x020e
> +#define IMX258_REG_R_DIGITAL_GAIN      0x0210
> +#define IMX258_REG_B_DIGITAL_GAIN      0x0212
> +#define IMX258_REG_GB_DIGITAL_GAIN     0x0214
> +#define IMX258_DGTL_GAIN_MIN           0
> +#define IMX258_DGTL_GAIN_MAX           4096   /* Max = 0xFFF */
> +#define IMX258_DGTL_GAIN_DEFAULT       1024
> +#define IMX258_DGTL_GAIN_STEP           1
> +
> +/* Orientation */
> +#define REG_MIRROR_FLIP_CONTROL        0x0101
> +#define REG_CONFIG_MIRROR_FLIP         0x03
> +
> +struct imx258_reg {
> +       u16 address;
> +       u8 val;
> +};
> +
> +struct imx258_reg_list {
> +       u32 num_of_regs;
> +       const struct imx258_reg *regs;
> +};
> +
> +/* Link frequency config */
> +struct imx258_link_freq_config {
> +       u32 pixels_per_line;
> +
> +       /* PLL registers for this link frequency */
> +       struct imx258_reg_list reg_list;
> +};
> +
> +/* Mode : resolution and related config&values */
> +struct imx258_mode {
> +       /* Frame width */
> +       u32 width;
> +       /* Frame height */
> +       u32 height;
> +
> +       /* V-timing */
> +       u32 vts_def;
> +       u32 vts_min;
> +
> +       /* Index of Link frequency config to be used */
> +       u32 link_freq_index;
> +       /* Default register values */
> +       struct imx258_reg_list reg_list;
> +};
> +
> +/* 4208x3118 needs 1300Mbps/lane, 4 lanes */
> +static const struct imx258_reg mipi_data_rate_1300mbps[] = {
> +       {0x0301, 0x05},

CodingStyle: Spaces inside the braces and lowercase hex, e.g.

{ 0x1234, 0xabcd },

[snip]

> +       {0x951B, 0x50},
> +       {0x3030, 0x00},
> +       {0x3032, 0x00},
> +       {0x0220, 0x00},
> +};

nit: Blank line would be nice here.

> +static const char * const imx258_test_pattern_menu[] = {
> +       "Disabled",
> +       "Vertical Color Bar Type 1",
> +       "Vertical Color Bar Type 2",
> +       "Vertical Color Bar Type 3",
> +       "Vertical Color Bar Type 4"
> +};
> +
> +/* Configurations for supported link frequencies */
> +#define IMX258_LINK_FREQ_650MHZ        649600000ULL
> +#define IMX258_LINK_FREQ_325MHZ        324800000ULL
> +
> +/*
> + * pixel_rate = link_freq * data-rate * nr_of_lanes / bits_per_sample
> + * data rate => double data rate; number of lanes => 4; bits per pixel => 10
> + */
> +static u64 link_freq_to_pixel_rate(u64 f)
> +{
> +       f *= 2 * 4;
> +       do_div(f, 10);
> +
> +       return f;
> +}
> +
> +/* Menu items for LINK_FREQ V4L2 control */
> +static const s64 link_freq_menu_items[] = {
> +       IMX258_LINK_FREQ_650MHZ,
> +       IMX258_LINK_FREQ_325MHZ,
> +};
> +
> +/* Link frequency configs */
> +static const struct imx258_link_freq_config link_freq_configs[] = {
> +       {
> +               .pixels_per_line = IMX258_PPL_650MHZ,
> +               .reg_list = {
> +                       .num_of_regs = ARRAY_SIZE(mipi_data_rate_1300mbps),
> +                       .regs = mipi_data_rate_1300mbps,
> +               }
> +       },
> +       {
> +               .pixels_per_line = IMX258_PPL_325MHZ,
> +               .reg_list = {
> +                       .num_of_regs = ARRAY_SIZE(mipi_data_rate_650mbps),
> +                       .regs = mipi_data_rate_650mbps,
> +               }
> +       },

Could you define an enum for the entries here nd use explicit indexing? e.g.

enum {
        IMX258_LINK_FREQ_1300MBPS,
        IMX258_LINK_FREQ_650MBPS,
};

static const struct imx258_link_freq_config link_freq_configs[] = {
        [IMX258_LINK_FREQ_1300MBPS] = { ... },
        [IMX258_LINK_FREQ_650MBPS] = { ... },
};

and then... (See below.)

> +};
> +
> +/* Mode configs */
> +static const struct imx258_mode supported_modes[] = {
> +       {
> +               .width = 4208,
> +               .height = 3118,
> +               .vts_def = IMX258_VTS_30FPS,
> +               .vts_min = IMX258_VTS_30FPS,
> +               .reg_list = {
> +                       .num_of_regs = ARRAY_SIZE(mode_4208x3118_regs),
> +                       .regs = mode_4208x3118_regs,
> +               },
> +               .link_freq_index = 0,

...use the indices defined above here. This way we have an explicit
link between both arrays and it's not possible to accidentally break
it.

[snip]

> +
> +       /* Mutex for serialized access */
> +       struct mutex mutex;

Please document what needs to be serialized.

> +
> +       /* Streaming on/off */
> +       bool streaming;
> +};
> +
> +#define to_imx258(_sd) container_of(_sd, struct imx258, sd)

Please use a static inline for compiler type safety.

> +
> +/* Read registers up to 4 at a time */
> +static int imx258_read_reg(struct imx258 *imx258, u16 reg, u32 len, u32 *val)
> +{
> +       struct i2c_client *client = v4l2_get_subdevdata(&imx258->sd);
> +       struct i2c_msg msgs[2];
> +       u8 *data_be_p;
> +       int ret;
> +       u32 data_be = 0;
> +       u16 reg_addr_be = cpu_to_be16(reg);
> +
> +       if (len > 4)
> +               return -EINVAL;
> +
> +       data_be_p = (u8 *)&data_be;
> +       /* Write register address */
> +       msgs[0].addr = client->addr;
> +       msgs[0].flags = 0;
> +       msgs[0].len = 2;
> +       msgs[0].buf = (u8 *)&reg_addr_be;

No need for this big endian and pointer cast magic. Let's make this a
bit more readable:

u8 addr_buf[2] = { reg >> 8, reg & 0xff };

[...]

msgs[0].len = ARRAY_SIZE(addr_buf);
msgs[0].buf = addr_buf;

> +
> +       /* Read data from register */
> +       msgs[1].addr = client->addr;
> +       msgs[1].flags = I2C_M_RD;
> +       msgs[1].len = len;
> +       msgs[1].buf = &data_be_p[4 - len];

u8 data_buf[4] = { 0, };

[...]

msgs[1].buf = &data_buf[4 - len];

> +
> +       ret = i2c_transfer(client->adapter, msgs, ARRAY_SIZE(msgs));
> +       if (ret != ARRAY_SIZE(msgs))
> +               return -EIO;
> +
> +       *val = be32_to_cpu(data_be);

*val = get_unaligned_be32(data_buf);

> +
> +       return 0;
> +}
> +
> +/* Write registers up to 4 at a time */
> +static int imx258_write_reg(struct imx258 *imx258, u16 reg, u32 len, u32 val)
> +{
> +       struct i2c_client *client = v4l2_get_subdevdata(&imx258->sd);
> +       int buf_i, val_i;
> +       u8 buf[6], *val_p;
> +
> +       if (len > 4)
> +               return -EINVAL;
> +
> +       buf[0] = reg >> 8;
> +       buf[1] = reg & 0xff;
> +
> +       val = cpu_to_be32(val);
> +       val_p = (u8 *)&val;
> +       buf_i = 2;
> +       val_i = 4 - len;
> +
> +       while (val_i < 4)
> +               buf[buf_i++] = val_p[val_i++];

Similar thing here. The above 7 lines are the same as:

put_unaligned_be32(val << (8 * (4 - len)), buf);

> +
> +       if (i2c_master_send(client, buf, len + 2) != len + 2)
> +               return -EIO;
> +
> +       return 0;
> +}
> +
> +/* Write a list of registers */
> +static int imx258_write_regs(struct imx258 *imx258,
> +                             const struct imx258_reg *regs, u32 len)
> +{
> +       struct i2c_client *client = v4l2_get_subdevdata(&imx258->sd);
> +       int ret;
> +       u32 i;
> +
> +       for (i = 0; i < len; i++) {
> +               ret = imx258_write_reg(imx258, regs[i].address, 1,
> +                                       regs[i].val);
> +               if (ret) {
> +                       dev_err_ratelimited(
> +                               &client->dev,
> +                               "Failed to write reg 0x%4.4x. error = %d\n",
> +                               regs[i].address, ret);
> +
> +                       return ret;
> +               }
> +       }
> +
> +       return 0;
> +}
> +
> +static int imx258_write_reg_list(struct imx258 *imx258,
> +                                 const struct imx258_reg_list *r_list)
> +{
> +       return imx258_write_regs(imx258, r_list->regs, r_list->num_of_regs);

This is the only place where imx258_write_regs() is used. Is there any
need to make it a separate function?

> +}
> +
> +/* Open sub-device */
> +static int imx258_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
> +{
> +       struct v4l2_mbus_framefmt *try_fmt =
> +               v4l2_subdev_get_try_format(sd, fh->pad, 0);
> +
> +       /* Initialize try_fmt */
> +       try_fmt->width = supported_modes[0].width;
> +       try_fmt->height = supported_modes[0].height;
> +       try_fmt->code = MEDIA_BUS_FMT_SGRBG10_1X10;
> +       try_fmt->field = V4L2_FIELD_NONE;
> +
> +       return 0;
> +}
> +
> +static int imx258_i2c_write_reg_ext(struct imx258 *imx258, u16 reg,
> +                                               u32 len, u32 val)
> +{
> +       u32 val_d, val_d2;
> +       int ret;
> +       u32 mask = 0xff;
> +
> +       val_d = (val & ~mask) >> 8;
> +       val_d2 = val & mask;
> +
> +       ret = imx258_write_reg(imx258, reg, len/2, val_d);
> +       ret = imx258_write_reg(imx258, reg+1, len/2, val_d2);
> +
> +       if (ret)
> +               return ret;
> +       return 0;
> +}

What is this function for? I don't see why imx258_write_reg() couldn't
be called directly...

> +
> +static int imx258_update_digital_gain(struct imx258 *imx258, u32 len, u32 val)
> +{
> +       int ret;
> +
> +       ret = imx258_i2c_write_reg_ext(imx258, IMX258_REG_GR_DIGITAL_GAIN,
> +                               IMX258_REG_VALUE_16BIT,
> +                               val);
> +       ret |= imx258_i2c_write_reg_ext(imx258, IMX258_REG_GB_DIGITAL_GAIN,
> +                               IMX258_REG_VALUE_16BIT,
> +                               val);
> +       ret |= imx258_i2c_write_reg_ext(imx258, IMX258_REG_R_DIGITAL_GAIN,
> +                               IMX258_REG_VALUE_16BIT,
> +                               val);
> +       ret |= imx258_i2c_write_reg_ext(imx258, IMX258_REG_B_DIGITAL_GAIN,
> +                               IMX258_REG_VALUE_16BIT,
> +                               val);

Please don't do bitwise OR on return values. If two or more of the
above calls return different non-zero values, the resulting value will
make no sense.

> +       if (ret)
> +               return ret;
> +       return 0;
> +}
> +
> +static int imx258_set_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +       struct imx258 *imx258 =
> +               container_of(ctrl->handler, struct imx258, ctrl_handler);
> +       struct i2c_client *client = v4l2_get_subdevdata(&imx258->sd);
> +       int ret = 0;
> +       /*
> +        * Applying V4L2 control value only happens
> +        * when power is up for streaming
> +        */
> +       if (pm_runtime_get_if_in_use(&client->dev) <= 0)
> +               return 0;

I thought we decided to fix this to handle disabled runtime PM properly.

> +
> +       switch (ctrl->id) {
> +       case V4L2_CID_ANALOGUE_GAIN:
> +               ret = imx258_i2c_write_reg_ext(imx258, IMX258_REG_ANALOG_GAIN,
> +                               IMX258_REG_VALUE_16BIT,
> +                               ctrl->val);
> +               break;
> +       case V4L2_CID_EXPOSURE:
> +               ret = imx258_i2c_write_reg_ext(imx258, IMX258_REG_EXPOSURE,
> +                               IMX258_REG_VALUE_16BIT,
> +                               ctrl->val);
> +               break;
> +       case V4L2_CID_DIGITAL_GAIN:
> +               ret = imx258_update_digital_gain(imx258, IMX258_REG_VALUE_16BIT,
> +                               ctrl->val);
> +               break;
> +       default:
> +               dev_info(&client->dev,
> +                        "ctrl(id:0x%x,val:0x%x) is not handled\n",
> +                        ctrl->id, ctrl->val);

dev_err() and set ret to an error.

> +               break;
> +       }
> +
> +       pm_runtime_put(&client->dev);
> +
> +       return ret;
> +}

[snip]

> +/* Start streaming */
> +static int imx258_start_streaming(struct imx258 *imx258)
> +{
> +       struct i2c_client *client = v4l2_get_subdevdata(&imx258->sd);
> +       const struct imx258_reg_list *reg_list;
> +       int ret, link_freq_index;
> +
> +       /* Setup PLL */
> +       link_freq_index = imx258->cur_mode->link_freq_index;
> +       reg_list = &link_freq_configs[link_freq_index].reg_list;
> +       ret = imx258_write_reg_list(imx258, reg_list);
> +       if (ret) {
> +               dev_err(&client->dev, "%s failed to set plls\n", __func__);
> +               return ret;
> +       }
> +
> +       /* Apply default values of current mode */
> +       reg_list = &imx258->cur_mode->reg_list;
> +       ret = imx258_write_reg_list(imx258, reg_list);
> +       if (ret) {
> +               dev_err(&client->dev, "%s failed to set mode\n", __func__);
> +               return ret;
> +       }
> +
> +       /* Set Orientation be 180 degree */
> +       ret = imx258_write_reg(imx258, REG_MIRROR_FLIP_CONTROL,
> +                               IMX258_REG_VALUE_08BIT, REG_CONFIG_MIRROR_FLIP);
> +       if (ret) {
> +               dev_err(&client->dev, "%s failed to set orientation\n",
> +                       __func__);
> +               return ret;
> +       }
> +
> +       /* Apply customized values from user */
> +       ret =  __v4l2_ctrl_handler_setup(imx258->sd.ctrl_handler);
> +       if (ret)
> +               return ret;
> +
> +       usleep_range(12000, 13000);

Please add a comment explaining what this usleep_range() is waiting for.

> +
> +       /* set stream on register */
> +       return imx258_write_reg(imx258, IMX258_REG_MODE_SELECT,
> +                                IMX258_REG_VALUE_08BIT,
> +                                IMX258_MODE_STREAMING);
> +}
[snip]
> +/* Initialize control handlers */
> +static int imx258_init_controls(struct imx258 *imx258)
> +{
> +       struct i2c_client *client = v4l2_get_subdevdata(&imx258->sd);
> +       struct v4l2_ctrl_handler *ctrl_hdlr;
> +       s64 exposure_max;
> +       s64 vblank_def;
> +       s64 vblank_min;
> +       s64 pixel_rate_min;
> +       s64 pixel_rate_max;
> +       int ret;
> +
> +       ctrl_hdlr = &imx258->ctrl_handler;
> +       ret = v4l2_ctrl_handler_init(ctrl_hdlr, 8);
> +       if (ret)

Missing error message.

> +               return ret;
> +
> +       mutex_init(&imx258->mutex);
> +       ctrl_hdlr->lock = &imx258->mutex;
> +       imx258->link_freq = v4l2_ctrl_new_int_menu(ctrl_hdlr,
> +                               &imx258_ctrl_ops,
> +                               V4L2_CID_LINK_FREQ,
> +                               ARRAY_SIZE(link_freq_menu_items) - 1,
> +                               0,
> +                               link_freq_menu_items);
> +
> +       if (!imx258->link_freq) {
> +               ret = -EINVAL;

Missing error message.

> +               goto error;
> +       }
> +
> +       imx258->link_freq->flags |= V4L2_CTRL_FLAG_READ_ONLY;
> +
> +       pixel_rate_max = link_freq_to_pixel_rate(link_freq_menu_items[0]);
> +       pixel_rate_min = link_freq_to_pixel_rate(link_freq_menu_items[1]);
> +       /* By default, PIXEL_RATE is read only */
> +       imx258->pixel_rate = v4l2_ctrl_new_std(ctrl_hdlr, &imx258_ctrl_ops,
> +                                       V4L2_CID_PIXEL_RATE,
> +                                       pixel_rate_min, pixel_rate_max,
> +                                       1, pixel_rate_max);
> +
> +
> +       vblank_def = imx258->cur_mode->vts_def - imx258->cur_mode->height;
> +       vblank_min = imx258->cur_mode->vts_min - imx258->cur_mode->height;
> +       imx258->vblank = v4l2_ctrl_new_std(
> +                               ctrl_hdlr, &imx258_ctrl_ops, V4L2_CID_VBLANK,
> +                               vblank_min,
> +                               IMX258_VTS_MAX - imx258->cur_mode->height, 1,
> +                               vblank_def);
> +
> +       imx258->hblank = v4l2_ctrl_new_std(
> +                               ctrl_hdlr, &imx258_ctrl_ops, V4L2_CID_HBLANK,
> +                               IMX258_PPL_650MHZ - imx258->cur_mode->width,
> +                               IMX258_PPL_650MHZ - imx258->cur_mode->width,
> +                               1,
> +                               IMX258_PPL_650MHZ - imx258->cur_mode->width);
> +
> +       if (!imx258->hblank) {
> +               ret = -EINVAL;
> +               goto error;
> +       }

Why checking hblank, but not other controls? I think in this case just
the general check for ctrl_hdlr->error should be enough.

> +
> +       imx258->hblank->flags |= V4L2_CTRL_FLAG_READ_ONLY;
> +
> +       exposure_max = imx258->cur_mode->vts_def - 8;
> +       imx258->exposure = v4l2_ctrl_new_std(
> +                               ctrl_hdlr, &imx258_ctrl_ops,
> +                               V4L2_CID_EXPOSURE, IMX258_EXPOSURE_MIN,
> +                               IMX258_EXPOSURE_MAX, IMX258_EXPOSURE_STEP,
> +                               IMX258_EXPOSURE_DEFAULT);
> +
> +       v4l2_ctrl_new_std(ctrl_hdlr, &imx258_ctrl_ops, V4L2_CID_ANALOGUE_GAIN,
> +                               IMX258_ANA_GAIN_MIN, IMX258_ANA_GAIN_MAX,
> +                               IMX258_ANA_GAIN_STEP, IMX258_ANA_GAIN_DEFAULT);
> +
> +       v4l2_ctrl_new_std(ctrl_hdlr, &imx258_ctrl_ops, V4L2_CID_DIGITAL_GAIN,
> +                               IMX258_DGTL_GAIN_MIN, IMX258_DGTL_GAIN_MAX,
> +                               IMX258_DGTL_GAIN_STEP, IMX258_DGTL_GAIN_DEFAULT);
> +
> +       v4l2_ctrl_new_std_menu_items(ctrl_hdlr, &imx258_ctrl_ops,
> +                                    V4L2_CID_TEST_PATTERN,
> +                                    ARRAY_SIZE(imx258_test_pattern_menu) - 1,
> +                                    0, 0, imx258_test_pattern_menu);
> +
> +       if (ctrl_hdlr->error) {
> +               ret = ctrl_hdlr->error;
> +               dev_err(&client->dev, "%s control init failed (%d)\n",
> +                       __func__, ret);
> +               goto error;
> +       }
> +
> +       imx258->sd.ctrl_handler = ctrl_hdlr;
> +
> +       return 0;
> +
> +error:
> +       v4l2_ctrl_handler_free(ctrl_hdlr);
> +       mutex_destroy(&imx258->mutex);
> +
> +       return ret;
> +}
> +
> +static void imx258_free_controls(struct imx258 *imx258)
> +{
> +       v4l2_ctrl_handler_free(imx258->sd.ctrl_handler);
> +       mutex_destroy(&imx258->mutex);
> +}
> +
> +static int imx258_probe(struct i2c_client *client)
> +{
> +       struct imx258 *imx258;
> +       int ret;
> +       u32 val = 0;
> +
> +       device_property_read_u32(&client->dev, "clock-frequency", &val);
> +       if (val != 19200000)

Would be nice to print some error.

> +               return -EINVAL;
> +
> +       imx258 = devm_kzalloc(&client->dev, sizeof(*imx258), GFP_KERNEL);
> +       if (!imx258)
> +               return -ENOMEM;
> +
> +       /* Initialize subdev */
> +       v4l2_i2c_subdev_init(&imx258->sd, client, &imx258_subdev_ops);
> +
> +       /* Check module identity */
> +       ret = imx258_identify_module(imx258);
> +       if (ret)
> +               return ret;
> +
> +       /* Set default mode to max resolution */
> +       imx258->cur_mode = &supported_modes[0];
> +
> +       ret = imx258_init_controls(imx258);
> +       if (ret)
> +               return ret;
> +
> +       /* Initialize subdev */
> +       imx258->sd.internal_ops = &imx258_internal_ops;
> +       imx258->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> +       imx258->sd.entity.function = MEDIA_ENT_F_CAM_SENSOR;
> +
> +       /* Initialize source pad */
> +       imx258->pad.flags = MEDIA_PAD_FL_SOURCE;
> +
> +       ret = media_entity_pads_init(&imx258->sd.entity, 1, &imx258->pad);
> +       if (ret) {
> +               dev_err(&client->dev, "%s failed:%d\n", __func__, ret);

This isn't a very useful error message. "media_entity_pads_init()
failed: %d\n" would make more sense.

Best regards,
Tomasz
