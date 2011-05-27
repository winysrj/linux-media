Return-path: <mchehab@pedra>
Received: from comal.ext.ti.com ([198.47.26.152]:44251 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752960Ab1E0Gzp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 27 May 2011 02:55:45 -0400
Received: from dlep33.itg.ti.com ([157.170.170.112])
	by comal.ext.ti.com (8.13.7/8.13.7) with ESMTP id p4R6tisK021503
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Fri, 27 May 2011 01:55:44 -0500
Received: from dlep26.itg.ti.com (smtp-le.itg.ti.com [157.170.170.27])
	by dlep33.itg.ti.com (8.13.7/8.13.8) with ESMTP id p4R6tiR7003270
	for <linux-media@vger.kernel.org>; Fri, 27 May 2011 01:55:44 -0500 (CDT)
Received: from dlee74.ent.ti.com (localhost [127.0.0.1])
	by dlep26.itg.ti.com (8.13.8/8.13.8) with ESMTP id p4R6tiS1007385
	for <linux-media@vger.kernel.org>; Fri, 27 May 2011 01:55:44 -0500 (CDT)
From: Archit Taneja <archit@ti.com>
To: <linux-media@vger.kernel.org>
CC: hvaibhav@ti.com, Archit Taneja <archit@ti.com>
Subject: [PATCH 0/2] OMAP_VOUT: Allow omap_vout to build without VRFB
Date: Fri, 27 May 2011 12:31:15 +0530
Message-ID: <1306479677-23540-1-git-send-email-archit@ti.com>
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

Archit Taneja (2):
  OMAP_VOUT: CLEANUP: Move some functions and macros from omap_vout
  OMAP_VOUT: Create separate file for VRFB related API's

 drivers/media/video/omap/Kconfig          |    7 +-
 drivers/media/video/omap/Makefile         |    1 +
 drivers/media/video/omap/omap_vout.c      |  562 +++++------------------------
 drivers/media/video/omap/omap_vout_vrfb.c |  390 ++++++++++++++++++++
 drivers/media/video/omap/omap_vout_vrfb.h |   40 ++
 drivers/media/video/omap/omap_voutdef.h   |   78 ++++
 drivers/media/video/omap/omap_voutlib.c   |   44 +++
 drivers/media/video/omap/omap_voutlib.h   |    2 +
 8 files changed, 644 insertions(+), 480 deletions(-)
 create mode 100644 drivers/media/video/omap/omap_vout_vrfb.c
 create mode 100644 drivers/media/video/omap/omap_vout_vrfb.h

