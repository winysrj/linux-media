Return-path: <mchehab@pedra>
Received: from comal.ext.ti.com ([198.47.26.152]:56286 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753234Ab1FNGrk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jun 2011 02:47:40 -0400
Received: from dlep35.itg.ti.com ([157.170.170.118])
	by comal.ext.ti.com (8.13.7/8.13.7) with ESMTP id p5E6legK002611
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Tue, 14 Jun 2011 01:47:40 -0500
Received: from dlep26.itg.ti.com (smtp-le.itg.ti.com [157.170.170.27])
	by dlep35.itg.ti.com (8.13.7/8.13.8) with ESMTP id p5E6ld4e008410
	for <linux-media@vger.kernel.org>; Tue, 14 Jun 2011 01:47:39 -0500 (CDT)
Received: from dlee73.ent.ti.com (localhost [127.0.0.1])
	by dlep26.itg.ti.com (8.13.8/8.13.8) with ESMTP id p5E6ldOl022049
	for <linux-media@vger.kernel.org>; Tue, 14 Jun 2011 01:47:39 -0500 (CDT)
From: Archit Taneja <archit@ti.com>
To: <hvaibhav@ti.com>
CC: linux-media@vger.kernel.org, Archit Taneja <archit@ti.com>
Subject: [PATCH v2 0/3] OMAP_VOUT: Allow omap_vout to build without VRFB
Date: Tue, 14 Jun 2011 12:24:44 +0530
Message-ID: <1308034487-11852-1-git-send-email-archit@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Introduce omap_vout_vrfb.c and omap_vout_vrfb.h, for all VRFB related API's,
making OMAP_VOUT driver independent from VRFB. This is required for OMAP4 DSS,
since OMAP4 doesn't have VRFB block.

A new enum called vout_rotation_type is introduced to differentiate between no
rotation and vrfb rotation. A member rotation_type is introduced in
omapvideo_info, this allows to call vrfb specific functions only if the rotation
type is VOUT_ROT_VRFB. When the rotation_type is set to VOUT_ROT_NONE, the
S_CTRL ioctl prevents the user setting a non zero rotation or non zero mirror
value.

Changes since v1:
- add a patch to make rotation related functions names more descriptive.
- remove unnecessary externs, add static to some local functions.
- improve patch description.

Archit Taneja (3):
  OMAP_VOUT: CLEANUP: Move generic functions and macros to common files
  OMAP_VOUT: CLEANUP: Make rotation related helper functions more
    descriptive
  OMAP_VOUT: Create separate file for VRFB related API's

 drivers/media/video/omap/Kconfig          |    7 +-
 drivers/media/video/omap/Makefile         |    1 +
 drivers/media/video/omap/omap_vout.c      |  582 +++++------------------------
 drivers/media/video/omap/omap_vout_vrfb.c |  390 +++++++++++++++++++
 drivers/media/video/omap/omap_vout_vrfb.h |   40 ++
 drivers/media/video/omap/omap_voutdef.h   |   78 ++++
 drivers/media/video/omap/omap_voutlib.c   |   46 +++
 drivers/media/video/omap/omap_voutlib.h   |   12 +-
 8 files changed, 661 insertions(+), 495 deletions(-)
 create mode 100644 drivers/media/video/omap/omap_vout_vrfb.c
 create mode 100644 drivers/media/video/omap/omap_vout_vrfb.h

