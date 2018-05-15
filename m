Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:56081 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752253AbeEOOfx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 May 2018 10:35:53 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.18] Various fixes, move zoran to staging
Message-ID: <cba99054-7b9c-5c22-6432-2d65b91ea305@xs4all.nl>
Date: Tue, 15 May 2018 16:35:48 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Besides the various fixes the main change is that the zoran driver
is moved to staging with the intention to remove it next year.

Regards,

	Hans

The following changes since commit 2a5f2705c97625aa1a4e1dd4d584eaa05392e060:

  media: lgdt330x.h: fix compiler warning (2018-05-11 11:40:09 -0400)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.18d

for you to fetch changes up to ca575b76cf4a0b2ae851d398e1725f43fc81e7c8:

  adv7511: fix clearing of the CEC receive buffer (2018-05-15 16:28:35 +0200)

----------------------------------------------------------------
Ezequiel Garcia (1):
      usbtv: Implement wait_prepare and wait_finish

Fabien Dessenne (2):
      media: bdisp: don't use GFP_DMA
      media: st-hva: don't use GFP_DMA

Hans Verkuil (10):
      zoran: move to staging in preparation for removal
      go7007: fix two sparse warnings
      zoran: fix compiler warning
      s5p-mfc: fix two sparse warnings
      hdpvr: fix compiler warning
      imx: fix compiler warning
      renesas-ceu: fix compiler warning
      soc_camera: fix compiler warning
      cec: improve cec status documentation
      adv7511: fix clearing of the CEC receive buffer

Laurent Pinchart (1):
      media: i2c: adv748x: Fix pixel rate values

