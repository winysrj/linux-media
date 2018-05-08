Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:57081 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751119AbeEHKsu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 May 2018 06:48:50 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.18] v2: Various fixes/improvements
Message-ID: <b9c05ebb-6cb3-d6b3-f2e4-48720f3a05bd@xs4all.nl>
Date: Tue, 8 May 2018 12:48:45 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes/improvements all over the place.

Changes since v1:

Replaced "media: media-device: fix ioctl function types" with the v2 version
of that patch. My fault, I missed Sakari's request for a change of v1.

Regards,

	Hans

The following changes since commit f10379aad39e9da8bc7d1822e251b5f0673067ef:

  media: include/video/omapfb_dss.h: use IS_ENABLED() (2018-05-05 11:45:51 -0400)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.18b

for you to fetch changes up to 171d364998d1e2373c12b93924fe63cc71586101:

  media: media-device: fix ioctl function types (2018-05-08 12:40:23 +0200)

----------------------------------------------------------------
Arvind Yadav (2):
      platform: Use gpio_is_valid()
      sta2x11: Use gpio_is_valid() and remove unnecessary check

Brad Love (4):
      em28xx: Fix DualHD broken second tuner
      intel-ipu3: Kconfig coding style issue
      cec: Kconfig coding style issue
      saa7164: Fix driver name in debug output

Colin Ian King (1):
      media/usbvision: fix spelling mistake: "compresion" -> "compression"

Dan Carpenter (1):
      media: vpbe_venc: potential uninitialized variable in ven_sub_dev_init()

Fengguang Wu (1):
      media: vcodec: fix ptr_ret.cocci warnings

Hans Verkuil (2):
      cec-gpio: use GPIOD_OUT_HIGH_OPEN_DRAIN
      v4l2-dev.h: fix doc warning

Jacopo Mondi (1):
      media: renesas-ceu: Set mbus_fmt on subdev operations

Jan Luebbe (1):
      media: imx-csi: fix burst size for 16 bit

Jasmin Jessich (2):
      media: Use ktime_set() in pt1.c
      media: Revert cleanup ktime_set() usage

Julia Lawall (1):
      pvrusb2: delete unneeded include

Niklas Söderlund (1):
      media: entity: fix spelling for media_entity_get_fwnode_pad()

Philipp Zabel (4):
      media: coda: reuse coda_s_fmt_vid_cap to propagate format in coda_s_fmt_vid_out
      media: coda: do not try to propagate format if capture queue busy
      media: coda: set colorimetry on coded queue
      media: imx: add 16-bit grayscale support

Robin Murphy (1):
      media: videobuf-dma-sg: Fix dma_{sync,unmap}_sg() calls

Sami Tolvanen (1):
      media: media-device: fix ioctl function types

Simon Que (1):
      v4l2-core: Rename array 'video_driver' to 'video_drivers'

Souptick Joarder (1):
      videobuf: Change return type to vm_fault_t

Wolfram Sang (1):
      media: platform: am437x: simplify getting .drvdata

 drivers/media/Kconfig                           | 12 ++++++------
 drivers/media/dvb-core/dmxdev.c                 |  2 +-
 drivers/media/media-device.c                    | 21 +++++++++++----------
 drivers/media/pci/cx88/cx88-input.c             |  6 ++++--
 drivers/media/pci/intel/ipu3/Kconfig            | 12 ++++++------
 drivers/media/pci/pt1/pt1.c                     |  2 +-
 drivers/media/pci/pt3/pt3.c                     |  2 +-
 drivers/media/pci/saa7164/saa7164-fw.c          |  3 ++-
 drivers/media/pci/sta2x11/sta2x11_vip.c         | 31 +++++++++++++++----------------
 drivers/media/platform/am437x/am437x-vpfe.c     |  6 ++----
 drivers/media/platform/cec-gpio/cec-gpio.c      |  2 +-
 drivers/media/platform/coda/coda-common.c       | 45 +++++++++++++++++++++++++++++++--------------
 drivers/media/platform/davinci/vpbe_venc.c      |  2 +-
 drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c |  5 +----
 drivers/media/platform/renesas-ceu.c            | 20 +++++++++++++++-----
 drivers/media/platform/via-camera.c             |  2 +-
 drivers/media/usb/em28xx/em28xx-dvb.c           |  2 +-
 drivers/media/usb/pvrusb2/pvrusb2-cx2584x-v4l.c |  1 -
 drivers/media/usb/usbvision/usbvision-core.c    |  2 +-
 drivers/media/v4l2-core/v4l2-dev.c              | 22 +++++++++++-----------
 drivers/media/v4l2-core/videobuf-dma-sg.c       |  6 +++---
 drivers/staging/media/imx/imx-media-csi.c       |  3 ++-
 drivers/staging/media/imx/imx-media-utils.c     |  9 +++++++++
 include/media/media-entity.h                    |  2 +-
 include/media/v4l2-dev.h                        |  1 +
 25 files changed, 128 insertions(+), 93 deletions(-)
