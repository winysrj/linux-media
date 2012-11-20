Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:54600 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049Ab2KTQMW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Nov 2012 11:12:22 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
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
Subject: Re: [PATCH v12 0/6] of: add display helper
Date: Tue, 20 Nov 2012 17:13:19 +0100
Message-ID: <1501232.SOApmW1MhU@avalon>
In-Reply-To: <1353426896-6045-1-git-send-email-s.trumtrar@pengutronix.de>
References: <1353426896-6045-1-git-send-email-s.trumtrar@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 20 November 2012 16:54:50 Steffen Trumtrar wrote:
> Hi!
> 
> Changes since v11:
> 	- make pointers const where applicable
> 	- add reviewed-by Laurent Pinchart

Looks good to me.

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Through which tree do you plan to push this ?

> Regards,
> Steffen
> 
> 
> Steffen Trumtrar (6):
>   video: add display_timing and videomode
>   video: add of helper for videomode
>   fbmon: add videomode helpers
>   fbmon: add of_videomode helpers
>   drm_modes: add videomode helpers
>   drm_modes: add of_videomode helpers
> 
>  .../devicetree/bindings/video/display-timings.txt  |  107 ++++++++++
>  drivers/gpu/drm/drm_modes.c                        |   70 +++++++
>  drivers/video/Kconfig                              |   19 ++
>  drivers/video/Makefile                             |    4 +
>  drivers/video/display_timing.c                     |   24 +++
>  drivers/video/fbmon.c                              |   86 ++++++++
>  drivers/video/of_display_timing.c                  |  216 +++++++++++++++++
>  drivers/video/of_videomode.c                       |   48 +++++
>  drivers/video/videomode.c                          |   46 +++++
>  include/drm/drmP.h                                 |   12 ++
>  include/linux/display_timing.h                     |   70 +++++++
>  include/linux/fb.h                                 |   13 ++
>  include/linux/of_display_timings.h                 |   20 ++
>  include/linux/of_videomode.h                       |   18 ++
>  include/linux/videomode.h                          |   40 ++++
>  15 files changed, 793 insertions(+)
>  create mode 100644
> Documentation/devicetree/bindings/video/display-timings.txt create mode
> 100644 drivers/video/display_timing.c
>  create mode 100644 drivers/video/of_display_timing.c
>  create mode 100644 drivers/video/of_videomode.c
>  create mode 100644 drivers/video/videomode.c
>  create mode 100644 include/linux/display_timing.h
>  create mode 100644 include/linux/of_display_timings.h
>  create mode 100644 include/linux/of_videomode.h
>  create mode 100644 include/linux/videomode.h
-- 
Regards,

Laurent Pinchart

