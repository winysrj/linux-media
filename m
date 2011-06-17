Return-path: <mchehab@pedra>
Received: from comal.ext.ti.com ([198.47.26.152]:33724 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756141Ab1FQHBr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jun 2011 03:01:47 -0400
Received: from dbdp20.itg.ti.com ([172.24.170.38])
	by comal.ext.ti.com (8.13.7/8.13.7) with ESMTP id p5H71ivY018352
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Fri, 17 Jun 2011 02:01:46 -0500
From: Manjunath Hadli <manjunath.hadli@ti.com>
To: LMML <linux-media@vger.kernel.org>
CC: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>
Subject: [RESEND PATCH v19 0/6] davinci vpbe: dm6446 v4l2 driver
Date: Fri, 17 Jun 2011 12:31:30 +0530
Message-ID: <1308294096-25743-1-git-send-email-manjunath.hadli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

fixed a wrong file inclusion in one of the patches

Manjunath Hadli (6):
  davinci vpbe: V4L2 display driver for DM644X SoC
  davinci vpbe: VPBE display driver
  davinci vpbe: OSD(On Screen Display) block
  davinci vpbe: VENC( Video Encoder) implementation
  davinci vpbe: Build infrastructure for VPBE driver
  davinci vpbe: Readme text for Dm6446 vpbe

 Documentation/video4linux/README.davinci-vpbe |   93 ++
 drivers/media/video/davinci/Kconfig           |   23 +
 drivers/media/video/davinci/Makefile          |    2 +
 drivers/media/video/davinci/vpbe.c            |  864 ++++++++++++
 drivers/media/video/davinci/vpbe_display.c    | 1860 +++++++++++++++++++++++++
 drivers/media/video/davinci/vpbe_osd.c        | 1231 ++++++++++++++++
 drivers/media/video/davinci/vpbe_osd_regs.h   |  364 +++++
 drivers/media/video/davinci/vpbe_venc.c       |  566 ++++++++
 drivers/media/video/davinci/vpbe_venc_regs.h  |  177 +++
 include/media/davinci/vpbe.h                  |  184 +++
 include/media/davinci/vpbe_display.h          |  147 ++
 include/media/davinci/vpbe_osd.h              |  394 ++++++
 include/media/davinci/vpbe_types.h            |   91 ++
 include/media/davinci/vpbe_venc.h             |   45 +
 14 files changed, 6041 insertions(+), 0 deletions(-)
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

