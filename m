Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:55646 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570Ab2EaMMP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 May 2012 08:12:15 -0400
From: "Hadli, Manjunath" <manjunath.hadli@ti.com>
To: LMML <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>
Subject: [GIT PULL FOR v3.5] davicni: vpfe:media controller based capture
 driver for dm365
Date: Thu, 31 May 2012 12:12:06 +0000
Message-ID: <E99FAA59F8D8D34D8A118DD37F7C8F753E92E936@DBDE01.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,
 The following patch set adds the media controller based driver TI dm365 SoC. 
Patches have gone through RFC and reviews and are pending for some time.

The main support added here:
-CCDC capture
-Previewer
-Resizer
-AEW/AF
-Some media formats supported on dm365
-PIX_FORMATs supported on dm365


---
The following changes since commit a01ee165a132fadb57659d26246e340d6ac53265:

  Merge branch 'for-linus' of git://git.open-osd.org/linux-open-osd (2012-05-28 13:10:41 -0700)

are available in the git repository at:

  git://linuxtv.org/mhadli/v4l-dvb-davinci_devices.git pull_dm365_mc_for_mauro

Manjunath Hadli (19):
      media: add new mediabus format enums for dm365
      v4l2: add new pixel formats supported on dm365
      davinci: vpfe: add dm3xx IPIPEIF hardware support module
      davinci: vpfe: add IPIPE hardware layer support
      davinci: vpfe: add IPIPE support for media controller driver
      davinci: vpfe: add support for CCDC hardware for dm365
      davinci: vpfe: add ccdc driver with media controller interface
      davinci: vpfe: add v4l2 video driver support
      davinci: vpfe: v4l2 capture driver with media interface
      davinci: vpfe: previewer driver based on v4l2 media controller framework
      davinci: vpfe: resizer driver based on media framework
      davinci: vpfe: add DM365 autofoucus(AF) hardware interface
      davinci: vpfe: add autofocus driver based on media framework
      davinci: vpfe: add hardware interface for dm365 aew
      davinci: vpfe: add aew driver based on v4l2 media framework
      dm365: vpss: setup ISP registers
      dm365: vpss: set vpss clk ctrl
      dm365: vpss: add helper functions for setting hardware parameters used by main driver
      davinci: vpfe: build infrastructure for dm365

 .../DocBook/media/v4l/pixfmt-srggb10alaw8.xml      |   34 +
 Documentation/DocBook/media/v4l/pixfmt-uv8.xml     |   62 +
 Documentation/DocBook/media/v4l/pixfmt.xml         |    2 +
 Documentation/DocBook/media/v4l/subdev-formats.xml |  171 +
 drivers/media/video/davinci/Kconfig                |   72 +-
 drivers/media/video/davinci/Makefile               |   17 +
 drivers/media/video/davinci/ccdc_hw_device.h       |    2 +-
 drivers/media/video/davinci/dm355_ccdc.c           |    2 +-
 drivers/media/video/davinci/dm365_a3_hw.c          |  389 ++
 drivers/media/video/davinci/dm365_a3_hw.h          |  253 ++
 drivers/media/video/davinci/dm365_aew.c            |  544 +++
 drivers/media/video/davinci/dm365_aew.h            |   55 +
 drivers/media/video/davinci/dm365_af.c             |  563 +++
 drivers/media/video/davinci/dm365_af.h             |   59 +
 drivers/media/video/davinci/dm365_ccdc.c           | 1453 ++++++++
 drivers/media/video/davinci/dm365_ccdc.h           |   91 +
 drivers/media/video/davinci/dm365_ccdc_regs.h      |  309 ++
 drivers/media/video/davinci/dm365_def_para.c       |  310 ++
 drivers/media/video/davinci/dm365_def_para.h       |   39 +
 drivers/media/video/davinci/dm365_ipipe.c          | 3844 ++++++++++++++++++++
 drivers/media/video/davinci/dm365_ipipe.h          |  378 ++
 drivers/media/video/davinci/dm365_ipipe_hw.c       |  935 +++++
 drivers/media/video/davinci/dm365_ipipe_hw.h       |  539 +++
 drivers/media/video/davinci/dm3xx_ipipeif.c        |  313 ++
 drivers/media/video/davinci/dm3xx_ipipeif.h        |  256 ++
 drivers/media/video/davinci/dm644x_ccdc.c          |    2 +-
 drivers/media/video/davinci/imp_common.h           |   87 +
 drivers/media/video/davinci/imp_hw_if.h            |  170 +
 drivers/media/video/davinci/isif.c                 |    2 +-
 drivers/media/video/davinci/vpfe_aew.c             |  238 ++
 drivers/media/video/davinci/vpfe_aew.h             |   51 +
 drivers/media/video/davinci/vpfe_af.c              |  240 ++
 drivers/media/video/davinci/vpfe_af.h              |   47 +
 drivers/media/video/davinci/vpfe_capture.c         |    2 +-
 drivers/media/video/davinci/vpfe_ccdc.c            |  817 +++++
 drivers/media/video/davinci/vpfe_ccdc.h            |   86 +
 drivers/media/video/davinci/vpfe_mc_capture.c      |  801 ++++
 drivers/media/video/davinci/vpfe_mc_capture.h      |   99 +
 drivers/media/video/davinci/vpfe_previewer.c       | 1066 ++++++
 drivers/media/video/davinci/vpfe_previewer.h       |   65 +
 drivers/media/video/davinci/vpfe_resizer.c         | 1076 ++++++
 drivers/media/video/davinci/vpfe_resizer.h         |   63 +
 drivers/media/video/davinci/vpfe_video.c           | 1728 +++++++++
 drivers/media/video/davinci/vpfe_video.h           |  146 +
 drivers/media/video/davinci/vpss.c                 |   56 +
 include/linux/dm365_aew.h                          |  153 +
 include/linux/dm365_af.h                           |  203 +
 include/linux/dm365_ccdc.h                         |  611 ++++
 include/linux/dm365_ipipe.h                        | 1029 ++++++
 include/linux/dm3xx_ipipeif.h                      |   65 +
 include/linux/imp_common.h                         |  172 +
 include/linux/v4l2-mediabus.h                      |   10 +-
 include/linux/videodev2.h                          |    8 +
 include/media/davinci/vpfe.h                       |   81 +
 include/media/davinci/vpss.h                       |   15 +
 55 files changed, 19872 insertions(+), 9 deletions(-)
 create mode 100644 Documentation/DocBook/media/v4l/pixfmt-srggb10alaw8.xml
 create mode 100644 Documentation/DocBook/media/v4l/pixfmt-uv8.xml
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
 create mode 100644 drivers/media/video/davinci/vpfe_ccdc.c
 create mode 100644 drivers/media/video/davinci/vpfe_ccdc.h
 create mode 100644 drivers/media/video/davinci/vpfe_mc_capture.c
 create mode 100644 drivers/media/video/davinci/vpfe_mc_capture.h
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
 create mode 100644 include/media/davinci/vpfe.h
