Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:58420 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729430AbeG0Jab (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Jul 2018 05:30:31 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.19] Various fixes
Message-ID: <767f1dd9-2bc5-d606-a20e-2b36f94800c8@xs4all.nl>
Date: Fri, 27 Jul 2018 10:09:45 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Various fixes for 4.19.

Regards,

	Hans

The following changes since commit 343b23a7c6b6680ef949e6112a4ee60688acf39d:

  media: gpu: ipu-v3: Allow negative offsets for interlaced scanning (2018-07-26 15:21:50 -0400)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.19n

for you to fetch changes up to e0d084eedd4f531bc32b2b61c92963126dbf642d:

  media: pci: ivtv: Replace GFP_ATOMIC with GFP_KERNEL (2018-07-27 09:57:28 +0200)

----------------------------------------------------------------
Ezequiel Garcia (1):
      rockchip/rga: Fix bad dma_free_attrs() parameter

Hans Verkuil (1):
      media.h: remove linux/version.h include

Jia-Ju Bai (10):
      media: i2c: adv7842: Replace mdelay() with msleep() and usleep_range() in adv7842_ddr_ram_test()
      media: i2c: vs6624: Replace mdelay() with msleep() and usleep_range() in vs6624_probe()
      media: pci: cobalt: Replace GFP_ATOMIC with GFP_KERNEL in cobalt_probe()
      media: pci: cx23885: Replace mdelay() with msleep() and usleep_range() in altera_ci_slot_reset()
      media: pci: cx23885: Replace mdelay() with msleep() and usleep_range() in cx23885_gpio_setup()
      media: pci: cx23885: Replace mdelay() with msleep() in cx23885_reset()
      media: pci: cx25821: Replace mdelay() with msleep()
      media: pci: cx88: Replace mdelay() with msleep() in cx88_card_setup_pre_i2c()
      media: pci: cx88: Replace mdelay() with msleep() in dvb_register()
      media: pci: ivtv: Replace GFP_ATOMIC with GFP_KERNEL

Matt Ranostay (1):
      media: video-i2c: hwmon: fix return value from amg88xx_hwmon_init()

Nicolas Dufresne (1):
      vivid: Fix V4L2_FIELD_ALTERNATE new frame check

Niklas Söderlund (3):
      adv7180: fix field type to V4L2_FIELD_ALTERNATE
      adv7180: add g_frame_interval support
      rcar-csi2: update stream start for V3M

Philipp Zabel (2):
      media: coda: let CODA960 firmware set frame cropping in SPS header
      media: coda: add SPS fixup code for frame sizes that are not multiples of 16

 drivers/media/i2c/adv7180.c                      |  30 +++++-
 drivers/media/i2c/adv7842.c                      |   8 +-
 drivers/media/i2c/video-i2c.c                    |   2 +-
 drivers/media/i2c/vs6624.c                       |   4 +-
 drivers/media/media-device.c                     |   1 +
 drivers/media/pci/cobalt/cobalt-driver.c         |   2 +-
 drivers/media/pci/cx23885/altera-ci.c            |   2 +-
 drivers/media/pci/cx23885/cx23885-cards.c        |  82 +++++++-------
 drivers/media/pci/cx23885/cx23885-core.c         |   2 +-
 drivers/media/pci/cx25821/cx25821-core.c         |   4 +-
 drivers/media/pci/cx25821/cx25821-gpio.c         |   2 +-
 drivers/media/pci/cx88/cx88-cards.c              |   4 +-
 drivers/media/pci/cx88/cx88-dvb.c                |  20 ++--
 drivers/media/pci/ivtv/ivtv-driver.c             |   2 +-
 drivers/media/pci/ivtv/ivtvfb.c                  |   2 +-
 drivers/media/platform/coda/coda-bit.c           |  40 +++++++
 drivers/media/platform/coda/coda-h264.c          | 316 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/media/platform/coda/coda.h               |   2 +
 drivers/media/platform/rcar-vin/rcar-csi2.c      |  20 ++--
 drivers/media/platform/rockchip/rga/rga.c        |   2 +-
 drivers/media/platform/vivid/vivid-kthread-cap.c |   2 +-
 include/uapi/linux/media.h                       |   3 +-
 22 files changed, 469 insertions(+), 83 deletions(-)
