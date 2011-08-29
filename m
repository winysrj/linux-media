Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:35028 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753741Ab1H2PH3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Aug 2011 11:07:29 -0400
Received: from dbdp20.itg.ti.com ([172.24.170.38])
	by arroyo.ext.ti.com (8.13.7/8.13.7) with ESMTP id p7TF7PnC003495
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Mon, 29 Aug 2011 10:07:27 -0500
From: Manjunath Hadli <manjunath.hadli@ti.com>
To: LMML <linux-media@vger.kernel.org>
CC: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>
Subject: [PATCH v2 0/8] RFC for Media Controller capture driver for DM365
Date: Mon, 29 Aug 2011 20:37:11 +0530
Message-ID: <1314630439-1122-1-git-send-email-manjunath.hadli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

changes from last patch set:
1. Made changes based on Sakari's feedback mainly:
        a. returned early to allow unindenting
        b. reformatting to shift the code to left where possible
        c. changed hex numbers to lower case
        d. corrected the defines according to module names.
        e. magic numbers removed.
        f. changed non-integer returning functions to void
        g. removed unwanted paranthses.
        h. fixed error codes.
        i. fixed some RESET_BIt code to what it was intended for.
2. reorganized the header files to move the kernel-only headers
along with the c files and interface headers in the include folder.

Manjunath Hadli (6):
  davinci: vpfe: add dm3xx IPIPEIF hardware support module
  davinci: vpfe: add support for CCDC hardware for dm365
  davinci: vpfe: add ccdc driver with media controller interface
  davinci: vpfe: add v4l2 video driver support
  davinci: vpfe: v4l2 capture driver with media interface
  davinci: vpfe: build infrastructure for dm365

Nagabhushana Netagunte (2):
  davinci: vpfe: add IPIPE hardware layer support
  davinci: vpfe: add IPIPE support for media controller driver

 drivers/media/video/davinci/Kconfig           |   46 +-
 drivers/media/video/davinci/Makefile          |   17 +-
 drivers/media/video/davinci/ccdc_hw_device.h  |   10 +-
 drivers/media/video/davinci/ccdc_types.h      |   43 +
 drivers/media/video/davinci/dm365_ccdc.c      | 1519 ++++++++++
 drivers/media/video/davinci/dm365_ccdc.h      |   88 +
 drivers/media/video/davinci/dm365_ccdc_regs.h |  309 ++
 drivers/media/video/davinci/dm365_def_para.c  |  486 +++
 drivers/media/video/davinci/dm365_def_para.h  |   39 +
 drivers/media/video/davinci/dm365_ipipe.c     | 3966 +++++++++++++++++++++++++
 drivers/media/video/davinci/dm365_ipipe.h     |  300 ++
 drivers/media/video/davinci/dm365_ipipe_hw.c  |  949 ++++++
 drivers/media/video/davinci/dm365_ipipe_hw.h  |  539 ++++
 drivers/media/video/davinci/dm3xx_ipipeif.c   |  317 ++
 drivers/media/video/davinci/dm3xx_ipipeif.h   |  258 ++
 drivers/media/video/davinci/imp_common.h      |   85 +
 drivers/media/video/davinci/imp_hw_if.h       |  178 ++
 drivers/media/video/davinci/vpfe_capture.c    |  793 +++++
 drivers/media/video/davinci/vpfe_capture.h    |  104 +
 drivers/media/video/davinci/vpfe_ccdc.c       |  813 +++++
 drivers/media/video/davinci/vpfe_ccdc.h       |   85 +
 drivers/media/video/davinci/vpfe_video.c      | 1712 +++++++++++
 drivers/media/video/davinci/vpfe_video.h      |  142 +
 include/linux/davinci_vpfe.h                  | 1223 ++++++++
 include/linux/dm365_ccdc.h                    |  664 +++++
 include/linux/dm3xx_ipipeif.h                 |   64 +
 include/media/davinci/vpfe.h                  |   91 +
 27 files changed, 14829 insertions(+), 11 deletions(-)
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

