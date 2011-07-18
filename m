Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:54791 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751263Ab1GRStr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jul 2011 14:49:47 -0400
From: <hvaibhav@ti.com>
To: <linux-media@vger.kernel.org>
CC: mchehab@redhat.com
Subject: [GIT PULL for v3.1] OMAP_VOUT code cleanup
Date: Tue, 19 Jul 2011 00:19:30 +0530
Message-ID: <1311014970-29235-1-git-send-email-hvaibhav@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 5dcd07b9f39ca3e9be5bcc387d193fc0674e1c81:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../steve/gfs2-2.6-fixes

are available in the git repository at:

  git://arago-project.org/git/people/vaibhav/ti-psp-omap-video.git for-linux-media

Amber Jain (5):
      V4L2: omap_vout: Remove GFP_DMA allocation as ZONE_DMA is not configured on OMAP
      OMAP2: V4L2: Remove GFP_DMA allocation as ZONE_DMA is not configured on OMAP
      V4L2: OMAP: VOUT: isr handling extended for DPI and HDMI interface
      V4L2: OMAP: VOUT: dma map and unmap v4l2 buffers in qbuf and dqbuf
      V4l2: OMAP: VOUT: Minor Cleanup, removing the unnecessary code.

Archit Taneja (3):
      OMAP_VOUT: CLEANUP: Move generic functions and macros to common files
      OMAP_VOUT: CLEANUP: Make rotation related helper functions more descriptive
      OMAP_VOUT: Create separate file for VRFB related API's

 drivers/media/video/omap/Kconfig          |    7 +-
 drivers/media/video/omap/Makefile         |    1 +
 drivers/media/video/omap/omap_vout.c      |  645 +++++++----------------------
 drivers/media/video/omap/omap_vout_vrfb.c |  390 +++++++++++++++++
 drivers/media/video/omap/omap_vout_vrfb.h |   40 ++
 drivers/media/video/omap/omap_voutdef.h   |   78 ++++
 drivers/media/video/omap/omap_voutlib.c   |   46 ++
 drivers/media/video/omap/omap_voutlib.h   |   12 +-
 drivers/media/video/omap24xxcam.c         |    4 +-
 9 files changed, 710 insertions(+), 513 deletions(-)
 create mode 100644 drivers/media/video/omap/omap_vout_vrfb.c
 create mode 100644 drivers/media/video/omap/omap_vout_vrfb.h
