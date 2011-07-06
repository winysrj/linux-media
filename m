Return-path: <mchehab@localhost>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:41368 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572Ab1GFPRL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jul 2011 11:17:11 -0400
Received: from spt2.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LNX000KH3SLZW@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 06 Jul 2011 16:17:09 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LNX002LJ3SKFI@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 06 Jul 2011 16:17:08 +0100 (BST)
Date: Wed, 06 Jul 2011 17:17:03 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [GIT PULL FOR 3.1] TV driver for Samsung S5P platform
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com
Message-id: <1309965423-12082-1-git-send-email-t.stanislaws@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

Hello Mauro,

The following changes since commit 66ef90675ad5e45717ff84e4a106c0d22e690803:

  [media] DocBook/v4l: Document the new system-wide version behavior (2011-06-29 17:45:31 -0300)

are available in the git repository at:
  git://git.infradead.org/users/kmpark/linux-2.6-samsung s5p-tv-for-mauro-no59_94

Tomasz Stanislawski (7):
      v4l: add g_tvnorms_output callback to V4L2 subdev
      v4l: add g_dv_preset callback to V4L2 subdev
      v4l: add g_std_output callback to V4L2 subdev
      v4l: fix v4l_fill_dv_preset_info function
      v4l: s5p-tv: add drivers for HDMI on Samsung S5P platform
      v4l: s5p-tv: add SDO driver for Samsung S5P platform
      v4l: s5p-tv: add TV Mixer driver for Samsung S5P platform

 drivers/media/video/Kconfig                  |    2 +
 drivers/media/video/Makefile                 |    1 +
 drivers/media/video/s5p-tv/Kconfig           |   76 ++
 drivers/media/video/s5p-tv/Makefile          |   17 +
 drivers/media/video/s5p-tv/hdmi_drv.c        | 1042 ++++++++++++++++++++++++++
 drivers/media/video/s5p-tv/hdmiphy_drv.c     |  188 +++++
 drivers/media/video/s5p-tv/mixer.h           |  354 +++++++++
 drivers/media/video/s5p-tv/mixer_drv.c       |  487 ++++++++++++
 drivers/media/video/s5p-tv/mixer_grp_layer.c |  185 +++++
 drivers/media/video/s5p-tv/mixer_reg.c       |  541 +++++++++++++
 drivers/media/video/s5p-tv/mixer_video.c     | 1006 +++++++++++++++++++++++++
 drivers/media/video/s5p-tv/mixer_vp_layer.c  |  211 ++++++
 drivers/media/video/s5p-tv/regs-hdmi.h       |  141 ++++
 drivers/media/video/s5p-tv/regs-mixer.h      |  121 +++
 drivers/media/video/s5p-tv/regs-sdo.h        |   63 ++
 drivers/media/video/s5p-tv/regs-vp.h         |   88 +++
 drivers/media/video/s5p-tv/sdo_drv.c         |  479 ++++++++++++
 drivers/media/video/v4l2-common.c            |    2 +
 include/media/v4l2-subdev.h                  |   12 +
 19 files changed, 5016 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/s5p-tv/Kconfig
 create mode 100644 drivers/media/video/s5p-tv/Makefile
 create mode 100644 drivers/media/video/s5p-tv/hdmi_drv.c
 create mode 100644 drivers/media/video/s5p-tv/hdmiphy_drv.c
 create mode 100644 drivers/media/video/s5p-tv/mixer.h
 create mode 100644 drivers/media/video/s5p-tv/mixer_drv.c
 create mode 100644 drivers/media/video/s5p-tv/mixer_grp_layer.c
 create mode 100644 drivers/media/video/s5p-tv/mixer_reg.c
 create mode 100644 drivers/media/video/s5p-tv/mixer_video.c
 create mode 100644 drivers/media/video/s5p-tv/mixer_vp_layer.c
 create mode 100644 drivers/media/video/s5p-tv/regs-hdmi.h
 create mode 100644 drivers/media/video/s5p-tv/regs-mixer.h
 create mode 100644 drivers/media/video/s5p-tv/regs-sdo.h
 create mode 100644 drivers/media/video/s5p-tv/regs-vp.h
 create mode 100644 drivers/media/video/s5p-tv/sdo_drv.c
