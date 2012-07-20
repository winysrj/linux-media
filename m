Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:53791 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472Ab2GTPg6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Jul 2012 11:36:58 -0400
Received: by vbbff1 with SMTP id ff1so3020731vbb.19
        for <linux-media@vger.kernel.org>; Fri, 20 Jul 2012 08:36:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <50087ECD.2060909@gmail.com>
References: <1342700047-31806-1-git-send-email-sangwook.lee@linaro.org>
	<1342700047-31806-3-git-send-email-sangwook.lee@linaro.org>
	<50087ECD.2060909@gmail.com>
Date: Fri, 20 Jul 2012 16:36:56 +0100
Message-ID: <CADPsn1aR5mgbs+HgN2a0CsUfzLN-Fz+uWNF3a0So3YO7JvZ1Vg@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] v4l: Add v4l2 subdev driver for S5K4ECGX sensor
From: Sangwook Lee <sangwook.lee@linaro.org>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	laurent.pinchart@ideasonboard.com,
	sakari.ailus@maxwell.research.nokia.com, suapapa@insignal.co.kr,
	quartz.jang@samsung.com, linaro-dev@lists.linaro.org,
	patches@linaro.org, usman.ahmad@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester

Thank you for the great review!

On 19 July 2012 22:40, Sylwester Nawrocki <sylvester.nawrocki@gmail.com> wrote:
>
> Hi Sangwook,
>
> A few review comments for you below...
>
> On 07/19/2012 02:14 PM, Sangwook Lee wrote:
> > This dirver implements preview mode of the S5K4ECGX sensor.
>
> dirver -> driver

OK, I will fix this.

> > capture (snapshot) operation, face detection are missing now.
> >
> > Following controls are supported:
> > contrast/saturation/birghtness/sharpness
>
> birghtness -> brightness
>

ditto

> > Signed-off-by: Sangwook Lee<sangwook.lee@linaro.org>
> > ---
> > + * Driver for s5k4ecgx (5MP Camera) from SAMSUNG
> > + * a quarter-inch optical format 1.4 micron 5 megapixel (Mp)
> > + * CMOS image sensor, as reffering to s5k6aa.c
>
> I think this should be mentioned after your own copyright notice,
> e.g. in form of:
>
> Based on s5k6aa driver,
> Copyright (C) 2011, Samsung Electronics Co., Ltd.

ditto

> > + *
> > + * Copyright (C) 2012, Linaro, Sangwook Lee<sangwook.lee@linaro.org>
> > + * Copyright (C) 2012, Insignal Co,. Ltd,  Homin
> > Lee<suapapa@insignal.co.kr>
> > + * Copyright (C) 2011, SAMSUNG ELECTRONICS
>
> No need to shout, "Samsung Electronics Co., Ltd." would be just enough.

ditto

>

> > +#include<media/v4l2-device.h>
> > +#include<media/v4l2-subdev.h>
> > +#include<media/media-entity.h>
> > +#include<media/v4l2-ctrls.h>
> > +#include<media/v4l2-mediabus.h>
> > +#include<media/s5k4ecgx.h>
>
> Can we, please, have these sorted alphabetically ?

OK, I will fix this.

>
> > +#include "s5k4ecgx_regs.h"
> > +
> > +static int debug;
> > +module_param(debug, int, 0644);
> > +
[snip]
> > +/* General purpose parameters */
> > +#define REG_USER_BRIGHTNESS          0x7000022C /* Brigthness */
>
> availble -> available

ditto

>
> > +#define REG_USER_SHARP1                      0x70000A28
> > +#define REG_USER_SHARP2                      0x70000ADE
> > +#define REG_USER_SHARP3                      0x70000B94
> > +#define REG_USER_SHARP4                      0x70000C4A
> > +#define REG_USER_SHARP5                      0x70000D00
> > +
> > +#define LSB(X) (((X)&  0xFF))
> > +#define MSB(Y) (((Y)>>  8)&  0xFF)
>
> Lower case for hex numbers is preferred.
>

ditto

> > +
> > +/*
> > + * Preview size lists supported by sensor
> > + */
> > +struct regval_list *pview_size[] = {
> > +     s5k4ecgx_176_preview,
> > +     s5k4ecgx_352_preview,
> > +     s5k4ecgx_640_preview,
> > +     s5k4ecgx_720_preview,
> > +};
> > +
> > +struct s5k4ecgx_framesize {
> > +     u32 idx; /* Should indicate index of pview_size */
> > +     u32 width;
> > +     u32 height;
> > +};
> > +
> > +/*
> > + * TODO: currently only preview is supported and snapshopt(capture)
> > + * is not implemented yet
> > + */
> > +static struct s5k4ecgx_framesize p_sets[] = {
>
> p_sets -> s5k4ecgx_framesizes ?

Hmm, the structure name needs to be changed properly.

>
> > +     {0, 176, 144},
> > +     {1, 352, 288},
> > +     {2, 640, 480},
> > +     {3, 720, 480},
>
> I believe we can do without presets for just the preview operation mode.

This (p_sets[]) is only used to configure preview size dynamically
when _s_fmt is called and then s_stream become on.

> Then, the number of registers to configure when device is powered on
> should then decrease significantly.
> Those presets are meant to speed up switching the device context, e.g.
> from preview to capture, but they just slow down initialization, because
> you have to configure all presets beforehand.
>
> > +};
> > +
> > +#define S5K4ECGX_NUM_PREV ARRAY_SIZE(p_sets)
> > +struct s5k4ecgx_pixfmt {
> > +     enum v4l2_mbus_pixelcode code;
> > +     u32 colorspace;
> > +};
> > +
> > +/* By defaut value, output from sensor will be YUV422 0-255 */
> > +static const struct s5k4ecgx_pixfmt s5k4ecgx_formats[] = {
> > +     { V4L2_MBUS_FMT_YUYV8_2X8, V4L2_COLORSPACE_JPEG},
>
> Nit: missing whitespace before }.

