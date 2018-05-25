Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:51392 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S935638AbeEYKOV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 May 2018 06:14:21 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.18] Various fixes
Message-ID: <e527b7bf-68ee-85ee-aa16-28194586bb55@xs4all.nl>
Date: Fri, 25 May 2018 12:14:13 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This is the usual collection of random fixes/improvements.

A note on one patch "v4l2-core: push taking ioctl mutex down to ioctl handler.":

I would like to get this in for 4.18 since it will help the fence and request API
implementation. But it is also OK if you decide to push this to 4.19. In addition,
this patch will almost certainly conflict with the "v4l2-ioctl: delete unused
v4l2_disable_ioctl_locking" patch from the gspca pull request. It should be
trivial to resolve, though.

Regards,

	Hans


The following changes since commit 8ed8bba70b4355b1ba029b151ade84475dd12991:

  media: imx274: remove non-indexed pointers from mode_table (2018-05-17 06:22:08 -0400)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.18e

for you to fetch changes up to a0cd70c2ce3d48e5007632d2d58d3c776b87a6b2:

  gspca_zc3xx: Enable short exposure times for OV7648 (2018-05-25 11:37:04 +0200)

----------------------------------------------------------------
Akinobu Mita (1):
      media: pxa_camera: avoid duplicate s_power calls

Colin Ian King (1):
      hdpvr: fix spelling mistake: "Hauppage" -> "Hauppauge"

Dan Carpenter (1):
      media: vivid: potential integer overflow in vidioc_g_edid()

Dmitry Osipenko (1):
      media: staging: tegra-vde: Reset memory client

Ezequiel Garcia (4):
      stk1160: Fix typo s/therwise/Otherwise
      stk1160: Add missing calls to mutex_destroy
      m2m-deinterlace: Remove DMA_ENGINE dependency
      tw686x: Fix incorrect vb2_mem_ops GFP flags

Geert Uytterhoeven (1):
      media: Remove depends on HAS_DMA in case of platform dependency

Gustavo A. R. Silva (1):
      au8522: remove duplicate code

Hans Verkuil (4):
      cec: fix wrong tx/rx_status values when canceling a msg
      adv7511: fix incorrect clear of CEC receive interrupt
      pvrusb2: replace pvr2_v4l2_ioctl by video_ioctl2
      v4l2-core: push taking ioctl mutex down to ioctl handler.

Mauro Carvalho Chehab (1):
      media: cec-pin-error-inj: avoid a false-positive Spectre detection

Ondrej Zary (3):
      gspca_zc3xx: Implement proper autogain and exposure control for OV7648
      gspca_zc3xx: Fix power line frequency settings for OV7648
      gspca_zc3xx: Enable short exposure times for OV7648

 drivers/media/cec/cec-adap.c                    | 19 +++++++++----
 drivers/media/cec/cec-pin-error-inj.c           | 23 ++++++++--------
 drivers/media/common/videobuf2/Kconfig          |  2 --
 drivers/media/dvb-frontends/au8522_decoder.c    | 14 ++++------
 drivers/media/i2c/adv7511.c                     |  4 +--
 drivers/media/pci/dt3155/Kconfig                |  1 -
 drivers/media/pci/intel/ipu3/Kconfig            |  1 -
 drivers/media/pci/solo6x10/Kconfig              |  1 -
 drivers/media/pci/sta2x11/Kconfig               |  1 -
 drivers/media/pci/tw5864/Kconfig                |  1 -
 drivers/media/pci/tw686x/Kconfig                |  1 -
 drivers/media/pci/tw686x/tw686x-video.c         |  3 +-
 drivers/media/platform/Kconfig                  | 45 ++++++++++--------------------
 drivers/media/platform/am437x/Kconfig           |  2 +-
 drivers/media/platform/atmel/Kconfig            |  4 +--
 drivers/media/platform/davinci/Kconfig          |  6 ----
 drivers/media/platform/marvell-ccic/Kconfig     |  2 --
 drivers/media/platform/pxa_camera.c             | 17 ++++++++----
 drivers/media/platform/rcar-vin/Kconfig         |  2 +-
 drivers/media/platform/soc_camera/Kconfig       |  3 +-
 drivers/media/platform/sti/c8sectpfe/Kconfig    |  2 +-
 drivers/media/platform/vivid/vivid-vid-common.c |  2 +-
 drivers/media/usb/gspca/zc3xx.c                 | 58 +++++++++++++++++++++++++++------------
 drivers/media/usb/hdpvr/hdpvr-i2c.c             |  2 +-
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.c        | 83 +++++++++++++++++++++-----------------------------------
 drivers/media/usb/stk1160/stk1160-core.c        |  4 ++-
 drivers/media/v4l2-core/Kconfig                 |  2 --
 drivers/media/v4l2-core/v4l2-dev.c              |  6 ----
 drivers/media/v4l2-core/v4l2-ioctl.c            | 20 ++++++++++++--
 drivers/media/v4l2-core/v4l2-subdev.c           | 17 +++++++++++-
 drivers/staging/media/davinci_vpfe/Kconfig      |  1 -
 drivers/staging/media/omap4iss/Kconfig          |  1 -
 drivers/staging/media/tegra-vde/tegra-vde.c     | 42 +++++++++++++++++++++++++---
 include/media/v4l2-dev.h                        |  9 ------
 include/media/v4l2-ioctl.h                      | 12 --------
 35 files changed, 215 insertions(+), 198 deletions(-)
