Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:4436 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858Ab3HNGOu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Aug 2013 02:14:50 -0400
Message-ID: <520B201F.9040207@xs4all.nl>
Date: Wed, 14 Aug 2013 08:13:51 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
CC: linux-media <linux-media@vger.kernel.org>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	uclinux-dist-devel@blackfin.uclinux.org,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH 1/3] adv7842: add new video decoder driver.
References: <1376313239-19921-1-git-send-email-hverkuil@xs4all.nl> <1376313239-19921-2-git-send-email-hverkuil@xs4all.nl> <CA+V-a8tyNUQiO2b-jgupUZM3QX2rGzr3=z21Ukk3bUrNDUvapQ@mail.gmail.com>
In-Reply-To: <CA+V-a8tyNUQiO2b-jgupUZM3QX2rGzr3=z21Ukk3bUrNDUvapQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/14/2013 05:10 AM, Prabhakar Lad wrote:
> Hi Hans,
> 
> Thanks for the patch. Few nits below.
> 
> On Mon, Aug 12, 2013 at 6:43 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>  drivers/media/i2c/Kconfig   |   12 +
>>  drivers/media/i2c/Makefile  |    1 +
>>  drivers/media/i2c/adv7842.c | 3022 +++++++++++++++++++++++++++++++++++++++++++
>>  include/media/adv7842.h     |  226 ++++
>>  4 files changed, 3261 insertions(+)
>>  create mode 100644 drivers/media/i2c/adv7842.c
>>  create mode 100644 include/media/adv7842.h
>>
>> diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
>> index b2cd8ca..847b711 100644
>> --- a/drivers/media/i2c/Kconfig
>> +++ b/drivers/media/i2c/Kconfig
>> @@ -206,6 +206,18 @@ config VIDEO_ADV7604
>>           To compile this driver as a module, choose M here: the
>>           module will be called adv7604.
>>
>> +config VIDEO_ADV7842
>> +       tristate "Analog Devices ADV7842 decoder"
>> +       depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
>> +       ---help---
>> +         Support for the Analog Devices ADV7842 video decoder.
>> +
>> +         This is a Analog Devices Component/Graphics/SD Digitizer
>> +         with 2:1 Multiplexed HDMI Receiver.
>> +
>> +         To compile this driver as a module, choose M here: the
>> +         module will be called adv7842.
>> +
>>  config VIDEO_BT819
>>         tristate "BT819A VideoStream decoder"
>>         depends on VIDEO_V4L2 && I2C
>> diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
>> index dc20653..b4cf972 100644
>> --- a/drivers/media/i2c/Makefile
>> +++ b/drivers/media/i2c/Makefile
>> @@ -26,6 +26,7 @@ obj-$(CONFIG_VIDEO_ADV7183) += adv7183.o
>>  obj-$(CONFIG_VIDEO_ADV7343) += adv7343.o
>>  obj-$(CONFIG_VIDEO_ADV7393) += adv7393.o
>>  obj-$(CONFIG_VIDEO_ADV7604) += adv7604.o
>> +obj-$(CONFIG_VIDEO_ADV7842) += adv7842.o
>>  obj-$(CONFIG_VIDEO_AD9389B) += ad9389b.o
>>  obj-$(CONFIG_VIDEO_VPX3220) += vpx3220.o
>>  obj-$(CONFIG_VIDEO_VS6624)  += vs6624.o
>> diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
>> new file mode 100644
>> index 0000000..84c9a83
>> --- /dev/null
>> +++ b/drivers/media/i2c/adv7842.c
>> @@ -0,0 +1,3022 @@
>> +/*
>> + * adv7842 - Analog Devices ADV7842 video decoder driver
>> + *
>> + * Copyright 2013 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
>> + *
>> + * This program is free software; you may redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; version 2 of the License.
>> + *
>> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
>> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
>> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
>> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
>> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
>> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
>> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
>> + * SOFTWARE.
>> + *
>> + */
>> +
>> +/*
>> + * References (c = chapter, p = page):
>> + * REF_01 - Analog devices, ADV7842, Register Settings Recommendations,
>> + *             Revision 2.5, June 2010
>> + * REF_02 - Analog devices, Register map documentation, Documentation of
>> + *             the register maps, Software manual, Rev. F, June 2010
>> + */
>> +
>> +
>> +#include <linux/kernel.h>
>> +#include <linux/module.h>
>> +#include <linux/slab.h>
>> +#include <linux/i2c.h>
>> +#include <linux/delay.h>
>> +#include <linux/videodev2.h>
>> +#include <linux/workqueue.h>
>> +#include <linux/v4l2-dv-timings.h>
>> +#include <media/v4l2-device.h>
>> +#include <media/v4l2-ctrls.h>
>> +#include <media/adv7842.h>
>> +
>> +static int debug;
>> +module_param(debug, int, 0644);
>> +MODULE_PARM_DESC(debug, "debug level (0-2)");
>> +
>> +MODULE_DESCRIPTION("Analog Devices ADV7842 video decoder driver");
>> +MODULE_AUTHOR("Hans Verkuil <hans.verkuil@cisco.com>");
>> +MODULE_AUTHOR("Martin Bugge <marbugge@cisco.com>");
>> +MODULE_LICENSE("GPL");
>> +
>> +/* ADV7842 system clock frequency */
>> +#define ADV7842_fsc (28636360)
>> +
>> +/*
>> +**********************************************************************
>> +*
>> +*  Arrays with configuration parameters for the ADV7842
>> +*
>> +**********************************************************************
>> +*/
>> +
>> +struct adv7842_state {
>> +       struct v4l2_subdev sd;
>> +       struct media_pad pad;
>> +       struct v4l2_ctrl_handler hdl;
>> +       enum adv7842_mode mode;
>> +       struct v4l2_dv_timings timings;
>> +       enum adv7842_vid_std_select vid_std_select;
>> +       v4l2_std_id norm;
>> +       struct {
>> +               u8 edid[256];
>> +               u32 present;
>> +       } hdmi_edid;
>> +       struct {
>> +               u8 edid[256];
>> +               u32 present;
>> +       } vga_edid;
>> +       struct v4l2_fract aspect_ratio;
>> +       u32 rgb_quantization_range;
>> +       bool is_cea_format;
>> +       struct workqueue_struct *work_queues;
>> +       struct delayed_work delayed_work_enable_hotplug;
>> +       bool connector_hdmi;
>> +       bool hdmi_port_a;
>> +
>> +       /* i2c clients */
>> +       struct i2c_client *i2c_sdp_io;
>> +       struct i2c_client *i2c_sdp;
>> +       struct i2c_client *i2c_cp;
>> +       struct i2c_client *i2c_vdp;
>> +       struct i2c_client *i2c_afe;
>> +       struct i2c_client *i2c_hdmi;
>> +       struct i2c_client *i2c_repeater;
>> +       struct i2c_client *i2c_edid;
>> +       struct i2c_client *i2c_infoframe;
>> +       struct i2c_client *i2c_cec;
>> +       struct i2c_client *i2c_avlink;
>> +
>> +       /* controls */
>> +       struct v4l2_ctrl *detect_tx_5v_ctrl;
>> +       struct v4l2_ctrl *analog_sampling_phase_ctrl;
>> +       struct v4l2_ctrl *free_run_color_ctrl_manual;
>> +       struct v4l2_ctrl *free_run_color_ctrl;
>> +       struct v4l2_ctrl *rgb_quantization_range_ctrl;
>> +};
>> +
>> +/* Supported CEA and DMT timings */
>> +static const struct v4l2_dv_timings adv7842_timings[] = {
>> +       V4L2_DV_BT_CEA_720X480P59_94,
>> +       V4L2_DV_BT_CEA_720X576P50,
>> +       V4L2_DV_BT_CEA_1280X720P24,
>> +       V4L2_DV_BT_CEA_1280X720P25,
>> +       V4L2_DV_BT_CEA_1280X720P50,
>> +       V4L2_DV_BT_CEA_1280X720P60,
>> +       V4L2_DV_BT_CEA_1920X1080P24,
>> +       V4L2_DV_BT_CEA_1920X1080P25,
>> +       V4L2_DV_BT_CEA_1920X1080P30,
>> +       V4L2_DV_BT_CEA_1920X1080P50,
>> +       V4L2_DV_BT_CEA_1920X1080P60,
>> +
>> +       /* sorted by DMT ID */
>> +       V4L2_DV_BT_DMT_640X350P85,
>> +       V4L2_DV_BT_DMT_640X400P85,
>> +       V4L2_DV_BT_DMT_720X400P85,
>> +       V4L2_DV_BT_DMT_640X480P60,
>> +       V4L2_DV_BT_DMT_640X480P72,
>> +       V4L2_DV_BT_DMT_640X480P75,
>> +       V4L2_DV_BT_DMT_640X480P85,
>> +       V4L2_DV_BT_DMT_800X600P56,
>> +       V4L2_DV_BT_DMT_800X600P60,
>> +       V4L2_DV_BT_DMT_800X600P72,
>> +       V4L2_DV_BT_DMT_800X600P75,
>> +       V4L2_DV_BT_DMT_800X600P85,
>> +       V4L2_DV_BT_DMT_848X480P60,
>> +       V4L2_DV_BT_DMT_1024X768P60,
>> +       V4L2_DV_BT_DMT_1024X768P70,
>> +       V4L2_DV_BT_DMT_1024X768P75,
>> +       V4L2_DV_BT_DMT_1024X768P85,
>> +       V4L2_DV_BT_DMT_1152X864P75,
>> +       V4L2_DV_BT_DMT_1280X768P60_RB,
>> +       V4L2_DV_BT_DMT_1280X768P60,
>> +       V4L2_DV_BT_DMT_1280X768P75,
>> +       V4L2_DV_BT_DMT_1280X768P85,
>> +       V4L2_DV_BT_DMT_1280X800P60_RB,
>> +       V4L2_DV_BT_DMT_1280X800P60,
>> +       V4L2_DV_BT_DMT_1280X800P75,
>> +       V4L2_DV_BT_DMT_1280X800P85,
>> +       V4L2_DV_BT_DMT_1280X960P60,
>> +       V4L2_DV_BT_DMT_1280X960P85,
>> +       V4L2_DV_BT_DMT_1280X1024P60,
>> +       V4L2_DV_BT_DMT_1280X1024P75,
>> +       V4L2_DV_BT_DMT_1280X1024P85,
>> +       V4L2_DV_BT_DMT_1360X768P60,
>> +       V4L2_DV_BT_DMT_1400X1050P60_RB,
>> +       V4L2_DV_BT_DMT_1400X1050P60,
>> +       V4L2_DV_BT_DMT_1400X1050P75,
>> +       V4L2_DV_BT_DMT_1400X1050P85,
>> +       V4L2_DV_BT_DMT_1440X900P60_RB,
>> +       V4L2_DV_BT_DMT_1440X900P60,
>> +       V4L2_DV_BT_DMT_1600X1200P60,
>> +       V4L2_DV_BT_DMT_1680X1050P60_RB,
>> +       V4L2_DV_BT_DMT_1680X1050P60,
>> +       V4L2_DV_BT_DMT_1792X1344P60,
>> +       V4L2_DV_BT_DMT_1856X1392P60,
>> +       V4L2_DV_BT_DMT_1920X1200P60_RB,
>> +       V4L2_DV_BT_DMT_1366X768P60,
>> +       V4L2_DV_BT_DMT_1920X1080P60,
>> +       { },
>> +};
>> +
> why not use the dv_timings helpers ?

