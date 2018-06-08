Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:35406 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751056AbeFHKwz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Jun 2018 06:52:55 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.19] Various fixes
Message-ID: <6aee5f17-5d23-0c06-59ee-fef145867701@xs4all.nl>
Date: Fri, 8 Jun 2018 12:52:50 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit f2809d20b9250c675fca8268a0f6274277cca7ff:

  media: omap2: fix compile-testing with FB_OMAP2=m (2018-06-05 09:56:56 -0400)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.19a

for you to fetch changes up to 5286c2c46ef67346079b86a700d90faec0756d33:

  media: rcar-vin: Drop unnecessary register properties from example vin port (2018-06-08 11:34:27 +0200)

----------------------------------------------------------------
Alexey Khoroshilov (1):
      media: tc358743: release device_node in tc358743_probe_of()

Arnd Bergmann (4):
      media: v4l: cadence: include linux/slab.h
      media: cx231xx: fix RC_CORE dependency
      media: v4l: cadence: add VIDEO_V4L2 dependency
      media: v4l: omap: add VIDEO_V4L2 dependency

Colin Ian King (1):
      media: mtk-vpu: fix spelling mistake: "Prosessor" -> "Processor"

Dmitry Osipenko (1):
      media: dt: bindings: tegra-vde: Document new optional Memory Client reset property

Gabriel Fanelli (1):
      staging: media: bcm2048: match alignment with open parenthesis

Geert Uytterhoeven (1):
      v4l: rcar_fdp1: Change platform dependency to ARCH_RENESAS

Jacopo Mondi (1):
      media: renesas-ceu: Add support for YUYV permutations

Janani Sankara Babu (1):
      Staging:media:imx Fix multiple assignments in a line

Nicholas Mc Guire (3):
      media: adv7604: simplify of_node_put()
      media: atmel-isi: drop unnecessary while loop
      media: atmel-isi: move of_node_put() to cover success branch as well

Pavel Machek (1):
      media: i2c: lm3560: add support for lm3559 chip

Simon Horman (1):
      media: rcar-vin: Drop unnecessary register properties from example vin port

 Documentation/devicetree/bindings/media/nvidia,tegra-vde.txt | 11 ++++-
 Documentation/devicetree/bindings/media/rcar_vin.txt         |  3 --
 drivers/media/i2c/adv7604.c                                  |  7 +---
 drivers/media/i2c/lm3560.c                                   |  3 +-
 drivers/media/i2c/tc358743.c                                 |  5 ++-
 drivers/media/platform/Kconfig                               |  2 +-
 drivers/media/platform/atmel/atmel-isi.c                     | 27 ++++++------
 drivers/media/platform/cadence/Kconfig                       |  2 +
 drivers/media/platform/cadence/cdns-csi2rx.c                 |  1 +
 drivers/media/platform/cadence/cdns-csi2tx.c                 |  1 +
 drivers/media/platform/mtk-vpu/mtk_vpu.c                     |  2 +-
 drivers/media/platform/omap/Kconfig                          |  1 +
 drivers/media/platform/renesas-ceu.c                         | 91 ++++++++++++++++++++++++++++++++++------
 drivers/media/usb/cx231xx/Kconfig                            |  2 +-
 drivers/staging/media/bcm2048/radio-bcm2048.c                |  2 +-
 drivers/staging/media/imx/imx-media-csi.c                    |  6 ++-
 include/media/i2c/lm3560.h                                   |  1 +
 17 files changed, 121 insertions(+), 46 deletions(-)
