Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:2463 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756014Ab3LTMML (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Dec 2013 07:12:11 -0500
Received: from tschai.lan (209.80-203-20.nextgentel.com [80.203.20.209])
	(authenticated bits=0)
	by smtp-vbr4.xs4all.nl (8.13.8/8.13.8) with ESMTP id rBKCC891039045
	for <linux-media@vger.kernel.org>; Fri, 20 Dec 2013 13:12:10 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from [10.61.168.73] (173-38-208-169.cisco.com [173.38.208.169])
	by tschai.lan (Postfix) with ESMTPSA id 136B22A2226
	for <linux-media@vger.kernel.org>; Fri, 20 Dec 2013 13:11:49 +0100 (CET)
Message-ID: <52B43416.8070603@xs4all.nl>
Date: Fri, 20 Dec 2013 13:12:06 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.14] Fixes (second attempt)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(This fixes a broken patch in my previous pull request and it adds a patch for the
broken davinci_vfpe compile)

Hi Mauro,

This empties my list of pending patches.

I will do one other pull request today (to move the omap2 and sn9c102 to staging)
and another in one week for the adv patches, assuming there will be no comments.

Regards,

	HansThe following changes since commit d22d32e117c19efa1761d871d9dab5e294b7b77d:

  [media] Add USB IDs for Winfast DTV Dongle Mini-D (2013-12-19 09:26:15 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.14b

for you to fetch changes up to ddcefa026585c38950224fc6d12a9a324b1088d0:

  davinci-vpfe: fix compile error (2013-12-20 13:04:44 +0100)

----------------------------------------------------------------
Antonio Ospite (2):
      Documentation/DocBook/media/v4l/subdev-formats.xml: fix a typo
      Documentation/DocBook/media/v4l: fix typo, s/packet/packed/

Archit Taneja (8):
      v4l: ti-vpe: create a scaler block library
      v4l: ti-vpe: support loading of scaler coefficients
      v4l: ti-vpe: make vpe driver load scaler coefficients
      v4l: ti-vpe: enable basic scaler support
      v4l: ti-vpe: create a color space converter block library
      v4l: ti-vpe: Add helper to perform color conversion
      v4l: ti-vpe: enable CSC support for VPE
      v4l: ti-vpe: Add a type specifier to describe vpdma data format type

Fengguang Wu (2):
      fix coccinelle warnings
      fix coccinelle warnings

Hans Verkuil (26):
      v4l2: move tracepoints to video_usercopy
      vb2: push the mmap semaphore down to __buf_prepare()
      vb2: simplify qbuf/prepare_buf by removing callback.
      vb2: fix race condition between REQBUFS and QBUF/PREPARE_BUF.
      vb2: remove the 'fileio = NULL' hack.
      vb2: retry start_streaming in case of insufficient buffers.
      vb2: don't set index, don't start streaming for write()
      vb2: return ENOBUFS in start_streaming in case of too few buffers.
      vb2: Improve file I/O emulation to handle buffers in any order
      DocBook: drop the word 'only'.
      saa7134: move the queue data from saa7134_fh to saa7134_dev.
      saa7134: convert to the control framework.
      saa7134: cleanup radio/video/empress ioctl handling
      saa7134: remove dev from saa7134_fh, use saa7134_fh for empress node
      saa7134: share resource management between normal and empress nodes.
      saa7134: add support for control events.
      saa7134: use V4L2_IN_ST_NO_SIGNAL instead of NO_SYNC
      saa6752hs: drop compat control code.
      saa6752hs: move to media/i2c
      saa6752hs.h: drop empty header.
      saa7134: drop log_status for radio.
      saa6588: after calling CMD_CLOSE, CMD_POLL is broken.
      saa6588: remove unused CMD_OPEN.
      saa6588: add support for non-blocking mode.
      saa7134: don't set vfd->debug.
      davinci-vpfe: fix compile error

Joe Perches (1):
      media: Remove OOM message after input_allocate_device

Matthias Schwarzott (2):
      cx231xx: Add missing selects for MEDIA_SUBDRV_AUTOSELECT
      cx231xx: fix i2c debug prints

Ricardo Ribalda (1):
      videodev2: Set vb2_rect's width and height as unsigned

Wei Yongjun (1):
      radio-bcm2048: fix missing unlock on error in bcm2048_rds_fifo_receive()

 Documentation/DocBook/media/v4l/compat.xml          |   12 +
 Documentation/DocBook/media/v4l/dev-overlay.xml     |    9 +-
 Documentation/DocBook/media/v4l/subdev-formats.xml  |    6 +-
 Documentation/DocBook/media/v4l/v4l2.xml            |   10 +-
 Documentation/DocBook/media/v4l/vidioc-cropcap.xml  |   10 +-
 Documentation/DocBook/media/v4l/vidioc-streamon.xml |    2 +-
 drivers/media/i2c/Kconfig                           |   12 +
 drivers/media/i2c/Makefile                          |    1 +
 drivers/media/i2c/mt9m032.c                         |   16 +-
 drivers/media/i2c/mt9p031.c                         |   28 +-
 drivers/media/i2c/mt9t001.c                         |   26 +-
 drivers/media/i2c/mt9v032.c                         |   38 +-
 drivers/media/i2c/saa6588.c                         |   50 +--
 drivers/media/{pci/saa7134 => i2c}/saa6752hs.c      |   19 +-
 drivers/media/i2c/smiapp/smiapp-core.c              |    8 +-
 drivers/media/i2c/soc_camera/mt9m111.c              |    4 +-
 drivers/media/i2c/tvp5150.c                         |   14 +-
 drivers/media/pci/bt8xx/bttv-driver.c               |   10 +-
 drivers/media/pci/saa7134/Kconfig                   |    1 +
 drivers/media/pci/saa7134/Makefile                  |    2 +-
 drivers/media/pci/saa7134/saa7134-core.c            |   11 +-
 drivers/media/pci/saa7134/saa7134-empress.c         |  359 +++++-------------
 drivers/media/pci/saa7134/saa7134-vbi.c             |   11 +-
 drivers/media/pci/saa7134/saa7134-video.c           |  781 +++++++++++++++------------------------
 drivers/media/pci/saa7134/saa7134.h                 |   66 +++-
 drivers/media/platform/davinci/vpbe_display.c       |    2 +-
 drivers/media/platform/davinci/vpif_capture.c       |    2 +-
 drivers/media/platform/davinci/vpif_display.c       |    2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c        |    2 +-
 drivers/media/platform/s5p-tv/mixer_video.c         |    2 +-
 drivers/media/platform/soc_camera/mx2_camera.c      |    2 +-
 drivers/media/platform/soc_camera/soc_scale_crop.c  |    4 +-
 drivers/media/platform/ti-vpe/Makefile              |    2 +-
 drivers/media/platform/ti-vpe/csc.c                 |  196 ++++++++++
 drivers/media/platform/ti-vpe/csc.h                 |   68 ++++
 drivers/media/platform/ti-vpe/sc.c                  |  311 ++++++++++++++++
 drivers/media/platform/ti-vpe/sc.h                  |  208 +++++++++++
 drivers/media/platform/ti-vpe/sc_coeff.h            | 1342 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/media/platform/ti-vpe/vpdma.c               |   36 +-
 drivers/media/platform/ti-vpe/vpdma.h               |    7 +
 drivers/media/platform/ti-vpe/vpe.c                 |  251 ++++++++-----
 drivers/media/platform/ti-vpe/vpe_regs.h            |  187 ----------
 drivers/media/rc/imon.c                             |    8 +-
 drivers/media/usb/cx231xx/Kconfig                   |    2 +
 drivers/media/usb/cx231xx/cx231xx-i2c.c             |   16 +-
 drivers/media/usb/em28xx/em28xx-input.c             |    4 +-
 drivers/media/usb/pwc/pwc-if.c                      |    1 -
 drivers/media/v4l2-core/v4l2-dev.c                  |    9 -
 drivers/media/v4l2-core/v4l2-ioctl.c                |    9 +
 drivers/media/v4l2-core/videobuf2-core.c            |  452 ++++++++++++-----------
 drivers/staging/media/bcm2048/radio-bcm2048.c       |   11 +-
 drivers/staging/media/davinci_vpfe/dm365_isif.c     |    1 +
 drivers/staging/media/davinci_vpfe/vpfe_video.c     |    2 +
 include/media/saa6588.h                             |    2 +-
 include/media/saa6752hs.h                           |   26 --
 include/media/videobuf2-core.h                      |   17 +-
 include/uapi/linux/v4l2-controls.h                  |    4 +
 include/uapi/linux/videodev2.h                      |    4 +-
 58 files changed, 3241 insertions(+), 1457 deletions(-)
 rename drivers/media/{pci/saa7134 => i2c}/saa6752hs.c (98%)
 create mode 100644 drivers/media/platform/ti-vpe/csc.c
 create mode 100644 drivers/media/platform/ti-vpe/csc.h
 create mode 100644 drivers/media/platform/ti-vpe/sc.c
 create mode 100644 drivers/media/platform/ti-vpe/sc.h
 create mode 100644 drivers/media/platform/ti-vpe/sc_coeff.h
 delete mode 100644 include/media/saa6752hs.h
