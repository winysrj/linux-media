Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:60262 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041Ab1DEMTJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Apr 2011 08:19:09 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH/RFC 0/4] V4L: new ioctl()s to support multi-sized video-buffers
Date: Tue, 5 Apr 2011 14:19:42 +0200
Cc: Pawel Osciak <pawel@osciak.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
References: <Pine.LNX.4.64.1104010959470.9530@axis700.grange> <BANLkTimGCJRv2Hd6ejgewPpRd4ZK=thPxA@mail.gmail.com> <Pine.LNX.4.64.1104040837020.4668@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1104040837020.4668@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104051419.42495.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Guennadi,

On Monday 04 April 2011 09:15:55 Guennadi Liakhovetski wrote:
> On Sun, 3 Apr 2011, Pawel Osciak wrote:
> > On Fri, Apr 1, 2011 at 01:12, Guennadi Liakhovetski wrote:
> > > Hi all
> > > 
> > > As discussed at the last V4L2 meeting in Warsaw, one of the
> > > prerequisites to support fast switching between different image
> > > formats is an ability to preallocate buffers of different sizes and
> > > handle them over to the driver in advance. This avoids the need to
> > > allocate buffers at the time of switching. This patch series is a
> > > first implementation of these ioctl()s, implemented for the
> > > sh_mobile_ceu_camera soc-camera host driver. Tested on an sh7722 migor
> > > SuperH platform. Yes, I know, documentation is missing yet;-)
> > 
> > I will have to wait for documentation before doing a full review, it's
> > hard to comment without it. Also, please mention how the new ioctls
> > influence the state machine.
> 
> Ok, I wanted to wait with the documentation until we have the API settled,
> because modifying the code is easier, than modifying the documentation:-)
> But right, I'll try to put something together.
> 
> > Some questions and doubts I'm having:
> > - Can you call CREATE more than once, before/after REQBUFS, for all
> > streaming states? What about reading/writing?
> 
> The idea was to use CREATE/DESTROY _instead_ of REQBUFS. And yes, one of
> the purposes of CREATE is to be able to call it multiple times with
> different parameters. The new API should provide at least all the
> functionality, that REQBUFS provides, i.e., you should be able to use it
> with MMAP and USERPTR memory.
> 
> > - Can driver decline CREATE if it is not supported? What if the format
> > is not supported?
> 
> Sure, if .vidioc_create_bufs() is not implemented by the driver, the
> ioctl() will just error out. Of course you're allowed to do any checks you
> see fit in your driver, like unsupported formats and return an error in
> case of a problem.
> 
> > - If we fail allocating in CREATE, should the whole queue be freed (as
> > it is done in your patch I believe)?
> 
> No, that's a bug, thanks for spotting!
> 
> > - I'm assuming REQBUFS(0) is to free buffers allocated with CREATE too?
> 
> Currently it is possible to mix CREATE/DESTROY and REQBUFS. Not sure if
> this is good, maybe we have to allow the use of only one API. I'd probably
> prefer the latter, but I'm open for suggestions here.
> 
> > - Are we allowing DESTROY to free arbitrary span of buffers (i.e.
> > those created with REQBUFS as well)?
> 
> Again, we can decide, whether we want to support mixing of these APIs or
> not.
> 
> > - Are "holes" in buffer indexes allowed? I don't like the ability to
> > free an arbitrary span of buffers in the queue, it complicates checks
> > in many places and I don't think is worth it...
> 
> That's how this ioctl() has been proposed at the Warsaw meeting.

If my memory is correct, we agreed that buffers created with a single CREATE 
call had to be freed all at once by DESTROY. This won't prevent holes though, 
as applications could call CREATE three times and then free buffers allocated 
by the second call.

[snip]

-- 
Regards,

Laurent Pinchart
