Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:40888 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750906AbZH0HOe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Aug 2009 03:14:34 -0400
Date: Thu, 27 Aug 2009 09:14:36 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans de Goede <j.w.r.degoede@hhs.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC] Pixel format definition on the "image" bus
In-Reply-To: <200908270851.27073.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.0908270857230.4808@axis700.grange>
References: <Pine.LNX.4.64.0908261452460.7670@axis700.grange>
 <200908270851.27073.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 27 Aug 2009, Hans Verkuil wrote:

> On Wednesday 26 August 2009 16:39:16 Guennadi Liakhovetski wrote:
> > Hi all
> > 
> > With the ability to arbitrarily combine (video) data sources and sinks we 
> > have to be able to suitably configure both parties. This includes setting 
> > bus parameters, which is discussed elsewhere, and selecting a data format, 
> > which is discussed in this RFC.
> > 
> > Video data, coming from a source (e.g., a camera sensor) to a sink (e.g., 
> > a bridge) can be processed in two ways: (1) as raw data, and (2) as 
> > formatted data.
> > 
> > Definition 1: Raw Data Sampling means storing frames, consisting of a 
> > certain number of lines, consisting of a certain number of samples (which 
> > may or may not represent pixels) in memory. Each sample contains a certain 
> > number of bits of useful information, multiple samples can be packed 
> > together according to some rule.
> > 
> > In case (1) the sink has no specific knowledge about the format, so it can 
> > only sample data on its data bus and store it in memory in some specific 
> > manner. This "manner" is completely defined by the following three 
> > parameters: (a) how many bits are sampled, (b) in which order they will be 
> > stored in memory, (c) how samples have to be packed. To provide such "raw" 
> > data to the user the bridge driver also has to know what format the data 
> > represents if stored in memory as required by the source.
> > 
> > In case (2) the sink "knows" this specific format and can handle it 
> > accordingly, e.g., convert to some other format.
> > 
> > It is therefore proposed to describe a data format on-the-bus using the 
> > following parameters:
> > 
> > enum V4L2_DATA_PACKING {
> > 	V4L2_DATA_PACKING_NONE	= 0,
> > };
> > 
> > enum V4L2_DATA_ORDER {
> > 	V4L2_DATA_ORDER_LE	= 0,
> > 	V4L2_DATA_ORDER_BE	= 1,
> > };
> > 
> > /**
> >  * struct v4l2_subdev_bus_pixelfmt - Data format on the image bus
> >  * @sourceformat:	Format identification for sinks, capable to process this
> >  *			specific format
> >  * @pixelformat:	Fourcc code...
> >  * @colorspace:		and colorspace, that will be obtained if the data is
> >  *			stored in memory in the following way:
> >  * @bits_per_sample:	How many bits the bridge has to sample
> >  * @packing:		Type of sample-packing, that has to be used
> >  * @order:		Sample order when storing in memory
> >  */
> > struct v4l2_subdev_bus_pixelfmt {
> > 	u32			sourceformat;
> > 	u32			pixelformat;
> > 	enum v4l2_colorspace	colorspace;
> > 	int			index;
> > 	u8			bits_per_sample;
> > 	enum V4L2_DATA_PACKING	packing;
> > 	enum V4L2_DATA_ORDER	order;
> > };
> > 
> > The .sourceformat field above is a new enumeration, similar to currently 
> > defined in include/linux/videodev2.h fourcc codes, but combining the 
> > fourcc, bits-per-sample, packing and order information in one. If an 
> > existing Fourcc code already uniquely defines this combination, the new 
> > code might coincide with it. In principle, this code is redundant, because 
> > the data format is completely described by the "raw" parameters, but it 
> > can be useful for some (simple) source-sink combinations.
> > 
> > The sink driver can then use the following new method from struct 
> > v4l2_subdev_video_ops:
> > 
> > int (*enum_bus_pixelfmt)(struct v4l2_subdev *sd,
> > 			 const struct v4l2_subdev_bus_pixelfmt **fmt);
> > 
> > to enumerate formats, provided by the source and to decide, which of them 
> > it can support in raw mode, which as formatted data, and which of them it 
> > cannot support at all, e.g., because it does not support the requested 
> > packing type. This enumeration can either take place upon reception of a 
> > S_FMT ioctl, or during probing to build a list of formats, that this 
> > specific source-sink pair can provide to the user.
> > 
> > Comments welcome.
> 
> Hi Guennadi,
> 
> This seems way too complicated to me. The original approach you took in
> soc_camera (just a fourcc code and the colorspace) seems fine to me (and
> colorspace is probably not even needed). The sensor supports X formats, the
> sink supports Y sensor formats and knows how to map those to the actual
> formats as are returned by VIDIOC_ENUM_FMT. So a pointer to a list of supported
> fourcc codes is probably all you need.

Unfortunately, even the current soc-camera approach with its 
format-enumeration and -conversion API is not enough. As I explained 
above, there are two ways you can handle source's data: "cooked" and 
"raw." The "cooked" way is simple - the sink knows exactly this specific 
format and knows how to deal with it. Every sink has a final number of 
such natively supported formats, so, that's just a switch-case statement 
in each sink driver, that is specific to each sink hardware, and that you 
cannot avoid.

It's the "raw" or "pass-through" mode that is difficult. It is used, when 
the sink does not have any specific knowledge about this format, but can 
pack data into RAM in some way, or, hopefully, in a number of ways, among 
which we can choose. The source "knows" what data it is delivering, and, 
in principle, how this data has to be packed in RAM to provide some 
meaningful user format. Now, we have to pass this information on to the 
sink driver to tell it "if you configure the source to deliver the raw 
format X, and then configure your bus in a way Y and pack the data into 
RAM in a way Z, you get as RAM user format W." So, my proposal is - during 
probing, the sink enumerates all raw formats, provided by the source, 
accepts those formats, that it can process natively ("cooked" mode), and 
verifies if it can be configured to bus configuration Y and can perform 
packing Z, if so, it adds format W to the list of supported formats. Do 
you see an easier way to do this? I'm currently trying to port one driver 
combination to this scheme, I'll post a patch, hopefully, later today.

> But I also have other questions that need to be answered:
> 
> 1) Isn't there a relationship between the supported sensor formats and the
> bus configuration? E.g. the davinci dm646x has two bus modes on its capture
> port: either embedded syncs or separate syncs. Depending on the mode it can
> capture different formats.

Yes, sure, the sink driver has to check, if it supports bus configuration 
"Y" - see above.

> 2) What will the relationship be between this functionality and how the
> enum/try/g/s_fmt subdev ops are currently used? Perhaps we should switch
> everything over to this new API? I think there are only three subdev drivers
> that use these fmt ops, so it wouldn't be too hard to change them if we decide
> to do so.

Yes, I think so.

> I'm definitely going to think about this some more when I work on the bus
> config RFC this weekend.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
