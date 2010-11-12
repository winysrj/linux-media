Return-path: <mchehab@pedra>
Received: from arroyo.ext.ti.com ([192.94.94.40]:56988 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753181Ab0KLQBg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Nov 2010 11:01:36 -0500
From: "Hadli, Manjunath" <manjunath.hadli@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Date: Fri, 12 Nov 2010 21:30:36 +0530
Subject: RE: mediabus enums
Message-ID: <E0D41E29EB0DAC4E9F3FF173962E9E9402DC24F0EB@dbde02.ent.ti.com>
In-Reply-To: <201011111747.23718.laurent.pinchart@ideasonboard.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, Nov 11, 2010 at 22:17:23, Laurent Pinchart wrote:
> Hi Guennadi,
> 
> On Thursday 11 November 2010 16:32:02 Guennadi Liakhovetski wrote:
> > On Wed, 10 Nov 2010, Hadli, Manjunath wrote:
> > > Hello Guennadi,
> > > 
> > >    Your media-bus enumerations capture the formats quite well. I 
> > > needed
> > > 
> > > the following for support on Davinci SOCs and liked to check with 
> > > you if these are covered in some format in the list.
> > > 1. Parallel RGB 666 (18 data lines+ 5 sync lines) 2. YUYV16 (16 
> > > lines) (16 data lines + 4 or 5 sync lines)
> > 
> > According to the subdev-formats.xml
> > 
> > http://git.linuxtv.org/pinchartl/media.git?a=blob;f=Documentation/DocB
> > ook/v 
> > 4l/subdev-formats.xml;h=3688f27185f72ab109e3094c268e04f67cb8643e;hb=re
> > fs/he
> > ads/media-0003-subdev-pad
> > 
> > they should be called V4L2_MBUS_FMT_RGB666_1X18 (or BGR666...)
> 
> Agreed.
> 
> > and V4L2_MBUS_FMT_YUYV16_1X16.
> 
> Depending on what Manjunath meant, this should be either YUYV16_2X16 or > > YUYV8_1X16. 16 bits per sample seems quite high to me, I suppose it should > then be YUYV8_1X16.

Actually, the interface transfers 16 bits per sample (Y=8bits and C=8bits)
For the YC16 and 18 data lines (parallel) for RGB666. probably V4L2_MBUS_FMT_RGB666_1X18 and V4L2_MBUS_FMT_YUYV16_1X16 fit the bill.
> 
> > Notice, that these codes do not define the complete bus topology, 
> > e.g., they say nothing about sync signals. This is a separate topic.
> 
> --
> Regards,
> 
> Laurent Pinchart
> 

