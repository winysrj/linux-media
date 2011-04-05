Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.9]:50110 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753573Ab1DEMsa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Apr 2011 08:48:30 -0400
Date: Tue, 5 Apr 2011 14:48:25 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Pawel Osciak <pawel@osciak.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH/RFC 0/4] V4L: new ioctl()s to support multi-sized
 video-buffers
In-Reply-To: <201104051419.42495.laurent.pinchart@ideasonboard.com>
Message-ID: <Pine.LNX.4.64.1104051445280.14419@axis700.grange>
References: <Pine.LNX.4.64.1104010959470.9530@axis700.grange>
 <BANLkTimGCJRv2Hd6ejgewPpRd4ZK=thPxA@mail.gmail.com>
 <Pine.LNX.4.64.1104040837020.4668@axis700.grange>
 <201104051419.42495.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, 5 Apr 2011, Laurent Pinchart wrote:

[snip]

> > > - Are "holes" in buffer indexes allowed? I don't like the ability to
> > > free an arbitrary span of buffers in the queue, it complicates checks
> > > in many places and I don't think is worth it...
> > 
> > That's how this ioctl() has been proposed at the Warsaw meeting.
> 
> If my memory is correct, we agreed that buffers created with a single CREATE 
> call had to be freed all at once by DESTROY. This won't prevent holes though, 
> as applications could call CREATE three times and then free buffers allocated 
> by the second call.

Yes, I think, you're right. Currently I don't track those creation sets... 
Do we really want that? What does it give us?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
