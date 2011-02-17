Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.9]:61773 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048Ab1BQVNk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Feb 2011 16:13:40 -0500
Date: Thu, 17 Feb 2011 22:13:35 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hansverk@cisco.com>, Qing Xu <qingx@marvell.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Neil Johnson <realdealneil@gmail.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Uwe Taeubert <u.taeubert@road.de>,
	"Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	Eino-Ville Talvala <talvala@stanford.edu>
Subject: Re: [RFD] frame-size switching: preview / single-shot use-case
In-Reply-To: <4D5D893B.5090101@infradead.org>
Message-ID: <Pine.LNX.4.64.1102172153470.1841@axis700.grange>
References: <Pine.LNX.4.64.1102151641490.16709@axis700.grange>
 <201102160949.04605.hansverk@cisco.com> <Pine.LNX.4.64.1102160954560.20711@axis700.grange>
 <201102161011.59830.laurent.pinchart@ideasonboard.com>
 <Pine.LNX.4.64.1102161033440.20711@axis700.grange> <4D5D7141.4030101@infradead.org>
 <Pine.LNX.4.64.1102172020410.30692@axis700.grange> <4D5D893B.5090101@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, 17 Feb 2011, Mauro Carvalho Chehab wrote:

> Em 17-02-2011 17:26, Guennadi Liakhovetski escreveu:
> > Hi Mauro
> > 
> > Thanks for your comments.
> > 
> > On Thu, 17 Feb 2011, Mauro Carvalho Chehab wrote:
> > 
> >> Em 16-02-2011 08:35, Guennadi Liakhovetski escreveu:
> > 
> > [snip]
> > 
> >>> (2) cleanly separate setting video data format (S_FMT) from specifying the 
> >>> allocated buffer size.
> >>
> >> This would break existing applications. Too late for that, except if negotiated
> >> with a "SETCAP" like approach.
> > 
> > Sorry, don't see how my proposal from my last mail would change existing 
> > applications. As long as no explicit buffer-queue management is performed, 
> > no new queues are allocated, the driver will just implicitly allocate one 
> > queue and use it. I.e., no change in behaviour.
> 
> Using the same ioctl to explicitly or to implicitly allocating memory depending
> on the context would make the API more complicated than it should be.

Sorry again, of course, we're adding new functionality, so, it may well 
happen, that the API will become more complicated too. But that was not 
the question. The question was - would it break any existing users? And it 
looks like it wouldn't, at the same time giving new users the required 
additional flexibility and functionality.

> >> There's an additional problem with that: assume that streaming is happening,
> >> and a S_FMT changing the resolution was sent. There's no way to warrant that
> >> the very next frame will have the new resolution. So, a meta-data with the
> >> frame resolution (and format) would be needed.
> > 
> > Sorry, we are not going to allow format changes during a running capture. 
> > You have to stop streaming, set new formats (possibly switch to another 
> > queue) and restart streaming.
> 
> > What am I missing?
> 
> If you're stopping the stream, the current API will work as-is.
> 
> If all of your concerns is about reserving a bigger buffer queue, I think that one
> of the reasons for the CMA allocator it for such usage.

Not just bigger, say, with our preview / still-shot example, we would have 
one queue with a larger number of small buffers for drop-free preview, and 
a small number of larger buffers for still images. Currently you would 
have to allocate a large number of large buffers, which would waste 
memory. Or you would have to reallocate the queue, losing time. AFAICS, 
CMA doesn't manage our memory for us. It only provides an API to reserve 
memory for various uses with various restrictions (alignment, etc.) and 
use different allocators to obtain that memory. So, are you suggesting, 
that with that in place, we would first allocate the preview queue from 
this memory, then free it, when switching to snapshooting, allocate our 
large-buffer queue from the _same_ memory, capture images, free and 
allocate preview queue again? Would that be fast enough?

In fact, it would be kind of smart to reuse the same memory for both 
queues, but if we could do it without re-allocations?...

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
