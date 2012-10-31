Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39214 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932172Ab2JaJ3E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Oct 2012 05:29:04 -0400
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: devicetree-discuss@lists.ozlabs.org
Cc: Steffen Trumtrar <s.trumtrar@pengutronix.de>,
	"Rob Herring" <robherring2@gmail.com>, linux-fbdev@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	"Laurent Pinchart" <laurent.pinchart@ideasonboard.com>,
	"Thierry Reding" <thierry.reding@avionic-design.de>,
	"Guennady Liakhovetski" <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org,
	"Tomi Valkeinen" <tomi.valkeinen@ti.com>,
	"Stephen Warren" <swarren@wwwdotorg.org>, kernel@pengutronix.de
Subject: [PATCH v7 0/8] of: add display helper
Date: Wed, 31 Oct 2012 10:28:00 +0100
Message-Id: <1351675689-26814-1-git-send-email-s.trumtrar@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

Finally, v7 of the series.

Changes since v6:
	- get rid of some empty lines etc.
	- move functions to their subsystems
	- split of_ from non-of_ functions
	- add at least some kerneldoc to some functions

Regards,
Steffen


Steffen Trumtrar (8):
  video: add display_timing struct and helpers
  of: add helper to parse display timings
  of: add generic videomode description
  video: add videomode helpers
  fbmon: add videomode helpers
  fbmon: add of_videomode helpers
  drm_modes: add videomode helpers
  drm_modes: add of_videomode helpers

 .../devicetree/bindings/video/display-timings.txt  |  139 +++++++++++++++
 drivers/gpu/drm/drm_modes.c                        |   78 +++++++++
 drivers/of/Kconfig                                 |   12 ++
 drivers/of/Makefile                                |    2 +
 drivers/of/of_display_timings.c                    |  185 ++++++++++++++++++++
 drivers/of/of_videomode.c                          |   47 +++++
 drivers/video/Kconfig                              |   11 ++
 drivers/video/Makefile                             |    2 +
 drivers/video/display_timing.c                     |   24 +++
 drivers/video/fbmon.c                              |   76 ++++++++
 drivers/video/videomode.c                          |   44 +++++
 include/drm/drmP.h                                 |    8 +
 include/linux/display_timing.h                     |   69 ++++++++
 include/linux/fb.h                                 |    5 +
 include/linux/of_display_timings.h                 |   20 +++
 include/linux/of_videomode.h                       |   15 ++
 include/linux/videomode.h                          |   36 ++++
 17 files changed, 773 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/video/display-timings.txt
 create mode 100644 drivers/of/of_display_timings.c
 create mode 100644 drivers/of/of_videomode.c
 create mode 100644 drivers/video/display_timing.c
 create mode 100644 drivers/video/videomode.c
 create mode 100644 include/linux/display_timing.h
 create mode 100644 include/linux/of_display_timings.h
 create mode 100644 include/linux/of_videomode.h
 create mode 100644 include/linux/videomode.h

-- 
1.7.10.4

