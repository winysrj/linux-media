Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:60394 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932744Ab1J2Ovm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Oct 2011 10:51:42 -0400
Received: from dbdp20.itg.ti.com ([172.24.170.38])
	by comal.ext.ti.com (8.13.7/8.13.7) with ESMTP id p9TEpdL6031768
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sat, 29 Oct 2011 09:51:41 -0500
From: Manjunath Hadli <manjunath.hadli@ti.com>
To: LMML <linux-media@vger.kernel.org>
CC: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>
Subject: [RFC PATCH v3 0/8] RFC for Media Controller capture driver for DM365
Date: Sat, 29 Oct 2011 20:21:24 +0530
Message-ID: <1319899892-19658-1-git-send-email-manjunath.hadli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Changes from last version:
Addressed Sakari's comments. mainly -
 1. Used lower case hexadecimals.
 2. Removed ISNULL and replaced it appropriately.
 3. Alligned the code wherever necessary.
 4. Used v4l2_mbus_pixelcode.
 5. Removed #ifdef CONFIG_IPIPE_PARAM_VALIDATION
 6. Removed #ifdef __KERNEL__ from kerenel header files.
 7. Created the pipe state datastructure as part of the
    device structure rather than a static. Appropriately changed
    signatures.
 8. Removed zero initialisation.

Manjunath Hadli (8):
  davinci: vpfe: add dm3xx IPIPEIF hardware support module
  davinci: vpfe: add IPIPE hardware layer support
  davinci: vpfe: add IPIPE support for media controller driver
  davinci: vpfe: add support for CCDC hardware for dm365
  davinci: vpfe: add ccdc driver with media controller interface
  davinci: vpfe: add v4l2 video driver support
  davinci: vpfe: v4l2 capture driver with media interface
  davinci: vpfe: build infrastructure for dm365

 drivers/media/video/davinci/Kconfig           |   46 +-
 drivers/media/video/davinci/Makefile          |   17 +-
 drivers/media/video/davinci/ccdc_hw_device.h  |   12 +-
 drivers/media/video/davinci/ccdc_types.h      |   43 +
 drivers/media/video/davinci/dm365_ccdc.c      | 1505 +++++++++
 drivers/media/video/davinci/dm365_ccdc.h      |   86 +
 drivers/media/video/davinci/dm365_ccdc_regs.h |  309 ++
 drivers/media/video/davinci/dm365_def_para.c  |  334 ++
 drivers/media/video/davinci/dm365_def_para.h  |   39 +
 drivers/media/video/davinci/dm365_ipipe.c     | 4034 +++++++++++++++++++++++++
 drivers/media/video/davinci/dm365_ipipe.h     |  395 +++
 drivers/media/video/davinci/dm365_ipipe_hw.c  |  948 ++++++
 drivers/media/video/davinci/dm365_ipipe_hw.h  |  539 ++++
 drivers/media/video/davinci/dm3xx_ipipeif.c   |  314 ++
 drivers/media/video/davinci/dm3xx_ipipeif.h   |  255 ++
 drivers/media/video/davinci/imp_common.h      |   81 +
 drivers/media/video/davinci/imp_hw_if.h       |  184 ++
 drivers/media/video/davinci/vpfe_capture.c    |  795 +++++
 drivers/media/video/davinci/vpfe_capture.h    |  102 +
 drivers/media/video/davinci/vpfe_ccdc.c       |  813 +++++
 drivers/media/video/davinci/vpfe_ccdc.h       |   82 +
 drivers/media/video/davinci/vpfe_video.c      | 1713 +++++++++++
 drivers/media/video/davinci/vpfe_video.h      |  142 +
 include/linux/davinci_vpfe.h                  | 1194 ++++++++
 include/linux/dm365_ccdc.h                    |  621 ++++
 include/linux/dm3xx_ipipeif.h                 |   64 +
 include/media/davinci/vpfe.h                  |   91 +
 27 files changed, 14745 insertions(+), 13 deletions(-)
 create mode 100644 drivers/media/video/davinci/ccdc_types.h
 create mode 100644 drivers/media/video/davinci/dm365_ccdc.c
 create mode 100644 drivers/media/video/davinci/dm365_ccdc.h
 create mode 100644 drivers/media/video/davinci/dm365_ccdc_regs.h
 create mode 100644 drivers/media/video/davinci/dm365_def_para.c
 create mode 100644 drivers/media/video/davinci/dm365_def_para.h
 create mode 100644 drivers/media/video/davinci/dm365_ipipe.c
 create mode 100644 drivers/media/video/davinci/dm365_ipipe.h
 create mode 100644 drivers/media/video/davinci/dm365_ipipe_hw.c
 create mode 100644 drivers/media/video/davinci/dm365_ipipe_hw.h
 create mode 100644 drivers/media/video/davinci/dm3xx_ipipeif.c
 create mode 100644 drivers/media/video/davinci/dm3xx_ipipeif.h
 create mode 100644 drivers/media/video/davinci/imp_common.h
 create mode 100644 drivers/media/video/davinci/imp_hw_if.h
 create mode 100644 drivers/media/video/davinci/vpfe_capture.c
 create mode 100644 drivers/media/video/davinci/vpfe_capture.h
 create mode 100644 drivers/media/video/davinci/vpfe_ccdc.c
 create mode 100644 drivers/media/video/davinci/vpfe_ccdc.h
 create mode 100644 drivers/media/video/davinci/vpfe_video.c
 create mode 100644 drivers/media/video/davinci/vpfe_video.h
 create mode 100644 include/linux/davinci_vpfe.h
 create mode 100644 include/linux/dm365_ccdc.h
 create mode 100644 include/linux/dm3xx_ipipeif.h
 create mode 100644 include/media/davinci/vpfe.h

