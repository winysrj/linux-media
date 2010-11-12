Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52707 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab0KLRRn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Nov 2010 12:17:43 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Hadli, Manjunath" <manjunath.hadli@ti.com>
Subject: Re: mediabus enums
Date: Fri, 12 Nov 2010 18:17:40 +0100
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
References: <E0D41E29EB0DAC4E9F3FF173962E9E9402DC24F0EB@dbde02.ent.ti.com>
In-Reply-To: <E0D41E29EB0DAC4E9F3FF173962E9E9402DC24F0EB@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011121817.40926.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Manjunath,

On Friday 12 November 2010 17:00:36 Hadli, Manjunath wrote:
> On Thu, Nov 11, 2010 at 22:17:23, Laurent Pinchart wrote:
> > On Thursday 11 November 2010 16:32:02 Guennadi Liakhovetski wrote:
> > > On Wed, 10 Nov 2010, Hadli, Manjunath wrote:
> > > > Hello Guennadi,
> > > > 
> > > >    Your media-bus enumerations capture the formats quite well. I
> > > > 
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
> > Depending on what Manjunath meant, this should be either YUYV16_2X16 or >
> > > YUYV8_1X16. 16 bits per sample seems quite high to me, I suppose it
> > should > then be YUYV8_1X16.
> 
> Actually, the interface transfers 16 bits per sample (Y=8bits and C=8bits)
> For the YC16 and 18 data lines (parallel) for RGB666. probably
> V4L2_MBUS_FMT_RGB666_1X18 and V4L2_MBUS_FMT_YUYV16_1X16 fit the bill.

V4L2_MBUS_FMT_RGB666_1X18 is correct, but for YUYV I think it should be 
V4L2_MBUS_FMT_YUYV8_1X16. You can find a detailed description of the format at 
http://www.ideasonboard.org/media/media/subdev.html#V4L2-MBUS-FMT-YUYV8-1X16

-- 
Regards,

Laurent Pinchart
