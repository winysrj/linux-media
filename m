Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:54356 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752363AbZFJU2T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Jun 2009 16:28:19 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	Muralidharan Karicheri <a0868495@dal.design.ti.com>
Date: Wed, 10 Jun 2009 15:28:14 -0500
Subject: RE: [PATCH] adding support for setting bus parameters in sub device
Message-ID: <A69FA2915331DC488A831521EAE36FE40139A08DC3@dlee06.ent.ti.com>
References: <1244580891-24153-1-git-send-email-m-karicheri2@ti.com>
 <Pine.LNX.4.64.0906102022320.4817@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0906102022320.4817@axis700.grange>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi,

Thanks for responding. I acknowledge I need to add
master & slave information in the structure. Querying
the capabilities from the sub device is a good feature.
I will look into your references and let you know if I
have any question.

I will send an updated patch based on this.

BTW, I have a question about the mt9t031.c driver. Could
I use this driver to stream VGA frames from the sensor?
Is it possible to configure the driver to stream at a
specific fps? We have a version of the driver used internally
and it can do capture and stream of Bayer RGB data at VGA,
480p, 576p and 720p resolutions. I have started integrating
your driver with my vpfe capture driver and it wasn't very
clear to me. Looks like driver calculates the timing parameters
based on the width and height of the capture area. We need
streaming capability in the driver. This is how our driver works
with mt9t031 sensor
		  raw-bus (10 bit)
vpfe-capture  ----------------- mt9t031 driver
	  |					   |
	  V				         V
	VPFE	 				MT9T031

VPFE hardware has internal timing and DMA controller to
copy data frame by frame from the sensor output to SDRAM.
The PCLK form the sensor is used to generate the internal
timing.

Thanks.

Murali
email: m-karicheri2@ti.com

>-----Original Message-----
>From: Guennadi Liakhovetski [mailto:g.liakhovetski@gmx.de]
>Sent: Wednesday, June 10, 2009 2:32 PM
>To: Karicheri, Muralidharan
>Cc: linux-media@vger.kernel.org; davinci-linux-open-
>source@linux.davincidsp.com; Muralidharan Karicheri
>Subject: Re: [PATCH] adding support for setting bus parameters in sub
>device
>
>On Tue, 9 Jun 2009, m-karicheri2@ti.com wrote:
>
>> From: Muralidharan Karicheri <a0868495@gt516km11.gt.design.ti.com>
>>
>> This patch adds support for setting bus parameters such as bus type
>> (BT.656, BT.1120 etc), width (example 10 bit raw image data bus)
>> and polarities (vsync, hsync, field etc) in sub device. This allows
>> bridge driver to configure the sub device for a specific set of bus
>> parameters through s_bus() function call.
>
>Yes, this is required, but this is not enough. Firstly, you're missing at
>least one more flag - master or slave. Secondly, it is not enough to
>provide a s_bus function. Many hosts and sensors can configure one of
>several alternate configurations - they can select signal polarities, data
>widths, master / slave role, etc. Whereas others have some or all of these
>parameters fixed. That's why we have a query method in soc-camera, which
>delivers all supported configurations, and then the host can select some
>mutually acceptable subset. No, just returning an error code is not
>enough.
>
>So, you would need to request supported flags, the sensor would return a
>bitmask, and the host would then issue a s_bus call with a selected subset
>and configure itself. And then you realise, that one bit per parameter is
>not enough - you need a bit for both, e.g., vsync active low and active
>high.
>
>Have a look at
>include/media/soc_camera.h::soc_camera_bus_param_compatible() and macros
>defined there, then you might want to have a look at
>drivers/media/video/pxa_camera.c::pxa_camera_set_bus_param() to see how
>the whole machinery works. And you also want inverter flags, see
>drivers/media/video/soc_camera.c::soc_camera_apply_sensor_flags().
>
>So, this is a step in the right direction, but it doesn't seem final yet.
>
>Thanks
>Guennadi
>
>>
>> Reviewed By "Hans Verkuil".
>> Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
>> ---
>> Applies to v4l-dvb repository
>>
>>  include/media/v4l2-subdev.h |   36 ++++++++++++++++++++++++++++++++++++
>>  1 files changed, 36 insertions(+), 0 deletions(-)
>>
>> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
>> index 1785608..c1cfb3b 100644
>> --- a/include/media/v4l2-subdev.h
>> +++ b/include/media/v4l2-subdev.h
>> @@ -37,6 +37,41 @@ struct v4l2_decode_vbi_line {
>>  	u32 type;		/* VBI service type (V4L2_SLICED_*). 0 if no
>service found */
>>  };
>>
>> +/*
>> + * Some sub-devices are connected to the bridge device through a bus
>that
>> + * carries * the clock, vsync, hsync and data. Some interfaces such as
>BT.656
>> + * carries the sync embedded in the data where as others have separate
>line
>> + * carrying the sync signals. The structure below is used by bridge
>driver to
>> + * set the desired bus parameters in the sub device to work with it.
>> + */
>> +enum v4l2_subdev_bus_type {
>> +	/* BT.656 interface. Embedded sync */
>> +	V4L2_SUBDEV_BUS_BT_656,
>> +	/* BT.1120 interface. Embedded sync */
>> +	V4L2_SUBDEV_BUS_BT_1120,
>> +	/* 8 bit muxed YCbCr bus, separate sync and field signals */
>> +	V4L2_SUBDEV_BUS_YCBCR_8,
>> +	/* 16 bit YCbCr bus, separate sync and field signals */
>> +	V4L2_SUBDEV_BUS_YCBCR_16,
>> +	/* Raw Bayer image data bus , 8 - 16 bit wide, sync signals */
>> +	V4L2_SUBDEV_BUS_RAW_BAYER
>> +};
>> +
>> +struct v4l2_subdev_bus	{
>> +	enum v4l2_subdev_bus_type type;
>> +	u8 width;
>> +	/* 0 - active low, 1 - active high */
>> +	unsigned pol_vsync:1;
>> +	/* 0 - active low, 1 - active high */
>> +	unsigned pol_hsync:1;
>> +	/* 0 - low to high , 1 - high to low */
>> +	unsigned pol_field:1;
>> +	/* 0 - sample at falling edge , 1 - sample at rising edge */
>> +	unsigned pol_pclock:1;
>> +	/* 0 - active low , 1 - active high */
>> +	unsigned pol_data:1;
>> +};
>> +
>>  /* Sub-devices are devices that are connected somehow to the main bridge
>>     device. These devices are usually audio/video
>muxers/encoders/decoders or
>>     sensors and webcam controllers.
>> @@ -109,6 +144,7 @@ struct v4l2_subdev_core_ops {
>>  	int (*querymenu)(struct v4l2_subdev *sd, struct v4l2_querymenu *qm);
>>  	int (*s_std)(struct v4l2_subdev *sd, v4l2_std_id norm);
>>  	long (*ioctl)(struct v4l2_subdev *sd, unsigned int cmd, void *arg);
>> +	int (*s_bus)(struct v4l2_subdev *sd, struct v4l2_subdev_bus *bus);
>>  #ifdef CONFIG_VIDEO_ADV_DEBUG
>>  	int (*g_register)(struct v4l2_subdev *sd, struct v4l2_dbg_register
>*reg);
>>  	int (*s_register)(struct v4l2_subdev *sd, struct v4l2_dbg_register
>*reg);
>> --
>> 1.6.0.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
>---
>Guennadi Liakhovetski, Ph.D.
>Freelance Open-Source Software Developer
>http://www.open-technology.de/

