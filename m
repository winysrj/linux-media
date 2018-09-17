Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:56813 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726910AbeIQQcm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Sep 2018 12:32:42 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.20] Various fixes
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Message-ID: <2e5ffc4f-adb3-4fad-298c-42361b8d0d0e@xs4all.nl>
Date: Mon, 17 Sep 2018 13:05:46 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Nothing special, just lots of fixes.

Note that my four cec patches have a CC for stable for 4.17 and up (they no
longer apply for 4.16 and older). I decided not to add them for 4.19 since
these patches are a bit bigger than I'd like and it's been broken since 4.12
without anyone noticing. So a few extra weeks before they are backported to
4.19 shouldn't matter.

Once they are merged I might make another patch set for the 4.14 longterm kernel,
the only longterm kernel that is affected by this.

Regards,

	Hans

The following changes since commit 78cf8c842c111df656c63b5d04997ea4e40ef26a:

  media: drxj: fix spelling mistake in fall-through annotations (2018-09-12 11:21:52 -0400)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git tags/v4.20c

for you to fetch changes up to dbfb412d7e38fdcc6ada339b2431b9d5db1df667:

  media: davinci: Fix implicit enum conversion warning (2018-09-17 12:46:13 +0200)

----------------------------------------------------------------
Tag v4.20c

----------------------------------------------------------------
Alexandre GRIVEAUX (1):
      saa7134: add P7131_4871 analog inputs

Arnd Bergmann (1):
      media: imx: work around false-positive warning, again

Brad Love (2):
      au0828: cannot kfree dev before usb disconnect
      au0828: Fix incorrect error messages

Ezequiel Garcia (2):
      vicodec: Drop unneeded symbol dependency
      vicodec: Drop unused job_abort()

Gustavo A. R. Silva (1):
      venus: helpers: use true and false for boolean values

Hans Verkuil (8):
      cec: make cec_get_edid_spa_location() an inline function
      cec: integrate cec_validate_phys_addr() in cec-api.c
      cec/v4l2: move V4L2 specific CEC functions to V4L2
      cec: remove cec-edid.c
      vicodec: check for valid format in v4l2_fwht_en/decode
      vicodec: set state->info before calling the encode/decode funcs
      media: replace ADOBERGB by OPRGB
      media colorspaces*.rst: rename AdobeRGB to opRGB

Jia-Ju Bai (1):
      media: pci: ivtv: Fix a sleep-in-atomic-context bug in ivtv_yuv_init()

Johan Fjeldtvedt (1):
      vb2: check for sane values from queue_setup

Lucas Stach (1):
      media: coda: don't overwrite h.264 profile_idc on decoder instance

Nathan Chancellor (2):
      bt8xx: Remove unnecessary self-assignment
      media: davinci: Fix implicit enum conversion warning

Nicholas Mc Guire (1):
      media: pci: cx23885: handle adding to list failure

Niklas Söderlund (1):
      v4l2-common: fix typo in documentation for v4l_bound_align_image()

Philipp Zabel (1):
      media: imx-pxp: fix compilation on i386 or x86_64

zhong jiang (2):
      media: coda: remove redundant null pointer check before of_node_put
      media: platform: remove redundant null pointer check before of_node_put

 Documentation/media/uapi/v4l/biblio.rst              |  10 --
 Documentation/media/uapi/v4l/colorspaces-defs.rst    |   8 +-
 Documentation/media/uapi/v4l/colorspaces-details.rst |  13 ++-
 Documentation/media/videodev2.h.rst.exceptions       |   6 +-
 drivers/media/cec/Makefile                           |   2 +-
 drivers/media/cec/cec-adap.c                         |  13 +++
 drivers/media/cec/cec-api.c                          |  19 +++-
 drivers/media/cec/cec-edid.c                         | 155 ----------------------------
 drivers/media/common/v4l2-tpg/v4l2-tpg-colors.c      | 262 +++++++++++++++++++++++------------------------
 drivers/media/common/videobuf2/videobuf2-core.c      |   9 ++
 drivers/media/i2c/adv7511.c                          |   2 +-
 drivers/media/i2c/adv7604.c                          |   6 +-
 drivers/media/i2c/adv7842.c                          |   4 +-
 drivers/media/i2c/tc358743.c                         |   6 +-
 drivers/media/pci/bt8xx/bttv-driver.c                |   1 -
 drivers/media/pci/cx23885/altera-ci.c                |  10 ++
 drivers/media/pci/ivtv/ivtv-yuv.c                    |   2 +-
 drivers/media/pci/saa7134/saa7134-cards.c            |  15 +++
 drivers/media/platform/coda/coda-common.c            |   6 +-
 drivers/media/platform/davinci/vpbe_display.c        |   2 +-
 drivers/media/platform/imx-pxp.c                     |   1 +
 drivers/media/platform/qcom/venus/helpers.c          |   2 +-
 drivers/media/platform/ti-vpe/cal.c                  |  12 +--
 drivers/media/platform/vicodec/Kconfig               |   2 +-
 drivers/media/platform/vicodec/codec-v4l2-fwht.c     |  15 ++-
 drivers/media/platform/vicodec/codec-v4l2-fwht.h     |   7 +-
 drivers/media/platform/vicodec/vicodec-core.c        |  23 ++---
 drivers/media/platform/vivid/vivid-core.h            |   2 +-
 drivers/media/platform/vivid/vivid-ctrls.c           |   6 +-
 drivers/media/platform/vivid/vivid-vid-cap.c         |   4 +-
 drivers/media/platform/vivid/vivid-vid-common.c      |   2 +-
 drivers/media/platform/vivid/vivid-vid-out.c         |   2 +-
 drivers/media/usb/au0828/au0828-core.c               |   5 +-
 drivers/media/v4l2-core/v4l2-dv-timings.c            | 159 +++++++++++++++++++++++++++-
 drivers/staging/media/imx/imx-media-csi.c            |   5 +-
 include/media/cec.h                                  | 150 +++++++++++++--------------
 include/media/v4l2-common.h                          |   2 +-
 include/media/v4l2-dv-timings.h                      |   6 ++
 include/uapi/linux/videodev2.h                       |  23 +++--
 39 files changed, 517 insertions(+), 462 deletions(-)
 delete mode 100644 drivers/media/cec/cec-edid.c
