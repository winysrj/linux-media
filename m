Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb0-f195.google.com ([209.85.213.195]:33687 "EHLO
        mail-yb0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726755AbeG3Ly2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Jul 2018 07:54:28 -0400
Received: by mail-yb0-f195.google.com with SMTP id e84-v6so4525970ybb.0
        for <linux-media@vger.kernel.org>; Mon, 30 Jul 2018 03:20:09 -0700 (PDT)
Received: from mail-yw0-f176.google.com (mail-yw0-f176.google.com. [209.85.161.176])
        by smtp.gmail.com with ESMTPSA id 135-v6sm4665479ywm.74.2018.07.30.03.20.08
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 30 Jul 2018 03:20:08 -0700 (PDT)
Received: by mail-yw0-f176.google.com with SMTP id t18-v6so4152767ywg.2
        for <linux-media@vger.kernel.org>; Mon, 30 Jul 2018 03:20:08 -0700 (PDT)
MIME-Version: 1.0
References: <1532942799-25289-1-git-send-email-ping-chung.chen@intel.com>
In-Reply-To: <1532942799-25289-1-git-send-email-ping-chung.chen@intel.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Mon, 30 Jul 2018 19:19:56 +0900
Message-ID: <CAAFQd5D33wzALT+0KkfXKzKs68cYKy05GbHe_SnLakpfJyry3w@mail.gmail.com>
Subject: Re: [PATCH v2] media: imx208: Add imx208 camera sensor driver
To: ping-chung.chen@intel.com
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        "Yeh, Andy" <andy.yeh@intel.com>, "Lai, Jim" <jim.lai@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Grant Grundler <grundler@chromium.org>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ping-chung,

On Mon, Jul 30, 2018 at 6:19 PM Ping-chung Chen
<ping-chung.chen@intel.com> wrote:
>
> From: "Chen, Ping-chung" <ping-chung.chen@intel.com>
>
> Add a V4L2 sub-device driver for the Sony IMX208 image sensor.
> This is a camera sensor using the I2C bus for control and the
> CSI-2 bus for data.
>

Please see my comments inline.

[snip]
> diff --git a/drivers/media/i2c/imx208.c b/drivers/media/i2c/imx208.c
> new file mode 100644
> index 0000000..5adfb79
> --- /dev/null
> +++ b/drivers/media/i2c/imx208.c
> @@ -0,0 +1,984 @@
> +// SPDX-License-Identifier: GPL-2.0
> +// Copyright (C) 2018 Intel Corporation
> +
> +#include <linux/acpi.h>
> +#include <linux/delay.h>
> +#include <linux/i2c.h>
> +#include <linux/module.h>
> +#include <linux/pm_runtime.h>
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-device.h>
> +#include <asm/unaligned.h>
> +
> +#define IMX208_REG_VALUE_08BIT         1
> +#define IMX208_REG_VALUE_16BIT         2

We don't need to define these. It's obvious that 8 bits is 1 byte and
16 bits are 2 bytes.

> +
> +#define IMX208_REG_MODE_SELECT         0x0100
> +#define IMX208_MODE_STANDBY            0x00
> +#define IMX208_MODE_STREAMING          0x01
[snip]
> +/* Test Pattern Control */
> +#define IMX208_REG_TEST_PATTERN_MODE   0x0600
> +#define IMX208_TEST_PATTERN_DISABLE    0
> +#define IMX208_TEST_PATTERN_SOLID_COLOR        1
> +#define IMX208_TEST_PATTERN_COLOR_BARS 2
> +#define IMX208_TEST_PATTERN_GREY_COLOR 3
> +#define IMX208_TEST_PATTERN_PN9                4

Please use hexadecimal notation for register values (as already done below).

> +#define IMX208_TEST_PATTERN_FIX_1      0x100
> +#define IMX208_TEST_PATTERN_FIX_2      0x101
> +#define IMX208_TEST_PATTERN_FIX_3      0x102
> +#define IMX208_TEST_PATTERN_FIX_4      0x103
> +#define IMX208_TEST_PATTERN_FIX_5      0x104
> +#define IMX208_TEST_PATTERN_FIX_6      0x105
[snip]
> +static const int imx208_test_pattern_val[] = {
> +       IMX208_TEST_PATTERN_DISABLE,
> +       IMX208_TEST_PATTERN_SOLID_COLOR,
> +       IMX208_TEST_PATTERN_COLOR_BARS,
> +       IMX208_TEST_PATTERN_GREY_COLOR,
> +       IMX208_TEST_PATTERN_PN9,
> +       IMX208_TEST_PATTERN_FIX_1,
> +       IMX208_TEST_PATTERN_FIX_2,
> +       IMX208_TEST_PATTERN_FIX_3,
> +       IMX208_TEST_PATTERN_FIX_4,
> +       IMX208_TEST_PATTERN_FIX_5,
> +       IMX208_TEST_PATTERN_FIX_6,
> +};
> +
> +/* Configurations for supported link frequencies */
> +#define IMX208_LINK_FREQ_384MHZ        384000000ULL
> +#define IMX208_LINK_FREQ_96MHZ  96000000ULL

nit: If we really need defines for these, then at least they should be
somehow useful, e.g.

#define MHZ (1000*1000ULL)
#define IMX208_LINK_FREQ_384MHZ (384ULL * MHZ)

This at least makes it easy to see that there are no mistakes in the
number, e.g. wrong number of zeroes.

> +
> +enum {
> +       IMX208_LINK_FREQ_384MHZ_INDEX,
> +       IMX208_LINK_FREQ_96MHZ_INDEX,
> +};
> +
> +/*
> + * pixel_rate = link_freq * data-rate * nr_of_lanes / bits_per_sample
> + * data rate => double data rate; number of lanes => 2; bits per pixel => 10
> + */
> +static u64 link_freq_to_pixel_rate(u64 f)
> +{
> +       f *= 2 * 2;
> +       do_div(f, 10);

Please add macros for those magic numbers.

> +
> +       return f;
> +}
> +
> +/* Menu items for LINK_FREQ V4L2 control */
> +static const s64 link_freq_menu_items[] = {
> +       IMX208_LINK_FREQ_384MHZ,
> +       IMX208_LINK_FREQ_96MHZ,

Since we have an enum already, please use it for explicit indices, to
ensure things are consistent and actually easier to read, i.e.

[IMX208_LINK_FREQ_384MHZ_INDEX] = IMX208_LINK_FREQ_384MHZ,

> +};
> +
> +/* Link frequency configs */
> +static const struct imx208_link_freq_config link_freq_configs[] = {
> +       {

Explicit indices, i.e.

[IMX208_LINK_FREQ_384MHZ_INDEX] = {

> +               .pixels_per_line = IMX208_PPL_384MHZ,
> +               .reg_list = {
> +                       .num_of_regs = ARRAY_SIZE(mipi_data_rate),
> +                       .regs = mipi_data_rate,
> +               }
> +       },
> +       {

Ditto.

> +               .pixels_per_line = IMX208_PPL_96MHZ,
> +               .reg_list = {
> +                       .num_of_regs = ARRAY_SIZE(mipi_data_rate),
> +                       .regs = mipi_data_rate,

How comes that both link frequencies have the same register values for
MIPI data rate?

> +               }
> +       },
> +};
> +
> +/* Mode configs */
> +static const struct imx208_mode supported_modes[] = {
> +       {
> +               .width = 1936,
> +               .height = 1096,
> +               .vts_def = IMX208_VTS_60FPS,
> +               .vts_min = IMX208_VTS_60FPS_MIN,
> +               .reg_list = {
> +                       .num_of_regs = ARRAY_SIZE(mode_1936x1096_60fps_regs),
> +                       .regs = mode_1936x1096_60fps_regs,
> +               },
> +               .link_freq_index = 0,

Please use the index that was defined before - IMX208_LINK_FREQ_384MHZ_INDEX.

> +       },
> +       {
> +               .width = 968,
> +               .height = 548,
> +               .vts_def = IMX208_VTS_BINNING,
> +               .vts_min = IMX208_VTS_BINNING_MIN,
> +               .reg_list = {
> +                       .num_of_regs = ARRAY_SIZE(mode_968_548_60fps_regs),
> +                       .regs = mode_968_548_60fps_regs,
> +               },
> +               .link_freq_index = IMX208_LINK_FREQ_96MHZ_INDEX,
> +       },
> +};
> +
> +struct imx208 {
> +       struct v4l2_subdev sd;
> +       struct media_pad pad;
> +
> +       struct v4l2_ctrl_handler ctrl_handler;
> +       /* V4L2 Controls */
> +       struct v4l2_ctrl *link_freq;
> +       struct v4l2_ctrl *pixel_rate;
> +       struct v4l2_ctrl *vblank;
> +       struct v4l2_ctrl *hblank;
> +       struct v4l2_ctrl *vflip;
> +       struct v4l2_ctrl *hflip;
> +
> +       /* Current mode */
> +       const struct imx208_mode *cur_mode;
> +
> +       /* Mutex for serialized access */

The comment doesn't say access to what is serialized.

> +       struct mutex imx208_mx;
> +
> +       /* Streaming on/off */
> +       bool streaming;
> +};
> +
> +static inline struct imx208 *to_imx208(struct v4l2_subdev *_sd)
> +{
> +       return container_of(_sd, struct imx208, sd);
> +}
> +
> +/* Get bayer order based on flip setting. */
> +static __u32 imx208_get_format_code(struct imx208 *imx208)

Why not just "u32"?

> +{
> +       /*
> +        * Only one bayer order is supported.
> +        * It depends on the flip settings.
> +        */
> +       static const __u32 codes[2][2] = {

Ditto.

> +               { MEDIA_BUS_FMT_SRGGB10_1X10, MEDIA_BUS_FMT_SGRBG10_1X10, },
> +               { MEDIA_BUS_FMT_SGBRG10_1X10, MEDIA_BUS_FMT_SBGGR10_1X10, },
> +       };
> +
> +       return codes[imx208->vflip->val][imx208->hflip->val];
> +}
> +
> +/* Read registers up to 2 at a time */

The function seems to be handling up to 4 (which I guess is okay, but
the comment is off).

> +static int imx208_read_reg(struct imx208 *imx208, u16 reg, u32 len, u32 *val)
> +{
> +       struct i2c_client *client = v4l2_get_subdevdata(&imx208->sd);
> +       struct i2c_msg msgs[2];
> +       u8 addr_buf[2] = { reg >> 8, reg & 0xff };
> +       u8 data_buf[4] = { 0, };
> +       int ret;
> +
> +       if (len > 4)
> +               return -EINVAL;
> +
> +       /* Write register address */
> +       msgs[0].addr = client->addr;
> +       msgs[0].flags = 0;
> +       msgs[0].len = ARRAY_SIZE(addr_buf);
> +       msgs[0].buf = addr_buf;
> +
> +       /* Read data from register */
> +       msgs[1].addr = client->addr;
> +       msgs[1].flags = I2C_M_RD;
> +       msgs[1].len = len;
> +       msgs[1].buf = &data_buf[4 - len];
> +
> +       ret = i2c_transfer(client->adapter, msgs, ARRAY_SIZE(msgs));
> +       if (ret != ARRAY_SIZE(msgs))
> +               return -EIO;
> +
> +       *val = get_unaligned_be32(data_buf);
> +
> +       return 0;
> +}
[snip]
> +static int imx208_set_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +       struct imx208 *imx208 =
> +               container_of(ctrl->handler, struct imx208, ctrl_handler);
> +       struct i2c_client *client = v4l2_get_subdevdata(&imx208->sd);
> +       int ret;
> +
> +       /*
> +        * Applying V4L2 control value only happens
> +        * when power is up for streaming
> +        */
> +       if (pm_runtime_get_if_in_use(&client->dev) <= 0)

This is buggy, because it won't handle the case of runtime PM disabled
in kernel config. The check should be
(!pm_runtime_get_if_in_use(&client->dev)).

> +               return 0;
> +
> +       switch (ctrl->id) {
> +       case V4L2_CID_ANALOGUE_GAIN:
> +               ret = imx208_write_reg(imx208, IMX208_REG_ANALOG_GAIN,
> +                                      IMX208_REG_VALUE_16BIT, ctrl->val);
> +               break;
> +       case V4L2_CID_EXPOSURE:
> +               ret = imx208_write_reg(imx208, IMX208_REG_EXPOSURE,
> +                                      IMX208_REG_VALUE_16BIT, ctrl->val);
> +               break;
> +       case V4L2_CID_DIGITAL_GAIN:
> +               ret = imx208_update_digital_gain(imx208, IMX208_REG_VALUE_16BIT,
> +                               ctrl->val);

nit: The line looks misaligned.

> +               break;
> +       case V4L2_CID_VBLANK:
> +               /* Update VTS that meets expected vertical blanking */
> +               ret = imx208_write_reg(imx208, IMX208_REG_VTS,
> +                                      IMX208_REG_VALUE_16BIT,
> +                                      imx208->cur_mode->height + ctrl->val);
> +               break;
> +       case V4L2_CID_TEST_PATTERN:
> +               ret = imx208_write_reg(imx208, IMX208_REG_TEST_PATTERN_MODE,
> +                                      IMX208_REG_VALUE_16BIT,
> +                                      imx208_test_pattern_val[ctrl->val]);
> +               break;
> +       case V4L2_CID_HFLIP:
> +       case V4L2_CID_VFLIP:
> +               ret = imx208_write_reg(imx208, IMX208_REG_ORIENTATION_CONTROL,
> +                                      IMX208_REG_VALUE_08BIT,
> +                                      imx208->hflip->val |
> +                                      imx208->vflip->val << 1);
> +               break;
> +       default:
> +               ret = -EINVAL;
> +               dev_info(&client->dev,

This is an error, so dev_err().

> +                       "ctrl(id:0x%x,val:0x%x) is not handled\n",
> +                       ctrl->id, ctrl->val);
> +               break;
> +       }
> +
> +       pm_runtime_put(&client->dev);
> +
> +       return ret;
> +}
[snip]
> +/* Initialize control handlers */
> +static int imx208_init_controls(struct imx208 *imx208)
> +{
> +       struct i2c_client *client = v4l2_get_subdevdata(&imx208->sd);
> +       struct v4l2_ctrl_handler *ctrl_hdlr = &imx208->ctrl_handler;
> +       s64 exposure_max;
> +       s64 vblank_def;
> +       s64 vblank_min;
> +       s64 pixel_rate_min;
> +       s64 pixel_rate_max;
> +       int ret;
> +
> +       ret = v4l2_ctrl_handler_init(ctrl_hdlr, 8);
> +       if (ret)
> +               return ret;
> +
> +       mutex_init(&imx208->imx208_mx);
> +       ctrl_hdlr->lock = &imx208->imx208_mx;
> +       imx208->link_freq = v4l2_ctrl_new_int_menu(ctrl_hdlr,
> +                               &imx208_ctrl_ops,
> +                               V4L2_CID_LINK_FREQ,
> +                               ARRAY_SIZE(link_freq_menu_items) - 1,
> +                               0,
> +                               link_freq_menu_items);
> +
> +       if (imx208->link_freq)
> +               imx208->link_freq->flags |= V4L2_CTRL_FLAG_READ_ONLY;
> +
> +       pixel_rate_max = link_freq_to_pixel_rate(link_freq_menu_items[0]);
> +       pixel_rate_min = link_freq_to_pixel_rate(link_freq_menu_items[1]);

Please replace [1] with [ARRAY_SIZE(link_freq_menu_items) - 1]. Also
please add a comment saying that link_freq_menu_items[] must be sorted
by link freq descending, above the array.

> +       /* By default, PIXEL_RATE is read only */
> +       imx208->pixel_rate = v4l2_ctrl_new_std(ctrl_hdlr, &imx208_ctrl_ops,
> +                                       V4L2_CID_PIXEL_RATE,
> +                                       pixel_rate_min, pixel_rate_max,
> +                                       1, pixel_rate_max);
> +
> +       vblank_def = imx208->cur_mode->vts_def - imx208->cur_mode->height;
> +       vblank_min = imx208->cur_mode->vts_min - imx208->cur_mode->height;
> +       imx208->vblank = v4l2_ctrl_new_std(
> +                               ctrl_hdlr, &imx208_ctrl_ops, V4L2_CID_VBLANK,
> +                               vblank_min,
> +                               IMX208_VTS_MAX - imx208->cur_mode->height, 1,
> +                               vblank_def);
> +
> +       imx208->hblank = v4l2_ctrl_new_std(
> +                               ctrl_hdlr, &imx208_ctrl_ops, V4L2_CID_HBLANK,
> +                               IMX208_PPL_384MHZ - imx208->cur_mode->width,
> +                               IMX208_PPL_384MHZ - imx208->cur_mode->width,
> +                               1,
> +                               IMX208_PPL_384MHZ - imx208->cur_mode->width);
> +
> +       if (imx208->hblank)
> +               imx208->hblank->flags |= V4L2_CTRL_FLAG_READ_ONLY;
> +
> +       exposure_max = imx208->cur_mode->vts_def - 8;
> +       v4l2_ctrl_new_std(ctrl_hdlr, &imx208_ctrl_ops, V4L2_CID_EXPOSURE,
> +                       IMX208_EXPOSURE_MIN, IMX208_EXPOSURE_MAX,
> +                       IMX208_EXPOSURE_STEP, IMX208_EXPOSURE_DEFAULT);
> +
> +       imx208->hflip = v4l2_ctrl_new_std(ctrl_hdlr, &imx208_ctrl_ops,
> +                                         V4L2_CID_HFLIP, 0, 1, 1, 0);
> +       imx208->vflip = v4l2_ctrl_new_std(ctrl_hdlr, &imx208_ctrl_ops,
> +                                         V4L2_CID_VFLIP, 0, 1, 1, 0);
> +
> +       v4l2_ctrl_new_std(ctrl_hdlr, &imx208_ctrl_ops, V4L2_CID_ANALOGUE_GAIN,
> +                               IMX208_ANA_GAIN_MIN, IMX208_ANA_GAIN_MAX,
> +                               IMX208_ANA_GAIN_STEP, IMX208_ANA_GAIN_DEFAULT);
> +
> +       v4l2_ctrl_new_std(ctrl_hdlr, &imx208_ctrl_ops, V4L2_CID_DIGITAL_GAIN,
> +                               IMX208_DGTL_GAIN_MIN, IMX208_DGTL_GAIN_MAX,
> +                               IMX208_DGTL_GAIN_STEP,
> +                               IMX208_DGTL_GAIN_DEFAULT);
> +
> +       v4l2_ctrl_new_std_menu_items(ctrl_hdlr, &imx208_ctrl_ops,
> +                                    V4L2_CID_TEST_PATTERN,
> +                                    ARRAY_SIZE(imx208_test_pattern_menu) - 1,
> +                                    0, 0, imx208_test_pattern_menu);
> +
> +       if (ctrl_hdlr->error) {
> +               ret = ctrl_hdlr->error;
> +               dev_err(&client->dev, "%s control init failed (%d)\n",
> +                       __func__, ret);
> +               goto error;
> +       }
> +
> +       imx208->sd.ctrl_handler = ctrl_hdlr;
> +
> +       return 0;
> +
> +error:
> +       v4l2_ctrl_handler_free(ctrl_hdlr);
> +       mutex_destroy(&imx208->imx208_mx);
> +
> +       return ret;
> +}
> +
> +static void imx208_free_controls(struct imx208 *imx208)
> +{
> +       v4l2_ctrl_handler_free(imx208->sd.ctrl_handler);
> +       mutex_destroy(&imx208->imx208_mx);

This mutex is not related to controls. Please just paste the 2 lines
above to where they are called, as this function adds more lines than
it saves.

> +}
> +
> +static int imx208_probe(struct i2c_client *client)
> +{
> +       struct imx208 *imx208;
> +       int ret;
> +       u32 val = 0;
> +
> +       device_property_read_u32(&client->dev, "clock-frequency", &val);
> +       if (val != 19200000)

Please print an error message, e.g.

dev_err(&client->dev, "Unsupported value of 'clock-frequency' (%u).
Expected 19200000.\n",
        val);

P.S. Please use my @chromium.org address in the future, if posting upstream.

Best regards,
Tomasz
