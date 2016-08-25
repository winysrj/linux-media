Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:51780 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S934202AbcHYN7G (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 25 Aug 2016 09:59:06 -0400
Date: Thu, 25 Aug 2016 16:58:53 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Todor Tomov <todor.tomov@linaro.org>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        devicetree@vger.kernel.org, mchehab@osg.samsung.com,
        hverkuil@xs4all.nl, geert@linux-m68k.org, matrandg@cisco.com,
        linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH v5 2/2] media: Add a driver for the ov5645 camera sensor.
Message-ID: <20160825135853.GL12130@valkosipuli.retiisi.org.uk>
References: <1467989679-29774-1-git-send-email-todor.tomov@linaro.org>
 <1467989679-29774-3-git-send-email-todor.tomov@linaro.org>
 <20160824101708.GI12130@valkosipuli.retiisi.org.uk>
 <57BDBC2F.7020902@linaro.org>
 <20160825071800.GK12130@valkosipuli.retiisi.org.uk>
 <57BEF2F9.4000809@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57BEF2F9.4000809@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Todor,

On Thu, Aug 25, 2016 at 04:30:33PM +0300, Todor Tomov wrote:
> Hi Sakari, Rob,
> 
> On 08/25/2016 10:18 AM, Sakari Ailus wrote:
> > Hi Todor,
> > 
> > On Wed, Aug 24, 2016 at 06:24:31PM +0300, Todor Tomov wrote:
> >> Hi Sakari,
> >>
> >> Thanks a lot for the time spent to review the driver!
> > 
> > You're welcome! :-)
> > 
> >> I have a few responses bellow.
> >>
> >>
> >> On 08/24/2016 01:17 PM, Sakari Ailus wrote:
> >>> Hi Todor,
> >>>
> >>> Thank you for the patch. Please see my comments below.
> >>>
> >>> On Fri, Jul 08, 2016 at 05:54:39PM +0300, Todor Tomov wrote:
> >>>> The ov5645 sensor from Omnivision supports up to 2592x1944
> >>>> and CSI2 interface.
> >>>>
> >>>> The driver adds support for the following modes:
> >>>> - 1280x960
> >>>> - 1920x1080
> >>>> - 2592x1944
> >>>>
> >>>> Output format is packed 8bit UYVY.
> >>>>
> >>>> Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
> >>>> ---
> >>>>  drivers/media/i2c/Kconfig  |   12 +
> >>>>  drivers/media/i2c/Makefile |    1 +
> >>>>  drivers/media/i2c/ov5645.c | 1371 ++++++++++++++++++++++++++++++++++++++++++++
> >>>>  3 files changed, 1384 insertions(+)
> >>>>  create mode 100644 drivers/media/i2c/ov5645.c
> >>>>
> >>>> diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
> >>>> index 993dc50..0cee05b 100644
> >>>> --- a/drivers/media/i2c/Kconfig
> >>>> +++ b/drivers/media/i2c/Kconfig
> >>>> @@ -500,6 +500,18 @@ config VIDEO_OV2659
> >>>>  	  To compile this driver as a module, choose M here: the
> >>>>  	  module will be called ov2659.
> >>>>  
> >>>> +config VIDEO_OV5645
> >>>> +	tristate "OmniVision OV5645 sensor support"
> >>>> +	depends on OF
> >>>> +	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
> >>>> +	depends on MEDIA_CAMERA_SUPPORT
> >>>> +	---help---
> >>>> +	  This is a Video4Linux2 sensor-level driver for the OmniVision
> >>>> +	  OV5645 camera.
> >>>> +
> >>>> +	  To compile this driver as a module, choose M here: the
> >>>> +	  module will be called ov5645.
> >>>> +
> >>>>  config VIDEO_OV7640
> >>>>  	tristate "OmniVision OV7640 sensor support"
> >>>>  	depends on I2C && VIDEO_V4L2
> >>>> diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
> >>>> index 94f2c99..2485aed 100644
> >>>> --- a/drivers/media/i2c/Makefile
> >>>> +++ b/drivers/media/i2c/Makefile
> >>>> @@ -55,6 +55,7 @@ obj-$(CONFIG_VIDEO_VP27SMPX) += vp27smpx.o
> >>>>  obj-$(CONFIG_VIDEO_SONY_BTF_MPX) += sony-btf-mpx.o
> >>>>  obj-$(CONFIG_VIDEO_UPD64031A) += upd64031a.o
> >>>>  obj-$(CONFIG_VIDEO_UPD64083) += upd64083.o
> >>>> +obj-$(CONFIG_VIDEO_OV5645) += ov5645.o
> >>>>  obj-$(CONFIG_VIDEO_OV7640) += ov7640.o
> >>>>  obj-$(CONFIG_VIDEO_OV7670) += ov7670.o
> >>>>  obj-$(CONFIG_VIDEO_OV9650) += ov9650.o
> >>>> diff --git a/drivers/media/i2c/ov5645.c b/drivers/media/i2c/ov5645.c
> >>>> new file mode 100644
> >>>> index 0000000..ec96d10
> >>>> --- /dev/null
> >>>> +++ b/drivers/media/i2c/ov5645.c
> >>>> @@ -0,0 +1,1371 @@
> >>>> +/*
> >>>> + * Driver for the OV5645 camera sensor.
> >>>> + *
> >>>> + * Copyright (c) 2011-2015, The Linux Foundation. All rights reserved.
> >>>> + * Copyright (C) 2015 By Tech Design S.L. All Rights Reserved.
> >>>> + * Copyright (C) 2012-2013 Freescale Semiconductor, Inc. All Rights Reserved.
> >>>> + *
> >>>> + * Based on:
> >>>> + * - the OV5645 driver from QC msm-3.10 kernel on codeaurora.org:
> >>>> + *   https://us.codeaurora.org/cgit/quic/la/kernel/msm-3.10/tree/drivers/
> >>>> + *       media/platform/msm/camera_v2/sensor/ov5645.c?h=LA.BR.1.2.4_rb1.41
> >>>> + * - the OV5640 driver posted on linux-media:
> >>>> + *   https://www.mail-archive.com/linux-media%40vger.kernel.org/msg92671.html
> >>>> + */
> >>>> +
> >>>> +/*
> >>>> + * This program is free software; you can redistribute it and/or modify
> >>>> + * it under the terms of the GNU General Public License as published by
> >>>> + * the Free Software Foundation; either version 2 of the License, or
> >>>> + * (at your option) any later version.
> >>>> +
> >>>> + * This program is distributed in the hope that it will be useful,
> >>>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> >>>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> >>>> + * GNU General Public License for more details.
> >>>> + */
> >>>> +
> >>>> +#include <linux/bitops.h>
> >>>> +#include <linux/clk.h>
> >>>> +#include <linux/delay.h>
> >>>> +#include <linux/device.h>
> >>>> +#include <linux/gpio/consumer.h>
> >>>> +#include <linux/i2c.h>
> >>>> +#include <linux/init.h>
> >>>> +#include <linux/module.h>
> >>>> +#include <linux/of.h>
> >>>> +#include <linux/of_graph.h>
> >>>> +#include <linux/regulator/consumer.h>
> >>>> +#include <linux/slab.h>
> >>>> +#include <linux/types.h>
> >>>> +#include <media/v4l2-ctrls.h>
> >>>> +#include <media/v4l2-of.h>
> >>>> +#include <media/v4l2-subdev.h>
> >>>> +
> >>>> +#define OV5645_VOLTAGE_ANALOG               2800000
> >>>> +#define OV5645_VOLTAGE_DIGITAL_CORE         1500000
> >>>> +#define OV5645_VOLTAGE_DIGITAL_IO           1800000
> >>>> +
> >>>> +#define OV5645_XCLK	23880000
> >>>
> >>> Is this really a property of the sensor itself? Shouldn't this go to the DT
> >>> instead? And 23,88 MHz seems pretty unusual for an external clock frequency.
> >>>
> >>> Even if your driver only could use this frequency for now, the DT still
> >>> should contain the real board specific frequency.
> >>
> >> Yes, 23.88MHz is the value of the external clock frequency.
> >> The sensor mode settings (the big sensor register settings arrays below)
> >> are calculated over this value. Changing the external clock frequency
> >> implies different sensor mode settings. However, the sensor mode settings
> >> come from the reference driver by QC so we don't actually have a way to
> >> change them and I doubt that we will ever have.
> >>
> >> So both the external clock frequency and the sensor mode settings are
> >> hardcoded in the driver. I have also discussed this with Rob Herring
> >> when he reviewed the 1/2 patch and we came to this conclusion.
> > 
> > It still isn't a property of the sensor. I'd put the frequency to the DT, so
> > that if support for more frequencies is added, no hacks will be needed.
> 
> Ok, I can add a property in th DT for the external clock frequency but also
> will add a comment in the driver that the frequency currently supported is
> 23.88MHz only.