I'm planning to once the helpers are merged.

> 
>> +struct adv7842_video_standards {
>> +       struct v4l2_dv_timings timings;
>> +       u8 vid_std;
>> +       u8 v_freq;
>> +};
>> +
>> +/* sorted by number of lines */
>> +static const struct adv7842_video_standards adv7842_prim_mode_comp[] = {
>> +       /* { V4L2_DV_BT_CEA_720X480P59_94, 0x0a, 0x00 }, TODO flickering */
>> +       { V4L2_DV_BT_CEA_720X576P50, 0x0b, 0x00 },
>> +       { V4L2_DV_BT_CEA_1280X720P50, 0x19, 0x01 },
>> +       { V4L2_DV_BT_CEA_1280X720P60, 0x19, 0x00 },
>> +       { V4L2_DV_BT_CEA_1920X1080P24, 0x1e, 0x04 },
>> +       { V4L2_DV_BT_CEA_1920X1080P25, 0x1e, 0x03 },
>> +       { V4L2_DV_BT_CEA_1920X1080P30, 0x1e, 0x02 },
>> +       { V4L2_DV_BT_CEA_1920X1080P50, 0x1e, 0x01 },
>> +       { V4L2_DV_BT_CEA_1920X1080P60, 0x1e, 0x00 },
>> +       /* TODO add 1920x1080P60_RB (CVT timing) */
>> +       { },
>> +};
>> +
>> +/* sorted by number of lines */
>> +static const struct adv7842_video_standards adv7842_prim_mode_gr[] = {
>> +       { V4L2_DV_BT_DMT_640X480P60, 0x08, 0x00 },
>> +       { V4L2_DV_BT_DMT_640X480P72, 0x09, 0x00 },
>> +       { V4L2_DV_BT_DMT_640X480P75, 0x0a, 0x00 },
>> +       { V4L2_DV_BT_DMT_640X480P85, 0x0b, 0x00 },
>> +       { V4L2_DV_BT_DMT_800X600P56, 0x00, 0x00 },
>> +       { V4L2_DV_BT_DMT_800X600P60, 0x01, 0x00 },
>> +       { V4L2_DV_BT_DMT_800X600P72, 0x02, 0x00 },
>> +       { V4L2_DV_BT_DMT_800X600P75, 0x03, 0x00 },
>> +       { V4L2_DV_BT_DMT_800X600P85, 0x04, 0x00 },
>> +       { V4L2_DV_BT_DMT_1024X768P60, 0x0c, 0x00 },
>> +       { V4L2_DV_BT_DMT_1024X768P70, 0x0d, 0x00 },
>> +       { V4L2_DV_BT_DMT_1024X768P75, 0x0e, 0x00 },
>> +       { V4L2_DV_BT_DMT_1024X768P85, 0x0f, 0x00 },
>> +       { V4L2_DV_BT_DMT_1280X1024P60, 0x05, 0x00 },
>> +       { V4L2_DV_BT_DMT_1280X1024P75, 0x06, 0x00 },
>> +       { V4L2_DV_BT_DMT_1360X768P60, 0x12, 0x00 },
>> +       { V4L2_DV_BT_DMT_1366X768P60, 0x13, 0x00 },
>> +       { V4L2_DV_BT_DMT_1400X1050P60, 0x14, 0x00 },
>> +       { V4L2_DV_BT_DMT_1400X1050P75, 0x15, 0x00 },
>> +       { V4L2_DV_BT_DMT_1600X1200P60, 0x16, 0x00 }, /* TODO not tested */
>> +       /* TODO add 1600X1200P60_RB (not a DMT timing) */
>> +       { V4L2_DV_BT_DMT_1680X1050P60, 0x18, 0x00 },
>> +       { V4L2_DV_BT_DMT_1920X1200P60_RB, 0x19, 0x00 }, /* TODO not tested */
>> +       { },
>> +};
>> +
>> +/* sorted by number of lines */
>> +static const struct adv7842_video_standards adv7842_prim_mode_hdmi_comp[] = {
>> +       { V4L2_DV_BT_CEA_720X480P59_94, 0x0a, 0x00 },
>> +       { V4L2_DV_BT_CEA_720X576P50, 0x0b, 0x00 },
>> +       { V4L2_DV_BT_CEA_1280X720P50, 0x13, 0x01 },
>> +       { V4L2_DV_BT_CEA_1280X720P60, 0x13, 0x00 },
>> +       { V4L2_DV_BT_CEA_1920X1080P24, 0x1e, 0x04 },
>> +       { V4L2_DV_BT_CEA_1920X1080P25, 0x1e, 0x03 },
>> +       { V4L2_DV_BT_CEA_1920X1080P30, 0x1e, 0x02 },
>> +       { V4L2_DV_BT_CEA_1920X1080P50, 0x1e, 0x01 },
>> +       { V4L2_DV_BT_CEA_1920X1080P60, 0x1e, 0x00 },
>> +       { },
>> +};
>> +
>> +/* sorted by number of lines */
>> +static const struct adv7842_video_standards adv7842_prim_mode_hdmi_gr[] = {
>> +       { V4L2_DV_BT_DMT_640X480P60, 0x08, 0x00 },
>> +       { V4L2_DV_BT_DMT_640X480P72, 0x09, 0x00 },
>> +       { V4L2_DV_BT_DMT_640X480P75, 0x0a, 0x00 },
>> +       { V4L2_DV_BT_DMT_640X480P85, 0x0b, 0x00 },
>> +       { V4L2_DV_BT_DMT_800X600P56, 0x00, 0x00 },
>> +       { V4L2_DV_BT_DMT_800X600P60, 0x01, 0x00 },
>> +       { V4L2_DV_BT_DMT_800X600P72, 0x02, 0x00 },
>> +       { V4L2_DV_BT_DMT_800X600P75, 0x03, 0x00 },
>> +       { V4L2_DV_BT_DMT_800X600P85, 0x04, 0x00 },
>> +       { V4L2_DV_BT_DMT_1024X768P60, 0x0c, 0x00 },
>> +       { V4L2_DV_BT_DMT_1024X768P70, 0x0d, 0x00 },
>> +       { V4L2_DV_BT_DMT_1024X768P75, 0x0e, 0x00 },
>> +       { V4L2_DV_BT_DMT_1024X768P85, 0x0f, 0x00 },
>> +       { V4L2_DV_BT_DMT_1280X1024P60, 0x05, 0x00 },
>> +       { V4L2_DV_BT_DMT_1280X1024P75, 0x06, 0x00 },
>> +       { },
>> +};
>> +
>> +/* ----------------------------------------------------------------------- */
>> +
>> +static inline struct adv7842_state *to_state(struct v4l2_subdev *sd)
>> +{
>> +       return container_of(sd, struct adv7842_state, sd);
>> +}
>> +
>> +static inline struct v4l2_subdev *to_sd(struct v4l2_ctrl *ctrl)
>> +{
>> +       return &container_of(ctrl->handler, struct adv7842_state, hdl)->sd;
>> +}
>> +
>> +static inline unsigned hblanking(const struct v4l2_bt_timings *t)
>> +{
>> +       return t->hfrontporch + t->hsync + t->hbackporch;
>> +}
>> +
>> +static inline unsigned htotal(const struct v4l2_bt_timings *t)
>> +{
>> +       return t->width + t->hfrontporch + t->hsync + t->hbackporch;
>> +}
>> +
>> +static inline unsigned vblanking(const struct v4l2_bt_timings *t)
>> +{
>> +       return t->vfrontporch + t->vsync + t->vbackporch;
>> +}
>> +
>> +static inline unsigned vtotal(const struct v4l2_bt_timings *t)
>> +{
>> +       return t->height + t->vfrontporch + t->vsync + t->vbackporch;
>> +}
>> +
> 
> Replacing the above with V4L2_DV_BT_BLANKING/FRAME defines ?

