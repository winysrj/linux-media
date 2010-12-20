Return-path: <mchehab@gaivota>
Received: from devils.ext.ti.com ([198.47.26.153]:40119 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945Ab0LTNx6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Dec 2010 08:53:58 -0500
From: Manjunath Hadli <manjunath.hadli@ti.com>
To: LMML <linux-media@vger.kernel.org>
Cc: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Manjunath Hadli <manjunath.hadli@ti.com>
Subject: [PATCH v8 0/8] davinci vpbe: dm6446 v4l2 driver
Date: Mon, 20 Dec 2010 19:23:36 +0530
Message-Id: <1292853216-2216-1-git-send-email-manjunath.hadli@ti.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

version8 : addressed on Sergei's comments
on:
1.Interchanged platform and board specific patches due to dependencies.

Manjunath Hadli (8):
  davinci vpbe: V4L2 display driver for DM644X SoC
  davinci vpbe: VPBE display driver
  davinci vpbe: OSD(On Screen Display) block
  davinci vpbe: VENC( Video Encoder) implementation
  davinci vpbe: platform specific additions
  davinci vpbe: board specific additions
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