Thanks, I will fix this.

>
> > +};
> > +
> > +struct s5k4ecgx_preset {
> > +             /* output pixel format and resolution */
> > +             struct v4l2_mbus_framefmt mbus_fmt;
> > +             u8 clk_id;
> > +             u8 index;
> > +};
> > +
> > +struct s5k4ecgx {
> > +     struct v4l2_subdev sd;
> > +     struct media_pad pad;
> > +     struct v4l2_ctrl_handler handler;
> > +
> > +     struct s5k4ecgx_platform_data *pdata;
> > +     struct s5k4ecgx_preset presets[S5K4ECGX_MAX_PRESETS];
> > +     struct s5k4ecgx_preset *preset;
> > +     struct s5k4ecgx_framesize *p_now;       /* Current frame size */
> > +     struct v4l2_fract timeperframe;
> > +
> > +       /* protects the struct members below */
> > +     struct mutex lock;
> > +     int streaming;
> > +
> > +     /* Token for I2C burst write */
> > +     enum token_type reg_type;
> > +     u16 reg_addr_high;
> > +     u16 reg_addr_low;
> > +
> > +     /* Platform specific field */
> > +     int (*set_power)(int);
>
> This need to be replaced with regulator/GPIO API, if possible.
> Platform data callbacks cannot be supported on device tree platforms,
> hence we really need to avoid such callbacks.

Thanks for reminding me about device tree.
let me update the driver with regulator/GPIO API.

>
> > +     int mdelay;
> > +};
> > +
> > +static inline struct s5k4ecgx *to_s5k4ecgx(struct v4l2_subdev *sd)
> > +{
> > +     return container_of(sd, struct s5k4ecgx, sd);
> > +}
> > +
> > +static int s5k4ecgx_write_i2c(struct i2c_client *client, u8 *data, u16
> > len)
> > +{
> > +     struct i2c_msg msg = {client->addr, 0, len, (u8 *)data};
> > +     int ret;
> > +
> > +     ret = i2c_transfer(client->adapter,&msg, 1);
> > +     mdelay(S5K4ECGX_POLL_TIME);
>
> Argh, why is this needed ? If it can't be avoided, please replace it
> with usleep_range().

Ok, I will update this.

>
> > +     if (ret<  0) {
> > +             dev_err(&client->dev, "Failed to write I2C err\n");
> > +             return ret;
> > +     }
> > +
> > +     return 0;
> > +}
> > +
> > +static int s5k4ecgx_write32(struct i2c_client *client,
> > +                                    u16 addr, u16 data)
> > +{
> > +     u8 buf[4];
> > +
> > +     buf[0] = MSB(addr); /* SWAP 16 bit */
> > +     buf[1] = LSB(addr);
> > +     buf[2] = MSB(data);
> > +     buf[3] = LSB(data);
> > +
> > +     return s5k4ecgx_write_i2c(client, buf, 4);
> > +}
> > +
> > +static int s5k4ecgx_read_setup(struct v4l2_subdev *sd, u32 addr)
> > +{
> > +     struct i2c_client *client = v4l2_get_subdevdata(sd);
> > +     struct s5k4ecgx *priv = to_s5k4ecgx(sd);
> > +     u16 high = addr>>  16, low =  addr&  0xFFFF;
> > +     int ret = 0;
> > +
> > +     if (priv->reg_type != TOK_READ) {
> > +             priv->reg_addr_high = 0;
> > +             priv->reg_type = TOK_READ;
> > +     }
> > +     if (priv->reg_addr_high != high) {
> > +             ret = s5k4ecgx_write32(client, 0x002C, high);
> > +             priv->reg_addr_high = high;
> > +     }
> > +     ret |= s5k4ecgx_write32(client, 0x002E, low);
> > +
> > +     return ret;
> > +}
> > +
> > +static int s5k4ecgx_read16(struct i2c_client *client, u16 *val)
> > +{
> > +     struct i2c_msg msg[2];
> > +     u16 subaddr = 0x0F12;
> > +     u8 buf[2];
> > +     int err;
> > +
> > +     subaddr = swab16(subaddr);
> > +
> > +     msg[0].addr = client->addr;
> > +     msg[0].flags = 0;
> > +     msg[0].len = 2;
> > +     msg[0].buf = (u8 *)&subaddr;
> > +
> > +     msg[1].addr = client->addr;
> > +     msg[1].flags = I2C_M_RD;
> > +     msg[1].len = 2;
> > +     msg[1].buf = buf;
> > +
> > +     err = i2c_transfer(client->adapter, msg, 2);
> > +     if (unlikely(err != 2)) {
>
> "unlikely" doesn't make much sense here, it's not a fast path.

OK, I will fix this.

>
> > +             dev_err(&client->dev, "Failed to read register 0x%02x!\n",
> > +                     subaddr);
> > +             return -EIO;
> > +     }
> > +
> > +     *val = ((buf[0]<<  8) | buf[1]);
> > +
> > +     return 0;
> > +}
> > +
> > +/*
> > + * Access address will be remapped inside sensor (ARM7 core)
> > + */
> > +static int s5k4ecgx_write_setup(struct v4l2_subdev *sd, u16 high, u16
> > low)
> > +{
> > +     struct i2c_client *client = v4l2_get_subdevdata(sd);
> > +     struct s5k4ecgx *priv = to_s5k4ecgx(sd);
> > +     int ret = 0;
> > +
> > +     if (priv->reg_type != TOK_WRITE) {
> > +             priv->reg_addr_high = 0;
> > +             priv->reg_addr_low = 0;
> > +             priv->reg_type = TOK_WRITE;
> > +     }
> > +
> > +     /* FIXME: no information about 0x0028 in the datasheet */
>
> Hint: have a look at the S5K6AAFX sensor documentation.
>
> > +     if (priv->reg_addr_high != high) {
> > +             ret = s5k4ecgx_write32(client, 0x0028, high);
> > +             priv->reg_addr_high = high;
> > +             priv->reg_addr_low = 0;
> > +     }
> > +
> > +     /* FIXME: no information about 0x002A in the datasheet */
>
> Ditto.
>
> > +     if (priv->reg_addr_low != low) {
> > +             ret |= s5k4ecgx_write32(client, 0x002A, low);
> > +             priv->reg_addr_low = low;
> > +     }
> > +
> > +     return ret;
> > +}
> > +
> > +static int s5k4ecgx_write_ctrl(struct v4l2_subdev *sd, u32 addr, u16
> > data)
> > +{
> > +     struct i2c_client *client = v4l2_get_subdevdata(sd);
> > +     int ret;
> > +
> > +     v4l2_dbg(1, debug, sd, "Ctrl register val 0x%4x\n", data);
> > +     s5k4ecgx_write_setup(sd, addr>>  16, addr&  0xffff);
> > +     ret = s5k4ecgx_write32(client, 0x0F12, data);
>
> Just do:
>         return s5k4ecgx_write32(client, 0x0f12, data);

OK, I will change this.

> > +
> > +     return ret;
> > +}
> > +
> > +static u8 *s5k4ecgx_prep_buffer(int *cnt, struct regval_list **pos)
> > +{
> > +     struct regval_list *p_cur = *pos;
> > +     int burst_len = 0, len;
> > +     u8 *p_buf;
> > +
> > +     while (p_cur->type != TOK_TERM) {
> > +             /*
> > +              * Make sure two bytes data are used and address is
> > continous
>
> continous -> continuous

ditto

>
> > +              * to write them in a block
> > +              */
> > +             burst_len += 2;
> > +             if (TOK_WRITE != (p_cur + 1)->type)
> > +                     break;
> > +             if ((p_cur->addr + 2) != (p_cur + 1)->addr)
> > +                     break;
> > +             p_cur += 1;
> > +     }
> > +     p_buf = vmalloc(burst_len + 2);
>
> what ? why ? Is it just to append 2 bytes at the beginning of
> a register address/value array,

Yes it is just to append 2 bytes in the beginning.

>or just to swap regiter value
> bytes ?
>
> > +     if (!p_buf)
> > +             return NULL;
> > +
> > +     p_buf[0] = 0x0F; /* FIXME: no information in the datasheet */
> > +     p_buf[1] = 0x12;
>
> This may be some command write buffer I2C sub-address.

It makes sense. thanks!

>
> > +     p_cur = *pos;
> > +     len = 2;
> > +     burst_len += 2; /* Add two bytes */
> > +     while (1) {
> > +             p_buf[len] = MSB(p_cur->val);
> > +             p_buf[len + 1] = LSB(p_cur->val);
> > +             len += 2;
> > +             if (len<  burst_len)
> > +                     p_cur++;
> > +             else
> > +                     break;
> > +     }
> > +     *pos = p_cur;
> > +     *cnt = burst_len ;
>
> This looks really suspicious to me. I guess the purpose of this
> function is similar to what s5k6aa_write_array() does.
> It looks like a helper for writing an array of registers with
> contiguous addresses.

I think so. but I can't find any burst I2C writing information in the datasheet,
and as long as the sensor requires lots of initial settings value, It makes
sense.

>This shouldn't be needed as long as you update
> the I2C register write pointer as you go, when a difference of two
> subsequent addresses does not equal some constant value.
>
> Can you shed some light on why this function is needed ?
>
currently it is also updating register write pointers (regval_list **pos)
as it is only filling register data except address.

> > +
> > +     return p_buf;
> > +}
> > +
> > +static int s5k4ecgx_write_burst(struct v4l2_subdev *sd,
> > +                                     struct regval_list **pos)
> > +{
> > +     struct s5k4ecgx *priv = to_s5k4ecgx(sd);
> > +     struct i2c_client *client = v4l2_get_subdevdata(sd);
> > +     struct regval_list *p_cur = *pos;
> > +     int burst_len, ret = 0;
> > +     u8 *p_buf;
> > +
> > +     /* Select starting address of burst data */
> > +     s5k4ecgx_write_setup(sd, p_cur->addr>>  16, p_cur->addr&  0xffff);
> > +
> > +     /* Make buffer and then copy data into it */
> > +     p_buf = s5k4ecgx_prep_buffer(&burst_len, pos);
> > +     if (!p_buf)
> > +             return -ENOMEM;
> > +     ret = s5k4ecgx_write_i2c(client, p_buf, burst_len);
> > +     vfree(p_buf);
> > +     priv->reg_addr_low = 0;
> > +
> > +     return ret;
> > +}
> > +
> > +static int s5k4ecgx_write_array(struct v4l2_subdev *sd,
> > +                                     struct regval_list *vals)
> > +{
> > +     struct i2c_client *client = v4l2_get_subdevdata(sd);
> > +     int err = 0;
> > +
> > +     while (vals->type != TOK_TERM&&  !err) {
> > +             switch (vals->type) {
> > +             case TOK_WRITE:
> > +                     /*
> > +                      * This function continues to check the
> > +                      * following addresses, then update the address of
> > vals
> > +                      */
> > +                     err = s5k4ecgx_write_burst(sd,&vals);
> > +                     break;
> > +             case TOK_CMD:
> > +                     err = s5k4ecgx_write32(client, vals->addr,
> > vals->val);
> > +                     break;
> > +             case TOK_DELAY:
> > +                     msleep(vals->val);
> > +                     break;
> > +             default:
> > +                     v4l2_err(sd, "Failed to detect i2c type!\n");
> > +                     err = -EINVAL;
> > +                     break;
> > +             }
> > +             vals++;
> > +     }
> > +
> > +     if (unlikely(vals->type != TOK_TERM) || err)
> > +             v4l2_err(sd, "Failed to write array!\n");
> > +
> > +     return err;
> > +}
> > +
> > +static void s5k4ecgx_init_parameters(struct v4l2_subdev *sd)
> > +{
> > +     struct s5k4ecgx *priv = to_s5k4ecgx(sd);
> > +     int err = 0;
> > +
> > +     priv->streaming = 0;
> > +     /* brigthness default */
> > +     err = s5k4ecgx_write_array(sd, s5k4ecgx_ev_default);
> > +     /* no image effect */
> > +     err |= s5k4ecgx_write_array(sd, s5k4ecgx_effect_normal);
> > +     /* white blance auto */
> > +     err |= s5k4ecgx_write_array(sd, s5k4ecgx_wb_auto);
> > +     err |= s5k4ecgx_write_array(sd, s5k4ecgx_contrast_default);
> > +     err |= s5k4ecgx_write_array(sd, s5k4ecgx_iso_auto);
> > +     /* default 30 FPS */
> > +     err |= s5k4ecgx_write_array(sd, s5k4ecgx_fps_30);
> > +     err |= s5k4ecgx_write_array(sd, s5k4ecgx_scene_default);
> > +     err |= s5k4ecgx_write_array(sd, s5k4ecgx_saturation_default);
> > +     err |= s5k4ecgx_write_array(sd, s5k4ecgx_sharpness_default);
>
> I hope most of these go away, when we're done ;
>
> > +     if (err)
> > +             v4l2_err(sd, "Failed to write init params!\n");
> > +}
> > +
> > +static void s5k4ecgx_set_framesize(struct v4l2_subdev *sd,
> > +                                     struct v4l2_mbus_framefmt *in)
> > +{
> > +     struct s5k4ecgx *priv = to_s5k4ecgx(sd);
> > +     struct s5k4ecgx_framesize *a = p_sets;
> > +     struct s5k4ecgx_framesize *z = p_sets + S5K4ECGX_NUM_PREV - 1;
> > +
> > +     /* If not match, assign the biggest size  */
> > +     while (a != z) {
> > +             if (a->width == in->width&&  a->height == in->height)
> > +                     break;
> > +             a++;
> > +     }
> > +     priv->p_now = a;
> > +}
> > +
> > +static int s5k4ecgx_get_pixfmt_index(struct s5k4ecgx *priv,
> > +                                struct v4l2_mbus_framefmt *mf)
> > +{
> > +     unsigned int i;
> > +
> > +     for (i = 0; i<  ARRAY_SIZE(s5k4ecgx_formats); i++)
> > +             if (mf->colorspace == s5k4ecgx_formats[i].colorspace&&
> > +                 mf->code == s5k4ecgx_formats[i].code)
> > +                     return i;
> > +
> > +     return 0;
> > +}
> > +
> > +static void s5k4ecgx_try_fmt(struct s5k4ecgx *priv,
> > +                          struct v4l2_mbus_framefmt *mf)
> > +{
> > +     unsigned int index;
> > +
> > +     v4l_bound_align_image(&mf->width, S5K4ECGX_WIN_WIDTH_MIN,
> > +                     S5K4ECGX_WIN_WIDTH_MAX, 1,&mf->height,
> > +                     S5K4ECGX_WIN_HEIGHT_MIN, S5K4ECGX_WIN_HEIGHT_MAX,
> > 1, 0);
>
> You should return just 1 of 4 discrete resolutions here, according to
> p_sets[] array. Now the user is juts fooled that we support any resolution
> in range from S5K4ECGX_WIN_WIDTH_MIN x S5K4ECGX_WIN_HEIGHT_MIN to
> S5K4ECGX_WIN_WIDTH_MAX x S5K4ECGX_WIN_HEIGHT_MAX, with 2 pixel increments.
>
> Please see noon010pc30.c driver for a reference.
Thanks for info.
>
> > +     if (mf->colorspace != V4L2_COLORSPACE_JPEG)
> > +             mf->colorspace = V4L2_COLORSPACE_JPEG;
> > +     index = s5k4ecgx_get_pixfmt_index(priv, mf);
> > +     mf->colorspace  = s5k4ecgx_formats[0].colorspace;
> > +     mf->code                = s5k4ecgx_formats[0].code;
> > +     mf->field               = V4L2_FIELD_NONE;
> > +}
> > +
> > +static int s5k4ecgx_read_fw_ver(struct v4l2_subdev *sd)
> > +{
> > +     struct i2c_client *client = v4l2_get_subdevdata(sd);
> > +     u16 fw_ver = 0, hw_rev = 0;
> > +
> > +     s5k4ecgx_read_setup(sd, REG_FW_VERSION);
> > +     s5k4ecgx_read16(client,&fw_ver);
> > +     if (fw_ver != S5K4ECGX_FW_VERSION) {
> > +             v4l2_err(sd, "FW version check failed!");
> > +             return -ENODEV;
> > +     }
> > +     s5k4ecgx_read_setup(sd, REG_FW_REVISION);
> > +     s5k4ecgx_read16(client,&hw_rev);
> > +
> > +     if (hw_rev == S5K4ECGX_REVISION_1_1) {
> > +             v4l2_info(sd, "chip found FW ver: 0x%X, HW rev: 0x%X\n",
> > +                                             fw_ver, hw_rev);
> > +     } else {
> > +             v4l2_err(sd, "chip found but it has unknown revision
> > 0x%x\n",
>
> How about just making it:
>                 v4l2_err(sd, "Unknown H/W revision: %#x\n", hw_rev);
>
Oh, it looks better, I will take it.

> > +             return -ENODEV;
> > +     };
> > +
> > +     return 0;
> > +}
> > +
> > +static int s5k4ecgx_enum_mbus_code(struct v4l2_subdev *sd,
> > +                                struct v4l2_subdev_fh *fh,
> > +                                struct v4l2_subdev_mbus_code_enum
> > *code)
> > +{
> > +     if (code->index>= ARRAY_SIZE(s5k4ecgx_formats))
> > +             return -EINVAL;
> > +     code->code = s5k4ecgx_formats[code->index].code;
> > +
> > +     return 0;
> > +}
> > +
> > +static int s5k4ecgx_enum_frame_size(struct v4l2_subdev *sd,
> > +                               struct v4l2_subdev_fh *fh,
> > +                               struct v4l2_subdev_frame_size_enum *fse)
> > +{
> > +     int i = ARRAY_SIZE(s5k4ecgx_formats);
> > +
> > +     if (fse->index>  0)
>
> No, if you support 4 resolutions, fse->index = 0..3 are valid.

Thanks, let me fix this.

>
> > +             return -EINVAL;
> > +
> > +     while (--i)
> > +             if (fse->code == s5k4ecgx_formats[i].code)
> > +                     break;
> > +
> > +     fse->code = s5k4ecgx_formats[i].code;
> > +     fse->min_width  = S5K4ECGX_WIN_WIDTH_MIN;
> > +     fse->max_width  = S5K4ECGX_WIN_WIDTH_MAX;
>
> min_width, max_width should be equal in your case, to a pixel width
> of resolution pointed by fse->index.
>
> > +     fse->max_height = S5K4ECGX_WIN_HEIGHT_MIN;
> > +     fse->min_height = S5K4ECGX_WIN_HEIGHT_MAX;
>
> Similar as for width.
>
> > +
> > +     return 0;
> > +}
> > +
> > +static int s5k4ecgx_get_fmt(struct v4l2_subdev *sd, struct
> > v4l2_subdev_fh *fh,
> > +                         struct v4l2_subdev_format *fmt)
> > +{
> > +     struct s5k4ecgx *priv = to_s5k4ecgx(sd);
> > +     struct v4l2_mbus_framefmt *mf;
> > +
> > +     memset(fmt->reserved, 0, sizeof(fmt->reserved));
>
> I think it's safe to drop that line.
>
> > +     if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
> > +             mf = v4l2_subdev_get_try_format(fh, 0);
> > +             fmt->format = *mf;
> > +             return 0;
> > +     }
> > +     mutex_lock(&priv->lock);
> > +     fmt->format.width = priv->p_now->width;
> > +     fmt->format.height = priv->p_now->height;
> > +     mutex_unlock(&priv->lock);
> > +
> > +     return 0;
> > +}
> > +
> > +static int s5k4ecgx_set_fmt(struct v4l2_subdev *sd, struct
> > v4l2_subdev_fh *fh,
> > +                         struct v4l2_subdev_format *fmt)
> > +{
> > +     struct s5k4ecgx *priv = to_s5k4ecgx(sd);
> > +     struct s5k4ecgx_preset *preset = priv->preset;
> > +     struct v4l2_mbus_framefmt *mf;
> > +     struct v4l2_rect *crop;
> > +     int ret = 0;
> > +
> > +     mutex_lock(&priv->lock);
> > +     s5k4ecgx_try_fmt(priv,&fmt->format);
> > +
> > +     if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
> > +             mf = v4l2_subdev_get_try_format(fh, fmt->pad);
> > +             crop = v4l2_subdev_get_try_crop(fh, 0);
> > +     } else {
> > +             if (priv->streaming)
> > +                     ret = -EBUSY;
> > +             else
> > +                     mf =&preset->mbus_fmt;
> > +     }
> > +     if (ret == 0) {
> > +             *mf = fmt->format;
> > +             s5k4ecgx_set_framesize(sd,&fmt->format);
> > +     }
> > +     mutex_unlock(&priv->lock);
> > +
> > +     return ret;
> > +}
> > +
> > +static const struct v4l2_subdev_pad_ops s5k4ecgx_pad_ops = {
> > +     .enum_mbus_code         = s5k4ecgx_enum_mbus_code,
> > +     .enum_frame_size        = s5k4ecgx_enum_frame_size,
> > +     .get_fmt        = s5k4ecgx_get_fmt,
> > +     .set_fmt        = s5k4ecgx_set_fmt,
> > +};
> > +
> > +/*
> > + * V4L2 subdev controls
> > + */
> > +static int s5k4ecgx_s_ctrl(struct v4l2_ctrl *ctrl)
> > +{
> > +
> > +     struct v4l2_subdev *sd =&container_of(ctrl->handler, struct
> > s5k4ecgx,
> > +                                             handler)->sd;
> > +     struct s5k4ecgx *priv = to_s5k4ecgx(sd);
> > +     int err = 0;
> > +
> > +     v4l2_dbg(1, debug, sd, "ctrl: 0x%x, value: %d\n", ctrl->id,
> > ctrl->val);
> > +     mutex_lock(&priv->lock);
> > +
> > +     switch (ctrl->id) {
> > +     case V4L2_CID_CONTRAST:
> > +             err = s5k4ecgx_write_ctrl(sd, REG_USER_CONTRAST,
> > ctrl->val);
> > +             break;
> > +
> > +     case V4L2_CID_SATURATION:
> > +             err = s5k4ecgx_write_ctrl(sd, REG_USER_SATURATION,
> > ctrl->val);
> > +             break;
> > +
> > +     case V4L2_CID_SHARPNESS:
> > +             err |= s5k4ecgx_write_ctrl(sd, REG_USER_SHARP1,
> > ctrl->val);
> > +             err |= s5k4ecgx_write_ctrl(sd, REG_USER_SHARP2,
> > ctrl->val);
> > +             err |= s5k4ecgx_write_ctrl(sd, REG_USER_SHARP3,
> > ctrl->val);
> > +             err |= s5k4ecgx_write_ctrl(sd, REG_USER_SHARP4,
> > ctrl->val);
> > +             err |= s5k4ecgx_write_ctrl(sd, REG_USER_SHARP5,
> > ctrl->val);
>
> ????????
>
> Are you writing sharpness value for all possible "presets" even though
> only preset 0 is used ?

I don't think so. If I see the base reference code (from Google Nexus
S 3.0 kernel)
with one set sharpness, driver always write 5 registers continuously
with the defined
same value.

For example:

S5K4ECGX_DEFINE_REGSET(s5k4ecgx_Sharpness_Minus_3) = {
        S5K4ECGX_REG_WRITE(0x70000A28, 0x0000),
        S5K4ECGX_REG_WRITE(0x70000ADE, 0x0000),
        S5K4ECGX_REG_WRITE(0x70000B94, 0x0000),
        S5K4ECGX_REG_WRITE(0x70000C4A, 0x0000),
        S5K4ECGX_REG_WRITE(0x70000D00, 0x0000),
        S5K4ECGX_REGSET_END
};


>
> > +             break;
> > +
> > +     case V4L2_CID_BRIGHTNESS:
> > +             err = s5k4ecgx_write_ctrl(sd, REG_USER_BRIGHTNESS,
> > ctrl->val);
> > +             break;
> > +     default:
>
> This should never happen, i.e. s_ctrl is only called with valid ctrl->id.

Thanks, I will fix this.

>
> > +             v4l2_dbg(1, debug, sd, "unknown set ctrl id 0x%x\n",
> > ctrl->id);
> > +             err = -ENOIOCTLCMD;
>
> Return value should be -EINVAL, if you ever decide to keep it.
>
> > +             break;
> > +     }
> > +
> > +     /* Review this */
> > +     priv->reg_type = TOK_TERM;
> > +
> > +     mutex_unlock(&priv->lock);
> > +
> > +     if (err<  0)
> > +             v4l2_err(sd, "Failed to write videoc_s_ctrl err %d\n",
> > err);
>
> "Failed to write videoc_s_ctrl err" ? ;)
>
> > +     return err;
> > +}
> > +
> > +static const struct v4l2_ctrl_ops s5k4ecgx_ctrl_ops = {
> > +     .s_ctrl = s5k4ecgx_s_ctrl,
> > +};
> > +
> > +/*
> > + * Reading s5k4ecgx version information
> > + */
> > +static int s5k4ecgx_registered(struct v4l2_subdev *sd)
> > +{
> > +     struct s5k4ecgx *priv = to_s5k4ecgx(sd);
> > +     int ret;
> > +
> > +     if (!priv->set_power) {
> > +             v4l2_err(sd, "Error: power callback undefined!\n");
>
> Is it possible to avoid this callback, by moving voltage regulators
> handling to this driver ?

let me see it again when I use voltage regulator

>
> > +             return -EIO;
> > +     }
> > +
> > +     mutex_lock(&priv->lock);
> > +     priv->set_power(true);
> > +     /* Time to stablize sensor */
> > +     mdelay(priv->mdelay);
>
> Ugh, why people keep using those busy wait delays, instead of
> yielding CPU cycles to other tasks, by using *sleep*(..) versions ?
>
> > +     ret = s5k4ecgx_read_fw_ver(sd);
> > +     priv->set_power(false);
> > +     mutex_unlock(&priv->lock);
> > +
> > +     return ret;
> > +}
> > +
> > +/*
> > + *  V4L2 subdev internal operations
> > + */
> > +static int s5k4ecgx_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh
> > *fh)
> > +{
> > +
> > +     struct v4l2_mbus_framefmt *format = v4l2_subdev_get_try_format(fh,
> > 0);
> > +     struct v4l2_rect *crop = v4l2_subdev_get_try_crop(fh, 0);
> > +
> > +     format->colorspace = s5k4ecgx_formats[0].colorspace;
> > +     format->code = s5k4ecgx_formats[0].code;
> > +     format->width = S5K4ECGX_OUT_WIDTH_DEF;
> > +     format->height = S5K4ECGX_OUT_HEIGHT_DEF;
> > +     format->field = V4L2_FIELD_NONE;
> > +
> > +     crop->width = S5K4ECGX_WIN_WIDTH_MAX;
> > +     crop->height = S5K4ECGX_WIN_HEIGHT_MAX;
> > +     crop->left = 0;
> > +     crop->top = 0;
> > +
> > +     return 0;
> > +}
> > +
> > +static const struct v4l2_subdev_internal_ops
> > s5k4ecgx_subdev_internal_ops = {
> > +     .registered = s5k4ecgx_registered,
> > +     .open = s5k4ecgx_open,
> > +};
> > +
> > +static int s5k4ecgx_s_power(struct v4l2_subdev *sd, int on)
> > +{
> > +     struct s5k4ecgx *priv = to_s5k4ecgx(sd);
> > +
> > +     if (!priv->set_power)
> > +             return -EIO;
> > +
> > +     v4l2_dbg(1, debug, sd, "Switching %s\n", on ? "on" : "off");
> > +
> > +     if (on) {
> > +             priv->set_power(on);
> > +             /* Time to stablize sensor */
> > +             mdelay(priv->mdelay);
>
> msleep()
ditto

>
> > +             /* Loading firmware into ARM7 core of sensor */
> > +             if (s5k4ecgx_write_array(sd, s5k4ecgx_init_regs)<  0) {
>
> Yes, those register arrays could be converted to real firmware blobs
> as well. :)
For me, it looks like loading firmware. too many initial values. :-)

>
> > +                     priv->set_power(0); /* Turn off power */
> > +                     return -EIO;
> > +             }
> > +             s5k4ecgx_init_parameters(sd);
> > +     } else {
> > +             priv->set_power(0);
> > +     }
> > +
> > +     return 0;
> > +}
> > +
> > +static int s5k4ecgx_log_status(struct v4l2_subdev *sd)
> > +{
> > +     v4l2_ctrl_handler_log_status(sd->ctrl_handler, sd->name);
> > +
> > +     return 0;
> > +}
> > +
> > +static const struct v4l2_subdev_core_ops s5k4ecgx_core_ops = {
> > +     .s_power = s5k4ecgx_s_power,
> > +     .log_status     = s5k4ecgx_log_status,
> > +};
> > +
> > +static int __s5k4ecgx_s_stream(struct v4l2_subdev *sd, int on)
> > +{
> > +     struct s5k4ecgx *priv = to_s5k4ecgx(sd);
> > +     int err = 0;
> > +
> > +     if (on)
> > +             err = s5k4ecgx_write_array(sd,
> > pview_size[priv->p_now->idx]);
> > +
> > +     return err;
> > +}
> > +
> > +static int s5k4ecgx_s_stream(struct v4l2_subdev *sd, int on)
> > +{
> > +     struct s5k4ecgx *priv = to_s5k4ecgx(sd);
> > +     int ret = 0;
> > +
> > +     v4l2_dbg(1, debug, sd, "Turn streaming %s\n", on ? "on" : "off");
> > +     mutex_lock(&priv->lock);
> > +
> > +     if (on) {
> > +             /* Ignore if s_stream is called twice */
> > +             if (!priv->streaming) {
> > +                     ret = __s5k4ecgx_s_stream(sd, on);
> > +                     if (!ret)
> > +                             priv->streaming = on;
> > +             }
> > +     } else {
> > +             priv->streaming = 0;
>
> Data streaming is still active, as no registers were touched in this
> case. So this line should probably be moved to s_power(sd, 0) case above.

I agree that is more sensible. I just wanted a status variable in the
same function.
let me update this as well.

>
> > +     }
> > +
> > +     mutex_unlock(&priv->lock);
> > +
> > +     return ret;
> > +}
> > +
> > +static const struct v4l2_subdev_video_ops s5k4ecgx_video_ops = {
> > +     .s_stream = s5k4ecgx_s_stream,
> > +};
> > +
> > +static const struct v4l2_subdev_ops s5k4ecgx_ops = {
> > +     .core =&s5k4ecgx_core_ops,
> > +     .pad =&s5k4ecgx_pad_ops,
> > +     .video =&s5k4ecgx_video_ops,
> > +};
> > +
> > +static int s5k4ecgx_initialize_ctrls(struct s5k4ecgx *priv)
> > +{
> > +     const struct v4l2_ctrl_ops *ops =&s5k4ecgx_ctrl_ops;
> > +     struct v4l2_ctrl_handler *hdl =&priv->handler;
> > +     int ret;
> > +
> > +     ret =  v4l2_ctrl_handler_init(hdl, 16);
>
> The hint should be 4, not 16. There are only 4 controls added to the
> control handler below.

Good point, I will change this.

>
> > +     if (ret)
> > +             return ret;
> > +
> > +     v4l2_ctrl_new_std(hdl, ops, V4L2_CID_BRIGHTNESS, -208, 127, 1, 0);
>
> Is minimum brightness really -208 ?

so to speak, this is kind of reverse engineering :-), not from the datasheet.

