Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:49071 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752830AbZFIVU0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Jun 2009 17:20:26 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	Muralidharan Karicheri <a0868495@dal.design.ti.com>
Date: Tue, 9 Jun 2009 16:20:21 -0500
Subject: RE: [PATCH RFC] adding support for setting bus parameters in sub
 device
Message-ID: <A69FA2915331DC488A831521EAE36FE4013564FCA0@dlee06.ent.ti.com>
References: <1244580953-24188-1-git-send-email-m-karicheri2@ti.com>
 <200906092303.01871.hverkuil@xs4all.nl>
In-Reply-To: <200906092303.01871.hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


email: m-karicheri2@ti.com

>-----Original Message-----
>From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
>Sent: Tuesday, June 09, 2009 5:03 PM
>To: Karicheri, Muralidharan
>Cc: linux-media@vger.kernel.org; davinci-linux-open-
>source@linux.davincidsp.com; Muralidharan Karicheri
>Subject: Re: [PATCH RFC] adding support for setting bus parameters in sub
>device
>
>On Tuesday 09 June 2009 22:55:53 m-karicheri2@ti.com wrote:
>> From: Muralidharan Karicheri <a0868495@gt516km11.gt.design.ti.com>
>>
>> re-sending with RFC in the header
>>
>> This patch adds support for setting bus parameters such as bus type
>> (BT.656, BT.1120 etc), width (example 10 bit raw image data bus)
>> and polarities (vsync, hsync, field etc) in sub device. This allows
>> bridge driver to configure the sub device for a specific set of bus
>> parameters through s_bus() function call.
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
>service found
>> */ };
>>
>> +/*
>> + * Some sub-devices are connected to the bridge device through a bus
>> that + * carries * the clock, vsync, hsync and data. Some interfaces such
>> as BT.656 + * carries the sync embedded in the data where as others have
>> separate line + * carrying the sync signals. The structure below is used
>> by bridge driver to + * set the desired bus parameters in the sub device
>> to work with it. + */
>> +enum v4l2_subdev_bus_type {
>> +	/* BT.656 interface. Embedded sync */
>> +	V4L2_SUBDEV_BUS_BT_656,
>> +	/* BT.1120 interface. Embedded sync */
>> +	V4L2_SUBDEV_BUS_BT_1120,
>> +	/* 8 bit muxed YCbCr bus, separate sync and field signals */
>> +	V4L2_SUBDEV_BUS_YCBCR_8,
>> +	/* 16 bit YCbCr bus, separate sync and field signals */
>> +	V4L2_SUBDEV_BUS_YCBCR_16,
>
>Hmm, what do you mean with "8 bit muxed YCbCr bus"? It's not clear to me
>what the format of these YCBCR bus types is exactly.
>
[MK] For YCbCr16, there is separate bus to carry Y and CbCr data, where as on YCbCr8, both gets multiplexed over same 8 bit bus (Y, Cb, Y, Cr, Y, Cb.... The difference between V4L2_SUBDEV_BUS_BT_656 and V4L2_SUBDEV_BUS_YCBCR_8 is that sync is embedded with data in the former, where as there is dedicated sync lines for the latter.
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
>> muxers/encoders/decoders or sensors and webcam controllers.
>> @@ -109,6 +144,7 @@ struct v4l2_subdev_core_ops {
>>  	int (*querymenu)(struct v4l2_subdev *sd, struct v4l2_querymenu *qm);
>>  	int (*s_std)(struct v4l2_subdev *sd, v4l2_std_id norm);
>>  	long (*ioctl)(struct v4l2_subdev *sd, unsigned int cmd, void *arg);
>> +	int (*s_bus)(struct v4l2_subdev *sd, struct v4l2_subdev_bus *bus);
>
>Make this 'const struct v4l2_subdev_bus *bus'.
>
Ok.
>>  #ifdef CONFIG_VIDEO_ADV_DEBUG
>>  	int (*g_register)(struct v4l2_subdev *sd, struct v4l2_dbg_register
>> *reg); int (*s_register)(struct v4l2_subdev *sd, struct v4l2_dbg_register
>> *reg);
>
>Regards,
>
>	Hans
>
>--
>Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

