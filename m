Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39628 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751326AbeAaUHZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Jan 2018 15:07:25 -0500
Date: Wed, 31 Jan 2018 22:07:22 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hugues FRUCHET <hugues.fruchet@st.com>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: Re: [PATCH] media: ov5640: various typo & style fixes
Message-ID: <20180131200722.5z2noqhd2bwrd2ge@valkosipuli.retiisi.org.uk>
References: <1517397729-12758-1-git-send-email-hugues.fruchet@st.com>
 <20180131142305.6hbdf2xjyn4ay3ij@valkosipuli.retiisi.org.uk>
 <68469dfd-f2d6-88a5-3a71-d731fa4896b2@st.com>
 <cc7708b2-a21d-8e7f-b558-f9e0de7b1baa@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cc7708b2-a21d-8e7f-b558-f9e0de7b1baa@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hugues,

On Wed, Jan 31, 2018 at 03:41:07PM +0000, Hugues FRUCHET wrote:
> Comment added about module_param()
> 
> On 01/31/2018 03:29 PM, Hugues Fruchet wrote:
> > Y're welcome, changes you pointed out are detected by checkpatch 
> > (--strict), see below:
> > 
> > On 01/31/2018 03:23 PM, Sakari Ailus wrote:
> >> Hi Hugues,
> >>
> >> Thanks for the patch. It's nice to see cleanups, too! :-)
> >>
> >> A few comments below. Apart those this seems good to me.
> >>
> >> On Wed, Jan 31, 2018 at 12:22:09PM +0100, Hugues Fruchet wrote:
> >>> Various typo & style fixes either detected by code
> >>> review or checkpatch.
> >>>
> >>> Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
> >>> ---
> >>>   drivers/media/i2c/ov5640.c | 52 
> >>> +++++++++++++++++++++++-----------------------
> >>>   1 file changed, 26 insertions(+), 26 deletions(-)
> >>>
> >>> diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
> >>> index 882a7c3..9cceb5f 100644
> >>> --- a/drivers/media/i2c/ov5640.c
> >>> +++ b/drivers/media/i2c/ov5640.c
> >>> @@ -14,14 +14,14 @@
> >>>   #include <linux/ctype.h>
> >>>   #include <linux/delay.h>
> >>>   #include <linux/device.h>
> >>> +#include <linux/gpio/consumer.h>
> >>>   #include <linux/i2c.h>
> >>>   #include <linux/init.h>
> >>>   #include <linux/module.h>
> >>>   #include <linux/of_device.h>
> >>> +#include <linux/regulator/consumer.h>
> >>>   #include <linux/slab.h>
> >>>   #include <linux/types.h>
> >>> -#include <linux/gpio/consumer.h>
> >>> -#include <linux/regulator/consumer.h>
> >>>   #include <media/v4l2-async.h>
> >>>   #include <media/v4l2-ctrls.h>
> >>>   #include <media/v4l2-device.h>
> >>> @@ -128,7 +128,7 @@ struct ov5640_pixfmt {
> >>>    * to set the MIPI CSI-2 virtual channel.
> >>>    */
> >>>   static unsigned int virtual_channel;
> >>> -module_param(virtual_channel, int, 0);
> >>> +module_param(virtual_channel, int, 0000);
> >>
> >> Why?
> > $ scripts/checkpatch.pl -f drivers/media/i2c/ov5640.c
> > ERROR: Use 4 digit octal (0777) not decimal permissions
> > #131: FILE: drivers/media/i2c/ov5640.c:131:
> > +module_param(virtual_channel, int, 0);
> > 
> > 
> Here I feel that there was a misunderstanding on module_param() last 
> argument treated as initial value (0), in order to fix both 
> initialization to 0 and permission I would suggest:
> 
> static unsigned int virtual_channel = 0;
> module_param(virtual_channel, int, 0644);

Yes, this would actually be better to put in a separate patch. It's a fix,
not a cleanup.

> 
> 
> >>
> >>>   MODULE_PARM_DESC(virtual_channel,
> >>>            "MIPI CSI-2 virtual channel (0..3), default 0");
> >>> @@ -139,7 +139,7 @@ struct ov5640_pixfmt {
> >>>   /* regulator supplies */
> >>>   static const char * const ov5640_supply_name[] = {
> >>> -    "DOVDD", /* Digital I/O (1.8V) suppply */
> >>> +    "DOVDD", /* Digital I/O (1.8V) supply */
> >>>       "DVDD",  /* Digital Core (1.5V) supply */
> >>>       "AVDD",  /* Analog (2.8V) supply */
> >>>   };
> >>> @@ -245,7 +245,6 @@ static inline struct v4l2_subdev 
> >>> *ctrl_to_sd(struct v4l2_ctrl *ctrl)
> >>>    */
> >>>   static const struct reg_value ov5640_init_setting_30fps_VGA[] = {
> >>> -
> >>>       {0x3103, 0x11, 0, 0}, {0x3008, 0x82, 0, 5}, {0x3008, 0x42, 0, 0},
> >>>       {0x3103, 0x03, 0, 0}, {0x3017, 0x00, 0, 0}, {0x3018, 0x00, 0, 0},
> >>>       {0x3034, 0x18, 0, 0}, {0x3035, 0x14, 0, 0}, {0x3036, 0x38, 0, 0},
> >>> @@ -334,7 +333,6 @@ static inline struct v4l2_subdev 
> >>> *ctrl_to_sd(struct v4l2_ctrl *ctrl)
> >>>   };
> >>>   static const struct reg_value ov5640_setting_30fps_VGA_640_480[] = {
> >>> -
> >>>       {0x3035, 0x14, 0, 0}, {0x3036, 0x38, 0, 0}, {0x3c07, 0x08, 0, 0},
> >>>       {0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
> >>>       {0x3820, 0x41, 0, 0}, {0x3821, 0x07, 0, 0}, {0x3814, 0x31, 0, 0},
> >>> @@ -377,7 +375,6 @@ static inline struct v4l2_subdev 
> >>> *ctrl_to_sd(struct v4l2_ctrl *ctrl)
> >>>   };
> >>>   static const struct reg_value ov5640_setting_30fps_XGA_1024_768[] = {
> >>> -
> >>>       {0x3035, 0x14, 0, 0}, {0x3036, 0x38, 0, 0}, {0x3c07, 0x08, 0, 0},
> >>>       {0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
> >>>       {0x3820, 0x41, 0, 0}, {0x3821, 0x07, 0, 0}, {0x3814, 0x31, 0, 0},
> >>> @@ -484,6 +481,7 @@ static inline struct v4l2_subdev 
> >>> *ctrl_to_sd(struct v4l2_ctrl *ctrl)
> >>>       {0x4407, 0x04, 0, 0}, {0x460b, 0x35, 0, 0}, {0x460c, 0x22, 0, 0},
> >>>       {0x3824, 0x02, 0, 0}, {0x5001, 0xa3, 0, 0},
> >>>   };
> >>> +
> >>>   static const struct reg_value ov5640_setting_15fps_QCIF_176_144[] = {
> >>>       {0x3035, 0x22, 0, 0}, {0x3036, 0x38, 0, 0}, {0x3c07, 0x08, 0, 0},
> >>>       {0x3c09, 0x1c, 0, 0}, {0x3c0a, 0x9c, 0, 0}, {0x3c0b, 0x40, 0, 0},
> >>> @@ -840,7 +838,7 @@ static int ov5640_write_reg(struct ov5640_dev 
> >>> *sensor, u16 reg, u8 val)
> >>>       ret = i2c_transfer(client->adapter, &msg, 1);
> >>>       if (ret < 0) {
> >>>           v4l2_err(&sensor->sd, "%s: error: reg=%x, val=%x\n",
> >>> -            __func__, reg, val);
> >>> +             __func__, reg, val);
> >>>           return ret;
> >>>       }
> >>> @@ -886,7 +884,7 @@ static int ov5640_read_reg16(struct ov5640_dev 
> >>> *sensor, u16 reg, u16 *val)
> >>>       ret = ov5640_read_reg(sensor, reg, &hi);
> >>>       if (ret)
> >>>           return ret;
> >>> -    ret = ov5640_read_reg(sensor, reg+1, &lo);
> >>> +    ret = ov5640_read_reg(sensor, reg + 1, &lo);
> >>>       if (ret)
> >>>           return ret;
> >>> @@ -947,7 +945,7 @@ static int ov5640_load_regs(struct ov5640_dev 
> >>> *sensor,
> >>>               break;
> >>>           if (delay_ms)
> >>> -            usleep_range(1000*delay_ms, 1000*delay_ms+100);
> >>> +            usleep_range(1000 * delay_ms, 1000 * delay_ms + 100);
> >>>       }
> >>>       return ret;
> >>> @@ -1289,7 +1287,6 @@ static int ov5640_set_bandingfilter(struct 
> >>> ov5640_dev *sensor)
> >>>           return ret;
> >>>       prev_vts = ret;
> >>> -
> >>>       /* calculate banding filter */
> >>>       /* 60Hz */
> >>>       band_step60 = sensor->prev_sysclk * 100 / sensor->prev_hts * 
> >>> 100 / 120;
> >>> @@ -1405,8 +1402,8 @@ static int ov5640_set_virtual_channel(struct 
> >>> ov5640_dev *sensor)
> >>>    * sensor changes between scaling and subsampling, go through
> >>>    * exposure calculation
> >>>    */
> >>> -static int ov5640_set_mode_exposure_calc(
> >>> -    struct ov5640_dev *sensor, const struct ov5640_mode_info *mode)
> >>> +static int ov5640_set_mode_exposure_calc(struct ov5640_dev *sensor,
> >>> +                     const struct ov5640_mode_info *mode)
> >>>   {
> >>>       u32 prev_shutter, prev_gain16;
> >>>       u32 cap_shutter, cap_gain16;
> >>> @@ -1416,7 +1413,7 @@ static int ov5640_set_mode_exposure_calc(
> >>>       u8 average;
> >>>       int ret;
> >>> -    if (mode->reg_data == NULL)
> >>> +    if (!mode->reg_data)
> >>>           return -EINVAL;
> >>>       /* read preview shutter */
> >>> @@ -1570,7 +1567,7 @@ static int ov5640_set_mode_direct(struct 
> >>> ov5640_dev *sensor,
> >>>   {
> >>>       int ret;
> >>> -    if (mode->reg_data == NULL)
> >>> +    if (!mode->reg_data)
> >>>           return -EINVAL;
> >>>       /* Write capture setting */
> >>> @@ -2117,7 +2114,8 @@ static int ov5640_set_ctrl_gain(struct 
> >>> ov5640_dev *sensor, int auto_gain)
> >>>       if (ctrls->auto_gain->is_new) {
> >>>           ret = ov5640_mod_reg(sensor, OV5640_REG_AEC_PK_MANUAL,
> >>> -                     BIT(1), ctrls->auto_gain->val ? 0 : BIT(1));
> >>> +                     BIT(1),
> >>> +                     ctrls->auto_gain->val ? 0 : BIT(1));
> >>>           if (ret)
> >>>               return ret;
> >>>       }
> >>> @@ -2297,18 +2295,20 @@ static int ov5640_enum_frame_size(struct 
> >>> v4l2_subdev *sd,
> >>>       if (fse->index >= OV5640_NUM_MODES)
> >>>           return -EINVAL;
> >>> -    fse->min_width = fse->max_width =
> >>> +    fse->min_width =
> >>>           ov5640_mode_data[0][fse->index].width;
> >>> -    fse->min_height = fse->max_height =
> >>> +    fse->max_width = fse->min_width;
> >>> +    fse->min_height =
> >>>           ov5640_mode_data[0][fse->index].height;
> >>> +    fse->max_height = fse->min_height;
> >>>       return 0;
> >>>   }
> >>> -static int ov5640_enum_frame_interval(
> >>> -    struct v4l2_subdev *sd,
> >>> -    struct v4l2_subdev_pad_config *cfg,
> >>> -    struct v4l2_subdev_frame_interval_enum *fie)
> > CHECK: Lines should not end with a '('
> > #2309: FILE: drivers/media/i2c/ov5640.c:2309:
> > +static int ov5640_enum_frame_interval(

Fair enough. The result still looks distinctly odd, I don't remember seeing
that anywhere whilst it's not uncommon to wrap a line right after an
opening parenthesis. Sometimes that's an only reasonable option to wrap
long lines.

How about dropping the two changes?

> > 
> >>> +static int ov5640_enum_frame_interval
> >>> +                (struct v4l2_subdev *sd,
> >>> +                 struct v4l2_subdev_pad_config *cfg,
> >>> +                 struct v4l2_subdev_frame_interval_enum *fie)
> > 
> >>>   {
> >>>       struct ov5640_dev *sensor = to_ov5640_dev(sd);
> >>>       struct v4l2_fract tpf;
> >>> @@ -2376,8 +2376,8 @@ static int ov5640_s_frame_interval(struct 
> >>> v4l2_subdev *sd,
> >>>   }
> >>>   static int ov5640_enum_mbus_code(struct v4l2_subdev *sd,
> >>> -                  struct v4l2_subdev_pad_config *cfg,
> >>> -                  struct v4l2_subdev_mbus_code_enum *code)
> >>> +                 struct v4l2_subdev_pad_config *cfg,
> >>> +                 struct v4l2_subdev_mbus_code_enum *code)
> >>>   {
> >>>       if (code->pad != 0)
> >>>           return -EINVAL;
> >>> @@ -2509,8 +2509,8 @@ static int ov5640_probe(struct i2c_client *client,
> >>>       sensor->ae_target = 52;
> >>> -    endpoint = fwnode_graph_get_next_endpoint(
> >>> -        of_fwnode_handle(client->dev.of_node), NULL);
> >>> +    endpoint = fwnode_graph_get_next_endpoint
> >>> +        (of_fwnode_handle(client->dev.of_node), NULL);
> >>
> >> Hmm. This looks weird to me. Isn't the change rather against the common
> >> practices? The same on ov5640_enum_frame_interval prototype change.
> >>
> > CHECK: Lines should not end with a '('
> > #2513: FILE: drivers/media/i2c/ov5640.c:2513:
> > +    endpoint = fwnode_graph_get_next_endpoint(
> > 
> > 
> >>>       if (!endpoint) {
> >>>           dev_err(dev, "endpoint node not found\n");
> >>>           return -EINVAL;
> >>

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
