Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:51983 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729Ab2BTQJv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Feb 2012 11:09:51 -0500
Date: Mon, 20 Feb 2012 17:09:36 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Daniel Vetter <daniel@ffwll.ch>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
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
In-Reply-To: <20120217095554.GA5511@phenom.ffwll.local>
Message-ID: <Pine.LNX.4.64.1202201633100.2836@axis700.grange>
References: <201201171126.42675.laurent.pinchart@ideasonboard.com>
 <1654816.MX2JJ87BEo@avalon> <1775349.d0yvHiVdjB@avalon>
 <20120217095554.GA5511@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 17 Feb 2012, Daniel Vetter wrote:

> On Fri, Feb 17, 2012 at 12:25:51AM +0100, Laurent Pinchart wrote:
> > Hello everybody,
> > 
> > First of all, I would like to thank all the attendees for their participation 
> > in the mini-summit that helped make the meeting a success.
> > 
> > Here are my consolidated notes that cover both the Linaro Connect meeting and 
> > the ELC meeting. They're also available at 
> > http://www.ideasonboard.org/media/meetings/.
> 
> Looks like you've been all really busy ;-) A few quick comments below.
> 
> > Kernel Display and Video API Consolidation mini-summit at ELC 2012
> > ------------------------------------------------------------------
> 
> [snip]
> 
> > ***  Common video mode data structure and EDID parser ***
> > 
> >   Goal: Sharing an EDID parser between DRM/KMS, FBDEV and V4L2.
> > 
> >   The DRM EDID parser is currently the most advanced implementation and will
> >   be taken as a starting point.

I'm certainly absolutely in favour of creating a common EDID parser, and 
the DRM/KMS implementation might indeed be the most complete / advanced 
one, but at least back in 2010 as I was working on the sh-mobile HDMI 
driver, some functinality was still missing there, which I had to add to 
fbdev independently. Unless those features have been added to DRM / KMS 
since then you might want to use the fbdev version. See

http://thread.gmane.org/gmane.linux.ports.arm.omap/55193/focus=55337

as well as possibly some other discussions from that period

http://marc.info/?l=linux-fbdev&r=1&b=201010&w=4

> >   Different subsystems use different data structures to describe video
> >   mode/timing information:
> > 
> >   - struct drm_mode_modeinfo in DRM/KMS
> >   - struct fb_videomode in FBDEV
> >   - struct v4l2_bt_timings in V4L2
> > 
> >   A new common video mode/timing data structure (struct media_video_mode_info,
> >   exact name is to be defined), not tied to any specific subsystem, is
> >   required to share the EDID parser. That structure won't be exported to
> >   userspace.
> > 
> >   Helper functions will be implemented in the subsystems to convert between
> >   that generic structure and the various subsystem-specific structures.
> > 
> >   The mode list is stored in the DRM connector in the EDID parser. A new mode
> >   list data structure can be added, or a callback function can be used by the
> >   parser to give modes one at a time to the caller.
> > 
> >   3D needs to be taken into account (this is similar to interlacing).
> > 
> >   Action points:
> >   - Laurent to work on a proposal. The DRM/KMS EDID parser will be reused.
> 
> I think we should include kernel cmdline video mode parsing here, afaik
> kms and fbdev are rather similar (won't work if they're too different,
> obviously).

This has been a pretty hot discussion topic wrt sh-mobile LCDC / HDMI 
too:-) The goal was to (1) take into account driver's capabilities: not 
all standard HDMI modes were working properly, (2) use EDID data, (3) give 
the user a chance to select a specific mode. Also here a generic solution 
would be very welcome, without breaking existing configurations, of 
course:)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
