Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:53146 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756516Ab1KQKos (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Nov 2011 05:44:48 -0500
Received: from dbdp20.itg.ti.com ([172.24.170.38])
	by comal.ext.ti.com (8.13.7/8.13.7) with ESMTP id pAHAijMv008784
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Thu, 17 Nov 2011 04:44:47 -0600
From: Manjunath Hadli <manjunath.hadli@ti.com>
To: LMML <linux-media@vger.kernel.org>
CC: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>
Subject: [RESEND RFC PATCH v4 00/15] RFC for Media Controller capture driver for DM365
Date: Thu, 17 Nov 2011 16:14:26 +0530
Message-ID: <1321526681-22574-1-git-send-email-manjunath.hadli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These are a updated subset of patches for Media Controller implementation on
DM365. A few more implementation patches which include Resizer, Previewer ,
AEW and AF  are added to provide a broader perspective for review.

Manjunath Hadli (15):
  davinci: vpfe: add dm3xx IPIPEIF hardware support module
  davinci: vpfe: add IPIPE hardware layer support
  davinci: vpfe: add IPIPE support for media controller driver
  davinci: vpfe: add support for CCDC hardware for dm365
  davinci: vpfe: add ccdc driver with media controller interface
  davinci: vpfe: add v4l2 video driver support
  davinci: vpfe: v4l2 capture driver with media interface
  davinci: vpfe: previewer driver based on v4l2 media controller
    framework
  davinci: vpfe: resizer driver based on media framework
  davinci: vpfe: add DM365 autofoucus(AF) hardware interface
  davinci: vpfe: add autofocus driver based on media framework
  davinci: vpfe: add hardware interface for dm365 aew
  davinci: vpfe: add aew driver based on v4l2 media framework
  davinci: vpfe: delete vpfe_types.h
  davinci: vpfe: build infrastructure for dm365

 drivers/media/video/davinci/Kconfig           |   46 +-
 drivers/media/video/davinci/Makefile          |   17 +-
 drivers/media/video/davinci/ccdc_hw_device.h  |   12 +-
 drivers/media/video/davinci/ccdc_types.h      |   43 +
 drivers/media/video/davinci/dm365_a3_hw.c     |  387 +++
 drivers/media/video/davinci/dm365_a3_hw.h     |  253 ++
 drivers/media/video/davinci/dm365_aew.c       |  544 ++++
 drivers/media/video/davinci/dm365_aew.h       |   55 +
 drivers/media/video/davinci/dm365_af.c        |  564 ++++
 drivers/media/video/davinci/dm365_af.h        |   59 +
 drivers/media/video/davinci/dm365_ccdc.c      | 1456 ++++++++++
 drivers/media/video/davinci/dm365_ccdc.h      |   91 +
 drivers/media/video/davinci/dm365_ccdc_regs.h |  309 ++
 drivers/media/video/davinci/dm365_def_para.c  |  310 ++
 drivers/media/video/davinci/dm365_def_para.h  |   39 +
 drivers/media/video/davinci/dm365_ipipe.c     | 3844 +++++++++++++++++++++++++
 drivers/media/video/davinci/dm365_ipipe.h     |  378 +++
 drivers/media/video/davinci/dm365_ipipe_hw.c  |  935 ++++++
 drivers/media/video/davinci/dm365_ipipe_hw.h  |  539 ++++
 drivers/media/video/davinci/dm3xx_ipipeif.c   |  312 ++
 drivers/media/video/davinci/dm3xx_ipipeif.h   |  255 ++
 drivers/media/video/davinci/imp_common.h      |   86 +
 drivers/media/video/davinci/imp_hw_if.h       |  171 ++
 drivers/media/video/davinci/vpfe_aew.c        |  238 ++
 drivers/media/video/davinci/vpfe_aew.h        |   51 +
 drivers/media/video/davinci/vpfe_af.c         |  240 ++
 drivers/media/video/davinci/vpfe_af.h         |   50 +
 drivers/media/video/davinci/vpfe_capture.c    |  796 +++++
 drivers/media/video/davinci/vpfe_capture.h    |   99 +
 drivers/media/video/davinci/vpfe_ccdc.c       |  817 ++++++
 drivers/media/video/davinci/vpfe_ccdc.h       |   86 +
 drivers/media/video/davinci/vpfe_previewer.c  | 1064 +++++++
 drivers/media/video/davinci/vpfe_previewer.h  |   65 +
 drivers/media/video/davinci/vpfe_resizer.c    | 1079 +++++++
 drivers/media/video/davinci/vpfe_resizer.h    |   63 +
 drivers/media/video/davinci/vpfe_video.c      | 1726 +++++++++++
 drivers/media/video/davinci/vpfe_video.h      |  146 +
 include/linux/dm365_aew.h                     |  153 +
 include/linux/dm365_af.h                      |  203 ++
 include/linux/dm365_ccdc.h                    |  611 ++++
 include/linux/dm365_ipipe.h                   | 1029 +++++++
 include/linux/dm3xx_ipipeif.h                 |   64 +
 include/linux/imp_common.h                    |  171 ++
 include/media/davinci/ccdc_types.h            |   43 -
 include/media/davinci/vpfe.h                  |   93 +
 include/media/davinci/vpfe_types.h            |   51 -
 46 files changed, 19536 insertions(+), 107 deletions(-)
 create mode 100644 drivers/media/video/davinci/ccdc_types.h
 create mode 100644 drivers/media/video/davinci/dm365_a3_hw.c
 create mode 100644 drivers/media/video/davinci/dm365_a3_hw.h
 create mode 100644 drivers/media/video/davinci/dm365_aew.c
 create mode 100644 drivers/media/video/davinci/dm365_aew.h
 create mode 100644 drivers/media/video/davinci/dm365_af.c
 create mode 100644 drivers/media/video/davinci/dm365_af.h
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
 create mode 100644 drivers/media/video/davinci/vpfe_aew.c
 create mode 100644 drivers/media/video/davinci/vpfe_aew.h
 create mode 100644 drivers/media/video/davinci/vpfe_af.c
 create mode 100644 drivers/media/video/davinci/vpfe_af.h
 create mode 100644 drivers/media/video/davinci/vpfe_capture.c
 create mode 100644 drivers/media/video/davinci/vpfe_capture.h
 create mode 100644 drivers/media/video/davinci/vpfe_ccdc.c
 create mode 100644 drivers/media/video/davinci/vpfe_ccdc.h
 create mode 100644 drivers/media/video/davinci/vpfe_previewer.c
 create mode 100644 drivers/media/video/davinci/vpfe_previewer.h
 create mode 100644 drivers/media/video/davinci/vpfe_resizer.c
 create mode 100644 drivers/media/video/davinci/vpfe_resizer.h
 create mode 100644 drivers/media/video/davinci/vpfe_video.c
 create mode 100644 drivers/media/video/davinci/vpfe_video.h
 create mode 100644 include/linux/dm365_aew.h
 create mode 100644 include/linux/dm365_af.h
 create mode 100644 include/linux/dm365_ccdc.h
 create mode 100644 include/linux/dm365_ipipe.h
 create mode 100644 include/linux/dm3xx_ipipeif.h
 create mode 100644 include/linux/imp_common.h
 delete mode 100644 include/media/davinci/ccdc_types.h
 create mode 100644 include/media/davinci/vpfe.h
 delete mode 100644 include/media/davinci/vpfe_types.h

