Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:46166 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756506Ab1KQKTJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Nov 2011 05:19:09 -0500
From: Manjunath Hadli <manjunath.hadli@ti.com>
To: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	LAK <linux-arm-kernel@lists.infradead.org>
CC: Manjunath Hadli <manjunath.hadli@ti.com>
Subject: [PATCH v3 0/5] ARM: davinci: re-arrange definitions to have a common davinci header
Date: Thu, 17 Nov 2011 15:48:53 +0530
Message-ID: <1321525138-3928-1-git-send-email-manjunath.hadli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Re-arrange definitions and remove unnecessary code so that we can
have a common header for all davinci platforms. This will enable
us to share defines and enable common routines to be used without
polluting hardware.h.
 This patch set forms the base for a later set of patches for having
a common system module base address (DAVINCI_SYSTEM_MODULE_BASE).

Changes from previous version(As per Sergei's comments):
1. Renamed davinci_common.h to davinci.h.
2. Added extra line whereever appropriate.
3. removed unnecessary header inclusion.

Manjunath Hadli (5):
  ARM: davinci: dm644x: remove the macros from the header to move to c
    file
  ARM: davinci: dm365: remove the macros from the header to move to c
    file
  ARM: davinci: dm646x: remove the macros from the header to move to c
    file
  ARM: davinci: create new common platform header for davinci
  ARM: davinci: delete individual platform header files and use a
    common header

 arch/arm/mach-davinci/board-dm355-evm.c      |    2 +-
 arch/arm/mach-davinci/board-dm355-leopard.c  |    2 +-
 arch/arm/mach-davinci/board-dm365-evm.c      |    2 +-
 arch/arm/mach-davinci/board-dm644x-evm.c     |    2 +-
 arch/arm/mach-davinci/board-dm646x-evm.c     |    2 +-
 arch/arm/mach-davinci/board-neuros-osd2.c    |    2 +-
 arch/arm/mach-davinci/board-sffsdr.c         |    2 +-
 arch/arm/mach-davinci/dm355.c                |    2 +-
 arch/arm/mach-davinci/dm365.c                |   18 +++++-
 arch/arm/mach-davinci/dm644x.c               |    9 +++-
 arch/arm/mach-davinci/dm646x.c               |    9 +++-
 arch/arm/mach-davinci/include/mach/davinci.h |   88 ++++++++++++++++++++++++++
 arch/arm/mach-davinci/include/mach/dm355.h   |   32 ---------
 arch/arm/mach-davinci/include/mach/dm365.h   |   52 ---------------
 arch/arm/mach-davinci/include/mach/dm644x.h  |   47 --------------
 arch/arm/mach-davinci/include/mach/dm646x.h  |   41 ------------
 drivers/media/video/davinci/vpif.h           |    3 +-
 drivers/media/video/davinci/vpif_display.c   |    2 +-
 18 files changed, 131 insertions(+), 186 deletions(-)
 create mode 100644 arch/arm/mach-davinci/include/mach/davinci.h
 delete mode 100644 arch/arm/mach-davinci/include/mach/dm355.h
 delete mode 100644 arch/arm/mach-davinci/include/mach/dm365.h
 delete mode 100644 arch/arm/mach-davinci/include/mach/dm644x.h
 delete mode 100644 arch/arm/mach-davinci/include/mach/dm646x.h

