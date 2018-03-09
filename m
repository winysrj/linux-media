Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:53473 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751120AbeCIQGJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Mar 2018 11:06:09 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.17] Various fixes
Message-ID: <356124df-8300-0a24-dac7-f1d62a4ba7a2@xs4all.nl>
Date: Fri, 9 Mar 2018 17:06:07 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 3f127ce11353fd1071cae9b65bc13add6aec6b90:

  media: em28xx-cards: fix em28xx_duplicate_dev() (2018-03-08 06:06:51 -0500)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.17c

for you to fetch changes up to 579f4f639b7507ab1bff5ecde52ad4ef3cd565ec:

  cpia2_usb: drop bogus interface-release call (2018-03-09 16:56:47 +0100)

----------------------------------------------------------------
Douglas Fischer (3):
      media: radio: Tuning bugfix for si470x over i2c
      media: radio: Critical v4l2 registration bugfix for si470x over i2c
      media: radio: Critical interrupt bugfix for si470x over i2c

Hans Verkuil (1):
      media: add tuner standby op, use where needed

Hugues Fruchet (4):
      media: stm32-dcmi: fix lock scheme
      media: stm32-dcmi: rework overrun/error case
      media: stm32-dcmi: fix unnecessary parentheses
      media: stm32-dcmi: add JPEG support

Jean-Michel Hautbois (2):
      dt-bindings: media: adv7604: Extend bindings to allow specifying slave map addresses
      media: adv7604: Add support for i2c_new_secondary_device

Johan Hovold (1):
      cpia2_usb: drop bogus interface-release call

Kieran Bingham (3):
      media: i2c: adv748x: Simplify regmap configuration
      media: i2c: adv748x: Add missing CBUS page
      media: i2c: adv748x: Add support for i2c_new_secondary_device

Luca Ceresoli (3):
      media: vb2-core: vb2_buffer_done: consolidate docs
      media: vb2-core: document the REQUEUEING state
      media: vb2-core: vb2_ops: document non-interrupt-context calling

Philipp Zabel (1):
      media: imx: add 8-bit grayscale support

 Documentation/devicetree/bindings/media/i2c/adv7604.txt |  18 +++-
 drivers/media/i2c/adv748x/adv748x-core.c                | 185 +++++++++++++---------------------------
 drivers/media/i2c/adv748x/adv748x.h                     |  14 +--
 drivers/media/i2c/adv7604.c                             |  62 +++++++++-----
 drivers/media/pci/cx23885/cx23885-core.c                |   2 +-
 drivers/media/pci/cx23885/cx23885-dvb.c                 |   4 +-
 drivers/media/pci/cx88/cx88-cards.c                     |   2 +-
 drivers/media/pci/cx88/cx88-dvb.c                       |   4 +-
 drivers/media/pci/saa7134/saa7134-video.c               |   2 +-
 drivers/media/platform/stm32/stm32-dcmi.c               | 267 ++++++++++++++++++++++++++++++++++++++--------------------
 drivers/media/radio/si470x/radio-si470x-common.c        |  17 +++-
 drivers/media/radio/si470x/radio-si470x-i2c.c           |  32 ++++++-
 drivers/media/radio/si470x/radio-si470x.h               |   2 +
 drivers/media/tuners/e4000.c                            |  16 +---
 drivers/media/tuners/fc2580.c                           |  16 +---
 drivers/media/tuners/msi001.c                           |  19 +----
 drivers/media/usb/au0828/au0828-video.c                 |   4 +-
 drivers/media/usb/cpia2/cpia2_usb.c                     |   3 -
 drivers/media/usb/cx231xx/cx231xx-video.c               |   2 +-
 drivers/media/usb/em28xx/em28xx-video.c                 |   4 +-
 drivers/media/v4l2-core/tuner-core.c                    |  15 +---
 drivers/staging/media/imx/imx-media-csi.c               |   1 +
 drivers/staging/media/imx/imx-media-utils.c             |   8 +-
 include/media/v4l2-subdev.h                             |   4 +
 include/media/videobuf2-core.h                          |  33 +++++---
 25 files changed, 390 insertions(+), 346 deletions(-)
