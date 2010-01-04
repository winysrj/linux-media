Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:45601 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751860Ab0ADODM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jan 2010 09:03:12 -0500
From: hvaibhav@ti.com
To: linux-media@vger.kernel.org
Cc: linux-omap@vger.kernel.org, hverkuil@xs4all.nl,
	davinci-linux-open-source@linux.davincidsp.com,
	m-karicheri2@ti.com, Vaibhav Hiremath <hvaibhav@ti.com>
Subject: [PATCH 0/9] Feature enhancement of VPFE/CCDC Capture driver
Date: Mon,  4 Jan 2010 19:32:53 +0530
Message-Id: <1262613782-20463-1-git-send-email-hvaibhav@ti.com>
In-Reply-To: <hvaibhav@ti.com>
References: <hvaibhav@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Vaibhav Hiremath <hvaibhav@ti.com>

While adding support for AM3517/05 devices I have implemented/came-across
these features/enhancement/bug-fixes for VPFE-Capture driver.

Also the important change added is, to introduced "ti-media"
directory for all TI devices.

Vaibhav Hiremath (9):
  Makfile:Removed duplicate entry of davinci
  TVP514x:Switch to automode for querystd
  tvp514x: add YUYV format support
  Introducing ti-media directory
  DMx:Update board files for ti-media directory change
  Davinci VPFE Capture:Return 0 from suspend/resume
  DM644x CCDC : Add Suspend/Resume Support
  VPFE Capture: Add call back function for interrupt clear to vpfe_cfg
  DM644x CCDC: Add 10bit BT support

 arch/arm/mach-davinci/include/mach/dm355.h      |    2 +-
 arch/arm/mach-davinci/include/mach/dm644x.h     |    2 +-
 drivers/media/video/Kconfig                     |   84 +-
 drivers/media/video/Makefile                    |    4 +-
 drivers/media/video/davinci/Makefile            |   17 -
 drivers/media/video/davinci/ccdc_hw_device.h    |  110 --
 drivers/media/video/davinci/dm355_ccdc.c        | 1081 -----------
 drivers/media/video/davinci/dm355_ccdc_regs.h   |  310 ----
 drivers/media/video/davinci/dm644x_ccdc.c       |  966 ----------
 drivers/media/video/davinci/dm644x_ccdc_regs.h  |  145 --
 drivers/media/video/davinci/vpfe_capture.c      | 2055 ---------------------
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
 drivers/media/video/ti-media/dm355_ccdc.c       | 1081 +++++++++++
 drivers/media/video/ti-media/dm355_ccdc_regs.h  |  310 ++++
 drivers/media/video/ti-media/dm644x_ccdc.c      | 1090 ++++++++++++
 drivers/media/video/ti-media/dm644x_ccdc_regs.h |  153 ++
 drivers/media/video/ti-media/vpfe_capture.c     | 2067 +++++++++++++++++++++
 drivers/media/video/ti-media/vpif.c             |  296 +++
 drivers/media/video/ti-media/vpif.h             |  642 +++++++
 drivers/media/video/ti-media/vpif_capture.c     | 2168 +++++++++++++++++++++++
 drivers/media/video/ti-media/vpif_capture.h     |  165 ++
 drivers/media/video/ti-media/vpif_display.c     | 1654 +++++++++++++++++
 drivers/media/video/ti-media/vpif_display.h     |  175 ++
 drivers/media/video/ti-media/vpss.c             |  301 ++++
 drivers/media/video/tvp514x.c                   |   15 +
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
 46 files changed, 11207 insertions(+), 11040 deletions(-)
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

