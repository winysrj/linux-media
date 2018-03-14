Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:41255 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932842AbeCNDoX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Mar 2018 23:44:23 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.17] Various fixes
Message-ID: <a979247e-0c29-f32b-4ae4-5dbfff5baac2@xs4all.nl>
Date: Tue, 13 Mar 2018 20:44:17 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 3f127ce11353fd1071cae9b65bc13add6aec6b90:

  media: em28xx-cards: fix em28xx_duplicate_dev() (2018-03-08 06:06:51 -0500)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.17e

for you to fetch changes up to f39b55d1fdcbb9252a60f5923b1e11ded0cd584c:

  rcar-vin: use scratch buffer and always run in continuous mode (2018-03-14 04:39:15 +0100)

----------------------------------------------------------------
Arnd Bergmann (2):
      media: v4l: omap_vout: vrfb: remove an unused variable
      media: ngene: avoid unused variable warning

Daniel Scheller (1):
      ttpci: improve printing of encoded MAC address

Geert Uytterhoeven (1):
      dt-bindings: media: rcar_vin: Use status "okay"

Guennadi Liakhovetski (1):
      V4L: remove myself as soc-camera maintainer

Hans Verkuil (2):
      imx.rst: fix typo
      pixfmt-v4l2.rst: fix broken enum :c:type:

Niklas Söderlund (2):
      rcar-vin: allocate a scratch buffer at stream start
      rcar-vin: use scratch buffer and always run in continuous mode

 Documentation/devicetree/bindings/media/rcar_vin.txt |   4 ++--
 Documentation/media/uapi/v4l/pixfmt-v4l2.rst         |   2 +-
 Documentation/media/v4l-drivers/imx.rst              |   2 +-
 MAINTAINERS                                          |   3 +--
 drivers/media/pci/ngene/ngene-core.c                 |   2 +-
 drivers/media/pci/ttpci/ttpci-eeprom.c               |   9 +++------
 drivers/media/platform/omap/omap_vout_vrfb.c         |   1 -
 drivers/media/platform/rcar-vin/rcar-dma.c           | 206
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----------------------------------------------------------------------------------------------------------------------------------------
 drivers/media/platform/rcar-vin/rcar-vin.h           |  10 +++++-----
 9 files changed, 84 insertions(+), 155 deletions(-)