Sounds good to me.

> 
> However I'd like to hear also Rob's opinion on this as he is the one
> who already acknowledged the dt binding.
> 
> 
> <snip>
> 
> >>>> +static int ov5645_s_power(struct v4l2_subdev *sd, int on)
> >>>> +{
> >>>> +	struct ov5645 *ov5645 = to_ov5645(sd);
> >>>> +	int ret = 0;
> >>>> +
> >>>> +	dev_dbg(ov5645->dev, "%s: on = %d\n", __func__, on);
> >>>> +
> >>>> +	mutex_lock(&ov5645->power_lock);
> >>>> +
> >>>> +	if (ov5645->power == !on) {
> >>>> +		/* Power state changes. */
> >>>> +		if (on) {
> >>>> +			ret = ov5645_set_power_on(ov5645);
> >>>> +			if (ret < 0) {
> >>>> +				dev_err(ov5645->dev, "could not set power %s\n",
> >>>> +					on ? "on" : "off");
> >>>> +				goto exit;
> >>>> +			}
> >>>> +
> >>>> +			ret = ov5645_init(ov5645);
> >>>> +			if (ret < 0) {
> >>>> +				dev_err(ov5645->dev,
> >>>> +					"could not set init registers\n");
> >>>> +				ov5645_set_power_off(ov5645);
> >>>> +				goto exit;
> >>>> +			}
> >>>> +
> >>>> +			ret = ov5645_write_reg(ov5645, OV5645_SYSTEM_CTRL0,
> >>>> +					       OV5645_SYSTEM_CTRL0_STOP);
> >>>
> >>> Is there a change that the sensor was streaming at this point?
> >>
> >> I'm not sure, but this is the startup sequence which is used in the reference driver
> >> from QC so I've followed it.
> > 
> > I suppose that'd only be the case if streaming was enabled by the register
> > list. That'd be a bug most probably.
> 
> I cannot say whether it is a bug or not.
> This init settings usually come from the camera sensor vendor and you just follow
> them - I guess this is what QC did when preparing their driver. But they have put
> this stop command after the init explicitly so I believe they were told to do it
> that way.

Ok.

> 
> > 
> >>
> >>>
> >>>> +			if (ret < 0) {
> >>>> +				ov5645_set_power_off(ov5645);
> >>>> +				goto exit;
> >>>> +			}
> >>>> +		} else {
> >>>> +			ov5645_set_power_off(ov5645);
> >>>> +		}
> >>>> +
> >>>> +		/* Update the power state. */
> >>>> +		ov5645->power = on ? true : false;
> >>>> +	}
> >>>> +
> >>>> +exit:
> >>>> +	mutex_unlock(&ov5645->power_lock);
> >>>> +
> >>>> +	return ret;
> >>>> +}
> >>>> +
> >>>> +
> 
> <snip>
> 
> >>>> +static int ov5645_set_format(struct v4l2_subdev *sd,
> >>>> +			     struct v4l2_subdev_pad_config *cfg,
> >>>> +			     struct v4l2_subdev_format *format)
> >>>> +{
> >>>> +	struct ov5645 *ov5645 = to_ov5645(sd);
> >>>> +	struct v4l2_mbus_framefmt *__format;
> >>>> +	struct v4l2_rect *__crop;
> >>>> +	enum ov5645_mode new_mode;
> >>>> +
> >>>> +	__crop = __ov5645_get_pad_crop(ov5645, cfg, format->pad,
> >>>> +			format->which);
> >>>> +
> >>>> +	new_mode = ov5645_find_nearest_mode(ov5645,
> >>>> +			format->format.width, format->format.height);
> >>>
> >>> Do you think you could you use v4l2_find_nearest_format() instead of making
> >>> your own function for the purpose?
> >>
> >> v4l2_find_nearest_format() doesn't quite fit with the current implementation
> >> which stores the current mode in "enum ov5645_mode current_mode".
> >> Is it recommended to use it?
> > 
> > I guess if you can't reasonably use it then don't, but then it raises the
> > question whether there's something wrong with the function. I think so. It
> > should be able to associate driver specific data to each resolution.
> 
> I'm not sure that I understand what you mean here. The newly found mode is
> set in ov5645->current_mode which is actually an index in the ov5645_mode_info_data
> array, which contains the settings for this resolution/mode.

The idea is that v4l2_find_nearest_format() should be usable for drivers to
search the closest suitable configuration for a given size. If the function
isn't up to the task, there probably is something wrong with it.

It'd be nice to fix that, if there's something wrong with the implementation.

> 
> > 
> >>
> >>>
> >>>> +	__crop->width = ov5645_mode_info_data[new_mode].width;
> >>>> +	__crop->height = ov5645_mode_info_data[new_mode].height;
> >>>> +
> >>>> +	ov5645->current_mode = new_mode;
> >>>> +
> >>>> +	__format = __ov5645_get_pad_format(ov5645, cfg, format->pad,
> >>>> +			format->which);
> >>>> +	__format->width = __crop->width;
> >>>> +	__format->height = __crop->height;
> >>>> +
> >>>> +	format->format = *__format;
> >>>> +
> >>>> +	return 0;
> >>>> +}
> >>>> +
> 
> <snip>

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
