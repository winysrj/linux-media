Return-path: <mchehab@gaivota>
Received: from bear.ext.ti.com ([192.94.94.41]:50137 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752478Ab0LQGnL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Dec 2010 01:43:11 -0500
From: Archit Taneja <archit@ti.com>
To: linux-media@vger.kernel.org
Cc: linux-omap@vger.kernel.org, Archit Taneja <archit@ti.com>
Subject: [PATCH v4 0/2] OMAP_VOUT: Allow omap_vout to build without VRFB
Date: Fri, 17 Dec 2010 12:13:26 +0530
Message-Id: <1292568208-16049-1-git-send-email-archit@ti.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Introduce omap_vout_vrfb.c and omap_vout_vrfb.h, for all VRFB related API's,
making OMAP_VOUT driver independent from VRFB. This is required for OMAP4 DSS,
since OMAP4 doesn't have VRFB block.

A new enum called vout_rotation_type is introduced to differentiate between no
rotation and vrfb rotation. A member rotation_type is introduced in omapvideo_info,
this allows to call vrfb specific functions only if the rotation type is VOUT_ROT_VRFB
When the rotation_type is set to VOUT_ROT_NONE, the S_CTRL ioctl prevents the user setting
a non zero rotation or non zero mirror value.

Archit Taneja (2):
  OMAP_VOUT: CLEANUP: Move some functions and macros from omap_vout
  OMAP_VOUT: Create separate file for VRFB related API's

 drivers/media/video/omap/Kconfig          |    2 +-
 drivers/media/video/omap/Makefile         |    1 +
 drivers/media/video/omap/omap_vout.c      |  566 +++++------------------------
 drivers/media/video/omap/omap_vout_vrfb.c |  390 ++++++++++++++++++++
 drivers/media/video/omap/omap_vout_vrfb.h |   40 ++
 drivers/media/video/omap/omap_voutdef.h   |   78 ++++
 drivers/media/video/omap/omap_voutlib.c   |   44 +++
 drivers/media/video/omap/omap_voutlib.h   |    2 +
 8 files changed, 640 insertions(+), 483 deletions(-)
 create mode 100644 drivers/media/video/omap/omap_vout_vrfb.c
 create mode 100644 drivers/media/video/omap/omap_vout_vrfb.h
--
Version 4:
 - Some minor fixes, renaming of git commits, patches 2 and 3 merged into 1.
Version 3:
 - Introduce a new enum at V4L2 driver level which cleanly differentiates
   between vrfb rotation and no rotation, incorporate comments given for v2
Version 2:
 - Don't try to enable SDRAM rotation , return an error if non zero rotation
   is attempted when rotation_type is set to SDMA rotation.
Version 1:
   http://www.mail-archive.com/linux-media@vger.kernel.org/msg21937.html
