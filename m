Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:43573 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753562AbZFIQzT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Jun 2009 12:55:19 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Tue, 9 Jun 2009 11:55:15 -0500
Subject: RE: [RFC] passing bus/interface parameters from bridge driver to
 sub device
Message-ID: <A69FA2915331DC488A831521EAE36FE4013564FA4E@dlee06.ent.ti.com>
References: <A69FA2915331DC488A831521EAE36FE4013557A8AF@dlee06.ent.ti.com>
 <200906091833.26174.hverkuil@xs4all.nl>
 <A69FA2915331DC488A831521EAE36FE4013564FA48@dlee06.ent.ti.com>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE4013564FA48@dlee06.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some typo corrected....
>-----Original Message-----
>From: linux-media-owner@vger.kernel.org [mailto:linux-media-
>owner@vger.kernel.org] On Behalf Of Karicheri, Muralidharan
>Sent: Tuesday, June 09, 2009 12:51 PM
>To: Hans Verkuil
>Cc: linux-media@vger.kernel.org
>Subject: RE: [RFC] passing bus/interface parameters from bridge driver to
>sub device
>
>
>Hans,
>
>Thanks for looking into this...
>
>>>
>>> 1) I want to use v4l2_i2c_new_probed_subdev_addr() to load and probe the
>>> the v4l2 sub-device from my vpfe capture driver. Currently the api's
>>> available doesn't allow setting platform data in the client before the
>>> sub-device's probe is called. I see that there is discussion about
>adding
>>> i2c_board_info as an argument to the api. I would need this to allow
>>> loading of sub-device from vpfe capture. I have seen patches sent by
>>> Eduardo Valentin & Guennadi Liakhovetski addressing the issue. Do you
>>> have any suggestions for use in my vpfe capture driver?
>>
>>As you have probably seen by now I've made changes to the v4l2 core that
>>make it easy to use an i2c_board_info struct when creating a subdev. So as
>>far as I can tell that solves this issue completely.
>>
>>The code is in my v4l-dvb-subdev tree.
>>
>[MK] Yes. I have been following this and will resolve this.
>>> 2) I need a common structure (preferably in i2c-subdev.h for defining
>and
>>> using bus (interface) parameters in the bridge (vpfe capture) and sub
>>> device (tvp514x or mt9t031) drivers. This will allow bridge driver to
>>> read these values from platform data and set the same in the vpfe
>capture
>>> driver and sub device drivers. Since bus parameters such as interface
>>> type (BT.656, BT.1120, Raw Bayer image data etc), polarity of various
>>> signals etc are used across bridge and sub-devices, it make sense to add
>>> it to i2c-subdev.h. Here is what I have come up with. If this support is
>>> not already planned, I would like to sent a patch for the same.
>>
>>It makes sense to define a struct in v4l2-subdev.h and a core ops to set
>it
>>(s_bus).
>>
>>However, I would pack it differently:
>>
>>struct v4l2_subdev_bus {
>>	enum v4l2_subdev_bus_type type;
>>	u8 width;
>>	unsigned pol_vsync:1;
>>	unsigned pol_hsync:1;
>>	unsigned pol_field:1;
>>	unsigned pol_pclock:1;
>>};
>>
>[MK] Looks good to me. So is it up to the bridge driver and sub devices to
>determine how they interpret the values of pol_xxx fields? Since same sub-
>device might work across multiple bridge drivers, it is worth documenting them >as given in my RFC. I would like to add one more field for data polarity :-
>	unsigned pol_data:1;
>
>Will you take care of this yourself or expecting me to send a patch for the
>same?
>
>Regards,
>Murali
>>It's more concise this way.
>>
>>Regards,
>>
>>	Hans
>>
>>> +/*
>>> + * Some Sub-devices are connected to the bridge device through a bus
>>> + * that carries the clock, vsync, hsync and data. Some interfaces
>>> + * such as BT.656 carries the sync embedded in the data where as others
>>> + * have seperate line carrying the sync signals. This structure is
>>> + * used by bridge driver to set the desired bus parameters in the sub
>>> + * device to work with it.
>>> + */
>>> +enum v4l2_subdev_bus_type {
>>> +	/* BT.656 interface. Embedded syncs */
>>> +	V4L2_SUBDEV_BUS_BT_656,
>>> +	/* BT.1120 interface. Embedded syncs */
>>> +	V4L2_SUBDEV_BUS_BT_1120,
>>> +	/* 8 bit YCbCr muxed bus, separate sync and field id signals */
>>> +	V4L2_SUBDEV_BUS_YCBCR_8,
>>> +	/* 16 bit YCbCr bus, separate sync and field id signals */
>>> +	V4L2_SUBDEV_BUS_YCBCR_16,
>>> +	/* Raw Bayer data bus, 8 - 16 bit wide, sync signals  */
>>> +	V4L2_SUBDEV_BUS_RAW_BAYER
>>> +};
>>> +
>>> +/* Raw bayer data bus width */
>>> +enum v4l2_subdev_raw_bayer_data_width {
>>> +	V4L2_SUBDEV_RAW_BAYER_DATA_8BIT,
>>> +	V4L2_SUBDEV_RAW_BAYER_DATA_9BIT,
>>> +	V4L2_SUBDEV_RAW_BAYER_DATA_10BIT,
>>> +	V4L2_SUBDEV_RAW_BAYER_DATA_11BIT,
>>> +	V4L2_SUBDEV_RAW_BAYER_DATA_12BIT,
>>> +	V4L2_SUBDEV_RAW_BAYER_DATA_13BIT,
>>> +	V4L2_SUBDEV_RAW_BAYER_DATA_14BIT,
>>> +	V4L2_SUBDEV_RAW_BAYER_DATA_15BIT,
>>> +	V4L2_SUBDEV_RAW_BAYER_DATA_16BIT
>>> +};
>>> +
>>> +struct v4l2_subdev_bus_params {
>>> +	/* bus type */
>>> +	enum v4l2_subdev_bus_type type;
>>> +	/* data size for raw bayer data bus */
>>> +	enum v4l2_subdev_raw_bayer_data_width width;
>>> +	/* polarity of vsync. 0 - active low, 1 - active high */
>>> +	u8 vsync_pol;
>>> +	/* polarity of hsync. 0 - active low, 1 - active low */
>>> +	u8 hsync_pol;
>>> +	/* polarity of field id, 0 - low to high, 1 - high to low */
>>> +	u8 fid_pol;
>>> +	/* polarity of data. 0 - active low, 1 - active high */
>>> +	u8 data_pol;
>>> +	/* pclk polarity. 0 - sample at falling edge, 1 - sample at rising
>>edge
>>> */ +	u8 pclk_pol;
>>> +};
>>> +
>>> Murali Karicheri
>>> email: m-karicheri2@ti.com
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-media"
>in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>>
>>--
>>Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
>>--
>>To unsubscribe from this list: send the line "unsubscribe linux-media" in
>>the body of a message to majordomo@vger.kernel.org
>>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

