Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:36928 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753983AbeBGOjo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Feb 2018 09:39:44 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/7] Add SPDX headers for Cisco-authored sources
Date: Wed,  7 Feb 2018 15:39:32 +0100
Message-Id: <20180207143939.29491-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This replaces all the old boilerplate license code with the new SPDX
tags for Cisco-authored files in the media subsystem.

Regards,

	Hans

Hans Verkuil (7):
  media: v4l2-compat-ioctl32.c: make ctrl_is_pointer work for subdevs
  include/(uapi/)media: add SPDX license info
  vivid: add SPDX license info
  cobalt: add SPDX license info
  cec: add SPDX license info
  i2c: add SPDX license info
  media: add SPDX license info

 drivers/media/cec/cec-adap.c                       | 14 +----------
 drivers/media/cec/cec-api.c                        | 14 +----------
 drivers/media/cec/cec-core.c                       | 14 +----------
 drivers/media/cec/cec-edid.c                       | 14 +----------
 drivers/media/cec/cec-notifier.c                   | 14 +----------
 drivers/media/cec/cec-pin-priv.h                   | 14 +----------
 drivers/media/cec/cec-pin.c                        | 14 +----------
 drivers/media/cec/cec-priv.h                       | 14 +----------
 drivers/media/common/v4l2-tpg/v4l2-tpg-colors.c    | 14 +----------
 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c      | 14 +----------
 drivers/media/i2c/ad9389b.c                        | 14 +----------
 drivers/media/i2c/adv7511.c                        | 14 +----------
 drivers/media/i2c/adv7604.c                        | 14 +----------
 drivers/media/i2c/adv7842.c                        | 15 +----------
 drivers/media/i2c/tc358743.c                       | 15 +----------
 drivers/media/i2c/tc358743_regs.h                  | 15 +----------
 drivers/media/pci/cobalt/Makefile                  |  1 +
 drivers/media/pci/cobalt/cobalt-alsa-main.c        | 14 +----------
 drivers/media/pci/cobalt/cobalt-alsa-pcm.c         | 14 +----------
 drivers/media/pci/cobalt/cobalt-alsa-pcm.h         | 14 +----------
 drivers/media/pci/cobalt/cobalt-alsa.h             | 14 +----------
 drivers/media/pci/cobalt/cobalt-cpld.c             | 14 +----------
 drivers/media/pci/cobalt/cobalt-cpld.h             | 14 +----------
 drivers/media/pci/cobalt/cobalt-driver.c           | 14 +----------
 drivers/media/pci/cobalt/cobalt-driver.h           | 14 +----------
 drivers/media/pci/cobalt/cobalt-flash.c            | 14 +----------
 drivers/media/pci/cobalt/cobalt-flash.h            | 14 +----------
 drivers/media/pci/cobalt/cobalt-i2c.c              | 14 +----------
 drivers/media/pci/cobalt/cobalt-i2c.h              | 14 +----------
 drivers/media/pci/cobalt/cobalt-irq.c              | 14 +----------
 drivers/media/pci/cobalt/cobalt-irq.h              | 14 +----------
 drivers/media/pci/cobalt/cobalt-omnitek.c          | 14 +----------
 drivers/media/pci/cobalt/cobalt-omnitek.h          | 14 +----------
 drivers/media/pci/cobalt/cobalt-v4l2.c             | 14 +----------
 drivers/media/pci/cobalt/cobalt-v4l2.h             | 14 +----------
 .../cobalt/m00233_video_measure_memmap_package.h   | 14 +----------
 .../pci/cobalt/m00235_fdma_packer_memmap_package.h | 14 +----------
 .../media/pci/cobalt/m00389_cvi_memmap_package.h   | 14 +----------
 .../media/pci/cobalt/m00460_evcnt_memmap_package.h | 14 +----------
 .../pci/cobalt/m00473_freewheel_memmap_package.h   | 14 +----------
 .../m00479_clk_loss_detector_memmap_package.h      | 14 +----------
 .../m00514_syncgen_flow_evcnt_memmap_package.h     | 14 +----------
 drivers/media/platform/cec-gpio/cec-gpio.c         | 14 +----------
 drivers/media/platform/vivid/vivid-cec.c           | 14 +----------
 drivers/media/platform/vivid/vivid-cec.h           | 14 +----------
 drivers/media/platform/vivid/vivid-core.c          | 14 +----------
 drivers/media/platform/vivid/vivid-core.h          | 14 +----------
 drivers/media/platform/vivid/vivid-ctrls.c         | 14 +----------
 drivers/media/platform/vivid/vivid-ctrls.h         | 14 +----------
 drivers/media/platform/vivid/vivid-kthread-cap.c   | 14 +----------
 drivers/media/platform/vivid/vivid-kthread-cap.h   | 14 +----------
 drivers/media/platform/vivid/vivid-kthread-out.c   | 14 +----------
 drivers/media/platform/vivid/vivid-kthread-out.h   | 14 +----------
 drivers/media/platform/vivid/vivid-osd.c           | 14 +----------
 drivers/media/platform/vivid/vivid-osd.h           | 14 +----------
 drivers/media/platform/vivid/vivid-radio-common.c  | 14 +----------
 drivers/media/platform/vivid/vivid-radio-common.h  | 14 +----------
 drivers/media/platform/vivid/vivid-radio-rx.c      | 14 +----------
 drivers/media/platform/vivid/vivid-radio-rx.h      | 14 +----------
 drivers/media/platform/vivid/vivid-radio-tx.c      | 14 +----------
 drivers/media/platform/vivid/vivid-radio-tx.h      | 14 +----------
 drivers/media/platform/vivid/vivid-rds-gen.c       | 14 +----------
 drivers/media/platform/vivid/vivid-rds-gen.h       | 14 +----------
 drivers/media/platform/vivid/vivid-sdr-cap.c       | 14 +----------
 drivers/media/platform/vivid/vivid-sdr-cap.h       | 14 +----------
 drivers/media/platform/vivid/vivid-vbi-cap.c       | 14 +----------
 drivers/media/platform/vivid/vivid-vbi-cap.h       | 14 +----------
 drivers/media/platform/vivid/vivid-vbi-gen.c       | 14 +----------
 drivers/media/platform/vivid/vivid-vbi-gen.h       | 14 +----------
 drivers/media/platform/vivid/vivid-vbi-out.c       | 14 +----------
 drivers/media/platform/vivid/vivid-vbi-out.h       | 14 +----------
 drivers/media/platform/vivid/vivid-vid-cap.c       | 14 +----------
 drivers/media/platform/vivid/vivid-vid-cap.h       | 14 +----------
 drivers/media/platform/vivid/vivid-vid-common.c    | 14 +----------
 drivers/media/platform/vivid/vivid-vid-common.h    | 14 +----------
 drivers/media/platform/vivid/vivid-vid-out.c       | 14 +----------
 drivers/media/platform/vivid/vivid-vid-out.h       | 14 +----------
 drivers/media/radio/radio-raremono.c               | 14 +----------
 drivers/media/radio/si4713/radio-usb-si4713.c      | 14 +----------
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c      |  2 +-
 drivers/media/v4l2-core/v4l2-dv-timings.c          | 15 +----------
 include/media/cec-notifier.h                       | 14 +----------
 include/media/cec-pin.h                            | 14 +----------
 include/media/cec.h                                | 14 +----------
 include/media/i2c/ad9389b.h                        | 14 +----------
 include/media/i2c/adv7511.h                        | 14 +----------
 include/media/i2c/adv7604.h                        | 15 +----------
 include/media/i2c/adv7842.h                        | 15 +----------
 include/media/i2c/tc358743.h                       | 18 ++------------
 include/media/i2c/ths7303.h                        | 10 +-------
 include/media/i2c/uda1342.h                        | 15 +----------
 include/media/tpg/v4l2-tpg.h                       | 14 +----------
 include/media/v4l2-dv-timings.h                    | 15 +----------
 include/media/v4l2-rect.h                          | 14 +----------
 include/uapi/linux/cec-funcs.h                     | 29 ----------------------
 include/uapi/linux/cec.h                           | 29 ----------------------
 96 files changed, 95 insertions(+), 1262 deletions(-)

-- 
2.15.1
