Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:50245 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753533AbeGDJuN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 4 Jul 2018 05:50:13 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.19] Various fixes
Message-ID: <2a1acbfa-019c-41f3-7f5e-bdd2fcf424e7@xs4all.nl>
Date: Wed, 4 Jul 2018 11:50:11 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

About half of this pull request is Jacopo's R-Car R8A77995 series, the
other half are miscellaneous patches.

Regards,

	Hans

The following changes since commit 3c4a737267e89aafa6308c6c456d2ebea3fcd085:

  media: ov5640: fix frame interval enumeration (2018-06-28 09:24:38 -0400)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.19h

for you to fetch changes up to f7080d547e040e061a6dd7aebcde74c14f844392:

  tuner-simple: allow setting mono radio mode (2018-07-04 11:35:49 +0200)

----------------------------------------------------------------
Jacopo Mondi (11):
      media: rcar-vin: Rename 'digital' to 'parallel'
      media: rcar-vin: Remove two empty lines
      media: rcar-vin: Create a group notifier
      media: rcar-vin: Cleanup notifier in error path
      media: rcar-vin: Cache the mbus configuration flags
      media: rcar-vin: Parse parallel input on Gen3
      media: rcar-vin: Link parallel input media entities
      media: rcar-vin: Handle parallel subdev in link_notify
      media: rcar-vin: Rename _rcar_info to rcar_info
      media: rcar-vin: Add support for R-Car R8A77995 SoC
      dt-bindings: media: rcar-vin: Add R8A77995 support

Jan Luebbe (2):
      media: imx: capture: refactor enum_/try_fmt
      media: imx: add support for RGB565_2X8 on parallel bus

Keiichi Watanabe (3):
      media: v4l2-ctrl: Change control for VP8 profile to menu control
      media: v4l2-ctrl: Add control for VP9 profile
      media: mtk-vcodec: Support VP9 profile in decoder

Maciej S. Szmigiero (3):
      ivtv: zero-initialize cx25840 platform data
      cx25840: add kernel-doc description of struct cx25840_state
      tuner-simple: allow setting mono radio mode

Peter Seiderer (2):
      media: staging/imx: fill vb2_v4l2_buffer field entry
      media: staging/imx: fill vb2_v4l2_buffer sequence entry

 Documentation/devicetree/bindings/media/rcar_vin.txt |   1 +
 Documentation/media/uapi/v4l/extended-controls.rst   |  48 ++++++++-
 drivers/media/i2c/cx25840/cx25840-core.h             |  33 ++++++-
 drivers/media/pci/ivtv/ivtv-i2c.c                    |   1 +
 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c   |   5 +
 drivers/media/platform/qcom/venus/vdec_ctrls.c       |  10 +-
 drivers/media/platform/qcom/venus/venc.c             |   4 +-
 drivers/media/platform/qcom/venus/venc_ctrls.c       |  10 +-
 drivers/media/platform/rcar-vin/rcar-core.c          | 265 +++++++++++++++++++++++++++++++++-----------------
 drivers/media/platform/rcar-vin/rcar-dma.c           |  36 ++++---
 drivers/media/platform/rcar-vin/rcar-v4l2.c          |  12 +--
 drivers/media/platform/rcar-vin/rcar-vin.h           |  29 ++++--
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c         |  15 ++-
 drivers/media/tuners/tuner-simple.c                  |   5 +-
 drivers/media/v4l2-core/v4l2-ctrls.c                 |  23 ++++-
 drivers/staging/media/imx/imx-ic-prpencvf.c          |   5 +
 drivers/staging/media/imx/imx-media-capture.c        |  38 ++++----
 drivers/staging/media/imx/imx-media-csi.c            | 106 +++++++++++++-------
 drivers/staging/media/imx/imx-media-utils.c          |   1 +
 drivers/staging/media/imx/imx-media.h                |   2 +
 include/uapi/linux/v4l2-controls.h                   |  18 +++-
 21 files changed, 468 insertions(+), 199 deletions(-)
