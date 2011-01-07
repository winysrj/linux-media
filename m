Return-path: <mchehab@pedra>
Received: from comal.ext.ti.com ([198.47.26.152]:60289 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753304Ab1AGNiw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 7 Jan 2011 08:38:52 -0500
From: Manjunath Hadli <manjunath.hadli@ti.com>
To: LMML <linux-media@vger.kernel.org>,
	Kevin Hilman <khilman@deeprootsystems.com>
Cc: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	linux-arm-kernel@listinfradead.com,
	Manjunath Hadli <manjunath.hadli@ti.com>
Subject: [PATCH v12 0/8] davinci vpbe: dm6446 v4l2 driver
Date: Fri,  7 Jan 2011 19:08:29 +0530
Message-Id: <1294407509-23180-1-git-send-email-manjunath.hadli@ti.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

version12 : addressed Kaspter Ju's, Sylwester Nawrocki's,Sergei's,Shekhar's comments
on:
1. Removal of code duplication
2. Replacing _raw_readl() with readl()
3. Removal of blank lines
4. Removal of extra comments
5. Removal of platform resource overlap
6. Changing the Field inversion #ifdef to platform 
   based implementation

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
Acked-by: Muralidharan Karicheri <m-karicheri2@ti.com>
Acked-by: Hans Verkuil <hverkuil@xs4all.nl>

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
 arch/arm/mach-davinci/board-dm644x-evm.c      |   86 +-
 arch/arm/mach-davinci/dm644x.c                |  168 ++-
 arch/arm/mach-davinci/include/mach/dm644x.h   |   20 +-
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
 17 files changed, 6447 insertions(+), 27 deletions(-)
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

