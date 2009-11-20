Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:1526 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208AbZKTM3M (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Nov 2009 07:29:12 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH/RFC 7/9 v2] v4l: add an image-bus API for configuring v4l2 subdev pixel and frame formats
Date: Fri, 20 Nov 2009 13:29:10 +0100
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Muralidharan Karicheri <m-karicheri2@ti.com>
References: <Pine.LNX.4.64.0910301338140.4378@axis700.grange> <200911151723.59743.hverkuil@xs4all.nl> <Pine.LNX.4.64.0911192213100.6767@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0911192213100.6767@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911201329.10963.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 19 November 2009 23:33:22 Guennadi Liakhovetski wrote:
> Hi Hans
>
> On Sun, 15 Nov 2009, Hans Verkuil wrote:
>
> [snip]
>
> > > > > +s32 v4l2_imgbus_bytes_per_line(u32 width,
> > > > > +			       const struct v4l2_imgbus_pixelfmt *imgf)
> > > > > +{
> > > > > +	switch (imgf->packing) {
> > > > > +	case V4L2_IMGBUS_PACKING_NONE:
> > > > > +		return width * imgf->bits_per_sample / 8;
> > > > > +	case V4L2_IMGBUS_PACKING_2X8_PADHI:
> > > > > +	case V4L2_IMGBUS_PACKING_2X8_PADLO:
> > > > > +	case V4L2_IMGBUS_PACKING_EXTEND16:
> > > > > +		return width * 2;
> > > > > +	}
> > > > > +	return -EINVAL;
> > > > > +}
> > > > > +EXPORT_SYMBOL(v4l2_imgbus_bytes_per_line);
> > > >
> > > > As you know, I am not convinced that this code belongs in the core.
> > > > I do not think this translation from IMGBUS to PIXFMT is generic
> > > > enough. However, if you just make this part of soc-camera then I am
> > > > OK with this.
> > >
> > > Are you referring to a specific function like
> > > v4l2_imgbus_bytes_per_line or to the whole v4l2-imagebus.c?
> >
> > I'm referring to the whole file.
> >
> > > The whole file and the
> > > v4l2_imgbus_get_fmtdesc() function must be available to all drivers,
> > > not just to soc-camera, if we want to use {enum,g,s,try}_imgbus_fmt
> > > API in other drivers too, and we do want to use them, if we want to
> > > re-use client drivers.
> >
> > The sub-device drivers do not need this source. They just need to
> > report the supported image bus formats. And I am far from convinced
> > that other bridge drivers can actually reuse your v4l2-imagebus.c code.
>
> You mean, all non-soc-camera bridge drivers only handle special client
> formats, no generic pass-through?

That's correct. It's never been a problem until now. Usually the format is
fixed, so there is nothing to configure.

> What about other SoC v4l host drivers, 
> not using soc-camera, and willing to switch to v4l2-subdev? Like OMAPs,
> etc? I'm sure they would want to be able to use the pass-through mode

And if they can reuse your code, then we will rename it to v4l2-busimage.c

But I have my doubts about that. I don't like that code, but I also don't 
have the time to think about a better alternative. As long as it is
soc-camera specific, then I don't mind. And if omap3 can reuse it, then I 
clearly was wrong and we can rename it and make it part of the core 
framework.

> > If they can, then we can always rename it from e.g. soc-imagebus.c to
> > v4l2-imagebus.c. Right now I prefer to keep it inside soc-camera where
> > is clearly does work and when other people start implementing imagebus
> > support, then we can refer them to the work you did in soc-camera and
> > we'll see what happens.
>
> You know how it happens - some authors do not know about some hidden
> code, during the review noone realises, that they are re-implementing
> that... Eventually you end up with duplicated customised sub-optimal
> code. Fresh example - the whole soc-camera framework:-) I only learned
> about int-device after soc-camera has already been submitted in its
> submission form. And I did ask on lists whether there was any code for
> such systems:-)

