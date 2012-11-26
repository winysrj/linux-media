Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42079 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754703Ab2KZJIR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Nov 2012 04:08:17 -0500
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
	"Stephen Warren" <swarren@wwwdotorg.org>, kernel@pengutronix.de,
	"Florian Tobias Schandinat" <FlorianSchandinat@gmx.de>,
	"David Airlie" <airlied@linux.ie>
Subject: [PATCHv15 0/7] of: add display helper
Date: Mon, 26 Nov 2012 10:07:21 +0100
Message-Id: <1353920848-1705-1-git-send-email-s.trumtrar@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

Changes since v14:
	- fix "const struct *" warning
		(reported by: Leela Krishna Amudala <l.krishna@samsung.com>)
	- return -EINVAL when htotal or vtotal are zero
	- remove unreachable code in of_get_display_timings
	- include headers in .c files and not implicit in .h
	- sort includes alphabetically
	- fix lower/uppercase in binding documentation
	- rebase onto v3.7-rc7

Changes since v13:
	- fix "const struct *" warning
		(reported by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>)
	- prevent division by zero in fb_videomode_from_videomode

Changes since v12:
	- rename struct display_timing to via_display_timing in via subsystem
	- fix refreshrate calculation
	- fix "const struct *" warnings
		(reported by: Manjunathappa, Prakash <prakash.pm@ti.com>)
	- some CodingStyle fixes
	- rewrite parts of commit messages and display-timings.txt
	- let display_timing_get_value get all values instead of just typical

Changes since v11:
	- make pointers const where applicable
	- add reviewed-by Laurent Pinchart

Changes since v10:
	- fix function name (drm_)display_mode_from_videomode
	- add acked-by, reviewed-by, tested-by

Changes since v9:
	- don't leak memory when previous timings were correct
	- CodingStyle fixes
	- move blank lines around

Changes since v8:
	- fix memory leaks
	- change API to be more consistent (foo_from_bar(struct bar, struct foo))
	- include headers were necessary
	- misc minor bufixe

Changes since v7:
	- move of_xxx to drivers/video
	- remove non-binding documentation from display-timings.txt
	- squash display_timings and videomode in one patch
	- misc minor fixes

Changes since v6:
	- get rid of some empty lines etc.
	- move functions to their subsystems
	- split of_ from non-of_ functions
	- add at least some kerneldoc to some functions

Changes since v5:
	- removed all display stuff and just describe timings

Changes since v4:
	- refactored functions

Changes since v3:
	- print error messages
	- free alloced memory
	- general cleanup

Changes since v2:
	- use hardware-near property-names
	- provide a videomode structure
	- allow ranges for all properties (<min,typ,max>)
	- functions to get display_mode or fb_videomode


Steffen Trumtrar (7):
  viafb: rename display_timing to via_display_timing
  video: add display_timing and videomode
  video: add of helper for display timings/videomode
  fbmon: add videomode helpers
  fbmon: add of_videomode helpers
  drm_modes: add videomode helpers
  drm_modes: add of_videomode helpers

 .../devicetree/bindings/video/display-timing.txt   |  107 ++++++++++
 drivers/gpu/drm/drm_modes.c                        |   70 +++++++
 drivers/video/Kconfig                              |   21 ++
 drivers/video/Makefile                             |    4 +
 drivers/video/display_timing.c                     |   24 +++
 drivers/video/fbmon.c                              |   93 +++++++++
 drivers/video/of_display_timing.c                  |  219 ++++++++++++++++++++
 drivers/video/of_videomode.c                       |   54 +++++
 drivers/video/via/hw.c                             |    6 +-
 drivers/video/via/hw.h                             |    2 +-
 drivers/video/via/lcd.c                            |    2 +-
 drivers/video/via/share.h                          |    2 +-
 drivers/video/via/via_modesetting.c                |    8 +-
 drivers/video/via/via_modesetting.h                |    6 +-
 drivers/video/videomode.c                          |   44 ++++
 include/drm/drmP.h                                 |   13 ++
 include/linux/display_timing.h                     |  104 ++++++++++
 include/linux/fb.h                                 |   12 ++
 include/linux/of_display_timing.h                  |   20 ++
 include/linux/of_videomode.h                       |   18 ++
 include/linux/videomode.h                          |   54 +++++
 21 files changed, 870 insertions(+), 13 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/video/display-timing.txt
 create mode 100644 drivers/video/display_timing.c
 create mode 100644 drivers/video/of_display_timing.c
 create mode 100644 drivers/video/of_videomode.c
 create mode 100644 drivers/video/videomode.c
 create mode 100644 include/linux/display_timing.h
 create mode 100644 include/linux/of_display_timing.h
 create mode 100644 include/linux/of_videomode.h
 create mode 100644 include/linux/videomode.h

-- 
1.7.10.4

