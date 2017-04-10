Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:36165 "EHLO
        lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751615AbdDJLpv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Apr 2017 07:45:51 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.12] Various fixes
Message-ID: <135445f3-a728-3eef-43fb-24643cd92f51@xs4all.nl>
Date: Mon, 10 Apr 2017 13:45:45 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Various fixes for 4.12.

Regards,

	Hans

The following changes since commit 0538bee6fdec9b79910c1c9835e79be75d0e1bdf:

  [media] MAINTAINERS: update atmel-isi.c path (2017-04-10 08:13:08 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.12f

for you to fetch changes up to 2c3d089c30302bf17953176e37ccfb344b53186e:

  v4l2-tpg: don't clamp XV601/709 to lim range (2017-04-10 13:32:32 +0200)

----------------------------------------------------------------
Alexey Khoroshilov (1):
      m2m-deinterlace: don't return zero on failure paths in deinterlace_probe()

Colin Ian King (1):
      coda: remove redundant call to v4l2_m2m_get_vq

Geliang Tang (11):
      saa7134: use setup_timer
      saa7146: use setup_timer
      bt8xx: use setup_timer
      cx18: use setup_timer
      ivtv: use setup_timer
      netup_unidvb: use setup_timer
      av7110: use setup_timer
      fsl-viu: use setup_timer
      c8sectpfe: use setup_timer
      wl128x: use setup_timer
      imon: use setup_timer

Hans Verkuil (2):
      videodev2.h: fix outdated comment
      v4l2-tpg: don't clamp XV601/709 to lim range

Nikola Jelic (1):
      media: bcm2048: fix several macros

Philipp Zabel (3):
      tvp5150: allow get/set_fmt on the video source pad
      tvp5150: fix pad format frame height
      coda: do not enumerate YUYV if VDOA is not available

 drivers/media/common/saa7146/saa7146_vbi.c            |  5 ++---
 drivers/media/common/saa7146/saa7146_video.c          |  5 ++---
 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c         |  9 ++++++++-
 drivers/media/i2c/tvp5150.c                           |  4 ++--
 drivers/media/pci/bt8xx/bttv-driver.c                 |  4 +---
 drivers/media/pci/cx18/cx18-streams.c                 |  4 +---
 drivers/media/pci/ivtv/ivtv-driver.c                  |  5 ++---
 drivers/media/pci/netup_unidvb/netup_unidvb_core.c    |  5 ++---
 drivers/media/pci/saa7134/saa7134-ts.c                |  5 ++---
 drivers/media/pci/saa7134/saa7134-vbi.c               |  5 ++---
 drivers/media/pci/saa7134/saa7134-video.c             |  5 ++---
 drivers/media/pci/ttpci/av7110_ir.c                   |  5 ++---
 drivers/media/platform/coda/coda-common.c             |  8 ++++++--
 drivers/media/platform/fsl-viu.c                      |  5 ++---
 drivers/media/platform/m2m-deinterlace.c              |  1 +
 drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c |  5 ++---
 drivers/media/radio/wl128x/fmdrv_common.c             |  5 ++---
 drivers/media/rc/imon.c                               |  5 ++---
 drivers/staging/media/bcm2048/radio-bcm2048.c         | 12 ++++++------
 include/uapi/linux/videodev2.h                        |  3 +--
 20 files changed, 50 insertions(+), 55 deletions(-)
