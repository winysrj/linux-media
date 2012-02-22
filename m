Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:56352 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715Ab2BVQYK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Feb 2012 11:24:10 -0500
Date: Wed, 22 Feb 2012 17:24:24 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: James Simmons <jsimmons@infradead.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Daniel Vetter <daniel@ffwll.ch>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	linux-fbdev@vger.kernel.org,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Pawel Osciak <pawel@osciak.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	Marcus Lorentzon <marcus.lorentzon@linaro.org>,
	dri-devel@lists.freedesktop.org,
	Alexander Deucher <alexander.deucher@amd.com>,
	Rob Clark <rob@ti.com>, linux-media@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: Kernel Display and Video API Consolidation mini-summit at ELC
 2012 - Notes
Message-ID: <20120222162424.GE4872@phenom.ffwll.local>
References: <201201171126.42675.laurent.pinchart@ideasonboard.com>
 <1775349.d0yvHiVdjB@avalon>
 <20120217095554.GA5511@phenom.ffwll.local>
 <2168398.Pv8ir5xFGf@avalon>
 <alpine.LFD.2.02.1202221559510.3721@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1202221559510.3721@casper.infradead.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Feb 22, 2012 at 04:03:21PM +0000, James Simmons wrote:
> 
> > > Imo we should ditch this - fb accel doesn't belong into the kernel. Even
> > > on hw that still has a blitter for easy 2d accel without a complete 3d
> > > state setup necessary, it's not worth it. Chris Wilson from our team once
> > > played around with implementing fb accel in the kernel (i915 hw still has
> > > a blitter engine in the latest generations). He quickly noticed that to
> > > have decent speed, competitive with s/w rendering by the cpu he needs the
> > > entire batch and buffer management stuff from userspace. And to really
> > > beat the cpu, you need even more magic.
> > > 
> > > If you want fast 2d accel, use something like cairo.
> > 
> > Our conclusion on this is that we should not expose an explicit 2D 
> > acceleration API at the kernel level. If really needed, hardware 2D 
> > acceleration could be implemented as a DRM device to handle memory management, 
> > commands ring setup, synchronization, ... but I'm not even sure if that's 
> > worth it. I might not have conveyed it well in my notes.
> 
> Fbcon scrolling at be painful at HD or better modes. Fbcon needs 3 
> possible accels; copyarea, imageblit, and fillrect. The first two could be 
> hooked from the TTM layer. Its something I plan to experiment to see if 
> its worth it.

Let's bite into this ;-) I know that fbcon scrolling totally sucks on big
screens, but I also think it's a total waste of time to fix this. Imo
fbcon has 2 use-cases:
- display an OOSP.
- allow me to run fsck (or any other desaster-recovery stuff).

It can do that quite fine already.

Flamy yours, Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
