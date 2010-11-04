Return-path: <mchehab@gaivota>
Received: from arroyo.ext.ti.com ([192.94.94.40]:55306 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753020Ab0KDHzk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Nov 2010 03:55:40 -0400
From: Archit Taneja <archit@ti.com>
To: hvaibhav@ti.com
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	Archit Taneja <archit@ti.com>
Subject: [PATCH v3 0/3] V4L/DVB: OMAP_VOUT: Allow omap_vout to build without VRFB
Date: Thu,  4 Nov 2010 13:26:23 +0530
Message-Id: <1288857386-15431-1-git-send-email-archit@ti.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

This lets omap_vout driver build and run without VRFB. It works along the
lines of the following patch series:

OMAP: DSS2: OMAPFB: Allow FB_OMAP2 to build without VRFB
https://patchwork.kernel.org/patch/105371/

Since VRFB is tightly coupled with the omap_vout driver, a handful of vrfb
specific functions have been defined and placed in omap_vout_vrfb.c

A new enum called vout_rotation_type is introduced to differentiate between no
rotation and vrfb rotation. A member rotation_type is introduced in omapvideo_info,
this allows to call vrfb specific functions only if the rotation type is VOUT_ROT_VRFB
When the rotation_type is set to VOUT_ROT_NONE, the S_CTRL ioctl prevents the user setting
a non zero rotation or non zero mirror value.

Archit Taneja (3):
  V4L/DVB: OMAP_VOUT: Move some functions and preprocessor defines from
    omap_vout
  V4L/DVB: OMAP_VOUT: Create a seperate vrfb functions library
  V4L/DVB: OMAP_VOUT: Use rotation_type to choose between vrfb rotation
    and no rotation

 drivers/media/video/omap/Kconfig          |    2 +-
 drivers/media/video/omap/Makefile         |    1 +
 drivers/media/video/omap/omap_vout.c      |  560 +++++------------------------
 drivers/media/video/omap/omap_vout_vrfb.c |  411 +++++++++++++++++++++
 drivers/media/video/omap/omap_vout_vrfb.h |   42 +++
 drivers/media/video/omap/omap_voutdef.h   |   77 ++++
 drivers/media/video/omap/omap_voutlib.c   |   44 +++
 drivers/media/video/omap/omap_voutlib.h   |    2 +
 8 files changed, 659 insertions(+), 480 deletions(-)
 create mode 100644 drivers/media/video/omap/omap_vout_vrfb.c
 create mode 100644 drivers/media/video/omap/omap_vout_vrfb.h
--
Version 3:
 - Introduce a new enum at V4L2 driver level which cleanly differentiates
   between vrfb rotation and no rotation, incorporate comments given for v2
Version 2:
 - Don't try to enable SDRAM rotation , return an error if non zero rotation
   is attempted when rotation_type is set to SDMA rotation.
Version 1:
   http://www.mail-archive.com/linux-media@vger.kernel.org/msg21937.html
