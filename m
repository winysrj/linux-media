Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54444 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957Ab2KPIxP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Nov 2012 03:53:15 -0500
Date: Fri, 16 Nov 2012 09:53:04 +0100
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	devicetree-discuss@lists.ozlabs.org, linux-fbdev@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	Tomi Valkeinen <tomi.valkeinen@ti.com>, kernel@pengutronix.de,
	Guennady Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v10 1/6] video: add display_timing and videomode
Message-ID: <20121116085304.GA7493@pengutronix.de>
References: <1352971437-29877-1-git-send-email-s.trumtrar@pengutronix.de>
 <1352971437-29877-2-git-send-email-s.trumtrar@pengutronix.de>
 <20121115154753.C82223E194B@localhost>
 <2466982.zTBri0jEif@avalon>
 <20121115180359.1E6F33E197F@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121115180359.1E6F33E197F@localhost>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Grant,

On Thu, Nov 15, 2012 at 06:03:59PM +0000, Grant Likely wrote:
> On Thu, 15 Nov 2012 17:00:57 +0100, Laurent Pinchart <laurent.pinchart@ideasonboard.com> wrote:
> > Hi Grant,
> > 
> > On Thursday 15 November 2012 15:47:53 Grant Likely wrote:
> > > On Thu, 15 Nov 2012 10:23:52 +0100, Steffen Trumtrar wrote:
> > > > Add display_timing structure and the according helper functions. This
> > > > allows the description of a display via its supported timing parameters.
> > > > 
> > > > Every timing parameter can be specified as a single value or a range
> > > > <min typ max>.
> > > > 
> > > > Also, add helper functions to convert from display timings to a generic
> > > > videomode structure. This videomode can then be converted to the
> > > > corresponding subsystem mode representation (e.g. fb_videomode).
> > > > 
> > > > Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
> > > 
> > > Hmmm... here's my thoughts as an outside reviewer. Correct me if I'm
> > > making an incorrect assumption.
> > > 
> > > It looks to me that the purpose of this entire series is to decode video
> > > timings from the device tree and (eventually) provide the data in the
> > > form 'struct videomode'. Correct?
> > > 

For the time being it is straight from devicetree via struct videomode
to struct drm_display_mode or fb_videomode. Correct.

> > > If so, then it looks over engineered. Creating new infrastructure to
> > > allocate, maintain, and free a new 'struct display_timings' doesn't make
> > > any sense when it is an intermediary data format that will never be used
> > > by drivers.
> > > 
> > > Can the DT parsing code instead return a table of struct videomode?
> > > 

See below.

> > > But, wait... struct videomode is also a new structure. So it looks like
> > > this series creates two new intermediary data structures;
> > > display_timings and videomode. And at least as far as I can see in this
> > > series struct fb_videomode is the only user.

struct drm_display_mode is also a user in this series see 5/6 and 6/6.

> > 
> > struct videomode is supposed to slowly replace the various video mode 
> > structures we currently have in the kernel (struct drm_mode_modeinfo, struct 
> > fb_videomode and struct v4l2_bt_timings), at least where possible (userspace 
> > APIs can't be broken). This will make it possible to reuse code across the 
> > DRM, FB and V4L2 subsystems, such as the EDID parser or HDMI encoder drivers. 
> > This rationale might not be clearly explained in the commit message, but 
> > having a shared video mode structure is pretty important.
>

That.

> Okay that make sense. What about struct display_timings?
> 

The reason for defining an intermediary step is because of the different things
that are described:
- struct display_timing describes the signal ranges a display supports
- struct display_timings describes all timing settings of a display
- struct videomode describes one single mode generated from that settings

It is possible to generate multiple struct videomodes from one
struct display_timing based on the circumstances. And that is a task for the
driver using the display_timing infos. This means drivers are supposed to use
struct display_timings if they need to generate a struct videomode from the
timing ranges of one entry.
This is just the first step in that direction.
I hope this makes the need for struct display_timings a little clearer.
The other solution would be the one Laurent suggested and pass multiple values
around. Which in my opinion doesn't make it better, more practical or cleaner.


Regards,
Steffen

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