All the relevant omap developers are CC-ed in this discussion, and I'm also 
paying fairly close attention to anything SoC related.

> I do not quite understand what disturbs you about making this API global.
> It is a completely internal API - no exposure to user-space. We can
> modify or remove it any time.
>
> Then think about wider exposure, testing. If you like we can make it a
> separate module and make soc-camera select it. And we can always degrade
> it back to soc-camera-specific:-)

Making this API global means that it becomes part of the framework. And I 
want to pay a lot more attention to that code than we did in the past. So I 
have to be convinced that it is code that is really reusable by other 
drivers. And I am not convinced about that. Since I know omap3 will need 
this soon, I want to wait for their experiences with your code before 
making this part of the framework.

> > > > One other comment to throw into the pot: what about calling this
> > > > just V4L2_BUS_FMT...? So imgbus becomes just bus. For some reason I
> > > > find imgbus a bit odd. Probably because I think of it more as a
> > > > video bus or even as a more general data bus. For all I know it
> > > > might be used in the future to choose between different types of
> > > > histogram data or something like that.
> > >
> > > It might well be not the best namespace choice. But just "bus" OTOH
> > > seems way too generic to me. Maybe some (multi)mediabus? Or is even
> > > that too generic? It certainly depends on the scope which we foresee
> > > for this API.
> >
> > Hmm, I like that: 'mediabus'. Much better IMHO than imagebus. Image bus
> > is too specific to sensor, I think. Media bus is more generic (also for
> > video and audio formats), but it still clearly refers to the media data
> > flowing over the bus rather than e.g. control data.
>
> Well, do we really think it might ever become relevant for audio? We're
> having problems adopting it generically for video even:-)

Or VBI data, or whatever we might need in the future that is related to 
media.

