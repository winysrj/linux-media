Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:25595 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753772Ab2BVQgm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Feb 2012 11:36:42 -0500
Message-Id: <e39f63$3q903a@fmsmga002.fm.intel.com>
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: Kernel Display and Video API Consolidation mini-summit at ELC 2012 - Notes
To: Daniel Vetter <daniel@ffwll.ch>,
	James Simmons <jsimmons@infradead.org>
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>,
	linux-fbdev@vger.kernel.org,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Marcus Lorentzon <marcus.lorentzon@linaro.org>,
	Pawel Osciak <pawel@osciak.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	dri-devel@lists.freedesktop.org,
	Alexander Deucher <alexander.deucher@amd.com>,
	Rob Clark <rob@ti.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-media@vger.kernel.org
In-Reply-To: <20120222162424.GE4872@phenom.ffwll.local>
References: <201201171126.42675.laurent.pinchart@ideasonboard.com> <1775349.d0yvHiVdjB@avalon> <20120217095554.GA5511@phenom.ffwll.local> <2168398.Pv8ir5xFGf@avalon> <alpine.LFD.2.02.1202221559510.3721@casper.infradead.org> <20120222162424.GE4872@phenom.ffwll.local>
Date: Wed, 22 Feb 2012 16:36:32 +0000
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 22 Feb 2012 17:24:24 +0100, Daniel Vetter <daniel@ffwll.ch> wrote:
> On Wed, Feb 22, 2012 at 04:03:21PM +0000, James Simmons wrote:
> > Fbcon scrolling at be painful at HD or better modes. Fbcon needs 3 
> > possible accels; copyarea, imageblit, and fillrect. The first two could be 
> > hooked from the TTM layer. Its something I plan to experiment to see if 
> > its worth it.
> 
> Let's bite into this ;-) I know that fbcon scrolling totally sucks on big
> screens, but I also think it's a total waste of time to fix this. Imo
> fbcon has 2 use-cases:
> - display an OOSP.
> - allow me to run fsck (or any other desaster-recovery stuff).
3. Show panics.

Ensuring that nothing prevents the switch to fbcon and displaying the
panic message is the reason why we haven't felt inclined to accelerate
fbcon - it just gets messy for no real gain.

For example: https://bugs.freedesktop.org/attachment.cgi?id=48933
which doesn't handle flushing of pending updates via the GPU when
writing with the CPU during interrupts (i.e. a panic).
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
