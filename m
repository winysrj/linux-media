Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:39654 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752294AbdJ0H1w (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Oct 2017 03:27:52 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.15] Various fixes
Message-ID: <245a055c-75fc-c0fc-d41e-d06db8d2e534@xs4all.nl>
Date: Fri, 27 Oct 2017 09:27:46 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Strange, this is actually an updated version for an earlier pull request that
I sent on October 17th but that never showed up in patchwork!

Odd, hopefully this will register there correctly.

Regards,

	Hans

The following changes since commit 61065fc3e32002ba48aa6bc3816c1f6f9f8daf55:

  Merge commit '3728e6a255b5' into patchwork (2017-10-17 17:22:20 -0700)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.15d

for you to fetch changes up to d2b87c4c5e74719f46582612b0ee426c61248d31:

  media: atmel-isc: Rework the format list (2017-10-27 09:23:51 +0200)

----------------------------------------------------------------
Arvind Yadav (1):
      coda: Handle return value of kasprintf

Bhumika Goyal (4):
      bt8xx: make bttv_vbi_qops const
      zoran: make zoran_template const
      cx23885/saa7134: make vb2_ops const
      au0828/em28xx: make vb2_ops const

Dan Carpenter (1):
      media: tc358743: remove an unneeded condition

Hans Verkuil (2):
      cec-pin.h: move non-kAPI parts into cec-pin-priv.h
      cec-pin: use IS_ERR instead of PTR_ERR_OR_ZERO

Jacob Chen (1):
      media: i2c: tc358743: fix spelling mistake

Markus Elfring (4):
      tm6000: Delete seven error messages for a failed memory allocation
      tm6000: Adjust seven checks for null pointers
      tm6000: Use common error handling code in tm6000_usb_probe()
      tm6000: One function call less in tm6000_usb_probe() after error detection

Philipp Zabel (1):
      tc358743: set entity function to video interface bridge

Ricardo Ribalda Delgado (1):
      media: v4l2-ctrl: Fix flags field on Control events

Stanimir Varbanov (3):
      media: venus: fix wrong size on dma_free
      media: venus: venc: fix bytesused v4l2_plane field
      venus: reimplement decoder stop command

Tim Harvey (1):
      media: imx: Fix VDIC CSI1 selection

Wei Yongjun (1):
      vimc: Fix return value check in vimc_add_subdevs()

Wenyou Yang (5):
      media: atmel-isc: Add spin lock for clock enable ops
      media: atmel-isc: Add prepare and unprepare ops
      media: atmel-isc: Enable the clocks during probe
      media: atmel-isc: Remove unnecessary member
      media: atmel-isc: Rework the format list

 drivers/media/cec/cec-api.c                   |   1 +
 drivers/media/cec/cec-pin-priv.h              | 133 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/media/cec/cec-pin.c                   |   3 +-
 drivers/media/i2c/tc358743.c                  |   5 +-
 drivers/media/pci/bt8xx/bttv-vbi.c            |   2 +-
 drivers/media/pci/bt8xx/bttvp.h               |   2 +-
 drivers/media/pci/cx23885/cx23885-vbi.c       |   2 +-
 drivers/media/pci/cx23885/cx23885.h           |   2 +-
 drivers/media/pci/saa7134/saa7134-vbi.c       |   2 +-
 drivers/media/pci/saa7134/saa7134.h           |   2 +-
 drivers/media/pci/zoran/zoran_card.h          |   2 +-
 drivers/media/pci/zoran/zoran_driver.c        |   2 +-
 drivers/media/platform/atmel/atmel-isc-regs.h |   1 +
 drivers/media/platform/atmel/atmel-isc.c      | 629
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----------------------------------------------
 drivers/media/platform/coda/coda-bit.c        |   4 ++
 drivers/media/platform/qcom/venus/core.h      |   2 -
 drivers/media/platform/qcom/venus/helpers.c   |   7 ---
 drivers/media/platform/qcom/venus/hfi.c       |   1 +
 drivers/media/platform/qcom/venus/hfi_venus.c |  12 ++---
 drivers/media/platform/qcom/venus/vdec.c      |  34 ++++++++----
 drivers/media/platform/qcom/venus/venc.c      |   7 ++-
 drivers/media/platform/vimc/vimc-core.c       |   5 +-
 drivers/media/usb/au0828/au0828-vbi.c         |   2 +-
 drivers/media/usb/au0828/au0828.h             |   2 +-
 drivers/media/usb/em28xx/em28xx-v4l.h         |   2 +-
 drivers/media/usb/em28xx/em28xx-vbi.c         |   2 +-
 drivers/media/usb/tm6000/tm6000-cards.c       |  27 +++++-----
 drivers/media/usb/tm6000/tm6000-dvb.c         |  11 ++--
 drivers/media/usb/tm6000/tm6000-input.c       |   2 +-
 drivers/media/usb/tm6000/tm6000-video.c       |  17 ++----
 drivers/media/v4l2-core/v4l2-ctrls.c          |  16 ++++--
 drivers/staging/media/imx/imx-ic-prp.c        |   5 +-
 include/media/cec-pin.h                       | 107 -------------------------------------
 33 files changed, 725 insertions(+), 328 deletions(-)
 create mode 100644 drivers/media/cec/cec-pin-priv.h
