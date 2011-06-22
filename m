Return-path: <mchehab@pedra>
Received: from bear.ext.ti.com ([192.94.94.41]:57228 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757971Ab1FVTc7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jun 2011 15:32:59 -0400
From: <hvaibhav@ti.com>
To: <linux-media@vger.kernel.org>
CC: mchehab@redhat.com
Subject: [GIT PULL for v3.0] OMAP_VOUT bug fixes and code cleanup
Date: Thu, 23 Jun 2011 01:02:49 +0530
Message-ID: <1308771169-10741-1-git-send-email-hvaibhav@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The following changes since commit af0d6a0a3a30946f7df69c764791f1b0643f7cd6:
  Linus Torvalds (1):
        Merge branch 'x86-urgent-for-linus' of git://git.kernel.org/.../tip/linux-2.6-tip

are available in the git repository at:

  git://arago-project.org/git/people/vaibhav/ti-psp-omap-video.git for-linux-media

Amber Jain (2):
      V4L2: omap_vout: Remove GFP_DMA allocation as ZONE_DMA is not configured on OMAP
      OMAP2: V4L2: Remove GFP_DMA allocation as ZONE_DMA is not configured on OMAP

Archit Taneja (3):
      OMAP_VOUT: CLEANUP: Move generic functions and macros to common files
      OMAP_VOUT: CLEANUP: Make rotation related helper functions more descriptive
      OMAP_VOUT: Create separate file for VRFB related API's

Vaibhav Hiremath (2):
      OMAP_VOUT: Change hardcoded device node number to -1
      omap_vout: Added check in reqbuf & mmap for buf_size allocation

Vladimir Pantelic (1):
      OMAP_VOUTLIB: Fix wrong resizer calculation

 drivers/media/video/omap/Kconfig          |    7 +-
 drivers/media/video/omap/Makefile         |    1 +
 drivers/media/video/omap/omap_vout.c      |  602 ++++++-----------------------
 drivers/media/video/omap/omap_vout_vrfb.c |  390 +++++++++++++++++++
 drivers/media/video/omap/omap_vout_vrfb.h |   40 ++
 drivers/media/video/omap/omap_voutdef.h   |   78 ++++
 drivers/media/video/omap/omap_voutlib.c   |   52 +++-
 drivers/media/video/omap/omap_voutlib.h   |   12 +-
 drivers/media/video/omap24xxcam.c         |    4 +-
 9 files changed, 684 insertions(+), 502 deletions(-)
 create mode 100644 drivers/media/video/omap/omap_vout_vrfb.c
 create mode 100644 drivers/imedia/video/omap/omap_vout_vrfb.h


 These patches include bug fixes and code cleanup.
