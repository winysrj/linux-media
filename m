Return-path: <mchehab@pedra>
Received: from arroyo.ext.ti.com ([192.94.94.40]:50041 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755067Ab0I0HQm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Sep 2010 03:16:42 -0400
From: Archit Taneja <archit@ti.com>
To: hvaibhav@ti.com
Cc: linux-omap@vger.kernel.org, linux-media@vger.kernel.org,
	Archit Taneja <archit@ti.com>
Subject: [PATCH v2 0/2] V4L/DVB: OMAP_VOUT: Allow omap_vout to build without VRFB
Date: Mon, 27 Sep 2010 12:46:45 +0530
Message-Id: <1285571807-23210-1-git-send-email-archit@ti.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This lets omap_vout driver build and run without VRFB. It works along the
lines of the following patch series:

OMAP: DSS2: OMAPFB: Allow FB_OMAP2 to build without VRFB
https://patchwork.kernel.org/patch/105371/

Since VRFB is tightly coupled with the omap_vout driver, a handful of vrfb
specific functions have been defined and placed in omap_vout_vrfb.c

A variable rotation_type is introduced in omapvideo_info like the way in
omapfb_info, this allows to call vrfb specific functions only if the rotation
type is vrfb. When the rotation_type is set to SDMA, the S_CTRL ioctl prevents
the user setting a non zero rotation value.

Archit Taneja (2):
  V4L/DVB: OMAP_VOUT: Create a seperate vrfb functions library
  V4L/DVB: OMAP_VOUT: Use rotation_type to choose between vrfb and
    sdram buffers

 drivers/media/video/omap/Kconfig          |    1 -
 drivers/media/video/omap/Makefile         |    1 +
 drivers/media/video/omap/omap_vout.c      |  480 ++++++-----------------------
 drivers/media/video/omap/omap_vout_vrfb.c |  417 +++++++++++++++++++++++++
 drivers/media/video/omap/omap_vout_vrfb.h |   40 +++
 drivers/media/video/omap/omap_voutdef.h   |   26 ++
 6 files changed, 571 insertions(+), 394 deletions(-)
 create mode 100644 drivers/media/video/omap/omap_vout_vrfb.c
 create mode 100644 drivers/media/video/omap/omap_vout_vrfb.h
--
Version 2:
 - Don't try to enable SDRAM rotation , return an error if non zero rotation
   is attempted when rotation_type is set to SDMA rotation.
Version 1:
   http://www.mail-archive.com/linux-media@vger.kernel.org/msg21937.html
