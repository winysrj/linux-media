Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:40065 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753929AbZFJPNS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Jun 2009 11:13:18 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	Muralidharan Karicheri <a0868495@dal.design.ti.com>
Date: Wed, 10 Jun 2009 10:13:13 -0500
Subject: RE: [PATCH RFC] adding support for setting bus parameters in sub
 device
Message-ID: <A69FA2915331DC488A831521EAE36FE40139A08B16@dlee06.ent.ti.com>
References: <1244580953-24188-1-git-send-email-m-karicheri2@ti.com>
 <200906092303.01871.hverkuil@xs4all.nl>
 <200906092307.29392.hverkuil@xs4all.nl>
In-Reply-To: <200906092307.29392.hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


>> >
>> > +/*
>> > + * Some sub-devices are connected to the bridge device through a bus
>> > that + * carries * the clock, vsync, hsync and data. Some interfaces
>> > such as BT.656 + * carries the sync embedded in the data where as
>> > others have separate line + * carrying the sync signals. The structure
>> > below is used by bridge driver to + * set the desired bus parameters in
>> > the sub device to work with it. + */
>> > +enum v4l2_subdev_bus_type {
>> > +	/* BT.656 interface. Embedded sync */
>> > +	V4L2_SUBDEV_BUS_BT_656,
>> > +	/* BT.1120 interface. Embedded sync */
>> > +	V4L2_SUBDEV_BUS_BT_1120,
>> > +	/* 8 bit muxed YCbCr bus, separate sync and field signals */
>> > +	V4L2_SUBDEV_BUS_YCBCR_8,
>> > +	/* 16 bit YCbCr bus, separate sync and field signals */
>> > +	V4L2_SUBDEV_BUS_YCBCR_16,
>>
>> Hmm, what do you mean with "8 bit muxed YCbCr bus"? It's not clear to me
>> what the format of these YCBCR bus types is exactly.
>>
[MK]I spent sometime yesterday looking at different interfaces that we support in our soc. Here is the list...
BT.656, which is 8 bit or 10 bit multiplexed YCbCr bus
BT.1120, which is 16 bit or 20 bit YCbCr bus
YUV bus with separate sync signals (hsync, vsync and field)which could be 8 bit, 10 bit, 16 bit and 20 bit
Since BT_656 & BT_1120 also carries YUV data, we could call them  as YUV bus. So we can classify bus type based on the type of data it carries as below..

enum v4l2_subdev_bus_type {
	/* Raw YUV image data bus, such as BT.656, BT.1120, or with
	 * separate sync
	 */
	V4L2_SUBDEV_BUS_RAW_YUV,
      /* Raw Bayer image data bus , 8 - 16 bit wide, sync signals */
	V4L2_SUBDEV_BUS_RAW_BAYER
};

Since we have width to describe the bus size, we could define all of the above bus types using above bus types and width. In addition we could add another Boolean to describe if sync is sent embedded or separate as below.
Just want to do it right. If anyone has any comments about the classification, please reply. I will sent an updated patch soon.....

>> > +
>> > +struct v4l2_subdev_bus	{
>> > +	enum v4l2_subdev_bus_type type;
>> > +	u8 width;
		unsigned embedded_sync:1;
>> > +	/* 0 - active low, 1 - active high */
>> > +	unsigned pol_vsync:1;
>> > +	/* 0 - active low, 1 - active high */
>> > +	unsigned pol_hsync:1;
>> > +	/* 0 - low to high , 1 - high to low */
>> > +	unsigned pol_field:1;
>> > +	/* 0 - sample at falling edge , 1 - sample at rising edge */
>> > +	unsigned pol_pclock:1;
>> > +	/* 0 - active low , 1 - active high */
>> > +	unsigned pol_data:1;
>> > +};
>> > +
>> >  /* Sub-devices are devices that are connected somehow to the main
>> > bridge device. These devices are usually audio/video
>> > muxers/encoders/decoders or sensors and webcam controllers.
>> > @@ -109,6 +144,7 @@ struct v4l2_subdev_core_ops {
>> >  	int (*querymenu)(struct v4l2_subdev *sd, struct v4l2_querymenu *qm);
>> >  	int (*s_std)(struct v4l2_subdev *sd, v4l2_std_id norm);
>> >  	long (*ioctl)(struct v4l2_subdev *sd, unsigned int cmd, void *arg);
>> > +	int (*s_bus)(struct v4l2_subdev *sd, struct v4l2_subdev_bus *bus);
>>
>> Make this 'const struct v4l2_subdev_bus *bus'.
>
>And move it to the video ops. This op is only relevant for video, after all.
>Yes, I know I said to add it to core initially; so sue me :-)
>
>Regards,
>
>	Hans
>
>>
>> >  #ifdef CONFIG_VIDEO_ADV_DEBUG
>> >  	int (*g_register)(struct v4l2_subdev *sd, struct v4l2_dbg_register
>> > *reg); int (*s_register)(struct v4l2_subdev *sd, struct
>> > v4l2_dbg_register *reg);
>>
>> Regards,
>>
>> 	Hans
>
>
>
>--
>Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

