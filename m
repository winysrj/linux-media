Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:55306 "EHLO
        lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751702AbdBMOFK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Feb 2017 09:05:10 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.12] Various fixes/enhancements
Message-ID: <af600d14-a2fe-fcf0-7f54-afb924a86df5@xs4all.nl>
Date: Mon, 13 Feb 2017 15:05:05 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Various fixes and enhancements.

Regards,

	Hans

The following changes since commit 9eeb0ed0f30938f31a3d9135a88b9502192c18dd:

  [media] mtk-vcodec: fix build warnings without DEBUG (2017-02-08 12:08:20 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.12a

for you to fetch changes up to ec82f86f87ca556d60086123ae09cf6539209bf1:

  vidioc-g-dv-timings.rst: update v4l2_bt_timings struct (2017-02-13 14:51:28 +0100)

----------------------------------------------------------------
Arnd Bergmann (5):
      pvrusb2: reduce stack usage pvr2_eeprom_analyze()
      cx231xx-i2c: reduce stack size in bus scan
      mxl111sf: reduce stack usage in init function
      tc358743: fix register i2c_rd/wr functions
      coda/imx-vdoa: platform_driver should not be const

Hans Verkuil (2):
      cec.h: small typo fix
      vidioc-g-dv-timings.rst: update v4l2_bt_timings struct

Shailendra Verma (1):
      bdisp: Clean up file handle in open() error path.

Shilpa P (1):
      staging: Replaced BUG_ON with warnings

Songjun Wu (1):
      atmel-isc: add the isc pipeline function

Vincent ABRIOU (1):
      vivid: support for contiguous DMA buffers

 Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst |  16 +-
 Documentation/media/v4l-drivers/vivid.rst            |   8 +
 drivers/media/i2c/tc358743.c                         |  46 ++--
 drivers/media/platform/atmel/atmel-isc-regs.h        | 102 +++++++-
 drivers/media/platform/atmel/atmel-isc.c             | 627 +++++++++++++++++++++++++++++++++++++++--------
 drivers/media/platform/coda/imx-vdoa.c               |   2 +-
 drivers/media/platform/sti/bdisp/bdisp-v4l2.c        |   2 +-
 drivers/media/platform/vivid/Kconfig                 |   2 +
 drivers/media/platform/vivid/vivid-core.c            |  32 ++-
 drivers/media/usb/cx231xx/cx231xx-i2c.c              |  16 +-
 drivers/media/usb/dvb-usb-v2/mxl111sf.c              |  14 +-
 drivers/media/usb/pvrusb2/pvrusb2-eeprom.c           |  13 +-
 drivers/staging/media/bcm2048/radio-bcm2048.c        |  12 +-
 include/uapi/linux/cec.h                             |   2 +-
 14 files changed, 731 insertions(+), 163 deletions(-)
