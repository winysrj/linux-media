Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx3-phx2.redhat.com ([209.132.183.24]:37966 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753761Ab2BTQTY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Feb 2012 11:19:24 -0500
Date: Mon, 20 Feb 2012 11:19:09 -0500 (EST)
From: David Airlie <airlied@redhat.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
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
	linux-media@vger.kernel.org, Daniel Vetter <daniel@ffwll.ch>
Subject: Re: Kernel Display and Video API Consolidation mini-summit at ELC	2012 - Notes
Message-ID: <23a20eb7-2ce0-447a-a991-100dfaeb8571@zmail16.collab.prod.int.phx2.redhat.com>
In-Reply-To: <Pine.LNX.4.64.1202201633100.2836@axis700.grange>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> 
> I'm certainly absolutely in favour of creating a common EDID parser,
> and
> the DRM/KMS implementation might indeed be the most complete /
> advanced
> one, but at least back in 2010 as I was working on the sh-mobile HDMI
> driver, some functinality was still missing there, which I had to add
> to
> fbdev independently. Unless those features have been added to DRM /
> KMS
> since then you might want to use the fbdev version. See
> 
> http://thread.gmane.org/gmane.linux.ports.arm.omap/55193/focus=55337
> 
> as well as possibly some other discussions from that period
> 
> http://marc.info/?l=linux-fbdev&r=1&b=201010&w=4

One feature missing from the drm EDID parser doesn't mean the fbdev one is better in all cases.

Whoever takes over the merging process will have to check for missing bits anyways to avoid regressions.

> > 
> > I think we should include kernel cmdline video mode parsing here,
> > afaik
> > kms and fbdev are rather similar (won't work if they're too
> > different,
> > obviously).
> 
> This has been a pretty hot discussion topic wrt sh-mobile LCDC / HDMI
> too:-) The goal was to (1) take into account driver's capabilities:
> not
> all standard HDMI modes were working properly, (2) use EDID data, (3)
> give
> the user a chance to select a specific mode. Also here a generic
> solution
> would be very welcome, without breaking existing configurations, of
> course:)

The reason the drm has a more enhanced command line parser is to allow
for multiple devices otherwise it should parse mostly the same I thought
I based the drm one directly on the fbdev one + connector specifiers.

Dave.
