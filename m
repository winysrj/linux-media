Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33212 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753771Ab2KLPib (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Nov 2012 10:38:31 -0500
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
Subject: [PATCH v8 0/6] of: add display helper
Date: Mon, 12 Nov 2012 16:37:00 +0100
Message-Id: <1352734626-27412-1-git-send-email-s.trumtrar@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

This is v8 of the display helper series

Changes since v7:
	- move of_xxx to drivers/video
	- remove non-binding documentation from display-timings.txt
	- squash display_timings and videomode in one patch
	- misc minor fixes

Regards,
Steffen


Steffen Trumtrar (6):
  video: add display_timing and videomode
  video: add of helper for videomode
  fbmon: add videomode helpers
  fbmon: add of_videomode helpers
  drm_modes: add videomode helpers
  drm_modes: add of_videomode helpers

 .../devicetree/bindings/video/display-timings.txt  |  107 +++++++++++
 drivers/gpu/drm/drm_modes.c                        |   77 ++++++++
 drivers/video/Kconfig                              |   19 ++
 drivers/video/Makefile                             |    4 +
 drivers/video/display_timing.c                     |   22 +++
 drivers/video/fbmon.c                              |   77 ++++++++
 drivers/video/of_display_timing.c                  |  186 ++++++++++++++++++++
 drivers/video/of_videomode.c                       |   47 +++++
 drivers/video/videomode.c                          |   45 +++++
 include/drm/drmP.h                                 |    8 +
 include/linux/display_timing.h                     |   69 ++++++++
 include/linux/fb.h                                 |    5 +
 include/linux/of_display_timings.h                 |   19 ++
 include/linux/of_videomode.h                       |   15 ++
 include/linux/videomode.h                          |   39 ++++
 15 files changed, 739 insertions(+)
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

