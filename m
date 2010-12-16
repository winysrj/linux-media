Return-path: <mchehab@gaivota>
Received: from bear.ext.ti.com ([192.94.94.41]:55646 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753606Ab0LPNy3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Dec 2010 08:54:29 -0500
From: Manjunath Hadli <manjunath.hadli@ti.com>
To: LMML <linux-media@vger.kernel.org>
Cc: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Manjunath Hadli <manjunath.hadli@ti.com>
Subject: [PATCH v7 0/8] davinci vpbe: dm6446 v4l2 driver
Date: Thu, 16 Dec 2010 19:24:16 +0530
Message-Id: <1292507656-30143-1-git-send-email-manjunath.hadli@ti.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

version7 : addressed Murali's and Sergei's comments 
on:
1. Readme cleanup.
2. Seperate patch for platform dependent and board specific files.

Manjunath Hadli (8):
  davinci vpbe: V4L2 display driver for DM644X SoC
  davinci vpbe: VPBE display driver
  davinci vpbe: OSD(On Screen Display) block
  davinci vpbe: VENC( Video Encoder) implementation
  davinci vpbe: board specific additions
  davinci vpbe: platform specific additions
  davinci vpbe: Build infrastructure for VPBE driver
  davinci vpbe: Readme text for Dm6446 vpbe

 Documentation/video4linux/README.davinci-vpbe |   93 ++
 arch/arm/mach-davinci/board-dm644x-evm.c      |   79 +-
 arch/arm/mach-davinci/dm644x.c                |  164 ++-
 arch/arm/mach-davinci/include/mach/dm644x.h   |    4 +
 drivers/media/video/davinci/Kconfig           |   22 +
 drivers/media/video/davinci/Makefile          |    2 +
 drivers/media/video/davinci/vpbe.c            |  837 ++++++++++
 drivers/media/video/davinci/vpbe_display.c    | 2099 +++++++++++++++++++++++++
 drivers/media/video/davinci/vpbe_osd.c        | 1211 ++++++++++++++
 drivers/media/video/davinci/vpbe_osd_regs.h   |  389 +++++
 drivers/media/video/davinci/vpbe_venc.c       |  574 +++++++
 drivers/media/video/davinci/vpbe_venc_regs.h  |  189 +++
 include/media/davinci/vpbe.h                  |  186 +++
 include/media/davinci/vpbe_display.h          |  146 ++
 include/media/davinci/vpbe_osd.h              |  397 +++++
 include/media/davinci/vpbe_types.h            |   93 ++
 include/media/davinci/vpbe_venc.h             |   38 +
 17 files changed, 6504 insertions(+), 19 deletions(-)
 create mode 100644 Documentation/video4linux/README.davinci-vpbe
 create mode 100644 drivers/media/video/davinci/vpbe.c
 create mode 100644 drivers/media/video/davinci/vpbe_display.c
 create mode 100644 drivers/media/video/davinci/vpbe_osd.c
 create mode 100644 drivers/media/video/davinci/vpbe_osd_regs.h
 create mode 100644 drivers/media/video/davinci/vpbe_venc.c
 create mode 100644 drivers/media/video/davinci/vpbe_venc_regs.h
 create mode 100644 include/media/davinci/vpbe.h
 create mode 100644 include/media/davinci/vpbe_display.h
 create mode 100644 include/media/davinci/vpbe_osd.h
 create mode 100644 include/media/davinci/vpbe_types.h
 create mode 100644 include/media/davinci/vpbe_venc.h

