Return-path: <mchehab@pedra>
Received: from bear.ext.ti.com ([192.94.94.41]:37686 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753570Ab1F3NN2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jun 2011 09:13:28 -0400
Received: from dbdp20.itg.ti.com ([172.24.170.38])
	by bear.ext.ti.com (8.13.7/8.13.7) with ESMTP id p5UDDP14022254
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Thu, 30 Jun 2011 08:13:27 -0500
From: Manjunath Hadli <manjunath.hadli@ti.com>
To: LMML <linux-media@vger.kernel.org>
CC: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>
Subject: [ RFC PATCH 0/8] RFC for Media Controller capture driver for DM365
Date: Thu, 30 Jun 2011 18:43:09 +0530
Message-ID: <1309439597-15998-1-git-send-email-manjunath.hadli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Thease are the RFC patches for the DM365 video capture, of which 
the current set includes only CCDC and the VPFE framework. Once
the present set is reviewed, I will send out the other parts
like H3A, sensor additions etc.

Introduction
------------
This is the proposal of the initial version of design and implementation  of
the Davinci family (dm644x,dm355,dm365)VPFE (Video Port Front End) drivers
using Media Controloler , the initial version which supports
the following:
1) dm365 vpfe
2) ccdc,previewer,resizer,h3a,af blocks
3) supports both continuous and single-shot modes
4) supports user pointer exchange and memory mapped modes for buffer allocation

This driver bases its design on Laurent Pinchart's Media Controller Design
whose patches for Media Controller and subdev enhancements form the base.
The driver also takes copious elements taken from Laurent Pinchart and
others' OMAP ISP driver based on Media Controller. So thank you all the
people who are responsible for the Media Controller and the OMAP ISP driver.

Also, the core functionality of the driver comes from the arago vpfe capture
driver of which the CCDC capture was based on V4L2, with other drivers like
Previwer, and Resizer.

The current driver caters to dm6446,dm355 and dm365 of which the current
implementation works for dm365. The three VPFE IPs have some common elements
in terms of some highe level functionality but there are differences in terms
of register definitions and some core blocks.

The individual specifications for each of these can be found here:
dm6446 vpfe: http://www.ti.com/litv/pdf/sprue38h
dm355  vpfe: http://www.ti.com/litv/pdf/spruf71a
dm365  vpfe: http://www.ti.com/litv/pdf/sprufg8c

The initial version of the  driver implementation can be found here:

http://git.linuxtv.org/mhadli/v4l-dvb-davinci_devices.git?a=shortlog;h=refs/heads/mc_release

Driver Design: Main entities
----------------------------
The hardware modules for dm355,dm365 are mainly ipipe, ipipeif,isif. These
hardware modules are generically exposed to the user level in the for of
dm6446 style modules. Mainly -
ccdc, previewer, resizer in addition to the other histogram and
auto color/white balance correction and auto focus modules.

1)MT9P031 sensor  module for RAW capture
2)TVP7002 decoder module for HD inputs
3)TVP514x decoder module for SD inputs
4)CCDC capture module
5)Previewer Module for Bayer to YUV conversion
6)Resizer Module for scaling

Connection for on-the-fly capture
---------------------------------
Mt9P031 ------>CCDC--->Previewer(optional)--->Resizer(optional)--->Video
           |
TVP7002 ---
           |
TV514x  ---


Manjunath Hadli (3):
  davinci: vpfe: add dm3xx IPIPEIF hardware support module
  davinci: vpfe: add support for CCDC hardware for dm365
  davinci: vpfe: build infrastructure for dm365

Nagabhushana Netagunte (5):
  davinci: vpfe: add IPIPE hardware layer support
  davinci: vpfe: add IPIPE support for media controller driver
  davinci: vpfe: add ccdc driver with media controller interface
  davinci: vpfe: add v4l2 video driver support
  davinci: vpfe: v4l2 capture driver with media interface

 drivers/media/video/davinci/Kconfig           |   46 +-
 drivers/media/video/davinci/Makefile          |   17 +-
 drivers/media/video/davinci/ccdc_hw_device.h  |    6 +-
 drivers/media/video/davinci/dm365_ccdc.c      | 1517 +++++++++
 drivers/media/video/davinci/dm365_ccdc_regs.h |  309 ++
 drivers/media/video/davinci/dm365_def_para.c  |  485 +++
 drivers/media/video/davinci/dm365_def_para.h  |   39 +
 drivers/media/video/davinci/dm365_ipipe.c     | 4086 +++++++++++++++++++++++++
 drivers/media/video/davinci/dm365_ipipe_hw.c  | 1012 ++++++
 drivers/media/video/davinci/dm365_ipipe_hw.h  |  539 ++++
 drivers/media/video/davinci/dm3xx_ipipeif.c   |  368 +++
 drivers/media/video/davinci/vpfe_capture.c    |  793 +++++
 drivers/media/video/davinci/vpfe_ccdc.c       |  813 +++++
 drivers/media/video/davinci/vpfe_video.c      | 1712 +++++++++++
 include/media/davinci/dm365_ccdc.h            |  722 +++++
 include/media/davinci/dm365_ipipe.h           | 1353 ++++++++
 include/media/davinci/dm3xx_ipipeif.h         |  292 ++
 include/media/davinci/imp_common.h            |  231 ++
 include/media/davinci/imp_hw_if.h             |  177 ++
 include/media/davinci/vpfe_capture.h          |  158 +
 include/media/davinci/vpfe_ccdc.h             |   89 +
 include/media/davinci/vpfe_types.h            |   50 +-
 include/media/davinci/vpfe_video.h            |  142 +
 23 files changed, 14914 insertions(+), 42 deletions(-)
 create mode 100644 drivers/media/video/davinci/dm365_ccdc.c
 create mode 100644 drivers/media/video/davinci/dm365_ccdc_regs.h
 create mode 100644 drivers/media/video/davinci/dm365_def_para.c
 create mode 100644 drivers/media/video/davinci/dm365_def_para.h
 create mode 100644 drivers/media/video/davinci/dm365_ipipe.c
 create mode 100644 drivers/media/video/davinci/dm365_ipipe_hw.c
 create mode 100644 drivers/media/video/davinci/dm365_ipipe_hw.h
 create mode 100644 drivers/media/video/davinci/dm3xx_ipipeif.c
 create mode 100644 drivers/media/video/davinci/vpfe_capture.c
 create mode 100644 drivers/media/video/davinci/vpfe_ccdc.c
 create mode 100644 drivers/media/video/davinci/vpfe_video.c
 create mode 100644 include/media/davinci/dm365_ccdc.h
 create mode 100644 include/media/davinci/dm365_ipipe.h
 create mode 100644 include/media/davinci/dm3xx_ipipeif.h
 create mode 100644 include/media/davinci/imp_common.h
 create mode 100644 include/media/davinci/imp_hw_if.h
 create mode 100644 include/media/davinci/vpfe_capture.h
 create mode 100644 include/media/davinci/vpfe_ccdc.h
 create mode 100644 include/media/davinci/vpfe_video.h

