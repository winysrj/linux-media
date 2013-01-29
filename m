Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:32981 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754958Ab3A2JNS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Jan 2013 04:13:18 -0500
Received: by mail-wg0-f46.google.com with SMTP id fg15so133748wgb.13
        for <linux-media@vger.kernel.org>; Tue, 29 Jan 2013 01:13:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201301251257.20164.hverkuil@xs4all.nl>
References: <201301251257.20164.hverkuil@xs4all.nl>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Tue, 29 Jan 2013 14:42:57 +0530
Message-ID: <CA+V-a8s5htX2P_7ZVdfr2+rF5REHgD51TozHKFBBPBX0fNfAng@mail.gmail.com>
Subject: Re: [FYI PATCH] Cisco's ths7353 driver...
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>,
	Martin Bugge <marbugge@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Fri, Jan 25, 2013 at 5:27 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Hi Prabhakar,
>
> As mentioned in my review of your ths7353 driver we (Cisco) have a driver
> for this device as well. Below is our driver so you can take the best bits
> of both.
>
Thanks for sharing the patch.

> However, I wonder if instead the ths7353 driver and the already existing
> ths7303 driver should just be merged. They are awfully similar.
>
Yes, that would be good idea. It might take some time for me stitch things
since I am busy with other stuff hope you are ok with it.

Regards,
--Prabhakar

