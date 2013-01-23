Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39717 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626Ab3AWJMP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jan 2013 04:12:15 -0500
Date: Wed, 23 Jan 2013 10:12:02 +0100
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: Rob Clark <robdclark@gmail.com>
Cc: devicetree-discuss@lists.ozlabs.org,
	David Airlie <airlied@linux.ie>,
	Rob Herring <robherring2@gmail.com>,
	linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Thierry Reding <thierry.reding@avionic-design.de>,
	Guennady Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	Leela Krishna Amudala <leelakrishna.a@gmail.com>,
	"Mohammed, Afzal" <afzal@ti.com>, kernel@pengutronix.de
Subject: Re: [PATCH v16 RESEND 0/7] of: add display helper
Message-ID: <20130123091202.GA11828@pengutronix.de>
References: <1358766482-6275-1-git-send-email-s.trumtrar@pengutronix.de>
 <CAF6AEGvFNA1gc_5XWqL_baEnn8DTn0R-xqui034rg3Eo-V_6Qw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF6AEGvFNA1gc_5XWqL_baEnn8DTn0R-xqui034rg3Eo-V_6Qw@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 22, 2013 at 03:50:48PM -0600, Rob Clark wrote:
> On Mon, Jan 21, 2013 at 5:07 AM, Steffen Trumtrar
> <s.trumtrar@pengutronix.de> wrote:
> > Hi!
> >
> > There was still no maintainer, that commented, ack'd, nack'd, apply'd the
> > series. So, this is just a resend.
> > The patches were tested with:
> >
> >         - v15 on Tegra by Thierry
> >         - sh-mobile-lcdcfb by Laurent
> >         - MX53QSB by Marek
> >         - Exynos: smdk5250 by Leela
> >         - AM335X EVM & AM335X EVM-SK by Afzal
> >         - imx6q: sabrelite, sabresd by Philipp and me
> >         - imx53: tqma53/mba53 by me
> 
> 
> btw, you can add my tested-by for this series..  I've been using them
> for the tilcdc lcd-panel output driver support.
> 

Thanks. The more drivers the merrier ;-)

Steffen

> >
> >
> > Changes since v15:
> >         - move include/linux/{videomode,display_timing}.h to include/video
> >         - move include/linux/of_{videomode,display_timing}.h to include/video
> >         - reimplement flags: add VESA flags and data flags
> >         - let pixelclock in struct videomode be unsigned long
> >         - rename of_display_timings_exists to of_display_timings_exist
> >         - revise logging/error messages: replace __func__ with np->full_name
> >         - rename pixelclk-inverted to pixelclk-active
> >         - revise comments in code
> >
> > Changes since v14:
> >         - fix "const struct *" warning
> >                 (reported by: Leela Krishna Amudala <l.krishna@samsung.com>)
> >         - return -EINVAL when htotal or vtotal are zero
> >         - remove unreachable code in of_get_display_timings
> >         - include headers in .c files and not implicit in .h
> >         - sort includes alphabetically
> >         - fix lower/uppercase in binding documentation
> >         - rebase onto v3.7-rc7
> >
> > Changes since v13:
> >         - fix "const struct *" warning
> >                 (reported by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>)
> >         - prevent division by zero in fb_videomode_from_videomode
> >
> > Changes since v12:
> >         - rename struct display_timing to via_display_timing in via subsystem
> >         - fix refreshrate calculation
> >         - fix "const struct *" warnings
> >                 (reported by: Manjunathappa, Prakash <prakash.pm@ti.com>)
> >         - some CodingStyle fixes
> >         - rewrite parts of commit messages and display-timings.txt
> >         - let display_timing_get_value get all values instead of just typical
> >
> > Changes since v11:
> >         - make pointers const where applicable
> >         - add reviewed-by Laurent Pinchart
> >
> > Changes since v10:
> >         - fix function name (drm_)display_mode_from_videomode
> >         - add acked-by, reviewed-by, tested-by
> >
> > Changes since v9:
> >         - don't leak memory when previous timings were correct
> >         - CodingStyle fixes
> >         - move blank lines around
> >
> > Changes since v8:
> >         - fix memory leaks
> >         - change API to be more consistent (foo_from_bar(struct bar, struct foo))
> >         - include headers were necessary
> >         - misc minor bugfixes
> >
> > Changes since v7:
> >         - move of_xxx to drivers/video
> >         - remove non-binding documentation from display-timings.txt
> >         - squash display_timings and videomode in one patch
> >         - misc minor fixes
> >
> > Changes since v6:
> >         - get rid of some empty lines etc.
> >         - move functions to their subsystems
> >         - split of_ from non-of_ functions
> >         - add at least some kerneldoc to some functions
> >
> > Changes since v5:
> >         - removed all display stuff and just describe timings
> >
> > Changes since v4:
> >         - refactored functions
> >
> > Changes since v3:
> >         - print error messages
> >         - free alloced memory
> >         - general cleanup
> >
> > Changes since v2:
> >         - use hardware-near property-names
> >         - provide a videomode structure
> >         - allow ranges for all properties (<min,typ,max>)
> >         - functions to get display_mode or fb_videomode
> >
> >
> > Regards,
> > Steffen
> >
> >
> > Steffen Trumtrar (7):
> >   viafb: rename display_timing to via_display_timing
> >   video: add display_timing and videomode
> >   video: add of helper for display timings/videomode
> >   fbmon: add videomode helpers
> >   fbmon: add of_videomode helpers
> >   drm_modes: add videomode helpers
> >   drm_modes: add of_videomode helpers
> >
> >  .../devicetree/bindings/video/display-timing.txt   |  109 +++++++++
> >  drivers/gpu/drm/drm_modes.c                        |   70 ++++++
> >  drivers/video/Kconfig                              |   21 ++
> >  drivers/video/Makefile                             |    4 +
> >  drivers/video/display_timing.c                     |   24 ++
> >  drivers/video/fbmon.c                              |   94 ++++++++
> >  drivers/video/of_display_timing.c                  |  239 ++++++++++++++++++++
> >  drivers/video/of_videomode.c                       |   54 +++++
> >  drivers/video/via/hw.c                             |    6 +-
> >  drivers/video/via/hw.h                             |    2 +-
> >  drivers/video/via/lcd.c                            |    2 +-
> >  drivers/video/via/share.h                          |    2 +-
> >  drivers/video/via/via_modesetting.c                |    8 +-
> >  drivers/video/via/via_modesetting.h                |    6 +-
> >  drivers/video/videomode.c                          |   39 ++++
> >  include/drm/drmP.h                                 |    9 +
> >  include/linux/fb.h                                 |    8 +
> >  include/video/display_timing.h                     |  124 ++++++++++
> >  include/video/of_display_timing.h                  |   20 ++
> >  include/video/of_videomode.h                       |   18 ++
> >  include/video/videomode.h                          |   48 ++++
> >  21 files changed, 894 insertions(+), 13 deletions(-)
> >  create mode 100644 Documentation/devicetree/bindings/video/display-timing.txt
> >  create mode 100644 drivers/video/display_timing.c
> >  create mode 100644 drivers/video/of_display_timing.c
> >  create mode 100644 drivers/video/of_videomode.c
> >  create mode 100644 drivers/video/videomode.c
> >  create mode 100644 include/video/display_timing.h
> >  create mode 100644 include/video/of_display_timing.h
> >  create mode 100644 include/video/of_videomode.h
> >  create mode 100644 include/video/videomode.h
> >
> > --
> > 1.7.10.4
> >
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
