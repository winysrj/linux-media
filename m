Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39435 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756324Ab2IXPgI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Sep 2012 11:36:08 -0400
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: devicetree-discuss@lists.ozlabs.org
Cc: Rob Herring <robherring2@gmail.com>, linux-fbdev@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	kernel@pengutronix.de, linux-media@vger.kernel.org,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: [PATCH v5] of: add display helper (was: of: add videomode helper)
Date: Mon, 24 Sep 2012 17:35:22 +0200
Message-Id: <1348500924-8551-1-git-send-email-s.trumtrar@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi!

After the feedback I got on v4, I thought about the current state of the 
videomode helper and decided to reengineer it. The most confusion seems to
stem from the fact, that a videomode does not have ranges. And that is correct.
Therefore the description of the display now uses a list of timings.
These timings support ranges, as they do in datasheets (min/typ/max).

A device driver may choose to grep a display-description from the devicetree and
directly work with that (matching parameters according to their range etc.).
Or one can use the former struct videomode to convert from the timings to a videomode
(at the moment it just grabs the typical-value from every timing-parameter).
This videomode on the other hand, can then be converted to a mode the backend wants
(drm_mode_info, fb_videomode,...).
As of now, this intermediate step is a bit, well, unnecessary. But it provides a way
to have a generic videomode and functions to possibly convert back-and-forth.
In the end, this version does the same as of_videomode, but I hope makes the whole
thing a little clearer.

Thanks to everybody who reviewed the previous versions.
Feedback is always welcome.

Regards,
Steffen


----------------------------------------------------------------
Steffen Trumtrar (2):
      of: add helper to parse display specs
      video: add generic videomode description

 Documentation/devicetree/bindings/video/display |  208 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/of/Kconfig                              |    5 +++
 drivers/of/Makefile                             |    1 +
 drivers/of/of_display.c                         |  157 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/video/Makefile                          |    1 +
 drivers/video/videomode.c                       |  146 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/display.h                         |   85 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/of_display.h                      |   15 ++++++++
 include/linux/videomode.h                       |   38 +++++++++++++++++++
 9 files changed, 656 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/video/display
 create mode 100644 drivers/of/of_display.c
 create mode 100644 drivers/video/videomode.c
 create mode 100644 include/linux/display.h
 create mode 100644 include/linux/of_display.h
 create mode 100644 include/linux/videomode.h