I got the values such 0xFF30, 0xFFA0, 0xFFC8, 0XFFE0, 0x0, 0x20, 0X7F
                                 -208      -96
                           127

For example)
S5K4ECGX_DEFINE_REGSET(s5k4ecgx_EV_Minus_4) = {
        S5K4ECGX_REG_WRITE(0x70000230, 0xFF30),
        S5K4ECGX_REGSET_END
};


>
> > +     v4l2_ctrl_new_std(hdl, ops, V4L2_CID_CONTRAST, -127, 127, 1, 0);
> > +     v4l2_ctrl_new_std(hdl, ops, V4L2_CID_SATURATION, -127, 127, 1, 0);
> > +
> > +     /* For sharpness, 0x6024 is default value */
> > +     v4l2_ctrl_new_std(hdl, ops, V4L2_CID_SHARPNESS, -32704, 24612,
> > 8208,
> > +                       24612);
>
> How about:
>         v4l2_ctrl_new_std(hdl, ops, V4L2_CID_SHARPNESS, -32704/8208,
> 24612/8208, 1,
> > +                       24612/8208);
>
> and multiplying brightness control value by 8208 in s_ctrl() ?
> It's not that difficult and would let us present more uniform interface
> to the user.

Good point, I will change this.


> > +     if (hdl->error) {
> > +             ret = hdl->error;
> > +             v4l2_ctrl_handler_free(hdl);
> > +             return ret;
> > +     }
> > +     priv->sd.ctrl_handler = hdl;
> > +
> > +     return 0;
> > +};
> > +
> > +/*
> > + * Set initial values for all preview presets
> > + */
> > +static void s5k4ecgx_presets_data_init(struct s5k4ecgx *priv)
> > +{
> > +     struct s5k4ecgx_preset *preset =&priv->presets[0];
> > +     int i;
> > +
> > +     for (i = 0; i<  S5K4ECGX_MAX_PRESETS; i++) {
> > +             preset->mbus_fmt.width  = S5K4ECGX_OUT_WIDTH_DEF;
> > +             preset->mbus_fmt.height = S5K4ECGX_OUT_HEIGHT_DEF;
> > +             preset->mbus_fmt.code   = s5k4ecgx_formats[0].code;
> > +             preset->index           = i;
> > +             preset->clk_id          = 0;
> > +             preset++;
> > +     }
> > +     priv->preset =&priv->presets[0];
> > +}
> > +
> > +/*
> > +  * Fetching platform data is being done with s_config subdev call.
>
> This is not true, please remove it. There have been no s_config callback
> for ages now.
>
> > +  * In probe routine, we just register subdev device
>
> This comment also doesn't add any special value, IMHO.
>
> > +  */
> > +static int s5k4ecgx_probe(struct i2c_client *client,
> > +                       const struct i2c_device_id *id)
> > +{
> > +     struct v4l2_subdev *sd;
> > +     struct s5k4ecgx *priv;
> > +     struct s5k4ecgx_platform_data *pdata = client->dev.platform_data;
> > +     int     ret;
> > +
> > +     if (pdata == NULL) {
> > +             dev_err(&client->dev, "platform data is missing!\n");
> > +             return -EINVAL;
> > +     }
> > +     priv = kzalloc(sizeof(struct s5k4ecgx), GFP_KERNEL);
>
> devm_kzalloc ?

Thanks, please let me look at this.

>
> > +
> > +     if (!priv)
> > +             return -ENOMEM;
> > +
> > +     mutex_init(&priv->lock);
> > +
> > +     priv->set_power = pdata->set_power;
> > +     priv->mdelay = pdata->mdelay;
> > +
> > +     sd =&priv->sd;
> > +     /* Registering subdev */
> > +     v4l2_i2c_subdev_init(sd, client,&s5k4ecgx_ops);
> > +     strlcpy(sd->name, S5K4ECGX_DRIVER_NAME, sizeof(sd->name));
> > +
> > +     sd->internal_ops =&s5k4ecgx_subdev_internal_ops;
> > +     /* Support v4l2 sub-device userspace API */
> > +     sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> > +
> > +     priv->pad.flags = MEDIA_PAD_FL_SOURCE;
> > +     sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV_SENSOR;
> > +     ret = media_entity_init(&sd->entity, 1,&priv->pad, 0);
> > +     if (ret)
> > +             goto out_err;
> > +
> > +     ret = s5k4ecgx_initialize_ctrls(priv);
> > +     s5k4ecgx_presets_data_init(priv);
> > +
> > +     if (ret)
> > +             goto out_err;
> > +
> > +     return 0;
> > +
> > + out_err:
> > +     media_entity_cleanup(&priv->sd.entity);
> > +     kfree(priv);
> > +
> > +     return ret;
> > +}
> > +
> > +static int s5k4ecgx_remove(struct i2c_client *client)
> > +{
> > +     struct v4l2_subdev *sd = i2c_get_clientdata(client);
> > +     struct s5k4ecgx *priv = to_s5k4ecgx(sd);
> > +
> > +     mutex_destroy(&priv->lock);
> > +     v4l2_device_unregister_subdev(sd);
> > +     v4l2_ctrl_handler_free(&priv->handler);
>
> If you use devm_kzalloc() in probe(), then this could be:
>
>         v4l2_ctrl_handler_free(sd->ctrl_handler);
>
> > +     media_entity_cleanup(&sd->entity);
> > +     kfree(priv);
>
> ...and this line could be dropped.
>
> > +
> > +     return 0;
> > +}
> > +
> > +static const struct i2c_device_id s5k4ecgx_id[] = {
> > +     { S5K4ECGX_DRIVER_NAME, 0 },
> > +     {}
> > +};
> > +MODULE_DEVICE_TABLE(i2c, s5k4ecgx_id);
> > +
> > +static struct i2c_driver v4l2_i2c_driver = {
> > +     .driver = {
> > +             .owner  = THIS_MODULE,
> > +             .name = S5K4ECGX_DRIVER_NAME,
> > +     },
> > +     .probe = s5k4ecgx_probe,
> > +     .remove = s5k4ecgx_remove,
> > +     .id_table = s5k4ecgx_id,
> > +};
> > +
> > +module_i2c_driver(v4l2_i2c_driver);
> > +
> > +MODULE_DESCRIPTION("Samsung S5K4ECGX 5MP SOC camera");
> > +MODULE_AUTHOR("Sangwook Lee<sangwook.lee@linaro.org>");
> > +MODULE_AUTHOR("Seok-Young Jang<quartz.jang@samsung.com>");
> > +MODULE_LICENSE("GPL");
> > diff --git a/include/media/s5k4ecgx.h b/include/media/s5k4ecgx.h
> > new file mode 100644
> > index 0000000..e041761
> > --- /dev/null
> > +++ b/include/media/s5k4ecgx.h
> > @@ -0,0 +1,29 @@
> > +/*
> > + * S5K4ECGX Platform data header
>
> S5K4ECGX image sensor driver header ?
>
> > + *
> > + * Copyright (C) 2012, Linaro
> > + *
> > + * Copyright (C) 2010, SAMSUNG ELECTRONICS
>
> Plase use lower case, and proper copyright for Samsung is exactly:

Good point.

>
>  "Copyright (C) 2010, Samsung Electronics Co., Ltd."
>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License as published by
> > + * the Free Software Foundation; either version 2 of the License, or
> > + * (at your option) any later version.
> > + */
> > +
> > +#ifndef S5K4ECGX_H
> > +#define S5K4ECGX_H
> > +
> > +/**
> > + * struct ss5k4ecgx_platform_data- s5k4ecgx driver platform data
> > + * @set_power: an callback to give the chance to turn off/on
> > + *            camera which is depending on the board code
> > + * @mdelay   : delay (ms) needed after enabling power
> > + */
> > +
> > +struct s5k4ecgx_platform_data {
> > +     int (*set_power)(int);
>
> It would be good to replace this callback with something else,
> for the reasons I mentioned above. I think for Origen board we
> could get rid of it by adding (fixed) voltage regulator support
> in this driver and passing SRST, nSTBY GPIOs through this platform
> data structure.

Fair enough, I will fix this.

>
> It's done this way in s5k6aa case, and for some boards the
> set_power callback remains unused (it's treated as optional in
> the driver).
>
> > +     int mdelay;
> > +};
> > +
> > +#endif /* S5K4ECGX_H */
>
> --
>
> Thanks!
> Sylwester


Thanks
Sangwook
