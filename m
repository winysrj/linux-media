Return-path: <mchehab@pedra>
Received: from devils.ext.ti.com ([198.47.26.153]:51544 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068Ab1CON47 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Mar 2011 09:56:59 -0400
From: Manjunath Hadli <manjunath.hadli@ti.com>
To: LMML <linux-media@vger.kernel.org>,
	Kevin Hilman <khilman@deeprootsystems.com>,
	LAK <linux-arm-kernel@lists.infradead.org>,
	Sekhar Nori <nsekhar@ti.com>
Cc: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Manjunath Hadli <manjunath.hadli@ti.com>
Subject: [PATCH v17 00/13] davinci vpbe: dm6446 v4l2 driver
Date: Tue, 15 Mar 2011 19:26:28 +0530
Message-Id: <1300197388-3704-1-git-send-email-manjunath.hadli@ti.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

version17:
The more important among the patch history from previous comments 
1. Replacing _raw_readl() with readl().
2. Removal of platform resource overlap.
3. Removal of unused macros.
4. Fixing the module params typo.
5. Minor changes in the GPL licensing header.
6. Removed the initializer for field inversion parameter.
7. Changing the Field inversion #ifdef to platform 
   based implementation.
8. Interchanged platform and board specific patches due to dependencies.

Manjunath Hadli (13):
  davinci vpbe: V4L2 display driver for DM644X SoC
  davinci vpbe: VPBE display driver
  davinci vpbe: OSD(On Screen Display) block
  davinci vpbe: VENC( Video Encoder) implementation
  davinci vpbe: Build infrastructure for VPBE driver
  davinci vpbe: Readme text for Dm6446 vpbe
  davinci: move DM64XX_VDD3P3V_PWDN to devices.c
  davinci: eliminate use of IO_ADDRESS() on sysmod
  davinci: dm644x: Replace register base value with a defined macro
  davinci: dm644x: change vpfe capture structure variables for
    consistency
  davinci: dm644x: move vpfe init from soc to board specific files
  davinci: dm644x: add support for v4l2 video display
  davinci: dm644x EVM: add support for VPBE display

 Documentation/video4linux/README.davinci-vpbe |   93 ++
 arch/arm/mach-davinci/board-dm644x-evm.c      |  131 ++-
 arch/arm/mach-davinci/devices.c               |   24 +-
 arch/arm/mach-davinci/dm355.c                 |    1 +
 arch/arm/mach-davinci/dm365.c                 |    1 +
 arch/arm/mach-davinci/dm644x.c                |  172 ++-
 arch/arm/mach-davinci/dm646x.c                |    1 +
 arch/arm/mach-davinci/include/mach/dm644x.h   |    7 +-
 arch/arm/mach-davinci/include/mach/hardware.h |    7 +-
 drivers/media/video/davinci/Kconfig           |   22 +
 drivers/media/video/davinci/Makefile          |    2 +
 drivers/media/video/davinci/vpbe.c            |  826 ++++++++++
 drivers/media/video/davinci/vpbe_display.c    | 2084 +++++++++++++++++++++++++
 drivers/media/video/davinci/vpbe_osd.c        | 1216 ++++++++++++++
 drivers/media/video/davinci/vpbe_osd_regs.h   |  364 +++++
 drivers/media/video/davinci/vpbe_venc.c       |  556 +++++++
 drivers/media/video/davinci/vpbe_venc_regs.h  |  177 +++
 include/media/davinci/vpbe.h                  |  185 +++
 include/media/davinci/vpbe_display.h          |  146 ++
 include/media/davinci/vpbe_osd.h              |  397 +++++
 include/media/davinci/vpbe_types.h            |   91 ++
 include/media/davinci/vpbe_venc.h             |   41 +
 22 files changed, 6500 insertions(+), 44 deletions(-)
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

