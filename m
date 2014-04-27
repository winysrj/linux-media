Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55900 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbaD0SsI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Apr 2014 14:48:08 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] V4L2: fix VIDIOC_CREATE_BUFS in 64- / 32-bit compatibility mode
Date: Sun, 27 Apr 2014 20:48:17 +0200
Message-ID: <9583205.X1uy75Zhv6@avalon>
In-Reply-To: <Pine.LNX.4.64.1404261627390.21367@axis700.grange>
References: <Pine.LNX.4.64.1403272206410.18471@axis700.grange> <7890812.mee88PGtyI@avalon> <Pine.LNX.4.64.1404261627390.21367@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Saturday 26 April 2014 17:28:24 Guennadi Liakhovetski wrote:
> On Fri, 28 Mar 2014, Laurent Pinchart wrote:
> > On Friday 28 March 2014 18:44:04 Guennadi Liakhovetski wrote:
> > > On Fri, 28 Mar 2014, Laurent Pinchart wrote:
> > > > On Thursday 27 March 2014 22:34:07 Guennadi Liakhovetski wrote:
> > > > > It turns out, that 64-bit compilations sometimes align structs
> > > > > within other structs on 32-bit boundaries, but in other cases
> > > > > alignment is done on 64-bit boundaries, adding padding if necessary.
> > > > 
> > > > You make it sound like the behaviour is random, I'm pretty sure it
> > > > isn't
> > > > 
> > > > :-)
> > > 
> > > I didn't mean it was random, I just meant it is not be as simple as
> > > "align always." E.g. if there are only 32-bit fields in the embedded
> > > struct, it won't be aligned, below I explain a bit with pointers. I just
> > > don't know the exact logic, that's used there.
> > 
> > The logic is basically that fields are aligned within structures to a
> > multiple of their native access size, and structures are aligned to a
> > multiple of the access size of the largest field. If a structure on a
> > 64-bit systems contains a pointer the pointer field will be aligned to a
> > multiple of 8 bytes within the structure, and instances of the structure
> > will be aligned to multiples of 8 bytes as well. If that structure is
> > embedded inside another structure, it will be placed on an 8 bytes
> > boundary, possibly creating a gap if the fields before the structure
> > don't add up to a multiple of 8 bytes. This is what happens here.
> 
> Yes, that's what I thought too, but I didn't have a documented
> confirmation at hand, so, I left it a bit vague :) Have you got a pointer
> to this?

AFAIK how data are aligned in memory isn't part of the C standard but is 
defined by the platform ABI. For instance see the ARM Procedure Call Standard 
(AAPCS -  
http://infocenter.arm.com/help/topic/com.arm.doc.ihi0042e/IHI0042E_aapcs.pdf). 
There's probably a similar document for x86.

-- 
Regards,

Laurent Pinchart

