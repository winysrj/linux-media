Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:36368 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729035AbeJAQd0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 1 Oct 2018 12:33:26 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.20] Various fixes
Message-ID: <616ee393-6487-5830-08ee-2d916912be37@xs4all.nl>
Date: Mon, 1 Oct 2018 11:56:22 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 4158757395b300b6eb308fc20b96d1d231484413:

  media: davinci: Fix implicit enum conversion warning (2018-09-24 09:43:13 -0400)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git tags/tag-v4.20d

for you to fetch changes up to f7a1170fcc19617647c78262a79abdec7b0a08cd:

  media: i2c: adv748x: fix typo in comment for TXB CSI-2 transmitter power down (2018-10-01 11:09:09 +0200)

----------------------------------------------------------------
Tag branch

----------------------------------------------------------------
Arnd Bergmann (1):
      media: imx-pxp: include linux/interrupt.h

Benjamin Gaignard (1):
      MAINTAINERS: fix reference to STI CEC driver

Colin Ian King (1):
      media: zoran: fix spelling mistake "queing" -> "queuing"

Dan Carpenter (1):
      VPU: mediatek: don't pass an unused parameter

Hans Verkuil (1):
      vidioc-dqevent.rst: clarify V4L2_EVENT_SRC_CH_RESOLUTION

Hugues Fruchet (1):
      media: stm32-dcmi: only enable IT frame on JPEG capture

Jacopo Mondi (4):
      media: i2c: adv748x: Support probing a single output
      media: i2c: adv748x: Handle TX[A|B] power management
      media: i2c: adv748x: Conditionally enable only CSI-2 outputs
      media: i2c: adv748x: Register only enabled inputs

Laurent Pinchart (1):
      MAINTAINERS: Remove stale file entry for the Atmel ISI driver

Nathan Chancellor (1):
      media: pxa_camera: Fix check for pdev->dev.of_node

Niklas Söderlund (2):
      rcar-vin: fix redeclaration of symbol
      media: i2c: adv748x: fix typo in comment for TXB CSI-2 transmitter power down

Philipp Zabel (1):
      media: imx: use well defined 32-bit RGB pixel format

zhong jiang (1):
      media: qcom: remove duplicated include file

 Documentation/media/uapi/v4l/vidioc-dqevent.rst | 12 +++++++-
 MAINTAINERS                                     |  3 +-
 drivers/media/i2c/adv748x/adv748x-afe.c         |  2 +-
 drivers/media/i2c/adv748x/adv748x-core.c        | 85 +++++++++++++++++++++++++++--------------------------
 drivers/media/i2c/adv748x/adv748x-csi2.c        | 29 ++++++------------
 drivers/media/i2c/adv748x/adv748x-hdmi.c        |  2 +-
 drivers/media/i2c/adv748x/adv748x.h             | 19 ++++++++----
 drivers/media/platform/imx-pxp.c                |  1 +
 drivers/media/platform/mtk-vpu/mtk_vpu.c        |  7 ++---
 drivers/media/platform/pxa_camera.c             |  2 +-
 drivers/media/platform/qcom/camss/camss.h       |  1 -
 drivers/media/platform/rcar-vin/rcar-core.c     |  1 -
 drivers/media/platform/stm32/stm32-dcmi.c       |  5 +++-
 drivers/staging/media/imx/imx-media-utils.c     |  4 +--
 drivers/staging/media/zoran/zoran_driver.c      |  2 +-
 15 files changed, 93 insertions(+), 82 deletions(-)
