Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56920 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754617Ab2KVSju (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Nov 2012 13:39:50 -0500
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: devicetree-discuss@lists.ozlabs.org
Cc: "Rob Herring" <robherring2@gmail.com>, linux-fbdev@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	"Laurent Pinchart" <laurent.pinchart@ideasonboard.com>,
	"Thierry Reding" <thierry.reding@avionic-design.de>,
	"Guennady Liakhovetski" <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org,
	"Tomi Valkeinen" <tomi.valkeinen@ti.com>,
	"Stephen Warren" <swarren@wwwdotorg.org>, kernel@pengutronix.de,
	"Florian Tobias Schandinat" <FlorianSchandinat@gmx.de>,
	"David Airlie" <airlied@linux.ie>
Subject: [PATCHv13 0/7] of: add display helper
Date: Thu, 22 Nov 2012 17:00:08 +0100
Message-Id: <1353600015-6974-1-git-send-email-s.trumtrar@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

Changes since v12:
	- rename struct display_timing to via_display_timing in via subsystem
	- fix refreshrate calculation
	- fix "const struct *" warnings
		(reported by: "Manjunathappa, Prakash" <prakash.pm@ti.com>)
	- some CodingStyle fixes
	- rewrite parts of commit messages and display-timings.txt
	- let display_timing_get_value get all values instead of just typical

Regards,
Steffen

Steffen Trumtrar (7):
  viafb: rename display_timing to via_display_timing
  video: add display_timing and videomode
  video: add of helper for display timings/videomode
  fbmon: add videomode helpers
  fbmon: add of_videomode helpers
  drm_modes: add videomode helpers
  drm_modes: add of_videomode helpers

 .../devicetree/bindings/video/display-timings.txt  |  107 ++++++++++
 drivers/gpu/drm/drm_modes.c                        |   69 ++++++
 drivers/video/Kconfig                              |   21 ++
 drivers/video/Makefile                             |    4 +
 drivers/video/display_timing.c                     |   24 +++
 drivers/video/fbmon.c                              |   84 ++++++++
 drivers/video/of_display_timing.c                  |  223 ++++++++++++++++++++
 drivers/video/of_videomode.c                       |   48 +++++
 drivers/video/via/hw.c                             |    6 +-
 drivers/video/via/hw.h                             |    2 +-
 drivers/video/via/lcd.c                            |    2 +-
 drivers/video/via/share.h                          |    2 +-
 drivers/video/via/via_modesetting.c                |    8 +-
 drivers/video/via/via_modesetting.h                |    6 +-
 drivers/video/videomode.c                          |   45 ++++
 include/drm/drmP.h                                 |   12 ++
 include/linux/display_timing.h                     |  104 +++++++++
 include/linux/fb.h                                 |   12 ++
 include/linux/of_display_timings.h                 |   20 ++
 include/linux/of_videomode.h                       |   18 ++
 include/linux/videomode.h                          |   52 +++++
 21 files changed, 856 insertions(+), 13 deletions(-)
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

