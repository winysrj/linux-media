Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:33451 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1756726Ab0KLQUt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Nov 2010 11:20:49 -0500
Date: Fri, 12 Nov 2010 17:20:52 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: "Hadli, Manjunath" <manjunath.hadli@ti.com>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: RE: mediabus enums
In-Reply-To: <E0D41E29EB0DAC4E9F3FF173962E9E9402DC24F0EB@dbde02.ent.ti.com>
Message-ID: <Pine.LNX.4.64.1011121710390.27571@axis700.grange>
References: <E0D41E29EB0DAC4E9F3FF173962E9E9402DC24F0EB@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, 12 Nov 2010, Hadli, Manjunath wrote:

> On Thu, Nov 11, 2010 at 22:17:23, Laurent Pinchart wrote:
> > Hi Guennadi,
> > 
> > On Thursday 11 November 2010 16:32:02 Guennadi Liakhovetski wrote:
> > > On Wed, 10 Nov 2010, Hadli, Manjunath wrote:
> > > > Hello Guennadi,
> > > > 
> > > >    Your media-bus enumerations capture the formats quite well. I 
> > > > needed
> > > > 
> > > > the following for support on Davinci SOCs and liked to check with 
> > > > you if these are covered in some format in the list.
> > > > 1. Parallel RGB 666 (18 data lines+ 5 sync lines) 2. YUYV16 (16 
> > > > lines) (16 data lines + 4 or 5 sync lines)
> > > 
> > > According to the subdev-formats.xml
> > > 
> > > http://git.linuxtv.org/pinchartl/media.git?a=blob;f=Documentation/DocB
> > > ook/v 
> > > 4l/subdev-formats.xml;h=3688f27185f72ab109e3094c268e04f67cb8643e;hb=re
> > > fs/he
> > > ads/media-0003-subdev-pad
> > > 
> > > they should be called V4L2_MBUS_FMT_RGB666_1X18 (or BGR666...)
> > 
> > Agreed.
> > 
> > > and V4L2_MBUS_FMT_YUYV16_1X16.
> > 
> > Depending on what Manjunath meant, this should be either YUYV16_2X16 or 
> > YUYV8_1X16. 16 bits per sample seems quite high to me, I suppose it should 
> > then be YUYV8_1X16.
> 
> Actually, the interface transfers 16 bits per sample (Y=8bits and C=8bits)
> For the YC16 and 18 data lines (parallel) for RGB666. probably 
> V4L2_MBUS_FMT_RGB666_1X18 and V4L2_MBUS_FMT_YUYV16_1X16 fit the bill.

No, I think, Laurent was right. If that your 1 16-bit sample also 
corresponds to one pixel, then it's a normal 16-bit YUYV, i.e., 
V4L2_MBUS_FMT_YUYV8_1X16. In the aforementioned document the number after 
"YUYV" is "The number of bits per pixel component," where the "component" 
is either the luminance, or the chrominance, both of which are 8 bit wide.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