Luca Ceresoli (5):
      media: docs: selection: fix typos
      media: docs: clarify relationship between crop and selection APIs
      media: docs: selection: rename files to something meaningful
      media: docs: selection: improve formatting
      media: docs: selection: fix misleading sentence about the CROP API

 Documentation/media/kapi/cec-core.rst                                                   |  5 ++++-
 Documentation/media/uapi/cec/cec-ioc-receive.rst                                        | 24 +++++++++++++++---------
 Documentation/media/uapi/v4l/common.rst                                                 |  2 +-
 Documentation/media/uapi/v4l/crop.rst                                                   | 22 +++++++++++++++-------
 Documentation/media/uapi/v4l/selection-api-005.rst                                      | 34 ----------------------------------
 Documentation/media/uapi/v4l/{selection-api-004.rst => selection-api-configuration.rst} |  2 +-
 Documentation/media/uapi/v4l/{selection-api-006.rst => selection-api-examples.rst}      |  0
 Documentation/media/uapi/v4l/{selection-api-002.rst => selection-api-intro.rst}         |  0
 Documentation/media/uapi/v4l/{selection-api-003.rst => selection-api-targets.rst}       |  0
 Documentation/media/uapi/v4l/selection-api-vs-crop-api.rst                              | 39 +++++++++++++++++++++++++++++++++++++++
 Documentation/media/uapi/v4l/selection-api.rst                                          | 14 +++++++-------
 Documentation/media/uapi/v4l/selection.svg                                              |  4 ++--
 MAINTAINERS                                                                             |  2 +-
 drivers/media/i2c/adv748x/adv748x-afe.c                                                 | 12 ++++++------
 drivers/media/i2c/adv748x/adv748x-hdmi.c                                                |  8 +-------
 drivers/media/i2c/adv7511.c                                                             | 18 +++++++++---------
 drivers/media/pci/Kconfig                                                               |  1 -
 drivers/media/pci/Makefile                                                              |  1 -
 drivers/media/platform/renesas-ceu.c                                                    |  2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c                                            |  4 ++--
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c                                            |  4 ++--
 drivers/media/platform/soc_camera/soc_camera_platform.c                                 |  3 ++-
 drivers/media/platform/sti/bdisp/bdisp-hw.c                                             |  2 +-
 drivers/media/platform/sti/bdisp/bdisp-v4l2.c                                           |  4 ++++
 drivers/media/platform/sti/hva/hva-mem.c                                                |  2 +-
 drivers/media/platform/sti/hva/hva-v4l2.c                                               |  4 ++++
 drivers/media/usb/go7007/go7007-fw.c                                                    |  3 +++
 drivers/media/usb/go7007/go7007-v4l2.c                                                  |  2 +-
 drivers/media/usb/hdpvr/hdpvr-video.c                                                   |  2 +-
 drivers/media/usb/usbtv/usbtv-video.c                                                   |  2 ++
 drivers/staging/media/Kconfig                                                           |  2 ++
 drivers/staging/media/Makefile                                                          |  1 +
 drivers/staging/media/imx/imx-media-capture.c                                           |  4 ++--
 drivers/{media/pci => staging/media}/zoran/Kconfig                                      |  2 +-
 drivers/{media/pci => staging/media}/zoran/Makefile                                     |  0
 drivers/staging/media/zoran/TODO                                                        |  4 ++++
 drivers/{media/pci => staging/media}/zoran/videocodec.c                                 |  0
 drivers/{media/pci => staging/media}/zoran/videocodec.h                                 |  0
 drivers/{media/pci => staging/media}/zoran/zoran.h                                      |  0
 drivers/{media/pci => staging/media}/zoran/zoran_card.c                                 |  0
 drivers/{media/pci => staging/media}/zoran/zoran_card.h                                 |  0
 drivers/{media/pci => staging/media}/zoran/zoran_device.c                               |  0
 drivers/{media/pci => staging/media}/zoran/zoran_device.h                               |  0
 drivers/{media/pci => staging/media}/zoran/zoran_driver.c                               |  4 ++--
 drivers/{media/pci => staging/media}/zoran/zoran_procfs.c                               |  0
 drivers/{media/pci => staging/media}/zoran/zoran_procfs.h                               |  0
 drivers/{media/pci => staging/media}/zoran/zr36016.c                                    |  0
 drivers/{media/pci => staging/media}/zoran/zr36016.h                                    |  0
 drivers/{media/pci => staging/media}/zoran/zr36050.c                                    |  0
 drivers/{media/pci => staging/media}/zoran/zr36050.h                                    |  0
 drivers/{media/pci => staging/media}/zoran/zr36057.h                                    |  0
 drivers/{media/pci => staging/media}/zoran/zr36060.c                                    |  0
 drivers/{media/pci => staging/media}/zoran/zr36060.h                                    |  0
 53 files changed, 137 insertions(+), 102 deletions(-)
 delete mode 100644 Documentation/media/uapi/v4l/selection-api-005.rst
 rename Documentation/media/uapi/v4l/{selection-api-004.rst => selection-api-configuration.rst} (98%)
 rename Documentation/media/uapi/v4l/{selection-api-006.rst => selection-api-examples.rst} (100%)
 rename Documentation/media/uapi/v4l/{selection-api-002.rst => selection-api-intro.rst} (100%)
 rename Documentation/media/uapi/v4l/{selection-api-003.rst => selection-api-targets.rst} (100%)
 create mode 100644 Documentation/media/uapi/v4l/selection-api-vs-crop-api.rst
 rename drivers/{media/pci => staging/media}/zoran/Kconfig (97%)
 rename drivers/{media/pci => staging/media}/zoran/Makefile (100%)
 create mode 100644 drivers/staging/media/zoran/TODO
 rename drivers/{media/pci => staging/media}/zoran/videocodec.c (100%)
 rename drivers/{media/pci => staging/media}/zoran/videocodec.h (100%)
 rename drivers/{media/pci => staging/media}/zoran/zoran.h (100%)
 rename drivers/{media/pci => staging/media}/zoran/zoran_card.c (100%)
 rename drivers/{media/pci => staging/media}/zoran/zoran_card.h (100%)
 rename drivers/{media/pci => staging/media}/zoran/zoran_device.c (100%)
 rename drivers/{media/pci => staging/media}/zoran/zoran_device.h (100%)
 rename drivers/{media/pci => staging/media}/zoran/zoran_driver.c (99%)
 rename drivers/{media/pci => staging/media}/zoran/zoran_procfs.c (100%)
 rename drivers/{media/pci => staging/media}/zoran/zoran_procfs.h (100%)
 rename drivers/{media/pci => staging/media}/zoran/zr36016.c (100%)
 rename drivers/{media/pci => staging/media}/zoran/zr36016.h (100%)
 rename drivers/{media/pci => staging/media}/zoran/zr36050.c (100%)
 rename drivers/{media/pci => staging/media}/zoran/zr36050.h (100%)
 rename drivers/{media/pci => staging/media}/zoran/zr36057.h (100%)
 rename drivers/{media/pci => staging/media}/zoran/zr36060.c (100%)
 rename drivers/{media/pci => staging/media}/zoran/zr36060.h (100%)
