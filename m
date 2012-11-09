Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50966 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013Ab2KIIXA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Nov 2012 03:23:00 -0500
Date: Fri, 9 Nov 2012 09:22:51 +0100
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: Rob Herring <robherring2@gmail.com>
Cc: devicetree-discuss@lists.ozlabs.org, linux-fbdev@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Thierry Reding <thierry.reding@avionic-design.de>,
	Guennady Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Stephen Warren <swarren@wwwdotorg.org>, kernel@pengutronix.de
Subject: Re: [PATCH v7 0/8] of: add display helper
Message-ID: <20121109082251.GA8598@pengutronix.de>
References: <1351675689-26814-1-git-send-email-s.trumtrar@pengutronix.de>
 <509C25B3.5060509@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <509C25B3.5060509@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 08, 2012 at 03:35:47PM -0600, Rob Herring wrote:
> On 10/31/2012 04:28 AM, Steffen Trumtrar wrote:
> > Hi!
> > 
> > Finally, v7 of the series.
> > 
> > Changes since v6:
> > 	- get rid of some empty lines etc.
> > 	- move functions to their subsystems
> > 	- split of_ from non-of_ functions
> > 	- add at least some kerneldoc to some functions
> > 
> > Regards,
> > Steffen
> > 
> > 
> > Steffen Trumtrar (8):
> >   video: add display_timing struct and helpers
> >   of: add helper to parse display timings
> >   of: add generic videomode description
> >   video: add videomode helpers
> >   fbmon: add videomode helpers
> >   fbmon: add of_videomode helpers
> >   drm_modes: add videomode helpers
> >   drm_modes: add of_videomode helpers
> > 
> >  .../devicetree/bindings/video/display-timings.txt  |  139 +++++++++++++++
> >  drivers/gpu/drm/drm_modes.c                        |   78 +++++++++
> >  drivers/of/Kconfig                                 |   12 ++
> >  drivers/of/Makefile                                |    2 +
> >  drivers/of/of_display_timings.c                    |  185 ++++++++++++++++++++
> >  drivers/of/of_videomode.c                          |   47 +++++
> 
> Not sure why you moved this, but please move this back to drivers/video.
> We're trying to move subsystem specific pieces out of drivers/of.
> 
> Rob
> 

Hm, the of_xxx part always was in drivers/of, but I can move that. No problem.

Regards,
Steffen

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
