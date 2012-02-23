Return-path: <linux-media-owner@vger.kernel.org>
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:40465 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753704Ab2BWANb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Feb 2012 19:13:31 -0500
Date: Thu, 23 Feb 2012 00:15:03 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Clark, Rob" <rob@ti.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	linux-fbdev@vger.kernel.org,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Pawel Osciak <pawel@osciak.com>,
	Marcus Lorentzon <marcus.lorentzon@linaro.org>,
	Magnus Damm <magnus.damm@gmail.com>,
	dri-devel@lists.freedesktop.org,
	Alexander Deucher <alexander.deucher@amd.com>,
	linux-media@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: Kernel Display and Video API Consolidation mini-summit at ELC
 2012 - Notes
Message-ID: <20120223001503.550ea0a5@pyramind.ukuu.org.uk>
In-Reply-To: <CAO8GWqnVLfu5p3yNbE-BNqXfUu=2JX3S82GoJFS1baRwV126pQ@mail.gmail.com>
References: <201201171126.42675.laurent.pinchart@ideasonboard.com>
	<1775349.d0yvHiVdjB@avalon>
	<20120217095554.GA5511@phenom.ffwll.local>
	<2168398.Pv8ir5xFGf@avalon>
	<alpine.LFD.2.02.1202221559510.3721@casper.infradead.org>
	<20120222162424.GE4872@phenom.ffwll.local>
	<e39f63$3q903a@fmsmga002.fm.intel.com>
	<CAO8GWqnVLfu5p3yNbE-BNqXfUu=2JX3S82GoJFS1baRwV126pQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> and when doing 2d accel on a 3d core..  it basically amounts to
> putting a shader compiler in the kernel.   Wheeee!

What I did for the GMA500 is to use the GTT to do scrolling by rewriting
the framebuffer GTT tables so they work as a circular buffer and doing a
bit of alignment of buffers.

The end result is faster than most accelerated 2D scrolls unsurprisingly.

Even faster would be to map enough of the start of the object on the end
of the range in repeat and just roll the frame buffer base. That would
get it down to a couple of 32bit I/O writes..

Alan