Ditto, waiting for that to be merged first.

> 
> 

<snip>

>> +static int adv7842_probe(struct i2c_client *client,
>> +                        const struct i2c_device_id *id)
>> +{
>> +       struct adv7842_state *state;
>> +       struct adv7842_platform_data *pdata = client->dev.platform_data;
>> +       struct v4l2_ctrl_handler *hdl;
>> +       struct v4l2_subdev *sd;
>> +       u16 rev;
>> +       int err;
>> +
>> +       /* Check if the adapter supports the needed features */
>> +       if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA))
>> +               return -EIO;
>> +
>> +       v4l_dbg(1, debug, client, "detecting adv7842 client on address 0x%x\n",
>> +               client->addr << 1);
>> +
>> +       if (!pdata) {
>> +               v4l_err(client, "No platform data!\n");
>> +               return -ENODEV;
>> +       }
>> +
>> +       state = kzalloc(sizeof(struct adv7842_state), GFP_KERNEL);
> devm*() instead ?

Good point. Will do.

> 
>> +       if (!state) {
>> +               v4l_err(client, "Could not allocate adv7842_state memory!\n");
>> +               return -ENOMEM;
>> +       }
>> +
>> +       sd = &state->sd;
>> +       v4l2_i2c_subdev_init(sd, client, &adv7842_ops);
>> +       sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
>> +       state->connector_hdmi = pdata->connector_hdmi;
>> +       state->mode = pdata->mode;
>> +
>> +       state->hdmi_port_a = true;
>> +
>> +       /* i2c access to adv7842? */
>> +       rev = adv_smbus_read_byte_data_check(client, 0xea, false) << 8 |
>> +               adv_smbus_read_byte_data_check(client, 0xeb, false);
>> +       if (rev != 0x2012) {
>> +               v4l2_info(sd, "got rev=0x%04x on first read attempt\n", rev);
>> +               rev = adv_smbus_read_byte_data_check(client, 0xea, false) << 8 |
>> +                       adv_smbus_read_byte_data_check(client, 0xeb, false);
>> +       }
>> +       if (rev != 0x2012) {
>> +               v4l2_info(sd, "not an adv7842 on address 0x%x (rev=0x%04x)\n",
>> +                         client->addr << 1, rev);
>> +               err = -ENODEV;
>> +               goto err_state;
>> +       }
>> +
>> +       if (pdata->chip_reset)
>> +               main_reset(sd);
>> +
>> +       /* control handlers */
>> +       hdl = &state->hdl;
>> +       v4l2_ctrl_handler_init(hdl, 6);
>> +
>> +       /* add in ascending ID order */
>> +       v4l2_ctrl_new_std(hdl, &adv7842_ctrl_ops,
>> +                         V4L2_CID_BRIGHTNESS, -128, 127, 1, 0);
>> +       v4l2_ctrl_new_std(hdl, &adv7842_ctrl_ops,
>> +                         V4L2_CID_CONTRAST, 0, 255, 1, 128);
>> +       v4l2_ctrl_new_std(hdl, &adv7842_ctrl_ops,
>> +                         V4L2_CID_SATURATION, 0, 255, 1, 128);
>> +       v4l2_ctrl_new_std(hdl, &adv7842_ctrl_ops,
>> +                         V4L2_CID_HUE, 0, 128, 1, 0);
>> +
>> +       /* custom controls */
>> +       state->detect_tx_5v_ctrl = v4l2_ctrl_new_std(hdl, NULL,
>> +                       V4L2_CID_DV_RX_POWER_PRESENT, 0, 3, 0, 0);
>> +       state->analog_sampling_phase_ctrl = v4l2_ctrl_new_custom(hdl,
>> +                       &adv7842_ctrl_analog_sampling_phase, NULL);
>> +       state->free_run_color_ctrl_manual = v4l2_ctrl_new_custom(hdl,
>> +                       &adv7842_ctrl_free_run_color_manual, NULL);
>> +       state->free_run_color_ctrl = v4l2_ctrl_new_custom(hdl,
>> +                       &adv7842_ctrl_free_run_color, NULL);
>> +       state->rgb_quantization_range_ctrl =
>> +               v4l2_ctrl_new_std_menu(hdl, &adv7842_ctrl_ops,
>> +                       V4L2_CID_DV_RX_RGB_RANGE, V4L2_DV_RGB_RANGE_FULL,
>> +                       0, V4L2_DV_RGB_RANGE_AUTO);
>> +       sd->ctrl_handler = hdl;
>> +       if (hdl->error) {
>> +               err = hdl->error;
>> +               goto err_hdl;
>> +       }
>> +
>> +       if (adv7842_s_detect_tx_5v_ctrl(sd)) {
>> +               err = -ENODEV;
>> +               goto err_hdl;
>> +       }
>> +
>> +       state->i2c_avlink = adv7842_dummy_client(sd, pdata->i2c_avlink, 0xf3);
>> +       state->i2c_cec = adv7842_dummy_client(sd, pdata->i2c_cec, 0xf4);
>> +       state->i2c_infoframe = adv7842_dummy_client(sd, pdata->i2c_infoframe, 0xf5);
>> +       state->i2c_sdp_io = adv7842_dummy_client(sd, pdata->i2c_sdp_io, 0xf2);
>> +       state->i2c_sdp = adv7842_dummy_client(sd, pdata->i2c_sdp, 0xf1);
>> +       state->i2c_afe = adv7842_dummy_client(sd, pdata->i2c_afe, 0xf8);
>> +       state->i2c_repeater = adv7842_dummy_client(sd, pdata->i2c_repeater, 0xf9);
>> +       state->i2c_edid = adv7842_dummy_client(sd, pdata->i2c_edid, 0xfa);
>> +       state->i2c_hdmi = adv7842_dummy_client(sd, pdata->i2c_hdmi, 0xfb);
>> +       state->i2c_cp = adv7842_dummy_client(sd, pdata->i2c_cp, 0xfd);
>> +       state->i2c_vdp = adv7842_dummy_client(sd, pdata->i2c_vdp, 0xfe);
>> +       if (!state->i2c_avlink || !state->i2c_cec || !state->i2c_infoframe ||
>> +           !state->i2c_sdp_io || !state->i2c_sdp || !state->i2c_afe ||
>> +           !state->i2c_repeater || !state->i2c_edid || !state->i2c_hdmi ||
>> +           !state->i2c_cp || !state->i2c_vdp) {
>> +               err = -ENOMEM;
>> +               v4l2_err(sd, "failed to create all i2c clients\n");
>> +               goto err_i2c;
>> +       }
>> +
>> +       /* work queues */
>> +       state->work_queues = create_singlethread_workqueue(client->name);
>> +       if (!state->work_queues) {
>> +               v4l2_err(sd, "Could not create work queue\n");
>> +               err = -ENOMEM;
>> +               goto err_i2c;
>> +       }
>> +
>> +       INIT_DELAYED_WORK(&state->delayed_work_enable_hotplug,
>> +                       adv7842_delayed_work_enable_hotplug);
>> +
>> +       state->pad.flags = MEDIA_PAD_FL_SOURCE;
>> +       err = media_entity_init(&sd->entity, 1, &state->pad, 0);
>> +       if (err)
>> +               goto err_work_queues;
>> +
>> +       err = adv7842_core_init(sd, pdata);
>> +       if (err)
>> +               goto err_entity;
>> +
>> +       v4l2_info(sd, "%s found @ 0x%x (%s)\n", client->name,
>> +                 client->addr << 1, client->adapter->name);
>> +       return 0;
>> +
>> +err_entity:
>> +       media_entity_cleanup(&sd->entity);
>> +err_work_queues:
>> +       cancel_delayed_work(&state->delayed_work_enable_hotplug);
>> +       destroy_workqueue(state->work_queues);
>> +err_i2c:
>> +       adv7842_unregister_clients(state);
>> +err_hdl:
>> +       v4l2_ctrl_handler_free(hdl);
>> +err_state:
>> +       kfree(state);
>> +       return err;
>> +}
>> +
>> +/* ----------------------------------------------------------------------- */
>> +
>> +static int adv7842_remove(struct i2c_client *client)
>> +{
>> +       struct v4l2_subdev *sd = i2c_get_clientdata(client);
>> +       struct adv7842_state *state = to_state(sd);
>> +
>> +       adv7842_irq_enable(sd, false);
>> +
>> +       cancel_delayed_work(&state->delayed_work_enable_hotplug);
>> +       destroy_workqueue(state->work_queues);
>> +       v4l2_device_unregister_subdev(sd);
>> +       media_entity_cleanup(&sd->entity);
>> +       adv7842_unregister_clients(to_state(sd));
>> +       v4l2_ctrl_handler_free(sd->ctrl_handler);
>> +       kfree(to_state(sd));
>> +       return 0;
>> +}
>> +
>> +/* ----------------------------------------------------------------------- */
>> +
>> +static struct i2c_device_id adv7842_id[] = {
>> +       { "adv7842", 0 },
>> +       { }
>> +};
>> +MODULE_DEVICE_TABLE(i2c, adv7842_id);
>> +
>> +/* ----------------------------------------------------------------------- */
>> +
>> +static struct i2c_driver adv7842_driver = {
>> +       .driver = {
>> +               .owner = THIS_MODULE,
>> +               .name = "adv7842",
>> +       },
>> +       .probe = adv7842_probe,
>> +       .remove = adv7842_remove,
>> +       .id_table = adv7842_id,
>> +};
>> +
>> +module_i2c_driver(adv7842_driver);

Thanks!

	Hans

