Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37100 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020Ab2KTLLR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Nov 2012 06:11:17 -0500
Date: Tue, 20 Nov 2012 12:11:09 +0100
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: devicetree-discuss@lists.ozlabs.org,
	Rob Herring <robherring2@gmail.com>,
	linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Thierry Reding <thierry.reding@avionic-design.de>,
	Guennady Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Stephen Warren <swarren@wwwdotorg.org>, kernel@pengutronix.de,
	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	David Airlie <airlied@linux.ie>
Subject: Re: [PATCH v11 0/6] of: add display helper
Message-ID: <20121120111109.GC11249@pengutronix.de>
References: <1352985312-18178-1-git-send-email-s.trumtrar@pengutronix.de>
 <20121120103918.GB11249@pengutronix.de>
 <5248190.b4XqndYeI2@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5248190.b4XqndYeI2@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Nov 20, 2012 at 11:52:06AM +0100, Laurent Pinchart wrote:
> Hi Steffen,
> 
> On Tuesday 20 November 2012 11:39:18 Steffen Trumtrar wrote:
> > On Thu, Nov 15, 2012 at 02:15:06PM +0100, Steffen Trumtrar wrote:
> > > Hi!
> > > 
> > > Changes since v10:
> > > 	- fix function name (drm_)display_mode_from_videomode
> > > 	- add acked-by, reviewed-by, tested-by
> > > 
> > > Regards,
> > > Steffen
> > > 
> > > Steffen Trumtrar (6):
> > >   video: add display_timing and videomode
> > >   video: add of helper for videomode
> > >   fbmon: add videomode helpers
> > >   fbmon: add of_videomode helpers
> > >   drm_modes: add videomode helpers
> > >   drm_modes: add of_videomode helpers
> > >  
> > >  .../devicetree/bindings/video/display-timings.txt  |  107 ++++++++++
> > >  drivers/gpu/drm/drm_modes.c                        |   70 +++++++
> > >  drivers/video/Kconfig                              |   19 ++
> > >  drivers/video/Makefile                             |    4 +
> > >  drivers/video/display_timing.c                     |   24 +++
> > >  drivers/video/fbmon.c                              |   86 ++++++++
> > >  drivers/video/of_display_timing.c                  |  212 +++++++++++++++
> > >  drivers/video/of_videomode.c                       |   47 +++++
> > >  drivers/video/videomode.c                          |   45 +++++
> > >  include/drm/drmP.h                                 |   12 ++
> > >  include/linux/display_timing.h                     |   69 +++++++
> > >  include/linux/fb.h                                 |   12 ++
> > >  include/linux/of_display_timings.h                 |   20 ++
> > >  include/linux/of_videomode.h                       |   17 ++
> > >  include/linux/videomode.h                          |   40 ++++
> > >  15 files changed, 784 insertions(+)
> > >  create mode 100644
> > >  Documentation/devicetree/bindings/video/display-timings.txt create mode
> > >  100644 drivers/video/display_timing.c
> > >  create mode 100644 drivers/video/of_display_timing.c
> > >  create mode 100644 drivers/video/of_videomode.c
> > >  create mode 100644 drivers/video/videomode.c
> > >  create mode 100644 include/linux/display_timing.h
> > >  create mode 100644 include/linux/of_display_timings.h
> > >  create mode 100644 include/linux/of_videomode.h
> > >  create mode 100644 include/linux/videomode.h
> > 
> > Ping!
> > 
> > Any comments or taker for v11? Errors are fixed, driver is tested and
> > working, DT binding got two ACKs. So, the series is finished as far as I
> > can tell.
> 
> Just one last comment, sorry for not bringing this up earlier. Could you 
> constify pointer arguments to functions where applicable ? For instance
> 
> int videomode_from_timing(struct display_timings *disp, struct videomode *vm,
>                           unsigned int index);
> 
> The function shouldn't modify disp, so you can make it const. Same for most of 
> the API functions.
> 

Okay. Will do.

> You can then add my
> 
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 

Thanks.

Regards,
Steffen

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
