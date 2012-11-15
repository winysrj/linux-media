Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45768 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946008Ab2KOJYY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Nov 2012 04:24:24 -0500
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
Subject: [PATCH v10 0/6] of: add display helper
Date: Thu, 15 Nov 2012 10:23:51 +0100
Message-Id: <1352971437-29877-1-git-send-email-s.trumtrar@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

Changes since v9:
	- don't leak memory when previous timings were correct
	- CodingStyle fixes
	- move blank lines around

Regards,
Steffen


Steffen Trumtrar (6):
  video: add display_timing and videomode
  video: add of helper for videomode
  fbmon: add videomode helpers
  fbmon: add of_videomode helpers
  drm_modes: add videomode helpers
  drm_modes: add of_videomode helpers

 .../devicetree/bindings/video/display-timings.txt  |  107 ++++++++++
 drivers/gpu/drm/drm_modes.c                        |   70 +++++++
 drivers/video/Kconfig                              |   19 ++
 drivers/video/Makefile                             |    4 +
 drivers/video/display_timing.c                     |   24 +++
 drivers/video/fbmon.c                              |   86 ++++++++
 drivers/video/of_display_timing.c                  |  212 ++++++++++++++++++++
 drivers/video/of_videomode.c                       |   47 +++++
 drivers/video/videomode.c                          |   45 +++++
 include/drm/drmP.h                                 |   12 ++
 include/linux/display_timing.h                     |   69 +++++++
 include/linux/fb.h                                 |   12 ++
 include/linux/of_display_timings.h                 |   20 ++
 include/linux/of_videomode.h                       |   17 ++
 include/linux/videomode.h                          |   40 ++++
 15 files changed, 784 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/video/display-timings.txt
 create mode 100644 drivers/video/display_timing.c
 create mode 100644 drivers/video/of_display_timing.c
 create mode 100644 drivers/video/of_videomode.c
 create mode 100644 drivers/video/videomode.c
 create mode 100644 include/linux/display_timing.h
 create mode 100644 include/linux/of_display_timings.h
 create mode 100644 include/linux/of_videomode.h
 create mode 100644 include/linux/videomode.h

-- 
1.7.10.4