> > > > > +	V4L2_IMGBUS_FMT_YUYV,
> > > > > +	V4L2_IMGBUS_FMT_YVYU,
> > > > > +	V4L2_IMGBUS_FMT_UYVY,
> > > > > +	V4L2_IMGBUS_FMT_VYUY,
> > > > > +	V4L2_IMGBUS_FMT_VYUY_SMPTE170M_8,
> > > > > +	V4L2_IMGBUS_FMT_VYUY_SMPTE170M_16,
> > > > > +	V4L2_IMGBUS_FMT_RGB555,
> > > > > +	V4L2_IMGBUS_FMT_RGB555X,
> > > > > +	V4L2_IMGBUS_FMT_RGB565,
> > > > > +	V4L2_IMGBUS_FMT_RGB565X,
> > > > > +	V4L2_IMGBUS_FMT_SBGGR8,
> > > > > +	V4L2_IMGBUS_FMT_SGBRG8,
> > > > > +	V4L2_IMGBUS_FMT_SGRBG8,
> > > > > +	V4L2_IMGBUS_FMT_SRGGB8,
> > > > > +	V4L2_IMGBUS_FMT_SBGGR10,
> > > > > +	V4L2_IMGBUS_FMT_SGBRG10,
> > > > > +	V4L2_IMGBUS_FMT_SGRBG10,
> > > > > +	V4L2_IMGBUS_FMT_SRGGB10,
> > > > > +	V4L2_IMGBUS_FMT_GREY,
> > > > > +	V4L2_IMGBUS_FMT_Y16,
> > > > > +	V4L2_IMGBUS_FMT_Y10,
> > > > > +	V4L2_IMGBUS_FMT_SBGGR10_2X8_PADHI_BE,
> > > > > +	V4L2_IMGBUS_FMT_SBGGR10_2X8_PADLO_BE,
> > > > > +	V4L2_IMGBUS_FMT_SBGGR10_2X8_PADHI_LE,
> > > > > +	V4L2_IMGBUS_FMT_SBGGR10_2X8_PADLO_LE,
> > > >
> > > > Obviously the meaning of these formats need to be documented in
> > > > this header as well. Are all these imgbus formats used? Anything
> > > > that is not used shouldn't be in this list IMHO.
> > >
> > > A few of them are, yes, some might not actually be used yes, but have
> > > been added for completenes. We can have a better look at them and
> > > maybe throw a couple of them away, yes.
> > >
> > > Document - yes. But, please, under linux/Documentation/video4linux/.
> >
> > The problem is that people will forget to add it to the documentation
> > when they add new formats. We have that problem already with PIXFMT,
> > and there you actually get an error or warning when building the
> > documentation.
> >
> > I think that the chances of keeping the documentation up to date are
> > much higher if we document it at the same place that these formats are
> > defined.
>
> Ah, you mean docbook in the code - sure, better yet. I meant in the
> kernel as opposed to the hg documentation collection.
>
> > > > > +};
> > > > > +
> > > > > +/**
> > > > > + * struct v4l2_imgbus_pixelfmt - Data format on the image bus
> > > > > + * @fourcc:		Fourcc code...
> > > > > + * @colorspace:		and colorspace, that will be obtained if the
> > > > > data is + *			stored in memory in the following way:
> > > > > + * @bits_per_sample:	How many bits the bridge has to sample
> > > > > + * @packing:		Type of sample-packing, that has to be used
> > > > > + * @order:		Sample order when storing in memory
> > > > > + */
> > > > > +struct v4l2_imgbus_pixelfmt {
> > > > > +	u32				fourcc;
> > > > > +	enum v4l2_colorspace		colorspace;
> > > > > +	const char			*name;
> > > > > +	enum v4l2_imgbus_packing	packing;
> > > > > +	enum v4l2_imgbus_order		order;
> > > > > +	u8				bits_per_sample;
> > > > > +};
> > > >
> > > > Ditto for this struct. Note that the colorspace field should be
> > > > moved to imgbus_framefmt.
> > >
> > > Hm, not sure. Consider a simple scenario: user issues S_FMT. Host
> > > driver cannot handle that pixel-format in a "special" way, so, it
> > > goes for "pass-through," so it has to find an enum
> > > v4l2_imgbus_pixelcode value, from which it can generate the requested
> > > pixel-format _and_ colorspace. To do that it scans the internal
> > > pixel/data format translation table to look for the specific
> > > pixel-format and colorspace value, and issues s_imgbus_fmt to the
> > > client with the respective pixelcode.
> > >
> > > Of course, this could ylso be done differently. In fact, I just do
> > > not know what client drivers know about colorspaces. Are they fixed
> > > per data format, and thus also uniquely defined by the latter? If so,
> > > no client-visible struct needs it. If some pixelcodes can exist with
> > > different colorspaces, then yes, we might want to pass the colorspace
> > > with s_imgbus_fmt in struct v4l2_imgbus_framefmt instead of
> > > allocating separate pixelcodes for them.
> >
> > Yes, some video devices have image bus formats that can deliver
> > different colorspaces. For example, HDMI receivers will typically get
> > information of the colorspace as part of the datastream. So the same
> > YCbCr bus format might use either the ITU601 or ITU709 colorspace.
> >
> > Typically for receivers calling g_imgbus_fmt() will return the
> > colorspace it currently receives but it will ignore any attempt to set
> > the colorspace.
> >
> > When programming a HDMI transmitter you will typically have to provide
> > the colorspace when you set the format since it needs that information
> > to fill in the colorspace information that it will generate in the
> > datastream.
> >
> > What is not needed is that you attempt to match a pixelformat to a
> > busformat and colorspace pair. You can ignore the colorspace for that.
>
> Ok, thanks, I'll change that.

We are really almost there: rename imgbus to mediabus and rename to 
v4l2-imagebus.c to soc-mediabus.c (which we might change back in the 
future). It would be really nice to get this in for 2.6.33.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
