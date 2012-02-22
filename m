Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:58290 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882Ab2BVR0s (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Feb 2012 12:26:48 -0500
Date: Wed, 22 Feb 2012 17:26:40 +0000 (GMT)
From: James Simmons <jsimmons@infradead.org>
To: "Clark, Rob" <rob@ti.com>
cc: Chris Wilson <chris@chris-wilson.co.uk>,
	Daniel Vetter <daniel@ffwll.ch>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	linux-fbdev@vger.kernel.org,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Marcus Lorentzon <marcus.lorentzon@linaro.org>,
	Pawel Osciak <pawel@osciak.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	dri-devel@lists.freedesktop.org,
	Alexander Deucher <alexander.deucher@amd.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: Kernel Display and Video API Consolidation mini-summit at ELC
 2012 - Notes
In-Reply-To: <CAO8GWqnVLfu5p3yNbE-BNqXfUu=2JX3S82GoJFS1baRwV126pQ@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1202221723480.11138@casper.infradead.org>
References: <201201171126.42675.laurent.pinchart@ideasonboard.com> <1775349.d0yvHiVdjB@avalon> <20120217095554.GA5511@phenom.ffwll.local> <2168398.Pv8ir5xFGf@avalon> <alpine.LFD.2.02.1202221559510.3721@casper.infradead.org> <20120222162424.GE4872@phenom.ffwll.local>
 <e39f63$3q903a@fmsmga002.fm.intel.com> <CAO8GWqnVLfu5p3yNbE-BNqXfUu=2JX3S82GoJFS1baRwV126pQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> > Ensuring that nothing prevents the switch to fbcon and displaying the
> > panic message is the reason why we haven't felt inclined to accelerate
> > fbcon - it just gets messy for no real gain.
> 
> and when doing 2d accel on a 3d core..  it basically amounts to
> putting a shader compiler in the kernel.   Wheeee!

Yikes. I'm not suggesting that. In fact I doubt accelerating the imageblit
would be worthy it due to the small size of the images being pushed. The 
real cost is the copyarea which is used for scrolling when no panning is 
available. 

> > For example: https://bugs.freedesktop.org/attachment.cgi?id=48933
> > which doesn't handle flushing of pending updates via the GPU when
> > writing with the CPU during interrupts (i.e. a panic).
> > -Chris
> >
> > --
> > Chris Wilson, Intel Open Source Technology Centre
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fbdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
