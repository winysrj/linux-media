Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47236 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754231Ab0KKQtI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Nov 2010 11:49:08 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: mediabus enums
Date: Thu, 11 Nov 2010 17:47:23 +0100
Cc: "Hadli, Manjunath" <manjunath.hadli@ti.com>,
	LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
References: <E0D41E29EB0DAC4E9F3FF173962E9E9402DC1A7C8C@dbde02.ent.ti.com> <Pine.LNX.4.64.1011111553320.15747@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1011111553320.15747@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011111747.23718.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Guennadi,

On Thursday 11 November 2010 16:32:02 Guennadi Liakhovetski wrote:
> On Wed, 10 Nov 2010, Hadli, Manjunath wrote:
> > Hello Guennadi,
> > 
> >    Your media-bus enumerations capture the formats quite well. I needed
> > 
> > the following for support on Davinci SOCs and liked to check with you if
> > these are covered in some format in the list.
> > 1. Parallel RGB 666 (18 data lines+ 5 sync lines)
> > 2. YUYV16 (16 lines) (16 data lines + 4 or 5 sync lines)
> 
> According to the subdev-formats.xml
> 
> http://git.linuxtv.org/pinchartl/media.git?a=blob;f=Documentation/DocBook/v
> 4l/subdev-formats.xml;h=3688f27185f72ab109e3094c268e04f67cb8643e;hb=refs/he
> ads/media-0003-subdev-pad
> 
> they should be called V4L2_MBUS_FMT_RGB666_1X18 (or BGR666...)

Agreed.

> and V4L2_MBUS_FMT_YUYV16_1X16.

Depending on what Manjunath meant, this should be either YUYV16_2X16 or 
YUYV8_1X16. 16 bits per sample seems quite high to me, I suppose it should 
then be YUYV8_1X16.

> Notice, that these codes do not define the complete bus topology, e.g., they
> say nothing about sync signals. This is a separate topic.

-- 
Regards,

Laurent Pinchart
