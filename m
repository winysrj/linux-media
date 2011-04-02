Return-path: <mchehab@pedra>
Received: from arroyo.ext.ti.com ([192.94.94.40]:41461 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753392Ab1DBJkx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 2 Apr 2011 05:40:53 -0400
From: Manjunath Hadli <manjunath.hadli@ti.com>
To: LMML <linux-media@vger.kernel.org>,
	Kevin Hilman <khilman@deeprootsystems.com>,
	LAK <linux-arm-kernel@lists.infradead.org>,
	Sekhar Nori <nsekhar@ti.com>
Cc: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>
Subject: [PATCH v16 00/13] davinci vpbe: dm6446 v4l2 driver
Date: Sat,  2 Apr 2011 15:10:38 +0530
Message-Id: <1301737238-3961-1-git-send-email-manjunath.hadli@ti.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The more important among the patch history from previous comments
1. Removal of platform resource overlap.
2. Removal of unused macros.
3. Fixing the module params typo.
4. Minor changes in the GPL licensing header.
5. Removed the initializer for field inversion parameter.
6. Changing the Field inversion #ifdef to platform 
   based implementation.
7. Interchanged platform and board specific patches due to dependencies.
8. Fixed sparse warnings.

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
 arch/arm/mach-davinci/devices.c               |   25 +-
 arch/arm/mach-davinci/dm355.c                 |    1 +
 arch/arm/mach-davinci/dm365.c                 |    1 +
 arch/arm/mach-davinci/dm644x.c                |  177 ++-
 arch/arm/mach-davinci/dm646x.c                |    1 +
 arch/arm/mach-davinci/include/mach/dm644x.h   |    6 +-
 arch/arm/mach-davinci/include/mach/hardware.h |    7 +-
 drivers/media/video/davinci/Kconfig           |   22 +
 drivers/media/video/davinci/Makefile          |    2 +
 drivers/media/video/davinci/vpbe.c            |  827 ++++++++++
 drivers/media/video/davinci/vpbe_display.c    | 2085 +++++++++++++++++++++++++
 drivers/media/video/davinci/vpbe_osd.c        | 1216 ++++++++++++++
 drivers/media/video/davinci/vpbe_osd_regs.h   |  364 +++++
 drivers/media/video/davinci/vpbe_venc.c       |  556 +++++++
 drivers/media/video/davinci/vpbe_venc_regs.h  |  177 +++
 include/media/davinci/vpbe.h                  |  182 +++
 include/media/davinci/vpbe_display.h          |  146 ++
 include/media/davinci/vpbe_osd.h              |  397 +++++
 include/media/davinci/vpbe_types.h            |   91 ++
 include/media/davinci/vpbe_venc.h             |   44 +
 22 files changed, 6507 insertions(+), 44 deletions(-)
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

