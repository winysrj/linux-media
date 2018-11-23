Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:45546 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731828AbeKWTFs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Nov 2018 14:05:48 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.21 v2] Various fixes (coda, rcar, pxp, others)
Message-ID: <b6636d40-6ee1-f85d-0463-605555243f04@xs4all.nl>
Date: Fri, 23 Nov 2018 09:22:33 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixed my SoB mess.

Regards,

	Hans

The following changes since commit fbe57dde7126d1b2712ab5ea93fb9d15f89de708:

  media: ov7740: constify structures stored in fields of v4l2_subdev_ops structure (2018-11-06 07:17:02 -0500)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git tags/br-v4.21c

for you to fetch changes up to fb248101254782a3939c40eaaa7e347260b27b77:

  pulse8-cec: return 0 when invalidating the logical address (2018-11-14 16:07:47 +0100)

----------------------------------------------------------------
Tag branch

----------------------------------------------------------------
Fabio Estevam (3):
      media: imx-pxp: Check the return value from clk_prepare_enable()
      media: imx-pxp: Check for pxp_soft_reset() error
      media: imx-pxp: Improve pxp_soft_reset() error message

Hans Verkuil (3):
      vb2: vb2_mmap: move lock up
      cec-pin: fix broken tx_ignore_nack_until_eom error injection
      pulse8-cec: return 0 when invalidating the logical address

Jacopo Mondi (6):
      media: dt-bindings: rcar-vin: Add R8A77990 support
      media: rcar-vin: Add support for R-Car R8A77990
      media: dt-bindings: rcar-csi2: Add R8A77990
      media: rcar-csi2: Add R8A77990 support
      media: rcar: rcar-csi2: Update V3M/E3 PHTW tables
      media: rcar-csi2: Handle per-SoC number of channels

Lucas Stach (2):
      media: coda: limit queueing into internal bitstream buffer
      media: coda: don't disable IRQs across buffer meta handling

Michael Tretter (1):
      media: coda: print SEQ_INIT error code as hex value

Philipp Zabel (12):
      media: coda: fix memory corruption in case more than 32 instances are opened
      media: coda: store unmasked fifo position in meta
      media: coda: always hold back decoder jobs until we have enough bitstream payload
      media: coda: reduce minimum frame size to 48x16 pixels.
      media: coda: remove unused instances list
      media: coda: set V4L2_CAP_TIMEPERFRAME flag in coda_s_parm
      media: coda: implement ENUM_FRAMEINTERVALS
      media: coda: never set infinite timeperframe
      media: coda: fail S_SELECTION for read-only targets
      media: coda: improve queue busy error message
      media: coda: normalise debug output
      media: coda: debug output when setting visible size via crop selection

Ricardo Ribalda Delgado (1):
      media: doc-rst: Fix broken references

kbuild test robot (1):
      media: platform: fix platform_no_drv_owner.cocci warnings

 Documentation/devicetree/bindings/media/rcar_vin.txt          |   1 +
 Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt |   1 +
 Documentation/media/v4l-drivers/sh_mobile_ceu_camera.rst      |   2 +-
 drivers/media/cec/cec-pin.c                                   |   5 +-
 drivers/media/common/videobuf2/videobuf2-core.c               |  11 +-
 drivers/media/platform/coda/coda-bit.c                        | 113 +++++++++++---------
 drivers/media/platform/coda/coda-common.c                     | 231 ++++++++++++++++++++++-------------------
 drivers/media/platform/coda/coda.h                            |  28 ++++-
 drivers/media/platform/coda/trace.h                           |  10 +-
 drivers/media/platform/imx-pxp.c                              |  17 ++-
 drivers/media/platform/rcar-vin/rcar-core.c                   |  20 ++++
 drivers/media/platform/rcar-vin/rcar-csi2.c                   |  86 +++++++++------
 drivers/media/platform/sh_vou.c                               |   2 +-
 drivers/media/usb/pulse8-cec/pulse8-cec.c                     |   2 +-
 drivers/staging/media/sunxi/cedrus/cedrus.c                   |   1 -
 15 files changed, 319 insertions(+), 211 deletions(-)
