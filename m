Return-path: <mchehab@localhost>
Received: from devils.ext.ti.com ([198.47.26.153]:51973 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841Ab0IDIlR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Sep 2010 04:41:17 -0400
From: Archit Taneja <archit@ti.com>
To: hvaibhav@ti.com
Cc: linux-omap@vger.kernel.org, linux-media@vger.kernel.org,
	Archit Taneja <archit@ti.com>
Subject: [PATCH 0/2] V4L/DVB: OMAP_VOUT: Allow omap_vout to build without VRFB
Date: Sat,  4 Sep 2010 14:11:43 +0530
Message-Id: <1283589705-6723-1-git-send-email-archit@ti.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@localhost>

This lets omap_vout driver build and run without VRFB. It works along the
lines of the following patch series:
OMAP: DSS2: OMAPFB: Allow FB_OMAP2 to build without VRFB
https://patchwork.kernel.org/patch/105371/

A variable rotation_type is introduced in omapvideo_info like the way in
omapfb_info to make both vrfb and non vrfb rotation possible.

Since VRFB is tightly coupled with the omap_vout driver, a handful of
vrfb-specific functions have been defined and placed in omap_vout_vrfb.c

This series applies along with the previously submitted patch:
https://patchwork.kernel.org/patch/146401/

Archit Taneja (2):
  V4L/DVB: OMAP_VOUT: Create a seperate vrfb functions library
  V4L/DVB: OMAP_VOUT: Use rotation_type to choose between vrfb and
    sdram rotation

 drivers/media/video/omap/Kconfig          |    1 -
 drivers/media/video/omap/Makefile         |    1 +
 drivers/media/video/omap/omap_vout.c      |  502 ++++++-----------------------
 drivers/media/video/omap/omap_vout_vrfb.c |  417 ++++++++++++++++++++++++
 drivers/media/video/omap/omap_vout_vrfb.h |   40 +++
 drivers/media/video/omap/omap_voutdef.h   |   26 ++
 6 files changed, 582 insertions(+), 405 deletions(-)
 create mode 100644 drivers/media/video/omap/omap_vout_vrfb.c
 create mode 100644 drivers/media/video/omap/omap_vout_vrfb.h

