Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:41498 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1768601Ab2KOSEE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Nov 2012 13:04:04 -0500
Received: by mail-wi0-f172.google.com with SMTP id hj6so1540704wib.1
        for <linux-media@vger.kernel.org>; Thu, 15 Nov 2012 10:04:02 -0800 (PST)
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v10 1/6] video: add display_timing and videomode
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Steffen Trumtrar <s.trumtrar@pengutronix.de>,
	devicetree-discuss@lists.ozlabs.org, linux-fbdev@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	Tomi Valkeinen <tomi.valkeinen@ti.com>, kernel@pengutronix.de,
	Guennady Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org
In-Reply-To: <2466982.zTBri0jEif@avalon>
References: <1352971437-29877-1-git-send-email-s.trumtrar@pengutronix.de> <1352971437-29877-2-git-send-email-s.trumtrar@pengutronix.de> <20121115154753.C82223E194B@localhost> <2466982.zTBri0jEif@avalon>
Date: Thu, 15 Nov 2012 18:03:59 +0000
Message-Id: <20121115180359.1E6F33E197F@localhost>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 15 Nov 2012 17:00:57 +0100, Laurent Pinchart <laurent.pinchart@ideasonboard.com> wrote:
> Hi Grant,
> 
> On Thursday 15 November 2012 15:47:53 Grant Likely wrote:
> > On Thu, 15 Nov 2012 10:23:52 +0100, Steffen Trumtrar wrote:
> > > Add display_timing structure and the according helper functions. This
> > > allows the description of a display via its supported timing parameters.
> > > 
> > > Every timing parameter can be specified as a single value or a range
> > > <min typ max>.
> > > 
> > > Also, add helper functions to convert from display timings to a generic
> > > videomode structure. This videomode can then be converted to the
> > > corresponding subsystem mode representation (e.g. fb_videomode).
> > > 
> > > Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
> > 
> > Hmmm... here's my thoughts as an outside reviewer. Correct me if I'm
> > making an incorrect assumption.
> > 
> > It looks to me that the purpose of this entire series is to decode video
> > timings from the device tree and (eventually) provide the data in the
> > form 'struct videomode'. Correct?
> > 
> > If so, then it looks over engineered. Creating new infrastructure to
> > allocate, maintain, and free a new 'struct display_timings' doesn't make
> > any sense when it is an intermediary data format that will never be used
> > by drivers.
> > 
> > Can the DT parsing code instead return a table of struct videomode?
> > 
> > But, wait... struct videomode is also a new structure. So it looks like
> > this series creates two new intermediary data structures;
> > display_timings and videomode. And at least as far as I can see in this
> > series struct fb_videomode is the only user.
> 
> struct videomode is supposed to slowly replace the various video mode 
> structures we currently have in the kernel (struct drm_mode_modeinfo, struct 
> fb_videomode and struct v4l2_bt_timings), at least where possible (userspace 
> APIs can't be broken). This will make it possible to reuse code across the 
> DRM, FB and V4L2 subsystems, such as the EDID parser or HDMI encoder drivers. 
> This rationale might not be clearly explained in the commit message, but 
> having a shared video mode structure is pretty important.

Okay that make sense. What about struct display_timings?

g.
