Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:36378 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308Ab1KLNTL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Nov 2011 08:19:11 -0500
Received: from dbdp20.itg.ti.com ([172.24.170.38])
	by devils.ext.ti.com (8.13.7/8.13.7) with ESMTP id pACDJ8db023252
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sat, 12 Nov 2011 07:19:10 -0600
From: Manjunath Hadli <manjunath.hadli@ti.com>
To: LMML <linux-media@vger.kernel.org>
CC: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>
Subject: [RFC PATCH v4 0/8] RFC for Media Controller capture driver for DM365
Date: Sat, 12 Nov 2011 18:48:54 +0530
Message-ID: <1321103942-2778-1-git-send-email-manjunath.hadli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These are a updated subset of patches for Media Controller implementation on
DM365.

Updates from last patch set:
1. Some header reorg.
2. Support for some extra formats - NV12 and other semiplanar.
3. ResizerB support

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
 drivers/media/video/davinci/vpfe_capture.c    |  796 +++++
 drivers/media/video/davinci/vpfe_capture.h    |   99 +
 drivers/media/video/davinci/vpfe_ccdc.c       |  817 ++++++
 drivers/media/video/davinci/vpfe_ccdc.h       |   86 +
 drivers/media/video/davinci/vpfe_video.c      | 1744 +++++++++++
 drivers/media/video/davinci/vpfe_video.h      |  146 +
 include/linux/dm365_ccdc.h                    |  611 ++++
 include/linux/dm365_ipipe.h                   | 1029 +++++++
 include/linux/dm3xx_ipipeif.h                 |   64 +
 include/linux/imp_common.h                    |  171 ++
 include/media/davinci/vpfe.h                  |   93 +
 28 files changed, 14486 insertions(+), 13 deletions(-)
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
 create mode 100644 include/linux/dm365_ccdc.h
 create mode 100644 include/linux/dm365_ipipe.h
 create mode 100644 include/linux/dm3xx_ipipeif.h
 create mode 100644 include/linux/imp_common.h
 create mode 100644 include/media/davinci/vpfe.h

