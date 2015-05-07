Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:34250 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbbEGNty (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 May 2015 09:49:54 -0400
Received: by wgic8 with SMTP id c8so17674546wgi.1
        for <linux-media@vger.kernel.org>; Thu, 07 May 2015 06:49:53 -0700 (PDT)
Date: Thu, 7 May 2015 15:52:12 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Thierry Reding <treding@nvidia.com>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
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
Message-ID: <20150507135212.GD30184@phenom.ffwll.local>
References: <CA+M3ks7=3sfRiUdUiyq03jCbp08FdZ9ESMgDwE5rgb-0+No3uA@mail.gmail.com>
 <20150505175405.2787db4b@lxorguk.ukuu.org.uk>
 <20150506083552.GF30184@phenom.ffwll.local>
 <20150506091919.GC16325@ulmo.nvidia.com>
 <20150506131532.GC30184@phenom.ffwll.local>
 <20150507132218.GA24541@ulmo.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150507132218.GA24541@ulmo.nvidia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, May 07, 2015 at 03:22:20PM +0200, Thierry Reding wrote:
> On Wed, May 06, 2015 at 03:15:32PM +0200, Daniel Vetter wrote:
> > Yes the idea would be a special-purpose allocater thing like ion. Might
> > even want that to be a syscall to do it properly.
> 
> Would you care to elaborate why a syscall would be more proper? Not that
> I'm objecting to it, just for my education.

It seems to be the theme with someone proposing a global /dev node for a
few system wide ioctls, then reviewers ask to make a proper ioctl out of
it. E.g. kdbus, but I have vague memory of this happening a lot.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
