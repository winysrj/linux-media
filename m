Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:34259 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751648AbZHZSNa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Aug 2009 14:13:30 -0400
Date: Wed, 26 Aug 2009 20:13:46 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Hans de Goede <j.w.r.degoede@hhs.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: RE: [RFC] Pixel format definition on the "image" bus
In-Reply-To: <Pine.LNX.4.64.0908261826110.7670@axis700.grange>
Message-ID: <Pine.LNX.4.64.0908262003310.7670@axis700.grange>
References: <Pine.LNX.4.64.0908261452460.7670@axis700.grange>
 <A69FA2915331DC488A831521EAE36FE40154E2C11B@dlee06.ent.ti.com>
 <Pine.LNX.4.64.0908261826110.7670@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 26 Aug 2009, Guennadi Liakhovetski wrote:

> On Wed, 26 Aug 2009, Karicheri, Muralidharan wrote:
> 
> > Guennadi,
> > 
> > How is this different from enum_fmt() sub device operation. The pixel 
> > format does specify how bridge device pack the data from sub device into 
> > memory
> 
> Now, this is something I don't understand. .enum_fmt() from struct 
> v4l2_subdev_video_ops is a function, that a sink (bridge) driver calls 
> into a source. The data is provided by the source. It might well tell the 
> bridge driver what it can get from the data, but it doesn't tell it _how_ 
> to do it - how to pack data on the bus to get that format in memory. The 
> sensor just pushes its data out on the image bus over a serial / 8-bit / 
> 9-bit / 10-bit / ... link. It's the sink's responsibility to recognise 
> what data format the source is providing on the bus and decide how to pack 
> it into memory. As I said, in principle you're right - we can agree to 
> just encode the complete data format into the format code, but this would 
> require us to write a decoder, which extracts the information I described 
> in the RFC from those codes - bits, packing, order... In fact, it might 
> indeed be better to write such a decoder once, than to make each source 
> driver provide all that data.

I think, best would be to define these new on-the-bus data format codes as 
simple indices, define a const array of struct v4l2_subdev_bus_pixelfmt, 
e.g., in drivers/media/video/v4l2-device.c and a function that just 
returns a pointer to the indexed struct.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
