Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:60317 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119Ab1HQIpJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Aug 2011 04:45:09 -0400
Date: Wed, 17 Aug 2011 10:44:59 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sakari Ailus <sakari.ailus@iki.fi>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Pawel Osciak <pawel@osciak.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 4/6 v4] V4L: vb2: add support for buffers of different
 sizes on a single queue
In-Reply-To: <4E3D8E70.2010407@iki.fi>
Message-ID: <Pine.LNX.4.64.1108171042150.18317@axis700.grange>
References: <Pine.LNX.4.64.1108042329460.31239@axis700.grange>
 <Pine.LNX.4.64.1108050930450.26715@axis700.grange> <4E3D8E70.2010407@iki.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 6 Aug 2011, Sakari Ailus wrote:

[snip]

> > +
> > +		/*
> > +		 * q->num_buffers contains the total number of buffers, that the
> > +		 * queue driver has set up
> > +		 */
> > +		ret = call_qop(q, queue_setup, q, &num_buffers,
> > +			       &num_planes, create->sizes, q->alloc_ctx);
> > +
> > +		if (!ret && allocated_buffers < num_buffers)
> > +			ret = -ENOMEM;
> 
> Is this really an error?

It is. See the current REQBUFS implementation

> How is the queue_setup op expected to change
> num_buffers, and why?

At this stage it should accept the proposed smaller number of buffers, because 
that's all we managed to allocate.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
