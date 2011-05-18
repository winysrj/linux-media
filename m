Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.171]:63718 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856Ab1EROsK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 May 2011 10:48:10 -0400
Date: Wed, 18 May 2011 16:48:02 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH/RFC 1/4] V4L: add three new ioctl()s for multi-size
 videobuffer management
In-Reply-To: <201105181601.23093.laurent.pinchart@ideasonboard.com>
Message-ID: <Pine.LNX.4.64.1105181642510.16324@axis700.grange>
References: <Pine.LNX.4.64.1104010959470.9530@axis700.grange>
 <Pine.LNX.4.64.1105162144200.29373@axis700.grange> <4DD20D1C.4020808@maxwell.research.nokia.com>
 <201105181601.23093.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, 18 May 2011, Laurent Pinchart wrote:

> On Tuesday 17 May 2011 07:52:28 Sakari Ailus wrote:
> > Guennadi Liakhovetski wrote:

[snip]

> > >> What about making it possible to pass an array of buffer indices to the
> > >> user, just like VIDIOC_S_EXT_CTRLS does? I'm not sure if this would be
> > >> perfect, but it would avoid the problem of requiring continuous ranges
> > >> of buffer ids.
> > >> 
> > >> struct v4l2_create_buffers {
> > >> 
> > >> 	__u32			*index;
> > >> 	__u32			count;
> > >> 	__u32			flags;
> > >> 	enum v4l2_memory        memory;
> > >> 	__u32			size;
> > >> 	struct v4l2_format	format;
> > >> 
> > >> };
> > >> 
> > >> Index would be a pointer to an array of buffer indices and its length
> > >> would be count.
> > > 
> > > I don't understand this. We do _not_ want to allow holes in indices. For
> > > now we decide to not implement DESTROY at all. In this case indices just
> > > increment contiguously.
> > > 
> > > The next stage is to implement DESTROY, but only in strict reverse order
> > > - without holes and in the same ranges, as buffers have been CREATEd
> > > before. So, I really don't understand why we need arrays, sorry.
> > 
> > Well, now that we're defining a second interface to make new buffer
> > objects, I just thought it should be made as future-proof as we can.
> 
> I second that. I don't like rushing new APIs to find out we need something 
> else after 6 months.

Ok, so, we pass an array from user-space with CREATE of size count. The 
kernel fills it with as many buffers entries as it has allocated. But 
currently drivers are also allowed to allocate more buffers, than the 
user-space has requested. What do we do in such a case?

Thanks
Guennadi

> > But even with single index, it's always possible to issue the ioctl more
> > than once and achieve the same result as if there was an array of indices.
> > 
> > What would be the reason to disallow creating holes to index range? I
> > don't see much reason from application or implementation point of view,
> > as we're even being limited to such low numbers.
> > 
> > Speaking of which; perhaps I'm bringing this up rather late, but should
> > we define the API to allow larger numbers than VIDEO_MAX_FRAME? 32 isn't
> > all that much after all --- this might become a limiting factor later on
> > when there are devices with huge amounts of memory.
> > 
> > Allowing CREATE_BUF to do that right now would be possible since
> > applications using it are new users and can be expected to be using it
> > properly. :-)
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
