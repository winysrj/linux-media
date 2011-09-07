Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:53263 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756180Ab1IGQIl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Sep 2011 12:08:41 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: Re: [PATCH 0/2] video: s3c-fb: Add window positioning support
Date: Wed, 7 Sep 2011 17:31:00 +0200
Cc: Ajay Kumar <ajaykumar.rs@samsung.com>,
	linux-samsung-soc@vger.kernel.org, linux-fbdev@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, lethal@linux-sh.org,
	jg1.han@samsung.com, m.szyprowski@samsung.com, ben-linux@fluff.org,
	banajit.g@samsung.com, Manuel Lauss <manuel.lauss@googlemail.com>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <1314301917-9938-1-git-send-email-ajaykumar.rs@samsung.com> <4E5FB69E.2060907@gmx.de>
In-Reply-To: <4E5FB69E.2060907@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109071731.02293.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Florian,

On Thursday 01 September 2011 18:45:18 Florian Tobias Schandinat wrote:
> Hi all,
> 
> On 08/25/2011 07:51 PM, Ajay Kumar wrote:
> > Just as a note, there are many drivers like mx3fb.c, au1200fb.c and OMAP
> > seem to be doing window/plane positioning in their driver code.
> > Is it possible to have this window positioning support at a common place?
> 
> Good point. Congratulations for figuring out that I like to standardize
> things. But I think your suggestion is far from being enough to be useful
> for userspace (which is our goal so that applications can be reused along
> drivers and don't need to know about individual drivers).

Beside standardizing things, do you also like to take them one level higher to 
solve challenging issues ? I know the answer must be yes :-)

The problem at hand here is something we have solved in V4L2 (theoretically 
only for part of it) with the media controller API, the V4L2 subdevs and their 
pad-level format API.

In a nutshell, the media controller lets drivers model hardware as a graph of 
buliding blocks connected through their pads and expose that description to 
userspace applications. In V4L2 most of those blocks are V4L2 subdevs, which 
are abstract building blocks that implement sets of standard operations. Those 
operations are exposed to userspace through the V4L2 subdevs pad-level format 
API, allowing application to configure sizes and selection rectangles at all 
pads in the graph. Selection rectangles can be used to configure cropping and 
composing, which is exactly what the window positioning API needs to do.

Instead of creating a new fbdev-specific API to do the same, shouldn't we try 
to join forces ?

> So let me at first summarize how I understand you implemented those things
> after having a brief look at some of the drivers:
> Windows are rectangular screen areas whose pixel data come from other
> locations. The other locations are accessible via other framebuffer
> devices (e.g. fb1). So in this area the data of fb1 is shown and not the
> data of fb0 that would be normally shown.
> 
> So in addition to your proposed positioning I think we should also have the
> following to give userspace a useful set of functionality:
> 
> - a way to discover how the screen is composited (how many windows are
> there, how they are stacked and how to access those)
> 
> - a way to enable/disable windows (make them (in)visible)
> 
> - reporting and selecting how the window content can be mixed with the root
> screen (overwrite, source or destination color keying)
> 
> - things like window size and color format could be handled by the usual fb
> API used on the window. However there might be restrictions which cause
> them to be not 100% API compatible (for example when changing the color
> format if the windows are required to have the same format as the root
> screen)
> 
> - do we need to worry about hardware (up/down) scaling of the window
> content?
> 
> 
> So is that what you need for a standardized window implementation?
> Any additional things that were useful/needed in this context?
> Would you consider adding support for this API in your drivers? (as
> standardizing wouldn't be useful if nobody would implement it)

-- 
Regards,

Laurent Pinchart
