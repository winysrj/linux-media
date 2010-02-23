Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:49922 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953Ab0BWIei (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Feb 2010 03:34:38 -0500
From: hvaibhav@ti.com
To: linux-media@vger.kernel.org
Cc: linux-omap@vger.kernel.org, hverkuil@xs4all.nl,
	Vaibhav Hiremath <hvaibhav@ti.com>
Subject: [PATCH-V1 00/10] VPFE Capture Bug Fixes and feature enhancement
Date: Tue, 23 Feb 2010 14:04:23 +0530
Message-Id: <1266914073-30135-1-git-send-email-hvaibhav@ti.com>
In-Reply-To: <hvaibhav@ti.com>
References: <hvaibhav@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Vaibhav Hiremath <hvaibhav@ti.com>

This is second version of patch series fixing few bugs and adds
some feature enhancements - 

Changes:
	- Introduce t-media directory
	- Add YUYV support to tvp514x.c
	- Add UserPtr support to vpfe_capture
	- Call-back function for interrupt clear (required for AM3517)
	- VPFE Capture support for AM3517
	- Suspend Resume support

Changes from last version - 
	- Merge board specific changes to patch "introduce ti-media directory"
	(comment from Hans)

Vaibhav Hiremath (10):
  Makfile:Removed duplicate entry of davinci
  tvp514x: add YUYV format support
  Introducing ti-media directory
  AM3517 CCDC: Debug register read prints removed
  VPFE Capture: Add call back function for interrupt clear to vpfe_cfg
  DM644x CCDC: Add 10bit BT support
  Davinci VPFE Capture:Return 0 from suspend/resume
  DM644x CCDC : Add Suspend/Resume Support
  VPFE Capture: Add support for USERPTR mode of operation
  AM3517: Add VPFE Capture driver support

 arch/arm/mach-davinci/include/mach/dm355.h      |    2 +-
 arch/arm/mach-davinci/include/mach/dm644x.h     |    2 +-
 arch/arm/mach-omap2/board-am3517evm.c           |  160 ++
 drivers/media/video/Kconfig                     |   84 +-
 drivers/media/video/Makefile                    |    4 +-
 drivers/media/video/davinci/Makefile            |   17 -
 drivers/media/video/davinci/ccdc_hw_device.h    |  110 --
 drivers/media/video/davinci/dm355_ccdc.c        | 1082 -----------
 drivers/media/video/davinci/dm355_ccdc_regs.h   |  310 ----
 drivers/media/video/davinci/dm644x_ccdc.c       |  967 ----------
 drivers/media/video/davinci/dm644x_ccdc_regs.h  |  145 --
 drivers/media/video/davinci/vpfe_capture.c      | 2054 ---------------------
 drivers/media/video/davinci/vpif.c              |  296 ---
 drivers/media/video/davinci/vpif.h              |  642 -------
 drivers/media/video/davinci/vpif_capture.c      | 2168 -----------------------
 drivers/media/video/davinci/vpif_capture.h      |  165 --
 drivers/media/video/davinci/vpif_display.c      | 1654 -----------------
 drivers/media/video/davinci/vpif_display.h      |  175 --
 drivers/media/video/davinci/vpss.c              |  301 ----
 drivers/media/video/ti-media/Kconfig            |   88 +
 drivers/media/video/ti-media/Makefile           |   17 +
 drivers/media/video/ti-media/ccdc_hw_device.h   |  110 ++
 drivers/media/video/ti-media/dm355_ccdc.c       | 1082 +++++++++++
 drivers/media/video/ti-media/dm355_ccdc_regs.h  |  310 ++++
 drivers/media/video/ti-media/dm644x_ccdc.c      | 1090 ++++++++++++
 drivers/media/video/ti-media/dm644x_ccdc_regs.h |  153 ++
 drivers/media/video/ti-media/vpfe_capture.c     | 2130 ++++++++++++++++++++++
 drivers/media/video/ti-media/vpif.c             |  296 +++
 drivers/media/video/ti-media/vpif.h             |  642 +++++++
 drivers/media/video/ti-media/vpif_capture.c     | 2168 +++++++++++++++++++++++
 drivers/media/video/ti-media/vpif_capture.h     |  165 ++
 drivers/media/video/ti-media/vpif_display.c     | 1654 +++++++++++++++++
 drivers/media/video/ti-media/vpif_display.h     |  175 ++
 drivers/media/video/ti-media/vpss.c             |  301 ++++
 drivers/media/video/tvp514x.c                   |    7 +
 include/media/davinci/ccdc_types.h              |   43 -
 include/media/davinci/dm355_ccdc.h              |  321 ----
 include/media/davinci/dm644x_ccdc.h             |  184 --
 include/media/davinci/vpfe_capture.h            |  200 ---
 include/media/davinci/vpfe_types.h              |   51 -
 include/media/davinci/vpss.h                    |   69 -
 include/media/ti-media/ccdc_types.h             |   43 +
 include/media/ti-media/dm355_ccdc.h             |  321 ++++
 include/media/ti-media/dm644x_ccdc.h            |  184 ++
 include/media/ti-media/vpfe_capture.h           |  202 +++
 include/media/ti-media/vpfe_types.h             |   51 +
 include/media/ti-media/vpss.h                   |   69 +
 47 files changed, 11423 insertions(+), 11041 deletions(-)
 delete mode 100644 drivers/media/video/davinci/Makefile
 delete mode 100644 drivers/media/video/davinci/ccdc_hw_device.h
 delete mode 100644 drivers/media/video/davinci/dm355_ccdc.c
 delete mode 100644 drivers/media/video/davinci/dm355_ccdc_regs.h
 delete mode 100644 drivers/media/video/davinci/dm644x_ccdc.c
 delete mode 100644 drivers/media/video/davinci/dm644x_ccdc_regs.h
 delete mode 100644 drivers/media/video/davinci/vpfe_capture.c
 delete mode 100644 drivers/media/video/davinci/vpif.c
 delete mode 100644 drivers/media/video/davinci/vpif.h
 delete mode 100644 drivers/media/video/davinci/vpif_capture.c
 delete mode 100644 drivers/media/video/davinci/vpif_capture.h
 delete mode 100644 drivers/media/video/davinci/vpif_display.c
 delete mode 100644 drivers/media/video/davinci/vpif_display.h
 delete mode 100644 drivers/media/video/davinci/vpss.c
 create mode 100644 drivers/media/video/ti-media/Kconfig
 create mode 100644 drivers/media/video/ti-media/Makefile
 create mode 100644 drivers/media/video/ti-media/ccdc_hw_device.h
 create mode 100644 drivers/media/video/ti-media/dm355_ccdc.c
 create mode 100644 drivers/media/video/ti-media/dm355_ccdc_regs.h
 create mode 100644 drivers/media/video/ti-media/dm644x_ccdc.c
 create mode 100644 drivers/media/video/ti-media/dm644x_ccdc_regs.h
 create mode 100644 drivers/media/video/ti-media/vpfe_capture.c
 create mode 100644 drivers/media/video/ti-media/vpif.c
 create mode 100644 drivers/media/video/ti-media/vpif.h
 create mode 100644 drivers/media/video/ti-media/vpif_capture.c
 create mode 100644 drivers/media/video/ti-media/vpif_capture.h
 create mode 100644 drivers/media/video/ti-media/vpif_display.c
 create mode 100644 drivers/media/video/ti-media/vpif_display.h
 create mode 100644 drivers/media/video/ti-media/vpss.c
 delete mode 100644 include/media/davinci/ccdc_types.h
 delete mode 100644 include/media/davinci/dm355_ccdc.h
 delete mode 100644 include/media/davinci/dm644x_ccdc.h
 delete mode 100644 include/media/davinci/vpfe_capture.h
 delete mode 100644 include/media/davinci/vpfe_types.h
 delete mode 100644 include/media/davinci/vpss.h
 create mode 100644 include/media/ti-media/ccdc_types.h
 create mode 100644 include/media/ti-media/dm355_ccdc.h
 create mode 100644 include/media/ti-media/dm644x_ccdc.h
 create mode 100644 include/media/ti-media/vpfe_capture.h
 create mode 100644 include/media/ti-media/vpfe_types.h
 create mode 100644 include/media/ti-media/vpss.h

