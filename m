Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:55079 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750747AbZHZOjF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Aug 2009 10:39:05 -0400
Date: Wed, 26 Aug 2009 16:39:16 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Hans de Goede <j.w.r.degoede@hhs.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [RFC] Pixel format definition on the "image" bus
Message-ID: <Pine.LNX.4.64.0908261452460.7670@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all

With the ability to arbitrarily combine (video) data sources and sinks we 
have to be able to suitably configure both parties. This includes setting 
bus parameters, which is discussed elsewhere, and selecting a data format, 
which is discussed in this RFC.

Video data, coming from a source (e.g., a camera sensor) to a sink (e.g., 
a bridge) can be processed in two ways: (1) as raw data, and (2) as 
formatted data.

Definition 1: Raw Data Sampling means storing frames, consisting of a 
certain number of lines, consisting of a certain number of samples (which 
may or may not represent pixels) in memory. Each sample contains a certain 
number of bits of useful information, multiple samples can be packed 
together according to some rule.

In case (1) the sink has no specific knowledge about the format, so it can 
only sample data on its data bus and store it in memory in some specific 
manner. This "manner" is completely defined by the following three 
parameters: (a) how many bits are sampled, (b) in which order they will be 
stored in memory, (c) how samples have to be packed. To provide such "raw" 
data to the user the bridge driver also has to know what format the data 
represents if stored in memory as required by the source.

In case (2) the sink "knows" this specific format and can handle it 
accordingly, e.g., convert to some other format.

It is therefore proposed to describe a data format on-the-bus using the 
following parameters:

enum V4L2_DATA_PACKING {
	V4L2_DATA_PACKING_NONE	= 0,
};

enum V4L2_DATA_ORDER {
	V4L2_DATA_ORDER_LE	= 0,
	V4L2_DATA_ORDER_BE	= 1,
};

/**
 * struct v4l2_subdev_bus_pixelfmt - Data format on the image bus
 * @sourceformat:	Format identification for sinks, capable to process this
 *			specific format
 * @pixelformat:	Fourcc code...
 * @colorspace:		and colorspace, that will be obtained if the data is
 *			stored in memory in the following way:
 * @bits_per_sample:	How many bits the bridge has to sample
 * @packing:		Type of sample-packing, that has to be used
 * @order:		Sample order when storing in memory
 */
struct v4l2_subdev_bus_pixelfmt {
	u32			sourceformat;
	u32			pixelformat;
	enum v4l2_colorspace	colorspace;
	int			index;
	u8			bits_per_sample;
	enum V4L2_DATA_PACKING	packing;
	enum V4L2_DATA_ORDER	order;
};

The .sourceformat field above is a new enumeration, similar to currently 
defined in include/linux/videodev2.h fourcc codes, but combining the 
fourcc, bits-per-sample, packing and order information in one. If an 
existing Fourcc code already uniquely defines this combination, the new 
code might coincide with it. In principle, this code is redundant, because 
the data format is completely described by the "raw" parameters, but it 
can be useful for some (simple) source-sink combinations.

The sink driver can then use the following new method from struct 
v4l2_subdev_video_ops:

int (*enum_bus_pixelfmt)(struct v4l2_subdev *sd,
			 const struct v4l2_subdev_bus_pixelfmt **fmt);

to enumerate formats, provided by the source and to decide, which of them 
it can support in raw mode, which as formatted data, and which of them it 
cannot support at all, e.g., because it does not support the requested 
packing type. This enumeration can either take place upon reception of a 
S_FMT ioctl, or during probing to build a list of formats, that this 
specific source-sink pair can provide to the user.

Comments welcome.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
