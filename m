Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:35365 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756528AbdGCOpj (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Jul 2017 10:45:39 -0400
Subject: Re: [PATCH v6 2/3] media: i2c: adv748x: add adv748x driver
To: Hans Verkuil <hverkuil@xs4all.nl>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, niklas.soderlund@ragnatech.se,
        hans.verkuil@cisco.com,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Pavel Machek <pavel@ucw.cz>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Todor Tomov <todor.tomov@linaro.org>,
        Hyungwoo Yang <hyungwoo.yang@intel.com>
References: <cover.13d48bb2ba66a5e11c962c62b1a7b5832b0a2344.1498575029.git-series.kieran.bingham+renesas@ideasonboard.com>
 <4c528c1a666f6e9bc8550f70b7c9d84d3c013178.1498575029.git-series.kieran.bingham+renesas@ideasonboard.com>
 <2b6688cb-3e73-815d-e23f-6c44c2e793af@xs4all.nl>
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Reply-To: kieran.bingham@ideasonboard.com
Message-ID: <3a8aecf8-fbca-d48e-c6c8-ea5122f32e97@ideasonboard.com>
Date: Mon, 3 Jul 2017 15:45:32 +0100
MIME-Version: 1.0
In-Reply-To: <2b6688cb-3e73-815d-e23f-6c44c2e793af@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for your review,

On 03/07/17 14:51, Hans Verkuil wrote:
> On 06/27/2017 05:03 PM, Kieran Bingham wrote:
>> From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>>
>> Provide support for the ADV7481 and ADV7482.
>>
>> The driver is modelled with 4 subdevices to allow simultaneous streaming
>> from the AFE (Analog front end) and HDMI inputs though two CSI TX
>> entities.
>>
>> The HDMI entity is linked to the TXA CSI bus, whilst the AFE is linked
>> to the TXB CSI bus.
>>
>> The driver is based on a prototype by Koji Matsuoka in the Renesas BSP,
>> and an earlier rework by Niklas Söderlund.
>>
>> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>>
>> ---
>>
>> v2:
>>   - Implement DT parsing
>>   - adv748x: Add CSI2 entity
>>   - adv748x: Rework pad allocations and fmts
>>   - Give AFE 8 input pads and move pad defines
>>   - Use the enums to ensure pads are referenced correctly.
>>   - adv748x: Rename AFE/HDMI entities
>>     Now they are 'just afe' and 'just hdmi'
>>   - Reorder the entity enum and structures
>>   - Added pad-format for the CSI2 entities
>>   - CSI2 s_stream pass through
>>   - CSI2 control pass through (with link following)
>>
>> v3:
>>   - dt: Extend DT documentation to specify interrupt mappings
>>   - simplify adv748x_parse_dt
>>   - core: Add banner to header file describing ADV748x variants
>>   - Use entity structure pointers rather than global state pointers where
>>     possible
>>   - afe: Reduce indent on afe_status
>>   - hdmi: Add error checking to the bt->pixelclock values.
>>   - Remove all unnecessary pad checks: handled by core
>>   - Fix all probe cleanup paths
>>   - adv748x_csi2_probe() now fails if it has no endpoint
>>   - csi2: Fix small oneliners for is_txa and get_remote_sd()
>>   - csi2: Fix checkpatch warnings
>>   - csi2: Fix up s_stream pass-through
>>   - csi2: Fix up Pixel Rate passthrough
>>   - csi2: simplify adv748x_csi2_get_pad_format()
>>   - Remove 'async notifiers' from AFE/HDMI
>>     Using async notifiers was overkill, when we have access to the
>>     subdevices internally and can register them directly.
>>   - Use state lock in control handlers and clean up s_ctrls
>>   - remove _interruptible mutex locks
>>
>> v4:
>>   - all: Convert hex 0xXX to lowercase
>>   - all: Use defines instead of hardcoded register values
>>   - all: Use regmap
>>   - afe, csi2, hdmi: _probe -> _init
>>   - afe, csi2, hdmi: _remove -> _cleanup
>>   - afe, hdmi: Convert pattern generator to a control
>>   - afe, hdmi: get/set-fmt refactor
>>   - afe, hdmi, csi2: Convert to internal calls for pixelrate
>>   - afe: Allow the AFE to configure the Input Select from DT
>>   - afe: Reduce indent on adv748x_afe_status switch
>>   - afe: Remove ununsed macro definitions AIN0-7
>>   - afe: Remove extraneous control checks handled by core
>>   - afe: Comment fixups
>>   - afe: Rename error label
>>   - afe: Correct control names on the SDP
>>   - afe: Use AIN0-7 rather than AIN1-8 to match ports and MC pads
>>   - core: adv748x_parse_dt references to nodes, and catch multiple
>>     endpoints in a port.
>>   - core: adv748x_dt_cleanup to simplify releasing DT nodes
>>   - core: adv748x_print_info renamed to adv748x_identify_chip
>>   - core: reorganise ordering of probe sequence
>>   - core: No need for of_match_ptr
>>   - core: Fix up i2c read/writes (regmap still on todo list)
>>   - core: Set specific functions from the entities on subdev-init
>>   - core: Use kzalloc for state instead of devm
>>   - core: Improve probe error reporting
>>   - core: Track unknown BIT(6) in tx{a,b}_power
>>   - csi2: Improve adv748x_csi2_get_remote_sd as adv748x_csi2_get_source_sd
>>   - csi2: -EPIPE instead of -ENODEV
>>   - csi2: adv_dbg, instead of adv_info
>>   - csi2: adv748x_csi2_set_format fix
>>   - csi2: remove async notifier and sd member variables
>>   - csi2: register links from the CSI2
>>   - csi2: create virtual channel helper function
>>   - dt: Remove numbering from endpoints
>>   - dt: describe ports and interrupts as optional
>>   - dt: Re-tab
>>   - hdmi: adv748x_hdmi_have_signal -> adv748x_hdmi_has_signal
>>   - hdmi: fix adv748x_hdmi_read_pixelclock return checks
>>   - hdmi: improve adv748x_hdmi_set_video_timings
>>   - hdmi: Fix tmp variable as polarity
>>   - hdmi: Improve adv748x_hdmi_s_stream
>>   - hdmi: Clean up adv748x_hdmi_s_ctrl register definitions and usage
>>   - hdmi: Fix up adv748x_hdmi_s_dv_timings with macro names for register
>>   - hdmi: Add locking to adv748x_hdmi_g_dv_timings
>>     writes and locking
>>   - hdmi: adv748x_hdmi_set_de_timings function added to clarify DE writes
>>   - hdmi: Use CP in control register naming to match component processor
>>   - hdmi: clean up adv748x_hdmi_query_dv_timings()
>>   - KConfig: Fix up dependency and capitalisation
>>
>> v5:
>>   - afe,hdmi: _set_pixelrate -> _propagate_pixelrate
>>   - hdmi: Fix arm32 compilation failure : Use DIV_ROUND_CLOSEST_ULL
>>   - core: remove unused link functions
>>   - csi2: Use immutable links for HDMI->TXA, AFE->TXB
>>
>> v6:
>>   - hdmi: Provide EDID support
>>   - afe: Fix InLock inversion bug
>>   - afe: Prevent autodetection of input format except in querystd
>>   - afe,hdmi: Improve pattern generator control strings
>>   - hdmi: Remove interlaced support capability (it's untested)
>>
>>   drivers/media/i2c/Kconfig                |  11 +-
>>   drivers/media/i2c/Makefile               |   1 +-
>>   drivers/media/i2c/adv748x/Makefile       |   7 +-
>>   drivers/media/i2c/adv748x/adv748x-afe.c  | 545 ++++++++++++++++-
>>   drivers/media/i2c/adv748x/adv748x-core.c | 831 ++++++++++++++++++++++++-
>>   drivers/media/i2c/adv748x/adv748x-csi2.c | 327 +++++++++-
>>   drivers/media/i2c/adv748x/adv748x-hdmi.c | 769 ++++++++++++++++++++++-
>>   drivers/media/i2c/adv748x/adv748x.h      | 425 ++++++++++++-
>>   8 files changed, 2916 insertions(+)
>>   create mode 100644 drivers/media/i2c/adv748x/Makefile
>>   create mode 100644 drivers/media/i2c/adv748x/adv748x-afe.c
>>   create mode 100644 drivers/media/i2c/adv748x/adv748x-core.c
>>   create mode 100644 drivers/media/i2c/adv748x/adv748x-csi2.c
>>   create mode 100644 drivers/media/i2c/adv748x/adv748x-hdmi.c
>>   create mode 100644 drivers/media/i2c/adv748x/adv748x.h
>>
>> diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
>> index 121b3b5394cb..7641667c00ab 100644
>> --- a/drivers/media/i2c/Kconfig
>> +++ b/drivers/media/i2c/Kconfig
>> @@ -204,6 +204,17 @@ config VIDEO_ADV7183
>>         To compile this driver as a module, choose M here: the
>>         module will be called adv7183.
>>   +config VIDEO_ADV748X
>> +    tristate "Analog Devices ADV748x decoder"
>> +    depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
>> +    depends on OF
>> +    ---help---
>> +      V4L2 subdevice driver for the Analog Devices
>> +      ADV7481 and ADV7482 HDMI/Analog video decoders.
>> +
>> +      To compile this driver as a module, choose M here: the
>> +      module will be called adv748x.
>> +
>>   config VIDEO_ADV7604
>>       tristate "Analog Devices ADV7604 decoder"
>>       depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
>> diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
>> index 2c0868fa6034..30e856c02422 100644
>> --- a/drivers/media/i2c/Makefile
>> +++ b/drivers/media/i2c/Makefile
>> @@ -28,6 +28,7 @@ obj-$(CONFIG_VIDEO_ADV7180) += adv7180.o
>>   obj-$(CONFIG_VIDEO_ADV7183) += adv7183.o
>>   obj-$(CONFIG_VIDEO_ADV7343) += adv7343.o
>>   obj-$(CONFIG_VIDEO_ADV7393) += adv7393.o
>> +obj-$(CONFIG_VIDEO_ADV748X) += adv748x/
>>   obj-$(CONFIG_VIDEO_ADV7604) += adv7604.o
>>   obj-$(CONFIG_VIDEO_ADV7842) += adv7842.o
>>   obj-$(CONFIG_VIDEO_AD9389B) += ad9389b.o
>> diff --git a/drivers/media/i2c/adv748x/Makefile
>> b/drivers/media/i2c/adv748x/Makefile
>> new file mode 100644
>> index 000000000000..c0711e076f1d
>> --- /dev/null
>> +++ b/drivers/media/i2c/adv748x/Makefile
>> @@ -0,0 +1,7 @@
>> +adv748x-objs    := \
>> +        adv748x-afe.o \
>> +        adv748x-core.o \
>> +        adv748x-csi2.o \
>> +        adv748x-hdmi.o
>> +
>> +obj-$(CONFIG_VIDEO_ADV748X)    += adv748x.o
>> diff --git a/drivers/media/i2c/adv748x/adv748x-afe.c
>> b/drivers/media/i2c/adv748x/adv748x-afe.c
>> new file mode 100644
>> index 000000000000..f19b05e2780d
>> --- /dev/null
>> +++ b/drivers/media/i2c/adv748x/adv748x-afe.c
>> @@ -0,0 +1,545 @@
>> +/*
>> + * Driver for Analog Devices ADV748X 8 channel analog front end (AFE) receiver
>> + * with standard definition processor (SDP)
>> + *
>> + * Copyright (C) 2017 Renesas Electronics Corp.
>> + *
>> + * This program is free software; you can redistribute  it and/or modify it
>> + * under  the terms of  the GNU General  Public License as published by the
>> + * Free Software Foundation;  either version 2 of the  License, or (at your
>> + * option) any later version.
>> + */
>> +
>> +#include <linux/delay.h>
>> +#include <linux/module.h>
>> +#include <linux/mutex.h>
>> +#include <linux/v4l2-dv-timings.h>
>> +
>> +#include <media/v4l2-ctrls.h>
>> +#include <media/v4l2-device.h>
>> +#include <media/v4l2-dv-timings.h>
>> +#include <media/v4l2-ioctl.h>
>> +
>> +#include "adv748x.h"
>> +
>> +/* -----------------------------------------------------------------------------
>> + * SDP
>> + */
>> +
>> +#define ADV748X_AFE_STD_AD_PAL_BG_NTSC_J_SECAM        0x0
>> +#define ADV748X_AFE_STD_AD_PAL_BG_NTSC_J_SECAM_PED    0x1
>> +#define ADV748X_AFE_STD_AD_PAL_N_NTSC_J_SECAM        0x2
>> +#define ADV748X_AFE_STD_AD_PAL_N_NTSC_M_SECAM        0x3
>> +#define ADV748X_AFE_STD_NTSC_J                0x4
>> +#define ADV748X_AFE_STD_NTSC_M                0x5
>> +#define ADV748X_AFE_STD_PAL60                0x6
>> +#define ADV748X_AFE_STD_NTSC_443            0x7
>> +#define ADV748X_AFE_STD_PAL_BG                0x8
>> +#define ADV748X_AFE_STD_PAL_N                0x9
>> +#define ADV748X_AFE_STD_PAL_M                0xa
>> +#define ADV748X_AFE_STD_PAL_M_PED            0xb
>> +#define ADV748X_AFE_STD_PAL_COMB_N            0xc
>> +#define ADV748X_AFE_STD_PAL_COMB_N_PED            0xd
>> +#define ADV748X_AFE_STD_PAL_SECAM            0xe
>> +#define ADV748X_AFE_STD_PAL_SECAM_PED            0xf
>> +
>> +static int adv748x_afe_read_ro_map(struct adv748x_state *state, u8 reg)
>> +{
>> +    int ret;
>> +
>> +    /* Select SDP Read-Only Main Map */
>> +    ret = sdp_write(state, ADV748X_SDP_MAP_SEL,
>> +            ADV748X_SDP_MAP_SEL_RO_MAIN);
>> +    if (ret < 0)
>> +        return ret;
>> +
>> +    return sdp_read(state, reg);
>> +}
>> +
>> +static int adv748x_afe_status(struct adv748x_afe *afe, u32 *signal,
>> +                  v4l2_std_id *std)
>> +{
>> +    struct adv748x_state *state = adv748x_afe_to_state(afe);
>> +    int info;
>> +
>> +    /* Read status from reg 0x10 of SDP RO Map */
>> +    info = adv748x_afe_read_ro_map(state, ADV748X_SDP_RO_10);
>> +    if (info < 0)
>> +        return info;
>> +
>> +    if (signal)
>> +        *signal = info & ADV748X_SDP_RO_10_IN_LOCK ?
>> +                0 : V4L2_IN_ST_NO_SIGNAL;
>> +
>> +    if (!std)
>> +        return 0;
>> +
>> +    /* Standard not valid if there is no signal */
>> +    if (!(info & ADV748X_SDP_RO_10_IN_LOCK)) {
>> +        *std = V4L2_STD_UNKNOWN;
>> +        return 0;
>> +    }
>> +
>> +    switch (info & 0x70) {
>> +    case 0x00:
>> +        *std = V4L2_STD_NTSC;
>> +        break;
>> +    case 0x10:
>> +        *std = V4L2_STD_NTSC_443;
>> +        break;
>> +    case 0x20:
>> +        *std = V4L2_STD_PAL_M;
>> +        break;
>> +    case 0x30:
>> +        *std = V4L2_STD_PAL_60;
>> +        break;
>> +    case 0x40:
>> +        *std = V4L2_STD_PAL;
>> +        break;
>> +    case 0x50:
>> +        *std = V4L2_STD_SECAM;
>> +        break;
>> +    case 0x60:
>> +        *std = V4L2_STD_PAL_Nc | V4L2_STD_PAL_N;
>> +        break;
>> +    case 0x70:
>> +        *std = V4L2_STD_SECAM;
>> +        break;
>> +    default:
>> +        *std = V4L2_STD_UNKNOWN;
>> +        break;
>> +    }
>> +
>> +    return 0;
>> +}
>> +
>> +static void adv748x_afe_fill_format(struct adv748x_afe *afe,
>> +                    struct v4l2_mbus_framefmt *fmt)
>> +{
>> +    memset(fmt, 0, sizeof(*fmt));
>> +
>> +    fmt->code = MEDIA_BUS_FMT_UYVY8_2X8;
>> +    fmt->colorspace = V4L2_COLORSPACE_SMPTE170M;
>> +    fmt->field = V4L2_FIELD_INTERLACED;
>> +
>> +    fmt->width = 720;
>> +    fmt->height = afe->curr_norm & V4L2_STD_525_60 ? 480 : 576;
>> +}
>> +
>> +static int adv748x_afe_std(v4l2_std_id std)
>> +{
>> +    if (std == V4L2_STD_PAL_60)
>> +        return ADV748X_AFE_STD_PAL60;
>> +    if (std == V4L2_STD_NTSC_443)
>> +        return ADV748X_AFE_STD_NTSC_443;
>> +    if (std == V4L2_STD_PAL_N)
>> +        return ADV748X_AFE_STD_PAL_N;
>> +    if (std == V4L2_STD_PAL_M)
>> +        return ADV748X_AFE_STD_PAL_M;
>> +    if (std == V4L2_STD_PAL_Nc)
>> +        return ADV748X_AFE_STD_PAL_COMB_N;
>> +    if (std & V4L2_STD_NTSC)
>> +        return ADV748X_AFE_STD_NTSC_M;
>> +    if (std & V4L2_STD_PAL)
>> +        return ADV748X_AFE_STD_PAL_BG;
>> +    if (std & V4L2_STD_SECAM)
>> +        return ADV748X_AFE_STD_PAL_SECAM;
>> +
>> +    return -EINVAL;
>> +}
>> +
>> +static void adv748x_afe_set_video_standard(struct adv748x_state *state,
>> +                      int sdpstd)
>> +{
>> +    sdp_clrset(state, ADV748X_SDP_VID_SEL, ADV748X_SDP_VID_SEL_MASK,
>> +           (sdpstd & 0xf) << ADV748X_SDP_VID_SEL_SHIFT);
>> +}
>> +
>> +static int adv748x_afe_s_input(struct adv748x_afe *afe, unsigned int input)
>> +{
>> +    struct adv748x_state *state = adv748x_afe_to_state(afe);
>> +
>> +    return sdp_write(state, ADV748X_SDP_INSEL, input);
>> +}
>> +
>> +static int adv748x_afe_g_pixelaspect(struct v4l2_subdev *sd,
>> +                     struct v4l2_fract *aspect)
>> +{
>> +    struct adv748x_afe *afe = adv748x_sd_to_afe(sd);
>> +
>> +    if (afe->curr_norm & V4L2_STD_525_60) {
>> +        aspect->numerator = 11;
>> +        aspect->denominator = 10;
>> +    } else {
>> +        aspect->numerator = 54;
>> +        aspect->denominator = 59;
>> +    }
>> +
>> +    return 0;
>> +}
>> +
>> +/* -----------------------------------------------------------------------------
>> + * v4l2_subdev_video_ops
>> + */
>> +
>> +static int adv748x_afe_g_std(struct v4l2_subdev *sd, v4l2_std_id *norm)
>> +{
>> +    struct adv748x_afe *afe = adv748x_sd_to_afe(sd);
>> +
>> +    *norm = afe->curr_norm;
>> +
>> +    return 0;
>> +}
>> +
>> +static int adv748x_afe_s_std(struct v4l2_subdev *sd, v4l2_std_id std)
>> +{
>> +    struct adv748x_afe *afe = adv748x_sd_to_afe(sd);
>> +    struct adv748x_state *state = adv748x_afe_to_state(afe);
>> +    int afe_std = adv748x_afe_std(std);
>> +
>> +    if (afe_std < 0)
>> +        return afe_std;
>> +
>> +    mutex_lock(&state->mutex);
>> +
>> +    adv748x_afe_set_video_standard(state, afe_std);
>> +    afe->curr_norm = std;
>> +
>> +    mutex_unlock(&state->mutex);
>> +
>> +    return 0;
>> +}
>> +
>> +static int adv748x_afe_querystd(struct v4l2_subdev *sd, v4l2_std_id *std)
>> +{
>> +    struct adv748x_afe *afe = adv748x_sd_to_afe(sd);
>> +    struct adv748x_state *state = adv748x_afe_to_state(afe);
>> +    int ret;
>> +
>> +    mutex_lock(&state->mutex);
>> +
>> +    if (afe->streaming) {
>> +        ret = -EBUSY;
>> +        goto unlock;
>> +    }
>> +
>> +    /* Set auto detect mode */
>> +    adv748x_afe_set_video_standard(state,
>> +                       ADV748X_AFE_STD_AD_PAL_BG_NTSC_J_SECAM);
>> +
>> +    msleep(100);
>> +
>> +    /* Read detected standard */
>> +    ret = adv748x_afe_status(afe, NULL, std);
> 
> Shouldn't you restore the video standard at this point after changing it above?

I did wonder about that...

I guess it makes sense :-)

> 
>> +unlock:
>> +    mutex_unlock(&state->mutex);
>> +
>> +    return ret;
>> +}
> 
> <snip>
> 
>> +int adv748x_afe_init(struct adv748x_afe *afe)
>> +{
>> +    struct adv748x_state *state = adv748x_afe_to_state(afe);
>> +    int ret;
>> +    unsigned int i;
>> +
>> +    afe->input = 0;
>> +    afe->streaming = false;
>> +    afe->curr_norm = V4L2_STD_ALL;
> 
> This isn't valid. Usually the initial standard is set to NTSC_M.
> 

Hrm... I messed up somewhere - because you've already told me this, and I'm sure
I'd already changed it...

My apologies ...

It's *definitely* changed for v7 :)


>> +
>> +    adv748x_subdev_init(&afe->sd, state, &adv748x_afe_ops,
>> +                MEDIA_ENT_F_ATV_DECODER, "afe");
>> +
>> +    /* Identify the first connector found as a default input if set */
>> +    for (i = ADV748X_PORT_AIN0; i <= ADV748X_PORT_AIN7; i++) {
>> +        /* Inputs and ports are 1-indexed to match the data sheet */
>> +        if (state->endpoints[i]) {
>> +            afe->input = i;
>> +            break;
>> +        }
>> +    }
>> +
>> +    adv748x_afe_s_input(afe, afe->input);
>> +
>> +    adv_dbg(state, "AFE Default input set to %d\n", afe->input);
>> +
>> +    /* Entity pads and sinks are 0-indexed to match the pads */
>> +    for (i = ADV748X_AFE_SINK_AIN0; i <= ADV748X_AFE_SINK_AIN7; i++)
>> +        afe->pads[i].flags = MEDIA_PAD_FL_SINK;
>> +
>> +    afe->pads[ADV748X_AFE_SOURCE].flags = MEDIA_PAD_FL_SOURCE;
>> +
>> +    ret = media_entity_pads_init(&afe->sd.entity, ADV748X_AFE_NR_PADS,
>> +            afe->pads);
>> +    if (ret)
>> +        return ret;
>> +
>> +    ret = adv748x_afe_init_controls(afe);
>> +    if (ret)
>> +        goto error;
>> +
>> +    return 0;
>> +
>> +error:
>> +    media_entity_cleanup(&afe->sd.entity);
>> +
>> +    return ret;
>> +}
>> +
>> +void adv748x_afe_cleanup(struct adv748x_afe *afe)
>> +{
>> +    v4l2_device_unregister_subdev(&afe->sd);
>> +    media_entity_cleanup(&afe->sd.entity);
>> +    v4l2_ctrl_handler_free(&afe->ctrl_hdl);
>> +}
> 
> <snip>
> 
>> diff --git a/drivers/media/i2c/adv748x/adv748x-hdmi.c
>> b/drivers/media/i2c/adv748x/adv748x-hdmi.c
>> new file mode 100644
>> index 000000000000..6ab3f9791b4f
>> --- /dev/null
>> +++ b/drivers/media/i2c/adv748x/adv748x-hdmi.c
>> @@ -0,0 +1,769 @@
>> +/*
>> + * Driver for Analog Devices ADV748X HDMI receiver and Component Processor (CP)
>> + *
>> + * Copyright (C) 2017 Renesas Electronics Corp.
>> + *
>> + * This program is free software; you can redistribute  it and/or modify it
>> + * under  the terms of  the GNU General  Public License as published by the
>> + * Free Software Foundation;  either version 2 of the  License, or (at your
>> + * option) any later version.
>> + */
>> +
>> +#include <linux/module.h>
>> +#include <linux/mutex.h>
>> +
>> +#include <media/v4l2-ctrls.h>
>> +#include <media/v4l2-device.h>
>> +#include <media/v4l2-dv-timings.h>
>> +#include <media/v4l2-ioctl.h>
>> +
>> +#include <uapi/linux/v4l2-dv-timings.h>
>> +
>> +#include "adv748x.h"
>> +
>> +/* -----------------------------------------------------------------------------
>> + * HDMI and CP
>> + */
>> +
>> +#define ADV748X_HDMI_MIN_WIDTH        640
>> +#define ADV748X_HDMI_MAX_WIDTH        1920
>> +#define ADV748X_HDMI_MIN_HEIGHT        480
>> +#define ADV748X_HDMI_MAX_HEIGHT        1200
>> +#define ADV748X_HDMI_MIN_PIXELCLOCK    0        /* unknown */
> 
> 0 makes no sense. Something like 13000000 would work better (pixelclock rate for
> V4L2_DV_BT_CEA_720X480I59_94 is 13500000).

This is another one that must have got lost somehow - you'd already told me this
and I'm really sure I changed it to the value you suggested ...

/me is confused at code loss - Must have been a rebase gone bad. :-(


>> +#define ADV748X_HDMI_MAX_PIXELCLOCK    162000000
> 
> You probably based that on the 1600x1200p60 format?

No idea I'm afraid - it's the value that was set when I recieved the driver...

> 
> 162MHz is a bit low for an adv receiver. The adv7604 and adv8742 have a max rate
> of 225 MHz.
> This should be documented in the datasheet.

Hrm ... haven't found it yet - I'll keep digging....

> Besides, you need a bit of margin since detected pixelclock rates can be a bit off.
> 
>> +
>> +static const struct v4l2_dv_timings_cap adv748x_hdmi_timings_cap = {
>> +    .type = V4L2_DV_BT_656_1120,
>> +    /* keep this initialization for compatibility with GCC < 4.4.6 */
>> +    .reserved = { 0 },
>> +    /* Min pixelclock value is unknown */
>> +    V4L2_INIT_BT_TIMINGS(ADV748X_HDMI_MIN_WIDTH, ADV748X_HDMI_MAX_WIDTH,
>> +                 ADV748X_HDMI_MIN_HEIGHT, ADV748X_HDMI_MAX_HEIGHT,
>> +                 ADV748X_HDMI_MIN_PIXELCLOCK,
>> +                 ADV748X_HDMI_MAX_PIXELCLOCK,
>> +                 V4L2_DV_BT_STD_CEA861 | V4L2_DV_BT_STD_DMT,
>> +                 V4L2_DV_BT_CAP_PROGRESSIVE)
>> +};
>> +
>> +struct adv748x_hdmi_video_standards {
>> +    struct v4l2_dv_timings timings;
>> +    u8 vid_std;
>> +    u8 v_freq;
>> +};
>> +
>> +static const struct adv748x_hdmi_video_standards
>> +adv748x_hdmi_video_standards[] = {
>> +    { V4L2_DV_BT_CEA_720X480I59_94, 0x40, 0x00 },
>> +    { V4L2_DV_BT_CEA_720X576I50, 0x41, 0x01 },
> 
> Since adv748x_hdmi_timings_cap doesn't specify CAP_INTERLACED you shouldn't
> add these interlaced timings in this list.

Ok - I'll move these into a local patch for when I can get interlace tested
correctly.

>> +    { V4L2_DV_BT_CEA_720X480P59_94, 0x4a, 0x00 },
>> +    { V4L2_DV_BT_CEA_720X576P50, 0x4b, 0x00 },
>> +    { V4L2_DV_BT_CEA_1280X720P60, 0x53, 0x00 },
>> +    { V4L2_DV_BT_CEA_1280X720P50, 0x53, 0x01 },
>> +    { V4L2_DV_BT_CEA_1280X720P30, 0x53, 0x02 },
>> +    { V4L2_DV_BT_CEA_1280X720P25, 0x53, 0x03 },
>> +    { V4L2_DV_BT_CEA_1280X720P24, 0x53, 0x04 },
>> +    { V4L2_DV_BT_CEA_1920X1080I60, 0x54, 0x00 },
>> +    { V4L2_DV_BT_CEA_1920X1080I50, 0x54, 0x01 },
>> +    { V4L2_DV_BT_CEA_1920X1080P60, 0x5e, 0x00 },
>> +    { V4L2_DV_BT_CEA_1920X1080P50, 0x5e, 0x01 },
>> +    { V4L2_DV_BT_CEA_1920X1080P30, 0x5e, 0x02 },
>> +    { V4L2_DV_BT_CEA_1920X1080P25, 0x5e, 0x03 },
>> +    { V4L2_DV_BT_CEA_1920X1080P24, 0x5e, 0x04 },
>> +    /* SVGA */
>> +    { V4L2_DV_BT_DMT_800X600P56, 0x80, 0x00 },
>> +    { V4L2_DV_BT_DMT_800X600P60, 0x81, 0x00 },
>> +    { V4L2_DV_BT_DMT_800X600P72, 0x82, 0x00 },
>> +    { V4L2_DV_BT_DMT_800X600P75, 0x83, 0x00 },
>> +    { V4L2_DV_BT_DMT_800X600P85, 0x84, 0x00 },
>> +    /* SXGA */
>> +    { V4L2_DV_BT_DMT_1280X1024P60, 0x85, 0x00 },
>> +    { V4L2_DV_BT_DMT_1280X1024P75, 0x86, 0x00 },
>> +    /* VGA */
>> +    { V4L2_DV_BT_DMT_640X480P60, 0x88, 0x00 },
>> +    { V4L2_DV_BT_DMT_640X480P72, 0x89, 0x00 },
>> +    { V4L2_DV_BT_DMT_640X480P75, 0x8a, 0x00 },
>> +    { V4L2_DV_BT_DMT_640X480P85, 0x8b, 0x00 },
>> +    /* XGA */
>> +    { V4L2_DV_BT_DMT_1024X768P60, 0x8c, 0x00 },
>> +    { V4L2_DV_BT_DMT_1024X768P70, 0x8d, 0x00 },
>> +    { V4L2_DV_BT_DMT_1024X768P75, 0x8e, 0x00 },
>> +    { V4L2_DV_BT_DMT_1024X768P85, 0x8f, 0x00 },
>> +    /* UXGA */
>> +    { V4L2_DV_BT_DMT_1600X1200P60, 0x96, 0x00 },
>> +};
>> +
>> +static void adv748x_hdmi_fill_format(struct adv748x_hdmi *hdmi,
>> +                     struct v4l2_mbus_framefmt *fmt)
>> +{
>> +    memset(fmt, 0, sizeof(*fmt));
>> +
>> +    fmt->code = MEDIA_BUS_FMT_RGB888_1X24;
>> +    fmt->field = hdmi->timings.bt.interlaced ?
>> +        V4L2_FIELD_INTERLACED : V4L2_FIELD_NONE;
> 
> INTERLACED -> ALTERNATE.

OK.

OOI: Is this because of the removal of the interlaced cap - or because
V4L2_FIELD_INTERLACED is deprecated or such?

>> +
>> +    /* The colorspace depends on the AVI InfoFrame contents */
>> +    fmt->colorspace = V4L2_COLORSPACE_SRGB;
>> +
>> +    fmt->width = hdmi->timings.bt.width;
>> +    fmt->height = hdmi->timings.bt.height;
>> +}
>> +
>> +static void adv748x_fill_optional_dv_timings(struct v4l2_dv_timings *timings)
>> +{
>> +    v4l2_find_dv_timings_cap(timings, &adv748x_hdmi_timings_cap,
>> +                 250000, NULL, NULL);
>> +}
>> +
>> +static bool adv748x_hdmi_has_signal(struct adv748x_state *state)
>> +{
>> +    int val;
>> +
>> +    /* Check that VERT_FILTER and DE_REGEN is locked */
>> +    val = hdmi_read(state, ADV748X_HDMI_LW1);
>> +    return (val & ADV748X_HDMI_LW1_VERT_FILTER) &&
>> +           (val & ADV748X_HDMI_LW1_DE_REGEN);
>> +}
>> +
>> +static int adv748x_hdmi_read_pixelclock(struct adv748x_state *state)
>> +{
>> +    int a, b;
>> +
>> +    a = hdmi_read(state, ADV748X_HDMI_TMDS_1);
>> +    b = hdmi_read(state, ADV748X_HDMI_TMDS_2);
>> +    if (a < 0 || b < 0)
>> +        return -ENODATA;
>> +
>> +    /*
>> +     * The high 9 bits store TMDS frequency measurement in MHz
>> +     * The low 7 bits of TMDS_2 store the 7-bit TMDS fractional frequency
>> +     * measurement in 1/128 MHz
>> +     */
>> +    return ((a << 1) | (b >> 7)) * 1000000 + (b & 0x7f) * 1000000 / 128;
>> +}
>> +
>> +/*
>> + * adv748x_hdmi_set_de_timings: Adjust horizontal picture offset through DE
>> + *
>> + * HDMI CP uses a Data Enable synchronisation timing reference
>> + *
>> + * Vary the leading and trailing edge position of the DE signal output by the CP
>> + * core. Values are stored as signed-twos-complement in one-pixel-clock units
>> + *
>> + * The start and end are shifted equally by the 10-bit shift value.
>> + */
>> +static void adv748x_hdmi_set_de_timings(struct adv748x_state *state, int shift)
>> +{
>> +    u8 high, low;
>> +
>> +    /* POS_HIGH stores bits 8 and 9 of both the start and end */
>> +    high = ADV748X_CP_DE_POS_HIGH_SET;
>> +    high |= (shift & 0x300) >> 8;
>> +    low = shift & 0xff;
>> +
>> +    /* The sequence of the writes is important and must be followed */
>> +    cp_write(state, ADV748X_CP_DE_POS_HIGH, high);
>> +    cp_write(state, ADV748X_CP_DE_POS_END_LOW, low);
>> +
>> +    high |= (shift & 0x300) >> 6;
>> +
>> +    cp_write(state, ADV748X_CP_DE_POS_HIGH, high);
>> +    cp_write(state, ADV748X_CP_DE_POS_START_LOW, low);
>> +}
>> +
>> +static int adv748x_hdmi_set_video_timings(struct adv748x_state *state,
>> +                      const struct v4l2_dv_timings *timings)
>> +{
>> +    const struct adv748x_hdmi_video_standards *stds =
>> +        adv748x_hdmi_video_standards;
>> +    unsigned int i;
>> +
>> +    for (i = 0; i < ARRAY_SIZE(adv748x_hdmi_video_standards); i++) {
>> +        if (!v4l2_match_dv_timings(timings, &stds[i].timings, 250000,
>> +                       false))
>> +            continue;
>> +    }
>> +
>> +    if (i >= ARRAY_SIZE(adv748x_hdmi_video_standards))
>> +        return -EINVAL;
>> +
>> +    /*
>> +     * When setting cp_vid_std to either 720p, 1080i, or 1080p, the video
>> +     * will get shifted horizontally to the left in active video mode.
>> +     * The de_h_start and de_h_end controls are used to centre the picture
>> +     * correctly
>> +     */
>> +    switch (stds[i].vid_std) {
>> +    case 0x53: /* 720p */
>> +        adv748x_hdmi_set_de_timings(state, -40);
>> +        break;
>> +    case 0x54: /* 1080i */
>> +    case 0x5e: /* 1080p */
>> +        adv748x_hdmi_set_de_timings(state, -44);
>> +        break;
>> +    default:
>> +        adv748x_hdmi_set_de_timings(state, 0);
>> +        break;
>> +    }
>> +
>> +    io_write(state, ADV748X_IO_VID_STD, stds[i].vid_std);
>> +    io_clrset(state, ADV748X_IO_DATAPATH, ADV748X_IO_DATAPATH_VFREQ_M,
>> +          stds[i].v_freq << ADV748X_IO_DATAPATH_VFREQ_SHIFT);
>> +
>> +    return 0;
>> +}
>> +
>> +/* -----------------------------------------------------------------------------
>> + * v4l2_subdev_video_ops
>> + */
>> +
>> +static int adv748x_hdmi_s_dv_timings(struct v4l2_subdev *sd,
>> +                     struct v4l2_dv_timings *timings)
>> +{
>> +    struct adv748x_hdmi *hdmi = adv748x_sd_to_hdmi(sd);
>> +    struct adv748x_state *state = adv748x_hdmi_to_state(hdmi);
>> +    int ret;
>> +
>> +    if (!timings)
>> +        return -EINVAL;
>> +
>> +    if (v4l2_match_dv_timings(&hdmi->timings, timings, 0, false))
>> +        return 0;
>> +
>> +    if (!v4l2_valid_dv_timings(timings, &adv748x_hdmi_timings_cap,
>> +                   NULL, NULL))
>> +        return -ERANGE;
>> +
>> +    adv748x_fill_optional_dv_timings(timings);
>> +
>> +    mutex_lock(&state->mutex);
>> +
>> +    ret = adv748x_hdmi_set_video_timings(state, timings);
>> +    if (ret)
>> +        goto error;
>> +
>> +    hdmi->timings = *timings;
>> +
>> +    cp_clrset(state, ADV748X_CP_VID_ADJ_2, ADV748X_CP_VID_ADJ_2_INTERLACED,
>> +          timings->bt.interlaced ?
>> +                  ADV748X_CP_VID_ADJ_2_INTERLACED : 0);
>> +
>> +    mutex_unlock(&state->mutex);
>> +
>> +    return 0;
>> +
>> +error:
>> +    mutex_unlock(&state->mutex);
>> +    return ret;
>> +}
>> +
>> +static int adv748x_hdmi_g_dv_timings(struct v4l2_subdev *sd,
>> +                     struct v4l2_dv_timings *timings)
>> +{
>> +    struct adv748x_hdmi *hdmi = adv748x_sd_to_hdmi(sd);
>> +    struct adv748x_state *state = adv748x_hdmi_to_state(hdmi);
>> +
>> +    mutex_lock(&state->mutex);
>> +
>> +    *timings = hdmi->timings;
>> +
>> +    mutex_unlock(&state->mutex);
>> +
>> +    return 0;
>> +}
>> +
>> +static int adv748x_hdmi_query_dv_timings(struct v4l2_subdev *sd,
>> +                     struct v4l2_dv_timings *timings)
>> +{
>> +    struct adv748x_hdmi *hdmi = adv748x_sd_to_hdmi(sd);
>> +    struct adv748x_state *state = adv748x_hdmi_to_state(hdmi);
>> +    struct v4l2_bt_timings *bt = &timings->bt;
>> +    int pixelclock;
>> +    int polarity;
>> +
>> +    if (!timings)
>> +        return -EINVAL;
>> +
>> +    memset(timings, 0, sizeof(struct v4l2_dv_timings));
>> +
>> +    if (!adv748x_hdmi_has_signal(state))
>> +        return -ENOLINK;
>> +
>> +    pixelclock = adv748x_hdmi_read_pixelclock(state);
>> +    if (pixelclock < 0)
>> +        return -ENODATA;
>> +
>> +    timings->type = V4L2_DV_BT_656_1120;
>> +
>> +    bt->pixelclock = pixelclock;
>> +    bt->interlaced = hdmi_read(state, ADV748X_HDMI_F1H1) &
>> +                ADV748X_HDMI_F1H1_INTERLACED ?
>> +                V4L2_DV_INTERLACED : V4L2_DV_PROGRESSIVE;
>> +    bt->width = hdmi_read16(state, ADV748X_HDMI_LW1,
>> +                ADV748X_HDMI_LW1_WIDTH_MASK);
>> +    bt->height = hdmi_read16(state, ADV748X_HDMI_F0H1,
>> +                 ADV748X_HDMI_F0H1_HEIGHT_MASK);
>> +    bt->hfrontporch = hdmi_read16(state, ADV748X_HDMI_HFRONT_PORCH,
>> +                      ADV748X_HDMI_HFRONT_PORCH_MASK);
>> +    bt->hsync = hdmi_read16(state, ADV748X_HDMI_HSYNC_WIDTH,
>> +                ADV748X_HDMI_HSYNC_WIDTH_MASK);
>> +    bt->hbackporch = hdmi_read16(state, ADV748X_HDMI_HBACK_PORCH,
>> +                     ADV748X_HDMI_HBACK_PORCH_MASK);
>> +    bt->vfrontporch = hdmi_read16(state, ADV748X_HDMI_VFRONT_PORCH,
>> +                      ADV748X_HDMI_VFRONT_PORCH_MASK) / 2;
>> +    bt->vsync = hdmi_read16(state, ADV748X_HDMI_VSYNC_WIDTH,
>> +                ADV748X_HDMI_VSYNC_WIDTH_MASK) / 2;
>> +    bt->vbackporch = hdmi_read16(state, ADV748X_HDMI_VBACK_PORCH,
>> +                     ADV748X_HDMI_VBACK_PORCH_MASK) / 2;
>> +
>> +    polarity = hdmi_read(state, 0x05);
>> +    bt->polarities = (polarity & BIT(4) ? V4L2_DV_VSYNC_POS_POL : 0) |
>> +        (polarity & BIT(5) ? V4L2_DV_HSYNC_POS_POL : 0);
>> +
>> +    if (bt->interlaced == V4L2_DV_INTERLACED) {
>> +        bt->height += hdmi_read16(state, 0x0b, 0x1fff);
>> +        bt->il_vfrontporch = hdmi_read16(state, 0x2c, 0x3fff) / 2;
>> +        bt->il_vsync = hdmi_read16(state, 0x30, 0x3fff) / 2;
>> +        bt->il_vbackporch = hdmi_read16(state, 0x34, 0x3fff) / 2;
>> +    }
>> +
>> +    adv748x_fill_optional_dv_timings(timings);
>> +
>> +    /*
>> +     * No interrupt handling is implemented yet.
>> +     * There should be an IRQ when a cable is plugged and the new timings
>> +     * should be figured out and stored to state.
>> +     */
>> +    hdmi->timings = *timings;
>> +
>> +    return 0;
>> +}
>> +
>> +static int adv748x_hdmi_g_input_status(struct v4l2_subdev *sd, u32 *status)
>> +{
>> +    struct adv748x_hdmi *hdmi = adv748x_sd_to_hdmi(sd);
>> +    struct adv748x_state *state = adv748x_hdmi_to_state(hdmi);
>> +
>> +    mutex_lock(&state->mutex);
>> +
>> +    *status = adv748x_hdmi_has_signal(state) ? 0 : V4L2_IN_ST_NO_SIGNAL;
>> +
>> +    mutex_unlock(&state->mutex);
>> +
>> +    return 0;
>> +}
>> +
>> +static int adv748x_hdmi_s_stream(struct v4l2_subdev *sd, int enable)
>> +{
>> +    struct adv748x_hdmi *hdmi = adv748x_sd_to_hdmi(sd);
>> +    struct adv748x_state *state = adv748x_hdmi_to_state(hdmi);
>> +    int ret;
>> +
>> +    mutex_lock(&state->mutex);
>> +
>> +    ret = adv748x_txa_power(state, enable);
>> +    if (ret)
>> +        goto done;
>> +
>> +    if (adv748x_hdmi_has_signal(state))
>> +        adv_dbg(state, "Detected HDMI signal\n");
>> +    else
>> +        adv_dbg(state, "Couldn't detect HDMI video signal\n");
>> +
>> +done:
>> +    mutex_unlock(&state->mutex);
>> +    return ret;
>> +}
>> +
>> +static int adv748x_hdmi_g_pixelaspect(struct v4l2_subdev *sd,
>> +                      struct v4l2_fract *aspect)
>> +{
>> +    aspect->numerator = 1;
>> +    aspect->denominator = 1;
>> +
>> +    return 0;
>> +}
>> +
>> +static const struct v4l2_subdev_video_ops adv748x_video_ops_hdmi = {
>> +    .s_dv_timings = adv748x_hdmi_s_dv_timings,
>> +    .g_dv_timings = adv748x_hdmi_g_dv_timings,
>> +    .query_dv_timings = adv748x_hdmi_query_dv_timings,
>> +    .g_input_status = adv748x_hdmi_g_input_status,
>> +    .s_stream = adv748x_hdmi_s_stream,
>> +    .g_pixelaspect = adv748x_hdmi_g_pixelaspect,
>> +};
>> +
>> +/* -----------------------------------------------------------------------------
>> + * v4l2_subdev_pad_ops
>> + */
>> +
>> +static int adv748x_hdmi_propagate_pixelrate(struct adv748x_hdmi *hdmi)
>> +{
>> +    struct v4l2_subdev *tx;
>> +    struct v4l2_dv_timings timings;
>> +    struct v4l2_bt_timings *bt = &timings.bt;
>> +    unsigned int fps;
>> +
>> +    tx = adv748x_get_remote_sd(&hdmi->pads[ADV748X_HDMI_SOURCE]);
>> +    if (!tx)
>> +        return -ENOLINK;
>> +
>> +    adv748x_hdmi_query_dv_timings(&hdmi->sd, &timings);
>> +
>> +    fps = DIV_ROUND_CLOSEST_ULL(bt->pixelclock,
>> +                    V4L2_DV_BT_FRAME_WIDTH(bt) *
>> +                    V4L2_DV_BT_FRAME_HEIGHT(bt));
>> +
>> +    return adv748x_csi2_set_pixelrate(tx, bt->width * bt->height * fps);
>> +}
>> +
>> +static int adv748x_hdmi_enum_mbus_code(struct v4l2_subdev *sd,
>> +                  struct v4l2_subdev_pad_config *cfg,
>> +                  struct v4l2_subdev_mbus_code_enum *code)
>> +{
>> +    if (code->index != 0)
>> +        return -EINVAL;
>> +
>> +    code->code = MEDIA_BUS_FMT_RGB888_1X24;
>> +
>> +    return 0;
>> +}
>> +
>> +static int adv748x_hdmi_get_format(struct v4l2_subdev *sd,
>> +                   struct v4l2_subdev_pad_config *cfg,
>> +                   struct v4l2_subdev_format *sdformat)
>> +{
>> +    struct adv748x_hdmi *hdmi = adv748x_sd_to_hdmi(sd);
>> +    struct v4l2_mbus_framefmt *mbusformat;
>> +
>> +    if (sdformat->pad != ADV748X_HDMI_SOURCE)
>> +        return -EINVAL;
>> +
>> +    if (sdformat->which == V4L2_SUBDEV_FORMAT_TRY) {
>> +        mbusformat = v4l2_subdev_get_try_format(sd, cfg, sdformat->pad);
>> +        sdformat->format = *mbusformat;
>> +    } else {
>> +        adv748x_hdmi_fill_format(hdmi, &sdformat->format);
>> +        adv748x_hdmi_propagate_pixelrate(hdmi);
>> +    }
>> +
>> +    return 0;
>> +}
>> +
>> +static int adv748x_hdmi_set_format(struct v4l2_subdev *sd,
>> +                   struct v4l2_subdev_pad_config *cfg,
>> +                   struct v4l2_subdev_format *sdformat)
>> +{
>> +    struct v4l2_mbus_framefmt *mbusformat;
>> +
>> +    if (sdformat->pad != ADV748X_HDMI_SOURCE)
>> +        return -EINVAL;
>> +
>> +    if (sdformat->which == V4L2_SUBDEV_FORMAT_ACTIVE)
>> +        return adv748x_hdmi_get_format(sd, cfg, sdformat);
>> +
>> +    mbusformat = v4l2_subdev_get_try_format(sd, cfg, sdformat->pad);
>> +    *mbusformat = sdformat->format;
>> +
>> +    return 0;
>> +}
>> +
>> +static int adv748x_hdmi_get_edid(struct v4l2_subdev *sd, struct v4l2_edid *edid)
>> +{
>> +    struct adv748x_hdmi *hdmi = adv748x_sd_to_hdmi(sd);
>> +
>> +    memset(edid->reserved, 0, sizeof(edid->reserved));
>> +
>> +    if (!hdmi->edid.present)
>> +        return -ENODATA;
>> +
>> +    if (edid->start_block == 0 && edid->blocks == 0) {
>> +        edid->blocks = hdmi->edid.blocks;
>> +        return 0;
>> +    }
>> +
>> +    if (edid->start_block >= hdmi->edid.blocks)
>> +        return -EINVAL;
>> +
>> +    if (edid->start_block + edid->blocks > hdmi->edid.blocks)
>> +        edid->blocks = hdmi->edid.blocks - edid->start_block;
>> +
>> +    memcpy(edid->edid, hdmi->edid.edid + edid->start_block * 128,
>> +            edid->blocks * 128);
>> +
>> +    return 0;
>> +}
>> +
>> +static inline int adv748x_hdmi_edid_write_block(struct adv748x_hdmi *hdmi,
>> +                    unsigned int total_len, const u8 *val)
>> +{
>> +    struct adv748x_state *state = adv748x_hdmi_to_state(hdmi);
>> +    int err = 0;
>> +    int i = 0;
>> +    int len = 0;
>> +
>> +    adv_dbg(state, "%s: write EDID block (%d byte)\n",
>> +                __func__, total_len);
>> +
>> +    while (!err && i < total_len) {
>> +        len = (total_len - i) > I2C_SMBUS_BLOCK_MAX ?
>> +                I2C_SMBUS_BLOCK_MAX :
>> +                (total_len - i);
>> +
>> +        err = adv748x_write_block(state, ADV748X_PAGE_EDID,
>> +                i, val + i, len);
>> +        i += len;
>> +    }
>> +
>> +    return err;
>> +}
>> +
>> +static int adv748x_hdmi_set_edid(struct v4l2_subdev *sd, struct v4l2_edid *edid)
>> +{
>> +    struct adv748x_hdmi *hdmi = adv748x_sd_to_hdmi(sd);
>> +    struct adv748x_state *state = adv748x_hdmi_to_state(hdmi);
>> +    int err;
>> +
>> +    memset(edid->reserved, 0, sizeof(edid->reserved));
>> +
>> +    if (edid->start_block != 0)
>> +        return -EINVAL;
>> +
>> +    if (edid->blocks == 0) {
>> +        hdmi->edid.blocks = 0;
>> +        hdmi->edid.present = 0;
>> +
>> +        /* Fall back to a 16:9 aspect ratio */
>> +        hdmi->aspect_ratio.numerator = 16;
>> +        hdmi->aspect_ratio.denominator = 9;
>> +
>> +        /* Disable the EDID */
>> +        repeater_write(state, ADV748X_REPEATER_EDID_SZ,
>> +                   edid->blocks << ADV748X_REPEATER_EDID_SZ_SHIFT);
>> +
>> +        repeater_write(state, ADV748X_REPEATER_EDID_CTL, 0);
>> +
>> +        return 0;
>> +    }
>> +
>> +    if (edid->blocks > 4) {
>> +        edid->blocks = 4;
>> +        return -E2BIG;
>> +    }
>> +
>> +    memcpy(hdmi->edid.edid, edid->edid, 128 * edid->blocks);
>> +    hdmi->edid.blocks = edid->blocks;
>> +    hdmi->edid.present = true;
>> +
>> +    hdmi->aspect_ratio = v4l2_calc_aspect_ratio(edid->edid[0x15],
>> +            edid->edid[0x16]);
>> +
>> +    err = adv748x_hdmi_edid_write_block(hdmi, 128 * edid->blocks,
>> +            hdmi->edid.edid);
>> +    if (err < 0) {
>> +        v4l2_err(sd, "error %d writing edid pad %d\n", err, edid->pad);
>> +        return err;
>> +    }
>> +
>> +    repeater_write(state, ADV748X_REPEATER_EDID_SZ,
>> +               edid->blocks << ADV748X_REPEATER_EDID_SZ_SHIFT);
>> +
>> +    repeater_write(state, ADV748X_REPEATER_EDID_CTL,
>> +               ADV748X_REPEATER_EDID_CTL_EN);
>> +
>> +    return 0;
>> +}
> 
> The new EDID code looks good! Thank you for doing this.
> 

No worries - I was happy to see it work - it makes the input testing easier.

It was on the task list, for after I'd converted the driver to use regmap ...
Once that had been done - the edid parts were easy enough, especially with your
ADV7604 driver as an example.

> Regards,
> 
>     Hans
