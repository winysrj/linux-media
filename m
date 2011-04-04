Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.186]:54761 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753803Ab1DDHP5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Apr 2011 03:15:57 -0400
Date: Mon, 4 Apr 2011 09:15:55 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Pawel Osciak <pawel@osciak.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH/RFC 0/4] V4L: new ioctl()s to support multi-sized
 video-buffers
In-Reply-To: <BANLkTimGCJRv2Hd6ejgewPpRd4ZK=thPxA@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1104040837020.4668@axis700.grange>
References: <Pine.LNX.4.64.1104010959470.9530@axis700.grange>
 <BANLkTimGCJRv2Hd6ejgewPpRd4ZK=thPxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sun, 3 Apr 2011, Pawel Osciak wrote:

> Hi Guennadi,
> 
> On Fri, Apr 1, 2011 at 01:12, Guennadi Liakhovetski
> <g.liakhovetski@gmx.de> wrote:
> > Hi all
> >
> > As discussed at the last V4L2 meeting in Warsaw, one of the prerequisites
> > to support fast switching between different image formats is an ability to
> > preallocate buffers of different sizes and handle them over to the driver
> > in advance. This avoids the need to allocate buffers at the time of
> > switching. This patch series is a first implementation of these ioctl()s,
> > implemented for the sh_mobile_ceu_camera soc-camera host driver. Tested on
> > an sh7722 migor SuperH platform. Yes, I know, documentation is missing
> > yet;-)
> >
> 
> I will have to wait for documentation before doing a full review, it's
> hard to comment without it. Also, please mention how the new ioctls
> influence the state machine.

Ok, I wanted to wait with the documentation until we have the API settled, 
because modifying the code is easier, than modifying the documentation:-) 
But right, I'll try to put something together.

> Some questions and doubts I'm having:
> - Can you call CREATE more than once, before/after REQBUFS, for all
> streaming states? What about reading/writing?

The idea was to use CREATE/DESTROY _instead_ of REQBUFS. And yes, one of 
the purposes of CREATE is to be able to call it multiple times with 
different parameters. The new API should provide at least all the 
functionality, that REQBUFS provides, i.e., you should be able to use it 
with MMAP and USERPTR memory.

> - Can driver decline CREATE if it is not supported? What if the format
> is not supported?

Sure, if .vidioc_create_bufs() is not implemented by the driver, the 
ioctl() will just error out. Of course you're allowed to do any checks you 
see fit in your driver, like unsupported formats and return an error in 
case of a problem.

> - If we fail allocating in CREATE, should the whole queue be freed (as
> it is done in your patch I believe)?

No, that's a bug, thanks for spotting!

> - I'm assuming REQBUFS(0) is to free buffers allocated with CREATE too?

Currently it is possible to mix CREATE/DESTROY and REQBUFS. Not sure if 
this is good, maybe we have to allow the use of only one API. I'd probably 
prefer the latter, but I'm open for suggestions here.

> - Are we allowing DESTROY to free arbitrary span of buffers (i.e.
> those created with REQBUFS as well)?

Again, we can decide, whether we want to support mixing of these APIs or 
not.

> - Are "holes" in buffer indexes allowed? I don't like the ability to
> free an arbitrary span of buffers in the queue, it complicates checks
> in many places and I don't think is worth it...

That's how this ioctl() has been proposed at the Warsaw meeting.

> - I understand SUBMIT is optional?

yes.

> - Could you give an example of how this could be used in an application?

Ok, for my testing I modified the capture.c example from v4l2, I'll try to 
clean up a patch for it and post it.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
