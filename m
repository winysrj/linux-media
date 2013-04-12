Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:1313 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753785Ab3DLMkP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Apr 2013 08:40:15 -0400
Received: from alastor.dyndns.org (166.80-203-20.nextgentel.com [80.203.20.166] (may be forged))
	(authenticated bits=0)
	by smtp-vbr8.xs4all.nl (8.13.8/8.13.8) with ESMTP id r3CCeAnJ090872
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Fri, 12 Apr 2013 14:40:13 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.localnet (tschai.lan [192.168.1.10])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id 853D411E018C
	for <linux-media@vger.kernel.org>; Fri, 12 Apr 2013 14:40:10 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.10] V4L2 patches
Date: Fri, 12 Apr 2013 14:40:08 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201304121440.08921.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here is my set of pending V4L2 patches for 3.10.

Patchwork has been updated accordingly.

Regards,

	Hans

The following changes since commit 81e096c8ac6a064854c2157e0bf802dc4906678c:

  [media] budget: Add support for Philips Semi Sylt PCI ref. design (2013-04-08 07:28:01 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-mauro1

for you to fetch changes up to a5d57a4138b7d45a4d72645c2ac500bbffc5ec36:

  ARM: daVinci: dm644x/dm355/dm365: replace V4L2_STD_525_60/625_50 with V4L2_STD_NTSC/PAL (2013-04-12 14:02:31 +0200)

----------------------------------------------------------------
Antti Palosaari (1):
      MAINTAINERS: update CYPRESS_FIRMWARE media driver

Frank Schaefer (2):
      em28xx: fix snapshot button support
      em28xx: improve em2710/em2820 distinction

Hans Verkuil (30):
      tuner-core/tda9887: get_afc can be tuner mode specific
      tuner-core/simple: get_rf_strength can be tuner mode specific
      v4l2: put VIDIOC_DBG_G_CHIP_NAME under ADV_DEBUG.
      v4l2: drop V4L2_CHIP_MATCH_SUBDEV_NAME.
      v4l2-ioctl: fill in name before calling vidioc_g_chip_name
      v4l2: rename VIDIOC_DBG_G_CHIP_NAME to _CHIP_INFO
      videodev2.h: increase size of 'reserved' array.
      em28xx: fix kernel oops when watching digital TV
      radio-si4713: remove audout ioctls
      radio-si4713: embed struct video_device instead of allocating it.
      radio-si4713: improve querycap
      radio-si4713: use V4L2 core lock.
      radio-si4713: fix g/s_frequency
      radio-si4713: convert to the control framework
      radio-si4713: add prio checking and control events.
      videodev2.h: fix incorrect V4L2_DV_FL_HALF_LINE bitmask.
      v4l2-dv-timings.h: add 480i59.94 and 576i50 CEA-861-E timings.
      hdpvr: convert to the control framework.
      hdpvr: remove hdpvr_fh and just use v4l2_fh.
      hdpvr: add prio and control event support.
      hdpvr: support device_caps in querycap.
      hdpvr: small fixes
      hdpvr: register the video node at the end of probe.
      hdpvr: recognize firmware version 0x1e.
      hdpvr: add g/querystd, remove deprecated current_norm.
      hdpvr: add dv_timings support.
      hdpvr: allow g/s/enum/querystd when in legacy mode.
      MAINTAINERS: add hdpvr entry.
      dt3155v4l: fix incorrect mutex locking.
      dt3155v4l: fix timestamp handling.

Lad, Prabhakar (9):
      davinci: vpif: add pm_runtime support
      media: davinci: vpss: enable vpss clocks
      media: davinci: vpbe: venc: move the enabling of vpss clocks to driver
      davinic: vpss: trivial cleanup
      ARM: davinci: dm365: add support for v4l2 video display
      ARM: davinci: dm365 EVM: add support for VPBE display
      ARM: davinci: dm355: add support for v4l2 video display
      ARM: davinci: dm355 EVM: add support for VPBE display
      ARM: daVinci: dm644x/dm355/dm365: replace V4L2_STD_525_60/625_50 with V4L2_STD_NTSC/PAL

Ondrej Zary (8):
      saa7134: v4l2-compliance: implement V4L2_CAP_DEVICE_CAPS
      saa7134: v4l2-compliance: don't report invalid audio modes for radio
      saa7134: v4l2-compliance: use v4l2_fh to fix priority handling
      saa7134: v4l2-compliance: return real frequency
      saa7134: v4l2-compliance: fix g_tuner/s_tuner
      saa7134: v4l2-compliance: remove bogus audio input support
      saa7134: v4l2-compliance: remove bogus g_parm
      saa7134: v4l2-compliance: clear reserved part of VBI structure

Randy Dunlap (1):
      media: Fix randconfig error

Sekhar Nori (1):
      media: davinci: kconfig: fix incorrect selects

Vladimir Barinov (1):
      adv7180: fix querystd() method for no input signal

 Documentation/DocBook/media/v4l/compat.xml                                      |    2 +-
 Documentation/DocBook/media/v4l/v4l2.xml                                        |    4 +-
 Documentation/DocBook/media/v4l/vidioc-dbg-g-chip-ident.xml                     |    7 +-
 .../media/v4l/{vidioc-dbg-g-chip-name.xml => vidioc-dbg-g-chip-info.xml}        |   41 +-
 Documentation/DocBook/media/v4l/vidioc-dbg-g-register.xml                       |   27 +-
 MAINTAINERS                                                                     |   28 +-
 arch/arm/mach-davinci/board-dm355-evm.c                                         |   71 ++-
 arch/arm/mach-davinci/board-dm365-evm.c                                         |  166 +++++-
 arch/arm/mach-davinci/board-dm644x-evm.c                                        |    4 +-
 arch/arm/mach-davinci/davinci.h                                                 |   11 +-
 arch/arm/mach-davinci/dm355.c                                                   |  174 +++++-
 arch/arm/mach-davinci/dm365.c                                                   |  195 ++++++-
 arch/arm/mach-davinci/dm644x.c                                                  |    9 +-
 arch/arm/mach-davinci/pm_domain.c                                               |    2 +-
 drivers/media/common/Kconfig                                                    |    1 +
 drivers/media/dvb-core/dvb_frontend.h                                           |    4 +-
 drivers/media/i2c/adv7180.c                                                     |    4 +
 drivers/media/pci/saa7134/saa7134-core.c                                        |    3 +-
 drivers/media/pci/saa7134/saa7134-video.c                                       |  167 ++----
 drivers/media/pci/saa7134/saa7134.h                                             |    5 +-
 drivers/media/platform/davinci/Kconfig                                          |  103 ++--
 drivers/media/platform/davinci/Makefile                                         |   17 +-
 drivers/media/platform/davinci/dm355_ccdc.c                                     |   39 +-
 drivers/media/platform/davinci/dm644x_ccdc.c                                    |   44 --
 drivers/media/platform/davinci/isif.c                                           |   28 +-
 drivers/media/platform/davinci/vpbe_venc.c                                      |   25 +
 drivers/media/platform/davinci/vpif.c                                           |   24 +-
 drivers/media/platform/davinci/vpss.c                                           |   36 +-
 drivers/media/radio/radio-si4713.c                                              |  165 +-----
 drivers/media/radio/si4713-i2c.c                                                | 1044 ++++++++----------------------------
 drivers/media/radio/si4713-i2c.h                                                |   66 ++-
 drivers/media/tuners/tda8290.c                                                  |   15 +-
 drivers/media/tuners/tda9887.c                                                  |   14 +-
 drivers/media/tuners/tuner-simple.c                                             |    5 +-
 drivers/media/usb/em28xx/em28xx-cards.c                                         |   19 +-
 drivers/media/usb/em28xx/em28xx-dvb.c                                           |    8 +-
 drivers/media/usb/em28xx/em28xx-video.c                                         |   10 +-
 drivers/media/usb/hdpvr/hdpvr-core.c                                            |   14 +-
 drivers/media/usb/hdpvr/hdpvr-video.c                                           |  940 ++++++++++++++++----------------
 drivers/media/usb/hdpvr/hdpvr.h                                                 |   19 +-
 drivers/media/v4l2-core/tuner-core.c                                            |   43 +-
 drivers/media/v4l2-core/v4l2-common.c                                           |    3 +-
 drivers/media/v4l2-core/v4l2-dev.c                                              |    2 +-
 drivers/media/v4l2-core/v4l2-ioctl.c                                            |   81 ++-
 drivers/staging/media/dt3155v4l/dt3155v4l.c                                     |    7 +-
 include/media/v4l2-ioctl.h                                                      |    6 +-
 include/uapi/linux/v4l2-dv-timings.h                                            |   18 +
 include/uapi/linux/videodev2.h                                                  |   15 +-
 48 files changed, 1686 insertions(+), 2049 deletions(-)
 rename Documentation/DocBook/media/v4l/{vidioc-dbg-g-chip-name.xml => vidioc-dbg-g-chip-info.xml} (85%)
