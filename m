Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:34407 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750951AbdE2Vui (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 May 2017 17:50:38 -0400
From: Steve Longerbeam <slongerbeam@gmail.com>
Subject: Re: [PATCH v7 16/34] [media] add Omnivision OV5640 sensor driver
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com,
        linux@armlinux.org.uk, mchehab@kernel.org, hverkuil@xs4all.nl,
        nick@shmanahar.org, markus.heiser@darmarIT.de,
        p.zabel@pengutronix.de, laurent.pinchart+renesas@ideasonboard.com,
        bparrot@ti.com, geert@linux-m68k.org, arnd@arndb.de,
        sudipm.mukherjee@gmail.com, minghsiu.tsai@mediatek.com,
        tiffany.lin@mediatek.com, jean-christophe.trotin@st.com,
        horms+renesas@verge.net.au, niklas.soderlund+renesas@ragnatech.se,
        robert.jarzmik@free.fr, songjun.wu@microchip.com,
        andrew-ct.chen@mediatek.com, gregkh@linuxfoundation.org,
        shuah@kernel.org, sakari.ailus@linux.intel.com, pavel@ucw.cz,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
References: <1495672189-29164-1-git-send-email-steve_longerbeam@mentor.com>
 <1495672189-29164-17-git-send-email-steve_longerbeam@mentor.com>
 <20170529155511.GI29527@valkosipuli.retiisi.org.uk>
Message-ID: <c50c3c5f-71cf-fa73-f5a8-a4b5f59a87dc@gmail.com>
Date: Mon, 29 May 2017 14:50:34 -0700
MIME-Version: 1.0
In-Reply-To: <20170529155511.GI29527@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,


On 05/29/2017 08:55 AM, Sakari Ailus wrote:
> Hi Steve,
>
> A few comments below.
>
> On Wed, May 24, 2017 at 05:29:31PM -0700, Steve Longerbeam wrote:
>> This driver is based on ov5640_mipi.c from Freescale imx_3.10.17_1.0.0_beta
>> branch, modified heavily to bring forward to latest interfaces and code
>> cleanup.
>>
>> Signed-off-by: Steve Longerbeam<steve_longerbeam@mentor.com>
>> ---
>>   drivers/media/i2c/Kconfig  |    9 +
>>   drivers/media/i2c/Makefile |    1 +
>>   drivers/media/i2c/ov5640.c | 2224 ++++++++++++++++++++++++++++++++++++++++++++
>>   3 files changed, 2234 insertions(+)
>>   create mode 100644 drivers/media/i2c/ov5640.c
>>
>> diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
>> index fd181c9..ff082a7 100644
>> --- a/drivers/media/i2c/Kconfig
>> +++ b/drivers/media/i2c/Kconfig
>> @@ -539,6 +539,15 @@ config VIDEO_OV2659
>>   	  To compile this driver as a module, choose M here: the
>>   	  module will be called ov2659.
>>   
>> +config VIDEO_OV5640
>> +	tristate "OmniVision OV5640 sensor support"
>> +	depends on OF
>> +	depends on GPIOLIB && VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
>> +	depends on MEDIA_CAMERA_SUPPORT
>> +	---help---
>> +	  This is a Video4Linux2 sensor-level driver for the Omnivision
>> +	  OV5640 camera sensor with a MIPI CSI-2 interface.
>> +
>>   config VIDEO_OV5645
>>   	tristate "OmniVision OV5645 sensor support"
>>   	depends on OF
>> diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
>> index 62323ec..dc6b0c4 100644
>> --- a/drivers/media/i2c/Makefile
>> +++ b/drivers/media/i2c/Makefile
>> @@ -58,6 +58,7 @@ obj-$(CONFIG_VIDEO_SONY_BTF_MPX) += sony-btf-mpx.o
>>   obj-$(CONFIG_VIDEO_UPD64031A) += upd64031a.o
>>   obj-$(CONFIG_VIDEO_UPD64083) += upd64083.o
>>   obj-$(CONFIG_VIDEO_OV2640) += ov2640.o
>> +obj-$(CONFIG_VIDEO_OV5640) += ov5640.o
>>   obj-$(CONFIG_VIDEO_OV5645) += ov5645.o
>>   obj-$(CONFIG_VIDEO_OV5647) += ov5647.o
>>   obj-$(CONFIG_VIDEO_OV7640) += ov7640.o
>> diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
>> new file mode 100644
>> index 0000000..2a032bc
>> --- /dev/null
>> +++ b/drivers/media/i2c/ov5640.c
>> @@ -0,0 +1,2224 @@
>> +/*
>> + * Copyright (C) 2011-2013 Freescale Semiconductor, Inc. All Rights Reserved.
>> + * Copyright (C) 2014-2017 Mentor Graphics Inc.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License, or
>> + * (at your option) any later version.
>> + */
>> +
>> +#include <linux/clk.h>
>> +#include <linux/clk-provider.h>
>> +#include <linux/clkdev.h>
>> +#include <linux/ctype.h>
>> +#include <linux/delay.h>
>> +#include <linux/device.h>
>> +#include <linux/i2c.h>
>> +#include <linux/init.h>
>> +#include <linux/module.h>
>> +#include <linux/of_device.h>
>> +#include <linux/slab.h>
>> +#include <linux/types.h>
>> +#include <linux/gpio/consumer.h>
>> +#include <linux/regulator/consumer.h>
>> +#include <media/v4l2-async.h>
>> +#include <media/v4l2-ctrls.h>
>> +#include <media/v4l2-device.h>
>> +#include <media/v4l2-of.h>
> Could you rebase this on the V4L2 fwnode patchset here, please?
>
> <URL:https://git.linuxtv.org/sailus/media_tree.git/log/?h=v4l2-acpi>

Once the fwnode patchset hits mediatree, then yes it can be
converted along with all the others under media/i2c.

> <snip>
>
>> +
>> +static int ov5640_write_reg16(struct ov5640_dev *sensor, u16 reg, u16 val)
>> +{
>> +	int ret;
>> +
>> +	ret = ov5640_write_reg(sensor, reg, val >> 8);
>> +	if (ret)
>> +		return ret;
>> +
>> +	return ov5640_write_reg(sensor, reg + 1, val & 0xff);
> Does the sensor datasheet suggest doing this?

Why would the datasheet suggest or not suggest such things?
Coding details like this don't belong in the datasheet.

>   Making the write in two
> transactions will make it non-atomic that could be an issue in some corner
> cases.

It's called everywhere under the same device mutex.


> <snip>
>> +
>> +static int ov5640_set_gain(struct ov5640_dev *sensor, int auto_gain)
>> +{
>> +	struct ov5640_ctrls *ctrls = &sensor->ctrls;
>> +
>> +	if (ctrls->auto_gain->is_new) {
>> +		ov5640_mod_reg(sensor, OV5640_REG_AEC_PK_MANUAL,
>> +			       BIT(1), ctrls->auto_gain->val ? 0 : BIT(1));
> You're generally silently ignoring all I²C access errors. Is that
> intentional?

Yeah, this driver is much cleaned up from the original, but there are
still some issues like this. The register access errors are really only
being paid attention to during s_power() when loading the initial
register set, which is enough at least to catch a non-existent chip
or basic i2c bus or other hardware issues. But I should work on
catching all access errors. This is something I did in an earlier rev
but I used a questionable short-cut to make it easier to implement.
I'll just have to catch every case one by one.


> <snip>
>
>> +
>> +static int ov5640_s_ctrl(struct v4l2_ctrl *ctrl)
>> +{
>> +	struct v4l2_subdev *sd = ctrl_to_sd(ctrl);
>> +	struct ov5640_dev *sensor = to_ov5640_dev(sd);
>> +	int ret = 0;
>> +
>> +	mutex_lock(&sensor->lock);
> Could you use the same lock for the controls as you use for the rest? Just
> setting handler->lock after handler init does the trick.

Can you please rephrase, I don't follow. "same lock for the controls as
you use for the rest" - there's only one device lock owned by this driver
and I am already using that same lock.


> <snip>
>> +
>> +static int ov5640_s_stream(struct v4l2_subdev *sd, int enable)
>> +{
>> +	struct ov5640_dev *sensor = to_ov5640_dev(sd);
>> +	int ret = 0;
>> +
>> +	mutex_lock(&sensor->lock);
>> +
>> +#if defined(CONFIG_MEDIA_CONTROLLER)
>> +	if (sd->entity.stream_count > 1)
> The entity stream_count isn't connected to the number of times s_stream(sd,
> true) is called. Please remove the check.

It's incremented by media_pipeline_start(), even if the entity is already
a member of the given pipeline.

I added this check because in imx-media, the ov5640 can be streaming
concurrently to multiple video capture devices, and each capture device 
calls
media_pipeline_start() at stream on, which increments the entity stream 
count.

So if one capture device issues a stream off while others are still 
streaming,
ov5640 should remain at stream on. So the entity stream count is being
used as a streaming usage counter. Is there a better way to do this? Should
I use a private stream use counter instead?



> <snip>
>
>> +
>> +free_ctrls:
>> +	v4l2_ctrl_handler_free(&sensor->ctrls.handler);
>> +entity_cleanup:
>> +	mutex_destroy(&sensor->lock);
>> +	media_entity_cleanup(&sensor->sd.entity);
>> +	regulator_bulk_disable(OV5640_NUM_SUPPLIES, sensor->supplies);
> Should this still be here?
>
>> +	return ret;
>> +}
>> +
>> +static int ov5640_remove(struct i2c_client *client)
>> +{
>> +	struct v4l2_subdev *sd = i2c_get_clientdata(client);
>> +	struct ov5640_dev *sensor = to_ov5640_dev(sd);
>> +
>> +	regulator_bulk_disable(OV5640_NUM_SUPPLIES, sensor->supplies);
> Ditto.

I don't understand. regulator_bulk_disable() is still needed, am I missing
something?

Steve
