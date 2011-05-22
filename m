Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.171]:58181 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382Ab1EVKSM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 May 2011 06:18:12 -0400
Date: Sun, 22 May 2011 12:18:07 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH/RFC 1/4] V4L: add three new ioctl()s for multi-size
 videobuffer management
In-Reply-To: <4DD20D1C.4020808@maxwell.research.nokia.com>
Message-ID: <Pine.LNX.4.64.1105221209480.8519@axis700.grange>
References: <Pine.LNX.4.64.1104010959470.9530@axis700.grange>
 <Pine.LNX.4.64.1104011010530.9530@axis700.grange>
 <Pine.LNX.4.64.1105121835370.24486@axis700.grange> <4DD12784.2000100@maxwell.research.nokia.com>
 <Pine.LNX.4.64.1105162144200.29373@axis700.grange> <4DD20D1C.4020808@maxwell.research.nokia.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, 17 May 2011, Sakari Ailus wrote:

> Guennadi Liakhovetski wrote:

[snip]

> > I don't understand this. We do _not_ want to allow holes in indices. For 
> > now we decide to not implement DESTROY at all. In this case indices just 
> > increment contiguously.
> > 
> > The next stage is to implement DESTROY, but only in strict reverse order - 
> > without holes and in the same ranges, as buffers have been CREATEd before. 
> > So, I really don't understand why we need arrays, sorry.
> 
> Well, now that we're defining a second interface to make new buffer
> objects, I just thought it should be made as future-proof as we can. But
> even with single index, it's always possible to issue the ioctl more
> than once and achieve the same result as if there was an array of indices.
> 
> What would be the reason to disallow creating holes to index range? I
> don't see much reason from application or implementation point of view,
> as we're even being limited to such low numbers.

I think, there are a few locations in V4L2, that assume, that for N number 
of buffers currently allocated, their indices are 0...N-1. Just look for 
loops like

	for (buffer = 0; buffer < q->num_buffers; ++buffer) {

in videobuf2-core.c.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