> Regards,
>
>         Hans
>
> From 8db6b9c176ac6d7a7d5328fc96f38e0be0c2e8dc Mon Sep 17 00:00:00 2001
> Message-Id: <8db6b9c176ac6d7a7d5328fc96f38e0be0c2e8dc.1359114954.git.hans.verkuil@cisco.com>
> From: Hans Verkuil <hans.verkuil@cisco.com>
> Date: Fri, 25 Jan 2013 12:55:31 +0100
> Subject: [PATCH] ths7353
>
> Signed-off-by: Martin Bugge <marbugge@cisco.com>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/i2c/Kconfig       |   10 +
>  drivers/media/i2c/Makefile      |    1 +
>  drivers/media/i2c/ths7353.c     |  419 +++++++++++++++++++++++++++++++++++++++
>  include/media/ths7353.h         |   31 +++
>  include/media/v4l2-chip-ident.h |    3 +
>  5 files changed, 464 insertions(+)
>  create mode 100644 drivers/media/i2c/ths7353.c
>  create mode 100644 include/media/ths7353.h
>
> diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
> index 1e4b2d0..a1bbb2f 100644
> --- a/drivers/media/i2c/Kconfig
> +++ b/drivers/media/i2c/Kconfig
> @@ -570,6 +570,16 @@ config VIDEO_THS7303
>           To compile this driver as a module, choose M here: the
>           module will be called ths7303.
>
> +config VIDEO_THS7353
> +       tristate "THS7353 Video Amplifier"
> +       depends on I2C
> +       help
> +         Support for TI THS7353 video amplifier
> +
> +         To compile this driver as a module, choose M here: the
> +         module will be called ths7353. This helps tvp7002 to amplify
> +         the signals.
> +
>  config VIDEO_M52790
>         tristate "Mitsubishi M52790 A/V switch"
>         depends on VIDEO_V4L2 && I2C
> diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
> index b1d62df..9944d06 100644
> --- a/drivers/media/i2c/Makefile
> +++ b/drivers/media/i2c/Makefile
> @@ -34,6 +34,7 @@ obj-$(CONFIG_VIDEO_BT856) += bt856.o
>  obj-$(CONFIG_VIDEO_BT866) += bt866.o
>  obj-$(CONFIG_VIDEO_KS0127) += ks0127.o
>  obj-$(CONFIG_VIDEO_THS7303) += ths7303.o
> +obj-$(CONFIG_VIDEO_THS7353) += ths7353.o
>  obj-$(CONFIG_VIDEO_TVP5150) += tvp5150.o
>  obj-$(CONFIG_VIDEO_TVP514X) += tvp514x.o
>  obj-$(CONFIG_VIDEO_TVP7002) += tvp7002.o
> diff --git a/drivers/media/i2c/ths7353.c b/drivers/media/i2c/ths7353.c
> new file mode 100644
> index 0000000..618cfbf
> --- /dev/null
> +++ b/drivers/media/i2c/ths7353.c
> @@ -0,0 +1,419 @@
> +/*
> + * ths7353 - Texas Instruments THS7353 Video Amplifier driver
> + *
> + * Copyright 2013 Cisco Systems, Inc. and/or its affiliates.  All rights reserved.
> + *
> + * This program is free software; you may redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; version 2 of the License.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> + * SOFTWARE.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/ctype.h>
> +#include <linux/slab.h>
> +#include <linux/i2c.h>
> +#include <linux/device.h>
> +#include <linux/delay.h>
> +#include <linux/module.h>
> +#include <linux/uaccess.h>
> +#include <linux/videodev2.h>
> +
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-subdev.h>
> +#include <media/v4l2-chip-ident.h>
> +#include <media/ths7353.h>
> +
> +MODULE_DESCRIPTION("TI THS7353 video amplifier driver");
> +MODULE_AUTHOR("Martin Bugge <marbugge@cisco.com>");
> +MODULE_LICENSE("GPL");
> +
> +static int debug;
> +module_param(debug, int, 0644);
> +MODULE_PARM_DESC(debug, "Debug level 0-1");
> +
> +struct ths7353_state {
> +       struct v4l2_subdev sd;
> +       struct ths7353_platform_data pdata;
> +       struct v4l2_dv_timings dv_timings;
> +       int stream_on;
> +};
> +
> +/* ----------------------------------------------------------------------- */
> +
> +static inline struct ths7353_state *to_state(struct v4l2_subdev *sd)
> +{
> +       return container_of(sd, struct ths7353_state, sd);
> +}
> +
> +/* ----------------------------------- I2C ------------------------------------ */
> +
> +static int ths7353_rd(struct v4l2_subdev *sd, u8 reg)
> +{
> +       struct i2c_client *client = v4l2_get_subdevdata(sd);
> +
> +       return i2c_smbus_read_byte_data(client, reg);
> +}
> +
> +static int ths7353_wr(struct v4l2_subdev *sd, u8 reg, u8 val)
> +{
> +       struct i2c_client *client = v4l2_get_subdevdata(sd);
> +       int ret;
> +       int i;
> +
> +       for (i = 0; i < 3; i++) {
> +               ret = i2c_smbus_write_byte_data(client, reg, val);
> +               if (ret == 0)
> +                       return 0;
> +       }
> +       v4l2_err(sd, "I2C Write Problem\n");
> +       return ret;
> +}
> +
> +static inline void ths7353_wr_and_or(struct v4l2_subdev *sd, u8 reg, uint8_t clr_mask, uint8_t val_mask)
> +{
> +       ths7353_wr(sd, reg, (ths7353_rd(sd, reg) & clr_mask) | val_mask);
> +}
> +
> +/* ----------------------------------------------------------------------- */
> +
> +struct channel_register_bit_decoder {
> +       uint8_t stc_lpf_sel;
> +       uint8_t in_mux_sel;
> +       uint8_t lpf_freq_sel;
> +       uint8_t in_bias_sel_dis_cont;
> +};
> +
> +static const char *stc_lpf_sel_txt[4] = {
> +       "500-kHz Filter",
> +       "2.5-MHz Filter",
> +       "5-MHz Filter",
> +       "5-MHz Filter",
> +};
> +
> +static const char *in_mux_sel_txt[2] = {
> +       "Input A Select",
> +       "Input B Select",
> +};
> +
> +static const char *lpf_freq_sel_txt[4] = {
> +       "9-MHz LPF",
> +       "16-MHz LPF",
> +       "35-MHz LPF",
> +       "Bypass LPF",
> +};
> +
> +static const char *in_bias_sel_dis_cont_txt[8] = {
> +       "Disable Channel",
> +       "Mute Function - No Output",
> +       "DC Bias Select",
> +       "DC Bias + 250 mV Offset Select",
> +       "AC Bias Select",
> +       "Sync Tip Clamp with low bias",
> +       "Sync Tip Clamp with mid bias",
> +       "Sync Tip Clamp with high bias",
> +};
> +
> +static void parse_channel_register(struct channel_register_bit_decoder *ch_reg, u8 val)
> +{
> +       ch_reg->stc_lpf_sel = (val >> 6) & 0x3;
> +       ch_reg->in_mux_sel = (val >> 5) & 0x1;
> +       ch_reg->lpf_freq_sel = (val >> 3) & 0x3;
> +       ch_reg->in_bias_sel_dis_cont = (val >> 0) & 0x7;
> +}
> +
> +static void ths7353_log_channel_status(struct v4l2_subdev *sd, u8 reg)
> +{
> +       struct channel_register_bit_decoder ch_reg;
> +       u8 val = ths7353_rd(sd, reg);
> +
> +       if ((val & 0x7) == 0) {
> +               v4l2_info(sd, "Channel %d Off\n", reg);
> +               return;
> +       }
> +
> +       parse_channel_register(&ch_reg, val);
> +
> +       v4l2_info(sd, "Channel %d On\n", reg);
> +       v4l2_info(sd, "  value 0x%x\n", val);
> +       v4l2_info(sd, "  %s\n", stc_lpf_sel_txt[ch_reg.stc_lpf_sel]);
> +       v4l2_info(sd, "  %s\n", in_mux_sel_txt[ch_reg.in_mux_sel]);
> +       v4l2_info(sd, "  %s\n", lpf_freq_sel_txt[ch_reg.lpf_freq_sel]);
> +       v4l2_info(sd, "  %s\n", in_bias_sel_dis_cont_txt[ch_reg.in_bias_sel_dis_cont]);
> +}
> +
> +static void ths7353_config(struct v4l2_subdev *sd)
> +{
> +       struct ths7353_state *state = to_state(sd);
> +       struct v4l2_bt_timings *bt = bt = &state->dv_timings.bt;
> +       struct ths7353_platform_data *pdata = &state->pdata;
> +       u8 val, sel = 0;
> +
> +       v4l2_dbg(1, debug, sd, "%s:\n", __func__);
> +
> +       if (!state->stream_on) {
> +               v4l2_dbg(1, debug, sd, "%s: stream off\n", __func__);
> +               ths7353_wr_and_or(sd, 0x01, 0xf8, 0x00);
> +               ths7353_wr_and_or(sd, 0x02, 0xf8, 0x00);
> +               ths7353_wr_and_or(sd, 0x03, 0xf8, 0x00);
> +               return;
> +       }
> +
> +       if (state->dv_timings.type != V4L2_DV_BT_656_1120)
> +               return;
> +
> +       if (bt->pixelclock > 120000000) {
> +               /* 1080p and SXGA/UXGA */
> +               sel = 0x3;
> +       } else if (bt->pixelclock > 70000000) {
> +               /* 720p, 1080i, and SVGA/XGA */
> +               sel = 0x2;
> +       } else if (bt->pixelclock > 20000000) {
> +               /* EDTV 480p/576p and VGA */
> +               sel = 0x1;
> +       } else {
> +               /* SDTV, S-Video, 480i/576i */
> +               sel = 0x0;
> +       }
> +
> +       v4l2_dbg(1, debug, sd, "%s: filter select 0x%x\n", __func__, sel);
> +
> +       /*
> +        * use same filter selection both on
> +        *  STC LPF and Freq. LPF
> +        */
> +       val = (pdata->ch_1 & 0x27) | (sel << 6) | (sel << 3);
> +       ths7353_wr(sd, 0x01, val);
> +       val = (pdata->ch_2 & 0x27) | (sel << 6) | (sel << 3);
> +       ths7353_wr(sd, 0x02, val);
> +       val = (pdata->ch_3 & 0x27) | (sel << 6) | (sel << 3);
> +       ths7353_wr(sd, 0x03, val);
> +}
> +
> +/* ----------------------------------------------------------------------- */
> +
> +static int ths7353_g_chip_ident(struct v4l2_subdev *sd,
> +                               struct v4l2_dbg_chip_ident *chip)
> +{
> +       struct i2c_client *client = v4l2_get_subdevdata(sd);
> +
> +       return v4l2_chip_ident_i2c_client(client, chip, V4L2_IDENT_THS7353, 0);
> +}
> +
> +static int ths7353_log_status(struct v4l2_subdev *sd)
> +{
> +       struct ths7353_state *state = to_state(sd);
> +
> +       v4l2_info(sd, "stream %s\n", state->stream_on ? "On" : "Off");
> +
> +       if (state->dv_timings.type == V4L2_DV_BT_656_1120) {
> +               struct v4l2_bt_timings *bt = bt = &state->dv_timings.bt;
> +               u32 frame_width = bt->width + bt->hfrontporch + bt->hsync + bt->hbackporch;
> +               u32 frame_height = bt->height + bt->vfrontporch + bt->vsync + bt->vbackporch;
> +
> +               v4l2_info(sd, "timings: %dx%d%s%d (%dx%d). Pix freq. = %d Hz. Polarities = 0x%x\n",
> +                       bt->width, bt->height, bt->interlaced ? "i" : "p",
> +                       (frame_height * frame_width) > 0 ?
> +                               (int)bt->pixelclock / (frame_height * frame_width) : 0,
> +                       frame_width, frame_height, (int)bt->pixelclock, bt->polarities);
> +       } else {
> +               v4l2_info(sd, "no timings set\n");
> +       }
> +
> +       ths7353_log_channel_status(sd, 1);
> +       ths7353_log_channel_status(sd, 2);
> +       ths7353_log_channel_status(sd, 3);
> +
> +       return 0;
> +}
> +
> +#ifdef CONFIG_VIDEO_ADV_DEBUG
> +
> +static int ths7353_g_register(struct v4l2_subdev *sd,
> +                             struct v4l2_dbg_register *reg)
> +{
> +       struct i2c_client *client = v4l2_get_subdevdata(sd);
> +
> +       if (!v4l2_chip_match_i2c_client(client, &reg->match))
> +               return -EINVAL;
> +       if (!capable(CAP_SYS_ADMIN))
> +               return -EPERM;
> +
> +       reg->size = 1;
> +       reg->val = ths7353_rd(sd, reg->reg);
> +       return 0;
> +}
> +
> +static int ths7353_s_register(struct v4l2_subdev *sd,
> +                             struct v4l2_dbg_register *reg)
> +{
> +       struct i2c_client *client = v4l2_get_subdevdata(sd);
> +
> +       if (!v4l2_chip_match_i2c_client(client, &reg->match))
> +               return -EINVAL;
> +       if (!capable(CAP_SYS_ADMIN))
> +               return -EPERM;
> +
> +       ths7353_wr(sd, reg->reg, reg->val);
> +       return 0;
> +}
> +#endif
> +
> +static const struct v4l2_subdev_core_ops ths7353_core_ops = {
> +       .g_chip_ident = ths7353_g_chip_ident,
> +       .log_status = ths7353_log_status,
> +#ifdef CONFIG_VIDEO_ADV_DEBUG
> +       .g_register = ths7353_g_register,
> +       .s_register = ths7353_s_register,
> +#endif
> +};
> +
> +static int ths7353_s_stream(struct v4l2_subdev *sd, int enable)
> +{
> +       struct ths7353_state *state = to_state(sd);
> +
> +       v4l2_dbg(1, debug, sd, "%s: %s\n", __func__, enable ? "on" : "off");
> +
> +       state->stream_on = enable;
> +
> +       ths7353_config(sd);
> +
> +       return 0;
> +}
> +
> +static int ths7353_s_dv_timings(struct v4l2_subdev *sd,
> +                               struct v4l2_dv_timings *timings)
> +{
> +       struct ths7353_state *state = to_state(sd);
> +
> +       v4l2_dbg(1, debug, sd, "%s:\n", __func__);
> +
> +       if (!timings || timings->type != V4L2_DV_BT_656_1120)
> +               return -EINVAL;
> +
> +       /* save timings */
> +       state->dv_timings = *timings;
> +
> +       ths7353_config(sd);
> +
> +       return 0;
> +}
> +
> +static const struct v4l2_subdev_video_ops ths7353_video_ops = {
> +       .s_stream = ths7353_s_stream,
> +       .s_dv_timings = ths7353_s_dv_timings,
> +};
> +
> +static const struct v4l2_subdev_ops ths7353_ops = {
> +       .core = &ths7353_core_ops,
> +       .video = &ths7353_video_ops,
> +};
> +
> +static int ths7353_setup(struct v4l2_subdev *sd)
> +{
> +       struct ths7353_state *state = to_state(sd);
> +       struct ths7353_platform_data *pdata = &state->pdata;
> +       int ret;
> +       u8 mask;
> +
> +       state->stream_on = pdata->init_enable;
> +
> +       mask = state->stream_on ? 0xff : 0xf8;
> +
> +       ret = ths7353_wr(sd, 0x01, pdata->ch_1 & mask);
> +       if (ret)
> +               return ret;
> +
> +       ret = ths7353_wr(sd, 0x02, pdata->ch_2 & mask);
> +       if (ret)
> +               return ret;
> +
> +       ret = ths7353_wr(sd, 0x03, pdata->ch_3 & mask);
> +       if (ret)
> +               return ret;
> +
> +       return 0;
> +}
> +
> +static int ths7353_probe(struct i2c_client *client,
> +                        const struct i2c_device_id *id)
> +{
> +       struct ths7353_state *state;
> +       struct v4l2_subdev *sd;
> +       struct ths7353_platform_data *pdata = client->dev.platform_data;
> +       int ret = 0;
> +
> +       if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA))
> +               return -ENODEV;
> +
> +       v4l_info(client, "chip found @ 0x%x (%s)\n",
> +                client->addr << 1, client->adapter->name);
> +
> +       state = kzalloc(sizeof(struct ths7353_state), GFP_KERNEL);
> +       if (!state)
> +               return -ENOMEM;
> +
> +       if (pdata == NULL) {
> +               v4l_err(client, "No platform data!\n");
> +               ret = -ENODEV;
> +               goto err_free;
> +       }
> +
> +       state->pdata = *pdata;
> +
> +       sd = &state->sd;
> +       v4l2_i2c_subdev_init(sd, client, &ths7353_ops);
> +       sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> +
> +       if (ths7353_setup(sd) < 0) {
> +               v4l_err(client, "init failed\n");
> +               ret = -EIO;
> +               goto err_free;
> +       }
> +
> +       return ret;
> +
> +err_free:
> +       kfree(state);
> +       return ret;
> +}
> +
> +static int ths7353_remove(struct i2c_client *client)
> +{
> +       struct v4l2_subdev *sd = i2c_get_clientdata(client);
> +       struct ths7353_state *state = to_state(sd);
> +
> +       v4l2_device_unregister_subdev(sd);
> +
> +       kfree(state);
> +       return 0;
> +}
> +
> +static const struct i2c_device_id ths7353_id[] = {
> +       { "ths7353", 0 },
> +       {},
> +};
> +
> +MODULE_DEVICE_TABLE(i2c, ths7353_id);
> +
> +static struct i2c_driver ths7353_driver = {
> +       .driver = {
> +               .owner  = THIS_MODULE,
> +               .name   = "ths7353",
> +       },
> +       .probe          = ths7353_probe,
> +       .remove         = ths7353_remove,
> +       .id_table       = ths7353_id,
> +};
> +
> +module_i2c_driver(ths7353_driver);
> +
> diff --git a/include/media/ths7353.h b/include/media/ths7353.h
> new file mode 100644
> index 0000000..37401bf
> --- /dev/null
> +++ b/include/media/ths7353.h
> @@ -0,0 +1,31 @@
> +/*
> + * ths7353 - Texas Instruments THS7353 DVI-A Amplifier
> + *
> + * Copyright 2013 Cisco Systems, Inc. and/or its affiliates.  All rights reserved.
> + *
> + * This program is free software; you may redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; version 2 of the License.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> + * SOFTWARE.
> + */
> +
> +#ifndef THS7353_H
> +#define THS7353_H
> +
> +/* Platform dependent definitions */
> +struct ths7353_platform_data {
> +       u8 ch_1;
> +       u8 ch_2;
> +       u8 ch_3;
> +       u8 init_enable;
> +};
> +
> +#endif
> diff --git a/include/media/v4l2-chip-ident.h b/include/media/v4l2-chip-ident.h
> index 4ee125b..f9f687e 100644
> --- a/include/media/v4l2-chip-ident.h
> +++ b/include/media/v4l2-chip-ident.h
> @@ -180,6 +180,9 @@ enum {
>         /* module adv7343: just ident 7343 */
>         V4L2_IDENT_ADV7343 = 7343,
>
> +       /* module ths7353: just ident 7353 */
> +       V4L2_IDENT_THS7353 = 7353,
> +
>         /* module adv7393: just ident 7393 */
>         V4L2_IDENT_ADV7393 = 7393,
>
> --
> 1.7.10.4
>
