Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:32990 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026AbbEHIfR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 May 2015 04:35:17 -0400
Received: by wgin8 with SMTP id n8so65833512wgi.0
        for <linux-media@vger.kernel.org>; Fri, 08 May 2015 01:35:16 -0700 (PDT)
Date: Fri, 8 May 2015 10:37:35 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Daniel Vetter <daniel@ffwll.ch>,
	Thierry Reding <treding@nvidia.com>,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Rob Clark <robdclark@gmail.com>,
	Dave Airlie <airlied@redhat.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Tom Gall <tom.gall@linaro.org>
Subject: Re: [RFC] How implement Secure Data Path ?
Message-ID: <20150508083735.GB15256@phenom.ffwll.local>
References: <CA+M3ks7=3sfRiUdUiyq03jCbp08FdZ9ESMgDwE5rgb-0+No3uA@mail.gmail.com>
 <20150505175405.2787db4b@lxorguk.ukuu.org.uk>
 <20150506083552.GF30184@phenom.ffwll.local>
 <20150506091919.GC16325@ulmo.nvidia.com>
 <20150506131532.GC30184@phenom.ffwll.local>
 <20150507132218.GA24541@ulmo.nvidia.com>
 <20150507135212.GD30184@phenom.ffwll.local>
 <20150507174003.2a5b42e6@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150507174003.2a5b42e6@lxorguk.ukuu.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, May 07, 2015 at 05:40:03PM +0100, One Thousand Gnomes wrote:
> On Thu, 7 May 2015 15:52:12 +0200
> Daniel Vetter <daniel@ffwll.ch> wrote:
> 
> > On Thu, May 07, 2015 at 03:22:20PM +0200, Thierry Reding wrote:
> > > On Wed, May 06, 2015 at 03:15:32PM +0200, Daniel Vetter wrote:
> > > > Yes the idea would be a special-purpose allocater thing like ion. Might
> > > > even want that to be a syscall to do it properly.
> > > 
> > > Would you care to elaborate why a syscall would be more proper? Not that
> > > I'm objecting to it, just for my education.
> > 
> > It seems to be the theme with someone proposing a global /dev node for a
> > few system wide ioctls, then reviewers ask to make a proper ioctl out of
> > it. E.g. kdbus, but I have vague memory of this happening a lot.
> 
> kdbus is not necessarily an advert for how to do anything 8)
> 
> If it can be user allocated then it really ought to be one or more device
> nodes IMHO, because you want the resource to be passable between users,
> you need a handle to it and you want it to go away nicely on last close.
> In the cases where the CPU is allowed to or expected to have write only
> access you also might want an mmap of it.

dma-buf user handles are fds, which means anything allocated can be passed
around nicely already. The question really is whether we'll have one ioctl
on top of a special dev node or a syscall. I thought that in these cases
where the dev node is only ever used to allocate the real thing, a syscall
is the preferred way to go.

> I guess the same kind of logic as with GEM (except preferably without
> the DoS security holes) applies as to why its useful to have handles to
> the DMA buffers.

We have handles (well file descriptors) to dma-bufs already, I'm a bit
confused what you mean?
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
