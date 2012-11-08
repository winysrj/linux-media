Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:37311 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756999Ab2KHVfv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Nov 2012 16:35:51 -0500
Message-ID: <509C25B3.5060509@gmail.com>
Date: Thu, 08 Nov 2012 15:35:47 -0600
From: Rob Herring <robherring2@gmail.com>
MIME-Version: 1.0
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
CC: devicetree-discuss@lists.ozlabs.org, linux-fbdev@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Thierry Reding <thierry.reding@avionic-design.de>,
	Guennady Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Stephen Warren <swarren@wwwdotorg.org>, kernel@pengutronix.de
Subject: Re: [PATCH v7 0/8] of: add display helper
References: <1351675689-26814-1-git-send-email-s.trumtrar@pengutronix.de>
In-Reply-To: <1351675689-26814-1-git-send-email-s.trumtrar@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/31/2012 04:28 AM, Steffen Trumtrar wrote:
> Hi!
> 
> Finally, v7 of the series.
> 
> Changes since v6:
> 	- get rid of some empty lines etc.
> 	- move functions to their subsystems
> 	- split of_ from non-of_ functions
> 	- add at least some kerneldoc to some functions
> 
> Regards,
> Steffen
> 
> 
> Steffen Trumtrar (8):
>   video: add display_timing struct and helpers
>   of: add helper to parse display timings
>   of: add generic videomode description
>   video: add videomode helpers
>   fbmon: add videomode helpers
>   fbmon: add of_videomode helpers
>   drm_modes: add videomode helpers
>   drm_modes: add of_videomode helpers
> 
>  .../devicetree/bindings/video/display-timings.txt  |  139 +++++++++++++++
>  drivers/gpu/drm/drm_modes.c                        |   78 +++++++++
>  drivers/of/Kconfig                                 |   12 ++
>  drivers/of/Makefile                                |    2 +
>  drivers/of/of_display_timings.c                    |  185 ++++++++++++++++++++
>  drivers/of/of_videomode.c                          |   47 +++++

Not sure why you moved this, but please move this back to drivers/video.
We're trying to move subsystem specific pieces out of drivers/of.

Rob

>  drivers/video/Kconfig                              |   11 ++
>  drivers/video/Makefile                             |    2 +
>  drivers/video/display_timing.c                     |   24 +++
>  drivers/video/fbmon.c                              |   76 ++++++++
>  drivers/video/videomode.c                          |   44 +++++
>  include/drm/drmP.h                                 |    8 +
>  include/linux/display_timing.h                     |   69 ++++++++
>  include/linux/fb.h                                 |    5 +
>  include/linux/of_display_timings.h                 |   20 +++
>  include/linux/of_videomode.h                       |   15 ++
>  include/linux/videomode.h                          |   36 ++++
>  17 files changed, 773 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/video/display-timings.txt
>  create mode 100644 drivers/of/of_display_timings.c
>  create mode 100644 drivers/of/of_videomode.c
>  create mode 100644 drivers/video/display_timing.c
>  create mode 100644 drivers/video/videomode.c
>  create mode 100644 include/linux/display_timing.h
>  create mode 100644 include/linux/of_display_timings.h
>  create mode 100644 include/linux/of_videomode.h
>  create mode 100644 include/linux/videomode.h
> 

