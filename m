Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:36514 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752605AbaLSLOH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Dec 2014 06:14:07 -0500
Received: from [10.61.169.145] (173-38-208-170.cisco.com [173.38.208.170])
	by tschai.lan (Postfix) with ESMTPSA id B17CE2A002F
	for <linux-media@vger.kernel.org>; Fri, 19 Dec 2014 12:13:50 +0100 (CET)
Message-ID: <54940879.7030108@xs4all.nl>
Date: Fri, 19 Dec 2014 12:14:01 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.20] Various fixes/improvements
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 427ae153c65ad7a08288d86baf99000569627d03:

  [media] bq/c-qcam, w9966, pms: move to staging in preparation for removal (2014-12-16 23:21:44 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.20c

for you to fetch changes up to db15c959f68f77b743a214a63a3c3d235feb5bd7:

  VIDEO_CAFE_CCIC should select VIDEOBUF2_DMA_SG (2014-12-19 12:09:26 +0100)

----------------------------------------------------------------
Andrey Utkin (1):
      solo6x10: just pass frame motion flag from hardware, drop additional handling as complicated and unstable

Geert Uytterhoeven (1):
      VIDEO_CAFE_CCIC should select VIDEOBUF2_DMA_SG

Hans Verkuil (12):
      media: drivers shouldn't touch debug field in video_device
      v4l2 core: improve debug flag handling
      v4l2-framework.txt: document debug attribute
      av7110: fix sparse warning
      budget-core: fix sparse warnings
      ivtv: fix sparse warning
      videobuf2-vmalloc: fix sparse warning
      hd29l2: fix sparse error and warnings
      m5mols: fix sparse warnings
      s5k4ecgx: fix sparse warnings
      s5k6aa: fix sparse warnings
      s5k5baf: fix sparse warnings

Shuah Khan (1):
      media: au0828 VBI support comment cleanup

 Documentation/video4linux/v4l2-framework.txt    | 25 ++++++++++++++++--
 drivers/media/dvb-frontends/hd29l2.c            | 10 ++++---
 drivers/media/i2c/m5mols/m5mols_core.c          |  9 ++-----
 drivers/media/i2c/s5k4ecgx.c                    | 11 ++++----
 drivers/media/i2c/s5k5baf.c                     | 13 ++++-----
 drivers/media/i2c/s5k6aa.c                      |  2 +-
 drivers/media/pci/bt8xx/bttv-driver.c           |  1 -
 drivers/media/pci/cx88/cx88-blackbird.c         |  3 ---
 drivers/media/pci/ivtv/ivtv-irq.c               | 22 +++++++++-------
 drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c  | 30 +--------------------
 drivers/media/pci/solo6x10/solo6x10.h           |  2 --
 drivers/media/pci/ttpci/av7110.c                |  5 +++-
 drivers/media/pci/ttpci/budget-core.c           | 89 ++++++++++++++++++++++++++++++++++----------------------------
 drivers/media/platform/marvell-ccic/Kconfig     |  1 +
 drivers/media/platform/marvell-ccic/mcam-core.c |  1 -
 drivers/media/usb/au0828/au0828-video.c         |  1 -
 drivers/media/usb/cx231xx/cx231xx-video.c       |  1 -
 drivers/media/usb/em28xx/em28xx-video.c         |  1 -
 drivers/media/usb/stk1160/stk1160-v4l.c         |  5 ----
 drivers/media/usb/stkwebcam/stk-webcam.c        |  1 -
 drivers/media/usb/tm6000/tm6000-video.c         |  3 +--
 drivers/media/usb/zr364xx/zr364xx.c             |  2 --
 drivers/media/v4l2-core/v4l2-dev.c              | 28 +++++++++++---------
 drivers/media/v4l2-core/v4l2-ioctl.c            | 10 ++++---
 drivers/media/v4l2-core/videobuf2-vmalloc.c     |  4 +--
 drivers/staging/media/tlg2300/pd-common.h       |  1 -
 drivers/staging/media/tlg2300/pd-radio.c        |  3 ---
 drivers/staging/media/tlg2300/pd-video.c        | 10 -------
 include/media/v4l2-dev.h                        |  3 ++-
 include/media/v4l2-ioctl.h                      | 15 ++++++++---
 30 files changed, 152 insertions(+), 160 deletions(-)
