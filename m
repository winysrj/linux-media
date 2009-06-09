Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:3986 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756108AbZFIVHf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Jun 2009 17:07:35 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: m-karicheri2@ti.com
Subject: Re: [PATCH RFC] adding support for setting bus parameters in sub device
Date: Tue, 9 Jun 2009 23:07:29 +0200
Cc: linux-media@vger.kernel.org,
	davinci-linux-open-source@linux.davincidsp.com,
	Muralidharan Karicheri <a0868495@dal.design.ti.com>
References: <1244580953-24188-1-git-send-email-m-karicheri2@ti.com> <200906092303.01871.hverkuil@xs4all.nl>
In-Reply-To: <200906092303.01871.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906092307.29392.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 09 June 2009 23:03:01 Hans Verkuil wrote:
> On Tuesday 09 June 2009 22:55:53 m-karicheri2@ti.com wrote:
> > From: Muralidharan Karicheri <a0868495@gt516km11.gt.design.ti.com>
> >
> > re-sending with RFC in the header
> >
> > This patch adds support for setting bus parameters such as bus type
> > (BT.656, BT.1120 etc), width (example 10 bit raw image data bus)
> > and polarities (vsync, hsync, field etc) in sub device. This allows
> > bridge driver to configure the sub device for a specific set of bus
> > parameters through s_bus() function call.
> >
> > Reviewed By "Hans Verkuil".
> > Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
> > ---
> > Applies to v4l-dvb repository
> >
> >  include/media/v4l2-subdev.h |   36
> > ++++++++++++++++++++++++++++++++++++ 1 files changed, 36 insertions(+),
> > 0 deletions(-)
> >
> > diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> > index 1785608..c1cfb3b 100644
> > --- a/include/media/v4l2-subdev.h
> > +++ b/include/media/v4l2-subdev.h
> > @@ -37,6 +37,41 @@ struct v4l2_decode_vbi_line {
> >  	u32 type;		/* VBI service type (V4L2_SLICED_*). 0 if no service found
> > */ };
> >
> > +/*
> > + * Some sub-devices are connected to the bridge device through a bus
> > that + * carries * the clock, vsync, hsync and data. Some interfaces
> > such as BT.656 + * carries the sync embedded in the data where as
> > others have separate line + * carrying the sync signals. The structure
> > below is used by bridge driver to + * set the desired bus parameters in
> > the sub device to work with it. + */
> > +enum v4l2_subdev_bus_type {
> > +	/* BT.656 interface. Embedded sync */
> > +	V4L2_SUBDEV_BUS_BT_656,
> > +	/* BT.1120 interface. Embedded sync */
> > +	V4L2_SUBDEV_BUS_BT_1120,
> > +	/* 8 bit muxed YCbCr bus, separate sync and field signals */
> > +	V4L2_SUBDEV_BUS_YCBCR_8,
> > +	/* 16 bit YCbCr bus, separate sync and field signals */
> > +	V4L2_SUBDEV_BUS_YCBCR_16,
>
> Hmm, what do you mean with "8 bit muxed YCbCr bus"? It's not clear to me
> what the format of these YCBCR bus types is exactly.
>
> > +	/* Raw Bayer image data bus , 8 - 16 bit wide, sync signals */
> > +	V4L2_SUBDEV_BUS_RAW_BAYER
> > +};
> > +
> > +struct v4l2_subdev_bus	{
> > +	enum v4l2_subdev_bus_type type;
> > +	u8 width;
> > +	/* 0 - active low, 1 - active high */
> > +	unsigned pol_vsync:1;
> > +	/* 0 - active low, 1 - active high */
> > +	unsigned pol_hsync:1;
> > +	/* 0 - low to high , 1 - high to low */
> > +	unsigned pol_field:1;
> > +	/* 0 - sample at falling edge , 1 - sample at rising edge */
> > +	unsigned pol_pclock:1;
> > +	/* 0 - active low , 1 - active high */
> > +	unsigned pol_data:1;
> > +};
> > +
> >  /* Sub-devices are devices that are connected somehow to the main
> > bridge device. These devices are usually audio/video
> > muxers/encoders/decoders or sensors and webcam controllers.
> > @@ -109,6 +144,7 @@ struct v4l2_subdev_core_ops {
> >  	int (*querymenu)(struct v4l2_subdev *sd, struct v4l2_querymenu *qm);
> >  	int (*s_std)(struct v4l2_subdev *sd, v4l2_std_id norm);
> >  	long (*ioctl)(struct v4l2_subdev *sd, unsigned int cmd, void *arg);
> > +	int (*s_bus)(struct v4l2_subdev *sd, struct v4l2_subdev_bus *bus);
>
> Make this 'const struct v4l2_subdev_bus *bus'.

And move it to the video ops. This op is only relevant for video, after all. 
Yes, I know I said to add it to core initially; so sue me :-)

Regards,

	Hans

>
> >  #ifdef CONFIG_VIDEO_ADV_DEBUG
> >  	int (*g_register)(struct v4l2_subdev *sd, struct v4l2_dbg_register
> > *reg); int (*s_register)(struct v4l2_subdev *sd, struct
> > v4l2_dbg_register *reg);
>
> Regards,
>
> 	Hans



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
