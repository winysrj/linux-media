Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:4098 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179AbZKESLS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Nov 2009 13:11:18 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH/RFC 7/9 v2] v4l: add an image-bus API for configuring v4l2 subdev pixel and frame formats
Date: Thu, 5 Nov 2009 19:11:17 +0100
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Muralidharan Karicheri <m-karicheri2@ti.com>
References: <Pine.LNX.4.64.0910301338140.4378@axis700.grange> <200911051641.15978.hverkuil@xs4all.nl> <Pine.LNX.4.64.0911051729570.5620@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0911051729570.5620@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911051911.17196.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 05 November 2009 17:51:50 Guennadi Liakhovetski wrote:
> On Thu, 5 Nov 2009, Hans Verkuil wrote:
> 
> > On Friday 30 October 2009 15:01:27 Guennadi Liakhovetski wrote:
> > > Video subdevices, like cameras, decoders, connect to video bridges over
> > > specialised busses. Data is being transferred over these busses in various
> > > formats, which only loosely correspond to fourcc codes, describing how video
> > > data is stored in RAM. This is not a one-to-one correspondence, therefore we
> > > cannot use fourcc codes to configure subdevice output data formats. This patch
> > > adds codes for several such on-the-bus formats and an API, similar to the
> > > familiar .s_fmt(), .g_fmt(), .try_fmt(), .enum_fmt() API for configuring those
> > > codes. After all users of the old API in struct v4l2_subdev_video_ops are
> > > converted, the API will be removed.
> > 
> > OK, this seems to completely disregard points raised in my earlier "bus and
> > data format negotiation" RFC which is available here once www.mail-archive.org
> > is working again:
> > 
> > http://www.mail-archive.com/linux-media%40vger.kernel.org/msg09644.html
> > 
> > BTW, ignore the 'Video timings' section of that RFC. That part is wrong.
> > 
> > The big problem I have with this proposal is the unholy mixing of bus and
> > memory formatting. That should be completely separated. Only the bridge
> > knows how a bus format can be converted into which memory (pixel) formats.
> 
> Please, explain why only the bridge knows about that.
> 
> My model is the following:
> 
> 1. we define various data formats on the bus. Each such format variation 
> gets a unique identification.
> 
> 2. given a data format ID the data format is perfectly defined. This 
> means, you do not have to have a special knowledge about this specific 
> format to be able to handle it in some _generic_ way. A typical such 
> generic handling on a bridge is, for instance, copying the data into 
> memory "one-to-one." For example, if a sensor delivers 10 bit monochrome 
> data over an eight bit bus as follows
> 
> y7 y6 y5 y4 y3 y2 y1 y0   xx xx xx xx xx xx y9 y8 ...
> 
> then _any_ bridge, capable of just copying data from the bus bytewise into 
> RAM will be able to produce little-endian 10-bit grey pixel format in RAM. 
> This handling is _not_ bridge specific. This is what I call packing.

Of course it is bridge dependent. It is the bridge that takes data from the
bus and puts it in memory. In many cases that is done very simply by bytewise
copying. Other bridges can do RGB to YUV or vice versa conversions or can do
endianness conversion or can do JPEG/MPEG compression on the fly or whatever
else hardware designers will think of.

It's no doubt true for the SoCs you have been working with, but it is not so
simple in general.
 
> 3. Therefore, each bridge, capable of handling of some "generic" data 
> using some specific packing, can perfectly look through data-format 
> descriptors, see if it finds any with the supported packing, and if so, it 
> _then_ knows, that it can use that specific data format and the specific 
> packing to produce the resulting pixel format from the format descriptor.
> 
> > A bus format is also separate from the colorspace: that is an independent
> > piece of data.
> 
> Sure. TBH, I do not quite how enum v4l2_colorspace is actually used. Is it 
> uniquely defined by each pixel format? So, it can be derived from that? 
> Then it is indeed redundant. Can drop, don't care about it that much.

It's independent from the pixel format. So the same pixel (or bus) format can
have different colorspaces.

> > Personally I would just keep using v4l2_pix_format, except
> > that the fourcc field refers to a busimg format rather than a pixel format
> > in the case of subdevs. In most non-sensor drivers this field is completely
> > ignored anyway since the bus format is fixed.
> 
> Example: there are cameras, that can be configured to pad 2 bits from the 
> incomplete byte above to 10 either in high or in low bits. Do you want to 
> introduce a new FOURCC code for those two formats? This is an example of 
> what I call packing.

If this happens in the sensor, then yes.

> > I don't mind if you do a bus format to pixel format mapping inside soc-camera,
> > but it shouldn't spill over into the v4l core code.
> 
> Don't understand. This is not for soc-camera only. This infrastructure 
> should be used by all subdev drivers, communicating aver a data bus. The 
> distinction is quite clear to me: if two entities connect over a bus, they 
> use an image-bus data format to describe the data format. If they write 
> and read from RAM - that's pixel format.

We agree about that, but why then does struct v4l2_imgbus_framefmt contain
memory-related fields like packing, order and bits_per_sample? A subdev driver
does not care about that. All it has are X pins through which the data has to
pass. How that will look like in memory it doesn't know and doesn't care.

> > Laurent is also correct that this should be eventually pad-specific, but
> > we can ignore that for now.
> > 
> > I'm also missing the bus hardware configuration (polarities, sampling on
> > rising or falling edge). What happened to that? Or is that a next step?
> 
> It is separate, yes.

I saw that as well. I had a lot of emails to go through :-)

Regards,

	Hans

> 
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
> 
> 



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
