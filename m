Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:55078 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753752Ab1HAInP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Aug 2011 04:43:15 -0400
Date: Mon, 1 Aug 2011 10:42:57 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Pawel Osciak <pawel@osciak.com>
Subject: Re: [PATCH v3] V4L: add two new ioctl()s for multi-size videobuffer
 management
In-Reply-To: <201107261357.31673.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.1108011031150.30975@axis700.grange>
References: <Pine.LNX.4.64.1107201025120.12084@axis700.grange>
 <201107261305.29863.hverkuil@xs4all.nl> <20110726114427.GC32507@valkosipuli.localdomain>
 <201107261357.31673.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 26 Jul 2011, Hans Verkuil wrote:

> On Tuesday, July 26, 2011 13:44:28 Sakari Ailus wrote:
> > Hi Hans and Guennadi,
> 
> <snip>
> 
> > > I realized that it is not clear from the documentation whether it is possible to call
> > > VIDIOC_REQBUFS and make additional calls to VIDIOC_CREATE_BUFS afterwards.
> > 
> > That's actually a must if one wants to release buffers. Currently no other
> > method than requesting 0 buffers using REQBUFS is provided (apart from
> > closing the file handle).
> 
> I was referring to the non-0 use-case :-)
> 
> > > I can't remember whether the code allows it or not, but it should be clearly documented.
> > 
> > I would guess no user application would have to call REQBUFS with other than
> > zero buffers when using CREATE_BUFS. This must be an exception if mixing
> > REQBUFS and CREATE_BUFS is not allowed in general. That said, I don't see a
> > reason to prohibit either, but perhaps Guennadi has more informed opinion
> > on this.
>  
> <snip>
> 
> > > > > > Future functionality which would be nice:
> > > > > > 
> > > > > > - Format counters. Every format set by S_FMT (or gotten by G_FMT) should
> > > > > >   come with a counter value so that the user would know the format of
> > > > > >   dequeued buffers when setting the format on-the-fly. Currently there are
> > > > > >   only bytesperline and length, but the format can't be explicitly
> > > > > >   determined from those.
> > > 
> > > Actually, the index field will give you that information. When you create the
> > > buffers you know that range [index, index + count - 1] is associated with that
> > > specific format.
> > 
> > Some hardware is able to change the format while streaming is ongoing (for
> > example: OMAP 3). The problem is that the user should be able to know which
> > frame has the new format.

How exactly does this work or should it work? You mean, you just configure 
your hardware with new frame size parameters without stopping the current 
streaming, and the ISP will change frame sizes, beginning with some future 
frame? How does the driver then get to know, which frame already has the 
new sizes? You actually want to know this in advance to already queue a 
suitably sized buffer to the hardware?

Thanks
Guennadi

> Ah, of course.
> 
> > Of course one could stop streaming but this would mean lost frames.
> > 
> > A flag has been proposed to this previously. That's one option but forces
> > the user to keep track of the changes since only one change is allowed until
> > it has taken effect.
> 
> Something to discuss next week, I think.
> 
> Regards,
> 
> 	Hans
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
